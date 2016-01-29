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
    11 00000003 E81F1B                   call getarg
    12 00000006 E8640B                   call parse
    13 00000009 E8711D                   call epilog
    14 0000000C E8AA1E                   call end1
    15                                  
    16                                  ;-2 char Version1[]="AS.C V0.07 29.1.2016";
    17                                  
    18 0000000F C3                       ret
    19                                  ; ENDP
    20 00000010 41532E432056302E30-     Version1 db "AS.C V0.07 29.1.2016",0
    21 00000019 372032392E312E3230-
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
   861                                  ;-138 // section, segment .TEXT .DATA .BSS
   862                                  
   863                                  
   864                                  ;-139 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   865                                  
   866 000003ED 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   867 000003F6 F1                 
   868                                  
   869                                  ;-140 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   870                                  
   871 000003F7 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   872 00000400 F1                 
   873                                  
   874                                  ;-141 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   875                                  
   876 00000401 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   877 0000040A 6EF1               
   878                                  
   879                                  ;-142 char I_DB[]=   {'D','B',0,            200,        0xF1};
   880                                  
   881 0000040C 444200C8F1              I_DB db 68,66,0,200,241
   882                                  
   883                                  ;-143 char I_DW[]=   {'D','W',0,            201,        0xF1};
   884                                  
   885 00000411 445700C9F1              I_DW db 68,87,0,201,241
   886                                  
   887                                  ;-144 char I_DD[]=   {'D','D',0,            202,        0xF1};
   888                                  
   889 00000416 444400CAF1              I_DD db 68,68,0,202,241
   890                                  
   891                                  ;-145 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   892                                  
   893 0000041B 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   894                                  
   895                                  ;-146 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   896                                  
   897 00000422 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   898                                  
   899                                  ;-147 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   900                                  
   901 00000429 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   902                                  
   903                                  ;-148 char I_END=0;// end of table char
   904                                  
   905 00000430 00                      I_END db 0
   906                                  ;Back to main program: AS.C
   907                                  
   908                                  ;-5 
   909                                  
   910                                  
   911                                  ;-6 int process() {
   912                                  
   913                                  
   914                                  process:  ; *** PROC ***
   915                                  
   916                                  ;-7   getTokeType();//0, DIGIT, ALNUME, NOALNUME
   917                                  
   918 00000431 E82308                   call getTokeType
   919                                  
   920                                  ;-8   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
   921                                  
   922 00000434 E81A0B                   call getCodeSize
   923 00000437 A2[4400]                 mov byte [OpSize], al
   924                                  
   925                                  ;-9   getCodes();//set: Code1, Code2, Code3
   926                                  
   927 0000043A E87C05                   call getCodes
   928                                  
   929                                  ;-10 
   930                                  
   931                                  
   932                                  ;-11   if (CodeType ==  1) {//1 byte opcode
   933                                  
   934 0000043D A0[3E00]                 mov al, [CodeType]
   935 00000440 3C01                     cmp al, 1
   936 00000442 0F850F00                 jne @@process1
   937                                  
   938                                  ;-12     genCode8(Code1);
   939                                  
   940 00000446 A0[3F00]                 mov al, byte [Code1]
   941 00000449 B400                     mov ah, 0
   942 0000044B 50                       push ax
   943 0000044C E8BC05                   call genCode8
   944 0000044F 83C402                   add  sp, 2
   945                                  
   946                                  ;-13     return;
   947                                  
   948 00000452 E9FA00                   jmp @@retn
   949                                  
   950                                  ;-14   }
   951                                  
   952                                  
   953                                  ;-15   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
   954                                  
   955                                  @@process1:
   956 00000455 A0[3E00]                 mov al, [CodeType]
   957 00000458 3C02                     cmp al, 2
   958 0000045A 0F858A00                 jne @@process2
   959                                  
   960                                  ;-16     checkLeftOp();
   961                                  
   962 0000045E E87401                   call checkLeftOp
   963                                  
   964                                  ;-17       if (Code2 <= 1) {//inc,dec
   965                                  
   966 00000461 A0[4000]                 mov al, [Code2]
   967 00000464 3C01                     cmp al, 1
   968 00000466 0F8F4500                 jg  @@process3
   969                                  
   970                                  ;-18     	if (Op1 == REG) {
   971                                  
   972 0000046A A0[3D00]                 mov al, [Op1]
   973 0000046D 3C02                     cmp al, 2
   974 0000046F 0F853C00                 jne @@process4
   975                                  
   976                                  ;-19         if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
   977                                  
   978 00000473 A0[4200]                 mov al, [RegType]
   979 00000476 3C02                     cmp al, 2
   980 00000478 0F851500                 jne @@process5
   981 0000047C A0[4300]                 mov al, byte [RegNo]
   982 0000047F B400                     mov ah, 0
   983 00000481 50                       push ax
   984 00000482 A0[4100]                 mov al, byte [Code3]
   985 00000485 B400                     mov ah, 0
   986 00000487 50                       push ax
   987 00000488 E86505                   call genCode
   988 0000048B 83C404                   add  sp, 4
   989 0000048E E9BE00                   jmp @@retn
   990                                  
   991                                  ;-20         if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
   992                                  
   993                                  @@process5:
   994 00000491 A0[4200]                 mov al, [RegType]
   995 00000494 3C03                     cmp al, 3
   996 00000496 0F851500                 jne @@process6
   997 0000049A A0[4300]                 mov al, byte [RegNo]
   998 0000049D B400                     mov ah, 0
   999 0000049F 50                       push ax
  1000 000004A0 A0[4100]                 mov al, byte [Code3]
  1001 000004A3 B400                     mov ah, 0
  1002 000004A5 50                       push ax
  1003 000004A6 E84705                   call genCode
  1004 000004A9 83C404                   add  sp, 4
  1005 000004AC E9A000                   jmp @@retn
  1006                                  
  1007                                  ;-21         }
  1008                                  
  1009                                  @@process6:
  1010                                  
  1011                                  ;-22       }
  1012                                  
  1013                                  @@process4:
  1014                                  
  1015                                  ;-23       if (Code2 == 5) {//imul extension?
  1016                                  
  1017                                  @@process3:
  1018 000004AF A0[4000]                 mov al, [Code2]
  1019 000004B2 3C05                     cmp al, 5
  1020 000004B4 0F850F00                 jne @@process7
  1021                                  
  1022                                  ;-24         getTokeType();
  1023                                  
  1024 000004B8 E89C07                   call getTokeType
  1025                                  
  1026                                  ;-25         if (TokeType) implerror();
  1027                                  
  1028 000004BB A0[3C00]                 mov al, [TokeType]
  1029 000004BE 08C0                     or  al, al
  1030 000004C0 0F840300                 je @@process8
  1031 000004C4 E83B15                   call implerror
  1032                                  
  1033                                  ;-26       }
  1034                                  
  1035                                  @@process8:
  1036                                  
  1037                                  ;-27       genCode(Code1, wflag);
  1038                                  
  1039                                  @@process7:
  1040 000004C7 A0[4500]                 mov al, byte [wflag]
  1041 000004CA B400                     mov ah, 0
  1042 000004CC 50                       push ax
  1043 000004CD A0[3F00]                 mov al, byte [Code1]
  1044 000004D0 B400                     mov ah, 0
  1045 000004D2 50                       push ax
  1046 000004D3 E81A05                   call genCode
  1047 000004D6 83C404                   add  sp, 4
  1048                                  
  1049                                  ;-28       writeEA(Code2);
  1050                                  
  1051 000004D9 A0[4000]                 mov al, byte [Code2]
  1052 000004DC B400                     mov ah, 0
  1053 000004DE 50                       push ax
  1054 000004DF E87C05                   call writeEA
  1055 000004E2 83C402                   add  sp, 2
  1056                                  
  1057                                  ;-29       return;
  1058                                  
  1059 000004E5 E96700                   jmp @@retn
  1060                                  
  1061                                  ;-30   }
  1062                                  
  1063                                  
  1064                                  ;-31  
  1065                                  
  1066                                  
  1067                                  ;-32   if (CodeType ==  8) {//ret,retf
  1068                                  
  1069                                  @@process2:
  1070 000004E8 A0[3E00]                 mov al, [CodeType]
  1071 000004EB 3C08                     cmp al, 8
  1072 000004ED 0F853100                 jne @@process9
  1073                                  
  1074                                  ;-33     if (TokeType == DIGIT) {
  1075                                  
  1076 000004F1 A0[3C00]                 mov al, [TokeType]
  1077 000004F4 3C01                     cmp al, 1
  1078 000004F6 0F851900                 jne @@process10
  1079                                  
  1080                                  ;-34       genCode8(Code2);
  1081                                  
  1082 000004FA A0[4000]                 mov al, byte [Code2]
  1083 000004FD B400                     mov ah, 0
  1084 000004FF 50                       push ax
  1085 00000500 E80805                   call genCode8
  1086 00000503 83C402                   add  sp, 2
  1087                                  
  1088                                  ;-35       genCode16(SymbolInt);
  1089                                  
  1090 00000506 FF36[2600]               push word [SymbolInt]
  1091 0000050A E83005                   call genCode16
  1092 0000050D 83C402                   add  sp, 2
  1093                                  
  1094                                  ;-36       return;
  1095                                  
  1096 00000510 E93C00                   jmp @@retn
  1097                                  
  1098                                  ;-37     }
  1099                                  
  1100                                  
  1101                                  ;-38     genCode8(Code1); 
  1102                                  
  1103                                  @@process10:
  1104 00000513 A0[3F00]                 mov al, byte [Code1]
  1105 00000516 B400                     mov ah, 0
  1106 00000518 50                       push ax
  1107 00000519 E8EF04                   call genCode8
  1108 0000051C 83C402                   add  sp, 2
  1109                                  
  1110                                  ;-39     return;
  1111                                  
  1112 0000051F E92D00                   jmp @@retn
  1113                                  
  1114                                  ;-40   }
  1115                                  
  1116                                  
  1117                                  ;-41 
  1118                                  
  1119                                  
  1120                                  ;-42   if (CodeType==101) {// ORG nn
  1121                                  
  1122                                  @@process9:
  1123 00000522 A0[3E00]                 mov al, [CodeType]
  1124 00000525 3C65                     cmp al, 101
  1125 00000527 0F851B00                 jne @@process11
  1126                                  
  1127                                  ;-43     if (TokeType != DIGIT) error1("only digit allowed");
  1128                                  
  1129 0000052B A0[3C00]                 mov al, [TokeType]
  1130 0000052E 3C01                     cmp al, 1
  1131 00000530 0F840900                 je  @@process12
  1132 00000534 68[5005]                 push process_0
  1133 00000537 E84E14                   call error1
  1134 0000053A 83C402                   add  sp, 2
  1135                                  
  1136                                  ;-44     PC=SymbolInt;return;
  1137                                  
  1138                                  @@process12:
  1139 0000053D A1[2600]                 mov ax, [SymbolInt]
  1140 00000540 A3[3700]                 mov word [PC], ax
  1141 00000543 E90900                   jmp @@retn
  1142                                  
  1143                                  ;-45   }
  1144                                  
  1145                                  
  1146                                  ;-46   error1("unknown CodeType");
  1147                                  
  1148                                  @@process11:
  1149 00000546 68[6305]                 push process_1
  1150 00000549 E83C14                   call error1
  1151 0000054C 83C402                   add  sp, 2
  1152                                  
  1153                                  ;-47 }
  1154                                  
  1155                                  
  1156                                  ;-48 
  1157                                  
  1158                                  
  1159                                  ;-49 int setwflag() {//only Op1 (first operand)
  1160                                  
  1161                                  @@retn:
  1162 0000054F C3                       ret
  1163                                  ; ENDP
  1164 00000550 6F6E6C792064696769-     process_0 db "only digit allowed",0
  1165 00000559 7420616C6C6F776564-
  1166 00000562 00                 
  1167 00000563 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  1168 0000056C 6F64655479706500   
  1169                                  
  1170                                  setwflag:  ; *** PROC ***
  1171                                  
  1172                                  ;-50   wflag=0;
  1173                                  
  1174 00000574 66B800000000             mov eax, 0
  1175 0000057A A2[4500]                 mov byte [wflag], al
  1176                                  
  1177                                  ;-51   if (OpSize == 0) {//do not override OpSize
  1178                                  
  1179 0000057D A0[4400]                 mov al, [OpSize]
  1180 00000580 3C00                     cmp al, 0
  1181 00000582 0F852100                 jne @@setwflag13
  1182                                  
  1183                                  ;-52     if (Op1 == REG) {
  1184                                  
  1185 00000586 A0[3D00]                 mov al, [Op1]
  1186 00000589 3C02                     cmp al, 2
  1187 0000058B 0F851800                 jne @@setwflag14
  1188                                  
  1189                                  ;-53       OpSize=RegType;
  1190                                  
  1191 0000058F A0[4200]                 mov al, [RegType]
  1192 00000592 A2[4400]                 mov byte [OpSize], al
  1193                                  
  1194                                  ;-54       if (RegType == SEGREG) OpSize=WORD;
  1195                                  
  1196 00000595 A0[4200]                 mov al, [RegType]
  1197 00000598 3C04                     cmp al, 4
  1198 0000059A 0F850900                 jne @@setwflag15
  1199 0000059E 66B802000000             mov eax, 2
  1200 000005A4 A2[4400]                 mov byte [OpSize], al
  1201                                  
  1202                                  ;-55     }
  1203                                  
  1204                                  @@setwflag15:
  1205                                  
  1206                                  ;-56   }
  1207                                  
  1208                                  @@setwflag14:
  1209                                  
  1210                                  ;-57   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1211                                  
  1212                                  @@setwflag13:
  1213 000005A7 A0[4400]                 mov al, [OpSize]
  1214 000005AA 3C03                     cmp al, 3
  1215 000005AC 0F850C00                 jne @@setwflag16
  1216 000005B0 E83404                   call gen66h
  1217 000005B3 66B801000000             mov eax, 1
  1218 000005B9 A2[4500]                 mov byte [wflag], al
  1219                                  
  1220                                  ;-58   if (OpSize  ==  WORD) wflag=1;
  1221                                  
  1222                                  @@setwflag16:
  1223 000005BC A0[4400]                 mov al, [OpSize]
  1224 000005BF 3C02                     cmp al, 2
  1225 000005C1 0F850900                 jne @@setwflag17
  1226 000005C5 66B801000000             mov eax, 1
  1227 000005CB A2[4500]                 mov byte [wflag], al
  1228                                  
  1229                                  ;-59 }
  1230                                  
  1231                                  @@setwflag17:
  1232                                  
  1233                                  ;-60 
  1234                                  
  1235                                  
  1236                                  ;-61 int Check2Op(char left, char rigth) {
  1237                                  
  1238 000005CE C3                       ret
  1239                                  ; ENDP
  1240                                  
  1241                                  Check2Op:  ; *** PROC ***
  1242                                  
  1243                                  ;-62 }
  1244                                  
  1245                                  ;Function : Check2Op, Number of local variables: 2
  1246                                  ;   # type sign width line used address name   list of local variables
  1247                                  ;  200 var sign byte    61 NULL bp+4    left
  1248                                  ;  201 var sign byte    61 NULL bp+6    rigth;
  1249 000005CF C8000000                 ENTER  0,0
  1250                                  
  1251                                  ;-63 int checkLeftOp() {
  1252 000005D3 C9                       LEAVE
  1253 000005D4 C3                       ret
  1254                                  ; ENDP
  1255                                  
  1256                                  checkLeftOp:  ; *** PROC ***
  1257                                  
  1258                                  ;-64   getOp();
  1259                                  
  1260 000005D5 E8BA00                   call getOp
  1261                                  
  1262                                  ;-65   if (Op1 == ADR) implerror();
  1263                                  
  1264 000005D8 A0[3D00]                 mov al, [Op1]
  1265 000005DB 3C03                     cmp al, 3
  1266 000005DD 0F850300                 jne @@checkLeftOp18
  1267 000005E1 E81E14                   call implerror
  1268                                  
  1269                                  ;-66   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  1270                                  
  1271                                  @@checkLeftOp18:
  1272 000005E4 A0[4200]                 mov al, [RegType]
  1273 000005E7 3C04                     cmp al, 4
  1274 000005E9 0F850600                 jne @@checkLeftOp19
  1275 000005ED E8AC14                   call segregerror
  1276 000005F0 E95300                   jmp @@retn
  1277                                  
  1278                                  ;-67   setwflag();
  1279                                  
  1280                                  @@checkLeftOp19:
  1281 000005F3 E87EFF                   call setwflag
  1282                                  
  1283                                  ;-68   if (OpSize == 0) error1("no op size declared");
  1284                                  
  1285 000005F6 A0[4400]                 mov al, [OpSize]
  1286 000005F9 3C00                     cmp al, 0
  1287 000005FB 0F850900                 jne @@checkLeftOp20
  1288 000005FF 68[4706]                 push checkLeftOp_0
  1289 00000602 E88313                   call error1
  1290 00000605 83C402                   add  sp, 2
  1291                                  
  1292                                  ;-69   if (OpSize == RegType) return;
  1293                                  
  1294                                  @@checkLeftOp20:
  1295 00000608 A0[4400]                 mov al, [OpSize]
  1296 0000060B 3A06[4200]               cmp al, [RegType]
  1297 0000060F 0F850300                 jne @@checkLeftOp21
  1298 00000613 E93000                   jmp @@retn
  1299                                  
  1300                                  ;-70   if (OpSize){if (Op1 == MEM) return;
  1301                                  
  1302                                  @@checkLeftOp21:
  1303 00000616 A0[4400]                 mov al, [OpSize]
  1304 00000619 08C0                     or  al, al
  1305 0000061B 0F841500                 je @@checkLeftOp22
  1306 0000061F A0[3D00]                 mov al, [Op1]
  1307 00000622 3C04                     cmp al, 4
  1308 00000624 0F850300                 jne @@checkLeftOp23
  1309 00000628 E91B00                   jmp @@retn
  1310                                  
  1311                                  ;-71     error1("Conflict OpSize and RegSize"); }
  1312                                  
  1313                                  @@checkLeftOp23:
  1314 0000062B 68[5B06]                 push checkLeftOp_1
  1315 0000062E E85713                   call error1
  1316 00000631 83C402                   add  sp, 2
  1317                                  
  1318                                  ;-72   if (RegType==0) error1("no register defined");
  1319                                  
  1320                                  @@checkLeftOp22:
  1321 00000634 A0[4200]                 mov al, [RegType]
  1322 00000637 3C00                     cmp al, 0
  1323 00000639 0F850900                 jne @@checkLeftOp24
  1324 0000063D 68[7706]                 push checkLeftOp_2
  1325 00000640 E84513                   call error1
  1326 00000643 83C402                   add  sp, 2
  1327                                  
  1328                                  ;-73 }
  1329                                  
  1330                                  @@checkLeftOp24:
  1331                                  
  1332                                  ;-74 
  1333                                  
  1334                                  
  1335                                  ;-75 int saveLeftOp(){
  1336                                  
  1337                                  @@retn:
  1338 00000646 C3                       ret
  1339                                  ; ENDP
  1340 00000647 6E6F206F702073697A-     checkLeftOp_0 db "no op size declared",0
  1341 00000650 65206465636C617265-
  1342 00000659 6400               
  1343 0000065B 436F6E666C69637420-     checkLeftOp_1 db "Conflict OpSize and RegSize",0
  1344 00000664 4F7053697A6520616E-
  1345 0000066D 642052656753697A65-
  1346 00000676 00                 
  1347 00000677 6E6F20726567697374-     checkLeftOp_2 db "no register defined",0
  1348 00000680 657220646566696E65-
  1349 00000689 6400               
  1350                                  
  1351                                  saveLeftOp:  ; *** PROC ***
  1352                                  
  1353                                  ;-76 }
  1354                                  
  1355                                  
  1356                                  ;-77 int checkRightOp(char mode){
  1357                                  
  1358 0000068B C3                       ret
  1359                                  ; ENDP
  1360                                  
  1361                                  checkRightOp:  ; *** PROC ***
  1362                                  
  1363                                  ;-78 }
  1364                                  
  1365                                  ;Function : checkRightOp, Number of local variables: 1
  1366                                  ;   # type sign width line used address name   list of local variables
  1367                                  ;  200 var sign byte    77 NULL bp+4    mode;
  1368 0000068C C8000000                 ENTER  0,0
  1369                                  
  1370                                  ;-79 /*        Op      = 0, IMM, REG, ADR, MEM
  1371                                  
  1372                                  
  1373                                  ;-80 IMM       imme    = 0, SymbolInt    
  1374                                  
  1375                                  
  1376                                  ;-81 REG     R RegNo   = 0 - 7
  1377                                  
  1378                                  
  1379                                  ;-82 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  1380                                  
  1381                                  
  1382                                  ;-83 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  1383                                  
  1384                                  
  1385                                  ;-84 MEM       regindexbase = 0 - 7
  1386                                  
  1387                                  
  1388                                  ;-85 
  1389                                  
  1390                                  
  1391                                  ;-86           OpSize  = 0, BYTE, WORD, DWORD (set wflag)
  1392                                  
  1393                                  
  1394                                  ;-87 */
  1395                                  
  1396                                  
  1397                                  ;-88 int getOp() {
  1398 00000690 C9                       LEAVE
  1399 00000691 C3                       ret
  1400                                  ; ENDP
  1401                                  
  1402                                  getOp:  ; *** PROC ***
  1403                                  
  1404                                  ;-89 //set: op1=0,IMM,REG,ADR,MEM
  1405                                  
  1406                                  
  1407                                  ;-90   disp=0; imme=0; regindexbase=0; isDirect=1;
  1408                                  
  1409 00000692 66B800000000             mov eax, 0
  1410 00000698 A3[4800]                 mov word [disp], ax
  1411 0000069B 66B800000000             mov eax, 0
  1412 000006A1 A3[4A00]                 mov word [imme], ax
  1413 000006A4 66B800000000             mov eax, 0
  1414 000006AA A2[4600]                 mov byte [regindexbase], al
  1415 000006AD 66B801000000             mov eax, 1
  1416 000006B3 A2[4700]                 mov byte [isDirect], al
  1417                                  
  1418                                  ;-91 
  1419                                  
  1420                                  
  1421                                  ;-92   Op1=getOp1();
  1422                                  
  1423 000006B6 E8A800                   call getOp1
  1424 000006B9 A2[3D00]                 mov byte [Op1], al
  1425                                  
  1426                                  ;-93   if (isToken('[')) {Op1 = MEM; getMEM();  return;}
  1427                                  
  1428 000006BC 6A5B                     push 91
  1429 000006BE E81309                   call isToken
  1430 000006C1 83C402                   add  sp, 2
  1431 000006C4 08C0                     or  al, al
  1432 000006C6 0F840F00                 je @@getOp25
  1433 000006CA 66B804000000             mov eax, 4
  1434 000006D0 A2[3D00]                 mov byte [Op1], al
  1435 000006D3 E81101                   call getMEM
  1436 000006D6 E95200                   jmp @@retn
  1437                                  
  1438                                  ;-94   if (Op1 == 0) error1("Name of operand expected");
  1439                                  
  1440                                  @@getOp25:
  1441 000006D9 A0[3D00]                 mov al, [Op1]
  1442 000006DC 3C00                     cmp al, 0
  1443 000006DE 0F850900                 jne @@getOp26
  1444 000006E2 68[2C07]                 push getOp_0
  1445 000006E5 E8A012                   call error1
  1446 000006E8 83C402                   add  sp, 2
  1447                                  
  1448                                  ;-95   if (Op1 == IMM) {imme=SymbolInt;         return;}
  1449                                  
  1450                                  @@getOp26:
  1451 000006EB A0[3D00]                 mov al, [Op1]
  1452 000006EE 3C01                     cmp al, 1
  1453 000006F0 0F850900                 jne @@getOp27
  1454 000006F4 A1[2600]                 mov ax, [SymbolInt]
  1455 000006F7 A3[4A00]                 mov word [imme], ax
  1456 000006FA E92E00                   jmp @@retn
  1457                                  
  1458                                  ;-96   if (Op1 == REG)                          return;
  1459                                  
  1460                                  @@getOp27:
  1461 000006FD A0[3D00]                 mov al, [Op1]
  1462 00000700 3C02                     cmp al, 2
  1463 00000702 0F850300                 jne @@getOp28
  1464 00000706 E92200                   jmp @@retn
  1465                                  
  1466                                  ;-97   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}
  1467                                  
  1468                                  @@getOp28:
  1469 00000709 A0[3D00]                 mov al, [Op1]
  1470 0000070C 3C03                     cmp al, 3
  1471 0000070E 0F851000                 jne @@getOp29
  1472 00000712 8B1E[5500]               mov bx, [LabelIx]
  1473 00000716 D1E3                     shl bx, 1
  1474 00000718 8B87A37A                 mov ax, [LabelAddr + bx]
  1475 0000071C A3[4800]                 mov word [disp], ax
  1476 0000071F E90900                   jmp @@retn
  1477                                  
  1478                                  ;-98   error1("Name of operand expected #1");
  1479                                  
  1480                                  @@getOp29:
  1481 00000722 68[4507]                 push getOp_1
  1482 00000725 E86012                   call error1
  1483 00000728 83C402                   add  sp, 2
  1484                                  
  1485                                  ;-99 }
  1486                                  
  1487                                  
  1488                                  ;-100 
  1489                                  
  1490                                  
  1491                                  ;-101 int getOp1() {//scan for a single operand
  1492                                  
  1493                                  @@retn:
  1494 0000072B C3                       ret
  1495                                  ; ENDP
  1496 0000072C 4E616D65206F66206F-     getOp_0 db "Name of operand expected",0
  1497 00000735 706572616E64206578-
  1498 0000073E 70656374656400     
  1499 00000745 4E616D65206F66206F-     getOp_1 db "Name of operand expected #1",0
  1500 0000074E 706572616E64206578-
  1501 00000757 706563746564202331-
  1502 00000760 00                 
  1503                                  
  1504                                  getOp1:  ; *** PROC ***
  1505                                  
  1506                                  ;-102 //return:0, IMM, REG, ADR (not MEM)
  1507                                  
  1508                                  
  1509                                  ;-103 //set   :RegType, RegNo by testReg
  1510                                  
  1511                                  
  1512                                  ;-104 //set   :LabelIx by searchLabel
  1513                                  
  1514                                  
  1515                                  ;-105   if (TokeType == 0)      return 0;
  1516                                  
  1517 00000761 A0[3C00]                 mov al, [TokeType]
  1518 00000764 3C00                     cmp al, 0
  1519 00000766 0F850900                 jne @@getOp130
  1520 0000076A 66B800000000             mov eax, 0
  1521 00000770 E96000                   jmp @@retn
  1522                                  
  1523                                  ;-106   if (TokeType == DIGIT)  return IMM;
  1524                                  
  1525                                  @@getOp130:
  1526 00000773 A0[3C00]                 mov al, [TokeType]
  1527 00000776 3C01                     cmp al, 1
  1528 00000778 0F850900                 jne @@getOp131
  1529 0000077C 66B801000000             mov eax, 1
  1530 00000782 E94E00                   jmp @@retn
  1531                                  
  1532                                  ;-107   if (TokeType == ALNUME) {
  1533                                  
  1534                                  @@getOp131:
  1535 00000785 A0[3C00]                 mov al, [TokeType]
  1536 00000788 3C03                     cmp al, 3
  1537 0000078A 0F853C00                 jne @@getOp132
  1538                                  
  1539                                  ;-108     RegNo=testReg();
  1540                                  
  1541 0000078E E8500B                   call testReg
  1542 00000791 A2[4300]                 mov byte [RegNo], al
  1543                                  
  1544                                  ;-109     if (RegType)          return REG;
  1545                                  
  1546 00000794 A0[4200]                 mov al, [RegType]
  1547 00000797 08C0                     or  al, al
  1548 00000799 0F840900                 je @@getOp133
  1549 0000079D 66B802000000             mov eax, 2
  1550 000007A3 E92D00                   jmp @@retn
  1551                                  
  1552                                  ;-110     LabelIx=searchLabel();
  1553                                  
  1554                                  @@getOp133:
  1555 000007A6 E89605                   call searchLabel
  1556 000007A9 A3[5500]                 mov word [LabelIx], ax
  1557                                  
  1558                                  ;-111     if (LabelIx)          return ADR;
  1559                                  
  1560 000007AC A1[5500]                 mov ax, [LabelIx]
  1561 000007AF 08C0                     or  al, al
  1562 000007B1 0F840C00                 je @@getOp134
  1563 000007B5 66B803000000             mov eax, 3
  1564 000007BB E91500                   jmp @@retn
  1565                                  
  1566                                  ;-112     else error1("variable not found"); 
  1567                                  
  1568 000007BE E90900                   jmp @@getOp135
  1569                                  @@getOp134:
  1570 000007C1 68[D407]                 push getOp1_0
  1571 000007C4 E8C111                   call error1
  1572 000007C7 83C402                   add  sp, 2
  1573                                  
  1574                                  ;-113   }
  1575                                  
  1576                                  @@getOp135:
  1577                                  
  1578                                  ;-114   return 0;
  1579                                  
  1580                                  @@getOp132:
  1581 000007CA 66B800000000             mov eax, 0
  1582 000007D0 E90000                   jmp @@retn
  1583                                  
  1584                                  ;-115 }
  1585                                  
  1586                                  
  1587                                  ;-116 
  1588                                  
  1589                                  
  1590                                  ;-117 int getMEM() {// e.g. [array+bp+si-4]
  1591                                  
  1592                                  @@retn:
  1593 000007D3 C3                       ret
  1594                                  ; ENDP
  1595 000007D4 7661726961626C6520-     getOp1_0 db "variable not found",0
  1596 000007DD 6E6F7420666F756E64-
  1597 000007E6 00                 
  1598                                  
  1599                                  getMEM:  ; *** PROC ***
  1600                                  
  1601                                  ;-118 //set: disp, regindexbase, RegType
  1602                                  
  1603                                  
  1604                                  ;-119   char op2;
  1605                                  
  1606                                  
  1607                                  ;-120   disp=0; regindexbase=0; RegType=0;
  1608                                  
  1609                                  ;Function : getMEM, Number of local variables: 1
  1610                                  ;   # type sign width line used address name   list of local variables
  1611                                  ;  200 var sign byte   119 NULL bp-2    op2;
  1612 000007E7 C8020000                 ENTER  2,0
  1613 000007EB 66B800000000             mov eax, 0
  1614 000007F1 A3[4800]                 mov word [disp], ax
  1615 000007F4 66B800000000             mov eax, 0
  1616 000007FA A2[4600]                 mov byte [regindexbase], al
  1617 000007FD 66B800000000             mov eax, 0
  1618 00000803 A2[4200]                 mov byte [RegType], al
  1619                                  
  1620                                  ;-121   do {
  1621                                  
  1622                                  @@getMEM36:
  1623                                  
  1624                                  ;-122     getTokeType();
  1625                                  
  1626 00000806 E84E04                   call getTokeType
  1627                                  
  1628                                  ;-123     op2=getOp1();
  1629                                  
  1630 00000809 E855FF                   call getOp1
  1631 0000080C 8846FE                   mov byte [bp-2], al
  1632                                  
  1633                                  ;-124     if (op2 ==   0) syntaxerror();
  1634                                  
  1635 0000080F 8A46FE                   mov al, [bp-2]
  1636 00000812 3C00                     cmp al, 0
  1637 00000814 0F850300                 jne @@getMEM37
  1638 00000818 E8A812                   call syntaxerror
  1639                                  
  1640                                  ;-125     if (op2 == REG) {isDirect=0;
  1641                                  
  1642                                  @@getMEM37:
  1643 0000081B 8A46FE                   mov al, [bp-2]
  1644 0000081E 3C02                     cmp al, 2
  1645 00000820 0F851E00                 jne @@getMEM38
  1646 00000824 66B800000000             mov eax, 0
  1647 0000082A A2[4700]                 mov byte [isDirect], al
  1648                                  
  1649                                  ;-126                       if (regindexbase) regindexbase=getIndReg2();
  1650                                  
  1651 0000082D A0[4600]                 mov al, [regindexbase]
  1652 00000830 08C0                     or  al, al
  1653 00000832 0F840900                 je @@getMEM39
  1654 00000836 E8F300                   call getIndReg2
  1655 00000839 A2[4600]                 mov byte [regindexbase], al
  1656                                  
  1657                                  ;-127                       else getIndReg1();
  1658                                  
  1659 0000083C E90300                   jmp @@getMEM40
  1660                                  @@getMEM39:
  1661 0000083F E88900                   call getIndReg1
  1662                                  
  1663                                  ;-128                     }
  1664                                  
  1665                                  @@getMEM40:
  1666                                  
  1667                                  ;-129     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  1668                                  
  1669                                  @@getMEM38:
  1670 00000842 8A46FE                   mov al, [bp-2]
  1671 00000845 3C03                     cmp al, 3
  1672 00000847 0F851000                 jne @@getMEM41
  1673 0000084B A1[4800]                 mov ax, [disp]
  1674 0000084E 8B1E[5500]               mov bx, [LabelIx]
  1675 00000852 D1E3                     shl bx, 1
  1676 00000854 0387A37A                 add ax, [LabelAddr + bx]
  1677 00000858 A3[4800]                 mov word [disp], ax
  1678                                  
  1679                                  ;-130     if (op2 == IMM) disp=disp+SymbolInt;
  1680                                  
  1681                                  @@getMEM41:
  1682 0000085B 8A46FE                   mov al, [bp-2]
  1683 0000085E 3C01                     cmp al, 1
  1684 00000860 0F850A00                 jne @@getMEM42
  1685 00000864 A1[4800]                 mov ax, [disp]
  1686 00000867 0306[2600]               add ax, [SymbolInt]
  1687 0000086B A3[4800]                 mov word [disp], ax
  1688                                  
  1689                                  ;-131     if (isToken('-')) {
  1690                                  
  1691                                  @@getMEM42:
  1692 0000086E 6A2D                     push 45
  1693 00000870 E86107                   call isToken
  1694 00000873 83C402                   add  sp, 2
  1695 00000876 08C0                     or  al, al
  1696 00000878 0F841900                 je @@getMEM43
  1697                                  
  1698                                  ;-132       getTokeType();
  1699                                  
  1700 0000087C E8D803                   call getTokeType
  1701                                  
  1702                                  ;-133       if (TokeType != DIGIT) numbererror();
  1703                                  
  1704 0000087F A0[3C00]                 mov al, [TokeType]
  1705 00000882 3C01                     cmp al, 1
  1706 00000884 0F840300                 je  @@getMEM44
  1707 00000888 E8CD11                   call numbererror
  1708                                  
  1709                                  ;-134       disp = disp - SymbolInt;
  1710                                  
  1711                                  @@getMEM44:
  1712 0000088B A1[4800]                 mov ax, [disp]
  1713 0000088E 2B06[2600]               sub ax, [SymbolInt]
  1714 00000892 A3[4800]                 mov word [disp], ax
  1715                                  
  1716                                  ;-135     }
  1717                                  
  1718                                  
  1719                                  ;-136   } while (isToken('+'));
  1720                                  
  1721                                  @@getMEM43:
  1722 00000895 6A2B                     push 43
  1723 00000897 E83A07                   call isToken
  1724 0000089A 83C402                   add  sp, 2
  1725 0000089D 08C0                     or  al, al
  1726 0000089F 0F840300                 je @@getMEM45
  1727 000008A3 E960FF                   jmp @@getMEM36
  1728                                  @@getMEM45:
  1729                                  
  1730                                  ;-137   if (isToken(']') == 0) errorexit("] expected");
  1731                                  
  1732 000008A6 6A5D                     push 93
  1733 000008A8 E82907                   call isToken
  1734 000008AB 83C402                   add  sp, 2
  1735 000008AE 83F800                   cmp ax, 0
  1736 000008B1 0F850900                 jne @@getMEM46
  1737 000008B5 68[C008]                 push getMEM_0
  1738 000008B8 E81912                   call errorexit
  1739 000008BB 83C402                   add  sp, 2
  1740                                  
  1741                                  ;-138 }
  1742                                  
  1743                                  @@getMEM46:
  1744                                  
  1745                                  ;-139 int getIndReg1() {
  1746 000008BE C9                       LEAVE
  1747 000008BF C3                       ret
  1748                                  ; ENDP
  1749 000008C0 5D2065787065637465-     getMEM_0 db "] expected",0
  1750 000008C9 6400               
  1751                                  
  1752                                  getIndReg1:  ; *** PROC ***
  1753                                  
  1754                                  ;-140   if (RegType !=WORD) indexerror();
  1755                                  
  1756 000008CB A0[4200]                 mov al, [RegType]
  1757 000008CE 3C02                     cmp al, 2
  1758 000008D0 0F840300                 je  @@getIndReg147
  1759 000008D4 E84511                   call indexerror
  1760                                  
  1761                                  ;-141   if (RegNo==3) regindexbase=7;//BX
  1762                                  
  1763                                  @@getIndReg147:
  1764 000008D7 A0[4300]                 mov al, [RegNo]
  1765 000008DA 3C03                     cmp al, 3
  1766 000008DC 0F850900                 jne @@getIndReg148
  1767 000008E0 66B807000000             mov eax, 7
  1768 000008E6 A2[4600]                 mov byte [regindexbase], al
  1769                                  
  1770                                  ;-142   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  1771                                  
  1772                                  @@getIndReg148:
  1773 000008E9 A0[4300]                 mov al, [RegNo]
  1774 000008EC 3C05                     cmp al, 5
  1775 000008EE 0F850900                 jne @@getIndReg149
  1776 000008F2 66B806000000             mov eax, 6
  1777 000008F8 A2[4600]                 mov byte [regindexbase], al
  1778                                  
  1779                                  ;-143   if (RegNo==7) regindexbase=5;//DI
  1780                                  
  1781                                  @@getIndReg149:
  1782 000008FB A0[4300]                 mov al, [RegNo]
  1783 000008FE 3C07                     cmp al, 7
  1784 00000900 0F850900                 jne @@getIndReg150
  1785 00000904 66B805000000             mov eax, 5
  1786 0000090A A2[4600]                 mov byte [regindexbase], al
  1787                                  
  1788                                  ;-144   if (RegNo==6) regindexbase=4;//SI
  1789                                  
  1790                                  @@getIndReg150:
  1791 0000090D A0[4300]                 mov al, [RegNo]
  1792 00000910 3C06                     cmp al, 6
  1793 00000912 0F850900                 jne @@getIndReg151
  1794 00000916 66B804000000             mov eax, 4
  1795 0000091C A2[4600]                 mov byte [regindexbase], al
  1796                                  
  1797                                  ;-145   if (regindexbase==0) indexerror();
  1798                                  
  1799                                  @@getIndReg151:
  1800 0000091F A0[4600]                 mov al, [regindexbase]
  1801 00000922 3C00                     cmp al, 0
  1802 00000924 0F850300                 jne @@getIndReg152
  1803 00000928 E8F110                   call indexerror
  1804                                  
  1805                                  ;-146 }
  1806                                  
  1807                                  @@getIndReg152:
  1808                                  
  1809                                  ;-147 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1810                                  
  1811 0000092B C3                       ret
  1812                                  ; ENDP
  1813                                  
  1814                                  getIndReg2:  ; *** PROC ***
  1815                                  ;Function : getIndReg2, Number of local variables: 1
  1816                                  ;   # type sign width line used address name   list of local variables
  1817                                  ;  200 var sign byte   147 NULL bp-2    m;
  1818 0000092C C8020000                 ENTER  2,0
  1819 00000930 66B804000000             mov eax, 4
  1820 00000936 8846FE                   mov byte [bp-2], al
  1821                                  
  1822                                  ;-148   if (RegType !=WORD) indexerror();
  1823                                  
  1824 00000939 A0[4200]                 mov al, [RegType]
  1825 0000093C 3C02                     cmp al, 2
  1826 0000093E 0F840300                 je  @@getIndReg253
  1827 00000942 E8D710                   call indexerror
  1828                                  
  1829                                  ;-149   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  1830                                  
  1831                                  @@getIndReg253:
  1832 00000945 A0[4300]                 mov al, [RegNo]
  1833 00000948 3C07                     cmp al, 7
  1834 0000094A 0F852700                 jne @@getIndReg254
  1835 0000094E A0[4600]                 mov al, [regindexbase]
  1836 00000951 3C06                     cmp al, 6
  1837 00000953 0F850C00                 jne @@getIndReg255
  1838 00000957 66B803000000             mov eax, 3
  1839 0000095D 8846FE                   mov byte [bp-2], al
  1840                                  
  1841                                  ;-150            else if (regindexbase==7) m=1;//BX+DI
  1842                                  
  1843 00000960 E91200                   jmp @@getIndReg256
  1844                                  @@getIndReg255:
  1845 00000963 A0[4600]                 mov al, [regindexbase]
  1846 00000966 3C07                     cmp al, 7
  1847 00000968 0F850900                 jne @@getIndReg257
  1848 0000096C 66B801000000             mov eax, 1
  1849 00000972 8846FE                   mov byte [bp-2], al
  1850                                  
  1851                                  ;-151   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  1852                                  
  1853                                  @@getIndReg257:
  1854                                  @@getIndReg256:
  1855                                  @@getIndReg254:
  1856 00000975 A0[4300]                 mov al, [RegNo]
  1857 00000978 3C06                     cmp al, 6
  1858 0000097A 0F852700                 jne @@getIndReg258
  1859 0000097E A0[4600]                 mov al, [regindexbase]
  1860 00000981 3C06                     cmp al, 6
  1861 00000983 0F850C00                 jne @@getIndReg259
  1862 00000987 66B802000000             mov eax, 2
  1863 0000098D 8846FE                   mov byte [bp-2], al
  1864                                  
  1865                                  ;-152            else if (regindexbase==7) m=0;//BX+SI
  1866                                  
  1867 00000990 E91200                   jmp @@getIndReg260
  1868                                  @@getIndReg259:
  1869 00000993 A0[4600]                 mov al, [regindexbase]
  1870 00000996 3C07                     cmp al, 7
  1871 00000998 0F850900                 jne @@getIndReg261
  1872 0000099C 66B800000000             mov eax, 0
  1873 000009A2 8846FE                   mov byte [bp-2], al
  1874                                  
  1875                                  ;-153   if (m > 3) indexerror();
  1876                                  
  1877                                  @@getIndReg261:
  1878                                  @@getIndReg260:
  1879                                  @@getIndReg258:
  1880 000009A5 8A46FE                   mov al, [bp-2]
  1881 000009A8 3C03                     cmp al, 3
  1882 000009AA 0F8E0300                 jle @@getIndReg262
  1883 000009AE E86B10                   call indexerror
  1884                                  
  1885                                  ;-154   return m;
  1886                                  
  1887                                  @@getIndReg262:
  1888 000009B1 8A46FE                   mov al, [bp-2]
  1889 000009B4 E90000                   jmp @@retn
  1890                                  
  1891                                  ;-155 }
  1892                                  
  1893                                  
  1894                                  ;-156 
  1895                                  
  1896                                  
  1897                                  ;-157 // generate code ........................................
  1898                                  
  1899                                  
  1900                                  ;-158 int getCodes() {
  1901                                  
  1902 000009B7 C9                      @@retn: LEAVE
  1903 000009B8 C3                       ret
  1904                                  ; ENDP
  1905                                  
  1906                                  getCodes:  ; *** PROC ***
  1907                                  
  1908                                  ;-159   OpCodePtr ++; Code1 = *OpCodePtr;
  1909                                  
  1910 000009B9 FF06[4E00]               inc  word [OpCodePtr]
  1911 000009BD 8B1E[4E00]               mov bx, [OpCodePtr]
  1912 000009C1 8A07                     mov al, [bx]
  1913 000009C3 B400                     mov ah, 0
  1914 000009C5 A2[3F00]                 mov byte [Code1], al
  1915                                  
  1916                                  ;-160   OpCodePtr ++; Code2 = *OpCodePtr;
  1917                                  
  1918 000009C8 FF06[4E00]               inc  word [OpCodePtr]
  1919 000009CC 8B1E[4E00]               mov bx, [OpCodePtr]
  1920 000009D0 8A07                     mov al, [bx]
  1921 000009D2 B400                     mov ah, 0
  1922 000009D4 A2[4000]                 mov byte [Code2], al
  1923                                  
  1924                                  ;-161   OpCodePtr ++; Code3 = *OpCodePtr;
  1925                                  
  1926 000009D7 FF06[4E00]               inc  word [OpCodePtr]
  1927 000009DB 8B1E[4E00]               mov bx, [OpCodePtr]
  1928 000009DF 8A07                     mov al, [bx]
  1929 000009E1 B400                     mov ah, 0
  1930 000009E3 A2[4100]                 mov byte [Code3], al
  1931                                  
  1932                                  ;-162 }
  1933                                  
  1934                                  
  1935                                  ;-163 int gen66h() {genCode8(0x66);
  1936                                  
  1937 000009E6 C3                       ret
  1938                                  ; ENDP
  1939                                  
  1940                                  gen66h:  ; *** PROC ***
  1941 000009E7 6A66                     push 102
  1942 000009E9 E81F00                   call genCode8
  1943 000009EC 83C402                   add  sp, 2
  1944                                  
  1945                                  ;-164 }
  1946                                  
  1947                                  
  1948                                  ;-165 int genCode(char c, char d) {
  1949                                  
  1950 000009EF C3                       ret
  1951                                  ; ENDP
  1952                                  
  1953                                  genCode:  ; *** PROC ***
  1954                                  
  1955                                  ;-166     c = c + d;
  1956                                  
  1957                                  ;Function : genCode, Number of local variables: 2
  1958                                  ;   # type sign width line used address name   list of local variables
  1959                                  ;  200 var sign byte   165 NULL bp+4    c
  1960                                  ;  201 var sign byte   165 NULL bp+6    d;
  1961 000009F0 C8000000                 ENTER  0,0
  1962 000009F4 8A4604                   mov al, [bp+4]
  1963 000009F7 024606                   add al, [bp+6]
  1964 000009FA 884604                   mov byte [bp+4], al
  1965                                  
  1966                                  ;-167     genCode8(c);
  1967                                  
  1968 000009FD 8A4604                   mov al, byte [bp+4]
  1969 00000A00 B400                     mov ah, 0
  1970 00000A02 50                       push ax
  1971 00000A03 E80500                   call genCode8
  1972 00000A06 83C402                   add  sp, 2
  1973                                  
  1974                                  ;-168 }
  1975                                  
  1976                                  
  1977                                  ;-169 int genCode8(char c) {
  1978 00000A09 C9                       LEAVE
  1979 00000A0A C3                       ret
  1980                                  ; ENDP
  1981                                  
  1982                                  genCode8:  ; *** PROC ***
  1983                                  
  1984                                  ;-170 //set: BinLen++, OpPrintIndex++
  1985                                  
  1986                                  
  1987                                  ;-171   FileBin[BinLen]=c;
  1988                                  
  1989                                  ;Function : genCode8, Number of local variables: 1
  1990                                  ;   # type sign width line used address name   list of local variables
  1991                                  ;  200 var sign byte   169 NULL bp+4    c;
  1992 00000A0B C8000000                 ENTER  0,0
  1993 00000A0F 8A4604                   mov al, [bp+4]
  1994 00000A12 8B1E[5700]               mov bx, [BinLen]
  1995 00000A16 88876B7B                 mov [FileBin+bx], al
  1996                                  
  1997                                  ;-172   BinLen++;
  1998                                  
  1999 00000A1A FF06[5700]               inc  word [BinLen]
  2000                                  
  2001                                  ;-173   PC++;
  2002                                  
  2003 00000A1E FF06[3700]               inc  word [PC]
  2004                                  
  2005                                  ;-174   if (OpPrintIndex < OPMAXLEN) {
  2006                                  
  2007 00000A22 A1[4C00]                 mov ax, [OpPrintIndex]
  2008 00000A25 83F805                   cmp ax, 5
  2009 00000A28 0F8D0F00                 jge @@genCode863
  2010                                  
  2011                                  ;-175     OpPos[OpPrintIndex]=c;
  2012                                  
  2013 00000A2C 8A4604                   mov al, [bp+4]
  2014 00000A2F 8B1E[4C00]               mov bx, [OpPrintIndex]
  2015 00000A33 8887B676                 mov [OpPos+bx], al
  2016                                  
  2017                                  ;-176     OpPrintIndex++;
  2018                                  
  2019 00000A37 FF06[4C00]               inc  word [OpPrintIndex]
  2020                                  
  2021                                  ;-177   }
  2022                                  
  2023                                  
  2024                                  ;-178 }
  2025                                  
  2026                                  @@genCode863:
  2027                                  
  2028                                  ;-179 int genCode16(int i) {
  2029 00000A3B C9                       LEAVE
  2030 00000A3C C3                       ret
  2031                                  ; ENDP
  2032                                  
  2033                                  genCode16:  ; *** PROC ***
  2034                                  
  2035                                  ;-180   genCode8(i); i=i >> 8;
  2036                                  
  2037                                  ;Function : genCode16, Number of local variables: 1
  2038                                  ;   # type sign width line used address name   list of local variables
  2039                                  ;  200 var sign word   179 NULL bp+4    i;
  2040 00000A3D C8000000                 ENTER  0,0
  2041 00000A41 FF7604                   push word [bp+4]
  2042 00000A44 E8C4FF                   call genCode8
  2043 00000A47 83C402                   add  sp, 2
  2044 00000A4A 8B4604                   mov ax, [bp+4]
  2045 00000A4D C1E808                   shr ax, 8
  2046 00000A50 894604                   mov word [bp+4], ax
  2047                                  
  2048                                  ;-181   genCode8(i);
  2049                                  
  2050 00000A53 FF7604                   push word [bp+4]
  2051 00000A56 E8B2FF                   call genCode8
  2052 00000A59 83C402                   add  sp, 2
  2053                                  
  2054                                  ;-182 }
  2055                                  
  2056                                  
  2057                                  ;-183 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  2058 00000A5C C9                       LEAVE
  2059 00000A5D C3                       ret
  2060                                  ; ENDP
  2061                                  
  2062                                  writeEA:  ; *** PROC ***
  2063                                  
  2064                                  ;-184 //mod-byte: mode76, reg/opcode543, r/m210    
  2065                                  
  2066                                  
  2067                                  ;-185   char len;
  2068                                  
  2069                                  
  2070                                  ;-186   len=0;
  2071                                  
  2072                                  ;Function : writeEA, Number of local variables: 2
  2073                                  ;   # type sign width line used address name   list of local variables
  2074                                  ;  200 var sign byte   183 NULL bp+4    xxx
  2075                                  ;  201 var sign byte   185 NULL bp-2    len;
  2076 00000A5E C8020000                 ENTER  2,0
  2077 00000A62 66B800000000             mov eax, 0
  2078 00000A68 8846FE                   mov byte [bp-2], al
  2079                                  
  2080                                  ;-187 //  prs("\nxxx:"); printhex8a(xxx);
  2081                                  
  2082                                  
  2083                                  ;-188   xxx = xxx << 3;//in reg/opcode field
  2084                                  
  2085 00000A6B 8A4604                   mov al, [bp+4]
  2086 00000A6E C0E003                   shl al, 3
  2087 00000A71 884604                   mov byte [bp+4], al
  2088                                  
  2089                                  ;-189   if (Op1 ==   0) addrexit();
  2090                                  
  2091 00000A74 A0[3D00]                 mov al, [Op1]
  2092 00000A77 3C00                     cmp al, 0
  2093 00000A79 0F850300                 jne @@writeEA64
  2094 00000A7D E86B10                   call addrexit
  2095                                  
  2096                                  ;-190   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  2097                                  
  2098                                  @@writeEA64:
  2099 00000A80 A0[3D00]                 mov al, [Op1]
  2100 00000A83 3C02                     cmp al, 2
  2101 00000A85 0F850E00                 jne @@writeEA65
  2102 00000A89 804E04C0                 or  byte [bp+4], 192
  2103 00000A8D 8A4604                   mov al, [bp+4]
  2104 00000A90 0206[4300]               add al, [RegNo]
  2105 00000A94 884604                   mov byte [bp+4], al
  2106                                  
  2107                                  ;-191   if (Op1 == ADR) error1("writeEA");           
  2108                                  
  2109                                  @@writeEA65:
  2110 00000A97 A0[3D00]                 mov al, [Op1]
  2111 00000A9A 3C03                     cmp al, 3
  2112 00000A9C 0F850900                 jne @@writeEA66
  2113 00000AA0 68[650B]                 push writeEA_0
  2114 00000AA3 E8E20E                   call error1
  2115 00000AA6 83C402                   add  sp, 2
  2116                                  
  2117                                  ;-192   if (Op1 == MEM) {
  2118                                  
  2119                                  @@writeEA66:
  2120 00000AA9 A0[3D00]                 mov al, [Op1]
  2121 00000AAC 3C04                     cmp al, 4
  2122 00000AAE 0F857F00                 jne @@writeEA67
  2123                                  
  2124                                  ;-193     if (isDirect) {
  2125                                  
  2126 00000AB2 A0[4700]                 mov al, [isDirect]
  2127 00000AB5 08C0                     or  al, al
  2128 00000AB7 0F841000                 je @@writeEA68
  2129                                  
  2130                                  ;-194         xxx |= 6;
  2131                                  
  2132 00000ABB 804E0406                 or  byte [bp+4], 6
  2133                                  
  2134                                  ;-195         len = 2;
  2135                                  
  2136 00000ABF 66B802000000             mov eax, 2
  2137 00000AC5 8846FE                   mov byte [bp-2], al
  2138                                  
  2139                                  ;-196     }
  2140                                  
  2141                                  
  2142                                  ;-197     else { 
  2143                                  
  2144 00000AC8 E96600                   jmp @@writeEA69
  2145                                  @@writeEA68:
  2146                                  
  2147                                  ;-198       xxx = xxx + regindexbase;   
  2148                                  
  2149 00000ACB 8A4604                   mov al, [bp+4]
  2150 00000ACE 0206[4600]               add al, [regindexbase]
  2151 00000AD2 884604                   mov byte [bp+4], al
  2152                                  
  2153                                  ;-199       if (regindexbase == 6) {//make [BP+00]
  2154                                  
  2155 00000AD5 A0[4600]                 mov al, [regindexbase]
  2156 00000AD8 3C06                     cmp al, 6
  2157 00000ADA 0F851700                 jne @@writeEA70
  2158                                  
  2159                                  ;-200         len=1;
  2160                                  
  2161 00000ADE 66B801000000             mov eax, 1
  2162 00000AE4 8846FE                   mov byte [bp-2], al
  2163                                  
  2164                                  ;-201         if (disp == 0) xxx |= 0x40;
  2165                                  
  2166 00000AE7 A1[4800]                 mov ax, [disp]
  2167 00000AEA 83F800                   cmp ax, 0
  2168 00000AED 0F850400                 jne @@writeEA71
  2169 00000AF1 804E0440                 or  byte [bp+4], 64
  2170                                  
  2171                                  ;-202       }
  2172                                  
  2173                                  @@writeEA71:
  2174                                  
  2175                                  ;-203 
  2176                                  
  2177                                  
  2178                                  ;-204       if (disp) {
  2179                                  
  2180                                  @@writeEA70:
  2181 00000AF5 A1[4800]                 mov ax, [disp]
  2182 00000AF8 08C0                     or  al, al
  2183 00000AFA 0F843300                 je @@writeEA72
  2184                                  
  2185                                  ;-205         ax = disp;
  2186                                  
  2187 00000AFE A1[4800]                 mov  ax, [disp]
  2188                                  
  2189                                  ;-206         if(ax > 127) len=2;
  2190                                  
  2191 00000B01 83F87F                   cmp  ax, 127
  2192 00000B04 0F8E0C00                 jle @@writeEA73
  2193 00000B08 66B802000000             mov eax, 2
  2194 00000B0E 8846FE                   mov byte [bp-2], al
  2195                                  
  2196                                  ;-207         else len=1;
  2197                                  
  2198 00000B11 E90900                   jmp @@writeEA74
  2199                                  @@writeEA73:
  2200 00000B14 66B801000000             mov eax, 1
  2201 00000B1A 8846FE                   mov byte [bp-2], al
  2202                                  
  2203                                  ;-208         if (len == 1) xxx |= 0x40;
  2204                                  
  2205                                  @@writeEA74:
  2206 00000B1D 8A46FE                   mov al, [bp-2]
  2207 00000B20 3C01                     cmp al, 1
  2208 00000B22 0F850700                 jne @@writeEA75
  2209 00000B26 804E0440                 or  byte [bp+4], 64
  2210                                  
  2211                                  ;-209         else xxx |= 0x80;
  2212                                  
  2213 00000B2A E90400                   jmp @@writeEA76
  2214                                  @@writeEA75:
  2215 00000B2D 804E0480                 or  byte [bp+4], 128
  2216                                  
  2217                                  ;-210       }
  2218                                  
  2219                                  @@writeEA76:
  2220                                  
  2221                                  ;-211     }
  2222                                  
  2223                                  @@writeEA72:
  2224                                  
  2225                                  ;-212   }
  2226                                  
  2227                                  @@writeEA69:
  2228                                  
  2229                                  ;-213   genCode8(xxx);// gen second byte
  2230                                  
  2231                                  @@writeEA67:
  2232 00000B31 8A4604                   mov al, byte [bp+4]
  2233 00000B34 B400                     mov ah, 0
  2234 00000B36 50                       push ax
  2235 00000B37 E8D1FE                   call genCode8
  2236 00000B3A 83C402                   add  sp, 2
  2237                                  
  2238                                  ;-214   if (len == 1) genCode8 (disp);
  2239                                  
  2240 00000B3D 8A46FE                   mov al, [bp-2]
  2241 00000B40 3C01                     cmp al, 1
  2242 00000B42 0F850A00                 jne @@writeEA77
  2243 00000B46 FF36[4800]               push word [disp]
  2244 00000B4A E8BEFE                   call genCode8
  2245 00000B4D 83C402                   add  sp, 2
  2246                                  
  2247                                  ;-215   if (len == 2) genCode16(disp);
  2248                                  
  2249                                  @@writeEA77:
  2250 00000B50 8A46FE                   mov al, [bp-2]
  2251 00000B53 3C02                     cmp al, 2
  2252 00000B55 0F850A00                 jne @@writeEA78
  2253 00000B59 FF36[4800]               push word [disp]
  2254 00000B5D E8DDFE                   call genCode16
  2255 00000B60 83C402                   add  sp, 2
  2256                                  
  2257                                  ;-216 }
  2258                                  
  2259                                  @@writeEA78:
  2260                                  
  2261                                  ;-217 
  2262                                  
  2263                                  
  2264                                  ;-218 #include "PARSE.C"
  2265 00000B63 C9                       LEAVE
  2266 00000B64 C3                       ret
  2267                                  ; ENDP
  2268 00000B65 7772697465454100        writeEA_0 db "writeEA",0
  2269                                  ;Use include file: PARSE.C
  2270                                  
  2271                                  ;-1 int parse() {
  2272                                  
  2273                                  
  2274                                  parse:  ; *** PROC ***
  2275                                  
  2276                                  ;-2   LabelNamePtr= &LabelNames;
  2277                                  
  2278 00000B6D B8BB76                   mov ax, LabelNames
  2279 00000B70 A3[5100]                 mov word [LabelNamePtr], ax
  2280                                  
  2281                                  ;-3   do {
  2282                                  
  2283                                  @@parse79:
  2284                                  
  2285                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  2286                                  
  2287 00000B73 A1[3700]                 mov ax, [PC]
  2288 00000B76 A3[3900]                 mov word [PCStart], ax
  2289 00000B79 66B800000000             mov eax, 0
  2290 00000B7F A2[4400]                 mov byte [OpSize], al
  2291 00000B82 66B800000000             mov eax, 0
  2292 00000B88 A3[4C00]                 mov word [OpPrintIndex], ax
  2293 00000B8B 66B820000000             mov eax, 32
  2294 00000B91 A2[5000]                 mov byte [PrintR], al
  2295                                  
  2296                                  ;-5     getLine();
  2297                                  
  2298 00000B94 E89404                   call getLine
  2299                                  
  2300                                  ;-6     InputPtr = &InputBuf;
  2301                                  
  2302 00000B97 B86E75                   mov ax, InputBuf
  2303 00000B9A A3[2800]                 mov word [InputPtr], ax
  2304                                  
  2305                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2306                                  
  2307 00000B9D E8B700                   call getTokeType
  2308                                  
  2309                                  ;-8     if (TokeType == ALNUME) {
  2310                                  
  2311 00000BA0 A0[3C00]                 mov al, [TokeType]
  2312 00000BA3 3C03                     cmp al, 3
  2313 00000BA5 0F851300                 jne @@parse80
  2314                                  
  2315                                  ;-9       if (isLabel) { //set in getName
  2316                                  
  2317 00000BA9 A0[3B00]                 mov al, [isLabel]
  2318 00000BAC 08C0                     or  al, al
  2319 00000BAE 0F840A00                 je @@parse81
  2320                                  
  2321                                  ;-10         storeLabel();
  2322                                  
  2323 00000BB2 E84001                   call storeLabel
  2324                                  
  2325                                  ;-11         InputPtr++;//remove :
  2326                                  
  2327 00000BB5 FF06[2800]               inc  word [InputPtr]
  2328                                  
  2329                                  ;-12         getTokeType();
  2330                                  
  2331 00000BB9 E89B00                   call getTokeType
  2332                                  
  2333                                  ;-13       }
  2334                                  
  2335                                  
  2336                                  ;-14     }
  2337                                  
  2338                                  @@parse81:
  2339                                  
  2340                                  ;-15     if (TokeType == ALNUME) {
  2341                                  
  2342                                  @@parse80:
  2343 00000BBC A0[3C00]                 mov al, [TokeType]
  2344 00000BBF 3C03                     cmp al, 3
  2345 00000BC1 0F851B00                 jne @@parse82
  2346                                  
  2347                                  ;-16       lookCode();// and OpCodePtr
  2348                                  
  2349 00000BC5 E80F03                   call lookCode
  2350                                  
  2351                                  ;-17       if(CodeType) process();
  2352                                  
  2353 00000BC8 A0[3E00]                 mov al, [CodeType]
  2354 00000BCB 08C0                     or  al, al
  2355 00000BCD 0F840600                 je @@parse83
  2356 00000BD1 E85DF8                   call process
  2357                                  
  2358                                  ;-18       else getVariable();
  2359                                  
  2360 00000BD4 E90300                   jmp @@parse84
  2361                                  @@parse83:
  2362 00000BD7 E8C501                   call getVariable
  2363                                  
  2364                                  ;-19       skipRest();
  2365                                  
  2366                                  @@parse84:
  2367 00000BDA E82504                   call skipRest
  2368                                  
  2369                                  ;-20     }
  2370                                  
  2371                                  
  2372                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  2373                                  
  2374 00000BDD E92700                   jmp @@parse85
  2375                                  @@parse82:
  2376 00000BE0 A0[3C00]                 mov al, [TokeType]
  2377 00000BE3 3C03                     cmp al, 3
  2378 00000BE5 0F8E0C00                 jle @@parse86
  2379 00000BE9 68[180C]                 push parse_0
  2380 00000BEC E8990D                   call error1
  2381 00000BEF 83C402                   add  sp, 2
  2382                                  
  2383                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  2384                                  
  2385 00000BF2 E91200                   jmp @@parse87
  2386                                  @@parse86:
  2387 00000BF5 A0[3C00]                 mov al, [TokeType]
  2388 00000BF8 3C01                     cmp al, 1
  2389 00000BFA 0F850900                 jne @@parse88
  2390 00000BFE 68[360C]                 push parse_1
  2391 00000C01 E8840D                   call error1
  2392 00000C04 83C402                   add  sp, 2
  2393                                  
  2394                                  ;-23     printLine();
  2395                                  
  2396                                  @@parse88:
  2397                                  @@parse87:
  2398                                  @@parse85:
  2399 00000C07 E8130B                   call printLine
  2400                                  
  2401                                  ;-24   } while (DOS_NoBytes != 0 );
  2402                                  
  2403 00000C0A A1[3400]                 mov ax, [DOS_NoBytes]
  2404 00000C0D 83F800                   cmp ax, 0
  2405 00000C10 0F840300                 je  @@parse89
  2406 00000C14 E95CFF                   jmp @@parse79
  2407                                  @@parse89:
  2408                                  
  2409                                  ;-25 }
  2410                                  
  2411                                  
  2412                                  ;-26 // scan code .....................................
  2413                                  
  2414                                  
  2415                                  ;-27 int getTokeType() { char c;
  2416                                  
  2417 00000C17 C3                       ret
  2418                                  ; ENDP
  2419 00000C18 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2420 00000C21 696E73747275637469-
  2421 00000C2A 6F6E20657870656374-
  2422 00000C33 656400             
  2423 00000C36 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  2424 00000C3F 616C6C6F7765642040-
  2425 00000C48 207374617274206F66-
  2426 00000C51 206C696E6500       
  2427                                  
  2428                                  getTokeType:  ; *** PROC ***
  2429                                  
  2430                                  ;-28   skipBlank();
  2431                                  
  2432                                  ;Function : getTokeType, Number of local variables: 1
  2433                                  ;   # type sign width line used address name   list of local variables
  2434                                  ;  200 var sign byte    27 NULL bp-2    c;
  2435 00000C57 C8020000                 ENTER  2,0
  2436 00000C5B E89A04                   call skipBlank
  2437                                  
  2438                                  ;-29   c = *InputPtr;
  2439                                  
  2440 00000C5E 8B1E[2800]               mov bx, [InputPtr]
  2441 00000C62 8A07                     mov al, [bx]
  2442 00000C64 B400                     mov ah, 0
  2443 00000C66 8846FE                   mov byte [bp-2], al
  2444                                  
  2445                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  2446                                  
  2447 00000C69 8A46FE                   mov al, [bp-2]
  2448 00000C6C 3C00                     cmp al, 0
  2449 00000C6E 0F850C00                 jne @@getTokeType90
  2450 00000C72 66B800000000             mov eax, 0
  2451 00000C78 A2[3C00]                 mov byte [TokeType], al
  2452 00000C7B E97500                   jmp @@retn
  2453                                  
  2454                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  2455                                  
  2456                                  @@getTokeType90:
  2457 00000C7E 8A46FE                   mov al, [bp-2]
  2458 00000C81 3C3B                     cmp al, 59
  2459 00000C83 0F850C00                 jne @@getTokeType91
  2460 00000C87 66B800000000             mov eax, 0
  2461 00000C8D A2[3C00]                 mov byte [TokeType], al
  2462 00000C90 E96000                   jmp @@retn
  2463                                  
  2464                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2465                                  
  2466                                  @@getTokeType91:
  2467 00000C93 8A46FE                   mov al, byte [bp-2]
  2468 00000C96 B400                     mov ah, 0
  2469 00000C98 50                       push ax
  2470 00000C99 E82713                   call digit
  2471 00000C9C 83C402                   add  sp, 2
  2472 00000C9F 08C0                     or  al, al
  2473 00000CA1 0F841800                 je @@getTokeType92
  2474 00000CA5 8A46FE                   mov al, byte [bp-2]
  2475 00000CA8 B400                     mov ah, 0
  2476 00000CAA 50                       push ax
  2477 00000CAB E85005                   call getDigit
  2478 00000CAE 83C402                   add  sp, 2
  2479 00000CB1 66B801000000             mov eax, 1
  2480 00000CB7 A2[3C00]                 mov byte [TokeType], al
  2481 00000CBA E93600                   jmp @@retn
  2482                                  
  2483                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2484                                  
  2485                                  @@getTokeType92:
  2486 00000CBD 8A46FE                   mov al, byte [bp-2]
  2487 00000CC0 B400                     mov ah, 0
  2488 00000CC2 50                       push ax
  2489 00000CC3 E85D04                   call letterE
  2490 00000CC6 83C402                   add  sp, 2
  2491 00000CC9 08C0                     or  al, al
  2492 00000CCB 0F841800                 je @@getTokeType93
  2493 00000CCF 8A46FE                   mov al, byte [bp-2]
  2494 00000CD2 B400                     mov ah, 0
  2495 00000CD4 50                       push ax
  2496 00000CD5 E87D05                   call getName
  2497 00000CD8 83C402                   add  sp, 2
  2498 00000CDB 66B803000000             mov eax, 3
  2499 00000CE1 A2[3C00]                 mov byte [TokeType], al
  2500 00000CE4 E90C00                   jmp @@retn
  2501                                  
  2502                                  ;-34   TokeType=NOALNUME; return;
  2503                                  
  2504                                  @@getTokeType93:
  2505 00000CE7 66B804000000             mov eax, 4
  2506 00000CED A2[3C00]                 mov byte [TokeType], al
  2507 00000CF0 E90000                   jmp @@retn
  2508                                  
  2509                                  ;-35 }
  2510                                  
  2511                                  
  2512                                  ;-36 int storeLabel() {
  2513                                  
  2514 00000CF3 C9                      @@retn: LEAVE
  2515 00000CF4 C3                       ret
  2516                                  ; ENDP
  2517                                  
  2518                                  storeLabel:  ; *** PROC ***
  2519                                  
  2520                                  ;-37   if(searchLabel()) error1("duplicate label");
  2521                                  
  2522 00000CF5 E84700                   call searchLabel
  2523 00000CF8 08C0                     or  al, al
  2524 00000CFA 0F840900                 je @@storeLabel94
  2525 00000CFE 68[2F0D]                 push storeLabel_0
  2526 00000D01 E8840C                   call error1
  2527 00000D04 83C402                   add  sp, 2
  2528                                  
  2529                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2530                                  
  2531                                  @@storeLabel94:
  2532 00000D07 8D063075                 lea  ax, [Symbol]
  2533 00000D0B 50                       push ax
  2534 00000D0C FF36[5100]               push word [LabelNamePtr]
  2535 00000D10 E87712                   call strcpy
  2536 00000D13 83C404                   add  sp, 4
  2537 00000D16 A3[5100]                 mov word [LabelNamePtr], ax
  2538                                  
  2539                                  ;-39   LabelNamePtr++;
  2540                                  
  2541 00000D19 FF06[5100]               inc  word [LabelNamePtr]
  2542                                  
  2543                                  ;-40   LabelMaxIx++;
  2544                                  
  2545 00000D1D FF06[5300]               inc  word [LabelMaxIx]
  2546                                  
  2547                                  ;-41   LabelAddr[LabelMaxIx] = PC;
  2548                                  
  2549 00000D21 A1[3700]                 mov ax, [PC]
  2550 00000D24 8B1E[5300]               mov bx, [LabelMaxIx]
  2551 00000D28 D1E3                     shl bx, 1
  2552 00000D2A 8987A37A                 mov [LabelAddr+bx], ax
  2553                                  
  2554                                  ;-42 }
  2555                                  
  2556                                  
  2557                                  ;-43 int searchLabel() {
  2558                                  
  2559 00000D2E C3                       ret
  2560                                  ; ENDP
  2561 00000D2F 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2562 00000D38 206C6162656C00     
  2563                                  
  2564                                  searchLabel:  ; *** PROC ***
  2565                                  
  2566                                  ;-44   int LIx; char *p; int j;
  2567                                  
  2568                                  
  2569                                  ;-45   p = &LabelNames;
  2570                                  
  2571                                  ;Function : searchLabel, Number of local variables: 3
  2572                                  ;   # type sign width line used address name   list of local variables
  2573                                  ;  200 var sign word    44 NULL bp-2    LIx
  2574                                  ;  201 ptr sign byte    44 NULL bp-4    p
  2575                                  ;  202 var sign word    44 NULL bp-6    j;
  2576 00000D3F C8060000                 ENTER  6,0
  2577 00000D43 B8BB76                   mov ax, LabelNames
  2578 00000D46 8946FC                   mov word [bp-4], ax
  2579                                  
  2580                                  ;-46   LIx=1;
  2581                                  
  2582 00000D49 66B801000000             mov eax, 1
  2583 00000D4F 8946FE                   mov word [bp-2], ax
  2584                                  
  2585                                  ;-47   while (LIx <= LabelMaxIx) {
  2586                                  
  2587                                  @@searchLabel95:
  2588 00000D52 8B46FE                   mov ax, [bp-2]
  2589 00000D55 3B06[5300]               cmp ax, [LabelMaxIx]
  2590 00000D59 0F8F3700                 jg  @@searchLabel96
  2591                                  
  2592                                  ;-48     if (eqstr(p, Symbol)) return LIx;//pos of label
  2593                                  
  2594 00000D5D 8D063075                 lea  ax, [Symbol]
  2595 00000D61 50                       push ax
  2596 00000D62 FF76FC                   push word [bp-4]
  2597 00000D65 E88E12                   call eqstr
  2598 00000D68 83C404                   add  sp, 4
  2599 00000D6B 08C0                     or  al, al
  2600 00000D6D 0F840600                 je @@searchLabel97
  2601 00000D71 8B46FE                   mov ax, [bp-2]
  2602 00000D74 E92600                   jmp @@retn
  2603                                  
  2604                                  ;-49     j=strlen(p);
  2605                                  
  2606                                  @@searchLabel97:
  2607 00000D77 FF76FC                   push word [bp-4]
  2608 00000D7A E8E211                   call strlen
  2609 00000D7D 83C402                   add  sp, 2
  2610 00000D80 8946FA                   mov word [bp-6], ax
  2611                                  
  2612                                  ;-50     p=p+j; p++; LIx++;
  2613                                  
  2614 00000D83 8B46FC                   mov ax, [bp-4]
  2615 00000D86 0346FA                   add ax, [bp-6]
  2616 00000D89 8946FC                   mov word [bp-4], ax
  2617 00000D8C FF46FC                   inc  word [bp-4]
  2618 00000D8F FF46FE                   inc  word [bp-2]
  2619                                  
  2620                                  ;-51   }
  2621                                  
  2622                                  
  2623                                  ;-52   return 0;
  2624                                  
  2625 00000D92 EBBE                     jmp @@searchLabel95
  2626                                  @@searchLabel96:
  2627 00000D94 66B800000000             mov eax, 0
  2628 00000D9A E90000                   jmp @@retn
  2629                                  
  2630                                  ;-53 }
  2631                                  
  2632                                  
  2633                                  ;-54 int getVariable() { char c;
  2634                                  
  2635 00000D9D C9                      @@retn: LEAVE
  2636 00000D9E C3                       ret
  2637                                  ; ENDP
  2638                                  
  2639                                  getVariable:  ; *** PROC ***
  2640                                  
  2641                                  ;-55   storeLabel();
  2642                                  
  2643                                  ;Function : getVariable, Number of local variables: 1
  2644                                  ;   # type sign width line used address name   list of local variables
  2645                                  ;  200 var sign byte    54 NULL bp-2    c;
  2646 00000D9F C8020000                 ENTER  2,0
  2647 00000DA3 E84FFF                   call storeLabel
  2648                                  
  2649                                  ;-56   getTokeType(); if(TokeType==ALNUME) {// getName
  2650                                  
  2651 00000DA6 E8AEFE                   call getTokeType
  2652 00000DA9 A0[3C00]                 mov al, [TokeType]
  2653 00000DAC 3C03                     cmp al, 3
  2654 00000DAE 0F85CC00                 jne @@getVariable98
  2655                                  
  2656                                  ;-57     lookCode();
  2657                                  
  2658 00000DB2 E82201                   call lookCode
  2659                                  
  2660                                  ;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2661                                  
  2662 00000DB5 A0[3E00]                 mov al, [CodeType]
  2663 00000DB8 3CC8                     cmp al, 200
  2664 00000DBA 0F8D0900                 jge @@getVariable99
  2665 00000DBE 68[890E]                 push getVariable_0
  2666 00000DC1 E8100D                   call errorexit
  2667 00000DC4 83C402                   add  sp, 2
  2668                                  
  2669                                  ;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2670                                  
  2671                                  @@getVariable99:
  2672 00000DC7 A0[3E00]                 mov al, [CodeType]
  2673 00000DCA 3CCF                     cmp al, 207
  2674 00000DCC 0F8E0900                 jle @@getVariable100
  2675 00000DD0 68[A10E]                 push getVariable_1
  2676 00000DD3 E8FE0C                   call errorexit
  2677 00000DD6 83C402                   add  sp, 2
  2678                                  
  2679                                  ;-60     if (CodeType== 200) {// DB
  2680                                  
  2681                                  @@getVariable100:
  2682 00000DD9 A0[3E00]                 mov al, [CodeType]
  2683 00000DDC 3CC8                     cmp al, 200
  2684 00000DDE 0F856A00                 jne @@getVariable101
  2685                                  
  2686                                  ;-61       do { getTokeType();
  2687                                  
  2688                                  @@getVariable102:
  2689 00000DE2 E872FE                   call getTokeType
  2690                                  
  2691                                  ;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2692                                  
  2693 00000DE5 A0[3C00]                 mov al, [TokeType]
  2694 00000DE8 3C01                     cmp al, 1
  2695 00000DEA 0F850D00                 jne @@getVariable103
  2696 00000DEE FF36[2600]               push word [SymbolInt]
  2697 00000DF2 E816FC                   call genCode8
  2698 00000DF5 83C402                   add  sp, 2
  2699                                  
  2700                                  ;-63         else {
  2701                                  
  2702 00000DF8 E94100                   jmp @@getVariable104
  2703                                  @@getVariable103:
  2704                                  
  2705                                  ;-64           skipBlank();
  2706                                  
  2707 00000DFB E8FA02                   call skipBlank
  2708                                  
  2709                                  ;-65           if (isToken('"')) {
  2710                                  
  2711 00000DFE 6A22                     push 34
  2712 00000E00 E8D101                   call isToken
  2713 00000E03 83C402                   add  sp, 2
  2714 00000E06 08C0                     or  al, al
  2715 00000E08 0F843000                 je @@getVariable105
  2716                                  
  2717                                  ;-66             do { c= *InputPtr;
  2718                                  
  2719                                  @@getVariable106:
  2720 00000E0C 8B1E[2800]               mov bx, [InputPtr]
  2721 00000E10 8A07                     mov al, [bx]
  2722 00000E12 B400                     mov ah, 0
  2723 00000E14 8846FE                   mov byte [bp-2], al
  2724                                  
  2725                                  ;-67               genCode8(c);
  2726                                  
  2727 00000E17 8A46FE                   mov al, byte [bp-2]
  2728 00000E1A B400                     mov ah, 0
  2729 00000E1C 50                       push ax
  2730 00000E1D E8EBFB                   call genCode8
  2731 00000E20 83C402                   add  sp, 2
  2732                                  
  2733                                  ;-68               InputPtr++;
  2734                                  
  2735 00000E23 FF06[2800]               inc  word [InputPtr]
  2736                                  
  2737                                  ;-69             } while (*InputPtr != '"' );
  2738                                  
  2739 00000E27 8B1E[2800]               mov bx, [InputPtr]
  2740 00000E2B 8A07                     mov al, [bx]
  2741 00000E2D B400                     mov ah, 0
  2742 00000E2F 83F822                   cmp ax, 34
  2743 00000E32 0F840200                 je  @@getVariable107
  2744 00000E36 EBD4                     jmp @@getVariable106
  2745                                  @@getVariable107:
  2746                                  
  2747                                  ;-70             InputPtr++;
  2748                                  
  2749 00000E38 FF06[2800]               inc  word [InputPtr]
  2750                                  
  2751                                  ;-71           }
  2752                                  
  2753                                  
  2754                                  ;-72         }
  2755                                  
  2756                                  @@getVariable105:
  2757                                  
  2758                                  ;-73       } while (isToken(','));
  2759                                  
  2760                                  @@getVariable104:
  2761 00000E3C 6A2C                     push 44
  2762 00000E3E E89301                   call isToken
  2763 00000E41 83C402                   add  sp, 2
  2764 00000E44 08C0                     or  al, al
  2765 00000E46 0F840200                 je @@getVariable108
  2766 00000E4A EB96                     jmp @@getVariable102
  2767                                  @@getVariable108:
  2768                                  
  2769                                  ;-74     }
  2770                                  
  2771                                  
  2772                                  ;-75     if (CodeType== 201) {// DW
  2773                                  
  2774                                  @@getVariable101:
  2775 00000E4C A0[3E00]                 mov al, [CodeType]
  2776 00000E4F 3CC9                     cmp al, 201
  2777 00000E51 0F852600                 jne @@getVariable109
  2778                                  
  2779                                  ;-76       do { getTokeType();
  2780                                  
  2781                                  @@getVariable110:
  2782 00000E55 E8FFFD                   call getTokeType
  2783                                  
  2784                                  ;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2785                                  
  2786 00000E58 A0[3C00]                 mov al, [TokeType]
  2787 00000E5B 3C01                     cmp al, 1
  2788 00000E5D 0F850A00                 jne @@getVariable111
  2789 00000E61 FF36[2600]               push word [SymbolInt]
  2790 00000E65 E8D5FB                   call genCode16
  2791 00000E68 83C402                   add  sp, 2
  2792                                  
  2793                                  ;-78       } while (isToken(','));
  2794                                  
  2795                                  @@getVariable111:
  2796 00000E6B 6A2C                     push 44
  2797 00000E6D E86401                   call isToken
  2798 00000E70 83C402                   add  sp, 2
  2799 00000E73 08C0                     or  al, al
  2800 00000E75 0F840200                 je @@getVariable112
  2801 00000E79 EBDA                     jmp @@getVariable110
  2802                                  @@getVariable112:
  2803                                  
  2804                                  ;-79     }
  2805                                  
  2806                                  
  2807                                  ;-80   }
  2808                                  
  2809                                  @@getVariable109:
  2810                                  
  2811                                  ;-81   else errorexit("DB,DW,DD or RESB,W,D expected");
  2812                                  
  2813 00000E7B E90900                   jmp @@getVariable113
  2814                                  @@getVariable98:
  2815 00000E7E 68[B90E]                 push getVariable_2
  2816 00000E81 E8500C                   call errorexit
  2817 00000E84 83C402                   add  sp, 2
  2818                                  
  2819                                  ;-82 }
  2820                                  
  2821                                  @@getVariable113:
  2822                                  
  2823                                  ;-83 int lookCode() { // ret: CodeType, *OpCodePtr
  2824 00000E87 C9                       LEAVE
  2825 00000E88 C3                       ret
  2826                                  ; ENDP
  2827 00000E89 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2828 00000E92 422C572C4420657870-
  2829 00000E9B 656374656400       
  2830 00000EA1 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2831 00000EAA 422C572C4420657870-
  2832 00000EB3 656374656400       
  2833 00000EB9 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2834 00000EC2 6F7220524553422C57-
  2835 00000ECB 2C4420657870656374-
  2836 00000ED4 656400             
  2837                                  
  2838                                  lookCode:  ; *** PROC ***
  2839                                  
  2840                                  ;-84   CodeType=0;
  2841                                  
  2842 00000ED7 66B800000000             mov eax, 0
  2843 00000EDD A2[3E00]                 mov byte [CodeType], al
  2844                                  
  2845                                  ;-85   OpCodePtr= &I_START;
  2846                                  
  2847 00000EE0 B8[5D00]                 mov ax, I_START
  2848 00000EE3 A3[4E00]                 mov word [OpCodePtr], ax
  2849                                  
  2850                                  ;-86   OpCodePtr++;
  2851                                  
  2852 00000EE6 FF06[4E00]               inc  word [OpCodePtr]
  2853                                  
  2854                                  ;-87   do  {
  2855                                  
  2856                                  @@lookCode114:
  2857                                  
  2858                                  ;-88     if (eqstr(SymbolUpper, OpCodePtr))  {
  2859                                  
  2860 00000EEA FF36[4E00]               push word [OpCodePtr]
  2861 00000EEE 8D064F75                 lea  ax, [SymbolUpper]
  2862 00000EF2 50                       push ax
  2863 00000EF3 E80011                   call eqstr
  2864 00000EF6 83C404                   add  sp, 4
  2865 00000EF9 08C0                     or  al, al
  2866 00000EFB 0F842700                 je @@lookCode115
  2867                                  
  2868                                  ;-89       while(*OpCodePtr!=0) OpCodePtr++;
  2869                                  
  2870                                  @@lookCode116:
  2871 00000EFF 8B1E[4E00]               mov bx, [OpCodePtr]
  2872 00000F03 8A07                     mov al, [bx]
  2873 00000F05 B400                     mov ah, 0
  2874 00000F07 83F800                   cmp ax, 0
  2875 00000F0A 0F840600                 je  @@lookCode117
  2876 00000F0E FF06[4E00]               inc  word [OpCodePtr]
  2877                                  
  2878                                  ;-90       OpCodePtr++; CodeType =*OpCodePtr;
  2879                                  
  2880 00000F12 EBEB                     jmp @@lookCode116
  2881                                  @@lookCode117:
  2882 00000F14 FF06[4E00]               inc  word [OpCodePtr]
  2883 00000F18 8B1E[4E00]               mov bx, [OpCodePtr]
  2884 00000F1C 8A07                     mov al, [bx]
  2885 00000F1E B400                     mov ah, 0
  2886 00000F20 A2[3E00]                 mov byte [CodeType], al
  2887                                  
  2888                                  ;-91       return;
  2889                                  
  2890 00000F23 E92A00                   jmp @@retn
  2891                                  
  2892                                  ;-92     }
  2893                                  
  2894                                  
  2895                                  ;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2896                                  
  2897                                  @@lookCode115:
  2898                                  @@lookCode118:
  2899 00000F26 8B1E[4E00]               mov bx, [OpCodePtr]
  2900 00000F2A 8A07                     mov al, [bx]
  2901 00000F2C B400                     mov ah, 0
  2902 00000F2E 3DF100                   cmp ax, 241
  2903 00000F31 0F840600                 je  @@lookCode119
  2904 00000F35 FF06[4E00]               inc  word [OpCodePtr]
  2905                                  
  2906                                  ;-94   OpCodePtr++;
  2907                                  
  2908 00000F39 EBEB                     jmp @@lookCode118
  2909                                  @@lookCode119:
  2910 00000F3B FF06[4E00]               inc  word [OpCodePtr]
  2911                                  
  2912                                  ;-95   } while(*OpCodePtr!=0);
  2913                                  
  2914 00000F3F 8B1E[4E00]               mov bx, [OpCodePtr]
  2915 00000F43 8A07                     mov al, [bx]
  2916 00000F45 B400                     mov ah, 0
  2917 00000F47 83F800                   cmp ax, 0
  2918 00000F4A 0F840200                 je  @@lookCode120
  2919 00000F4E EB9A                     jmp @@lookCode114
  2920                                  @@lookCode120:
  2921                                  
  2922                                  ;-96 }
  2923                                  
  2924                                  
  2925                                  ;-97 int getCodeSize() {
  2926                                  
  2927                                  @@retn:
  2928 00000F50 C3                       ret
  2929                                  ; ENDP
  2930                                  
  2931                                  getCodeSize:  ; *** PROC ***
  2932                                  
  2933                                  ;-98   if (TokeType ==ALNUME) {
  2934                                  
  2935 00000F51 A0[3C00]                 mov al, [TokeType]
  2936 00000F54 3C03                     cmp al, 3
  2937 00000F56 0F856000                 jne @@getCodeSize121
  2938                                  
  2939                                  ;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2940                                  
  2941 00000F5A 68[C40F]                 push getCodeSize_0
  2942 00000F5D 8D064F75                 lea  ax, [SymbolUpper]
  2943 00000F61 50                       push ax
  2944 00000F62 E89110                   call eqstr
  2945 00000F65 83C404                   add  sp, 4
  2946 00000F68 08C0                     or  al, al
  2947 00000F6A 0F840C00                 je @@getCodeSize122
  2948 00000F6E E8E6FC                   call getTokeType
  2949 00000F71 66B801000000             mov eax, 1
  2950 00000F77 E94900                   jmp @@retn
  2951                                  
  2952                                  ;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2953                                  
  2954                                  @@getCodeSize122:
  2955 00000F7A 68[C90F]                 push getCodeSize_1
  2956 00000F7D 8D064F75                 lea  ax, [SymbolUpper]
  2957 00000F81 50                       push ax
  2958 00000F82 E87110                   call eqstr
  2959 00000F85 83C404                   add  sp, 4
  2960 00000F88 08C0                     or  al, al
  2961 00000F8A 0F840C00                 je @@getCodeSize123
  2962 00000F8E E8C6FC                   call getTokeType
  2963 00000F91 66B802000000             mov eax, 2
  2964 00000F97 E92900                   jmp @@retn
  2965                                  
  2966                                  ;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2967                                  
  2968                                  @@getCodeSize123:
  2969 00000F9A 68[CE0F]                 push getCodeSize_2
  2970 00000F9D 8D064F75                 lea  ax, [SymbolUpper]
  2971 00000FA1 50                       push ax
  2972 00000FA2 E85110                   call eqstr
  2973 00000FA5 83C404                   add  sp, 4
  2974 00000FA8 08C0                     or  al, al
  2975 00000FAA 0F840C00                 je @@getCodeSize124
  2976 00000FAE E8A6FC                   call getTokeType
  2977 00000FB1 66B803000000             mov eax, 3
  2978 00000FB7 E90900                   jmp @@retn
  2979                                  
  2980                                  ;-102   } return 0;
  2981                                  
  2982                                  @@getCodeSize124:
  2983                                  @@getCodeSize121:
  2984 00000FBA 66B800000000             mov eax, 0
  2985 00000FC0 E90000                   jmp @@retn
  2986                                  
  2987                                  ;-103 }
  2988                                  
  2989                                  
  2990                                  ;-104 int isToken(char c) {
  2991                                  
  2992                                  @@retn:
  2993 00000FC3 C3                       ret
  2994                                  ; ENDP
  2995 00000FC4 4259544500              getCodeSize_0 db "BYTE",0
  2996 00000FC9 574F524400              getCodeSize_1 db "WORD",0
  2997 00000FCE 44574F524400            getCodeSize_2 db "DWORD",0
  2998                                  
  2999                                  isToken:  ; *** PROC ***
  3000                                  
  3001                                  ;-105   skipBlank();
  3002                                  
  3003                                  ;Function : isToken, Number of local variables: 1
  3004                                  ;   # type sign width line used address name   list of local variables
  3005                                  ;  200 var sign byte   104 NULL bp+4    c;
  3006 00000FD4 C8000000                 ENTER  0,0
  3007 00000FD8 E81D01                   call skipBlank
  3008                                  
  3009                                  ;-106   if (*InputPtr == c) {
  3010                                  
  3011 00000FDB 8B1E[2800]               mov bx, [InputPtr]
  3012 00000FDF 8A07                     mov al, [bx]
  3013 00000FE1 B400                     mov ah, 0
  3014 00000FE3 3A4604                   cmp al, [bp+4]
  3015 00000FE6 0F850D00                 jne @@isToken125
  3016                                  
  3017                                  ;-107     InputPtr++; return 1;} return 0;
  3018                                  
  3019 00000FEA FF06[2800]               inc  word [InputPtr]
  3020 00000FEE 66B801000000             mov eax, 1
  3021 00000FF4 E90900                   jmp @@retn
  3022                                  @@isToken125:
  3023 00000FF7 66B800000000             mov eax, 0
  3024 00000FFD E90000                   jmp @@retn
  3025                                  
  3026                                  ;-108 }
  3027                                  
  3028                                  
  3029                                  ;-109 int skipRest() {
  3030                                  
  3031 00001000 C9                      @@retn: LEAVE
  3032 00001001 C3                       ret
  3033                                  ; ENDP
  3034                                  
  3035                                  skipRest:  ; *** PROC ***
  3036                                  
  3037                                  ;-110   getTokeType(); 
  3038                                  
  3039 00001002 E852FC                   call getTokeType
  3040                                  
  3041                                  ;-111   if(TokeType)error1("extra char ignored");
  3042                                  
  3043 00001005 A0[3C00]                 mov al, [TokeType]
  3044 00001008 08C0                     or  al, al
  3045 0000100A 0F840900                 je @@skipRest126
  3046 0000100E 68[1810]                 push skipRest_0
  3047 00001011 E87409                   call error1
  3048 00001014 83C402                   add  sp, 2
  3049                                  
  3050                                  ;-112 }
  3051                                  
  3052                                  @@skipRest126:
  3053 00001017 C3                       ret
  3054                                  ; ENDP
  3055 00001018 657874726120636861-     skipRest_0 db "extra char ignored",0
  3056 00001021 722069676E6F726564-
  3057 0000102A 00                 
  3058                                  ;Back to main program: AS.C
  3059                                  
  3060                                  ;-219 #include "HELPER.C"
  3061                                  
  3062                                  ;Use include file: HELPER.C
  3063                                  
  3064                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3065                                  
  3066                                  
  3067                                  getLine:  ; *** PROC ***
  3068                                  
  3069                                  ;-2   InputPtr= &InputBuf;
  3070                                  
  3071 0000102B B86E75                   mov ax, InputBuf
  3072 0000102E A3[2800]                 mov word [InputPtr], ax
  3073                                  
  3074                                  ;-3   *InputPtr=0;//if last line is empty
  3075                                  
  3076 00001031 66B800000000             mov eax, 0
  3077 00001037 8B1E[2800]               mov  bx, [InputPtr]
  3078 0000103B 8807                     mov  [bx], al
  3079                                  
  3080                                  ;-4   do {
  3081                                  
  3082                                  @@getLine127:
  3083                                  
  3084                                  ;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3085                                  
  3086 0000103D 6A01                     push 1
  3087 0000103F FF36[2A00]               push word [asm_fd]
  3088 00001043 8D06[3600]               lea  ax, [DOS_ByteRead]
  3089 00001047 50                       push ax
  3090 00001048 E84610                   call readRL
  3091 0000104B 83C406                   add  sp, 6
  3092 0000104E A3[3400]                 mov word [DOS_NoBytes], ax
  3093                                  
  3094                                  ;-6     if (DOS_ERR) errorexit("Reading Source");
  3095                                  
  3096 00001051 A1[3000]                 mov ax, [DOS_ERR]
  3097 00001054 08C0                     or  al, al
  3098 00001056 0F840900                 je @@getLine128
  3099 0000105A 68[A210]                 push getLine_0
  3100 0000105D E8740A                   call errorexit
  3101 00001060 83C402                   add  sp, 2
  3102                                  
  3103                                  ;-7     if (DOS_NoBytes == 0) return;
  3104                                  
  3105                                  @@getLine128:
  3106 00001063 A1[3400]                 mov ax, [DOS_NoBytes]
  3107 00001066 83F800                   cmp ax, 0
  3108 00001069 0F850300                 jne @@getLine129
  3109 0000106D E93100                   jmp @@retn
  3110                                  
  3111                                  ;-8     *InputPtr = DOS_ByteRead;
  3112                                  
  3113                                  @@getLine129:
  3114 00001070 A0[3600]                 mov al, [DOS_ByteRead]
  3115 00001073 8B1E[2800]               mov  bx, [InputPtr]
  3116 00001077 8807                     mov  [bx], al
  3117                                  
  3118                                  ;-9     InputPtr++;
  3119                                  
  3120 00001079 FF06[2800]               inc  word [InputPtr]
  3121                                  
  3122                                  ;-10   } while (ifEOL(DOS_ByteRead) == 0);
  3123                                  
  3124 0000107D A0[3600]                 mov al, byte [DOS_ByteRead]
  3125 00001080 B400                     mov ah, 0
  3126 00001082 50                       push ax
  3127 00001083 E82B00                   call ifEOL
  3128 00001086 83C402                   add  sp, 2
  3129 00001089 3C00                     cmp al, 0
  3130 0000108B 0F850200                 jne @@getLine130
  3131 0000108F EBAC                     jmp @@getLine127
  3132                                  @@getLine130:
  3133                                  
  3134                                  ;-11   InputPtr--;
  3135                                  
  3136 00001091 FF0E[2800]               dec  word [InputPtr]
  3137                                  
  3138                                  ;-12   *InputPtr=0;
  3139                                  
  3140 00001095 66B800000000             mov eax, 0
  3141 0000109B 8B1E[2800]               mov  bx, [InputPtr]
  3142 0000109F 8807                     mov  [bx], al
  3143                                  
  3144                                  ;-13 }
  3145                                  
  3146                                  
  3147                                  ;-14 int ifEOL(char c) {
  3148                                  
  3149                                  @@retn:
  3150 000010A1 C3                       ret
  3151                                  ; ENDP
  3152 000010A2 52656164696E672053-     getLine_0 db "Reading Source",0
  3153 000010AB 6F7572636500       
  3154                                  
  3155                                  ifEOL:  ; *** PROC ***
  3156                                  
  3157                                  ;-15   if (c == 10) return 1;
  3158                                  
  3159                                  ;Function : ifEOL, Number of local variables: 1
  3160                                  ;   # type sign width line used address name   list of local variables
  3161                                  ;  200 var sign byte    14 NULL bp+4    c;
  3162 000010B1 C8000000                 ENTER  0,0
  3163 000010B5 8A4604                   mov al, [bp+4]
  3164 000010B8 3C0A                     cmp al, 10
  3165 000010BA 0F850900                 jne @@ifEOL131
  3166 000010BE 66B801000000             mov eax, 1
  3167 000010C4 E92F00                   jmp @@retn
  3168                                  
  3169                                  ;-16   if (c == 13) {
  3170                                  
  3171                                  @@ifEOL131:
  3172 000010C7 8A4604                   mov al, [bp+4]
  3173 000010CA 3C0D                     cmp al, 13
  3174 000010CC 0F851D00                 jne @@ifEOL132
  3175                                  
  3176                                  ;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3177                                  
  3178 000010D0 6A01                     push 1
  3179 000010D2 FF36[2A00]               push word [asm_fd]
  3180 000010D6 8D06[3600]               lea  ax, [DOS_ByteRead]
  3181 000010DA 50                       push ax
  3182 000010DB E8B30F                   call readRL
  3183 000010DE 83C406                   add  sp, 6
  3184 000010E1 A3[3400]                 mov word [DOS_NoBytes], ax
  3185                                  
  3186                                  ;-18     return 1;}
  3187                                  
  3188 000010E4 66B801000000             mov eax, 1
  3189 000010EA E90900                   jmp @@retn
  3190                                  
  3191                                  ;-19   return 0;
  3192                                  
  3193                                  @@ifEOL132:
  3194 000010ED 66B800000000             mov eax, 0
  3195 000010F3 E90000                   jmp @@retn
  3196                                  
  3197                                  ;-20 }
  3198                                  
  3199                                  
  3200                                  ;-21 int skipBlank() {
  3201                                  
  3202 000010F6 C9                      @@retn: LEAVE
  3203 000010F7 C3                       ret
  3204                                  ; ENDP
  3205                                  
  3206                                  skipBlank:  ; *** PROC ***
  3207                                  
  3208                                  ;-22   skipblank1:
  3209                                  
  3210                                  @@skipblank1:
  3211                                  
  3212                                  ;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3213                                  
  3214 000010F8 8B1E[2800]               mov bx, [InputPtr]
  3215 000010FC 8A07                     mov al, [bx]
  3216 000010FE B400                     mov ah, 0
  3217 00001100 83F820                   cmp ax, 32
  3218 00001103 0F850600                 jne @@skipBlank133
  3219 00001107 FF06[2800]               inc  word [InputPtr]
  3220 0000110B EBEB                     jmp @@skipblank1
  3221                                  
  3222                                  ;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3223                                  
  3224                                  @@skipBlank133:
  3225 0000110D 8B1E[2800]               mov bx, [InputPtr]
  3226 00001111 8A07                     mov al, [bx]
  3227 00001113 B400                     mov ah, 0
  3228 00001115 83F809                   cmp ax, 9
  3229 00001118 0F850600                 jne @@skipBlank134
  3230 0000111C FF06[2800]               inc  word [InputPtr]
  3231 00001120 EBD6                     jmp @@skipblank1
  3232                                  
  3233                                  ;-25 }
  3234                                  
  3235                                  @@skipBlank134:
  3236                                  
  3237                                  ;-26 int letterE(char c) {
  3238                                  
  3239 00001122 C3                       ret
  3240                                  ; ENDP
  3241                                  
  3242                                  letterE:  ; *** PROC ***
  3243                                  
  3244                                  ;-27   if (c=='_') return 1;
  3245                                  
  3246                                  ;Function : letterE, Number of local variables: 1
  3247                                  ;   # type sign width line used address name   list of local variables
  3248                                  ;  200 var sign byte    26 NULL bp+4    c;
  3249 00001123 C8000000                 ENTER  0,0
  3250 00001127 8A4604                   mov al, [bp+4]
  3251 0000112A 3C5F                     cmp al, 95
  3252 0000112C 0F850900                 jne @@letterE135
  3253 00001130 66B801000000             mov eax, 1
  3254 00001136 E97E00                   jmp @@retn
  3255                                  
  3256                                  ;-28   if (c=='.') return 1;
  3257                                  
  3258                                  @@letterE135:
  3259 00001139 8A4604                   mov al, [bp+4]
  3260 0000113C 3C2E                     cmp al, 46
  3261 0000113E 0F850900                 jne @@letterE136
  3262 00001142 66B801000000             mov eax, 1
  3263 00001148 E96C00                   jmp @@retn
  3264                                  
  3265                                  ;-29   if (c=='?') return 1;
  3266                                  
  3267                                  @@letterE136:
  3268 0000114B 8A4604                   mov al, [bp+4]
  3269 0000114E 3C3F                     cmp al, 63
  3270 00001150 0F850900                 jne @@letterE137
  3271 00001154 66B801000000             mov eax, 1
  3272 0000115A E95A00                   jmp @@retn
  3273                                  
  3274                                  ;-30   if (c=='$') return 1;
  3275                                  
  3276                                  @@letterE137:
  3277 0000115D 8A4604                   mov al, [bp+4]
  3278 00001160 3C24                     cmp al, 36
  3279 00001162 0F850900                 jne @@letterE138
  3280 00001166 66B801000000             mov eax, 1
  3281 0000116C E94800                   jmp @@retn
  3282                                  
  3283                                  ;-31   if (c> 'z') return 0;
  3284                                  
  3285                                  @@letterE138:
  3286 0000116F 8A4604                   mov al, [bp+4]
  3287 00001172 3C7A                     cmp al, 122
  3288 00001174 0F8E0900                 jle @@letterE139
  3289 00001178 66B800000000             mov eax, 0
  3290 0000117E E93600                   jmp @@retn
  3291                                  
  3292                                  ;-32   if (c< '@') return 0; // at included
  3293                                  
  3294                                  @@letterE139:
  3295 00001181 8A4604                   mov al, [bp+4]
  3296 00001184 3C40                     cmp al, 64
  3297 00001186 0F8D0900                 jge @@letterE140
  3298 0000118A 66B800000000             mov eax, 0
  3299 00001190 E92400                   jmp @@retn
  3300                                  
  3301                                  ;-33   if (c> 'Z') { if (c< 'a') return 0; }
  3302                                  
  3303                                  @@letterE140:
  3304 00001193 8A4604                   mov al, [bp+4]
  3305 00001196 3C5A                     cmp al, 90
  3306 00001198 0F8E1200                 jle @@letterE141
  3307 0000119C 8A4604                   mov al, [bp+4]
  3308 0000119F 3C61                     cmp al, 97
  3309 000011A1 0F8D0900                 jge @@letterE142
  3310 000011A5 66B800000000             mov eax, 0
  3311 000011AB E90900                   jmp @@retn
  3312                                  @@letterE142:
  3313                                  
  3314                                  ;-34   return 1;
  3315                                  
  3316                                  @@letterE141:
  3317 000011AE 66B801000000             mov eax, 1
  3318 000011B4 E90000                   jmp @@retn
  3319                                  
  3320                                  ;-35 }
  3321                                  
  3322                                  
  3323                                  ;-36 int alnumE(char c) {
  3324                                  
  3325 000011B7 C9                      @@retn: LEAVE
  3326 000011B8 C3                       ret
  3327                                  ; ENDP
  3328                                  
  3329                                  alnumE:  ; *** PROC ***
  3330                                  
  3331                                  ;-37   if (digit(c)) return 1;
  3332                                  
  3333                                  ;Function : alnumE, Number of local variables: 1
  3334                                  ;   # type sign width line used address name   list of local variables
  3335                                  ;  200 var sign byte    36 NULL bp+4    c;
  3336 000011B9 C8000000                 ENTER  0,0
  3337 000011BD 8A4604                   mov al, byte [bp+4]
  3338 000011C0 B400                     mov ah, 0
  3339 000011C2 50                       push ax
  3340 000011C3 E8FD0D                   call digit
  3341 000011C6 83C402                   add  sp, 2
  3342 000011C9 08C0                     or  al, al
  3343 000011CB 0F840900                 je @@alnumE143
  3344 000011CF 66B801000000             mov eax, 1
  3345 000011D5 E92400                   jmp @@retn
  3346                                  
  3347                                  ;-38   if (letterE(c)) return 1;
  3348                                  
  3349                                  @@alnumE143:
  3350 000011D8 8A4604                   mov al, byte [bp+4]
  3351 000011DB B400                     mov ah, 0
  3352 000011DD 50                       push ax
  3353 000011DE E842FF                   call letterE
  3354 000011E1 83C402                   add  sp, 2
  3355 000011E4 08C0                     or  al, al
  3356 000011E6 0F840900                 je @@alnumE144
  3357 000011EA 66B801000000             mov eax, 1
  3358 000011F0 E90900                   jmp @@retn
  3359                                  
  3360                                  ;-39   return 0;
  3361                                  
  3362                                  @@alnumE144:
  3363 000011F3 66B800000000             mov eax, 0
  3364 000011F9 E90000                   jmp @@retn
  3365                                  
  3366                                  ;-40 }
  3367                                  
  3368                                  
  3369                                  ;-41 int getDigit(unsigned char c) {//ret: SymbolInt
  3370                                  
  3371 000011FC C9                      @@retn: LEAVE
  3372 000011FD C3                       ret
  3373                                  ; ENDP
  3374                                  
  3375                                  getDigit:  ; *** PROC ***
  3376                                  
  3377                                  ;-42   unsigned int CastInt;
  3378                                  
  3379                                  
  3380                                  ;-43   SymbolInt=0;
  3381                                  
  3382                                  ;Function : getDigit, Number of local variables: 2
  3383                                  ;   # type sign width line used address name   list of local variables
  3384                                  ;  200 var unsg byte    41 NULL bp+4    c
  3385                                  ;  201 var unsg word    42 NULL bp-2    CastInt;
  3386 000011FE C8020000                 ENTER  2,0
  3387 00001202 66B800000000             mov eax, 0
  3388 00001208 A3[2600]                 mov word [SymbolInt], ax
  3389                                  
  3390                                  ;-44   do {
  3391                                  
  3392                                  @@getDigit145:
  3393                                  
  3394                                  ;-45     c-='0';
  3395                                  
  3396 0000120B 806E0430                 sub  byte [bp+4], 48
  3397                                  
  3398                                  ;-46     SymbolInt=SymbolInt*10;
  3399                                  
  3400 0000120F A1[2600]                 mov ax, [SymbolInt]
  3401 00001212 66BB0A000000             mov ebx, 10
  3402 00001218 66F7E3                   mul ebx
  3403 0000121B A3[2600]                 mov word [SymbolInt], ax
  3404                                  
  3405                                  ;-47     ax=0; CastInt=c; //cast b2w
  3406                                  
  3407 0000121E B80000                   mov  ax, 0
  3408 00001221 8A4604                   mov al, [bp+4]
  3409 00001224 8946FE                   mov word [bp-2], ax
  3410                                  
  3411                                  ;-48     SymbolInt=SymbolInt+CastInt;
  3412                                  
  3413 00001227 A1[2600]                 mov ax, [SymbolInt]
  3414 0000122A 0346FE                   add ax, [bp-2]
  3415 0000122D A3[2600]                 mov word [SymbolInt], ax
  3416                                  
  3417                                  ;-49     InputPtr++;
  3418                                  
  3419 00001230 FF06[2800]               inc  word [InputPtr]
  3420                                  
  3421                                  ;-50     c = *InputPtr;
  3422                                  
  3423 00001234 8B1E[2800]               mov bx, [InputPtr]
  3424 00001238 8A07                     mov al, [bx]
  3425 0000123A B400                     mov ah, 0
  3426 0000123C 884604                   mov byte [bp+4], al
  3427                                  
  3428                                  ;-51   } while(digit(c));
  3429                                  
  3430 0000123F 8A4604                   mov al, byte [bp+4]
  3431 00001242 B400                     mov ah, 0
  3432 00001244 50                       push ax
  3433 00001245 E87B0D                   call digit
  3434 00001248 83C402                   add  sp, 2
  3435 0000124B 08C0                     or  al, al
  3436 0000124D 0F840200                 je @@getDigit146
  3437 00001251 EBB8                     jmp @@getDigit145
  3438                                  @@getDigit146:
  3439                                  
  3440                                  ;-52 }
  3441                                  
  3442                                  
  3443                                  ;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3444 00001253 C9                       LEAVE
  3445 00001254 C3                       ret
  3446                                  ; ENDP
  3447                                  
  3448                                  getName:  ; *** PROC ***
  3449                                  
  3450                                  ;-54   char *p;
  3451                                  
  3452                                  
  3453                                  ;-55   p = &Symbol;
  3454                                  
  3455                                  ;Function : getName, Number of local variables: 2
  3456                                  ;   # type sign width line used address name   list of local variables
  3457                                  ;  200 var unsg byte    53 NULL bp+4    c
  3458                                  ;  201 ptr sign byte    54 NULL bp-2    p;
  3459 00001255 C8020000                 ENTER  2,0
  3460 00001259 B83075                   mov ax, Symbol
  3461 0000125C 8946FE                   mov word [bp-2], ax
  3462                                  
  3463                                  ;-56   *p = c;
  3464                                  
  3465 0000125F 8A4604                   mov al, [bp+4]
  3466 00001262 8B5EFE                   mov  bx, [bp-2]
  3467 00001265 8807                     mov  [bx], al
  3468                                  
  3469                                  ;-57   p++;
  3470                                  
  3471 00001267 FF46FE                   inc  word [bp-2]
  3472                                  
  3473                                  ;-58   while (alnumE(c)) {
  3474                                  
  3475                                  @@getName147:
  3476 0000126A 8A4604                   mov al, byte [bp+4]
  3477 0000126D B400                     mov ah, 0
  3478 0000126F 50                       push ax
  3479 00001270 E846FF                   call alnumE
  3480 00001273 83C402                   add  sp, 2
  3481 00001276 08C0                     or  al, al
  3482 00001278 0F841C00                 je @@getName148
  3483                                  
  3484                                  ;-59     InputPtr++;
  3485                                  
  3486 0000127C FF06[2800]               inc  word [InputPtr]
  3487                                  
  3488                                  ;-60     c = *InputPtr;
  3489                                  
  3490 00001280 8B1E[2800]               mov bx, [InputPtr]
  3491 00001284 8A07                     mov al, [bx]
  3492 00001286 B400                     mov ah, 0
  3493 00001288 884604                   mov byte [bp+4], al
  3494                                  
  3495                                  ;-61     *p = c;
  3496                                  
  3497 0000128B 8A4604                   mov al, [bp+4]
  3498 0000128E 8B5EFE                   mov  bx, [bp-2]
  3499 00001291 8807                     mov  [bx], al
  3500                                  
  3501                                  ;-62     p++;
  3502                                  
  3503 00001293 FF46FE                   inc  word [bp-2]
  3504                                  
  3505                                  ;-63   }
  3506                                  
  3507                                  
  3508                                  ;-64   if (c == ':') isLabel=1; else isLabel=0;
  3509                                  
  3510 00001296 EBD2                     jmp @@getName147
  3511                                  @@getName148:
  3512 00001298 8A4604                   mov al, [bp+4]
  3513 0000129B 3C3A                     cmp al, 58
  3514 0000129D 0F850C00                 jne @@getName149
  3515 000012A1 66B801000000             mov eax, 1
  3516 000012A7 A2[3B00]                 mov byte [isLabel], al
  3517 000012AA E90900                   jmp @@getName150
  3518                                  @@getName149:
  3519 000012AD 66B800000000             mov eax, 0
  3520 000012B3 A2[3B00]                 mov byte [isLabel], al
  3521                                  
  3522                                  ;-65   p--;
  3523                                  
  3524                                  @@getName150:
  3525 000012B6 FF4EFE                   dec  word [bp-2]
  3526                                  
  3527                                  ;-66   *p = 0;
  3528                                  
  3529 000012B9 66B800000000             mov eax, 0
  3530 000012BF 8B5EFE                   mov  bx, [bp-2]
  3531 000012C2 8807                     mov  [bx], al
  3532                                  
  3533                                  ;-67   strcpy(SymbolUpper, Symbol);
  3534                                  
  3535 000012C4 8D063075                 lea  ax, [Symbol]
  3536 000012C8 50                       push ax
  3537 000012C9 8D064F75                 lea  ax, [SymbolUpper]
  3538 000012CD 50                       push ax
  3539 000012CE E8B90C                   call strcpy
  3540 000012D1 83C404                   add  sp, 4
  3541                                  
  3542                                  ;-68   toupper(SymbolUpper);
  3543                                  
  3544 000012D4 8D064F75                 lea  ax, [SymbolUpper]
  3545 000012D8 50                       push ax
  3546 000012D9 E8400C                   call toupper
  3547 000012DC 83C402                   add  sp, 2
  3548                                  
  3549                                  ;-69 }
  3550                                  
  3551                                  
  3552                                  ;-70 int testReg() {
  3553 000012DF C9                       LEAVE
  3554 000012E0 C3                       ret
  3555                                  ; ENDP
  3556                                  
  3557                                  testReg:  ; *** PROC ***
  3558                                  
  3559                                  ;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3560                                  
  3561                                  
  3562                                  ;-72   RegType=0;
  3563                                  
  3564 000012E1 66B800000000             mov eax, 0
  3565 000012E7 A2[4200]                 mov byte [RegType], al
  3566                                  
  3567                                  ;-73   if (strlen(Symbol) < 2) return 0;
  3568                                  
  3569 000012EA 8D063075                 lea  ax, [Symbol]
  3570 000012EE 50                       push ax
  3571 000012EF E86D0C                   call strlen
  3572 000012F2 83C402                   add  sp, 2
  3573 000012F5 3C02                     cmp al, 2
  3574 000012F7 0F8D0900                 jge @@testReg151
  3575 000012FB 66B800000000             mov eax, 0
  3576 00001301 E9B603                   jmp @@retn
  3577                                  
  3578                                  ;-74   if (strlen(Symbol) > 3) return 0;
  3579                                  
  3580                                  @@testReg151:
  3581 00001304 8D063075                 lea  ax, [Symbol]
  3582 00001308 50                       push ax
  3583 00001309 E8530C                   call strlen
  3584 0000130C 83C402                   add  sp, 2
  3585 0000130F 3C03                     cmp al, 3
  3586 00001311 0F8E0900                 jle @@testReg152
  3587 00001315 66B800000000             mov eax, 0
  3588 0000131B E99C03                   jmp @@retn
  3589                                  
  3590                                  ;-75   RegType=BYTE;
  3591                                  
  3592                                  @@testReg152:
  3593 0000131E 66B801000000             mov eax, 1
  3594 00001324 A2[4200]                 mov byte [RegType], al
  3595                                  
  3596                                  ;-76   if (eqstr(SymbolUpper, "AL")) return 0;
  3597                                  
  3598 00001327 68[BB16]                 push testReg_0
  3599 0000132A 8D064F75                 lea  ax, [SymbolUpper]
  3600 0000132E 50                       push ax
  3601 0000132F E8C40C                   call eqstr
  3602 00001332 83C404                   add  sp, 4
  3603 00001335 08C0                     or  al, al
  3604 00001337 0F840900                 je @@testReg153
  3605 0000133B 66B800000000             mov eax, 0
  3606 00001341 E97603                   jmp @@retn
  3607                                  
  3608                                  ;-77   if (eqstr(SymbolUpper, "CL")) return 1;
  3609                                  
  3610                                  @@testReg153:
  3611 00001344 68[BE16]                 push testReg_1
  3612 00001347 8D064F75                 lea  ax, [SymbolUpper]
  3613 0000134B 50                       push ax
  3614 0000134C E8A70C                   call eqstr
  3615 0000134F 83C404                   add  sp, 4
  3616 00001352 08C0                     or  al, al
  3617 00001354 0F840900                 je @@testReg154
  3618 00001358 66B801000000             mov eax, 1
  3619 0000135E E95903                   jmp @@retn
  3620                                  
  3621                                  ;-78   if (eqstr(SymbolUpper, "DL")) return 2;
  3622                                  
  3623                                  @@testReg154:
  3624 00001361 68[C116]                 push testReg_2
  3625 00001364 8D064F75                 lea  ax, [SymbolUpper]
  3626 00001368 50                       push ax
  3627 00001369 E88A0C                   call eqstr
  3628 0000136C 83C404                   add  sp, 4
  3629 0000136F 08C0                     or  al, al
  3630 00001371 0F840900                 je @@testReg155
  3631 00001375 66B802000000             mov eax, 2
  3632 0000137B E93C03                   jmp @@retn
  3633                                  
  3634                                  ;-79   if (eqstr(SymbolUpper, "BL")) return 3;
  3635                                  
  3636                                  @@testReg155:
  3637 0000137E 68[C416]                 push testReg_3
  3638 00001381 8D064F75                 lea  ax, [SymbolUpper]
  3639 00001385 50                       push ax
  3640 00001386 E86D0C                   call eqstr
  3641 00001389 83C404                   add  sp, 4
  3642 0000138C 08C0                     or  al, al
  3643 0000138E 0F840900                 je @@testReg156
  3644 00001392 66B803000000             mov eax, 3
  3645 00001398 E91F03                   jmp @@retn
  3646                                  
  3647                                  ;-80   if (eqstr(SymbolUpper, "AH")) return 4;
  3648                                  
  3649                                  @@testReg156:
  3650 0000139B 68[C716]                 push testReg_4
  3651 0000139E 8D064F75                 lea  ax, [SymbolUpper]
  3652 000013A2 50                       push ax
  3653 000013A3 E8500C                   call eqstr
  3654 000013A6 83C404                   add  sp, 4
  3655 000013A9 08C0                     or  al, al
  3656 000013AB 0F840900                 je @@testReg157
  3657 000013AF 66B804000000             mov eax, 4
  3658 000013B5 E90203                   jmp @@retn
  3659                                  
  3660                                  ;-81   if (eqstr(SymbolUpper, "CH")) return 5;
  3661                                  
  3662                                  @@testReg157:
  3663 000013B8 68[CA16]                 push testReg_5
  3664 000013BB 8D064F75                 lea  ax, [SymbolUpper]
  3665 000013BF 50                       push ax
  3666 000013C0 E8330C                   call eqstr
  3667 000013C3 83C404                   add  sp, 4
  3668 000013C6 08C0                     or  al, al
  3669 000013C8 0F840900                 je @@testReg158
  3670 000013CC 66B805000000             mov eax, 5
  3671 000013D2 E9E502                   jmp @@retn
  3672                                  
  3673                                  ;-82   if (eqstr(SymbolUpper, "DH")) return 6;
  3674                                  
  3675                                  @@testReg158:
  3676 000013D5 68[CD16]                 push testReg_6
  3677 000013D8 8D064F75                 lea  ax, [SymbolUpper]
  3678 000013DC 50                       push ax
  3679 000013DD E8160C                   call eqstr
  3680 000013E0 83C404                   add  sp, 4
  3681 000013E3 08C0                     or  al, al
  3682 000013E5 0F840900                 je @@testReg159
  3683 000013E9 66B806000000             mov eax, 6
  3684 000013EF E9C802                   jmp @@retn
  3685                                  
  3686                                  ;-83   if (eqstr(SymbolUpper, "BH")) return 7;
  3687                                  
  3688                                  @@testReg159:
  3689 000013F2 68[D016]                 push testReg_7
  3690 000013F5 8D064F75                 lea  ax, [SymbolUpper]
  3691 000013F9 50                       push ax
  3692 000013FA E8F90B                   call eqstr
  3693 000013FD 83C404                   add  sp, 4
  3694 00001400 08C0                     or  al, al
  3695 00001402 0F840900                 je @@testReg160
  3696 00001406 66B807000000             mov eax, 7
  3697 0000140C E9AB02                   jmp @@retn
  3698                                  
  3699                                  ;-84   RegType=WORD;
  3700                                  
  3701                                  @@testReg160:
  3702 0000140F 66B802000000             mov eax, 2
  3703 00001415 A2[4200]                 mov byte [RegType], al
  3704                                  
  3705                                  ;-85   if (eqstr(SymbolUpper, "AX")) return 0;
  3706                                  
  3707 00001418 68[D316]                 push testReg_8
  3708 0000141B 8D064F75                 lea  ax, [SymbolUpper]
  3709 0000141F 50                       push ax
  3710 00001420 E8D30B                   call eqstr
  3711 00001423 83C404                   add  sp, 4
  3712 00001426 08C0                     or  al, al
  3713 00001428 0F840900                 je @@testReg161
  3714 0000142C 66B800000000             mov eax, 0
  3715 00001432 E98502                   jmp @@retn
  3716                                  
  3717                                  ;-86   if (eqstr(SymbolUpper, "CX")) return 1;
  3718                                  
  3719                                  @@testReg161:
  3720 00001435 68[D616]                 push testReg_9
  3721 00001438 8D064F75                 lea  ax, [SymbolUpper]
  3722 0000143C 50                       push ax
  3723 0000143D E8B60B                   call eqstr
  3724 00001440 83C404                   add  sp, 4
  3725 00001443 08C0                     or  al, al
  3726 00001445 0F840900                 je @@testReg162
  3727 00001449 66B801000000             mov eax, 1
  3728 0000144F E96802                   jmp @@retn
  3729                                  
  3730                                  ;-87   if (eqstr(SymbolUpper, "DX")) return 2;
  3731                                  
  3732                                  @@testReg162:
  3733 00001452 68[D916]                 push testReg_10
  3734 00001455 8D064F75                 lea  ax, [SymbolUpper]
  3735 00001459 50                       push ax
  3736 0000145A E8990B                   call eqstr
  3737 0000145D 83C404                   add  sp, 4
  3738 00001460 08C0                     or  al, al
  3739 00001462 0F840900                 je @@testReg163
  3740 00001466 66B802000000             mov eax, 2
  3741 0000146C E94B02                   jmp @@retn
  3742                                  
  3743                                  ;-88   if (eqstr(SymbolUpper, "BX")) return 3;
  3744                                  
  3745                                  @@testReg163:
  3746 0000146F 68[DC16]                 push testReg_11
  3747 00001472 8D064F75                 lea  ax, [SymbolUpper]
  3748 00001476 50                       push ax
  3749 00001477 E87C0B                   call eqstr
  3750 0000147A 83C404                   add  sp, 4
  3751 0000147D 08C0                     or  al, al
  3752 0000147F 0F840900                 je @@testReg164
  3753 00001483 66B803000000             mov eax, 3
  3754 00001489 E92E02                   jmp @@retn
  3755                                  
  3756                                  ;-89   if (eqstr(SymbolUpper, "SP")) return 4;
  3757                                  
  3758                                  @@testReg164:
  3759 0000148C 68[DF16]                 push testReg_12
  3760 0000148F 8D064F75                 lea  ax, [SymbolUpper]
  3761 00001493 50                       push ax
  3762 00001494 E85F0B                   call eqstr
  3763 00001497 83C404                   add  sp, 4
  3764 0000149A 08C0                     or  al, al
  3765 0000149C 0F840900                 je @@testReg165
  3766 000014A0 66B804000000             mov eax, 4
  3767 000014A6 E91102                   jmp @@retn
  3768                                  
  3769                                  ;-90   if (eqstr(SymbolUpper, "BP")) return 5;
  3770                                  
  3771                                  @@testReg165:
  3772 000014A9 68[E216]                 push testReg_13
  3773 000014AC 8D064F75                 lea  ax, [SymbolUpper]
  3774 000014B0 50                       push ax
  3775 000014B1 E8420B                   call eqstr
  3776 000014B4 83C404                   add  sp, 4
  3777 000014B7 08C0                     or  al, al
  3778 000014B9 0F840900                 je @@testReg166
  3779 000014BD 66B805000000             mov eax, 5
  3780 000014C3 E9F401                   jmp @@retn
  3781                                  
  3782                                  ;-91   if (eqstr(SymbolUpper, "SI")) return 6;
  3783                                  
  3784                                  @@testReg166:
  3785 000014C6 68[E516]                 push testReg_14
  3786 000014C9 8D064F75                 lea  ax, [SymbolUpper]
  3787 000014CD 50                       push ax
  3788 000014CE E8250B                   call eqstr
  3789 000014D1 83C404                   add  sp, 4
  3790 000014D4 08C0                     or  al, al
  3791 000014D6 0F840900                 je @@testReg167
  3792 000014DA 66B806000000             mov eax, 6
  3793 000014E0 E9D701                   jmp @@retn
  3794                                  
  3795                                  ;-92   if (eqstr(SymbolUpper, "DI")) return 7;
  3796                                  
  3797                                  @@testReg167:
  3798 000014E3 68[E816]                 push testReg_15
  3799 000014E6 8D064F75                 lea  ax, [SymbolUpper]
  3800 000014EA 50                       push ax
  3801 000014EB E8080B                   call eqstr
  3802 000014EE 83C404                   add  sp, 4
  3803 000014F1 08C0                     or  al, al
  3804 000014F3 0F840900                 je @@testReg168
  3805 000014F7 66B807000000             mov eax, 7
  3806 000014FD E9BA01                   jmp @@retn
  3807                                  
  3808                                  ;-93   RegType=SEGREG;
  3809                                  
  3810                                  @@testReg168:
  3811 00001500 66B804000000             mov eax, 4
  3812 00001506 A2[4200]                 mov byte [RegType], al
  3813                                  
  3814                                  ;-94   if (eqstr(SymbolUpper, "ES")) return 0;
  3815                                  
  3816 00001509 68[EB16]                 push testReg_16
  3817 0000150C 8D064F75                 lea  ax, [SymbolUpper]
  3818 00001510 50                       push ax
  3819 00001511 E8E20A                   call eqstr
  3820 00001514 83C404                   add  sp, 4
  3821 00001517 08C0                     or  al, al
  3822 00001519 0F840900                 je @@testReg169
  3823 0000151D 66B800000000             mov eax, 0
  3824 00001523 E99401                   jmp @@retn
  3825                                  
  3826                                  ;-95   if (eqstr(SymbolUpper, "CS")) return 1;
  3827                                  
  3828                                  @@testReg169:
  3829 00001526 68[EE16]                 push testReg_17
  3830 00001529 8D064F75                 lea  ax, [SymbolUpper]
  3831 0000152D 50                       push ax
  3832 0000152E E8C50A                   call eqstr
  3833 00001531 83C404                   add  sp, 4
  3834 00001534 08C0                     or  al, al
  3835 00001536 0F840900                 je @@testReg170
  3836 0000153A 66B801000000             mov eax, 1
  3837 00001540 E97701                   jmp @@retn
  3838                                  
  3839                                  ;-96   if (eqstr(SymbolUpper, "SS")) return 2;
  3840                                  
  3841                                  @@testReg170:
  3842 00001543 68[F116]                 push testReg_18
  3843 00001546 8D064F75                 lea  ax, [SymbolUpper]
  3844 0000154A 50                       push ax
  3845 0000154B E8A80A                   call eqstr
  3846 0000154E 83C404                   add  sp, 4
  3847 00001551 08C0                     or  al, al
  3848 00001553 0F840900                 je @@testReg171
  3849 00001557 66B802000000             mov eax, 2
  3850 0000155D E95A01                   jmp @@retn
  3851                                  
  3852                                  ;-97   if (eqstr(SymbolUpper, "DS")) return 3;
  3853                                  
  3854                                  @@testReg171:
  3855 00001560 68[F416]                 push testReg_19
  3856 00001563 8D064F75                 lea  ax, [SymbolUpper]
  3857 00001567 50                       push ax
  3858 00001568 E88B0A                   call eqstr
  3859 0000156B 83C404                   add  sp, 4
  3860 0000156E 08C0                     or  al, al
  3861 00001570 0F840900                 je @@testReg172
  3862 00001574 66B803000000             mov eax, 3
  3863 0000157A E93D01                   jmp @@retn
  3864                                  
  3865                                  ;-98   if (eqstr(SymbolUpper, "FS")) return 4;
  3866                                  
  3867                                  @@testReg172:
  3868 0000157D 68[F716]                 push testReg_20
  3869 00001580 8D064F75                 lea  ax, [SymbolUpper]
  3870 00001584 50                       push ax
  3871 00001585 E86E0A                   call eqstr
  3872 00001588 83C404                   add  sp, 4
  3873 0000158B 08C0                     or  al, al
  3874 0000158D 0F840900                 je @@testReg173
  3875 00001591 66B804000000             mov eax, 4
  3876 00001597 E92001                   jmp @@retn
  3877                                  
  3878                                  ;-99   if (eqstr(SymbolUpper, "GS")) return 5;
  3879                                  
  3880                                  @@testReg173:
  3881 0000159A 68[FA16]                 push testReg_21
  3882 0000159D 8D064F75                 lea  ax, [SymbolUpper]
  3883 000015A1 50                       push ax
  3884 000015A2 E8510A                   call eqstr
  3885 000015A5 83C404                   add  sp, 4
  3886 000015A8 08C0                     or  al, al
  3887 000015AA 0F840900                 je @@testReg174
  3888 000015AE 66B805000000             mov eax, 5
  3889 000015B4 E90301                   jmp @@retn
  3890                                  
  3891                                  ;-100   RegType=DWORD;
  3892                                  
  3893                                  @@testReg174:
  3894 000015B7 66B803000000             mov eax, 3
  3895 000015BD A2[4200]                 mov byte [RegType], al
  3896                                  
  3897                                  ;-101   if (eqstr(SymbolUpper, "EAX"))return 0;
  3898                                  
  3899 000015C0 68[FD16]                 push testReg_22
  3900 000015C3 8D064F75                 lea  ax, [SymbolUpper]
  3901 000015C7 50                       push ax
  3902 000015C8 E82B0A                   call eqstr
  3903 000015CB 83C404                   add  sp, 4
  3904 000015CE 08C0                     or  al, al
  3905 000015D0 0F840900                 je @@testReg175
  3906 000015D4 66B800000000             mov eax, 0
  3907 000015DA E9DD00                   jmp @@retn
  3908                                  
  3909                                  ;-102   if (eqstr(SymbolUpper, "ECX"))return 1;
  3910                                  
  3911                                  @@testReg175:
  3912 000015DD 68[0117]                 push testReg_23
  3913 000015E0 8D064F75                 lea  ax, [SymbolUpper]
  3914 000015E4 50                       push ax
  3915 000015E5 E80E0A                   call eqstr
  3916 000015E8 83C404                   add  sp, 4
  3917 000015EB 08C0                     or  al, al
  3918 000015ED 0F840900                 je @@testReg176
  3919 000015F1 66B801000000             mov eax, 1
  3920 000015F7 E9C000                   jmp @@retn
  3921                                  
  3922                                  ;-103   if (eqstr(SymbolUpper, "EDX"))return 2;
  3923                                  
  3924                                  @@testReg176:
  3925 000015FA 68[0517]                 push testReg_24
  3926 000015FD 8D064F75                 lea  ax, [SymbolUpper]
  3927 00001601 50                       push ax
  3928 00001602 E8F109                   call eqstr
  3929 00001605 83C404                   add  sp, 4
  3930 00001608 08C0                     or  al, al
  3931 0000160A 0F840900                 je @@testReg177
  3932 0000160E 66B802000000             mov eax, 2
  3933 00001614 E9A300                   jmp @@retn
  3934                                  
  3935                                  ;-104   if (eqstr(SymbolUpper, "EBX"))return 3;
  3936                                  
  3937                                  @@testReg177:
  3938 00001617 68[0917]                 push testReg_25
  3939 0000161A 8D064F75                 lea  ax, [SymbolUpper]
  3940 0000161E 50                       push ax
  3941 0000161F E8D409                   call eqstr
  3942 00001622 83C404                   add  sp, 4
  3943 00001625 08C0                     or  al, al
  3944 00001627 0F840900                 je @@testReg178
  3945 0000162B 66B803000000             mov eax, 3
  3946 00001631 E98600                   jmp @@retn
  3947                                  
  3948                                  ;-105   if (eqstr(SymbolUpper, "ESP"))return 4;
  3949                                  
  3950                                  @@testReg178:
  3951 00001634 68[0D17]                 push testReg_26
  3952 00001637 8D064F75                 lea  ax, [SymbolUpper]
  3953 0000163B 50                       push ax
  3954 0000163C E8B709                   call eqstr
  3955 0000163F 83C404                   add  sp, 4
  3956 00001642 08C0                     or  al, al
  3957 00001644 0F840900                 je @@testReg179
  3958 00001648 66B804000000             mov eax, 4
  3959 0000164E E96900                   jmp @@retn
  3960                                  
  3961                                  ;-106   if (eqstr(SymbolUpper, "EBP"))return 5;
  3962                                  
  3963                                  @@testReg179:
  3964 00001651 68[1117]                 push testReg_27
  3965 00001654 8D064F75                 lea  ax, [SymbolUpper]
  3966 00001658 50                       push ax
  3967 00001659 E89A09                   call eqstr
  3968 0000165C 83C404                   add  sp, 4
  3969 0000165F 08C0                     or  al, al
  3970 00001661 0F840900                 je @@testReg180
  3971 00001665 66B805000000             mov eax, 5
  3972 0000166B E94C00                   jmp @@retn
  3973                                  
  3974                                  ;-107   if (eqstr(SymbolUpper, "ESI"))return 6;
  3975                                  
  3976                                  @@testReg180:
  3977 0000166E 68[1517]                 push testReg_28
  3978 00001671 8D064F75                 lea  ax, [SymbolUpper]
  3979 00001675 50                       push ax
  3980 00001676 E87D09                   call eqstr
  3981 00001679 83C404                   add  sp, 4
  3982 0000167C 08C0                     or  al, al
  3983 0000167E 0F840900                 je @@testReg181
  3984 00001682 66B806000000             mov eax, 6
  3985 00001688 E92F00                   jmp @@retn
  3986                                  
  3987                                  ;-108   if (eqstr(SymbolUpper, "EDI"))return 7;
  3988                                  
  3989                                  @@testReg181:
  3990 0000168B 68[1917]                 push testReg_29
  3991 0000168E 8D064F75                 lea  ax, [SymbolUpper]
  3992 00001692 50                       push ax
  3993 00001693 E86009                   call eqstr
  3994 00001696 83C404                   add  sp, 4
  3995 00001699 08C0                     or  al, al
  3996 0000169B 0F840900                 je @@testReg182
  3997 0000169F 66B807000000             mov eax, 7
  3998 000016A5 E91200                   jmp @@retn
  3999                                  
  4000                                  ;-109   RegType=0; return 0;
  4001                                  
  4002                                  @@testReg182:
  4003 000016A8 66B800000000             mov eax, 0
  4004 000016AE A2[4200]                 mov byte [RegType], al
  4005 000016B1 66B800000000             mov eax, 0
  4006 000016B7 E90000                   jmp @@retn
  4007                                  
  4008                                  ;-110 }
  4009                                  
  4010                                  @@retn:
  4011 000016BA C3                       ret
  4012                                  ; ENDP
  4013 000016BB 414C00                  testReg_0 db "AL",0
  4014 000016BE 434C00                  testReg_1 db "CL",0
  4015 000016C1 444C00                  testReg_2 db "DL",0
  4016 000016C4 424C00                  testReg_3 db "BL",0
  4017 000016C7 414800                  testReg_4 db "AH",0
  4018 000016CA 434800                  testReg_5 db "CH",0
  4019 000016CD 444800                  testReg_6 db "DH",0
  4020 000016D0 424800                  testReg_7 db "BH",0
  4021 000016D3 415800                  testReg_8 db "AX",0
  4022 000016D6 435800                  testReg_9 db "CX",0
  4023 000016D9 445800                  testReg_10 db "DX",0
  4024 000016DC 425800                  testReg_11 db "BX",0
  4025 000016DF 535000                  testReg_12 db "SP",0
  4026 000016E2 425000                  testReg_13 db "BP",0
  4027 000016E5 534900                  testReg_14 db "SI",0
  4028 000016E8 444900                  testReg_15 db "DI",0
  4029 000016EB 455300                  testReg_16 db "ES",0
  4030 000016EE 435300                  testReg_17 db "CS",0
  4031 000016F1 535300                  testReg_18 db "SS",0
  4032 000016F4 445300                  testReg_19 db "DS",0
  4033 000016F7 465300                  testReg_20 db "FS",0
  4034 000016FA 475300                  testReg_21 db "GS",0
  4035 000016FD 45415800                testReg_22 db "EAX",0
  4036 00001701 45435800                testReg_23 db "ECX",0
  4037 00001705 45445800                testReg_24 db "EDX",0
  4038 00001709 45425800                testReg_25 db "EBX",0
  4039 0000170D 45535000                testReg_26 db "ESP",0
  4040 00001711 45425000                testReg_27 db "EBP",0
  4041 00001715 45534900                testReg_28 db "ESI",0
  4042 00001719 45444900                testReg_29 db "EDI",0
  4043                                  ;Back to main program: AS.C
  4044                                  
  4045                                  ;-220 #include "OUTPUT.C"
  4046                                  
  4047                                  ;Use include file: OUTPUT.C
  4048                                  
  4049                                  ;-1 int printLine() { int i; char c;
  4050                                  
  4051                                  
  4052                                  printLine:  ; *** PROC ***
  4053                                  
  4054                                  ;-2   prs("\n"); printhex16(PCStart);
  4055                                  
  4056                                  ;Function : printLine, Number of local variables: 2
  4057                                  ;   # type sign width line used address name   list of local variables
  4058                                  ;  200 var sign word     1 NULL bp-2    i
  4059                                  ;  201 var sign byte     1 NULL bp-4    c;
  4060 0000171D C8040000                 ENTER  4,0
  4061 00001721 68[B217]                 push printLine_0
  4062 00001724 E80401                   call prs
  4063 00001727 83C402                   add  sp, 2
  4064 0000172A FF36[3900]               push word [PCStart]
  4065 0000172E E8EB01                   call printhex16
  4066 00001731 83C402                   add  sp, 2
  4067                                  
  4068                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  4069                                  
  4070 00001734 A1[4C00]                 mov ax, [OpPrintIndex]
  4071 00001737 83F800                   cmp ax, 0
  4072 0000173A 0F850C00                 jne @@printLine183
  4073 0000173E 68[B517]                 push printLine_1
  4074 00001741 E8E700                   call prs
  4075 00001744 83C402                   add  sp, 2
  4076                                  
  4077                                  ;-4   else {
  4078                                  
  4079 00001747 E95B00                   jmp @@printLine184
  4080                                  @@printLine183:
  4081                                  
  4082                                  ;-5     prc(PrintR);
  4083                                  
  4084 0000174A A0[5000]                 mov al, byte [PrintR]
  4085 0000174D B400                     mov ah, 0
  4086 0000174F 50                       push ax
  4087 00001750 E87700                   call prc
  4088 00001753 83C402                   add  sp, 2
  4089                                  
  4090                                  ;-6     i=0;
  4091                                  
  4092 00001756 66B800000000             mov eax, 0
  4093 0000175C 8946FE                   mov word [bp-2], ax
  4094                                  
  4095                                  ;-7     do {
  4096                                  
  4097                                  @@printLine185:
  4098                                  
  4099                                  ;-8       c=OpPos[i];
  4100                                  
  4101 0000175F 8B5EFE                   mov bx, [bp-2]
  4102 00001762 8A87B676                 mov al, [OpPos + bx]
  4103 00001766 8846FC                   mov byte [bp-4], al
  4104                                  
  4105                                  ;-9       printhex8a(c); prc(' ');
  4106                                  
  4107 00001769 8A46FC                   mov al, byte [bp-4]
  4108 0000176C B400                     mov ah, 0
  4109 0000176E 50                       push ax
  4110 0000176F E85C01                   call printhex8a
  4111 00001772 83C402                   add  sp, 2
  4112 00001775 6A20                     push 32
  4113 00001777 E85000                   call prc
  4114 0000177A 83C402                   add  sp, 2
  4115                                  
  4116                                  ;-10       i++;
  4117                                  
  4118 0000177D FF46FE                   inc  word [bp-2]
  4119                                  
  4120                                  ;-11     } while(i < OpPrintIndex);
  4121                                  
  4122 00001780 8B46FE                   mov ax, [bp-2]
  4123 00001783 3B06[4C00]               cmp ax, [OpPrintIndex]
  4124 00001787 0F8D0200                 jge @@printLine186
  4125 0000178B EBD2                     jmp @@printLine185
  4126                                  @@printLine186:
  4127                                  
  4128                                  ;-12     do {// fill rest with blank
  4129                                  
  4130                                  @@printLine187:
  4131                                  
  4132                                  ;-13       prs("   ");
  4133                                  
  4134 0000178D 68[C617]                 push printLine_2
  4135 00001790 E89800                   call prs
  4136 00001793 83C402                   add  sp, 2
  4137                                  
  4138                                  ;-14       i++;
  4139                                  
  4140 00001796 FF46FE                   inc  word [bp-2]
  4141                                  
  4142                                  ;-15     } while(i < OPMAXLEN);
  4143                                  
  4144 00001799 8B46FE                   mov ax, [bp-2]
  4145 0000179C 83F805                   cmp ax, 5
  4146 0000179F 0F8D0200                 jge @@printLine188
  4147 000017A3 EBE8                     jmp @@printLine187
  4148                                  @@printLine188:
  4149                                  
  4150                                  ;-16   }
  4151                                  
  4152                                  
  4153                                  ;-17   prscomment(InputBuf);
  4154                                  
  4155                                  @@printLine184:
  4156 000017A5 8D066E75                 lea  ax, [InputBuf]
  4157 000017A9 50                       push ax
  4158 000017AA E85000                   call prscomment
  4159 000017AD 83C402                   add  sp, 2
  4160                                  
  4161                                  ;-18 }
  4162                                  
  4163                                  
  4164                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  4165 000017B0 C9                       LEAVE
  4166 000017B1 C3                       ret
  4167                                  ; ENDP
  4168 000017B2 5C6E00                  printLine_0 db "\n",0
  4169 000017B5 202020202020202020-     printLine_1 db "                ",0
  4170 000017BE 2020202020202000   
  4171 000017C6 20202000                printLine_2 db "   ",0
  4172                                  
  4173                                  prc:  ; *** PROC ***
  4174                                  ;Function : prc, Number of local variables: 1
  4175                                  ;   # type sign width line used address name   list of local variables
  4176                                  ;  200 var unsg byte    19 NULL bp+4    c;
  4177 000017CA C8000000                 ENTER  0,0
  4178 000017CE A0[2500]                 mov al, [LIST]
  4179 000017D1 08C0                     or  al, al
  4180 000017D3 0F841400                 je @@prc189
  4181 000017D7 807E040A                cmp byte [bp+4], 10
  4182 000017DB 0F850600                 jne @@prc190
  4183 000017DF B80D00                   mov  ax, 13
  4184 000017E2 E80107                   call writetty
  4185                                  
  4186                                  ;-20      al=c; writetty(); }
  4187                                  
  4188                                  @@prc190:
  4189 000017E5 8A4604                   mov  al, [bp+4]
  4190 000017E8 E8FB06                   call writetty
  4191                                  
  4192                                  ;-21    fputcR(c,lst_fd); }
  4193                                  
  4194                                  @@prc189:
  4195 000017EB FF36[2C00]               push word [lst_fd]
  4196 000017EF 8A4604                   mov al, byte [bp+4]
  4197 000017F2 B400                     mov ah, 0
  4198 000017F4 50                       push ax
  4199 000017F5 E8AE08                   call fputcR
  4200 000017F8 83C404                   add  sp, 4
  4201                                  
  4202                                  ;-22 
  4203                                  
  4204                                  
  4205                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  4206 000017FB C9                       LEAVE
  4207 000017FC C3                       ret
  4208                                  ; ENDP
  4209                                  
  4210                                  prscomment:  ; *** PROC ***
  4211                                  
  4212                                  ;-24   while(*s){c=*s;prc(c);s++;}
  4213                                  
  4214                                  ;Function : prscomment, Number of local variables: 2
  4215                                  ;   # type sign width line used address name   list of local variables
  4216                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  4217                                  ;  201 var unsg byte    23 NULL bp-2    c;
  4218 000017FD C8020000                 ENTER  2,0
  4219                                  @@prscomment191:
  4220 00001801 8B5E04                   mov bx, [bp+4]
  4221 00001804 8A07                     mov al, [bx]
  4222 00001806 B400                     mov ah, 0
  4223 00001808 08C0                     or  al, al
  4224 0000180A 0F841B00                 je @@prscomment192
  4225 0000180E 8B5E04                   mov bx, [bp+4]
  4226 00001811 8A07                     mov al, [bx]
  4227 00001813 B400                     mov ah, 0
  4228 00001815 8846FE                   mov byte [bp-2], al
  4229 00001818 8A46FE                   mov al, byte [bp-2]
  4230 0000181B B400                     mov ah, 0
  4231 0000181D 50                       push ax
  4232 0000181E E8A9FF                   call prc
  4233 00001821 83C402                   add  sp, 2
  4234 00001824 FF4604                   inc  word [bp+4]
  4235                                  
  4236                                  ;-25 }
  4237                                  
  4238 00001827 EBD8                     jmp @@prscomment191
  4239                                  @@prscomment192:
  4240                                  
  4241                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  4242 00001829 C9                       LEAVE
  4243 0000182A C3                       ret
  4244                                  ; ENDP
  4245                                  
  4246                                  prs:  ; *** PROC ***
  4247                                  ;Function : prs, Number of local variables: 3
  4248                                  ;   # type sign width line used address name   list of local variables
  4249                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  4250                                  ;  201 var unsg byte    26 NULL bp-2    c
  4251                                  ;  202 var sign word    26 NULL bp-4    com;
  4252 0000182B C8040000                 ENTER  4,0
  4253 0000182F 66B800000000             mov eax, 0
  4254 00001835 8946FC                   mov word [bp-4], ax
  4255                                  
  4256                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  4257                                  
  4258                                  @@prs193:
  4259 00001838 8B5E04                   mov bx, [bp+4]
  4260 0000183B 8A07                     mov al, [bx]
  4261 0000183D B400                     mov ah, 0
  4262 0000183F 08C0                     or  al, al
  4263 00001841 0F848700                 je @@prs194
  4264 00001845 8B5E04                   mov bx, [bp+4]
  4265 00001848 8A07                     mov al, [bx]
  4266 0000184A B400                     mov ah, 0
  4267 0000184C 8846FE                   mov byte [bp-2], al
  4268 0000184F 8A46FE                   mov al, [bp-2]
  4269 00001852 3C22                     cmp al, 34
  4270 00001854 0F851E00                 jne @@prs195
  4271 00001858 8B46FC                   mov ax, [bp-4]
  4272 0000185B 08C0                     or  al, al
  4273 0000185D 0F840C00                 je @@prs196
  4274 00001861 66B800000000             mov eax, 0
  4275 00001867 8946FC                   mov word [bp-4], ax
  4276 0000186A E90900                   jmp @@prs197
  4277                                  @@prs196:
  4278 0000186D 66B801000000             mov eax, 1
  4279 00001873 8946FC                   mov word [bp-4], ax
  4280                                  
  4281                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  4282                                  
  4283                                  @@prs197:
  4284                                  @@prs195:
  4285 00001876 8A46FE                   mov al, [bp-2]
  4286 00001879 3C5C                     cmp al, 92
  4287 0000187B 0F853B00                 jne @@prs198
  4288 0000187F 8B46FC                   mov ax, [bp-4]
  4289 00001882 83F800                   cmp ax, 0
  4290 00001885 0F853100                 jne @@prs199
  4291 00001889 FF4604                   inc  word [bp+4]
  4292 0000188C 8B5E04                   mov bx, [bp+4]
  4293 0000188F 8A07                     mov al, [bx]
  4294 00001891 B400                     mov ah, 0
  4295 00001893 8846FE                   mov byte [bp-2], al
  4296                                  
  4297                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  4298                                  
  4299 00001896 8A46FE                   mov al, [bp-2]
  4300 00001899 3C6E                     cmp al, 110
  4301 0000189B 0F850900                 jne @@prs200
  4302 0000189F 66B80A000000             mov eax, 10
  4303 000018A5 8846FE                   mov byte [bp-2], al
  4304                                  @@prs200:
  4305 000018A8 8A46FE                   mov al, [bp-2]
  4306 000018AB 3C74                     cmp al, 116
  4307 000018AD 0F850900                 jne @@prs201
  4308 000018B1 66B809000000             mov eax, 9
  4309 000018B7 8846FE                   mov byte [bp-2], al
  4310                                  @@prs201:
  4311                                  @@prs199:
  4312                                  @@prs198:
  4313 000018BA 8A46FE                   mov al, byte [bp-2]
  4314 000018BD B400                     mov ah, 0
  4315 000018BF 50                       push ax
  4316 000018C0 E807FF                   call prc
  4317 000018C3 83C402                   add  sp, 2
  4318 000018C6 FF4604                   inc  word [bp+4]
  4319                                  
  4320                                  ;-30 }
  4321                                  
  4322 000018C9 E96CFF                   jmp @@prs193
  4323                                  @@prs194:
  4324                                  
  4325                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  4326 000018CC C9                       LEAVE
  4327 000018CD C3                       ret
  4328                                  ; ENDP
  4329                                  
  4330                                  printhex8a:  ; *** PROC ***
  4331                                  
  4332                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4333                                  
  4334                                  ;Function : printhex8a, Number of local variables: 2
  4335                                  ;   # type sign width line used address name   list of local variables
  4336                                  ;  200 var unsg word    31 NULL bp+4    c
  4337                                  ;  201 var unsg word    31 NULL bp-2    nib;
  4338 000018CE C8020000                 ENTER  2,0
  4339 000018D2 8B4604                   mov ax, [bp+4]
  4340 000018D5 C1E804                   shr ax, 4
  4341 000018D8 8946FE                   mov word [bp-2], ax
  4342 000018DB 8346FE30                 add  word [bp-2], 48
  4343 000018DF 8B46FE                   mov ax, [bp-2]
  4344 000018E2 83F839                   cmp ax, 57
  4345 000018E5 0F8E0400                 jle @@printhex8a202
  4346 000018E9 8346FE07                 add  word [bp-2], 7
  4347                                  @@printhex8a202:
  4348 000018ED FF76FE                   push word [bp-2]
  4349 000018F0 E8D7FE                   call prc
  4350 000018F3 83C402                   add  sp, 2
  4351                                  
  4352                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  4353                                  
  4354 000018F6 8B4604                   mov ax, [bp+4]
  4355 000018F9 83E00F                   and ax, 15
  4356 000018FC 8946FE                   mov word [bp-2], ax
  4357 000018FF 8346FE30                 add  word [bp-2], 48
  4358 00001903 8B46FE                   mov ax, [bp-2]
  4359 00001906 83F839                   cmp ax, 57
  4360 00001909 0F8E0400                 jle @@printhex8a203
  4361 0000190D 8346FE07                 add  word [bp-2], 7
  4362                                  @@printhex8a203:
  4363 00001911 FF76FE                   push word [bp-2]
  4364 00001914 E8B3FE                   call prc
  4365 00001917 83C402                   add  sp, 2
  4366                                  
  4367                                  ;-34 }
  4368                                  
  4369                                  
  4370                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  4371 0000191A C9                       LEAVE
  4372 0000191B C3                       ret
  4373                                  ; ENDP
  4374                                  
  4375                                  printhex16:  ; *** PROC ***
  4376                                  
  4377                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  4378                                  
  4379                                  ;Function : printhex16, Number of local variables: 2
  4380                                  ;   # type sign width line used address name   list of local variables
  4381                                  ;  200 var unsg word    35 NULL bp+4    i
  4382                                  ;  201 var unsg word    35 NULL bp-2    half;
  4383 0000191C C8020000                 ENTER  2,0
  4384 00001920 8B4604                   mov ax, [bp+4]
  4385 00001923 C1E808                   shr ax, 8
  4386 00001926 8946FE                   mov word [bp-2], ax
  4387 00001929 FF76FE                   push word [bp-2]
  4388 0000192C E89FFF                   call printhex8a
  4389 0000192F 83C402                   add  sp, 2
  4390 00001932 8B4604                   mov ax, [bp+4]
  4391 00001935 25FF00                   and ax, 255
  4392 00001938 8946FE                   mov word [bp-2], ax
  4393 0000193B FF76FE                   push word [bp-2]
  4394 0000193E E88DFF                   call printhex8a
  4395 00001941 83C402                   add  sp, 2
  4396                                  
  4397                                  ;-37 }
  4398                                  
  4399                                  
  4400                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  4401 00001944 C9                       LEAVE
  4402 00001945 C3                       ret
  4403                                  ; ENDP
  4404                                  
  4405                                  printIntU:  ; *** PROC ***
  4406                                  
  4407                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  4408                                  
  4409                                  ;Function : printIntU, Number of local variables: 2
  4410                                  ;   # type sign width line used address name   list of local variables
  4411                                  ;  200 var unsg word    38 NULL bp+4    n
  4412                                  ;  201 var unsg word    38 NULL bp-2    e;
  4413 00001946 C8020000                 ENTER  2,0
  4414 0000194A 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4415 0000194E 0F821700                 jb  @@printIntU204
  4416 00001952 8B4604                   mov ax, [bp+4]
  4417 00001955 BB0A00                   mov bx, 10
  4418 00001958 BA0000                   mov dx, 0
  4419 0000195B F7F3                     div bx
  4420 0000195D 8946FE                   mov word [bp-2], ax
  4421                                  
  4422                                  ;-40     printIntU(e); }
  4423                                  
  4424 00001960 FF76FE                   push word [bp-2]
  4425 00001963 E8E0FF                   call printIntU
  4426 00001966 83C402                   add  sp, 2
  4427                                  
  4428                                  ;-41     n = n % 10; //unsigned mod
  4429                                  
  4430                                  @@printIntU204:
  4431 00001969 8B4604                   mov ax, [bp+4]
  4432 0000196C BB0A00                   mov bx, 10
  4433 0000196F BA0000                   mov dx, 0
  4434 00001972 F7F3                     div bx
  4435 00001974 89D0                     mov ax, dx
  4436 00001976 894604                   mov word [bp+4], ax
  4437                                  
  4438                                  ;-42     n += '0'; prc(n);
  4439                                  
  4440 00001979 83460430                 add  word [bp+4], 48
  4441 0000197D FF7604                   push word [bp+4]
  4442 00001980 E847FE                   call prc
  4443 00001983 83C402                   add  sp, 2
  4444                                  
  4445                                  ;-43 }
  4446                                  
  4447                                  
  4448                                  ;-44 
  4449                                  
  4450                                  
  4451                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  4452 00001986 C9                       LEAVE
  4453 00001987 C3                       ret
  4454                                  ; ENDP
  4455                                  
  4456                                  error1:  ; *** PROC ***
  4457                                  ;Function : error1, Number of local variables: 1
  4458                                  ;   # type sign width line used address name   list of local variables
  4459                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  4460 00001988 C8000000                 ENTER  0,0
  4461 0000198C 66B801000000             mov eax, 1
  4462 00001992 A2[2500]                 mov byte [LIST], al
  4463 00001995 FF06[3200]               inc  word [ErrorCount]
  4464                                  
  4465                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  4466                                  
  4467 00001999 68[C119]                 push error1_0
  4468 0000199C E88CFE                   call prs
  4469 0000199F 83C402                   add  sp, 2
  4470 000019A2 FF7604                   push word [bp+4]
  4471 000019A5 E883FE                   call prs
  4472 000019A8 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  4475                                  
  4476 000019AB 68[DC19]                 push error1_1
  4477 000019AE E87AFE                   call prs
  4478 000019B1 83C402                   add  sp, 2
  4479 000019B4 8D063075                 lea  ax, [Symbol]
  4480 000019B8 50                       push ax
  4481 000019B9 E86FFE                   call prs
  4482 000019BC 83C402                   add  sp, 2
  4483                                  
  4484                                  ;-48 int allowederror(){error1("not allowed here"); }
  4485 000019BF C9                       LEAVE
  4486 000019C0 C3                       ret
  4487                                  ; ENDP
  4488 000019C1 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4489 000019CA 6E657874206C696E65-
  4490 000019D3 204552524F523A2000 
  4491 000019DC 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4492 000019E5 2000               
  4493                                  
  4494                                  allowederror:  ; *** PROC ***
  4495 000019E7 68[F119]                 push allowederror_0
  4496 000019EA E89BFF                   call error1
  4497 000019ED 83C402                   add  sp, 2
  4498                                  
  4499                                  ;-49 int implerror()  {error1("not implemented");}
  4500                                  
  4501 000019F0 C3                       ret
  4502                                  ; ENDP
  4503 000019F1 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4504 000019FA 6564206865726500   
  4505                                  
  4506                                  implerror:  ; *** PROC ***
  4507 00001A02 68[0C1A]                 push implerror_0
  4508 00001A05 E880FF                   call error1
  4509 00001A08 83C402                   add  sp, 2
  4510                                  
  4511                                  ;-50 int indexerror (){error1("invalid index register");}
  4512                                  
  4513 00001A0B C3                       ret
  4514                                  ; ENDP
  4515 00001A0C 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4516 00001A15 6D656E74656400     
  4517                                  
  4518                                  indexerror:  ; *** PROC ***
  4519 00001A1C 68[261A]                 push indexerror_0
  4520 00001A1F E866FF                   call error1
  4521 00001A22 83C402                   add  sp, 2
  4522                                  
  4523                                  ;-51 int invaloperror (){error1("invalid operands");}
  4524                                  
  4525 00001A25 C3                       ret
  4526                                  ; ENDP
  4527 00001A26 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4528 00001A2F 6E6465782072656769-
  4529 00001A38 7374657200         
  4530                                  
  4531                                  invaloperror:  ; *** PROC ***
  4532 00001A3D 68[471A]                 push invaloperror_0
  4533 00001A40 E845FF                   call error1
  4534 00001A43 83C402                   add  sp, 2
  4535                                  
  4536                                  ;-52 int numbererror(){error1("number expected");}
  4537                                  
  4538 00001A46 C3                       ret
  4539                                  ; ENDP
  4540 00001A47 696E76616C6964206F-     invaloperror_0 db "invalid operands",0
  4541 00001A50 706572616E647300   
  4542                                  
  4543                                  numbererror:  ; *** PROC ***
  4544 00001A58 68[621A]                 push numbererror_0
  4545 00001A5B E82AFF                   call error1
  4546 00001A5E 83C402                   add  sp, 2
  4547                                  
  4548                                  ;-53 int regmemerror(){error1("only register or memory allowed");}
  4549                                  
  4550 00001A61 C3                       ret
  4551                                  ; ENDP
  4552 00001A62 6E756D626572206578-     numbererror_0 db "number expected",0
  4553 00001A6B 70656374656400     
  4554                                  
  4555                                  regmemerror:  ; *** PROC ***
  4556 00001A72 68[7C1A]                 push regmemerror_0
  4557 00001A75 E810FF                   call error1
  4558 00001A78 83C402                   add  sp, 2
  4559                                  
  4560                                  ;-54 int segregerror(){error1("segment register not allowed");}
  4561                                  
  4562 00001A7B C3                       ret
  4563                                  ; ENDP
  4564 00001A7C 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4565 00001A85 73746572206F72206D-
  4566 00001A8E 656D6F727920616C6C-
  4567 00001A97 6F77656400         
  4568                                  
  4569                                  segregerror:  ; *** PROC ***
  4570 00001A9C 68[A61A]                 push segregerror_0
  4571 00001A9F E8E6FE                   call error1
  4572 00001AA2 83C402                   add  sp, 2
  4573                                  
  4574                                  ;-55 int syntaxerror(){error1("syntax");}
  4575                                  
  4576 00001AA5 C3                       ret
  4577                                  ; ENDP
  4578 00001AA6 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4579 00001AAF 65676973746572206E-
  4580 00001AB8 6F7420616C6C6F7765-
  4581 00001AC1 6400               
  4582                                  
  4583                                  syntaxerror:  ; *** PROC ***
  4584 00001AC3 68[CD1A]                 push syntaxerror_0
  4585 00001AC6 E8BFFE                   call error1
  4586 00001AC9 83C402                   add  sp, 2
  4587                                  
  4588                                  ;-56 
  4589                                  
  4590                                  
  4591                                  ;-57 int errorexit(char *s) { error1(s); end1(1);}
  4592                                  
  4593 00001ACC C3                       ret
  4594                                  ; ENDP
  4595 00001ACD 73796E74617800          syntaxerror_0 db "syntax",0
  4596                                  
  4597                                  errorexit:  ; *** PROC ***
  4598                                  ;Function : errorexit, Number of local variables: 1
  4599                                  ;   # type sign width line used address name   list of local variables
  4600                                  ;  200 ptr sign byte    57 NULL bp+4    s;
  4601 00001AD4 C8000000                 ENTER  0,0
  4602 00001AD8 FF7604                   push word [bp+4]
  4603 00001ADB E8AAFE                   call error1
  4604 00001ADE 83C402                   add  sp, 2
  4605 00001AE1 6A01                     push 1
  4606 00001AE3 E8D303                   call end1
  4607 00001AE6 83C402                   add  sp, 2
  4608                                  
  4609                                  ;-58 int addrexit(){errorexit("illegal address");}
  4610 00001AE9 C9                       LEAVE
  4611 00001AEA C3                       ret
  4612                                  ; ENDP
  4613                                  
  4614                                  addrexit:  ; *** PROC ***
  4615 00001AEB 68[F51A]                 push addrexit_0
  4616 00001AEE E8E3FF                   call errorexit
  4617 00001AF1 83C402                   add  sp, 2
  4618                                  
  4619                                  ;-59 int internexit(){errorexit("intern compiler error");}
  4620                                  
  4621 00001AF4 C3                       ret
  4622                                  ; ENDP
  4623 00001AF5 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4624 00001AFE 64647265737300     
  4625                                  
  4626                                  internexit:  ; *** PROC ***
  4627 00001B05 68[0F1B]                 push internexit_0
  4628 00001B08 E8C9FF                   call errorexit
  4629 00001B0B 83C402                   add  sp, 2
  4630 00001B0E C3                       ret
  4631                                  ; ENDP
  4632 00001B0F 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4633 00001B18 6D70696C6572206572-
  4634 00001B21 726F7200           
  4635                                  ;Back to main program: AS.C
  4636                                  
  4637                                  ;-221 #include "MAIN.C"
  4638                                  
  4639                                  ;Use include file: MAIN.C
  4640                                  
  4641                                  ;-1 int getarg() { int arglen1; int i; char *c;
  4642                                  
  4643                                  
  4644                                  getarg:  ; *** PROC ***
  4645                                  
  4646                                  ;-2   arglen1=*arglen;
  4647                                  
  4648                                  ;Function : getarg, Number of local variables: 3
  4649                                  ;   # type sign width line used address name   list of local variables
  4650                                  ;  200 var sign word     1 NULL bp-2    arglen1
  4651                                  ;  201 var sign word     1 NULL bp-4    i
  4652                                  ;  202 ptr sign byte     1 NULL bp-6    c;
  4653 00001B25 C8060000                 ENTER  6,0
  4654 00001B29 8B1E[5900]               mov bx, [arglen]
  4655 00001B2D 8A07                     mov al, [bx]
  4656 00001B2F B400                     mov ah, 0
  4657 00001B31 8946FE                   mov word [bp-2], ax
  4658                                  
  4659                                  ;-3   if (arglen1==0) {
  4660                                  
  4661 00001B34 8B46FE                   mov ax, [bp-2]
  4662 00001B37 83F800                   cmp ax, 0
  4663 00001B3A 0F851C00                 jne @@getarg205
  4664                                  
  4665                                  ;-4     cputs(Version1);
  4666                                  
  4667 00001B3E 8D06[1000]               lea  ax, [Version1]
  4668 00001B42 50                       push ax
  4669 00001B43 E8A803                   call cputs
  4670 00001B46 83C402                   add  sp, 2
  4671                                  
  4672                                  ;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");
  4673                                  
  4674 00001B49 68[EA1C]                 push getarg_0
  4675 00001B4C E89F03                   call cputs
  4676 00001B4F 83C402                   add  sp, 2
  4677                                  
  4678                                  ;-6     exitR(3);
  4679                                  
  4680 00001B52 6A03                     push 3
  4681 00001B54 E87205                   call exitR
  4682 00001B57 83C402                   add  sp, 2
  4683                                  
  4684                                  ;-7   }
  4685                                  
  4686                                  
  4687                                  ;-8   i=arglen1+129; *i=0;  arglen1--;
  4688                                  
  4689                                  @@getarg205:
  4690 00001B5A 8B46FE                   mov ax, [bp-2]
  4691 00001B5D 058100                   add ax, 129
  4692 00001B60 8946FC                   mov word [bp-4], ax
  4693 00001B63 66B800000000             mov eax, 0
  4694 00001B69 8B5EFC                   mov  bx, [bp-4]
  4695 00001B6C 8907                     mov  [bx], ax
  4696 00001B6E FF4EFE                   dec  word [bp-2]
  4697                                  
  4698                                  ;-9   toupper(argv);
  4699                                  
  4700 00001B71 FF36[5B00]               push word [argv]
  4701 00001B75 E8A403                   call toupper
  4702 00001B78 83C402                   add  sp, 2
  4703                                  
  4704                                  ;-10   strcpy(namein, argv); strcat1(namein, ".S");
  4705                                  
  4706 00001B7B FF36[5B00]               push word [argv]
  4707 00001B7F 8D06ED75                 lea  ax, [namein]
  4708 00001B83 50                       push ax
  4709 00001B84 E80304                   call strcpy
  4710 00001B87 83C404                   add  sp, 4
  4711 00001B8A 68[0F1D]                 push getarg_1
  4712 00001B8D 8D06ED75                 lea  ax, [namein]
  4713 00001B91 50                       push ax
  4714 00001B92 E8B604                   call strcat1
  4715 00001B95 83C404                   add  sp, 4
  4716                                  
  4717                                  ;-11   strcpy(namelst,argv); strcat1(namelst,".LST");
  4718                                  
  4719 00001B98 FF36[5B00]               push word [argv]
  4720 00001B9C 8D063076                 lea  ax, [namelst]
  4721 00001BA0 50                       push ax
  4722 00001BA1 E8E603                   call strcpy
  4723 00001BA4 83C404                   add  sp, 4
  4724 00001BA7 68[121D]                 push getarg_2
  4725 00001BAA 8D063076                 lea  ax, [namelst]
  4726 00001BAE 50                       push ax
  4727 00001BAF E89904                   call strcat1
  4728 00001BB2 83C404                   add  sp, 4
  4729                                  
  4730                                  ;-12   strcpy(namebin,argv); strcat1(namebin,".COM");
  4731                                  
  4732 00001BB5 FF36[5B00]               push word [argv]
  4733 00001BB9 8D067376                 lea  ax, [namebin]
  4734 00001BBD 50                       push ax
  4735 00001BBE E8C903                   call strcpy
  4736 00001BC1 83C404                   add  sp, 4
  4737 00001BC4 68[171D]                 push getarg_3
  4738 00001BC7 8D067376                 lea  ax, [namebin]
  4739 00001BCB 50                       push ax
  4740 00001BCC E87C04                   call strcat1
  4741 00001BCF 83C404                   add  sp, 4
  4742                                  
  4743                                  ;-13 
  4744                                  
  4745                                  
  4746                                  ;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4747                                  
  4748 00001BD2 66B801000000             mov eax, 1
  4749 00001BD8 A2[2500]                 mov byte [LIST], al
  4750 00001BDB 66B800000000             mov eax, 0
  4751 00001BE1 A3[3000]                 mov word [DOS_ERR], ax
  4752 00001BE4 66B800000000             mov eax, 0
  4753 00001BEA A3[3700]                 mov word [PC], ax
  4754 00001BED 66B800000000             mov eax, 0
  4755 00001BF3 A3[3200]                 mov word [ErrorCount], ax
  4756                                  
  4757                                  ;-15   asm_fd=openR (namein);
  4758                                  
  4759 00001BF6 8D06ED75                 lea  ax, [namein]
  4760 00001BFA 50                       push ax
  4761 00001BFB E87204                   call openR
  4762 00001BFE 83C402                   add  sp, 2
  4763 00001C01 A3[2A00]                 mov word [asm_fd], ax
  4764                                  
  4765                                  ;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  4766                                  
  4767 00001C04 A1[3000]                 mov ax, [DOS_ERR]
  4768 00001C07 08C0                     or  al, al
  4769 00001C09 0F841C00                 je @@getarg206
  4770 00001C0D 68[1C1D]                 push getarg_4
  4771 00001C10 E8DB02                   call cputs
  4772 00001C13 83C402                   add  sp, 2
  4773 00001C16 8D06ED75                 lea  ax, [namein]
  4774 00001C1A 50                       push ax
  4775 00001C1B E8D002                   call cputs
  4776 00001C1E 83C402                   add  sp, 2
  4777 00001C21 6A01                     push 1
  4778 00001C23 E8A304                   call exitR
  4779 00001C26 83C402                   add  sp, 2
  4780                                  
  4781                                  ;-17   lst_fd=creatR(namelst);
  4782                                  
  4783                                  @@getarg206:
  4784 00001C29 8D063076                 lea  ax, [namelst]
  4785 00001C2D 50                       push ax
  4786 00001C2E E84E04                   call creatR
  4787 00001C31 83C402                   add  sp, 2
  4788 00001C34 A3[2C00]                 mov word [lst_fd], ax
  4789                                  
  4790                                  ;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4791                                  
  4792 00001C37 A1[3000]                 mov ax, [DOS_ERR]
  4793 00001C3A 08C0                     or  al, al
  4794 00001C3C 0F841C00                 je @@getarg207
  4795 00001C40 68[321D]                 push getarg_5
  4796 00001C43 E8A802                   call cputs
  4797 00001C46 83C402                   add  sp, 2
  4798 00001C49 8D063076                 lea  ax, [namelst]
  4799 00001C4D 50                       push ax
  4800 00001C4E E89D02                   call cputs
  4801 00001C51 83C402                   add  sp, 2
  4802 00001C54 6A02                     push 2
  4803 00001C56 E87004                   call exitR
  4804 00001C59 83C402                   add  sp, 2
  4805                                  
  4806                                  ;-19   bin_fd=creatR(namebin);
  4807                                  
  4808                                  @@getarg207:
  4809 00001C5C 8D067376                 lea  ax, [namebin]
  4810 00001C60 50                       push ax
  4811 00001C61 E81B04                   call creatR
  4812 00001C64 83C402                   add  sp, 2
  4813 00001C67 A3[2E00]                 mov word [bin_fd], ax
  4814                                  
  4815                                  ;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  4816                                  
  4817 00001C6A A1[3000]                 mov ax, [DOS_ERR]
  4818 00001C6D 08C0                     or  al, al
  4819 00001C6F 0F841C00                 je @@getarg208
  4820 00001C73 68[491D]                 push getarg_6
  4821 00001C76 E87502                   call cputs
  4822 00001C79 83C402                   add  sp, 2
  4823 00001C7C 8D067376                 lea  ax, [namebin]
  4824 00001C80 50                       push ax
  4825 00001C81 E86A02                   call cputs
  4826 00001C84 83C402                   add  sp, 2
  4827 00001C87 6A02                     push 2
  4828 00001C89 E83D04                   call exitR
  4829 00001C8C 83C402                   add  sp, 2
  4830                                  
  4831                                  ;-21   prs(";");prs(Version1);
  4832                                  
  4833                                  @@getarg208:
  4834 00001C8F 68[5F1D]                 push getarg_7
  4835 00001C92 E896FB                   call prs
  4836 00001C95 83C402                   add  sp, 2
  4837 00001C98 8D06[1000]               lea  ax, [Version1]
  4838 00001C9C 50                       push ax
  4839 00001C9D E88BFB                   call prs
  4840 00001CA0 83C402                   add  sp, 2
  4841                                  
  4842                                  ;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  4843                                  
  4844 00001CA3 68[611D]                 push getarg_8
  4845 00001CA6 E882FB                   call prs
  4846 00001CA9 83C402                   add  sp, 2
  4847 00001CAC 8D06ED75                 lea  ax, [namein]
  4848 00001CB0 50                       push ax
  4849 00001CB1 E877FB                   call prs
  4850 00001CB4 83C402                   add  sp, 2
  4851 00001CB7 68[6C1D]                 push getarg_9
  4852 00001CBA E86EFB                   call prs
  4853 00001CBD 83C402                   add  sp, 2
  4854 00001CC0 8D063076                 lea  ax, [namelst]
  4855 00001CC4 50                       push ax
  4856 00001CC5 E863FB                   call prs
  4857 00001CC8 83C402                   add  sp, 2
  4858                                  
  4859                                  ;-23   prs(", "); prs(namebin);
  4860                                  
  4861 00001CCB 68[771D]                 push getarg_10
  4862 00001CCE E85AFB                   call prs
  4863 00001CD1 83C402                   add  sp, 2
  4864 00001CD4 8D067376                 lea  ax, [namebin]
  4865 00001CD8 50                       push ax
  4866 00001CD9 E84FFB                   call prs
  4867 00001CDC 83C402                   add  sp, 2
  4868                                  
  4869                                  ;-24   prs("\n");
  4870                                  
  4871 00001CDF 68[7A1D]                 push getarg_11
  4872 00001CE2 E846FB                   call prs
  4873 00001CE5 83C402                   add  sp, 2
  4874                                  
  4875                                  ;-25 }
  4876                                  
  4877                                  
  4878                                  ;-26 int epilog() { int i; int j; char c;
  4879 00001CE8 C9                       LEAVE
  4880 00001CE9 C3                       ret
  4881                                  ; ENDP
  4882 00001CEA 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4883 00001CF3 41532E434F4D206669-
  4884 00001CFC 6C656E616D65205B77-
  4885 00001D05 2F6F202E535D203A20-
  4886 00001D0E 00                 
  4887 00001D0F 2E5300                  getarg_1 db ".S",0
  4888 00001D12 2E4C535400              getarg_2 db ".LST",0
  4889 00001D17 2E434F4D00              getarg_3 db ".COM",0
  4890 00001D1C 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4891 00001D25 6C65206D697373696E-
  4892 00001D2E 673A2000           
  4893 00001D32 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4894 00001D3B 206E6F742063726561-
  4895 00001D44 74653A2000         
  4896 00001D49 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4897 00001D52 6E6F74206372656174-
  4898 00001D5B 653A2000           
  4899 00001D5F 3B00                    getarg_7 db ";",0
  4900 00001D61 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4901 00001D6A 2000               
  4902 00001D6C 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4903 00001D75 2000               
  4904 00001D77 2C2000                  getarg_10 db ", ",0
  4905 00001D7A 5C6E00                  getarg_11 db "\n",0
  4906                                  
  4907                                  epilog:  ; *** PROC ***
  4908                                  
  4909                                  ;-27   prs("\n;END Errors: "); printIntU(ErrorCount);
  4910                                  
  4911                                  ;Function : epilog, Number of local variables: 3
  4912                                  ;   # type sign width line used address name   list of local variables
  4913                                  ;  200 var sign word    26 NULL bp-2    i
  4914                                  ;  201 var sign word    26 NULL bp-4    j
  4915                                  ;  202 var sign byte    26 NULL bp-6    c;
  4916 00001D7D C8060000                 ENTER  6,0
  4917 00001D81 68[721E]                 push epilog_0
  4918 00001D84 E8A4FA                   call prs
  4919 00001D87 83C402                   add  sp, 2
  4920 00001D8A FF36[3200]               push word [ErrorCount]
  4921 00001D8E E8B5FB                   call printIntU
  4922 00001D91 83C402                   add  sp, 2
  4923                                  
  4924                                  ;-28   if (ErrorCount) prs(" ***ERROR*** ");
  4925                                  
  4926 00001D94 A1[3200]                 mov ax, [ErrorCount]
  4927 00001D97 08C0                     or  al, al
  4928 00001D99 0F840900                 je @@epilog209
  4929 00001D9D 68[821E]                 push epilog_1
  4930 00001DA0 E888FA                   call prs
  4931 00001DA3 83C402                   add  sp, 2
  4932                                  
  4933                                  ;-29   prs(", Label & Var: ");
  4934                                  
  4935                                  @@epilog209:
  4936 00001DA6 68[901E]                 push epilog_2
  4937 00001DA9 E87FFA                   call prs
  4938 00001DAC 83C402                   add  sp, 2
  4939                                  
  4940                                  ;-30   if (LabelMaxIx) {
  4941                                  
  4942 00001DAF A1[5300]                 mov ax, [LabelMaxIx]
  4943 00001DB2 08C0                     or  al, al
  4944 00001DB4 0F846900                 je @@epilog210
  4945                                  
  4946                                  ;-31     i = 1;
  4947                                  
  4948 00001DB8 66B801000000             mov eax, 1
  4949 00001DBE 8946FE                   mov word [bp-2], ax
  4950                                  
  4951                                  ;-32     LabelNamePtr= &LabelNames;
  4952                                  
  4953 00001DC1 B8BB76                   mov ax, LabelNames
  4954 00001DC4 A3[5100]                 mov word [LabelNamePtr], ax
  4955                                  
  4956                                  ;-33     do {
  4957                                  
  4958                                  @@epilog211:
  4959                                  
  4960                                  ;-34       prs(LabelNamePtr); prc(' ');
  4961                                  
  4962 00001DC7 FF36[5100]               push word [LabelNamePtr]
  4963 00001DCB E85DFA                   call prs
  4964 00001DCE 83C402                   add  sp, 2
  4965 00001DD1 6A20                     push 32
  4966 00001DD3 E8F4F9                   call prc
  4967 00001DD6 83C402                   add  sp, 2
  4968                                  
  4969                                  ;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");
  4970                                  
  4971 00001DD9 8B5EFE                   mov bx, [bp-2]
  4972 00001DDC D1E3                     shl bx, 1
  4973 00001DDE 8B87A37A                 mov ax, [LabelAddr + bx]
  4974 00001DE2 8946FC                   mov word [bp-4], ax
  4975 00001DE5 FF76FC                   push word [bp-4]
  4976 00001DE8 E831FB                   call printhex16
  4977 00001DEB 83C402                   add  sp, 2
  4978 00001DEE 68[A01E]                 push epilog_3
  4979 00001DF1 E837FA                   call prs
  4980 00001DF4 83C402                   add  sp, 2
  4981                                  
  4982                                  ;-36       j=strlen(LabelNamePtr);//get end of actual name
  4983                                  
  4984 00001DF7 FF36[5100]               push word [LabelNamePtr]
  4985 00001DFB E86101                   call strlen
  4986 00001DFE 83C402                   add  sp, 2
  4987 00001E01 8946FC                   mov word [bp-4], ax
  4988                                  
  4989                                  ;-37       LabelNamePtr=LabelNamePtr+j;
  4990                                  
  4991 00001E04 A1[5100]                 mov ax, [LabelNamePtr]
  4992 00001E07 0346FC                   add ax, [bp-4]
  4993 00001E0A A3[5100]                 mov word [LabelNamePtr], ax
  4994                                  
  4995                                  ;-38       LabelNamePtr++;
  4996                                  
  4997 00001E0D FF06[5100]               inc  word [LabelNamePtr]
  4998                                  
  4999                                  ;-39       i++;
  5000                                  
  5001 00001E11 FF46FE                   inc  word [bp-2]
  5002                                  
  5003                                  ;-40     } while (i <= LabelMaxIx);
  5004                                  
  5005 00001E14 8B46FE                   mov ax, [bp-2]
  5006 00001E17 3B06[5300]               cmp ax, [LabelMaxIx]
  5007 00001E1B 0F8F0200                 jg  @@epilog212
  5008 00001E1F EBA6                     jmp @@epilog211
  5009                                  @@epilog212:
  5010                                  
  5011                                  ;-41   }
  5012                                  
  5013                                  
  5014                                  ;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  5015                                  
  5016                                  @@epilog210:
  5017 00001E21 68[A41E]                 push epilog_4
  5018 00001E24 E804FA                   call prs
  5019 00001E27 83C402                   add  sp, 2
  5020 00001E2A FF36[5700]               push word [BinLen]
  5021 00001E2E E815FB                   call printIntU
  5022 00001E31 83C402                   add  sp, 2
  5023 00001E34 68[B11E]                 push epilog_5
  5024 00001E37 E8F1F9                   call prs
  5025 00001E3A 83C402                   add  sp, 2
  5026                                  
  5027                                  ;-43 //  i=0;
  5028                                  
  5029                                  
  5030                                  ;-44 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  5031                                  
  5032                                  
  5033                                  ;-45 //  } while (i < BinLen);
  5034                                  
  5035                                  
  5036                                  ;-46   i=0;
  5037                                  
  5038 00001E3D 66B800000000             mov eax, 0
  5039 00001E43 8946FE                   mov word [bp-2], ax
  5040                                  
  5041                                  ;-47   do {
  5042                                  
  5043                                  @@epilog213:
  5044                                  
  5045                                  ;-48     c = FileBin[i];
  5046                                  
  5047 00001E46 8B5EFE                   mov bx, [bp-2]
  5048 00001E49 8A876B7B                 mov al, [FileBin + bx]
  5049 00001E4D 8846FA                   mov byte [bp-6], al
  5050                                  
  5051                                  ;-49     fputcR(c, bin_fd);
  5052                                  
  5053 00001E50 FF36[2E00]               push word [bin_fd]
  5054 00001E54 8A46FA                   mov al, byte [bp-6]
  5055 00001E57 B400                     mov ah, 0
  5056 00001E59 50                       push ax
  5057 00001E5A E84902                   call fputcR
  5058 00001E5D 83C404                   add  sp, 4
  5059                                  
  5060                                  ;-50     i++;
  5061                                  
  5062 00001E60 FF46FE                   inc  word [bp-2]
  5063                                  
  5064                                  ;-51   } while (i < BinLen);
  5065                                  
  5066 00001E63 8B46FE                   mov ax, [bp-2]
  5067 00001E66 3B06[5700]               cmp ax, [BinLen]
  5068 00001E6A 0F8D0200                 jge @@epilog214
  5069 00001E6E EBD6                     jmp @@epilog213
  5070                                  @@epilog214:
  5071                                  
  5072                                  ;-52 }
  5073                                  
  5074                                  
  5075                                  ;-53 int end1(int n) {
  5076 00001E70 C9                       LEAVE
  5077 00001E71 C3                       ret
  5078                                  ; ENDP
  5079 00001E72 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  5080 00001E7B 726F72733A2000     
  5081 00001E82 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5082 00001E8B 2A2A2A2000         
  5083 00001E90 2C204C6162656C2026-     epilog_2 db ", Label & Var: ",0
  5084 00001E99 205661723A2000     
  5085 00001EA0 2C202000                epilog_3 db ",  ",0
  5086 00001EA4 5C6E3B434F4D206669-     epilog_4 db "\n;COM file ",0
  5087 00001EAD 6C652000           
  5088 00001EB1 2062797465733A00        epilog_5 db " bytes:",0
  5089                                  
  5090                                  end1:  ; *** PROC ***
  5091                                  
  5092                                  ;-54   fcloseR(asm_fd);
  5093                                  
  5094                                  ;Function : end1, Number of local variables: 1
  5095                                  ;   # type sign width line used address name   list of local variables
  5096                                  ;  200 var sign word    53 NULL bp+4    n;
  5097 00001EB9 C8000000                 ENTER  0,0
  5098 00001EBD FF36[2A00]               push word [asm_fd]
  5099 00001EC1 E8F701                   call fcloseR
  5100 00001EC4 83C402                   add  sp, 2
  5101                                  
  5102                                  ;-55   fcloseR(lst_fd);
  5103                                  
  5104 00001EC7 FF36[2C00]               push word [lst_fd]
  5105 00001ECB E8ED01                   call fcloseR
  5106 00001ECE 83C402                   add  sp, 2
  5107                                  
  5108                                  ;-56   fcloseR(bin_fd);
  5109                                  
  5110 00001ED1 FF36[2E00]               push word [bin_fd]
  5111 00001ED5 E8E301                   call fcloseR
  5112 00001ED8 83C402                   add  sp, 2
  5113                                  
  5114                                  ;-57   exitR(n);
  5115                                  
  5116 00001EDB FF7604                   push word [bp+4]
  5117 00001EDE E8E801                   call exitR
  5118 00001EE1 83C402                   add  sp, 2
  5119                                  
  5120                                  ;-58 }
  5121 00001EE4 C9                       LEAVE
  5122 00001EE5 C3                       ret
  5123                                  ; ENDP
  5124                                  ;Back to main program: AS.C
  5125                                   
  5126                                  ; missing functions: 
  5127                                  ; digit
  5128                                  ; strcpy
  5129                                  ; eqstr
  5130                                  ; strlen
  5131                                  ; eqstr
  5132                                  ; eqstr
  5133                                  ; eqstr
  5134                                  ; eqstr
  5135                                  ; readRL
  5136                                  ; readRL
  5137                                  ; digit
  5138                                  ; digit
  5139                                  ; strcpy
  5140                                  ; toupper
  5141                                  ; strlen
  5142                                  ; strlen
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
  5166                                  ; eqstr
  5167                                  ; eqstr
  5168                                  ; eqstr
  5169                                  ; eqstr
  5170                                  ; eqstr
  5171                                  ; eqstr
  5172                                  ; eqstr
  5173                                  ; writetty
  5174                                  ; writetty
  5175                                  ; fputcR
  5176                                  ; cputs
  5177                                  ; cputs
  5178                                  ; exitR
  5179                                  ; toupper
  5180                                  ; strcpy
  5181                                  ; strcat1
  5182                                  ; strcpy
  5183                                  ; strcat1
  5184                                  ; strcpy
  5185                                  ; strcat1
  5186                                  ; openR
  5187                                  ; cputs
  5188                                  ; cputs
  5189                                  ; exitR
  5190                                  ; creatR
  5191                                  ; cputs
  5192                                  ; cputs
  5193                                  ; exitR
  5194                                  ; creatR
  5195                                  ; cputs
  5196                                  ; cputs
  5197                                  ; exitR
  5198                                  ; strlen
  5199                                  ; fputcR
  5200                                  ; fcloseR
  5201                                  ; fcloseR
  5202                                  ; fcloseR
  5203                                  ; exitR
  5204                                  ; Number of unresolved CALLs :   77
  5205                                  ;use archive file: AR.C
  5206                                  
  5207                                  ;-222 // AR.C Archive
  5208                                  
  5209                                  ;Number of CALLs:    2 : writetty
  5210                                  
  5211                                  writetty:  ; *** PROC ***
  5212 00001EE6 B40E                     mov  ah, 14
  5213 00001EE8 BB0000                   mov  bx, 0
  5214 00001EEB CD10                     int  16
  5215                                  
  5216                                  ;-223 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5217                                  
  5218 00001EED C3                       ret
  5219                                  ; ENDP
  5220                                  ;Number of CALLs:    8 : cputs
  5221                                  
  5222                                  cputs:  ; *** PROC ***
  5223                                  ;Function : cputs, Number of local variables: 2
  5224                                  ;   # type sign width line used address name   list of local variables
  5225                                  ;  200 ptr sign byte   223 NULL bp+4    s
  5226                                  ;  201 var sign byte   223 NULL bp-2    c;
  5227 00001EEE C8020000                 ENTER  2,0
  5228                                  @@cputs215:
  5229 00001EF2 8B5E04                   mov bx, [bp+4]
  5230 00001EF5 8A07                     mov al, [bx]
  5231 00001EF7 B400                     mov ah, 0
  5232 00001EF9 08C0                     or  al, al
  5233 00001EFB 0F841B00                 je @@cputs216
  5234 00001EFF 8B5E04                   mov bx, [bp+4]
  5235 00001F02 8A07                     mov al, [bx]
  5236 00001F04 B400                     mov ah, 0
  5237 00001F06 8846FE                   mov byte [bp-2], al
  5238 00001F09 8A46FE                   mov al, byte [bp-2]
  5239 00001F0C B400                     mov ah, 0
  5240 00001F0E 50                       push ax
  5241 00001F0F E8C401                   call putch
  5242 00001F12 83C402                   add  sp, 2
  5243 00001F15 FF4604                   inc  word [bp+4]
  5244 00001F18 EBD8                     jmp @@cputs215
  5245                                  @@cputs216:
  5246                                  
  5247                                  ;-224 int mkneg(int n) { n; __asm {neg ax} }
  5248 00001F1A C9                       LEAVE
  5249 00001F1B C3                       ret
  5250                                  ; ENDP
  5251                                  ;Number of CALLs:    2 : toupper
  5252                                  
  5253                                  toupper:  ; *** PROC ***
  5254                                  ;Function : toupper, Number of local variables: 1
  5255                                  ;   # type sign width line used address name   list of local variables
  5256                                  ;  200 ptr sign byte   224 NULL bp+4    s;
  5257 00001F1C C8000000                 ENTER  0,0
  5258                                  @@toupper217:
  5259 00001F20 8B5E04                   mov bx, [bp+4]
  5260 00001F23 8A07                     mov al, [bx]
  5261 00001F25 B400                     mov ah, 0
  5262 00001F27 08C0                     or  al, al
  5263 00001F29 0F843000                 je @@toupper218
  5264 00001F2D 8B5E04                   mov bx, [bp+4]
  5265 00001F30 8A07                     mov al, [bx]
  5266 00001F32 B400                     mov ah, 0
  5267 00001F34 83F861                   cmp ax, 97 ;unsigned : 1
  5268 00001F37 0F8C1D00                 jl  @@toupper219
  5269 00001F3B 8B5E04                   mov bx, [bp+4]
  5270 00001F3E 8A07                     mov al, [bx]
  5271 00001F40 B400                     mov ah, 0
  5272 00001F42 83F87A                   cmp ax, 122
  5273 00001F45 0F8F0F00                 jg  @@toupper220
  5274 00001F49 8B5E04                   mov bx, [bp+4]
  5275 00001F4C 8A07                     mov al, [bx]
  5276 00001F4E B400                     mov ah, 0
  5277 00001F50 83E820                   sub ax, 32
  5278 00001F53 8B5E04                   mov  bx, [bp+4]
  5279 00001F56 8807                     mov  [bx], al
  5280                                  @@toupper220:
  5281                                  @@toupper219:
  5282 00001F58 FF4604                   inc  word [bp+4]
  5283 00001F5B EBC3                     jmp @@toupper217
  5284                                  @@toupper218:
  5285                                  
  5286                                  ;-225 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5287                                  
  5288                                  
  5289                                  ;-226 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5290 00001F5D C9                       LEAVE
  5291 00001F5E C3                       ret
  5292                                  ; ENDP
  5293                                  ;Number of CALLs:    4 : strlen
  5294                                  
  5295                                  strlen:  ; *** PROC ***
  5296                                  ;Function : strlen, Number of local variables: 2
  5297                                  ;   # type sign width line used address name   list of local variables
  5298                                  ;  200 ptr sign byte   226 NULL bp+4    s
  5299                                  ;  201 var sign word   226 NULL bp-2    c;
  5300 00001F5F C8020000                 ENTER  2,0
  5301 00001F63 66B800000000             mov eax, 0
  5302 00001F69 8946FE                   mov word [bp-2], ax
  5303                                  @@strlen221:
  5304 00001F6C 8B5E04                   mov bx, [bp+4]
  5305 00001F6F 8A07                     mov al, [bx]
  5306 00001F71 B400                     mov ah, 0
  5307 00001F73 83F800                   cmp ax, 0
  5308 00001F76 0F840800                 je  @@strlen222
  5309 00001F7A FF4604                   inc  word [bp+4]
  5310 00001F7D FF46FE                   inc  word [bp-2]
  5311 00001F80 EBEA                     jmp @@strlen221
  5312                                  @@strlen222:
  5313 00001F82 8B46FE                   mov ax, [bp-2]
  5314 00001F85 E90000                   jmp @@retn
  5315                                  
  5316                                  ;-227 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5317                                  
  5318 00001F88 C9                      @@retn: LEAVE
  5319 00001F89 C3                       ret
  5320                                  ; ENDP
  5321                                  ;Number of CALLs:    5 : strcpy
  5322                                  
  5323                                  strcpy:  ; *** PROC ***
  5324                                  ;Function : strcpy, Number of local variables: 2
  5325                                  ;   # type sign width line used address name   list of local variables
  5326                                  ;  200 ptr sign byte   227 NULL bp+4    s
  5327                                  ;  201 ptr sign byte   227 NULL bp+6    t;
  5328 00001F8A C8000000                 ENTER  0,0
  5329                                  @@strcpy223:
  5330 00001F8E 8B5E06                   mov bx, [bp+6]
  5331 00001F91 8A07                     mov al, [bx]
  5332 00001F93 B400                     mov ah, 0
  5333 00001F95 8B5E04                   mov  bx, [bp+4]
  5334 00001F98 8807                     mov  [bx], al
  5335 00001F9A FF4604                   inc  word [bp+4]
  5336 00001F9D FF4606                   inc  word [bp+6]
  5337                                  
  5338                                  ;-228   while (*t!=0); *s=0; return s; }
  5339                                  
  5340 00001FA0 8B5E06                   mov bx, [bp+6]
  5341 00001FA3 8A07                     mov al, [bx]
  5342 00001FA5 B400                     mov ah, 0
  5343 00001FA7 83F800                   cmp ax, 0
  5344 00001FAA 0F840200                 je  @@strcpy224
  5345 00001FAE EBDE                     jmp @@strcpy223
  5346                                  @@strcpy224:
  5347 00001FB0 66B800000000             mov eax, 0
  5348 00001FB6 8B5E04                   mov  bx, [bp+4]
  5349 00001FB9 8807                     mov  [bx], al
  5350 00001FBB 8B4604                   mov ax, [bp+4]
  5351 00001FBE E90000                   jmp @@retn
  5352                                  
  5353                                  ;-229 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5354                                  
  5355 00001FC1 C9                      @@retn: LEAVE
  5356 00001FC2 C3                       ret
  5357                                  ; ENDP
  5358                                  ;Number of CALLs:    3 : digit
  5359                                  
  5360                                  digit:  ; *** PROC ***
  5361                                  ;Function : digit, Number of local variables: 1
  5362                                  ;   # type sign width line used address name   list of local variables
  5363                                  ;  200 var sign byte   229 NULL bp+4    c;
  5364 00001FC3 C8000000                 ENTER  0,0
  5365 00001FC7 8A4604                   mov al, [bp+4]
  5366 00001FCA 3C30                     cmp al, 48
  5367 00001FCC 0F8D0900                 jge @@digit225
  5368 00001FD0 66B800000000             mov eax, 0
  5369 00001FD6 E91B00                   jmp @@retn
  5370                                  @@digit225:
  5371 00001FD9 8A4604                   mov al, [bp+4]
  5372 00001FDC 3C39                     cmp al, 57
  5373 00001FDE 0F8E0900                 jle @@digit226
  5374 00001FE2 66B800000000             mov eax, 0
  5375 00001FE8 E90900                   jmp @@retn
  5376                                  @@digit226:
  5377 00001FEB 66B801000000             mov eax, 1
  5378 00001FF1 E90000                   jmp @@retn
  5379                                  
  5380                                  ;-230 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5381                                  
  5382 00001FF4 C9                      @@retn: LEAVE
  5383 00001FF5 C3                       ret
  5384                                  ; ENDP
  5385                                  ;Number of CALLs:   35 : eqstr
  5386                                  
  5387                                  eqstr:  ; *** PROC ***
  5388                                  ;Function : eqstr, Number of local variables: 2
  5389                                  ;   # type sign width line used address name   list of local variables
  5390                                  ;  200 ptr sign byte   230 NULL bp+4    p
  5391                                  ;  201 ptr sign byte   230 NULL bp+6    q;
  5392 00001FF6 C8000000                 ENTER  0,0
  5393                                  @@eqstr227:
  5394 00001FFA 8B5E04                   mov bx, [bp+4]
  5395 00001FFD 8A07                     mov al, [bx]
  5396 00001FFF B400                     mov ah, 0
  5397 00002001 08C0                     or  al, al
  5398 00002003 0F842300                 je @@eqstr228
  5399                                  
  5400                                  ;-231     if (*p != *q) return 0; p++; q++; }
  5401                                  
  5402 00002007 8B5E04                   mov bx, [bp+4]
  5403 0000200A 8A07                     mov al, [bx]
  5404 0000200C B400                     mov ah, 0
  5405 0000200E 8B5E06                   mov bx, [bp+6]
  5406 00002011 3A07                     cmp al, [bx]
  5407 00002013 B400                     mov ah, 0
  5408 00002015 0F840900                 je  @@eqstr229
  5409 00002019 66B800000000             mov eax, 0
  5410 0000201F E92700                   jmp @@retn
  5411                                  @@eqstr229:
  5412 00002022 FF4604                   inc  word [bp+4]
  5413 00002025 FF4606                   inc  word [bp+6]
  5414                                  
  5415                                  ;-232     if(*q) return 0; return 1; }
  5416                                  
  5417 00002028 EBD0                     jmp @@eqstr227
  5418                                  @@eqstr228:
  5419 0000202A 8B5E06                   mov bx, [bp+6]
  5420 0000202D 8A07                     mov al, [bx]
  5421 0000202F B400                     mov ah, 0
  5422 00002031 08C0                     or  al, al
  5423 00002033 0F840900                 je @@eqstr230
  5424 00002037 66B800000000             mov eax, 0
  5425 0000203D E90900                   jmp @@retn
  5426                                  @@eqstr230:
  5427 00002040 66B801000000             mov eax, 1
  5428 00002046 E90000                   jmp @@retn
  5429                                  
  5430                                  ;-233 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5431                                  
  5432 00002049 C9                      @@retn: LEAVE
  5433 0000204A C3                       ret
  5434                                  ; ENDP
  5435                                  ;Number of CALLs:    3 : strcat1
  5436                                  
  5437                                  strcat1:  ; *** PROC ***
  5438                                  ;Function : strcat1, Number of local variables: 2
  5439                                  ;   # type sign width line used address name   list of local variables
  5440                                  ;  200 ptr sign byte   233 NULL bp+4    s
  5441                                  ;  201 ptr sign byte   233 NULL bp+6    t;
  5442 0000204B C8000000                 ENTER  0,0
  5443                                  @@strcat1231:
  5444 0000204F 8B5E04                   mov bx, [bp+4]
  5445 00002052 8A07                     mov al, [bx]
  5446 00002054 B400                     mov ah, 0
  5447 00002056 83F800                   cmp ax, 0
  5448 00002059 0F840500                 je  @@strcat1232
  5449 0000205D FF4604                   inc  word [bp+4]
  5450 00002060 EBED                     jmp @@strcat1231
  5451                                  @@strcat1232:
  5452 00002062 FF7606                   push word [bp+6]
  5453 00002065 FF7604                   push word [bp+4]
  5454 00002068 E81FFF                   call strcpy
  5455 0000206B 83C404                   add  sp, 4
  5456                                  
  5457                                  ;-234 int basename(char *s) { char *p; p=0;
  5458 0000206E C9                       LEAVE
  5459 0000206F C3                       ret
  5460                                  ; ENDP
  5461                                  ;Number of CALLs:    1 : openR
  5462                                  
  5463                                  openR:  ; *** PROC ***
  5464                                  ;Function : openR, Number of local variables: 1
  5465                                  ;   # type sign width line used address name   list of local variables
  5466                                  ;  200 ptr sign byte   234 NULL bp+4    s;
  5467 00002070 C8000000                 ENTER  0,0
  5468 00002074 8B5604                   mov  dx, [bp+4]
  5469 00002077 B8023D                   mov  ax, 15618
  5470 0000207A E87200                   call DosInt
  5471                                  
  5472                                  ;-235 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5473 0000207D C9                       LEAVE
  5474 0000207E C3                       ret
  5475                                  ; ENDP
  5476                                  ;Number of CALLs:    2 : creatR
  5477                                  
  5478                                  creatR:  ; *** PROC ***
  5479                                  ;Function : creatR, Number of local variables: 1
  5480                                  ;   # type sign width line used address name   list of local variables
  5481                                  ;  200 ptr sign byte   235 NULL bp+4    s;
  5482 0000207F C8000000                 ENTER  0,0
  5483 00002083 8B5604                   mov  dx, [bp+4]
  5484 00002086 B90000                   mov  cx, 0
  5485 00002089 B8003C                   mov  ax, 15360
  5486 0000208C E86000                   call DosInt
  5487                                  
  5488                                  ;-236 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5489 0000208F C9                       LEAVE
  5490 00002090 C3                       ret
  5491                                  ; ENDP
  5492                                  ;Number of CALLs:    2 : readRL
  5493                                  
  5494                                  readRL:  ; *** PROC ***
  5495                                  ;Function : readRL, Number of local variables: 3
  5496                                  ;   # type sign width line used address name   list of local variables
  5497                                  ;  200 ptr sign byte   236 NULL bp+4    s
  5498                                  ;  201 var sign word   236 NULL bp+6    fd
  5499                                  ;  202 var sign word   236 NULL bp+8    len;
  5500 00002091 C8000000                 ENTER  0,0
  5501 00002095 8B5604                   mov  dx, [bp+4]
  5502 00002098 8B4E08                   mov  cx, [bp+8]
  5503 0000209B 8B5E06                   mov  bx, [bp+6]
  5504 0000209E B8003F                   mov  ax, 16128
  5505 000020A1 E84B00                   call DosInt
  5506                                  
  5507                                  ;-237 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5508 000020A4 C9                       LEAVE
  5509 000020A5 C3                       ret
  5510                                  ; ENDP
  5511                                  ;Number of CALLs:    2 : fputcR
  5512                                  
  5513                                  fputcR:  ; *** PROC ***
  5514                                  ;Function : fputcR, Number of local variables: 2
  5515                                  ;   # type sign width line used address name   list of local variables
  5516                                  ;  200 ptr sign byte   237 NULL bp+4    n
  5517                                  ;  201 var sign word   237 NULL bp+6    fd;
  5518 000020A6 C8000000                 ENTER  0,0
  5519 000020AA 8D5604                  lea dx, [bp+4]
  5520                                  
  5521                                  ;-238   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5522                                  
  5523 000020AD B90100                   mov  cx, 1
  5524 000020B0 8B5E06                   mov  bx, [bp+6]
  5525 000020B3 B80040                   mov  ax, 16384
  5526 000020B6 E83600                   call DosInt
  5527                                  
  5528                                  ;-239 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5529 000020B9 C9                       LEAVE
  5530 000020BA C3                       ret
  5531                                  ; ENDP
  5532                                  ;Number of CALLs:    3 : fcloseR
  5533                                  
  5534                                  fcloseR:  ; *** PROC ***
  5535                                  ;Function : fcloseR, Number of local variables: 1
  5536                                  ;   # type sign width line used address name   list of local variables
  5537                                  ;  200 var sign word   239 NULL bp+4    fd;
  5538 000020BB C8000000                 ENTER  0,0
  5539 000020BF 8B5E04                   mov  bx, [bp+4]
  5540 000020C2 B8003E                   mov  ax, 15872
  5541 000020C5 CD21                     int  33
  5542                                  
  5543                                  ;-240 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5544 000020C7 C9                       LEAVE
  5545 000020C8 C3                       ret
  5546                                  ; ENDP
  5547                                  ;Number of CALLs:    5 : exitR
  5548                                  
  5549                                  exitR:  ; *** PROC ***
  5550                                  ;Function : exitR, Number of local variables: 1
  5551                                  ;   # type sign width line used address name   list of local variables
  5552                                  ;  200 var sign byte   240 NULL bp+4    c;
  5553 000020C9 C8000000                 ENTER  0,0
  5554 000020CD B44C                     mov  ah, 76
  5555 000020CF 8A4604                   mov  al, [bp+4]
  5556 000020D2 CD21                     int  33
  5557                                  
  5558                                  ;-241 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5559 000020D4 C9                       LEAVE
  5560 000020D5 C3                       ret
  5561                                  ; ENDP
  5562                                  ;End of archive file. 
  5563                                   
  5564                                  ; missing functions: 
  5565                                  ; putch
  5566                                  ; DosInt
  5567                                  ; DosInt
  5568                                  ; DosInt
  5569                                  ; DosInt
  5570                                  ; Number of unresolved CALLs :    5
  5571                                  ;use archive file: AR.C
  5572                                  
  5573                                  ;-242 // AR.C Archive
  5574                                  
  5575                                  ;Number of CALLs:    1 : putch
  5576                                  
  5577                                  putch:  ; *** PROC ***
  5578                                  ;Function : putch, Number of local variables: 1
  5579                                  ;   # type sign width line used address name   list of local variables
  5580                                  ;  200 var sign byte   242 NULL bp+4    c;
  5581 000020D6 C8000000                 ENTER  0,0
  5582 000020DA 807E040A                cmp byte [bp+4], 10
  5583 000020DE 0F850500                 jne @@putch233
  5584 000020E2 B00D                     mov  al, 13
  5585 000020E4 E8FFFD                   call writetty
  5586                                  @@putch233:
  5587 000020E7 8A4604                   mov  al, [bp+4]
  5588 000020EA E8F9FD                   call writetty
  5589                                  
  5590                                  ;-243 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5591 000020ED C9                       LEAVE
  5592 000020EE C3                       ret
  5593                                  ; ENDP
  5594                                  ;Number of CALLs:    4 : DosInt
  5595                                  
  5596                                  DosInt:  ; *** PROC ***
  5597 000020EF CD21                     int  33
  5598 000020F1 7304                     jae short @@DosInt234
  5599 000020F3 FF06[3000]               inc  word [DOS_ERR]
  5600                                  @@DosInt234:
  5601                                  
  5602                                  ;-244 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5603                                  
  5604 000020F7 C3                       ret
  5605                                  ; ENDP
  5606                                  ;End of archive file. 
  5607                                   
  5608                                  ; missing functions:  All FUNCTIONs in place
  5609 000020F8 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5610 000020FB 58                      pop ax
  5611 000020FC C3                      ret
  5612                                   
  5613                                  ;   # type sign width line used  address name   list of global variables
  5614                                  
  5615                                  ;    1 arr sign byte     2    2        0 Version1[20]
  5616                                  ;    2 var sign byte     1    3        0 LIST
  5617                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5618                                  ;    4 arr sign byte     3    7    30000 Symbol[31]
  5619                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  5620                                  ;    6 var unsg word     5   12        0 SymbolInt
  5621                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5622                                  ;    8 arr sign byte     7    3    30062 InputBuf[127]
  5623                                  ;    9 ptr unsg byte     8   23        0 InputPtr
  5624                                  ;   10 arr sign byte     9    5    30189 namein[67]
  5625                                  ;   11 arr sign byte    10    5    30256 namelst[67]
  5626                                  ;   12 arr sign byte    11    5    30323 namebin[67]
  5627                                  ;   13 var sign word    12    4        0 asm_fd
  5628                                  ;   14 var sign word    13    3        0 lst_fd
  5629                                  ;   15 var sign word    14    3        0 bin_fd
  5630                                  ;   16 var sign word    15    6        0 DOS_ERR
  5631                                  ;   17 var sign word    16    4        0 ErrorCount
  5632                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5633                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5634                                  ;   20 var unsg word    20    5        0 PC
  5635                                  ;   21 var unsg word    21    2        0 PCStart
  5636                                  ;   22 var sign byte    22    3        0 isLabel
  5637                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5638                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5639                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5640                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5641                                  ;   27 var sign byte    27   21        0 TokeType
  5642                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5643                                  ;   29 def unsg byte    29    -        0 WORD=2
  5644                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5645                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5646                                  ;   32 def unsg byte    32    -        0 IMM=1
  5647                                  ;   33 def unsg byte    33    -        0 REG=2
  5648                                  ;   34 def unsg byte    34    -        0 ADR=3
  5649                                  ;   35 def unsg byte    35    -        0 MEM=4
  5650                                  ;   36 var sign byte    36   14        0 Op1
  5651                                  ;   37 var sign byte    37   11        0 CodeType
  5652                                  ;   38 var sign byte    38    4        0 Code1
  5653                                  ;   39 var sign byte    39    5        0 Code2
  5654                                  ;   40 var sign byte    40    3        0 Code3
  5655                                  ;   41 var sign byte    41   17        0 RegType
  5656                                  ;   42 var sign byte    42   10        0 RegNo
  5657                                  ;   43 var sign byte    43   10        0 OpSize
  5658                                  ;   44 var sign byte    44    4        0 wflag
  5659                                  ;   45 var sign byte    49   15        0 regindexbase
  5660                                  ;   46 var sign byte    50    3        0 isDirect
  5661                                  ;   47 var sign word    51   14        0 disp
  5662                                  ;   48 var sign word    52    2        0 imme
  5663                                  ;   49 def unsg byte    54    -        0 OPMAXLEN=5
  5664                                  ;   50 arr sign byte    55    2    30390 OpPos[5]
  5665                                  ;   51 var sign word    56    6        0 OpPrintIndex
  5666                                  ;   52 ptr sign byte    57   17        0 OpCodePtr
  5667                                  ;   53 var sign byte    58    2        0 PrintR
  5668                                  ;   54 def unsg byte    60    -        0 LABELNAMESMAX=969
  5669                                  ;   55 arr sign byte    61    3    30395 LabelNames[1000]
  5670                                  ;   56 ptr sign byte    62   10        0 LabelNamePtr
  5671                                  ;   57 def unsg byte    63    -        0 LABELADRMAX=100
  5672                                  ;   58 arr unsg word    64    4    31395 LabelAddr[100]
  5673                                  ;   59 var sign word    65    5        0 LabelMaxIx
  5674                                  ;   60 var sign word    66    4        0 LabelIx
  5675                                  ;   61 def unsg byte    68    -        0 FILEBINMAX=1990
  5676                                  ;   62 arr sign byte    69    2    31595 FileBin[2000]
  5677                                  ;   63 var unsg word    70    4        0 BinLen
  5678                                  ;   64 ptr sign byte    72    1        0 arglen
  5679                                  ;   65 ptr sign byte    73    4        0 argv
  5680                                  ;   66 var sign byte     1    1        0 I_START
  5681                                  ;   67 arr sign byte     4 NULL        0 I_PUSHA[9]
  5682                                  ;   68 arr sign byte     5 NULL        0 I_POPA[8]
  5683                                  ;   69 arr sign byte     6 NULL        0 I_NOP[7]
  5684                                  ;   70 arr sign byte     7 NULL        0 I_CBW[7]
  5685                                  ;   71 arr sign byte     8 NULL        0 I_CWDE[8]
  5686                                  ;   72 arr sign byte     9 NULL        0 I_CWD[7]
  5687                                  ;   73 arr sign byte    10 NULL        0 I_CDQ[7]
  5688                                  ;   74 arr sign byte    11 NULL        0 I_WAIT[8]
  5689                                  ;   75 arr sign byte    12 NULL        0 I_PUSHF[9]
  5690                                  ;   76 arr sign byte    13 NULL        0 I_POPF[8]
  5691                                  ;   77 arr sign byte    14 NULL        0 I_SAHF[8]
  5692                                  ;   78 arr sign byte    15 NULL        0 I_LAHF[8]
  5693                                  ;   79 arr sign byte    16 NULL        0 I_MOVSB[9]
  5694                                  ;   80 arr sign byte    17 NULL        0 I_MOVSW[9]
  5695                                  ;   81 arr sign byte    18 NULL        0 I_CMPSB[9]
  5696                                  ;   82 arr sign byte    19 NULL        0 I_CMPSW[9]
  5697                                  ;   83 arr sign byte    20 NULL        0 I_STOSB[9]
  5698                                  ;   84 arr sign byte    21 NULL        0 I_STOSW[9]
  5699                                  ;   85 arr sign byte    22 NULL        0 I_LODSB[9]
  5700                                  ;   86 arr sign byte    23 NULL        0 I_LODSW[9]
  5701                                  ;   87 arr sign byte    24 NULL        0 I_SCASB[9]
  5702                                  ;   88 arr sign byte    25 NULL        0 I_SCASW[9]
  5703                                  ;   89 arr sign byte    26 NULL        0 I_LEAVE[9]
  5704                                  ;   90 arr sign byte    27 NULL        0 I_IRET[8]
  5705                                  ;   91 arr sign byte    28 NULL        0 I_XLAT[8]
  5706                                  ;   92 arr sign byte    29 NULL        0 I_LOCK[8]
  5707                                  ;   93 arr sign byte    30 NULL        0 I_REPNE[9]
  5708                                  ;   94 arr sign byte    31 NULL        0 I_REPNZ[9]
  5709                                  ;   95 arr sign byte    32 NULL        0 I_REPE[8]
  5710                                  ;   96 arr sign byte    33 NULL        0 I_REPZ[8]
  5711                                  ;   97 arr sign byte    34 NULL        0 I_HLT[7]
  5712                                  ;   98 arr sign byte    35 NULL        0 I_CLC[7]
  5713                                  ;   99 arr sign byte    36 NULL        0 I_STC[7]
  5714                                  ;  100 arr sign byte    37 NULL        0 I_CLI[7]
  5715                                  ;  101 arr sign byte    38 NULL        0 I_STI[7]
  5716                                  ;  102 arr sign byte    39 NULL        0 I_CLD[7]
  5717                                  ;  103 arr sign byte    40 NULL        0 I_STD[7]
  5718                                  ;  104 arr sign byte    42 NULL        0 I_INC[9]
  5719                                  ;  105 arr sign byte    43 NULL        0 I_DEC[9]
  5720                                  ;  106 arr sign byte    44 NULL        0 I_NOT[8]
  5721                                  ;  107 arr sign byte    45 NULL        0 I_NEG[8]
  5722                                  ;  108 arr sign byte    46 NULL        0 I_MUL[8]
  5723                                  ;  109 arr sign byte    47 NULL        0 I_IMUL[9]
  5724                                  ;  110 arr sign byte    48 NULL        0 I_DIV[8]
  5725                                  ;  111 arr sign byte    49 NULL        0 I_IDIV[9]
  5726                                  ;  112 arr sign byte    51 NULL        0 I_LES[7]
  5727                                  ;  113 arr sign byte    52 NULL        0 I_LDS[7]
  5728                                  ;  114 arr sign byte    53 NULL        0 I_LEA[7]
  5729                                  ;  115 arr sign byte    55 NULL        0 I_ADD[7]
  5730                                  ;  116 arr sign byte    56 NULL        0 I_OR[6]
  5731                                  ;  117 arr sign byte    57 NULL        0 I_ADC[7]
  5732                                  ;  118 arr sign byte    58 NULL        0 I_SBB[7]
  5733                                  ;  119 arr sign byte    59 NULL        0 I_AND[7]
  5734                                  ;  120 arr sign byte    60 NULL        0 I_SUB[7]
  5735                                  ;  121 arr sign byte    61 NULL        0 I_XOR[7]
  5736                                  ;  122 arr sign byte    62 NULL        0 I_CMP[7]
  5737                                  ;  123 arr sign byte    64 NULL        0 I_MOV[6]
  5738                                  ;  124 arr sign byte    65 NULL        0 I_MOVSX[9]
  5739                                  ;  125 arr sign byte    66 NULL        0 I_MOVZX[9]
  5740                                  ;  126 arr sign byte    68 NULL        0 I_JO[6]
  5741                                  ;  127 arr sign byte    69 NULL        0 I_JNO[7]
  5742                                  ;  128 arr sign byte    70 NULL        0 I_JB[6]
  5743                                  ;  129 arr sign byte    71 NULL        0 I_JC[6]
  5744                                  ;  130 arr sign byte    72 NULL        0 I_JNB[7]
  5745                                  ;  131 arr sign byte    73 NULL        0 I_JAE[7]
  5746                                  ;  132 arr sign byte    74 NULL        0 I_JNC[7]
  5747                                  ;  133 arr sign byte    75 NULL        0 I_JE[6]
  5748                                  ;  134 arr sign byte    76 NULL        0 I_JZ[6]
  5749                                  ;  135 arr sign byte    77 NULL        0 I_JNE[7]
  5750                                  ;  136 arr sign byte    78 NULL        0 I_JNZ[7]
  5751                                  ;  137 arr sign byte    79 NULL        0 I_JBE[7]
  5752                                  ;  138 arr sign byte    80 NULL        0 I_JNA[7]
  5753                                  ;  139 arr sign byte    81 NULL        0 I_JA[6]
  5754                                  ;  140 arr sign byte    82 NULL        0 I_JS[6]
  5755                                  ;  141 arr sign byte    83 NULL        0 I_JNS[7]
  5756                                  ;  142 arr sign byte    84 NULL        0 I_JP[6]
  5757                                  ;  143 arr sign byte    85 NULL        0 I_JPE[7]
  5758                                  ;  144 arr sign byte    86 NULL        0 I_JNP[7]
  5759                                  ;  145 arr sign byte    87 NULL        0 I_JPO[7]
  5760                                  ;  146 arr sign byte    88 NULL        0 I_JL[6]
  5761                                  ;  147 arr sign byte    89 NULL        0 I_JNL[7]
  5762                                  ;  148 arr sign byte    90 NULL        0 I_JGE[7]
  5763                                  ;  149 arr sign byte    91 NULL        0 I_JLE[7]
  5764                                  ;  150 arr sign byte    92 NULL        0 I_JNG[7]
  5765                                  ;  151 arr sign byte    93 NULL        0 I_JG[6]
  5766                                  ;  152 arr sign byte    95 NULL        0 I_JMP[8]
  5767                                  ;  153 arr sign byte    96 NULL        0 I_CALL[9]
  5768                                  ;  154 arr sign byte    98 NULL        0 I_RET[8]
  5769                                  ;  155 arr sign byte    99 NULL        0 I_RETF[9]
  5770                                  ;  156 arr sign byte   101 NULL        0 I_PUSH[8]
  5771                                  ;  157 arr sign byte   102 NULL        0 I_POP[7]
  5772                                  ;  158 arr sign byte   104 NULL        0 I_ROL[7]
  5773                                  ;  159 arr sign byte   105 NULL        0 I_ROR[7]
  5774                                  ;  160 arr sign byte   106 NULL        0 I_RCL[7]
  5775                                  ;  161 arr sign byte   107 NULL        0 I_RCR[7]
  5776                                  ;  162 arr sign byte   108 NULL        0 I_SHL[7]
  5777                                  ;  163 arr sign byte   109 NULL        0 I_SAL[7]
  5778                                  ;  164 arr sign byte   110 NULL        0 I_SHR[7]
  5779                                  ;  165 arr sign byte   111 NULL        0 I_SAR[7]
  5780                                  ;  166 arr sign byte   113 NULL        0 I_INT[8]
  5781                                  ;  167 arr sign byte   114 NULL        0 I_INTO[8]
  5782                                  ;  168 arr sign byte   116 NULL        0 I_IN[7]
  5783                                  ;  169 arr sign byte   117 NULL        0 I_INSB[8]
  5784                                  ;  170 arr sign byte   118 NULL        0 I_INSW[8]
  5785                                  ;  171 arr sign byte   119 NULL        0 I_INSD[8]
  5786                                  ;  172 arr sign byte   120 NULL        0 I_OUT[8]
  5787                                  ;  173 arr sign byte   121 NULL        0 I_OUTSB[8]
  5788                                  ;  174 arr sign byte   122 NULL        0 I_OUTSW[8]
  5789                                  ;  175 arr sign byte   123 NULL        0 I_OUTSD[8]
  5790                                  ;  176 arr sign byte   125 NULL        0 I_XCHG[9]
  5791                                  ;  177 arr sign byte   127 NULL        0 I_LOOPNZ[10]
  5792                                  ;  178 arr sign byte   128 NULL        0 I_LOOPNE[10]
  5793                                  ;  179 arr sign byte   129 NULL        0 I_LOOPZ[9]
  5794                                  ;  180 arr sign byte   130 NULL        0 I_LOOPE[9]
  5795                                  ;  181 arr sign byte   131 NULL        0 I_LOOP[8]
  5796                                  ;  182 arr sign byte   132 NULL        0 I_JCXZ[8]
  5797                                  ;  183 arr sign byte   133 NULL        0 I_JECXZ[9]
  5798                                  ;  184 arr sign byte   135 NULL        0 I_ENTER[9]
  5799                                  ;  185 arr sign byte   137 NULL        0 I_ORG[6]
  5800                                  ;  186 arr sign byte   139 NULL        0 I_SECTION[10]
  5801                                  ;  187 arr sign byte   140 NULL        0 I_SEGMENT[10]
  5802                                  ;  188 arr sign byte   141 NULL        0 I_ABSOLUTE[11]
  5803                                  ;  189 arr sign byte   142 NULL        0 I_DB[5]
  5804                                  ;  190 arr sign byte   143 NULL        0 I_DW[5]
  5805                                  ;  191 arr sign byte   144 NULL        0 I_DD[5]
  5806                                  ;  192 arr sign byte   145 NULL        0 I_RESB[7]
  5807                                  ;  193 arr sign byte   146 NULL        0 I_RESW[7]
  5808                                  ;  194 arr sign byte   147 NULL        0 I_RESD[7]
  5809                                  ;  195 var sign byte   148 NULL        0 I_END
  5810                                  
  5811                                  
  5812                                  ;   # Calls Line Width  Name   list of functions
  5813                                  
  5814                                  ;    0 NULL    1 word   main
  5815                                  ;    1    1    6 word   process
  5816                                  ;    2    1   49 word   setwflag
  5817                                  ;    3 NULL   61 word   Check2Op
  5818                                  ;    4    1   63 word   checkLeftOp
  5819                                  ;    5 NULL   75 word   saveLeftOp
  5820                                  ;    6 NULL   77 word   checkRightOp
  5821                                  ;    7    1   88 word   getOp
  5822                                  ;    8    2  101 word   getOp1
  5823                                  ;    9    1  117 word   getMEM
  5824                                  ;   10    1  139 word   getIndReg1
  5825                                  ;   11    1  147 word   getIndReg2
  5826                                  ;   12    1  158 word   getCodes
  5827                                  ;   13    1  163 word   gen66h
  5828                                  ;   14    3  165 word   genCode
  5829                                  ;   15   11  169 word   genCode8
  5830                                  ;   16    3  179 word   genCode16
  5831                                  ;   17    1  183 word   writeEA
  5832                                  ;   18    1    1 word   parse
  5833                                  ;   19   13   27 word   getTokeType
  5834                                  ;   20    2   36 word   storeLabel
  5835                                  ;   21    2   43 word   searchLabel
  5836                                  ;   22    1   54 word   getVariable
  5837                                  ;   23    2   83 word   lookCode
  5838                                  ;   24    1   97 word   getCodeSize
  5839                                  ;   25    7  104 word   isToken
  5840                                  ;   26    1  109 word   skipRest
  5841                                  ;   27    1    1 word   getLine
  5842                                  ;   28    1   14 word   ifEOL
  5843                                  ;   29    3   21 word   skipBlank
  5844                                  ;   30    2   26 word   letterE
  5845                                  ;   31    1   36 word   alnumE
  5846                                  ;   32    1   41 word   getDigit
  5847                                  ;   33    1   53 word   getName
  5848                                  ;   34    1   70 word   testReg
  5849                                  ;   35    1    1 word   printLine
  5850                                  ;   36    8   19 word   prc
  5851                                  ;   37    1   23 word   prscomment
  5852                                  ;   38   23   26 word   prs
  5853                                  ;   39    3   31 word   printhex8a
  5854                                  ;   40    2   35 word   printhex16
  5855                                  ;   41    3   38 word   printIntU
  5856                                  ;   42   22   45 word   error1
  5857                                  ;   43 NULL   48 word   allowederror
  5858                                  ;   44    2   49 word   implerror
  5859                                  ;   45    4   50 word   indexerror
  5860                                  ;   46 NULL   51 word   invaloperror
  5861                                  ;   47    1   52 word   numbererror
  5862                                  ;   48 NULL   53 word   regmemerror
  5863                                  ;   49    1   54 word   segregerror
  5864                                  ;   50    1   55 word   syntaxerror
  5865                                  ;   51    7   57 word   errorexit
  5866                                  ;   52    1   58 word   addrexit
  5867                                  ;   53 NULL   59 word   internexit
  5868                                  ;   54    1    1 word   getarg
  5869                                  ;   55    1   26 word   epilog
  5870                                  ;   56    2   53 word   end1
  5871                                  ;   57    4  222 word   writetty
  5872                                  ;   58    8  223 word   cputs
  5873                                  ;   59    2  224 word   toupper
  5874                                  ;   60    4  226 word   strlen
  5875                                  ;   61    6  227 word   strcpy
  5876                                  ;   62    3  229 word   digit
  5877                                  ;   63   35  230 word   eqstr
  5878                                  ;   64    3  233 word   strcat1
  5879                                  ;   65    1  234 word   openR
  5880                                  ;   66    2  235 word   creatR
  5881                                  ;   67    2  236 word   readRL
  5882                                  ;   68    2  237 word   fputcR
  5883                                  ;   69    3  239 word   fcloseR
  5884                                  ;   70    5  240 word   exitR
  5885                                  ;   71    1  242 word   putch
  5886                                  ;   72    4  243 word   DosInt
  5887                                  ;   73 NULL  244 word   LastFunctionByt
  5888                                  
  5889                                  ;    #  addr name   list of CALLs
  5890                                  
  5891                                  ;    0     5 getarg
  5892                                  ;    1    12 parse
  5893                                  ;    2    18 epilog
  5894                                  ;    3    25 end1
  5895                                  ;    4  1418 getTokeType
  5896                                  ;    5  1430 getCodeSize
  5897                                  ;    6  1442 getCodes
  5898                                  ;    7  1451 genCode8
  5899                                  ;    8  1460 checkLeftOp
  5900                                  ;    9  1472 genCode
  5901                                  ;   10  1480 genCode
  5902                                  ;   11  1488 getTokeType
  5903                                  ;   12  1500 implerror
  5904                                  ;   13  1510 genCode
  5905                                  ;   14  1518 writeEA
  5906                                  ;   15  1526 genCode8
  5907                                  ;   16  1535 genCode16
  5908                                  ;   17  1545 genCode8
  5909                                  ;   18  1554 error1
  5910                                  ;   19  1561 error1
  5911                                  ;   20  1577 gen66h
  5912                                  ;   21  1616 getOp
  5913                                  ;   22  1622 implerror
  5914                                  ;   23  1632 segregerror
  5915                                  ;   24  1644 setwflag
  5916                                  ;   25  1653 error1
  5917                                  ;   26  1660 error1
  5918                                  ;   27  1667 error1
  5919                                  ;   28  1709 getOp1
  5920                                  ;   29  1716 isToken
  5921                                  ;   30  1724 getMEM
  5922                                  ;   31  1731 error1
  5923                                  ;   32  1738 error1
  5924                                  ;   33  1752 testReg
  5925                                  ;   34  1760 searchLabel
  5926                                  ;   35  1772 error1
  5927                                  ;   36  1790 getTokeType
  5928                                  ;   37  1802 getOp1
  5929                                  ;   38  1809 syntaxerror
  5930                                  ;   39  1821 getIndReg2
  5931                                  ;   40  1832 getIndReg1
  5932                                  ;   41  1843 isToken
  5933                                  ;   42  1851 getTokeType
  5934                                  ;   43  1863 numbererror
  5935                                  ;   44  1875 isToken
  5936                                  ;   45  1883 isToken
  5937                                  ;   46  1891 errorexit
  5938                                  ;   47  1912 indexerror
  5939                                  ;   48  1923 indexerror
  5940                                  ;   49  1947 indexerror
  5941                                  ;   50  1958 indexerror
  5942                                  ;   51  1985 genCode8
  5943                                  ;   52  2006 genCode8
  5944                                  ;   53  2038 genCode8
  5945                                  ;   54  2047 genCode8
  5946                                  ;   55  2072 addrexit
  5947                                  ;   56  2081 error1
  5948                                  ;   57  2088 genCode8
  5949                                  ;   58  2097 genCode8
  5950                                  ;   59  2106 genCode16
  5951                                  ;   60  2122 getLine
  5952                                  ;   61  2130 getTokeType
  5953                                  ;   62  2142 storeLabel
  5954                                  ;   63  2153 getTokeType
  5955                                  ;   64  2165 lookCode
  5956                                  ;   65  2174 process
  5957                                  ;   66  2182 getVariable
  5958                                  ;   67  2194 skipRest
  5959                                  ;   68  2203 error1
  5960                                  ;   69  2210 error1
  5961                                  ;   70  2217 printLine
  5962                                  ;   71  2241 skipBlank
  5963                                  ;   72  2251 digit
  5964                                  ;   73  2257 getDigit
  5965                                  ;   74  2266 letterE
  5966                                  ;   75  2274 getName
  5967                                  ;   76  2293 searchLabel
  5968                                  ;   77  2305 error1
  5969                                  ;   78  2312 strcpy
  5970                                  ;   79  2339 eqstr
  5971                                  ;   80  2345 strlen
  5972                                  ;   81  2366 storeLabel
  5973                                  ;   82  2377 getTokeType
  5974                                  ;   83  2389 lookCode
  5975                                  ;   84  2398 errorexit
  5976                                  ;   85  2408 errorexit
  5977                                  ;   86  2418 getTokeType
  5978                                  ;   87  2430 genCode8
  5979                                  ;   88  2439 skipBlank
  5980                                  ;   89  2449 isToken
  5981                                  ;   90  2457 genCode8
  5982                                  ;   91  2466 isToken
  5983                                  ;   92  2474 getTokeType
  5984                                  ;   93  2486 genCode16
  5985                                  ;   94  2496 isToken
  5986                                  ;   95  2504 errorexit
  5987                                  ;   96  2523 eqstr
  5988                                  ;   97  2541 eqstr
  5989                                  ;   98  2547 getTokeType
  5990                                  ;   99  2559 eqstr
  5991                                  ;  100  2565 getTokeType
  5992                                  ;  101  2577 eqstr
  5993                                  ;  102  2583 getTokeType
  5994                                  ;  103  2605 skipBlank
  5995                                  ;  104  2624 getTokeType
  5996                                  ;  105  2636 error1
  5997                                  ;  106  2651 readRL
  5998                                  ;  107  2658 errorexit
  5999                                  ;  108  2668 ifEOL
  6000                                  ;  109  2682 readRL
  6001                                  ;  110  2718 digit
  6002                                  ;  111  2724 letterE
  6003                                  ;  112  2751 digit
  6004                                  ;  113  2769 alnumE
  6005                                  ;  114  2776 strcpy
  6006                                  ;  115  2783 toupper
  6007                                  ;  116  2799 strlen
  6008                                  ;  117  2806 strlen
  6009                                  ;  118  2813 eqstr
  6010                                  ;  119  2819 eqstr
  6011                                  ;  120  2825 eqstr
  6012                                  ;  121  2831 eqstr
  6013                                  ;  122  2837 eqstr
  6014                                  ;  123  2843 eqstr
  6015                                  ;  124  2849 eqstr
  6016                                  ;  125  2855 eqstr
  6017                                  ;  126  2861 eqstr
  6018                                  ;  127  2867 eqstr
  6019                                  ;  128  2873 eqstr
  6020                                  ;  129  2879 eqstr
  6021                                  ;  130  2885 eqstr
  6022                                  ;  131  2891 eqstr
  6023                                  ;  132  2897 eqstr
  6024                                  ;  133  2903 eqstr
  6025                                  ;  134  2909 eqstr
  6026                                  ;  135  2915 eqstr
  6027                                  ;  136  2921 eqstr
  6028                                  ;  137  2927 eqstr
  6029                                  ;  138  2933 eqstr
  6030                                  ;  139  2939 eqstr
  6031                                  ;  140  2945 eqstr
  6032                                  ;  141  2951 eqstr
  6033                                  ;  142  2957 eqstr
  6034                                  ;  143  2963 eqstr
  6035                                  ;  144  2969 eqstr
  6036                                  ;  145  2975 eqstr
  6037                                  ;  146  2981 eqstr
  6038                                  ;  147  2987 eqstr
  6039                                  ;  148  3007 prs
  6040                                  ;  149  3011 printhex16
  6041                                  ;  150  3022 prs
  6042                                  ;  151  3026 prc
  6043                                  ;  152  3030 printhex8a
  6044                                  ;  153  3041 prc
  6045                                  ;  154  3045 prs
  6046                                  ;  155  3049 prscomment
  6047                                  ;  156  3066 writetty
  6048                                  ;  157  3075 writetty
  6049                                  ;  158  3084 fputcR
  6050                                  ;  159  3106 prc
  6051                                  ;  160  3122 prc
  6052                                  ;  161  3143 prc
  6053                                  ;  162  3147 prc
  6054                                  ;  163  3169 printhex8a
  6055                                  ;  164  3180 printhex8a
  6056                                  ;  165  3205 printIntU
  6057                                  ;  166  3215 prc
  6058                                  ;  167  3228 prs
  6059                                  ;  168  3232 prs
  6060                                  ;  169  3236 prs
  6061                                  ;  170  3240 prs
  6062                                  ;  171  3257 error1
  6063                                  ;  172  3274 error1
  6064                                  ;  173  3292 error1
  6065                                  ;  174  3312 error1
  6066                                  ;  175  3331 error1
  6067                                  ;  176  3350 error1
  6068                                  ;  177  3369 error1
  6069                                  ;  178  3388 error1
  6070                                  ;  179  3407 error1
  6071                                  ;  180  3414 end1
  6072                                  ;  181  3428 errorexit
  6073                                  ;  182  3449 errorexit
  6074                                  ;  183  3478 cputs
  6075                                  ;  184  3484 cputs
  6076                                  ;  185  3490 exitR
  6077                                  ;  186  3496 toupper
  6078                                  ;  187  3504 strcpy
  6079                                  ;  188  3511 strcat1
  6080                                  ;  189  3519 strcpy
  6081                                  ;  190  3526 strcat1
  6082                                  ;  191  3534 strcpy
  6083                                  ;  192  3541 strcat1
  6084                                  ;  193  3549 openR
  6085                                  ;  194  3555 cputs
  6086                                  ;  195  3561 cputs
  6087                                  ;  196  3567 exitR
  6088                                  ;  197  3573 creatR
  6089                                  ;  198  3580 cputs
  6090                                  ;  199  3586 cputs
  6091                                  ;  200  3592 exitR
  6092                                  ;  201  3598 creatR
  6093                                  ;  202  3605 cputs
  6094                                  ;  203  3611 cputs
  6095                                  ;  204  3617 exitR
  6096                                  ;  205  3623 prs
  6097                                  ;  206  3627 prs
  6098                                  ;  207  3631 prs
  6099                                  ;  208  3635 prs
  6100                                  ;  209  3639 prs
  6101                                  ;  210  3643 prs
  6102                                  ;  211  3647 prs
  6103                                  ;  212  3651 prs
  6104                                  ;  213  3655 prs
  6105                                  ;  214  3672 prs
  6106                                  ;  215  3676 printIntU
  6107                                  ;  216  3686 prs
  6108                                  ;  217  3690 prs
  6109                                  ;  218  3694 prs
  6110                                  ;  219  3698 prc
  6111                                  ;  220  3702 printhex16
  6112                                  ;  221  3713 prs
  6113                                  ;  222  3717 strlen
  6114                                  ;  223  3724 prs
  6115                                  ;  224  3728 printIntU
  6116                                  ;  225  3738 prs
  6117                                  ;  226  3742 fputcR
  6118                                  ;  227  3756 fcloseR
  6119                                  ;  228  3764 fcloseR
  6120                                  ;  229  3772 fcloseR
  6121                                  ;  230  3780 exitR
  6122                                  ;  231  3805 putch
  6123                                  ;  232  3873 strcpy
  6124                                  ;  233  3888 DosInt
  6125                                  ;  234  3904 DosInt
  6126                                  ;  235  3927 DosInt
  6127                                  ;  236  3946 DosInt
  6128                                  ;  237  3980 writetty
  6129                                  ;  238  3989 writetty
  6130                                  ;Input: AS.C, List: AS.S,  Lines:  245
  6131                                  ;Glob. variables:  195 max.:  200
  6132                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6133                                  ;Functions      :   74 max.:  300
  6134                                  ;Calls          :  239 max.: 2000, NameField: 4021 max.:    65535
  6135                                  ;Code until     :26009 max.: 30000, free: 3991
  6136                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6137                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
