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
    11 00000003 E8CD1A                   call getarg
    12 00000006 E82D0B                   call parse
    13 00000009 E81F1D                   call epilog
    14 0000000C E88C1E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 24.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 24.1.2016",0
    21 00000019 372032342E312E3230-
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
   159                                  ;-32 #define IMM      1      //const  ,123
   160                                  
   161                                  
   162                                  ;-33 #define REG      2      //       ,BX    mode=11
   163                                  
   164                                  
   165                                  ;-34 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110
   166                                  
   167                                  
   168                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   169                                  
   170                                  
   171                                  ;-36 char Op1;               //0, IMM, REG, ADR, MEM
   172                                  
   173 0000003D 00                      Op1 db 0
   174                                  
   175                                  ;-37 char CodeType;          //1-207 by searchSymbol(), must be byte size
   176                                  
   177 0000003E 00                      CodeType db 0
   178                                  
   179                                  ;-38 char Code1;             // first  Opcode
   180                                  
   181 0000003F 00                      Code1 db 0
   182                                  
   183                                  ;-39 char Code2;             // second Opcode
   184                                  
   185 00000040 00                      Code2 db 0
   186                                  
   187                                  ;-40 char Code3;             // third  Opcode
   188                                  
   189 00000041 00                      Code3 db 0
   190                                  
   191                                  ;-41 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   192                                  
   193 00000042 00                      RegType db 0
   194                                  
   195                                  ;-42 char RegNo;             //0 - 7 AL, CL, ...  by testReg()
   196                                  
   197 00000043 00                      RegNo db 0
   198                                  
   199                                  ;-43 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   200                                  
   201 00000044 00                      OpSize db 0
   202                                  
   203                                  ;-44 char wflag;             //0=byte, 1=word/dword
   204                                  
   205 00000045 00                      wflag db 0
   206                                  
   207                                  ;-45 //char AddrSize;          //67h:
   208                                  
   209                                  
   210                                  ;-46 //char NumOprns;          //0-2
   211                                  
   212                                  
   213                                  ;-47 //char dflag;             //0=source is reg,  1=dest is reg
   214                                  
   215                                  
   216                                  ;-48 //char modrm;           //mod, r/m
   217                                  
   218                                  
   219                                  ;-49 char regindexbase;      //combination of index and base reg
   220                                  
   221 00000046 00                      regindexbase db 0
   222                                  
   223                                  ;-50 char isDirect;          //is direct addressing
   224                                  
   225 00000047 00                      isDirect db 0
   226                                  
   227                                  ;-51 int disp;               //displacement      0-8 bytes
   228                                  
   229 00000048 0000                    disp dw 0
   230                                  
   231                                  ;-52 int imme;               //immediate         0-8 bytes
   232                                  
   233 0000004A 0000                    imme dw 0
   234                                  
   235                                  ;-53 
   236                                  
   237                                  
   238                                  ;-54 #define OPMAXLEN 5
   239                                  
   240                                  
   241                                  ;-55 char OpPos[OPMAXLEN];   //array for one opcode to list
   242                                  
   243                                  section .bss
   244                                  absolute 30390
   245 000076B6 <res 00000005>          OpPos resb 5
   246                                  section .text
   247                                  
   248                                  ;-56 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   249                                  
   250 0000004C 0000                    OpPrintIndex dw 0
   251                                  
   252                                  ;-57 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   253                                  
   254 0000004E 0000                    OpCodePtr dw 0
   255                                  
   256                                  ;-58 char PrintR;           //print 'R' if relocative
   257                                  
   258 00000050 00                      PrintR db 0
   259                                  
   260                                  ;-59 
   261                                  
   262                                  
   263                                  ;-60 #define LABELNAMESMAX 969//next number - 31
   264                                  
   265                                  
   266                                  ;-61 char LabelNames[1000];  //space for names of all labels
   267                                  
   268                                  section .bss
   269                                  absolute 30395
   270 000076BB <res 000003E8>          LabelNames resb 1000
   271                                  section .text
   272                                  
   273                                  ;-62 char *LabelNamePtr;     // first free position
   274                                  
   275 00000051 0000                    LabelNamePtr dw 0
   276                                  
   277                                  ;-63 #define LABELADRMAX 100
   278                                  
   279                                  
   280                                  ;-64 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   281                                  
   282                                  section .bss
   283                                  absolute 31395
   284 00007AA3 <res 000000C8>          LabelAddr resw 100
   285                                  section .text
   286                                  
   287                                  ;-65 int LabelMaxIx=0;       //actual number of stored labels
   288                                  
   289 00000053 0000                    LabelMaxIx dw 0
   290                                  
   291                                  ;-66 int LabelIx;            //actual number of just searched label
   292                                  
   293 00000055 0000                    LabelIx dw 0
   294                                  
   295                                  ;-67 
   296                                  
   297                                  
   298                                  ;-68 #define FILEBINMAX 1990 //next number - max. oplemgth
   299                                  
   300                                  
   301                                  ;-69 char FileBin  [2000];   //output binary file
   302                                  
   303                                  section .bss
   304                                  absolute 31595
   305 00007B6B <res 000007D0>          FileBin resb 2000
   306                                  section .text
   307                                  
   308                                  ;-70 unsigned int BinLen=0;  //length of binary file
   309                                  
   310 00000057 0000                    BinLen dw 0
   311                                  
   312                                  ;-71 
   313                                  
   314                                  
   315                                  ;-72 char *arglen=0x80;      // for main only
   316                                  
   317 00000059 8000                    arglen dw 128
   318                                  
   319                                  ;-73 char *argv=0x82;        // for main only
   320                                  
   321 0000005B 8200                    argv dw 130
   322                                  ;Back to main program: AS.C
   323                                  
   324                                  ;-4 #include "OPTABL.C"
   325                                  
   326                                  ;Use include file: OPTABL.C
   327                                  
   328                                  ;-1 char I_START=0xF1;
   329                                  
   330 0000005D F1                      I_START db 241
   331                                  
   332                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   333                                  
   334                                  
   335                                  ;-3 //  1:   1 byte opcode
   336                                  
   337                                  
   338                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   339                                  
   340 0000005E 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   341                                  
   342                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   343                                  
   344 00000067 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   345                                  
   346                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   347                                  
   348 0000006F 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   349                                  
   350                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   351                                  
   352 00000076 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   353                                  
   354                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   355                                  
   356 0000007D 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   357                                  
   358                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   359                                  
   360 00000085 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   361                                  
   362                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   363                                  
   364 0000008C 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   365                                  
   366                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   367                                  
   368 00000093 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   369                                  
   370                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   371                                  
   372 0000009B 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   373                                  
   374                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   375                                  
   376 000000A4 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   377                                  
   378                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   379                                  
   380 000000AC 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   381                                  
   382                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   383                                  
   384 000000B4 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   385                                  
   386                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   387                                  
   388 000000BC 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   389                                  
   390                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   391                                  
   392 000000C5 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   393                                  
   394                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   395                                  
   396 000000CE 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   397                                  
   398                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   399                                  
   400 000000D7 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   401                                  
   402                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   403                                  
   404 000000E0 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   405                                  
   406                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   407                                  
   408 000000E9 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   409                                  
   410                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   411                                  
   412 000000F2 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   413                                  
   414                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   415                                  
   416 000000FB 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   417                                  
   418                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   419                                  
   420 00000104 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   421                                  
   422                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   423                                  
   424 0000010D 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   425                                  
   426                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   427                                  
   428 00000116 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   429                                  
   430                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   431                                  
   432 0000011F 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   433                                  
   434                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   435                                  
   436 00000127 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   437                                  
   438                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   439                                  
   440 0000012F 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   441                                  
   442                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   443                                  
   444 00000137 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   445                                  
   446                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   447                                  
   448 00000140 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   449                                  
   450                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   451                                  
   452 00000149 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   453                                  
   454                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   455                                  
   456 00000151 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   457                                  
   458                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   459                                  
   460 00000159 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   461                                  
   462                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   463                                  
   464 00000160 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   465                                  
   466                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   467                                  
   468 00000167 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   469                                  
   470                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   471                                  
   472 0000016E 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   473                                  
   474                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   475                                  
   476 00000175 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   477                                  
   478                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   479                                  
   480 0000017C 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   481                                  
   482                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   483                                  
   484 00000183 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   485                                  
   486                                  ;-41 // 52: mem reg 16 bit
   487                                  
   488                                  
   489                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   490                                  
   491 0000018A 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   492                                  
   493                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   494                                  
   495 00000193 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   496                                  
   497                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,0xF1};
   498                                  
   499 0000019C 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   500                                  
   501                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,0xF1};
   502                                  
   503 000001A4 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   504                                  
   505                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,0xF1};
   506                                  
   507 000001AC 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   508                                  
   509                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,0xF1};//only acc
   510                                  
   511 000001B4 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   512                                  
   513                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,0xF1};
   514                                  
   515 000001BD 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   516                                  
   517                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,0xF1};
   518                                  
   519 000001C5 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   520                                  
   521                                  ;-50 //  3: les, lda, lea
   522                                  
   523                                  
   524                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16
   525                                  
   526 000001CE 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   527                                  
   528                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16
   529                                  
   530 000001D5 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   531                                  
   532                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16
   533                                  
   534 000001DC 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   535                                  
   536                                  ;-54 //  4: acc,imm  reg,imm  index,reg
   537                                  
   538                                  
   539                                  ;-55 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   540                                  
   541 000001E3 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   542                                  
   543                                  ;-56 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   544                                  
   545 000001EA 4F52000401F1            I_OR db 79,82,0,4,1,241
   546                                  
   547                                  ;-57 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   548                                  
   549 000001F0 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   550                                  
   551                                  ;-58 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   552                                  
   553 000001F7 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   554                                  
   555                                  ;-59 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   556                                  
   557 000001FE 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   558                                  
   559                                  ;-60 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   560                                  
   561 00000205 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   562                                  
   563                                  ;-61 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   564                                  
   565 0000020C 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   566                                  
   567                                  ;-62 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   568                                  
   569 00000213 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   570                                  
   571                                  ;-63 //  5: mov
   572                                  
   573                                  
   574                                  ;-64 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   575                                  
   576 0000021A 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   577                                  
   578                                  ;-65 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   579                                  
   580 00000220 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   581                                  
   582                                  ;-66 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   583                                  
   584 00000229 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   585                                  
   586                                  ;-67 //  6: single byte relative jump
   587                                  
   588                                  
   589                                  ;-68 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   590                                  
   591 00000232 4A4F000600F1            I_JO db 74,79,0,6,0,241
   592                                  
   593                                  ;-69 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   594                                  
   595 00000238 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   596                                  
   597                                  ;-70 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   598                                  
   599 0000023F 4A42000602F1            I_JB db 74,66,0,6,2,241
   600                                  
   601                                  ;-71 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   602                                  
   603 00000245 4A43000602F1            I_JC db 74,67,0,6,2,241
   604                                  
   605                                  ;-72 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   606                                  
   607 0000024B 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   608                                  
   609                                  ;-73 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   610                                  
   611 00000252 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   612                                  
   613                                  ;-74 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   614                                  
   615 00000259 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   616                                  
   617                                  ;-75 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   618                                  
   619 00000260 4A45000604F1            I_JE db 74,69,0,6,4,241
   620                                  
   621                                  ;-76 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   622                                  
   623 00000266 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   624                                  
   625                                  ;-77 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   626                                  
   627 0000026C 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   628                                  
   629                                  ;-78 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   630                                  
   631 00000273 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   632                                  
   633                                  ;-79 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   634                                  
   635 0000027A 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   636                                  
   637                                  ;-80 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   638                                  
   639 00000281 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   640                                  
   641                                  ;-81 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   642                                  
   643 00000288 4A41000607F1            I_JA db 74,65,0,6,7,241
   644                                  
   645                                  ;-82 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   646                                  
   647 0000028E 4A53000608F1            I_JS db 74,83,0,6,8,241
   648                                  
   649                                  ;-83 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   650                                  
   651 00000294 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   652                                  
   653                                  ;-84 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   654                                  
   655 0000029B 4A5000060AF1            I_JP db 74,80,0,6,10,241
   656                                  
   657                                  ;-85 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   658                                  
   659 000002A1 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   660                                  
   661                                  ;-86 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   662                                  
   663 000002A8 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   664                                  
   665                                  ;-87 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   666                                  
   667 000002AF 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   668                                  
   669                                  ;-88 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   670                                  
   671 000002B6 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   672                                  
   673                                  ;-89 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   674                                  
   675 000002BC 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   676                                  
   677                                  ;-90 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   678                                  
   679 000002C3 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   680                                  
   681                                  ;-91 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   682                                  
   683 000002CA 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   684                                  
   685                                  ;-92 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   686                                  
   687 000002D1 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   688                                  
   689                                  ;-93 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   690                                  
   691 000002D8 4A4700060FF1            I_JG db 74,71,0,6,15,241
   692                                  
   693                                  ;-94 //  7: jmp, call
   694                                  
   695                                  
   696                                  ;-95 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   697                                  
   698 000002DE 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   699                                  
   700                                  ;-96 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   701                                  
   702 000002E6 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   703                                  
   704                                  ;-97 //  8: ret
   705                                  
   706                                  
   707                                  ;-98 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   708                                  
   709 000002EF 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   710                                  
   711                                  ;-99 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   712                                  
   713 000002F7 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   714                                  
   715                                  ;-100 //  9: seg, r/m
   716                                  
   717                                  
   718                                  ;-101 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   719                                  
   720 00000300 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   721                                  
   722                                  ;-102 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   723                                  
   724 00000308 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   725                                  
   726                                  ;-103 //  11: shift, rotates
   727                                  
   728                                  
   729                                  ;-104 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   730                                  
   731 0000030F 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   732                                  
   733                                  ;-105 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   734                                  
   735 00000316 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   736                                  
   737                                  ;-106 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   738                                  
   739 0000031D 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   740                                  
   741                                  ;-107 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   742                                  
   743 00000324 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   744                                  
   745                                  ;-108 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   746                                  
   747 0000032B 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   748                                  
   749                                  ;-109 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   750                                  
   751 00000332 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   752                                  
   753                                  ;-110 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   754                                  
   755 00000339 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   756                                  
   757                                  ;-111 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   758                                  
   759 00000340 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   760                                  
   761                                  ;-112 //  12: int
   762                                  
   763                                  
   764                                  ;-113 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   765                                  
   766 00000347 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   767                                  
   768                                  ;-114 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   769                                  
   770 0000034F 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   771                                  
   772                                  ;-115 //  14: in/out
   773                                  
   774                                  
   775                                  ;-116 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   776                                  
   777 00000357 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   778                                  
   779                                  ;-117 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   780                                  
   781 0000035E 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   782                                  
   783                                  ;-118 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   784                                  
   785 00000366 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   786                                  
   787                                  ;-119 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   788                                  
   789 0000036E 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   790                                  
   791                                  ;-120 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   792                                  
   793 00000376 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   794                                  
   795                                  ;-121 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   796                                  
   797 0000037E 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   798                                  
   799                                  ;-122 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   800                                  
   801 00000386 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   802                                  
   803                                  ;-123 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   804                                  
   805 0000038E 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   806                                  
   807                                  ;-124 //  15: xchg
   808                                  
   809                                  
   810                                  ;-125 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   811                                  
   812 00000396 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   813                                  
   814                                  ;-126 //  16: loop, jcxz
   815                                  
   816                                  
   817                                  ;-127 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   818                                  
   819 0000039F 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   820 000003A8 F1                 
   821                                  
   822                                  ;-128 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   823                                  
   824 000003A9 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   825 000003B2 F1                 
   826                                  
   827                                  ;-129 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   828                                  
   829 000003B3 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   830                                  
   831                                  ;-130 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   832                                  
   833 000003BC 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   834                                  
   835                                  ;-131 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   836                                  
   837 000003C5 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   838                                  
   839                                  ;-132 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   840                                  
   841 000003CD 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   842                                  
   843                                  ;-133 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   844                                  
   845 000003D5 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   846                                  
   847                                  ;-134 //  30: enter
   848                                  
   849                                  
   850                                  ;-135 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   851                                  
   852 000003DE 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   853                                  
   854                                  ;-136 // 100: directives
   855                                  
   856                                  
   857                                  ;-137 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   858                                  
   859 000003E7 4F52470065F1            I_ORG db 79,82,71,0,101,241
   860                                  
   861                                  ;-138 char I_DB[]=   {'D','B',0,            200,        0xF1};
   862                                  
   863 000003ED 444200C8F1              I_DB db 68,66,0,200,241
   864                                  
   865                                  ;-139 char I_DW[]=   {'D','W',0,            201,        0xF1};
   866                                  
   867 000003F2 445700C9F1              I_DW db 68,87,0,201,241
   868                                  
   869                                  ;-140 char I_DD[]=   {'D','D',0,            202,        0xF1};
   870                                  
   871 000003F7 444400CAF1              I_DD db 68,68,0,202,241
   872                                  
   873                                  ;-141 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   874                                  
   875 000003FC 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   876                                  
   877                                  ;-142 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   878                                  
   879 00000403 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   880                                  
   881                                  ;-143 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   882                                  
   883 0000040A 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   884                                  
   885                                  ;-144 char I_END=0;// end of table char
   886                                  
   887 00000411 00                      I_END db 0
   888                                  ;Back to main program: AS.C
   889                                  
   890                                  ;-5 
   891                                  
   892                                  
   893                                  ;-6 int process() {
   894                                  
   895                                  
   896                                  process:  ; *** PROC ***
   897                                  
   898                                  ;-7   getTokeType();//0, DIGIT, ALNUME, NOALNUME
   899                                  
   900 00000412 E80B08                   call getTokeType
   901                                  
   902                                  ;-8   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
   903                                  
   904 00000415 E8020B                   call getCodeSize
   905 00000418 A2[4400]                 mov byte [OpSize], al
   906                                  
   907                                  ;-9   getCodes();//set: Code1, Code2, Code3
   908                                  
   909 0000041B E86405                   call getCodes
   910                                  
   911                                  ;-10 
   912                                  
   913                                  
   914                                  ;-11   if (CodeType ==  1) {//1 byte opcode
   915                                  
   916 0000041E A0[3E00]                 mov al, [CodeType]
   917 00000421 3C01                     cmp al, 1
   918 00000423 0F850F00                 jne @@process1
   919                                  
   920                                  ;-12     genCode8(Code1);
   921                                  
   922 00000427 A0[3F00]                 mov al, byte [Code1]
   923 0000042A B400                     mov ah, 0
   924 0000042C 50                       push ax
   925 0000042D E8A405                   call genCode8
   926 00000430 83C402                   add  sp, 2
   927                                  
   928                                  ;-13     return;
   929                                  
   930 00000433 E9E200                   jmp @@retn
   931                                  
   932                                  ;-14   }
   933                                  
   934                                  
   935                                  ;-15   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
   936                                  
   937                                  @@process1:
   938 00000436 A0[3E00]                 mov al, [CodeType]
   939 00000439 3C02                     cmp al, 2
   940 0000043B 0F857200                 jne @@process2
   941                                  
   942                                  ;-16     checkLeftOp();
   943                                  
   944 0000043F E85C01                   call checkLeftOp
   945                                  
   946                                  ;-17       if (Code2 <= 1) {//inc,dec
   947                                  
   948 00000442 A0[4000]                 mov al, [Code2]
   949 00000445 3C01                     cmp al, 1
   950 00000447 0F8F4500                 jg  @@process3
   951                                  
   952                                  ;-18     	if (Op1 == REG) {
   953                                  
   954 0000044B A0[3D00]                 mov al, [Op1]
   955 0000044E 3C02                     cmp al, 2
   956 00000450 0F853C00                 jne @@process4
   957                                  
   958                                  ;-19         if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
   959                                  
   960 00000454 A0[4200]                 mov al, [RegType]
   961 00000457 3C02                     cmp al, 2
   962 00000459 0F851500                 jne @@process5
   963 0000045D A0[4300]                 mov al, byte [RegNo]
   964 00000460 B400                     mov ah, 0
   965 00000462 50                       push ax
   966 00000463 A0[4100]                 mov al, byte [Code3]
   967 00000466 B400                     mov ah, 0
   968 00000468 50                       push ax
   969 00000469 E84D05                   call genCode
   970 0000046C 83C404                   add  sp, 4
   971 0000046F E9A600                   jmp @@retn
   972                                  
   973                                  ;-20         if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
   974                                  
   975                                  @@process5:
   976 00000472 A0[4200]                 mov al, [RegType]
   977 00000475 3C03                     cmp al, 3
   978 00000477 0F851500                 jne @@process6
   979 0000047B A0[4300]                 mov al, byte [RegNo]
   980 0000047E B400                     mov ah, 0
   981 00000480 50                       push ax
   982 00000481 A0[4100]                 mov al, byte [Code3]
   983 00000484 B400                     mov ah, 0
   984 00000486 50                       push ax
   985 00000487 E82F05                   call genCode
   986 0000048A 83C404                   add  sp, 4
   987 0000048D E98800                   jmp @@retn
   988                                  
   989                                  ;-21         }
   990                                  
   991                                  @@process6:
   992                                  
   993                                  ;-22       }
   994                                  
   995                                  @@process4:
   996                                  
   997                                  ;-23       genCode(Code1, wflag);
   998                                  
   999                                  @@process3:
  1000 00000490 A0[4500]                 mov al, byte [wflag]
  1001 00000493 B400                     mov ah, 0
  1002 00000495 50                       push ax
  1003 00000496 A0[3F00]                 mov al, byte [Code1]
  1004 00000499 B400                     mov ah, 0
  1005 0000049B 50                       push ax
  1006 0000049C E81A05                   call genCode
  1007 0000049F 83C404                   add  sp, 4
  1008                                  
  1009                                  ;-24       writeEA(Code2);
  1010                                  
  1011 000004A2 A0[4000]                 mov al, byte [Code2]
  1012 000004A5 B400                     mov ah, 0
  1013 000004A7 50                       push ax
  1014 000004A8 E87C05                   call writeEA
  1015 000004AB 83C402                   add  sp, 2
  1016                                  
  1017                                  ;-25       return;
  1018                                  
  1019 000004AE E96700                   jmp @@retn
  1020                                  
  1021                                  ;-26   }
  1022                                  
  1023                                  
  1024                                  ;-27  
  1025                                  
  1026                                  
  1027                                  ;-28   if (CodeType ==  8) {//ret,retf
  1028                                  
  1029                                  @@process2:
  1030 000004B1 A0[3E00]                 mov al, [CodeType]
  1031 000004B4 3C08                     cmp al, 8
  1032 000004B6 0F853100                 jne @@process7
  1033                                  
  1034                                  ;-29     if (TokeType == DIGIT) {
  1035                                  
  1036 000004BA A0[3C00]                 mov al, [TokeType]
  1037 000004BD 3C01                     cmp al, 1
  1038 000004BF 0F851900                 jne @@process8
  1039                                  
  1040                                  ;-30       genCode8(Code2);
  1041                                  
  1042 000004C3 A0[4000]                 mov al, byte [Code2]
  1043 000004C6 B400                     mov ah, 0
  1044 000004C8 50                       push ax
  1045 000004C9 E80805                   call genCode8
  1046 000004CC 83C402                   add  sp, 2
  1047                                  
  1048                                  ;-31       genCode16(SymbolInt);
  1049                                  
  1050 000004CF FF36[2600]               push word [SymbolInt]
  1051 000004D3 E83005                   call genCode16
  1052 000004D6 83C402                   add  sp, 2
  1053                                  
  1054                                  ;-32       return;
  1055                                  
  1056 000004D9 E93C00                   jmp @@retn
  1057                                  
  1058                                  ;-33     }
  1059                                  
  1060                                  
  1061                                  ;-34     genCode8(Code1); 
  1062                                  
  1063                                  @@process8:
  1064 000004DC A0[3F00]                 mov al, byte [Code1]
  1065 000004DF B400                     mov ah, 0
  1066 000004E1 50                       push ax
  1067 000004E2 E8EF04                   call genCode8
  1068 000004E5 83C402                   add  sp, 2
  1069                                  
  1070                                  ;-35     return;
  1071                                  
  1072 000004E8 E92D00                   jmp @@retn
  1073                                  
  1074                                  ;-36   }
  1075                                  
  1076                                  
  1077                                  ;-37 
  1078                                  
  1079                                  
  1080                                  ;-38   if (CodeType==101) {// ORG nn
  1081                                  
  1082                                  @@process7:
  1083 000004EB A0[3E00]                 mov al, [CodeType]
  1084 000004EE 3C65                     cmp al, 101
  1085 000004F0 0F851B00                 jne @@process9
  1086                                  
  1087                                  ;-39     if (TokeType != DIGIT) error1("only digit allowed");
  1088                                  
  1089 000004F4 A0[3C00]                 mov al, [TokeType]
  1090 000004F7 3C01                     cmp al, 1
  1091 000004F9 0F840900                 je  @@process10
  1092 000004FD 68[1905]                 push process_0
  1093 00000500 E84E14                   call error1
  1094 00000503 83C402                   add  sp, 2
  1095                                  
  1096                                  ;-40     PC=SymbolInt;return;
  1097                                  
  1098                                  @@process10:
  1099 00000506 A1[2600]                 mov ax, [SymbolInt]
  1100 00000509 A3[3700]                 mov word [PC], ax
  1101 0000050C E90900                   jmp @@retn
  1102                                  
  1103                                  ;-41   }
  1104                                  
  1105                                  
  1106                                  ;-42   error1("unknown CodeType");
  1107                                  
  1108                                  @@process9:
  1109 0000050F 68[2C05]                 push process_1
  1110 00000512 E83C14                   call error1
  1111 00000515 83C402                   add  sp, 2
  1112                                  
  1113                                  ;-43 }
  1114                                  
  1115                                  
  1116                                  ;-44 
  1117                                  
  1118                                  
  1119                                  ;-45 int setwflag() {//only Op1 (first operand)
  1120                                  
  1121                                  @@retn:
  1122 00000518 C3                       ret
  1123                                  ; ENDP
  1124 00000519 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1125 00000522 7420616C6C6F776564-
  1126 0000052B 00                 
  1127 0000052C 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1128 00000535 6F64655479706500   
  1129                                  
  1130                                  setwflag:  ; *** PROC ***
  1131                                  
  1132                                  ;-46   wflag=0;
  1133                                  
  1134 0000053D 66B800000000             mov eax, 0
  1135 00000543 A2[4500]                 mov byte [wflag], al
  1136                                  
  1137                                  ;-47   if (OpSize == 0) {//do not override OpSize
  1138                                  
  1139 00000546 A0[4400]                 mov al, [OpSize]
  1140 00000549 3C00                     cmp al, 0
  1141 0000054B 0F852100                 jne @@setwflag11
  1142                                  
  1143                                  ;-48     if (Op1 == REG) {
  1144                                  
  1145 0000054F A0[3D00]                 mov al, [Op1]
  1146 00000552 3C02                     cmp al, 2
  1147 00000554 0F851800                 jne @@setwflag12
  1148                                  
  1149                                  ;-49       OpSize=RegType;
  1150                                  
  1151 00000558 A0[4200]                 mov al, [RegType]
  1152 0000055B A2[4400]                 mov byte [OpSize], al
  1153                                  
  1154                                  ;-50       if (RegType == SEGREG) OpSize=WORD;
  1155                                  
  1156 0000055E A0[4200]                 mov al, [RegType]
  1157 00000561 3C04                     cmp al, 4
  1158 00000563 0F850900                 jne @@setwflag13
  1159 00000567 66B802000000             mov eax, 2
  1160 0000056D A2[4400]                 mov byte [OpSize], al
  1161                                  
  1162                                  ;-51     }
  1163                                  
  1164                                  @@setwflag13:
  1165                                  
  1166                                  ;-52   }
  1167                                  
  1168                                  @@setwflag12:
  1169                                  
  1170                                  ;-53   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1171                                  
  1172                                  @@setwflag11:
  1173 00000570 A0[4400]                 mov al, [OpSize]
  1174 00000573 3C03                     cmp al, 3
  1175 00000575 0F850C00                 jne @@setwflag14
  1176 00000579 E83404                   call gen66h
  1177 0000057C 66B801000000             mov eax, 1
  1178 00000582 A2[4500]                 mov byte [wflag], al
  1179                                  
  1180                                  ;-54   if (OpSize  ==  WORD) wflag=1;
  1181                                  
  1182                                  @@setwflag14:
  1183 00000585 A0[4400]                 mov al, [OpSize]
  1184 00000588 3C02                     cmp al, 2
  1185 0000058A 0F850900                 jne @@setwflag15
  1186 0000058E 66B801000000             mov eax, 1
  1187 00000594 A2[4500]                 mov byte [wflag], al
  1188                                  
  1189                                  ;-55 }
  1190                                  
  1191                                  @@setwflag15:
  1192                                  
  1193                                  ;-56 
  1194                                  
  1195                                  
  1196                                  ;-57 int Check2Op(char left, char rigth) {
  1197                                  
  1198 00000597 C3                       ret
  1199                                  ; ENDP
  1200                                  
  1201                                  Check2Op:  ; *** PROC ***
  1202                                  
  1203                                  ;-58 }
  1204                                  
  1205                                  ;Function : Check2Op, Number of local variables: 2
  1206                                  ;   # type sign width line used address name   list of local variables
  1207                                  ;  200 var sign byte    57 NULL bp+4    left
  1208                                  ;  201 var sign byte    57 NULL bp+6    rigth;
  1209 00000598 C8000000                 ENTER  0,0
  1210                                  
  1211                                  ;-59 int checkLeftOp() {
  1212 0000059C C9                       LEAVE
  1213 0000059D C3                       ret
  1214                                  ; ENDP
  1215                                  
  1216                                  checkLeftOp:  ; *** PROC ***
  1217                                  
  1218                                  ;-60   getOp();
  1219                                  
  1220 0000059E E8BA00                   call getOp
  1221                                  
  1222                                  ;-61   if (Op1 == ADR) implmerror();
  1223                                  
  1224 000005A1 A0[3D00]                 mov al, [Op1]
  1225 000005A4 3C03                     cmp al, 3
  1226 000005A6 0F850300                 jne @@checkLeftOp16
  1227 000005AA E81E14                   call implmerror
  1228                                  
  1229                                  ;-62   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1230                                  
  1231                                  @@checkLeftOp16:
  1232 000005AD A0[4200]                 mov al, [RegType]
  1233 000005B0 3C04                     cmp al, 4
  1234 000005B2 0F850600                 jne @@checkLeftOp17
  1235 000005B6 E89114                   call segregerror
  1236 000005B9 E95300                   jmp @@retn
  1237                                  
  1238                                  ;-63   setwflag();
  1239                                  
  1240                                  @@checkLeftOp17:
  1241 000005BC E87EFF                   call setwflag
  1242                                  
  1243                                  ;-64   if (OpSize == 0) error1("no op size declared");
  1244                                  
  1245 000005BF A0[4400]                 mov al, [OpSize]
  1246 000005C2 3C00                     cmp al, 0
  1247 000005C4 0F850900                 jne @@checkLeftOp18
  1248 000005C8 68[1006]                 push checkLeftOp_0
  1249 000005CB E88313                   call error1
  1250 000005CE 83C402                   add  sp, 2
  1251                                  
  1252                                  ;-65   if (OpSize == RegType) return;
  1253                                  
  1254                                  @@checkLeftOp18:
  1255 000005D1 A0[4400]                 mov al, [OpSize]
  1256 000005D4 3A06[4200]               cmp al, [RegType]
  1257 000005D8 0F850300                 jne @@checkLeftOp19
  1258 000005DC E93000                   jmp @@retn
  1259                                  
  1260                                  ;-66   if (OpSize){if (Op1 == MEM) return;
  1261                                  
  1262                                  @@checkLeftOp19:
  1263 000005DF A0[4400]                 mov al, [OpSize]
  1264 000005E2 08C0                     or  al, al
  1265 000005E4 0F841500                 je @@checkLeftOp20
  1266 000005E8 A0[3D00]                 mov al, [Op1]
  1267 000005EB 3C04                     cmp al, 4
  1268 000005ED 0F850300                 jne @@checkLeftOp21
  1269 000005F1 E91B00                   jmp @@retn
  1270                                  
  1271                                  ;-67     error1("Conflict OpSize and RegSize"); }
  1272                                  
  1273                                  @@checkLeftOp21:
  1274 000005F4 68[2406]                 push checkLeftOp_1
  1275 000005F7 E85713                   call error1
  1276 000005FA 83C402                   add  sp, 2
  1277                                  
  1278                                  ;-68   if (RegType==0) error1("no register defined");
  1279                                  
  1280                                  @@checkLeftOp20:
  1281 000005FD A0[4200]                 mov al, [RegType]
  1282 00000600 3C00                     cmp al, 0
  1283 00000602 0F850900                 jne @@checkLeftOp22
  1284 00000606 68[4006]                 push checkLeftOp_2
  1285 00000609 E84513                   call error1
  1286 0000060C 83C402                   add  sp, 2
  1287                                  
  1288                                  ;-69 }
  1289                                  
  1290                                  @@checkLeftOp22:
  1291                                  
  1292                                  ;-70 
  1293                                  
  1294                                  
  1295                                  ;-71 int saveLeftOp(){
  1296                                  
  1297                                  @@retn:
  1298 0000060F C3                       ret
  1299                                  ; ENDP
  1300 00000610 6E6F206F702073697A-     checkLeftOp_0 db "no op size declared",0
  1301 00000619 65206465636C617265-
  1302 00000622 6400               
  1303 00000624 436F6E666C69637420-     checkLeftOp_1 db "Conflict OpSize and RegSize",0
  1304 0000062D 4F7053697A6520616E-
  1305 00000636 642052656753697A65-
  1306 0000063F 00                 
  1307 00000640 6E6F20726567697374-     checkLeftOp_2 db "no register defined",0
  1308 00000649 657220646566696E65-
  1309 00000652 6400               
  1310                                  
  1311                                  saveLeftOp:  ; *** PROC ***
  1312                                  
  1313                                  ;-72 }
  1314                                  
  1315                                  
  1316                                  ;-73 int checkRightOp(char mode){
  1317                                  
  1318 00000654 C3                       ret
  1319                                  ; ENDP
  1320                                  
  1321                                  checkRightOp:  ; *** PROC ***
  1322                                  
  1323                                  ;-74 }
  1324                                  
  1325                                  ;Function : checkRightOp, Number of local variables: 1
  1326                                  ;   # type sign width line used address name   list of local variables
  1327                                  ;  200 var sign byte    73 NULL bp+4    mode;
  1328 00000655 C8000000                 ENTER  0,0
  1329                                  
  1330                                  ;-75 /*        Op      = 0, IMM, REG, ADR, MEM
  1331                                  
  1332                                  
  1333                                  ;-76 IMM       imme    = 0, SymbolInt    
  1334                                  
  1335                                  
  1336                                  ;-77 REG     R RegNo   = 0 - 7
  1337                                  
  1338                                  
  1339                                  ;-78 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  1340                                  
  1341                                  
  1342                                  ;-79 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  1343                                  
  1344                                  
  1345                                  ;-80 MEM       regindexbase = 0 - 7
  1346                                  
  1347                                  
  1348                                  ;-81 
  1349                                  
  1350                                  
  1351                                  ;-82           OpSize  = 0, BYTE, WORD, DWORD (set wflag)
  1352                                  
  1353                                  
  1354                                  ;-83 */
  1355                                  
  1356                                  
  1357                                  ;-84 int getOp() {
  1358 00000659 C9                       LEAVE
  1359 0000065A C3                       ret
  1360                                  ; ENDP
  1361                                  
  1362                                  getOp:  ; *** PROC ***
  1363                                  
  1364                                  ;-85 //set: op1=0,IMM,REG,ADR,MEM
  1365                                  
  1366                                  
  1367                                  ;-86   disp=0; imme=0; regindexbase=0; isDirect=1;
  1368                                  
  1369 0000065B 66B800000000             mov eax, 0
  1370 00000661 A3[4800]                 mov word [disp], ax
  1371 00000664 66B800000000             mov eax, 0
  1372 0000066A A3[4A00]                 mov word [imme], ax
  1373 0000066D 66B800000000             mov eax, 0
  1374 00000673 A2[4600]                 mov byte [regindexbase], al
  1375 00000676 66B801000000             mov eax, 1
  1376 0000067C A2[4700]                 mov byte [isDirect], al
  1377                                  
  1378                                  ;-87 
  1379                                  
  1380                                  
  1381                                  ;-88   Op1=getOp1();
  1382                                  
  1383 0000067F E8A800                   call getOp1
  1384 00000682 A2[3D00]                 mov byte [Op1], al
  1385                                  
  1386                                  ;-89   if (isToken('[')) {Op1 = MEM; getMEM();  return;}
  1387                                  
  1388 00000685 6A5B                     push 91
  1389 00000687 E81309                   call isToken
  1390 0000068A 83C402                   add  sp, 2
  1391 0000068D 08C0                     or  al, al
  1392 0000068F 0F840F00                 je @@getOp23
  1393 00000693 66B804000000             mov eax, 4
  1394 00000699 A2[3D00]                 mov byte [Op1], al
  1395 0000069C E81101                   call getMEM
  1396 0000069F E95200                   jmp @@retn
  1397                                  
  1398                                  ;-90   if (Op1 == 0) error1("Name of operand expected");
  1399                                  
  1400                                  @@getOp23:
  1401 000006A2 A0[3D00]                 mov al, [Op1]
  1402 000006A5 3C00                     cmp al, 0
  1403 000006A7 0F850900                 jne @@getOp24
  1404 000006AB 68[F506]                 push getOp_0
  1405 000006AE E8A012                   call error1
  1406 000006B1 83C402                   add  sp, 2
  1407                                  
  1408                                  ;-91   if (Op1 == IMM) {imme=SymbolInt;         return;}
  1409                                  
  1410                                  @@getOp24:
  1411 000006B4 A0[3D00]                 mov al, [Op1]
  1412 000006B7 3C01                     cmp al, 1
  1413 000006B9 0F850900                 jne @@getOp25
  1414 000006BD A1[2600]                 mov ax, [SymbolInt]
  1415 000006C0 A3[4A00]                 mov word [imme], ax
  1416 000006C3 E92E00                   jmp @@retn
  1417                                  
  1418                                  ;-92   if (Op1 == REG)                          return;
  1419                                  
  1420                                  @@getOp25:
  1421 000006C6 A0[3D00]                 mov al, [Op1]
  1422 000006C9 3C02                     cmp al, 2
  1423 000006CB 0F850300                 jne @@getOp26
  1424 000006CF E92200                   jmp @@retn
  1425                                  
  1426                                  ;-93   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}
  1427                                  
  1428                                  @@getOp26:
  1429 000006D2 A0[3D00]                 mov al, [Op1]
  1430 000006D5 3C03                     cmp al, 3
  1431 000006D7 0F851000                 jne @@getOp27
  1432 000006DB 8B1E[5500]               mov bx, [LabelIx]
  1433 000006DF D1E3                     shl bx, 1
  1434 000006E1 8B87A37A                 mov ax, [LabelAddr + bx]
  1435 000006E5 A3[4800]                 mov word [disp], ax
  1436 000006E8 E90900                   jmp @@retn
  1437                                  
  1438                                  ;-94   error1("Name of operand expected #1");
  1439                                  
  1440                                  @@getOp27:
  1441 000006EB 68[0E07]                 push getOp_1
  1442 000006EE E86012                   call error1
  1443 000006F1 83C402                   add  sp, 2
  1444                                  
  1445                                  ;-95 }
  1446                                  
  1447                                  
  1448                                  ;-96 
  1449                                  
  1450                                  
  1451                                  ;-97 int getOp1() {//scan for a single operand
  1452                                  
  1453                                  @@retn:
  1454 000006F4 C3                       ret
  1455                                  ; ENDP
  1456 000006F5 4E616D65206F66206F-     getOp_0 db "Name of operand expected",0
  1457 000006FE 706572616E64206578-
  1458 00000707 70656374656400     
  1459 0000070E 4E616D65206F66206F-     getOp_1 db "Name of operand expected #1",0
  1460 00000717 706572616E64206578-
  1461 00000720 706563746564202331-
  1462 00000729 00                 
  1463                                  
  1464                                  getOp1:  ; *** PROC ***
  1465                                  
  1466                                  ;-98 //return:0, IMM, REG, ADR (not MEM)
  1467                                  
  1468                                  
  1469                                  ;-99 //set   :RegType, RegNo by testReg
  1470                                  
  1471                                  
  1472                                  ;-100 //set   :LabelIx by searchLabel
  1473                                  
  1474                                  
  1475                                  ;-101   if (TokeType == 0)      return 0;
  1476                                  
  1477 0000072A A0[3C00]                 mov al, [TokeType]
  1478 0000072D 3C00                     cmp al, 0
  1479 0000072F 0F850900                 jne @@getOp128
  1480 00000733 66B800000000             mov eax, 0
  1481 00000739 E96000                   jmp @@retn
  1482                                  
  1483                                  ;-102   if (TokeType == DIGIT)  return IMM;
  1484                                  
  1485                                  @@getOp128:
  1486 0000073C A0[3C00]                 mov al, [TokeType]
  1487 0000073F 3C01                     cmp al, 1
  1488 00000741 0F850900                 jne @@getOp129
  1489 00000745 66B801000000             mov eax, 1
  1490 0000074B E94E00                   jmp @@retn
  1491                                  
  1492                                  ;-103   if (TokeType == ALNUME) {
  1493                                  
  1494                                  @@getOp129:
  1495 0000074E A0[3C00]                 mov al, [TokeType]
  1496 00000751 3C03                     cmp al, 3
  1497 00000753 0F853C00                 jne @@getOp130
  1498                                  
  1499                                  ;-104     RegNo=testReg();
  1500                                  
  1501 00000757 E8500B                   call testReg
  1502 0000075A A2[4300]                 mov byte [RegNo], al
  1503                                  
  1504                                  ;-105     if (RegType)          return REG;
  1505                                  
  1506 0000075D A0[4200]                 mov al, [RegType]
  1507 00000760 08C0                     or  al, al
  1508 00000762 0F840900                 je @@getOp131
  1509 00000766 66B802000000             mov eax, 2
  1510 0000076C E92D00                   jmp @@retn
  1511                                  
  1512                                  ;-106     LabelIx=searchLabel();
  1513                                  
  1514                                  @@getOp131:
  1515 0000076F E89605                   call searchLabel
  1516 00000772 A3[5500]                 mov word [LabelIx], ax
  1517                                  
  1518                                  ;-107     if (LabelIx)          return ADR;
  1519                                  
  1520 00000775 A1[5500]                 mov ax, [LabelIx]
  1521 00000778 08C0                     or  al, al
  1522 0000077A 0F840C00                 je @@getOp132
  1523 0000077E 66B803000000             mov eax, 3
  1524 00000784 E91500                   jmp @@retn
  1525                                  
  1526                                  ;-108     else error1("variable not found"); 
  1527                                  
  1528 00000787 E90900                   jmp @@getOp133
  1529                                  @@getOp132:
  1530 0000078A 68[9D07]                 push getOp1_0
  1531 0000078D E8C111                   call error1
  1532 00000790 83C402                   add  sp, 2
  1533                                  
  1534                                  ;-109   }
  1535                                  
  1536                                  @@getOp133:
  1537                                  
  1538                                  ;-110   return 0;
  1539                                  
  1540                                  @@getOp130:
  1541 00000793 66B800000000             mov eax, 0
  1542 00000799 E90000                   jmp @@retn
  1543                                  
  1544                                  ;-111 }
  1545                                  
  1546                                  
  1547                                  ;-112 
  1548                                  
  1549                                  
  1550                                  ;-113 int getMEM() {// e.g. [array+bp+si-4]
  1551                                  
  1552                                  @@retn:
  1553 0000079C C3                       ret
  1554                                  ; ENDP
  1555 0000079D 7661726961626C6520-     getOp1_0 db "variable not found",0
  1556 000007A6 6E6F7420666F756E64-
  1557 000007AF 00                 
  1558                                  
  1559                                  getMEM:  ; *** PROC ***
  1560                                  
  1561                                  ;-114 //set: disp, regindexbase, RegType
  1562                                  
  1563                                  
  1564                                  ;-115   char op2;
  1565                                  
  1566                                  
  1567                                  ;-116   disp=0; regindexbase=0; RegType=0;
  1568                                  
  1569                                  ;Function : getMEM, Number of local variables: 1
  1570                                  ;   # type sign width line used address name   list of local variables
  1571                                  ;  200 var sign byte   115 NULL bp-2    op2;
  1572 000007B0 C8020000                 ENTER  2,0
  1573 000007B4 66B800000000             mov eax, 0
  1574 000007BA A3[4800]                 mov word [disp], ax
  1575 000007BD 66B800000000             mov eax, 0
  1576 000007C3 A2[4600]                 mov byte [regindexbase], al
  1577 000007C6 66B800000000             mov eax, 0
  1578 000007CC A2[4200]                 mov byte [RegType], al
  1579                                  
  1580                                  ;-117   do {
  1581                                  
  1582                                  @@getMEM34:
  1583                                  
  1584                                  ;-118     getTokeType();
  1585                                  
  1586 000007CF E84E04                   call getTokeType
  1587                                  
  1588                                  ;-119     op2=getOp1();
  1589                                  
  1590 000007D2 E855FF                   call getOp1
  1591 000007D5 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-120     if (op2 ==   0) syntaxerror();
  1594                                  
  1595 000007D8 8A46FE                   mov al, [bp-2]
  1596 000007DB 3C00                     cmp al, 0
  1597 000007DD 0F850300                 jne @@getMEM35
  1598 000007E1 E88D12                   call syntaxerror
  1599                                  
  1600                                  ;-121     if (op2 == REG) {isDirect=0;
  1601                                  
  1602                                  @@getMEM35:
  1603 000007E4 8A46FE                   mov al, [bp-2]
  1604 000007E7 3C02                     cmp al, 2
  1605 000007E9 0F851E00                 jne @@getMEM36
  1606 000007ED 66B800000000             mov eax, 0
  1607 000007F3 A2[4700]                 mov byte [isDirect], al
  1608                                  
  1609                                  ;-122                       if (regindexbase) regindexbase=getIndReg2();
  1610                                  
  1611 000007F6 A0[4600]                 mov al, [regindexbase]
  1612 000007F9 08C0                     or  al, al
  1613 000007FB 0F840900                 je @@getMEM37
  1614 000007FF E8F300                   call getIndReg2
  1615 00000802 A2[4600]                 mov byte [regindexbase], al
  1616                                  
  1617                                  ;-123                       else getIndReg1();
  1618                                  
  1619 00000805 E90300                   jmp @@getMEM38
  1620                                  @@getMEM37:
  1621 00000808 E88900                   call getIndReg1
  1622                                  
  1623                                  ;-124                     }
  1624                                  
  1625                                  @@getMEM38:
  1626                                  
  1627                                  ;-125     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  1628                                  
  1629                                  @@getMEM36:
  1630 0000080B 8A46FE                   mov al, [bp-2]
  1631 0000080E 3C03                     cmp al, 3
  1632 00000810 0F851000                 jne @@getMEM39
  1633 00000814 A1[4800]                 mov ax, [disp]
  1634 00000817 8B1E[5500]               mov bx, [LabelIx]
  1635 0000081B D1E3                     shl bx, 1
  1636 0000081D 0387A37A                 add ax, [LabelAddr + bx]
  1637 00000821 A3[4800]                 mov word [disp], ax
  1638                                  
  1639                                  ;-126     if (op2 == IMM) disp=disp+SymbolInt;
  1640                                  
  1641                                  @@getMEM39:
  1642 00000824 8A46FE                   mov al, [bp-2]
  1643 00000827 3C01                     cmp al, 1
  1644 00000829 0F850A00                 jne @@getMEM40
  1645 0000082D A1[4800]                 mov ax, [disp]
  1646 00000830 0306[2600]               add ax, [SymbolInt]
  1647 00000834 A3[4800]                 mov word [disp], ax
  1648                                  
  1649                                  ;-127     if (isToken('-')) {
  1650                                  
  1651                                  @@getMEM40:
  1652 00000837 6A2D                     push 45
  1653 00000839 E86107                   call isToken
  1654 0000083C 83C402                   add  sp, 2
  1655 0000083F 08C0                     or  al, al
  1656 00000841 0F841900                 je @@getMEM41
  1657                                  
  1658                                  ;-128       getTokeType();
  1659                                  
  1660 00000845 E8D803                   call getTokeType
  1661                                  
  1662                                  ;-129       if (TokeType != DIGIT) numbererror();
  1663                                  
  1664 00000848 A0[3C00]                 mov al, [TokeType]
  1665 0000084B 3C01                     cmp al, 1
  1666 0000084D 0F840300                 je  @@getMEM42
  1667 00000851 E8B211                   call numbererror
  1668                                  
  1669                                  ;-130       disp = disp - SymbolInt;
  1670                                  
  1671                                  @@getMEM42:
  1672 00000854 A1[4800]                 mov ax, [disp]
  1673 00000857 2B06[2600]               sub ax, [SymbolInt]
  1674 0000085B A3[4800]                 mov word [disp], ax
  1675                                  
  1676                                  ;-131     }
  1677                                  
  1678                                  
  1679                                  ;-132   } while (isToken('+'));
  1680                                  
  1681                                  @@getMEM41:
  1682 0000085E 6A2B                     push 43
  1683 00000860 E83A07                   call isToken
  1684 00000863 83C402                   add  sp, 2
  1685 00000866 08C0                     or  al, al
  1686 00000868 0F840300                 je @@getMEM43
  1687 0000086C E960FF                   jmp @@getMEM34
  1688                                  @@getMEM43:
  1689                                  
  1690                                  ;-133   if (isToken(']') == 0) errorexit("] expected");
  1691                                  
  1692 0000086F 6A5D                     push 93
  1693 00000871 E82907                   call isToken
  1694 00000874 83C402                   add  sp, 2
  1695 00000877 83F800                   cmp ax, 0
  1696 0000087A 0F850900                 jne @@getMEM44
  1697 0000087E 68[8908]                 push getMEM_0
  1698 00000881 E8FE11                   call errorexit
  1699 00000884 83C402                   add  sp, 2
  1700                                  
  1701                                  ;-134 }
  1702                                  
  1703                                  @@getMEM44:
  1704                                  
  1705                                  ;-135 int getIndReg1() {
  1706 00000887 C9                       LEAVE
  1707 00000888 C3                       ret
  1708                                  ; ENDP
  1709 00000889 5D2065787065637465-     getMEM_0 db "] expected",0
  1710 00000892 6400               
  1711                                  
  1712                                  getIndReg1:  ; *** PROC ***
  1713                                  
  1714                                  ;-136   if (RegType !=WORD) indexerror();
  1715                                  
  1716 00000894 A0[4200]                 mov al, [RegType]
  1717 00000897 3C02                     cmp al, 2
  1718 00000899 0F840300                 je  @@getIndReg145
  1719 0000089D E84511                   call indexerror
  1720                                  
  1721                                  ;-137   if (RegNo==3) regindexbase=7;//BX
  1722                                  
  1723                                  @@getIndReg145:
  1724 000008A0 A0[4300]                 mov al, [RegNo]
  1725 000008A3 3C03                     cmp al, 3
  1726 000008A5 0F850900                 jne @@getIndReg146
  1727 000008A9 66B807000000             mov eax, 7
  1728 000008AF A2[4600]                 mov byte [regindexbase], al
  1729                                  
  1730                                  ;-138   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  1731                                  
  1732                                  @@getIndReg146:
  1733 000008B2 A0[4300]                 mov al, [RegNo]
  1734 000008B5 3C05                     cmp al, 5
  1735 000008B7 0F850900                 jne @@getIndReg147
  1736 000008BB 66B806000000             mov eax, 6
  1737 000008C1 A2[4600]                 mov byte [regindexbase], al
  1738                                  
  1739                                  ;-139   if (RegNo==7) regindexbase=5;//DI
  1740                                  
  1741                                  @@getIndReg147:
  1742 000008C4 A0[4300]                 mov al, [RegNo]
  1743 000008C7 3C07                     cmp al, 7
  1744 000008C9 0F850900                 jne @@getIndReg148
  1745 000008CD 66B805000000             mov eax, 5
  1746 000008D3 A2[4600]                 mov byte [regindexbase], al
  1747                                  
  1748                                  ;-140   if (RegNo==6) regindexbase=4;//SI
  1749                                  
  1750                                  @@getIndReg148:
  1751 000008D6 A0[4300]                 mov al, [RegNo]
  1752 000008D9 3C06                     cmp al, 6
  1753 000008DB 0F850900                 jne @@getIndReg149
  1754 000008DF 66B804000000             mov eax, 4
  1755 000008E5 A2[4600]                 mov byte [regindexbase], al
  1756                                  
  1757                                  ;-141   if (regindexbase==0) indexerror();
  1758                                  
  1759                                  @@getIndReg149:
  1760 000008E8 A0[4600]                 mov al, [regindexbase]
  1761 000008EB 3C00                     cmp al, 0
  1762 000008ED 0F850300                 jne @@getIndReg150
  1763 000008F1 E8F110                   call indexerror
  1764                                  
  1765                                  ;-142 }
  1766                                  
  1767                                  @@getIndReg150:
  1768                                  
  1769                                  ;-143 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1770                                  
  1771 000008F4 C3                       ret
  1772                                  ; ENDP
  1773                                  
  1774                                  getIndReg2:  ; *** PROC ***
  1775                                  ;Function : getIndReg2, Number of local variables: 1
  1776                                  ;   # type sign width line used address name   list of local variables
  1777                                  ;  200 var sign byte   143 NULL bp-2    m;
  1778 000008F5 C8020000                 ENTER  2,0
  1779 000008F9 66B804000000             mov eax, 4
  1780 000008FF 8846FE                   mov byte [bp-2], al
  1781                                  
  1782                                  ;-144   if (RegType !=WORD) indexerror();
  1783                                  
  1784 00000902 A0[4200]                 mov al, [RegType]
  1785 00000905 3C02                     cmp al, 2
  1786 00000907 0F840300                 je  @@getIndReg251
  1787 0000090B E8D710                   call indexerror
  1788                                  
  1789                                  ;-145   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  1790                                  
  1791                                  @@getIndReg251:
  1792 0000090E A0[4300]                 mov al, [RegNo]
  1793 00000911 3C07                     cmp al, 7
  1794 00000913 0F852700                 jne @@getIndReg252
  1795 00000917 A0[4600]                 mov al, [regindexbase]
  1796 0000091A 3C06                     cmp al, 6
  1797 0000091C 0F850C00                 jne @@getIndReg253
  1798 00000920 66B803000000             mov eax, 3
  1799 00000926 8846FE                   mov byte [bp-2], al
  1800                                  
  1801                                  ;-146            else if (regindexbase==7) m=1;//BX+DI
  1802                                  
  1803 00000929 E91200                   jmp @@getIndReg254
  1804                                  @@getIndReg253:
  1805 0000092C A0[4600]                 mov al, [regindexbase]
  1806 0000092F 3C07                     cmp al, 7
  1807 00000931 0F850900                 jne @@getIndReg255
  1808 00000935 66B801000000             mov eax, 1
  1809 0000093B 8846FE                   mov byte [bp-2], al
  1810                                  
  1811                                  ;-147   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  1812                                  
  1813                                  @@getIndReg255:
  1814                                  @@getIndReg254:
  1815                                  @@getIndReg252:
  1816 0000093E A0[4300]                 mov al, [RegNo]
  1817 00000941 3C06                     cmp al, 6
  1818 00000943 0F852700                 jne @@getIndReg256
  1819 00000947 A0[4600]                 mov al, [regindexbase]
  1820 0000094A 3C06                     cmp al, 6
  1821 0000094C 0F850C00                 jne @@getIndReg257
  1822 00000950 66B802000000             mov eax, 2
  1823 00000956 8846FE                   mov byte [bp-2], al
  1824                                  
  1825                                  ;-148            else if (regindexbase==7) m=0;//BX+SI
  1826                                  
  1827 00000959 E91200                   jmp @@getIndReg258
  1828                                  @@getIndReg257:
  1829 0000095C A0[4600]                 mov al, [regindexbase]
  1830 0000095F 3C07                     cmp al, 7
  1831 00000961 0F850900                 jne @@getIndReg259
  1832 00000965 66B800000000             mov eax, 0
  1833 0000096B 8846FE                   mov byte [bp-2], al
  1834                                  
  1835                                  ;-149   if (m > 3) indexerror();
  1836                                  
  1837                                  @@getIndReg259:
  1838                                  @@getIndReg258:
  1839                                  @@getIndReg256:
  1840 0000096E 8A46FE                   mov al, [bp-2]
  1841 00000971 3C03                     cmp al, 3
  1842 00000973 0F8E0300                 jle @@getIndReg260
  1843 00000977 E86B10                   call indexerror
  1844                                  
  1845                                  ;-150   return m;
  1846                                  
  1847                                  @@getIndReg260:
  1848 0000097A 8A46FE                   mov al, [bp-2]
  1849 0000097D E90000                   jmp @@retn
  1850                                  
  1851                                  ;-151 }
  1852                                  
  1853                                  
  1854                                  ;-152 
  1855                                  
  1856                                  
  1857                                  ;-153 // generate code ........................................
  1858                                  
  1859                                  
  1860                                  ;-154 int getCodes() {
  1861                                  
  1862 00000980 C9                      @@retn: LEAVE
  1863 00000981 C3                       ret
  1864                                  ; ENDP
  1865                                  
  1866                                  getCodes:  ; *** PROC ***
  1867                                  
  1868                                  ;-155   OpCodePtr ++; Code1 = *OpCodePtr;
  1869                                  
  1870 00000982 FF06[4E00]               inc  word [OpCodePtr]
  1871 00000986 8B1E[4E00]               mov bx, [OpCodePtr]
  1872 0000098A 8A07                     mov al, [bx]
  1873 0000098C B400                     mov ah, 0
  1874 0000098E A2[3F00]                 mov byte [Code1], al
  1875                                  
  1876                                  ;-156   OpCodePtr ++; Code2 = *OpCodePtr;
  1877                                  
  1878 00000991 FF06[4E00]               inc  word [OpCodePtr]
  1879 00000995 8B1E[4E00]               mov bx, [OpCodePtr]
  1880 00000999 8A07                     mov al, [bx]
  1881 0000099B B400                     mov ah, 0
  1882 0000099D A2[4000]                 mov byte [Code2], al
  1883                                  
  1884                                  ;-157   OpCodePtr ++; Code3 = *OpCodePtr;
  1885                                  
  1886 000009A0 FF06[4E00]               inc  word [OpCodePtr]
  1887 000009A4 8B1E[4E00]               mov bx, [OpCodePtr]
  1888 000009A8 8A07                     mov al, [bx]
  1889 000009AA B400                     mov ah, 0
  1890 000009AC A2[4100]                 mov byte [Code3], al
  1891                                  
  1892                                  ;-158 }
  1893                                  
  1894                                  
  1895                                  ;-159 int gen66h() {genCode8(0x66);
  1896                                  
  1897 000009AF C3                       ret
  1898                                  ; ENDP
  1899                                  
  1900                                  gen66h:  ; *** PROC ***
  1901 000009B0 6A66                     push 102
  1902 000009B2 E81F00                   call genCode8
  1903 000009B5 83C402                   add  sp, 2
  1904                                  
  1905                                  ;-160 }
  1906                                  
  1907                                  
  1908                                  ;-161 int genCode(char c, char d) {
  1909                                  
  1910 000009B8 C3                       ret
  1911                                  ; ENDP
  1912                                  
  1913                                  genCode:  ; *** PROC ***
  1914                                  
  1915                                  ;-162     c = c + d;
  1916                                  
  1917                                  ;Function : genCode, Number of local variables: 2
  1918                                  ;   # type sign width line used address name   list of local variables
  1919                                  ;  200 var sign byte   161 NULL bp+4    c
  1920                                  ;  201 var sign byte   161 NULL bp+6    d;
  1921 000009B9 C8000000                 ENTER  0,0
  1922 000009BD 8A4604                   mov al, [bp+4]
  1923 000009C0 024606                   add al, [bp+6]
  1924 000009C3 884604                   mov byte [bp+4], al
  1925                                  
  1926                                  ;-163     genCode8(c);
  1927                                  
  1928 000009C6 8A4604                   mov al, byte [bp+4]
  1929 000009C9 B400                     mov ah, 0
  1930 000009CB 50                       push ax
  1931 000009CC E80500                   call genCode8
  1932 000009CF 83C402                   add  sp, 2
  1933                                  
  1934                                  ;-164 }
  1935                                  
  1936                                  
  1937                                  ;-165 int genCode8(char c) {
  1938 000009D2 C9                       LEAVE
  1939 000009D3 C3                       ret
  1940                                  ; ENDP
  1941                                  
  1942                                  genCode8:  ; *** PROC ***
  1943                                  
  1944                                  ;-166 //set: BinLen++, OpPrintIndex++
  1945                                  
  1946                                  
  1947                                  ;-167   FileBin[BinLen]=c;
  1948                                  
  1949                                  ;Function : genCode8, Number of local variables: 1
  1950                                  ;   # type sign width line used address name   list of local variables
  1951                                  ;  200 var sign byte   165 NULL bp+4    c;
  1952 000009D4 C8000000                 ENTER  0,0
  1953 000009D8 8A4604                   mov al, [bp+4]
  1954 000009DB 8B1E[5700]               mov bx, [BinLen]
  1955 000009DF 88876B7B                 mov [FileBin+bx], al
  1956                                  
  1957                                  ;-168   BinLen++;
  1958                                  
  1959 000009E3 FF06[5700]               inc  word [BinLen]
  1960                                  
  1961                                  ;-169   PC++;
  1962                                  
  1963 000009E7 FF06[3700]               inc  word [PC]
  1964                                  
  1965                                  ;-170   if (OpPrintIndex < OPMAXLEN) {
  1966                                  
  1967 000009EB A1[4C00]                 mov ax, [OpPrintIndex]
  1968 000009EE 83F805                   cmp ax, 5
  1969 000009F1 0F8D0F00                 jge @@genCode861
  1970                                  
  1971                                  ;-171     OpPos[OpPrintIndex]=c;
  1972                                  
  1973 000009F5 8A4604                   mov al, [bp+4]
  1974 000009F8 8B1E[4C00]               mov bx, [OpPrintIndex]
  1975 000009FC 8887B676                 mov [OpPos+bx], al
  1976                                  
  1977                                  ;-172     OpPrintIndex++;
  1978                                  
  1979 00000A00 FF06[4C00]               inc  word [OpPrintIndex]
  1980                                  
  1981                                  ;-173   }
  1982                                  
  1983                                  
  1984                                  ;-174 }
  1985                                  
  1986                                  @@genCode861:
  1987                                  
  1988                                  ;-175 int genCode16(int i) {
  1989 00000A04 C9                       LEAVE
  1990 00000A05 C3                       ret
  1991                                  ; ENDP
  1992                                  
  1993                                  genCode16:  ; *** PROC ***
  1994                                  
  1995                                  ;-176   genCode8(i); i=i >> 8;
  1996                                  
  1997                                  ;Function : genCode16, Number of local variables: 1
  1998                                  ;   # type sign width line used address name   list of local variables
  1999                                  ;  200 var sign word   175 NULL bp+4    i;
  2000 00000A06 C8000000                 ENTER  0,0
  2001 00000A0A FF7604                   push word [bp+4]
  2002 00000A0D E8C4FF                   call genCode8
  2003 00000A10 83C402                   add  sp, 2
  2004 00000A13 8B4604                   mov ax, [bp+4]
  2005 00000A16 C1E808                   shr ax, 8
  2006 00000A19 894604                   mov word [bp+4], ax
  2007                                  
  2008                                  ;-177   genCode8(i);
  2009                                  
  2010 00000A1C FF7604                   push word [bp+4]
  2011 00000A1F E8B2FF                   call genCode8
  2012 00000A22 83C402                   add  sp, 2
  2013                                  
  2014                                  ;-178 }
  2015                                  
  2016                                  
  2017                                  ;-179 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2018 00000A25 C9                       LEAVE
  2019 00000A26 C3                       ret
  2020                                  ; ENDP
  2021                                  
  2022                                  writeEA:  ; *** PROC ***
  2023                                  
  2024                                  ;-180 //mod-byte: mode76, reg/opcode543, r/m210    
  2025                                  
  2026                                  
  2027                                  ;-181   char len;
  2028                                  
  2029                                  
  2030                                  ;-182   len=0;
  2031                                  
  2032                                  ;Function : writeEA, Number of local variables: 2
  2033                                  ;   # type sign width line used address name   list of local variables
  2034                                  ;  200 var sign byte   179 NULL bp+4    xxx
  2035                                  ;  201 var sign byte   181 NULL bp-2    len;
  2036 00000A27 C8020000                 ENTER  2,0
  2037 00000A2B 66B800000000             mov eax, 0
  2038 00000A31 8846FE                   mov byte [bp-2], al
  2039                                  
  2040                                  ;-183 //  prs("\nxxx:"); printhex8a(xxx);
  2041                                  
  2042                                  
  2043                                  ;-184   xxx = xxx << 3;//in reg/opcode field
  2044                                  
  2045 00000A34 8A4604                   mov al, [bp+4]
  2046 00000A37 C0E003                   shl al, 3
  2047 00000A3A 884604                   mov byte [bp+4], al
  2048                                  
  2049                                  ;-185   if (Op1 ==   0) addrexit();
  2050                                  
  2051 00000A3D A0[3D00]                 mov al, [Op1]
  2052 00000A40 3C00                     cmp al, 0
  2053 00000A42 0F850300                 jne @@writeEA62
  2054 00000A46 E85010                   call addrexit
  2055                                  
  2056                                  ;-186   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  2057                                  
  2058                                  @@writeEA62:
  2059 00000A49 A0[3D00]                 mov al, [Op1]
  2060 00000A4C 3C02                     cmp al, 2
  2061 00000A4E 0F850E00                 jne @@writeEA63
  2062 00000A52 804E04C0                 or  byte [bp+4], 192
  2063 00000A56 8A4604                   mov al, [bp+4]
  2064 00000A59 0206[4300]               add al, [RegNo]
  2065 00000A5D 884604                   mov byte [bp+4], al
  2066                                  
  2067                                  ;-187   if (Op1 == ADR) error1("writeEA");           
  2068                                  
  2069                                  @@writeEA63:
  2070 00000A60 A0[3D00]                 mov al, [Op1]
  2071 00000A63 3C03                     cmp al, 3
  2072 00000A65 0F850900                 jne @@writeEA64
  2073 00000A69 68[2E0B]                 push writeEA_0
  2074 00000A6C E8E20E                   call error1
  2075 00000A6F 83C402                   add  sp, 2
  2076                                  
  2077                                  ;-188   if (Op1 == MEM) {
  2078                                  
  2079                                  @@writeEA64:
  2080 00000A72 A0[3D00]                 mov al, [Op1]
  2081 00000A75 3C04                     cmp al, 4
  2082 00000A77 0F857F00                 jne @@writeEA65
  2083                                  
  2084                                  ;-189     if (isDirect) {
  2085                                  
  2086 00000A7B A0[4700]                 mov al, [isDirect]
  2087 00000A7E 08C0                     or  al, al
  2088 00000A80 0F841000                 je @@writeEA66
  2089                                  
  2090                                  ;-190         xxx |= 6;
  2091                                  
  2092 00000A84 804E0406                 or  byte [bp+4], 6
  2093                                  
  2094                                  ;-191         len = 2;
  2095                                  
  2096 00000A88 66B802000000             mov eax, 2
  2097 00000A8E 8846FE                   mov byte [bp-2], al
  2098                                  
  2099                                  ;-192     }
  2100                                  
  2101                                  
  2102                                  ;-193     else { 
  2103                                  
  2104 00000A91 E96600                   jmp @@writeEA67
  2105                                  @@writeEA66:
  2106                                  
  2107                                  ;-194       xxx = xxx + regindexbase;   
  2108                                  
  2109 00000A94 8A4604                   mov al, [bp+4]
  2110 00000A97 0206[4600]               add al, [regindexbase]
  2111 00000A9B 884604                   mov byte [bp+4], al
  2112                                  
  2113                                  ;-195       if (regindexbase == 6) {//make [BP+00]
  2114                                  
  2115 00000A9E A0[4600]                 mov al, [regindexbase]
  2116 00000AA1 3C06                     cmp al, 6
  2117 00000AA3 0F851700                 jne @@writeEA68
  2118                                  
  2119                                  ;-196         len=1;
  2120                                  
  2121 00000AA7 66B801000000             mov eax, 1
  2122 00000AAD 8846FE                   mov byte [bp-2], al
  2123                                  
  2124                                  ;-197         if (disp == 0) xxx |= 0x40;
  2125                                  
  2126 00000AB0 A1[4800]                 mov ax, [disp]
  2127 00000AB3 83F800                   cmp ax, 0
  2128 00000AB6 0F850400                 jne @@writeEA69
  2129 00000ABA 804E0440                 or  byte [bp+4], 64
  2130                                  
  2131                                  ;-198       }
  2132                                  
  2133                                  @@writeEA69:
  2134                                  
  2135                                  ;-199 
  2136                                  
  2137                                  
  2138                                  ;-200       if (disp) {
  2139                                  
  2140                                  @@writeEA68:
  2141 00000ABE A1[4800]                 mov ax, [disp]
  2142 00000AC1 08C0                     or  al, al
  2143 00000AC3 0F843300                 je @@writeEA70
  2144                                  
  2145                                  ;-201         ax = disp;
  2146                                  
  2147 00000AC7 A1[4800]                 mov  ax, [disp]
  2148                                  
  2149                                  ;-202         if(ax > 127) len=2;
  2150                                  
  2151 00000ACA 83F87F                   cmp  ax, 127
  2152 00000ACD 0F8E0C00                 jle @@writeEA71
  2153 00000AD1 66B802000000             mov eax, 2
  2154 00000AD7 8846FE                   mov byte [bp-2], al
  2155                                  
  2156                                  ;-203         else len=1;
  2157                                  
  2158 00000ADA E90900                   jmp @@writeEA72
  2159                                  @@writeEA71:
  2160 00000ADD 66B801000000             mov eax, 1
  2161 00000AE3 8846FE                   mov byte [bp-2], al
  2162                                  
  2163                                  ;-204         if (len == 1) xxx |= 0x40;
  2164                                  
  2165                                  @@writeEA72:
  2166 00000AE6 8A46FE                   mov al, [bp-2]
  2167 00000AE9 3C01                     cmp al, 1
  2168 00000AEB 0F850700                 jne @@writeEA73
  2169 00000AEF 804E0440                 or  byte [bp+4], 64
  2170                                  
  2171                                  ;-205         else xxx |= 0x80;
  2172                                  
  2173 00000AF3 E90400                   jmp @@writeEA74
  2174                                  @@writeEA73:
  2175 00000AF6 804E0480                 or  byte [bp+4], 128
  2176                                  
  2177                                  ;-206       }
  2178                                  
  2179                                  @@writeEA74:
  2180                                  
  2181                                  ;-207     }
  2182                                  
  2183                                  @@writeEA70:
  2184                                  
  2185                                  ;-208   }
  2186                                  
  2187                                  @@writeEA67:
  2188                                  
  2189                                  ;-209   genCode8(xxx);// gen second byte
  2190                                  
  2191                                  @@writeEA65:
  2192 00000AFA 8A4604                   mov al, byte [bp+4]
  2193 00000AFD B400                     mov ah, 0
  2194 00000AFF 50                       push ax
  2195 00000B00 E8D1FE                   call genCode8
  2196 00000B03 83C402                   add  sp, 2
  2197                                  
  2198                                  ;-210   if (len == 1) genCode8 (disp);
  2199                                  
  2200 00000B06 8A46FE                   mov al, [bp-2]
  2201 00000B09 3C01                     cmp al, 1
  2202 00000B0B 0F850A00                 jne @@writeEA75
  2203 00000B0F FF36[4800]               push word [disp]
  2204 00000B13 E8BEFE                   call genCode8
  2205 00000B16 83C402                   add  sp, 2
  2206                                  
  2207                                  ;-211   if (len == 2) genCode16(disp);
  2208                                  
  2209                                  @@writeEA75:
  2210 00000B19 8A46FE                   mov al, [bp-2]
  2211 00000B1C 3C02                     cmp al, 2
  2212 00000B1E 0F850A00                 jne @@writeEA76
  2213 00000B22 FF36[4800]               push word [disp]
  2214 00000B26 E8DDFE                   call genCode16
  2215 00000B29 83C402                   add  sp, 2
  2216                                  
  2217                                  ;-212 }
  2218                                  
  2219                                  @@writeEA76:
  2220                                  
  2221                                  ;-213 
  2222                                  
  2223                                  
  2224                                  ;-214 #include "PARSE.C"
  2225 00000B2C C9                       LEAVE
  2226 00000B2D C3                       ret
  2227                                  ; ENDP
  2228 00000B2E 7772697465454100        writeEA_0 db "writeEA",0
  2229                                  ;Use include file: PARSE.C
  2230                                  
  2231                                  ;-1 int parse() {
  2232                                  
  2233                                  
  2234                                  parse:  ; *** PROC ***
  2235                                  
  2236                                  ;-2   LabelNamePtr= &LabelNames;
  2237                                  
  2238 00000B36 B8BB76                   mov ax, LabelNames
  2239 00000B39 A3[5100]                 mov word [LabelNamePtr], ax
  2240                                  
  2241                                  ;-3   do {
  2242                                  
  2243                                  @@parse77:
  2244                                  
  2245                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  2246                                  
  2247 00000B3C A1[3700]                 mov ax, [PC]
  2248 00000B3F A3[3900]                 mov word [PCStart], ax
  2249 00000B42 66B800000000             mov eax, 0
  2250 00000B48 A2[4400]                 mov byte [OpSize], al
  2251 00000B4B 66B800000000             mov eax, 0
  2252 00000B51 A3[4C00]                 mov word [OpPrintIndex], ax
  2253 00000B54 66B820000000             mov eax, 32
  2254 00000B5A A2[5000]                 mov byte [PrintR], al
  2255                                  
  2256                                  ;-5     getLine();
  2257                                  
  2258 00000B5D E89404                   call getLine
  2259                                  
  2260                                  ;-6     InputPtr = &InputBuf;
  2261                                  
  2262 00000B60 B86E75                   mov ax, InputBuf
  2263 00000B63 A3[2800]                 mov word [InputPtr], ax
  2264                                  
  2265                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2266                                  
  2267 00000B66 E8B700                   call getTokeType
  2268                                  
  2269                                  ;-8     if (TokeType == ALNUME) {
  2270                                  
  2271 00000B69 A0[3C00]                 mov al, [TokeType]
  2272 00000B6C 3C03                     cmp al, 3
  2273 00000B6E 0F851300                 jne @@parse78
  2274                                  
  2275                                  ;-9       if (isLabel) { //set in getName
  2276                                  
  2277 00000B72 A0[3B00]                 mov al, [isLabel]
  2278 00000B75 08C0                     or  al, al
  2279 00000B77 0F840A00                 je @@parse79
  2280                                  
  2281                                  ;-10         storeLabel();
  2282                                  
  2283 00000B7B E84001                   call storeLabel
  2284                                  
  2285                                  ;-11         InputPtr++;//remove :
  2286                                  
  2287 00000B7E FF06[2800]               inc  word [InputPtr]
  2288                                  
  2289                                  ;-12         getTokeType();
  2290                                  
  2291 00000B82 E89B00                   call getTokeType
  2292                                  
  2293                                  ;-13       }
  2294                                  
  2295                                  
  2296                                  ;-14     }
  2297                                  
  2298                                  @@parse79:
  2299                                  
  2300                                  ;-15     if (TokeType == ALNUME) {
  2301                                  
  2302                                  @@parse78:
  2303 00000B85 A0[3C00]                 mov al, [TokeType]
  2304 00000B88 3C03                     cmp al, 3
  2305 00000B8A 0F851B00                 jne @@parse80
  2306                                  
  2307                                  ;-16       lookCode();// and OpCodePtr
  2308                                  
  2309 00000B8E E80F03                   call lookCode
  2310                                  
  2311                                  ;-17       if(CodeType) process();
  2312                                  
  2313 00000B91 A0[3E00]                 mov al, [CodeType]
  2314 00000B94 08C0                     or  al, al
  2315 00000B96 0F840600                 je @@parse81
  2316 00000B9A E875F8                   call process
  2317                                  
  2318                                  ;-18       else getVariable();
  2319                                  
  2320 00000B9D E90300                   jmp @@parse82
  2321                                  @@parse81:
  2322 00000BA0 E8C501                   call getVariable
  2323                                  
  2324                                  ;-19       skipRest();
  2325                                  
  2326                                  @@parse82:
  2327 00000BA3 E82504                   call skipRest
  2328                                  
  2329                                  ;-20     }
  2330                                  
  2331                                  
  2332                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2333                                  
  2334 00000BA6 E92700                   jmp @@parse83
  2335                                  @@parse80:
  2336 00000BA9 A0[3C00]                 mov al, [TokeType]
  2337 00000BAC 3C03                     cmp al, 3
  2338 00000BAE 0F8E0C00                 jle @@parse84
  2339 00000BB2 68[E10B]                 push parse_0
  2340 00000BB5 E8990D                   call error1
  2341 00000BB8 83C402                   add  sp, 2
  2342                                  
  2343                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2344                                  
  2345 00000BBB E91200                   jmp @@parse85
  2346                                  @@parse84:
  2347 00000BBE A0[3C00]                 mov al, [TokeType]
  2348 00000BC1 3C01                     cmp al, 1
  2349 00000BC3 0F850900                 jne @@parse86
  2350 00000BC7 68[FF0B]                 push parse_1
  2351 00000BCA E8840D                   call error1
  2352 00000BCD 83C402                   add  sp, 2
  2353                                  
  2354                                  ;-23     printLine();
  2355                                  
  2356                                  @@parse86:
  2357                                  @@parse85:
  2358                                  @@parse83:
  2359 00000BD0 E8130B                   call printLine
  2360                                  
  2361                                  ;-24   } while (DOS_NoBytes != 0 );
  2362                                  
  2363 00000BD3 A1[3400]                 mov ax, [DOS_NoBytes]
  2364 00000BD6 83F800                   cmp ax, 0
  2365 00000BD9 0F840300                 je  @@parse87
  2366 00000BDD E95CFF                   jmp @@parse77
  2367                                  @@parse87:
  2368                                  
  2369                                  ;-25 }
  2370                                  
  2371                                  
  2372                                  ;-26 // scan code .....................................
  2373                                  
  2374                                  
  2375                                  ;-27 int getTokeType() { char c;
  2376                                  
  2377 00000BE0 C3                       ret
  2378                                  ; ENDP
  2379 00000BE1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2380 00000BEA 696E73747275637469-
  2381 00000BF3 6F6E20657870656374-
  2382 00000BFC 656400             
  2383 00000BFF 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2384 00000C08 616C6C6F7765642040-
  2385 00000C11 207374617274206F66-
  2386 00000C1A 206C696E6500       
  2387                                  
  2388                                  getTokeType:  ; *** PROC ***
  2389                                  
  2390                                  ;-28   skipBlank();
  2391                                  
  2392                                  ;Function : getTokeType, Number of local variables: 1
  2393                                  ;   # type sign width line used address name   list of local variables
  2394                                  ;  200 var sign byte    27 NULL bp-2    c;
  2395 00000C20 C8020000                 ENTER  2,0
  2396 00000C24 E89A04                   call skipBlank
  2397                                  
  2398                                  ;-29   c = *InputPtr;
  2399                                  
  2400 00000C27 8B1E[2800]               mov bx, [InputPtr]
  2401 00000C2B 8A07                     mov al, [bx]
  2402 00000C2D B400                     mov ah, 0
  2403 00000C2F 8846FE                   mov byte [bp-2], al
  2404                                  
  2405                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2406                                  
  2407 00000C32 8A46FE                   mov al, [bp-2]
  2408 00000C35 3C00                     cmp al, 0
  2409 00000C37 0F850C00                 jne @@getTokeType88
  2410 00000C3B 66B800000000             mov eax, 0
  2411 00000C41 A2[3C00]                 mov byte [TokeType], al
  2412 00000C44 E97500                   jmp @@retn
  2413                                  
  2414                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2415                                  
  2416                                  @@getTokeType88:
  2417 00000C47 8A46FE                   mov al, [bp-2]
  2418 00000C4A 3C3B                     cmp al, 59
  2419 00000C4C 0F850C00                 jne @@getTokeType89
  2420 00000C50 66B800000000             mov eax, 0
  2421 00000C56 A2[3C00]                 mov byte [TokeType], al
  2422 00000C59 E96000                   jmp @@retn
  2423                                  
  2424                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2425                                  
  2426                                  @@getTokeType89:
  2427 00000C5C 8A46FE                   mov al, byte [bp-2]
  2428 00000C5F B400                     mov ah, 0
  2429 00000C61 50                       push ax
  2430 00000C62 E84013                   call digit
  2431 00000C65 83C402                   add  sp, 2
  2432 00000C68 08C0                     or  al, al
  2433 00000C6A 0F841800                 je @@getTokeType90
  2434 00000C6E 8A46FE                   mov al, byte [bp-2]
  2435 00000C71 B400                     mov ah, 0
  2436 00000C73 50                       push ax
  2437 00000C74 E85005                   call getDigit
  2438 00000C77 83C402                   add  sp, 2
  2439 00000C7A 66B801000000             mov eax, 1
  2440 00000C80 A2[3C00]                 mov byte [TokeType], al
  2441 00000C83 E93600                   jmp @@retn
  2442                                  
  2443                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2444                                  
  2445                                  @@getTokeType90:
  2446 00000C86 8A46FE                   mov al, byte [bp-2]
  2447 00000C89 B400                     mov ah, 0
  2448 00000C8B 50                       push ax
  2449 00000C8C E85D04                   call letterE
  2450 00000C8F 83C402                   add  sp, 2
  2451 00000C92 08C0                     or  al, al
  2452 00000C94 0F841800                 je @@getTokeType91
  2453 00000C98 8A46FE                   mov al, byte [bp-2]
  2454 00000C9B B400                     mov ah, 0
  2455 00000C9D 50                       push ax
  2456 00000C9E E87D05                   call getName
  2457 00000CA1 83C402                   add  sp, 2
  2458 00000CA4 66B803000000             mov eax, 3
  2459 00000CAA A2[3C00]                 mov byte [TokeType], al
  2460 00000CAD E90C00                   jmp @@retn
  2461                                  
  2462                                  ;-34   TokeType=NOALNUME; return;
  2463                                  
  2464                                  @@getTokeType91:
  2465 00000CB0 66B804000000             mov eax, 4
  2466 00000CB6 A2[3C00]                 mov byte [TokeType], al
  2467 00000CB9 E90000                   jmp @@retn
  2468                                  
  2469                                  ;-35 }
  2470                                  
  2471                                  
  2472                                  ;-36 int storeLabel() {
  2473                                  
  2474 00000CBC C9                      @@retn: LEAVE
  2475 00000CBD C3                       ret
  2476                                  ; ENDP
  2477                                  
  2478                                  storeLabel:  ; *** PROC ***
  2479                                  
  2480                                  ;-37   if(searchLabel()) error1("duplicate label");
  2481                                  
  2482 00000CBE E84700                   call searchLabel
  2483 00000CC1 08C0                     or  al, al
  2484 00000CC3 0F840900                 je @@storeLabel92
  2485 00000CC7 68[F80C]                 push storeLabel_0
  2486 00000CCA E8840C                   call error1
  2487 00000CCD 83C402                   add  sp, 2
  2488                                  
  2489                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2490                                  
  2491                                  @@storeLabel92:
  2492 00000CD0 8D063075                 lea  ax, [Symbol]
  2493 00000CD4 50                       push ax
  2494 00000CD5 FF36[5100]               push word [LabelNamePtr]
  2495 00000CD9 E89012                   call strcpy
  2496 00000CDC 83C404                   add  sp, 4
  2497 00000CDF A3[5100]                 mov word [LabelNamePtr], ax
  2498                                  
  2499                                  ;-39   LabelNamePtr++;
  2500                                  
  2501 00000CE2 FF06[5100]               inc  word [LabelNamePtr]
  2502                                  
  2503                                  ;-40   LabelMaxIx++;
  2504                                  
  2505 00000CE6 FF06[5300]               inc  word [LabelMaxIx]
  2506                                  
  2507                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2508                                  
  2509 00000CEA A1[3700]                 mov ax, [PC]
  2510 00000CED 8B1E[5300]               mov bx, [LabelMaxIx]
  2511 00000CF1 D1E3                     shl bx, 1
  2512 00000CF3 8987A37A                 mov [LabelAddr+bx], ax
  2513                                  
  2514                                  ;-42 }
  2515                                  
  2516                                  
  2517                                  ;-43 int searchLabel() {
  2518                                  
  2519 00000CF7 C3                       ret
  2520                                  ; ENDP
  2521 00000CF8 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2522 00000D01 206C6162656C00     
  2523                                  
  2524                                  searchLabel:  ; *** PROC ***
  2525                                  
  2526                                  ;-44   int LIx; char *p; int j;
  2527                                  
  2528                                  
  2529                                  ;-45   p = &LabelNames;
  2530                                  
  2531                                  ;Function : searchLabel, Number of local variables: 3
  2532                                  ;   # type sign width line used address name   list of local variables
  2533                                  ;  200 var sign word    44 NULL bp-2    LIx
  2534                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2535                                  ;  202 var sign word    44 NULL bp-6    j;
  2536 00000D08 C8060000                 ENTER  6,0
  2537 00000D0C B8BB76                   mov ax, LabelNames
  2538 00000D0F 8946FC                   mov word [bp-4], ax
  2539                                  
  2540                                  ;-46   LIx=1;
  2541                                  
  2542 00000D12 66B801000000             mov eax, 1
  2543 00000D18 8946FE                   mov word [bp-2], ax
  2544                                  
  2545                                  ;-47   while (LIx <= LabelMaxIx) {
  2546                                  
  2547                                  @@searchLabel93:
  2548 00000D1B 8B46FE                   mov ax, [bp-2]
  2549 00000D1E 3B06[5300]               cmp ax, [LabelMaxIx]
  2550 00000D22 0F8F3700                 jg  @@searchLabel94
  2551                                  
  2552                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2553                                  
  2554 00000D26 8D063075                 lea  ax, [Symbol]
  2555 00000D2A 50                       push ax
  2556 00000D2B FF76FC                   push word [bp-4]
  2557 00000D2E E8A712                   call eqstr
  2558 00000D31 83C404                   add  sp, 4
  2559 00000D34 08C0                     or  al, al
  2560 00000D36 0F840600                 je @@searchLabel95
  2561 00000D3A 8B46FE                   mov ax, [bp-2]
  2562 00000D3D E92600                   jmp @@retn
  2563                                  
  2564                                  ;-49     j=strlen(p);
  2565                                  
  2566                                  @@searchLabel95:
  2567 00000D40 FF76FC                   push word [bp-4]
  2568 00000D43 E8FB11                   call strlen
  2569 00000D46 83C402                   add  sp, 2
  2570 00000D49 8946FA                   mov word [bp-6], ax
  2571                                  
  2572                                  ;-50     p=p+j; p++; LIx++;
  2573                                  
  2574 00000D4C 8B46FC                   mov ax, [bp-4]
  2575 00000D4F 0346FA                   add ax, [bp-6]
  2576 00000D52 8946FC                   mov word [bp-4], ax
  2577 00000D55 FF46FC                   inc  word [bp-4]
  2578 00000D58 FF46FE                   inc  word [bp-2]
  2579                                  
  2580                                  ;-51   }
  2581                                  
  2582                                  
  2583                                  ;-52   return 0;
  2584                                  
  2585 00000D5B EBBE                     jmp @@searchLabel93
  2586                                  @@searchLabel94:
  2587 00000D5D 66B800000000             mov eax, 0
  2588 00000D63 E90000                   jmp @@retn
  2589                                  
  2590                                  ;-53 }
  2591                                  
  2592                                  
  2593                                  ;-54 int getVariable() { char c;
  2594                                  
  2595 00000D66 C9                      @@retn: LEAVE
  2596 00000D67 C3                       ret
  2597                                  ; ENDP
  2598                                  
  2599                                  getVariable:  ; *** PROC ***
  2600                                  
  2601                                  ;-55   storeLabel();
  2602                                  
  2603                                  ;Function : getVariable, Number of local variables: 1
  2604                                  ;   # type sign width line used address name   list of local variables
  2605                                  ;  200 var sign byte    54 NULL bp-2    c;
  2606 00000D68 C8020000                 ENTER  2,0
  2607 00000D6C E84FFF                   call storeLabel
  2608                                  
  2609                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2610                                  
  2611 00000D6F E8AEFE                   call getTokeType
  2612 00000D72 A0[3C00]                 mov al, [TokeType]
  2613 00000D75 3C03                     cmp al, 3
  2614 00000D77 0F85CC00                 jne @@getVariable96
  2615                                  
  2616                                  ;-57     lookCode();
  2617                                  
  2618 00000D7B E82201                   call lookCode
  2619                                  
  2620                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2621                                  
  2622 00000D7E A0[3E00]                 mov al, [CodeType]
  2623 00000D81 3CC8                     cmp al, 200
  2624 00000D83 0F8D0900                 jge @@getVariable97
  2625 00000D87 68[520E]                 push getVariable_0
  2626 00000D8A E8F50C                   call errorexit
  2627 00000D8D 83C402                   add  sp, 2
  2628                                  
  2629                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2630                                  
  2631                                  @@getVariable97:
  2632 00000D90 A0[3E00]                 mov al, [CodeType]
  2633 00000D93 3CCF                     cmp al, 207
  2634 00000D95 0F8E0900                 jle @@getVariable98
  2635 00000D99 68[6A0E]                 push getVariable_1
  2636 00000D9C E8E30C                   call errorexit
  2637 00000D9F 83C402                   add  sp, 2
  2638                                  
  2639                                  ;-60     if (CodeType== 200) {// DB
  2640                                  
  2641                                  @@getVariable98:
  2642 00000DA2 A0[3E00]                 mov al, [CodeType]
  2643 00000DA5 3CC8                     cmp al, 200
  2644 00000DA7 0F856A00                 jne @@getVariable99
  2645                                  
  2646                                  ;-61       do { getTokeType();
  2647                                  
  2648                                  @@getVariable100:
  2649 00000DAB E872FE                   call getTokeType
  2650                                  
  2651                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2652                                  
  2653 00000DAE A0[3C00]                 mov al, [TokeType]
  2654 00000DB1 3C01                     cmp al, 1
  2655 00000DB3 0F850D00                 jne @@getVariable101
  2656 00000DB7 FF36[2600]               push word [SymbolInt]
  2657 00000DBB E816FC                   call genCode8
  2658 00000DBE 83C402                   add  sp, 2
  2659                                  
  2660                                  ;-63         else {
  2661                                  
  2662 00000DC1 E94100                   jmp @@getVariable102
  2663                                  @@getVariable101:
  2664                                  
  2665                                  ;-64           skipBlank();
  2666                                  
  2667 00000DC4 E8FA02                   call skipBlank
  2668                                  
  2669                                  ;-65           if (isToken('"')) {
  2670                                  
  2671 00000DC7 6A22                     push 34
  2672 00000DC9 E8D101                   call isToken
  2673 00000DCC 83C402                   add  sp, 2
  2674 00000DCF 08C0                     or  al, al
  2675 00000DD1 0F843000                 je @@getVariable103
  2676                                  
  2677                                  ;-66             do { c= *InputPtr;
  2678                                  
  2679                                  @@getVariable104:
  2680 00000DD5 8B1E[2800]               mov bx, [InputPtr]
  2681 00000DD9 8A07                     mov al, [bx]
  2682 00000DDB B400                     mov ah, 0
  2683 00000DDD 8846FE                   mov byte [bp-2], al
  2684                                  
  2685                                  ;-67               genCode8(c);
  2686                                  
  2687 00000DE0 8A46FE                   mov al, byte [bp-2]
  2688 00000DE3 B400                     mov ah, 0
  2689 00000DE5 50                       push ax
  2690 00000DE6 E8EBFB                   call genCode8
  2691 00000DE9 83C402                   add  sp, 2
  2692                                  
  2693                                  ;-68               InputPtr++;
  2694                                  
  2695 00000DEC FF06[2800]               inc  word [InputPtr]
  2696                                  
  2697                                  ;-69             } while (*InputPtr != '"' );
  2698                                  
  2699 00000DF0 8B1E[2800]               mov bx, [InputPtr]
  2700 00000DF4 8A07                     mov al, [bx]
  2701 00000DF6 B400                     mov ah, 0
  2702 00000DF8 83F822                   cmp ax, 34
  2703 00000DFB 0F840200                 je  @@getVariable105
  2704 00000DFF EBD4                     jmp @@getVariable104
  2705                                  @@getVariable105:
  2706                                  
  2707                                  ;-70             InputPtr++;
  2708                                  
  2709 00000E01 FF06[2800]               inc  word [InputPtr]
  2710                                  
  2711                                  ;-71           }
  2712                                  
  2713                                  
  2714                                  ;-72         }
  2715                                  
  2716                                  @@getVariable103:
  2717                                  
  2718                                  ;-73       } while (isToken(','));
  2719                                  
  2720                                  @@getVariable102:
  2721 00000E05 6A2C                     push 44
  2722 00000E07 E89301                   call isToken
  2723 00000E0A 83C402                   add  sp, 2
  2724 00000E0D 08C0                     or  al, al
  2725 00000E0F 0F840200                 je @@getVariable106
  2726 00000E13 EB96                     jmp @@getVariable100
  2727                                  @@getVariable106:
  2728                                  
  2729                                  ;-74     }
  2730                                  
  2731                                  
  2732                                  ;-75     if (CodeType== 201) {// DW
  2733                                  
  2734                                  @@getVariable99:
  2735 00000E15 A0[3E00]                 mov al, [CodeType]
  2736 00000E18 3CC9                     cmp al, 201
  2737 00000E1A 0F852600                 jne @@getVariable107
  2738                                  
  2739                                  ;-76       do { getTokeType();
  2740                                  
  2741                                  @@getVariable108:
  2742 00000E1E E8FFFD                   call getTokeType
  2743                                  
  2744                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2745                                  
  2746 00000E21 A0[3C00]                 mov al, [TokeType]
  2747 00000E24 3C01                     cmp al, 1
  2748 00000E26 0F850A00                 jne @@getVariable109
  2749 00000E2A FF36[2600]               push word [SymbolInt]
  2750 00000E2E E8D5FB                   call genCode16
  2751 00000E31 83C402                   add  sp, 2
  2752                                  
  2753                                  ;-78       } while (isToken(','));
  2754                                  
  2755                                  @@getVariable109:
  2756 00000E34 6A2C                     push 44
  2757 00000E36 E86401                   call isToken
  2758 00000E39 83C402                   add  sp, 2
  2759 00000E3C 08C0                     or  al, al
  2760 00000E3E 0F840200                 je @@getVariable110
  2761 00000E42 EBDA                     jmp @@getVariable108
  2762                                  @@getVariable110:
  2763                                  
  2764                                  ;-79     }
  2765                                  
  2766                                  
  2767                                  ;-80   }
  2768                                  
  2769                                  @@getVariable107:
  2770                                  
  2771                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2772                                  
  2773 00000E44 E90900                   jmp @@getVariable111
  2774                                  @@getVariable96:
  2775 00000E47 68[820E]                 push getVariable_2
  2776 00000E4A E8350C                   call errorexit
  2777 00000E4D 83C402                   add  sp, 2
  2778                                  
  2779                                  ;-82 }
  2780                                  
  2781                                  @@getVariable111:
  2782                                  
  2783                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2784 00000E50 C9                       LEAVE
  2785 00000E51 C3                       ret
  2786                                  ; ENDP
  2787 00000E52 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2788 00000E5B 422C572C4420657870-
  2789 00000E64 656374656400       
  2790 00000E6A 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2791 00000E73 422C572C4420657870-
  2792 00000E7C 656374656400       
  2793 00000E82 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2794 00000E8B 6F7220524553422C57-
  2795 00000E94 2C4420657870656374-
  2796 00000E9D 656400             
  2797                                  
  2798                                  lookCode:  ; *** PROC ***
  2799                                  
  2800                                  ;-84   CodeType=0;
  2801                                  
  2802 00000EA0 66B800000000             mov eax, 0
  2803 00000EA6 A2[3E00]                 mov byte [CodeType], al
  2804                                  
  2805                                  ;-85   OpCodePtr= &I_START;
  2806                                  
  2807 00000EA9 B8[5D00]                 mov ax, I_START
  2808 00000EAC A3[4E00]                 mov word [OpCodePtr], ax
  2809                                  
  2810                                  ;-86   OpCodePtr++;
  2811                                  
  2812 00000EAF FF06[4E00]               inc  word [OpCodePtr]
  2813                                  
  2814                                  ;-87   do  {
  2815                                  
  2816                                  @@lookCode112:
  2817                                  
  2818                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2819                                  
  2820 00000EB3 FF36[4E00]               push word [OpCodePtr]
  2821 00000EB7 8D064F75                 lea  ax, [SymbolUpper]
  2822 00000EBB 50                       push ax
  2823 00000EBC E81911                   call eqstr
  2824 00000EBF 83C404                   add  sp, 4
  2825 00000EC2 08C0                     or  al, al
  2826 00000EC4 0F842700                 je @@lookCode113
  2827                                  
  2828                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2829                                  
  2830                                  @@lookCode114:
  2831 00000EC8 8B1E[4E00]               mov bx, [OpCodePtr]
  2832 00000ECC 8A07                     mov al, [bx]
  2833 00000ECE B400                     mov ah, 0
  2834 00000ED0 83F800                   cmp ax, 0
  2835 00000ED3 0F840600                 je  @@lookCode115
  2836 00000ED7 FF06[4E00]               inc  word [OpCodePtr]
  2837                                  
  2838                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2839                                  
  2840 00000EDB EBEB                     jmp @@lookCode114
  2841                                  @@lookCode115:
  2842 00000EDD FF06[4E00]               inc  word [OpCodePtr]
  2843 00000EE1 8B1E[4E00]               mov bx, [OpCodePtr]
  2844 00000EE5 8A07                     mov al, [bx]
  2845 00000EE7 B400                     mov ah, 0
  2846 00000EE9 A2[3E00]                 mov byte [CodeType], al
  2847                                  
  2848                                  ;-91       return;
  2849                                  
  2850 00000EEC E92A00                   jmp @@retn
  2851                                  
  2852                                  ;-92     }
  2853                                  
  2854                                  
  2855                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2856                                  
  2857                                  @@lookCode113:
  2858                                  @@lookCode116:
  2859 00000EEF 8B1E[4E00]               mov bx, [OpCodePtr]
  2860 00000EF3 8A07                     mov al, [bx]
  2861 00000EF5 B400                     mov ah, 0
  2862 00000EF7 3DF100                   cmp ax, 241
  2863 00000EFA 0F840600                 je  @@lookCode117
  2864 00000EFE FF06[4E00]               inc  word [OpCodePtr]
  2865                                  
  2866                                  ;-94   OpCodePtr++;
  2867                                  
  2868 00000F02 EBEB                     jmp @@lookCode116
  2869                                  @@lookCode117:
  2870 00000F04 FF06[4E00]               inc  word [OpCodePtr]
  2871                                  
  2872                                  ;-95   } while(*OpCodePtr!=0);
  2873                                  
  2874 00000F08 8B1E[4E00]               mov bx, [OpCodePtr]
  2875 00000F0C 8A07                     mov al, [bx]
  2876 00000F0E B400                     mov ah, 0
  2877 00000F10 83F800                   cmp ax, 0
  2878 00000F13 0F840200                 je  @@lookCode118
  2879 00000F17 EB9A                     jmp @@lookCode112
  2880                                  @@lookCode118:
  2881                                  
  2882                                  ;-96 }
  2883                                  
  2884                                  
  2885                                  ;-97 int getCodeSize() {
  2886                                  
  2887                                  @@retn:
  2888 00000F19 C3                       ret
  2889                                  ; ENDP
  2890                                  
  2891                                  getCodeSize:  ; *** PROC ***
  2892                                  
  2893                                  ;-98   if (TokeType ==ALNUME) {
  2894                                  
  2895 00000F1A A0[3C00]                 mov al, [TokeType]
  2896 00000F1D 3C03                     cmp al, 3
  2897 00000F1F 0F856000                 jne @@getCodeSize119
  2898                                  
  2899                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2900                                  
  2901 00000F23 68[8D0F]                 push getCodeSize_0
  2902 00000F26 8D064F75                 lea  ax, [SymbolUpper]
  2903 00000F2A 50                       push ax
  2904 00000F2B E8AA10                   call eqstr
  2905 00000F2E 83C404                   add  sp, 4
  2906 00000F31 08C0                     or  al, al
  2907 00000F33 0F840C00                 je @@getCodeSize120
  2908 00000F37 E8E6FC                   call getTokeType
  2909 00000F3A 66B801000000             mov eax, 1
  2910 00000F40 E94900                   jmp @@retn
  2911                                  
  2912                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2913                                  
  2914                                  @@getCodeSize120:
  2915 00000F43 68[920F]                 push getCodeSize_1
  2916 00000F46 8D064F75                 lea  ax, [SymbolUpper]
  2917 00000F4A 50                       push ax
  2918 00000F4B E88A10                   call eqstr
  2919 00000F4E 83C404                   add  sp, 4
  2920 00000F51 08C0                     or  al, al
  2921 00000F53 0F840C00                 je @@getCodeSize121
  2922 00000F57 E8C6FC                   call getTokeType
  2923 00000F5A 66B802000000             mov eax, 2
  2924 00000F60 E92900                   jmp @@retn
  2925                                  
  2926                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2927                                  
  2928                                  @@getCodeSize121:
  2929 00000F63 68[970F]                 push getCodeSize_2
  2930 00000F66 8D064F75                 lea  ax, [SymbolUpper]
  2931 00000F6A 50                       push ax
  2932 00000F6B E86A10                   call eqstr
  2933 00000F6E 83C404                   add  sp, 4
  2934 00000F71 08C0                     or  al, al
  2935 00000F73 0F840C00                 je @@getCodeSize122
  2936 00000F77 E8A6FC                   call getTokeType
  2937 00000F7A 66B803000000             mov eax, 3
  2938 00000F80 E90900                   jmp @@retn
  2939                                  
  2940                                  ;-102   } return 0;
  2941                                  
  2942                                  @@getCodeSize122:
  2943                                  @@getCodeSize119:
  2944 00000F83 66B800000000             mov eax, 0
  2945 00000F89 E90000                   jmp @@retn
  2946                                  
  2947                                  ;-103 }
  2948                                  
  2949                                  
  2950                                  ;-104 int isToken(char c) {
  2951                                  
  2952                                  @@retn:
  2953 00000F8C C3                       ret
  2954                                  ; ENDP
  2955 00000F8D 4259544500              getCodeSize_0 db "BYTE",0
  2956 00000F92 574F524400              getCodeSize_1 db "WORD",0
  2957 00000F97 44574F524400            getCodeSize_2 db "DWORD",0
  2958                                  
  2959                                  isToken:  ; *** PROC ***
  2960                                  
  2961                                  ;-105   skipBlank();
  2962                                  
  2963                                  ;Function : isToken, Number of local variables: 1
  2964                                  ;   # type sign width line used address name   list of local variables
  2965                                  ;  200 var sign byte   104 NULL bp+4    c;
  2966 00000F9D C8000000                 ENTER  0,0
  2967 00000FA1 E81D01                   call skipBlank
  2968                                  
  2969                                  ;-106   if (*InputPtr == c) {
  2970                                  
  2971 00000FA4 8B1E[2800]               mov bx, [InputPtr]
  2972 00000FA8 8A07                     mov al, [bx]
  2973 00000FAA B400                     mov ah, 0
  2974 00000FAC 3A4604                   cmp al, [bp+4]
  2975 00000FAF 0F850D00                 jne @@isToken123
  2976                                  
  2977                                  ;-107     InputPtr++; return 1;} return 0;
  2978                                  
  2979 00000FB3 FF06[2800]               inc  word [InputPtr]
  2980 00000FB7 66B801000000             mov eax, 1
  2981 00000FBD E90900                   jmp @@retn
  2982                                  @@isToken123:
  2983 00000FC0 66B800000000             mov eax, 0
  2984 00000FC6 E90000                   jmp @@retn
  2985                                  
  2986                                  ;-108 }
  2987                                  
  2988                                  
  2989                                  ;-109 int skipRest() {
  2990                                  
  2991 00000FC9 C9                      @@retn: LEAVE
  2992 00000FCA C3                       ret
  2993                                  ; ENDP
  2994                                  
  2995                                  skipRest:  ; *** PROC ***
  2996                                  
  2997                                  ;-110   getTokeType(); if(TokeType!=0)error1("extra char ignored");
  2998                                  
  2999 00000FCB E852FC                   call getTokeType
  3000 00000FCE A0[3C00]                 mov al, [TokeType]
  3001 00000FD1 3C00                     cmp al, 0
  3002 00000FD3 0F840900                 je  @@skipRest124
  3003 00000FD7 68[E10F]                 push skipRest_0
  3004 00000FDA E87409                   call error1
  3005 00000FDD 83C402                   add  sp, 2
  3006                                  
  3007                                  ;-111 }
  3008                                  
  3009                                  @@skipRest124:
  3010 00000FE0 C3                       ret
  3011                                  ; ENDP
  3012 00000FE1 657874726120636861-     skipRest_0 db "extra char ignored",0
  3013 00000FEA 722069676E6F726564-
  3014 00000FF3 00                 
  3015                                  ;Back to main program: AS.C
  3016                                  
  3017                                  ;-215 #include "HELPER.C"
  3018                                  
  3019                                  ;Use include file: HELPER.C
  3020                                  
  3021                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3022                                  
  3023                                  
  3024                                  getLine:  ; *** PROC ***
  3025                                  
  3026                                  ;-2   InputPtr= &InputBuf;
  3027                                  
  3028 00000FF4 B86E75                   mov ax, InputBuf
  3029 00000FF7 A3[2800]                 mov word [InputPtr], ax
  3030                                  
  3031                                  ;-3   *InputPtr=0;//if last line is empty
  3032                                  
  3033 00000FFA 66B800000000             mov eax, 0
  3034 00001000 8B1E[2800]               mov  bx, [InputPtr]
  3035 00001004 8807                     mov  [bx], al
  3036                                  
  3037                                  ;-4   do {
  3038                                  
  3039                                  @@getLine125:
  3040                                  
  3041                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3042                                  
  3043 00001006 6A01                     push 1
  3044 00001008 FF36[2A00]               push word [asm_fd]
  3045 0000100C 8D06[3600]               lea  ax, [DOS_ByteRead]
  3046 00001010 50                       push ax
  3047 00001011 E85F10                   call readRL
  3048 00001014 83C406                   add  sp, 6
  3049 00001017 A3[3400]                 mov word [DOS_NoBytes], ax
  3050                                  
  3051                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3052                                  
  3053 0000101A A1[3000]                 mov ax, [DOS_ERR]
  3054 0000101D 08C0                     or  al, al
  3055 0000101F 0F840900                 je @@getLine126
  3056 00001023 68[6B10]                 push getLine_0
  3057 00001026 E8590A                   call errorexit
  3058 00001029 83C402                   add  sp, 2
  3059                                  
  3060                                  ;-7     if (DOS_NoBytes == 0) return;
  3061                                  
  3062                                  @@getLine126:
  3063 0000102C A1[3400]                 mov ax, [DOS_NoBytes]
  3064 0000102F 83F800                   cmp ax, 0
  3065 00001032 0F850300                 jne @@getLine127
  3066 00001036 E93100                   jmp @@retn
  3067                                  
  3068                                  ;-8     *InputPtr = DOS_ByteRead;
  3069                                  
  3070                                  @@getLine127:
  3071 00001039 A0[3600]                 mov al, [DOS_ByteRead]
  3072 0000103C 8B1E[2800]               mov  bx, [InputPtr]
  3073 00001040 8807                     mov  [bx], al
  3074                                  
  3075                                  ;-9     InputPtr++;
  3076                                  
  3077 00001042 FF06[2800]               inc  word [InputPtr]
  3078                                  
  3079                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3080                                  
  3081 00001046 A0[3600]                 mov al, byte [DOS_ByteRead]
  3082 00001049 B400                     mov ah, 0
  3083 0000104B 50                       push ax
  3084 0000104C E82B00                   call ifEOL
  3085 0000104F 83C402                   add  sp, 2
  3086 00001052 3C00                     cmp al, 0
  3087 00001054 0F850200                 jne @@getLine128
  3088 00001058 EBAC                     jmp @@getLine125
  3089                                  @@getLine128:
  3090                                  
  3091                                  ;-11   InputPtr--;
  3092                                  
  3093 0000105A FF0E[2800]               dec  word [InputPtr]
  3094                                  
  3095                                  ;-12   *InputPtr=0;
  3096                                  
  3097 0000105E 66B800000000             mov eax, 0
  3098 00001064 8B1E[2800]               mov  bx, [InputPtr]
  3099 00001068 8807                     mov  [bx], al
  3100                                  
  3101                                  ;-13 }
  3102                                  
  3103                                  
  3104                                  ;-14 int ifEOL(char c) {
  3105                                  
  3106                                  @@retn:
  3107 0000106A C3                       ret
  3108                                  ; ENDP
  3109 0000106B 52656164696E672053-     getLine_0 db "Reading Source",0
  3110 00001074 6F7572636500       
  3111                                  
  3112                                  ifEOL:  ; *** PROC ***
  3113                                  
  3114                                  ;-15   if (c == 10) return 1;
  3115                                  
  3116                                  ;Function : ifEOL, Number of local variables: 1
  3117                                  ;   # type sign width line used address name   list of local variables
  3118                                  ;  200 var sign byte    14 NULL bp+4    c;
  3119 0000107A C8000000                 ENTER  0,0
  3120 0000107E 8A4604                   mov al, [bp+4]
  3121 00001081 3C0A                     cmp al, 10
  3122 00001083 0F850900                 jne @@ifEOL129
  3123 00001087 66B801000000             mov eax, 1
  3124 0000108D E92F00                   jmp @@retn
  3125                                  
  3126                                  ;-16   if (c == 13) {
  3127                                  
  3128                                  @@ifEOL129:
  3129 00001090 8A4604                   mov al, [bp+4]
  3130 00001093 3C0D                     cmp al, 13
  3131 00001095 0F851D00                 jne @@ifEOL130
  3132                                  
  3133                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3134                                  
  3135 00001099 6A01                     push 1
  3136 0000109B FF36[2A00]               push word [asm_fd]
  3137 0000109F 8D06[3600]               lea  ax, [DOS_ByteRead]
  3138 000010A3 50                       push ax
  3139 000010A4 E8CC0F                   call readRL
  3140 000010A7 83C406                   add  sp, 6
  3141 000010AA A3[3400]                 mov word [DOS_NoBytes], ax
  3142                                  
  3143                                  ;-18     return 1;}
  3144                                  
  3145 000010AD 66B801000000             mov eax, 1
  3146 000010B3 E90900                   jmp @@retn
  3147                                  
  3148                                  ;-19   return 0;
  3149                                  
  3150                                  @@ifEOL130:
  3151 000010B6 66B800000000             mov eax, 0
  3152 000010BC E90000                   jmp @@retn
  3153                                  
  3154                                  ;-20 }
  3155                                  
  3156                                  
  3157                                  ;-21 int skipBlank() {
  3158                                  
  3159 000010BF C9                      @@retn: LEAVE
  3160 000010C0 C3                       ret
  3161                                  ; ENDP
  3162                                  
  3163                                  skipBlank:  ; *** PROC ***
  3164                                  
  3165                                  ;-22   skipblank1:
  3166                                  
  3167                                  @@skipblank1:
  3168                                  
  3169                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3170                                  
  3171 000010C1 8B1E[2800]               mov bx, [InputPtr]
  3172 000010C5 8A07                     mov al, [bx]
  3173 000010C7 B400                     mov ah, 0
  3174 000010C9 83F820                   cmp ax, 32
  3175 000010CC 0F850600                 jne @@skipBlank131
  3176 000010D0 FF06[2800]               inc  word [InputPtr]
  3177 000010D4 EBEB                     jmp @@skipblank1
  3178                                  
  3179                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3180                                  
  3181                                  @@skipBlank131:
  3182 000010D6 8B1E[2800]               mov bx, [InputPtr]
  3183 000010DA 8A07                     mov al, [bx]
  3184 000010DC B400                     mov ah, 0
  3185 000010DE 83F809                   cmp ax, 9
  3186 000010E1 0F850600                 jne @@skipBlank132
  3187 000010E5 FF06[2800]               inc  word [InputPtr]
  3188 000010E9 EBD6                     jmp @@skipblank1
  3189                                  
  3190                                  ;-25 }
  3191                                  
  3192                                  @@skipBlank132:
  3193                                  
  3194                                  ;-26 int letterE(char c) {
  3195                                  
  3196 000010EB C3                       ret
  3197                                  ; ENDP
  3198                                  
  3199                                  letterE:  ; *** PROC ***
  3200                                  
  3201                                  ;-27   if (c=='_') return 1;
  3202                                  
  3203                                  ;Function : letterE, Number of local variables: 1
  3204                                  ;   # type sign width line used address name   list of local variables
  3205                                  ;  200 var sign byte    26 NULL bp+4    c;
  3206 000010EC C8000000                 ENTER  0,0
  3207 000010F0 8A4604                   mov al, [bp+4]
  3208 000010F3 3C5F                     cmp al, 95
  3209 000010F5 0F850900                 jne @@letterE133
  3210 000010F9 66B801000000             mov eax, 1
  3211 000010FF E97E00                   jmp @@retn
  3212                                  
  3213                                  ;-28   if (c=='.') return 1;
  3214                                  
  3215                                  @@letterE133:
  3216 00001102 8A4604                   mov al, [bp+4]
  3217 00001105 3C2E                     cmp al, 46
  3218 00001107 0F850900                 jne @@letterE134
  3219 0000110B 66B801000000             mov eax, 1
  3220 00001111 E96C00                   jmp @@retn
  3221                                  
  3222                                  ;-29   if (c=='?') return 1;
  3223                                  
  3224                                  @@letterE134:
  3225 00001114 8A4604                   mov al, [bp+4]
  3226 00001117 3C3F                     cmp al, 63
  3227 00001119 0F850900                 jne @@letterE135
  3228 0000111D 66B801000000             mov eax, 1
  3229 00001123 E95A00                   jmp @@retn
  3230                                  
  3231                                  ;-30   if (c=='$') return 1;
  3232                                  
  3233                                  @@letterE135:
  3234 00001126 8A4604                   mov al, [bp+4]
  3235 00001129 3C24                     cmp al, 36
  3236 0000112B 0F850900                 jne @@letterE136
  3237 0000112F 66B801000000             mov eax, 1
  3238 00001135 E94800                   jmp @@retn
  3239                                  
  3240                                  ;-31   if (c> 'z') return 0;
  3241                                  
  3242                                  @@letterE136:
  3243 00001138 8A4604                   mov al, [bp+4]
  3244 0000113B 3C7A                     cmp al, 122
  3245 0000113D 0F8E0900                 jle @@letterE137
  3246 00001141 66B800000000             mov eax, 0
  3247 00001147 E93600                   jmp @@retn
  3248                                  
  3249                                  ;-32   if (c< '@') return 0; // at included
  3250                                  
  3251                                  @@letterE137:
  3252 0000114A 8A4604                   mov al, [bp+4]
  3253 0000114D 3C40                     cmp al, 64
  3254 0000114F 0F8D0900                 jge @@letterE138
  3255 00001153 66B800000000             mov eax, 0
  3256 00001159 E92400                   jmp @@retn
  3257                                  
  3258                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3259                                  
  3260                                  @@letterE138:
  3261 0000115C 8A4604                   mov al, [bp+4]
  3262 0000115F 3C5A                     cmp al, 90
  3263 00001161 0F8E1200                 jle @@letterE139
  3264 00001165 8A4604                   mov al, [bp+4]
  3265 00001168 3C61                     cmp al, 97
  3266 0000116A 0F8D0900                 jge @@letterE140
  3267 0000116E 66B800000000             mov eax, 0
  3268 00001174 E90900                   jmp @@retn
  3269                                  @@letterE140:
  3270                                  
  3271                                  ;-34   return 1;
  3272                                  
  3273                                  @@letterE139:
  3274 00001177 66B801000000             mov eax, 1
  3275 0000117D E90000                   jmp @@retn
  3276                                  
  3277                                  ;-35 }
  3278                                  
  3279                                  
  3280                                  ;-36 int alnumE(char c) {
  3281                                  
  3282 00001180 C9                      @@retn: LEAVE
  3283 00001181 C3                       ret
  3284                                  ; ENDP
  3285                                  
  3286                                  alnumE:  ; *** PROC ***
  3287                                  
  3288                                  ;-37   if (digit(c)) return 1;
  3289                                  
  3290                                  ;Function : alnumE, Number of local variables: 1
  3291                                  ;   # type sign width line used address name   list of local variables
  3292                                  ;  200 var sign byte    36 NULL bp+4    c;
  3293 00001182 C8000000                 ENTER  0,0
  3294 00001186 8A4604                   mov al, byte [bp+4]
  3295 00001189 B400                     mov ah, 0
  3296 0000118B 50                       push ax
  3297 0000118C E8160E                   call digit
  3298 0000118F 83C402                   add  sp, 2
  3299 00001192 08C0                     or  al, al
  3300 00001194 0F840900                 je @@alnumE141
  3301 00001198 66B801000000             mov eax, 1
  3302 0000119E E92400                   jmp @@retn
  3303                                  
  3304                                  ;-38   if (letterE(c)) return 1;
  3305                                  
  3306                                  @@alnumE141:
  3307 000011A1 8A4604                   mov al, byte [bp+4]
  3308 000011A4 B400                     mov ah, 0
  3309 000011A6 50                       push ax
  3310 000011A7 E842FF                   call letterE
  3311 000011AA 83C402                   add  sp, 2
  3312 000011AD 08C0                     or  al, al
  3313 000011AF 0F840900                 je @@alnumE142
  3314 000011B3 66B801000000             mov eax, 1
  3315 000011B9 E90900                   jmp @@retn
  3316                                  
  3317                                  ;-39   return 0;
  3318                                  
  3319                                  @@alnumE142:
  3320 000011BC 66B800000000             mov eax, 0
  3321 000011C2 E90000                   jmp @@retn
  3322                                  
  3323                                  ;-40 }
  3324                                  
  3325                                  
  3326                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3327                                  
  3328 000011C5 C9                      @@retn: LEAVE
  3329 000011C6 C3                       ret
  3330                                  ; ENDP
  3331                                  
  3332                                  getDigit:  ; *** PROC ***
  3333                                  
  3334                                  ;-42   unsigned int CastInt;
  3335                                  
  3336                                  
  3337                                  ;-43   SymbolInt=0;
  3338                                  
  3339                                  ;Function : getDigit, Number of local variables: 2
  3340                                  ;   # type sign width line used address name   list of local variables
  3341                                  ;  200 var unsg byte    41 NULL bp+4    c
  3342                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3343 000011C7 C8020000                 ENTER  2,0
  3344 000011CB 66B800000000             mov eax, 0
  3345 000011D1 A3[2600]                 mov word [SymbolInt], ax
  3346                                  
  3347                                  ;-44   do {
  3348                                  
  3349                                  @@getDigit143:
  3350                                  
  3351                                  ;-45     c-='0';
  3352                                  
  3353 000011D4 806E0430                 sub  byte [bp+4], 48
  3354                                  
  3355                                  ;-46     SymbolInt=SymbolInt*10;
  3356                                  
  3357 000011D8 A1[2600]                 mov ax, [SymbolInt]
  3358 000011DB 66BB0A000000             mov ebx, 10
  3359 000011E1 66F7E3                   mul ebx
  3360 000011E4 A3[2600]                 mov word [SymbolInt], ax
  3361                                  
  3362                                  ;-47     ax=0; CastInt=c; //cast b2w
  3363                                  
  3364 000011E7 B80000                   mov  ax, 0
  3365 000011EA 8A4604                   mov al, [bp+4]
  3366 000011ED 8946FE                   mov word [bp-2], ax
  3367                                  
  3368                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3369                                  
  3370 000011F0 A1[2600]                 mov ax, [SymbolInt]
  3371 000011F3 0346FE                   add ax, [bp-2]
  3372 000011F6 A3[2600]                 mov word [SymbolInt], ax
  3373                                  
  3374                                  ;-49     InputPtr++;
  3375                                  
  3376 000011F9 FF06[2800]               inc  word [InputPtr]
  3377                                  
  3378                                  ;-50     c = *InputPtr;
  3379                                  
  3380 000011FD 8B1E[2800]               mov bx, [InputPtr]
  3381 00001201 8A07                     mov al, [bx]
  3382 00001203 B400                     mov ah, 0
  3383 00001205 884604                   mov byte [bp+4], al
  3384                                  
  3385                                  ;-51   } while(digit(c));
  3386                                  
  3387 00001208 8A4604                   mov al, byte [bp+4]
  3388 0000120B B400                     mov ah, 0
  3389 0000120D 50                       push ax
  3390 0000120E E8940D                   call digit
  3391 00001211 83C402                   add  sp, 2
  3392 00001214 08C0                     or  al, al
  3393 00001216 0F840200                 je @@getDigit144
  3394 0000121A EBB8                     jmp @@getDigit143
  3395                                  @@getDigit144:
  3396                                  
  3397                                  ;-52 }
  3398                                  
  3399                                  
  3400                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3401 0000121C C9                       LEAVE
  3402 0000121D C3                       ret
  3403                                  ; ENDP
  3404                                  
  3405                                  getName:  ; *** PROC ***
  3406                                  
  3407                                  ;-54   char *p;
  3408                                  
  3409                                  
  3410                                  ;-55   p = &Symbol;
  3411                                  
  3412                                  ;Function : getName, Number of local variables: 2
  3413                                  ;   # type sign width line used address name   list of local variables
  3414                                  ;  200 var unsg byte    53 NULL bp+4    c
  3415                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3416 0000121E C8020000                 ENTER  2,0
  3417 00001222 B83075                   mov ax, Symbol
  3418 00001225 8946FE                   mov word [bp-2], ax
  3419                                  
  3420                                  ;-56   *p = c;
  3421                                  
  3422 00001228 8A4604                   mov al, [bp+4]
  3423 0000122B 8B5EFE                   mov  bx, [bp-2]
  3424 0000122E 8807                     mov  [bx], al
  3425                                  
  3426                                  ;-57   p++;
  3427                                  
  3428 00001230 FF46FE                   inc  word [bp-2]
  3429                                  
  3430                                  ;-58   while (alnumE(c)) {
  3431                                  
  3432                                  @@getName145:
  3433 00001233 8A4604                   mov al, byte [bp+4]
  3434 00001236 B400                     mov ah, 0
  3435 00001238 50                       push ax
  3436 00001239 E846FF                   call alnumE
  3437 0000123C 83C402                   add  sp, 2
  3438 0000123F 08C0                     or  al, al
  3439 00001241 0F841C00                 je @@getName146
  3440                                  
  3441                                  ;-59     InputPtr++;
  3442                                  
  3443 00001245 FF06[2800]               inc  word [InputPtr]
  3444                                  
  3445                                  ;-60     c = *InputPtr;
  3446                                  
  3447 00001249 8B1E[2800]               mov bx, [InputPtr]
  3448 0000124D 8A07                     mov al, [bx]
  3449 0000124F B400                     mov ah, 0
  3450 00001251 884604                   mov byte [bp+4], al
  3451                                  
  3452                                  ;-61     *p = c;
  3453                                  
  3454 00001254 8A4604                   mov al, [bp+4]
  3455 00001257 8B5EFE                   mov  bx, [bp-2]
  3456 0000125A 8807                     mov  [bx], al
  3457                                  
  3458                                  ;-62     p++;
  3459                                  
  3460 0000125C FF46FE                   inc  word [bp-2]
  3461                                  
  3462                                  ;-63   }
  3463                                  
  3464                                  
  3465                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3466                                  
  3467 0000125F EBD2                     jmp @@getName145
  3468                                  @@getName146:
  3469 00001261 8A4604                   mov al, [bp+4]
  3470 00001264 3C3A                     cmp al, 58
  3471 00001266 0F850C00                 jne @@getName147
  3472 0000126A 66B801000000             mov eax, 1
  3473 00001270 A2[3B00]                 mov byte [isLabel], al
  3474 00001273 E90900                   jmp @@getName148
  3475                                  @@getName147:
  3476 00001276 66B800000000             mov eax, 0
  3477 0000127C A2[3B00]                 mov byte [isLabel], al
  3478                                  
  3479                                  ;-65   p--;
  3480                                  
  3481                                  @@getName148:
  3482 0000127F FF4EFE                   dec  word [bp-2]
  3483                                  
  3484                                  ;-66   *p = 0;
  3485                                  
  3486 00001282 66B800000000             mov eax, 0
  3487 00001288 8B5EFE                   mov  bx, [bp-2]
  3488 0000128B 8807                     mov  [bx], al
  3489                                  
  3490                                  ;-67   strcpy(SymbolUpper, Symbol);
  3491                                  
  3492 0000128D 8D063075                 lea  ax, [Symbol]
  3493 00001291 50                       push ax
  3494 00001292 8D064F75                 lea  ax, [SymbolUpper]
  3495 00001296 50                       push ax
  3496 00001297 E8D20C                   call strcpy
  3497 0000129A 83C404                   add  sp, 4
  3498                                  
  3499                                  ;-68   toupper(SymbolUpper);
  3500                                  
  3501 0000129D 8D064F75                 lea  ax, [SymbolUpper]
  3502 000012A1 50                       push ax
  3503 000012A2 E8590C                   call toupper
  3504 000012A5 83C402                   add  sp, 2
  3505                                  
  3506                                  ;-69 }
  3507                                  
  3508                                  
  3509                                  ;-70 int testReg() {
  3510 000012A8 C9                       LEAVE
  3511 000012A9 C3                       ret
  3512                                  ; ENDP
  3513                                  
  3514                                  testReg:  ; *** PROC ***
  3515                                  
  3516                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3517                                  
  3518                                  
  3519                                  ;-72   RegType=0;
  3520                                  
  3521 000012AA 66B800000000             mov eax, 0
  3522 000012B0 A2[4200]                 mov byte [RegType], al
  3523                                  
  3524                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3525                                  
  3526 000012B3 8D063075                 lea  ax, [Symbol]
  3527 000012B7 50                       push ax
  3528 000012B8 E8860C                   call strlen
  3529 000012BB 83C402                   add  sp, 2
  3530 000012BE 3C02                     cmp al, 2
  3531 000012C0 0F8D0900                 jge @@testReg149
  3532 000012C4 66B800000000             mov eax, 0
  3533 000012CA E9B603                   jmp @@retn
  3534                                  
  3535                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3536                                  
  3537                                  @@testReg149:
  3538 000012CD 8D063075                 lea  ax, [Symbol]
  3539 000012D1 50                       push ax
  3540 000012D2 E86C0C                   call strlen
  3541 000012D5 83C402                   add  sp, 2
  3542 000012D8 3C03                     cmp al, 3
  3543 000012DA 0F8E0900                 jle @@testReg150
  3544 000012DE 66B800000000             mov eax, 0
  3545 000012E4 E99C03                   jmp @@retn
  3546                                  
  3547                                  ;-75   RegType=BYTE;
  3548                                  
  3549                                  @@testReg150:
  3550 000012E7 66B801000000             mov eax, 1
  3551 000012ED A2[4200]                 mov byte [RegType], al
  3552                                  
  3553                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3554                                  
  3555 000012F0 68[8416]                 push testReg_0
  3556 000012F3 8D064F75                 lea  ax, [SymbolUpper]
  3557 000012F7 50                       push ax
  3558 000012F8 E8DD0C                   call eqstr
  3559 000012FB 83C404                   add  sp, 4
  3560 000012FE 08C0                     or  al, al
  3561 00001300 0F840900                 je @@testReg151
  3562 00001304 66B800000000             mov eax, 0
  3563 0000130A E97603                   jmp @@retn
  3564                                  
  3565                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3566                                  
  3567                                  @@testReg151:
  3568 0000130D 68[8716]                 push testReg_1
  3569 00001310 8D064F75                 lea  ax, [SymbolUpper]
  3570 00001314 50                       push ax
  3571 00001315 E8C00C                   call eqstr
  3572 00001318 83C404                   add  sp, 4
  3573 0000131B 08C0                     or  al, al
  3574 0000131D 0F840900                 je @@testReg152
  3575 00001321 66B801000000             mov eax, 1
  3576 00001327 E95903                   jmp @@retn
  3577                                  
  3578                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3579                                  
  3580                                  @@testReg152:
  3581 0000132A 68[8A16]                 push testReg_2
  3582 0000132D 8D064F75                 lea  ax, [SymbolUpper]
  3583 00001331 50                       push ax
  3584 00001332 E8A30C                   call eqstr
  3585 00001335 83C404                   add  sp, 4
  3586 00001338 08C0                     or  al, al
  3587 0000133A 0F840900                 je @@testReg153
  3588 0000133E 66B802000000             mov eax, 2
  3589 00001344 E93C03                   jmp @@retn
  3590                                  
  3591                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3592                                  
  3593                                  @@testReg153:
  3594 00001347 68[8D16]                 push testReg_3
  3595 0000134A 8D064F75                 lea  ax, [SymbolUpper]
  3596 0000134E 50                       push ax
  3597 0000134F E8860C                   call eqstr
  3598 00001352 83C404                   add  sp, 4
  3599 00001355 08C0                     or  al, al
  3600 00001357 0F840900                 je @@testReg154
  3601 0000135B 66B803000000             mov eax, 3
  3602 00001361 E91F03                   jmp @@retn
  3603                                  
  3604                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3605                                  
  3606                                  @@testReg154:
  3607 00001364 68[9016]                 push testReg_4
  3608 00001367 8D064F75                 lea  ax, [SymbolUpper]
  3609 0000136B 50                       push ax
  3610 0000136C E8690C                   call eqstr
  3611 0000136F 83C404                   add  sp, 4
  3612 00001372 08C0                     or  al, al
  3613 00001374 0F840900                 je @@testReg155
  3614 00001378 66B804000000             mov eax, 4
  3615 0000137E E90203                   jmp @@retn
  3616                                  
  3617                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3618                                  
  3619                                  @@testReg155:
  3620 00001381 68[9316]                 push testReg_5
  3621 00001384 8D064F75                 lea  ax, [SymbolUpper]
  3622 00001388 50                       push ax
  3623 00001389 E84C0C                   call eqstr
  3624 0000138C 83C404                   add  sp, 4
  3625 0000138F 08C0                     or  al, al
  3626 00001391 0F840900                 je @@testReg156
  3627 00001395 66B805000000             mov eax, 5
  3628 0000139B E9E502                   jmp @@retn
  3629                                  
  3630                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3631                                  
  3632                                  @@testReg156:
  3633 0000139E 68[9616]                 push testReg_6
  3634 000013A1 8D064F75                 lea  ax, [SymbolUpper]
  3635 000013A5 50                       push ax
  3636 000013A6 E82F0C                   call eqstr
  3637 000013A9 83C404                   add  sp, 4
  3638 000013AC 08C0                     or  al, al
  3639 000013AE 0F840900                 je @@testReg157
  3640 000013B2 66B806000000             mov eax, 6
  3641 000013B8 E9C802                   jmp @@retn
  3642                                  
  3643                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3644                                  
  3645                                  @@testReg157:
  3646 000013BB 68[9916]                 push testReg_7
  3647 000013BE 8D064F75                 lea  ax, [SymbolUpper]
  3648 000013C2 50                       push ax
  3649 000013C3 E8120C                   call eqstr
  3650 000013C6 83C404                   add  sp, 4
  3651 000013C9 08C0                     or  al, al
  3652 000013CB 0F840900                 je @@testReg158
  3653 000013CF 66B807000000             mov eax, 7
  3654 000013D5 E9AB02                   jmp @@retn
  3655                                  
  3656                                  ;-84   RegType=WORD;
  3657                                  
  3658                                  @@testReg158:
  3659 000013D8 66B802000000             mov eax, 2
  3660 000013DE A2[4200]                 mov byte [RegType], al
  3661                                  
  3662                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3663                                  
  3664 000013E1 68[9C16]                 push testReg_8
  3665 000013E4 8D064F75                 lea  ax, [SymbolUpper]
  3666 000013E8 50                       push ax
  3667 000013E9 E8EC0B                   call eqstr
  3668 000013EC 83C404                   add  sp, 4
  3669 000013EF 08C0                     or  al, al
  3670 000013F1 0F840900                 je @@testReg159
  3671 000013F5 66B800000000             mov eax, 0
  3672 000013FB E98502                   jmp @@retn
  3673                                  
  3674                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3675                                  
  3676                                  @@testReg159:
  3677 000013FE 68[9F16]                 push testReg_9
  3678 00001401 8D064F75                 lea  ax, [SymbolUpper]
  3679 00001405 50                       push ax
  3680 00001406 E8CF0B                   call eqstr
  3681 00001409 83C404                   add  sp, 4
  3682 0000140C 08C0                     or  al, al
  3683 0000140E 0F840900                 je @@testReg160
  3684 00001412 66B801000000             mov eax, 1
  3685 00001418 E96802                   jmp @@retn
  3686                                  
  3687                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3688                                  
  3689                                  @@testReg160:
  3690 0000141B 68[A216]                 push testReg_10
  3691 0000141E 8D064F75                 lea  ax, [SymbolUpper]
  3692 00001422 50                       push ax
  3693 00001423 E8B20B                   call eqstr
  3694 00001426 83C404                   add  sp, 4
  3695 00001429 08C0                     or  al, al
  3696 0000142B 0F840900                 je @@testReg161
  3697 0000142F 66B802000000             mov eax, 2
  3698 00001435 E94B02                   jmp @@retn
  3699                                  
  3700                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3701                                  
  3702                                  @@testReg161:
  3703 00001438 68[A516]                 push testReg_11
  3704 0000143B 8D064F75                 lea  ax, [SymbolUpper]
  3705 0000143F 50                       push ax
  3706 00001440 E8950B                   call eqstr
  3707 00001443 83C404                   add  sp, 4
  3708 00001446 08C0                     or  al, al
  3709 00001448 0F840900                 je @@testReg162
  3710 0000144C 66B803000000             mov eax, 3
  3711 00001452 E92E02                   jmp @@retn
  3712                                  
  3713                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3714                                  
  3715                                  @@testReg162:
  3716 00001455 68[A816]                 push testReg_12
  3717 00001458 8D064F75                 lea  ax, [SymbolUpper]
  3718 0000145C 50                       push ax
  3719 0000145D E8780B                   call eqstr
  3720 00001460 83C404                   add  sp, 4
  3721 00001463 08C0                     or  al, al
  3722 00001465 0F840900                 je @@testReg163
  3723 00001469 66B804000000             mov eax, 4
  3724 0000146F E91102                   jmp @@retn
  3725                                  
  3726                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3727                                  
  3728                                  @@testReg163:
  3729 00001472 68[AB16]                 push testReg_13
  3730 00001475 8D064F75                 lea  ax, [SymbolUpper]
  3731 00001479 50                       push ax
  3732 0000147A E85B0B                   call eqstr
  3733 0000147D 83C404                   add  sp, 4
  3734 00001480 08C0                     or  al, al
  3735 00001482 0F840900                 je @@testReg164
  3736 00001486 66B805000000             mov eax, 5
  3737 0000148C E9F401                   jmp @@retn
  3738                                  
  3739                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3740                                  
  3741                                  @@testReg164:
  3742 0000148F 68[AE16]                 push testReg_14
  3743 00001492 8D064F75                 lea  ax, [SymbolUpper]
  3744 00001496 50                       push ax
  3745 00001497 E83E0B                   call eqstr
  3746 0000149A 83C404                   add  sp, 4
  3747 0000149D 08C0                     or  al, al
  3748 0000149F 0F840900                 je @@testReg165
  3749 000014A3 66B806000000             mov eax, 6
  3750 000014A9 E9D701                   jmp @@retn
  3751                                  
  3752                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3753                                  
  3754                                  @@testReg165:
  3755 000014AC 68[B116]                 push testReg_15
  3756 000014AF 8D064F75                 lea  ax, [SymbolUpper]
  3757 000014B3 50                       push ax
  3758 000014B4 E8210B                   call eqstr
  3759 000014B7 83C404                   add  sp, 4
  3760 000014BA 08C0                     or  al, al
  3761 000014BC 0F840900                 je @@testReg166
  3762 000014C0 66B807000000             mov eax, 7
  3763 000014C6 E9BA01                   jmp @@retn
  3764                                  
  3765                                  ;-93   RegType=SEGREG;
  3766                                  
  3767                                  @@testReg166:
  3768 000014C9 66B804000000             mov eax, 4
  3769 000014CF A2[4200]                 mov byte [RegType], al
  3770                                  
  3771                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3772                                  
  3773 000014D2 68[B416]                 push testReg_16
  3774 000014D5 8D064F75                 lea  ax, [SymbolUpper]
  3775 000014D9 50                       push ax
  3776 000014DA E8FB0A                   call eqstr
  3777 000014DD 83C404                   add  sp, 4
  3778 000014E0 08C0                     or  al, al
  3779 000014E2 0F840900                 je @@testReg167
  3780 000014E6 66B800000000             mov eax, 0
  3781 000014EC E99401                   jmp @@retn
  3782                                  
  3783                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3784                                  
  3785                                  @@testReg167:
  3786 000014EF 68[B716]                 push testReg_17
  3787 000014F2 8D064F75                 lea  ax, [SymbolUpper]
  3788 000014F6 50                       push ax
  3789 000014F7 E8DE0A                   call eqstr
  3790 000014FA 83C404                   add  sp, 4
  3791 000014FD 08C0                     or  al, al
  3792 000014FF 0F840900                 je @@testReg168
  3793 00001503 66B801000000             mov eax, 1
  3794 00001509 E97701                   jmp @@retn
  3795                                  
  3796                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3797                                  
  3798                                  @@testReg168:
  3799 0000150C 68[BA16]                 push testReg_18
  3800 0000150F 8D064F75                 lea  ax, [SymbolUpper]
  3801 00001513 50                       push ax
  3802 00001514 E8C10A                   call eqstr
  3803 00001517 83C404                   add  sp, 4
  3804 0000151A 08C0                     or  al, al
  3805 0000151C 0F840900                 je @@testReg169
  3806 00001520 66B802000000             mov eax, 2
  3807 00001526 E95A01                   jmp @@retn
  3808                                  
  3809                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3810                                  
  3811                                  @@testReg169:
  3812 00001529 68[BD16]                 push testReg_19
  3813 0000152C 8D064F75                 lea  ax, [SymbolUpper]
  3814 00001530 50                       push ax
  3815 00001531 E8A40A                   call eqstr
  3816 00001534 83C404                   add  sp, 4
  3817 00001537 08C0                     or  al, al
  3818 00001539 0F840900                 je @@testReg170
  3819 0000153D 66B803000000             mov eax, 3
  3820 00001543 E93D01                   jmp @@retn
  3821                                  
  3822                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3823                                  
  3824                                  @@testReg170:
  3825 00001546 68[C016]                 push testReg_20
  3826 00001549 8D064F75                 lea  ax, [SymbolUpper]
  3827 0000154D 50                       push ax
  3828 0000154E E8870A                   call eqstr
  3829 00001551 83C404                   add  sp, 4
  3830 00001554 08C0                     or  al, al
  3831 00001556 0F840900                 je @@testReg171
  3832 0000155A 66B804000000             mov eax, 4
  3833 00001560 E92001                   jmp @@retn
  3834                                  
  3835                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3836                                  
  3837                                  @@testReg171:
  3838 00001563 68[C316]                 push testReg_21
  3839 00001566 8D064F75                 lea  ax, [SymbolUpper]
  3840 0000156A 50                       push ax
  3841 0000156B E86A0A                   call eqstr
  3842 0000156E 83C404                   add  sp, 4
  3843 00001571 08C0                     or  al, al
  3844 00001573 0F840900                 je @@testReg172
  3845 00001577 66B805000000             mov eax, 5
  3846 0000157D E90301                   jmp @@retn
  3847                                  
  3848                                  ;-100   RegType=DWORD;
  3849                                  
  3850                                  @@testReg172:
  3851 00001580 66B803000000             mov eax, 3
  3852 00001586 A2[4200]                 mov byte [RegType], al
  3853                                  
  3854                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3855                                  
  3856 00001589 68[C616]                 push testReg_22
  3857 0000158C 8D064F75                 lea  ax, [SymbolUpper]
  3858 00001590 50                       push ax
  3859 00001591 E8440A                   call eqstr
  3860 00001594 83C404                   add  sp, 4
  3861 00001597 08C0                     or  al, al
  3862 00001599 0F840900                 je @@testReg173
  3863 0000159D 66B800000000             mov eax, 0
  3864 000015A3 E9DD00                   jmp @@retn
  3865                                  
  3866                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3867                                  
  3868                                  @@testReg173:
  3869 000015A6 68[CA16]                 push testReg_23
  3870 000015A9 8D064F75                 lea  ax, [SymbolUpper]
  3871 000015AD 50                       push ax
  3872 000015AE E8270A                   call eqstr
  3873 000015B1 83C404                   add  sp, 4
  3874 000015B4 08C0                     or  al, al
  3875 000015B6 0F840900                 je @@testReg174
  3876 000015BA 66B801000000             mov eax, 1
  3877 000015C0 E9C000                   jmp @@retn
  3878                                  
  3879                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3880                                  
  3881                                  @@testReg174:
  3882 000015C3 68[CE16]                 push testReg_24
  3883 000015C6 8D064F75                 lea  ax, [SymbolUpper]
  3884 000015CA 50                       push ax
  3885 000015CB E80A0A                   call eqstr
  3886 000015CE 83C404                   add  sp, 4
  3887 000015D1 08C0                     or  al, al
  3888 000015D3 0F840900                 je @@testReg175
  3889 000015D7 66B802000000             mov eax, 2
  3890 000015DD E9A300                   jmp @@retn
  3891                                  
  3892                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3893                                  
  3894                                  @@testReg175:
  3895 000015E0 68[D216]                 push testReg_25
  3896 000015E3 8D064F75                 lea  ax, [SymbolUpper]
  3897 000015E7 50                       push ax
  3898 000015E8 E8ED09                   call eqstr
  3899 000015EB 83C404                   add  sp, 4
  3900 000015EE 08C0                     or  al, al
  3901 000015F0 0F840900                 je @@testReg176
  3902 000015F4 66B803000000             mov eax, 3
  3903 000015FA E98600                   jmp @@retn
  3904                                  
  3905                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3906                                  
  3907                                  @@testReg176:
  3908 000015FD 68[D616]                 push testReg_26
  3909 00001600 8D064F75                 lea  ax, [SymbolUpper]
  3910 00001604 50                       push ax
  3911 00001605 E8D009                   call eqstr
  3912 00001608 83C404                   add  sp, 4
  3913 0000160B 08C0                     or  al, al
  3914 0000160D 0F840900                 je @@testReg177
  3915 00001611 66B804000000             mov eax, 4
  3916 00001617 E96900                   jmp @@retn
  3917                                  
  3918                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3919                                  
  3920                                  @@testReg177:
  3921 0000161A 68[DA16]                 push testReg_27
  3922 0000161D 8D064F75                 lea  ax, [SymbolUpper]
  3923 00001621 50                       push ax
  3924 00001622 E8B309                   call eqstr
  3925 00001625 83C404                   add  sp, 4
  3926 00001628 08C0                     or  al, al
  3927 0000162A 0F840900                 je @@testReg178
  3928 0000162E 66B805000000             mov eax, 5
  3929 00001634 E94C00                   jmp @@retn
  3930                                  
  3931                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3932                                  
  3933                                  @@testReg178:
  3934 00001637 68[DE16]                 push testReg_28
  3935 0000163A 8D064F75                 lea  ax, [SymbolUpper]
  3936 0000163E 50                       push ax
  3937 0000163F E89609                   call eqstr
  3938 00001642 83C404                   add  sp, 4
  3939 00001645 08C0                     or  al, al
  3940 00001647 0F840900                 je @@testReg179
  3941 0000164B 66B806000000             mov eax, 6
  3942 00001651 E92F00                   jmp @@retn
  3943                                  
  3944                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3945                                  
  3946                                  @@testReg179:
  3947 00001654 68[E216]                 push testReg_29
  3948 00001657 8D064F75                 lea  ax, [SymbolUpper]
  3949 0000165B 50                       push ax
  3950 0000165C E87909                   call eqstr
  3951 0000165F 83C404                   add  sp, 4
  3952 00001662 08C0                     or  al, al
  3953 00001664 0F840900                 je @@testReg180
  3954 00001668 66B807000000             mov eax, 7
  3955 0000166E E91200                   jmp @@retn
  3956                                  
  3957                                  ;-109   RegType=0; return 0;
  3958                                  
  3959                                  @@testReg180:
  3960 00001671 66B800000000             mov eax, 0
  3961 00001677 A2[4200]                 mov byte [RegType], al
  3962 0000167A 66B800000000             mov eax, 0
  3963 00001680 E90000                   jmp @@retn
  3964                                  
  3965                                  ;-110 }
  3966                                  
  3967                                  @@retn:
  3968 00001683 C3                       ret
  3969                                  ; ENDP
  3970 00001684 414C00                  testReg_0 db "AL",0
  3971 00001687 434C00                  testReg_1 db "CL",0
  3972 0000168A 444C00                  testReg_2 db "DL",0
  3973 0000168D 424C00                  testReg_3 db "BL",0
  3974 00001690 414800                  testReg_4 db "AH",0
  3975 00001693 434800                  testReg_5 db "CH",0
  3976 00001696 444800                  testReg_6 db "DH",0
  3977 00001699 424800                  testReg_7 db "BH",0
  3978 0000169C 415800                  testReg_8 db "AX",0
  3979 0000169F 435800                  testReg_9 db "CX",0
  3980 000016A2 445800                  testReg_10 db "DX",0
  3981 000016A5 425800                  testReg_11 db "BX",0
  3982 000016A8 535000                  testReg_12 db "SP",0
  3983 000016AB 425000                  testReg_13 db "BP",0
  3984 000016AE 534900                  testReg_14 db "SI",0
  3985 000016B1 444900                  testReg_15 db "DI",0
  3986 000016B4 455300                  testReg_16 db "ES",0
  3987 000016B7 435300                  testReg_17 db "CS",0
  3988 000016BA 535300                  testReg_18 db "SS",0
  3989 000016BD 445300                  testReg_19 db "DS",0
  3990 000016C0 465300                  testReg_20 db "FS",0
  3991 000016C3 475300                  testReg_21 db "GS",0
  3992 000016C6 45415800                testReg_22 db "EAX",0
  3993 000016CA 45435800                testReg_23 db "ECX",0
  3994 000016CE 45445800                testReg_24 db "EDX",0
  3995 000016D2 45425800                testReg_25 db "EBX",0
  3996 000016D6 45535000                testReg_26 db "ESP",0
  3997 000016DA 45425000                testReg_27 db "EBP",0
  3998 000016DE 45534900                testReg_28 db "ESI",0
  3999 000016E2 45444900                testReg_29 db "EDI",0
  4000                                  ;Back to main program: AS.C
  4001                                  
  4002                                  ;-216 #include "OUTPUT.C"
  4003                                  
  4004                                  ;Use include file: OUTPUT.C
  4005                                  
  4006                                  ;-1 int printLine() { int i; char c;
  4007                                  
  4008                                  
  4009                                  printLine:  ; *** PROC ***
  4010                                  
  4011                                  ;-2   prs("\n"); printhex16(PCStart);
  4012                                  
  4013                                  ;Function : printLine, Number of local variables: 2
  4014                                  ;   # type sign width line used address name   list of local variables
  4015                                  ;  200 var sign word     1 NULL bp-2    i
  4016                                  ;  201 var sign byte     1 NULL bp-4    c;
  4017 000016E6 C8040000                 ENTER  4,0
  4018 000016EA 68[7B17]                 push printLine_0
  4019 000016ED E80401                   call prs
  4020 000016F0 83C402                   add  sp, 2
  4021 000016F3 FF36[3900]               push word [PCStart]
  4022 000016F7 E8EB01                   call printhex16
  4023 000016FA 83C402                   add  sp, 2
  4024                                  
  4025                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4026                                  
  4027 000016FD A1[4C00]                 mov ax, [OpPrintIndex]
  4028 00001700 83F800                   cmp ax, 0
  4029 00001703 0F850C00                 jne @@printLine181
  4030 00001707 68[7E17]                 push printLine_1
  4031 0000170A E8E700                   call prs
  4032 0000170D 83C402                   add  sp, 2
  4033                                  
  4034                                  ;-4   else {
  4035                                  
  4036 00001710 E95B00                   jmp @@printLine182
  4037                                  @@printLine181:
  4038                                  
  4039                                  ;-5     prc(PrintR);
  4040                                  
  4041 00001713 A0[5000]                 mov al, byte [PrintR]
  4042 00001716 B400                     mov ah, 0
  4043 00001718 50                       push ax
  4044 00001719 E87700                   call prc
  4045 0000171C 83C402                   add  sp, 2
  4046                                  
  4047                                  ;-6     i=0;
  4048                                  
  4049 0000171F 66B800000000             mov eax, 0
  4050 00001725 8946FE                   mov word [bp-2], ax
  4051                                  
  4052                                  ;-7     do {
  4053                                  
  4054                                  @@printLine183:
  4055                                  
  4056                                  ;-8       c=OpPos[i];
  4057                                  
  4058 00001728 8B5EFE                   mov bx, [bp-2]
  4059 0000172B 8A87B676                 mov al, [OpPos + bx]
  4060 0000172F 8846FC                   mov byte [bp-4], al
  4061                                  
  4062                                  ;-9       printhex8a(c); prc(' ');
  4063                                  
  4064 00001732 8A46FC                   mov al, byte [bp-4]
  4065 00001735 B400                     mov ah, 0
  4066 00001737 50                       push ax
  4067 00001738 E85C01                   call printhex8a
  4068 0000173B 83C402                   add  sp, 2
  4069 0000173E 6A20                     push 32
  4070 00001740 E85000                   call prc
  4071 00001743 83C402                   add  sp, 2
  4072                                  
  4073                                  ;-10       i++;
  4074                                  
  4075 00001746 FF46FE                   inc  word [bp-2]
  4076                                  
  4077                                  ;-11     } while(i < OpPrintIndex);
  4078                                  
  4079 00001749 8B46FE                   mov ax, [bp-2]
  4080 0000174C 3B06[4C00]               cmp ax, [OpPrintIndex]
  4081 00001750 0F8D0200                 jge @@printLine184
  4082 00001754 EBD2                     jmp @@printLine183
  4083                                  @@printLine184:
  4084                                  
  4085                                  ;-12     do {// fill rest with blank
  4086                                  
  4087                                  @@printLine185:
  4088                                  
  4089                                  ;-13       prs("   ");
  4090                                  
  4091 00001756 68[8F17]                 push printLine_2
  4092 00001759 E89800                   call prs
  4093 0000175C 83C402                   add  sp, 2
  4094                                  
  4095                                  ;-14       i++;
  4096                                  
  4097 0000175F FF46FE                   inc  word [bp-2]
  4098                                  
  4099                                  ;-15     } while(i < OPMAXLEN);
  4100                                  
  4101 00001762 8B46FE                   mov ax, [bp-2]
  4102 00001765 83F805                   cmp ax, 5
  4103 00001768 0F8D0200                 jge @@printLine186
  4104 0000176C EBE8                     jmp @@printLine185
  4105                                  @@printLine186:
  4106                                  
  4107                                  ;-16   }
  4108                                  
  4109                                  
  4110                                  ;-17   prscomment(InputBuf);
  4111                                  
  4112                                  @@printLine182:
  4113 0000176E 8D066E75                 lea  ax, [InputBuf]
  4114 00001772 50                       push ax
  4115 00001773 E85000                   call prscomment
  4116 00001776 83C402                   add  sp, 2
  4117                                  
  4118                                  ;-18 }
  4119                                  
  4120                                  
  4121                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4122 00001779 C9                       LEAVE
  4123 0000177A C3                       ret
  4124                                  ; ENDP
  4125 0000177B 5C6E00                  printLine_0 db "\n",0
  4126 0000177E 202020202020202020-     printLine_1 db "                ",0
  4127 00001787 2020202020202000   
  4128 0000178F 20202000                printLine_2 db "   ",0
  4129                                  
  4130                                  prc:  ; *** PROC ***
  4131                                  ;Function : prc, Number of local variables: 1
  4132                                  ;   # type sign width line used address name   list of local variables
  4133                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4134 00001793 C8000000                 ENTER  0,0
  4135 00001797 A0[2500]                 mov al, [LIST]
  4136 0000179A 08C0                     or  al, al
  4137 0000179C 0F841400                 je @@prc187
  4138 000017A0 807E040A                cmp byte [bp+4], 10
  4139 000017A4 0F850600                 jne @@prc188
  4140 000017A8 B80D00                   mov  ax, 13
  4141 000017AB E81A07                   call writetty
  4142                                  
  4143                                  ;-20      al=c; writetty(); }
  4144                                  
  4145                                  @@prc188:
  4146 000017AE 8A4604                   mov  al, [bp+4]
  4147 000017B1 E81407                   call writetty
  4148                                  
  4149                                  ;-21    fputcR(c,lst_fd); }
  4150                                  
  4151                                  @@prc187:
  4152 000017B4 FF36[2C00]               push word [lst_fd]
  4153 000017B8 8A4604                   mov al, byte [bp+4]
  4154 000017BB B400                     mov ah, 0
  4155 000017BD 50                       push ax
  4156 000017BE E8C708                   call fputcR
  4157 000017C1 83C404                   add  sp, 4
  4158                                  
  4159                                  ;-22 
  4160                                  
  4161                                  
  4162                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4163 000017C4 C9                       LEAVE
  4164 000017C5 C3                       ret
  4165                                  ; ENDP
  4166                                  
  4167                                  prscomment:  ; *** PROC ***
  4168                                  
  4169                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4170                                  
  4171                                  ;Function : prscomment, Number of local variables: 2
  4172                                  ;   # type sign width line used address name   list of local variables
  4173                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4174                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4175 000017C6 C8020000                 ENTER  2,0
  4176                                  @@prscomment189:
  4177 000017CA 8B5E04                   mov bx, [bp+4]
  4178 000017CD 8A07                     mov al, [bx]
  4179 000017CF B400                     mov ah, 0
  4180 000017D1 08C0                     or  al, al
  4181 000017D3 0F841B00                 je @@prscomment190
  4182 000017D7 8B5E04                   mov bx, [bp+4]
  4183 000017DA 8A07                     mov al, [bx]
  4184 000017DC B400                     mov ah, 0
  4185 000017DE 8846FE                   mov byte [bp-2], al
  4186 000017E1 8A46FE                   mov al, byte [bp-2]
  4187 000017E4 B400                     mov ah, 0
  4188 000017E6 50                       push ax
  4189 000017E7 E8A9FF                   call prc
  4190 000017EA 83C402                   add  sp, 2
  4191 000017ED FF4604                   inc  word [bp+4]
  4192                                  
  4193                                  ;-25 }
  4194                                  
  4195 000017F0 EBD8                     jmp @@prscomment189
  4196                                  @@prscomment190:
  4197                                  
  4198                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4199 000017F2 C9                       LEAVE
  4200 000017F3 C3                       ret
  4201                                  ; ENDP
  4202                                  
  4203                                  prs:  ; *** PROC ***
  4204                                  ;Function : prs, Number of local variables: 3
  4205                                  ;   # type sign width line used address name   list of local variables
  4206                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4207                                  ;  201 var unsg byte    26 NULL bp-2    c
  4208                                  ;  202 var sign word    26 NULL bp-4    com;
  4209 000017F4 C8040000                 ENTER  4,0
  4210 000017F8 66B800000000             mov eax, 0
  4211 000017FE 8946FC                   mov word [bp-4], ax
  4212                                  
  4213                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4214                                  
  4215                                  @@prs191:
  4216 00001801 8B5E04                   mov bx, [bp+4]
  4217 00001804 8A07                     mov al, [bx]
  4218 00001806 B400                     mov ah, 0
  4219 00001808 08C0                     or  al, al
  4220 0000180A 0F848700                 je @@prs192
  4221 0000180E 8B5E04                   mov bx, [bp+4]
  4222 00001811 8A07                     mov al, [bx]
  4223 00001813 B400                     mov ah, 0
  4224 00001815 8846FE                   mov byte [bp-2], al
  4225 00001818 8A46FE                   mov al, [bp-2]
  4226 0000181B 3C22                     cmp al, 34
  4227 0000181D 0F851E00                 jne @@prs193
  4228 00001821 8B46FC                   mov ax, [bp-4]
  4229 00001824 08C0                     or  al, al
  4230 00001826 0F840C00                 je @@prs194
  4231 0000182A 66B800000000             mov eax, 0
  4232 00001830 8946FC                   mov word [bp-4], ax
  4233 00001833 E90900                   jmp @@prs195
  4234                                  @@prs194:
  4235 00001836 66B801000000             mov eax, 1
  4236 0000183C 8946FC                   mov word [bp-4], ax
  4237                                  
  4238                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4239                                  
  4240                                  @@prs195:
  4241                                  @@prs193:
  4242 0000183F 8A46FE                   mov al, [bp-2]
  4243 00001842 3C5C                     cmp al, 92
  4244 00001844 0F853B00                 jne @@prs196
  4245 00001848 8B46FC                   mov ax, [bp-4]
  4246 0000184B 83F800                   cmp ax, 0
  4247 0000184E 0F853100                 jne @@prs197
  4248 00001852 FF4604                   inc  word [bp+4]
  4249 00001855 8B5E04                   mov bx, [bp+4]
  4250 00001858 8A07                     mov al, [bx]
  4251 0000185A B400                     mov ah, 0
  4252 0000185C 8846FE                   mov byte [bp-2], al
  4253                                  
  4254                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4255                                  
  4256 0000185F 8A46FE                   mov al, [bp-2]
  4257 00001862 3C6E                     cmp al, 110
  4258 00001864 0F850900                 jne @@prs198
  4259 00001868 66B80A000000             mov eax, 10
  4260 0000186E 8846FE                   mov byte [bp-2], al
  4261                                  @@prs198:
  4262 00001871 8A46FE                   mov al, [bp-2]
  4263 00001874 3C74                     cmp al, 116
  4264 00001876 0F850900                 jne @@prs199
  4265 0000187A 66B809000000             mov eax, 9
  4266 00001880 8846FE                   mov byte [bp-2], al
  4267                                  @@prs199:
  4268                                  @@prs197:
  4269                                  @@prs196:
  4270 00001883 8A46FE                   mov al, byte [bp-2]
  4271 00001886 B400                     mov ah, 0
  4272 00001888 50                       push ax
  4273 00001889 E807FF                   call prc
  4274 0000188C 83C402                   add  sp, 2
  4275 0000188F FF4604                   inc  word [bp+4]
  4276                                  
  4277                                  ;-30 }
  4278                                  
  4279 00001892 E96CFF                   jmp @@prs191
  4280                                  @@prs192:
  4281                                  
  4282                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4283 00001895 C9                       LEAVE
  4284 00001896 C3                       ret
  4285                                  ; ENDP
  4286                                  
  4287                                  printhex8a:  ; *** PROC ***
  4288                                  
  4289                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4290                                  
  4291                                  ;Function : printhex8a, Number of local variables: 2
  4292                                  ;   # type sign width line used address name   list of local variables
  4293                                  ;  200 var unsg word    31 NULL bp+4    c
  4294                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4295 00001897 C8020000                 ENTER  2,0
  4296 0000189B 8B4604                   mov ax, [bp+4]
  4297 0000189E C1E804                   shr ax, 4
  4298 000018A1 8946FE                   mov word [bp-2], ax
  4299 000018A4 8346FE30                 add  word [bp-2], 48
  4300 000018A8 8B46FE                   mov ax, [bp-2]
  4301 000018AB 83F839                   cmp ax, 57
  4302 000018AE 0F8E0400                 jle @@printhex8a200
  4303 000018B2 8346FE07                 add  word [bp-2], 7
  4304                                  @@printhex8a200:
  4305 000018B6 FF76FE                   push word [bp-2]
  4306 000018B9 E8D7FE                   call prc
  4307 000018BC 83C402                   add  sp, 2
  4308                                  
  4309                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4310                                  
  4311 000018BF 8B4604                   mov ax, [bp+4]
  4312 000018C2 83E00F                   and ax, 15
  4313 000018C5 8946FE                   mov word [bp-2], ax
  4314 000018C8 8346FE30                 add  word [bp-2], 48
  4315 000018CC 8B46FE                   mov ax, [bp-2]
  4316 000018CF 83F839                   cmp ax, 57
  4317 000018D2 0F8E0400                 jle @@printhex8a201
  4318 000018D6 8346FE07                 add  word [bp-2], 7
  4319                                  @@printhex8a201:
  4320 000018DA FF76FE                   push word [bp-2]
  4321 000018DD E8B3FE                   call prc
  4322 000018E0 83C402                   add  sp, 2
  4323                                  
  4324                                  ;-34 }
  4325                                  
  4326                                  
  4327                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4328 000018E3 C9                       LEAVE
  4329 000018E4 C3                       ret
  4330                                  ; ENDP
  4331                                  
  4332                                  printhex16:  ; *** PROC ***
  4333                                  
  4334                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4335                                  
  4336                                  ;Function : printhex16, Number of local variables: 2
  4337                                  ;   # type sign width line used address name   list of local variables
  4338                                  ;  200 var unsg word    35 NULL bp+4    i
  4339                                  ;  201 var unsg word    35 NULL bp-2    half;
  4340 000018E5 C8020000                 ENTER  2,0
  4341 000018E9 8B4604                   mov ax, [bp+4]
  4342 000018EC C1E808                   shr ax, 8
  4343 000018EF 8946FE                   mov word [bp-2], ax
  4344 000018F2 FF76FE                   push word [bp-2]
  4345 000018F5 E89FFF                   call printhex8a
  4346 000018F8 83C402                   add  sp, 2
  4347 000018FB 8B4604                   mov ax, [bp+4]
  4348 000018FE 25FF00                   and ax, 255
  4349 00001901 8946FE                   mov word [bp-2], ax
  4350 00001904 FF76FE                   push word [bp-2]
  4351 00001907 E88DFF                   call printhex8a
  4352 0000190A 83C402                   add  sp, 2
  4353                                  
  4354                                  ;-37 }
  4355                                  
  4356                                  
  4357                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4358 0000190D C9                       LEAVE
  4359 0000190E C3                       ret
  4360                                  ; ENDP
  4361                                  
  4362                                  printIntU:  ; *** PROC ***
  4363                                  
  4364                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4365                                  
  4366                                  ;Function : printIntU, Number of local variables: 2
  4367                                  ;   # type sign width line used address name   list of local variables
  4368                                  ;  200 var unsg word    38 NULL bp+4    n
  4369                                  ;  201 var unsg word    38 NULL bp-2    e;
  4370 0000190F C8020000                 ENTER  2,0
  4371 00001913 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4372 00001917 0F821700                 jb  @@printIntU202
  4373 0000191B 8B4604                   mov ax, [bp+4]
  4374 0000191E BB0A00                   mov bx, 10
  4375 00001921 BA0000                   mov dx, 0
  4376 00001924 F7F3                     div bx
  4377 00001926 8946FE                   mov word [bp-2], ax
  4378                                  
  4379                                  ;-40     printIntU(e); }
  4380                                  
  4381 00001929 FF76FE                   push word [bp-2]
  4382 0000192C E8E0FF                   call printIntU
  4383 0000192F 83C402                   add  sp, 2
  4384                                  
  4385                                  ;-41     n = n % 10; //unsigned mod
  4386                                  
  4387                                  @@printIntU202:
  4388 00001932 8B4604                   mov ax, [bp+4]
  4389 00001935 BB0A00                   mov bx, 10
  4390 00001938 BA0000                   mov dx, 0
  4391 0000193B F7F3                     div bx
  4392 0000193D 89D0                     mov ax, dx
  4393 0000193F 894604                   mov word [bp+4], ax
  4394                                  
  4395                                  ;-42     n += '0'; prc(n);
  4396                                  
  4397 00001942 83460430                 add  word [bp+4], 48
  4398 00001946 FF7604                   push word [bp+4]
  4399 00001949 E847FE                   call prc
  4400 0000194C 83C402                   add  sp, 2
  4401                                  
  4402                                  ;-43 }
  4403                                  
  4404                                  
  4405                                  ;-44 
  4406                                  
  4407                                  
  4408                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4409 0000194F C9                       LEAVE
  4410 00001950 C3                       ret
  4411                                  ; ENDP
  4412                                  
  4413                                  error1:  ; *** PROC ***
  4414                                  ;Function : error1, Number of local variables: 1
  4415                                  ;   # type sign width line used address name   list of local variables
  4416                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4417 00001951 C8000000                 ENTER  0,0
  4418 00001955 66B801000000             mov eax, 1
  4419 0000195B A2[2500]                 mov byte [LIST], al
  4420 0000195E FF06[3200]               inc  word [ErrorCount]
  4421                                  
  4422                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4423                                  
  4424 00001962 68[8A19]                 push error1_0
  4425 00001965 E88CFE                   call prs
  4426 00001968 83C402                   add  sp, 2
  4427 0000196B FF7604                   push word [bp+4]
  4428 0000196E E883FE                   call prs
  4429 00001971 83C402                   add  sp, 2
  4430                                  
  4431                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4432                                  
  4433 00001974 68[A519]                 push error1_1
  4434 00001977 E87AFE                   call prs
  4435 0000197A 83C402                   add  sp, 2
  4436 0000197D 8D063075                 lea  ax, [Symbol]
  4437 00001981 50                       push ax
  4438 00001982 E86FFE                   call prs
  4439 00001985 83C402                   add  sp, 2
  4440                                  
  4441                                  ;-48 int allowederror(){error1("not allowed here"); }
  4442 00001988 C9                       LEAVE
  4443 00001989 C3                       ret
  4444                                  ; ENDP
  4445 0000198A 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4446 00001993 6E657874206C696E65-
  4447 0000199C 204552524F523A2000 
  4448 000019A5 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4449 000019AE 2000               
  4450                                  
  4451                                  allowederror:  ; *** PROC ***
  4452 000019B0 68[BA19]                 push allowederror_0
  4453 000019B3 E89BFF                   call error1
  4454 000019B6 83C402                   add  sp, 2
  4455                                  
  4456                                  ;-49 int implmerror(){error1("not implemented");}
  4457                                  
  4458 000019B9 C3                       ret
  4459                                  ; ENDP
  4460 000019BA 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4461 000019C3 6564206865726500   
  4462                                  
  4463                                  implmerror:  ; *** PROC ***
  4464 000019CB 68[D519]                 push implmerror_0
  4465 000019CE E880FF                   call error1
  4466 000019D1 83C402                   add  sp, 2
  4467                                  
  4468                                  ;-50 int indexerror (){error1("invalid index register");}
  4469                                  
  4470 000019D4 C3                       ret
  4471                                  ; ENDP
  4472 000019D5 6E6F7420696D706C65-     implmerror_0 db "not implemented",0
  4473 000019DE 6D656E74656400     
  4474                                  
  4475                                  indexerror:  ; *** PROC ***
  4476 000019E5 68[EF19]                 push indexerror_0
  4477 000019E8 E866FF                   call error1
  4478 000019EB 83C402                   add  sp, 2
  4479                                  
  4480                                  ;-51 int numbererror(){error1("number expected");}
  4481                                  
  4482 000019EE C3                       ret
  4483                                  ; ENDP
  4484 000019EF 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4485 000019F8 6E6465782072656769-
  4486 00001A01 7374657200         
  4487                                  
  4488                                  numbererror:  ; *** PROC ***
  4489 00001A06 68[101A]                 push numbererror_0
  4490 00001A09 E845FF                   call error1
  4491 00001A0C 83C402                   add  sp, 2
  4492                                  
  4493                                  ;-52 int regmemerror(){error1("only register or memory allowed");}
  4494                                  
  4495 00001A0F C3                       ret
  4496                                  ; ENDP
  4497 00001A10 6E756D626572206578-     numbererror_0 db "number expected",0
  4498 00001A19 70656374656400     
  4499                                  
  4500                                  regmemerror:  ; *** PROC ***
  4501 00001A20 68[2A1A]                 push regmemerror_0
  4502 00001A23 E82BFF                   call error1
  4503 00001A26 83C402                   add  sp, 2
  4504                                  
  4505                                  ;-53 int segregerror(){error1("segment register not allowed");}
  4506                                  
  4507 00001A29 C3                       ret
  4508                                  ; ENDP
  4509 00001A2A 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4510 00001A33 73746572206F72206D-
  4511 00001A3C 656D6F727920616C6C-
  4512 00001A45 6F77656400         
  4513                                  
  4514                                  segregerror:  ; *** PROC ***
  4515 00001A4A 68[541A]                 push segregerror_0
  4516 00001A4D E801FF                   call error1
  4517 00001A50 83C402                   add  sp, 2
  4518                                  
  4519                                  ;-54 int syntaxerror(){error1("syntax");}
  4520                                  
  4521 00001A53 C3                       ret
  4522                                  ; ENDP
  4523 00001A54 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4524 00001A5D 65676973746572206E-
  4525 00001A66 6F7420616C6C6F7765-
  4526 00001A6F 6400               
  4527                                  
  4528                                  syntaxerror:  ; *** PROC ***
  4529 00001A71 68[7B1A]                 push syntaxerror_0
  4530 00001A74 E8DAFE                   call error1
  4531 00001A77 83C402                   add  sp, 2
  4532                                  
  4533                                  ;-55 
  4534                                  
  4535                                  
  4536                                  ;-56 int errorexit(char *s) { error1(s); end1(1);}
  4537                                  
  4538 00001A7A C3                       ret
  4539                                  ; ENDP
  4540 00001A7B 73796E74617800          syntaxerror_0 db "syntax",0
  4541                                  
  4542                                  errorexit:  ; *** PROC ***
  4543                                  ;Function : errorexit, Number of local variables: 1
  4544                                  ;   # type sign width line used address name   list of local variables
  4545                                  ;  200 ptr sign byte    56 NULL bp+4    s;
  4546 00001A82 C8000000                 ENTER  0,0
  4547 00001A86 FF7604                   push word [bp+4]
  4548 00001A89 E8C5FE                   call error1
  4549 00001A8C 83C402                   add  sp, 2
  4550 00001A8F 6A01                     push 1
  4551 00001A91 E80704                   call end1
  4552 00001A94 83C402                   add  sp, 2
  4553                                  
  4554                                  ;-57 int addrexit(){errorexit("illegal address");}
  4555 00001A97 C9                       LEAVE
  4556 00001A98 C3                       ret
  4557                                  ; ENDP
  4558                                  
  4559                                  addrexit:  ; *** PROC ***
  4560 00001A99 68[A31A]                 push addrexit_0
  4561 00001A9C E8E3FF                   call errorexit
  4562 00001A9F 83C402                   add  sp, 2
  4563                                  
  4564                                  ;-58 int internexit(){errorexit("intern compiler error");}
  4565                                  
  4566 00001AA2 C3                       ret
  4567                                  ; ENDP
  4568 00001AA3 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4569 00001AAC 64647265737300     
  4570                                  
  4571                                  internexit:  ; *** PROC ***
  4572 00001AB3 68[BD1A]                 push internexit_0
  4573 00001AB6 E8C9FF                   call errorexit
  4574 00001AB9 83C402                   add  sp, 2
  4575 00001ABC C3                       ret
  4576                                  ; ENDP
  4577 00001ABD 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4578 00001AC6 6D70696C6572206572-
  4579 00001ACF 726F7200           
  4580                                  ;Back to main program: AS.C
  4581                                  
  4582                                  ;-217 #include "MAIN.C"
  4583                                  
  4584                                  ;Use include file: MAIN.C
  4585                                  
  4586                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4587                                  
  4588                                  
  4589                                  getarg:  ; *** PROC ***
  4590                                  
  4591                                  ;-2   arglen1=*arglen;
  4592                                  
  4593                                  ;Function : getarg, Number of local variables: 3
  4594                                  ;   # type sign width line used address name   list of local variables
  4595                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4596                                  ;  201 var sign word     1 NULL bp-4    i
  4597                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4598 00001AD3 C8060000                 ENTER  6,0
  4599 00001AD7 8B1E[5900]               mov bx, [arglen]
  4600 00001ADB 8A07                     mov al, [bx]
  4601 00001ADD B400                     mov ah, 0
  4602 00001ADF 8946FE                   mov word [bp-2], ax
  4603                                  
  4604                                  ;-3   if (arglen1==0) {
  4605                                  
  4606 00001AE2 8B46FE                   mov ax, [bp-2]
  4607 00001AE5 83F800                   cmp ax, 0
  4608 00001AE8 0F851C00                 jne @@getarg203
  4609                                  
  4610                                  ;-4     cputs(Version1);
  4611                                  
  4612 00001AEC 8D06[1000]               lea  ax, [Version1]
  4613 00001AF0 50                       push ax
  4614 00001AF1 E8DC03                   call cputs
  4615 00001AF4 83C402                   add  sp, 2
  4616                                  
  4617                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4618                                  
  4619 00001AF7 68[981C]                 push getarg_0
  4620 00001AFA E8D303                   call cputs
  4621 00001AFD 83C402                   add  sp, 2
  4622                                  
  4623                                  ;-6     exitR(3);
  4624                                  
  4625 00001B00 6A03                     push 3
  4626 00001B02 E8A605                   call exitR
  4627 00001B05 83C402                   add  sp, 2
  4628                                  
  4629                                  ;-7   }
  4630                                  
  4631                                  
  4632                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4633                                  
  4634                                  @@getarg203:
  4635 00001B08 8B46FE                   mov ax, [bp-2]
  4636 00001B0B 058100                   add ax, 129
  4637 00001B0E 8946FC                   mov word [bp-4], ax
  4638 00001B11 66B800000000             mov eax, 0
  4639 00001B17 8B5EFC                   mov  bx, [bp-4]
  4640 00001B1A 8907                     mov  [bx], ax
  4641 00001B1C FF4EFE                   dec  word [bp-2]
  4642                                  
  4643                                  ;-9   toupper(argv);
  4644                                  
  4645 00001B1F FF36[5B00]               push word [argv]
  4646 00001B23 E8D803                   call toupper
  4647 00001B26 83C402                   add  sp, 2
  4648                                  
  4649                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4650                                  
  4651 00001B29 FF36[5B00]               push word [argv]
  4652 00001B2D 8D06ED75                 lea  ax, [namein]
  4653 00001B31 50                       push ax
  4654 00001B32 E83704                   call strcpy
  4655 00001B35 83C404                   add  sp, 4
  4656 00001B38 68[BD1C]                 push getarg_1
  4657 00001B3B 8D06ED75                 lea  ax, [namein]
  4658 00001B3F 50                       push ax
  4659 00001B40 E8EA04                   call strcat1
  4660 00001B43 83C404                   add  sp, 4
  4661                                  
  4662                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4663                                  
  4664 00001B46 FF36[5B00]               push word [argv]
  4665 00001B4A 8D063076                 lea  ax, [namelst]
  4666 00001B4E 50                       push ax
  4667 00001B4F E81A04                   call strcpy
  4668 00001B52 83C404                   add  sp, 4
  4669 00001B55 68[C01C]                 push getarg_2
  4670 00001B58 8D063076                 lea  ax, [namelst]
  4671 00001B5C 50                       push ax
  4672 00001B5D E8CD04                   call strcat1
  4673 00001B60 83C404                   add  sp, 4
  4674                                  
  4675                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4676                                  
  4677 00001B63 FF36[5B00]               push word [argv]
  4678 00001B67 8D067376                 lea  ax, [namebin]
  4679 00001B6B 50                       push ax
  4680 00001B6C E8FD03                   call strcpy
  4681 00001B6F 83C404                   add  sp, 4
  4682 00001B72 68[C51C]                 push getarg_3
  4683 00001B75 8D067376                 lea  ax, [namebin]
  4684 00001B79 50                       push ax
  4685 00001B7A E8B004                   call strcat1
  4686 00001B7D 83C404                   add  sp, 4
  4687                                  
  4688                                  ;-13 
  4689                                  
  4690                                  
  4691                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4692                                  
  4693 00001B80 66B801000000             mov eax, 1
  4694 00001B86 A2[2500]                 mov byte [LIST], al
  4695 00001B89 66B800000000             mov eax, 0
  4696 00001B8F A3[3000]                 mov word [DOS_ERR], ax
  4697 00001B92 66B800000000             mov eax, 0
  4698 00001B98 A3[3700]                 mov word [PC], ax
  4699 00001B9B 66B800000000             mov eax, 0
  4700 00001BA1 A3[3200]                 mov word [ErrorCount], ax
  4701                                  
  4702                                  ;-15   asm_fd=openR (namein);
  4703                                  
  4704 00001BA4 8D06ED75                 lea  ax, [namein]
  4705 00001BA8 50                       push ax
  4706 00001BA9 E8A604                   call openR
  4707 00001BAC 83C402                   add  sp, 2
  4708 00001BAF A3[2A00]                 mov word [asm_fd], ax
  4709                                  
  4710                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4711                                  
  4712 00001BB2 A1[3000]                 mov ax, [DOS_ERR]
  4713 00001BB5 08C0                     or  al, al
  4714 00001BB7 0F841C00                 je @@getarg204
  4715 00001BBB 68[CA1C]                 push getarg_4
  4716 00001BBE E80F03                   call cputs
  4717 00001BC1 83C402                   add  sp, 2
  4718 00001BC4 8D06ED75                 lea  ax, [namein]
  4719 00001BC8 50                       push ax
  4720 00001BC9 E80403                   call cputs
  4721 00001BCC 83C402                   add  sp, 2
  4722 00001BCF 6A01                     push 1
  4723 00001BD1 E8D704                   call exitR
  4724 00001BD4 83C402                   add  sp, 2
  4725                                  
  4726                                  ;-17   lst_fd=creatR(namelst);
  4727                                  
  4728                                  @@getarg204:
  4729 00001BD7 8D063076                 lea  ax, [namelst]
  4730 00001BDB 50                       push ax
  4731 00001BDC E88204                   call creatR
  4732 00001BDF 83C402                   add  sp, 2
  4733 00001BE2 A3[2C00]                 mov word [lst_fd], ax
  4734                                  
  4735                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4736                                  
  4737 00001BE5 A1[3000]                 mov ax, [DOS_ERR]
  4738 00001BE8 08C0                     or  al, al
  4739 00001BEA 0F841C00                 je @@getarg205
  4740 00001BEE 68[E01C]                 push getarg_5
  4741 00001BF1 E8DC02                   call cputs
  4742 00001BF4 83C402                   add  sp, 2
  4743 00001BF7 8D063076                 lea  ax, [namelst]
  4744 00001BFB 50                       push ax
  4745 00001BFC E8D102                   call cputs
  4746 00001BFF 83C402                   add  sp, 2
  4747 00001C02 6A02                     push 2
  4748 00001C04 E8A404                   call exitR
  4749 00001C07 83C402                   add  sp, 2
  4750                                  
  4751                                  ;-19   bin_fd=creatR(namebin);
  4752                                  
  4753                                  @@getarg205:
  4754 00001C0A 8D067376                 lea  ax, [namebin]
  4755 00001C0E 50                       push ax
  4756 00001C0F E84F04                   call creatR
  4757 00001C12 83C402                   add  sp, 2
  4758 00001C15 A3[2E00]                 mov word [bin_fd], ax
  4759                                  
  4760                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4761                                  
  4762 00001C18 A1[3000]                 mov ax, [DOS_ERR]
  4763 00001C1B 08C0                     or  al, al
  4764 00001C1D 0F841C00                 je @@getarg206
  4765 00001C21 68[F71C]                 push getarg_6
  4766 00001C24 E8A902                   call cputs
  4767 00001C27 83C402                   add  sp, 2
  4768 00001C2A 8D067376                 lea  ax, [namebin]
  4769 00001C2E 50                       push ax
  4770 00001C2F E89E02                   call cputs
  4771 00001C32 83C402                   add  sp, 2
  4772 00001C35 6A02                     push 2
  4773 00001C37 E87104                   call exitR
  4774 00001C3A 83C402                   add  sp, 2
  4775                                  
  4776                                  ;-21   prs(";");prs(Version1);
  4777                                  
  4778                                  @@getarg206:
  4779 00001C3D 68[0D1D]                 push getarg_7
  4780 00001C40 E8B1FB                   call prs
  4781 00001C43 83C402                   add  sp, 2
  4782 00001C46 8D06[1000]               lea  ax, [Version1]
  4783 00001C4A 50                       push ax
  4784 00001C4B E8A6FB                   call prs
  4785 00001C4E 83C402                   add  sp, 2
  4786                                  
  4787                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4788                                  
  4789 00001C51 68[0F1D]                 push getarg_8
  4790 00001C54 E89DFB                   call prs
  4791 00001C57 83C402                   add  sp, 2
  4792 00001C5A 8D06ED75                 lea  ax, [namein]
  4793 00001C5E 50                       push ax
  4794 00001C5F E892FB                   call prs
  4795 00001C62 83C402                   add  sp, 2
  4796 00001C65 68[1A1D]                 push getarg_9
  4797 00001C68 E889FB                   call prs
  4798 00001C6B 83C402                   add  sp, 2
  4799 00001C6E 8D063076                 lea  ax, [namelst]
  4800 00001C72 50                       push ax
  4801 00001C73 E87EFB                   call prs
  4802 00001C76 83C402                   add  sp, 2
  4803                                  
  4804                                  ;-23   prs(", "); prs(namebin);
  4805                                  
  4806 00001C79 68[251D]                 push getarg_10
  4807 00001C7C E875FB                   call prs
  4808 00001C7F 83C402                   add  sp, 2
  4809 00001C82 8D067376                 lea  ax, [namebin]
  4810 00001C86 50                       push ax
  4811 00001C87 E86AFB                   call prs
  4812 00001C8A 83C402                   add  sp, 2
  4813                                  
  4814                                  ;-24   prs("\n");
  4815                                  
  4816 00001C8D 68[281D]                 push getarg_11
  4817 00001C90 E861FB                   call prs
  4818 00001C93 83C402                   add  sp, 2
  4819                                  
  4820                                  ;-25 }
  4821                                  
  4822                                  
  4823                                  ;-26 int epilog() { int i; int j; char c;
  4824 00001C96 C9                       LEAVE
  4825 00001C97 C3                       ret
  4826                                  ; ENDP
  4827 00001C98 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4828 00001CA1 41532E434F4D206669-
  4829 00001CAA 6C656E616D65205B77-
  4830 00001CB3 2F6F202E535D203A20-
  4831 00001CBC 00                 
  4832 00001CBD 2E5300                  getarg_1 db ".S",0
  4833 00001CC0 2E4C535400              getarg_2 db ".LST",0
  4834 00001CC5 2E434F4D00              getarg_3 db ".COM",0
  4835 00001CCA 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4836 00001CD3 6C65206D697373696E-
  4837 00001CDC 673A2000           
  4838 00001CE0 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4839 00001CE9 206E6F742063726561-
  4840 00001CF2 74653A2000         
  4841 00001CF7 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4842 00001D00 6E6F74206372656174-
  4843 00001D09 653A2000           
  4844 00001D0D 3B00                    getarg_7 db ";",0
  4845 00001D0F 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4846 00001D18 2000               
  4847 00001D1A 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4848 00001D23 2000               
  4849 00001D25 2C2000                  getarg_10 db ", ",0
  4850 00001D28 5C6E00                  getarg_11 db "\n",0
  4851                                  
  4852                                  epilog:  ; *** PROC ***
  4853                                  
  4854                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4855                                  
  4856                                  ;Function : epilog, Number of local variables: 3
  4857                                  ;   # type sign width line used address name   list of local variables
  4858                                  ;  200 var sign word    26 NULL bp-2    i
  4859                                  ;  201 var sign word    26 NULL bp-4    j
  4860                                  ;  202 var sign byte    26 NULL bp-6    c;
  4861 00001D2B C8060000                 ENTER  6,0
  4862 00001D2F 68[541E]                 push epilog_0
  4863 00001D32 E8BFFA                   call prs
  4864 00001D35 83C402                   add  sp, 2
  4865 00001D38 FF36[3200]               push word [ErrorCount]
  4866 00001D3C E8D0FB                   call printIntU
  4867 00001D3F 83C402                   add  sp, 2
  4868                                  
  4869                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4870                                  
  4871 00001D42 A1[3200]                 mov ax, [ErrorCount]
  4872 00001D45 08C0                     or  al, al
  4873 00001D47 0F840900                 je @@epilog207
  4874 00001D4B 68[641E]                 push epilog_1
  4875 00001D4E E8A3FA                   call prs
  4876 00001D51 83C402                   add  sp, 2
  4877                                  
  4878                                  ;-29   prs(", Label & Var: ");
  4879                                  
  4880                                  @@epilog207:
  4881 00001D54 68[721E]                 push epilog_2
  4882 00001D57 E89AFA                   call prs
  4883 00001D5A 83C402                   add  sp, 2
  4884                                  
  4885                                  ;-30   if (LabelMaxIx) {
  4886                                  
  4887 00001D5D A1[5300]                 mov ax, [LabelMaxIx]
  4888 00001D60 08C0                     or  al, al
  4889 00001D62 0F846900                 je @@epilog208
  4890                                  
  4891                                  ;-31     i = 1;
  4892                                  
  4893 00001D66 66B801000000             mov eax, 1
  4894 00001D6C 8946FE                   mov word [bp-2], ax
  4895                                  
  4896                                  ;-32     LabelNamePtr= &LabelNames;
  4897                                  
  4898 00001D6F B8BB76                   mov ax, LabelNames
  4899 00001D72 A3[5100]                 mov word [LabelNamePtr], ax
  4900                                  
  4901                                  ;-33     do {
  4902                                  
  4903                                  @@epilog209:
  4904                                  
  4905                                  ;-34       prs(LabelNamePtr); prc(' ');
  4906                                  
  4907 00001D75 FF36[5100]               push word [LabelNamePtr]
  4908 00001D79 E878FA                   call prs
  4909 00001D7C 83C402                   add  sp, 2
  4910 00001D7F 6A20                     push 32
  4911 00001D81 E80FFA                   call prc
  4912 00001D84 83C402                   add  sp, 2
  4913                                  
  4914                                  ;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4915                                  
  4916 00001D87 8B5EFE                   mov bx, [bp-2]
  4917 00001D8A D1E3                     shl bx, 1
  4918 00001D8C 8B87A37A                 mov ax, [LabelAddr + bx]
  4919 00001D90 8946FC                   mov word [bp-4], ax
  4920 00001D93 FF76FC                   push word [bp-4]
  4921 00001D96 E84CFB                   call printhex16
  4922 00001D99 83C402                   add  sp, 2
  4923 00001D9C 68[821E]                 push epilog_3
  4924 00001D9F E852FA                   call prs
  4925 00001DA2 83C402                   add  sp, 2
  4926                                  
  4927                                  ;-36       j=strlen(LabelNamePtr);//get end of actual name
  4928                                  
  4929 00001DA5 FF36[5100]               push word [LabelNamePtr]
  4930 00001DA9 E89501                   call strlen
  4931 00001DAC 83C402                   add  sp, 2
  4932 00001DAF 8946FC                   mov word [bp-4], ax
  4933                                  
  4934                                  ;-37       LabelNamePtr=LabelNamePtr+j;
  4935                                  
  4936 00001DB2 A1[5100]                 mov ax, [LabelNamePtr]
  4937 00001DB5 0346FC                   add ax, [bp-4]
  4938 00001DB8 A3[5100]                 mov word [LabelNamePtr], ax
  4939                                  
  4940                                  ;-38       LabelNamePtr++;
  4941                                  
  4942 00001DBB FF06[5100]               inc  word [LabelNamePtr]
  4943                                  
  4944                                  ;-39       i++;
  4945                                  
  4946 00001DBF FF46FE                   inc  word [bp-2]
  4947                                  
  4948                                  ;-40     } while (i <= LabelMaxIx);
  4949                                  
  4950 00001DC2 8B46FE                   mov ax, [bp-2]
  4951 00001DC5 3B06[5300]               cmp ax, [LabelMaxIx]
  4952 00001DC9 0F8F0200                 jg  @@epilog210
  4953 00001DCD EBA6                     jmp @@epilog209
  4954                                  @@epilog210:
  4955                                  
  4956                                  ;-41   }
  4957                                  
  4958                                  
  4959                                  ;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  4960                                  
  4961                                  @@epilog208:
  4962 00001DCF 68[861E]                 push epilog_4
  4963 00001DD2 E81FFA                   call prs
  4964 00001DD5 83C402                   add  sp, 2
  4965 00001DD8 FF36[5700]               push word [BinLen]
  4966 00001DDC E830FB                   call printIntU
  4967 00001DDF 83C402                   add  sp, 2
  4968 00001DE2 68[931E]                 push epilog_5
  4969 00001DE5 E80CFA                   call prs
  4970 00001DE8 83C402                   add  sp, 2
  4971                                  
  4972                                  ;-43   i=0;
  4973                                  
  4974 00001DEB 66B800000000             mov eax, 0
  4975 00001DF1 8946FE                   mov word [bp-2], ax
  4976                                  
  4977                                  ;-44   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4978                                  
  4979                                  @@epilog211:
  4980 00001DF4 6A20                     push 32
  4981 00001DF6 E89AF9                   call prc
  4982 00001DF9 83C402                   add  sp, 2
  4983 00001DFC 8B5EFE                   mov bx, [bp-2]
  4984 00001DFF 8A876B7B                 mov al, [FileBin + bx]
  4985 00001E03 8946FC                   mov word [bp-4], ax
  4986 00001E06 FF76FC                   push word [bp-4]
  4987 00001E09 E88BFA                   call printhex8a
  4988 00001E0C 83C402                   add  sp, 2
  4989 00001E0F FF46FE                   inc  word [bp-2]
  4990                                  
  4991                                  ;-45   } while (i < BinLen);
  4992                                  
  4993 00001E12 8B46FE                   mov ax, [bp-2]
  4994 00001E15 3B06[5700]               cmp ax, [BinLen]
  4995 00001E19 0F8D0200                 jge @@epilog212
  4996 00001E1D EBD5                     jmp @@epilog211
  4997                                  @@epilog212:
  4998                                  
  4999                                  ;-46   i=0;
  5000                                  
  5001 00001E1F 66B800000000             mov eax, 0
  5002 00001E25 8946FE                   mov word [bp-2], ax
  5003                                  
  5004                                  ;-47   do {
  5005                                  
  5006                                  @@epilog213:
  5007                                  
  5008                                  ;-48     c = FileBin[i];
  5009                                  
  5010 00001E28 8B5EFE                   mov bx, [bp-2]
  5011 00001E2B 8A876B7B                 mov al, [FileBin + bx]
  5012 00001E2F 8846FA                   mov byte [bp-6], al
  5013                                  
  5014                                  ;-49     fputcR(c, bin_fd);
  5015                                  
  5016 00001E32 FF36[2E00]               push word [bin_fd]
  5017 00001E36 8A46FA                   mov al, byte [bp-6]
  5018 00001E39 B400                     mov ah, 0
  5019 00001E3B 50                       push ax
  5020 00001E3C E84902                   call fputcR
  5021 00001E3F 83C404                   add  sp, 4
  5022                                  
  5023                                  ;-50     i++;
  5024                                  
  5025 00001E42 FF46FE                   inc  word [bp-2]
  5026                                  
  5027                                  ;-51   } while (i < BinLen);
  5028                                  
  5029 00001E45 8B46FE                   mov ax, [bp-2]
  5030 00001E48 3B06[5700]               cmp ax, [BinLen]
  5031 00001E4C 0F8D0200                 jge @@epilog214
  5032 00001E50 EBD6                     jmp @@epilog213
  5033                                  @@epilog214:
  5034                                  
  5035                                  ;-52 }
  5036                                  
  5037                                  
  5038                                  ;-53 int end1(int n) {
  5039 00001E52 C9                       LEAVE
  5040 00001E53 C3                       ret
  5041                                  ; ENDP
  5042 00001E54 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5043 00001E5D 726F72733A2000     
  5044 00001E64 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5045 00001E6D 2A2A2A2000         
  5046 00001E72 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5047 00001E7B 205661723A2000     
  5048 00001E82 2C202000                epilog_3 db ",  ",0
  5049 00001E86 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5050 00001E8F 6C652000           
  5051 00001E93 2062797465733A00        epilog_5 db " bytes:",0
  5052                                  
  5053                                  end1:  ; *** PROC ***
  5054                                  
  5055                                  ;-54   fcloseR(asm_fd);
  5056                                  
  5057                                  ;Function : end1, Number of local variables: 1
  5058                                  ;   # type sign width line used address name   list of local variables
  5059                                  ;  200 var sign word    53 NULL bp+4    n;
  5060 00001E9B C8000000                 ENTER  0,0
  5061 00001E9F FF36[2A00]               push word [asm_fd]
  5062 00001EA3 E8F701                   call fcloseR
  5063 00001EA6 83C402                   add  sp, 2
  5064                                  
  5065                                  ;-55   fcloseR(lst_fd);
  5066                                  
  5067 00001EA9 FF36[2C00]               push word [lst_fd]
  5068 00001EAD E8ED01                   call fcloseR
  5069 00001EB0 83C402                   add  sp, 2
  5070                                  
  5071                                  ;-56   fcloseR(bin_fd);
  5072                                  
  5073 00001EB3 FF36[2E00]               push word [bin_fd]
  5074 00001EB7 E8E301                   call fcloseR
  5075 00001EBA 83C402                   add  sp, 2
  5076                                  
  5077                                  ;-57   exitR(n);
  5078                                  
  5079 00001EBD FF7604                   push word [bp+4]
  5080 00001EC0 E8E801                   call exitR
  5081 00001EC3 83C402                   add  sp, 2
  5082                                  
  5083                                  ;-58 }
  5084 00001EC6 C9                       LEAVE
  5085 00001EC7 C3                       ret
  5086                                  ; ENDP
  5087                                  ;Back to main program: AS.C
  5088                                   
  5089                                  ; missing functions: 
  5090                                  ; digit
  5091                                  ; strcpy
  5092                                  ; eqstr
  5093                                  ; strlen
  5094                                  ; eqstr
  5095                                  ; eqstr
  5096                                  ; eqstr
  5097                                  ; eqstr
  5098                                  ; readRL
  5099                                  ; readRL
  5100                                  ; digit
  5101                                  ; digit
  5102                                  ; strcpy
  5103                                  ; toupper
  5104                                  ; strlen
  5105                                  ; strlen
  5106                                  ; eqstr
  5107                                  ; eqstr
  5108                                  ; eqstr
  5109                                  ; eqstr
  5110                                  ; eqstr
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
  5136                                  ; writetty
  5137                                  ; writetty
  5138                                  ; fputcR
  5139                                  ; cputs
  5140                                  ; cputs
  5141                                  ; exitR
  5142                                  ; toupper
  5143                                  ; strcpy
  5144                                  ; strcat1
  5145                                  ; strcpy
  5146                                  ; strcat1
  5147                                  ; strcpy
  5148                                  ; strcat1
  5149                                  ; openR
  5150                                  ; cputs
  5151                                  ; cputs
  5152                                  ; exitR
  5153                                  ; creatR
  5154                                  ; cputs
  5155                                  ; cputs
  5156                                  ; exitR
  5157                                  ; creatR
  5158                                  ; cputs
  5159                                  ; cputs
  5160                                  ; exitR
  5161                                  ; strlen
  5162                                  ; fputcR
  5163                                  ; fcloseR
  5164                                  ; fcloseR
  5165                                  ; fcloseR
  5166                                  ; exitR
  5167                                  ; Number of unresolved CALLs :   77
  5168                                  ;use archive file: AR.C
  5169                                  
  5170                                  ;-218 // AR.C Archive
  5171                                  
  5172                                  ;Number of CALLs:    2 : writetty
  5173                                  
  5174                                  writetty:  ; *** PROC ***
  5175 00001EC8 B40E                     mov  ah, 14
  5176 00001ECA BB0000                   mov  bx, 0
  5177 00001ECD CD10                     int  16
  5178                                  
  5179                                  ;-219 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5180                                  
  5181 00001ECF C3                       ret
  5182                                  ; ENDP
  5183                                  ;Number of CALLs:    8 : cputs
  5184                                  
  5185                                  cputs:  ; *** PROC ***
  5186                                  ;Function : cputs, Number of local variables: 2
  5187                                  ;   # type sign width line used address name   list of local variables
  5188                                  ;  200 ptr sign byte   219 NULL bp+4    s
  5189                                  ;  201 var sign byte   219 NULL bp-2    c;
  5190 00001ED0 C8020000                 ENTER  2,0
  5191                                  @@cputs215:
  5192 00001ED4 8B5E04                   mov bx, [bp+4]
  5193 00001ED7 8A07                     mov al, [bx]
  5194 00001ED9 B400                     mov ah, 0
  5195 00001EDB 08C0                     or  al, al
  5196 00001EDD 0F841B00                 je @@cputs216
  5197 00001EE1 8B5E04                   mov bx, [bp+4]
  5198 00001EE4 8A07                     mov al, [bx]
  5199 00001EE6 B400                     mov ah, 0
  5200 00001EE8 8846FE                   mov byte [bp-2], al
  5201 00001EEB 8A46FE                   mov al, byte [bp-2]
  5202 00001EEE B400                     mov ah, 0
  5203 00001EF0 50                       push ax
  5204 00001EF1 E8C401                   call putch
  5205 00001EF4 83C402                   add  sp, 2
  5206 00001EF7 FF4604                   inc  word [bp+4]
  5207 00001EFA EBD8                     jmp @@cputs215
  5208                                  @@cputs216:
  5209                                  
  5210                                  ;-220 int mkneg(int n) { n; __asm {neg ax} }
  5211 00001EFC C9                       LEAVE
  5212 00001EFD C3                       ret
  5213                                  ; ENDP
  5214                                  ;Number of CALLs:    2 : toupper
  5215                                  
  5216                                  toupper:  ; *** PROC ***
  5217                                  ;Function : toupper, Number of local variables: 1
  5218                                  ;   # type sign width line used address name   list of local variables
  5219                                  ;  200 ptr sign byte   220 NULL bp+4    s;
  5220 00001EFE C8000000                 ENTER  0,0
  5221                                  @@toupper217:
  5222 00001F02 8B5E04                   mov bx, [bp+4]
  5223 00001F05 8A07                     mov al, [bx]
  5224 00001F07 B400                     mov ah, 0
  5225 00001F09 08C0                     or  al, al
  5226 00001F0B 0F843000                 je @@toupper218
  5227 00001F0F 8B5E04                   mov bx, [bp+4]
  5228 00001F12 8A07                     mov al, [bx]
  5229 00001F14 B400                     mov ah, 0
  5230 00001F16 83F861                   cmp ax, 97 ;unsigned : 1
  5231 00001F19 0F8C1D00                 jl  @@toupper219
  5232 00001F1D 8B5E04                   mov bx, [bp+4]
  5233 00001F20 8A07                     mov al, [bx]
  5234 00001F22 B400                     mov ah, 0
  5235 00001F24 83F87A                   cmp ax, 122
  5236 00001F27 0F8F0F00                 jg  @@toupper220
  5237 00001F2B 8B5E04                   mov bx, [bp+4]
  5238 00001F2E 8A07                     mov al, [bx]
  5239 00001F30 B400                     mov ah, 0
  5240 00001F32 83E820                   sub ax, 32
  5241 00001F35 8B5E04                   mov  bx, [bp+4]
  5242 00001F38 8807                     mov  [bx], al
  5243                                  @@toupper220:
  5244                                  @@toupper219:
  5245 00001F3A FF4604                   inc  word [bp+4]
  5246 00001F3D EBC3                     jmp @@toupper217
  5247                                  @@toupper218:
  5248                                  
  5249                                  ;-221 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5250                                  
  5251                                  
  5252                                  ;-222 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5253 00001F3F C9                       LEAVE
  5254 00001F40 C3                       ret
  5255                                  ; ENDP
  5256                                  ;Number of CALLs:    4 : strlen
  5257                                  
  5258                                  strlen:  ; *** PROC ***
  5259                                  ;Function : strlen, Number of local variables: 2
  5260                                  ;   # type sign width line used address name   list of local variables
  5261                                  ;  200 ptr sign byte   222 NULL bp+4    s
  5262                                  ;  201 var sign word   222 NULL bp-2    c;
  5263 00001F41 C8020000                 ENTER  2,0
  5264 00001F45 66B800000000             mov eax, 0
  5265 00001F4B 8946FE                   mov word [bp-2], ax
  5266                                  @@strlen221:
  5267 00001F4E 8B5E04                   mov bx, [bp+4]
  5268 00001F51 8A07                     mov al, [bx]
  5269 00001F53 B400                     mov ah, 0
  5270 00001F55 83F800                   cmp ax, 0
  5271 00001F58 0F840800                 je  @@strlen222
  5272 00001F5C FF4604                   inc  word [bp+4]
  5273 00001F5F FF46FE                   inc  word [bp-2]
  5274 00001F62 EBEA                     jmp @@strlen221
  5275                                  @@strlen222:
  5276 00001F64 8B46FE                   mov ax, [bp-2]
  5277 00001F67 E90000                   jmp @@retn
  5278                                  
  5279                                  ;-223 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5280                                  
  5281 00001F6A C9                      @@retn: LEAVE
  5282 00001F6B C3                       ret
  5283                                  ; ENDP
  5284                                  ;Number of CALLs:    5 : strcpy
  5285                                  
  5286                                  strcpy:  ; *** PROC ***
  5287                                  ;Function : strcpy, Number of local variables: 2
  5288                                  ;   # type sign width line used address name   list of local variables
  5289                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5290                                  ;  201 ptr sign byte   223 NULL bp+6    t;
  5291 00001F6C C8000000                 ENTER  0,0
  5292                                  @@strcpy223:
  5293 00001F70 8B5E06                   mov bx, [bp+6]
  5294 00001F73 8A07                     mov al, [bx]
  5295 00001F75 B400                     mov ah, 0
  5296 00001F77 8B5E04                   mov  bx, [bp+4]
  5297 00001F7A 8807                     mov  [bx], al
  5298 00001F7C FF4604                   inc  word [bp+4]
  5299 00001F7F FF4606                   inc  word [bp+6]
  5300                                  
  5301                                  ;-224   while (*t!=0); *s=0; return s; }
  5302                                  
  5303 00001F82 8B5E06                   mov bx, [bp+6]
  5304 00001F85 8A07                     mov al, [bx]
  5305 00001F87 B400                     mov ah, 0
  5306 00001F89 83F800                   cmp ax, 0
  5307 00001F8C 0F840200                 je  @@strcpy224
  5308 00001F90 EBDE                     jmp @@strcpy223
  5309                                  @@strcpy224:
  5310 00001F92 66B800000000             mov eax, 0
  5311 00001F98 8B5E04                   mov  bx, [bp+4]
  5312 00001F9B 8807                     mov  [bx], al
  5313 00001F9D 8B4604                   mov ax, [bp+4]
  5314 00001FA0 E90000                   jmp @@retn
  5315                                  
  5316                                  ;-225 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5317                                  
  5318 00001FA3 C9                      @@retn: LEAVE
  5319 00001FA4 C3                       ret
  5320                                  ; ENDP
  5321                                  ;Number of CALLs:    3 : digit
  5322                                  
  5323                                  digit:  ; *** PROC ***
  5324                                  ;Function : digit, Number of local variables: 1
  5325                                  ;   # type sign width line used address name   list of local variables
  5326                                  ;  200 var sign byte   225 NULL bp+4    c;
  5327 00001FA5 C8000000                 ENTER  0,0
  5328 00001FA9 8A4604                   mov al, [bp+4]
  5329 00001FAC 3C30                     cmp al, 48
  5330 00001FAE 0F8D0900                 jge @@digit225
  5331 00001FB2 66B800000000             mov eax, 0
  5332 00001FB8 E91B00                   jmp @@retn
  5333                                  @@digit225:
  5334 00001FBB 8A4604                   mov al, [bp+4]
  5335 00001FBE 3C39                     cmp al, 57
  5336 00001FC0 0F8E0900                 jle @@digit226
  5337 00001FC4 66B800000000             mov eax, 0
  5338 00001FCA E90900                   jmp @@retn
  5339                                  @@digit226:
  5340 00001FCD 66B801000000             mov eax, 1
  5341 00001FD3 E90000                   jmp @@retn
  5342                                  
  5343                                  ;-226 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5344                                  
  5345 00001FD6 C9                      @@retn: LEAVE
  5346 00001FD7 C3                       ret
  5347                                  ; ENDP
  5348                                  ;Number of CALLs:   35 : eqstr
  5349                                  
  5350                                  eqstr:  ; *** PROC ***
  5351                                  ;Function : eqstr, Number of local variables: 2
  5352                                  ;   # type sign width line used address name   list of local variables
  5353                                  ;  200 ptr sign byte   226 NULL bp+4    p
  5354                                  ;  201 ptr sign byte   226 NULL bp+6    q;
  5355 00001FD8 C8000000                 ENTER  0,0
  5356                                  @@eqstr227:
  5357 00001FDC 8B5E04                   mov bx, [bp+4]
  5358 00001FDF 8A07                     mov al, [bx]
  5359 00001FE1 B400                     mov ah, 0
  5360 00001FE3 08C0                     or  al, al
  5361 00001FE5 0F842300                 je @@eqstr228
  5362                                  
  5363                                  ;-227     if (*p != *q) return 0; p++; q++; }
  5364                                  
  5365 00001FE9 8B5E04                   mov bx, [bp+4]
  5366 00001FEC 8A07                     mov al, [bx]
  5367 00001FEE B400                     mov ah, 0
  5368 00001FF0 8B5E06                   mov bx, [bp+6]
  5369 00001FF3 3A07                     cmp al, [bx]
  5370 00001FF5 B400                     mov ah, 0
  5371 00001FF7 0F840900                 je  @@eqstr229
  5372 00001FFB 66B800000000             mov eax, 0
  5373 00002001 E92700                   jmp @@retn
  5374                                  @@eqstr229:
  5375 00002004 FF4604                   inc  word [bp+4]
  5376 00002007 FF4606                   inc  word [bp+6]
  5377                                  
  5378                                  ;-228     if(*q) return 0; return 1; }
  5379                                  
  5380 0000200A EBD0                     jmp @@eqstr227
  5381                                  @@eqstr228:
  5382 0000200C 8B5E06                   mov bx, [bp+6]
  5383 0000200F 8A07                     mov al, [bx]
  5384 00002011 B400                     mov ah, 0
  5385 00002013 08C0                     or  al, al
  5386 00002015 0F840900                 je @@eqstr230
  5387 00002019 66B800000000             mov eax, 0
  5388 0000201F E90900                   jmp @@retn
  5389                                  @@eqstr230:
  5390 00002022 66B801000000             mov eax, 1
  5391 00002028 E90000                   jmp @@retn
  5392                                  
  5393                                  ;-229 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5394                                  
  5395 0000202B C9                      @@retn: LEAVE
  5396 0000202C C3                       ret
  5397                                  ; ENDP
  5398                                  ;Number of CALLs:    3 : strcat1
  5399                                  
  5400                                  strcat1:  ; *** PROC ***
  5401                                  ;Function : strcat1, Number of local variables: 2
  5402                                  ;   # type sign width line used address name   list of local variables
  5403                                  ;  200 ptr sign byte   229 NULL bp+4    s
  5404                                  ;  201 ptr sign byte   229 NULL bp+6    t;
  5405 0000202D C8000000                 ENTER  0,0
  5406                                  @@strcat1231:
  5407 00002031 8B5E04                   mov bx, [bp+4]
  5408 00002034 8A07                     mov al, [bx]
  5409 00002036 B400                     mov ah, 0
  5410 00002038 83F800                   cmp ax, 0
  5411 0000203B 0F840500                 je  @@strcat1232
  5412 0000203F FF4604                   inc  word [bp+4]
  5413 00002042 EBED                     jmp @@strcat1231
  5414                                  @@strcat1232:
  5415 00002044 FF7606                   push word [bp+6]
  5416 00002047 FF7604                   push word [bp+4]
  5417 0000204A E81FFF                   call strcpy
  5418 0000204D 83C404                   add  sp, 4
  5419                                  
  5420                                  ;-230 int basename(char *s) { char *p; p=0;
  5421 00002050 C9                       LEAVE
  5422 00002051 C3                       ret
  5423                                  ; ENDP
  5424                                  ;Number of CALLs:    1 : openR
  5425                                  
  5426                                  openR:  ; *** PROC ***
  5427                                  ;Function : openR, Number of local variables: 1
  5428                                  ;   # type sign width line used address name   list of local variables
  5429                                  ;  200 ptr sign byte   230 NULL bp+4    s;
  5430 00002052 C8000000                 ENTER  0,0
  5431 00002056 8B5604                   mov  dx, [bp+4]
  5432 00002059 B8023D                   mov  ax, 15618
  5433 0000205C E87200                   call DosInt
  5434                                  
  5435                                  ;-231 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5436 0000205F C9                       LEAVE
  5437 00002060 C3                       ret
  5438                                  ; ENDP
  5439                                  ;Number of CALLs:    2 : creatR
  5440                                  
  5441                                  creatR:  ; *** PROC ***
  5442                                  ;Function : creatR, Number of local variables: 1
  5443                                  ;   # type sign width line used address name   list of local variables
  5444                                  ;  200 ptr sign byte   231 NULL bp+4    s;
  5445 00002061 C8000000                 ENTER  0,0
  5446 00002065 8B5604                   mov  dx, [bp+4]
  5447 00002068 B90000                   mov  cx, 0
  5448 0000206B B8003C                   mov  ax, 15360
  5449 0000206E E86000                   call DosInt
  5450                                  
  5451                                  ;-232 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5452 00002071 C9                       LEAVE
  5453 00002072 C3                       ret
  5454                                  ; ENDP
  5455                                  ;Number of CALLs:    2 : readRL
  5456                                  
  5457                                  readRL:  ; *** PROC ***
  5458                                  ;Function : readRL, Number of local variables: 3
  5459                                  ;   # type sign width line used address name   list of local variables
  5460                                  ;  200 ptr sign byte   232 NULL bp+4    s
  5461                                  ;  201 var sign word   232 NULL bp+6    fd
  5462                                  ;  202 var sign word   232 NULL bp+8    len;
  5463 00002073 C8000000                 ENTER  0,0
  5464 00002077 8B5604                   mov  dx, [bp+4]
  5465 0000207A 8B4E08                   mov  cx, [bp+8]
  5466 0000207D 8B5E06                   mov  bx, [bp+6]
  5467 00002080 B8003F                   mov  ax, 16128
  5468 00002083 E84B00                   call DosInt
  5469                                  
  5470                                  ;-233 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5471 00002086 C9                       LEAVE
  5472 00002087 C3                       ret
  5473                                  ; ENDP
  5474                                  ;Number of CALLs:    2 : fputcR
  5475                                  
  5476                                  fputcR:  ; *** PROC ***
  5477                                  ;Function : fputcR, Number of local variables: 2
  5478                                  ;   # type sign width line used address name   list of local variables
  5479                                  ;  200 ptr sign byte   233 NULL bp+4    n
  5480                                  ;  201 var sign word   233 NULL bp+6    fd;
  5481 00002088 C8000000                 ENTER  0,0
  5482 0000208C 8D5604                  lea dx, [bp+4]
  5483                                  
  5484                                  ;-234   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5485                                  
  5486 0000208F B90100                   mov  cx, 1
  5487 00002092 8B5E06                   mov  bx, [bp+6]
  5488 00002095 B80040                   mov  ax, 16384
  5489 00002098 E83600                   call DosInt
  5490                                  
  5491                                  ;-235 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5492 0000209B C9                       LEAVE
  5493 0000209C C3                       ret
  5494                                  ; ENDP
  5495                                  ;Number of CALLs:    3 : fcloseR
  5496                                  
  5497                                  fcloseR:  ; *** PROC ***
  5498                                  ;Function : fcloseR, Number of local variables: 1
  5499                                  ;   # type sign width line used address name   list of local variables
  5500                                  ;  200 var sign word   235 NULL bp+4    fd;
  5501 0000209D C8000000                 ENTER  0,0
  5502 000020A1 8B5E04                   mov  bx, [bp+4]
  5503 000020A4 B8003E                   mov  ax, 15872
  5504 000020A7 CD21                     int  33
  5505                                  
  5506                                  ;-236 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5507 000020A9 C9                       LEAVE
  5508 000020AA C3                       ret
  5509                                  ; ENDP
  5510                                  ;Number of CALLs:    5 : exitR
  5511                                  
  5512                                  exitR:  ; *** PROC ***
  5513                                  ;Function : exitR, Number of local variables: 1
  5514                                  ;   # type sign width line used address name   list of local variables
  5515                                  ;  200 var sign byte   236 NULL bp+4    c;
  5516 000020AB C8000000                 ENTER  0,0
  5517 000020AF B44C                     mov  ah, 76
  5518 000020B1 8A4604                   mov  al, [bp+4]
  5519 000020B4 CD21                     int  33
  5520                                  
  5521                                  ;-237 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5522 000020B6 C9                       LEAVE
  5523 000020B7 C3                       ret
  5524                                  ; ENDP
  5525                                  ;End of archive file. 
  5526                                   
  5527                                  ; missing functions: 
  5528                                  ; putch
  5529                                  ; DosInt
  5530                                  ; DosInt
  5531                                  ; DosInt
  5532                                  ; DosInt
  5533                                  ; Number of unresolved CALLs :    5
  5534                                  ;use archive file: AR.C
  5535                                  
  5536                                  ;-238 // AR.C Archive
  5537                                  
  5538                                  ;Number of CALLs:    1 : putch
  5539                                  
  5540                                  putch:  ; *** PROC ***
  5541                                  ;Function : putch, Number of local variables: 1
  5542                                  ;   # type sign width line used address name   list of local variables
  5543                                  ;  200 var sign byte   238 NULL bp+4    c;
  5544 000020B8 C8000000                 ENTER  0,0
  5545 000020BC 807E040A                cmp byte [bp+4], 10
  5546 000020C0 0F850500                 jne @@putch233
  5547 000020C4 B00D                     mov  al, 13
  5548 000020C6 E8FFFD                   call writetty
  5549                                  @@putch233:
  5550 000020C9 8A4604                   mov  al, [bp+4]
  5551 000020CC E8F9FD                   call writetty
  5552                                  
  5553                                  ;-239 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5554 000020CF C9                       LEAVE
  5555 000020D0 C3                       ret
  5556                                  ; ENDP
  5557                                  ;Number of CALLs:    4 : DosInt
  5558                                  
  5559                                  DosInt:  ; *** PROC ***
  5560 000020D1 CD21                     int  33
  5561 000020D3 7304                     jae short @@DosInt234
  5562 000020D5 FF06[3000]               inc  word [DOS_ERR]
  5563                                  @@DosInt234:
  5564                                  
  5565                                  ;-240 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5566                                  
  5567 000020D9 C3                       ret
  5568                                  ; ENDP
  5569                                  ;End of archive file. 
  5570                                   
  5571                                  ; missing functions:  All FUNCTIONs in place
  5572 000020DA E80000                  LastFunctionByt:db 0E8h, 0, 0
  5573 000020DD 58                      pop ax
  5574 000020DE C3                      ret
  5575                                   
  5576                                  ;   # type sign width line used  address name   list of global variables
  5577                                  
  5578                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5579                                  ;    2 var sign byte     1    3        0 LIST
  5580                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5581                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5582                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5583                                  ;    6 var unsg word     5   12        0 SymbolInt
  5584                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5585                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5586                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5587                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5588                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5589                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5590                                  ;   13 var sign word    12    4        0 asm_fd
  5591                                  ;   14 var sign word    13    3        0 lst_fd
  5592                                  ;   15 var sign word    14    3        0 bin_fd
  5593                                  ;   16 var sign word    15    6        0 DOS_ERR
  5594                                  ;   17 var sign word    16    4        0 ErrorCount
  5595                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5596                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5597                                  ;   20 var unsg word    20    5        0 PC
  5598                                  ;   21 var unsg word    21    2        0 PCStart
  5599                                  ;   22 var sign byte    22    3        0 isLabel
  5600                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5601                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5602                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5603                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5604                                  ;   27 var sign byte    27   20        0 TokeType
  5605                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5606                                  ;   29 def unsg byte    29    -        0 WORD=2
  5607                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5608                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5609                                  ;   32 def unsg byte    32    -        0 IMM=1
  5610                                  ;   33 def unsg byte    33    -        0 REG=2
  5611                                  ;   34 def unsg byte    34    -        0 ADR=3
  5612                                  ;   35 def unsg byte    35    -        0 MEM=4
  5613                                  ;   36 var sign byte    36   14        0 Op1
  5614                                  ;   37 var sign byte    37   11        0 CodeType
  5615                                  ;   38 var sign byte    38    4        0 Code1
  5616                                  ;   39 var sign byte    39    4        0 Code2
  5617                                  ;   40 var sign byte    40    3        0 Code3
  5618                                  ;   41 var sign byte    41   17        0 RegType
  5619                                  ;   42 var sign byte    42   10        0 RegNo
  5620                                  ;   43 var sign byte    43   10        0 OpSize
  5621                                  ;   44 var sign byte    44    4        0 wflag
  5622                                  ;   45 var sign byte    49   15        0 regindexbase
  5623                                  ;   46 var sign byte    50    3        0 isDirect
  5624                                  ;   47 var sign word    51   14        0 disp
  5625                                  ;   48 var sign word    52    2        0 imme
  5626                                  ;   49 def unsg byte    54    -        0 OPMAXLEN=5
  5627                                  ;   50 arr sign byte    55    2    30390 OpPos[5]
  5628                                  ;   51 var sign word    56    6        0 OpPrintIndex
  5629                                  ;   52 ptr sign byte    57   17        0 OpCodePtr
  5630                                  ;   53 var sign byte    58    2        0 PrintR
  5631                                  ;   54 def unsg byte    60    -        0 LABELNAMESMAX=969
  5632                                  ;   55 arr sign byte    61    3    30395 LabelNames[1000]
  5633                                  ;   56 ptr sign byte    62   10        0 LabelNamePtr
  5634                                  ;   57 def unsg byte    63    -        0 LABELADRMAX=100
  5635                                  ;   58 arr unsg word    64    4    31395 LabelAddr[100]
  5636                                  ;   59 var sign word    65    5        0 LabelMaxIx
  5637                                  ;   60 var sign word    66    4        0 LabelIx
  5638                                  ;   61 def unsg byte    68    -        0 FILEBINMAX=1990
  5639                                  ;   62 arr sign byte    69    3    31595 FileBin[2000]
  5640                                  ;   63 var unsg word    70    5        0 BinLen
  5641                                  ;   64 ptr sign byte    72    1        0 arglen
  5642                                  ;   65 ptr sign byte    73    4        0 argv
  5643                                  ;   66 var sign byte     1    1        0 I_START
  5644                                  ;   67 arr sign byte     4 NULL        0 I_PUSHA[9]
  5645                                  ;   68 arr sign byte     5 NULL        0 I_POPA[8]
  5646                                  ;   69 arr sign byte     6 NULL        0 I_NOP[7]
  5647                                  ;   70 arr sign byte     7 NULL        0 I_CBW[7]
  5648                                  ;   71 arr sign byte     8 NULL        0 I_CWDE[8]
  5649                                  ;   72 arr sign byte     9 NULL        0 I_CWD[7]
  5650                                  ;   73 arr sign byte    10 NULL        0 I_CDQ[7]
  5651                                  ;   74 arr sign byte    11 NULL        0 I_WAIT[8]
  5652                                  ;   75 arr sign byte    12 NULL        0 I_PUSHF[9]
  5653                                  ;   76 arr sign byte    13 NULL        0 I_POPF[8]
  5654                                  ;   77 arr sign byte    14 NULL        0 I_SAHF[8]
  5655                                  ;   78 arr sign byte    15 NULL        0 I_LAHF[8]
  5656                                  ;   79 arr sign byte    16 NULL        0 I_MOVSB[9]
  5657                                  ;   80 arr sign byte    17 NULL        0 I_MOVSW[9]
  5658                                  ;   81 arr sign byte    18 NULL        0 I_CMPSB[9]
  5659                                  ;   82 arr sign byte    19 NULL        0 I_CMPSW[9]
  5660                                  ;   83 arr sign byte    20 NULL        0 I_STOSB[9]
  5661                                  ;   84 arr sign byte    21 NULL        0 I_STOSW[9]
  5662                                  ;   85 arr sign byte    22 NULL        0 I_LODSB[9]
  5663                                  ;   86 arr sign byte    23 NULL        0 I_LODSW[9]
  5664                                  ;   87 arr sign byte    24 NULL        0 I_SCASB[9]
  5665                                  ;   88 arr sign byte    25 NULL        0 I_SCASW[9]
  5666                                  ;   89 arr sign byte    26 NULL        0 I_LEAVE[9]
  5667                                  ;   90 arr sign byte    27 NULL        0 I_IRET[8]
  5668                                  ;   91 arr sign byte    28 NULL        0 I_XLAT[8]
  5669                                  ;   92 arr sign byte    29 NULL        0 I_LOCK[8]
  5670                                  ;   93 arr sign byte    30 NULL        0 I_REPNE[9]
  5671                                  ;   94 arr sign byte    31 NULL        0 I_REPNZ[9]
  5672                                  ;   95 arr sign byte    32 NULL        0 I_REPE[8]
  5673                                  ;   96 arr sign byte    33 NULL        0 I_REPZ[8]
  5674                                  ;   97 arr sign byte    34 NULL        0 I_HLT[7]
  5675                                  ;   98 arr sign byte    35 NULL        0 I_CLC[7]
  5676                                  ;   99 arr sign byte    36 NULL        0 I_STC[7]
  5677                                  ;  100 arr sign byte    37 NULL        0 I_CLI[7]
  5678                                  ;  101 arr sign byte    38 NULL        0 I_STI[7]
  5679                                  ;  102 arr sign byte    39 NULL        0 I_CLD[7]
  5680                                  ;  103 arr sign byte    40 NULL        0 I_STD[7]
  5681                                  ;  104 arr sign byte    42 NULL        0 I_INC[9]
  5682                                  ;  105 arr sign byte    43 NULL        0 I_DEC[9]
  5683                                  ;  106 arr sign byte    44 NULL        0 I_NOT[8]
  5684                                  ;  107 arr sign byte    45 NULL        0 I_NEG[8]
  5685                                  ;  108 arr sign byte    46 NULL        0 I_MUL[8]
  5686                                  ;  109 arr sign byte    47 NULL        0 I_IMUL[9]
  5687                                  ;  110 arr sign byte    48 NULL        0 I_DIV[8]
  5688                                  ;  111 arr sign byte    49 NULL        0 I_IDIV[9]
  5689                                  ;  112 arr sign byte    51 NULL        0 I_LES[7]
  5690                                  ;  113 arr sign byte    52 NULL        0 I_LDS[7]
  5691                                  ;  114 arr sign byte    53 NULL        0 I_LEA[7]
  5692                                  ;  115 arr sign byte    55 NULL        0 I_ADD[7]
  5693                                  ;  116 arr sign byte    56 NULL        0 I_OR[6]
  5694                                  ;  117 arr sign byte    57 NULL        0 I_ADC[7]
  5695                                  ;  118 arr sign byte    58 NULL        0 I_SBB[7]
  5696                                  ;  119 arr sign byte    59 NULL        0 I_AND[7]
  5697                                  ;  120 arr sign byte    60 NULL        0 I_SUB[7]
  5698                                  ;  121 arr sign byte    61 NULL        0 I_XOR[7]
  5699                                  ;  122 arr sign byte    62 NULL        0 I_CMP[7]
  5700                                  ;  123 arr sign byte    64 NULL        0 I_MOV[6]
  5701                                  ;  124 arr sign byte    65 NULL        0 I_MOVSX[9]
  5702                                  ;  125 arr sign byte    66 NULL        0 I_MOVZX[9]
  5703                                  ;  126 arr sign byte    68 NULL        0 I_JO[6]
  5704                                  ;  127 arr sign byte    69 NULL        0 I_JNO[7]
  5705                                  ;  128 arr sign byte    70 NULL        0 I_JB[6]
  5706                                  ;  129 arr sign byte    71 NULL        0 I_JC[6]
  5707                                  ;  130 arr sign byte    72 NULL        0 I_JNB[7]
  5708                                  ;  131 arr sign byte    73 NULL        0 I_JAE[7]
  5709                                  ;  132 arr sign byte    74 NULL        0 I_JNC[7]
  5710                                  ;  133 arr sign byte    75 NULL        0 I_JE[6]
  5711                                  ;  134 arr sign byte    76 NULL        0 I_JZ[6]
  5712                                  ;  135 arr sign byte    77 NULL        0 I_JNE[7]
  5713                                  ;  136 arr sign byte    78 NULL        0 I_JNZ[7]
  5714                                  ;  137 arr sign byte    79 NULL        0 I_JBE[7]
  5715                                  ;  138 arr sign byte    80 NULL        0 I_JNA[7]
  5716                                  ;  139 arr sign byte    81 NULL        0 I_JA[6]
  5717                                  ;  140 arr sign byte    82 NULL        0 I_JS[6]
  5718                                  ;  141 arr sign byte    83 NULL        0 I_JNS[7]
  5719                                  ;  142 arr sign byte    84 NULL        0 I_JP[6]
  5720                                  ;  143 arr sign byte    85 NULL        0 I_JPE[7]
  5721                                  ;  144 arr sign byte    86 NULL        0 I_JNP[7]
  5722                                  ;  145 arr sign byte    87 NULL        0 I_JPO[7]
  5723                                  ;  146 arr sign byte    88 NULL        0 I_JL[6]
  5724                                  ;  147 arr sign byte    89 NULL        0 I_JNL[7]
  5725                                  ;  148 arr sign byte    90 NULL        0 I_JGE[7]
  5726                                  ;  149 arr sign byte    91 NULL        0 I_JLE[7]
  5727                                  ;  150 arr sign byte    92 NULL        0 I_JNG[7]
  5728                                  ;  151 arr sign byte    93 NULL        0 I_JG[6]
  5729                                  ;  152 arr sign byte    95 NULL        0 I_JMP[8]
  5730                                  ;  153 arr sign byte    96 NULL        0 I_CALL[9]
  5731                                  ;  154 arr sign byte    98 NULL        0 I_RET[8]
  5732                                  ;  155 arr sign byte    99 NULL        0 I_RETF[9]
  5733                                  ;  156 arr sign byte   101 NULL        0 I_PUSH[8]
  5734                                  ;  157 arr sign byte   102 NULL        0 I_POP[7]
  5735                                  ;  158 arr sign byte   104 NULL        0 I_ROL[7]
  5736                                  ;  159 arr sign byte   105 NULL        0 I_ROR[7]
  5737                                  ;  160 arr sign byte   106 NULL        0 I_RCL[7]
  5738                                  ;  161 arr sign byte   107 NULL        0 I_RCR[7]
  5739                                  ;  162 arr sign byte   108 NULL        0 I_SHL[7]
  5740                                  ;  163 arr sign byte   109 NULL        0 I_SAL[7]
  5741                                  ;  164 arr sign byte   110 NULL        0 I_SHR[7]
  5742                                  ;  165 arr sign byte   111 NULL        0 I_SAR[7]
  5743                                  ;  166 arr sign byte   113 NULL        0 I_INT[8]
  5744                                  ;  167 arr sign byte   114 NULL        0 I_INTO[8]
  5745                                  ;  168 arr sign byte   116 NULL        0 I_IN[7]
  5746                                  ;  169 arr sign byte   117 NULL        0 I_INSB[8]
  5747                                  ;  170 arr sign byte   118 NULL        0 I_INSW[8]
  5748                                  ;  171 arr sign byte   119 NULL        0 I_INSD[8]
  5749                                  ;  172 arr sign byte   120 NULL        0 I_OUT[8]
  5750                                  ;  173 arr sign byte   121 NULL        0 I_OUTSB[8]
  5751                                  ;  174 arr sign byte   122 NULL        0 I_OUTSW[8]
  5752                                  ;  175 arr sign byte   123 NULL        0 I_OUTSD[8]
  5753                                  ;  176 arr sign byte   125 NULL        0 I_XCHG[9]
  5754                                  ;  177 arr sign byte   127 NULL        0 I_LOOPNZ[10]
  5755                                  ;  178 arr sign byte   128 NULL        0 I_LOOPNE[10]
  5756                                  ;  179 arr sign byte   129 NULL        0 I_LOOPZ[9]
  5757                                  ;  180 arr sign byte   130 NULL        0 I_LOOPE[9]
  5758                                  ;  181 arr sign byte   131 NULL        0 I_LOOP[8]
  5759                                  ;  182 arr sign byte   132 NULL        0 I_JCXZ[8]
  5760                                  ;  183 arr sign byte   133 NULL        0 I_JECXZ[9]
  5761                                  ;  184 arr sign byte   135 NULL        0 I_ENTER[9]
  5762                                  ;  185 arr sign byte   137 NULL        0 I_ORG[6]
  5763                                  ;  186 arr sign byte   138 NULL        0 I_DB[5]
  5764                                  ;  187 arr sign byte   139 NULL        0 I_DW[5]
  5765                                  ;  188 arr sign byte   140 NULL        0 I_DD[5]
  5766                                  ;  189 arr sign byte   141 NULL        0 I_RESB[7]
  5767                                  ;  190 arr sign byte   142 NULL        0 I_RESW[7]
  5768                                  ;  191 arr sign byte   143 NULL        0 I_RESD[7]
  5769                                  ;  192 var sign byte   144 NULL        0 I_END
  5770                                  
  5771                                  
  5772                                  ;   # Calls Line Width  Name   list of functions
  5773                                  
  5774                                  ;    0 NULL    1 word   main
  5775                                  ;    1    1    6 word   process
  5776                                  ;    2    1   45 word   setwflag
  5777                                  ;    3 NULL   57 word   Check2Op
  5778                                  ;    4    1   59 word   checkLeftOp
  5779                                  ;    5 NULL   71 word   saveLeftOp
  5780                                  ;    6 NULL   73 word   checkRightOp
  5781                                  ;    7    1   84 word   getOp
  5782                                  ;    8    2   97 word   getOp1
  5783                                  ;    9    1  113 word   getMEM
  5784                                  ;   10    1  135 word   getIndReg1
  5785                                  ;   11    1  143 word   getIndReg2
  5786                                  ;   12    1  154 word   getCodes
  5787                                  ;   13    1  159 word   gen66h
  5788                                  ;   14    3  161 word   genCode
  5789                                  ;   15   11  165 word   genCode8
  5790                                  ;   16    3  175 word   genCode16
  5791                                  ;   17    1  179 word   writeEA
  5792                                  ;   18    1    1 word   parse
  5793                                  ;   19   12   27 word   getTokeType
  5794                                  ;   20    2   36 word   storeLabel
  5795                                  ;   21    2   43 word   searchLabel
  5796                                  ;   22    1   54 word   getVariable
  5797                                  ;   23    2   83 word   lookCode
  5798                                  ;   24    1   97 word   getCodeSize
  5799                                  ;   25    7  104 word   isToken
  5800                                  ;   26    1  109 word   skipRest
  5801                                  ;   27    1    1 word   getLine
  5802                                  ;   28    1   14 word   ifEOL
  5803                                  ;   29    3   21 word   skipBlank
  5804                                  ;   30    2   26 word   letterE
  5805                                  ;   31    1   36 word   alnumE
  5806                                  ;   32    1   41 word   getDigit
  5807                                  ;   33    1   53 word   getName
  5808                                  ;   34    1   70 word   testReg
  5809                                  ;   35    1    1 word   printLine
  5810                                  ;   36    9   19 word   prc
  5811                                  ;   37    1   23 word   prscomment
  5812                                  ;   38   23   26 word   prs
  5813                                  ;   39    4   31 word   printhex8a
  5814                                  ;   40    2   35 word   printhex16
  5815                                  ;   41    3   38 word   printIntU
  5816                                  ;   42   21   45 word   error1
  5817                                  ;   43 NULL   48 word   allowederror
  5818                                  ;   44    1   49 word   implmerror
  5819                                  ;   45    4   50 word   indexerror
  5820                                  ;   46    1   51 word   numbererror
  5821                                  ;   47 NULL   52 word   regmemerror
  5822                                  ;   48    1   53 word   segregerror
  5823                                  ;   49    1   54 word   syntaxerror
  5824                                  ;   50    7   56 word   errorexit
  5825                                  ;   51    1   57 word   addrexit
  5826                                  ;   52 NULL   58 word   internexit
  5827                                  ;   53    1    1 word   getarg
  5828                                  ;   54    1   26 word   epilog
  5829                                  ;   55    2   53 word   end1
  5830                                  ;   56    4  218 word   writetty
  5831                                  ;   57    8  219 word   cputs
  5832                                  ;   58    2  220 word   toupper
  5833                                  ;   59    4  222 word   strlen
  5834                                  ;   60    6  223 word   strcpy
  5835                                  ;   61    3  225 word   digit
  5836                                  ;   62   35  226 word   eqstr
  5837                                  ;   63    3  229 word   strcat1
  5838                                  ;   64    1  230 word   openR
  5839                                  ;   65    2  231 word   creatR
  5840                                  ;   66    2  232 word   readRL
  5841                                  ;   67    2  233 word   fputcR
  5842                                  ;   68    3  235 word   fcloseR
  5843                                  ;   69    5  236 word   exitR
  5844                                  ;   70    1  238 word   putch
  5845                                  ;   71    4  239 word   DosInt
  5846                                  ;   72 NULL  240 word   LastFunctionByt
  5847                                  
  5848                                  ;    #  addr name   list of CALLs
  5849                                  
  5850                                  ;    0     5 getarg
  5851                                  ;    1    12 parse
  5852                                  ;    2    18 epilog
  5853                                  ;    3    25 end1
  5854                                  ;    4  1387 getTokeType
  5855                                  ;    5  1399 getCodeSize
  5856                                  ;    6  1411 getCodes
  5857                                  ;    7  1420 genCode8
  5858                                  ;    8  1429 checkLeftOp
  5859                                  ;    9  1441 genCode
  5860                                  ;   10  1449 genCode
  5861                                  ;   11  1457 genCode
  5862                                  ;   12  1465 writeEA
  5863                                  ;   13  1473 genCode8
  5864                                  ;   14  1482 genCode16
  5865                                  ;   15  1492 genCode8
  5866                                  ;   16  1501 error1
  5867                                  ;   17  1508 error1
  5868                                  ;   18  1524 gen66h
  5869                                  ;   19  1563 getOp
  5870                                  ;   20  1569 implmerror
  5871                                  ;   21  1580 segregerror
  5872                                  ;   22  1592 setwflag
  5873                                  ;   23  1601 error1
  5874                                  ;   24  1608 error1
  5875                                  ;   25  1615 error1
  5876                                  ;   26  1657 getOp1
  5877                                  ;   27  1664 isToken
  5878                                  ;   28  1672 getMEM
  5879                                  ;   29  1679 error1
  5880                                  ;   30  1686 error1
  5881                                  ;   31  1700 testReg
  5882                                  ;   32  1708 searchLabel
  5883                                  ;   33  1720 error1
  5884                                  ;   34  1738 getTokeType
  5885                                  ;   35  1750 getOp1
  5886                                  ;   36  1757 syntaxerror
  5887                                  ;   37  1769 getIndReg2
  5888                                  ;   38  1780 getIndReg1
  5889                                  ;   39  1791 isToken
  5890                                  ;   40  1799 getTokeType
  5891                                  ;   41  1811 numbererror
  5892                                  ;   42  1823 isToken
  5893                                  ;   43  1831 isToken
  5894                                  ;   44  1839 errorexit
  5895                                  ;   45  1860 indexerror
  5896                                  ;   46  1871 indexerror
  5897                                  ;   47  1895 indexerror
  5898                                  ;   48  1906 indexerror
  5899                                  ;   49  1933 genCode8
  5900                                  ;   50  1954 genCode8
  5901                                  ;   51  1986 genCode8
  5902                                  ;   52  1995 genCode8
  5903                                  ;   53  2020 addrexit
  5904                                  ;   54  2029 error1
  5905                                  ;   55  2036 genCode8
  5906                                  ;   56  2045 genCode8
  5907                                  ;   57  2054 genCode16
  5908                                  ;   58  2070 getLine
  5909                                  ;   59  2078 getTokeType
  5910                                  ;   60  2090 storeLabel
  5911                                  ;   61  2101 getTokeType
  5912                                  ;   62  2113 lookCode
  5913                                  ;   63  2122 process
  5914                                  ;   64  2130 getVariable
  5915                                  ;   65  2142 skipRest
  5916                                  ;   66  2151 error1
  5917                                  ;   67  2158 error1
  5918                                  ;   68  2165 printLine
  5919                                  ;   69  2189 skipBlank
  5920                                  ;   70  2199 digit
  5921                                  ;   71  2205 getDigit
  5922                                  ;   72  2214 letterE
  5923                                  ;   73  2222 getName
  5924                                  ;   74  2241 searchLabel
  5925                                  ;   75  2253 error1
  5926                                  ;   76  2260 strcpy
  5927                                  ;   77  2287 eqstr
  5928                                  ;   78  2293 strlen
  5929                                  ;   79  2314 storeLabel
  5930                                  ;   80  2325 getTokeType
  5931                                  ;   81  2337 lookCode
  5932                                  ;   82  2346 errorexit
  5933                                  ;   83  2356 errorexit
  5934                                  ;   84  2366 getTokeType
  5935                                  ;   85  2378 genCode8
  5936                                  ;   86  2387 skipBlank
  5937                                  ;   87  2397 isToken
  5938                                  ;   88  2405 genCode8
  5939                                  ;   89  2414 isToken
  5940                                  ;   90  2422 getTokeType
  5941                                  ;   91  2434 genCode16
  5942                                  ;   92  2444 isToken
  5943                                  ;   93  2452 errorexit
  5944                                  ;   94  2471 eqstr
  5945                                  ;   95  2489 eqstr
  5946                                  ;   96  2495 getTokeType
  5947                                  ;   97  2507 eqstr
  5948                                  ;   98  2513 getTokeType
  5949                                  ;   99  2525 eqstr
  5950                                  ;  100  2531 getTokeType
  5951                                  ;  101  2553 skipBlank
  5952                                  ;  102  2572 getTokeType
  5953                                  ;  103  2584 error1
  5954                                  ;  104  2599 readRL
  5955                                  ;  105  2606 errorexit
  5956                                  ;  106  2616 ifEOL
  5957                                  ;  107  2630 readRL
  5958                                  ;  108  2666 digit
  5959                                  ;  109  2672 letterE
  5960                                  ;  110  2699 digit
  5961                                  ;  111  2717 alnumE
  5962                                  ;  112  2724 strcpy
  5963                                  ;  113  2731 toupper
  5964                                  ;  114  2747 strlen
  5965                                  ;  115  2754 strlen
  5966                                  ;  116  2761 eqstr
  5967                                  ;  117  2767 eqstr
  5968                                  ;  118  2773 eqstr
  5969                                  ;  119  2779 eqstr
  5970                                  ;  120  2785 eqstr
  5971                                  ;  121  2791 eqstr
  5972                                  ;  122  2797 eqstr
  5973                                  ;  123  2803 eqstr
  5974                                  ;  124  2809 eqstr
  5975                                  ;  125  2815 eqstr
  5976                                  ;  126  2821 eqstr
  5977                                  ;  127  2827 eqstr
  5978                                  ;  128  2833 eqstr
  5979                                  ;  129  2839 eqstr
  5980                                  ;  130  2845 eqstr
  5981                                  ;  131  2851 eqstr
  5982                                  ;  132  2857 eqstr
  5983                                  ;  133  2863 eqstr
  5984                                  ;  134  2869 eqstr
  5985                                  ;  135  2875 eqstr
  5986                                  ;  136  2881 eqstr
  5987                                  ;  137  2887 eqstr
  5988                                  ;  138  2893 eqstr
  5989                                  ;  139  2899 eqstr
  5990                                  ;  140  2905 eqstr
  5991                                  ;  141  2911 eqstr
  5992                                  ;  142  2917 eqstr
  5993                                  ;  143  2923 eqstr
  5994                                  ;  144  2929 eqstr
  5995                                  ;  145  2935 eqstr
  5996                                  ;  146  2955 prs
  5997                                  ;  147  2959 printhex16
  5998                                  ;  148  2970 prs
  5999                                  ;  149  2974 prc
  6000                                  ;  150  2978 printhex8a
  6001                                  ;  151  2989 prc
  6002                                  ;  152  2993 prs
  6003                                  ;  153  2997 prscomment
  6004                                  ;  154  3014 writetty
  6005                                  ;  155  3023 writetty
  6006                                  ;  156  3032 fputcR
  6007                                  ;  157  3054 prc
  6008                                  ;  158  3070 prc
  6009                                  ;  159  3091 prc
  6010                                  ;  160  3095 prc
  6011                                  ;  161  3117 printhex8a
  6012                                  ;  162  3128 printhex8a
  6013                                  ;  163  3153 printIntU
  6014                                  ;  164  3163 prc
  6015                                  ;  165  3176 prs
  6016                                  ;  166  3180 prs
  6017                                  ;  167  3184 prs
  6018                                  ;  168  3188 prs
  6019                                  ;  169  3205 error1
  6020                                  ;  170  3223 error1
  6021                                  ;  171  3241 error1
  6022                                  ;  172  3260 error1
  6023                                  ;  173  3279 error1
  6024                                  ;  174  3298 error1
  6025                                  ;  175  3317 error1
  6026                                  ;  176  3336 error1
  6027                                  ;  177  3343 end1
  6028                                  ;  178  3357 errorexit
  6029                                  ;  179  3378 errorexit
  6030                                  ;  180  3407 cputs
  6031                                  ;  181  3413 cputs
  6032                                  ;  182  3419 exitR
  6033                                  ;  183  3425 toupper
  6034                                  ;  184  3433 strcpy
  6035                                  ;  185  3440 strcat1
  6036                                  ;  186  3448 strcpy
  6037                                  ;  187  3455 strcat1
  6038                                  ;  188  3463 strcpy
  6039                                  ;  189  3470 strcat1
  6040                                  ;  190  3478 openR
  6041                                  ;  191  3484 cputs
  6042                                  ;  192  3490 cputs
  6043                                  ;  193  3496 exitR
  6044                                  ;  194  3502 creatR
  6045                                  ;  195  3509 cputs
  6046                                  ;  196  3515 cputs
  6047                                  ;  197  3521 exitR
  6048                                  ;  198  3527 creatR
  6049                                  ;  199  3534 cputs
  6050                                  ;  200  3540 cputs
  6051                                  ;  201  3546 exitR
  6052                                  ;  202  3552 prs
  6053                                  ;  203  3556 prs
  6054                                  ;  204  3560 prs
  6055                                  ;  205  3564 prs
  6056                                  ;  206  3568 prs
  6057                                  ;  207  3572 prs
  6058                                  ;  208  3576 prs
  6059                                  ;  209  3580 prs
  6060                                  ;  210  3584 prs
  6061                                  ;  211  3601 prs
  6062                                  ;  212  3605 printIntU
  6063                                  ;  213  3615 prs
  6064                                  ;  214  3619 prs
  6065                                  ;  215  3623 prs
  6066                                  ;  216  3627 prc
  6067                                  ;  217  3631 printhex16
  6068                                  ;  218  3642 prs
  6069                                  ;  219  3646 strlen
  6070                                  ;  220  3653 prs
  6071                                  ;  221  3657 printIntU
  6072                                  ;  222  3667 prs
  6073                                  ;  223  3671 prc
  6074                                  ;  224  3675 printhex8a
  6075                                  ;  225  3686 fputcR
  6076                                  ;  226  3700 fcloseR
  6077                                  ;  227  3708 fcloseR
  6078                                  ;  228  3716 fcloseR
  6079                                  ;  229  3724 exitR
  6080                                  ;  230  3749 putch
  6081                                  ;  231  3817 strcpy
  6082                                  ;  232  3832 DosInt
  6083                                  ;  233  3848 DosInt
  6084                                  ;  234  3871 DosInt
  6085                                  ;  235  3890 DosInt
  6086                                  ;  236  3924 writetty
  6087                                  ;  237  3933 writetty
  6088                                  ;Input: AS.C, List: AS.S,  Lines:  241
  6089                                  ;Glob. variables:  192 max.:  200
  6090                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6091                                  ;Functions      :   73 max.:  300
  6092                                  ;Calls          :  238 max.: 2000, NameField: 3965 max.:    65535
  6093                                  ;Code until     :26009 max.: 30000, free: 3991
  6094                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6095                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
