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
    11 00000003 E8A61A                   call getarg
    12 00000006 E8060B                   call parse
    13 00000009 E8F81C                   call epilog
    14 0000000C E8651E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 16.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 16.1.2016",0
    21 00000019 372031362E312E3230-
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
   193                                  ;-42 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   194                                  
   195 00000041 00                      OpSize db 0
   196                                  
   197                                  ;-43 char wflag;             //0=byte, 1=word/dword
   198                                  
   199 00000042 00                      wflag db 0
   200                                  
   201                                  ;-44 //char AddrSize;          //67h:
   202                                  
   203                                  
   204                                  ;-45 //char NumOprns;          //0-2
   205                                  
   206                                  
   207                                  ;-46 //char dflag;             //0=source is reg,  1=dest is reg
   208                                  
   209                                  
   210                                  ;-47 //char modrm;           //mod, r/m
   211                                  
   212                                  
   213                                  ;-48 char regindexbase;      //combination of index and base reg
   214                                  
   215 00000043 00                      regindexbase db 0
   216                                  
   217                                  ;-49 int disp;               //displacement      0-8 bytes
   218                                  
   219 00000044 0000                    disp dw 0
   220                                  
   221                                  ;-50 int imme;               //immediate         0-8 bytes
   222                                  
   223 00000046 0000                    imme dw 0
   224                                  
   225                                  ;-51 
   226                                  
   227                                  
   228                                  ;-52 #define OPMAXLEN 5
   229                                  
   230                                  
   231                                  ;-53 char OpPos[OPMAXLEN];   //array for one opcode to list
   232                                  
   233                                  section .bss
   234                                  absolute 30390
   235 000076B6 <res 00000005>          OpPos resb 5
   236                                  section .text
   237                                  
   238                                  ;-54 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   239                                  
   240 00000048 0000                    OpPrintIndex dw 0
   241                                  
   242                                  ;-55 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   243                                  
   244 0000004A 0000                    OpCodePtr dw 0
   245                                  
   246                                  ;-56 char PrintR;           //print 'R' if relocative
   247                                  
   248 0000004C 00                      PrintR db 0
   249                                  
   250                                  ;-57 
   251                                  
   252                                  
   253                                  ;-58 #define LABELNAMESMAX 969//next number - 31
   254                                  
   255                                  
   256                                  ;-59 char LabelNames[1000];  //space for names of all labels
   257                                  
   258                                  section .bss
   259                                  absolute 30395
   260 000076BB <res 000003E8>          LabelNames resb 1000
   261                                  section .text
   262                                  
   263                                  ;-60 char *LabelNamePtr;     // first free position
   264                                  
   265 0000004D 0000                    LabelNamePtr dw 0
   266                                  
   267                                  ;-61 #define LABELADRMAX 100
   268                                  
   269                                  
   270                                  ;-62 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   271                                  
   272                                  section .bss
   273                                  absolute 31395
   274 00007AA3 <res 000000C8>          LabelAddr resw 100
   275                                  section .text
   276                                  
   277                                  ;-63 int LabelMaxIx=0;       //actual number of stored labels
   278                                  
   279 0000004F 0000                    LabelMaxIx dw 0
   280                                  
   281                                  ;-64 int LabelIx;            //actual number of just searched label
   282                                  
   283 00000051 0000                    LabelIx dw 0
   284                                  
   285                                  ;-65 
   286                                  
   287                                  
   288                                  ;-66 #define FILEBINMAX 1990 //next number - max. oplemgth
   289                                  
   290                                  
   291                                  ;-67 char FileBin  [2000];   //output binary file
   292                                  
   293                                  section .bss
   294                                  absolute 31595
   295 00007B6B <res 000007D0>          FileBin resb 2000
   296                                  section .text
   297                                  
   298                                  ;-68 unsigned int BinLen=0;  //length of binary file
   299                                  
   300 00000053 0000                    BinLen dw 0
   301                                  
   302                                  ;-69 
   303                                  
   304                                  
   305                                  ;-70 char *arglen=0x80;      // for main only
   306                                  
   307 00000055 8000                    arglen dw 128
   308                                  
   309                                  ;-71 char *argv=0x82;        // for main only
   310                                  
   311 00000057 8200                    argv dw 130
   312                                  ;Back to main program: AS.C
   313                                  
   314                                  ;-4 #include "OPTABL.C"
   315                                  
   316                                  ;Use include file: OPTABL.C
   317                                  
   318                                  ;-1 char I_START=0xF1;
   319                                  
   320 00000059 F1                      I_START db 241
   321                                  
   322                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   323                                  
   324                                  
   325                                  ;-3 //  1:   1 byte opcode
   326                                  
   327                                  
   328                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   329                                  
   330 0000005A 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   331                                  
   332                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   333                                  
   334 00000063 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   335                                  
   336                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   337                                  
   338 0000006B 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   339                                  
   340                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   341                                  
   342 00000072 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   343                                  
   344                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   345                                  
   346 00000079 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   347                                  
   348                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   349                                  
   350 00000081 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   351                                  
   352                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   353                                  
   354 00000088 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   355                                  
   356                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   357                                  
   358 0000008F 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   359                                  
   360                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   361                                  
   362 00000097 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   363                                  
   364                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   365                                  
   366 000000A0 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   367                                  
   368                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   369                                  
   370 000000A8 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   371                                  
   372                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   373                                  
   374 000000B0 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   375                                  
   376                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   377                                  
   378 000000B8 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   379                                  
   380                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   381                                  
   382 000000C1 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   383                                  
   384                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   385                                  
   386 000000CA 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   387                                  
   388                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   389                                  
   390 000000D3 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   391                                  
   392                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   393                                  
   394 000000DC 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   395                                  
   396                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   397                                  
   398 000000E5 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   399                                  
   400                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   401                                  
   402 000000EE 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   403                                  
   404                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   405                                  
   406 000000F7 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   407                                  
   408                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   409                                  
   410 00000100 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   411                                  
   412                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   413                                  
   414 00000109 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   415                                  
   416                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   417                                  
   418 00000112 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   419                                  
   420                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   421                                  
   422 0000011B 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   423                                  
   424                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   425                                  
   426 00000123 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   427                                  
   428                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   429                                  
   430 0000012B 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   431                                  
   432                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   433                                  
   434 00000133 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   435                                  
   436                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   437                                  
   438 0000013C 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   439                                  
   440                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   441                                  
   442 00000145 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   443                                  
   444                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   445                                  
   446 0000014D 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   447                                  
   448                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   449                                  
   450 00000155 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   451                                  
   452                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   453                                  
   454 0000015C 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   455                                  
   456                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   457                                  
   458 00000163 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   459                                  
   460                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   461                                  
   462 0000016A 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   463                                  
   464                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   465                                  
   466 00000171 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   467                                  
   468                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   469                                  
   470 00000178 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   471                                  
   472                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   473                                  
   474 0000017F 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   475                                  
   476                                  ;-41 //  2: inc,dec
   477                                  
   478                                  
   479                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   480                                  
   481 00000186 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   482                                  
   483                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   484                                  
   485 0000018F 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   486                                  
   487                                  ;-44 // 52: mem reg 16 bit
   488                                  
   489                                  
   490                                  ;-45 char I_NOT[]=  {'N','O','T',0,         52,0xF6, 2,0xF1};
   491                                  
   492 00000198 4E4F540034F602F1        I_NOT db 78,79,84,0,52,246,2,241
   493                                  
   494                                  ;-46 char I_NEG[]=  {'N','E','G',0,         52,0xF6, 3,0xF1};
   495                                  
   496 000001A0 4E45470034F603F1        I_NEG db 78,69,71,0,52,246,3,241
   497                                  
   498                                  ;-47 char I_MUL[]=  {'M','U','L',0,         52,0xF6, 4,0xF1};
   499                                  
   500 000001A8 4D554C0034F604F1        I_MUL db 77,85,76,0,52,246,4,241
   501                                  
   502                                  ;-48 char I_IMUL[]= {'I','M','U','L',0,     52,0xF6, 5,0xF1};//only acc
   503                                  
   504 000001B0 494D554C0034F605F1      I_IMUL db 73,77,85,76,0,52,246,5,241
   505                                  
   506                                  ;-49 char I_DIV[]=  {'D','I','V',0,         52,0xF6, 6,0xF1};
   507                                  
   508 000001B9 4449560034F606F1        I_DIV db 68,73,86,0,52,246,6,241
   509                                  
   510                                  ;-50 char I_IDIV[]= {'I','D','I','V',0,     52,0xF6, 7,0xF1};
   511                                  
   512 000001C1 494449560034F607F1      I_IDIV db 73,68,73,86,0,52,246,7,241
   513                                  
   514                                  ;-51 //  3: les, lda, lea
   515                                  
   516                                  
   517                                  ;-52 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   518                                  
   519 000001CA 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   520                                  
   521                                  ;-53 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   522                                  
   523 000001D1 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   524                                  
   525                                  ;-54 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   526                                  
   527 000001D8 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   528                                  
   529                                  ;-55 //  4: acc,imm  reg,imm  index,reg
   530                                  
   531                                  
   532                                  ;-56 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   533                                  
   534 000001DF 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   535                                  
   536                                  ;-57 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   537                                  
   538 000001E6 4F52000401F1            I_OR db 79,82,0,4,1,241
   539                                  
   540                                  ;-58 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   541                                  
   542 000001EC 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   543                                  
   544                                  ;-59 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   545                                  
   546 000001F3 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   547                                  
   548                                  ;-60 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   549                                  
   550 000001FA 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   551                                  
   552                                  ;-61 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   553                                  
   554 00000201 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   555                                  
   556                                  ;-62 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   557                                  
   558 00000208 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   559                                  
   560                                  ;-63 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   561                                  
   562 0000020F 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   563                                  
   564                                  ;-64 //  5: mov
   565                                  
   566                                  
   567                                  ;-65 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   568                                  
   569 00000216 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   570                                  
   571                                  ;-66 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   572                                  
   573 0000021C 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   574                                  
   575                                  ;-67 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   576                                  
   577 00000225 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   578                                  
   579                                  ;-68 //  6: single byte relative jump
   580                                  
   581                                  
   582                                  ;-69 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   583                                  
   584 0000022E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   585                                  
   586                                  ;-70 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   587                                  
   588 00000234 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   589                                  
   590                                  ;-71 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   591                                  
   592 0000023B 4A42000602F1            I_JB db 74,66,0,6,2,241
   593                                  
   594                                  ;-72 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   595                                  
   596 00000241 4A43000602F1            I_JC db 74,67,0,6,2,241
   597                                  
   598                                  ;-73 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   599                                  
   600 00000247 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   601                                  
   602                                  ;-74 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   603                                  
   604 0000024E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   605                                  
   606                                  ;-75 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   607                                  
   608 00000255 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   609                                  
   610                                  ;-76 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   611                                  
   612 0000025C 4A45000604F1            I_JE db 74,69,0,6,4,241
   613                                  
   614                                  ;-77 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   615                                  
   616 00000262 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   617                                  
   618                                  ;-78 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   619                                  
   620 00000268 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   621                                  
   622                                  ;-79 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   623                                  
   624 0000026F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   625                                  
   626                                  ;-80 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   627                                  
   628 00000276 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   629                                  
   630                                  ;-81 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   631                                  
   632 0000027D 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   633                                  
   634                                  ;-82 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   635                                  
   636 00000284 4A41000607F1            I_JA db 74,65,0,6,7,241
   637                                  
   638                                  ;-83 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   639                                  
   640 0000028A 4A53000608F1            I_JS db 74,83,0,6,8,241
   641                                  
   642                                  ;-84 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   643                                  
   644 00000290 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   645                                  
   646                                  ;-85 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   647                                  
   648 00000297 4A5000060AF1            I_JP db 74,80,0,6,10,241
   649                                  
   650                                  ;-86 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   651                                  
   652 0000029D 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   653                                  
   654                                  ;-87 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   655                                  
   656 000002A4 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   657                                  
   658                                  ;-88 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   659                                  
   660 000002AB 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   661                                  
   662                                  ;-89 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   663                                  
   664 000002B2 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   665                                  
   666                                  ;-90 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   667                                  
   668 000002B8 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   669                                  
   670                                  ;-91 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   671                                  
   672 000002BF 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   673                                  
   674                                  ;-92 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   675                                  
   676 000002C6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   677                                  
   678                                  ;-93 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   679                                  
   680 000002CD 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   681                                  
   682                                  ;-94 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   683                                  
   684 000002D4 4A4700060FF1            I_JG db 74,71,0,6,15,241
   685                                  
   686                                  ;-95 //  7: jmp, call
   687                                  
   688                                  
   689                                  ;-96 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   690                                  
   691 000002DA 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   692                                  
   693                                  ;-97 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   694                                  
   695 000002E2 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   696                                  
   697                                  ;-98 //  8: ret
   698                                  
   699                                  
   700                                  ;-99 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   701                                  
   702 000002EB 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   703                                  
   704                                  ;-100 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   705                                  
   706 000002F3 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   707                                  
   708                                  ;-101 //  9: seg, r/m
   709                                  
   710                                  
   711                                  ;-102 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   712                                  
   713 000002FC 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   714                                  
   715                                  ;-103 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   716                                  
   717 00000304 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   718                                  
   719                                  ;-104 //  11: shift, rotates
   720                                  
   721                                  
   722                                  ;-105 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   723                                  
   724 0000030B 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   725                                  
   726                                  ;-106 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   727                                  
   728 00000312 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   729                                  
   730                                  ;-107 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   731                                  
   732 00000319 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   733                                  
   734                                  ;-108 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   735                                  
   736 00000320 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   737                                  
   738                                  ;-109 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   739                                  
   740 00000327 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   741                                  
   742                                  ;-110 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   743                                  
   744 0000032E 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   745                                  
   746                                  ;-111 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   747                                  
   748 00000335 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   749                                  
   750                                  ;-112 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   751                                  
   752 0000033C 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   753                                  
   754                                  ;-113 //  12: int
   755                                  
   756                                  
   757                                  ;-114 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   758                                  
   759 00000343 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   760                                  
   761                                  ;-115 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   762                                  
   763 0000034B 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   764                                  
   765                                  ;-116 //  14: in/out
   766                                  
   767                                  
   768                                  ;-117 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   769                                  
   770 00000353 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   771                                  
   772                                  ;-118 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   773                                  
   774 0000035A 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   775                                  
   776                                  ;-119 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   777                                  
   778 00000362 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   779                                  
   780                                  ;-120 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   781                                  
   782 0000036A 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   783                                  
   784                                  ;-121 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   785                                  
   786 00000372 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   787                                  
   788                                  ;-122 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   789                                  
   790 0000037A 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   791                                  
   792                                  ;-123 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   793                                  
   794 00000382 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   795                                  
   796                                  ;-124 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   797                                  
   798 0000038A 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   799                                  
   800                                  ;-125 //  15: xchg
   801                                  
   802                                  
   803                                  ;-126 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   804                                  
   805 00000392 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   806                                  
   807                                  ;-127 //  16: loop, jcxz
   808                                  
   809                                  
   810                                  ;-128 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   811                                  
   812 0000039B 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   813 000003A4 F1                 
   814                                  
   815                                  ;-129 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   816                                  
   817 000003A5 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   818 000003AE F1                 
   819                                  
   820                                  ;-130 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   821                                  
   822 000003AF 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   823                                  
   824                                  ;-131 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   825                                  
   826 000003B8 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   827                                  
   828                                  ;-132 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   829                                  
   830 000003C1 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   831                                  
   832                                  ;-133 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   833                                  
   834 000003C9 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   835                                  
   836                                  ;-134 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   837                                  
   838 000003D1 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   839                                  
   840                                  ;-135 //  30: enter
   841                                  
   842                                  
   843                                  ;-136 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   844                                  
   845 000003DA 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   846                                  
   847                                  ;-137 // 100: directives
   848                                  
   849                                  
   850                                  ;-138 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   851                                  
   852 000003E3 4F52470065F1            I_ORG db 79,82,71,0,101,241
   853                                  
   854                                  ;-139 char I_DB[]=   {'D','B',0,            200,        0xF1};
   855                                  
   856 000003E9 444200C8F1              I_DB db 68,66,0,200,241
   857                                  
   858                                  ;-140 char I_DW[]=   {'D','W',0,            201,        0xF1};
   859                                  
   860 000003EE 445700C9F1              I_DW db 68,87,0,201,241
   861                                  
   862                                  ;-141 char I_DD[]=   {'D','D',0,            202,        0xF1};
   863                                  
   864 000003F3 444400CAF1              I_DD db 68,68,0,202,241
   865                                  
   866                                  ;-142 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   867                                  
   868 000003F8 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   869                                  
   870                                  ;-143 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   871                                  
   872 000003FF 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   873                                  
   874                                  ;-144 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   875                                  
   876 00000406 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   877                                  
   878                                  ;-145 char I_END=0;// end of table char
   879                                  
   880 0000040D 00                      I_END db 0
   881                                  ;Back to main program: AS.C
   882                                  
   883                                  ;-5 
   884                                  
   885                                  
   886                                  ;-6 int process() { int i; char c;
   887                                  
   888                                  
   889                                  process:  ; *** PROC ***
   890                                  
   891                                  ;-7   getTokeType();
   892                                  
   893                                  ;Function : process, Number of local variables: 2
   894                                  ;   # type sign width line used address name   list of local variables
   895                                  ;  200 var sign word     6 NULL bp-2    i
   896                                  ;  201 var sign byte     6 NULL bp-4    c;
   897 0000040E C8040000                 ENTER  4,0
   898 00000412 E8E407                   call getTokeType
   899                                  
   900                                  ;-8   OpSize=getCodeSize();////
   901                                  
   902 00000415 E8DB0A                   call getCodeSize
   903 00000418 A2[4100]                 mov byte [OpSize], al
   904                                  
   905                                  ;-9 
   906                                  
   907                                  
   908                                  ;-10   if (CodeType ==  1) {//1 byte opcode
   909                                  
   910 0000041B A0[3E00]                 mov al, [CodeType]
   911 0000041E 3C01                     cmp al, 1
   912 00000420 0F850D00                 jne @@process1
   913                                  
   914                                  ;-11     genInstruction(0, 1);
   915                                  
   916 00000424 6A01                     push 1
   917 00000426 6A00                     push 0
   918 00000428 E84205                   call genInstruction
   919 0000042B 83C404                   add  sp, 4
   920                                  
   921                                  ;-12     return;
   922                                  
   923 0000042E E9EA00                   jmp @@retn
   924                                  
   925                                  ;-13   }
   926                                  
   927                                  
   928                                  ;-14   if (CodeType ==  2) {//inc, dec
   929                                  
   930                                  @@process1:
   931 00000431 A0[3E00]                 mov al, [CodeType]
   932 00000434 3C02                     cmp al, 2
   933 00000436 0F855900                 jne @@process2
   934                                  
   935                                  ;-15     checkLeftOp(1);
   936                                  
   937 0000043A 6A01                     push 1
   938 0000043C E86301                   call checkLeftOp
   939 0000043F 83C402                   add  sp, 2
   940                                  
   941                                  ;-16     	if (Op1 == REG) {
   942                                  
   943 00000442 A0[3D00]                 mov al, [Op1]
   944 00000445 3C02                     cmp al, 2
   945 00000447 0F853400                 jne @@process3
   946                                  
   947                                  ;-17         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
   948                                  
   949 0000044B A0[3F00]                 mov al, [RegType]
   950 0000044E 3C02                     cmp al, 2
   951 00000450 0F851100                 jne @@process4
   952 00000454 6A03                     push 3
   953 00000456 A0[4000]                 mov al, byte [RegNo]
   954 00000459 B400                     mov ah, 0
   955 0000045B 50                       push ax
   956 0000045C E80E05                   call genInstruction
   957 0000045F 83C404                   add  sp, 4
   958 00000462 E9B600                   jmp @@retn
   959                                  
   960                                  ;-18         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }
   961                                  
   962                                  @@process4:
   963 00000465 A0[3F00]                 mov al, [RegType]
   964 00000468 3C03                     cmp al, 3
   965 0000046A 0F851100                 jne @@process5
   966 0000046E 6A03                     push 3
   967 00000470 A0[4000]                 mov al, byte [RegNo]
   968 00000473 B400                     mov ah, 0
   969 00000475 50                       push ax
   970 00000476 E8F404                   call genInstruction
   971 00000479 83C404                   add  sp, 4
   972 0000047C E99C00                   jmp @@retn
   973                                  
   974                                  ;-19       }
   975                                  
   976                                  @@process5:
   977                                  
   978                                  ;-20       genInstruction(wflag, 1);
   979                                  
   980                                  @@process3:
   981 0000047F 6A01                     push 1
   982 00000481 A0[4200]                 mov al, byte [wflag]
   983 00000484 B400                     mov ah, 0
   984 00000486 50                       push ax
   985 00000487 E8E304                   call genInstruction
   986 0000048A 83C404                   add  sp, 4
   987                                  
   988                                  ;-21       genCodeInREG();
   989                                  
   990 0000048D E86B05                   call genCodeInREG
   991                                  
   992                                  ;-22       return;
   993                                  
   994 00000490 E98800                   jmp @@retn
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
  1005 00000493 A0[3E00]                 mov al, [CodeType]
  1006 00000496 3C34                     cmp al, 52
  1007 00000498 0F851C00                 jne @@process6
  1008                                  
  1009                                  ;-26     checkLeftOp(2);
  1010                                  
  1011 0000049C 6A02                     push 2
  1012 0000049E E80101                   call checkLeftOp
  1013 000004A1 83C402                   add  sp, 2
  1014                                  
  1015                                  ;-27     genInstruction(wflag, 1);
  1016                                  
  1017 000004A4 6A01                     push 1
  1018 000004A6 A0[4200]                 mov al, byte [wflag]
  1019 000004A9 B400                     mov ah, 0
  1020 000004AB 50                       push ax
  1021 000004AC E8BE04                   call genInstruction
  1022 000004AF 83C404                   add  sp, 4
  1023                                  
  1024                                  ;-28     genCodeInREG();
  1025                                  
  1026 000004B2 E84605                   call genCodeInREG
  1027                                  
  1028                                  ;-29     return;
  1029                                  
  1030 000004B5 E96300                   jmp @@retn
  1031                                  
  1032                                  ;-30   }
  1033                                  
  1034                                  
  1035                                  ;-31 
  1036                                  
  1037                                  
  1038                                  ;-32   if (CodeType==  8) {// ret
  1039                                  
  1040                                  @@process6:
  1041 000004B8 A0[3E00]                 mov al, [CodeType]
  1042 000004BB 3C08                     cmp al, 8
  1043 000004BD 0F852D00                 jne @@process7
  1044                                  
  1045                                  ;-33     if (TokeType == DIGIT) {
  1046                                  
  1047 000004C1 A0[3C00]                 mov al, [TokeType]
  1048 000004C4 3C01                     cmp al, 1
  1049 000004C6 0F851700                 jne @@process8
  1050                                  
  1051                                  ;-34       genInstruction(0, 2);
  1052                                  
  1053 000004CA 6A02                     push 2
  1054 000004CC 6A00                     push 0
  1055 000004CE E89C04                   call genInstruction
  1056 000004D1 83C404                   add  sp, 4
  1057                                  
  1058                                  ;-35       genCode16(SymbolInt);
  1059                                  
  1060 000004D4 FF36[2600]               push word [SymbolInt]
  1061 000004D8 E8FF04                   call genCode16
  1062 000004DB 83C402                   add  sp, 2
  1063                                  
  1064                                  ;-36       return;
  1065                                  
  1066 000004DE E93A00                   jmp @@retn
  1067                                  
  1068                                  ;-37     }
  1069                                  
  1070                                  
  1071                                  ;-38     genInstruction(0, 1); return;
  1072                                  
  1073                                  @@process8:
  1074 000004E1 6A01                     push 1
  1075 000004E3 6A00                     push 0
  1076 000004E5 E88504                   call genInstruction
  1077 000004E8 83C404                   add  sp, 4
  1078 000004EB E92D00                   jmp @@retn
  1079                                  
  1080                                  ;-39   }
  1081                                  
  1082                                  
  1083                                  ;-40 
  1084                                  
  1085                                  
  1086                                  ;-41   if (CodeType==101) {// ORG nn
  1087                                  
  1088                                  @@process7:
  1089 000004EE A0[3E00]                 mov al, [CodeType]
  1090 000004F1 3C65                     cmp al, 101
  1091 000004F3 0F851B00                 jne @@process9
  1092                                  
  1093                                  ;-42     if (TokeType != DIGIT) error1("only digit allowed");
  1094                                  
  1095 000004F7 A0[3C00]                 mov al, [TokeType]
  1096 000004FA 3C01                     cmp al, 1
  1097 000004FC 0F840900                 je  @@process10
  1098 00000500 68[1D05]                 push process_0
  1099 00000503 E82414                   call error1
  1100 00000506 83C402                   add  sp, 2
  1101                                  
  1102                                  ;-43     PC=SymbolInt;return;
  1103                                  
  1104                                  @@process10:
  1105 00000509 A1[2600]                 mov ax, [SymbolInt]
  1106 0000050C A3[3700]                 mov word [PC], ax
  1107 0000050F E90900                   jmp @@retn
  1108                                  
  1109                                  ;-44   }
  1110                                  
  1111                                  
  1112                                  ;-45   error1("unknown CodeType");
  1113                                  
  1114                                  @@process9:
  1115 00000512 68[3005]                 push process_1
  1116 00000515 E81214                   call error1
  1117 00000518 83C402                   add  sp, 2
  1118                                  
  1119                                  ;-46 }
  1120                                  
  1121                                  
  1122                                  ;-47 
  1123                                  
  1124                                  
  1125                                  ;-48 int setwflag() {//only Op1 (first operand)
  1126                                  
  1127 0000051B C9                      @@retn: LEAVE
  1128 0000051C C3                       ret
  1129                                  ; ENDP
  1130 0000051D 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1131 00000526 7420616C6C6F776564-
  1132 0000052F 00                 
  1133 00000530 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1134 00000539 6F64655479706500   
  1135                                  
  1136                                  setwflag:  ; *** PROC ***
  1137                                  
  1138                                  ;-49   wflag=0;
  1139                                  
  1140 00000541 66B800000000             mov eax, 0
  1141 00000547 A2[4200]                 mov byte [wflag], al
  1142                                  
  1143                                  ;-50   if (OpSize == 0) {//do not override OpSize
  1144                                  
  1145 0000054A A0[4100]                 mov al, [OpSize]
  1146 0000054D 3C00                     cmp al, 0
  1147 0000054F 0F852100                 jne @@setwflag11
  1148                                  
  1149                                  ;-51     if (Op1 == REG) {
  1150                                  
  1151 00000553 A0[3D00]                 mov al, [Op1]
  1152 00000556 3C02                     cmp al, 2
  1153 00000558 0F851800                 jne @@setwflag12
  1154                                  
  1155                                  ;-52       OpSize=RegType;
  1156                                  
  1157 0000055C A0[3F00]                 mov al, [RegType]
  1158 0000055F A2[4100]                 mov byte [OpSize], al
  1159                                  
  1160                                  ;-53       if (RegType == SEGREG) OpSize=WORD;
  1161                                  
  1162 00000562 A0[3F00]                 mov al, [RegType]
  1163 00000565 3C04                     cmp al, 4
  1164 00000567 0F850900                 jne @@setwflag13
  1165 0000056B 66B802000000             mov eax, 2
  1166 00000571 A2[4100]                 mov byte [OpSize], al
  1167                                  
  1168                                  ;-54     }
  1169                                  
  1170                                  @@setwflag13:
  1171                                  
  1172                                  ;-55   }
  1173                                  
  1174                                  @@setwflag12:
  1175                                  
  1176                                  ;-56   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1177                                  
  1178                                  @@setwflag11:
  1179 00000574 A0[4100]                 mov al, [OpSize]
  1180 00000577 3C03                     cmp al, 3
  1181 00000579 0F850C00                 jne @@setwflag14
  1182 0000057D E81F04                   call gen66h
  1183 00000580 66B801000000             mov eax, 1
  1184 00000586 A2[4200]                 mov byte [wflag], al
  1185                                  
  1186                                  ;-57   if (OpSize  ==  WORD) wflag=1;
  1187                                  
  1188                                  @@setwflag14:
  1189 00000589 A0[4100]                 mov al, [OpSize]
  1190 0000058C 3C02                     cmp al, 2
  1191 0000058E 0F850900                 jne @@setwflag15
  1192 00000592 66B801000000             mov eax, 1
  1193 00000598 A2[4200]                 mov byte [wflag], al
  1194                                  
  1195                                  ;-58 }
  1196                                  
  1197                                  @@setwflag15:
  1198                                  
  1199                                  ;-59 
  1200                                  
  1201                                  
  1202                                  ;-60 int Check2Op(char left, char rigth) {
  1203                                  
  1204 0000059B C3                       ret
  1205                                  ; ENDP
  1206                                  
  1207                                  Check2Op:  ; *** PROC ***
  1208                                  
  1209                                  ;-61 }
  1210                                  
  1211                                  ;Function : Check2Op, Number of local variables: 2
  1212                                  ;   # type sign width line used address name   list of local variables
  1213                                  ;  200 var sign byte    60 NULL bp+4    left
  1214                                  ;  201 var sign byte    60 NULL bp+6    rigth;
  1215 0000059C C8000000                 ENTER  0,0
  1216                                  
  1217                                  ;-62 int checkLeftOp(char mode) {
  1218 000005A0 C9                       LEAVE
  1219 000005A1 C3                       ret
  1220                                  ; ENDP
  1221                                  
  1222                                  checkLeftOp:  ; *** PROC ***
  1223                                  
  1224                                  ;-63   getOp();
  1225                                  
  1226                                  ;Function : checkLeftOp, Number of local variables: 1
  1227                                  ;   # type sign width line used address name   list of local variables
  1228                                  ;  200 var sign byte    62 NULL bp+4    mode;
  1229 000005A2 C8000000                 ENTER  0,0
  1230 000005A6 E8AF00                   call getOp
  1231                                  
  1232                                  ;-64   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1233                                  
  1234 000005A9 A0[3F00]                 mov al, [RegType]
  1235 000005AC 3C04                     cmp al, 4
  1236 000005AE 0F850600                 jne @@checkLeftOp16
  1237 000005B2 E86E14                   call segregerror
  1238 000005B5 E95300                   jmp @@retn
  1239                                  
  1240                                  ;-65   setwflag();
  1241                                  
  1242                                  @@checkLeftOp16:
  1243 000005B8 E886FF                   call setwflag
  1244                                  
  1245                                  ;-66   if (OpSize == 0) error1("no op size declared");
  1246                                  
  1247 000005BB A0[4100]                 mov al, [OpSize]
  1248 000005BE 3C00                     cmp al, 0
  1249 000005C0 0F850900                 jne @@checkLeftOp17
  1250 000005C4 68[0D06]                 push checkLeftOp_0
  1251 000005C7 E86013                   call error1
  1252 000005CA 83C402                   add  sp, 2
  1253                                  
  1254                                  ;-67   if (OpSize == RegType) return;
  1255                                  
  1256                                  @@checkLeftOp17:
  1257 000005CD A0[4100]                 mov al, [OpSize]
  1258 000005D0 3A06[3F00]               cmp al, [RegType]
  1259 000005D4 0F850300                 jne @@checkLeftOp18
  1260 000005D8 E93000                   jmp @@retn
  1261                                  
  1262                                  ;-68   if (OpSize){if (Op1 == MEM) return;
  1263                                  
  1264                                  @@checkLeftOp18:
  1265 000005DB A0[4100]                 mov al, [OpSize]
  1266 000005DE 08C0                     or  al, al
  1267 000005E0 0F841500                 je @@checkLeftOp19
  1268 000005E4 A0[3D00]                 mov al, [Op1]
  1269 000005E7 3C04                     cmp al, 4
  1270 000005E9 0F850300                 jne @@checkLeftOp20
  1271 000005ED E91B00                   jmp @@retn
  1272                                  
  1273                                  ;-69     error1("Conflict OpSize and RegSize"); }
  1274                                  
  1275                                  @@checkLeftOp20:
  1276 000005F0 68[2106]                 push checkLeftOp_1
  1277 000005F3 E83413                   call error1
  1278 000005F6 83C402                   add  sp, 2
  1279                                  
  1280                                  ;-70   if (RegType==0) error1("no register defined");
  1281                                  
  1282                                  @@checkLeftOp19:
  1283 000005F9 A0[3F00]                 mov al, [RegType]
  1284 000005FC 3C00                     cmp al, 0
  1285 000005FE 0F850900                 jne @@checkLeftOp21
  1286 00000602 68[3D06]                 push checkLeftOp_2
  1287 00000605 E82213                   call error1
  1288 00000608 83C402                   add  sp, 2
  1289                                  
  1290                                  ;-71 }
  1291                                  
  1292                                  @@checkLeftOp21:
  1293                                  
  1294                                  ;-72 
  1295                                  
  1296                                  
  1297                                  ;-73 int saveLeftOp(){
  1298                                  
  1299 0000060B C9                      @@retn: LEAVE
  1300 0000060C C3                       ret
  1301                                  ; ENDP
  1302 0000060D 6E6F206F702073697A-     checkLeftOp_0 db "no op size declared",0
  1303 00000616 65206465636C617265-
  1304 0000061F 6400               
  1305 00000621 436F6E666C69637420-     checkLeftOp_1 db "Conflict OpSize and RegSize",0
  1306 0000062A 4F7053697A6520616E-
  1307 00000633 642052656753697A65-
  1308 0000063C 00                 
  1309 0000063D 6E6F20726567697374-     checkLeftOp_2 db "no register defined",0
  1310 00000646 657220646566696E65-
  1311 0000064F 6400               
  1312                                  
  1313                                  saveLeftOp:  ; *** PROC ***
  1314                                  
  1315                                  ;-74 }
  1316                                  
  1317                                  
  1318                                  ;-75 int checkRightOp(char mode){
  1319                                  
  1320 00000651 C3                       ret
  1321                                  ; ENDP
  1322                                  
  1323                                  checkRightOp:  ; *** PROC ***
  1324                                  
  1325                                  ;-76 }
  1326                                  
  1327                                  ;Function : checkRightOp, Number of local variables: 1
  1328                                  ;   # type sign width line used address name   list of local variables
  1329                                  ;  200 var sign byte    75 NULL bp+4    mode;
  1330 00000652 C8000000                 ENTER  0,0
  1331                                  
  1332                                  ;-77 
  1333                                  
  1334                                  
  1335                                  ;-78 /*        Op      = 0, IMM, REG, ADR, MEM
  1336                                  
  1337                                  
  1338                                  ;-79 IMM       imme    = 0, SymbolInt    
  1339                                  
  1340                                  
  1341                                  ;-80 REG     R RegNo   = 0 - 7
  1342                                  
  1343                                  
  1344                                  ;-81 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  1345                                  
  1346                                  
  1347                                  ;-82 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  1348                                  
  1349                                  
  1350                                  ;-83 MEM       regindexbase = 0 - 7
  1351                                  
  1352                                  
  1353                                  ;-84 
  1354                                  
  1355                                  
  1356                                  ;-85           OpSize  = 0, BYTE, WORD, DWORD (set wflag)
  1357                                  
  1358                                  
  1359                                  ;-86 */
  1360                                  
  1361                                  
  1362                                  ;-87 int getOp() {
  1363 00000656 C9                       LEAVE
  1364 00000657 C3                       ret
  1365                                  ; ENDP
  1366                                  
  1367                                  getOp:  ; *** PROC ***
  1368                                  
  1369                                  ;-88 //set: op1=0,IMM,REG,ADR,MEM
  1370                                  
  1371                                  
  1372                                  ;-89   disp=0; imme=0; regindexbase=0;
  1373                                  
  1374 00000658 66B800000000             mov eax, 0
  1375 0000065E A3[4400]                 mov word [disp], ax
  1376 00000661 66B800000000             mov eax, 0
  1377 00000667 A3[4600]                 mov word [imme], ax
  1378 0000066A 66B800000000             mov eax, 0
  1379 00000670 A2[4300]                 mov byte [regindexbase], al
  1380                                  
  1381                                  ;-90 
  1382                                  
  1383                                  
  1384                                  ;-91   Op1=getOp1();
  1385                                  
  1386 00000673 E8A800                   call getOp1
  1387 00000676 A2[3D00]                 mov byte [Op1], al
  1388                                  
  1389                                  ;-92   if (isToken('[')) {Op1 = MEM; getMEM();  return;}
  1390                                  
  1391 00000679 6A5B                     push 91
  1392 0000067B E8F808                   call isToken
  1393 0000067E 83C402                   add  sp, 2
  1394 00000681 08C0                     or  al, al
  1395 00000683 0F840F00                 je @@getOp22
  1396 00000687 66B804000000             mov eax, 4
  1397 0000068D A2[3D00]                 mov byte [Op1], al
  1398 00000690 E81101                   call getMEM
  1399 00000693 E95200                   jmp @@retn
  1400                                  
  1401                                  ;-93   if (Op1 == 0) error1("Name of operand expected");
  1402                                  
  1403                                  @@getOp22:
  1404 00000696 A0[3D00]                 mov al, [Op1]
  1405 00000699 3C00                     cmp al, 0
  1406 0000069B 0F850900                 jne @@getOp23
  1407 0000069F 68[E906]                 push getOp_0
  1408 000006A2 E88512                   call error1
  1409 000006A5 83C402                   add  sp, 2
  1410                                  
  1411                                  ;-94   if (Op1 == IMM) {imme=SymbolInt;         return;}
  1412                                  
  1413                                  @@getOp23:
  1414 000006A8 A0[3D00]                 mov al, [Op1]
  1415 000006AB 3C01                     cmp al, 1
  1416 000006AD 0F850900                 jne @@getOp24
  1417 000006B1 A1[2600]                 mov ax, [SymbolInt]
  1418 000006B4 A3[4600]                 mov word [imme], ax
  1419 000006B7 E92E00                   jmp @@retn
  1420                                  
  1421                                  ;-95   if (Op1 == REG)                          return;
  1422                                  
  1423                                  @@getOp24:
  1424 000006BA A0[3D00]                 mov al, [Op1]
  1425 000006BD 3C02                     cmp al, 2
  1426 000006BF 0F850300                 jne @@getOp25
  1427 000006C3 E92200                   jmp @@retn
  1428                                  
  1429                                  ;-96   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}
  1430                                  
  1431                                  @@getOp25:
  1432 000006C6 A0[3D00]                 mov al, [Op1]
  1433 000006C9 3C03                     cmp al, 3
  1434 000006CB 0F851000                 jne @@getOp26
  1435 000006CF 8B1E[5100]               mov bx, [LabelIx]
  1436 000006D3 D1E3                     shl bx, 1
  1437 000006D5 8B87A37A                 mov ax, [LabelAddr + bx]
  1438 000006D9 A3[4400]                 mov word [disp], ax
  1439 000006DC E90900                   jmp @@retn
  1440                                  
  1441                                  ;-97   error1("Name of operand expected #1");
  1442                                  
  1443                                  @@getOp26:
  1444 000006DF 68[0207]                 push getOp_1
  1445 000006E2 E84512                   call error1
  1446 000006E5 83C402                   add  sp, 2
  1447                                  
  1448                                  ;-98 }
  1449                                  
  1450                                  
  1451                                  ;-99 
  1452                                  
  1453                                  
  1454                                  ;-100 int getOp1() {//scan for a single operand
  1455                                  
  1456                                  @@retn:
  1457 000006E8 C3                       ret
  1458                                  ; ENDP
  1459 000006E9 4E616D65206F66206F-     getOp_0 db "Name of operand expected",0
  1460 000006F2 706572616E64206578-
  1461 000006FB 70656374656400     
  1462 00000702 4E616D65206F66206F-     getOp_1 db "Name of operand expected #1",0
  1463 0000070B 706572616E64206578-
  1464 00000714 706563746564202331-
  1465 0000071D 00                 
  1466                                  
  1467                                  getOp1:  ; *** PROC ***
  1468                                  
  1469                                  ;-101 //return:0, IMM, REG, ADR (not MEM)
  1470                                  
  1471                                  
  1472                                  ;-102 //set   :RegType, RegNo by testReg
  1473                                  
  1474                                  
  1475                                  ;-103 //set   :LabelIx by searchLabel
  1476                                  
  1477                                  
  1478                                  ;-104   if (TokeType == 0)      return 0;
  1479                                  
  1480 0000071E A0[3C00]                 mov al, [TokeType]
  1481 00000721 3C00                     cmp al, 0
  1482 00000723 0F850900                 jne @@getOp127
  1483 00000727 66B800000000             mov eax, 0
  1484 0000072D E96000                   jmp @@retn
  1485                                  
  1486                                  ;-105   if (TokeType == DIGIT)  return IMM;
  1487                                  
  1488                                  @@getOp127:
  1489 00000730 A0[3C00]                 mov al, [TokeType]
  1490 00000733 3C01                     cmp al, 1
  1491 00000735 0F850900                 jne @@getOp128
  1492 00000739 66B801000000             mov eax, 1
  1493 0000073F E94E00                   jmp @@retn
  1494                                  
  1495                                  ;-106   if (TokeType == ALNUME) {
  1496                                  
  1497                                  @@getOp128:
  1498 00000742 A0[3C00]                 mov al, [TokeType]
  1499 00000745 3C03                     cmp al, 3
  1500 00000747 0F853C00                 jne @@getOp129
  1501                                  
  1502                                  ;-107     RegNo=testReg();
  1503                                  
  1504 0000074B E8350B                   call testReg
  1505 0000074E A2[4000]                 mov byte [RegNo], al
  1506                                  
  1507                                  ;-108     if (RegType)          return REG;
  1508                                  
  1509 00000751 A0[3F00]                 mov al, [RegType]
  1510 00000754 08C0                     or  al, al
  1511 00000756 0F840900                 je @@getOp130
  1512 0000075A 66B802000000             mov eax, 2
  1513 00000760 E92D00                   jmp @@retn
  1514                                  
  1515                                  ;-109     LabelIx=searchLabel();
  1516                                  
  1517                                  @@getOp130:
  1518 00000763 E87B05                   call searchLabel
  1519 00000766 A3[5100]                 mov word [LabelIx], ax
  1520                                  
  1521                                  ;-110     if (LabelIx)          return ADR;
  1522                                  
  1523 00000769 A1[5100]                 mov ax, [LabelIx]
  1524 0000076C 08C0                     or  al, al
  1525 0000076E 0F840C00                 je @@getOp131
  1526 00000772 66B803000000             mov eax, 3
  1527 00000778 E91500                   jmp @@retn
  1528                                  
  1529                                  ;-111     else error1("variable not found"); 
  1530                                  
  1531 0000077B E90900                   jmp @@getOp132
  1532                                  @@getOp131:
  1533 0000077E 68[9107]                 push getOp1_0
  1534 00000781 E8A611                   call error1
  1535 00000784 83C402                   add  sp, 2
  1536                                  
  1537                                  ;-112   }
  1538                                  
  1539                                  @@getOp132:
  1540                                  
  1541                                  ;-113   return 0;
  1542                                  
  1543                                  @@getOp129:
  1544 00000787 66B800000000             mov eax, 0
  1545 0000078D E90000                   jmp @@retn
  1546                                  
  1547                                  ;-114 }
  1548                                  
  1549                                  
  1550                                  ;-115 
  1551                                  
  1552                                  
  1553                                  ;-116 int getMEM() {// e.g. [array+bp+si-4]
  1554                                  
  1555                                  @@retn:
  1556 00000790 C3                       ret
  1557                                  ; ENDP
  1558 00000791 7661726961626C6520-     getOp1_0 db "variable not found",0
  1559 0000079A 6E6F7420666F756E64-
  1560 000007A3 00                 
  1561                                  
  1562                                  getMEM:  ; *** PROC ***
  1563                                  
  1564                                  ;-117 //set: disp, regindexbase, RegType
  1565                                  
  1566                                  
  1567                                  ;-118   char op2;
  1568                                  
  1569                                  
  1570                                  ;-119   disp=0; regindexbase=0; RegType=0;
  1571                                  
  1572                                  ;Function : getMEM, Number of local variables: 1
  1573                                  ;   # type sign width line used address name   list of local variables
  1574                                  ;  200 var sign byte   118 NULL bp-2    op2;
  1575 000007A4 C8020000                 ENTER  2,0
  1576 000007A8 66B800000000             mov eax, 0
  1577 000007AE A3[4400]                 mov word [disp], ax
  1578 000007B1 66B800000000             mov eax, 0
  1579 000007B7 A2[4300]                 mov byte [regindexbase], al
  1580 000007BA 66B800000000             mov eax, 0
  1581 000007C0 A2[3F00]                 mov byte [RegType], al
  1582                                  
  1583                                  ;-120   do {
  1584                                  
  1585                                  @@getMEM33:
  1586                                  
  1587                                  ;-121     getTokeType();
  1588                                  
  1589 000007C3 E83304                   call getTokeType
  1590                                  
  1591                                  ;-122     op2=getOp1();
  1592                                  
  1593 000007C6 E855FF                   call getOp1
  1594 000007C9 8846FE                   mov byte [bp-2], al
  1595                                  
  1596                                  ;-123     if (op2 ==   0) syntaxerror();
  1597                                  
  1598 000007CC 8A46FE                   mov al, [bp-2]
  1599 000007CF 3C00                     cmp al, 0
  1600 000007D1 0F850300                 jne @@getMEM34
  1601 000007D5 E87212                   call syntaxerror
  1602                                  
  1603                                  ;-124     if (op2 == REG) if (regindexbase) regindexbase=getIndReg2();
  1604                                  
  1605                                  @@getMEM34:
  1606 000007D8 8A46FE                   mov al, [bp-2]
  1607 000007DB 3C02                     cmp al, 2
  1608 000007DD 0F851500                 jne @@getMEM35
  1609 000007E1 A0[4300]                 mov al, [regindexbase]
  1610 000007E4 08C0                     or  al, al
  1611 000007E6 0F840900                 je @@getMEM36
  1612 000007EA E8F300                   call getIndReg2
  1613 000007ED A2[4300]                 mov byte [regindexbase], al
  1614                                  
  1615                                  ;-125                     else getIndReg1();
  1616                                  
  1617 000007F0 E90300                   jmp @@getMEM37
  1618                                  @@getMEM36:
  1619 000007F3 E88900                   call getIndReg1
  1620                                  
  1621                                  ;-126     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  1622                                  
  1623                                  @@getMEM37:
  1624                                  @@getMEM35:
  1625 000007F6 8A46FE                   mov al, [bp-2]
  1626 000007F9 3C03                     cmp al, 3
  1627 000007FB 0F851000                 jne @@getMEM38
  1628 000007FF A1[4400]                 mov ax, [disp]
  1629 00000802 8B1E[5100]               mov bx, [LabelIx]
  1630 00000806 D1E3                     shl bx, 1
  1631 00000808 0387A37A                 add ax, [LabelAddr + bx]
  1632 0000080C A3[4400]                 mov word [disp], ax
  1633                                  
  1634                                  ;-127     if (op2 == IMM) disp=disp+SymbolInt;
  1635                                  
  1636                                  @@getMEM38:
  1637 0000080F 8A46FE                   mov al, [bp-2]
  1638 00000812 3C01                     cmp al, 1
  1639 00000814 0F850A00                 jne @@getMEM39
  1640 00000818 A1[4400]                 mov ax, [disp]
  1641 0000081B 0306[2600]               add ax, [SymbolInt]
  1642 0000081F A3[4400]                 mov word [disp], ax
  1643                                  
  1644                                  ;-128     if (isToken('-')) {
  1645                                  
  1646                                  @@getMEM39:
  1647 00000822 6A2D                     push 45
  1648 00000824 E84F07                   call isToken
  1649 00000827 83C402                   add  sp, 2
  1650 0000082A 08C0                     or  al, al
  1651 0000082C 0F841900                 je @@getMEM40
  1652                                  
  1653                                  ;-129       getTokeType();
  1654                                  
  1655 00000830 E8C603                   call getTokeType
  1656                                  
  1657                                  ;-130       if (TokeType != DIGIT) numbererror();
  1658                                  
  1659 00000833 A0[3C00]                 mov al, [TokeType]
  1660 00000836 3C01                     cmp al, 1
  1661 00000838 0F840300                 je  @@getMEM41
  1662 0000083C E8A011                   call numbererror
  1663                                  
  1664                                  ;-131       disp = disp - SymbolInt;
  1665                                  
  1666                                  @@getMEM41:
  1667 0000083F A1[4400]                 mov ax, [disp]
  1668 00000842 2B06[2600]               sub ax, [SymbolInt]
  1669 00000846 A3[4400]                 mov word [disp], ax
  1670                                  
  1671                                  ;-132     }
  1672                                  
  1673                                  
  1674                                  ;-133   } while (isToken('+'));
  1675                                  
  1676                                  @@getMEM40:
  1677 00000849 6A2B                     push 43
  1678 0000084B E82807                   call isToken
  1679 0000084E 83C402                   add  sp, 2
  1680 00000851 08C0                     or  al, al
  1681 00000853 0F840300                 je @@getMEM42
  1682 00000857 E969FF                   jmp @@getMEM33
  1683                                  @@getMEM42:
  1684                                  
  1685                                  ;-134   if (isToken(']') == 0) errorexit("] expected");
  1686                                  
  1687 0000085A 6A5D                     push 93
  1688 0000085C E81707                   call isToken
  1689 0000085F 83C402                   add  sp, 2
  1690 00000862 83F800                   cmp ax, 0
  1691 00000865 0F850900                 jne @@getMEM43
  1692 00000869 68[7408]                 push getMEM_0
  1693 0000086C E8EC11                   call errorexit
  1694 0000086F 83C402                   add  sp, 2
  1695                                  
  1696                                  ;-135 }
  1697                                  
  1698                                  @@getMEM43:
  1699                                  
  1700                                  ;-136 int getIndReg1() {
  1701 00000872 C9                       LEAVE
  1702 00000873 C3                       ret
  1703                                  ; ENDP
  1704 00000874 5D2065787065637465-     getMEM_0 db "] expected",0
  1705 0000087D 6400               
  1706                                  
  1707                                  getIndReg1:  ; *** PROC ***
  1708                                  
  1709                                  ;-137   if (RegType !=WORD) indexerror();
  1710                                  
  1711 0000087F A0[3F00]                 mov al, [RegType]
  1712 00000882 3C02                     cmp al, 2
  1713 00000884 0F840300                 je  @@getIndReg144
  1714 00000888 E83311                   call indexerror
  1715                                  
  1716                                  ;-138   if (RegNo==3) regindexbase=7;//BX
  1717                                  
  1718                                  @@getIndReg144:
  1719 0000088B A0[4000]                 mov al, [RegNo]
  1720 0000088E 3C03                     cmp al, 3
  1721 00000890 0F850900                 jne @@getIndReg145
  1722 00000894 66B807000000             mov eax, 7
  1723 0000089A A2[4300]                 mov byte [regindexbase], al
  1724                                  
  1725                                  ;-139   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  1726                                  
  1727                                  @@getIndReg145:
  1728 0000089D A0[4000]                 mov al, [RegNo]
  1729 000008A0 3C05                     cmp al, 5
  1730 000008A2 0F850900                 jne @@getIndReg146
  1731 000008A6 66B806000000             mov eax, 6
  1732 000008AC A2[4300]                 mov byte [regindexbase], al
  1733                                  
  1734                                  ;-140   if (RegNo==7) regindexbase=5;//DI
  1735                                  
  1736                                  @@getIndReg146:
  1737 000008AF A0[4000]                 mov al, [RegNo]
  1738 000008B2 3C07                     cmp al, 7
  1739 000008B4 0F850900                 jne @@getIndReg147
  1740 000008B8 66B805000000             mov eax, 5
  1741 000008BE A2[4300]                 mov byte [regindexbase], al
  1742                                  
  1743                                  ;-141   if (RegNo==6) regindexbase=4;//SI
  1744                                  
  1745                                  @@getIndReg147:
  1746 000008C1 A0[4000]                 mov al, [RegNo]
  1747 000008C4 3C06                     cmp al, 6
  1748 000008C6 0F850900                 jne @@getIndReg148
  1749 000008CA 66B804000000             mov eax, 4
  1750 000008D0 A2[4300]                 mov byte [regindexbase], al
  1751                                  
  1752                                  ;-142   if (regindexbase==0) indexerror();
  1753                                  
  1754                                  @@getIndReg148:
  1755 000008D3 A0[4300]                 mov al, [regindexbase]
  1756 000008D6 3C00                     cmp al, 0
  1757 000008D8 0F850300                 jne @@getIndReg149
  1758 000008DC E8DF10                   call indexerror
  1759                                  
  1760                                  ;-143 }
  1761                                  
  1762                                  @@getIndReg149:
  1763                                  
  1764                                  ;-144 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1765                                  
  1766 000008DF C3                       ret
  1767                                  ; ENDP
  1768                                  
  1769                                  getIndReg2:  ; *** PROC ***
  1770                                  ;Function : getIndReg2, Number of local variables: 1
  1771                                  ;   # type sign width line used address name   list of local variables
  1772                                  ;  200 var sign byte   144 NULL bp-2    m;
  1773 000008E0 C8020000                 ENTER  2,0
  1774 000008E4 66B804000000             mov eax, 4
  1775 000008EA 8846FE                   mov byte [bp-2], al
  1776                                  
  1777                                  ;-145   if (RegType !=WORD) indexerror();
  1778                                  
  1779 000008ED A0[3F00]                 mov al, [RegType]
  1780 000008F0 3C02                     cmp al, 2
  1781 000008F2 0F840300                 je  @@getIndReg250
  1782 000008F6 E8C510                   call indexerror
  1783                                  
  1784                                  ;-146   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  1785                                  
  1786                                  @@getIndReg250:
  1787 000008F9 A0[4000]                 mov al, [RegNo]
  1788 000008FC 3C07                     cmp al, 7
  1789 000008FE 0F852700                 jne @@getIndReg251
  1790 00000902 A0[4300]                 mov al, [regindexbase]
  1791 00000905 3C06                     cmp al, 6
  1792 00000907 0F850C00                 jne @@getIndReg252
  1793 0000090B 66B803000000             mov eax, 3
  1794 00000911 8846FE                   mov byte [bp-2], al
  1795                                  
  1796                                  ;-147            else if (regindexbase==7) m=1;//BX+DI
  1797                                  
  1798 00000914 E91200                   jmp @@getIndReg253
  1799                                  @@getIndReg252:
  1800 00000917 A0[4300]                 mov al, [regindexbase]
  1801 0000091A 3C07                     cmp al, 7
  1802 0000091C 0F850900                 jne @@getIndReg254
  1803 00000920 66B801000000             mov eax, 1
  1804 00000926 8846FE                   mov byte [bp-2], al
  1805                                  
  1806                                  ;-148   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  1807                                  
  1808                                  @@getIndReg254:
  1809                                  @@getIndReg253:
  1810                                  @@getIndReg251:
  1811 00000929 A0[4000]                 mov al, [RegNo]
  1812 0000092C 3C06                     cmp al, 6
  1813 0000092E 0F852700                 jne @@getIndReg255
  1814 00000932 A0[4300]                 mov al, [regindexbase]
  1815 00000935 3C06                     cmp al, 6
  1816 00000937 0F850C00                 jne @@getIndReg256
  1817 0000093B 66B802000000             mov eax, 2
  1818 00000941 8846FE                   mov byte [bp-2], al
  1819                                  
  1820                                  ;-149            else if (regindexbase==7) m=0;//BX+SI
  1821                                  
  1822 00000944 E91200                   jmp @@getIndReg257
  1823                                  @@getIndReg256:
  1824 00000947 A0[4300]                 mov al, [regindexbase]
  1825 0000094A 3C07                     cmp al, 7
  1826 0000094C 0F850900                 jne @@getIndReg258
  1827 00000950 66B800000000             mov eax, 0
  1828 00000956 8846FE                   mov byte [bp-2], al
  1829                                  
  1830                                  ;-150   if (m > 3) indexerror();
  1831                                  
  1832                                  @@getIndReg258:
  1833                                  @@getIndReg257:
  1834                                  @@getIndReg255:
  1835 00000959 8A46FE                   mov al, [bp-2]
  1836 0000095C 3C03                     cmp al, 3
  1837 0000095E 0F8E0300                 jle @@getIndReg259
  1838 00000962 E85910                   call indexerror
  1839                                  
  1840                                  ;-151   return m;
  1841                                  
  1842                                  @@getIndReg259:
  1843 00000965 8A46FE                   mov al, [bp-2]
  1844 00000968 E90000                   jmp @@retn
  1845                                  
  1846                                  ;-152 }
  1847                                  
  1848                                  
  1849                                  ;-153 
  1850                                  
  1851                                  
  1852                                  ;-154 // generate code ...........................................................
  1853                                  
  1854                                  
  1855                                  ;-155 int genInstruction(char No, int loc) {
  1856                                  
  1857 0000096B C9                      @@retn: LEAVE
  1858 0000096C C3                       ret
  1859                                  ; ENDP
  1860                                  
  1861                                  genInstruction:  ; *** PROC ***
  1862                                  
  1863                                  ;-156   char c;//add OpCodePtr with loc, emits contents  + No
  1864                                  
  1865                                  
  1866                                  ;-157   if(loc) OpCodePtr=OpCodePtr+loc;
  1867                                  
  1868                                  ;Function : genInstruction, Number of local variables: 3
  1869                                  ;   # type sign width line used address name   list of local variables
  1870                                  ;  200 var sign byte   155 NULL bp+4    No
  1871                                  ;  201 var sign word   155 NULL bp+6    loc
  1872                                  ;  202 var sign byte   156 NULL bp-2    c;
  1873 0000096D C8020000                 ENTER  2,0
  1874 00000971 8B4606                   mov ax, [bp+6]
  1875 00000974 08C0                     or  al, al
  1876 00000976 0F840900                 je @@genInstruction60
  1877 0000097A A1[4A00]                 mov ax, [OpCodePtr]
  1878 0000097D 034606                   add ax, [bp+6]
  1879 00000980 A3[4A00]                 mov word [OpCodePtr], ax
  1880                                  
  1881                                  ;-158   c= *OpCodePtr + No;
  1882                                  
  1883                                  @@genInstruction60:
  1884 00000983 8B1E[4A00]               mov bx, [OpCodePtr]
  1885 00000987 8A07                     mov al, [bx]
  1886 00000989 B400                     mov ah, 0
  1887 0000098B 024604                   add al, [bp+4]
  1888 0000098E 8846FE                   mov byte [bp-2], al
  1889                                  
  1890                                  ;-159   genCode8(c);
  1891                                  
  1892 00000991 8A46FE                   mov al, byte [bp-2]
  1893 00000994 B400                     mov ah, 0
  1894 00000996 50                       push ax
  1895 00000997 E80E00                   call genCode8
  1896 0000099A 83C402                   add  sp, 2
  1897                                  
  1898                                  ;-160 }
  1899                                  
  1900                                  
  1901                                  ;-161 int gen66h() {genCode8(0x66);
  1902 0000099D C9                       LEAVE
  1903 0000099E C3                       ret
  1904                                  ; ENDP
  1905                                  
  1906                                  gen66h:  ; *** PROC ***
  1907 0000099F 6A66                     push 102
  1908 000009A1 E80400                   call genCode8
  1909 000009A4 83C402                   add  sp, 2
  1910                                  
  1911                                  ;-162 }
  1912                                  
  1913                                  
  1914                                  ;-163 int genCode8(char c) {
  1915                                  
  1916 000009A7 C3                       ret
  1917                                  ; ENDP
  1918                                  
  1919                                  genCode8:  ; *** PROC ***
  1920                                  
  1921                                  ;-164 //set: BinLen++, OpPrintIndex++
  1922                                  
  1923                                  
  1924                                  ;-165   FileBin[BinLen]=c;
  1925                                  
  1926                                  ;Function : genCode8, Number of local variables: 1
  1927                                  ;   # type sign width line used address name   list of local variables
  1928                                  ;  200 var sign byte   163 NULL bp+4    c;
  1929 000009A8 C8000000                 ENTER  0,0
  1930 000009AC 8A4604                   mov al, [bp+4]
  1931 000009AF 8B1E[5300]               mov bx, [BinLen]
  1932 000009B3 88876B7B                 mov [FileBin+bx], al
  1933                                  
  1934                                  ;-166   BinLen++;
  1935                                  
  1936 000009B7 FF06[5300]               inc  word [BinLen]
  1937                                  
  1938                                  ;-167   PC++;
  1939                                  
  1940 000009BB FF06[3700]               inc  word [PC]
  1941                                  
  1942                                  ;-168   if (OpPrintIndex < OPMAXLEN) {
  1943                                  
  1944 000009BF A1[4800]                 mov ax, [OpPrintIndex]
  1945 000009C2 83F805                   cmp ax, 5
  1946 000009C5 0F8D0F00                 jge @@genCode861
  1947                                  
  1948                                  ;-169     OpPos[OpPrintIndex]=c;
  1949                                  
  1950 000009C9 8A4604                   mov al, [bp+4]
  1951 000009CC 8B1E[4800]               mov bx, [OpPrintIndex]
  1952 000009D0 8887B676                 mov [OpPos+bx], al
  1953                                  
  1954                                  ;-170     OpPrintIndex++;
  1955                                  
  1956 000009D4 FF06[4800]               inc  word [OpPrintIndex]
  1957                                  
  1958                                  ;-171   }
  1959                                  
  1960                                  
  1961                                  ;-172 }
  1962                                  
  1963                                  @@genCode861:
  1964                                  
  1965                                  ;-173 int genCode16(int i) {
  1966 000009D8 C9                       LEAVE
  1967 000009D9 C3                       ret
  1968                                  ; ENDP
  1969                                  
  1970                                  genCode16:  ; *** PROC ***
  1971                                  
  1972                                  ;-174   genCode8(i); i=i >> 8;
  1973                                  
  1974                                  ;Function : genCode16, Number of local variables: 1
  1975                                  ;   # type sign width line used address name   list of local variables
  1976                                  ;  200 var sign word   173 NULL bp+4    i;
  1977 000009DA C8000000                 ENTER  0,0
  1978 000009DE FF7604                   push word [bp+4]
  1979 000009E1 E8C4FF                   call genCode8
  1980 000009E4 83C402                   add  sp, 2
  1981 000009E7 8B4604                   mov ax, [bp+4]
  1982 000009EA C1E808                   shr ax, 8
  1983 000009ED 894604                   mov word [bp+4], ax
  1984                                  
  1985                                  ;-175   genCode8(i);
  1986                                  
  1987 000009F0 FF7604                   push word [bp+4]
  1988 000009F3 E8B2FF                   call genCode8
  1989 000009F6 83C402                   add  sp, 2
  1990                                  
  1991                                  ;-176 }
  1992                                  
  1993                                  
  1994                                  ;-177 int genCodeInREG() {char x; //get Code for second byte
  1995 000009F9 C9                       LEAVE
  1996 000009FA C3                       ret
  1997                                  ; ENDP
  1998                                  
  1999                                  genCodeInREG:  ; *** PROC ***
  2000                                  
  2001                                  ;-178   OpCodePtr++;
  2002                                  
  2003                                  ;Function : genCodeInREG, Number of local variables: 1
  2004                                  ;   # type sign width line used address name   list of local variables
  2005                                  ;  200 var sign byte   177 NULL bp-2    x;
  2006 000009FB C8020000                 ENTER  2,0
  2007 000009FF FF06[4A00]               inc  word [OpCodePtr]
  2008                                  
  2009                                  ;-179   x= *OpCodePtr;
  2010                                  
  2011 00000A03 8B1E[4A00]               mov bx, [OpCodePtr]
  2012 00000A07 8A07                     mov al, [bx]
  2013 00000A09 B400                     mov ah, 0
  2014 00000A0B 8846FE                   mov byte [bp-2], al
  2015                                  
  2016                                  ;-180   writeEA(x);
  2017                                  
  2018 00000A0E 8A46FE                   mov al, byte [bp-2]
  2019 00000A11 B400                     mov ah, 0
  2020 00000A13 50                       push ax
  2021 00000A14 E81200                   call writeEA
  2022 00000A17 83C402                   add  sp, 2
  2023                                  
  2024                                  ;-181 }
  2025                                  
  2026                                  
  2027                                  ;-182 int genModRegRM(){ writeEA(regindexbase);//todo
  2028 00000A1A C9                       LEAVE
  2029 00000A1B C3                       ret
  2030                                  ; ENDP
  2031                                  
  2032                                  genModRegRM:  ; *** PROC ***
  2033 00000A1C A0[4300]                 mov al, byte [regindexbase]
  2034 00000A1F B400                     mov ah, 0
  2035 00000A21 50                       push ax
  2036 00000A22 E80400                   call writeEA
  2037 00000A25 83C402                   add  sp, 2
  2038                                  
  2039                                  ;-183 }
  2040                                  
  2041                                  
  2042                                  ;-184 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2043                                  
  2044 00000A28 C3                       ret
  2045                                  ; ENDP
  2046                                  
  2047                                  writeEA:  ; *** PROC ***
  2048                                  
  2049                                  ;-185   char len;
  2050                                  
  2051                                  
  2052                                  ;-186   len=0;
  2053                                  
  2054                                  ;Function : writeEA, Number of local variables: 2
  2055                                  ;   # type sign width line used address name   list of local variables
  2056                                  ;  200 var sign byte   184 NULL bp+4    xxx
  2057                                  ;  201 var sign byte   185 NULL bp-2    len;
  2058 00000A29 C8020000                 ENTER  2,0
  2059 00000A2D 66B800000000             mov eax, 0
  2060 00000A33 8846FE                   mov byte [bp-2], al
  2061                                  
  2062                                  ;-187   xxx = xxx << 3;//in regindexbase field of mod r/m
  2063                                  
  2064 00000A36 8A4604                   mov al, [bp+4]
  2065 00000A39 C0E003                   shl al, 3
  2066 00000A3C 884604                   mov byte [bp+4], al
  2067                                  
  2068                                  ;-188   if (Op1 ==   0) addrexit();
  2069                                  
  2070 00000A3F A0[3D00]                 mov al, [Op1]
  2071 00000A42 3C00                     cmp al, 0
  2072 00000A44 0F850300                 jne @@writeEA62
  2073 00000A48 E82710                   call addrexit
  2074                                  
  2075                                  ;-189   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} //2
  2076                                  
  2077                                  @@writeEA62:
  2078 00000A4B A0[3D00]                 mov al, [Op1]
  2079 00000A4E 3C02                     cmp al, 2
  2080 00000A50 0F850E00                 jne @@writeEA63
  2081 00000A54 804E04C0                 or  byte [bp+4], 192
  2082 00000A58 8A4604                   mov al, [bp+4]
  2083 00000A5B 0206[4000]               add al, [RegNo]
  2084 00000A5F 884604                   mov byte [bp+4], al
  2085                                  
  2086                                  ;-190   if (Op1 == ADR) {xxx |= 6; len=2; }               //3
  2087                                  
  2088                                  @@writeEA63:
  2089 00000A62 A0[3D00]                 mov al, [Op1]
  2090 00000A65 3C03                     cmp al, 3
  2091 00000A67 0F850D00                 jne @@writeEA64
  2092 00000A6B 804E0406                 or  byte [bp+4], 6
  2093 00000A6F 66B802000000             mov eax, 2
  2094 00000A75 8846FE                   mov byte [bp-2], al
  2095                                  
  2096                                  ;-191   if (Op1 == MEM) { xxx = xxx + regindexbase;       //4
  2097                                  
  2098                                  @@writeEA64:
  2099 00000A78 A0[3D00]                 mov al, [Op1]
  2100 00000A7B 3C04                     cmp al, 4
  2101 00000A7D 0F854600                 jne @@writeEA65
  2102 00000A81 8A4604                   mov al, [bp+4]
  2103 00000A84 0206[4300]               add al, [regindexbase]
  2104 00000A88 884604                   mov byte [bp+4], al
  2105                                  
  2106                                  ;-192     if (disp) {
  2107                                  
  2108 00000A8B A1[4400]                 mov ax, [disp]
  2109 00000A8E 08C0                     or  al, al
  2110 00000A90 0F843300                 je @@writeEA66
  2111                                  
  2112                                  ;-193       disp;
  2113                                  
  2114 00000A94 A1[4400]                 mov ax, [disp]
  2115                                  
  2116                                  ;-194       if(ax > 127) len=2;
  2117                                  
  2118 00000A97 83F87F                   cmp  ax, 127
  2119 00000A9A 0F8E0C00                 jle @@writeEA67
  2120 00000A9E 66B802000000             mov eax, 2
  2121 00000AA4 8846FE                   mov byte [bp-2], al
  2122                                  
  2123                                  ;-195       else len=1;
  2124                                  
  2125 00000AA7 E90900                   jmp @@writeEA68
  2126                                  @@writeEA67:
  2127 00000AAA 66B801000000             mov eax, 1
  2128 00000AB0 8846FE                   mov byte [bp-2], al
  2129                                  
  2130                                  ;-196       if (len == 1) xxx |= 0x40;
  2131                                  
  2132                                  @@writeEA68:
  2133 00000AB3 8A46FE                   mov al, [bp-2]
  2134 00000AB6 3C01                     cmp al, 1
  2135 00000AB8 0F850700                 jne @@writeEA69
  2136 00000ABC 804E0440                 or  byte [bp+4], 64
  2137                                  
  2138                                  ;-197       else xxx |= 0x80;
  2139                                  
  2140 00000AC0 E90400                   jmp @@writeEA70
  2141                                  @@writeEA69:
  2142 00000AC3 804E0480                 or  byte [bp+4], 128
  2143                                  
  2144                                  ;-198     }
  2145                                  
  2146                                  @@writeEA70:
  2147                                  
  2148                                  ;-199   }
  2149                                  
  2150                                  @@writeEA66:
  2151                                  
  2152                                  ;-200   genCode8(xxx);// gen second byte
  2153                                  
  2154                                  @@writeEA65:
  2155 00000AC7 8A4604                   mov al, byte [bp+4]
  2156 00000ACA B400                     mov ah, 0
  2157 00000ACC 50                       push ax
  2158 00000ACD E8D8FE                   call genCode8
  2159 00000AD0 83C402                   add  sp, 2
  2160                                  
  2161                                  ;-201   if (len == 1) genCode8 (disp);
  2162                                  
  2163 00000AD3 8A46FE                   mov al, [bp-2]
  2164 00000AD6 3C01                     cmp al, 1
  2165 00000AD8 0F850A00                 jne @@writeEA71
  2166 00000ADC FF36[4400]               push word [disp]
  2167 00000AE0 E8C5FE                   call genCode8
  2168 00000AE3 83C402                   add  sp, 2
  2169                                  
  2170                                  ;-202   if (len == 2) genCode16(disp);
  2171                                  
  2172                                  @@writeEA71:
  2173 00000AE6 8A46FE                   mov al, [bp-2]
  2174 00000AE9 3C02                     cmp al, 2
  2175 00000AEB 0F850A00                 jne @@writeEA72
  2176 00000AEF FF36[4400]               push word [disp]
  2177 00000AF3 E8E4FE                   call genCode16
  2178 00000AF6 83C402                   add  sp, 2
  2179                                  
  2180                                  ;-203 }
  2181                                  
  2182                                  @@writeEA72:
  2183                                  
  2184                                  ;-204 
  2185                                  
  2186                                  
  2187                                  ;-205 int testx() { __asm {
  2188 00000AF9 C9                       LEAVE
  2189 00000AFA C3                       ret
  2190                                  ; ENDP
  2191                                  
  2192                                  testx:  ; *** PROC ***
  2193                                  
  2194                                  
  2195                                  ;-206 inc byte [Version1]   ;FE 06 [1000]
  2196                                  
  2197 00000AFB FE06[1000]              inc byte [Version1]   ;FE 06 [1000]
  2198                                  
  2199                                  ;-207 add bx, ax    ;01 C3
  2200                                  
  2201 00000AFF 01C3                    add bx, ax    ;01 C3
  2202                                  
  2203                                  ;-208 add ax, bx    ;01 D8
  2204                                  
  2205 00000B01 01D8                    add ax, bx    ;01 D8
  2206                                  
  2207                                  ;-209 add word ax, [bx] ;03 07
  2208                                  
  2209 00000B03 0307                    add word ax, [bx] ;03 07
  2210                                  
  2211                                  ;-210 VA dw 8
  2212                                  
  2213 00000B05 0800                    VA dw 8
  2214                                  
  2215                                  ;-211 mov byte [bp- 4], al ;88 46 FC
  2216                                  
  2217 00000B07 8846FC                  mov byte [bp- 4], al ;88 46 FC
  2218                                  
  2219                                  ;-212 mov      [VA+bx], al ;88 87 [300F]
  2220                                  
  2221 00000B0A 8887[050B]              mov      [VA+bx], al ;88 87 [300F]
  2222                                  
  2223                                  ;-213 }  
  2224                                  
  2225                                  
  2226                                  
  2227                                  ;-214 }
  2228                                  
  2229                                  
  2230                                  ;-215 #include "PARSE.C"
  2231                                  
  2232 00000B0E C3                       ret
  2233                                  ; ENDP
  2234                                  ;Use include file: PARSE.C
  2235                                  
  2236                                  ;-1 int parse() {
  2237                                  
  2238                                  
  2239                                  parse:  ; *** PROC ***
  2240                                  
  2241                                  ;-2   LabelNamePtr= &LabelNames;
  2242                                  
  2243 00000B0F B8BB76                   mov ax, LabelNames
  2244 00000B12 A3[4D00]                 mov word [LabelNamePtr], ax
  2245                                  
  2246                                  ;-3   do {
  2247                                  
  2248                                  @@parse73:
  2249                                  
  2250                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  2251                                  
  2252 00000B15 A1[3700]                 mov ax, [PC]
  2253 00000B18 A3[3900]                 mov word [PCStart], ax
  2254 00000B1B 66B800000000             mov eax, 0
  2255 00000B21 A2[4100]                 mov byte [OpSize], al
  2256 00000B24 66B800000000             mov eax, 0
  2257 00000B2A A3[4800]                 mov word [OpPrintIndex], ax
  2258 00000B2D 66B820000000             mov eax, 32
  2259 00000B33 A2[4C00]                 mov byte [PrintR], al
  2260                                  
  2261                                  ;-5     getLine();
  2262                                  
  2263 00000B36 E89404                   call getLine
  2264                                  
  2265                                  ;-6     InputPtr = &InputBuf;
  2266                                  
  2267 00000B39 B86E75                   mov ax, InputBuf
  2268 00000B3C A3[2800]                 mov word [InputPtr], ax
  2269                                  
  2270                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2271                                  
  2272 00000B3F E8B700                   call getTokeType
  2273                                  
  2274                                  ;-8     if (TokeType == ALNUME) {
  2275                                  
  2276 00000B42 A0[3C00]                 mov al, [TokeType]
  2277 00000B45 3C03                     cmp al, 3
  2278 00000B47 0F851300                 jne @@parse74
  2279                                  
  2280                                  ;-9       if (isLabel) { //set in getName
  2281                                  
  2282 00000B4B A0[3B00]                 mov al, [isLabel]
  2283 00000B4E 08C0                     or  al, al
  2284 00000B50 0F840A00                 je @@parse75
  2285                                  
  2286                                  ;-10         storeLabel();
  2287                                  
  2288 00000B54 E84001                   call storeLabel
  2289                                  
  2290                                  ;-11         InputPtr++;//remove :
  2291                                  
  2292 00000B57 FF06[2800]               inc  word [InputPtr]
  2293                                  
  2294                                  ;-12         getTokeType();
  2295                                  
  2296 00000B5B E89B00                   call getTokeType
  2297                                  
  2298                                  ;-13       }
  2299                                  
  2300                                  
  2301                                  ;-14     }
  2302                                  
  2303                                  @@parse75:
  2304                                  
  2305                                  ;-15     if (TokeType == ALNUME) {
  2306                                  
  2307                                  @@parse74:
  2308 00000B5E A0[3C00]                 mov al, [TokeType]
  2309 00000B61 3C03                     cmp al, 3
  2310 00000B63 0F851B00                 jne @@parse76
  2311                                  
  2312                                  ;-16       lookCode();// and OpCodePtr
  2313                                  
  2314 00000B67 E80F03                   call lookCode
  2315                                  
  2316                                  ;-17       if(CodeType) process();
  2317                                  
  2318 00000B6A A0[3E00]                 mov al, [CodeType]
  2319 00000B6D 08C0                     or  al, al
  2320 00000B6F 0F840600                 je @@parse77
  2321 00000B73 E898F8                   call process
  2322                                  
  2323                                  ;-18       else getVariable();
  2324                                  
  2325 00000B76 E90300                   jmp @@parse78
  2326                                  @@parse77:
  2327 00000B79 E8C501                   call getVariable
  2328                                  
  2329                                  ;-19       skipRest();
  2330                                  
  2331                                  @@parse78:
  2332 00000B7C E82504                   call skipRest
  2333                                  
  2334                                  ;-20     }
  2335                                  
  2336                                  
  2337                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2338                                  
  2339 00000B7F E92700                   jmp @@parse79
  2340                                  @@parse76:
  2341 00000B82 A0[3C00]                 mov al, [TokeType]
  2342 00000B85 3C03                     cmp al, 3
  2343 00000B87 0F8E0C00                 jle @@parse80
  2344 00000B8B 68[BA0B]                 push parse_0
  2345 00000B8E E8990D                   call error1
  2346 00000B91 83C402                   add  sp, 2
  2347                                  
  2348                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2349                                  
  2350 00000B94 E91200                   jmp @@parse81
  2351                                  @@parse80:
  2352 00000B97 A0[3C00]                 mov al, [TokeType]
  2353 00000B9A 3C01                     cmp al, 1
  2354 00000B9C 0F850900                 jne @@parse82
  2355 00000BA0 68[D80B]                 push parse_1
  2356 00000BA3 E8840D                   call error1
  2357 00000BA6 83C402                   add  sp, 2
  2358                                  
  2359                                  ;-23     printLine();
  2360                                  
  2361                                  @@parse82:
  2362                                  @@parse81:
  2363                                  @@parse79:
  2364 00000BA9 E8130B                   call printLine
  2365                                  
  2366                                  ;-24   } while (DOS_NoBytes != 0 );
  2367                                  
  2368 00000BAC A1[3400]                 mov ax, [DOS_NoBytes]
  2369 00000BAF 83F800                   cmp ax, 0
  2370 00000BB2 0F840300                 je  @@parse83
  2371 00000BB6 E95CFF                   jmp @@parse73
  2372                                  @@parse83:
  2373                                  
  2374                                  ;-25 }
  2375                                  
  2376                                  
  2377                                  ;-26 // scan code .....................................
  2378                                  
  2379                                  
  2380                                  ;-27 int getTokeType() { char c;
  2381                                  
  2382 00000BB9 C3                       ret
  2383                                  ; ENDP
  2384 00000BBA 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2385 00000BC3 696E73747275637469-
  2386 00000BCC 6F6E20657870656374-
  2387 00000BD5 656400             
  2388 00000BD8 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2389 00000BE1 616C6C6F7765642040-
  2390 00000BEA 207374617274206F66-
  2391 00000BF3 206C696E6500       
  2392                                  
  2393                                  getTokeType:  ; *** PROC ***
  2394                                  
  2395                                  ;-28   skipBlank();
  2396                                  
  2397                                  ;Function : getTokeType, Number of local variables: 1
  2398                                  ;   # type sign width line used address name   list of local variables
  2399                                  ;  200 var sign byte    27 NULL bp-2    c;
  2400 00000BF9 C8020000                 ENTER  2,0
  2401 00000BFD E89A04                   call skipBlank
  2402                                  
  2403                                  ;-29   c = *InputPtr;
  2404                                  
  2405 00000C00 8B1E[2800]               mov bx, [InputPtr]
  2406 00000C04 8A07                     mov al, [bx]
  2407 00000C06 B400                     mov ah, 0
  2408 00000C08 8846FE                   mov byte [bp-2], al
  2409                                  
  2410                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2411                                  
  2412 00000C0B 8A46FE                   mov al, [bp-2]
  2413 00000C0E 3C00                     cmp al, 0
  2414 00000C10 0F850C00                 jne @@getTokeType84
  2415 00000C14 66B800000000             mov eax, 0
  2416 00000C1A A2[3C00]                 mov byte [TokeType], al
  2417 00000C1D E97500                   jmp @@retn
  2418                                  
  2419                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2420                                  
  2421                                  @@getTokeType84:
  2422 00000C20 8A46FE                   mov al, [bp-2]
  2423 00000C23 3C3B                     cmp al, 59
  2424 00000C25 0F850C00                 jne @@getTokeType85
  2425 00000C29 66B800000000             mov eax, 0
  2426 00000C2F A2[3C00]                 mov byte [TokeType], al
  2427 00000C32 E96000                   jmp @@retn
  2428                                  
  2429                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2430                                  
  2431                                  @@getTokeType85:
  2432 00000C35 8A46FE                   mov al, byte [bp-2]
  2433 00000C38 B400                     mov ah, 0
  2434 00000C3A 50                       push ax
  2435 00000C3B E84013                   call digit
  2436 00000C3E 83C402                   add  sp, 2
  2437 00000C41 08C0                     or  al, al
  2438 00000C43 0F841800                 je @@getTokeType86
  2439 00000C47 8A46FE                   mov al, byte [bp-2]
  2440 00000C4A B400                     mov ah, 0
  2441 00000C4C 50                       push ax
  2442 00000C4D E85005                   call getDigit
  2443 00000C50 83C402                   add  sp, 2
  2444 00000C53 66B801000000             mov eax, 1
  2445 00000C59 A2[3C00]                 mov byte [TokeType], al
  2446 00000C5C E93600                   jmp @@retn
  2447                                  
  2448                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2449                                  
  2450                                  @@getTokeType86:
  2451 00000C5F 8A46FE                   mov al, byte [bp-2]
  2452 00000C62 B400                     mov ah, 0
  2453 00000C64 50                       push ax
  2454 00000C65 E85D04                   call letterE
  2455 00000C68 83C402                   add  sp, 2
  2456 00000C6B 08C0                     or  al, al
  2457 00000C6D 0F841800                 je @@getTokeType87
  2458 00000C71 8A46FE                   mov al, byte [bp-2]
  2459 00000C74 B400                     mov ah, 0
  2460 00000C76 50                       push ax
  2461 00000C77 E87D05                   call getName
  2462 00000C7A 83C402                   add  sp, 2
  2463 00000C7D 66B803000000             mov eax, 3
  2464 00000C83 A2[3C00]                 mov byte [TokeType], al
  2465 00000C86 E90C00                   jmp @@retn
  2466                                  
  2467                                  ;-34   TokeType=NOALNUME; return;
  2468                                  
  2469                                  @@getTokeType87:
  2470 00000C89 66B804000000             mov eax, 4
  2471 00000C8F A2[3C00]                 mov byte [TokeType], al
  2472 00000C92 E90000                   jmp @@retn
  2473                                  
  2474                                  ;-35 }
  2475                                  
  2476                                  
  2477                                  ;-36 int storeLabel() {
  2478                                  
  2479 00000C95 C9                      @@retn: LEAVE
  2480 00000C96 C3                       ret
  2481                                  ; ENDP
  2482                                  
  2483                                  storeLabel:  ; *** PROC ***
  2484                                  
  2485                                  ;-37   if(searchLabel()) error1("duplicate label");
  2486                                  
  2487 00000C97 E84700                   call searchLabel
  2488 00000C9A 08C0                     or  al, al
  2489 00000C9C 0F840900                 je @@storeLabel88
  2490 00000CA0 68[D10C]                 push storeLabel_0
  2491 00000CA3 E8840C                   call error1
  2492 00000CA6 83C402                   add  sp, 2
  2493                                  
  2494                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2495                                  
  2496                                  @@storeLabel88:
  2497 00000CA9 8D063075                 lea  ax, [Symbol]
  2498 00000CAD 50                       push ax
  2499 00000CAE FF36[4D00]               push word [LabelNamePtr]
  2500 00000CB2 E89012                   call strcpy
  2501 00000CB5 83C404                   add  sp, 4
  2502 00000CB8 A3[4D00]                 mov word [LabelNamePtr], ax
  2503                                  
  2504                                  ;-39   LabelNamePtr++;
  2505                                  
  2506 00000CBB FF06[4D00]               inc  word [LabelNamePtr]
  2507                                  
  2508                                  ;-40   LabelMaxIx++;
  2509                                  
  2510 00000CBF FF06[4F00]               inc  word [LabelMaxIx]
  2511                                  
  2512                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2513                                  
  2514 00000CC3 A1[3700]                 mov ax, [PC]
  2515 00000CC6 8B1E[4F00]               mov bx, [LabelMaxIx]
  2516 00000CCA D1E3                     shl bx, 1
  2517 00000CCC 8987A37A                 mov [LabelAddr+bx], ax
  2518                                  
  2519                                  ;-42 }
  2520                                  
  2521                                  
  2522                                  ;-43 int searchLabel() {
  2523                                  
  2524 00000CD0 C3                       ret
  2525                                  ; ENDP
  2526 00000CD1 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2527 00000CDA 206C6162656C00     
  2528                                  
  2529                                  searchLabel:  ; *** PROC ***
  2530                                  
  2531                                  ;-44   int LIx; char *p; int j;
  2532                                  
  2533                                  
  2534                                  ;-45   p = &LabelNames;
  2535                                  
  2536                                  ;Function : searchLabel, Number of local variables: 3
  2537                                  ;   # type sign width line used address name   list of local variables
  2538                                  ;  200 var sign word    44 NULL bp-2    LIx
  2539                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2540                                  ;  202 var sign word    44 NULL bp-6    j;
  2541 00000CE1 C8060000                 ENTER  6,0
  2542 00000CE5 B8BB76                   mov ax, LabelNames
  2543 00000CE8 8946FC                   mov word [bp-4], ax
  2544                                  
  2545                                  ;-46   LIx=1;
  2546                                  
  2547 00000CEB 66B801000000             mov eax, 1
  2548 00000CF1 8946FE                   mov word [bp-2], ax
  2549                                  
  2550                                  ;-47   while (LIx <= LabelMaxIx) {
  2551                                  
  2552                                  @@searchLabel89:
  2553 00000CF4 8B46FE                   mov ax, [bp-2]
  2554 00000CF7 3B06[4F00]               cmp ax, [LabelMaxIx]
  2555 00000CFB 0F8F3700                 jg  @@searchLabel90
  2556                                  
  2557                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2558                                  
  2559 00000CFF 8D063075                 lea  ax, [Symbol]
  2560 00000D03 50                       push ax
  2561 00000D04 FF76FC                   push word [bp-4]
  2562 00000D07 E8A712                   call eqstr
  2563 00000D0A 83C404                   add  sp, 4
  2564 00000D0D 08C0                     or  al, al
  2565 00000D0F 0F840600                 je @@searchLabel91
  2566 00000D13 8B46FE                   mov ax, [bp-2]
  2567 00000D16 E92600                   jmp @@retn
  2568                                  
  2569                                  ;-49     j=strlen(p);
  2570                                  
  2571                                  @@searchLabel91:
  2572 00000D19 FF76FC                   push word [bp-4]
  2573 00000D1C E8FB11                   call strlen
  2574 00000D1F 83C402                   add  sp, 2
  2575 00000D22 8946FA                   mov word [bp-6], ax
  2576                                  
  2577                                  ;-50     p=p+j; p++; LIx++;
  2578                                  
  2579 00000D25 8B46FC                   mov ax, [bp-4]
  2580 00000D28 0346FA                   add ax, [bp-6]
  2581 00000D2B 8946FC                   mov word [bp-4], ax
  2582 00000D2E FF46FC                   inc  word [bp-4]
  2583 00000D31 FF46FE                   inc  word [bp-2]
  2584                                  
  2585                                  ;-51   }
  2586                                  
  2587                                  
  2588                                  ;-52   return 0;
  2589                                  
  2590 00000D34 EBBE                     jmp @@searchLabel89
  2591                                  @@searchLabel90:
  2592 00000D36 66B800000000             mov eax, 0
  2593 00000D3C E90000                   jmp @@retn
  2594                                  
  2595                                  ;-53 }
  2596                                  
  2597                                  
  2598                                  ;-54 int getVariable() { char c;
  2599                                  
  2600 00000D3F C9                      @@retn: LEAVE
  2601 00000D40 C3                       ret
  2602                                  ; ENDP
  2603                                  
  2604                                  getVariable:  ; *** PROC ***
  2605                                  
  2606                                  ;-55   storeLabel();
  2607                                  
  2608                                  ;Function : getVariable, Number of local variables: 1
  2609                                  ;   # type sign width line used address name   list of local variables
  2610                                  ;  200 var sign byte    54 NULL bp-2    c;
  2611 00000D41 C8020000                 ENTER  2,0
  2612 00000D45 E84FFF                   call storeLabel
  2613                                  
  2614                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2615                                  
  2616 00000D48 E8AEFE                   call getTokeType
  2617 00000D4B A0[3C00]                 mov al, [TokeType]
  2618 00000D4E 3C03                     cmp al, 3
  2619 00000D50 0F85CC00                 jne @@getVariable92
  2620                                  
  2621                                  ;-57     lookCode();
  2622                                  
  2623 00000D54 E82201                   call lookCode
  2624                                  
  2625                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2626                                  
  2627 00000D57 A0[3E00]                 mov al, [CodeType]
  2628 00000D5A 3CC8                     cmp al, 200
  2629 00000D5C 0F8D0900                 jge @@getVariable93
  2630 00000D60 68[2B0E]                 push getVariable_0
  2631 00000D63 E8F50C                   call errorexit
  2632 00000D66 83C402                   add  sp, 2
  2633                                  
  2634                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2635                                  
  2636                                  @@getVariable93:
  2637 00000D69 A0[3E00]                 mov al, [CodeType]
  2638 00000D6C 3CCF                     cmp al, 207
  2639 00000D6E 0F8E0900                 jle @@getVariable94
  2640 00000D72 68[430E]                 push getVariable_1
  2641 00000D75 E8E30C                   call errorexit
  2642 00000D78 83C402                   add  sp, 2
  2643                                  
  2644                                  ;-60     if (CodeType== 200) {// DB
  2645                                  
  2646                                  @@getVariable94:
  2647 00000D7B A0[3E00]                 mov al, [CodeType]
  2648 00000D7E 3CC8                     cmp al, 200
  2649 00000D80 0F856A00                 jne @@getVariable95
  2650                                  
  2651                                  ;-61       do { getTokeType();
  2652                                  
  2653                                  @@getVariable96:
  2654 00000D84 E872FE                   call getTokeType
  2655                                  
  2656                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2657                                  
  2658 00000D87 A0[3C00]                 mov al, [TokeType]
  2659 00000D8A 3C01                     cmp al, 1
  2660 00000D8C 0F850D00                 jne @@getVariable97
  2661 00000D90 FF36[2600]               push word [SymbolInt]
  2662 00000D94 E811FC                   call genCode8
  2663 00000D97 83C402                   add  sp, 2
  2664                                  
  2665                                  ;-63         else {
  2666                                  
  2667 00000D9A E94100                   jmp @@getVariable98
  2668                                  @@getVariable97:
  2669                                  
  2670                                  ;-64           skipBlank();
  2671                                  
  2672 00000D9D E8FA02                   call skipBlank
  2673                                  
  2674                                  ;-65           if (isToken('"')) {
  2675                                  
  2676 00000DA0 6A22                     push 34
  2677 00000DA2 E8D101                   call isToken
  2678 00000DA5 83C402                   add  sp, 2
  2679 00000DA8 08C0                     or  al, al
  2680 00000DAA 0F843000                 je @@getVariable99
  2681                                  
  2682                                  ;-66             do { c= *InputPtr;
  2683                                  
  2684                                  @@getVariable100:
  2685 00000DAE 8B1E[2800]               mov bx, [InputPtr]
  2686 00000DB2 8A07                     mov al, [bx]
  2687 00000DB4 B400                     mov ah, 0
  2688 00000DB6 8846FE                   mov byte [bp-2], al
  2689                                  
  2690                                  ;-67               genCode8(c);
  2691                                  
  2692 00000DB9 8A46FE                   mov al, byte [bp-2]
  2693 00000DBC B400                     mov ah, 0
  2694 00000DBE 50                       push ax
  2695 00000DBF E8E6FB                   call genCode8
  2696 00000DC2 83C402                   add  sp, 2
  2697                                  
  2698                                  ;-68               InputPtr++;
  2699                                  
  2700 00000DC5 FF06[2800]               inc  word [InputPtr]
  2701                                  
  2702                                  ;-69             } while (*InputPtr != '"' );
  2703                                  
  2704 00000DC9 8B1E[2800]               mov bx, [InputPtr]
  2705 00000DCD 8A07                     mov al, [bx]
  2706 00000DCF B400                     mov ah, 0
  2707 00000DD1 83F822                   cmp ax, 34
  2708 00000DD4 0F840200                 je  @@getVariable101
  2709 00000DD8 EBD4                     jmp @@getVariable100
  2710                                  @@getVariable101:
  2711                                  
  2712                                  ;-70             InputPtr++;
  2713                                  
  2714 00000DDA FF06[2800]               inc  word [InputPtr]
  2715                                  
  2716                                  ;-71           }
  2717                                  
  2718                                  
  2719                                  ;-72         }
  2720                                  
  2721                                  @@getVariable99:
  2722                                  
  2723                                  ;-73       } while (isToken(','));
  2724                                  
  2725                                  @@getVariable98:
  2726 00000DDE 6A2C                     push 44
  2727 00000DE0 E89301                   call isToken
  2728 00000DE3 83C402                   add  sp, 2
  2729 00000DE6 08C0                     or  al, al
  2730 00000DE8 0F840200                 je @@getVariable102
  2731 00000DEC EB96                     jmp @@getVariable96
  2732                                  @@getVariable102:
  2733                                  
  2734                                  ;-74     }
  2735                                  
  2736                                  
  2737                                  ;-75     if (CodeType== 201) {// DW
  2738                                  
  2739                                  @@getVariable95:
  2740 00000DEE A0[3E00]                 mov al, [CodeType]
  2741 00000DF1 3CC9                     cmp al, 201
  2742 00000DF3 0F852600                 jne @@getVariable103
  2743                                  
  2744                                  ;-76       do { getTokeType();
  2745                                  
  2746                                  @@getVariable104:
  2747 00000DF7 E8FFFD                   call getTokeType
  2748                                  
  2749                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2750                                  
  2751 00000DFA A0[3C00]                 mov al, [TokeType]
  2752 00000DFD 3C01                     cmp al, 1
  2753 00000DFF 0F850A00                 jne @@getVariable105
  2754 00000E03 FF36[2600]               push word [SymbolInt]
  2755 00000E07 E8D0FB                   call genCode16
  2756 00000E0A 83C402                   add  sp, 2
  2757                                  
  2758                                  ;-78       } while (isToken(','));
  2759                                  
  2760                                  @@getVariable105:
  2761 00000E0D 6A2C                     push 44
  2762 00000E0F E86401                   call isToken
  2763 00000E12 83C402                   add  sp, 2
  2764 00000E15 08C0                     or  al, al
  2765 00000E17 0F840200                 je @@getVariable106
  2766 00000E1B EBDA                     jmp @@getVariable104
  2767                                  @@getVariable106:
  2768                                  
  2769                                  ;-79     }
  2770                                  
  2771                                  
  2772                                  ;-80   }
  2773                                  
  2774                                  @@getVariable103:
  2775                                  
  2776                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2777                                  
  2778 00000E1D E90900                   jmp @@getVariable107
  2779                                  @@getVariable92:
  2780 00000E20 68[5B0E]                 push getVariable_2
  2781 00000E23 E8350C                   call errorexit
  2782 00000E26 83C402                   add  sp, 2
  2783                                  
  2784                                  ;-82 }
  2785                                  
  2786                                  @@getVariable107:
  2787                                  
  2788                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2789 00000E29 C9                       LEAVE
  2790 00000E2A C3                       ret
  2791                                  ; ENDP
  2792 00000E2B 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2793 00000E34 422C572C4420657870-
  2794 00000E3D 656374656400       
  2795 00000E43 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2796 00000E4C 422C572C4420657870-
  2797 00000E55 656374656400       
  2798 00000E5B 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2799 00000E64 6F7220524553422C57-
  2800 00000E6D 2C4420657870656374-
  2801 00000E76 656400             
  2802                                  
  2803                                  lookCode:  ; *** PROC ***
  2804                                  
  2805                                  ;-84   CodeType=0;
  2806                                  
  2807 00000E79 66B800000000             mov eax, 0
  2808 00000E7F A2[3E00]                 mov byte [CodeType], al
  2809                                  
  2810                                  ;-85   OpCodePtr= &I_START;
  2811                                  
  2812 00000E82 B8[5900]                 mov ax, I_START
  2813 00000E85 A3[4A00]                 mov word [OpCodePtr], ax
  2814                                  
  2815                                  ;-86   OpCodePtr++;
  2816                                  
  2817 00000E88 FF06[4A00]               inc  word [OpCodePtr]
  2818                                  
  2819                                  ;-87   do  {
  2820                                  
  2821                                  @@lookCode108:
  2822                                  
  2823                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2824                                  
  2825 00000E8C FF36[4A00]               push word [OpCodePtr]
  2826 00000E90 8D064F75                 lea  ax, [SymbolUpper]
  2827 00000E94 50                       push ax
  2828 00000E95 E81911                   call eqstr
  2829 00000E98 83C404                   add  sp, 4
  2830 00000E9B 08C0                     or  al, al
  2831 00000E9D 0F842700                 je @@lookCode109
  2832                                  
  2833                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2834                                  
  2835                                  @@lookCode110:
  2836 00000EA1 8B1E[4A00]               mov bx, [OpCodePtr]
  2837 00000EA5 8A07                     mov al, [bx]
  2838 00000EA7 B400                     mov ah, 0
  2839 00000EA9 83F800                   cmp ax, 0
  2840 00000EAC 0F840600                 je  @@lookCode111
  2841 00000EB0 FF06[4A00]               inc  word [OpCodePtr]
  2842                                  
  2843                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2844                                  
  2845 00000EB4 EBEB                     jmp @@lookCode110
  2846                                  @@lookCode111:
  2847 00000EB6 FF06[4A00]               inc  word [OpCodePtr]
  2848 00000EBA 8B1E[4A00]               mov bx, [OpCodePtr]
  2849 00000EBE 8A07                     mov al, [bx]
  2850 00000EC0 B400                     mov ah, 0
  2851 00000EC2 A2[3E00]                 mov byte [CodeType], al
  2852                                  
  2853                                  ;-91       return;
  2854                                  
  2855 00000EC5 E92A00                   jmp @@retn
  2856                                  
  2857                                  ;-92     }
  2858                                  
  2859                                  
  2860                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2861                                  
  2862                                  @@lookCode109:
  2863                                  @@lookCode112:
  2864 00000EC8 8B1E[4A00]               mov bx, [OpCodePtr]
  2865 00000ECC 8A07                     mov al, [bx]
  2866 00000ECE B400                     mov ah, 0
  2867 00000ED0 3DF100                   cmp ax, 241
  2868 00000ED3 0F840600                 je  @@lookCode113
  2869 00000ED7 FF06[4A00]               inc  word [OpCodePtr]
  2870                                  
  2871                                  ;-94   OpCodePtr++;
  2872                                  
  2873 00000EDB EBEB                     jmp @@lookCode112
  2874                                  @@lookCode113:
  2875 00000EDD FF06[4A00]               inc  word [OpCodePtr]
  2876                                  
  2877                                  ;-95   } while(*OpCodePtr!=0);
  2878                                  
  2879 00000EE1 8B1E[4A00]               mov bx, [OpCodePtr]
  2880 00000EE5 8A07                     mov al, [bx]
  2881 00000EE7 B400                     mov ah, 0
  2882 00000EE9 83F800                   cmp ax, 0
  2883 00000EEC 0F840200                 je  @@lookCode114
  2884 00000EF0 EB9A                     jmp @@lookCode108
  2885                                  @@lookCode114:
  2886                                  
  2887                                  ;-96 }
  2888                                  
  2889                                  
  2890                                  ;-97 int getCodeSize() {
  2891                                  
  2892                                  @@retn:
  2893 00000EF2 C3                       ret
  2894                                  ; ENDP
  2895                                  
  2896                                  getCodeSize:  ; *** PROC ***
  2897                                  
  2898                                  ;-98   if (TokeType ==ALNUME) {
  2899                                  
  2900 00000EF3 A0[3C00]                 mov al, [TokeType]
  2901 00000EF6 3C03                     cmp al, 3
  2902 00000EF8 0F856000                 jne @@getCodeSize115
  2903                                  
  2904                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2905                                  
  2906 00000EFC 68[660F]                 push getCodeSize_0
  2907 00000EFF 8D064F75                 lea  ax, [SymbolUpper]
  2908 00000F03 50                       push ax
  2909 00000F04 E8AA10                   call eqstr
  2910 00000F07 83C404                   add  sp, 4
  2911 00000F0A 08C0                     or  al, al
  2912 00000F0C 0F840C00                 je @@getCodeSize116
  2913 00000F10 E8E6FC                   call getTokeType
  2914 00000F13 66B801000000             mov eax, 1
  2915 00000F19 E94900                   jmp @@retn
  2916                                  
  2917                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2918                                  
  2919                                  @@getCodeSize116:
  2920 00000F1C 68[6B0F]                 push getCodeSize_1
  2921 00000F1F 8D064F75                 lea  ax, [SymbolUpper]
  2922 00000F23 50                       push ax
  2923 00000F24 E88A10                   call eqstr
  2924 00000F27 83C404                   add  sp, 4
  2925 00000F2A 08C0                     or  al, al
  2926 00000F2C 0F840C00                 je @@getCodeSize117
  2927 00000F30 E8C6FC                   call getTokeType
  2928 00000F33 66B802000000             mov eax, 2
  2929 00000F39 E92900                   jmp @@retn
  2930                                  
  2931                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2932                                  
  2933                                  @@getCodeSize117:
  2934 00000F3C 68[700F]                 push getCodeSize_2
  2935 00000F3F 8D064F75                 lea  ax, [SymbolUpper]
  2936 00000F43 50                       push ax
  2937 00000F44 E86A10                   call eqstr
  2938 00000F47 83C404                   add  sp, 4
  2939 00000F4A 08C0                     or  al, al
  2940 00000F4C 0F840C00                 je @@getCodeSize118
  2941 00000F50 E8A6FC                   call getTokeType
  2942 00000F53 66B803000000             mov eax, 3
  2943 00000F59 E90900                   jmp @@retn
  2944                                  
  2945                                  ;-102   } return 0;
  2946                                  
  2947                                  @@getCodeSize118:
  2948                                  @@getCodeSize115:
  2949 00000F5C 66B800000000             mov eax, 0
  2950 00000F62 E90000                   jmp @@retn
  2951                                  
  2952                                  ;-103 }
  2953                                  
  2954                                  
  2955                                  ;-104 int isToken(char c) {
  2956                                  
  2957                                  @@retn:
  2958 00000F65 C3                       ret
  2959                                  ; ENDP
  2960 00000F66 4259544500              getCodeSize_0 db "BYTE",0
  2961 00000F6B 574F524400              getCodeSize_1 db "WORD",0
  2962 00000F70 44574F524400            getCodeSize_2 db "DWORD",0
  2963                                  
  2964                                  isToken:  ; *** PROC ***
  2965                                  
  2966                                  ;-105   skipBlank();
  2967                                  
  2968                                  ;Function : isToken, Number of local variables: 1
  2969                                  ;   # type sign width line used address name   list of local variables
  2970                                  ;  200 var sign byte   104 NULL bp+4    c;
  2971 00000F76 C8000000                 ENTER  0,0
  2972 00000F7A E81D01                   call skipBlank
  2973                                  
  2974                                  ;-106   if (*InputPtr == c) {
  2975                                  
  2976 00000F7D 8B1E[2800]               mov bx, [InputPtr]
  2977 00000F81 8A07                     mov al, [bx]
  2978 00000F83 B400                     mov ah, 0
  2979 00000F85 3A4604                   cmp al, [bp+4]
  2980 00000F88 0F850D00                 jne @@isToken119
  2981                                  
  2982                                  ;-107     InputPtr++; return 1;} return 0;
  2983                                  
  2984 00000F8C FF06[2800]               inc  word [InputPtr]
  2985 00000F90 66B801000000             mov eax, 1
  2986 00000F96 E90900                   jmp @@retn
  2987                                  @@isToken119:
  2988 00000F99 66B800000000             mov eax, 0
  2989 00000F9F E90000                   jmp @@retn
  2990                                  
  2991                                  ;-108 }
  2992                                  
  2993                                  
  2994                                  ;-109 int skipRest() {
  2995                                  
  2996 00000FA2 C9                      @@retn: LEAVE
  2997 00000FA3 C3                       ret
  2998                                  ; ENDP
  2999                                  
  3000                                  skipRest:  ; *** PROC ***
  3001                                  
  3002                                  ;-110   getTokeType(); if(TokeType!=0)error1("extra char ignored");
  3003                                  
  3004 00000FA4 E852FC                   call getTokeType
  3005 00000FA7 A0[3C00]                 mov al, [TokeType]
  3006 00000FAA 3C00                     cmp al, 0
  3007 00000FAC 0F840900                 je  @@skipRest120
  3008 00000FB0 68[BA0F]                 push skipRest_0
  3009 00000FB3 E87409                   call error1
  3010 00000FB6 83C402                   add  sp, 2
  3011                                  
  3012                                  ;-111 }
  3013                                  
  3014                                  @@skipRest120:
  3015 00000FB9 C3                       ret
  3016                                  ; ENDP
  3017 00000FBA 657874726120636861-     skipRest_0 db "extra char ignored",0
  3018 00000FC3 722069676E6F726564-
  3019 00000FCC 00                 
  3020                                  ;Back to main program: AS.C
  3021                                  
  3022                                  ;-216 #include "HELPER.C"
  3023                                  
  3024                                  ;Use include file: HELPER.C
  3025                                  
  3026                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3027                                  
  3028                                  
  3029                                  getLine:  ; *** PROC ***
  3030                                  
  3031                                  ;-2   InputPtr= &InputBuf;
  3032                                  
  3033 00000FCD B86E75                   mov ax, InputBuf
  3034 00000FD0 A3[2800]                 mov word [InputPtr], ax
  3035                                  
  3036                                  ;-3   *InputPtr=0;//if last line is empty
  3037                                  
  3038 00000FD3 66B800000000             mov eax, 0
  3039 00000FD9 8B1E[2800]               mov  bx, [InputPtr]
  3040 00000FDD 8807                     mov  [bx], al
  3041                                  
  3042                                  ;-4   do {
  3043                                  
  3044                                  @@getLine121:
  3045                                  
  3046                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3047                                  
  3048 00000FDF 6A01                     push 1
  3049 00000FE1 FF36[2A00]               push word [asm_fd]
  3050 00000FE5 8D06[3600]               lea  ax, [DOS_ByteRead]
  3051 00000FE9 50                       push ax
  3052 00000FEA E85F10                   call readRL
  3053 00000FED 83C406                   add  sp, 6
  3054 00000FF0 A3[3400]                 mov word [DOS_NoBytes], ax
  3055                                  
  3056                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3057                                  
  3058 00000FF3 A1[3000]                 mov ax, [DOS_ERR]
  3059 00000FF6 08C0                     or  al, al
  3060 00000FF8 0F840900                 je @@getLine122
  3061 00000FFC 68[4410]                 push getLine_0
  3062 00000FFF E8590A                   call errorexit
  3063 00001002 83C402                   add  sp, 2
  3064                                  
  3065                                  ;-7     if (DOS_NoBytes == 0) return;
  3066                                  
  3067                                  @@getLine122:
  3068 00001005 A1[3400]                 mov ax, [DOS_NoBytes]
  3069 00001008 83F800                   cmp ax, 0
  3070 0000100B 0F850300                 jne @@getLine123
  3071 0000100F E93100                   jmp @@retn
  3072                                  
  3073                                  ;-8     *InputPtr = DOS_ByteRead;
  3074                                  
  3075                                  @@getLine123:
  3076 00001012 A0[3600]                 mov al, [DOS_ByteRead]
  3077 00001015 8B1E[2800]               mov  bx, [InputPtr]
  3078 00001019 8807                     mov  [bx], al
  3079                                  
  3080                                  ;-9     InputPtr++;
  3081                                  
  3082 0000101B FF06[2800]               inc  word [InputPtr]
  3083                                  
  3084                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3085                                  
  3086 0000101F A0[3600]                 mov al, byte [DOS_ByteRead]
  3087 00001022 B400                     mov ah, 0
  3088 00001024 50                       push ax
  3089 00001025 E82B00                   call ifEOL
  3090 00001028 83C402                   add  sp, 2
  3091 0000102B 3C00                     cmp al, 0
  3092 0000102D 0F850200                 jne @@getLine124
  3093 00001031 EBAC                     jmp @@getLine121
  3094                                  @@getLine124:
  3095                                  
  3096                                  ;-11   InputPtr--;
  3097                                  
  3098 00001033 FF0E[2800]               dec  word [InputPtr]
  3099                                  
  3100                                  ;-12   *InputPtr=0;
  3101                                  
  3102 00001037 66B800000000             mov eax, 0
  3103 0000103D 8B1E[2800]               mov  bx, [InputPtr]
  3104 00001041 8807                     mov  [bx], al
  3105                                  
  3106                                  ;-13 }
  3107                                  
  3108                                  
  3109                                  ;-14 int ifEOL(char c) {
  3110                                  
  3111                                  @@retn:
  3112 00001043 C3                       ret
  3113                                  ; ENDP
  3114 00001044 52656164696E672053-     getLine_0 db "Reading Source",0
  3115 0000104D 6F7572636500       
  3116                                  
  3117                                  ifEOL:  ; *** PROC ***
  3118                                  
  3119                                  ;-15   if (c == 10) return 1;
  3120                                  
  3121                                  ;Function : ifEOL, Number of local variables: 1
  3122                                  ;   # type sign width line used address name   list of local variables
  3123                                  ;  200 var sign byte    14 NULL bp+4    c;
  3124 00001053 C8000000                 ENTER  0,0
  3125 00001057 8A4604                   mov al, [bp+4]
  3126 0000105A 3C0A                     cmp al, 10
  3127 0000105C 0F850900                 jne @@ifEOL125
  3128 00001060 66B801000000             mov eax, 1
  3129 00001066 E92F00                   jmp @@retn
  3130                                  
  3131                                  ;-16   if (c == 13) {
  3132                                  
  3133                                  @@ifEOL125:
  3134 00001069 8A4604                   mov al, [bp+4]
  3135 0000106C 3C0D                     cmp al, 13
  3136 0000106E 0F851D00                 jne @@ifEOL126
  3137                                  
  3138                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3139                                  
  3140 00001072 6A01                     push 1
  3141 00001074 FF36[2A00]               push word [asm_fd]
  3142 00001078 8D06[3600]               lea  ax, [DOS_ByteRead]
  3143 0000107C 50                       push ax
  3144 0000107D E8CC0F                   call readRL
  3145 00001080 83C406                   add  sp, 6
  3146 00001083 A3[3400]                 mov word [DOS_NoBytes], ax
  3147                                  
  3148                                  ;-18     return 1;}
  3149                                  
  3150 00001086 66B801000000             mov eax, 1
  3151 0000108C E90900                   jmp @@retn
  3152                                  
  3153                                  ;-19   return 0;
  3154                                  
  3155                                  @@ifEOL126:
  3156 0000108F 66B800000000             mov eax, 0
  3157 00001095 E90000                   jmp @@retn
  3158                                  
  3159                                  ;-20 }
  3160                                  
  3161                                  
  3162                                  ;-21 int skipBlank() {
  3163                                  
  3164 00001098 C9                      @@retn: LEAVE
  3165 00001099 C3                       ret
  3166                                  ; ENDP
  3167                                  
  3168                                  skipBlank:  ; *** PROC ***
  3169                                  
  3170                                  ;-22   skipblank1:
  3171                                  
  3172                                  @@skipblank1:
  3173                                  
  3174                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3175                                  
  3176 0000109A 8B1E[2800]               mov bx, [InputPtr]
  3177 0000109E 8A07                     mov al, [bx]
  3178 000010A0 B400                     mov ah, 0
  3179 000010A2 83F820                   cmp ax, 32
  3180 000010A5 0F850600                 jne @@skipBlank127
  3181 000010A9 FF06[2800]               inc  word [InputPtr]
  3182 000010AD EBEB                     jmp @@skipblank1
  3183                                  
  3184                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3185                                  
  3186                                  @@skipBlank127:
  3187 000010AF 8B1E[2800]               mov bx, [InputPtr]
  3188 000010B3 8A07                     mov al, [bx]
  3189 000010B5 B400                     mov ah, 0
  3190 000010B7 83F809                   cmp ax, 9
  3191 000010BA 0F850600                 jne @@skipBlank128
  3192 000010BE FF06[2800]               inc  word [InputPtr]
  3193 000010C2 EBD6                     jmp @@skipblank1
  3194                                  
  3195                                  ;-25 }
  3196                                  
  3197                                  @@skipBlank128:
  3198                                  
  3199                                  ;-26 int letterE(char c) {
  3200                                  
  3201 000010C4 C3                       ret
  3202                                  ; ENDP
  3203                                  
  3204                                  letterE:  ; *** PROC ***
  3205                                  
  3206                                  ;-27   if (c=='_') return 1;
  3207                                  
  3208                                  ;Function : letterE, Number of local variables: 1
  3209                                  ;   # type sign width line used address name   list of local variables
  3210                                  ;  200 var sign byte    26 NULL bp+4    c;
  3211 000010C5 C8000000                 ENTER  0,0
  3212 000010C9 8A4604                   mov al, [bp+4]
  3213 000010CC 3C5F                     cmp al, 95
  3214 000010CE 0F850900                 jne @@letterE129
  3215 000010D2 66B801000000             mov eax, 1
  3216 000010D8 E97E00                   jmp @@retn
  3217                                  
  3218                                  ;-28   if (c=='.') return 1;
  3219                                  
  3220                                  @@letterE129:
  3221 000010DB 8A4604                   mov al, [bp+4]
  3222 000010DE 3C2E                     cmp al, 46
  3223 000010E0 0F850900                 jne @@letterE130
  3224 000010E4 66B801000000             mov eax, 1
  3225 000010EA E96C00                   jmp @@retn
  3226                                  
  3227                                  ;-29   if (c=='?') return 1;
  3228                                  
  3229                                  @@letterE130:
  3230 000010ED 8A4604                   mov al, [bp+4]
  3231 000010F0 3C3F                     cmp al, 63
  3232 000010F2 0F850900                 jne @@letterE131
  3233 000010F6 66B801000000             mov eax, 1
  3234 000010FC E95A00                   jmp @@retn
  3235                                  
  3236                                  ;-30   if (c=='$') return 1;
  3237                                  
  3238                                  @@letterE131:
  3239 000010FF 8A4604                   mov al, [bp+4]
  3240 00001102 3C24                     cmp al, 36
  3241 00001104 0F850900                 jne @@letterE132
  3242 00001108 66B801000000             mov eax, 1
  3243 0000110E E94800                   jmp @@retn
  3244                                  
  3245                                  ;-31   if (c> 'z') return 0;
  3246                                  
  3247                                  @@letterE132:
  3248 00001111 8A4604                   mov al, [bp+4]
  3249 00001114 3C7A                     cmp al, 122
  3250 00001116 0F8E0900                 jle @@letterE133
  3251 0000111A 66B800000000             mov eax, 0
  3252 00001120 E93600                   jmp @@retn
  3253                                  
  3254                                  ;-32   if (c< '@') return 0; // at included
  3255                                  
  3256                                  @@letterE133:
  3257 00001123 8A4604                   mov al, [bp+4]
  3258 00001126 3C40                     cmp al, 64
  3259 00001128 0F8D0900                 jge @@letterE134
  3260 0000112C 66B800000000             mov eax, 0
  3261 00001132 E92400                   jmp @@retn
  3262                                  
  3263                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3264                                  
  3265                                  @@letterE134:
  3266 00001135 8A4604                   mov al, [bp+4]
  3267 00001138 3C5A                     cmp al, 90
  3268 0000113A 0F8E1200                 jle @@letterE135
  3269 0000113E 8A4604                   mov al, [bp+4]
  3270 00001141 3C61                     cmp al, 97
  3271 00001143 0F8D0900                 jge @@letterE136
  3272 00001147 66B800000000             mov eax, 0
  3273 0000114D E90900                   jmp @@retn
  3274                                  @@letterE136:
  3275                                  
  3276                                  ;-34   return 1;
  3277                                  
  3278                                  @@letterE135:
  3279 00001150 66B801000000             mov eax, 1
  3280 00001156 E90000                   jmp @@retn
  3281                                  
  3282                                  ;-35 }
  3283                                  
  3284                                  
  3285                                  ;-36 int alnumE(char c) {
  3286                                  
  3287 00001159 C9                      @@retn: LEAVE
  3288 0000115A C3                       ret
  3289                                  ; ENDP
  3290                                  
  3291                                  alnumE:  ; *** PROC ***
  3292                                  
  3293                                  ;-37   if (digit(c)) return 1;
  3294                                  
  3295                                  ;Function : alnumE, Number of local variables: 1
  3296                                  ;   # type sign width line used address name   list of local variables
  3297                                  ;  200 var sign byte    36 NULL bp+4    c;
  3298 0000115B C8000000                 ENTER  0,0
  3299 0000115F 8A4604                   mov al, byte [bp+4]
  3300 00001162 B400                     mov ah, 0
  3301 00001164 50                       push ax
  3302 00001165 E8160E                   call digit
  3303 00001168 83C402                   add  sp, 2
  3304 0000116B 08C0                     or  al, al
  3305 0000116D 0F840900                 je @@alnumE137
  3306 00001171 66B801000000             mov eax, 1
  3307 00001177 E92400                   jmp @@retn
  3308                                  
  3309                                  ;-38   if (letterE(c)) return 1;
  3310                                  
  3311                                  @@alnumE137:
  3312 0000117A 8A4604                   mov al, byte [bp+4]
  3313 0000117D B400                     mov ah, 0
  3314 0000117F 50                       push ax
  3315 00001180 E842FF                   call letterE
  3316 00001183 83C402                   add  sp, 2
  3317 00001186 08C0                     or  al, al
  3318 00001188 0F840900                 je @@alnumE138
  3319 0000118C 66B801000000             mov eax, 1
  3320 00001192 E90900                   jmp @@retn
  3321                                  
  3322                                  ;-39   return 0;
  3323                                  
  3324                                  @@alnumE138:
  3325 00001195 66B800000000             mov eax, 0
  3326 0000119B E90000                   jmp @@retn
  3327                                  
  3328                                  ;-40 }
  3329                                  
  3330                                  
  3331                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3332                                  
  3333 0000119E C9                      @@retn: LEAVE
  3334 0000119F C3                       ret
  3335                                  ; ENDP
  3336                                  
  3337                                  getDigit:  ; *** PROC ***
  3338                                  
  3339                                  ;-42   unsigned int CastInt;
  3340                                  
  3341                                  
  3342                                  ;-43   SymbolInt=0;
  3343                                  
  3344                                  ;Function : getDigit, Number of local variables: 2
  3345                                  ;   # type sign width line used address name   list of local variables
  3346                                  ;  200 var unsg byte    41 NULL bp+4    c
  3347                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3348 000011A0 C8020000                 ENTER  2,0
  3349 000011A4 66B800000000             mov eax, 0
  3350 000011AA A3[2600]                 mov word [SymbolInt], ax
  3351                                  
  3352                                  ;-44   do {
  3353                                  
  3354                                  @@getDigit139:
  3355                                  
  3356                                  ;-45     c-='0';
  3357                                  
  3358 000011AD 806E0430                 sub  byte [bp+4], 48
  3359                                  
  3360                                  ;-46     SymbolInt=SymbolInt*10;
  3361                                  
  3362 000011B1 A1[2600]                 mov ax, [SymbolInt]
  3363 000011B4 66BB0A000000             mov ebx, 10
  3364 000011BA 66F7E3                   mul ebx
  3365 000011BD A3[2600]                 mov word [SymbolInt], ax
  3366                                  
  3367                                  ;-47     ax=0; CastInt=c; //cast b2w
  3368                                  
  3369 000011C0 B80000                   mov  ax, 0
  3370 000011C3 8A4604                   mov al, [bp+4]
  3371 000011C6 8946FE                   mov word [bp-2], ax
  3372                                  
  3373                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3374                                  
  3375 000011C9 A1[2600]                 mov ax, [SymbolInt]
  3376 000011CC 0346FE                   add ax, [bp-2]
  3377 000011CF A3[2600]                 mov word [SymbolInt], ax
  3378                                  
  3379                                  ;-49     InputPtr++;
  3380                                  
  3381 000011D2 FF06[2800]               inc  word [InputPtr]
  3382                                  
  3383                                  ;-50     c = *InputPtr;
  3384                                  
  3385 000011D6 8B1E[2800]               mov bx, [InputPtr]
  3386 000011DA 8A07                     mov al, [bx]
  3387 000011DC B400                     mov ah, 0
  3388 000011DE 884604                   mov byte [bp+4], al
  3389                                  
  3390                                  ;-51   } while(digit(c));
  3391                                  
  3392 000011E1 8A4604                   mov al, byte [bp+4]
  3393 000011E4 B400                     mov ah, 0
  3394 000011E6 50                       push ax
  3395 000011E7 E8940D                   call digit
  3396 000011EA 83C402                   add  sp, 2
  3397 000011ED 08C0                     or  al, al
  3398 000011EF 0F840200                 je @@getDigit140
  3399 000011F3 EBB8                     jmp @@getDigit139
  3400                                  @@getDigit140:
  3401                                  
  3402                                  ;-52 }
  3403                                  
  3404                                  
  3405                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3406 000011F5 C9                       LEAVE
  3407 000011F6 C3                       ret
  3408                                  ; ENDP
  3409                                  
  3410                                  getName:  ; *** PROC ***
  3411                                  
  3412                                  ;-54   char *p;
  3413                                  
  3414                                  
  3415                                  ;-55   p = &Symbol;
  3416                                  
  3417                                  ;Function : getName, Number of local variables: 2
  3418                                  ;   # type sign width line used address name   list of local variables
  3419                                  ;  200 var unsg byte    53 NULL bp+4    c
  3420                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3421 000011F7 C8020000                 ENTER  2,0
  3422 000011FB B83075                   mov ax, Symbol
  3423 000011FE 8946FE                   mov word [bp-2], ax
  3424                                  
  3425                                  ;-56   *p = c;
  3426                                  
  3427 00001201 8A4604                   mov al, [bp+4]
  3428 00001204 8B5EFE                   mov  bx, [bp-2]
  3429 00001207 8807                     mov  [bx], al
  3430                                  
  3431                                  ;-57   p++;
  3432                                  
  3433 00001209 FF46FE                   inc  word [bp-2]
  3434                                  
  3435                                  ;-58   while (alnumE(c)) {
  3436                                  
  3437                                  @@getName141:
  3438 0000120C 8A4604                   mov al, byte [bp+4]
  3439 0000120F B400                     mov ah, 0
  3440 00001211 50                       push ax
  3441 00001212 E846FF                   call alnumE
  3442 00001215 83C402                   add  sp, 2
  3443 00001218 08C0                     or  al, al
  3444 0000121A 0F841C00                 je @@getName142
  3445                                  
  3446                                  ;-59     InputPtr++;
  3447                                  
  3448 0000121E FF06[2800]               inc  word [InputPtr]
  3449                                  
  3450                                  ;-60     c = *InputPtr;
  3451                                  
  3452 00001222 8B1E[2800]               mov bx, [InputPtr]
  3453 00001226 8A07                     mov al, [bx]
  3454 00001228 B400                     mov ah, 0
  3455 0000122A 884604                   mov byte [bp+4], al
  3456                                  
  3457                                  ;-61     *p = c;
  3458                                  
  3459 0000122D 8A4604                   mov al, [bp+4]
  3460 00001230 8B5EFE                   mov  bx, [bp-2]
  3461 00001233 8807                     mov  [bx], al
  3462                                  
  3463                                  ;-62     p++;
  3464                                  
  3465 00001235 FF46FE                   inc  word [bp-2]
  3466                                  
  3467                                  ;-63   }
  3468                                  
  3469                                  
  3470                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3471                                  
  3472 00001238 EBD2                     jmp @@getName141
  3473                                  @@getName142:
  3474 0000123A 8A4604                   mov al, [bp+4]
  3475 0000123D 3C3A                     cmp al, 58
  3476 0000123F 0F850C00                 jne @@getName143
  3477 00001243 66B801000000             mov eax, 1
  3478 00001249 A2[3B00]                 mov byte [isLabel], al
  3479 0000124C E90900                   jmp @@getName144
  3480                                  @@getName143:
  3481 0000124F 66B800000000             mov eax, 0
  3482 00001255 A2[3B00]                 mov byte [isLabel], al
  3483                                  
  3484                                  ;-65   p--;
  3485                                  
  3486                                  @@getName144:
  3487 00001258 FF4EFE                   dec  word [bp-2]
  3488                                  
  3489                                  ;-66   *p = 0;
  3490                                  
  3491 0000125B 66B800000000             mov eax, 0
  3492 00001261 8B5EFE                   mov  bx, [bp-2]
  3493 00001264 8807                     mov  [bx], al
  3494                                  
  3495                                  ;-67   strcpy(SymbolUpper, Symbol);
  3496                                  
  3497 00001266 8D063075                 lea  ax, [Symbol]
  3498 0000126A 50                       push ax
  3499 0000126B 8D064F75                 lea  ax, [SymbolUpper]
  3500 0000126F 50                       push ax
  3501 00001270 E8D20C                   call strcpy
  3502 00001273 83C404                   add  sp, 4
  3503                                  
  3504                                  ;-68   toupper(SymbolUpper);
  3505                                  
  3506 00001276 8D064F75                 lea  ax, [SymbolUpper]
  3507 0000127A 50                       push ax
  3508 0000127B E8590C                   call toupper
  3509 0000127E 83C402                   add  sp, 2
  3510                                  
  3511                                  ;-69 }
  3512                                  
  3513                                  
  3514                                  ;-70 int testReg() {
  3515 00001281 C9                       LEAVE
  3516 00001282 C3                       ret
  3517                                  ; ENDP
  3518                                  
  3519                                  testReg:  ; *** PROC ***
  3520                                  
  3521                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3522                                  
  3523                                  
  3524                                  ;-72   RegType=0;
  3525                                  
  3526 00001283 66B800000000             mov eax, 0
  3527 00001289 A2[3F00]                 mov byte [RegType], al
  3528                                  
  3529                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3530                                  
  3531 0000128C 8D063075                 lea  ax, [Symbol]
  3532 00001290 50                       push ax
  3533 00001291 E8860C                   call strlen
  3534 00001294 83C402                   add  sp, 2
  3535 00001297 3C02                     cmp al, 2
  3536 00001299 0F8D0900                 jge @@testReg145
  3537 0000129D 66B800000000             mov eax, 0
  3538 000012A3 E9B603                   jmp @@retn
  3539                                  
  3540                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3541                                  
  3542                                  @@testReg145:
  3543 000012A6 8D063075                 lea  ax, [Symbol]
  3544 000012AA 50                       push ax
  3545 000012AB E86C0C                   call strlen
  3546 000012AE 83C402                   add  sp, 2
  3547 000012B1 3C03                     cmp al, 3
  3548 000012B3 0F8E0900                 jle @@testReg146
  3549 000012B7 66B800000000             mov eax, 0
  3550 000012BD E99C03                   jmp @@retn
  3551                                  
  3552                                  ;-75   RegType=BYTE;
  3553                                  
  3554                                  @@testReg146:
  3555 000012C0 66B801000000             mov eax, 1
  3556 000012C6 A2[3F00]                 mov byte [RegType], al
  3557                                  
  3558                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3559                                  
  3560 000012C9 68[5D16]                 push testReg_0
  3561 000012CC 8D064F75                 lea  ax, [SymbolUpper]
  3562 000012D0 50                       push ax
  3563 000012D1 E8DD0C                   call eqstr
  3564 000012D4 83C404                   add  sp, 4
  3565 000012D7 08C0                     or  al, al
  3566 000012D9 0F840900                 je @@testReg147
  3567 000012DD 66B800000000             mov eax, 0
  3568 000012E3 E97603                   jmp @@retn
  3569                                  
  3570                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3571                                  
  3572                                  @@testReg147:
  3573 000012E6 68[6016]                 push testReg_1
  3574 000012E9 8D064F75                 lea  ax, [SymbolUpper]
  3575 000012ED 50                       push ax
  3576 000012EE E8C00C                   call eqstr
  3577 000012F1 83C404                   add  sp, 4
  3578 000012F4 08C0                     or  al, al
  3579 000012F6 0F840900                 je @@testReg148
  3580 000012FA 66B801000000             mov eax, 1
  3581 00001300 E95903                   jmp @@retn
  3582                                  
  3583                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3584                                  
  3585                                  @@testReg148:
  3586 00001303 68[6316]                 push testReg_2
  3587 00001306 8D064F75                 lea  ax, [SymbolUpper]
  3588 0000130A 50                       push ax
  3589 0000130B E8A30C                   call eqstr
  3590 0000130E 83C404                   add  sp, 4
  3591 00001311 08C0                     or  al, al
  3592 00001313 0F840900                 je @@testReg149
  3593 00001317 66B802000000             mov eax, 2
  3594 0000131D E93C03                   jmp @@retn
  3595                                  
  3596                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3597                                  
  3598                                  @@testReg149:
  3599 00001320 68[6616]                 push testReg_3
  3600 00001323 8D064F75                 lea  ax, [SymbolUpper]
  3601 00001327 50                       push ax
  3602 00001328 E8860C                   call eqstr
  3603 0000132B 83C404                   add  sp, 4
  3604 0000132E 08C0                     or  al, al
  3605 00001330 0F840900                 je @@testReg150
  3606 00001334 66B803000000             mov eax, 3
  3607 0000133A E91F03                   jmp @@retn
  3608                                  
  3609                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3610                                  
  3611                                  @@testReg150:
  3612 0000133D 68[6916]                 push testReg_4
  3613 00001340 8D064F75                 lea  ax, [SymbolUpper]
  3614 00001344 50                       push ax
  3615 00001345 E8690C                   call eqstr
  3616 00001348 83C404                   add  sp, 4
  3617 0000134B 08C0                     or  al, al
  3618 0000134D 0F840900                 je @@testReg151
  3619 00001351 66B804000000             mov eax, 4
  3620 00001357 E90203                   jmp @@retn
  3621                                  
  3622                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3623                                  
  3624                                  @@testReg151:
  3625 0000135A 68[6C16]                 push testReg_5
  3626 0000135D 8D064F75                 lea  ax, [SymbolUpper]
  3627 00001361 50                       push ax
  3628 00001362 E84C0C                   call eqstr
  3629 00001365 83C404                   add  sp, 4
  3630 00001368 08C0                     or  al, al
  3631 0000136A 0F840900                 je @@testReg152
  3632 0000136E 66B805000000             mov eax, 5
  3633 00001374 E9E502                   jmp @@retn
  3634                                  
  3635                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3636                                  
  3637                                  @@testReg152:
  3638 00001377 68[6F16]                 push testReg_6
  3639 0000137A 8D064F75                 lea  ax, [SymbolUpper]
  3640 0000137E 50                       push ax
  3641 0000137F E82F0C                   call eqstr
  3642 00001382 83C404                   add  sp, 4
  3643 00001385 08C0                     or  al, al
  3644 00001387 0F840900                 je @@testReg153
  3645 0000138B 66B806000000             mov eax, 6
  3646 00001391 E9C802                   jmp @@retn
  3647                                  
  3648                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3649                                  
  3650                                  @@testReg153:
  3651 00001394 68[7216]                 push testReg_7
  3652 00001397 8D064F75                 lea  ax, [SymbolUpper]
  3653 0000139B 50                       push ax
  3654 0000139C E8120C                   call eqstr
  3655 0000139F 83C404                   add  sp, 4
  3656 000013A2 08C0                     or  al, al
  3657 000013A4 0F840900                 je @@testReg154
  3658 000013A8 66B807000000             mov eax, 7
  3659 000013AE E9AB02                   jmp @@retn
  3660                                  
  3661                                  ;-84   RegType=WORD;
  3662                                  
  3663                                  @@testReg154:
  3664 000013B1 66B802000000             mov eax, 2
  3665 000013B7 A2[3F00]                 mov byte [RegType], al
  3666                                  
  3667                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3668                                  
  3669 000013BA 68[7516]                 push testReg_8
  3670 000013BD 8D064F75                 lea  ax, [SymbolUpper]
  3671 000013C1 50                       push ax
  3672 000013C2 E8EC0B                   call eqstr
  3673 000013C5 83C404                   add  sp, 4
  3674 000013C8 08C0                     or  al, al
  3675 000013CA 0F840900                 je @@testReg155
  3676 000013CE 66B800000000             mov eax, 0
  3677 000013D4 E98502                   jmp @@retn
  3678                                  
  3679                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3680                                  
  3681                                  @@testReg155:
  3682 000013D7 68[7816]                 push testReg_9
  3683 000013DA 8D064F75                 lea  ax, [SymbolUpper]
  3684 000013DE 50                       push ax
  3685 000013DF E8CF0B                   call eqstr
  3686 000013E2 83C404                   add  sp, 4
  3687 000013E5 08C0                     or  al, al
  3688 000013E7 0F840900                 je @@testReg156
  3689 000013EB 66B801000000             mov eax, 1
  3690 000013F1 E96802                   jmp @@retn
  3691                                  
  3692                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3693                                  
  3694                                  @@testReg156:
  3695 000013F4 68[7B16]                 push testReg_10
  3696 000013F7 8D064F75                 lea  ax, [SymbolUpper]
  3697 000013FB 50                       push ax
  3698 000013FC E8B20B                   call eqstr
  3699 000013FF 83C404                   add  sp, 4
  3700 00001402 08C0                     or  al, al
  3701 00001404 0F840900                 je @@testReg157
  3702 00001408 66B802000000             mov eax, 2
  3703 0000140E E94B02                   jmp @@retn
  3704                                  
  3705                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3706                                  
  3707                                  @@testReg157:
  3708 00001411 68[7E16]                 push testReg_11
  3709 00001414 8D064F75                 lea  ax, [SymbolUpper]
  3710 00001418 50                       push ax
  3711 00001419 E8950B                   call eqstr
  3712 0000141C 83C404                   add  sp, 4
  3713 0000141F 08C0                     or  al, al
  3714 00001421 0F840900                 je @@testReg158
  3715 00001425 66B803000000             mov eax, 3
  3716 0000142B E92E02                   jmp @@retn
  3717                                  
  3718                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3719                                  
  3720                                  @@testReg158:
  3721 0000142E 68[8116]                 push testReg_12
  3722 00001431 8D064F75                 lea  ax, [SymbolUpper]
  3723 00001435 50                       push ax
  3724 00001436 E8780B                   call eqstr
  3725 00001439 83C404                   add  sp, 4
  3726 0000143C 08C0                     or  al, al
  3727 0000143E 0F840900                 je @@testReg159
  3728 00001442 66B804000000             mov eax, 4
  3729 00001448 E91102                   jmp @@retn
  3730                                  
  3731                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3732                                  
  3733                                  @@testReg159:
  3734 0000144B 68[8416]                 push testReg_13
  3735 0000144E 8D064F75                 lea  ax, [SymbolUpper]
  3736 00001452 50                       push ax
  3737 00001453 E85B0B                   call eqstr
  3738 00001456 83C404                   add  sp, 4
  3739 00001459 08C0                     or  al, al
  3740 0000145B 0F840900                 je @@testReg160
  3741 0000145F 66B805000000             mov eax, 5
  3742 00001465 E9F401                   jmp @@retn
  3743                                  
  3744                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3745                                  
  3746                                  @@testReg160:
  3747 00001468 68[8716]                 push testReg_14
  3748 0000146B 8D064F75                 lea  ax, [SymbolUpper]
  3749 0000146F 50                       push ax
  3750 00001470 E83E0B                   call eqstr
  3751 00001473 83C404                   add  sp, 4
  3752 00001476 08C0                     or  al, al
  3753 00001478 0F840900                 je @@testReg161
  3754 0000147C 66B806000000             mov eax, 6
  3755 00001482 E9D701                   jmp @@retn
  3756                                  
  3757                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3758                                  
  3759                                  @@testReg161:
  3760 00001485 68[8A16]                 push testReg_15
  3761 00001488 8D064F75                 lea  ax, [SymbolUpper]
  3762 0000148C 50                       push ax
  3763 0000148D E8210B                   call eqstr
  3764 00001490 83C404                   add  sp, 4
  3765 00001493 08C0                     or  al, al
  3766 00001495 0F840900                 je @@testReg162
  3767 00001499 66B807000000             mov eax, 7
  3768 0000149F E9BA01                   jmp @@retn
  3769                                  
  3770                                  ;-93   RegType=SEGREG;
  3771                                  
  3772                                  @@testReg162:
  3773 000014A2 66B804000000             mov eax, 4
  3774 000014A8 A2[3F00]                 mov byte [RegType], al
  3775                                  
  3776                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3777                                  
  3778 000014AB 68[8D16]                 push testReg_16
  3779 000014AE 8D064F75                 lea  ax, [SymbolUpper]
  3780 000014B2 50                       push ax
  3781 000014B3 E8FB0A                   call eqstr
  3782 000014B6 83C404                   add  sp, 4
  3783 000014B9 08C0                     or  al, al
  3784 000014BB 0F840900                 je @@testReg163
  3785 000014BF 66B800000000             mov eax, 0
  3786 000014C5 E99401                   jmp @@retn
  3787                                  
  3788                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3789                                  
  3790                                  @@testReg163:
  3791 000014C8 68[9016]                 push testReg_17
  3792 000014CB 8D064F75                 lea  ax, [SymbolUpper]
  3793 000014CF 50                       push ax
  3794 000014D0 E8DE0A                   call eqstr
  3795 000014D3 83C404                   add  sp, 4
  3796 000014D6 08C0                     or  al, al
  3797 000014D8 0F840900                 je @@testReg164
  3798 000014DC 66B801000000             mov eax, 1
  3799 000014E2 E97701                   jmp @@retn
  3800                                  
  3801                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3802                                  
  3803                                  @@testReg164:
  3804 000014E5 68[9316]                 push testReg_18
  3805 000014E8 8D064F75                 lea  ax, [SymbolUpper]
  3806 000014EC 50                       push ax
  3807 000014ED E8C10A                   call eqstr
  3808 000014F0 83C404                   add  sp, 4
  3809 000014F3 08C0                     or  al, al
  3810 000014F5 0F840900                 je @@testReg165
  3811 000014F9 66B802000000             mov eax, 2
  3812 000014FF E95A01                   jmp @@retn
  3813                                  
  3814                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3815                                  
  3816                                  @@testReg165:
  3817 00001502 68[9616]                 push testReg_19
  3818 00001505 8D064F75                 lea  ax, [SymbolUpper]
  3819 00001509 50                       push ax
  3820 0000150A E8A40A                   call eqstr
  3821 0000150D 83C404                   add  sp, 4
  3822 00001510 08C0                     or  al, al
  3823 00001512 0F840900                 je @@testReg166
  3824 00001516 66B803000000             mov eax, 3
  3825 0000151C E93D01                   jmp @@retn
  3826                                  
  3827                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3828                                  
  3829                                  @@testReg166:
  3830 0000151F 68[9916]                 push testReg_20
  3831 00001522 8D064F75                 lea  ax, [SymbolUpper]
  3832 00001526 50                       push ax
  3833 00001527 E8870A                   call eqstr
  3834 0000152A 83C404                   add  sp, 4
  3835 0000152D 08C0                     or  al, al
  3836 0000152F 0F840900                 je @@testReg167
  3837 00001533 66B804000000             mov eax, 4
  3838 00001539 E92001                   jmp @@retn
  3839                                  
  3840                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3841                                  
  3842                                  @@testReg167:
  3843 0000153C 68[9C16]                 push testReg_21
  3844 0000153F 8D064F75                 lea  ax, [SymbolUpper]
  3845 00001543 50                       push ax
  3846 00001544 E86A0A                   call eqstr
  3847 00001547 83C404                   add  sp, 4
  3848 0000154A 08C0                     or  al, al
  3849 0000154C 0F840900                 je @@testReg168
  3850 00001550 66B805000000             mov eax, 5
  3851 00001556 E90301                   jmp @@retn
  3852                                  
  3853                                  ;-100   RegType=DWORD;
  3854                                  
  3855                                  @@testReg168:
  3856 00001559 66B803000000             mov eax, 3
  3857 0000155F A2[3F00]                 mov byte [RegType], al
  3858                                  
  3859                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3860                                  
  3861 00001562 68[9F16]                 push testReg_22
  3862 00001565 8D064F75                 lea  ax, [SymbolUpper]
  3863 00001569 50                       push ax
  3864 0000156A E8440A                   call eqstr
  3865 0000156D 83C404                   add  sp, 4
  3866 00001570 08C0                     or  al, al
  3867 00001572 0F840900                 je @@testReg169
  3868 00001576 66B800000000             mov eax, 0
  3869 0000157C E9DD00                   jmp @@retn
  3870                                  
  3871                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3872                                  
  3873                                  @@testReg169:
  3874 0000157F 68[A316]                 push testReg_23
  3875 00001582 8D064F75                 lea  ax, [SymbolUpper]
  3876 00001586 50                       push ax
  3877 00001587 E8270A                   call eqstr
  3878 0000158A 83C404                   add  sp, 4
  3879 0000158D 08C0                     or  al, al
  3880 0000158F 0F840900                 je @@testReg170
  3881 00001593 66B801000000             mov eax, 1
  3882 00001599 E9C000                   jmp @@retn
  3883                                  
  3884                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3885                                  
  3886                                  @@testReg170:
  3887 0000159C 68[A716]                 push testReg_24
  3888 0000159F 8D064F75                 lea  ax, [SymbolUpper]
  3889 000015A3 50                       push ax
  3890 000015A4 E80A0A                   call eqstr
  3891 000015A7 83C404                   add  sp, 4
  3892 000015AA 08C0                     or  al, al
  3893 000015AC 0F840900                 je @@testReg171
  3894 000015B0 66B802000000             mov eax, 2
  3895 000015B6 E9A300                   jmp @@retn
  3896                                  
  3897                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3898                                  
  3899                                  @@testReg171:
  3900 000015B9 68[AB16]                 push testReg_25
  3901 000015BC 8D064F75                 lea  ax, [SymbolUpper]
  3902 000015C0 50                       push ax
  3903 000015C1 E8ED09                   call eqstr
  3904 000015C4 83C404                   add  sp, 4
  3905 000015C7 08C0                     or  al, al
  3906 000015C9 0F840900                 je @@testReg172
  3907 000015CD 66B803000000             mov eax, 3
  3908 000015D3 E98600                   jmp @@retn
  3909                                  
  3910                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3911                                  
  3912                                  @@testReg172:
  3913 000015D6 68[AF16]                 push testReg_26
  3914 000015D9 8D064F75                 lea  ax, [SymbolUpper]
  3915 000015DD 50                       push ax
  3916 000015DE E8D009                   call eqstr
  3917 000015E1 83C404                   add  sp, 4
  3918 000015E4 08C0                     or  al, al
  3919 000015E6 0F840900                 je @@testReg173
  3920 000015EA 66B804000000             mov eax, 4
  3921 000015F0 E96900                   jmp @@retn
  3922                                  
  3923                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3924                                  
  3925                                  @@testReg173:
  3926 000015F3 68[B316]                 push testReg_27
  3927 000015F6 8D064F75                 lea  ax, [SymbolUpper]
  3928 000015FA 50                       push ax
  3929 000015FB E8B309                   call eqstr
  3930 000015FE 83C404                   add  sp, 4
  3931 00001601 08C0                     or  al, al
  3932 00001603 0F840900                 je @@testReg174
  3933 00001607 66B805000000             mov eax, 5
  3934 0000160D E94C00                   jmp @@retn
  3935                                  
  3936                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3937                                  
  3938                                  @@testReg174:
  3939 00001610 68[B716]                 push testReg_28
  3940 00001613 8D064F75                 lea  ax, [SymbolUpper]
  3941 00001617 50                       push ax
  3942 00001618 E89609                   call eqstr
  3943 0000161B 83C404                   add  sp, 4
  3944 0000161E 08C0                     or  al, al
  3945 00001620 0F840900                 je @@testReg175
  3946 00001624 66B806000000             mov eax, 6
  3947 0000162A E92F00                   jmp @@retn
  3948                                  
  3949                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3950                                  
  3951                                  @@testReg175:
  3952 0000162D 68[BB16]                 push testReg_29
  3953 00001630 8D064F75                 lea  ax, [SymbolUpper]
  3954 00001634 50                       push ax
  3955 00001635 E87909                   call eqstr
  3956 00001638 83C404                   add  sp, 4
  3957 0000163B 08C0                     or  al, al
  3958 0000163D 0F840900                 je @@testReg176
  3959 00001641 66B807000000             mov eax, 7
  3960 00001647 E91200                   jmp @@retn
  3961                                  
  3962                                  ;-109   RegType=0; return 0;
  3963                                  
  3964                                  @@testReg176:
  3965 0000164A 66B800000000             mov eax, 0
  3966 00001650 A2[3F00]                 mov byte [RegType], al
  3967 00001653 66B800000000             mov eax, 0
  3968 00001659 E90000                   jmp @@retn
  3969                                  
  3970                                  ;-110 }
  3971                                  
  3972                                  @@retn:
  3973 0000165C C3                       ret
  3974                                  ; ENDP
  3975 0000165D 414C00                  testReg_0 db "AL",0
  3976 00001660 434C00                  testReg_1 db "CL",0
  3977 00001663 444C00                  testReg_2 db "DL",0
  3978 00001666 424C00                  testReg_3 db "BL",0
  3979 00001669 414800                  testReg_4 db "AH",0
  3980 0000166C 434800                  testReg_5 db "CH",0
  3981 0000166F 444800                  testReg_6 db "DH",0
  3982 00001672 424800                  testReg_7 db "BH",0
  3983 00001675 415800                  testReg_8 db "AX",0
  3984 00001678 435800                  testReg_9 db "CX",0
  3985 0000167B 445800                  testReg_10 db "DX",0
  3986 0000167E 425800                  testReg_11 db "BX",0
  3987 00001681 535000                  testReg_12 db "SP",0
  3988 00001684 425000                  testReg_13 db "BP",0
  3989 00001687 534900                  testReg_14 db "SI",0
  3990 0000168A 444900                  testReg_15 db "DI",0
  3991 0000168D 455300                  testReg_16 db "ES",0
  3992 00001690 435300                  testReg_17 db "CS",0
  3993 00001693 535300                  testReg_18 db "SS",0
  3994 00001696 445300                  testReg_19 db "DS",0
  3995 00001699 465300                  testReg_20 db "FS",0
  3996 0000169C 475300                  testReg_21 db "GS",0
  3997 0000169F 45415800                testReg_22 db "EAX",0
  3998 000016A3 45435800                testReg_23 db "ECX",0
  3999 000016A7 45445800                testReg_24 db "EDX",0
  4000 000016AB 45425800                testReg_25 db "EBX",0
  4001 000016AF 45535000                testReg_26 db "ESP",0
  4002 000016B3 45425000                testReg_27 db "EBP",0
  4003 000016B7 45534900                testReg_28 db "ESI",0
  4004 000016BB 45444900                testReg_29 db "EDI",0
  4005                                  ;Back to main program: AS.C
  4006                                  
  4007                                  ;-217 #include "OUTPUT.C"
  4008                                  
  4009                                  ;Use include file: OUTPUT.C
  4010                                  
  4011                                  ;-1 int printLine() { int i; char c;
  4012                                  
  4013                                  
  4014                                  printLine:  ; *** PROC ***
  4015                                  
  4016                                  ;-2   prs("\n"); printhex16(PCStart);
  4017                                  
  4018                                  ;Function : printLine, Number of local variables: 2
  4019                                  ;   # type sign width line used address name   list of local variables
  4020                                  ;  200 var sign word     1 NULL bp-2    i
  4021                                  ;  201 var sign byte     1 NULL bp-4    c;
  4022 000016BF C8040000                 ENTER  4,0
  4023 000016C3 68[5417]                 push printLine_0
  4024 000016C6 E80401                   call prs
  4025 000016C9 83C402                   add  sp, 2
  4026 000016CC FF36[3900]               push word [PCStart]
  4027 000016D0 E8EB01                   call printhex16
  4028 000016D3 83C402                   add  sp, 2
  4029                                  
  4030                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4031                                  
  4032 000016D6 A1[4800]                 mov ax, [OpPrintIndex]
  4033 000016D9 83F800                   cmp ax, 0
  4034 000016DC 0F850C00                 jne @@printLine177
  4035 000016E0 68[5717]                 push printLine_1
  4036 000016E3 E8E700                   call prs
  4037 000016E6 83C402                   add  sp, 2
  4038                                  
  4039                                  ;-4   else {
  4040                                  
  4041 000016E9 E95B00                   jmp @@printLine178
  4042                                  @@printLine177:
  4043                                  
  4044                                  ;-5     prc(PrintR);
  4045                                  
  4046 000016EC A0[4C00]                 mov al, byte [PrintR]
  4047 000016EF B400                     mov ah, 0
  4048 000016F1 50                       push ax
  4049 000016F2 E87700                   call prc
  4050 000016F5 83C402                   add  sp, 2
  4051                                  
  4052                                  ;-6     i=0;
  4053                                  
  4054 000016F8 66B800000000             mov eax, 0
  4055 000016FE 8946FE                   mov word [bp-2], ax
  4056                                  
  4057                                  ;-7     do {
  4058                                  
  4059                                  @@printLine179:
  4060                                  
  4061                                  ;-8       c=OpPos[i];
  4062                                  
  4063 00001701 8B5EFE                   mov bx, [bp-2]
  4064 00001704 8A87B676                 mov al, [OpPos + bx]
  4065 00001708 8846FC                   mov byte [bp-4], al
  4066                                  
  4067                                  ;-9       printhex8a(c); prc(' ');
  4068                                  
  4069 0000170B 8A46FC                   mov al, byte [bp-4]
  4070 0000170E B400                     mov ah, 0
  4071 00001710 50                       push ax
  4072 00001711 E85C01                   call printhex8a
  4073 00001714 83C402                   add  sp, 2
  4074 00001717 6A20                     push 32
  4075 00001719 E85000                   call prc
  4076 0000171C 83C402                   add  sp, 2
  4077                                  
  4078                                  ;-10       i++;
  4079                                  
  4080 0000171F FF46FE                   inc  word [bp-2]
  4081                                  
  4082                                  ;-11     } while(i < OpPrintIndex);
  4083                                  
  4084 00001722 8B46FE                   mov ax, [bp-2]
  4085 00001725 3B06[4800]               cmp ax, [OpPrintIndex]
  4086 00001729 0F8D0200                 jge @@printLine180
  4087 0000172D EBD2                     jmp @@printLine179
  4088                                  @@printLine180:
  4089                                  
  4090                                  ;-12     do {// fill rest with blank
  4091                                  
  4092                                  @@printLine181:
  4093                                  
  4094                                  ;-13       prs("   ");
  4095                                  
  4096 0000172F 68[6817]                 push printLine_2
  4097 00001732 E89800                   call prs
  4098 00001735 83C402                   add  sp, 2
  4099                                  
  4100                                  ;-14       i++;
  4101                                  
  4102 00001738 FF46FE                   inc  word [bp-2]
  4103                                  
  4104                                  ;-15     } while(i < OPMAXLEN);
  4105                                  
  4106 0000173B 8B46FE                   mov ax, [bp-2]
  4107 0000173E 83F805                   cmp ax, 5
  4108 00001741 0F8D0200                 jge @@printLine182
  4109 00001745 EBE8                     jmp @@printLine181
  4110                                  @@printLine182:
  4111                                  
  4112                                  ;-16   }
  4113                                  
  4114                                  
  4115                                  ;-17   prscomment(InputBuf);
  4116                                  
  4117                                  @@printLine178:
  4118 00001747 8D066E75                 lea  ax, [InputBuf]
  4119 0000174B 50                       push ax
  4120 0000174C E85000                   call prscomment
  4121 0000174F 83C402                   add  sp, 2
  4122                                  
  4123                                  ;-18 }
  4124                                  
  4125                                  
  4126                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4127 00001752 C9                       LEAVE
  4128 00001753 C3                       ret
  4129                                  ; ENDP
  4130 00001754 5C6E00                  printLine_0 db "\n",0
  4131 00001757 202020202020202020-     printLine_1 db "                ",0
  4132 00001760 2020202020202000   
  4133 00001768 20202000                printLine_2 db "   ",0
  4134                                  
  4135                                  prc:  ; *** PROC ***
  4136                                  ;Function : prc, Number of local variables: 1
  4137                                  ;   # type sign width line used address name   list of local variables
  4138                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4139 0000176C C8000000                 ENTER  0,0
  4140 00001770 A0[2500]                 mov al, [LIST]
  4141 00001773 08C0                     or  al, al
  4142 00001775 0F841400                 je @@prc183
  4143 00001779 807E040A                cmp byte [bp+4], 10
  4144 0000177D 0F850600                 jne @@prc184
  4145 00001781 B80D00                   mov  ax, 13
  4146 00001784 E81A07                   call writetty
  4147                                  
  4148                                  ;-20      al=c; writetty(); }
  4149                                  
  4150                                  @@prc184:
  4151 00001787 8A4604                   mov  al, [bp+4]
  4152 0000178A E81407                   call writetty
  4153                                  
  4154                                  ;-21    fputcR(c,lst_fd); }
  4155                                  
  4156                                  @@prc183:
  4157 0000178D FF36[2C00]               push word [lst_fd]
  4158 00001791 8A4604                   mov al, byte [bp+4]
  4159 00001794 B400                     mov ah, 0
  4160 00001796 50                       push ax
  4161 00001797 E8C708                   call fputcR
  4162 0000179A 83C404                   add  sp, 4
  4163                                  
  4164                                  ;-22 
  4165                                  
  4166                                  
  4167                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4168 0000179D C9                       LEAVE
  4169 0000179E C3                       ret
  4170                                  ; ENDP
  4171                                  
  4172                                  prscomment:  ; *** PROC ***
  4173                                  
  4174                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4175                                  
  4176                                  ;Function : prscomment, Number of local variables: 2
  4177                                  ;   # type sign width line used address name   list of local variables
  4178                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4179                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4180 0000179F C8020000                 ENTER  2,0
  4181                                  @@prscomment185:
  4182 000017A3 8B5E04                   mov bx, [bp+4]
  4183 000017A6 8A07                     mov al, [bx]
  4184 000017A8 B400                     mov ah, 0
  4185 000017AA 08C0                     or  al, al
  4186 000017AC 0F841B00                 je @@prscomment186
  4187 000017B0 8B5E04                   mov bx, [bp+4]
  4188 000017B3 8A07                     mov al, [bx]
  4189 000017B5 B400                     mov ah, 0
  4190 000017B7 8846FE                   mov byte [bp-2], al
  4191 000017BA 8A46FE                   mov al, byte [bp-2]
  4192 000017BD B400                     mov ah, 0
  4193 000017BF 50                       push ax
  4194 000017C0 E8A9FF                   call prc
  4195 000017C3 83C402                   add  sp, 2
  4196 000017C6 FF4604                   inc  word [bp+4]
  4197                                  
  4198                                  ;-25 }
  4199                                  
  4200 000017C9 EBD8                     jmp @@prscomment185
  4201                                  @@prscomment186:
  4202                                  
  4203                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4204 000017CB C9                       LEAVE
  4205 000017CC C3                       ret
  4206                                  ; ENDP
  4207                                  
  4208                                  prs:  ; *** PROC ***
  4209                                  ;Function : prs, Number of local variables: 3
  4210                                  ;   # type sign width line used address name   list of local variables
  4211                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4212                                  ;  201 var unsg byte    26 NULL bp-2    c
  4213                                  ;  202 var sign word    26 NULL bp-4    com;
  4214 000017CD C8040000                 ENTER  4,0
  4215 000017D1 66B800000000             mov eax, 0
  4216 000017D7 8946FC                   mov word [bp-4], ax
  4217                                  
  4218                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4219                                  
  4220                                  @@prs187:
  4221 000017DA 8B5E04                   mov bx, [bp+4]
  4222 000017DD 8A07                     mov al, [bx]
  4223 000017DF B400                     mov ah, 0
  4224 000017E1 08C0                     or  al, al
  4225 000017E3 0F848700                 je @@prs188
  4226 000017E7 8B5E04                   mov bx, [bp+4]
  4227 000017EA 8A07                     mov al, [bx]
  4228 000017EC B400                     mov ah, 0
  4229 000017EE 8846FE                   mov byte [bp-2], al
  4230 000017F1 8A46FE                   mov al, [bp-2]
  4231 000017F4 3C22                     cmp al, 34
  4232 000017F6 0F851E00                 jne @@prs189
  4233 000017FA 8B46FC                   mov ax, [bp-4]
  4234 000017FD 08C0                     or  al, al
  4235 000017FF 0F840C00                 je @@prs190
  4236 00001803 66B800000000             mov eax, 0
  4237 00001809 8946FC                   mov word [bp-4], ax
  4238 0000180C E90900                   jmp @@prs191
  4239                                  @@prs190:
  4240 0000180F 66B801000000             mov eax, 1
  4241 00001815 8946FC                   mov word [bp-4], ax
  4242                                  
  4243                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4244                                  
  4245                                  @@prs191:
  4246                                  @@prs189:
  4247 00001818 8A46FE                   mov al, [bp-2]
  4248 0000181B 3C5C                     cmp al, 92
  4249 0000181D 0F853B00                 jne @@prs192
  4250 00001821 8B46FC                   mov ax, [bp-4]
  4251 00001824 83F800                   cmp ax, 0
  4252 00001827 0F853100                 jne @@prs193
  4253 0000182B FF4604                   inc  word [bp+4]
  4254 0000182E 8B5E04                   mov bx, [bp+4]
  4255 00001831 8A07                     mov al, [bx]
  4256 00001833 B400                     mov ah, 0
  4257 00001835 8846FE                   mov byte [bp-2], al
  4258                                  
  4259                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4260                                  
  4261 00001838 8A46FE                   mov al, [bp-2]
  4262 0000183B 3C6E                     cmp al, 110
  4263 0000183D 0F850900                 jne @@prs194
  4264 00001841 66B80A000000             mov eax, 10
  4265 00001847 8846FE                   mov byte [bp-2], al
  4266                                  @@prs194:
  4267 0000184A 8A46FE                   mov al, [bp-2]
  4268 0000184D 3C74                     cmp al, 116
  4269 0000184F 0F850900                 jne @@prs195
  4270 00001853 66B809000000             mov eax, 9
  4271 00001859 8846FE                   mov byte [bp-2], al
  4272                                  @@prs195:
  4273                                  @@prs193:
  4274                                  @@prs192:
  4275 0000185C 8A46FE                   mov al, byte [bp-2]
  4276 0000185F B400                     mov ah, 0
  4277 00001861 50                       push ax
  4278 00001862 E807FF                   call prc
  4279 00001865 83C402                   add  sp, 2
  4280 00001868 FF4604                   inc  word [bp+4]
  4281                                  
  4282                                  ;-30 }
  4283                                  
  4284 0000186B E96CFF                   jmp @@prs187
  4285                                  @@prs188:
  4286                                  
  4287                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4288 0000186E C9                       LEAVE
  4289 0000186F C3                       ret
  4290                                  ; ENDP
  4291                                  
  4292                                  printhex8a:  ; *** PROC ***
  4293                                  
  4294                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4295                                  
  4296                                  ;Function : printhex8a, Number of local variables: 2
  4297                                  ;   # type sign width line used address name   list of local variables
  4298                                  ;  200 var unsg word    31 NULL bp+4    c
  4299                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4300 00001870 C8020000                 ENTER  2,0
  4301 00001874 8B4604                   mov ax, [bp+4]
  4302 00001877 C1E804                   shr ax, 4
  4303 0000187A 8946FE                   mov word [bp-2], ax
  4304 0000187D 8346FE30                 add  word [bp-2], 48
  4305 00001881 8B46FE                   mov ax, [bp-2]
  4306 00001884 83F839                   cmp ax, 57
  4307 00001887 0F8E0400                 jle @@printhex8a196
  4308 0000188B 8346FE07                 add  word [bp-2], 7
  4309                                  @@printhex8a196:
  4310 0000188F FF76FE                   push word [bp-2]
  4311 00001892 E8D7FE                   call prc
  4312 00001895 83C402                   add  sp, 2
  4313                                  
  4314                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4315                                  
  4316 00001898 8B4604                   mov ax, [bp+4]
  4317 0000189B 83E00F                   and ax, 15
  4318 0000189E 8946FE                   mov word [bp-2], ax
  4319 000018A1 8346FE30                 add  word [bp-2], 48
  4320 000018A5 8B46FE                   mov ax, [bp-2]
  4321 000018A8 83F839                   cmp ax, 57
  4322 000018AB 0F8E0400                 jle @@printhex8a197
  4323 000018AF 8346FE07                 add  word [bp-2], 7
  4324                                  @@printhex8a197:
  4325 000018B3 FF76FE                   push word [bp-2]
  4326 000018B6 E8B3FE                   call prc
  4327 000018B9 83C402                   add  sp, 2
  4328                                  
  4329                                  ;-34 }
  4330                                  
  4331                                  
  4332                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4333 000018BC C9                       LEAVE
  4334 000018BD C3                       ret
  4335                                  ; ENDP
  4336                                  
  4337                                  printhex16:  ; *** PROC ***
  4338                                  
  4339                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4340                                  
  4341                                  ;Function : printhex16, Number of local variables: 2
  4342                                  ;   # type sign width line used address name   list of local variables
  4343                                  ;  200 var unsg word    35 NULL bp+4    i
  4344                                  ;  201 var unsg word    35 NULL bp-2    half;
  4345 000018BE C8020000                 ENTER  2,0
  4346 000018C2 8B4604                   mov ax, [bp+4]
  4347 000018C5 C1E808                   shr ax, 8
  4348 000018C8 8946FE                   mov word [bp-2], ax
  4349 000018CB FF76FE                   push word [bp-2]
  4350 000018CE E89FFF                   call printhex8a
  4351 000018D1 83C402                   add  sp, 2
  4352 000018D4 8B4604                   mov ax, [bp+4]
  4353 000018D7 25FF00                   and ax, 255
  4354 000018DA 8946FE                   mov word [bp-2], ax
  4355 000018DD FF76FE                   push word [bp-2]
  4356 000018E0 E88DFF                   call printhex8a
  4357 000018E3 83C402                   add  sp, 2
  4358                                  
  4359                                  ;-37 }
  4360                                  
  4361                                  
  4362                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4363 000018E6 C9                       LEAVE
  4364 000018E7 C3                       ret
  4365                                  ; ENDP
  4366                                  
  4367                                  printIntU:  ; *** PROC ***
  4368                                  
  4369                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4370                                  
  4371                                  ;Function : printIntU, Number of local variables: 2
  4372                                  ;   # type sign width line used address name   list of local variables
  4373                                  ;  200 var unsg word    38 NULL bp+4    n
  4374                                  ;  201 var unsg word    38 NULL bp-2    e;
  4375 000018E8 C8020000                 ENTER  2,0
  4376 000018EC 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4377 000018F0 0F821700                 jb  @@printIntU198
  4378 000018F4 8B4604                   mov ax, [bp+4]
  4379 000018F7 BB0A00                   mov bx, 10
  4380 000018FA BA0000                   mov dx, 0
  4381 000018FD F7F3                     div bx
  4382 000018FF 8946FE                   mov word [bp-2], ax
  4383                                  
  4384                                  ;-40     printIntU(e); }
  4385                                  
  4386 00001902 FF76FE                   push word [bp-2]
  4387 00001905 E8E0FF                   call printIntU
  4388 00001908 83C402                   add  sp, 2
  4389                                  
  4390                                  ;-41     n = n % 10; //unsigned mod
  4391                                  
  4392                                  @@printIntU198:
  4393 0000190B 8B4604                   mov ax, [bp+4]
  4394 0000190E BB0A00                   mov bx, 10
  4395 00001911 BA0000                   mov dx, 0
  4396 00001914 F7F3                     div bx
  4397 00001916 89D0                     mov ax, dx
  4398 00001918 894604                   mov word [bp+4], ax
  4399                                  
  4400                                  ;-42     n += '0'; prc(n);
  4401                                  
  4402 0000191B 83460430                 add  word [bp+4], 48
  4403 0000191F FF7604                   push word [bp+4]
  4404 00001922 E847FE                   call prc
  4405 00001925 83C402                   add  sp, 2
  4406                                  
  4407                                  ;-43 }
  4408                                  
  4409                                  
  4410                                  ;-44 
  4411                                  
  4412                                  
  4413                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4414 00001928 C9                       LEAVE
  4415 00001929 C3                       ret
  4416                                  ; ENDP
  4417                                  
  4418                                  error1:  ; *** PROC ***
  4419                                  ;Function : error1, Number of local variables: 1
  4420                                  ;   # type sign width line used address name   list of local variables
  4421                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4422 0000192A C8000000                 ENTER  0,0
  4423 0000192E 66B801000000             mov eax, 1
  4424 00001934 A2[2500]                 mov byte [LIST], al
  4425 00001937 FF06[3200]               inc  word [ErrorCount]
  4426                                  
  4427                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4428                                  
  4429 0000193B 68[6319]                 push error1_0
  4430 0000193E E88CFE                   call prs
  4431 00001941 83C402                   add  sp, 2
  4432 00001944 FF7604                   push word [bp+4]
  4433 00001947 E883FE                   call prs
  4434 0000194A 83C402                   add  sp, 2
  4435                                  
  4436                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4437                                  
  4438 0000194D 68[7E19]                 push error1_1
  4439 00001950 E87AFE                   call prs
  4440 00001953 83C402                   add  sp, 2
  4441 00001956 8D063075                 lea  ax, [Symbol]
  4442 0000195A 50                       push ax
  4443 0000195B E86FFE                   call prs
  4444 0000195E 83C402                   add  sp, 2
  4445                                  
  4446                                  ;-48 int allowederror(){error1("not allowed here"); }
  4447 00001961 C9                       LEAVE
  4448 00001962 C3                       ret
  4449                                  ; ENDP
  4450 00001963 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4451 0000196C 6E657874206C696E65-
  4452 00001975 204552524F523A2000 
  4453 0000197E 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4454 00001987 2000               
  4455                                  
  4456                                  allowederror:  ; *** PROC ***
  4457 00001989 68[9319]                 push allowederror_0
  4458 0000198C E89BFF                   call error1
  4459 0000198F 83C402                   add  sp, 2
  4460                                  
  4461                                  ;-49 int implmerror(){error1("not implemented");}
  4462                                  
  4463 00001992 C3                       ret
  4464                                  ; ENDP
  4465 00001993 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4466 0000199C 6564206865726500   
  4467                                  
  4468                                  implmerror:  ; *** PROC ***
  4469 000019A4 68[AE19]                 push implmerror_0
  4470 000019A7 E880FF                   call error1
  4471 000019AA 83C402                   add  sp, 2
  4472                                  
  4473                                  ;-50 int indexerror (){error1("invalid index register");}
  4474                                  
  4475 000019AD C3                       ret
  4476                                  ; ENDP
  4477 000019AE 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4478 000019B7 6D656E74656400     
  4479                                  
  4480                                  indexerror:  ; *** PROC ***
  4481 000019BE 68[C819]                 push indexerror_0
  4482 000019C1 E866FF                   call error1
  4483 000019C4 83C402                   add  sp, 2
  4484                                  
  4485                                  ;-51 int numbererror(){error1("number expected");}
  4486                                  
  4487 000019C7 C3                       ret
  4488                                  ; ENDP
  4489 000019C8 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4490 000019D1 6E6465782072656769-
  4491 000019DA 7374657200         
  4492                                  
  4493                                  numbererror:  ; *** PROC ***
  4494 000019DF 68[E919]                 push numbererror_0
  4495 000019E2 E845FF                   call error1
  4496 000019E5 83C402                   add  sp, 2
  4497                                  
  4498                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4499                                  
  4500 000019E8 C3                       ret
  4501                                  ; ENDP
  4502 000019E9 6E756D626572206578-     numbererror_0 db "number expected",0
  4503 000019F2 70656374656400     
  4504                                  
  4505                                  regmemerror:  ; *** PROC ***
  4506 000019F9 68[031A]                 push regmemerror_0
  4507 000019FC E82BFF                   call error1
  4508 000019FF 83C402                   add  sp, 2
  4509                                  
  4510                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4511                                  
  4512 00001A02 C3                       ret
  4513                                  ; ENDP
  4514 00001A03 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4515 00001A0C 73746572206F72206D-
  4516 00001A15 656D6F727920616C6C-
  4517 00001A1E 6F77656400         
  4518                                  
  4519                                  segregerror:  ; *** PROC ***
  4520 00001A23 68[2D1A]                 push segregerror_0
  4521 00001A26 E801FF                   call error1
  4522 00001A29 83C402                   add  sp, 2
  4523                                  
  4524                                  ;-54 int syntaxerror(){error1("syntax");}
  4525                                  
  4526 00001A2C C3                       ret
  4527                                  ; ENDP
  4528 00001A2D 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4529 00001A36 65676973746572206E-
  4530 00001A3F 6F7420616C6C6F7765-
  4531 00001A48 6400               
  4532                                  
  4533                                  syntaxerror:  ; *** PROC ***
  4534 00001A4A 68[541A]                 push syntaxerror_0
  4535 00001A4D E8DAFE                   call error1
  4536 00001A50 83C402                   add  sp, 2
  4537                                  
  4538                                  ;-55 
  4539                                  
  4540                                  
  4541                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4542                                  
  4543 00001A53 C3                       ret
  4544                                  ; ENDP
  4545 00001A54 73796E74617800          syntaxerror_0 db "syntax",0
  4546                                  
  4547                                  errorexit:  ; *** PROC ***
  4548                                  ;Function : errorexit, Number of local variables: 1
  4549                                  ;   # type sign width line used address name   list of local variables
  4550                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4551 00001A5B C8000000                 ENTER  0,0
  4552 00001A5F FF7604                   push word [bp+4]
  4553 00001A62 E8C5FE                   call error1
  4554 00001A65 83C402                   add  sp, 2
  4555 00001A68 6A01                     push 1
  4556 00001A6A E80704                   call end1
  4557 00001A6D 83C402                   add  sp, 2
  4558                                  
  4559                                  ;-57 int addrexit(){errorexit("illegal address");}
  4560 00001A70 C9                       LEAVE
  4561 00001A71 C3                       ret
  4562                                  ; ENDP
  4563                                  
  4564                                  addrexit:  ; *** PROC ***
  4565 00001A72 68[7C1A]                 push addrexit_0
  4566 00001A75 E8E3FF                   call errorexit
  4567 00001A78 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4570                                  
  4571 00001A7B C3                       ret
  4572                                  ; ENDP
  4573 00001A7C 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4574 00001A85 64647265737300     
  4575                                  
  4576                                  internexit:  ; *** PROC ***
  4577 00001A8C 68[961A]                 push internexit_0
  4578 00001A8F E8C9FF                   call errorexit
  4579 00001A92 83C402                   add  sp, 2
  4580 00001A95 C3                       ret
  4581                                  ; ENDP
  4582 00001A96 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4583 00001A9F 6D70696C6572206572-
  4584 00001AA8 726F7200           
  4585                                  ;Back to main program: AS.C
  4586                                  
  4587                                  ;-218 #include "MAIN.C"
  4588                                  
  4589                                  ;Use include file: MAIN.C
  4590                                  
  4591                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4592                                  
  4593                                  
  4594                                  getarg:  ; *** PROC ***
  4595                                  
  4596                                  ;-2   arglen1=*arglen;
  4597                                  
  4598                                  ;Function : getarg, Number of local variables: 3
  4599                                  ;   # type sign width line used address name   list of local variables
  4600                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4601                                  ;  201 var sign word     1 NULL bp-4    i
  4602                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4603 00001AAC C8060000                 ENTER  6,0
  4604 00001AB0 8B1E[5500]               mov bx, [arglen]
  4605 00001AB4 8A07                     mov al, [bx]
  4606 00001AB6 B400                     mov ah, 0
  4607 00001AB8 8946FE                   mov word [bp-2], ax
  4608                                  
  4609                                  ;-3   if (arglen1==0) {
  4610                                  
  4611 00001ABB 8B46FE                   mov ax, [bp-2]
  4612 00001ABE 83F800                   cmp ax, 0
  4613 00001AC1 0F851C00                 jne @@getarg199
  4614                                  
  4615                                  ;-4     cputs(Version1);
  4616                                  
  4617 00001AC5 8D06[1000]               lea  ax, [Version1]
  4618 00001AC9 50                       push ax
  4619 00001ACA E8DC03                   call cputs
  4620 00001ACD 83C402                   add  sp, 2
  4621                                  
  4622                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4623                                  
  4624 00001AD0 68[711C]                 push getarg_0
  4625 00001AD3 E8D303                   call cputs
  4626 00001AD6 83C402                   add  sp, 2
  4627                                  
  4628                                  ;-6     exitR(3);
  4629                                  
  4630 00001AD9 6A03                     push 3
  4631 00001ADB E8A605                   call exitR
  4632 00001ADE 83C402                   add  sp, 2
  4633                                  
  4634                                  ;-7   }
  4635                                  
  4636                                  
  4637                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4638                                  
  4639                                  @@getarg199:
  4640 00001AE1 8B46FE                   mov ax, [bp-2]
  4641 00001AE4 058100                   add ax, 129
  4642 00001AE7 8946FC                   mov word [bp-4], ax
  4643 00001AEA 66B800000000             mov eax, 0
  4644 00001AF0 8B5EFC                   mov  bx, [bp-4]
  4645 00001AF3 8907                     mov  [bx], ax
  4646 00001AF5 FF4EFE                   dec  word [bp-2]
  4647                                  
  4648                                  ;-9   toupper(argv);
  4649                                  
  4650 00001AF8 FF36[5700]               push word [argv]
  4651 00001AFC E8D803                   call toupper
  4652 00001AFF 83C402                   add  sp, 2
  4653                                  
  4654                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4655                                  
  4656 00001B02 FF36[5700]               push word [argv]
  4657 00001B06 8D06ED75                 lea  ax, [namein]
  4658 00001B0A 50                       push ax
  4659 00001B0B E83704                   call strcpy
  4660 00001B0E 83C404                   add  sp, 4
  4661 00001B11 68[961C]                 push getarg_1
  4662 00001B14 8D06ED75                 lea  ax, [namein]
  4663 00001B18 50                       push ax
  4664 00001B19 E8EA04                   call strcat1
  4665 00001B1C 83C404                   add  sp, 4
  4666                                  
  4667                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4668                                  
  4669 00001B1F FF36[5700]               push word [argv]
  4670 00001B23 8D063076                 lea  ax, [namelst]
  4671 00001B27 50                       push ax
  4672 00001B28 E81A04                   call strcpy
  4673 00001B2B 83C404                   add  sp, 4
  4674 00001B2E 68[991C]                 push getarg_2
  4675 00001B31 8D063076                 lea  ax, [namelst]
  4676 00001B35 50                       push ax
  4677 00001B36 E8CD04                   call strcat1
  4678 00001B39 83C404                   add  sp, 4
  4679                                  
  4680                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4681                                  
  4682 00001B3C FF36[5700]               push word [argv]
  4683 00001B40 8D067376                 lea  ax, [namebin]
  4684 00001B44 50                       push ax
  4685 00001B45 E8FD03                   call strcpy
  4686 00001B48 83C404                   add  sp, 4
  4687 00001B4B 68[9E1C]                 push getarg_3
  4688 00001B4E 8D067376                 lea  ax, [namebin]
  4689 00001B52 50                       push ax
  4690 00001B53 E8B004                   call strcat1
  4691 00001B56 83C404                   add  sp, 4
  4692                                  
  4693                                  ;-13 
  4694                                  
  4695                                  
  4696                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4697                                  
  4698 00001B59 66B801000000             mov eax, 1
  4699 00001B5F A2[2500]                 mov byte [LIST], al
  4700 00001B62 66B800000000             mov eax, 0
  4701 00001B68 A3[3000]                 mov word [DOS_ERR], ax
  4702 00001B6B 66B800000000             mov eax, 0
  4703 00001B71 A3[3700]                 mov word [PC], ax
  4704 00001B74 66B800000000             mov eax, 0
  4705 00001B7A A3[3200]                 mov word [ErrorCount], ax
  4706                                  
  4707                                  ;-15   asm_fd=openR (namein);
  4708                                  
  4709 00001B7D 8D06ED75                 lea  ax, [namein]
  4710 00001B81 50                       push ax
  4711 00001B82 E8A604                   call openR
  4712 00001B85 83C402                   add  sp, 2
  4713 00001B88 A3[2A00]                 mov word [asm_fd], ax
  4714                                  
  4715                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4716                                  
  4717 00001B8B A1[3000]                 mov ax, [DOS_ERR]
  4718 00001B8E 08C0                     or  al, al
  4719 00001B90 0F841C00                 je @@getarg200
  4720 00001B94 68[A31C]                 push getarg_4
  4721 00001B97 E80F03                   call cputs
  4722 00001B9A 83C402                   add  sp, 2
  4723 00001B9D 8D06ED75                 lea  ax, [namein]
  4724 00001BA1 50                       push ax
  4725 00001BA2 E80403                   call cputs
  4726 00001BA5 83C402                   add  sp, 2
  4727 00001BA8 6A01                     push 1
  4728 00001BAA E8D704                   call exitR
  4729 00001BAD 83C402                   add  sp, 2
  4730                                  
  4731                                  ;-17   lst_fd=creatR(namelst);
  4732                                  
  4733                                  @@getarg200:
  4734 00001BB0 8D063076                 lea  ax, [namelst]
  4735 00001BB4 50                       push ax
  4736 00001BB5 E88204                   call creatR
  4737 00001BB8 83C402                   add  sp, 2
  4738 00001BBB A3[2C00]                 mov word [lst_fd], ax
  4739                                  
  4740                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4741                                  
  4742 00001BBE A1[3000]                 mov ax, [DOS_ERR]
  4743 00001BC1 08C0                     or  al, al
  4744 00001BC3 0F841C00                 je @@getarg201
  4745 00001BC7 68[B91C]                 push getarg_5
  4746 00001BCA E8DC02                   call cputs
  4747 00001BCD 83C402                   add  sp, 2
  4748 00001BD0 8D063076                 lea  ax, [namelst]
  4749 00001BD4 50                       push ax
  4750 00001BD5 E8D102                   call cputs
  4751 00001BD8 83C402                   add  sp, 2
  4752 00001BDB 6A02                     push 2
  4753 00001BDD E8A404                   call exitR
  4754 00001BE0 83C402                   add  sp, 2
  4755                                  
  4756                                  ;-19   bin_fd=creatR(namebin);
  4757                                  
  4758                                  @@getarg201:
  4759 00001BE3 8D067376                 lea  ax, [namebin]
  4760 00001BE7 50                       push ax
  4761 00001BE8 E84F04                   call creatR
  4762 00001BEB 83C402                   add  sp, 2
  4763 00001BEE A3[2E00]                 mov word [bin_fd], ax
  4764                                  
  4765                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4766                                  
  4767 00001BF1 A1[3000]                 mov ax, [DOS_ERR]
  4768 00001BF4 08C0                     or  al, al
  4769 00001BF6 0F841C00                 je @@getarg202
  4770 00001BFA 68[D01C]                 push getarg_6
  4771 00001BFD E8A902                   call cputs
  4772 00001C00 83C402                   add  sp, 2
  4773 00001C03 8D067376                 lea  ax, [namebin]
  4774 00001C07 50                       push ax
  4775 00001C08 E89E02                   call cputs
  4776 00001C0B 83C402                   add  sp, 2
  4777 00001C0E 6A02                     push 2
  4778 00001C10 E87104                   call exitR
  4779 00001C13 83C402                   add  sp, 2
  4780                                  
  4781                                  ;-21   prs(";");prs(Version1);
  4782                                  
  4783                                  @@getarg202:
  4784 00001C16 68[E61C]                 push getarg_7
  4785 00001C19 E8B1FB                   call prs
  4786 00001C1C 83C402                   add  sp, 2
  4787 00001C1F 8D06[1000]               lea  ax, [Version1]
  4788 00001C23 50                       push ax
  4789 00001C24 E8A6FB                   call prs
  4790 00001C27 83C402                   add  sp, 2
  4791                                  
  4792                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4793                                  
  4794 00001C2A 68[E81C]                 push getarg_8
  4795 00001C2D E89DFB                   call prs
  4796 00001C30 83C402                   add  sp, 2
  4797 00001C33 8D06ED75                 lea  ax, [namein]
  4798 00001C37 50                       push ax
  4799 00001C38 E892FB                   call prs
  4800 00001C3B 83C402                   add  sp, 2
  4801 00001C3E 68[F31C]                 push getarg_9
  4802 00001C41 E889FB                   call prs
  4803 00001C44 83C402                   add  sp, 2
  4804 00001C47 8D063076                 lea  ax, [namelst]
  4805 00001C4B 50                       push ax
  4806 00001C4C E87EFB                   call prs
  4807 00001C4F 83C402                   add  sp, 2
  4808                                  
  4809                                  ;-23   prs(", "); prs(namebin);
  4810                                  
  4811 00001C52 68[FE1C]                 push getarg_10
  4812 00001C55 E875FB                   call prs
  4813 00001C58 83C402                   add  sp, 2
  4814 00001C5B 8D067376                 lea  ax, [namebin]
  4815 00001C5F 50                       push ax
  4816 00001C60 E86AFB                   call prs
  4817 00001C63 83C402                   add  sp, 2
  4818                                  
  4819                                  ;-24   prs("\n");
  4820                                  
  4821 00001C66 68[011D]                 push getarg_11
  4822 00001C69 E861FB                   call prs
  4823 00001C6C 83C402                   add  sp, 2
  4824                                  
  4825                                  ;-25 }
  4826                                  
  4827                                  
  4828                                  ;-26 int epilog() { int i; int j; char c;
  4829 00001C6F C9                       LEAVE
  4830 00001C70 C3                       ret
  4831                                  ; ENDP
  4832 00001C71 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4833 00001C7A 41532E434F4D206669-
  4834 00001C83 6C656E616D65205B77-
  4835 00001C8C 2F6F202E535D203A20-
  4836 00001C95 00                 
  4837 00001C96 2E5300                  getarg_1 db ".S",0
  4838 00001C99 2E4C535400              getarg_2 db ".LST",0
  4839 00001C9E 2E434F4D00              getarg_3 db ".COM",0
  4840 00001CA3 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4841 00001CAC 6C65206D697373696E-
  4842 00001CB5 673A2000           
  4843 00001CB9 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4844 00001CC2 206E6F742063726561-
  4845 00001CCB 74653A2000         
  4846 00001CD0 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4847 00001CD9 6E6F74206372656174-
  4848 00001CE2 653A2000           
  4849 00001CE6 3B00                    getarg_7 db ";",0
  4850 00001CE8 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4851 00001CF1 2000               
  4852 00001CF3 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4853 00001CFC 2000               
  4854 00001CFE 2C2000                  getarg_10 db ", ",0
  4855 00001D01 5C6E00                  getarg_11 db "\n",0
  4856                                  
  4857                                  epilog:  ; *** PROC ***
  4858                                  
  4859                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4860                                  
  4861                                  ;Function : epilog, Number of local variables: 3
  4862                                  ;   # type sign width line used address name   list of local variables
  4863                                  ;  200 var sign word    26 NULL bp-2    i
  4864                                  ;  201 var sign word    26 NULL bp-4    j
  4865                                  ;  202 var sign byte    26 NULL bp-6    c;
  4866 00001D04 C8060000                 ENTER  6,0
  4867 00001D08 68[2D1E]                 push epilog_0
  4868 00001D0B E8BFFA                   call prs
  4869 00001D0E 83C402                   add  sp, 2
  4870 00001D11 FF36[3200]               push word [ErrorCount]
  4871 00001D15 E8D0FB                   call printIntU
  4872 00001D18 83C402                   add  sp, 2
  4873                                  
  4874                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4875                                  
  4876 00001D1B A1[3200]                 mov ax, [ErrorCount]
  4877 00001D1E 08C0                     or  al, al
  4878 00001D20 0F840900                 je @@epilog203
  4879 00001D24 68[3D1E]                 push epilog_1
  4880 00001D27 E8A3FA                   call prs
  4881 00001D2A 83C402                   add  sp, 2
  4882                                  
  4883                                  ;-29   prs(", Label & Var: ");
  4884                                  
  4885                                  @@epilog203:
  4886 00001D2D 68[4B1E]                 push epilog_2
  4887 00001D30 E89AFA                   call prs
  4888 00001D33 83C402                   add  sp, 2
  4889                                  
  4890                                  ;-30   if (LabelMaxIx) {
  4891                                  
  4892 00001D36 A1[4F00]                 mov ax, [LabelMaxIx]
  4893 00001D39 08C0                     or  al, al
  4894 00001D3B 0F846900                 je @@epilog204
  4895                                  
  4896                                  ;-31     i = 1;
  4897                                  
  4898 00001D3F 66B801000000             mov eax, 1
  4899 00001D45 8946FE                   mov word [bp-2], ax
  4900                                  
  4901                                  ;-32     LabelNamePtr= &LabelNames;
  4902                                  
  4903 00001D48 B8BB76                   mov ax, LabelNames
  4904 00001D4B A3[4D00]                 mov word [LabelNamePtr], ax
  4905                                  
  4906                                  ;-33     do {
  4907                                  
  4908                                  @@epilog205:
  4909                                  
  4910                                  ;-34       prs(LabelNamePtr); prc(' ');
  4911                                  
  4912 00001D4E FF36[4D00]               push word [LabelNamePtr]
  4913 00001D52 E878FA                   call prs
  4914 00001D55 83C402                   add  sp, 2
  4915 00001D58 6A20                     push 32
  4916 00001D5A E80FFA                   call prc
  4917 00001D5D 83C402                   add  sp, 2
  4918                                  
  4919                                  ;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4920                                  
  4921 00001D60 8B5EFE                   mov bx, [bp-2]
  4922 00001D63 D1E3                     shl bx, 1
  4923 00001D65 8B87A37A                 mov ax, [LabelAddr + bx]
  4924 00001D69 8946FC                   mov word [bp-4], ax
  4925 00001D6C FF76FC                   push word [bp-4]
  4926 00001D6F E84CFB                   call printhex16
  4927 00001D72 83C402                   add  sp, 2
  4928 00001D75 68[5B1E]                 push epilog_3
  4929 00001D78 E852FA                   call prs
  4930 00001D7B 83C402                   add  sp, 2
  4931                                  
  4932                                  ;-36       j=strlen(LabelNamePtr);//get end of actual name
  4933                                  
  4934 00001D7E FF36[4D00]               push word [LabelNamePtr]
  4935 00001D82 E89501                   call strlen
  4936 00001D85 83C402                   add  sp, 2
  4937 00001D88 8946FC                   mov word [bp-4], ax
  4938                                  
  4939                                  ;-37       LabelNamePtr=LabelNamePtr+j;
  4940                                  
  4941 00001D8B A1[4D00]                 mov ax, [LabelNamePtr]
  4942 00001D8E 0346FC                   add ax, [bp-4]
  4943 00001D91 A3[4D00]                 mov word [LabelNamePtr], ax
  4944                                  
  4945                                  ;-38       LabelNamePtr++;
  4946                                  
  4947 00001D94 FF06[4D00]               inc  word [LabelNamePtr]
  4948                                  
  4949                                  ;-39       i++;
  4950                                  
  4951 00001D98 FF46FE                   inc  word [bp-2]
  4952                                  
  4953                                  ;-40     } while (i <= LabelMaxIx);
  4954                                  
  4955 00001D9B 8B46FE                   mov ax, [bp-2]
  4956 00001D9E 3B06[4F00]               cmp ax, [LabelMaxIx]
  4957 00001DA2 0F8F0200                 jg  @@epilog206
  4958 00001DA6 EBA6                     jmp @@epilog205
  4959                                  @@epilog206:
  4960                                  
  4961                                  ;-41   }
  4962                                  
  4963                                  
  4964                                  ;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4965                                  
  4966                                  @@epilog204:
  4967 00001DA8 68[5F1E]                 push epilog_4
  4968 00001DAB E81FFA                   call prs
  4969 00001DAE 83C402                   add  sp, 2
  4970 00001DB1 FF36[5300]               push word [BinLen]
  4971 00001DB5 E830FB                   call printIntU
  4972 00001DB8 83C402                   add  sp, 2
  4973 00001DBB 68[6C1E]                 push epilog_5
  4974 00001DBE E80CFA                   call prs
  4975 00001DC1 83C402                   add  sp, 2
  4976                                  
  4977                                  ;-43   i=0;
  4978                                  
  4979 00001DC4 66B800000000             mov eax, 0
  4980 00001DCA 8946FE                   mov word [bp-2], ax
  4981                                  
  4982                                  ;-44   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4983                                  
  4984                                  @@epilog207:
  4985 00001DCD 6A20                     push 32
  4986 00001DCF E89AF9                   call prc
  4987 00001DD2 83C402                   add  sp, 2
  4988 00001DD5 8B5EFE                   mov bx, [bp-2]
  4989 00001DD8 8A876B7B                 mov al, [FileBin + bx]
  4990 00001DDC 8946FC                   mov word [bp-4], ax
  4991 00001DDF FF76FC                   push word [bp-4]
  4992 00001DE2 E88BFA                   call printhex8a
  4993 00001DE5 83C402                   add  sp, 2
  4994 00001DE8 FF46FE                   inc  word [bp-2]
  4995                                  
  4996                                  ;-45   } while (i < BinLen);
  4997                                  
  4998 00001DEB 8B46FE                   mov ax, [bp-2]
  4999 00001DEE 3B06[5300]               cmp ax, [BinLen]
  5000 00001DF2 0F8D0200                 jge @@epilog208
  5001 00001DF6 EBD5                     jmp @@epilog207
  5002                                  @@epilog208:
  5003                                  
  5004                                  ;-46   i=0;
  5005                                  
  5006 00001DF8 66B800000000             mov eax, 0
  5007 00001DFE 8946FE                   mov word [bp-2], ax
  5008                                  
  5009                                  ;-47   do {
  5010                                  
  5011                                  @@epilog209:
  5012                                  
  5013                                  ;-48     c = FileBin[i];
  5014                                  
  5015 00001E01 8B5EFE                   mov bx, [bp-2]
  5016 00001E04 8A876B7B                 mov al, [FileBin + bx]
  5017 00001E08 8846FA                   mov byte [bp-6], al
  5018                                  
  5019                                  ;-49     fputcR(c, bin_fd);
  5020                                  
  5021 00001E0B FF36[2E00]               push word [bin_fd]
  5022 00001E0F 8A46FA                   mov al, byte [bp-6]
  5023 00001E12 B400                     mov ah, 0
  5024 00001E14 50                       push ax
  5025 00001E15 E84902                   call fputcR
  5026 00001E18 83C404                   add  sp, 4
  5027                                  
  5028                                  ;-50     i++;
  5029                                  
  5030 00001E1B FF46FE                   inc  word [bp-2]
  5031                                  
  5032                                  ;-51   } while (i < BinLen);
  5033                                  
  5034 00001E1E 8B46FE                   mov ax, [bp-2]
  5035 00001E21 3B06[5300]               cmp ax, [BinLen]
  5036 00001E25 0F8D0200                 jge @@epilog210
  5037 00001E29 EBD6                     jmp @@epilog209
  5038                                  @@epilog210:
  5039                                  
  5040                                  ;-52 }
  5041                                  
  5042                                  
  5043                                  ;-53 int end1(int n) {
  5044 00001E2B C9                       LEAVE
  5045 00001E2C C3                       ret
  5046                                  ; ENDP
  5047 00001E2D 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5048 00001E36 726F72733A2000     
  5049 00001E3D 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5050 00001E46 2A2A2A2000         
  5051 00001E4B 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5052 00001E54 205661723A2000     
  5053 00001E5B 2C202000                epilog_3 db ",  ",0
  5054 00001E5F 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5055 00001E68 6C652000           
  5056 00001E6C 2062797465733A00        epilog_5 db " bytes:",0
  5057                                  
  5058                                  end1:  ; *** PROC ***
  5059                                  
  5060                                  ;-54   fcloseR(asm_fd);
  5061                                  
  5062                                  ;Function : end1, Number of local variables: 1
  5063                                  ;   # type sign width line used address name   list of local variables
  5064                                  ;  200 var sign word    53 NULL bp+4    n;
  5065 00001E74 C8000000                 ENTER  0,0
  5066 00001E78 FF36[2A00]               push word [asm_fd]
  5067 00001E7C E8F701                   call fcloseR
  5068 00001E7F 83C402                   add  sp, 2
  5069                                  
  5070                                  ;-55   fcloseR(lst_fd);
  5071                                  
  5072 00001E82 FF36[2C00]               push word [lst_fd]
  5073 00001E86 E8ED01                   call fcloseR
  5074 00001E89 83C402                   add  sp, 2
  5075                                  
  5076                                  ;-56   fcloseR(bin_fd);
  5077                                  
  5078 00001E8C FF36[2E00]               push word [bin_fd]
  5079 00001E90 E8E301                   call fcloseR
  5080 00001E93 83C402                   add  sp, 2
  5081                                  
  5082                                  ;-57   exitR(n);
  5083                                  
  5084 00001E96 FF7604                   push word [bp+4]
  5085 00001E99 E8E801                   call exitR
  5086 00001E9C 83C402                   add  sp, 2
  5087                                  
  5088                                  ;-58 }
  5089 00001E9F C9                       LEAVE
  5090 00001EA0 C3                       ret
  5091                                  ; ENDP
  5092                                  ;Back to main program: AS.C
  5093                                   
  5094                                  ; missing functions: 
  5095                                  ; digit
  5096                                  ; strcpy
  5097                                  ; eqstr
  5098                                  ; strlen
  5099                                  ; eqstr
  5100                                  ; eqstr
  5101                                  ; eqstr
  5102                                  ; eqstr
  5103                                  ; readRL
  5104                                  ; readRL
  5105                                  ; digit
  5106                                  ; digit
  5107                                  ; strcpy
  5108                                  ; toupper
  5109                                  ; strlen
  5110                                  ; strlen
  5111                                  ; eqstr
  5112                                  ; eqstr
  5113                                  ; eqstr
  5114                                  ; eqstr
  5115                                  ; eqstr
  5116                                  ; eqstr
  5117                                  ; eqstr
  5118                                  ; eqstr
  5119                                  ; eqstr
  5120                                  ; eqstr
  5121                                  ; eqstr
  5122                                  ; eqstr
  5123                                  ; eqstr
  5124                                  ; eqstr
  5125                                  ; eqstr
  5126                                  ; eqstr
  5127                                  ; eqstr
  5128                                  ; eqstr
  5129                                  ; eqstr
  5130                                  ; eqstr
  5131                                  ; eqstr
  5132                                  ; eqstr
  5133                                  ; eqstr
  5134                                  ; eqstr
  5135                                  ; eqstr
  5136                                  ; eqstr
  5137                                  ; eqstr
  5138                                  ; eqstr
  5139                                  ; eqstr
  5140                                  ; eqstr
  5141                                  ; writetty
  5142                                  ; writetty
  5143                                  ; fputcR
  5144                                  ; cputs
  5145                                  ; cputs
  5146                                  ; exitR
  5147                                  ; toupper
  5148                                  ; strcpy
  5149                                  ; strcat1
  5150                                  ; strcpy
  5151                                  ; strcat1
  5152                                  ; strcpy
  5153                                  ; strcat1
  5154                                  ; openR
  5155                                  ; cputs
  5156                                  ; cputs
  5157                                  ; exitR
  5158                                  ; creatR
  5159                                  ; cputs
  5160                                  ; cputs
  5161                                  ; exitR
  5162                                  ; creatR
  5163                                  ; cputs
  5164                                  ; cputs
  5165                                  ; exitR
  5166                                  ; strlen
  5167                                  ; fputcR
  5168                                  ; fcloseR
  5169                                  ; fcloseR
  5170                                  ; fcloseR
  5171                                  ; exitR
  5172                                  ; Number of unresolved CALLs :   77
  5173                                  ;use archive file: AR.C
  5174                                  
  5175                                  ;-219 // AR.C Archive
  5176                                  
  5177                                  ;Number of CALLs:    2 : writetty
  5178                                  
  5179                                  writetty:  ; *** PROC ***
  5180 00001EA1 B40E                     mov  ah, 14
  5181 00001EA3 BB0000                   mov  bx, 0
  5182 00001EA6 CD10                     int  16
  5183                                  
  5184                                  ;-220 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5185                                  
  5186 00001EA8 C3                       ret
  5187                                  ; ENDP
  5188                                  ;Number of CALLs:    8 : cputs
  5189                                  
  5190                                  cputs:  ; *** PROC ***
  5191                                  ;Function : cputs, Number of local variables: 2
  5192                                  ;   # type sign width line used address name   list of local variables
  5193                                  ;  200 ptr sign byte   220 NULL bp+4    s
  5194                                  ;  201 var sign byte   220 NULL bp-2    c;
  5195 00001EA9 C8020000                 ENTER  2,0
  5196                                  @@cputs211:
  5197 00001EAD 8B5E04                   mov bx, [bp+4]
  5198 00001EB0 8A07                     mov al, [bx]
  5199 00001EB2 B400                     mov ah, 0
  5200 00001EB4 08C0                     or  al, al
  5201 00001EB6 0F841B00                 je @@cputs212
  5202 00001EBA 8B5E04                   mov bx, [bp+4]
  5203 00001EBD 8A07                     mov al, [bx]
  5204 00001EBF B400                     mov ah, 0
  5205 00001EC1 8846FE                   mov byte [bp-2], al
  5206 00001EC4 8A46FE                   mov al, byte [bp-2]
  5207 00001EC7 B400                     mov ah, 0
  5208 00001EC9 50                       push ax
  5209 00001ECA E8C401                   call putch
  5210 00001ECD 83C402                   add  sp, 2
  5211 00001ED0 FF4604                   inc  word [bp+4]
  5212 00001ED3 EBD8                     jmp @@cputs211
  5213                                  @@cputs212:
  5214                                  
  5215                                  ;-221 int mkneg(int n) { n; __asm {neg ax} }
  5216 00001ED5 C9                       LEAVE
  5217 00001ED6 C3                       ret
  5218                                  ; ENDP
  5219                                  ;Number of CALLs:    2 : toupper
  5220                                  
  5221                                  toupper:  ; *** PROC ***
  5222                                  ;Function : toupper, Number of local variables: 1
  5223                                  ;   # type sign width line used address name   list of local variables
  5224                                  ;  200 ptr sign byte   221 NULL bp+4    s;
  5225 00001ED7 C8000000                 ENTER  0,0
  5226                                  @@toupper213:
  5227 00001EDB 8B5E04                   mov bx, [bp+4]
  5228 00001EDE 8A07                     mov al, [bx]
  5229 00001EE0 B400                     mov ah, 0
  5230 00001EE2 08C0                     or  al, al
  5231 00001EE4 0F843000                 je @@toupper214
  5232 00001EE8 8B5E04                   mov bx, [bp+4]
  5233 00001EEB 8A07                     mov al, [bx]
  5234 00001EED B400                     mov ah, 0
  5235 00001EEF 83F861                   cmp ax, 97 ;unsigned : 1
  5236 00001EF2 0F8C1D00                 jl  @@toupper215
  5237 00001EF6 8B5E04                   mov bx, [bp+4]
  5238 00001EF9 8A07                     mov al, [bx]
  5239 00001EFB B400                     mov ah, 0
  5240 00001EFD 83F87A                   cmp ax, 122
  5241 00001F00 0F8F0F00                 jg  @@toupper216
  5242 00001F04 8B5E04                   mov bx, [bp+4]
  5243 00001F07 8A07                     mov al, [bx]
  5244 00001F09 B400                     mov ah, 0
  5245 00001F0B 83E820                   sub ax, 32
  5246 00001F0E 8B5E04                   mov  bx, [bp+4]
  5247 00001F11 8807                     mov  [bx], al
  5248                                  @@toupper216:
  5249                                  @@toupper215:
  5250 00001F13 FF4604                   inc  word [bp+4]
  5251 00001F16 EBC3                     jmp @@toupper213
  5252                                  @@toupper214:
  5253                                  
  5254                                  ;-222 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5255                                  
  5256                                  
  5257                                  ;-223 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5258 00001F18 C9                       LEAVE
  5259 00001F19 C3                       ret
  5260                                  ; ENDP
  5261                                  ;Number of CALLs:    4 : strlen
  5262                                  
  5263                                  strlen:  ; *** PROC ***
  5264                                  ;Function : strlen, Number of local variables: 2
  5265                                  ;   # type sign width line used address name   list of local variables
  5266                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5267                                  ;  201 var sign word   223 NULL bp-2    c;
  5268 00001F1A C8020000                 ENTER  2,0
  5269 00001F1E 66B800000000             mov eax, 0
  5270 00001F24 8946FE                   mov word [bp-2], ax
  5271                                  @@strlen217:
  5272 00001F27 8B5E04                   mov bx, [bp+4]
  5273 00001F2A 8A07                     mov al, [bx]
  5274 00001F2C B400                     mov ah, 0
  5275 00001F2E 83F800                   cmp ax, 0
  5276 00001F31 0F840800                 je  @@strlen218
  5277 00001F35 FF4604                   inc  word [bp+4]
  5278 00001F38 FF46FE                   inc  word [bp-2]
  5279 00001F3B EBEA                     jmp @@strlen217
  5280                                  @@strlen218:
  5281 00001F3D 8B46FE                   mov ax, [bp-2]
  5282 00001F40 E90000                   jmp @@retn
  5283                                  
  5284                                  ;-224 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5285                                  
  5286 00001F43 C9                      @@retn: LEAVE
  5287 00001F44 C3                       ret
  5288                                  ; ENDP
  5289                                  ;Number of CALLs:    5 : strcpy
  5290                                  
  5291                                  strcpy:  ; *** PROC ***
  5292                                  ;Function : strcpy, Number of local variables: 2
  5293                                  ;   # type sign width line used address name   list of local variables
  5294                                  ;  200 ptr sign byte   224 NULL bp+4    s
  5295                                  ;  201 ptr sign byte   224 NULL bp+6    t;
  5296 00001F45 C8000000                 ENTER  0,0
  5297                                  @@strcpy219:
  5298 00001F49 8B5E06                   mov bx, [bp+6]
  5299 00001F4C 8A07                     mov al, [bx]
  5300 00001F4E B400                     mov ah, 0
  5301 00001F50 8B5E04                   mov  bx, [bp+4]
  5302 00001F53 8807                     mov  [bx], al
  5303 00001F55 FF4604                   inc  word [bp+4]
  5304 00001F58 FF4606                   inc  word [bp+6]
  5305                                  
  5306                                  ;-225   while (*t!=0); *s=0; return s; }
  5307                                  
  5308 00001F5B 8B5E06                   mov bx, [bp+6]
  5309 00001F5E 8A07                     mov al, [bx]
  5310 00001F60 B400                     mov ah, 0
  5311 00001F62 83F800                   cmp ax, 0
  5312 00001F65 0F840200                 je  @@strcpy220
  5313 00001F69 EBDE                     jmp @@strcpy219
  5314                                  @@strcpy220:
  5315 00001F6B 66B800000000             mov eax, 0
  5316 00001F71 8B5E04                   mov  bx, [bp+4]
  5317 00001F74 8807                     mov  [bx], al
  5318 00001F76 8B4604                   mov ax, [bp+4]
  5319 00001F79 E90000                   jmp @@retn
  5320                                  
  5321                                  ;-226 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5322                                  
  5323 00001F7C C9                      @@retn: LEAVE
  5324 00001F7D C3                       ret
  5325                                  ; ENDP
  5326                                  ;Number of CALLs:    3 : digit
  5327                                  
  5328                                  digit:  ; *** PROC ***
  5329                                  ;Function : digit, Number of local variables: 1
  5330                                  ;   # type sign width line used address name   list of local variables
  5331                                  ;  200 var sign byte   226 NULL bp+4    c;
  5332 00001F7E C8000000                 ENTER  0,0
  5333 00001F82 8A4604                   mov al, [bp+4]
  5334 00001F85 3C30                     cmp al, 48
  5335 00001F87 0F8D0900                 jge @@digit221
  5336 00001F8B 66B800000000             mov eax, 0
  5337 00001F91 E91B00                   jmp @@retn
  5338                                  @@digit221:
  5339 00001F94 8A4604                   mov al, [bp+4]
  5340 00001F97 3C39                     cmp al, 57
  5341 00001F99 0F8E0900                 jle @@digit222
  5342 00001F9D 66B800000000             mov eax, 0
  5343 00001FA3 E90900                   jmp @@retn
  5344                                  @@digit222:
  5345 00001FA6 66B801000000             mov eax, 1
  5346 00001FAC E90000                   jmp @@retn
  5347                                  
  5348                                  ;-227 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5349                                  
  5350 00001FAF C9                      @@retn: LEAVE
  5351 00001FB0 C3                       ret
  5352                                  ; ENDP
  5353                                  ;Number of CALLs:   35 : eqstr
  5354                                  
  5355                                  eqstr:  ; *** PROC ***
  5356                                  ;Function : eqstr, Number of local variables: 2
  5357                                  ;   # type sign width line used address name   list of local variables
  5358                                  ;  200 ptr sign byte   227 NULL bp+4    p
  5359                                  ;  201 ptr sign byte   227 NULL bp+6    q;
  5360 00001FB1 C8000000                 ENTER  0,0
  5361                                  @@eqstr223:
  5362 00001FB5 8B5E04                   mov bx, [bp+4]
  5363 00001FB8 8A07                     mov al, [bx]
  5364 00001FBA B400                     mov ah, 0
  5365 00001FBC 08C0                     or  al, al
  5366 00001FBE 0F842300                 je @@eqstr224
  5367                                  
  5368                                  ;-228     if (*p != *q) return 0; p++; q++; }
  5369                                  
  5370 00001FC2 8B5E04                   mov bx, [bp+4]
  5371 00001FC5 8A07                     mov al, [bx]
  5372 00001FC7 B400                     mov ah, 0
  5373 00001FC9 8B5E06                   mov bx, [bp+6]
  5374 00001FCC 3A07                     cmp al, [bx]
  5375 00001FCE B400                     mov ah, 0
  5376 00001FD0 0F840900                 je  @@eqstr225
  5377 00001FD4 66B800000000             mov eax, 0
  5378 00001FDA E92700                   jmp @@retn
  5379                                  @@eqstr225:
  5380 00001FDD FF4604                   inc  word [bp+4]
  5381 00001FE0 FF4606                   inc  word [bp+6]
  5382                                  
  5383                                  ;-229     if(*q) return 0; return 1; }
  5384                                  
  5385 00001FE3 EBD0                     jmp @@eqstr223
  5386                                  @@eqstr224:
  5387 00001FE5 8B5E06                   mov bx, [bp+6]
  5388 00001FE8 8A07                     mov al, [bx]
  5389 00001FEA B400                     mov ah, 0
  5390 00001FEC 08C0                     or  al, al
  5391 00001FEE 0F840900                 je @@eqstr226
  5392 00001FF2 66B800000000             mov eax, 0
  5393 00001FF8 E90900                   jmp @@retn
  5394                                  @@eqstr226:
  5395 00001FFB 66B801000000             mov eax, 1
  5396 00002001 E90000                   jmp @@retn
  5397                                  
  5398                                  ;-230 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5399                                  
  5400 00002004 C9                      @@retn: LEAVE
  5401 00002005 C3                       ret
  5402                                  ; ENDP
  5403                                  ;Number of CALLs:    3 : strcat1
  5404                                  
  5405                                  strcat1:  ; *** PROC ***
  5406                                  ;Function : strcat1, Number of local variables: 2
  5407                                  ;   # type sign width line used address name   list of local variables
  5408                                  ;  200 ptr sign byte   230 NULL bp+4    s
  5409                                  ;  201 ptr sign byte   230 NULL bp+6    t;
  5410 00002006 C8000000                 ENTER  0,0
  5411                                  @@strcat1227:
  5412 0000200A 8B5E04                   mov bx, [bp+4]
  5413 0000200D 8A07                     mov al, [bx]
  5414 0000200F B400                     mov ah, 0
  5415 00002011 83F800                   cmp ax, 0
  5416 00002014 0F840500                 je  @@strcat1228
  5417 00002018 FF4604                   inc  word [bp+4]
  5418 0000201B EBED                     jmp @@strcat1227
  5419                                  @@strcat1228:
  5420 0000201D FF7606                   push word [bp+6]
  5421 00002020 FF7604                   push word [bp+4]
  5422 00002023 E81FFF                   call strcpy
  5423 00002026 83C404                   add  sp, 4
  5424                                  
  5425                                  ;-231 int basename(char *s) { char *p; p=0;
  5426 00002029 C9                       LEAVE
  5427 0000202A C3                       ret
  5428                                  ; ENDP
  5429                                  ;Number of CALLs:    1 : openR
  5430                                  
  5431                                  openR:  ; *** PROC ***
  5432                                  ;Function : openR, Number of local variables: 1
  5433                                  ;   # type sign width line used address name   list of local variables
  5434                                  ;  200 ptr sign byte   231 NULL bp+4    s;
  5435 0000202B C8000000                 ENTER  0,0
  5436 0000202F 8B5604                   mov  dx, [bp+4]
  5437 00002032 B8023D                   mov  ax, 15618
  5438 00002035 E87200                   call DosInt
  5439                                  
  5440                                  ;-232 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5441 00002038 C9                       LEAVE
  5442 00002039 C3                       ret
  5443                                  ; ENDP
  5444                                  ;Number of CALLs:    2 : creatR
  5445                                  
  5446                                  creatR:  ; *** PROC ***
  5447                                  ;Function : creatR, Number of local variables: 1
  5448                                  ;   # type sign width line used address name   list of local variables
  5449                                  ;  200 ptr sign byte   232 NULL bp+4    s;
  5450 0000203A C8000000                 ENTER  0,0
  5451 0000203E 8B5604                   mov  dx, [bp+4]
  5452 00002041 B90000                   mov  cx, 0
  5453 00002044 B8003C                   mov  ax, 15360
  5454 00002047 E86000                   call DosInt
  5455                                  
  5456                                  ;-233 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5457 0000204A C9                       LEAVE
  5458 0000204B C3                       ret
  5459                                  ; ENDP
  5460                                  ;Number of CALLs:    2 : readRL
  5461                                  
  5462                                  readRL:  ; *** PROC ***
  5463                                  ;Function : readRL, Number of local variables: 3
  5464                                  ;   # type sign width line used address name   list of local variables
  5465                                  ;  200 ptr sign byte   233 NULL bp+4    s
  5466                                  ;  201 var sign word   233 NULL bp+6    fd
  5467                                  ;  202 var sign word   233 NULL bp+8    len;
  5468 0000204C C8000000                 ENTER  0,0
  5469 00002050 8B5604                   mov  dx, [bp+4]
  5470 00002053 8B4E08                   mov  cx, [bp+8]
  5471 00002056 8B5E06                   mov  bx, [bp+6]
  5472 00002059 B8003F                   mov  ax, 16128
  5473 0000205C E84B00                   call DosInt
  5474                                  
  5475                                  ;-234 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5476 0000205F C9                       LEAVE
  5477 00002060 C3                       ret
  5478                                  ; ENDP
  5479                                  ;Number of CALLs:    2 : fputcR
  5480                                  
  5481                                  fputcR:  ; *** PROC ***
  5482                                  ;Function : fputcR, Number of local variables: 2
  5483                                  ;   # type sign width line used address name   list of local variables
  5484                                  ;  200 ptr sign byte   234 NULL bp+4    n
  5485                                  ;  201 var sign word   234 NULL bp+6    fd;
  5486 00002061 C8000000                 ENTER  0,0
  5487 00002065 8D5604                  lea dx, [bp+4]
  5488                                  
  5489                                  ;-235   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5490                                  
  5491 00002068 B90100                   mov  cx, 1
  5492 0000206B 8B5E06                   mov  bx, [bp+6]
  5493 0000206E B80040                   mov  ax, 16384
  5494 00002071 E83600                   call DosInt
  5495                                  
  5496                                  ;-236 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5497 00002074 C9                       LEAVE
  5498 00002075 C3                       ret
  5499                                  ; ENDP
  5500                                  ;Number of CALLs:    3 : fcloseR
  5501                                  
  5502                                  fcloseR:  ; *** PROC ***
  5503                                  ;Function : fcloseR, Number of local variables: 1
  5504                                  ;   # type sign width line used address name   list of local variables
  5505                                  ;  200 var sign word   236 NULL bp+4    fd;
  5506 00002076 C8000000                 ENTER  0,0
  5507 0000207A 8B5E04                   mov  bx, [bp+4]
  5508 0000207D B8003E                   mov  ax, 15872
  5509 00002080 CD21                     int  33
  5510                                  
  5511                                  ;-237 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5512 00002082 C9                       LEAVE
  5513 00002083 C3                       ret
  5514                                  ; ENDP
  5515                                  ;Number of CALLs:    5 : exitR
  5516                                  
  5517                                  exitR:  ; *** PROC ***
  5518                                  ;Function : exitR, Number of local variables: 1
  5519                                  ;   # type sign width line used address name   list of local variables
  5520                                  ;  200 var sign byte   237 NULL bp+4    c;
  5521 00002084 C8000000                 ENTER  0,0
  5522 00002088 B44C                     mov  ah, 76
  5523 0000208A 8A4604                   mov  al, [bp+4]
  5524 0000208D CD21                     int  33
  5525                                  
  5526                                  ;-238 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5527 0000208F C9                       LEAVE
  5528 00002090 C3                       ret
  5529                                  ; ENDP
  5530                                  ;End of archive file. 
  5531                                   
  5532                                  ; missing functions: 
  5533                                  ; putch
  5534                                  ; DosInt
  5535                                  ; DosInt
  5536                                  ; DosInt
  5537                                  ; DosInt
  5538                                  ; Number of unresolved CALLs :    5
  5539                                  ;use archive file: AR.C
  5540                                  
  5541                                  ;-239 // AR.C Archive
  5542                                  
  5543                                  ;Number of CALLs:    1 : putch
  5544                                  
  5545                                  putch:  ; *** PROC ***
  5546                                  ;Function : putch, Number of local variables: 1
  5547                                  ;   # type sign width line used address name   list of local variables
  5548                                  ;  200 var sign byte   239 NULL bp+4    c;
  5549 00002091 C8000000                 ENTER  0,0
  5550 00002095 807E040A                cmp byte [bp+4], 10
  5551 00002099 0F850500                 jne @@putch229
  5552 0000209D B00D                     mov  al, 13
  5553 0000209F E8FFFD                   call writetty
  5554                                  @@putch229:
  5555 000020A2 8A4604                   mov  al, [bp+4]
  5556 000020A5 E8F9FD                   call writetty
  5557                                  
  5558                                  ;-240 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5559 000020A8 C9                       LEAVE
  5560 000020A9 C3                       ret
  5561                                  ; ENDP
  5562                                  ;Number of CALLs:    4 : DosInt
  5563                                  
  5564                                  DosInt:  ; *** PROC ***
  5565 000020AA CD21                     int  33
  5566 000020AC 7304                     jae short @@DosInt230
  5567 000020AE FF06[3000]               inc  word [DOS_ERR]
  5568                                  @@DosInt230:
  5569                                  
  5570                                  ;-241 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5571                                  
  5572 000020B2 C3                       ret
  5573                                  ; ENDP
  5574                                  ;End of archive file. 
  5575                                   
  5576                                  ; missing functions:  All FUNCTIONs in place
  5577 000020B3 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5578 000020B6 58                      pop ax
  5579 000020B7 C3                      ret
  5580                                   
  5581                                  ;   # type sign width line used  address name   list of global variables
  5582                                  
  5583                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5584                                  ;    2 var sign byte     1    3        0 LIST
  5585                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5586                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5587                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5588                                  ;    6 var unsg word     5   12        0 SymbolInt
  5589                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5590                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5591                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5592                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5593                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5594                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5595                                  ;   13 var sign word    12    4        0 asm_fd
  5596                                  ;   14 var sign word    13    3        0 lst_fd
  5597                                  ;   15 var sign word    14    3        0 bin_fd
  5598                                  ;   16 var sign word    15    6        0 DOS_ERR
  5599                                  ;   17 var sign word    16    4        0 ErrorCount
  5600                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5601                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5602                                  ;   20 var unsg word    20    5        0 PC
  5603                                  ;   21 var unsg word    21    2        0 PCStart
  5604                                  ;   22 var sign byte    22    3        0 isLabel
  5605                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5606                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5607                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5608                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5609                                  ;   27 var sign byte    27   20        0 TokeType
  5610                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5611                                  ;   29 def unsg byte    29    -        0 WORD=2
  5612                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5613                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5614                                  ;   32 def unsg byte    33    -        0 IMM=1
  5615                                  ;   33 def unsg byte    34    -        0 REG=2
  5616                                  ;   34 def unsg byte    35    -        0 ADR=3
  5617                                  ;   35 def unsg byte    36    -        0 MEM=4
  5618                                  ;   36 var sign byte    37   13        0 Op1
  5619                                  ;   37 var sign byte    38   12        0 CodeType
  5620                                  ;   38 var sign byte    40   17        0 RegType
  5621                                  ;   39 var sign byte    41   10        0 RegNo
  5622                                  ;   40 var sign byte    42   10        0 OpSize
  5623                                  ;   41 var sign byte    43    5        0 wflag
  5624                                  ;   42 var sign byte    48   15        0 regindexbase
  5625                                  ;   43 var sign word    49   13        0 disp
  5626                                  ;   44 var sign word    50    2        0 imme
  5627                                  ;   45 def unsg byte    52    -        0 OPMAXLEN=5
  5628                                  ;   46 arr sign byte    53    2    30390 OpPos[5]
  5629                                  ;   47 var sign word    54    6        0 OpPrintIndex
  5630                                  ;   48 ptr sign byte    55   16        0 OpCodePtr
  5631                                  ;   49 var sign byte    56    2        0 PrintR
  5632                                  ;   50 def unsg byte    58    -        0 LABELNAMESMAX=969
  5633                                  ;   51 arr sign byte    59    3    30395 LabelNames[1000]
  5634                                  ;   52 ptr sign byte    60   10        0 LabelNamePtr
  5635                                  ;   53 def unsg byte    61    -        0 LABELADRMAX=100
  5636                                  ;   54 arr unsg word    62    4    31395 LabelAddr[100]
  5637                                  ;   55 var sign word    63    5        0 LabelMaxIx
  5638                                  ;   56 var sign word    64    4        0 LabelIx
  5639                                  ;   57 def unsg byte    66    -        0 FILEBINMAX=1990
  5640                                  ;   58 arr sign byte    67    3    31595 FileBin[2000]
  5641                                  ;   59 var unsg word    68    5        0 BinLen
  5642                                  ;   60 ptr sign byte    70    1        0 arglen
  5643                                  ;   61 ptr sign byte    71    4        0 argv
  5644                                  ;   62 var sign byte     1    1        0 I_START
  5645                                  ;   63 arr sign byte     4 NULL        0 I_PUSHA[9]
  5646                                  ;   64 arr sign byte     5 NULL        0 I_POPA[8]
  5647                                  ;   65 arr sign byte     6 NULL        0 I_NOP[7]
  5648                                  ;   66 arr sign byte     7 NULL        0 I_CBW[7]
  5649                                  ;   67 arr sign byte     8 NULL        0 I_CWDE[8]
  5650                                  ;   68 arr sign byte     9 NULL        0 I_CWD[7]
  5651                                  ;   69 arr sign byte    10 NULL        0 I_CDQ[7]
  5652                                  ;   70 arr sign byte    11 NULL        0 I_WAIT[8]
  5653                                  ;   71 arr sign byte    12 NULL        0 I_PUSHF[9]
  5654                                  ;   72 arr sign byte    13 NULL        0 I_POPF[8]
  5655                                  ;   73 arr sign byte    14 NULL        0 I_SAHF[8]
  5656                                  ;   74 arr sign byte    15 NULL        0 I_LAHF[8]
  5657                                  ;   75 arr sign byte    16 NULL        0 I_MOVSB[9]
  5658                                  ;   76 arr sign byte    17 NULL        0 I_MOVSW[9]
  5659                                  ;   77 arr sign byte    18 NULL        0 I_CMPSB[9]
  5660                                  ;   78 arr sign byte    19 NULL        0 I_CMPSW[9]
  5661                                  ;   79 arr sign byte    20 NULL        0 I_STOSB[9]
  5662                                  ;   80 arr sign byte    21 NULL        0 I_STOSW[9]
  5663                                  ;   81 arr sign byte    22 NULL        0 I_LODSB[9]
  5664                                  ;   82 arr sign byte    23 NULL        0 I_LODSW[9]
  5665                                  ;   83 arr sign byte    24 NULL        0 I_SCASB[9]
  5666                                  ;   84 arr sign byte    25 NULL        0 I_SCASW[9]
  5667                                  ;   85 arr sign byte    26 NULL        0 I_LEAVE[9]
  5668                                  ;   86 arr sign byte    27 NULL        0 I_IRET[8]
  5669                                  ;   87 arr sign byte    28 NULL        0 I_XLAT[8]
  5670                                  ;   88 arr sign byte    29 NULL        0 I_LOCK[8]
  5671                                  ;   89 arr sign byte    30 NULL        0 I_REPNE[9]
  5672                                  ;   90 arr sign byte    31 NULL        0 I_REPNZ[9]
  5673                                  ;   91 arr sign byte    32 NULL        0 I_REPE[8]
  5674                                  ;   92 arr sign byte    33 NULL        0 I_REPZ[8]
  5675                                  ;   93 arr sign byte    34 NULL        0 I_HLT[7]
  5676                                  ;   94 arr sign byte    35 NULL        0 I_CLC[7]
  5677                                  ;   95 arr sign byte    36 NULL        0 I_STC[7]
  5678                                  ;   96 arr sign byte    37 NULL        0 I_CLI[7]
  5679                                  ;   97 arr sign byte    38 NULL        0 I_STI[7]
  5680                                  ;   98 arr sign byte    39 NULL        0 I_CLD[7]
  5681                                  ;   99 arr sign byte    40 NULL        0 I_STD[7]
  5682                                  ;  100 arr sign byte    42 NULL        0 I_INC[9]
  5683                                  ;  101 arr sign byte    43 NULL        0 I_DEC[9]
  5684                                  ;  102 arr sign byte    45 NULL        0 I_NOT[8]
  5685                                  ;  103 arr sign byte    46 NULL        0 I_NEG[8]
  5686                                  ;  104 arr sign byte    47 NULL        0 I_MUL[8]
  5687                                  ;  105 arr sign byte    48 NULL        0 I_IMUL[9]
  5688                                  ;  106 arr sign byte    49 NULL        0 I_DIV[8]
  5689                                  ;  107 arr sign byte    50 NULL        0 I_IDIV[9]
  5690                                  ;  108 arr sign byte    52 NULL        0 I_LES[7]
  5691                                  ;  109 arr sign byte    53 NULL        0 I_LDS[7]
  5692                                  ;  110 arr sign byte    54 NULL        0 I_LEA[7]
  5693                                  ;  111 arr sign byte    56 NULL        0 I_ADD[7]
  5694                                  ;  112 arr sign byte    57 NULL        0 I_OR[6]
  5695                                  ;  113 arr sign byte    58 NULL        0 I_ADC[7]
  5696                                  ;  114 arr sign byte    59 NULL        0 I_SBB[7]
  5697                                  ;  115 arr sign byte    60 NULL        0 I_AND[7]
  5698                                  ;  116 arr sign byte    61 NULL        0 I_SUB[7]
  5699                                  ;  117 arr sign byte    62 NULL        0 I_XOR[7]
  5700                                  ;  118 arr sign byte    63 NULL        0 I_CMP[7]
  5701                                  ;  119 arr sign byte    65 NULL        0 I_MOV[6]
  5702                                  ;  120 arr sign byte    66 NULL        0 I_MOVSX[9]
  5703                                  ;  121 arr sign byte    67 NULL        0 I_MOVZX[9]
  5704                                  ;  122 arr sign byte    69 NULL        0 I_JO[6]
  5705                                  ;  123 arr sign byte    70 NULL        0 I_JNO[7]
  5706                                  ;  124 arr sign byte    71 NULL        0 I_JB[6]
  5707                                  ;  125 arr sign byte    72 NULL        0 I_JC[6]
  5708                                  ;  126 arr sign byte    73 NULL        0 I_JNB[7]
  5709                                  ;  127 arr sign byte    74 NULL        0 I_JAE[7]
  5710                                  ;  128 arr sign byte    75 NULL        0 I_JNC[7]
  5711                                  ;  129 arr sign byte    76 NULL        0 I_JE[6]
  5712                                  ;  130 arr sign byte    77 NULL        0 I_JZ[6]
  5713                                  ;  131 arr sign byte    78 NULL        0 I_JNE[7]
  5714                                  ;  132 arr sign byte    79 NULL        0 I_JNZ[7]
  5715                                  ;  133 arr sign byte    80 NULL        0 I_JBE[7]
  5716                                  ;  134 arr sign byte    81 NULL        0 I_JNA[7]
  5717                                  ;  135 arr sign byte    82 NULL        0 I_JA[6]
  5718                                  ;  136 arr sign byte    83 NULL        0 I_JS[6]
  5719                                  ;  137 arr sign byte    84 NULL        0 I_JNS[7]
  5720                                  ;  138 arr sign byte    85 NULL        0 I_JP[6]
  5721                                  ;  139 arr sign byte    86 NULL        0 I_JPE[7]
  5722                                  ;  140 arr sign byte    87 NULL        0 I_JNP[7]
  5723                                  ;  141 arr sign byte    88 NULL        0 I_JPO[7]
  5724                                  ;  142 arr sign byte    89 NULL        0 I_JL[6]
  5725                                  ;  143 arr sign byte    90 NULL        0 I_JNL[7]
  5726                                  ;  144 arr sign byte    91 NULL        0 I_JGE[7]
  5727                                  ;  145 arr sign byte    92 NULL        0 I_JLE[7]
  5728                                  ;  146 arr sign byte    93 NULL        0 I_JNG[7]
  5729                                  ;  147 arr sign byte    94 NULL        0 I_JG[6]
  5730                                  ;  148 arr sign byte    96 NULL        0 I_JMP[8]
  5731                                  ;  149 arr sign byte    97 NULL        0 I_CALL[9]
  5732                                  ;  150 arr sign byte    99 NULL        0 I_RET[8]
  5733                                  ;  151 arr sign byte   100 NULL        0 I_RETF[9]
  5734                                  ;  152 arr sign byte   102 NULL        0 I_PUSH[8]
  5735                                  ;  153 arr sign byte   103 NULL        0 I_POP[7]
  5736                                  ;  154 arr sign byte   105 NULL        0 I_ROL[7]
  5737                                  ;  155 arr sign byte   106 NULL        0 I_ROR[7]
  5738                                  ;  156 arr sign byte   107 NULL        0 I_RCL[7]
  5739                                  ;  157 arr sign byte   108 NULL        0 I_RCR[7]
  5740                                  ;  158 arr sign byte   109 NULL        0 I_SHL[7]
  5741                                  ;  159 arr sign byte   110 NULL        0 I_SAL[7]
  5742                                  ;  160 arr sign byte   111 NULL        0 I_SHR[7]
  5743                                  ;  161 arr sign byte   112 NULL        0 I_SAR[7]
  5744                                  ;  162 arr sign byte   114 NULL        0 I_INT[8]
  5745                                  ;  163 arr sign byte   115 NULL        0 I_INTO[8]
  5746                                  ;  164 arr sign byte   117 NULL        0 I_IN[7]
  5747                                  ;  165 arr sign byte   118 NULL        0 I_INSB[8]
  5748                                  ;  166 arr sign byte   119 NULL        0 I_INSW[8]
  5749                                  ;  167 arr sign byte   120 NULL        0 I_INSD[8]
  5750                                  ;  168 arr sign byte   121 NULL        0 I_OUT[8]
  5751                                  ;  169 arr sign byte   122 NULL        0 I_OUTSB[8]
  5752                                  ;  170 arr sign byte   123 NULL        0 I_OUTSW[8]
  5753                                  ;  171 arr sign byte   124 NULL        0 I_OUTSD[8]
  5754                                  ;  172 arr sign byte   126 NULL        0 I_XCHG[9]
  5755                                  ;  173 arr sign byte   128 NULL        0 I_LOOPNZ[10]
  5756                                  ;  174 arr sign byte   129 NULL        0 I_LOOPNE[10]
  5757                                  ;  175 arr sign byte   130 NULL        0 I_LOOPZ[9]
  5758                                  ;  176 arr sign byte   131 NULL        0 I_LOOPE[9]
  5759                                  ;  177 arr sign byte   132 NULL        0 I_LOOP[8]
  5760                                  ;  178 arr sign byte   133 NULL        0 I_JCXZ[8]
  5761                                  ;  179 arr sign byte   134 NULL        0 I_JECXZ[9]
  5762                                  ;  180 arr sign byte   136 NULL        0 I_ENTER[9]
  5763                                  ;  181 arr sign byte   138 NULL        0 I_ORG[6]
  5764                                  ;  182 arr sign byte   139 NULL        0 I_DB[5]
  5765                                  ;  183 arr sign byte   140 NULL        0 I_DW[5]
  5766                                  ;  184 arr sign byte   141 NULL        0 I_DD[5]
  5767                                  ;  185 arr sign byte   142 NULL        0 I_RESB[7]
  5768                                  ;  186 arr sign byte   143 NULL        0 I_RESW[7]
  5769                                  ;  187 arr sign byte   144 NULL        0 I_RESD[7]
  5770                                  ;  188 var sign byte   145 NULL        0 I_END
  5771                                  
  5772                                  
  5773                                  ;   # Calls Line Width  Name   list of functions
  5774                                  
  5775                                  ;    0 NULL    1 word   main
  5776                                  ;    1    1    6 word   process
  5777                                  ;    2    1   48 word   setwflag
  5778                                  ;    3 NULL   60 word   Check2Op
  5779                                  ;    4    2   62 word   checkLeftOp
  5780                                  ;    5 NULL   73 word   saveLeftOp
  5781                                  ;    6 NULL   75 word   checkRightOp
  5782                                  ;    7    1   87 word   getOp
  5783                                  ;    8    2  100 word   getOp1
  5784                                  ;    9    1  116 word   getMEM
  5785                                  ;   10    1  136 word   getIndReg1
  5786                                  ;   11    1  144 word   getIndReg2
  5787                                  ;   12    7  155 word   genInstruction
  5788                                  ;   13    1  161 word   gen66h
  5789                                  ;   14    8  163 word   genCode8
  5790                                  ;   15    3  173 word   genCode16
  5791                                  ;   16    2  177 word   genCodeInREG
  5792                                  ;   17 NULL  182 word   genModRegRM
  5793                                  ;   18    2  184 word   writeEA
  5794                                  ;   19 NULL  205 word   testx
  5795                                  ;   20    1    1 word   parse
  5796                                  ;   21   12   27 word   getTokeType
  5797                                  ;   22    2   36 word   storeLabel
  5798                                  ;   23    2   43 word   searchLabel
  5799                                  ;   24    1   54 word   getVariable
  5800                                  ;   25    2   83 word   lookCode
  5801                                  ;   26    1   97 word   getCodeSize
  5802                                  ;   27    7  104 word   isToken
  5803                                  ;   28    1  109 word   skipRest
  5804                                  ;   29    1    1 word   getLine
  5805                                  ;   30    1   14 word   ifEOL
  5806                                  ;   31    3   21 word   skipBlank
  5807                                  ;   32    2   26 word   letterE
  5808                                  ;   33    1   36 word   alnumE
  5809                                  ;   34    1   41 word   getDigit
  5810                                  ;   35    1   53 word   getName
  5811                                  ;   36    1   70 word   testReg
  5812                                  ;   37    1    1 word   printLine
  5813                                  ;   38    9   19 word   prc
  5814                                  ;   39    1   23 word   prscomment
  5815                                  ;   40   23   26 word   prs
  5816                                  ;   41    4   31 word   printhex8a
  5817                                  ;   42    2   35 word   printhex16
  5818                                  ;   43    3   38 word   printIntU
  5819                                  ;   44   20   45 word   error1
  5820                                  ;   45 NULL   48 word   allowederror
  5821                                  ;   46 NULL   49 word   implmerror
  5822                                  ;   47    4   50 word   indexerror
  5823                                  ;   48    1   51 word   numbererror
  5824                                  ;   49 NULL   52 word   regmemerror
  5825                                  ;   50    1   53 word   segregerror
  5826                                  ;   51    1   54 word   syntaxerror
  5827                                  ;   52    7   56 word   errorexit
  5828                                  ;   53    1   57 word   addrexit
  5829                                  ;   54 NULL   58 word   internexit
  5830                                  ;   55    1    1 word   getarg
  5831                                  ;   56    1   26 word   epilog
  5832                                  ;   57    2   53 word   end1
  5833                                  ;   58    4  219 word   writetty
  5834                                  ;   59    8  220 word   cputs
  5835                                  ;   60    2  221 word   toupper
  5836                                  ;   61    4  223 word   strlen
  5837                                  ;   62    6  224 word   strcpy
  5838                                  ;   63    3  226 word   digit
  5839                                  ;   64   35  227 word   eqstr
  5840                                  ;   65    3  230 word   strcat1
  5841                                  ;   66    1  231 word   openR
  5842                                  ;   67    2  232 word   creatR
  5843                                  ;   68    2  233 word   readRL
  5844                                  ;   69    2  234 word   fputcR
  5845                                  ;   70    3  236 word   fcloseR
  5846                                  ;   71    5  237 word   exitR
  5847                                  ;   72    1  239 word   putch
  5848                                  ;   73    4  240 word   DosInt
  5849                                  ;   74 NULL  241 word   LastFunctionByt
  5850                                  
  5851                                  ;    #  addr name   list of CALLs
  5852                                  
  5853                                  ;    0     5 getarg
  5854                                  ;    1    12 parse
  5855                                  ;    2    18 epilog
  5856                                  ;    3    25 end1
  5857                                  ;    4  1364 getTokeType
  5858                                  ;    5  1376 getCodeSize
  5859                                  ;    6  1388 genInstruction
  5860                                  ;    7  1403 checkLeftOp
  5861                                  ;    8  1415 genInstruction
  5862                                  ;    9  1430 genInstruction
  5863                                  ;   10  1445 genInstruction
  5864                                  ;   11  1460 genCodeInREG
  5865                                  ;   12  1473 checkLeftOp
  5866                                  ;   13  1485 genInstruction
  5867                                  ;   14  1500 genCodeInREG
  5868                                  ;   15  1513 genInstruction
  5869                                  ;   16  1528 genCode16
  5870                                  ;   17  1538 genInstruction
  5871                                  ;   18  1553 error1
  5872                                  ;   19  1560 error1
  5873                                  ;   20  1576 gen66h
  5874                                  ;   21  1620 getOp
  5875                                  ;   22  1626 segregerror
  5876                                  ;   23  1638 setwflag
  5877                                  ;   24  1647 error1
  5878                                  ;   25  1654 error1
  5879                                  ;   26  1661 error1
  5880                                  ;   27  1703 getOp1
  5881                                  ;   28  1710 isToken
  5882                                  ;   29  1718 getMEM
  5883                                  ;   30  1725 error1
  5884                                  ;   31  1732 error1
  5885                                  ;   32  1746 testReg
  5886                                  ;   33  1754 searchLabel
  5887                                  ;   34  1766 error1
  5888                                  ;   35  1784 getTokeType
  5889                                  ;   36  1796 getOp1
  5890                                  ;   37  1803 syntaxerror
  5891                                  ;   38  1815 getIndReg2
  5892                                  ;   39  1826 getIndReg1
  5893                                  ;   40  1837 isToken
  5894                                  ;   41  1845 getTokeType
  5895                                  ;   42  1857 numbererror
  5896                                  ;   43  1869 isToken
  5897                                  ;   44  1877 isToken
  5898                                  ;   45  1885 errorexit
  5899                                  ;   46  1906 indexerror
  5900                                  ;   47  1917 indexerror
  5901                                  ;   48  1941 indexerror
  5902                                  ;   49  1952 indexerror
  5903                                  ;   50  1987 genCode8
  5904                                  ;   51  2003 genCode8
  5905                                  ;   52  2035 genCode8
  5906                                  ;   53  2044 genCode8
  5907                                  ;   54  2068 writeEA
  5908                                  ;   55  2088 writeEA
  5909                                  ;   56  2112 addrexit
  5910                                  ;   57  2121 genCode8
  5911                                  ;   58  2130 genCode8
  5912                                  ;   59  2139 genCode16
  5913                                  ;   60  2161 getLine
  5914                                  ;   61  2169 getTokeType
  5915                                  ;   62  2181 storeLabel
  5916                                  ;   63  2192 getTokeType
  5917                                  ;   64  2204 lookCode
  5918                                  ;   65  2213 process
  5919                                  ;   66  2221 getVariable
  5920                                  ;   67  2233 skipRest
  5921                                  ;   68  2242 error1
  5922                                  ;   69  2249 error1
  5923                                  ;   70  2256 printLine
  5924                                  ;   71  2280 skipBlank
  5925                                  ;   72  2290 digit
  5926                                  ;   73  2296 getDigit
  5927                                  ;   74  2305 letterE
  5928                                  ;   75  2313 getName
  5929                                  ;   76  2332 searchLabel
  5930                                  ;   77  2344 error1
  5931                                  ;   78  2351 strcpy
  5932                                  ;   79  2378 eqstr
  5933                                  ;   80  2384 strlen
  5934                                  ;   81  2405 storeLabel
  5935                                  ;   82  2416 getTokeType
  5936                                  ;   83  2428 lookCode
  5937                                  ;   84  2437 errorexit
  5938                                  ;   85  2447 errorexit
  5939                                  ;   86  2457 getTokeType
  5940                                  ;   87  2469 genCode8
  5941                                  ;   88  2478 skipBlank
  5942                                  ;   89  2488 isToken
  5943                                  ;   90  2496 genCode8
  5944                                  ;   91  2505 isToken
  5945                                  ;   92  2513 getTokeType
  5946                                  ;   93  2525 genCode16
  5947                                  ;   94  2535 isToken
  5948                                  ;   95  2543 errorexit
  5949                                  ;   96  2562 eqstr
  5950                                  ;   97  2580 eqstr
  5951                                  ;   98  2586 getTokeType
  5952                                  ;   99  2598 eqstr
  5953                                  ;  100  2604 getTokeType
  5954                                  ;  101  2616 eqstr
  5955                                  ;  102  2622 getTokeType
  5956                                  ;  103  2644 skipBlank
  5957                                  ;  104  2663 getTokeType
  5958                                  ;  105  2675 error1
  5959                                  ;  106  2690 readRL
  5960                                  ;  107  2697 errorexit
  5961                                  ;  108  2707 ifEOL
  5962                                  ;  109  2721 readRL
  5963                                  ;  110  2757 digit
  5964                                  ;  111  2763 letterE
  5965                                  ;  112  2790 digit
  5966                                  ;  113  2808 alnumE
  5967                                  ;  114  2815 strcpy
  5968                                  ;  115  2822 toupper
  5969                                  ;  116  2838 strlen
  5970                                  ;  117  2845 strlen
  5971                                  ;  118  2852 eqstr
  5972                                  ;  119  2858 eqstr
  5973                                  ;  120  2864 eqstr
  5974                                  ;  121  2870 eqstr
  5975                                  ;  122  2876 eqstr
  5976                                  ;  123  2882 eqstr
  5977                                  ;  124  2888 eqstr
  5978                                  ;  125  2894 eqstr
  5979                                  ;  126  2900 eqstr
  5980                                  ;  127  2906 eqstr
  5981                                  ;  128  2912 eqstr
  5982                                  ;  129  2918 eqstr
  5983                                  ;  130  2924 eqstr
  5984                                  ;  131  2930 eqstr
  5985                                  ;  132  2936 eqstr
  5986                                  ;  133  2942 eqstr
  5987                                  ;  134  2948 eqstr
  5988                                  ;  135  2954 eqstr
  5989                                  ;  136  2960 eqstr
  5990                                  ;  137  2966 eqstr
  5991                                  ;  138  2972 eqstr
  5992                                  ;  139  2978 eqstr
  5993                                  ;  140  2984 eqstr
  5994                                  ;  141  2990 eqstr
  5995                                  ;  142  2996 eqstr
  5996                                  ;  143  3002 eqstr
  5997                                  ;  144  3008 eqstr
  5998                                  ;  145  3014 eqstr
  5999                                  ;  146  3020 eqstr
  6000                                  ;  147  3026 eqstr
  6001                                  ;  148  3046 prs
  6002                                  ;  149  3050 printhex16
  6003                                  ;  150  3061 prs
  6004                                  ;  151  3065 prc
  6005                                  ;  152  3069 printhex8a
  6006                                  ;  153  3080 prc
  6007                                  ;  154  3084 prs
  6008                                  ;  155  3088 prscomment
  6009                                  ;  156  3105 writetty
  6010                                  ;  157  3114 writetty
  6011                                  ;  158  3123 fputcR
  6012                                  ;  159  3145 prc
  6013                                  ;  160  3161 prc
  6014                                  ;  161  3182 prc
  6015                                  ;  162  3186 prc
  6016                                  ;  163  3208 printhex8a
  6017                                  ;  164  3219 printhex8a
  6018                                  ;  165  3244 printIntU
  6019                                  ;  166  3254 prc
  6020                                  ;  167  3267 prs
  6021                                  ;  168  3271 prs
  6022                                  ;  169  3275 prs
  6023                                  ;  170  3279 prs
  6024                                  ;  171  3296 error1
  6025                                  ;  172  3314 error1
  6026                                  ;  173  3332 error1
  6027                                  ;  174  3351 error1
  6028                                  ;  175  3370 error1
  6029                                  ;  176  3389 error1
  6030                                  ;  177  3408 error1
  6031                                  ;  178  3427 error1
  6032                                  ;  179  3434 end1
  6033                                  ;  180  3448 errorexit
  6034                                  ;  181  3469 errorexit
  6035                                  ;  182  3498 cputs
  6036                                  ;  183  3504 cputs
  6037                                  ;  184  3510 exitR
  6038                                  ;  185  3516 toupper
  6039                                  ;  186  3524 strcpy
  6040                                  ;  187  3531 strcat1
  6041                                  ;  188  3539 strcpy
  6042                                  ;  189  3546 strcat1
  6043                                  ;  190  3554 strcpy
  6044                                  ;  191  3561 strcat1
  6045                                  ;  192  3569 openR
  6046                                  ;  193  3575 cputs
  6047                                  ;  194  3581 cputs
  6048                                  ;  195  3587 exitR
  6049                                  ;  196  3593 creatR
  6050                                  ;  197  3600 cputs
  6051                                  ;  198  3606 cputs
  6052                                  ;  199  3612 exitR
  6053                                  ;  200  3618 creatR
  6054                                  ;  201  3625 cputs
  6055                                  ;  202  3631 cputs
  6056                                  ;  203  3637 exitR
  6057                                  ;  204  3643 prs
  6058                                  ;  205  3647 prs
  6059                                  ;  206  3651 prs
  6060                                  ;  207  3655 prs
  6061                                  ;  208  3659 prs
  6062                                  ;  209  3663 prs
  6063                                  ;  210  3667 prs
  6064                                  ;  211  3671 prs
  6065                                  ;  212  3675 prs
  6066                                  ;  213  3692 prs
  6067                                  ;  214  3696 printIntU
  6068                                  ;  215  3706 prs
  6069                                  ;  216  3710 prs
  6070                                  ;  217  3714 prs
  6071                                  ;  218  3718 prc
  6072                                  ;  219  3722 printhex16
  6073                                  ;  220  3733 prs
  6074                                  ;  221  3737 strlen
  6075                                  ;  222  3744 prs
  6076                                  ;  223  3748 printIntU
  6077                                  ;  224  3758 prs
  6078                                  ;  225  3762 prc
  6079                                  ;  226  3766 printhex8a
  6080                                  ;  227  3777 fputcR
  6081                                  ;  228  3791 fcloseR
  6082                                  ;  229  3799 fcloseR
  6083                                  ;  230  3807 fcloseR
  6084                                  ;  231  3815 exitR
  6085                                  ;  232  3840 putch
  6086                                  ;  233  3908 strcpy
  6087                                  ;  234  3923 DosInt
  6088                                  ;  235  3939 DosInt
  6089                                  ;  236  3962 DosInt
  6090                                  ;  237  3981 DosInt
  6091                                  ;  238  4015 writetty
  6092                                  ;  239  4024 writetty
  6093                                  ;Input: AS.C, List: AS.S,  Lines:  242
  6094                                  ;Glob. variables:  188 max.:  200
  6095                                  ;Local variables:    3 max.:  100, in 'genInstruction'
  6096                                  ;Functions      :   75 max.:  300
  6097                                  ;Calls          :  240 max.: 2000, NameField: 4056 max.:    65535
  6098                                  ;Code until     :26009 max.: 30000, free: 3991
  6099                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6100                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
