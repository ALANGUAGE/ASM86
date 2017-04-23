     1                                  
     2                                  ; A.COM V0.8, Source: AS.C, Out asm: AS.S
     3                                  org  256 
     4 00000000 E9EB1B                  jmp main
     5                                  
     6                                  ;-1 char Version1[]="AS.C V0.1";/// BAS.BAT, AS TE, NAS.BAT
     7                                  
     8 00000003 41532E432056302E31-     Version1 db "AS.C V0.1",0
     9 0000000C 00                 
    10                                  
    11                                  ;-2 #include "DECL.C"
    12                                  
    13                                  ;Use include file: DECL.C
    14                                  
    15                                  ;-1 char LIST;              ///< listing on/off     
    16                                  
    17 0000000D 00                      LIST db 0
    18                                  
    19                                  ;-2 #define SYMBOLMAX    31
    20                                  
    21                                  
    22                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    23                                  
    24                                  section .bss
    25                                  absolute 30000
    26 00007530 <res 0000001F>          Symbol resb 31
    27                                  section .text
    28                                  
    29                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    30                                  
    31                                  section .bss
    32                                  absolute 30031
    33 0000754F <res 0000001F>          SymbolUpper resb 31
    34                                  section .text
    35                                  
    36                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit   
    37                                  
    38 0000000E 0000                    SymbolInt dw 0
    39                                  
    40                                  ;-6 unsigned long SymbolLong;//integer value set in getDigit
    41                                  
    42 00000010 00000000                SymbolLong dd 0
    43                                  
    44                                  ;-7 #define INPUTBUFMAX 255
    45                                  
    46                                  
    47                                  ;-8 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    48                                  
    49                                  section .bss
    50                                  absolute 30062
    51 0000756E <res 000000FF>          InputBuf resb 255
    52                                  section .text
    53                                  
    54                                  ;-9 unsigned char *InputPtr;//position in InputBuf
    55                                  
    56 00000014 0000                    InputPtr dw 0
    57                                  
    58                                  ;-10 char namein [67];       //input file name  .S
    59                                  
    60                                  section .bss
    61                                  absolute 30317
    62 0000766D <res 00000043>          namein resb 67
    63                                  section .text
    64                                  
    65                                  ;-11 char namelst[67];       //list file name   .LST
    66                                  
    67                                  section .bss
    68                                  absolute 30384
    69 000076B0 <res 00000043>          namelst resb 67
    70                                  section .text
    71                                  
    72                                  ;-12 char namebin[67];       //output file name .COM
    73                                  
    74                                  section .bss
    75                                  absolute 30451
    76 000076F3 <res 00000043>          namebin resb 67
    77                                  section .text
    78                                  
    79                                  ;-13 int  asm_fd;            //input file descriptor
    80                                  
    81 00000016 0000                    asm_fd dw 0
    82                                  
    83                                  ;-14 int lst_fd;             //list file descriptor
    84                                  
    85 00000018 0000                    lst_fd dw 0
    86                                  
    87                                  ;-15 int bin_fd;             //output file descriptor
    88                                  
    89 0000001A 0000                    bin_fd dw 0
    90                                  
    91                                  ;-16 int DOS_ERR=0;          //global var
    92                                  
    93 0000001C 0000                    DOS_ERR dw 0
    94                                  
    95                                  ;-17 int ErrorCount=0;       //number of errors
    96                                  
    97 0000001E 0000                    ErrorCount dw 0
    98                                  
    99                                  ;-18 int DOS_NoBytes;        //number of bytes read (0 or 1)
   100                                  
   101 00000020 0000                    DOS_NoBytes dw 0
   102                                  
   103                                  ;-19 char DOS_ByteRead;      //the byte just read by DOS
   104                                  
   105 00000022 00                      DOS_ByteRead db 0
   106                                  
   107                                  ;-20 
   108                                  
   109                                  
   110                                  ;-21 unsigned int PC=0;      //program counter
   111                                  
   112 00000023 0000                    PC dw 0
   113                                  
   114                                  ;-22 unsigned int Origin=0;  //ORG nn   
   115                                  
   116 00000025 0000                    Origin dw 0
   117                                  
   118                                  ;-23 unsigned int AbsoluteLab=0;//uninitialised data
   119                                  
   120 00000027 0000                    AbsoluteLab dw 0
   121                                  
   122                                  ;-24 unsigned int PCStart;   //PC at start of line by PrintLine()
   123                                  
   124 00000029 0000                    PCStart dw 0
   125                                  
   126                                  ;-25 char isLabel;           //by getName()
   127                                  
   128 0000002B 00                      isLabel db 0
   129                                  
   130                                  ;-26 #define DIGIT    1      //0-9
   131                                  
   132                                  
   133                                  ;-27 #define LETTERE  2      //a-z A-Z @ . _
   134                                  
   135                                  
   136                                  ;-28 #define ALNUME   3      //a-z A-Z @ . _  0-9
   137                                  
   138                                  
   139                                  ;-29 #define NOALNUME 4      //other char
   140                                  
   141                                  
   142                                  ;-30 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   143                                  
   144 0000002C 00                      TokeType db 0
   145                                  
   146                                  ;-31 #define BYTE     1
   147                                  
   148                                  
   149                                  ;-32 #define WORD     2
   150                                  
   151                                  
   152                                  ;-33 #define DWORD    3
   153                                  
   154                                  
   155                                  ;-34 #define SEGREG   4
   156                                  
   157                                  
   158                                  ;-35 #define IMM      1      //const  ,123
   159                                  
   160                                  
   161                                  ;-36 #define REG      2      //       ,BX    mode=11
   162                                  
   163                                  
   164                                  ;-37 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   165                                  
   166                                  
   167                                  ;-38 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   168                                  
   169                                  
   170                                  ;-39 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   171                                  
   172 0000002D 00                      Op db 0
   173                                  
   174                                  ;-40 char Op2;               //2. operand
   175                                  
   176 0000002E 00                      Op2 db 0
   177                                  
   178                                  ;-41 char CodeType;          //1-207 by searchSymbol(), must be byte size
   179                                  
   180 0000002F 00                      CodeType db 0
   181                                  
   182                                  ;-42 char Code1;             //1. Opcode
   183                                  
   184 00000030 00                      Code1 db 0
   185                                  
   186                                  ;-43 char Code2;             //2. Opcode
   187                                  
   188 00000031 00                      Code2 db 0
   189                                  
   190                                  ;-44 char Code3;             //3. Opcode
   191                                  
   192 00000032 00                      Code3 db 0
   193                                  
   194                                  ;-45 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   195                                  
   196 00000033 00                      R2No db 0
   197                                  
   198                                  ;-46 char R1No;              //temp for 1. register
   199                                  
   200 00000034 00                      R1No db 0
   201                                  
   202                                  ;-47 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   203                                  
   204 00000035 00                      R2Type db 0
   205                                  
   206                                  ;-48 char R1Type;            //temp for 1. register 
   207                                  
   208 00000036 00                      R1Type db 0
   209                                  
   210                                  ;-49 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   211                                  
   212 00000037 00                      OpSize db 0
   213                                  
   214                                  ;-50 char wflag;             //wordflag: 0=byte, 1=word/dword
   215                                  
   216 00000038 00                      wflag db 0
   217                                  
   218                                  ;-51 char dflag;             //directionflag: 1=to reg MOV,ALU    
   219                                  
   220 00000039 00                      dflag db 0
   221                                  
   222                                  ;-52 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   223                                  
   224 0000003A 00                      sflag db 0
   225                                  
   226                                  ;-53 char rm;                //combination of index and base reg
   227                                  
   228 0000003B 00                      rm db 0
   229                                  
   230                                  ;-54 char isDirect;          //set in process and getMeM, need in WriteEA
   231                                  
   232 0000003C 00                      isDirect db 0
   233                                  
   234                                  ;-55 int disp;               //displacement      0-8 bytes
   235                                  
   236 0000003D 0000                    disp dw 0
   237                                  
   238                                  ;-56 unsigned int imme;      //immediate         0-8 bytes
   239                                  
   240 0000003F 0000                    imme dw 0
   241                                  
   242                                  ;-57 
   243                                  
   244                                  
   245                                  ;-58 #define OPMAXLEN 5
   246                                  
   247                                  
   248                                  ;-59 char OpPos[OPMAXLEN];   //array for one opcode to list
   249                                  
   250                                  section .bss
   251                                  absolute 30518
   252 00007736 <res 00000005>          OpPos resb 5
   253                                  section .text
   254                                  
   255                                  ;-60 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   256                                  
   257 00000041 0000                    OpPrintIndex dw 0
   258                                  
   259                                  ;-61 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   260                                  
   261 00000043 0000                    OpCodePtr dw 0
   262                                  
   263                                  ;-62 char PrintRA;           //print * for forward relocative jmp
   264                                  
   265 00000045 00                      PrintRA db 0
   266                                  
   267                                  ;-63 
   268                                  
   269                                  
   270                                  ;-64 #define LABELNAMESMAX 3969//next number - SYMBOLMAX
   271                                  
   272                                  
   273                                  ;-65 char LabelNames[4000];  //space for names of all labels
   274                                  
   275                                  section .bss
   276                                  absolute 30523
   277 0000773B <res 00000FA0>          LabelNames resb 4000
   278                                  section .text
   279                                  
   280                                  ;-66 char *LabelNamePtr;     //first free position
   281                                  
   282 00000046 0000                    LabelNamePtr dw 0
   283                                  
   284                                  ;-67 #define LABELADRMAX 600
   285                                  
   286                                  
   287                                  ;-68 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   288                                  
   289                                  section .bss
   290                                  absolute 34523
   291 000086DB <res 000004B0>          LabelAddr resw 600
   292                                  section .text
   293                                  
   294                                  ;-69 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   295                                  
   296 00000048 0000                    LabelMaxIx dw 0
   297                                  
   298                                  ;-70 int LabelIx;            //actual # of just searched label
   299                                  
   300 0000004A 0000                    LabelIx dw 0
   301                                  
   302                                  ;-71 
   303                                  
   304                                  
   305                                  ;-72 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   306                                  
   307                                  
   308                                  ;-73 char JmpCallNames[2000];//space for names of jmp, call
   309                                  
   310                                  section .bss
   311                                  absolute 35723
   312 00008B8B <res 000007D0>          JmpCallNames resb 2000
   313                                  section .text
   314                                  
   315                                  ;-74 char *JmpCallNamePtr;   //first free position 
   316                                  
   317 0000004C 0000                    JmpCallNamePtr dw 0
   318                                  
   319                                  ;-75 #define JMPCALLMAX 500  //max. jmp and call
   320                                  
   321                                  
   322                                  ;-76 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   323                                  
   324                                  section .bss
   325                                  absolute 37723
   326 0000935B <res 000003E8>          JmpCallAddr resw 500
   327                                  section .text
   328                                  
   329                                  ;-77 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   330                                  
   331 0000004E 0000                    JmpCallMaxIx dw 0
   332                                  
   333                                  ;-78  
   334                                  
   335                                  
   336                                  ;-79 #define FILEBINMAX 20000 
   337                                  
   338                                  
   339                                  ;-80 char FileBin  [FILEBINMAX];//output binary file
   340                                  
   341                                  section .bss
   342                                  absolute 38723
   343 00009743 <res 00004E20>          FileBin resb 20000
   344                                  section .text
   345                                  
   346                                  ;-81 unsigned int BinLen=0;  //length of binary file
   347                                  
   348 00000050 0000                    BinLen dw 0
   349                                  
   350                                  ;-82 
   351                                  
   352                                  
   353                                  ;-83 char *arglen=0x80;      // for main only
   354                                  
   355 00000052 8000                    arglen dw 128
   356                                  
   357                                  ;-84 char *argv=0x82;        // for main only
   358                                  
   359 00000054 8200                    argv dw 130
   360                                  ;Back to main program: AS.C
   361                                  
   362                                  ;-3 #include "OPTABL.C"   
   363                                  
   364                                  ;Use include file: OPTABL.C
   365                                  
   366                                  ;-1 char I_START=0xF1;
   367                                  
   368 00000056 F1                      I_START db 241
   369                                  
   370                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   371                                  
   372                                  
   373                                  ;-3 //  1:   1 byte opcode
   374                                  
   375                                  
   376                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   377                                  
   378 00000057 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   379                                  
   380                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   381                                  
   382 00000060 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   383                                  
   384                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   385                                  
   386 00000068 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   387                                  
   388                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   389                                  
   390 0000006F 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   391                                  
   392                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   393                                  
   394 00000076 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   395                                  
   396                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   397                                  
   398 0000007E 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   399                                  
   400                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   401                                  
   402 00000085 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   403                                  
   404                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   405                                  
   406 0000008C 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   407                                  
   408                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   409                                  
   410 00000094 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   411                                  
   412                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   413                                  
   414 0000009D 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   415                                  
   416                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   417                                  
   418 000000A5 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   419                                  
   420                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   421                                  
   422 000000AD 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   423                                  
   424                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   425                                  
   426 000000B5 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   427                                  
   428                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   429                                  
   430 000000BE 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   431                                  
   432                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   433                                  
   434 000000C7 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   435                                  
   436                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   437                                  
   438 000000D0 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   439                                  
   440                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   441                                  
   442 000000D9 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   443                                  
   444                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   445                                  
   446 000000E2 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   447                                  
   448                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   449                                  
   450 000000EB 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   451                                  
   452                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   453                                  
   454 000000F4 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   455                                  
   456                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   457                                  
   458 000000FD 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   459                                  
   460                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   461                                  
   462 00000106 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   463                                  
   464                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   465                                  
   466 0000010F 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   467                                  
   468                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   469                                  
   470 00000118 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   471                                  
   472                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   473                                  
   474 00000120 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   475                                  
   476                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   477                                  
   478 00000128 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   479                                  
   480                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   481                                  
   482 00000130 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   483                                  
   484                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   485                                  
   486 00000138 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   487                                  
   488                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   489                                  
   490 00000140 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   491                                  
   492                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   493                                  
   494 00000149 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   495                                  
   496                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   497                                  
   498 00000152 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   499                                  
   500                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   501                                  
   502 0000015A 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   503                                  
   504                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   505                                  
   506 00000162 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   507                                  
   508                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   509                                  
   510 00000169 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   511                                  
   512                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   513                                  
   514 00000170 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   515                                  
   516                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   517                                  
   518 00000177 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   519                                  
   520                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   521                                  
   522 0000017E 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   523                                  
   524                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   525                                  
   526 00000185 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   527                                  
   528                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   529                                  
   530 0000018C 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   531                                  
   532                                  ;-43 // 2: mem reg 16 bit
   533                                  
   534                                  
   535                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   536                                  
   537 00000193 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   538                                  
   539                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   540                                  
   541 0000019C 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   542                                  
   543                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   544                                  
   545 000001A5 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   546                                  
   547                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   548                                  
   549 000001AD 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   550                                  
   551                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   552                                  
   553 000001B5 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   554                                  
   555                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   556                                  
   557 000001BD 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   558                                  
   559                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   560                                  
   561 000001C6 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   562                                  
   563                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   564                                  
   565 000001CE 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   566                                  
   567                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   568                                  
   569                                  
   570                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   571                                  
   572 000001D7 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   573                                  
   574                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   575                                  
   576 000001DE 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   577                                  
   578                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   579                                  
   580 000001E5 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   581                                  
   582                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   583                                  
   584 000001EC 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   585                                  
   586                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   587                                  
   588 000001F4 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   589                                  
   590                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   591                                  
   592 000001FC 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   593                                  
   594                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   595                                  
   596                                  
   597                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   598                                  
   599 00000204 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   600                                  
   601                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   602                                  
   603 0000020B 4F52000401F1            I_OR db 79,82,0,4,1,241
   604                                  
   605                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   606                                  
   607 00000211 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   608                                  
   609                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   610                                  
   611 00000218 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   612                                  
   613                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   614                                  
   615 0000021F 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   616                                  
   617                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   618                                  
   619 00000226 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   620                                  
   621                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   622                                  
   623 0000022D 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   624                                  
   625                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   626                                  
   627 00000234 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   628                                  
   629                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   630                                  
   631 0000023B 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   632 00000244 00F1               
   633                                  
   634                                  ;-69 //  5: mov
   635                                  
   636                                  
   637                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   638                                  
   639 00000246 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   640                                  
   641                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   642                                  
   643 0000024C 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   644                                  
   645                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   646                                  
   647 00000255 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   648                                  
   649                                  ;-73 //  6: single byte relative jump
   650                                  
   651                                  
   652                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   653                                  
   654 0000025E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   655                                  
   656                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   657                                  
   658 00000264 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   659                                  
   660                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   661                                  
   662 0000026B 4A42000602F1            I_JB db 74,66,0,6,2,241
   663                                  
   664                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   665                                  
   666 00000271 4A43000602F1            I_JC db 74,67,0,6,2,241
   667                                  
   668                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   669                                  
   670 00000277 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   671                                  
   672                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   673                                  
   674 0000027E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   675                                  
   676                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   677                                  
   678 00000285 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   679                                  
   680                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   681                                  
   682 0000028C 4A45000604F1            I_JE db 74,69,0,6,4,241
   683                                  
   684                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   685                                  
   686 00000292 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   687                                  
   688                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   689                                  
   690 00000298 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   691                                  
   692                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   693                                  
   694 0000029F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   695                                  
   696                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   697                                  
   698 000002A6 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   699                                  
   700                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   701                                  
   702 000002AD 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   703                                  
   704                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   705                                  
   706 000002B4 4A41000607F1            I_JA db 74,65,0,6,7,241
   707                                  
   708                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   709                                  
   710 000002BA 4A53000608F1            I_JS db 74,83,0,6,8,241
   711                                  
   712                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   713                                  
   714 000002C0 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   715                                  
   716                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   717                                  
   718 000002C7 4A5000060AF1            I_JP db 74,80,0,6,10,241
   719                                  
   720                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   721                                  
   722 000002CD 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   723                                  
   724                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   725                                  
   726 000002D4 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   727                                  
   728                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   729                                  
   730 000002DB 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   731                                  
   732                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   733                                  
   734 000002E2 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   735                                  
   736                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   737                                  
   738 000002E8 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   739                                  
   740                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   741                                  
   742 000002EF 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   743                                  
   744                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   745                                  
   746 000002F6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   747                                  
   748                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   749                                  
   750 000002FD 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   751                                  
   752                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   753                                  
   754 00000304 4A4700060FF1            I_JG db 74,71,0,6,15,241
   755                                  
   756                                  ;-100 //  7: jmp, call
   757                                  
   758                                  
   759                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   760                                  
   761 0000030A 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   762                                  
   763                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   764                                  
   765 00000312 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   766                                  
   767                                  ;-103 //  8: ret
   768                                  
   769                                  
   770                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   771                                  
   772 0000031B 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   773                                  
   774                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   775                                  
   776 00000323 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   777                                  
   778                                  ;-106 //  9: seg, r/m
   779                                  
   780                                  
   781                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   782                                  
   783 0000032C 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   784 00000335 06F1               
   785                                  
   786                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   787                                  
   788 00000337 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   789 00000340 F1                 
   790                                  
   791                                  ;-109 //  11: shift, rotates
   792                                  
   793                                  
   794                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   795                                  
   796 00000341 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   797                                  
   798                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   799                                  
   800 00000348 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   801                                  
   802                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   803                                  
   804 0000034F 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   805                                  
   806                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   807                                  
   808 00000356 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   809                                  
   810                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   811                                  
   812 0000035D 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   813                                  
   814                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 4,    0xF1};
   815                                  
   816 00000364 53414C000B04F1          I_SAL db 83,65,76,0,11,4,241
   817                                  
   818                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 5,    0xF1};
   819                                  
   820 0000036B 534852000B05F1          I_SHR db 83,72,82,0,11,5,241
   821                                  
   822                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   823                                  
   824 00000372 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   825                                  
   826                                  ;-118 //  12: int
   827                                  
   828                                  
   829                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   830                                  
   831 00000379 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   832                                  
   833                                  ;-120 //  14: in/out
   834                                  
   835                                  
   836                                  ;-121 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   837                                  
   838 00000381 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   839                                  
   840                                  ;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   841                                  
   842 00000388 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   843                                  
   844                                  ;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   845                                  
   846 00000390 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   847                                  
   848                                  ;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   849                                  
   850 00000398 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   851                                  
   852                                  ;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   853                                  
   854 000003A0 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   855                                  
   856                                  ;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   857                                  
   858 000003A8 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   859                                  
   860                                  ;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   861                                  
   862 000003B0 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   863                                  
   864                                  ;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   865                                  
   866 000003B8 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   867                                  
   868                                  ;-129 //  15: xchg
   869                                  
   870                                  
   871                                  ;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   872                                  
   873 000003C0 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   874                                  
   875                                  ;-131 //  16: loop, jcxz
   876                                  
   877                                  
   878                                  ;-132 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   879                                  
   880 000003C9 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   881 000003D2 F1                 
   882                                  
   883                                  ;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   884                                  
   885 000003D3 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   886 000003DC F1                 
   887                                  
   888                                  ;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   889                                  
   890 000003DD 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   891                                  
   892                                  ;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   893                                  
   894 000003E6 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   895                                  
   896                                  ;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   897                                  
   898 000003EF 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   899                                  
   900                                  ;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   901                                  
   902 000003F7 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   903                                  
   904                                  ;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   905                                  
   906 000003FF 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   907                                  
   908                                  ;-139 //  30: enter
   909                                  
   910                                  
   911                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};
   912                                  
   913 00000408 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   914                                  
   915                                  ;-141 // 100: directives
   916                                  
   917                                  
   918                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   919                                  
   920 00000410 4F52470065F1            I_ORG db 79,82,71,0,101,241
   921                                  
   922                                  ;-143 // section, segment .TEXT .DATA .BSS
   923                                  
   924                                  
   925                                  ;-144 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   926                                  
   927 00000416 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   928 0000041F F1                 
   929                                  
   930                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   931                                  
   932 00000420 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   933 00000429 F1                 
   934                                  
   935                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   936                                  
   937 0000042A 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   938 00000433 6EF1               
   939                                  
   940                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   941                                  
   942 00000435 444200C8F1              I_DB db 68,66,0,200,241
   943                                  
   944                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   945                                  
   946 0000043A 445700C9F1              I_DW db 68,87,0,201,241
   947                                  
   948                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   949                                  
   950 0000043F 444400CAF1              I_DD db 68,68,0,202,241
   951                                  
   952                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   953                                  
   954 00000444 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   955                                  
   956                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   957                                  
   958 0000044B 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   959                                  
   960                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   961                                  
   962 00000452 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   963                                  
   964                                  ;-153 char I_END=0;// end of table char
   965                                  
   966 00000459 00                      I_END db 0
   967                                  ;Back to main program: AS.C
   968                                  
   969                                  ;-4 #include "OPS.C"
   970                                  
   971                                  ;Use include file: OPS.C
   972                                  
   973                                  ;-1 int ChangeDirection() {
   974                                  
   975                                  
   976                                  ChangeDirection:  ; *** PROC ***
   977                                  
   978                                  ;-2     char c;
   979                                  
   980                                  
   981                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   982                                  
   983                                  ;Function : ChangeDirection, Number of local variables: 1
   984                                  ;   # type sign width line used address name   list of local variables
   985                                  ;  250 var sign byte     2 NULL bp-2    c;
   986 0000045A C8020000                 ENTER  2,0
   987 0000045E A0[2D00]                 mov al, [Op]
   988 00000461 8846FE                   mov byte [bp-2], al
   989 00000464 A0[2E00]                 mov al, [Op2]
   990 00000467 A2[2D00]                 mov byte [Op], al
   991 0000046A 8A46FE                   mov al, [bp-2]
   992 0000046D A2[2E00]                 mov byte [Op2], al
   993                                  
   994                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   995                                  
   996 00000470 A0[3600]                 mov al, [R1Type]
   997 00000473 8846FE                   mov byte [bp-2], al
   998 00000476 A0[3500]                 mov al, [R2Type]
   999 00000479 A2[3600]                 mov byte [R1Type], al
  1000 0000047C 8A46FE                   mov al, [bp-2]
  1001 0000047F A2[3500]                 mov byte [R2Type], al
  1002                                  
  1003                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
  1004                                  
  1005 00000482 A0[3400]                 mov al, [R1No]
  1006 00000485 8846FE                   mov byte [bp-2], al
  1007 00000488 A0[3300]                 mov al, [R2No]
  1008 0000048B A2[3400]                 mov byte [R1No], al
  1009 0000048E 8A46FE                   mov al, [bp-2]
  1010 00000491 A2[3300]                 mov byte [R2No], al
  1011                                  
  1012                                  ;-6     dflag=2;     
  1013                                  
  1014 00000494 66B802000000             mov eax, 2
  1015 0000049A A2[3900]                 mov byte [dflag], al
  1016                                  
  1017                                  ;-7 }
  1018                                  
  1019                                  
  1020                                  ;-8      
  1021                                  
  1022                                  
  1023                                  ;-9 int checkOpL() {
  1024 0000049D C9                       LEAVE
  1025 0000049E C3                       ret
  1026                                  ; ENDP
  1027                                  
  1028                                  checkOpL:  ; *** PROC ***
  1029                                  
  1030                                  ;-10     if (Op == ADR) implerror();
  1031                                  
  1032 0000049F A0[2D00]                 mov al, [Op]
  1033 000004A2 3C03                     cmp al, 3
  1034 000004A4 0F850300                 jne @@checkOpL1
  1035 000004A8 E8E115                   call implerror
  1036                                  
  1037                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  1038                                  
  1039                                  @@checkOpL1:
  1040 000004AB A0[3600]                 mov al, [R1Type]
  1041 000004AE 3C04                     cmp al, 4
  1042 000004B0 0F850600                 jne @@checkOpL2
  1043 000004B4 E89D16                   call segregerror
  1044 000004B7 E93E00                   jmp @@retn
  1045                                  
  1046                                  ;-12     setwflag();
  1047                                  
  1048                                  @@checkOpL2:
  1049 000004BA E8CB03                   call setwflag
  1050                                  
  1051                                  ;-13     if (OpSize == 0) error1("no op size declared");
  1052                                  
  1053 000004BD A0[3700]                 mov al, [OpSize]
  1054 000004C0 3C00                     cmp al, 0
  1055 000004C2 0F850900                 jne @@checkOpL3
  1056 000004C6 68[F904]                 push checkOpL_0
  1057 000004C9 E8F014                   call error1
  1058 000004CC 83C402                   add  sp, 2
  1059                                  
  1060                                  ;-14     if (OpSize == R1Type) return;
  1061                                  
  1062                                  @@checkOpL3:
  1063 000004CF A0[3700]                 mov al, [OpSize]
  1064 000004D2 3A06[3600]               cmp al, [R1Type]
  1065 000004D6 0F850300                 jne @@checkOpL4
  1066 000004DA E91B00                   jmp @@retn
  1067                                  
  1068                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1069                                  
  1070                                  @@checkOpL4:
  1071 000004DD A0[2D00]                 mov al, [Op]
  1072 000004E0 3C02                     cmp al, 2
  1073 000004E2 0F851200                 jne @@checkOpL5
  1074 000004E6 A0[3600]                 mov al, [R1Type]
  1075 000004E9 3C00                     cmp al, 0
  1076 000004EB 0F850900                 jne @@checkOpL6
  1077 000004EF 68[0D05]                 push checkOpL_1
  1078 000004F2 E8C714                   call error1
  1079 000004F5 83C402                   add  sp, 2
  1080                                  
  1081                                  ;-16 }
  1082                                  
  1083                                  @@checkOpL6:
  1084                                  @@checkOpL5:
  1085                                  
  1086                                  ;-17     
  1087                                  
  1088                                  
  1089                                  ;-18 int check2Ops() {
  1090                                  
  1091                                  @@retn:
  1092 000004F8 C3                       ret
  1093                                  ; ENDP
  1094 000004F9 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1095 00000502 65206465636C617265-
  1096 0000050B 6400               
  1097 0000050D 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1098 00000516 657220646566696E65-
  1099 0000051F 6400               
  1100                                  
  1101                                  check2Ops:  ; *** PROC ***
  1102                                  
  1103                                  ;-19     get2Ops();
  1104                                  
  1105 00000521 E84900                   call get2Ops
  1106                                  
  1107                                  ;-20     if (Op ==   0) addrerror();
  1108                                  
  1109 00000524 A0[2D00]                 mov al, [Op]
  1110 00000527 3C00                     cmp al, 0
  1111 00000529 0F850300                 jne @@check2Ops7
  1112 0000052D E81D15                   call addrerror
  1113                                  
  1114                                  ;-21     if (Op == ADR) invaloperror(); 
  1115                                  
  1116                                  @@check2Ops7:
  1117 00000530 A0[2D00]                 mov al, [Op]
  1118 00000533 3C03                     cmp al, 3
  1119 00000535 0F850300                 jne @@check2Ops8
  1120 00000539 E88B15                   call invaloperror
  1121                                  
  1122                                  ;-22     if (Op == IMM) immeerror();   
  1123                                  
  1124                                  @@check2Ops8:
  1125 0000053C A0[2D00]                 mov al, [Op]
  1126 0000053F 3C01                     cmp al, 1
  1127 00000541 0F850300                 jne @@check2Ops9
  1128 00000545 E81F15                   call immeerror
  1129                                  
  1130                                  ;-23     if (Op2==   0) addrerror();
  1131                                  
  1132                                  @@check2Ops9:
  1133 00000548 A0[2E00]                 mov al, [Op2]
  1134 0000054B 3C00                     cmp al, 0
  1135 0000054D 0F850300                 jne @@check2Ops10
  1136 00000551 E8F914                   call addrerror
  1137                                  
  1138                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           
  1139                                  
  1140                                  @@check2Ops10:
  1141 00000554 A0[2F00]                 mov al, [CodeType]
  1142 00000557 3C05                     cmp al, 5
  1143 00000559 0F840C00                 je  @@check2Ops11
  1144 0000055D A0[2E00]                 mov al, [Op2]
  1145 00000560 3C03                     cmp al, 3
  1146 00000562 0F850300                 jne @@check2Ops12
  1147 00000566 E85E15                   call invaloperror
  1148                                  
  1149                                  ;-25     setwflag();       
  1150                                  
  1151                                  @@check2Ops12:
  1152                                  @@check2Ops11:
  1153 00000569 E81C03                   call setwflag
  1154                                  
  1155                                  ;-26 }    
  1156                                  
  1157                                  
  1158                                  ;-27 int get2Ops() {
  1159                                  
  1160 0000056C C3                       ret
  1161                                  ; ENDP
  1162                                  
  1163                                  get2Ops:  ; *** PROC ***
  1164                                  
  1165                                  ;-28     getOpL();
  1166                                  
  1167 0000056D E80C00                   call getOpL
  1168                                  
  1169                                  ;-29     need(',');    
  1170                                  
  1171 00000570 6A2C                     push 44
  1172 00000572 E81E0A                   call need
  1173 00000575 83C402                   add  sp, 2
  1174                                  
  1175                                  ;-30     getOpR();         
  1176                                  
  1177 00000578 E83200                   call getOpR
  1178                                  
  1179                                  ;-31 } 
  1180                                  
  1181                                  
  1182                                  ;-32         
  1183                                  
  1184                                  
  1185                                  ;-33 int getOpL() {
  1186                                  
  1187 0000057B C3                       ret
  1188                                  ; ENDP
  1189                                  
  1190                                  getOpL:  ; *** PROC ***
  1191                                  
  1192                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1193                                  
  1194                                  
  1195                                  ;-35     getOpR();
  1196                                  
  1197 0000057C E82E00                   call getOpR
  1198                                  
  1199                                  ;-36     Op=Op2;         Op2=0;
  1200                                  
  1201 0000057F A0[2E00]                 mov al, [Op2]
  1202 00000582 A2[2D00]                 mov byte [Op], al
  1203 00000585 66B800000000             mov eax, 0
  1204 0000058B A2[2E00]                 mov byte [Op2], al
  1205                                  
  1206                                  ;-37     R1No=R2No;      R2No=0;
  1207                                  
  1208 0000058E A0[3300]                 mov al, [R2No]
  1209 00000591 A2[3400]                 mov byte [R1No], al
  1210 00000594 66B800000000             mov eax, 0
  1211 0000059A A2[3300]                 mov byte [R2No], al
  1212                                  
  1213                                  ;-38     R1Type=R2Type; R2Type=0; 
  1214                                  
  1215 0000059D A0[3500]                 mov al, [R2Type]
  1216 000005A0 A2[3600]                 mov byte [R1Type], al
  1217 000005A3 66B800000000             mov eax, 0
  1218 000005A9 A2[3500]                 mov byte [R2Type], al
  1219                                  
  1220                                  ;-39 }  
  1221                                  
  1222                                  
  1223                                  ;-40 
  1224                                  
  1225                                  
  1226                                  ;-41 int getOpR() {
  1227                                  
  1228 000005AC C3                       ret
  1229                                  ; ENDP
  1230                                  
  1231                                  getOpR:  ; *** PROC ***
  1232                                  
  1233                                  ;-42     Op2=getOp1();
  1234                                  
  1235 000005AD E88900                   call getOp1
  1236 000005B0 A2[2E00]                 mov byte [Op2], al
  1237                                  
  1238                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1239                                  
  1240 000005B3 6A5B                     push 91
  1241 000005B5 E8AD09                   call isToken
  1242 000005B8 83C402                   add  sp, 2
  1243 000005BB 08C0                     or  al, al
  1244 000005BD 0F840F00                 je @@getOpR13
  1245 000005C1 66B804000000             mov eax, 4
  1246 000005C7 A2[2E00]                 mov byte [Op2], al
  1247 000005CA E8F200                   call getMEM
  1248 000005CD E94F00                   jmp @@retn
  1249                                  
  1250                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1251                                  
  1252                                  @@getOpR13:
  1253 000005D0 A0[2E00]                 mov al, [Op2]
  1254 000005D3 3C00                     cmp al, 0
  1255 000005D5 0F850600                 jne @@getOpR14
  1256 000005D9 E8EB14                   call invaloperror
  1257 000005DC E94000                   jmp @@retn
  1258                                  
  1259                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1260                                  
  1261                                  @@getOpR14:
  1262 000005DF A0[2E00]                 mov al, [Op2]
  1263 000005E2 3C01                     cmp al, 1
  1264 000005E4 0F850900                 jne @@getOpR15
  1265 000005E8 A1[0E00]                 mov ax, [SymbolInt]
  1266 000005EB A3[3F00]                 mov word [imme], ax
  1267 000005EE E92E00                   jmp @@retn
  1268                                  
  1269                                  ;-46     if (Op2 == REG)                            return;
  1270                                  
  1271                                  @@getOpR15:
  1272 000005F1 A0[2E00]                 mov al, [Op2]
  1273 000005F4 3C02                     cmp al, 2
  1274 000005F6 0F850300                 jne @@getOpR16
  1275 000005FA E92200                   jmp @@retn
  1276                                  
  1277                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1278                                  
  1279                                  @@getOpR16:
  1280 000005FD A0[2E00]                 mov al, [Op2]
  1281 00000600 3C03                     cmp al, 3
  1282 00000602 0F851000                 jne @@getOpR17
  1283 00000606 8B1E[4A00]               mov bx, [LabelIx]
  1284 0000060A D1E3                     shl bx, 1
  1285 0000060C 8B87DB86                 mov ax, [LabelAddr + bx]
  1286 00000610 A3[3D00]                 mov word [disp], ax
  1287 00000613 E90900                   jmp @@retn
  1288                                  
  1289                                  ;-48     error1("Name of operand expected");
  1290                                  
  1291                                  @@getOpR17:
  1292 00000616 68[2006]                 push getOpR_0
  1293 00000619 E8A013                   call error1
  1294 0000061C 83C402                   add  sp, 2
  1295                                  
  1296                                  ;-49 }
  1297                                  
  1298                                  
  1299                                  ;-50 
  1300                                  
  1301                                  
  1302                                  ;-51 int getOp1() {//scan for a single operand
  1303                                  
  1304                                  @@retn:
  1305 0000061F C3                       ret
  1306                                  ; ENDP
  1307 00000620 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1308 00000629 706572616E64206578-
  1309 00000632 70656374656400     
  1310                                  
  1311                                  getOp1:  ; *** PROC ***
  1312                                  
  1313                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1314                                  
  1315                                  
  1316                                  ;-53 //set   :R2Type, R2No by testReg
  1317                                  
  1318                                  
  1319                                  ;-54 //set   :LabelIx by searchLabel
  1320                                  
  1321                                  
  1322                                  ;-55     if (TokeType == 0)      return 0;
  1323                                  
  1324 00000639 A0[2C00]                 mov al, [TokeType]
  1325 0000063C 3C00                     cmp al, 0
  1326 0000063E 0F850900                 jne @@getOp118
  1327 00000642 66B800000000             mov eax, 0
  1328 00000648 E96000                   jmp @@retn
  1329                                  
  1330                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1331                                  
  1332                                  @@getOp118:
  1333 0000064B A0[2C00]                 mov al, [TokeType]
  1334 0000064E 3C01                     cmp al, 1
  1335 00000650 0F850900                 jne @@getOp119
  1336 00000654 66B801000000             mov eax, 1
  1337 0000065A E94E00                   jmp @@retn
  1338                                  
  1339                                  ;-57     if (TokeType == ALNUME) {
  1340                                  
  1341                                  @@getOp119:
  1342 0000065D A0[2C00]                 mov al, [TokeType]
  1343 00000660 3C03                     cmp al, 3
  1344 00000662 0F853C00                 jne @@getOp120
  1345                                  
  1346                                  ;-58         R2No=testReg();
  1347                                  
  1348 00000666 E8A90C                   call testReg
  1349 00000669 A2[3300]                 mov byte [R2No], al
  1350                                  
  1351                                  ;-59         if (R2Type)        return REG;
  1352                                  
  1353 0000066C A0[3500]                 mov al, [R2Type]
  1354 0000066F 08C0                     or  al, al
  1355 00000671 0F840900                 je @@getOp121
  1356 00000675 66B802000000             mov eax, 2
  1357 0000067B E92D00                   jmp @@retn
  1358                                  
  1359                                  ;-60         LabelIx=searchLabel();
  1360                                  
  1361                                  @@getOp121:
  1362 0000067E E8F005                   call searchLabel
  1363 00000681 A3[4A00]                 mov word [LabelIx], ax
  1364                                  
  1365                                  ;-61         if (LabelIx)        return ADR;
  1366                                  
  1367 00000684 A1[4A00]                 mov ax, [LabelIx]
  1368 00000687 08C0                     or  al, al
  1369 00000689 0F840C00                 je @@getOp122
  1370 0000068D 66B803000000             mov eax, 3
  1371 00000693 E91500                   jmp @@retn
  1372                                  
  1373                                  ;-62         else error1("variable not found"); 
  1374                                  
  1375 00000696 E90900                   jmp @@getOp123
  1376                                  @@getOp122:
  1377 00000699 68[AC06]                 push getOp1_0
  1378 0000069C E81D13                   call error1
  1379 0000069F 83C402                   add  sp, 2
  1380                                  
  1381                                  ;-63     }
  1382                                  
  1383                                  @@getOp123:
  1384                                  
  1385                                  ;-64     return 0;
  1386                                  
  1387                                  @@getOp120:
  1388 000006A2 66B800000000             mov eax, 0
  1389 000006A8 E90000                   jmp @@retn
  1390                                  
  1391                                  ;-65 }
  1392                                  
  1393                                  
  1394                                  ;-66 
  1395                                  
  1396                                  
  1397                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1398                                  
  1399                                  @@retn:
  1400 000006AB C3                       ret
  1401                                  ; ENDP
  1402 000006AC 7661726961626C6520-     getOp1_0 db "variable not found",0
  1403 000006B5 6E6F7420666F756E64-
  1404 000006BE 00                 
  1405                                  
  1406                                  getMEM:  ; *** PROC ***
  1407                                  
  1408                                  ;-68 //set: disp, rm, R2Type
  1409                                  
  1410                                  
  1411                                  ;-69     char c;
  1412                                  
  1413                                  
  1414                                  ;-70     disp=0; rm=0;
  1415                                  
  1416                                  ;Function : getMEM, Number of local variables: 1
  1417                                  ;   # type sign width line used address name   list of local variables
  1418                                  ;  250 var sign byte    69 NULL bp-2    c;
  1419 000006BF C8020000                 ENTER  2,0
  1420 000006C3 66B800000000             mov eax, 0
  1421 000006C9 A3[3D00]                 mov word [disp], ax
  1422 000006CC 66B800000000             mov eax, 0
  1423 000006D2 A2[3B00]                 mov byte [rm], al
  1424                                  
  1425                                  ;-71     do {
  1426                                  
  1427                                  @@getMEM24:
  1428                                  
  1429                                  ;-72         getTokeType();
  1430                                  
  1431 000006D5 E8D203                   call getTokeType
  1432                                  
  1433                                  ;-73         c=getOp1();
  1434                                  
  1435 000006D8 E85EFF                   call getOp1
  1436 000006DB 8846FE                   mov byte [bp-2], al
  1437                                  
  1438                                  ;-74         if (c ==   0) syntaxerror();
  1439                                  
  1440 000006DE 8A46FE                   mov al, [bp-2]
  1441 000006E1 3C00                     cmp al, 0
  1442 000006E3 0F850300                 jne @@getMEM25
  1443 000006E7 E89114                   call syntaxerror
  1444                                  
  1445                                  ;-75         if (c == REG) {
  1446                                  
  1447                                  @@getMEM25:
  1448 000006EA 8A46FE                   mov al, [bp-2]
  1449 000006ED 3C02                     cmp al, 2
  1450 000006EF 0F851E00                 jne @@getMEM26
  1451                                  
  1452                                  ;-76             isDirect=0;
  1453                                  
  1454 000006F3 66B800000000             mov eax, 0
  1455 000006F9 A2[3C00]                 mov byte [isDirect], al
  1456                                  
  1457                                  ;-77             if (rm) rm=getIndReg2();
  1458                                  
  1459 000006FC A0[3B00]                 mov al, [rm]
  1460 000006FF 08C0                     or  al, al
  1461 00000701 0F840900                 je @@getMEM27
  1462 00000705 E8F300                   call getIndReg2
  1463 00000708 A2[3B00]                 mov byte [rm], al
  1464                                  
  1465                                  ;-78             else getIndReg1();
  1466                                  
  1467 0000070B E90300                   jmp @@getMEM28
  1468                                  @@getMEM27:
  1469 0000070E E88900                   call getIndReg1
  1470                                  
  1471                                  ;-79         }
  1472                                  
  1473                                  @@getMEM28:
  1474                                  
  1475                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1476                                  
  1477                                  @@getMEM26:
  1478 00000711 8A46FE                   mov al, [bp-2]
  1479 00000714 3C03                     cmp al, 3
  1480 00000716 0F851000                 jne @@getMEM29
  1481 0000071A A1[3D00]                 mov ax, [disp]
  1482 0000071D 8B1E[4A00]               mov bx, [LabelIx]
  1483 00000721 D1E3                     shl bx, 1
  1484 00000723 0387DB86                 add ax, [LabelAddr + bx]
  1485 00000727 A3[3D00]                 mov word [disp], ax
  1486                                  
  1487                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1488                                  
  1489                                  @@getMEM29:
  1490 0000072A 8A46FE                   mov al, [bp-2]
  1491 0000072D 3C01                     cmp al, 1
  1492 0000072F 0F850A00                 jne @@getMEM30
  1493 00000733 A1[3D00]                 mov ax, [disp]
  1494 00000736 0306[0E00]               add ax, [SymbolInt]
  1495 0000073A A3[3D00]                 mov word [disp], ax
  1496                                  
  1497                                  ;-82         if (isToken('-')) {
  1498                                  
  1499                                  @@getMEM30:
  1500 0000073D 6A2D                     push 45
  1501 0000073F E82308                   call isToken
  1502 00000742 83C402                   add  sp, 2
  1503 00000745 08C0                     or  al, al
  1504 00000747 0F841900                 je @@getMEM31
  1505                                  
  1506                                  ;-83             getTokeType();
  1507                                  
  1508 0000074B E85C03                   call getTokeType
  1509                                  
  1510                                  ;-84             if (TokeType != DIGIT) numbererror();
  1511                                  
  1512 0000074E A0[2C00]                 mov al, [TokeType]
  1513 00000751 3C01                     cmp al, 1
  1514 00000753 0F840300                 je  @@getMEM32
  1515 00000757 E88E13                   call numbererror
  1516                                  
  1517                                  ;-85             disp = disp - SymbolInt;
  1518                                  
  1519                                  @@getMEM32:
  1520 0000075A A1[3D00]                 mov ax, [disp]
  1521 0000075D 2B06[0E00]               sub ax, [SymbolInt]
  1522 00000761 A3[3D00]                 mov word [disp], ax
  1523                                  
  1524                                  ;-86         }
  1525                                  
  1526                                  
  1527                                  ;-87     } while (isToken('+'));
  1528                                  
  1529                                  @@getMEM31:
  1530 00000764 6A2B                     push 43
  1531 00000766 E8FC07                   call isToken
  1532 00000769 83C402                   add  sp, 2
  1533 0000076C 08C0                     or  al, al
  1534 0000076E 0F840300                 je @@getMEM33
  1535 00000772 E960FF                   jmp @@getMEM24
  1536                                  @@getMEM33:
  1537                                  
  1538                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1539                                  
  1540 00000775 6A5D                     push 93
  1541 00000777 E8EB07                   call isToken
  1542 0000077A 83C402                   add  sp, 2
  1543 0000077D 83F800                   cmp ax, 0
  1544 00000780 0F850900                 jne @@getMEM34
  1545 00000784 68[8F07]                 push getMEM_0
  1546 00000787 E89112                   call errorexit
  1547 0000078A 83C402                   add  sp, 2
  1548                                  
  1549                                  ;-89 }
  1550                                  
  1551                                  @@getMEM34:
  1552                                  
  1553                                  ;-90 int getIndReg1() {
  1554 0000078D C9                       LEAVE
  1555 0000078E C3                       ret
  1556                                  ; ENDP
  1557 0000078F 5D2065787065637465-     getMEM_0 db "] expected",0
  1558 00000798 6400               
  1559                                  
  1560                                  getIndReg1:  ; *** PROC ***
  1561                                  
  1562                                  ;-91     if (R2Type !=WORD) indexerror();
  1563                                  
  1564 0000079A A0[3500]                 mov al, [R2Type]
  1565 0000079D 3C02                     cmp al, 2
  1566 0000079F 0F840300                 je  @@getIndReg135
  1567 000007A3 E80013                   call indexerror
  1568                                  
  1569                                  ;-92     if (R2No==3) rm=7;//BX
  1570                                  
  1571                                  @@getIndReg135:
  1572 000007A6 A0[3300]                 mov al, [R2No]
  1573 000007A9 3C03                     cmp al, 3
  1574 000007AB 0F850900                 jne @@getIndReg136
  1575 000007AF 66B807000000             mov eax, 7
  1576 000007B5 A2[3B00]                 mov byte [rm], al
  1577                                  
  1578                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1579                                  
  1580                                  @@getIndReg136:
  1581 000007B8 A0[3300]                 mov al, [R2No]
  1582 000007BB 3C05                     cmp al, 5
  1583 000007BD 0F850900                 jne @@getIndReg137
  1584 000007C1 66B806000000             mov eax, 6
  1585 000007C7 A2[3B00]                 mov byte [rm], al
  1586                                  
  1587                                  ;-94     if (R2No==7) rm=5;//DI
  1588                                  
  1589                                  @@getIndReg137:
  1590 000007CA A0[3300]                 mov al, [R2No]
  1591 000007CD 3C07                     cmp al, 7
  1592 000007CF 0F850900                 jne @@getIndReg138
  1593 000007D3 66B805000000             mov eax, 5
  1594 000007D9 A2[3B00]                 mov byte [rm], al
  1595                                  
  1596                                  ;-95     if (R2No==6) rm=4;//SI
  1597                                  
  1598                                  @@getIndReg138:
  1599 000007DC A0[3300]                 mov al, [R2No]
  1600 000007DF 3C06                     cmp al, 6
  1601 000007E1 0F850900                 jne @@getIndReg139
  1602 000007E5 66B804000000             mov eax, 4
  1603 000007EB A2[3B00]                 mov byte [rm], al
  1604                                  
  1605                                  ;-96     if (rm==0) indexerror();
  1606                                  
  1607                                  @@getIndReg139:
  1608 000007EE A0[3B00]                 mov al, [rm]
  1609 000007F1 3C00                     cmp al, 0
  1610 000007F3 0F850300                 jne @@getIndReg140
  1611 000007F7 E8AC12                   call indexerror
  1612                                  
  1613                                  ;-97 }
  1614                                  
  1615                                  @@getIndReg140:
  1616                                  
  1617                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1618                                  
  1619 000007FA C3                       ret
  1620                                  ; ENDP
  1621                                  
  1622                                  getIndReg2:  ; *** PROC ***
  1623                                  ;Function : getIndReg2, Number of local variables: 1
  1624                                  ;   # type sign width line used address name   list of local variables
  1625                                  ;  250 var sign byte    98 NULL bp-2    m;
  1626 000007FB C8020000                 ENTER  2,0
  1627 000007FF 66B804000000             mov eax, 4
  1628 00000805 8846FE                   mov byte [bp-2], al
  1629                                  
  1630                                  ;-99     if (R2Type !=WORD) indexerror();
  1631                                  
  1632 00000808 A0[3500]                 mov al, [R2Type]
  1633 0000080B 3C02                     cmp al, 2
  1634 0000080D 0F840300                 je  @@getIndReg241
  1635 00000811 E89212                   call indexerror
  1636                                  
  1637                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1638                                  
  1639                                  @@getIndReg241:
  1640 00000814 A0[3300]                 mov al, [R2No]
  1641 00000817 3C07                     cmp al, 7
  1642 00000819 0F852700                 jne @@getIndReg242
  1643 0000081D A0[3B00]                 mov al, [rm]
  1644 00000820 3C06                     cmp al, 6
  1645 00000822 0F850C00                 jne @@getIndReg243
  1646 00000826 66B803000000             mov eax, 3
  1647 0000082C 8846FE                   mov byte [bp-2], al
  1648                                  
  1649                                  ;-101              else if (rm==7) m=1;//BX+DI
  1650                                  
  1651 0000082F E91200                   jmp @@getIndReg244
  1652                                  @@getIndReg243:
  1653 00000832 A0[3B00]                 mov al, [rm]
  1654 00000835 3C07                     cmp al, 7
  1655 00000837 0F850900                 jne @@getIndReg245
  1656 0000083B 66B801000000             mov eax, 1
  1657 00000841 8846FE                   mov byte [bp-2], al
  1658                                  
  1659                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1660                                  
  1661                                  @@getIndReg245:
  1662                                  @@getIndReg244:
  1663                                  @@getIndReg242:
  1664 00000844 A0[3300]                 mov al, [R2No]
  1665 00000847 3C06                     cmp al, 6
  1666 00000849 0F852700                 jne @@getIndReg246
  1667 0000084D A0[3B00]                 mov al, [rm]
  1668 00000850 3C06                     cmp al, 6
  1669 00000852 0F850C00                 jne @@getIndReg247
  1670 00000856 66B802000000             mov eax, 2
  1671 0000085C 8846FE                   mov byte [bp-2], al
  1672                                  
  1673                                  ;-103              else if (rm==7) m=0;//BX+SI
  1674                                  
  1675 0000085F E91200                   jmp @@getIndReg248
  1676                                  @@getIndReg247:
  1677 00000862 A0[3B00]                 mov al, [rm]
  1678 00000865 3C07                     cmp al, 7
  1679 00000867 0F850900                 jne @@getIndReg249
  1680 0000086B 66B800000000             mov eax, 0
  1681 00000871 8846FE                   mov byte [bp-2], al
  1682                                  
  1683                                  ;-104     if (m > 3) indexerror();
  1684                                  
  1685                                  @@getIndReg249:
  1686                                  @@getIndReg248:
  1687                                  @@getIndReg246:
  1688 00000874 8A46FE                   mov al, [bp-2]
  1689 00000877 3C03                     cmp al, 3
  1690 00000879 0F8E0300                 jle @@getIndReg250
  1691 0000087D E82612                   call indexerror
  1692                                  
  1693                                  ;-105     return m;
  1694                                  
  1695                                  @@getIndReg250:
  1696 00000880 8A46FE                   mov al, [bp-2]
  1697 00000883 E90000                   jmp @@retn
  1698                                  
  1699                                  ;-106 }
  1700                                  
  1701                                  
  1702                                  ;-107                   
  1703                                  
  1704                                  
  1705                                  ;-108 int setwflag() {//word size, bit 0
  1706                                  
  1707 00000886 C9                      @@retn: LEAVE
  1708 00000887 C3                       ret
  1709                                  ; ENDP
  1710                                  
  1711                                  setwflag:  ; *** PROC ***
  1712                                  
  1713                                  ;-109     wflag=0;
  1714                                  
  1715 00000888 66B800000000             mov eax, 0
  1716 0000088E A2[3800]                 mov byte [wflag], al
  1717                                  
  1718                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1719                                  
  1720 00000891 A0[3700]                 mov al, [OpSize]
  1721 00000894 3C00                     cmp al, 0
  1722 00000896 0F854200                 jne @@setwflag51
  1723                                  
  1724                                  ;-111         if (Op == REG) OpSize=R1Type;
  1725                                  
  1726 0000089A A0[2D00]                 mov al, [Op]
  1727 0000089D 3C02                     cmp al, 2
  1728 0000089F 0F850600                 jne @@setwflag52
  1729 000008A3 A0[3600]                 mov al, [R1Type]
  1730 000008A6 A2[3700]                 mov byte [OpSize], al
  1731                                  
  1732                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1733                                  
  1734                                  @@setwflag52:
  1735 000008A9 A0[2E00]                 mov al, [Op2]
  1736 000008AC 3C02                     cmp al, 2
  1737 000008AE 0F850600                 jne @@setwflag53
  1738 000008B2 A0[3500]                 mov al, [R2Type]
  1739 000008B5 A2[3700]                 mov byte [OpSize], al
  1740                                  
  1741                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1742                                  
  1743                                  @@setwflag53:
  1744 000008B8 A0[3500]                 mov al, [R2Type]
  1745 000008BB 3C04                     cmp al, 4
  1746 000008BD 0F850900                 jne @@setwflag54
  1747 000008C1 66B802000000             mov eax, 2
  1748 000008C7 A2[3700]                 mov byte [OpSize], al
  1749                                  
  1750                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1751                                  
  1752                                  @@setwflag54:
  1753 000008CA A0[3600]                 mov al, [R1Type]
  1754 000008CD 3C04                     cmp al, 4
  1755 000008CF 0F850900                 jne @@setwflag55
  1756 000008D3 66B802000000             mov eax, 2
  1757 000008D9 A2[3700]                 mov byte [OpSize], al
  1758                                  
  1759                                  ;-115     }
  1760                                  
  1761                                  @@setwflag55:
  1762                                  
  1763                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1764                                  
  1765                                  @@setwflag51:
  1766 000008DC A0[3700]                 mov al, [OpSize]
  1767 000008DF 3C03                     cmp al, 3
  1768 000008E1 0F850C00                 jne @@setwflag56
  1769 000008E5 E8B417                   call gen66h
  1770 000008E8 66B801000000             mov eax, 1
  1771 000008EE A2[3800]                 mov byte [wflag], al
  1772                                  
  1773                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1774                                  
  1775                                  @@setwflag56:
  1776 000008F1 A0[3700]                 mov al, [OpSize]
  1777 000008F4 3C02                     cmp al, 2
  1778 000008F6 0F850900                 jne @@setwflag57
  1779 000008FA 66B801000000             mov eax, 1
  1780 00000900 A2[3800]                 mov byte [wflag], al
  1781                                  
  1782                                  ;-118 }
  1783                                  
  1784                                  @@setwflag57:
  1785                                  
  1786                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1787                                  
  1788 00000903 C3                       ret
  1789                                  ; ENDP
  1790                                  
  1791                                  setsflag:  ; *** PROC ***
  1792                                  
  1793                                  ;-120     unsigned int ui;    
  1794                                  
  1795                                  
  1796                                  ;-121     sflag=2;   
  1797                                  
  1798                                  ;Function : setsflag, Number of local variables: 1
  1799                                  ;   # type sign width line used address name   list of local variables
  1800                                  ;  250 var unsg word   120 NULL bp-2    ui;
  1801 00000904 C8020000                 ENTER  2,0
  1802 00000908 66B802000000             mov eax, 2
  1803 0000090E A2[3A00]                 mov byte [sflag], al
  1804                                  
  1805                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1806                                  
  1807 00000911 A1[3F00]                 mov ax, [imme]
  1808 00000914 2580FF                   and ax, 65408
  1809 00000917 8946FE                   mov word [bp-2], ax
  1810                                  
  1811                                  ;-123     if(ui != 0) sflag = 0;
  1812                                  
  1813 0000091A 8B46FE                   mov ax, [bp-2]
  1814 0000091D 83F800                   cmp ax, 0
  1815 00000920 0F840900                 je  @@setsflag58
  1816 00000924 66B800000000             mov eax, 0
  1817 0000092A A2[3A00]                 mov byte [sflag], al
  1818                                  
  1819                                  ;-124     if (OpSize == BYTE) {
  1820                                  
  1821                                  @@setsflag58:
  1822 0000092D A0[3700]                 mov al, [OpSize]
  1823 00000930 3C01                     cmp al, 1
  1824 00000932 0F851C00                 jne @@setsflag59
  1825                                  
  1826                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1827                                  
  1828 00000936 A1[3F00]                 mov ax, [imme]
  1829 00000939 3DFF00                   cmp ax, 255
  1830 0000093C 0F8E0900                 jle @@setsflag60
  1831 00000940 68[5409]                 push setsflag_0
  1832 00000943 E87610                   call error1
  1833 00000946 83C402                   add  sp, 2
  1834                                  
  1835                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1836                                  
  1837                                  @@setsflag60:
  1838 00000949 66B800000000             mov eax, 0
  1839 0000094F A2[3A00]                 mov byte [sflag], al
  1840                                  
  1841                                  ;-127     }
  1842                                  
  1843                                  
  1844                                  ;-128 }
  1845                                  
  1846                                  @@setsflag59:
  1847                                  
  1848                                  ;-129 int checkConstSize(unsigned int ui) {    
  1849 00000952 C9                       LEAVE
  1850 00000953 C3                       ret
  1851                                  ; ENDP
  1852 00000954 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1853 0000095D 6F7220627974652072-
  1854 00000966 2F6D00             
  1855                                  
  1856                                  checkConstSize:  ; *** PROC ***
  1857                                  
  1858                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1859                                  
  1860                                  ;Function : checkConstSize, Number of local variables: 1
  1861                                  ;   # type sign width line used address name   list of local variables
  1862                                  ;  250 var unsg word   129 NULL bp+4    ui;
  1863 00000969 C8000000                 ENTER  0,0
  1864 0000096D 8B4604                   mov ax, [bp+4]
  1865 00000970 83F87F                   cmp ax, 127
  1866 00000973 0F8E0900                 jle @@checkConstSize61
  1867 00000977 66B800000000             mov eax, 0
  1868 0000097D E91C00                   jmp @@retn
  1869                                  
  1870                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1871                                  
  1872                                  @@checkConstSize61:
  1873 00000980 8B4604                   mov ax, [bp+4]
  1874 00000983 3D80FF                   cmp ax, 65408
  1875 00000986 0F8D0900                 jge @@checkConstSize62
  1876 0000098A 66B800000000             mov eax, 0
  1877 00000990 E90900                   jmp @@retn
  1878                                  
  1879                                  ;-132     return 2;// is short        
  1880                                  
  1881                                  @@checkConstSize62:
  1882 00000993 66B802000000             mov eax, 2
  1883 00000999 E90000                   jmp @@retn
  1884                                  
  1885                                  ;-133 }
  1886                                  
  1887 0000099C C9                      @@retn: LEAVE
  1888 0000099D C3                       ret
  1889                                  ; ENDP
  1890                                  ;Back to main program: AS.C
  1891                                  
  1892                                  ;-5 #include "PARSE.C"
  1893                                  
  1894                                  ;Use include file: PARSE.C
  1895                                  
  1896                                  ;-1 int parse() {
  1897                                  
  1898                                  
  1899                                  parse:  ; *** PROC ***
  1900                                  
  1901                                  ;-2     LabelNamePtr  = &LabelNames;    
  1902                                  
  1903 0000099E B83B77                   mov ax, LabelNames
  1904 000009A1 A3[4600]                 mov word [LabelNamePtr], ax
  1905                                  
  1906                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1907                                  
  1908 000009A4 B88B8B                   mov ax, JmpCallNames
  1909 000009A7 A3[4C00]                 mov word [JmpCallNamePtr], ax
  1910                                  
  1911                                  ;-4     LabelMaxIx=0;    
  1912                                  
  1913 000009AA 66B800000000             mov eax, 0
  1914 000009B0 A3[4800]                 mov word [LabelMaxIx], ax
  1915                                  
  1916                                  ;-5     JmpCallMaxIx=0;  
  1917                                  
  1918 000009B3 66B800000000             mov eax, 0
  1919 000009B9 A3[4E00]                 mov word [JmpCallMaxIx], ax
  1920                                  
  1921                                  ;-6     BinLen=0;
  1922                                  
  1923 000009BC 66B800000000             mov eax, 0
  1924 000009C2 A3[5000]                 mov word [BinLen], ax
  1925                                  
  1926                                  ;-7     
  1927                                  
  1928                                  
  1929                                  ;-8     do {//process a new line
  1930                                  
  1931                                  @@parse63:
  1932                                  
  1933                                  ;-9         PCStart=PC; 
  1934                                  
  1935 000009C5 A1[2300]                 mov ax, [PC]
  1936 000009C8 A3[2900]                 mov word [PCStart], ax
  1937                                  
  1938                                  ;-10         OpSize=0;
  1939                                  
  1940 000009CB 66B800000000             mov eax, 0
  1941 000009D1 A2[3700]                 mov byte [OpSize], al
  1942                                  
  1943                                  ;-11         OpPrintIndex=0; 
  1944                                  
  1945 000009D4 66B800000000             mov eax, 0
  1946 000009DA A3[4100]                 mov word [OpPrintIndex], ax
  1947                                  
  1948                                  ;-12         PrintRA=' ';
  1949                                  
  1950 000009DD 66B820000000             mov eax, 32
  1951 000009E3 A2[4500]                 mov byte [PrintRA], al
  1952                                  
  1953                                  ;-13         getLine();
  1954                                  
  1955 000009E6 E81206                   call getLine
  1956                                  
  1957                                  ;-14         InputPtr = &InputBuf;
  1958                                  
  1959 000009E9 B86E75                   mov ax, InputBuf
  1960 000009EC A3[1400]                 mov word [InputPtr], ax
  1961                                  
  1962                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1963                                  
  1964 000009EF E8B800                   call getTokeType
  1965                                  
  1966                                  ;-16         if (TokeType == ALNUME) {
  1967                                  
  1968 000009F2 A0[2C00]                 mov al, [TokeType]
  1969 000009F5 3C03                     cmp al, 3
  1970 000009F7 0F851300                 jne @@parse64
  1971                                  
  1972                                  ;-17             if (isLabel) {//set in getName
  1973                                  
  1974 000009FB A0[2B00]                 mov al, [isLabel]
  1975 000009FE 08C0                     or  al, al
  1976 00000A00 0F840A00                 je @@parse65
  1977                                  
  1978                                  ;-18                 storeLabel();
  1979                                  
  1980 00000A04 E8C301                   call storeLabel
  1981                                  
  1982                                  ;-19                 InputPtr++;//remove :
  1983                                  
  1984 00000A07 FF06[1400]               inc  word [InputPtr]
  1985                                  
  1986                                  ;-20                 getTokeType();
  1987                                  
  1988 00000A0B E89C00                   call getTokeType
  1989                                  
  1990                                  ;-21             }
  1991                                  
  1992                                  
  1993                                  ;-22         }
  1994                                  
  1995                                  @@parse65:
  1996                                  
  1997                                  ;-23         if (TokeType == ALNUME) {
  1998                                  
  1999                                  @@parse64:
  2000 00000A0E A0[2C00]                 mov al, [TokeType]
  2001 00000A11 3C03                     cmp al, 3
  2002 00000A13 0F851B00                 jne @@parse66
  2003                                  
  2004                                  ;-24             lookCode();// and OpCodePtr
  2005                                  
  2006 00000A17 E84E04                   call lookCode
  2007                                  
  2008                                  ;-25             if(CodeType) process();
  2009                                  
  2010 00000A1A A0[2F00]                 mov al, [CodeType]
  2011 00000A1D 08C0                     or  al, al
  2012 00000A1F 0F840600                 je @@parse67
  2013 00000A23 E8A018                   call process
  2014                                  
  2015                                  ;-26             else getVariable();
  2016                                  
  2017 00000A26 E90300                   jmp @@parse68
  2018                                  @@parse67:
  2019 00000A29 E89F02                   call getVariable
  2020                                  
  2021                                  ;-27             skipRest();
  2022                                  
  2023                                  @@parse68:
  2024 00000A2C E8A305                   call skipRest
  2025                                  
  2026                                  ;-28         }
  2027                                  
  2028                                  
  2029                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  2030                                  
  2031 00000A2F E92700                   jmp @@parse69
  2032                                  @@parse66:
  2033 00000A32 A0[2C00]                 mov al, [TokeType]
  2034 00000A35 3C03                     cmp al, 3
  2035 00000A37 0F8E0C00                 jle @@parse70
  2036 00000A3B 68[6A0A]                 push parse_0
  2037 00000A3E E87B0F                   call error1
  2038 00000A41 83C402                   add  sp, 2
  2039                                  
  2040                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  2041                                  
  2042 00000A44 E91200                   jmp @@parse71
  2043                                  @@parse70:
  2044 00000A47 A0[2C00]                 mov al, [TokeType]
  2045 00000A4A 3C01                     cmp al, 1
  2046 00000A4C 0F850900                 jne @@parse72
  2047 00000A50 68[880A]                 push parse_1
  2048 00000A53 E8660F                   call error1
  2049 00000A56 83C402                   add  sp, 2
  2050                                  
  2051                                  ;-31         printLine();
  2052                                  
  2053                                  @@parse72:
  2054                                  @@parse71:
  2055                                  @@parse69:
  2056 00000A59 E8F20C                   call printLine
  2057                                  
  2058                                  ;-32     } while (DOS_NoBytes != 0 );
  2059                                  
  2060 00000A5C A1[2000]                 mov ax, [DOS_NoBytes]
  2061 00000A5F 83F800                   cmp ax, 0
  2062 00000A62 0F840300                 je  @@parse73
  2063 00000A66 E95CFF                   jmp @@parse63
  2064                                  @@parse73:
  2065                                  
  2066                                  ;-33 }
  2067                                  
  2068                                  
  2069                                  ;-34 
  2070                                  
  2071                                  
  2072                                  ;-35 int getTokeType() { 
  2073                                  
  2074 00000A69 C3                       ret
  2075                                  ; ENDP
  2076 00000A6A 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2077 00000A73 696E73747275637469-
  2078 00000A7C 6F6E20657870656374-
  2079 00000A85 656400             
  2080 00000A88 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2081 00000A91 616C6C6F7765642061-
  2082 00000A9A 74207374617274206F-
  2083 00000AA3 66206C696E6500     
  2084                                  
  2085                                  getTokeType:  ; *** PROC ***
  2086                                  
  2087                                  ;-36     char c;
  2088                                  
  2089                                  
  2090                                  ;-37     skipBlank();
  2091                                  
  2092                                  ;Function : getTokeType, Number of local variables: 1
  2093                                  ;   # type sign width line used address name   list of local variables
  2094                                  ;  250 var sign byte    36 NULL bp-2    c;
  2095 00000AAA C8020000                 ENTER  2,0
  2096 00000AAE E84C06                   call skipBlank
  2097                                  
  2098                                  ;-38     c = *InputPtr;
  2099                                  
  2100 00000AB1 8B1E[1400]               mov bx, [InputPtr]
  2101 00000AB5 8A07                     mov al, [bx]
  2102 00000AB7 B400                     mov ah, 0
  2103 00000AB9 8846FE                   mov byte [bp-2], al
  2104                                  
  2105                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2106                                  
  2107 00000ABC 8A46FE                   mov al, [bp-2]
  2108 00000ABF 3C00                     cmp al, 0
  2109 00000AC1 0F850C00                 jne @@getTokeType74
  2110 00000AC5 66B800000000             mov eax, 0
  2111 00000ACB A2[2C00]                 mov byte [TokeType], al
  2112 00000ACE E97200                   jmp @@retn
  2113                                  
  2114                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2115                                  
  2116                                  @@getTokeType74:
  2117 00000AD1 8A46FE                   mov al, [bp-2]
  2118 00000AD4 3C3B                     cmp al, 59
  2119 00000AD6 0F850C00                 jne @@getTokeType75
  2120 00000ADA 66B800000000             mov eax, 0
  2121 00000AE0 A2[2C00]                 mov byte [TokeType], al
  2122 00000AE3 E95D00                   jmp @@retn
  2123                                  
  2124                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2125                                  
  2126                                  @@getTokeType75:
  2127 00000AE6 8A46FE                   mov al, byte [bp-2]
  2128 00000AE9 B400                     mov ah, 0
  2129 00000AEB 50                       push ax
  2130 00000AEC E8FF20                   call digit
  2131 00000AEF 83C402                   add  sp, 2
  2132 00000AF2 08C0                     or  al, al
  2133 00000AF4 0F841800                 je @@getTokeType76
  2134 00000AF8 8A46FE                   mov al, byte [bp-2]
  2135 00000AFB B400                     mov ah, 0
  2136 00000AFD 50                       push ax
  2137 00000AFE E80207                   call getDigit
  2138 00000B01 83C402                   add  sp, 2
  2139 00000B04 66B801000000             mov eax, 1
  2140 00000B0A A2[2C00]                 mov byte [TokeType], al
  2141 00000B0D E93300                   jmp @@retn
  2142                                  
  2143                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2144                                  
  2145                                  @@getTokeType76:
  2146 00000B10 8A46FE                   mov al, byte [bp-2]
  2147 00000B13 B400                     mov ah, 0
  2148 00000B15 50                       push ax
  2149 00000B16 E80F06                   call letterE
  2150 00000B19 83C402                   add  sp, 2
  2151 00000B1C 08C0                     or  al, al
  2152 00000B1E 0F841800                 je @@getTokeType77
  2153 00000B22 8A46FE                   mov al, byte [bp-2]
  2154 00000B25 B400                     mov ah, 0
  2155 00000B27 50                       push ax
  2156 00000B28 E82F07                   call getName
  2157 00000B2B 83C402                   add  sp, 2
  2158 00000B2E 66B803000000             mov eax, 3
  2159 00000B34 A2[2C00]                 mov byte [TokeType], al
  2160 00000B37 E90900                   jmp @@retn
  2161                                  
  2162                                  ;-43     TokeType=NOALNUME;
  2163                                  
  2164                                  @@getTokeType77:
  2165 00000B3A 66B804000000             mov eax, 4
  2166 00000B40 A2[2C00]                 mov byte [TokeType], al
  2167                                  
  2168                                  ;-44 }                     
  2169                                  
  2170                                  
  2171                                  ;-45 
  2172                                  
  2173                                  
  2174                                  ;-46 int storeJmpCall() {
  2175                                  
  2176 00000B43 C9                      @@retn: LEAVE
  2177 00000B44 C3                       ret
  2178                                  ; ENDP
  2179                                  
  2180                                  storeJmpCall:  ; *** PROC ***
  2181                                  
  2182                                  ;-47     unsigned int i;
  2183                                  
  2184                                  
  2185                                  ;-48     JmpCallMaxIx++;
  2186                                  
  2187                                  ;Function : storeJmpCall, Number of local variables: 1
  2188                                  ;   # type sign width line used address name   list of local variables
  2189                                  ;  250 var unsg word    47 NULL bp-2    i;
  2190 00000B45 C8020000                 ENTER  2,0
  2191 00000B49 FF06[4E00]               inc  word [JmpCallMaxIx]
  2192                                  
  2193                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2194                                  
  2195 00000B4D A1[4E00]                 mov ax, [JmpCallMaxIx]
  2196 00000B50 3DF401                   cmp ax, 500 ;unsigned : 1
  2197 00000B53 0F8C0900                 jl  @@storeJmpCall78
  2198 00000B57 68[A10B]                 push storeJmpCall_0
  2199 00000B5A E8BE0E                   call errorexit
  2200 00000B5D 83C402                   add  sp, 2
  2201                                  
  2202                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2203                                  
  2204                                  @@storeJmpCall78:
  2205 00000B60 8D063075                 lea  ax, [Symbol]
  2206 00000B64 50                       push ax
  2207 00000B65 FF36[4C00]               push word [JmpCallNamePtr]
  2208 00000B69 E84920                   call strcpy
  2209 00000B6C 83C404                   add  sp, 4
  2210 00000B6F A3[4C00]                 mov word [JmpCallNamePtr], ax
  2211                                  
  2212                                  ;-51     JmpCallNamePtr++;
  2213                                  
  2214 00000B72 FF06[4C00]               inc  word [JmpCallNamePtr]
  2215                                  
  2216                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2217                                  
  2218 00000B76 A1[4C00]                 mov ax, [JmpCallNamePtr]
  2219 00000B79 2D8B8B                   sub ax, JmpCallNames
  2220 00000B7C 8946FE                   mov word [bp-2], ax
  2221                                  
  2222                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2223                                  
  2224 00000B7F 8B46FE                   mov ax, [bp-2]
  2225 00000B82 3DB107                   cmp ax, 1969 ;unsigned : 0
  2226 00000B85 0F820900                 jb  @@storeJmpCall79
  2227 00000B89 68[B30B]                 push storeJmpCall_1
  2228 00000B8C E88C0E                   call errorexit
  2229 00000B8F 83C402                   add  sp, 2
  2230                                  
  2231                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2232                                  
  2233                                  @@storeJmpCall79:
  2234 00000B92 A1[2300]                 mov ax, [PC]
  2235 00000B95 8B1E[4E00]               mov bx, [JmpCallMaxIx]
  2236 00000B99 D1E3                     shl bx, 1
  2237 00000B9B 89875B93                 mov [JmpCallAddr+bx], ax
  2238                                  
  2239                                  ;-55 }
  2240                                  
  2241                                  
  2242                                  ;-56 
  2243                                  
  2244                                  
  2245                                  ;-57 int storeLabel() {
  2246 00000B9F C9                       LEAVE
  2247 00000BA0 C3                       ret
  2248                                  ; ENDP
  2249 00000BA1 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2250 00000BAA 4A6D7043616C6C7300 
  2251 00000BB3 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2252 00000BBC 4A6D7043616C6C206E-
  2253 00000BC5 616D657300         
  2254                                  
  2255                                  storeLabel:  ; *** PROC ***
  2256                                  
  2257                                  ;-58     unsigned int i;
  2258                                  
  2259                                  
  2260                                  ;-59     LabelMaxIx++;
  2261                                  
  2262                                  ;Function : storeLabel, Number of local variables: 1
  2263                                  ;   # type sign width line used address name   list of local variables
  2264                                  ;  250 var unsg word    58 NULL bp-2    i;
  2265 00000BCA C8020000                 ENTER  2,0
  2266 00000BCE FF06[4800]               inc  word [LabelMaxIx]
  2267                                  
  2268                                  ;-60     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2269                                  
  2270 00000BD2 A1[4800]                 mov ax, [LabelMaxIx]
  2271 00000BD5 3D5802                   cmp ax, 600 ;unsigned : 1
  2272 00000BD8 0F8C0900                 jl  @@storeLabel80
  2273 00000BDC 68[3C0C]                 push storeLabel_0
  2274 00000BDF E8390E                   call errorexit
  2275 00000BE2 83C402                   add  sp, 2
  2276                                  
  2277                                  ;-61     if(searchLabel()) error1("duplicate label");
  2278                                  
  2279                                  @@storeLabel80:
  2280 00000BE5 E88900                   call searchLabel
  2281 00000BE8 08C0                     or  al, al
  2282 00000BEA 0F840900                 je @@storeLabel81
  2283 00000BEE 68[4C0C]                 push storeLabel_1
  2284 00000BF1 E8C80D                   call error1
  2285 00000BF4 83C402                   add  sp, 2
  2286                                  
  2287                                  ;-62     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2288                                  
  2289                                  @@storeLabel81:
  2290 00000BF7 8D063075                 lea  ax, [Symbol]
  2291 00000BFB 50                       push ax
  2292 00000BFC FF36[4600]               push word [LabelNamePtr]
  2293 00000C00 E8B21F                   call strcpy
  2294 00000C03 83C404                   add  sp, 4
  2295 00000C06 A3[4600]                 mov word [LabelNamePtr], ax
  2296                                  
  2297                                  ;-63     LabelNamePtr++;
  2298                                  
  2299 00000C09 FF06[4600]               inc  word [LabelNamePtr]
  2300                                  
  2301                                  ;-64     i = LabelNamePtr - &LabelNames;
  2302                                  
  2303 00000C0D A1[4600]                 mov ax, [LabelNamePtr]
  2304 00000C10 2D3B77                   sub ax, LabelNames
  2305 00000C13 8946FE                   mov word [bp-2], ax
  2306                                  
  2307                                  ;-65     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2308                                  
  2309 00000C16 8B46FE                   mov ax, [bp-2]
  2310 00000C19 3D810F                   cmp ax, 3969 ;unsigned : 0
  2311 00000C1C 0F820900                 jb  @@storeLabel82
  2312 00000C20 68[5C0C]                 push storeLabel_2
  2313 00000C23 E8F50D                   call errorexit
  2314 00000C26 83C402                   add  sp, 2
  2315                                  
  2316                                  ;-66     LabelAddr[LabelMaxIx] = PC + Origin;
  2317                                  
  2318                                  @@storeLabel82:
  2319 00000C29 A1[2300]                 mov ax, [PC]
  2320 00000C2C 0306[2500]               add ax, [Origin]
  2321 00000C30 8B1E[4800]               mov bx, [LabelMaxIx]
  2322 00000C34 D1E3                     shl bx, 1
  2323 00000C36 8987DB86                 mov [LabelAddr+bx], ax
  2324                                  
  2325                                  ;-67 }   
  2326                                  
  2327                                  
  2328                                  ;-68 
  2329                                  
  2330                                  
  2331                                  ;-69 int searchLabel() {
  2332 00000C3A C9                       LEAVE
  2333 00000C3B C3                       ret
  2334                                  ; ENDP
  2335 00000C3C 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2336 00000C45 6C6162656C7300     
  2337 00000C4C 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2338 00000C55 206C6162656C00     
  2339 00000C5C 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2340 00000C65 6C6162656C206E616D-
  2341 00000C6E 657300             
  2342                                  
  2343                                  searchLabel:  ; *** PROC ***
  2344                                  
  2345                                  ;-70     int LIx; char *p;
  2346                                  
  2347                                  
  2348                                  ;-71     p = &LabelNames;
  2349                                  
  2350                                  ;Function : searchLabel, Number of local variables: 2
  2351                                  ;   # type sign width line used address name   list of local variables
  2352                                  ;  250 var sign word    70 NULL bp-2    LIx
  2353                                  ;  251 ptr sign byte    70 NULL bp-4    p;
  2354 00000C71 C8040000                 ENTER  4,0
  2355 00000C75 B83B77                   mov ax, LabelNames
  2356 00000C78 8946FC                   mov word [bp-4], ax
  2357                                  
  2358                                  ;-72     LIx = 1;
  2359                                  
  2360 00000C7B 66B801000000             mov eax, 1
  2361 00000C81 8946FE                   mov word [bp-2], ax
  2362                                  
  2363                                  ;-73     while (LIx <= LabelMaxIx) {
  2364                                  
  2365                                  @@searchLabel83:
  2366 00000C84 8B46FE                   mov ax, [bp-2]
  2367 00000C87 3B06[4800]               cmp ax, [LabelMaxIx]
  2368 00000C8B 0F8F3100                 jg  @@searchLabel84
  2369                                  
  2370                                  ;-74         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2371                                  
  2372 00000C8F 8D063075                 lea  ax, [Symbol]
  2373 00000C93 50                       push ax
  2374 00000C94 FF76FC                   push word [bp-4]
  2375 00000C97 E8871F                   call eqstr
  2376 00000C9A 83C404                   add  sp, 4
  2377 00000C9D 08C0                     or  al, al
  2378 00000C9F 0F840600                 je @@searchLabel85
  2379 00000CA3 8B46FE                   mov ax, [bp-2]
  2380 00000CA6 E92000                   jmp @@retn
  2381                                  
  2382                                  ;-75         p=strlen(p) + p;                  
  2383                                  
  2384                                  @@searchLabel85:
  2385 00000CA9 FF76FC                   push word [bp-4]
  2386 00000CAC E8DB1E                   call strlen
  2387 00000CAF 83C402                   add  sp, 2
  2388 00000CB2 0346FC                   add ax, [bp-4]
  2389 00000CB5 8946FC                   mov word [bp-4], ax
  2390                                  
  2391                                  ;-76         p++; 
  2392                                  
  2393 00000CB8 FF46FC                   inc  word [bp-4]
  2394                                  
  2395                                  ;-77         LIx++;
  2396                                  
  2397 00000CBB FF46FE                   inc  word [bp-2]
  2398                                  
  2399                                  ;-78     }
  2400                                  
  2401                                  
  2402                                  ;-79     return 0;
  2403                                  
  2404 00000CBE EBC4                     jmp @@searchLabel83
  2405                                  @@searchLabel84:
  2406 00000CC0 66B800000000             mov eax, 0
  2407 00000CC6 E90000                   jmp @@retn
  2408                                  
  2409                                  ;-80 }   
  2410                                  
  2411                                  
  2412                                  ;-81 
  2413                                  
  2414                                  
  2415                                  ;-82 int getVariable() { 
  2416                                  
  2417 00000CC9 C9                      @@retn: LEAVE
  2418 00000CCA C3                       ret
  2419                                  ; ENDP
  2420                                  
  2421                                  getVariable:  ; *** PROC ***
  2422                                  
  2423                                  ;-83     char c; 
  2424                                  
  2425                                  
  2426                                  ;-84     storeLabel();
  2427                                  
  2428                                  ;Function : getVariable, Number of local variables: 1
  2429                                  ;   # type sign width line used address name   list of local variables
  2430                                  ;  250 var sign byte    83 NULL bp-2    c;
  2431 00000CCB C8020000                 ENTER  2,0
  2432 00000CCF E8F8FE                   call storeLabel
  2433                                  
  2434                                  ;-85     getTokeType(); 
  2435                                  
  2436 00000CD2 E8D5FD                   call getTokeType
  2437                                  
  2438                                  ;-86     if(TokeType==ALNUME) {//getName
  2439                                  
  2440 00000CD5 A0[2C00]                 mov al, [TokeType]
  2441 00000CD8 3C03                     cmp al, 3
  2442 00000CDA 0F857401                 jne @@getVariable86
  2443                                  
  2444                                  ;-87         lookCode();
  2445                                  
  2446 00000CDE E88701                   call lookCode
  2447                                  
  2448                                  ;-88         if (CodeType < 200) dataexit();
  2449                                  
  2450 00000CE1 A0[2F00]                 mov al, [CodeType]
  2451 00000CE4 3CC8                     cmp al, 200
  2452 00000CE6 0F8D0300                 jge @@getVariable87
  2453 00000CEA E8B90E                   call dataexit
  2454                                  
  2455                                  ;-89         if (CodeType > 205) dataexit();
  2456                                  
  2457                                  @@getVariable87:
  2458 00000CED A0[2F00]                 mov al, [CodeType]
  2459 00000CF0 3CCD                     cmp al, 205
  2460 00000CF2 0F8E0300                 jle @@getVariable88
  2461 00000CF6 E8AD0E                   call dataexit
  2462                                  
  2463                                  ;-90         if (CodeType== 200) {//DB
  2464                                  
  2465                                  @@getVariable88:
  2466 00000CF9 A0[2F00]                 mov al, [CodeType]
  2467 00000CFC 3CC8                     cmp al, 200
  2468 00000CFE 0F856A00                 jne @@getVariable89
  2469                                  
  2470                                  ;-91             do { 
  2471                                  
  2472                                  @@getVariable90:
  2473                                  
  2474                                  ;-92                 getTokeType();
  2475                                  
  2476 00000D02 E8A5FD                   call getTokeType
  2477                                  
  2478                                  ;-93                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2479                                  
  2480 00000D05 A0[2C00]                 mov al, [TokeType]
  2481 00000D08 3C01                     cmp al, 1
  2482 00000D0A 0F850D00                 jne @@getVariable91
  2483 00000D0E FF36[0E00]               push word [SymbolInt]
  2484 00000D12 E8C713                   call genCode8
  2485 00000D15 83C402                   add  sp, 2
  2486                                  
  2487                                  ;-94                 else {
  2488                                  
  2489 00000D18 E94100                   jmp @@getVariable92
  2490                                  @@getVariable91:
  2491                                  
  2492                                  ;-95                     skipBlank();
  2493                                  
  2494 00000D1B E8DF03                   call skipBlank
  2495                                  
  2496                                  ;-96                     if (isToken('"')) {
  2497                                  
  2498 00000D1E 6A22                     push 34
  2499 00000D20 E84202                   call isToken
  2500 00000D23 83C402                   add  sp, 2
  2501 00000D26 08C0                     or  al, al
  2502 00000D28 0F843000                 je @@getVariable93
  2503                                  
  2504                                  ;-97                         do { 
  2505                                  
  2506                                  @@getVariable94:
  2507                                  
  2508                                  ;-98                             c= *InputPtr;
  2509                                  
  2510 00000D2C 8B1E[1400]               mov bx, [InputPtr]
  2511 00000D30 8A07                     mov al, [bx]
  2512 00000D32 B400                     mov ah, 0
  2513 00000D34 8846FE                   mov byte [bp-2], al
  2514                                  
  2515                                  ;-99                             genCode8(c);
  2516                                  
  2517 00000D37 8A46FE                   mov al, byte [bp-2]
  2518 00000D3A B400                     mov ah, 0
  2519 00000D3C 50                       push ax
  2520 00000D3D E89C13                   call genCode8
  2521 00000D40 83C402                   add  sp, 2
  2522                                  
  2523                                  ;-100                             InputPtr++;
  2524                                  
  2525 00000D43 FF06[1400]               inc  word [InputPtr]
  2526                                  
  2527                                  ;-101                         } while (*InputPtr != '"' );
  2528                                  
  2529 00000D47 8B1E[1400]               mov bx, [InputPtr]
  2530 00000D4B 8A07                     mov al, [bx]
  2531 00000D4D B400                     mov ah, 0
  2532 00000D4F 83F822                   cmp ax, 34
  2533 00000D52 0F840200                 je  @@getVariable95
  2534 00000D56 EBD4                     jmp @@getVariable94
  2535                                  @@getVariable95:
  2536                                  
  2537                                  ;-102                         InputPtr++;
  2538                                  
  2539 00000D58 FF06[1400]               inc  word [InputPtr]
  2540                                  
  2541                                  ;-103                     }
  2542                                  
  2543                                  
  2544                                  ;-104                 }
  2545                                  
  2546                                  @@getVariable93:
  2547                                  
  2548                                  ;-105             } while (isToken(','));
  2549                                  
  2550                                  @@getVariable92:
  2551 00000D5C 6A2C                     push 44
  2552 00000D5E E80402                   call isToken
  2553 00000D61 83C402                   add  sp, 2
  2554 00000D64 08C0                     or  al, al
  2555 00000D66 0F840200                 je @@getVariable96
  2556 00000D6A EB96                     jmp @@getVariable90
  2557                                  @@getVariable96:
  2558                                  
  2559                                  ;-106         }
  2560                                  
  2561                                  
  2562                                  ;-107         if (CodeType == 201) {//DW
  2563                                  
  2564                                  @@getVariable89:
  2565 00000D6C A0[2F00]                 mov al, [CodeType]
  2566 00000D6F 3CC9                     cmp al, 201
  2567 00000D71 0F852600                 jne @@getVariable97
  2568                                  
  2569                                  ;-108             do { 
  2570                                  
  2571                                  @@getVariable98:
  2572                                  
  2573                                  ;-109                 getTokeType();
  2574                                  
  2575 00000D75 E832FD                   call getTokeType
  2576                                  
  2577                                  ;-110                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2578                                  
  2579 00000D78 A0[2C00]                 mov al, [TokeType]
  2580 00000D7B 3C01                     cmp al, 1
  2581 00000D7D 0F850A00                 jne @@getVariable99
  2582 00000D81 FF36[0E00]               push word [SymbolInt]
  2583 00000D85 E8AB13                   call genCode16
  2584 00000D88 83C402                   add  sp, 2
  2585                                  
  2586                                  ;-111             } while (isToken(','));
  2587                                  
  2588                                  @@getVariable99:
  2589 00000D8B 6A2C                     push 44
  2590 00000D8D E8D501                   call isToken
  2591 00000D90 83C402                   add  sp, 2
  2592 00000D93 08C0                     or  al, al
  2593 00000D95 0F840200                 je @@getVariable100
  2594 00000D99 EBDA                     jmp @@getVariable98
  2595                                  @@getVariable100:
  2596                                  
  2597                                  ;-112         } 
  2598                                  
  2599                                  
  2600                                  ;-113         if (CodeType == 202) {//DD
  2601                                  
  2602                                  @@getVariable97:
  2603 00000D9B A0[2F00]                 mov al, [CodeType]
  2604 00000D9E 3CCA                     cmp al, 202
  2605 00000DA0 0F852E00                 jne @@getVariable101
  2606                                  
  2607                                  ;-114             do { 
  2608                                  
  2609                                  @@getVariable102:
  2610                                  
  2611                                  ;-115                 getTokeType();
  2612                                  
  2613 00000DA4 E803FD                   call getTokeType
  2614                                  
  2615                                  ;-116                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2616                                  
  2617 00000DA7 A0[2C00]                 mov al, [TokeType]
  2618 00000DAA 3C01                     cmp al, 1
  2619 00000DAC 0F851200                 jne @@getVariable103
  2620 00000DB0 FF36[0E00]               push word [SymbolInt]
  2621 00000DB4 E87C13                   call genCode16
  2622 00000DB7 83C402                   add  sp, 2
  2623                                  
  2624                                  ;-117                                     genCode16(0);}//todo genCode32(SymbolLong);
  2625                                  
  2626 00000DBA 6A00                     push 0
  2627 00000DBC E87413                   call genCode16
  2628 00000DBF 83C402                   add  sp, 2
  2629                                  
  2630                                  ;-118             } while (isToken(','));
  2631                                  
  2632                                  @@getVariable103:
  2633 00000DC2 6A2C                     push 44
  2634 00000DC4 E89E01                   call isToken
  2635 00000DC7 83C402                   add  sp, 2
  2636 00000DCA 08C0                     or  al, al
  2637 00000DCC 0F840200                 je @@getVariable104
  2638 00000DD0 EBD2                     jmp @@getVariable102
  2639                                  @@getVariable104:
  2640                                  
  2641                                  ;-119         } 
  2642                                  
  2643                                  
  2644                                  ;-120         if (CodeType >= 203) {//resb, resw, resd
  2645                                  
  2646                                  @@getVariable101:
  2647 00000DD2 A0[2F00]                 mov al, [CodeType]
  2648 00000DD5 3CCB                     cmp al, 203 ;unsigned : 1
  2649 00000DD7 0F8C7400                 jl  @@getVariable105
  2650                                  
  2651                                  ;-121             getTokeType();
  2652                                  
  2653 00000DDB E8CCFC                   call getTokeType
  2654                                  
  2655                                  ;-122             if (TokeType == DIGIT) {
  2656                                  
  2657 00000DDE A0[2C00]                 mov al, [TokeType]
  2658 00000DE1 3C01                     cmp al, 1
  2659 00000DE3 0F856500                 jne @@getVariable106
  2660                                  
  2661                                  ;-123                 if (SymbolInt <= 0) syntaxerror();   
  2662                                  
  2663 00000DE7 A1[0E00]                 mov ax, [SymbolInt]
  2664 00000DEA 83F800                   cmp ax, 0
  2665 00000DED 0F870300                 ja  @@getVariable107
  2666 00000DF1 E8870D                   call syntaxerror
  2667                                  
  2668                                  ;-124                 if (AbsoluteLab == 0) error1("Absolute is null");
  2669                                  
  2670                                  @@getVariable107:
  2671 00000DF4 A1[2700]                 mov ax, [AbsoluteLab]
  2672 00000DF7 83F800                   cmp ax, 0
  2673 00000DFA 0F850900                 jne @@getVariable108
  2674 00000DFE 68[570E]                 push getVariable_0
  2675 00000E01 E8B80B                   call error1
  2676 00000E04 83C402                   add  sp, 2
  2677                                  
  2678                                  ;-125                 LabelAddr[LabelMaxIx] = AbsoluteLab; 
  2679                                  
  2680                                  @@getVariable108:
  2681 00000E07 A1[2700]                 mov ax, [AbsoluteLab]
  2682 00000E0A 8B1E[4800]               mov bx, [LabelMaxIx]
  2683 00000E0E D1E3                     shl bx, 1
  2684 00000E10 8987DB86                 mov [LabelAddr+bx], ax
  2685                                  
  2686                                  ;-126                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2687                                  
  2688 00000E14 A0[2F00]                 mov al, [CodeType]
  2689 00000E17 3CCC                     cmp al, 204
  2690 00000E19 0F850A00                 jne @@getVariable109
  2691 00000E1D A1[0E00]                 mov ax, [SymbolInt]
  2692 00000E20 0306[0E00]               add ax, [SymbolInt]
  2693 00000E24 A3[0E00]                 mov word [SymbolInt], ax
  2694                                  
  2695                                  ;-127                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd                  
  2696                                  
  2697                                  @@getVariable109:
  2698 00000E27 A0[2F00]                 mov al, [CodeType]
  2699 00000E2A 3CCD                     cmp al, 205
  2700 00000E2C 0F850F00                 jne @@getVariable110
  2701 00000E30 A1[0E00]                 mov ax, [SymbolInt]
  2702 00000E33 66BB04000000             mov ebx, 4
  2703 00000E39 66F7E3                   mul ebx
  2704 00000E3C A3[0E00]                 mov word [SymbolInt], ax
  2705                                  
  2706                                  ;-128                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2707                                  
  2708                                  @@getVariable110:
  2709 00000E3F A1[2700]                 mov ax, [AbsoluteLab]
  2710 00000E42 0306[0E00]               add ax, [SymbolInt]
  2711 00000E46 A3[2700]                 mov word [AbsoluteLab], ax
  2712                                  
  2713                                  ;-129             } else numbererror();  
  2714                                  
  2715 00000E49 E90300                   jmp @@getVariable111
  2716                                  @@getVariable106:
  2717 00000E4C E8990C                   call numbererror
  2718                                  
  2719                                  ;-130         }    
  2720                                  
  2721                                  @@getVariable111:
  2722                                  
  2723                                  ;-131     }
  2724                                  
  2725                                  @@getVariable105:
  2726                                  
  2727                                  ;-132     else dataexit();
  2728                                  
  2729 00000E4F E90300                   jmp @@getVariable112
  2730                                  @@getVariable86:
  2731 00000E52 E8510D                   call dataexit
  2732                                  
  2733                                  ;-133 }
  2734                                  
  2735                                  @@getVariable112:
  2736                                  
  2737                                  ;-134 
  2738                                  
  2739                                  
  2740                                  ;-135 int lookCode() {//ret: CodeType, *OpCodePtr
  2741 00000E55 C9                       LEAVE
  2742 00000E56 C3                       ret
  2743                                  ; ENDP
  2744 00000E57 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2745 00000E60 6973206E756C6C00   
  2746                                  
  2747                                  lookCode:  ; *** PROC ***
  2748                                  
  2749                                  ;-136     CodeType=0;
  2750                                  
  2751 00000E68 66B800000000             mov eax, 0
  2752 00000E6E A2[2F00]                 mov byte [CodeType], al
  2753                                  
  2754                                  ;-137     OpCodePtr= &I_START;
  2755                                  
  2756 00000E71 B8[5600]                 mov ax, I_START
  2757 00000E74 A3[4300]                 mov word [OpCodePtr], ax
  2758                                  
  2759                                  ;-138     OpCodePtr++;
  2760                                  
  2761 00000E77 FF06[4300]               inc  word [OpCodePtr]
  2762                                  
  2763                                  ;-139     do  {
  2764                                  
  2765                                  @@lookCode113:
  2766                                  
  2767                                  ;-140         if (eqstr(SymbolUpper, OpCodePtr))  {
  2768                                  
  2769 00000E7B FF36[4300]               push word [OpCodePtr]
  2770 00000E7F 8D064F75                 lea  ax, [SymbolUpper]
  2771 00000E83 50                       push ax
  2772 00000E84 E89A1D                   call eqstr
  2773 00000E87 83C404                   add  sp, 4
  2774 00000E8A 08C0                     or  al, al
  2775 00000E8C 0F842700                 je @@lookCode114
  2776                                  
  2777                                  ;-141             while(*OpCodePtr!=0) OpCodePtr++;
  2778                                  
  2779                                  @@lookCode115:
  2780 00000E90 8B1E[4300]               mov bx, [OpCodePtr]
  2781 00000E94 8A07                     mov al, [bx]
  2782 00000E96 B400                     mov ah, 0
  2783 00000E98 83F800                   cmp ax, 0
  2784 00000E9B 0F840600                 je  @@lookCode116
  2785 00000E9F FF06[4300]               inc  word [OpCodePtr]
  2786                                  
  2787                                  ;-142             OpCodePtr++; 
  2788                                  
  2789 00000EA3 EBEB                     jmp @@lookCode115
  2790                                  @@lookCode116:
  2791 00000EA5 FF06[4300]               inc  word [OpCodePtr]
  2792                                  
  2793                                  ;-143             CodeType =*OpCodePtr;
  2794                                  
  2795 00000EA9 8B1E[4300]               mov bx, [OpCodePtr]
  2796 00000EAD 8A07                     mov al, [bx]
  2797 00000EAF B400                     mov ah, 0
  2798 00000EB1 A2[2F00]                 mov byte [CodeType], al
  2799                                  
  2800                                  ;-144             return;
  2801                                  
  2802 00000EB4 E92A00                   jmp @@retn
  2803                                  
  2804                                  ;-145         }
  2805                                  
  2806                                  
  2807                                  ;-146     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2808                                  
  2809                                  @@lookCode114:
  2810                                  @@lookCode117:
  2811 00000EB7 8B1E[4300]               mov bx, [OpCodePtr]
  2812 00000EBB 8A07                     mov al, [bx]
  2813 00000EBD B400                     mov ah, 0
  2814 00000EBF 3DF100                   cmp ax, 241
  2815 00000EC2 0F840600                 je  @@lookCode118
  2816 00000EC6 FF06[4300]               inc  word [OpCodePtr]
  2817                                  
  2818                                  ;-147     OpCodePtr++;
  2819                                  
  2820 00000ECA EBEB                     jmp @@lookCode117
  2821                                  @@lookCode118:
  2822 00000ECC FF06[4300]               inc  word [OpCodePtr]
  2823                                  
  2824                                  ;-148     } while(*OpCodePtr!=0);
  2825                                  
  2826 00000ED0 8B1E[4300]               mov bx, [OpCodePtr]
  2827 00000ED4 8A07                     mov al, [bx]
  2828 00000ED6 B400                     mov ah, 0
  2829 00000ED8 83F800                   cmp ax, 0
  2830 00000EDB 0F840200                 je  @@lookCode119
  2831 00000EDF EB9A                     jmp @@lookCode113
  2832                                  @@lookCode119:
  2833                                  
  2834                                  ;-149 }
  2835                                  
  2836                                  
  2837                                  ;-150 
  2838                                  
  2839                                  
  2840                                  ;-151 int getCodeSize() {
  2841                                  
  2842                                  @@retn:
  2843 00000EE1 C3                       ret
  2844                                  ; ENDP
  2845                                  
  2846                                  getCodeSize:  ; *** PROC ***
  2847                                  
  2848                                  ;-152     if (TokeType ==ALNUME) {
  2849                                  
  2850 00000EE2 A0[2C00]                 mov al, [TokeType]
  2851 00000EE5 3C03                     cmp al, 3
  2852 00000EE7 0F856000                 jne @@getCodeSize120
  2853                                  
  2854                                  ;-153         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2855                                  
  2856 00000EEB 68[550F]                 push getCodeSize_0
  2857 00000EEE 8D064F75                 lea  ax, [SymbolUpper]
  2858 00000EF2 50                       push ax
  2859 00000EF3 E82B1D                   call eqstr
  2860 00000EF6 83C404                   add  sp, 4
  2861 00000EF9 08C0                     or  al, al
  2862 00000EFB 0F840C00                 je @@getCodeSize121
  2863 00000EFF E8A8FB                   call getTokeType
  2864 00000F02 66B801000000             mov eax, 1
  2865 00000F08 E94900                   jmp @@retn
  2866                                  
  2867                                  ;-154         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2868                                  
  2869                                  @@getCodeSize121:
  2870 00000F0B 68[5A0F]                 push getCodeSize_1
  2871 00000F0E 8D064F75                 lea  ax, [SymbolUpper]
  2872 00000F12 50                       push ax
  2873 00000F13 E80B1D                   call eqstr
  2874 00000F16 83C404                   add  sp, 4
  2875 00000F19 08C0                     or  al, al
  2876 00000F1B 0F840C00                 je @@getCodeSize122
  2877 00000F1F E888FB                   call getTokeType
  2878 00000F22 66B802000000             mov eax, 2
  2879 00000F28 E92900                   jmp @@retn
  2880                                  
  2881                                  ;-155         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2882                                  
  2883                                  @@getCodeSize122:
  2884 00000F2B 68[5F0F]                 push getCodeSize_2
  2885 00000F2E 8D064F75                 lea  ax, [SymbolUpper]
  2886 00000F32 50                       push ax
  2887 00000F33 E8EB1C                   call eqstr
  2888 00000F36 83C404                   add  sp, 4
  2889 00000F39 08C0                     or  al, al
  2890 00000F3B 0F840C00                 je @@getCodeSize123
  2891 00000F3F E868FB                   call getTokeType
  2892 00000F42 66B803000000             mov eax, 3
  2893 00000F48 E90900                   jmp @@retn
  2894                                  
  2895                                  ;-156     } 
  2896                                  
  2897                                  @@getCodeSize123:
  2898                                  
  2899                                  ;-157     return 0;
  2900                                  
  2901                                  @@getCodeSize120:
  2902 00000F4B 66B800000000             mov eax, 0
  2903 00000F51 E90000                   jmp @@retn
  2904                                  
  2905                                  ;-158 }
  2906                                  
  2907                                  
  2908                                  ;-159 int isToken(char c) {
  2909                                  
  2910                                  @@retn:
  2911 00000F54 C3                       ret
  2912                                  ; ENDP
  2913 00000F55 4259544500              getCodeSize_0 db "BYTE",0
  2914 00000F5A 574F524400              getCodeSize_1 db "WORD",0
  2915 00000F5F 44574F524400            getCodeSize_2 db "DWORD",0
  2916                                  
  2917                                  isToken:  ; *** PROC ***
  2918                                  
  2919                                  ;-160     skipBlank();
  2920                                  
  2921                                  ;Function : isToken, Number of local variables: 1
  2922                                  ;   # type sign width line used address name   list of local variables
  2923                                  ;  250 var sign byte   159 NULL bp+4    c;
  2924 00000F65 C8000000                 ENTER  0,0
  2925 00000F69 E89101                   call skipBlank
  2926                                  
  2927                                  ;-161     if (*InputPtr == c) {
  2928                                  
  2929 00000F6C 8B1E[1400]               mov bx, [InputPtr]
  2930 00000F70 8A07                     mov al, [bx]
  2931 00000F72 B400                     mov ah, 0
  2932 00000F74 3A4604                   cmp al, [bp+4]
  2933 00000F77 0F850D00                 jne @@isToken124
  2934                                  
  2935                                  ;-162         InputPtr++; 
  2936                                  
  2937 00000F7B FF06[1400]               inc  word [InputPtr]
  2938                                  
  2939                                  ;-163         return 1;
  2940                                  
  2941 00000F7F 66B801000000             mov eax, 1
  2942 00000F85 E90900                   jmp @@retn
  2943                                  
  2944                                  ;-164         } 
  2945                                  
  2946                                  
  2947                                  ;-165     return 0;
  2948                                  
  2949                                  @@isToken124:
  2950 00000F88 66B800000000             mov eax, 0
  2951 00000F8E E90000                   jmp @@retn
  2952                                  
  2953                                  ;-166 }
  2954                                  
  2955                                  
  2956                                  ;-167 int need(char c) {
  2957                                  
  2958 00000F91 C9                      @@retn: LEAVE
  2959 00000F92 C3                       ret
  2960                                  ; ENDP
  2961                                  
  2962                                  need:  ; *** PROC ***
  2963                                  
  2964                                  ;-168     if (isToken(c)) {
  2965                                  
  2966                                  ;Function : need, Number of local variables: 1
  2967                                  ;   # type sign width line used address name   list of local variables
  2968                                  ;  250 var sign byte   167 NULL bp+4    c;
  2969 00000F93 C8000000                 ENTER  0,0
  2970 00000F97 8A4604                   mov al, byte [bp+4]
  2971 00000F9A B400                     mov ah, 0
  2972 00000F9C 50                       push ax
  2973 00000F9D E8C5FF                   call isToken
  2974 00000FA0 83C402                   add  sp, 2
  2975 00000FA3 08C0                     or  al, al
  2976 00000FA5 0F840600                 je @@need125
  2977                                  
  2978                                  ;-169         getTokeType();
  2979                                  
  2980 00000FA9 E8FEFA                   call getTokeType
  2981                                  
  2982                                  ;-170         return;
  2983                                  
  2984 00000FAC E91800                   jmp @@retn
  2985                                  
  2986                                  ;-171         }
  2987                                  
  2988                                  
  2989                                  ;-172     error1();
  2990                                  
  2991                                  @@need125:
  2992 00000FAF E80A0A                   call error1
  2993                                  
  2994                                  ;-173     prs(". need: ");
  2995                                  
  2996 00000FB2 68[C90F]                 push need_0
  2997 00000FB5 E8A308                   call prs
  2998 00000FB8 83C402                   add  sp, 2
  2999                                  
  3000                                  ;-174     prc(c);
  3001                                  
  3002 00000FBB 8A4604                   mov al, byte [bp+4]
  3003 00000FBE B400                     mov ah, 0
  3004 00000FC0 50                       push ax
  3005 00000FC1 E83608                   call prc
  3006 00000FC4 83C402                   add  sp, 2
  3007                                  
  3008                                  ;-175 }
  3009                                  
  3010                                  
  3011                                  ;-176 int skipRest() {
  3012                                  
  3013 00000FC7 C9                      @@retn: LEAVE
  3014 00000FC8 C3                       ret
  3015                                  ; ENDP
  3016 00000FC9 2E206E6565643A2000      need_0 db ". need: ",0
  3017                                  
  3018                                  skipRest:  ; *** PROC ***
  3019                                  
  3020                                  ;-177     getTokeType(); 
  3021                                  
  3022 00000FD2 E8D5FA                   call getTokeType
  3023                                  
  3024                                  ;-178     if(TokeType)error1("extra char ignored");
  3025                                  
  3026 00000FD5 A0[2C00]                 mov al, [TokeType]
  3027 00000FD8 08C0                     or  al, al
  3028 00000FDA 0F840900                 je @@skipRest126
  3029 00000FDE 68[E80F]                 push skipRest_0
  3030 00000FE1 E8D809                   call error1
  3031 00000FE4 83C402                   add  sp, 2
  3032                                  
  3033                                  ;-179 }
  3034                                  
  3035                                  @@skipRest126:
  3036 00000FE7 C3                       ret
  3037                                  ; ENDP
  3038 00000FE8 657874726120636861-     skipRest_0 db "extra char ignored",0
  3039 00000FF1 722069676E6F726564-
  3040 00000FFA 00                 
  3041                                  ;Back to main program: AS.C
  3042                                  
  3043                                  ;-6 #include "HELPER.C"
  3044                                  
  3045                                  ;Use include file: HELPER.C
  3046                                  
  3047                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3048                                  
  3049                                  
  3050                                  getLine:  ; *** PROC ***
  3051                                  
  3052                                  ;-2   unsigned int i;
  3053                                  
  3054                                  
  3055                                  ;-3   InputPtr= &InputBuf;
  3056                                  
  3057                                  ;Function : getLine, Number of local variables: 1
  3058                                  ;   # type sign width line used address name   list of local variables
  3059                                  ;  250 var unsg word     2 NULL bp-2    i;
  3060 00000FFB C8020000                 ENTER  2,0
  3061 00000FFF B86E75                   mov ax, InputBuf
  3062 00001002 A3[1400]                 mov word [InputPtr], ax
  3063                                  
  3064                                  ;-4   *InputPtr=0;//if last line is empty
  3065                                  
  3066 00001005 66B800000000             mov eax, 0
  3067 0000100B 8B1E[1400]               mov  bx, [InputPtr]
  3068 0000100F 8807                     mov  [bx], al
  3069                                  
  3070                                  ;-5   do {
  3071                                  
  3072                                  @@getLine127:
  3073                                  
  3074                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3075                                  
  3076 00001011 6A01                     push 1
  3077 00001013 FF36[1600]               push word [asm_fd]
  3078 00001017 8D06[2200]               lea  ax, [DOS_ByteRead]
  3079 0000101B 50                       push ax
  3080 0000101C E89D1C                   call readRL
  3081 0000101F 83C406                   add  sp, 6
  3082 00001022 A3[2000]                 mov word [DOS_NoBytes], ax
  3083                                  
  3084                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  3085                                  
  3086 00001025 A1[1C00]                 mov ax, [DOS_ERR]
  3087 00001028 08C0                     or  al, al
  3088 0000102A 0F840900                 je @@getLine128
  3089 0000102E 68[9310]                 push getLine_0
  3090 00001031 E8E709                   call errorexit
  3091 00001034 83C402                   add  sp, 2
  3092                                  
  3093                                  ;-8     if (DOS_NoBytes == 0) return;
  3094                                  
  3095                                  @@getLine128:
  3096 00001037 A1[2000]                 mov ax, [DOS_NoBytes]
  3097 0000103A 83F800                   cmp ax, 0
  3098 0000103D 0F850300                 jne @@getLine129
  3099 00001041 E94D00                   jmp @@retn
  3100                                  
  3101                                  ;-9     *InputPtr = DOS_ByteRead;
  3102                                  
  3103                                  @@getLine129:
  3104 00001044 A0[2200]                 mov al, [DOS_ByteRead]
  3105 00001047 8B1E[1400]               mov  bx, [InputPtr]
  3106 0000104B 8807                     mov  [bx], al
  3107                                  
  3108                                  ;-10     InputPtr++;
  3109                                  
  3110 0000104D FF06[1400]               inc  word [InputPtr]
  3111                                  
  3112                                  ;-11     i = InputPtr - &InputBuf;
  3113                                  
  3114 00001051 A1[1400]                 mov ax, [InputPtr]
  3115 00001054 2D6E75                   sub ax, InputBuf
  3116 00001057 8946FE                   mov word [bp-2], ax
  3117                                  
  3118                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3119                                  
  3120 0000105A 8B46FE                   mov ax, [bp-2]
  3121 0000105D 3DFF00                   cmp ax, 255 ;unsigned : 0
  3122 00001060 0F820900                 jb  @@getLine130
  3123 00001064 68[A210]                 push getLine_1
  3124 00001067 E8B109                   call errorexit
  3125 0000106A 83C402                   add  sp, 2
  3126                                  
  3127                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  3128                                  
  3129                                  @@getLine130:
  3130 0000106D A0[2200]                 mov al, byte [DOS_ByteRead]
  3131 00001070 B400                     mov ah, 0
  3132 00001072 50                       push ax
  3133 00001073 E84000                   call ifEOL
  3134 00001076 83C402                   add  sp, 2
  3135 00001079 3C00                     cmp al, 0
  3136 0000107B 0F850200                 jne @@getLine131
  3137 0000107F EB90                     jmp @@getLine127
  3138                                  @@getLine131:
  3139                                  
  3140                                  ;-14   InputPtr--;
  3141                                  
  3142 00001081 FF0E[1400]               dec  word [InputPtr]
  3143                                  
  3144                                  ;-15   *InputPtr=0;
  3145                                  
  3146 00001085 66B800000000             mov eax, 0
  3147 0000108B 8B1E[1400]               mov  bx, [InputPtr]
  3148 0000108F 8807                     mov  [bx], al
  3149                                  
  3150                                  ;-16 }
  3151                                  
  3152                                  
  3153                                  ;-17 int ifEOL(char c) {
  3154                                  
  3155 00001091 C9                      @@retn: LEAVE
  3156 00001092 C3                       ret
  3157                                  ; ENDP
  3158 00001093 52656164696E672053-     getLine_0 db "Reading Source",0
  3159 0000109C 6F7572636500       
  3160 000010A2 696E707574206C696E-     getLine_1 db "input line too long",0
  3161 000010AB 6520746F6F206C6F6E-
  3162 000010B4 6700               
  3163                                  
  3164                                  ifEOL:  ; *** PROC ***
  3165                                  
  3166                                  ;-18   if (c == 10) return 1;
  3167                                  
  3168                                  ;Function : ifEOL, Number of local variables: 1
  3169                                  ;   # type sign width line used address name   list of local variables
  3170                                  ;  250 var sign byte    17 NULL bp+4    c;
  3171 000010B6 C8000000                 ENTER  0,0
  3172 000010BA 8A4604                   mov al, [bp+4]
  3173 000010BD 3C0A                     cmp al, 10
  3174 000010BF 0F850900                 jne @@ifEOL132
  3175 000010C3 66B801000000             mov eax, 1
  3176 000010C9 E92F00                   jmp @@retn
  3177                                  
  3178                                  ;-19   if (c == 13) {
  3179                                  
  3180                                  @@ifEOL132:
  3181 000010CC 8A4604                   mov al, [bp+4]
  3182 000010CF 3C0D                     cmp al, 13
  3183 000010D1 0F851D00                 jne @@ifEOL133
  3184                                  
  3185                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3186                                  
  3187 000010D5 6A01                     push 1
  3188 000010D7 FF36[1600]               push word [asm_fd]
  3189 000010DB 8D06[2200]               lea  ax, [DOS_ByteRead]
  3190 000010DF 50                       push ax
  3191 000010E0 E8D91B                   call readRL
  3192 000010E3 83C406                   add  sp, 6
  3193 000010E6 A3[2000]                 mov word [DOS_NoBytes], ax
  3194                                  
  3195                                  ;-21     return 1;}
  3196                                  
  3197 000010E9 66B801000000             mov eax, 1
  3198 000010EF E90900                   jmp @@retn
  3199                                  
  3200                                  ;-22   return 0;
  3201                                  
  3202                                  @@ifEOL133:
  3203 000010F2 66B800000000             mov eax, 0
  3204 000010F8 E90000                   jmp @@retn
  3205                                  
  3206                                  ;-23 }
  3207                                  
  3208                                  
  3209                                  ;-24 int skipBlank() {
  3210                                  
  3211 000010FB C9                      @@retn: LEAVE
  3212 000010FC C3                       ret
  3213                                  ; ENDP
  3214                                  
  3215                                  skipBlank:  ; *** PROC ***
  3216                                  
  3217                                  ;-25   skipblank1:
  3218                                  
  3219                                  @@skipblank1:
  3220                                  
  3221                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3222                                  
  3223 000010FD 8B1E[1400]               mov bx, [InputPtr]
  3224 00001101 8A07                     mov al, [bx]
  3225 00001103 B400                     mov ah, 0
  3226 00001105 83F820                   cmp ax, 32
  3227 00001108 0F850600                 jne @@skipBlank134
  3228 0000110C FF06[1400]               inc  word [InputPtr]
  3229 00001110 EBEB                     jmp @@skipblank1
  3230                                  
  3231                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3232                                  
  3233                                  @@skipBlank134:
  3234 00001112 8B1E[1400]               mov bx, [InputPtr]
  3235 00001116 8A07                     mov al, [bx]
  3236 00001118 B400                     mov ah, 0
  3237 0000111A 83F809                   cmp ax, 9
  3238 0000111D 0F850600                 jne @@skipBlank135
  3239 00001121 FF06[1400]               inc  word [InputPtr]
  3240 00001125 EBD6                     jmp @@skipblank1
  3241                                  
  3242                                  ;-28 }
  3243                                  
  3244                                  @@skipBlank135:
  3245                                  
  3246                                  ;-29 int letterE(char c) {
  3247                                  
  3248 00001127 C3                       ret
  3249                                  ; ENDP
  3250                                  
  3251                                  letterE:  ; *** PROC ***
  3252                                  
  3253                                  ;-30   if (c=='_') return 1;
  3254                                  
  3255                                  ;Function : letterE, Number of local variables: 1
  3256                                  ;   # type sign width line used address name   list of local variables
  3257                                  ;  250 var sign byte    29 NULL bp+4    c;
  3258 00001128 C8000000                 ENTER  0,0
  3259 0000112C 8A4604                   mov al, [bp+4]
  3260 0000112F 3C5F                     cmp al, 95
  3261 00001131 0F850900                 jne @@letterE136
  3262 00001135 66B801000000             mov eax, 1
  3263 0000113B E97E00                   jmp @@retn
  3264                                  
  3265                                  ;-31   if (c=='.') return 1;
  3266                                  
  3267                                  @@letterE136:
  3268 0000113E 8A4604                   mov al, [bp+4]
  3269 00001141 3C2E                     cmp al, 46
  3270 00001143 0F850900                 jne @@letterE137
  3271 00001147 66B801000000             mov eax, 1
  3272 0000114D E96C00                   jmp @@retn
  3273                                  
  3274                                  ;-32   if (c=='?') return 1;
  3275                                  
  3276                                  @@letterE137:
  3277 00001150 8A4604                   mov al, [bp+4]
  3278 00001153 3C3F                     cmp al, 63
  3279 00001155 0F850900                 jne @@letterE138
  3280 00001159 66B801000000             mov eax, 1
  3281 0000115F E95A00                   jmp @@retn
  3282                                  
  3283                                  ;-33   if (c=='$') return 1;
  3284                                  
  3285                                  @@letterE138:
  3286 00001162 8A4604                   mov al, [bp+4]
  3287 00001165 3C24                     cmp al, 36
  3288 00001167 0F850900                 jne @@letterE139
  3289 0000116B 66B801000000             mov eax, 1
  3290 00001171 E94800                   jmp @@retn
  3291                                  
  3292                                  ;-34   if (c> 'z') return 0;
  3293                                  
  3294                                  @@letterE139:
  3295 00001174 8A4604                   mov al, [bp+4]
  3296 00001177 3C7A                     cmp al, 122
  3297 00001179 0F8E0900                 jle @@letterE140
  3298 0000117D 66B800000000             mov eax, 0
  3299 00001183 E93600                   jmp @@retn
  3300                                  
  3301                                  ;-35   if (c< '@') return 0; // at included
  3302                                  
  3303                                  @@letterE140:
  3304 00001186 8A4604                   mov al, [bp+4]
  3305 00001189 3C40                     cmp al, 64
  3306 0000118B 0F8D0900                 jge @@letterE141
  3307 0000118F 66B800000000             mov eax, 0
  3308 00001195 E92400                   jmp @@retn
  3309                                  
  3310                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3311                                  
  3312                                  @@letterE141:
  3313 00001198 8A4604                   mov al, [bp+4]
  3314 0000119B 3C5A                     cmp al, 90
  3315 0000119D 0F8E1200                 jle @@letterE142
  3316 000011A1 8A4604                   mov al, [bp+4]
  3317 000011A4 3C61                     cmp al, 97
  3318 000011A6 0F8D0900                 jge @@letterE143
  3319 000011AA 66B800000000             mov eax, 0
  3320 000011B0 E90900                   jmp @@retn
  3321                                  @@letterE143:
  3322                                  
  3323                                  ;-37   return 1;
  3324                                  
  3325                                  @@letterE142:
  3326 000011B3 66B801000000             mov eax, 1
  3327 000011B9 E90000                   jmp @@retn
  3328                                  
  3329                                  ;-38 }
  3330                                  
  3331                                  
  3332                                  ;-39 int alnumE(char c) {
  3333                                  
  3334 000011BC C9                      @@retn: LEAVE
  3335 000011BD C3                       ret
  3336                                  ; ENDP
  3337                                  
  3338                                  alnumE:  ; *** PROC ***
  3339                                  
  3340                                  ;-40   if (digit(c)) return 1;
  3341                                  
  3342                                  ;Function : alnumE, Number of local variables: 1
  3343                                  ;   # type sign width line used address name   list of local variables
  3344                                  ;  250 var sign byte    39 NULL bp+4    c;
  3345 000011BE C8000000                 ENTER  0,0
  3346 000011C2 8A4604                   mov al, byte [bp+4]
  3347 000011C5 B400                     mov ah, 0
  3348 000011C7 50                       push ax
  3349 000011C8 E8231A                   call digit
  3350 000011CB 83C402                   add  sp, 2
  3351 000011CE 08C0                     or  al, al
  3352 000011D0 0F840900                 je @@alnumE144
  3353 000011D4 66B801000000             mov eax, 1
  3354 000011DA E92400                   jmp @@retn
  3355                                  
  3356                                  ;-41   if (letterE(c)) return 1;
  3357                                  
  3358                                  @@alnumE144:
  3359 000011DD 8A4604                   mov al, byte [bp+4]
  3360 000011E0 B400                     mov ah, 0
  3361 000011E2 50                       push ax
  3362 000011E3 E842FF                   call letterE
  3363 000011E6 83C402                   add  sp, 2
  3364 000011E9 08C0                     or  al, al
  3365 000011EB 0F840900                 je @@alnumE145
  3366 000011EF 66B801000000             mov eax, 1
  3367 000011F5 E90900                   jmp @@retn
  3368                                  
  3369                                  ;-42   return 0;
  3370                                  
  3371                                  @@alnumE145:
  3372 000011F8 66B800000000             mov eax, 0
  3373 000011FE E90000                   jmp @@retn
  3374                                  
  3375                                  ;-43 }
  3376                                  
  3377                                  
  3378                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3379                                  
  3380 00001201 C9                      @@retn: LEAVE
  3381 00001202 C3                       ret
  3382                                  ; ENDP
  3383                                  
  3384                                  getDigit:  ; *** PROC ***
  3385                                  
  3386                                  ;-45   unsigned int CastInt;
  3387                                  
  3388                                  
  3389                                  ;-46   SymbolInt=0;
  3390                                  
  3391                                  ;Function : getDigit, Number of local variables: 2
  3392                                  ;   # type sign width line used address name   list of local variables
  3393                                  ;  250 var unsg byte    44 NULL bp+4    c
  3394                                  ;  251 var unsg word    45 NULL bp-2    CastInt;
  3395 00001203 C8020000                 ENTER  2,0
  3396 00001207 66B800000000             mov eax, 0
  3397 0000120D A3[0E00]                 mov word [SymbolInt], ax
  3398                                  
  3399                                  ;-47   do {
  3400                                  
  3401                                  @@getDigit146:
  3402                                  
  3403                                  ;-48     c-='0';
  3404                                  
  3405 00001210 806E0430                 sub  byte [bp+4], 48
  3406                                  
  3407                                  ;-49     SymbolInt=SymbolInt*10;
  3408                                  
  3409 00001214 A1[0E00]                 mov ax, [SymbolInt]
  3410 00001217 66BB0A000000             mov ebx, 10
  3411 0000121D 66F7E3                   mul ebx
  3412 00001220 A3[0E00]                 mov word [SymbolInt], ax
  3413                                  
  3414                                  ;-50     ax=0; CastInt=c; //cast b2w
  3415                                  
  3416 00001223 B80000                   mov  ax, 0
  3417 00001226 8A4604                   mov al, [bp+4]
  3418 00001229 8946FE                   mov word [bp-2], ax
  3419                                  
  3420                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3421                                  
  3422 0000122C A1[0E00]                 mov ax, [SymbolInt]
  3423 0000122F 0346FE                   add ax, [bp-2]
  3424 00001232 A3[0E00]                 mov word [SymbolInt], ax
  3425                                  
  3426                                  ;-52     InputPtr++;
  3427                                  
  3428 00001235 FF06[1400]               inc  word [InputPtr]
  3429                                  
  3430                                  ;-53     c = *InputPtr;
  3431                                  
  3432 00001239 8B1E[1400]               mov bx, [InputPtr]
  3433 0000123D 8A07                     mov al, [bx]
  3434 0000123F B400                     mov ah, 0
  3435 00001241 884604                   mov byte [bp+4], al
  3436                                  
  3437                                  ;-54   } while(digit(c));
  3438                                  
  3439 00001244 8A4604                   mov al, byte [bp+4]
  3440 00001247 B400                     mov ah, 0
  3441 00001249 50                       push ax
  3442 0000124A E8A119                   call digit
  3443 0000124D 83C402                   add  sp, 2
  3444 00001250 08C0                     or  al, al
  3445 00001252 0F840200                 je @@getDigit147
  3446 00001256 EBB8                     jmp @@getDigit146
  3447                                  @@getDigit147:
  3448                                  
  3449                                  ;-55 }
  3450                                  
  3451                                  
  3452                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3453 00001258 C9                       LEAVE
  3454 00001259 C3                       ret
  3455                                  ; ENDP
  3456                                  
  3457                                  getName:  ; *** PROC ***
  3458                                  
  3459                                  ;-57   char *p; unsigned int i;
  3460                                  
  3461                                  
  3462                                  ;-58   p = &Symbol;
  3463                                  
  3464                                  ;Function : getName, Number of local variables: 3
  3465                                  ;   # type sign width line used address name   list of local variables
  3466                                  ;  250 var unsg byte    56 NULL bp+4    c
  3467                                  ;  251 ptr sign byte    57 NULL bp-2    p
  3468                                  ;  252 var unsg word    57 NULL bp-4    i;
  3469 0000125A C8040000                 ENTER  4,0
  3470 0000125E B83075                   mov ax, Symbol
  3471 00001261 8946FE                   mov word [bp-2], ax
  3472                                  
  3473                                  ;-59   *p = c;
  3474                                  
  3475 00001264 8A4604                   mov al, [bp+4]
  3476 00001267 8B5EFE                   mov  bx, [bp-2]
  3477 0000126A 8807                     mov  [bx], al
  3478                                  
  3479                                  ;-60   p++;
  3480                                  
  3481 0000126C FF46FE                   inc  word [bp-2]
  3482                                  
  3483                                  ;-61   while (alnumE(c)) {
  3484                                  
  3485                                  @@getName148:
  3486 0000126F 8A4604                   mov al, byte [bp+4]
  3487 00001272 B400                     mov ah, 0
  3488 00001274 50                       push ax
  3489 00001275 E846FF                   call alnumE
  3490 00001278 83C402                   add  sp, 2
  3491 0000127B 08C0                     or  al, al
  3492 0000127D 0F843800                 je @@getName149
  3493                                  
  3494                                  ;-62     InputPtr++;
  3495                                  
  3496 00001281 FF06[1400]               inc  word [InputPtr]
  3497                                  
  3498                                  ;-63     c = *InputPtr;
  3499                                  
  3500 00001285 8B1E[1400]               mov bx, [InputPtr]
  3501 00001289 8A07                     mov al, [bx]
  3502 0000128B B400                     mov ah, 0
  3503 0000128D 884604                   mov byte [bp+4], al
  3504                                  
  3505                                  ;-64     *p = c;
  3506                                  
  3507 00001290 8A4604                   mov al, [bp+4]
  3508 00001293 8B5EFE                   mov  bx, [bp-2]
  3509 00001296 8807                     mov  [bx], al
  3510                                  
  3511                                  ;-65     p++;
  3512                                  
  3513 00001298 FF46FE                   inc  word [bp-2]
  3514                                  
  3515                                  ;-66     i = p - &Symbol;
  3516                                  
  3517 0000129B 8B46FE                   mov ax, [bp-2]
  3518 0000129E 2D3075                   sub ax, Symbol
  3519 000012A1 8946FC                   mov word [bp-4], ax
  3520                                  
  3521                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3522                                  
  3523 000012A4 8B46FC                   mov ax, [bp-4]
  3524 000012A7 83F81F                   cmp ax, 31 ;unsigned : 0
  3525 000012AA 0F820900                 jb  @@getName150
  3526 000012AE 68[0213]                 push getName_0
  3527 000012B1 E86707                   call errorexit
  3528 000012B4 83C402                   add  sp, 2
  3529                                  
  3530                                  ;-68   }
  3531                                  
  3532                                  @@getName150:
  3533                                  
  3534                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3535                                  
  3536 000012B7 EBB6                     jmp @@getName148
  3537                                  @@getName149:
  3538 000012B9 8A4604                   mov al, [bp+4]
  3539 000012BC 3C3A                     cmp al, 58
  3540 000012BE 0F850C00                 jne @@getName151
  3541 000012C2 66B801000000             mov eax, 1
  3542 000012C8 A2[2B00]                 mov byte [isLabel], al
  3543 000012CB E90900                   jmp @@getName152
  3544                                  @@getName151:
  3545 000012CE 66B800000000             mov eax, 0
  3546 000012D4 A2[2B00]                 mov byte [isLabel], al
  3547                                  
  3548                                  ;-70   p--;
  3549                                  
  3550                                  @@getName152:
  3551 000012D7 FF4EFE                   dec  word [bp-2]
  3552                                  
  3553                                  ;-71   *p = 0;
  3554                                  
  3555 000012DA 66B800000000             mov eax, 0
  3556 000012E0 8B5EFE                   mov  bx, [bp-2]
  3557 000012E3 8807                     mov  [bx], al
  3558                                  
  3559                                  ;-72   strcpy(SymbolUpper, Symbol);
  3560                                  
  3561 000012E5 8D063075                 lea  ax, [Symbol]
  3562 000012E9 50                       push ax
  3563 000012EA 8D064F75                 lea  ax, [SymbolUpper]
  3564 000012EE 50                       push ax
  3565 000012EF E8C318                   call strcpy
  3566 000012F2 83C404                   add  sp, 4
  3567                                  
  3568                                  ;-73   toupper(SymbolUpper);
  3569                                  
  3570 000012F5 8D064F75                 lea  ax, [SymbolUpper]
  3571 000012F9 50                       push ax
  3572 000012FA E84A18                   call toupper
  3573 000012FD 83C402                   add  sp, 2
  3574                                  
  3575                                  ;-74 }
  3576                                  
  3577                                  
  3578                                  ;-75 int testReg() {
  3579 00001300 C9                       LEAVE
  3580 00001301 C3                       ret
  3581                                  ; ENDP
  3582 00001302 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3583 0000130B 6F206C6F6E6700     
  3584                                  
  3585                                  testReg:  ; *** PROC ***
  3586                                  
  3587                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3588                                  
  3589                                  
  3590                                  ;-77   R2Type=0;
  3591                                  
  3592 00001312 66B800000000             mov eax, 0
  3593 00001318 A2[3500]                 mov byte [R2Type], al
  3594                                  
  3595                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3596                                  
  3597 0000131B 8D063075                 lea  ax, [Symbol]
  3598 0000131F 50                       push ax
  3599 00001320 E86718                   call strlen
  3600 00001323 83C402                   add  sp, 2
  3601 00001326 3C02                     cmp al, 2
  3602 00001328 0F8D0900                 jge @@testReg153
  3603 0000132C 66B800000000             mov eax, 0
  3604 00001332 E9B603                   jmp @@retn
  3605                                  
  3606                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3607                                  
  3608                                  @@testReg153:
  3609 00001335 8D063075                 lea  ax, [Symbol]
  3610 00001339 50                       push ax
  3611 0000133A E84D18                   call strlen
  3612 0000133D 83C402                   add  sp, 2
  3613 00001340 3C03                     cmp al, 3
  3614 00001342 0F8E0900                 jle @@testReg154
  3615 00001346 66B800000000             mov eax, 0
  3616 0000134C E99C03                   jmp @@retn
  3617                                  
  3618                                  ;-80   R2Type=BYTE;
  3619                                  
  3620                                  @@testReg154:
  3621 0000134F 66B801000000             mov eax, 1
  3622 00001355 A2[3500]                 mov byte [R2Type], al
  3623                                  
  3624                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3625                                  
  3626 00001358 68[EC16]                 push testReg_0
  3627 0000135B 8D064F75                 lea  ax, [SymbolUpper]
  3628 0000135F 50                       push ax
  3629 00001360 E8BE18                   call eqstr
  3630 00001363 83C404                   add  sp, 4
  3631 00001366 08C0                     or  al, al
  3632 00001368 0F840900                 je @@testReg155
  3633 0000136C 66B800000000             mov eax, 0
  3634 00001372 E97603                   jmp @@retn
  3635                                  
  3636                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3637                                  
  3638                                  @@testReg155:
  3639 00001375 68[EF16]                 push testReg_1
  3640 00001378 8D064F75                 lea  ax, [SymbolUpper]
  3641 0000137C 50                       push ax
  3642 0000137D E8A118                   call eqstr
  3643 00001380 83C404                   add  sp, 4
  3644 00001383 08C0                     or  al, al
  3645 00001385 0F840900                 je @@testReg156
  3646 00001389 66B801000000             mov eax, 1
  3647 0000138F E95903                   jmp @@retn
  3648                                  
  3649                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3650                                  
  3651                                  @@testReg156:
  3652 00001392 68[F216]                 push testReg_2
  3653 00001395 8D064F75                 lea  ax, [SymbolUpper]
  3654 00001399 50                       push ax
  3655 0000139A E88418                   call eqstr
  3656 0000139D 83C404                   add  sp, 4
  3657 000013A0 08C0                     or  al, al
  3658 000013A2 0F840900                 je @@testReg157
  3659 000013A6 66B802000000             mov eax, 2
  3660 000013AC E93C03                   jmp @@retn
  3661                                  
  3662                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3663                                  
  3664                                  @@testReg157:
  3665 000013AF 68[F516]                 push testReg_3
  3666 000013B2 8D064F75                 lea  ax, [SymbolUpper]
  3667 000013B6 50                       push ax
  3668 000013B7 E86718                   call eqstr
  3669 000013BA 83C404                   add  sp, 4
  3670 000013BD 08C0                     or  al, al
  3671 000013BF 0F840900                 je @@testReg158
  3672 000013C3 66B803000000             mov eax, 3
  3673 000013C9 E91F03                   jmp @@retn
  3674                                  
  3675                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3676                                  
  3677                                  @@testReg158:
  3678 000013CC 68[F816]                 push testReg_4
  3679 000013CF 8D064F75                 lea  ax, [SymbolUpper]
  3680 000013D3 50                       push ax
  3681 000013D4 E84A18                   call eqstr
  3682 000013D7 83C404                   add  sp, 4
  3683 000013DA 08C0                     or  al, al
  3684 000013DC 0F840900                 je @@testReg159
  3685 000013E0 66B804000000             mov eax, 4
  3686 000013E6 E90203                   jmp @@retn
  3687                                  
  3688                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3689                                  
  3690                                  @@testReg159:
  3691 000013E9 68[FB16]                 push testReg_5
  3692 000013EC 8D064F75                 lea  ax, [SymbolUpper]
  3693 000013F0 50                       push ax
  3694 000013F1 E82D18                   call eqstr
  3695 000013F4 83C404                   add  sp, 4
  3696 000013F7 08C0                     or  al, al
  3697 000013F9 0F840900                 je @@testReg160
  3698 000013FD 66B805000000             mov eax, 5
  3699 00001403 E9E502                   jmp @@retn
  3700                                  
  3701                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3702                                  
  3703                                  @@testReg160:
  3704 00001406 68[FE16]                 push testReg_6
  3705 00001409 8D064F75                 lea  ax, [SymbolUpper]
  3706 0000140D 50                       push ax
  3707 0000140E E81018                   call eqstr
  3708 00001411 83C404                   add  sp, 4
  3709 00001414 08C0                     or  al, al
  3710 00001416 0F840900                 je @@testReg161
  3711 0000141A 66B806000000             mov eax, 6
  3712 00001420 E9C802                   jmp @@retn
  3713                                  
  3714                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3715                                  
  3716                                  @@testReg161:
  3717 00001423 68[0117]                 push testReg_7
  3718 00001426 8D064F75                 lea  ax, [SymbolUpper]
  3719 0000142A 50                       push ax
  3720 0000142B E8F317                   call eqstr
  3721 0000142E 83C404                   add  sp, 4
  3722 00001431 08C0                     or  al, al
  3723 00001433 0F840900                 je @@testReg162
  3724 00001437 66B807000000             mov eax, 7
  3725 0000143D E9AB02                   jmp @@retn
  3726                                  
  3727                                  ;-89   R2Type=WORD;
  3728                                  
  3729                                  @@testReg162:
  3730 00001440 66B802000000             mov eax, 2
  3731 00001446 A2[3500]                 mov byte [R2Type], al
  3732                                  
  3733                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3734                                  
  3735 00001449 68[0417]                 push testReg_8
  3736 0000144C 8D064F75                 lea  ax, [SymbolUpper]
  3737 00001450 50                       push ax
  3738 00001451 E8CD17                   call eqstr
  3739 00001454 83C404                   add  sp, 4
  3740 00001457 08C0                     or  al, al
  3741 00001459 0F840900                 je @@testReg163
  3742 0000145D 66B800000000             mov eax, 0
  3743 00001463 E98502                   jmp @@retn
  3744                                  
  3745                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3746                                  
  3747                                  @@testReg163:
  3748 00001466 68[0717]                 push testReg_9
  3749 00001469 8D064F75                 lea  ax, [SymbolUpper]
  3750 0000146D 50                       push ax
  3751 0000146E E8B017                   call eqstr
  3752 00001471 83C404                   add  sp, 4
  3753 00001474 08C0                     or  al, al
  3754 00001476 0F840900                 je @@testReg164
  3755 0000147A 66B801000000             mov eax, 1
  3756 00001480 E96802                   jmp @@retn
  3757                                  
  3758                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3759                                  
  3760                                  @@testReg164:
  3761 00001483 68[0A17]                 push testReg_10
  3762 00001486 8D064F75                 lea  ax, [SymbolUpper]
  3763 0000148A 50                       push ax
  3764 0000148B E89317                   call eqstr
  3765 0000148E 83C404                   add  sp, 4
  3766 00001491 08C0                     or  al, al
  3767 00001493 0F840900                 je @@testReg165
  3768 00001497 66B802000000             mov eax, 2
  3769 0000149D E94B02                   jmp @@retn
  3770                                  
  3771                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3772                                  
  3773                                  @@testReg165:
  3774 000014A0 68[0D17]                 push testReg_11
  3775 000014A3 8D064F75                 lea  ax, [SymbolUpper]
  3776 000014A7 50                       push ax
  3777 000014A8 E87617                   call eqstr
  3778 000014AB 83C404                   add  sp, 4
  3779 000014AE 08C0                     or  al, al
  3780 000014B0 0F840900                 je @@testReg166
  3781 000014B4 66B803000000             mov eax, 3
  3782 000014BA E92E02                   jmp @@retn
  3783                                  
  3784                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3785                                  
  3786                                  @@testReg166:
  3787 000014BD 68[1017]                 push testReg_12
  3788 000014C0 8D064F75                 lea  ax, [SymbolUpper]
  3789 000014C4 50                       push ax
  3790 000014C5 E85917                   call eqstr
  3791 000014C8 83C404                   add  sp, 4
  3792 000014CB 08C0                     or  al, al
  3793 000014CD 0F840900                 je @@testReg167
  3794 000014D1 66B804000000             mov eax, 4
  3795 000014D7 E91102                   jmp @@retn
  3796                                  
  3797                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3798                                  
  3799                                  @@testReg167:
  3800 000014DA 68[1317]                 push testReg_13
  3801 000014DD 8D064F75                 lea  ax, [SymbolUpper]
  3802 000014E1 50                       push ax
  3803 000014E2 E83C17                   call eqstr
  3804 000014E5 83C404                   add  sp, 4
  3805 000014E8 08C0                     or  al, al
  3806 000014EA 0F840900                 je @@testReg168
  3807 000014EE 66B805000000             mov eax, 5
  3808 000014F4 E9F401                   jmp @@retn
  3809                                  
  3810                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3811                                  
  3812                                  @@testReg168:
  3813 000014F7 68[1617]                 push testReg_14
  3814 000014FA 8D064F75                 lea  ax, [SymbolUpper]
  3815 000014FE 50                       push ax
  3816 000014FF E81F17                   call eqstr
  3817 00001502 83C404                   add  sp, 4
  3818 00001505 08C0                     or  al, al
  3819 00001507 0F840900                 je @@testReg169
  3820 0000150B 66B806000000             mov eax, 6
  3821 00001511 E9D701                   jmp @@retn
  3822                                  
  3823                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3824                                  
  3825                                  @@testReg169:
  3826 00001514 68[1917]                 push testReg_15
  3827 00001517 8D064F75                 lea  ax, [SymbolUpper]
  3828 0000151B 50                       push ax
  3829 0000151C E80217                   call eqstr
  3830 0000151F 83C404                   add  sp, 4
  3831 00001522 08C0                     or  al, al
  3832 00001524 0F840900                 je @@testReg170
  3833 00001528 66B807000000             mov eax, 7
  3834 0000152E E9BA01                   jmp @@retn
  3835                                  
  3836                                  ;-98   R2Type=SEGREG;
  3837                                  
  3838                                  @@testReg170:
  3839 00001531 66B804000000             mov eax, 4
  3840 00001537 A2[3500]                 mov byte [R2Type], al
  3841                                  
  3842                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3843                                  
  3844 0000153A 68[1C17]                 push testReg_16
  3845 0000153D 8D064F75                 lea  ax, [SymbolUpper]
  3846 00001541 50                       push ax
  3847 00001542 E8DC16                   call eqstr
  3848 00001545 83C404                   add  sp, 4
  3849 00001548 08C0                     or  al, al
  3850 0000154A 0F840900                 je @@testReg171
  3851 0000154E 66B800000000             mov eax, 0
  3852 00001554 E99401                   jmp @@retn
  3853                                  
  3854                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3855                                  
  3856                                  @@testReg171:
  3857 00001557 68[1F17]                 push testReg_17
  3858 0000155A 8D064F75                 lea  ax, [SymbolUpper]
  3859 0000155E 50                       push ax
  3860 0000155F E8BF16                   call eqstr
  3861 00001562 83C404                   add  sp, 4
  3862 00001565 08C0                     or  al, al
  3863 00001567 0F840900                 je @@testReg172
  3864 0000156B 66B801000000             mov eax, 1
  3865 00001571 E97701                   jmp @@retn
  3866                                  
  3867                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3868                                  
  3869                                  @@testReg172:
  3870 00001574 68[2217]                 push testReg_18
  3871 00001577 8D064F75                 lea  ax, [SymbolUpper]
  3872 0000157B 50                       push ax
  3873 0000157C E8A216                   call eqstr
  3874 0000157F 83C404                   add  sp, 4
  3875 00001582 08C0                     or  al, al
  3876 00001584 0F840900                 je @@testReg173
  3877 00001588 66B802000000             mov eax, 2
  3878 0000158E E95A01                   jmp @@retn
  3879                                  
  3880                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3881                                  
  3882                                  @@testReg173:
  3883 00001591 68[2517]                 push testReg_19
  3884 00001594 8D064F75                 lea  ax, [SymbolUpper]
  3885 00001598 50                       push ax
  3886 00001599 E88516                   call eqstr
  3887 0000159C 83C404                   add  sp, 4
  3888 0000159F 08C0                     or  al, al
  3889 000015A1 0F840900                 je @@testReg174
  3890 000015A5 66B803000000             mov eax, 3
  3891 000015AB E93D01                   jmp @@retn
  3892                                  
  3893                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3894                                  
  3895                                  @@testReg174:
  3896 000015AE 68[2817]                 push testReg_20
  3897 000015B1 8D064F75                 lea  ax, [SymbolUpper]
  3898 000015B5 50                       push ax
  3899 000015B6 E86816                   call eqstr
  3900 000015B9 83C404                   add  sp, 4
  3901 000015BC 08C0                     or  al, al
  3902 000015BE 0F840900                 je @@testReg175
  3903 000015C2 66B804000000             mov eax, 4
  3904 000015C8 E92001                   jmp @@retn
  3905                                  
  3906                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3907                                  
  3908                                  @@testReg175:
  3909 000015CB 68[2B17]                 push testReg_21
  3910 000015CE 8D064F75                 lea  ax, [SymbolUpper]
  3911 000015D2 50                       push ax
  3912 000015D3 E84B16                   call eqstr
  3913 000015D6 83C404                   add  sp, 4
  3914 000015D9 08C0                     or  al, al
  3915 000015DB 0F840900                 je @@testReg176
  3916 000015DF 66B805000000             mov eax, 5
  3917 000015E5 E90301                   jmp @@retn
  3918                                  
  3919                                  ;-105   R2Type=DWORD;                         
  3920                                  
  3921                                  @@testReg176:
  3922 000015E8 66B803000000             mov eax, 3
  3923 000015EE A2[3500]                 mov byte [R2Type], al
  3924                                  
  3925                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3926                                  
  3927 000015F1 68[2E17]                 push testReg_22
  3928 000015F4 8D064F75                 lea  ax, [SymbolUpper]
  3929 000015F8 50                       push ax
  3930 000015F9 E82516                   call eqstr
  3931 000015FC 83C404                   add  sp, 4
  3932 000015FF 08C0                     or  al, al
  3933 00001601 0F840900                 je @@testReg177
  3934 00001605 66B800000000             mov eax, 0
  3935 0000160B E9DD00                   jmp @@retn
  3936                                  
  3937                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3938                                  
  3939                                  @@testReg177:
  3940 0000160E 68[3217]                 push testReg_23
  3941 00001611 8D064F75                 lea  ax, [SymbolUpper]
  3942 00001615 50                       push ax
  3943 00001616 E80816                   call eqstr
  3944 00001619 83C404                   add  sp, 4
  3945 0000161C 08C0                     or  al, al
  3946 0000161E 0F840900                 je @@testReg178
  3947 00001622 66B801000000             mov eax, 1
  3948 00001628 E9C000                   jmp @@retn
  3949                                  
  3950                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3951                                  
  3952                                  @@testReg178:
  3953 0000162B 68[3617]                 push testReg_24
  3954 0000162E 8D064F75                 lea  ax, [SymbolUpper]
  3955 00001632 50                       push ax
  3956 00001633 E8EB15                   call eqstr
  3957 00001636 83C404                   add  sp, 4
  3958 00001639 08C0                     or  al, al
  3959 0000163B 0F840900                 je @@testReg179
  3960 0000163F 66B802000000             mov eax, 2
  3961 00001645 E9A300                   jmp @@retn
  3962                                  
  3963                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3964                                  
  3965                                  @@testReg179:
  3966 00001648 68[3A17]                 push testReg_25
  3967 0000164B 8D064F75                 lea  ax, [SymbolUpper]
  3968 0000164F 50                       push ax
  3969 00001650 E8CE15                   call eqstr
  3970 00001653 83C404                   add  sp, 4
  3971 00001656 08C0                     or  al, al
  3972 00001658 0F840900                 je @@testReg180
  3973 0000165C 66B803000000             mov eax, 3
  3974 00001662 E98600                   jmp @@retn
  3975                                  
  3976                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3977                                  
  3978                                  @@testReg180:
  3979 00001665 68[3E17]                 push testReg_26
  3980 00001668 8D064F75                 lea  ax, [SymbolUpper]
  3981 0000166C 50                       push ax
  3982 0000166D E8B115                   call eqstr
  3983 00001670 83C404                   add  sp, 4
  3984 00001673 08C0                     or  al, al
  3985 00001675 0F840900                 je @@testReg181
  3986 00001679 66B804000000             mov eax, 4
  3987 0000167F E96900                   jmp @@retn
  3988                                  
  3989                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3990                                  
  3991                                  @@testReg181:
  3992 00001682 68[4217]                 push testReg_27
  3993 00001685 8D064F75                 lea  ax, [SymbolUpper]
  3994 00001689 50                       push ax
  3995 0000168A E89415                   call eqstr
  3996 0000168D 83C404                   add  sp, 4
  3997 00001690 08C0                     or  al, al
  3998 00001692 0F840900                 je @@testReg182
  3999 00001696 66B805000000             mov eax, 5
  4000 0000169C E94C00                   jmp @@retn
  4001                                  
  4002                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  4003                                  
  4004                                  @@testReg182:
  4005 0000169F 68[4617]                 push testReg_28
  4006 000016A2 8D064F75                 lea  ax, [SymbolUpper]
  4007 000016A6 50                       push ax
  4008 000016A7 E87715                   call eqstr
  4009 000016AA 83C404                   add  sp, 4
  4010 000016AD 08C0                     or  al, al
  4011 000016AF 0F840900                 je @@testReg183
  4012 000016B3 66B806000000             mov eax, 6
  4013 000016B9 E92F00                   jmp @@retn
  4014                                  
  4015                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  4016                                  
  4017                                  @@testReg183:
  4018 000016BC 68[4A17]                 push testReg_29
  4019 000016BF 8D064F75                 lea  ax, [SymbolUpper]
  4020 000016C3 50                       push ax
  4021 000016C4 E85A15                   call eqstr
  4022 000016C7 83C404                   add  sp, 4
  4023 000016CA 08C0                     or  al, al
  4024 000016CC 0F840900                 je @@testReg184
  4025 000016D0 66B807000000             mov eax, 7
  4026 000016D6 E91200                   jmp @@retn
  4027                                  
  4028                                  ;-114   R2Type=0; return 0;
  4029                                  
  4030                                  @@testReg184:
  4031 000016D9 66B800000000             mov eax, 0
  4032 000016DF A2[3500]                 mov byte [R2Type], al
  4033 000016E2 66B800000000             mov eax, 0
  4034 000016E8 E90000                   jmp @@retn
  4035                                  
  4036                                  ;-115 }
  4037                                  
  4038                                  @@retn:
  4039 000016EB C3                       ret
  4040                                  ; ENDP
  4041 000016EC 414C00                  testReg_0 db "AL",0
  4042 000016EF 434C00                  testReg_1 db "CL",0
  4043 000016F2 444C00                  testReg_2 db "DL",0
  4044 000016F5 424C00                  testReg_3 db "BL",0
  4045 000016F8 414800                  testReg_4 db "AH",0
  4046 000016FB 434800                  testReg_5 db "CH",0
  4047 000016FE 444800                  testReg_6 db "DH",0
  4048 00001701 424800                  testReg_7 db "BH",0
  4049 00001704 415800                  testReg_8 db "AX",0
  4050 00001707 435800                  testReg_9 db "CX",0
  4051 0000170A 445800                  testReg_10 db "DX",0
  4052 0000170D 425800                  testReg_11 db "BX",0
  4053 00001710 535000                  testReg_12 db "SP",0
  4054 00001713 425000                  testReg_13 db "BP",0
  4055 00001716 534900                  testReg_14 db "SI",0
  4056 00001719 444900                  testReg_15 db "DI",0
  4057 0000171C 455300                  testReg_16 db "ES",0
  4058 0000171F 435300                  testReg_17 db "CS",0
  4059 00001722 535300                  testReg_18 db "SS",0
  4060 00001725 445300                  testReg_19 db "DS",0
  4061 00001728 465300                  testReg_20 db "FS",0
  4062 0000172B 475300                  testReg_21 db "GS",0
  4063 0000172E 45415800                testReg_22 db "EAX",0
  4064 00001732 45435800                testReg_23 db "ECX",0
  4065 00001736 45445800                testReg_24 db "EDX",0
  4066 0000173A 45425800                testReg_25 db "EBX",0
  4067 0000173E 45535000                testReg_26 db "ESP",0
  4068 00001742 45425000                testReg_27 db "EBP",0
  4069 00001746 45534900                testReg_28 db "ESI",0
  4070 0000174A 45444900                testReg_29 db "EDI",0
  4071                                  ;Back to main program: AS.C
  4072                                  
  4073                                  ;-7 #include "OUTPUT.C"
  4074                                  
  4075                                  ;Use include file: OUTPUT.C
  4076                                  
  4077                                  ;-1 int printLine() { 
  4078                                  
  4079                                  
  4080                                  printLine:  ; *** PROC ***
  4081                                  
  4082                                  ;-2     int i; char c;
  4083                                  
  4084                                  
  4085                                  ;-3     prs("\n"); 
  4086                                  
  4087                                  ;Function : printLine, Number of local variables: 2
  4088                                  ;   # type sign width line used address name   list of local variables
  4089                                  ;  250 var sign word     2 NULL bp-2    i
  4090                                  ;  251 var sign byte     2 NULL bp-4    c;
  4091 0000174E C8040000                 ENTER  4,0
  4092 00001752 68[E317]                 push printLine_0
  4093 00001755 E80301                   call prs
  4094 00001758 83C402                   add  sp, 2
  4095                                  
  4096                                  ;-4     printhex16(PCStart);
  4097                                  
  4098 0000175B FF36[2900]               push word [PCStart]
  4099 0000175F E8EE01                   call printhex16
  4100 00001762 83C402                   add  sp, 2
  4101                                  
  4102                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4103                                  
  4104 00001765 A1[4100]                 mov ax, [OpPrintIndex]
  4105 00001768 83F800                   cmp ax, 0
  4106 0000176B 0F850C00                 jne @@printLine185
  4107 0000176F 68[E617]                 push printLine_1
  4108 00001772 E8E600                   call prs
  4109 00001775 83C402                   add  sp, 2
  4110                                  
  4111                                  ;-6     else {
  4112                                  
  4113 00001778 E94F00                   jmp @@printLine186
  4114                                  @@printLine185:
  4115                                  
  4116                                  ;-7 //        prc(' ');
  4117                                  
  4118                                  
  4119                                  ;-8         i=0;
  4120                                  
  4121 0000177B 66B800000000             mov eax, 0
  4122 00001781 8946FE                   mov word [bp-2], ax
  4123                                  
  4124                                  ;-9         do {
  4125                                  
  4126                                  @@printLine187:
  4127                                  
  4128                                  ;-10             c=OpPos[i];
  4129                                  
  4130 00001784 8B5EFE                   mov bx, [bp-2]
  4131 00001787 8A873677                 mov al, [OpPos + bx]
  4132 0000178B 8846FC                   mov byte [bp-4], al
  4133                                  
  4134                                  ;-11             prc(' ');
  4135                                  
  4136 0000178E 6A20                     push 32
  4137 00001790 E86700                   call prc
  4138 00001793 83C402                   add  sp, 2
  4139                                  
  4140                                  ;-12             printhex8a(c); 
  4141                                  
  4142 00001796 8A46FC                   mov al, byte [bp-4]
  4143 00001799 B400                     mov ah, 0
  4144 0000179B 50                       push ax
  4145 0000179C E85F01                   call printhex8a
  4146 0000179F 83C402                   add  sp, 2
  4147                                  
  4148                                  ;-13             i++;
  4149                                  
  4150 000017A2 FF46FE                   inc  word [bp-2]
  4151                                  
  4152                                  ;-14         } while (i < OpPrintIndex);
  4153                                  
  4154 000017A5 8B46FE                   mov ax, [bp-2]
  4155 000017A8 3B06[4100]               cmp ax, [OpPrintIndex]
  4156 000017AC 0F8D0200                 jge @@printLine188
  4157 000017B0 EBD2                     jmp @@printLine187
  4158                                  @@printLine188:
  4159                                  
  4160                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4161                                  
  4162                                  @@printLine189:
  4163 000017B2 8B46FE                   mov ax, [bp-2]
  4164 000017B5 83F805                   cmp ax, 5
  4165 000017B8 0F8D0E00                 jge @@printLine190
  4166                                  
  4167                                  ;-16             prs("   ");
  4168                                  
  4169 000017BC 68[F617]                 push printLine_2
  4170 000017BF E89900                   call prs
  4171 000017C2 83C402                   add  sp, 2
  4172                                  
  4173                                  ;-17             i++;
  4174                                  
  4175 000017C5 FF46FE                   inc  word [bp-2]
  4176                                  
  4177                                  ;-18         }
  4178                                  
  4179                                  
  4180                                  ;-19     }
  4181                                  
  4182 000017C8 EBE8                     jmp @@printLine189
  4183                                  @@printLine190:
  4184                                  
  4185                                  ;-20     prc(PrintRA);
  4186                                  
  4187                                  @@printLine186:
  4188 000017CA A0[4500]                 mov al, byte [PrintRA]
  4189 000017CD B400                     mov ah, 0
  4190 000017CF 50                       push ax
  4191 000017D0 E82700                   call prc
  4192 000017D3 83C402                   add  sp, 2
  4193                                  
  4194                                  ;-21     prscomment(InputBuf);
  4195                                  
  4196 000017D6 8D066E75                 lea  ax, [InputBuf]
  4197 000017DA 50                       push ax
  4198 000017DB E84F00                   call prscomment
  4199 000017DE 83C402                   add  sp, 2
  4200                                  
  4201                                  ;-22 }
  4202                                  
  4203                                  
  4204                                  ;-23 int prc(unsigned char c) {//print char 
  4205 000017E1 C9                       LEAVE
  4206 000017E2 C3                       ret
  4207                                  ; ENDP
  4208 000017E3 5C6E00                  printLine_0 db "\n",0
  4209 000017E6 202020202020202020-     printLine_1 db "               ",0
  4210 000017EF 20202020202000     
  4211 000017F6 20202000                printLine_2 db "   ",0
  4212                                  
  4213                                  prc:  ; *** PROC ***
  4214                                  
  4215                                  ;-24     if (LIST) { 
  4216                                  
  4217                                  ;Function : prc, Number of local variables: 1
  4218                                  ;   # type sign width line used address name   list of local variables
  4219                                  ;  250 var unsg byte    23 NULL bp+4    c;
  4220 000017FA C8000000                 ENTER  0,0
  4221 000017FE A0[0D00]                 mov al, [LIST]
  4222 00001801 08C0                     or  al, al
  4223 00001803 0F841400                 je @@prc191
  4224                                  
  4225                                  ;-25         if ( _ c==10) {
  4226                                  
  4227 00001807 807E040A                cmp byte [bp+4], 10
  4228 0000180B 0F850600                 jne @@prc192
  4229                                  
  4230                                  ;-26             ax=13; 
  4231                                  
  4232 0000180F B80D00                   mov  ax, 13
  4233                                  
  4234                                  ;-27             writetty(); 
  4235                                  
  4236 00001812 E8FC12                   call writetty
  4237                                  
  4238                                  ;-28             }
  4239                                  
  4240                                  
  4241                                  ;-29         al=c; 
  4242                                  
  4243                                  @@prc192:
  4244 00001815 8A4604                   mov  al, [bp+4]
  4245                                  
  4246                                  ;-30         writetty(); 
  4247                                  
  4248 00001818 E8F612                   call writetty
  4249                                  
  4250                                  ;-31         }
  4251                                  
  4252                                  
  4253                                  ;-32     fputcR(c,lst_fd); 
  4254                                  
  4255                                  @@prc191:
  4256 0000181B FF36[1800]               push word [lst_fd]
  4257 0000181F 8A4604                   mov al, byte [bp+4]
  4258 00001822 B400                     mov ah, 0
  4259 00001824 50                       push ax
  4260 00001825 E8A914                   call fputcR
  4261 00001828 83C404                   add  sp, 4
  4262                                  
  4263                                  ;-33 }
  4264                                  
  4265                                  
  4266                                  ;-34 
  4267                                  
  4268                                  
  4269                                  ;-35 int prscomment(unsigned char *s) {
  4270 0000182B C9                       LEAVE
  4271 0000182C C3                       ret
  4272                                  ; ENDP
  4273                                  
  4274                                  prscomment:  ; *** PROC ***
  4275                                  
  4276                                  ;-36     unsigned char c;
  4277                                  
  4278                                  
  4279                                  ;-37     while (*s){
  4280                                  
  4281                                  ;Function : prscomment, Number of local variables: 2
  4282                                  ;   # type sign width line used address name   list of local variables
  4283                                  ;  250 ptr unsg byte    35 NULL bp+4    s
  4284                                  ;  251 var unsg byte    36 NULL bp-2    c;
  4285 0000182D C8020000                 ENTER  2,0
  4286                                  @@prscomment193:
  4287 00001831 8B5E04                   mov bx, [bp+4]
  4288 00001834 8A07                     mov al, [bx]
  4289 00001836 B400                     mov ah, 0
  4290 00001838 08C0                     or  al, al
  4291 0000183A 0F841B00                 je @@prscomment194
  4292                                  
  4293                                  ;-38         c=*s;
  4294                                  
  4295 0000183E 8B5E04                   mov bx, [bp+4]
  4296 00001841 8A07                     mov al, [bx]
  4297 00001843 B400                     mov ah, 0
  4298 00001845 8846FE                   mov byte [bp-2], al
  4299                                  
  4300                                  ;-39         prc(c);
  4301                                  
  4302 00001848 8A46FE                   mov al, byte [bp-2]
  4303 0000184B B400                     mov ah, 0
  4304 0000184D 50                       push ax
  4305 0000184E E8A9FF                   call prc
  4306 00001851 83C402                   add  sp, 2
  4307                                  
  4308                                  ;-40         s++;
  4309                                  
  4310 00001854 FF4604                   inc  word [bp+4]
  4311                                  
  4312                                  ;-41     }
  4313                                  
  4314                                  
  4315                                  ;-42 }
  4316                                  
  4317 00001857 EBD8                     jmp @@prscomment193
  4318                                  @@prscomment194:
  4319                                  
  4320                                  ;-43 int prs(unsigned char *s) {
  4321 00001859 C9                       LEAVE
  4322 0000185A C3                       ret
  4323                                  ; ENDP
  4324                                  
  4325                                  prs:  ; *** PROC ***
  4326                                  
  4327                                  ;-44     unsigned char c; 
  4328                                  
  4329                                  
  4330                                  ;-45     int com; 
  4331                                  
  4332                                  
  4333                                  ;-46     com=0;
  4334                                  
  4335                                  ;Function : prs, Number of local variables: 3
  4336                                  ;   # type sign width line used address name   list of local variables
  4337                                  ;  250 ptr unsg byte    43 NULL bp+4    s
  4338                                  ;  251 var unsg byte    44 NULL bp-2    c
  4339                                  ;  252 var sign word    45 NULL bp-4    com;
  4340 0000185B C8040000                 ENTER  4,0
  4341 0000185F 66B800000000             mov eax, 0
  4342 00001865 8946FC                   mov word [bp-4], ax
  4343                                  
  4344                                  ;-47     while (*s) { 
  4345                                  
  4346                                  @@prs195:
  4347 00001868 8B5E04                   mov bx, [bp+4]
  4348 0000186B 8A07                     mov al, [bx]
  4349 0000186D B400                     mov ah, 0
  4350 0000186F 08C0                     or  al, al
  4351 00001871 0F848700                 je @@prs196
  4352                                  
  4353                                  ;-48         c=*s; 
  4354                                  
  4355 00001875 8B5E04                   mov bx, [bp+4]
  4356 00001878 8A07                     mov al, [bx]
  4357 0000187A B400                     mov ah, 0
  4358 0000187C 8846FE                   mov byte [bp-2], al
  4359                                  
  4360                                  ;-49         if (c==34) {
  4361                                  
  4362 0000187F 8A46FE                   mov al, [bp-2]
  4363 00001882 3C22                     cmp al, 34
  4364 00001884 0F851E00                 jne @@prs197
  4365                                  
  4366                                  ;-50             if (com) com=0; 
  4367                                  
  4368 00001888 8B46FC                   mov ax, [bp-4]
  4369 0000188B 08C0                     or  al, al
  4370 0000188D 0F840C00                 je @@prs198
  4371 00001891 66B800000000             mov eax, 0
  4372 00001897 8946FC                   mov word [bp-4], ax
  4373                                  
  4374                                  ;-51                 else com=1;  
  4375                                  
  4376 0000189A E90900                   jmp @@prs199
  4377                                  @@prs198:
  4378 0000189D 66B801000000             mov eax, 1
  4379 000018A3 8946FC                   mov word [bp-4], ax
  4380                                  
  4381                                  ;-52         }
  4382                                  
  4383                                  @@prs199:
  4384                                  
  4385                                  ;-53         if (c==92) { 
  4386                                  
  4387                                  @@prs197:
  4388 000018A6 8A46FE                   mov al, [bp-2]
  4389 000018A9 3C5C                     cmp al, 92
  4390 000018AB 0F853B00                 jne @@prs200
  4391                                  
  4392                                  ;-54             if (com==0) { 
  4393                                  
  4394 000018AF 8B46FC                   mov ax, [bp-4]
  4395 000018B2 83F800                   cmp ax, 0
  4396 000018B5 0F853100                 jne @@prs201
  4397                                  
  4398                                  ;-55                 s++; 
  4399                                  
  4400 000018B9 FF4604                   inc  word [bp+4]
  4401                                  
  4402                                  ;-56                 c=*s;
  4403                                  
  4404 000018BC 8B5E04                   mov bx, [bp+4]
  4405 000018BF 8A07                     mov al, [bx]
  4406 000018C1 B400                     mov ah, 0
  4407 000018C3 8846FE                   mov byte [bp-2], al
  4408                                  
  4409                                  ;-57                 if (c=='n') c=10; 
  4410                                  
  4411 000018C6 8A46FE                   mov al, [bp-2]
  4412 000018C9 3C6E                     cmp al, 110
  4413 000018CB 0F850900                 jne @@prs202
  4414 000018CF 66B80A000000             mov eax, 10
  4415 000018D5 8846FE                   mov byte [bp-2], al
  4416                                  
  4417                                  ;-58                 if (c=='t') c= 9; 
  4418                                  
  4419                                  @@prs202:
  4420 000018D8 8A46FE                   mov al, [bp-2]
  4421 000018DB 3C74                     cmp al, 116
  4422 000018DD 0F850900                 jne @@prs203
  4423 000018E1 66B809000000             mov eax, 9
  4424 000018E7 8846FE                   mov byte [bp-2], al
  4425                                  
  4426                                  ;-59             } 
  4427                                  
  4428                                  @@prs203:
  4429                                  
  4430                                  ;-60         } 
  4431                                  
  4432                                  @@prs201:
  4433                                  
  4434                                  ;-61         prc(c); 
  4435                                  
  4436                                  @@prs200:
  4437 000018EA 8A46FE                   mov al, byte [bp-2]
  4438 000018ED B400                     mov ah, 0
  4439 000018EF 50                       push ax
  4440 000018F0 E807FF                   call prc
  4441 000018F3 83C402                   add  sp, 2
  4442                                  
  4443                                  ;-62         s++;  
  4444                                  
  4445 000018F6 FF4604                   inc  word [bp+4]
  4446                                  
  4447                                  ;-63     }
  4448                                  
  4449                                  
  4450                                  ;-64 }
  4451                                  
  4452 000018F9 E96CFF                   jmp @@prs195
  4453                                  @@prs196:
  4454                                  
  4455                                  ;-65 int printhex8a(unsigned char c) { 
  4456 000018FC C9                       LEAVE
  4457 000018FD C3                       ret
  4458                                  ; ENDP
  4459                                  
  4460                                  printhex8a:  ; *** PROC ***
  4461                                  
  4462                                  ;-66     unsigned char nib;
  4463                                  
  4464                                  
  4465                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4466                                  
  4467                                  ;Function : printhex8a, Number of local variables: 2
  4468                                  ;   # type sign width line used address name   list of local variables
  4469                                  ;  250 var unsg byte    65 NULL bp+4    c
  4470                                  ;  251 var unsg byte    66 NULL bp-2    nib;
  4471 000018FE C8020000                 ENTER  2,0
  4472 00001902 8A4604                   mov al, [bp+4]
  4473 00001905 C0E804                   shr al, 4
  4474 00001908 8846FE                   mov byte [bp-2], al
  4475 0000190B 8A46FE                   mov al, byte [bp-2]
  4476 0000190E B400                     mov ah, 0
  4477 00001910 50                       push ax
  4478 00001911 E81900                   call printhex4
  4479 00001914 83C402                   add  sp, 2
  4480                                  
  4481                                  ;-68     nib = c & 15; printhex4(nib);                    
  4482                                  
  4483 00001917 8A4604                   mov al, [bp+4]
  4484 0000191A 240F                     and al, 15
  4485 0000191C 8846FE                   mov byte [bp-2], al
  4486 0000191F 8A46FE                   mov al, byte [bp-2]
  4487 00001922 B400                     mov ah, 0
  4488 00001924 50                       push ax
  4489 00001925 E80500                   call printhex4
  4490 00001928 83C402                   add  sp, 2
  4491                                  
  4492                                  ;-69 } 
  4493                                  
  4494                                  
  4495                                  ;-70 int printhex4(unsigned char c) {
  4496 0000192B C9                       LEAVE
  4497 0000192C C3                       ret
  4498                                  ; ENDP
  4499                                  
  4500                                  printhex4:  ; *** PROC ***
  4501                                  
  4502                                  ;-71     c += 48; 
  4503                                  
  4504                                  ;Function : printhex4, Number of local variables: 1
  4505                                  ;   # type sign width line used address name   list of local variables
  4506                                  ;  250 var unsg byte    70 NULL bp+4    c;
  4507 0000192D C8000000                 ENTER  0,0
  4508 00001931 80460430                 add  byte [bp+4], 48
  4509                                  
  4510                                  ;-72     if (c > 57) c += 7; 
  4511                                  
  4512 00001935 8A4604                   mov al, [bp+4]
  4513 00001938 3C39                     cmp al, 57
  4514 0000193A 0F8E0400                 jle @@printhex4204
  4515 0000193E 80460407                 add  byte [bp+4], 7
  4516                                  
  4517                                  ;-73     prc(c);      
  4518                                  
  4519                                  @@printhex4204:
  4520 00001942 8A4604                   mov al, byte [bp+4]
  4521 00001945 B400                     mov ah, 0
  4522 00001947 50                       push ax
  4523 00001948 E8AFFE                   call prc
  4524 0000194B 83C402                   add  sp, 2
  4525                                  
  4526                                  ;-74 }
  4527                                  
  4528                                  
  4529                                  ;-75 int printhex16(unsigned int i) {
  4530 0000194E C9                       LEAVE
  4531 0000194F C3                       ret
  4532                                  ; ENDP
  4533                                  
  4534                                  printhex16:  ; *** PROC ***
  4535                                  
  4536                                  ;-76     unsigned int half;
  4537                                  
  4538                                  
  4539                                  ;-77     half = i >>  8; printhex8a(half); 
  4540                                  
  4541                                  ;Function : printhex16, Number of local variables: 2
  4542                                  ;   # type sign width line used address name   list of local variables
  4543                                  ;  250 var unsg word    75 NULL bp+4    i
  4544                                  ;  251 var unsg word    76 NULL bp-2    half;
  4545 00001950 C8020000                 ENTER  2,0
  4546 00001954 8B4604                   mov ax, [bp+4]
  4547 00001957 C1E808                   shr ax, 8
  4548 0000195A 8946FE                   mov word [bp-2], ax
  4549 0000195D FF76FE                   push word [bp-2]
  4550 00001960 E89BFF                   call printhex8a
  4551 00001963 83C402                   add  sp, 2
  4552                                  
  4553                                  ;-78     half = i & 255; printhex8a(half);
  4554                                  
  4555 00001966 8B4604                   mov ax, [bp+4]
  4556 00001969 25FF00                   and ax, 255
  4557 0000196C 8946FE                   mov word [bp-2], ax
  4558 0000196F FF76FE                   push word [bp-2]
  4559 00001972 E889FF                   call printhex8a
  4560 00001975 83C402                   add  sp, 2
  4561                                  
  4562                                  ;-79 }
  4563                                  
  4564                                  
  4565                                  ;-80 int printIntU(unsigned int n) { 
  4566 00001978 C9                       LEAVE
  4567 00001979 C3                       ret
  4568                                  ; ENDP
  4569                                  
  4570                                  printIntU:  ; *** PROC ***
  4571                                  
  4572                                  ;-81     unsigned int e;
  4573                                  
  4574                                  
  4575                                  ;-82     if ( _ n >= 10) {  
  4576                                  
  4577                                  ;Function : printIntU, Number of local variables: 2
  4578                                  ;   # type sign width line used address name   list of local variables
  4579                                  ;  250 var unsg word    80 NULL bp+4    n
  4580                                  ;  251 var unsg word    81 NULL bp-2    e;
  4581 0000197A C8020000                 ENTER  2,0
  4582 0000197E 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4583 00001982 0F821700                 jb  @@printIntU205
  4584                                  
  4585                                  ;-83         e=n/10; //DIV
  4586                                  
  4587 00001986 8B4604                   mov ax, [bp+4]
  4588 00001989 BB0A00                   mov bx, 10
  4589 0000198C BA0000                   mov dx, 0
  4590 0000198F F7F3                     div bx
  4591 00001991 8946FE                   mov word [bp-2], ax
  4592                                  
  4593                                  ;-84         printIntU(e); 
  4594                                  
  4595 00001994 FF76FE                   push word [bp-2]
  4596 00001997 E8E0FF                   call printIntU
  4597 0000199A 83C402                   add  sp, 2
  4598                                  
  4599                                  ;-85     }
  4600                                  
  4601                                  
  4602                                  ;-86     n = n % 10; //unsigned mod
  4603                                  
  4604                                  @@printIntU205:
  4605 0000199D 8B4604                   mov ax, [bp+4]
  4606 000019A0 BB0A00                   mov bx, 10
  4607 000019A3 BA0000                   mov dx, 0
  4608 000019A6 F7F3                     div bx
  4609 000019A8 89D0                     mov ax, dx
  4610 000019AA 894604                   mov word [bp+4], ax
  4611                                  
  4612                                  ;-87     n += '0'; 
  4613                                  
  4614 000019AD 83460430                 add  word [bp+4], 48
  4615                                  
  4616                                  ;-88     prc(n);
  4617                                  
  4618 000019B1 FF7604                   push word [bp+4]
  4619 000019B4 E843FE                   call prc
  4620 000019B7 83C402                   add  sp, 2
  4621                                  
  4622                                  ;-89 }
  4623                                  
  4624                                  
  4625                                  ;-90 
  4626                                  
  4627                                  
  4628                                  ;-91 int error1(char *s) { 
  4629 000019BA C9                       LEAVE
  4630 000019BB C3                       ret
  4631                                  ; ENDP
  4632                                  
  4633                                  error1:  ; *** PROC ***
  4634                                  
  4635                                  ;-92     LIST=1; 
  4636                                  
  4637                                  ;Function : error1, Number of local variables: 1
  4638                                  ;   # type sign width line used address name   list of local variables
  4639                                  ;  250 ptr sign byte    91 NULL bp+4    s;
  4640 000019BC C8000000                 ENTER  0,0
  4641 000019C0 66B801000000             mov eax, 1
  4642 000019C6 A2[0D00]                 mov byte [LIST], al
  4643                                  
  4644                                  ;-93     ErrorCount++;
  4645                                  
  4646 000019C9 FF06[1E00]               inc  word [ErrorCount]
  4647                                  
  4648                                  ;-94     prs("\n;***** next line ERROR: "); 
  4649                                  
  4650 000019CD 68[F519]                 push error1_0
  4651 000019D0 E888FE                   call prs
  4652 000019D3 83C402                   add  sp, 2
  4653                                  
  4654                                  ;-95     prs(s);
  4655                                  
  4656 000019D6 FF7604                   push word [bp+4]
  4657 000019D9 E87FFE                   call prs
  4658 000019DC 83C402                   add  sp, 2
  4659                                  
  4660                                  ;-96     prs(", Symbol: "); 
  4661                                  
  4662 000019DF 68[101A]                 push error1_1
  4663 000019E2 E876FE                   call prs
  4664 000019E5 83C402                   add  sp, 2
  4665                                  
  4666                                  ;-97     prs(Symbol);
  4667                                  
  4668 000019E8 8D063075                 lea  ax, [Symbol]
  4669 000019EC 50                       push ax
  4670 000019ED E86BFE                   call prs
  4671 000019F0 83C402                   add  sp, 2
  4672                                  
  4673                                  ;-98 }
  4674                                  
  4675                                  
  4676                                  ;-99 int errorexit(char *s) { 
  4677 000019F3 C9                       LEAVE
  4678 000019F4 C3                       ret
  4679                                  ; ENDP
  4680 000019F5 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4681 000019FE 6E657874206C696E65-
  4682 00001A07 204552524F523A2000 
  4683 00001A10 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4684 00001A19 2000               
  4685                                  
  4686                                  errorexit:  ; *** PROC ***
  4687                                  
  4688                                  ;-100     error1(s); 
  4689                                  
  4690                                  ;Function : errorexit, Number of local variables: 1
  4691                                  ;   # type sign width line used address name   list of local variables
  4692                                  ;  250 ptr sign byte    99 NULL bp+4    s;
  4693 00001A1B C8000000                 ENTER  0,0
  4694 00001A1F FF7604                   push word [bp+4]
  4695 00001A22 E897FF                   call error1
  4696 00001A25 83C402                   add  sp, 2
  4697                                  
  4698                                  ;-101     end1(1);
  4699                                  
  4700 00001A28 6A01                     push 1
  4701 00001A2A E81406                   call end1
  4702 00001A2D 83C402                   add  sp, 2
  4703                                  
  4704                                  ;-102 }
  4705                                  
  4706                                  
  4707                                  ;-103 int allowederror() {error1("not allowed here"); }
  4708 00001A30 C9                       LEAVE
  4709 00001A31 C3                       ret
  4710                                  ; ENDP
  4711                                  
  4712                                  allowederror:  ; *** PROC ***
  4713 00001A32 68[3C1A]                 push allowederror_0
  4714 00001A35 E884FF                   call error1
  4715 00001A38 83C402                   add  sp, 2
  4716                                  
  4717                                  ;-104 int addrerror()    {error1("address missing");} 
  4718                                  
  4719 00001A3B C3                       ret
  4720                                  ; ENDP
  4721 00001A3C 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4722 00001A45 6564206865726500   
  4723                                  
  4724                                  addrerror:  ; *** PROC ***
  4725 00001A4D 68[571A]                 push addrerror_0
  4726 00001A50 E869FF                   call error1
  4727 00001A53 83C402                   add  sp, 2
  4728                                  
  4729                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4730                                  
  4731 00001A56 C3                       ret
  4732                                  ; ENDP
  4733 00001A57 61646472657373206D-     addrerror_0 db "address missing",0
  4734 00001A60 697373696E6700     
  4735                                  
  4736                                  immeerror:  ; *** PROC ***
  4737 00001A67 68[711A]                 push immeerror_0
  4738 00001A6A E84FFF                   call error1
  4739 00001A6D 83C402                   add  sp, 2
  4740                                  
  4741                                  ;-106 int implerror()    {error1("not implemented");}
  4742                                  
  4743 00001A70 C3                       ret
  4744                                  ; ENDP
  4745 00001A71 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4746 00001A7A 206E6F7420616C6C6F-
  4747 00001A83 776564206865726500 
  4748                                  
  4749                                  implerror:  ; *** PROC ***
  4750 00001A8C 68[961A]                 push implerror_0
  4751 00001A8F E82AFF                   call error1
  4752 00001A92 83C402                   add  sp, 2
  4753                                  
  4754                                  ;-107 int indexerror()   {error1("invalid index register");}
  4755                                  
  4756 00001A95 C3                       ret
  4757                                  ; ENDP
  4758 00001A96 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4759 00001A9F 6D656E74656400     
  4760                                  
  4761                                  indexerror:  ; *** PROC ***
  4762 00001AA6 68[B01A]                 push indexerror_0
  4763 00001AA9 E810FF                   call error1
  4764 00001AAC 83C402                   add  sp, 2
  4765                                  
  4766                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4767                                  
  4768 00001AAF C3                       ret
  4769                                  ; ENDP
  4770 00001AB0 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4771 00001AB9 6E6465782072656769-
  4772 00001AC2 7374657200         
  4773                                  
  4774                                  invaloperror:  ; *** PROC ***
  4775 00001AC7 68[D11A]                 push invaloperror_0
  4776 00001ACA E8EFFE                   call error1
  4777 00001ACD 83C402                   add  sp, 2
  4778                                  
  4779                                  ;-109 int numbererror()  {error1("number expected");}
  4780                                  
  4781 00001AD0 C3                       ret
  4782                                  ; ENDP
  4783 00001AD1 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4784 00001ADA 72206E6F206F706572-
  4785 00001AE3 616E647300         
  4786                                  
  4787                                  numbererror:  ; *** PROC ***
  4788 00001AE8 68[F21A]                 push numbererror_0
  4789 00001AEB E8CEFE                   call error1
  4790 00001AEE 83C402                   add  sp, 2
  4791                                  
  4792                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4793                                  
  4794 00001AF1 C3                       ret
  4795                                  ; ENDP
  4796 00001AF2 6E756D626572206578-     numbererror_0 db "number expected",0
  4797 00001AFB 70656374656400     
  4798                                  
  4799                                  regmemerror:  ; *** PROC ***
  4800 00001B02 68[0C1B]                 push regmemerror_0
  4801 00001B05 E8B4FE                   call error1
  4802 00001B08 83C402                   add  sp, 2
  4803                                  
  4804                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4805                                  
  4806 00001B0B C3                       ret
  4807                                  ; ENDP
  4808 00001B0C 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4809 00001B15 73746572206F72206D-
  4810 00001B1E 656D6F727920616C6C-
  4811 00001B27 6F77656400         
  4812                                  
  4813                                  reg16error:  ; *** PROC ***
  4814 00001B2C 68[361B]                 push reg16error_0
  4815 00001B2F E88AFE                   call error1
  4816 00001B32 83C402                   add  sp, 2
  4817                                  
  4818                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4819                                  
  4820 00001B35 C3                       ret
  4821                                  ; ENDP
  4822 00001B36 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4823 00001B3F 362C206E6F20736567-
  4824 00001B48 72656720616C6C6F77-
  4825 00001B51 656400             
  4826                                  
  4827                                  segregerror:  ; *** PROC ***
  4828 00001B54 68[5E1B]                 push segregerror_0
  4829 00001B57 E862FE                   call error1
  4830 00001B5A 83C402                   add  sp, 2
  4831                                  
  4832                                  ;-113 int syntaxerror()  {error1("syntax");}
  4833                                  
  4834 00001B5D C3                       ret
  4835                                  ; ENDP
  4836 00001B5E 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4837 00001B67 65676973746572206E-
  4838 00001B70 6F7420616C6C6F7765-
  4839 00001B79 6400               
  4840                                  
  4841                                  syntaxerror:  ; *** PROC ***
  4842 00001B7B 68[851B]                 push syntaxerror_0
  4843 00001B7E E83BFE                   call error1
  4844 00001B81 83C402                   add  sp, 2
  4845                                  
  4846                                  ;-114          
  4847                                  
  4848                                  
  4849                                  ;-115 int addrexit()     {errorexit("illegal address");}   
  4850                                  
  4851 00001B84 C3                       ret
  4852                                  ; ENDP
  4853 00001B85 73796E74617800          syntaxerror_0 db "syntax",0
  4854                                  
  4855                                  addrexit:  ; *** PROC ***
  4856 00001B8C 68[961B]                 push addrexit_0
  4857 00001B8F E889FE                   call errorexit
  4858 00001B92 83C402                   add  sp, 2
  4859                                  
  4860                                  ;-116 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  4861                                  
  4862 00001B95 C3                       ret
  4863                                  ; ENDP
  4864 00001B96 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4865 00001B9F 64647265737300     
  4866                                  
  4867                                  dataexit:  ; *** PROC ***
  4868 00001BA6 68[B01B]                 push dataexit_0
  4869 00001BA9 E86FFE                   call errorexit
  4870 00001BAC 83C402                   add  sp, 2
  4871                                  
  4872                                  ;-117 int internexit()   {errorexit("intern compiler error");}
  4873                                  
  4874 00001BAF C3                       ret
  4875                                  ; ENDP
  4876 00001BB0 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  4877 00001BB9 6F7220524553422C57-
  4878 00001BC2 2C4420657870656374-
  4879 00001BCB 656400             
  4880                                  
  4881                                  internexit:  ; *** PROC ***
  4882 00001BCE 68[D81B]                 push internexit_0
  4883 00001BD1 E847FE                   call errorexit
  4884 00001BD4 83C402                   add  sp, 2
  4885 00001BD7 C3                       ret
  4886                                  ; ENDP
  4887 00001BD8 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4888 00001BE1 6D70696C6572206572-
  4889 00001BEA 726F7200           
  4890                                  ;Back to main program: AS.C
  4891                                  
  4892                                  ;-8 #include "MAIN.C"
  4893                                  
  4894                                  ;Use include file: MAIN.C
  4895                                  
  4896                                  ;-1 int main() {
  4897                                  
  4898                                  
  4899                                  main:  ; *** PROC ***
  4900                                  
  4901                                  ;-2     getarg(); 
  4902                                  
  4903 00001BEE E80D00                   call getarg
  4904                                  
  4905                                  ;-3     parse(); 
  4906                                  
  4907 00001BF1 E8AAED                   call parse
  4908                                  
  4909                                  ;-4     fixJmpCall();
  4910                                  
  4911 00001BF4 E85F02                   call fixJmpCall
  4912                                  
  4913                                  ;-5     epilog(); 
  4914                                  
  4915 00001BF7 E84B03                   call epilog
  4916                                  
  4917                                  ;-6     end1();
  4918                                  
  4919 00001BFA E84404                   call end1
  4920                                  
  4921                                  ;-7 }
  4922                                  
  4923                                  
  4924                                  ;-8 
  4925                                  
  4926                                  
  4927                                  ;-9 int getarg() { 
  4928                                  
  4929 00001BFD C3                       ret
  4930                                  ; ENDP
  4931                                  
  4932                                  getarg:  ; *** PROC ***
  4933                                  
  4934                                  ;-10     int arglen1; int i; char *c;
  4935                                  
  4936                                  
  4937                                  ;-11     arglen1=*arglen;
  4938                                  
  4939                                  ;Function : getarg, Number of local variables: 3
  4940                                  ;   # type sign width line used address name   list of local variables
  4941                                  ;  250 var sign word    10 NULL bp-2    arglen1
  4942                                  ;  251 var sign word    10 NULL bp-4    i
  4943                                  ;  252 ptr sign byte    10 NULL bp-6    c;
  4944 00001BFE C8060000                 ENTER  6,0
  4945 00001C02 8B1E[5200]               mov bx, [arglen]
  4946 00001C06 8A07                     mov al, [bx]
  4947 00001C08 B400                     mov ah, 0
  4948 00001C0A 8946FE                   mov word [bp-2], ax
  4949                                  
  4950                                  ;-12     if (arglen1==0) {
  4951                                  
  4952 00001C0D 8B46FE                   mov ax, [bp-2]
  4953 00001C10 83F800                   cmp ax, 0
  4954 00001C13 0F851C00                 jne @@getarg206
  4955                                  
  4956                                  ;-13         cputs(Version1);
  4957                                  
  4958 00001C17 8D06[0300]               lea  ax, [Version1]
  4959 00001C1B 50                       push ax
  4960 00001C1C E8FA0E                   call cputs
  4961 00001C1F 83C402                   add  sp, 2
  4962                                  
  4963                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4964                                  
  4965 00001C22 68[C31D]                 push getarg_0
  4966 00001C25 E8F10E                   call cputs
  4967 00001C28 83C402                   add  sp, 2
  4968                                  
  4969                                  ;-15         exitR(3);
  4970                                  
  4971 00001C2B 6A03                     push 3
  4972 00001C2D E8C410                   call exitR
  4973 00001C30 83C402                   add  sp, 2
  4974                                  
  4975                                  ;-16     }
  4976                                  
  4977                                  
  4978                                  ;-17     i=arglen1+129; 
  4979                                  
  4980                                  @@getarg206:
  4981 00001C33 8B46FE                   mov ax, [bp-2]
  4982 00001C36 058100                   add ax, 129
  4983 00001C39 8946FC                   mov word [bp-4], ax
  4984                                  
  4985                                  ;-18     *i=0;  
  4986                                  
  4987 00001C3C 66B800000000             mov eax, 0
  4988 00001C42 8B5EFC                   mov  bx, [bp-4]
  4989 00001C45 8907                     mov  [bx], ax
  4990                                  
  4991                                  ;-19     arglen1--;
  4992                                  
  4993 00001C47 FF4EFE                   dec  word [bp-2]
  4994                                  
  4995                                  ;-20     toupper(argv);
  4996                                  
  4997 00001C4A FF36[5400]               push word [argv]
  4998 00001C4E E8F60E                   call toupper
  4999 00001C51 83C402                   add  sp, 2
  5000                                  
  5001                                  ;-21   
  5002                                  
  5003                                  
  5004                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  5005                                  
  5006 00001C54 FF36[5400]               push word [argv]
  5007 00001C58 8D066D76                 lea  ax, [namein]
  5008 00001C5C 50                       push ax
  5009 00001C5D E8550F                   call strcpy
  5010 00001C60 83C404                   add  sp, 4
  5011 00001C63 68[E81D]                 push getarg_1
  5012 00001C66 8D066D76                 lea  ax, [namein]
  5013 00001C6A 50                       push ax
  5014 00001C6B E80810                   call strcat1
  5015 00001C6E 83C404                   add  sp, 4
  5016                                  
  5017                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  5018                                  
  5019 00001C71 FF36[5400]               push word [argv]
  5020 00001C75 8D06B076                 lea  ax, [namelst]
  5021 00001C79 50                       push ax
  5022 00001C7A E8380F                   call strcpy
  5023 00001C7D 83C404                   add  sp, 4
  5024 00001C80 68[EB1D]                 push getarg_2
  5025 00001C83 8D06B076                 lea  ax, [namelst]
  5026 00001C87 50                       push ax
  5027 00001C88 E8EB0F                   call strcat1
  5028 00001C8B 83C404                   add  sp, 4
  5029                                  
  5030                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  5031                                  
  5032 00001C8E FF36[5400]               push word [argv]
  5033 00001C92 8D06F376                 lea  ax, [namebin]
  5034 00001C96 50                       push ax
  5035 00001C97 E81B0F                   call strcpy
  5036 00001C9A 83C404                   add  sp, 4
  5037 00001C9D 68[F01D]                 push getarg_3
  5038 00001CA0 8D06F376                 lea  ax, [namebin]
  5039 00001CA4 50                       push ax
  5040 00001CA5 E8CE0F                   call strcat1
  5041 00001CA8 83C404                   add  sp, 4
  5042                                  
  5043                                  ;-25 
  5044                                  
  5045                                  
  5046                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  5047                                  
  5048 00001CAB 66B801000000             mov eax, 1
  5049 00001CB1 A2[0D00]                 mov byte [LIST], al
  5050 00001CB4 66B800000000             mov eax, 0
  5051 00001CBA A3[1C00]                 mov word [DOS_ERR], ax
  5052 00001CBD 66B800000000             mov eax, 0
  5053 00001CC3 A3[2300]                 mov word [PC], ax
  5054 00001CC6 66B800000000             mov eax, 0
  5055 00001CCC A3[1E00]                 mov word [ErrorCount], ax
  5056                                  
  5057                                  ;-27   
  5058                                  
  5059                                  
  5060                                  ;-28     asm_fd=openR (namein);
  5061                                  
  5062 00001CCF 8D066D76                 lea  ax, [namein]
  5063 00001CD3 50                       push ax
  5064 00001CD4 E8C40F                   call openR
  5065 00001CD7 83C402                   add  sp, 2
  5066 00001CDA A3[1600]                 mov word [asm_fd], ax
  5067                                  
  5068                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5069                                  
  5070 00001CDD A1[1C00]                 mov ax, [DOS_ERR]
  5071 00001CE0 08C0                     or  al, al
  5072 00001CE2 0F841C00                 je @@getarg207
  5073 00001CE6 68[F51D]                 push getarg_4
  5074 00001CE9 E82D0E                   call cputs
  5075 00001CEC 83C402                   add  sp, 2
  5076 00001CEF 8D066D76                 lea  ax, [namein]
  5077 00001CF3 50                       push ax
  5078 00001CF4 E8220E                   call cputs
  5079 00001CF7 83C402                   add  sp, 2
  5080 00001CFA 6A01                     push 1
  5081 00001CFC E8F50F                   call exitR
  5082 00001CFF 83C402                   add  sp, 2
  5083                                  
  5084                                  ;-30     lst_fd=creatR(namelst);
  5085                                  
  5086                                  @@getarg207:
  5087 00001D02 8D06B076                 lea  ax, [namelst]
  5088 00001D06 50                       push ax
  5089 00001D07 E8A00F                   call creatR
  5090 00001D0A 83C402                   add  sp, 2
  5091 00001D0D A3[1800]                 mov word [lst_fd], ax
  5092                                  
  5093                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5094                                  
  5095 00001D10 A1[1C00]                 mov ax, [DOS_ERR]
  5096 00001D13 08C0                     or  al, al
  5097 00001D15 0F841C00                 je @@getarg208
  5098 00001D19 68[0B1E]                 push getarg_5
  5099 00001D1C E8FA0D                   call cputs
  5100 00001D1F 83C402                   add  sp, 2
  5101 00001D22 8D06B076                 lea  ax, [namelst]
  5102 00001D26 50                       push ax
  5103 00001D27 E8EF0D                   call cputs
  5104 00001D2A 83C402                   add  sp, 2
  5105 00001D2D 6A02                     push 2
  5106 00001D2F E8C20F                   call exitR
  5107 00001D32 83C402                   add  sp, 2
  5108                                  
  5109                                  ;-32     bin_fd=creatR(namebin);
  5110                                  
  5111                                  @@getarg208:
  5112 00001D35 8D06F376                 lea  ax, [namebin]
  5113 00001D39 50                       push ax
  5114 00001D3A E86D0F                   call creatR
  5115 00001D3D 83C402                   add  sp, 2
  5116 00001D40 A3[1A00]                 mov word [bin_fd], ax
  5117                                  
  5118                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5119                                  
  5120 00001D43 A1[1C00]                 mov ax, [DOS_ERR]
  5121 00001D46 08C0                     or  al, al
  5122 00001D48 0F841C00                 je @@getarg209
  5123 00001D4C 68[221E]                 push getarg_6
  5124 00001D4F E8C70D                   call cputs
  5125 00001D52 83C402                   add  sp, 2
  5126 00001D55 8D06F376                 lea  ax, [namebin]
  5127 00001D59 50                       push ax
  5128 00001D5A E8BC0D                   call cputs
  5129 00001D5D 83C402                   add  sp, 2
  5130 00001D60 6A02                     push 2
  5131 00001D62 E88F0F                   call exitR
  5132 00001D65 83C402                   add  sp, 2
  5133                                  
  5134                                  ;-34   
  5135                                  
  5136                                  
  5137                                  ;-35     prs(";"); 
  5138                                  
  5139                                  @@getarg209:
  5140 00001D68 68[381E]                 push getarg_7
  5141 00001D6B E8EDFA                   call prs
  5142 00001D6E 83C402                   add  sp, 2
  5143                                  
  5144                                  ;-36     prs(Version1);
  5145                                  
  5146 00001D71 8D06[0300]               lea  ax, [Version1]
  5147 00001D75 50                       push ax
  5148 00001D76 E8E2FA                   call prs
  5149 00001D79 83C402                   add  sp, 2
  5150                                  
  5151                                  ;-37     prs(", Source: "); prs(namein);  
  5152                                  
  5153 00001D7C 68[3A1E]                 push getarg_8
  5154 00001D7F E8D9FA                   call prs
  5155 00001D82 83C402                   add  sp, 2
  5156 00001D85 8D066D76                 lea  ax, [namein]
  5157 00001D89 50                       push ax
  5158 00001D8A E8CEFA                   call prs
  5159 00001D8D 83C402                   add  sp, 2
  5160                                  
  5161                                  ;-38     prs(", Output: "); prs(namelst);
  5162                                  
  5163 00001D90 68[451E]                 push getarg_9
  5164 00001D93 E8C5FA                   call prs
  5165 00001D96 83C402                   add  sp, 2
  5166 00001D99 8D06B076                 lea  ax, [namelst]
  5167 00001D9D 50                       push ax
  5168 00001D9E E8BAFA                   call prs
  5169 00001DA1 83C402                   add  sp, 2
  5170                                  
  5171                                  ;-39     prs(", "); prs(namebin);
  5172                                  
  5173 00001DA4 68[501E]                 push getarg_10
  5174 00001DA7 E8B1FA                   call prs
  5175 00001DAA 83C402                   add  sp, 2
  5176 00001DAD 8D06F376                 lea  ax, [namebin]
  5177 00001DB1 50                       push ax
  5178 00001DB2 E8A6FA                   call prs
  5179 00001DB5 83C402                   add  sp, 2
  5180                                  
  5181                                  ;-40     prs("\n");
  5182                                  
  5183 00001DB8 68[531E]                 push getarg_11
  5184 00001DBB E89DFA                   call prs
  5185 00001DBE 83C402                   add  sp, 2
  5186                                  
  5187                                  ;-41 }
  5188                                  
  5189                                  
  5190                                  ;-42 
  5191                                  
  5192                                  
  5193                                  ;-43 int fixJmpCall() {
  5194 00001DC1 C9                       LEAVE
  5195 00001DC2 C3                       ret
  5196                                  ; ENDP
  5197 00001DC3 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5198 00001DCC 41532E434F4D206669-
  5199 00001DD5 6C656E616D65205B77-
  5200 00001DDE 2F6F202E535D203A20-
  5201 00001DE7 00                 
  5202 00001DE8 2E5300                  getarg_1 db ".S",0
  5203 00001DEB 2E4C535400              getarg_2 db ".LST",0
  5204 00001DF0 2E434F4D00              getarg_3 db ".COM",0
  5205 00001DF5 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5206 00001DFE 6C65206D697373696E-
  5207 00001E07 673A2000           
  5208 00001E0B 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5209 00001E14 206E6F742063726561-
  5210 00001E1D 74653A2000         
  5211 00001E22 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5212 00001E2B 6E6F74206372656174-
  5213 00001E34 653A2000           
  5214 00001E38 3B00                    getarg_7 db ";",0
  5215 00001E3A 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5216 00001E43 2000               
  5217 00001E45 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5218 00001E4E 2000               
  5219 00001E50 2C2000                  getarg_10 db ", ",0
  5220 00001E53 5C6E00                  getarg_11 db "\n",0
  5221                                  
  5222                                  fixJmpCall:  ; *** PROC ***
  5223                                  
  5224                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5225                                  
  5226                                  
  5227                                  ;-45     i=1;     
  5228                                  
  5229                                  ;Function : fixJmpCall, Number of local variables: 5
  5230                                  ;   # type sign width line used address name   list of local variables
  5231                                  ;  250 var sign word    44 NULL bp-2    i
  5232                                  ;  251 var unsg word    44 NULL bp-4    hex
  5233                                  ;  252 ptr sign byte    44 NULL bp-6    p
  5234                                  ;  253 var sign word    44 NULL bp-8    Ix
  5235                                  ;  254 var sign byte    44 NULL bp-10    c;
  5236 00001E56 C80A0000                 ENTER  10,0
  5237 00001E5A 66B801000000             mov eax, 1
  5238 00001E60 8946FE                   mov word [bp-2], ax
  5239                                  
  5240                                  ;-46     prs("\n;END open jmp/call: "); 
  5241                                  
  5242 00001E63 68[1E1F]                 push fixJmpCall_0
  5243 00001E66 E8F2F9                   call prs
  5244 00001E69 83C402                   add  sp, 2
  5245                                  
  5246                                  ;-47     printIntU(JmpCallMaxIx);      
  5247                                  
  5248 00001E6C FF36[4E00]               push word [JmpCallMaxIx]
  5249 00001E70 E807FB                   call printIntU
  5250 00001E73 83C402                   add  sp, 2
  5251                                  
  5252                                  ;-48     p = &JmpCallNames;   
  5253                                  
  5254 00001E76 B88B8B                   mov ax, JmpCallNames
  5255 00001E79 8946FA                   mov word [bp-6], ax
  5256                                  
  5257                                  ;-49     while (i <= JmpCallMaxIx) {
  5258                                  
  5259                                  @@fixJmpCall210:
  5260 00001E7C 8B46FE                   mov ax, [bp-2]
  5261 00001E7F 3B06[4E00]               cmp ax, [JmpCallMaxIx]
  5262 00001E83 0F8F9500                 jg  @@fixJmpCall211
  5263                                  
  5264                                  ;-50         strcpy(Symbol, p);
  5265                                  
  5266 00001E87 FF76FA                   push word [bp-6]
  5267 00001E8A 8D063075                 lea  ax, [Symbol]
  5268 00001E8E 50                       push ax
  5269 00001E8F E8230D                   call strcpy
  5270 00001E92 83C404                   add  sp, 4
  5271                                  
  5272                                  ;-51         p = strlen(Symbol) + p;
  5273                                  
  5274 00001E95 8D063075                 lea  ax, [Symbol]
  5275 00001E99 50                       push ax
  5276 00001E9A E8ED0C                   call strlen
  5277 00001E9D 83C402                   add  sp, 2
  5278 00001EA0 0346FA                   add ax, [bp-6]
  5279 00001EA3 8946FA                   mov word [bp-6], ax
  5280                                  
  5281                                  ;-52         p++;
  5282                                  
  5283 00001EA6 FF46FA                   inc  word [bp-6]
  5284                                  
  5285                                  ;-53 //        prs(Symbol);
  5286                                  
  5287                                  
  5288                                  ;-54 //        prc(' ');  
  5289                                  
  5290                                  
  5291                                  ;-55         hex = JmpCallAddr[i];
  5292                                  
  5293 00001EA9 8B5EFE                   mov bx, [bp-2]
  5294 00001EAC D1E3                     shl bx, 1
  5295 00001EAE 8B875B93                 mov ax, [JmpCallAddr + bx]
  5296 00001EB2 8946FC                   mov word [bp-4], ax
  5297                                  
  5298                                  ;-56 //        printhex16(hex);
  5299                                  
  5300                                  
  5301                                  ;-57             
  5302                                  
  5303                                  
  5304                                  ;-58         Ix=searchLabel();
  5305                                  
  5306 00001EB5 E8B9ED                   call searchLabel
  5307 00001EB8 8946F8                   mov word [bp-8], ax
  5308                                  
  5309                                  ;-59         if (Ix == 0) error1("Label not found");
  5310                                  
  5311 00001EBB 8B46F8                   mov ax, [bp-8]
  5312 00001EBE 83F800                   cmp ax, 0
  5313 00001EC1 0F850900                 jne @@fixJmpCall212
  5314 00001EC5 68[351F]                 push fixJmpCall_1
  5315 00001EC8 E8F1FA                   call error1
  5316 00001ECB 83C402                   add  sp, 2
  5317                                  
  5318                                  ;-60         disp = LabelAddr[Ix];
  5319                                  
  5320                                  @@fixJmpCall212:
  5321 00001ECE 8B5EF8                   mov bx, [bp-8]
  5322 00001ED1 D1E3                     shl bx, 1
  5323 00001ED3 8B87DB86                 mov ax, [LabelAddr + bx]
  5324 00001ED7 A3[3D00]                 mov word [disp], ax
  5325                                  
  5326                                  ;-61         disp = disp - hex;
  5327                                  
  5328 00001EDA A1[3D00]                 mov ax, [disp]
  5329 00001EDD 2B46FC                   sub ax, [bp-4]
  5330 00001EE0 A3[3D00]                 mov word [disp], ax
  5331                                  
  5332                                  ;-62         disp = disp - Origin;
  5333                                  
  5334 00001EE3 A1[3D00]                 mov ax, [disp]
  5335 00001EE6 2B06[2500]               sub ax, [Origin]
  5336 00001EEA A3[3D00]                 mov word [disp], ax
  5337                                  
  5338                                  ;-63 //        prs(", ");    
  5339                                  
  5340                                  
  5341                                  ;-64         
  5342                                  
  5343                                  
  5344                                  ;-65             hex = hex - 2;//fix at start of word              
  5345                                  
  5346 00001EED 8B46FC                   mov ax, [bp-4]
  5347 00001EF0 83E802                   sub ax, 2
  5348 00001EF3 8946FC                   mov word [bp-4], ax
  5349                                  
  5350                                  ;-66             FileBin[hex] = disp;//fix low byte    
  5351                                  
  5352 00001EF6 A1[3D00]                 mov ax, [disp]
  5353 00001EF9 8B5EFC                   mov bx, [bp-4]
  5354 00001EFC 88874397                 mov [FileBin+bx], al
  5355                                  
  5356                                  ;-67             hex++;
  5357                                  
  5358 00001F00 FF46FC                   inc  word [bp-4]
  5359                                  
  5360                                  ;-68             disp = disp >> 8;
  5361                                  
  5362 00001F03 A1[3D00]                 mov ax, [disp]
  5363 00001F06 C1E808                   shr ax, 8
  5364 00001F09 A3[3D00]                 mov word [disp], ax
  5365                                  
  5366                                  ;-69             FileBin[hex] = disp;            
  5367                                  
  5368 00001F0C A1[3D00]                 mov ax, [disp]
  5369 00001F0F 8B5EFC                   mov bx, [bp-4]
  5370 00001F12 88874397                 mov [FileBin+bx], al
  5371                                  
  5372                                  ;-70         i++;
  5373                                  
  5374 00001F16 FF46FE                   inc  word [bp-2]
  5375                                  
  5376                                  ;-71     }
  5377                                  
  5378                                  
  5379                                  ;-72 }
  5380                                  
  5381 00001F19 E960FF                   jmp @@fixJmpCall210
  5382                                  @@fixJmpCall211:
  5383                                  
  5384                                  ;-73 
  5385                                  
  5386                                  
  5387                                  ;-74 int epilog() { 
  5388 00001F1C C9                       LEAVE
  5389 00001F1D C3                       ret
  5390                                  ; ENDP
  5391 00001F1E 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5392 00001F27 656E206A6D702F6361-
  5393 00001F30 6C6C3A2000         
  5394 00001F35 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5395 00001F3E 20666F756E6400     
  5396                                  
  5397                                  epilog:  ; *** PROC ***
  5398                                  
  5399                                  ;-75     unsigned int i; char c;     int j;
  5400                                  
  5401                                  
  5402                                  ;-76     prs("\n Errors: "); 
  5403                                  
  5404                                  ;Function : epilog, Number of local variables: 3
  5405                                  ;   # type sign width line used address name   list of local variables
  5406                                  ;  250 var unsg word    75 NULL bp-2    i
  5407                                  ;  251 var sign byte    75 NULL bp-4    c
  5408                                  ;  252 var sign word    75 NULL bp-6    j;
  5409 00001F45 C8060000                 ENTER  6,0
  5410 00001F49 68[0320]                 push epilog_0
  5411 00001F4C E80CF9                   call prs
  5412 00001F4F 83C402                   add  sp, 2
  5413                                  
  5414                                  ;-77     printIntU(ErrorCount);
  5415                                  
  5416 00001F52 FF36[1E00]               push word [ErrorCount]
  5417 00001F56 E821FA                   call printIntU
  5418 00001F59 83C402                   add  sp, 2
  5419                                  
  5420                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5421                                  
  5422 00001F5C A1[1E00]                 mov ax, [ErrorCount]
  5423 00001F5F 08C0                     or  al, al
  5424 00001F61 0F840900                 je @@epilog213
  5425 00001F65 68[0F20]                 push epilog_1
  5426 00001F68 E8F0F8                   call prs
  5427 00001F6B 83C402                   add  sp, 2
  5428                                  
  5429                                  ;-79     prs(", Out: "); 
  5430                                  
  5431                                  @@epilog213:
  5432 00001F6E 68[1D20]                 push epilog_2
  5433 00001F71 E8E7F8                   call prs
  5434 00001F74 83C402                   add  sp, 2
  5435                                  
  5436                                  ;-80     prs(namelst);
  5437                                  
  5438 00001F77 8D06B076                 lea  ax, [namelst]
  5439 00001F7B 50                       push ax
  5440 00001F7C E8DCF8                   call prs
  5441 00001F7F 83C402                   add  sp, 2
  5442                                  
  5443                                  ;-81     prs(", ");
  5444                                  
  5445 00001F82 68[2520]                 push epilog_3
  5446 00001F85 E8D3F8                   call prs
  5447 00001F88 83C402                   add  sp, 2
  5448                                  
  5449                                  ;-82     prs(namebin); 
  5450                                  
  5451 00001F8B 8D06F376                 lea  ax, [namebin]
  5452 00001F8F 50                       push ax
  5453 00001F90 E8C8F8                   call prs
  5454 00001F93 83C402                   add  sp, 2
  5455                                  
  5456                                  ;-83     prs("= ");
  5457                                  
  5458 00001F96 68[2820]                 push epilog_4
  5459 00001F99 E8BFF8                   call prs
  5460 00001F9C 83C402                   add  sp, 2
  5461                                  
  5462                                  ;-84     printIntU(BinLen); 
  5463                                  
  5464 00001F9F FF36[5000]               push word [BinLen]
  5465 00001FA3 E8D4F9                   call printIntU
  5466 00001FA6 83C402                   add  sp, 2
  5467                                  
  5468                                  ;-85     prs(" bytes.");
  5469                                  
  5470 00001FA9 68[2B20]                 push epilog_5
  5471 00001FAC E8ACF8                   call prs
  5472 00001FAF 83C402                   add  sp, 2
  5473                                  
  5474                                  ;-86 
  5475                                  
  5476                                  
  5477                                  ;-87     i=0;
  5478                                  
  5479 00001FB2 66B800000000             mov eax, 0
  5480 00001FB8 8946FE                   mov word [bp-2], ax
  5481                                  
  5482                                  ;-88     do {
  5483                                  
  5484                                  @@epilog214:
  5485                                  
  5486                                  ;-89         c = FileBin[i];
  5487                                  
  5488 00001FBB 8B5EFE                   mov bx, [bp-2]
  5489 00001FBE 8A874397                 mov al, [FileBin + bx]
  5490 00001FC2 8846FC                   mov byte [bp-4], al
  5491                                  
  5492                                  ;-90         fputcR(c, bin_fd);  
  5493                                  
  5494 00001FC5 FF36[1A00]               push word [bin_fd]
  5495 00001FC9 8A46FC                   mov al, byte [bp-4]
  5496 00001FCC B400                     mov ah, 0
  5497 00001FCE 50                       push ax
  5498 00001FCF E8FF0C                   call fputcR
  5499 00001FD2 83C404                   add  sp, 4
  5500                                  
  5501                                  ;-91 //printhex8a(c); prc(' ');      
  5502                                  
  5503                                  
  5504                                  ;-92         i++;
  5505                                  
  5506 00001FD5 FF46FE                   inc  word [bp-2]
  5507                                  
  5508                                  ;-93     } while (i < BinLen);
  5509                                  
  5510 00001FD8 8B46FE                   mov ax, [bp-2]
  5511 00001FDB 3B06[5000]               cmp ax, [BinLen]
  5512 00001FDF 0F8D0200                 jge @@epilog215
  5513 00001FE3 EBD6                     jmp @@epilog214
  5514                                  @@epilog215:
  5515                                  
  5516                                  ;-94 
  5517                                  
  5518                                  
  5519                                  ;-95   prs("\ Labels: "); 
  5520                                  
  5521 00001FE5 68[3320]                 push epilog_6
  5522 00001FE8 E870F8                   call prs
  5523 00001FEB 83C402                   add  sp, 2
  5524                                  
  5525                                  ;-96   printIntU(LabelMaxIx); 
  5526                                  
  5527 00001FEE FF36[4800]               push word [LabelMaxIx]
  5528 00001FF2 E885F9                   call printIntU
  5529 00001FF5 83C402                   add  sp, 2
  5530                                  
  5531                                  ;-97   prs(". ");     
  5532                                  
  5533 00001FF8 68[3E20]                 push epilog_7
  5534 00001FFB E85DF8                   call prs
  5535 00001FFE 83C402                   add  sp, 2
  5536                                  
  5537                                  ;-98 /*  prs("size: ");
  5538                                  
  5539                                  
  5540                                  ;-99   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  5541                                  
  5542                                  
  5543                                  ;-100   prs(". >>");
  5544                                  
  5545                                  
  5546                                  ;-101   i= &LabelNames;
  5547                                  
  5548                                  
  5549                                  ;-102   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5550                                  
  5551                                  
  5552                                  ;-103   } while (i < LabelNamePtr); prs("<< \n");  */
  5553                                  
  5554                                  
  5555                                  ;-104 /*    i = 1;
  5556                                  
  5557                                  
  5558                                  ;-105     LabelNamePtr= &LabelNames;
  5559                                  
  5560                                  
  5561                                  ;-106     do {
  5562                                  
  5563                                  
  5564                                  ;-107       prs(LabelNamePtr); prc(' ');
  5565                                  
  5566                                  
  5567                                  ;-108       j=LabelAddr[i]; printhex16(j); prs(", ");
  5568                                  
  5569                                  
  5570                                  ;-109       j=strlen(LabelNamePtr);//get end of actual name
  5571                                  
  5572                                  
  5573                                  ;-110       LabelNamePtr=LabelNamePtr+j;
  5574                                  
  5575                                  
  5576                                  ;-111       LabelNamePtr++;
  5577                                  
  5578                                  
  5579                                  ;-112       i++;
  5580                                  
  5581                                  
  5582                                  ;-113     } while (i <= LabelMaxIx);
  5583                                  
  5584                                  
  5585                                  ;-114 */
  5586                                  
  5587                                  
  5588                                  ;-115 }
  5589                                  
  5590                                  
  5591                                  ;-116 
  5592                                  
  5593                                  
  5594                                  ;-117 int end1(int n) {
  5595 00002001 C9                       LEAVE
  5596 00002002 C3                       ret
  5597                                  ; ENDP
  5598 00002003 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  5599 0000200C 3A2000             
  5600 0000200F 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5601 00002018 2A2A2A2000         
  5602 0000201D 2C204F75743A2000        epilog_2 db ", Out: ",0
  5603 00002025 2C2000                  epilog_3 db ", ",0
  5604 00002028 3D2000                  epilog_4 db "= ",0
  5605 0000202B 2062797465732E00        epilog_5 db " bytes.",0
  5606 00002033 5C204C6162656C733A-     epilog_6 db "\ Labels: ",0
  5607 0000203C 2000               
  5608 0000203E 2E2000                  epilog_7 db ". ",0
  5609                                  
  5610                                  end1:  ; *** PROC ***
  5611                                  
  5612                                  ;-118     fcloseR(asm_fd);
  5613                                  
  5614                                  ;Function : end1, Number of local variables: 1
  5615                                  ;   # type sign width line used address name   list of local variables
  5616                                  ;  250 var sign word   117 NULL bp+4    n;
  5617 00002041 C8000000                 ENTER  0,0
  5618 00002045 FF36[1600]               push word [asm_fd]
  5619 00002049 E89A0C                   call fcloseR
  5620 0000204C 83C402                   add  sp, 2
  5621                                  
  5622                                  ;-119     fcloseR(lst_fd);
  5623                                  
  5624 0000204F FF36[1800]               push word [lst_fd]
  5625 00002053 E8900C                   call fcloseR
  5626 00002056 83C402                   add  sp, 2
  5627                                  
  5628                                  ;-120     fcloseR(bin_fd);
  5629                                  
  5630 00002059 FF36[1A00]               push word [bin_fd]
  5631 0000205D E8860C                   call fcloseR
  5632 00002060 83C402                   add  sp, 2
  5633                                  
  5634                                  ;-121     exitR(n);
  5635                                  
  5636 00002063 FF7604                   push word [bp+4]
  5637 00002066 E88B0C                   call exitR
  5638 00002069 83C402                   add  sp, 2
  5639                                  
  5640                                  ;-122 }
  5641 0000206C C9                       LEAVE
  5642 0000206D C3                       ret
  5643                                  ; ENDP
  5644                                  ;Back to main program: AS.C
  5645                                  
  5646                                  ;-9 #include "GENCODE.C"
  5647                                  
  5648                                  ;Use include file: GENCODE.C
  5649                                  
  5650                                  ;-1 // generate code
  5651                                  
  5652                                  
  5653                                  ;-2 int getCodes() {
  5654                                  
  5655                                  
  5656                                  getCodes:  ; *** PROC ***
  5657                                  
  5658                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5659                                  
  5660 0000206E FF06[4300]               inc  word [OpCodePtr]
  5661 00002072 8B1E[4300]               mov bx, [OpCodePtr]
  5662 00002076 8A07                     mov al, [bx]
  5663 00002078 B400                     mov ah, 0
  5664 0000207A A2[3000]                 mov byte [Code1], al
  5665                                  
  5666                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5667                                  
  5668 0000207D FF06[4300]               inc  word [OpCodePtr]
  5669 00002081 8B1E[4300]               mov bx, [OpCodePtr]
  5670 00002085 8A07                     mov al, [bx]
  5671 00002087 B400                     mov ah, 0
  5672 00002089 A2[3100]                 mov byte [Code2], al
  5673                                  
  5674                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5675                                  
  5676 0000208C FF06[4300]               inc  word [OpCodePtr]
  5677 00002090 8B1E[4300]               mov bx, [OpCodePtr]
  5678 00002094 8A07                     mov al, [bx]
  5679 00002096 B400                     mov ah, 0
  5680 00002098 A2[3200]                 mov byte [Code3], al
  5681                                  
  5682                                  ;-6 }
  5683                                  
  5684                                  
  5685                                  ;-7 int gen66h() {genCode8(0x66);
  5686                                  
  5687 0000209B C3                       ret
  5688                                  ; ENDP
  5689                                  
  5690                                  gen66h:  ; *** PROC ***
  5691 0000209C 6A66                     push 102
  5692 0000209E E83B00                   call genCode8
  5693 000020A1 83C402                   add  sp, 2
  5694                                  
  5695                                  ;-8 }
  5696                                  
  5697                                  
  5698                                  ;-9 int genCode2(char c, char d) {
  5699                                  
  5700 000020A4 C3                       ret
  5701                                  ; ENDP
  5702                                  
  5703                                  genCode2:  ; *** PROC ***
  5704                                  
  5705                                  ;-10     c = c + d;
  5706                                  
  5707                                  ;Function : genCode2, Number of local variables: 2
  5708                                  ;   # type sign width line used address name   list of local variables
  5709                                  ;  250 var sign byte     9 NULL bp+4    c
  5710                                  ;  251 var sign byte     9 NULL bp+6    d;
  5711 000020A5 C8000000                 ENTER  0,0
  5712 000020A9 8A4604                   mov al, [bp+4]
  5713 000020AC 024606                   add al, [bp+6]
  5714 000020AF 884604                   mov byte [bp+4], al
  5715                                  
  5716                                  ;-11     genCode8(c);
  5717                                  
  5718 000020B2 8A4604                   mov al, byte [bp+4]
  5719 000020B5 B400                     mov ah, 0
  5720 000020B7 50                       push ax
  5721 000020B8 E82100                   call genCode8
  5722 000020BB 83C402                   add  sp, 2
  5723                                  
  5724                                  ;-12 }                             
  5725                                  
  5726                                  
  5727                                  ;-13 int genCodeW(char c) {
  5728 000020BE C9                       LEAVE
  5729 000020BF C3                       ret
  5730                                  ; ENDP
  5731                                  
  5732                                  genCodeW:  ; *** PROC ***
  5733                                  
  5734                                  ;-14     c = c + wflag;  
  5735                                  
  5736                                  ;Function : genCodeW, Number of local variables: 1
  5737                                  ;   # type sign width line used address name   list of local variables
  5738                                  ;  250 var sign byte    13 NULL bp+4    c;
  5739 000020C0 C8000000                 ENTER  0,0
  5740 000020C4 8A4604                   mov al, [bp+4]
  5741 000020C7 0206[3800]               add al, [wflag]
  5742 000020CB 884604                   mov byte [bp+4], al
  5743                                  
  5744                                  ;-15     genCode8(c);
  5745                                  
  5746 000020CE 8A4604                   mov al, byte [bp+4]
  5747 000020D1 B400                     mov ah, 0
  5748 000020D3 50                       push ax
  5749 000020D4 E80500                   call genCode8
  5750 000020D7 83C402                   add  sp, 2
  5751                                  
  5752                                  ;-16 }   
  5753                                  
  5754                                  
  5755                                  ;-17 int genCode8(char c) {
  5756 000020DA C9                       LEAVE
  5757 000020DB C3                       ret
  5758                                  ; ENDP
  5759                                  
  5760                                  genCode8:  ; *** PROC ***
  5761                                  
  5762                                  ;-18 //set: BinLen++, OpPrintIndex++
  5763                                  
  5764                                  
  5765                                  ;-19     FileBin[BinLen]=c;
  5766                                  
  5767                                  ;Function : genCode8, Number of local variables: 1
  5768                                  ;   # type sign width line used address name   list of local variables
  5769                                  ;  250 var sign byte    17 NULL bp+4    c;
  5770 000020DC C8000000                 ENTER  0,0
  5771 000020E0 8A4604                   mov al, [bp+4]
  5772 000020E3 8B1E[5000]               mov bx, [BinLen]
  5773 000020E7 88874397                 mov [FileBin+bx], al
  5774                                  
  5775                                  ;-20     BinLen++;
  5776                                  
  5777 000020EB FF06[5000]               inc  word [BinLen]
  5778                                  
  5779                                  ;-21     PC++;
  5780                                  
  5781 000020EF FF06[2300]               inc  word [PC]
  5782                                  
  5783                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5784                                  
  5785 000020F3 A1[5000]                 mov ax, [BinLen]
  5786 000020F6 3D204E                   cmp ax, 20000 ;unsigned : 0
  5787 000020F9 0F820900                 jb  @@genCode8216
  5788 000020FD 68[2121]                 push genCode8_0
  5789 00002100 E818F9                   call errorexit
  5790 00002103 83C402                   add  sp, 2
  5791                                  
  5792                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5793                                  
  5794                                  @@genCode8216:
  5795 00002106 A1[4100]                 mov ax, [OpPrintIndex]
  5796 00002109 83F805                   cmp ax, 5
  5797 0000210C 0F8D0F00                 jge @@genCode8217
  5798                                  
  5799                                  ;-24         OpPos[OpPrintIndex]=c;
  5800                                  
  5801 00002110 8A4604                   mov al, [bp+4]
  5802 00002113 8B1E[4100]               mov bx, [OpPrintIndex]
  5803 00002117 88873677                 mov [OpPos+bx], al
  5804                                  
  5805                                  ;-25         OpPrintIndex++;
  5806                                  
  5807 0000211B FF06[4100]               inc  word [OpPrintIndex]
  5808                                  
  5809                                  ;-26     }
  5810                                  
  5811                                  
  5812                                  ;-27 }
  5813                                  
  5814                                  @@genCode8217:
  5815                                  
  5816                                  ;-28 int genCode16(unsigned int i) {
  5817 0000211F C9                       LEAVE
  5818 00002120 C3                       ret
  5819                                  ; ENDP
  5820 00002121 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5821 0000212A 746F6F206C6F6E6700 
  5822                                  
  5823                                  genCode16:  ; *** PROC ***
  5824                                  
  5825                                  ;-29     genCode8(i); i=i >> 8;
  5826                                  
  5827                                  ;Function : genCode16, Number of local variables: 1
  5828                                  ;   # type sign width line used address name   list of local variables
  5829                                  ;  250 var unsg word    28 NULL bp+4    i;
  5830 00002133 C8000000                 ENTER  0,0
  5831 00002137 FF7604                   push word [bp+4]
  5832 0000213A E89FFF                   call genCode8
  5833 0000213D 83C402                   add  sp, 2
  5834 00002140 8B4604                   mov ax, [bp+4]
  5835 00002143 C1E808                   shr ax, 8
  5836 00002146 894604                   mov word [bp+4], ax
  5837                                  
  5838                                  ;-30     genCode8(i);
  5839                                  
  5840 00002149 FF7604                   push word [bp+4]
  5841 0000214C E88DFF                   call genCode8
  5842 0000214F 83C402                   add  sp, 2
  5843                                  
  5844                                  ;-31 }
  5845                                  
  5846                                  
  5847                                  ;-32 int genCode32(unsigned long L) {
  5848 00002152 C9                       LEAVE
  5849 00002153 C3                       ret
  5850                                  ; ENDP
  5851                                  
  5852                                  genCode32:  ; *** PROC ***
  5853                                  
  5854                                  ;-33     genCode16(L); L=L >>16;
  5855                                  
  5856                                  ;Function : genCode32, Number of local variables: 1
  5857                                  ;   # type sign width line used address name   list of local variables
  5858                                  ;  250 var unsg dwrd    32 NULL bp+4    L;
  5859 00002154 C8000000                 ENTER  0,0
  5860 00002158 66FF7604                 push dword [bp+4]
  5861 0000215C E8D4FF                   call genCode16
  5862 0000215F 83C404                   add  sp, 4
  5863 00002162 668B4604                 mov eax, [bp+4]
  5864 00002166 66C1E810                 shr eax, 16
  5865 0000216A 66894604                 mov dword [bp+4], eax
  5866                                  
  5867                                  ;-34     genCode16(L);
  5868                                  
  5869 0000216E 66FF7604                 push dword [bp+4]
  5870 00002172 E8BEFF                   call genCode16
  5871 00002175 83C404                   add  sp, 4
  5872                                  
  5873                                  ;-35 }
  5874                                  
  5875                                  
  5876                                  ;-36 int writeEA(char xxx) {//value for reg/operand
  5877 00002178 C9                       LEAVE
  5878 00002179 C3                       ret
  5879                                  ; ENDP
  5880                                  
  5881                                  writeEA:  ; *** PROC ***
  5882                                  
  5883                                  ;-37 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5884                                  
  5885                                  
  5886                                  ;-38 //mod-bits: mode76, reg/opcode543, r/m210   
  5887                                  
  5888                                  
  5889                                  ;-39 //Op: 0, IMM, REG, ADR, MEM   
  5890                                  
  5891                                  
  5892                                  ;-40     char len;
  5893                                  
  5894                                  
  5895                                  ;-41     len=0;   
  5896                                  
  5897                                  ;Function : writeEA, Number of local variables: 2
  5898                                  ;   # type sign width line used address name   list of local variables
  5899                                  ;  250 var sign byte    36 NULL bp+4    xxx
  5900                                  ;  251 var sign byte    40 NULL bp-2    len;
  5901 0000217A C8020000                 ENTER  2,0
  5902 0000217E 66B800000000             mov eax, 0
  5903 00002184 8846FE                   mov byte [bp-2], al
  5904                                  
  5905                                  ;-42     xxx = xxx << 3;//in reg/opcode field      
  5906                                  
  5907 00002187 8A4604                   mov al, [bp+4]
  5908 0000218A C0E003                   shl al, 3
  5909 0000218D 884604                   mov byte [bp+4], al
  5910                                  
  5911                                  ;-43     if (Op == REG) {
  5912                                  
  5913 00002190 A0[2D00]                 mov al, [Op]
  5914 00002193 3C02                     cmp al, 2
  5915 00002195 0F853A00                 jne @@writeEA218
  5916                                  
  5917                                  ;-44         xxx |= 0xC0;     
  5918                                  
  5919 00002199 804E04C0                 or  byte [bp+4], 192
  5920                                  
  5921                                  ;-45         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5922                                  
  5923 0000219D A0[2E00]                 mov al, [Op2]
  5924 000021A0 3C01                     cmp al, 1
  5925 000021A2 0F8F0D00                 jg  @@writeEA219
  5926 000021A6 8A4604                   mov al, [bp+4]
  5927 000021A9 0206[3400]               add al, [R1No]
  5928 000021AD 884604                   mov byte [bp+4], al
  5929                                  
  5930                                  ;-46             else {
  5931                                  
  5932 000021B0 E92000                   jmp @@writeEA220
  5933                                  @@writeEA219:
  5934                                  
  5935                                  ;-47                 if (Op2 == REG) xxx = xxx + R1No;
  5936                                  
  5937 000021B3 A0[2E00]                 mov al, [Op2]
  5938 000021B6 3C02                     cmp al, 2
  5939 000021B8 0F850D00                 jne @@writeEA221
  5940 000021BC 8A4604                   mov al, [bp+4]
  5941 000021BF 0206[3400]               add al, [R1No]
  5942 000021C3 884604                   mov byte [bp+4], al
  5943                                  
  5944                                  ;-48                 else            xxx = xxx + R2No;  
  5945                                  
  5946 000021C6 E90A00                   jmp @@writeEA222
  5947                                  @@writeEA221:
  5948 000021C9 8A4604                   mov al, [bp+4]
  5949 000021CC 0206[3300]               add al, [R2No]
  5950 000021D0 884604                   mov byte [bp+4], al
  5951                                  
  5952                                  ;-49             }
  5953                                  
  5954                                  @@writeEA222:
  5955                                  
  5956                                  ;-50         } 
  5957                                  
  5958                                  @@writeEA220:
  5959                                  
  5960                                  ;-51     if (Op == MEM) {
  5961                                  
  5962                                  @@writeEA218:
  5963 000021D3 A0[2D00]                 mov al, [Op]
  5964 000021D6 3C04                     cmp al, 4
  5965 000021D8 0F857F00                 jne @@writeEA223
  5966                                  
  5967                                  ;-52         if (isDirect) {
  5968                                  
  5969 000021DC A0[3C00]                 mov al, [isDirect]
  5970 000021DF 08C0                     or  al, al
  5971 000021E1 0F841000                 je @@writeEA224
  5972                                  
  5973                                  ;-53             xxx |= 6;
  5974                                  
  5975 000021E5 804E0406                 or  byte [bp+4], 6
  5976                                  
  5977                                  ;-54             len = 2;
  5978                                  
  5979 000021E9 66B802000000             mov eax, 2
  5980 000021EF 8846FE                   mov byte [bp-2], al
  5981                                  
  5982                                  ;-55         }
  5983                                  
  5984                                  
  5985                                  ;-56         else { 
  5986                                  
  5987 000021F2 E96600                   jmp @@writeEA225
  5988                                  @@writeEA224:
  5989                                  
  5990                                  ;-57             xxx = xxx + rm;   
  5991                                  
  5992 000021F5 8A4604                   mov al, [bp+4]
  5993 000021F8 0206[3B00]               add al, [rm]
  5994 000021FC 884604                   mov byte [bp+4], al
  5995                                  
  5996                                  ;-58             if (rm == 6) {//make [BP+00]
  5997                                  
  5998 000021FF A0[3B00]                 mov al, [rm]
  5999 00002202 3C06                     cmp al, 6
  6000 00002204 0F851700                 jne @@writeEA226
  6001                                  
  6002                                  ;-59                 len=1;
  6003                                  
  6004 00002208 66B801000000             mov eax, 1
  6005 0000220E 8846FE                   mov byte [bp-2], al
  6006                                  
  6007                                  ;-60                 if (disp == 0) xxx |= 0x40;
  6008                                  
  6009 00002211 A1[3D00]                 mov ax, [disp]
  6010 00002214 83F800                   cmp ax, 0
  6011 00002217 0F850400                 jne @@writeEA227
  6012 0000221B 804E0440                 or  byte [bp+4], 64
  6013                                  
  6014                                  ;-61             }
  6015                                  
  6016                                  @@writeEA227:
  6017                                  
  6018                                  ;-62 
  6019                                  
  6020                                  
  6021                                  ;-63             if (disp) {
  6022                                  
  6023                                  @@writeEA226:
  6024 0000221F A1[3D00]                 mov ax, [disp]
  6025 00002222 08C0                     or  al, al
  6026 00002224 0F843300                 je @@writeEA228
  6027                                  
  6028                                  ;-64                 ax = disp;
  6029                                  
  6030 00002228 A1[3D00]                 mov  ax, [disp]
  6031                                  
  6032                                  ;-65                 if(ax > 127) len=2;
  6033                                  
  6034 0000222B 83F87F                   cmp  ax, 127
  6035 0000222E 0F8E0C00                 jle @@writeEA229
  6036 00002232 66B802000000             mov eax, 2
  6037 00002238 8846FE                   mov byte [bp-2], al
  6038                                  
  6039                                  ;-66                 else len=1;
  6040                                  
  6041 0000223B E90900                   jmp @@writeEA230
  6042                                  @@writeEA229:
  6043 0000223E 66B801000000             mov eax, 1
  6044 00002244 8846FE                   mov byte [bp-2], al
  6045                                  
  6046                                  ;-67                 if (len == 1) xxx |= 0x40;
  6047                                  
  6048                                  @@writeEA230:
  6049 00002247 8A46FE                   mov al, [bp-2]
  6050 0000224A 3C01                     cmp al, 1
  6051 0000224C 0F850700                 jne @@writeEA231
  6052 00002250 804E0440                 or  byte [bp+4], 64
  6053                                  
  6054                                  ;-68                 else xxx |= 0x80;
  6055                                  
  6056 00002254 E90400                   jmp @@writeEA232
  6057                                  @@writeEA231:
  6058 00002257 804E0480                 or  byte [bp+4], 128
  6059                                  
  6060                                  ;-69             }
  6061                                  
  6062                                  @@writeEA232:
  6063                                  
  6064                                  ;-70         }
  6065                                  
  6066                                  @@writeEA228:
  6067                                  
  6068                                  ;-71     }  
  6069                                  
  6070                                  @@writeEA225:
  6071                                  
  6072                                  ;-72     
  6073                                  
  6074                                  
  6075                                  ;-73     genCode8(xxx);// gen second byte
  6076                                  
  6077                                  @@writeEA223:
  6078 0000225B 8A4604                   mov al, byte [bp+4]
  6079 0000225E B400                     mov ah, 0
  6080 00002260 50                       push ax
  6081 00002261 E878FE                   call genCode8
  6082 00002264 83C402                   add  sp, 2
  6083                                  
  6084                                  ;-74     if (len == 1) genCode8 (disp);
  6085                                  
  6086 00002267 8A46FE                   mov al, [bp-2]
  6087 0000226A 3C01                     cmp al, 1
  6088 0000226C 0F850A00                 jne @@writeEA233
  6089 00002270 FF36[3D00]               push word [disp]
  6090 00002274 E865FE                   call genCode8
  6091 00002277 83C402                   add  sp, 2
  6092                                  
  6093                                  ;-75     if (len == 2) genCode16(disp);
  6094                                  
  6095                                  @@writeEA233:
  6096 0000227A 8A46FE                   mov al, [bp-2]
  6097 0000227D 3C02                     cmp al, 2
  6098 0000227F 0F850A00                 jne @@writeEA234
  6099 00002283 FF36[3D00]               push word [disp]
  6100 00002287 E8A9FE                   call genCode16
  6101 0000228A 83C402                   add  sp, 2
  6102                                  
  6103                                  ;-76 }
  6104                                  
  6105                                  @@writeEA234:
  6106                                  
  6107                                  ;-77 
  6108                                  
  6109                                  
  6110                                  ;-78 int genImmediate() { 
  6111 0000228D C9                       LEAVE
  6112 0000228E C3                       ret
  6113                                  ; ENDP
  6114                                  
  6115                                  genImmediate:  ; *** PROC ***
  6116                                  
  6117                                  ;-79     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6118                                  
  6119 0000228F A0[3800]                 mov al, [wflag]
  6120 00002292 08C0                     or  al, al
  6121 00002294 0F842300                 je @@genImmediate235
  6122 00002298 A0[3700]                 mov al, [OpSize]
  6123 0000229B 3C03                     cmp al, 3
  6124 0000229D 0F850D00                 jne @@genImmediate236
  6125 000022A1 FF36[3F00]               push word [imme]
  6126 000022A5 E8ACFE                   call genCode32
  6127 000022A8 83C402                   add  sp, 2
  6128                                  
  6129                                  ;-80         else genCode16(imme);
  6130                                  
  6131 000022AB E90A00                   jmp @@genImmediate237
  6132                                  @@genImmediate236:
  6133 000022AE FF36[3F00]               push word [imme]
  6134 000022B2 E87EFE                   call genCode16
  6135 000022B5 83C402                   add  sp, 2
  6136                                  
  6137                                  ;-81     else       genCode8 (imme);  
  6138                                  
  6139                                  @@genImmediate237:
  6140 000022B8 E90A00                   jmp @@genImmediate238
  6141                                  @@genImmediate235:
  6142 000022BB FF36[3F00]               push word [imme]
  6143 000022BF E81AFE                   call genCode8
  6144 000022C2 83C402                   add  sp, 2
  6145                                  
  6146                                  ;-82 }    
  6147                                  
  6148                                  @@genImmediate238:
  6149 000022C5 C3                       ret
  6150                                  ; ENDP
  6151                                  ;Back to main program: AS.C
  6152                                  
  6153                                  ;-10 
  6154                                  
  6155                                  
  6156                                  ;-11 int process() { 
  6157                                  
  6158                                  
  6159                                  process:  ; *** PROC ***
  6160                                  
  6161                                  ;-12     char c;           
  6162                                  
  6163                                  
  6164                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6165                                  
  6166                                  ;Function : process, Number of local variables: 1
  6167                                  ;   # type sign width line used address name   list of local variables
  6168                                  ;  250 var sign byte    12 NULL bp-2    c;
  6169 000022C6 C8020000                 ENTER  2,0
  6170 000022CA 66B800000000             mov eax, 0
  6171 000022D0 A2[3B00]                 mov byte [rm], al
  6172 000022D3 A2[3800]                 mov byte [wflag], al
  6173 000022D6 A2[3900]                 mov byte [dflag], al
  6174 000022D9 A2[3300]                 mov byte [R2No], al
  6175 000022DC A2[3400]                 mov byte [R1No], al
  6176 000022DF A2[3500]                 mov byte [R2Type], al
  6177 000022E2 A2[3600]                 mov byte [R1Type], al
  6178 000022E5 A2[2E00]                 mov byte [Op2], al
  6179 000022E8 A2[2D00]                 mov byte [Op], al
  6180                                  
  6181                                  ;-14     disp=imme=0;//int
  6182                                  
  6183 000022EB 66B800000000             mov eax, 0
  6184 000022F1 A3[3F00]                 mov word [imme], ax
  6185 000022F4 A3[3D00]                 mov word [disp], ax
  6186                                  
  6187                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6188                                  
  6189 000022F7 66B801000000             mov eax, 1
  6190 000022FD A2[3C00]                 mov byte [isDirect], al
  6191                                  
  6192                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6193                                  
  6194 00002300 E8A7E7                   call getTokeType
  6195                                  
  6196                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6197                                  
  6198 00002303 E8DCEB                   call getCodeSize
  6199 00002306 A2[3700]                 mov byte [OpSize], al
  6200                                  
  6201                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6202                                  
  6203 00002309 E862FD                   call getCodes
  6204                                  
  6205                                  ;-19 
  6206                                  
  6207                                  
  6208                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6209                                  
  6210 0000230C A0[2F00]                 mov al, [CodeType]
  6211 0000230F 3C01                     cmp al, 1
  6212 00002311 0F850F00                 jne @@process239
  6213                                  
  6214                                  ;-21         genCode8(Code1);
  6215                                  
  6216 00002315 A0[3000]                 mov al, byte [Code1]
  6217 00002318 B400                     mov ah, 0
  6218 0000231A 50                       push ax
  6219 0000231B E8BEFD                   call genCode8
  6220 0000231E 83C402                   add  sp, 2
  6221                                  
  6222                                  ;-22         return;
  6223                                  
  6224 00002321 E9B007                   jmp @@retn
  6225                                  
  6226                                  ;-23     }
  6227                                  
  6228                                  
  6229                                  ;-24   
  6230                                  
  6231                                  
  6232                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  6233                                  
  6234                                  @@process239:
  6235 00002324 A0[2F00]                 mov al, [CodeType]
  6236 00002327 3C02                     cmp al, 2
  6237 00002329 0F856900                 jne @@process240
  6238                                  
  6239                                  ;-26         getOpL();    
  6240                                  
  6241 0000232D E84CE2                   call getOpL
  6242                                  
  6243                                  ;-27         checkOpL();        
  6244                                  
  6245 00002330 E86CE1                   call checkOpL
  6246                                  
  6247                                  ;-28         if (Code2 <= 1) {//inc,dec
  6248                                  
  6249 00002333 A0[3100]                 mov al, [Code2]
  6250 00002336 3C01                     cmp al, 1
  6251 00002338 0F8F2700                 jg  @@process241
  6252                                  
  6253                                  ;-29   	        if (Op == REG) {//short
  6254                                  
  6255 0000233C A0[2D00]                 mov al, [Op]
  6256 0000233F 3C02                     cmp al, 2
  6257 00002341 0F851E00                 jne @@process242
  6258                                  
  6259                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6260                                  
  6261 00002345 A0[3800]                 mov al, [wflag]
  6262 00002348 08C0                     or  al, al
  6263 0000234A 0F841500                 je @@process243
  6264 0000234E A0[3400]                 mov al, byte [R1No]
  6265 00002351 B400                     mov ah, 0
  6266 00002353 50                       push ax
  6267 00002354 A0[3200]                 mov al, byte [Code3]
  6268 00002357 B400                     mov ah, 0
  6269 00002359 50                       push ax
  6270 0000235A E848FD                   call genCode2
  6271 0000235D 83C404                   add  sp, 4
  6272 00002360 E97107                   jmp @@retn
  6273                                  
  6274                                  ;-31             }
  6275                                  
  6276                                  @@process243:
  6277                                  
  6278                                  ;-32         }
  6279                                  
  6280                                  @@process242:
  6281                                  
  6282                                  ;-33         if (Code2 == 5) {//imul extension?
  6283                                  
  6284                                  @@process241:
  6285 00002363 A0[3100]                 mov al, [Code2]
  6286 00002366 3C05                     cmp al, 5
  6287 00002368 0F850F00                 jne @@process244
  6288                                  
  6289                                  ;-34             getTokeType();
  6290                                  
  6291 0000236C E83BE7                   call getTokeType
  6292                                  
  6293                                  ;-35             if (TokeType) implerror();
  6294                                  
  6295 0000236F A0[2C00]                 mov al, [TokeType]
  6296 00002372 08C0                     or  al, al
  6297 00002374 0F840300                 je @@process245
  6298 00002378 E811F7                   call implerror
  6299                                  
  6300                                  ;-36         }
  6301                                  
  6302                                  @@process245:
  6303                                  
  6304                                  ;-37         genCodeW(Code1);           
  6305                                  
  6306                                  @@process244:
  6307 0000237B A0[3000]                 mov al, byte [Code1]
  6308 0000237E B400                     mov ah, 0
  6309 00002380 50                       push ax
  6310 00002381 E83CFD                   call genCodeW
  6311 00002384 83C402                   add  sp, 2
  6312                                  
  6313                                  ;-38         writeEA(Code2);
  6314                                  
  6315 00002387 A0[3100]                 mov al, byte [Code2]
  6316 0000238A B400                     mov ah, 0
  6317 0000238C 50                       push ax
  6318 0000238D E8EAFD                   call writeEA
  6319 00002390 83C402                   add  sp, 2
  6320                                  
  6321                                  ;-39         return;
  6322                                  
  6323 00002393 E93E07                   jmp @@retn
  6324                                  
  6325                                  ;-40     }
  6326                                  
  6327                                  
  6328                                  ;-41   
  6329                                  
  6330                                  
  6331                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6332                                  
  6333                                  @@process240:
  6334 00002396 A0[2F00]                 mov al, [CodeType]
  6335 00002399 3C03                     cmp al, 3
  6336 0000239B 0F855100                 jne @@process246
  6337                                  
  6338                                  ;-43         check2Ops();    //setwflag not applicable
  6339                                  
  6340 0000239F E87FE1                   call check2Ops
  6341                                  
  6342                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6343                                  
  6344 000023A2 A0[3600]                 mov al, [R1Type]
  6345 000023A5 3C02                     cmp al, 2
  6346 000023A7 0F840300                 je  @@process247
  6347 000023AB E87EF7                   call reg16error
  6348                                  
  6349                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6350                                  
  6351                                  @@process247:
  6352 000023AE A0[2E00]                 mov al, [Op2]
  6353 000023B1 3C04                     cmp al, 4
  6354 000023B3 0F840300                 je  @@process248
  6355 000023B7 E893F6                   call addrerror
  6356                                  
  6357                                  ;-46         
  6358                                  
  6359                                  
  6360                                  ;-47         genCode8(Code1);//les,lds,lea
  6361                                  
  6362                                  @@process248:
  6363 000023BA A0[3000]                 mov al, byte [Code1]
  6364 000023BD B400                     mov ah, 0
  6365 000023BF 50                       push ax
  6366 000023C0 E819FD                   call genCode8
  6367 000023C3 83C402                   add  sp, 2
  6368                                  
  6369                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6370                                  
  6371 000023C6 A0[3000]                 mov al, [Code1]
  6372 000023C9 3C0F                     cmp al, 15
  6373 000023CB 0F850C00                 jne @@process249
  6374 000023CF A0[3100]                 mov al, byte [Code2]
  6375 000023D2 B400                     mov ah, 0
  6376 000023D4 50                       push ax
  6377 000023D5 E804FD                   call genCode8
  6378 000023D8 83C402                   add  sp, 2
  6379                                  
  6380                                  ;-49         Op=Op2;//set MEM for writeEA
  6381                                  
  6382                                  @@process249:
  6383 000023DB A0[2E00]                 mov al, [Op2]
  6384 000023DE A2[2D00]                 mov byte [Op], al
  6385                                  
  6386                                  ;-50         writeEA(R1No);           
  6387                                  
  6388 000023E1 A0[3400]                 mov al, byte [R1No]
  6389 000023E4 B400                     mov ah, 0
  6390 000023E6 50                       push ax
  6391 000023E7 E890FD                   call writeEA
  6392 000023EA 83C402                   add  sp, 2
  6393                                  
  6394                                  ;-51         return;
  6395                                  
  6396 000023ED E9E406                   jmp @@retn
  6397                                  
  6398                                  ;-52     }
  6399                                  
  6400                                  
  6401                                  ;-53 
  6402                                  
  6403                                  
  6404                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6405                                  
  6406                                  @@process246:
  6407 000023F0 A0[2F00]                 mov al, [CodeType]
  6408 000023F3 3C04                     cmp al, 4
  6409 000023F5 0F85EF00                 jne @@process250
  6410                                  
  6411                                  ;-55         check2Ops();    
  6412                                  
  6413 000023F9 E825E1                   call check2Ops
  6414                                  
  6415                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6416                                  
  6417 000023FC A0[2E00]                 mov al, [Op2]
  6418 000023FF 3C01                     cmp al, 1
  6419 00002401 0F857900                 jne @@process251
  6420                                  
  6421                                  ;-57             setsflag();   
  6422                                  
  6423 00002405 E8FCE4                   call setsflag
  6424                                  
  6425                                  ;-58             if (Op == REG) {                
  6426                                  
  6427 00002408 A0[2D00]                 mov al, [Op]
  6428 0000240B 3C02                     cmp al, 2
  6429 0000240D 0F853100                 jne @@process252
  6430                                  
  6431                                  ;-59                 if (R1No == 0) {// acc,imm   
  6432                                  
  6433 00002411 A0[3400]                 mov al, [R1No]
  6434 00002414 3C00                     cmp al, 0
  6435 00002416 0F852800                 jne @@process253
  6436                                  
  6437                                  ;-60                     if (sflag == 0) {                        
  6438                                  
  6439 0000241A A0[3A00]                 mov al, [sflag]
  6440 0000241D 3C00                     cmp al, 0
  6441 0000241F 0F851F00                 jne @@process254
  6442                                  
  6443                                  ;-61                         c = Code1 << 3;
  6444                                  
  6445 00002423 A0[3000]                 mov al, [Code1]
  6446 00002426 C0E003                   shl al, 3
  6447 00002429 8846FE                   mov byte [bp-2], al
  6448                                  
  6449                                  ;-62                         c += 4;    
  6450                                  
  6451 0000242C 8046FE04                 add  byte [bp-2], 4
  6452                                  
  6453                                  ;-63                         genCodeW(c);
  6454                                  
  6455 00002430 8A46FE                   mov al, byte [bp-2]
  6456 00002433 B400                     mov ah, 0
  6457 00002435 50                       push ax
  6458 00002436 E887FC                   call genCodeW
  6459 00002439 83C402                   add  sp, 2
  6460                                  
  6461                                  ;-64                         genImmediate();
  6462                                  
  6463 0000243C E850FE                   call genImmediate
  6464                                  
  6465                                  ;-65                         return;
  6466                                  
  6467 0000243F E99206                   jmp @@retn
  6468                                  
  6469                                  ;-66                     }
  6470                                  
  6471                                  
  6472                                  ;-67                 }
  6473                                  
  6474                                  @@process254:
  6475                                  
  6476                                  ;-68             }
  6477                                  
  6478                                  @@process253:
  6479                                  
  6480                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6481                                  
  6482                                  
  6483                                  ;-70             c = sflag + 0x80;   
  6484                                  
  6485                                  @@process252:
  6486 00002442 A0[3A00]                 mov al, [sflag]
  6487 00002445 0480                     add al, 128
  6488 00002447 8846FE                   mov byte [bp-2], al
  6489                                  
  6490                                  ;-71             genCodeW(c); 
  6491                                  
  6492 0000244A 8A46FE                   mov al, byte [bp-2]
  6493 0000244D B400                     mov ah, 0
  6494 0000244F 50                       push ax
  6495 00002450 E86DFC                   call genCodeW
  6496 00002453 83C402                   add  sp, 2
  6497                                  
  6498                                  ;-72             writeEA(Code1);  
  6499                                  
  6500 00002456 A0[3000]                 mov al, byte [Code1]
  6501 00002459 B400                     mov ah, 0
  6502 0000245B 50                       push ax
  6503 0000245C E81BFD                   call writeEA
  6504 0000245F 83C402                   add  sp, 2
  6505                                  
  6506                                  ;-73             if (sflag) genCode8(imme);
  6507                                  
  6508 00002462 A0[3A00]                 mov al, [sflag]
  6509 00002465 08C0                     or  al, al
  6510 00002467 0F840D00                 je @@process255
  6511 0000246B FF36[3F00]               push word [imme]
  6512 0000246F E86AFC                   call genCode8
  6513 00002472 83C402                   add  sp, 2
  6514                                  
  6515                                  ;-74             else genImmediate();    
  6516                                  
  6517 00002475 E90300                   jmp @@process256
  6518                                  @@process255:
  6519 00002478 E814FE                   call genImmediate
  6520                                  
  6521                                  ;-75             return;     
  6522                                  
  6523                                  @@process256:
  6524 0000247B E95606                   jmp @@retn
  6525                                  
  6526                                  ;-76         }  
  6527                                  
  6528                                  
  6529                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6530                                  
  6531                                  @@process251:
  6532 0000247E A0[3000]                 mov al, [Code1]
  6533 00002481 C0E003                   shl al, 3
  6534 00002484 8846FE                   mov byte [bp-2], al
  6535                                  
  6536                                  ;-78         if (Op == REG) {
  6537                                  
  6538 00002487 A0[2D00]                 mov al, [Op]
  6539 0000248A 3C02                     cmp al, 2
  6540 0000248C 0F852E00                 jne @@process257
  6541                                  
  6542                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6543                                  
  6544 00002490 A0[2E00]                 mov al, [Op2]
  6545 00002493 3C04                     cmp al, 4
  6546 00002495 0F852500                 jne @@process258
  6547                                  
  6548                                  ;-80                 c += 2;//add direction flag
  6549                                  
  6550 00002499 8046FE02                 add  byte [bp-2], 2
  6551                                  
  6552                                  ;-81                 genCodeW(c);
  6553                                  
  6554 0000249D 8A46FE                   mov al, byte [bp-2]
  6555 000024A0 B400                     mov ah, 0
  6556 000024A2 50                       push ax
  6557 000024A3 E81AFC                   call genCodeW
  6558 000024A6 83C402                   add  sp, 2
  6559                                  
  6560                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6561                                  
  6562 000024A9 A0[2E00]                 mov al, [Op2]
  6563 000024AC A2[2D00]                 mov byte [Op], al
  6564                                  
  6565                                  ;-83                 writeEA(R1No);
  6566                                  
  6567 000024AF A0[3400]                 mov al, byte [R1No]
  6568 000024B2 B400                     mov ah, 0
  6569 000024B4 50                       push ax
  6570 000024B5 E8C2FC                   call writeEA
  6571 000024B8 83C402                   add  sp, 2
  6572                                  
  6573                                  ;-84                 return;    
  6574                                  
  6575 000024BB E91606                   jmp @@retn
  6576                                  
  6577                                  ;-85             }
  6578                                  
  6579                                  
  6580                                  ;-86         }
  6581                                  
  6582                                  @@process258:
  6583                                  
  6584                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6585                                  
  6586                                  @@process257:
  6587 000024BE A0[2E00]                 mov al, [Op2]
  6588 000024C1 3C02                     cmp al, 2
  6589 000024C3 0F851B00                 jne @@process259
  6590                                  
  6591                                  ;-88             genCodeW(c);
  6592                                  
  6593 000024C7 8A46FE                   mov al, byte [bp-2]
  6594 000024CA B400                     mov ah, 0
  6595 000024CC 50                       push ax
  6596 000024CD E8F0FB                   call genCodeW
  6597 000024D0 83C402                   add  sp, 2
  6598                                  
  6599                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6600                                  
  6601 000024D3 A0[3300]                 mov al, byte [R2No]
  6602 000024D6 B400                     mov ah, 0
  6603 000024D8 50                       push ax
  6604 000024D9 E89EFC                   call writeEA
  6605 000024DC 83C402                   add  sp, 2
  6606                                  
  6607                                  ;-90             return;            
  6608                                  
  6609 000024DF E9F205                   jmp @@retn
  6610                                  
  6611                                  ;-91         }          
  6612                                  
  6613                                  
  6614                                  ;-92         syntaxerror();        
  6615                                  
  6616                                  @@process259:
  6617 000024E2 E896F6                   call syntaxerror
  6618                                  
  6619                                  ;-93         return;
  6620                                  
  6621 000024E5 E9EC05                   jmp @@retn
  6622                                  
  6623                                  ;-94     }
  6624                                  
  6625                                  
  6626                                  ;-95  
  6627                                  
  6628                                  
  6629                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6630                                  
  6631                                  @@process250:
  6632 000024E8 A0[2F00]                 mov al, [CodeType]
  6633 000024EB 3C05                     cmp al, 5
  6634 000024ED 0F857F01                 jne @@process260
  6635                                  
  6636                                  ;-97         check2Ops();    
  6637                                  
  6638 000024F1 E82DE0                   call check2Ops
  6639                                  
  6640                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6641                                  
  6642                                  
  6643                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6644                                  
  6645                                  
  6646                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6647                                  
  6648                                  
  6649                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6650                                  
  6651                                  
  6652                                  ;-102         if (Op2 == ADR) {
  6653                                  
  6654 000024F4 A0[2E00]                 mov al, [Op2]
  6655 000024F7 3C03                     cmp al, 3
  6656 000024F9 0F850F00                 jne @@process261
  6657                                  
  6658                                  ;-103             imme=disp;
  6659                                  
  6660 000024FD A1[3D00]                 mov ax, [disp]
  6661 00002500 A3[3F00]                 mov word [imme], ax
  6662                                  
  6663                                  ;-104             Op2=IMM;//continue with IMM    
  6664                                  
  6665 00002503 66B801000000             mov eax, 1
  6666 00002509 A2[2E00]                 mov byte [Op2], al
  6667                                  
  6668                                  ;-105         }  
  6669                                  
  6670                                  
  6671                                  ;-106         if (Op2 == IMM) {// r,i     
  6672                                  
  6673                                  @@process261:
  6674 0000250C A0[2E00]                 mov al, [Op2]
  6675 0000250F 3C01                     cmp al, 1
  6676 00002511 0F855400                 jne @@process262
  6677                                  
  6678                                  ;-107             if (Op == REG) {               
  6679                                  
  6680 00002515 A0[2D00]                 mov al, [Op]
  6681 00002518 3C02                     cmp al, 2
  6682 0000251A 0F852500                 jne @@process263
  6683                                  
  6684                                  ;-108                 c = wflag << 3;   
  6685                                  
  6686 0000251E A0[3800]                 mov al, [wflag]
  6687 00002521 C0E003                   shl al, 3
  6688 00002524 8846FE                   mov byte [bp-2], al
  6689                                  
  6690                                  ;-109                 c += 0xB0;                                     
  6691                                  
  6692 00002527 8046FEB0                 add  byte [bp-2], 176
  6693                                  
  6694                                  ;-110                 genCode2(c, R1No);   
  6695                                  
  6696 0000252B A0[3400]                 mov al, byte [R1No]
  6697 0000252E B400                     mov ah, 0
  6698 00002530 50                       push ax
  6699 00002531 8A46FE                   mov al, byte [bp-2]
  6700 00002534 B400                     mov ah, 0
  6701 00002536 50                       push ax
  6702 00002537 E86BFB                   call genCode2
  6703 0000253A 83C404                   add  sp, 4
  6704                                  
  6705                                  ;-111                 genImmediate();
  6706                                  
  6707 0000253D E84FFD                   call genImmediate
  6708                                  
  6709                                  ;-112                 return; 
  6710                                  
  6711 00002540 E99105                   jmp @@retn
  6712                                  
  6713                                  ;-113             }
  6714                                  
  6715                                  
  6716                                  ;-114             if (Op == MEM) {// m,i  
  6717                                  
  6718                                  @@process263:
  6719 00002543 A0[2D00]                 mov al, [Op]
  6720 00002546 3C04                     cmp al, 4
  6721 00002548 0F851700                 jne @@process264
  6722                                  
  6723                                  ;-115                 genCodeW(0xC6);
  6724                                  
  6725 0000254C 68C600                   push 198
  6726 0000254F E86EFB                   call genCodeW
  6727 00002552 83C402                   add  sp, 2
  6728                                  
  6729                                  ;-116                 writeEA( 0 );
  6730                                  
  6731 00002555 6A00                     push 0
  6732 00002557 E820FC                   call writeEA
  6733 0000255A 83C402                   add  sp, 2
  6734                                  
  6735                                  ;-117                 genImmediate();
  6736                                  
  6737 0000255D E82FFD                   call genImmediate
  6738                                  
  6739                                  ;-118                 return;  
  6740                                  
  6741 00002560 E97105                   jmp @@retn
  6742                                  
  6743                                  ;-119             }
  6744                                  
  6745                                  
  6746                                  ;-120             regmemerror();
  6747                                  
  6748                                  @@process264:
  6749 00002563 E89CF5                   call regmemerror
  6750                                  
  6751                                  ;-121             return;
  6752                                  
  6753 00002566 E96B05                   jmp @@retn
  6754                                  
  6755                                  ;-122         }      
  6756                                  
  6757                                  
  6758                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6759                                  
  6760                                  @@process262:
  6761 00002569 A0[3600]                 mov al, [R1Type]
  6762 0000256C 3C04                     cmp al, 4
  6763 0000256E 0F850300                 jne @@process265
  6764 00002572 E8E5DE                   call ChangeDirection
  6765                                  
  6766                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6767                                  
  6768                                  @@process265:
  6769 00002575 A0[3500]                 mov al, [R2Type]
  6770 00002578 3C04                     cmp al, 4
  6771 0000257A 0F852A00                 jne @@process266
  6772                                  
  6773                                  ;-125             if (OpSize != WORD) reg16error();
  6774                                  
  6775 0000257E A0[3700]                 mov al, [OpSize]
  6776 00002581 3C02                     cmp al, 2
  6777 00002583 0F840300                 je  @@process267
  6778 00002587 E8A2F5                   call reg16error
  6779                                  
  6780                                  ;-126                 genCode2(0x8C, dflag);
  6781                                  
  6782                                  @@process267:
  6783 0000258A A0[3900]                 mov al, byte [dflag]
  6784 0000258D B400                     mov ah, 0
  6785 0000258F 50                       push ax
  6786 00002590 688C00                   push 140
  6787 00002593 E80FFB                   call genCode2
  6788 00002596 83C404                   add  sp, 4
  6789                                  
  6790                                  ;-127                 writeEA(R2No);
  6791                                  
  6792 00002599 A0[3300]                 mov al, byte [R2No]
  6793 0000259C B400                     mov ah, 0
  6794 0000259E 50                       push ax
  6795 0000259F E8D8FB                   call writeEA
  6796 000025A2 83C402                   add  sp, 2
  6797                                  
  6798                                  ;-128                 return;   
  6799                                  
  6800 000025A5 E92C05                   jmp @@retn
  6801                                  
  6802                                  ;-129         }          
  6803                                  
  6804                                  
  6805                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6806                                  
  6807                                  @@process266:
  6808 000025A8 A0[2E00]                 mov al, [Op2]
  6809 000025AB 3C04                     cmp al, 4
  6810 000025AD 0F853100                 jne @@process268
  6811                                  
  6812                                  ;-131             if (Op == REG) {
  6813                                  
  6814 000025B1 A0[2D00]                 mov al, [Op]
  6815 000025B4 3C02                     cmp al, 2
  6816 000025B6 0F852800                 jne @@process269
  6817                                  
  6818                                  ;-132                 if (R1No == 0) {
  6819                                  
  6820 000025BA A0[3400]                 mov al, [R1No]
  6821 000025BD 3C00                     cmp al, 0
  6822 000025BF 0F851F00                 jne @@process270
  6823                                  
  6824                                  ;-133                     if (isDirect) {
  6825                                  
  6826 000025C3 A0[3C00]                 mov al, [isDirect]
  6827 000025C6 08C0                     or  al, al
  6828 000025C8 0F841600                 je @@process271
  6829                                  
  6830                                  ;-134                         genCodeW(0xA0);
  6831                                  
  6832 000025CC 68A000                   push 160
  6833 000025CF E8EEFA                   call genCodeW
  6834 000025D2 83C402                   add  sp, 2
  6835                                  
  6836                                  ;-135                         genCode16(disp);
  6837                                  
  6838 000025D5 FF36[3D00]               push word [disp]
  6839 000025D9 E857FB                   call genCode16
  6840 000025DC 83C402                   add  sp, 2
  6841                                  
  6842                                  ;-136                         return;   
  6843                                  
  6844 000025DF E9F204                   jmp @@retn
  6845                                  
  6846                                  ;-137                     }   
  6847                                  
  6848                                  
  6849                                  ;-138                 }   
  6850                                  
  6851                                  @@process271:
  6852                                  
  6853                                  ;-139             }   
  6854                                  
  6855                                  @@process270:
  6856                                  
  6857                                  ;-140         } 
  6858                                  
  6859                                  @@process269:
  6860                                  
  6861                                  ;-141         if (Op == MEM) {//moffs16, acc
  6862                                  
  6863                                  @@process268:
  6864 000025E2 A0[2D00]                 mov al, [Op]
  6865 000025E5 3C04                     cmp al, 4
  6866 000025E7 0F853100                 jne @@process272
  6867                                  
  6868                                  ;-142             if (Op2 == REG) {
  6869                                  
  6870 000025EB A0[2E00]                 mov al, [Op2]
  6871 000025EE 3C02                     cmp al, 2
  6872 000025F0 0F852800                 jne @@process273
  6873                                  
  6874                                  ;-143                 if (R2No == 0) {
  6875                                  
  6876 000025F4 A0[3300]                 mov al, [R2No]
  6877 000025F7 3C00                     cmp al, 0
  6878 000025F9 0F851F00                 jne @@process274
  6879                                  
  6880                                  ;-144                     if (isDirect) {
  6881                                  
  6882 000025FD A0[3C00]                 mov al, [isDirect]
  6883 00002600 08C0                     or  al, al
  6884 00002602 0F841600                 je @@process275
  6885                                  
  6886                                  ;-145                         genCodeW(0xA2);
  6887                                  
  6888 00002606 68A200                   push 162
  6889 00002609 E8B4FA                   call genCodeW
  6890 0000260C 83C402                   add  sp, 2
  6891                                  
  6892                                  ;-146                         genCode16(disp);
  6893                                  
  6894 0000260F FF36[3D00]               push word [disp]
  6895 00002613 E81DFB                   call genCode16
  6896 00002616 83C402                   add  sp, 2
  6897                                  
  6898                                  ;-147                         return;   
  6899                                  
  6900 00002619 E9B804                   jmp @@retn
  6901                                  
  6902                                  ;-148                     }   
  6903                                  
  6904                                  
  6905                                  ;-149                 }   
  6906                                  
  6907                                  @@process275:
  6908                                  
  6909                                  ;-150             }
  6910                                  
  6911                                  @@process274:
  6912                                  
  6913                                  ;-151         
  6914                                  
  6915                                  
  6916                                  ;-152         }
  6917                                  
  6918                                  @@process273:
  6919                                  
  6920                                  ;-153         if (Op2 == REG) {//rm, r
  6921                                  
  6922                                  @@process272:
  6923 0000261C A0[2E00]                 mov al, [Op2]
  6924 0000261F 3C02                     cmp al, 2
  6925 00002621 0F851800                 jne @@process276
  6926                                  
  6927                                  ;-154             genCodeW(0x88);     
  6928                                  
  6929 00002625 688800                   push 136
  6930 00002628 E895FA                   call genCodeW
  6931 0000262B 83C402                   add  sp, 2
  6932                                  
  6933                                  ;-155             writeEA(R2No);
  6934                                  
  6935 0000262E A0[3300]                 mov al, byte [R2No]
  6936 00002631 B400                     mov ah, 0
  6937 00002633 50                       push ax
  6938 00002634 E843FB                   call writeEA
  6939 00002637 83C402                   add  sp, 2
  6940                                  
  6941                                  ;-156             return;
  6942                                  
  6943 0000263A E99704                   jmp @@retn
  6944                                  
  6945                                  ;-157         }
  6946                                  
  6947                                  
  6948                                  ;-158         if (Op2 == MEM) {//r, m
  6949                                  
  6950                                  @@process276:
  6951 0000263D A0[2E00]                 mov al, [Op2]
  6952 00002640 3C04                     cmp al, 4
  6953 00002642 0F852400                 jne @@process277
  6954                                  
  6955                                  ;-159             if (Op == REG) {
  6956                                  
  6957 00002646 A0[2D00]                 mov al, [Op]
  6958 00002649 3C02                     cmp al, 2
  6959 0000264B 0F851B00                 jne @@process278
  6960                                  
  6961                                  ;-160                 ChangeDirection();
  6962                                  
  6963 0000264F E808DE                   call ChangeDirection
  6964                                  
  6965                                  ;-161                 genCodeW(0x8A);
  6966                                  
  6967 00002652 688A00                   push 138
  6968 00002655 E868FA                   call genCodeW
  6969 00002658 83C402                   add  sp, 2
  6970                                  
  6971                                  ;-162                 writeEA(R2No);
  6972                                  
  6973 0000265B A0[3300]                 mov al, byte [R2No]
  6974 0000265E B400                     mov ah, 0
  6975 00002660 50                       push ax
  6976 00002661 E816FB                   call writeEA
  6977 00002664 83C402                   add  sp, 2
  6978                                  
  6979                                  ;-163                 return;   
  6980                                  
  6981 00002667 E96A04                   jmp @@retn
  6982                                  
  6983                                  ;-164             }   
  6984                                  
  6985                                  
  6986                                  ;-165         }         
  6987                                  
  6988                                  @@process278:
  6989                                  
  6990                                  ;-166         syntaxerror();
  6991                                  
  6992                                  @@process277:
  6993 0000266A E80EF5                   call syntaxerror
  6994                                  
  6995                                  ;-167         return;
  6996                                  
  6997 0000266D E96404                   jmp @@retn
  6998                                  
  6999                                  ;-168     }    
  7000                                  
  7001                                  
  7002                                  ;-169     
  7003                                  
  7004                                  
  7005                                  ;-170     if (CodeType == 6) {//Jcc       
  7006                                  
  7007                                  @@process260:
  7008 00002670 A0[2F00]                 mov al, [CodeType]
  7009 00002673 3C06                     cmp al, 6
  7010 00002675 0F85C100                 jne @@process279
  7011                                  
  7012                                  ;-171         if (TokeType == ALNUME) {
  7013                                  
  7014 00002679 A0[2C00]                 mov al, [TokeType]
  7015 0000267C 3C03                     cmp al, 3
  7016 0000267E 0F85B800                 jne @@process280
  7017                                  
  7018                                  ;-172             LabelIx=searchLabel();
  7019                                  
  7020 00002682 E8ECE5                   call searchLabel
  7021 00002685 A3[4A00]                 mov word [LabelIx], ax
  7022                                  
  7023                                  ;-173             if (LabelIx > 0) {
  7024                                  
  7025 00002688 A1[4A00]                 mov ax, [LabelIx]
  7026 0000268B 83F800                   cmp ax, 0
  7027 0000268E 0F8E7A00                 jle @@process281
  7028                                  
  7029                                  ;-174                 disp=LabelAddr[LabelIx];
  7030                                  
  7031 00002692 8B1E[4A00]               mov bx, [LabelIx]
  7032 00002696 D1E3                     shl bx, 1
  7033 00002698 8B87DB86                 mov ax, [LabelAddr + bx]
  7034 0000269C A3[3D00]                 mov word [disp], ax
  7035                                  
  7036                                  ;-175                 disp = disp - PC;   
  7037                                  
  7038 0000269F A1[3D00]                 mov ax, [disp]
  7039 000026A2 2B06[2300]               sub ax, [PC]
  7040 000026A6 A3[3D00]                 mov word [disp], ax
  7041                                  
  7042                                  ;-176                 disp = disp - Origin;
  7043                                  
  7044 000026A9 A1[3D00]                 mov ax, [disp]
  7045 000026AC 2B06[2500]               sub ax, [Origin]
  7046 000026B0 A3[3D00]                 mov word [disp], ax
  7047                                  
  7048                                  ;-177                 if (checkConstSize(disp) ) {
  7049                                  
  7050 000026B3 FF36[3D00]               push word [disp]
  7051 000026B7 E8AFE2                   call checkConstSize
  7052 000026BA 83C402                   add  sp, 2
  7053 000026BD 08C0                     or  al, al
  7054 000026BF 0F842000                 je @@process282
  7055                                  
  7056                                  ;-178                     genCode2(Code1, 0x70);//short       
  7057                                  
  7058 000026C3 6A70                     push 112
  7059 000026C5 A0[3000]                 mov al, byte [Code1]
  7060 000026C8 B400                     mov ah, 0
  7061 000026CA 50                       push ax
  7062 000026CB E8D7F9                   call genCode2
  7063 000026CE 83C404                   add  sp, 4
  7064                                  
  7065                                  ;-179                     disp -= 2; 
  7066                                  
  7067 000026D1 832E[3D00]02             sub  word [disp], 2
  7068                                  
  7069                                  ;-180                     genCode8(disp);   
  7070                                  
  7071 000026D6 FF36[3D00]               push word [disp]
  7072 000026DA E8FFF9                   call genCode8
  7073 000026DD 83C402                   add  sp, 2
  7074                                  
  7075                                  ;-181                 } else {     
  7076                                  
  7077 000026E0 E92600                   jmp @@process283
  7078                                  @@process282:
  7079                                  
  7080                                  ;-182                     genCode8(0x0F);
  7081                                  
  7082 000026E3 6A0F                     push 15
  7083 000026E5 E8F4F9                   call genCode8
  7084 000026E8 83C402                   add  sp, 2
  7085                                  
  7086                                  ;-183                     genCode2(Code1, 0x80);//near       
  7087                                  
  7088 000026EB 688000                   push 128
  7089 000026EE A0[3000]                 mov al, byte [Code1]
  7090 000026F1 B400                     mov ah, 0
  7091 000026F3 50                       push ax
  7092 000026F4 E8AEF9                   call genCode2
  7093 000026F7 83C404                   add  sp, 4
  7094                                  
  7095                                  ;-184                     disp -= 4; 
  7096                                  
  7097 000026FA 832E[3D00]04             sub  word [disp], 4
  7098                                  
  7099                                  ;-185                     genCode16(disp);                       
  7100                                  
  7101 000026FF FF36[3D00]               push word [disp]
  7102 00002703 E82DFA                   call genCode16
  7103 00002706 83C402                   add  sp, 2
  7104                                  
  7105                                  ;-186                 }    
  7106                                  
  7107                                  
  7108                                  ;-187             }
  7109                                  
  7110                                  @@process283:
  7111                                  
  7112                                  ;-188             else {//jump forward, near only
  7113                                  
  7114 00002709 E92B00                   jmp @@process284
  7115                                  @@process281:
  7116                                  
  7117                                  ;-189                 genCode8(0x0F);
  7118                                  
  7119 0000270C 6A0F                     push 15
  7120 0000270E E8CBF9                   call genCode8
  7121 00002711 83C402                   add  sp, 2
  7122                                  
  7123                                  ;-190                 genCode2(Code1, 0x80);
  7124                                  
  7125 00002714 688000                   push 128
  7126 00002717 A0[3000]                 mov al, byte [Code1]
  7127 0000271A B400                     mov ah, 0
  7128 0000271C 50                       push ax
  7129 0000271D E885F9                   call genCode2
  7130 00002720 83C404                   add  sp, 4
  7131                                  
  7132                                  ;-191                 genCode16(0);
  7133                                  
  7134 00002723 6A00                     push 0
  7135 00002725 E80BFA                   call genCode16
  7136 00002728 83C402                   add  sp, 2
  7137                                  
  7138                                  ;-192                 PrintRA='*';
  7139                                  
  7140 0000272B 66B82A000000             mov eax, 42
  7141 00002731 A2[4500]                 mov byte [PrintRA], al
  7142                                  
  7143                                  ;-193                 storeJmpCall();
  7144                                  
  7145 00002734 E80EE4                   call storeJmpCall
  7146                                  
  7147                                  ;-194             }   
  7148                                  
  7149                                  
  7150                                  ;-195         return; 
  7151                                  
  7152                                  @@process284:
  7153 00002737 E99A03                   jmp @@retn
  7154                                  
  7155                                  ;-196         }  
  7156                                  
  7157                                  
  7158                                  ;-197     }
  7159                                  
  7160                                  @@process280:
  7161                                  
  7162                                  ;-198 
  7163                                  
  7164                                  
  7165                                  ;-199     if (CodeType == 7) {//jmp, call
  7166                                  
  7167                                  @@process279:
  7168 0000273A A0[2F00]                 mov al, [CodeType]
  7169 0000273D 3C07                     cmp al, 7
  7170 0000273F 0F85CD00                 jne @@process285
  7171                                  
  7172                                  ;-200         if (TokeType == ALNUME) {
  7173                                  
  7174 00002743 A0[2C00]                 mov al, [TokeType]
  7175 00002746 3C03                     cmp al, 3
  7176 00002748 0F85C400                 jne @@process286
  7177                                  
  7178                                  ;-201             LabelIx=searchLabel();
  7179                                  
  7180 0000274C E822E5                   call searchLabel
  7181 0000274F A3[4A00]                 mov word [LabelIx], ax
  7182                                  
  7183                                  ;-202             if (LabelIx > 0) {
  7184                                  
  7185 00002752 A1[4A00]                 mov ax, [LabelIx]
  7186 00002755 83F800                   cmp ax, 0
  7187 00002758 0F8E9100                 jle @@process287
  7188                                  
  7189                                  ;-203                 disp=LabelAddr[LabelIx];
  7190                                  
  7191 0000275C 8B1E[4A00]               mov bx, [LabelIx]
  7192 00002760 D1E3                     shl bx, 1
  7193 00002762 8B87DB86                 mov ax, [LabelAddr + bx]
  7194 00002766 A3[3D00]                 mov word [disp], ax
  7195                                  
  7196                                  ;-204                 disp = disp - PC;   
  7197                                  
  7198 00002769 A1[3D00]                 mov ax, [disp]
  7199 0000276C 2B06[2300]               sub ax, [PC]
  7200 00002770 A3[3D00]                 mov word [disp], ax
  7201                                  
  7202                                  ;-205                 disp = disp - Origin;
  7203                                  
  7204 00002773 A1[3D00]                 mov ax, [disp]
  7205 00002776 2B06[2500]               sub ax, [Origin]
  7206 0000277A A3[3D00]                 mov word [disp], ax
  7207                                  
  7208                                  ;-206                 if (checkConstSize(disp) ) {
  7209                                  
  7210 0000277D FF36[3D00]               push word [disp]
  7211 00002781 E8E5E1                   call checkConstSize
  7212 00002784 83C402                   add  sp, 2
  7213 00002787 08C0                     or  al, al
  7214 00002789 0F844200                 je @@process288
  7215                                  
  7216                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7217                                  
  7218 0000278D A0[3000]                 mov al, [Code1]
  7219 00002790 3CE9                     cmp al, 233
  7220 00002792 0F851B00                 jne @@process289
  7221                                  
  7222                                  ;-208                         genCode8(0xEB);//short       
  7223                                  
  7224 00002796 68EB00                   push 235
  7225 00002799 E840F9                   call genCode8
  7226 0000279C 83C402                   add  sp, 2
  7227                                  
  7228                                  ;-209                         disp -= 2; 
  7229                                  
  7230 0000279F 832E[3D00]02             sub  word [disp], 2
  7231                                  
  7232                                  ;-210                         genCode8(disp);
  7233                                  
  7234 000027A4 FF36[3D00]               push word [disp]
  7235 000027A8 E831F9                   call genCode8
  7236 000027AB 83C402                   add  sp, 2
  7237                                  
  7238                                  ;-211                     } 
  7239                                  
  7240                                  
  7241                                  ;-212                     else {     
  7242                                  
  7243 000027AE E91B00                   jmp @@process290
  7244                                  @@process289:
  7245                                  
  7246                                  ;-213                         genCode8(Code1);//near    
  7247                                  
  7248 000027B1 A0[3000]                 mov al, byte [Code1]
  7249 000027B4 B400                     mov ah, 0
  7250 000027B6 50                       push ax
  7251 000027B7 E822F9                   call genCode8
  7252 000027BA 83C402                   add  sp, 2
  7253                                  
  7254                                  ;-214                         disp -= 3; 
  7255                                  
  7256 000027BD 832E[3D00]03             sub  word [disp], 3
  7257                                  
  7258                                  ;-215                         genCode16(disp);                       
  7259                                  
  7260 000027C2 FF36[3D00]               push word [disp]
  7261 000027C6 E86AF9                   call genCode16
  7262 000027C9 83C402                   add  sp, 2
  7263                                  
  7264                                  ;-216                     }    
  7265                                  
  7266                                  
  7267                                  ;-217                 } 
  7268                                  
  7269                                  @@process290:
  7270                                  
  7271                                  ;-218                 else {     
  7272                                  
  7273 000027CC E91B00                   jmp @@process291
  7274                                  @@process288:
  7275                                  
  7276                                  ;-219                     genCode8(Code1);//near    
  7277                                  
  7278 000027CF A0[3000]                 mov al, byte [Code1]
  7279 000027D2 B400                     mov ah, 0
  7280 000027D4 50                       push ax
  7281 000027D5 E804F9                   call genCode8
  7282 000027D8 83C402                   add  sp, 2
  7283                                  
  7284                                  ;-220                     disp -= 3; 
  7285                                  
  7286 000027DB 832E[3D00]03             sub  word [disp], 3
  7287                                  
  7288                                  ;-221                     genCode16(disp);                       
  7289                                  
  7290 000027E0 FF36[3D00]               push word [disp]
  7291 000027E4 E84CF9                   call genCode16
  7292 000027E7 83C402                   add  sp, 2
  7293                                  
  7294                                  ;-222                 }    
  7295                                  
  7296                                  
  7297                                  ;-223             }
  7298                                  
  7299                                  @@process291:
  7300                                  
  7301                                  ;-224             else {//jump forward, near only
  7302                                  
  7303 000027EA E92000                   jmp @@process292
  7304                                  @@process287:
  7305                                  
  7306                                  ;-225                 genCode8(Code1);
  7307                                  
  7308 000027ED A0[3000]                 mov al, byte [Code1]
  7309 000027F0 B400                     mov ah, 0
  7310 000027F2 50                       push ax
  7311 000027F3 E8E6F8                   call genCode8
  7312 000027F6 83C402                   add  sp, 2
  7313                                  
  7314                                  ;-226                 genCode16(0);
  7315                                  
  7316 000027F9 6A00                     push 0
  7317 000027FB E835F9                   call genCode16
  7318 000027FE 83C402                   add  sp, 2
  7319                                  
  7320                                  ;-227                 PrintRA='*';
  7321                                  
  7322 00002801 66B82A000000             mov eax, 42
  7323 00002807 A2[4500]                 mov byte [PrintRA], al
  7324                                  
  7325                                  ;-228                 storeJmpCall();
  7326                                  
  7327 0000280A E838E3                   call storeJmpCall
  7328                                  
  7329                                  ;-229             }   
  7330                                  
  7331                                  
  7332                                  ;-230         return; 
  7333                                  
  7334                                  @@process292:
  7335 0000280D E9C402                   jmp @@retn
  7336                                  
  7337                                  ;-231         }
  7338                                  
  7339                                  
  7340                                  ;-232     }
  7341                                  
  7342                                  @@process286:
  7343                                  
  7344                                  ;-233     
  7345                                  
  7346                                  
  7347                                  ;-234     if (CodeType ==  8) {//ret,retf
  7348                                  
  7349                                  @@process285:
  7350 00002810 A0[2F00]                 mov al, [CodeType]
  7351 00002813 3C08                     cmp al, 8
  7352 00002815 0F853100                 jne @@process293
  7353                                  
  7354                                  ;-235         if (TokeType == DIGIT) {
  7355                                  
  7356 00002819 A0[2C00]                 mov al, [TokeType]
  7357 0000281C 3C01                     cmp al, 1
  7358 0000281E 0F851900                 jne @@process294
  7359                                  
  7360                                  ;-236             genCode8(Code2);
  7361                                  
  7362 00002822 A0[3100]                 mov al, byte [Code2]
  7363 00002825 B400                     mov ah, 0
  7364 00002827 50                       push ax
  7365 00002828 E8B1F8                   call genCode8
  7366 0000282B 83C402                   add  sp, 2
  7367                                  
  7368                                  ;-237             genCode16(SymbolInt);
  7369                                  
  7370 0000282E FF36[0E00]               push word [SymbolInt]
  7371 00002832 E8FEF8                   call genCode16
  7372 00002835 83C402                   add  sp, 2
  7373                                  
  7374                                  ;-238             return;
  7375                                  
  7376 00002838 E99902                   jmp @@retn
  7377                                  
  7378                                  ;-239         }
  7379                                  
  7380                                  
  7381                                  ;-240         genCode8(Code1); 
  7382                                  
  7383                                  @@process294:
  7384 0000283B A0[3000]                 mov al, byte [Code1]
  7385 0000283E B400                     mov ah, 0
  7386 00002840 50                       push ax
  7387 00002841 E898F8                   call genCode8
  7388 00002844 83C402                   add  sp, 2
  7389                                  
  7390                                  ;-241         return;
  7391                                  
  7392 00002847 E98A02                   jmp @@retn
  7393                                  
  7394                                  ;-242     }
  7395                                  
  7396                                  
  7397                                  ;-243        
  7398                                  
  7399                                  
  7400                                  ;-244     if (CodeType == 9) {//push, pop  
  7401                                  
  7402                                  @@process293:
  7403 0000284A A0[2F00]                 mov al, [CodeType]
  7404 0000284D 3C09                     cmp al, 9
  7405 0000284F 0F850301                 jne @@process295
  7406                                  
  7407                                  ;-245         getOpL();
  7408                                  
  7409 00002853 E826DD                   call getOpL
  7410                                  
  7411                                  ;-246         if (Code1 == 0x50) {//push only
  7412                                  
  7413 00002856 A0[3000]                 mov al, [Code1]
  7414 00002859 3C50                     cmp al, 80
  7415 0000285B 0F853D00                 jne @@process296
  7416                                  
  7417                                  ;-247             if (Op == IMM) {//push imm8,16
  7418                                  
  7419 0000285F A0[2D00]                 mov al, [Op]
  7420 00002862 3C01                     cmp al, 1
  7421 00002864 0F853400                 jne @@process297
  7422                                  
  7423                                  ;-248                 setsflag();
  7424                                  
  7425 00002868 E899E0                   call setsflag
  7426                                  
  7427                                  ;-249                 genCode2(0x68, sflag);     
  7428                                  
  7429 0000286B A0[3A00]                 mov al, byte [sflag]
  7430 0000286E B400                     mov ah, 0
  7431 00002870 50                       push ax
  7432 00002871 6A68                     push 104
  7433 00002873 E82FF8                   call genCode2
  7434 00002876 83C404                   add  sp, 4
  7435                                  
  7436                                  ;-250                 if (sflag) genCode8 (imme);
  7437                                  
  7438 00002879 A0[3A00]                 mov al, [sflag]
  7439 0000287C 08C0                     or  al, al
  7440 0000287E 0F840D00                 je @@process298
  7441 00002882 FF36[3F00]               push word [imme]
  7442 00002886 E853F8                   call genCode8
  7443 00002889 83C402                   add  sp, 2
  7444                                  
  7445                                  ;-251                 else       genCode16(imme);    
  7446                                  
  7447 0000288C E90A00                   jmp @@process299
  7448                                  @@process298:
  7449 0000288F FF36[3F00]               push word [imme]
  7450 00002893 E89DF8                   call genCode16
  7451 00002896 83C402                   add  sp, 2
  7452                                  
  7453                                  ;-252                 return;   
  7454                                  
  7455                                  @@process299:
  7456 00002899 E93802                   jmp @@retn
  7457                                  
  7458                                  ;-253             }   
  7459                                  
  7460                                  
  7461                                  ;-254         }
  7462                                  
  7463                                  @@process297:
  7464                                  
  7465                                  ;-255         if (R1Type == SEGREG) {
  7466                                  
  7467                                  @@process296:
  7468 0000289C A0[3600]                 mov al, [R1Type]
  7469 0000289F 3C04                     cmp al, 4
  7470 000028A1 0F855A00                 jne @@process300
  7471                                  
  7472                                  ;-256             if (Code1 == 0x58) {
  7473                                  
  7474 000028A5 A0[3000]                 mov al, [Code1]
  7475 000028A8 3C58                     cmp al, 88
  7476 000028AA 0F851200                 jne @@process301
  7477                                  
  7478                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");   
  7479                                  
  7480 000028AE A0[3400]                 mov al, [R1No]
  7481 000028B1 3C01                     cmp al, 1
  7482 000028B3 0F850900                 jne @@process302
  7483 000028B7 68[D62A]                 push process_0
  7484 000028BA E8FFF0                   call error1
  7485 000028BD 83C402                   add  sp, 2
  7486                                  
  7487                                  ;-258             }
  7488                                  
  7489                                  @@process302:
  7490                                  
  7491                                  ;-259             c = R1No <<3;
  7492                                  
  7493                                  @@process301:
  7494 000028C0 A0[3400]                 mov al, [R1No]
  7495 000028C3 C0E003                   shl al, 3
  7496 000028C6 8846FE                   mov byte [bp-2], al
  7497                                  
  7498                                  ;-260             if (R1No > 3) {//FS, GS
  7499                                  
  7500 000028C9 A0[3400]                 mov al, [R1No]
  7501 000028CC 3C03                     cmp al, 3
  7502 000028CE 0F8E0C00                 jle @@process303
  7503                                  
  7504                                  ;-261                 c += 122;
  7505                                  
  7506 000028D2 8046FE7A                 add  byte [bp-2], 122
  7507                                  
  7508                                  ;-262                 genCode8(0x0F);
  7509                                  
  7510 000028D6 6A0F                     push 15
  7511 000028D8 E801F8                   call genCode8
  7512 000028DB 83C402                   add  sp, 2
  7513                                  
  7514                                  ;-263             }
  7515                                  
  7516                                  
  7517                                  ;-264             OpCodePtr++;
  7518                                  
  7519                                  @@process303:
  7520 000028DE FF06[4300]               inc  word [OpCodePtr]
  7521                                  
  7522                                  ;-265             c = c + *OpCodePtr;//is Code4   
  7523                                  
  7524 000028E2 8A46FE                   mov al, [bp-2]
  7525 000028E5 8B1E[4300]               mov bx, [OpCodePtr]
  7526 000028E9 0207                     add al, [bx]
  7527 000028EB B400                     mov ah, 0
  7528 000028ED 8846FE                   mov byte [bp-2], al
  7529                                  
  7530                                  ;-266             genCode8(c);  
  7531                                  
  7532 000028F0 8A46FE                   mov al, byte [bp-2]
  7533 000028F3 B400                     mov ah, 0
  7534 000028F5 50                       push ax
  7535 000028F6 E8E3F7                   call genCode8
  7536 000028F9 83C402                   add  sp, 2
  7537                                  
  7538                                  ;-267             return; 
  7539                                  
  7540 000028FC E9D501                   jmp @@retn
  7541                                  
  7542                                  ;-268         }  
  7543                                  
  7544                                  
  7545                                  ;-269         checkOpL();    
  7546                                  
  7547                                  @@process300:
  7548 000028FF E89DDB                   call checkOpL
  7549                                  
  7550                                  ;-270         if (R1Type == BYTE) reg16error();
  7551                                  
  7552 00002902 A0[3600]                 mov al, [R1Type]
  7553 00002905 3C01                     cmp al, 1
  7554 00002907 0F850300                 jne @@process304
  7555 0000290B E81EF2                   call reg16error
  7556                                  
  7557                                  ;-271         if (R1Type == WORD) {
  7558                                  
  7559                                  @@process304:
  7560 0000290E A0[3600]                 mov al, [R1Type]
  7561 00002911 3C02                     cmp al, 2
  7562 00002913 0F851500                 jne @@process305
  7563                                  
  7564                                  ;-272             genCode2(Code1, R1No);
  7565                                  
  7566 00002917 A0[3400]                 mov al, byte [R1No]
  7567 0000291A B400                     mov ah, 0
  7568 0000291C 50                       push ax
  7569 0000291D A0[3000]                 mov al, byte [Code1]
  7570 00002920 B400                     mov ah, 0
  7571 00002922 50                       push ax
  7572 00002923 E87FF7                   call genCode2
  7573 00002926 83C404                   add  sp, 4
  7574                                  
  7575                                  ;-273             return;   
  7576                                  
  7577 00002929 E9A801                   jmp @@retn
  7578                                  
  7579                                  ;-274         }                
  7580                                  
  7581                                  
  7582                                  ;-275         if (Op == MEM) {
  7583                                  
  7584                                  @@process305:
  7585 0000292C A0[2D00]                 mov al, [Op]
  7586 0000292F 3C04                     cmp al, 4
  7587 00002931 0F851B00                 jne @@process306
  7588                                  
  7589                                  ;-276             genCode8(Code2);
  7590                                  
  7591 00002935 A0[3100]                 mov al, byte [Code2]
  7592 00002938 B400                     mov ah, 0
  7593 0000293A 50                       push ax
  7594 0000293B E89EF7                   call genCode8
  7595 0000293E 83C402                   add  sp, 2
  7596                                  
  7597                                  ;-277             writeEA(Code3);
  7598                                  
  7599 00002941 A0[3200]                 mov al, byte [Code3]
  7600 00002944 B400                     mov ah, 0
  7601 00002946 50                       push ax
  7602 00002947 E830F8                   call writeEA
  7603 0000294A 83C402                   add  sp, 2
  7604                                  
  7605                                  ;-278             return;   
  7606                                  
  7607 0000294D E98401                   jmp @@retn
  7608                                  
  7609                                  ;-279         }
  7610                                  
  7611                                  
  7612                                  ;-280         syntaxerror();
  7613                                  
  7614                                  @@process306:
  7615 00002950 E828F2                   call syntaxerror
  7616                                  
  7617                                  ;-281         return;        
  7618                                  
  7619 00002953 E97E01                   jmp @@retn
  7620                                  
  7621                                  ;-282     }
  7622                                  
  7623                                  
  7624                                  ;-283     
  7625                                  
  7626                                  
  7627                                  ;-284     if (CodeType == 11) {//shift, rotate
  7628                                  
  7629                                  @@process295:
  7630 00002956 A0[2F00]                 mov al, [CodeType]
  7631 00002959 3C0B                     cmp al, 11
  7632 0000295B 0F859500                 jne @@process307
  7633                                  
  7634                                  ;-285         check2Ops();
  7635                                  
  7636 0000295F E8BFDB                   call check2Ops
  7637                                  
  7638                                  ;-286         if (Op2 == IMM) {
  7639                                  
  7640 00002962 A0[2E00]                 mov al, [Op2]
  7641 00002965 3C01                     cmp al, 1
  7642 00002967 0F854400                 jne @@process308
  7643                                  
  7644                                  ;-287             if (imme == 1) {
  7645                                  
  7646 0000296B A1[3F00]                 mov ax, [imme]
  7647 0000296E 83F801                   cmp ax, 1
  7648 00002971 0F851800                 jne @@process309
  7649                                  
  7650                                  ;-288                 genCodeW(0xD0);
  7651                                  
  7652 00002975 68D000                   push 208
  7653 00002978 E845F7                   call genCodeW
  7654 0000297B 83C402                   add  sp, 2
  7655                                  
  7656                                  ;-289                 writeEA(Code1);
  7657                                  
  7658 0000297E A0[3000]                 mov al, byte [Code1]
  7659 00002981 B400                     mov ah, 0
  7660 00002983 50                       push ax
  7661 00002984 E8F3F7                   call writeEA
  7662 00002987 83C402                   add  sp, 2
  7663                                  
  7664                                  ;-290                 return;
  7665                                  
  7666 0000298A E94701                   jmp @@retn
  7667                                  
  7668                                  ;-291             }
  7669                                  
  7670                                  
  7671                                  ;-292             genCodeW(0xC0);//80186
  7672                                  
  7673                                  @@process309:
  7674 0000298D 68C000                   push 192
  7675 00002990 E82DF7                   call genCodeW
  7676 00002993 83C402                   add  sp, 2
  7677                                  
  7678                                  ;-293             writeEA(Code1);
  7679                                  
  7680 00002996 A0[3000]                 mov al, byte [Code1]
  7681 00002999 B400                     mov ah, 0
  7682 0000299B 50                       push ax
  7683 0000299C E8DBF7                   call writeEA
  7684 0000299F 83C402                   add  sp, 2
  7685                                  
  7686                                  ;-294             genCode8(imme);
  7687                                  
  7688 000029A2 FF36[3F00]               push word [imme]
  7689 000029A6 E833F7                   call genCode8
  7690 000029A9 83C402                   add  sp, 2
  7691                                  
  7692                                  ;-295             return;    
  7693                                  
  7694 000029AC E92501                   jmp @@retn
  7695                                  
  7696                                  ;-296         }
  7697                                  
  7698                                  
  7699                                  ;-297         if (Op2 == REG) {
  7700                                  
  7701                                  @@process308:
  7702 000029AF A0[2E00]                 mov al, [Op2]
  7703 000029B2 3C02                     cmp al, 2
  7704 000029B4 0F853C00                 jne @@process310
  7705                                  
  7706                                  ;-298             if (R2Type == BYTE) {
  7707                                  
  7708 000029B8 A0[3500]                 mov al, [R2Type]
  7709 000029BB 3C01                     cmp al, 1
  7710 000029BD 0F853300                 jne @@process311
  7711                                  
  7712                                  ;-299                 if (R2No == 1) {//CL-REG 
  7713                                  
  7714 000029C1 A0[3300]                 mov al, [R2No]
  7715 000029C4 3C01                     cmp al, 1
  7716 000029C6 0F852A00                 jne @@process312
  7717                                  
  7718                                  ;-300                     if (R1Type == WORD) wflag=1;//hack
  7719                                  
  7720 000029CA A0[3600]                 mov al, [R1Type]
  7721 000029CD 3C02                     cmp al, 2
  7722 000029CF 0F850900                 jne @@process313
  7723 000029D3 66B801000000             mov eax, 1
  7724 000029D9 A2[3800]                 mov byte [wflag], al
  7725                                  
  7726                                  ;-301                     genCodeW(0xD2);
  7727                                  
  7728                                  @@process313:
  7729 000029DC 68D200                   push 210
  7730 000029DF E8DEF6                   call genCodeW
  7731 000029E2 83C402                   add  sp, 2
  7732                                  
  7733                                  ;-302                     writeEA(Code1);
  7734                                  
  7735 000029E5 A0[3000]                 mov al, byte [Code1]
  7736 000029E8 B400                     mov ah, 0
  7737 000029EA 50                       push ax
  7738 000029EB E88CF7                   call writeEA
  7739 000029EE 83C402                   add  sp, 2
  7740                                  
  7741                                  ;-303                     return;   
  7742                                  
  7743 000029F1 E9E000                   jmp @@retn
  7744                                  
  7745                                  ;-304                 }   
  7746                                  
  7747                                  
  7748                                  ;-305             }
  7749                                  
  7750                                  @@process312:
  7751                                  
  7752                                  ;-306         }    
  7753                                  
  7754                                  @@process311:
  7755                                  
  7756                                  ;-307     }     
  7757                                  
  7758                                  @@process310:
  7759                                  
  7760                                  ;-308     
  7761                                  
  7762                                  
  7763                                  ;-309     if (CodeType == 12) {//int
  7764                                  
  7765                                  @@process307:
  7766 000029F4 A0[2F00]                 mov al, [CodeType]
  7767 000029F7 3C0C                     cmp al, 12
  7768 000029F9 0F852200                 jne @@process314
  7769                                  
  7770                                  ;-310         if (TokeType == DIGIT) {            
  7771                                  
  7772 000029FD A0[2C00]                 mov al, [TokeType]
  7773 00002A00 3C01                     cmp al, 1
  7774 00002A02 0F851900                 jne @@process315
  7775                                  
  7776                                  ;-311             genCode8(Code1);
  7777                                  
  7778 00002A06 A0[3000]                 mov al, byte [Code1]
  7779 00002A09 B400                     mov ah, 0
  7780 00002A0B 50                       push ax
  7781 00002A0C E8CDF6                   call genCode8
  7782 00002A0F 83C402                   add  sp, 2
  7783                                  
  7784                                  ;-312             genCode8(SymbolInt);
  7785                                  
  7786 00002A12 FF36[0E00]               push word [SymbolInt]
  7787 00002A16 E8C3F6                   call genCode8
  7788 00002A19 83C402                   add  sp, 2
  7789                                  
  7790                                  ;-313             return;   
  7791                                  
  7792 00002A1C E9B500                   jmp @@retn
  7793                                  
  7794                                  ;-314         }
  7795                                  
  7796                                  
  7797                                  ;-315     }
  7798                                  
  7799                                  @@process315:
  7800                                  
  7801                                  ;-316     
  7802                                  
  7803                                  
  7804                                  ;-317     if (CodeType == 30) {//enter i18,i8
  7805                                  
  7806                                  @@process314:
  7807 00002A1F A0[2F00]                 mov al, [CodeType]
  7808 00002A22 3C1E                     cmp al, 30
  7809 00002A24 0F855200                 jne @@process316
  7810                                  
  7811                                  ;-318         genCode8(0xC8);
  7812                                  
  7813 00002A28 68C800                   push 200
  7814 00002A2B E8AEF6                   call genCode8
  7815 00002A2E 83C402                   add  sp, 2
  7816                                  
  7817                                  ;-319         Op=getOp1();
  7818                                  
  7819 00002A31 E805DC                   call getOp1
  7820 00002A34 A2[2D00]                 mov byte [Op], al
  7821                                  
  7822                                  ;-320         if (Op == IMM) genCode16(SymbolInt);
  7823                                  
  7824 00002A37 A0[2D00]                 mov al, [Op]
  7825 00002A3A 3C01                     cmp al, 1
  7826 00002A3C 0F850D00                 jne @@process317
  7827 00002A40 FF36[0E00]               push word [SymbolInt]
  7828 00002A44 E8ECF6                   call genCode16
  7829 00002A47 83C402                   add  sp, 2
  7830                                  
  7831                                  ;-321         else numbererror();
  7832                                  
  7833 00002A4A E90300                   jmp @@process318
  7834                                  @@process317:
  7835 00002A4D E898F0                   call numbererror
  7836                                  
  7837                                  ;-322         need(',');
  7838                                  
  7839                                  @@process318:
  7840 00002A50 6A2C                     push 44
  7841 00002A52 E83EE5                   call need
  7842 00002A55 83C402                   add  sp, 2
  7843                                  
  7844                                  ;-323         Op=getOp1();
  7845                                  
  7846 00002A58 E8DEDB                   call getOp1
  7847 00002A5B A2[2D00]                 mov byte [Op], al
  7848                                  
  7849                                  ;-324         if (Op == IMM) genCode8 (SymbolInt);
  7850                                  
  7851 00002A5E A0[2D00]                 mov al, [Op]
  7852 00002A61 3C01                     cmp al, 1
  7853 00002A63 0F850D00                 jne @@process319
  7854 00002A67 FF36[0E00]               push word [SymbolInt]
  7855 00002A6B E86EF6                   call genCode8
  7856 00002A6E 83C402                   add  sp, 2
  7857                                  
  7858                                  ;-325         else numbererror();           
  7859                                  
  7860 00002A71 E90300                   jmp @@process320
  7861                                  @@process319:
  7862 00002A74 E871F0                   call numbererror
  7863                                  
  7864                                  ;-326         return;
  7865                                  
  7866                                  @@process320:
  7867 00002A77 E95A00                   jmp @@retn
  7868                                  
  7869                                  ;-327     }
  7870                                  
  7871                                  
  7872                                  ;-328        
  7873                                  
  7874                                  
  7875                                  ;-329     if (CodeType==101) {//ORG nn
  7876                                  
  7877                                  @@process316:
  7878 00002A7A A0[2F00]                 mov al, [CodeType]
  7879 00002A7D 3C65                     cmp al, 101
  7880 00002A7F 0F851500                 jne @@process321
  7881                                  
  7882                                  ;-330         if (TokeType != DIGIT) numbererror();
  7883                                  
  7884 00002A83 A0[2C00]                 mov al, [TokeType]
  7885 00002A86 3C01                     cmp al, 1
  7886 00002A88 0F840300                 je  @@process322
  7887 00002A8C E859F0                   call numbererror
  7888                                  
  7889                                  ;-331         Origin=SymbolInt;
  7890                                  
  7891                                  @@process322:
  7892 00002A8F A1[0E00]                 mov ax, [SymbolInt]
  7893 00002A92 A3[2500]                 mov word [Origin], ax
  7894                                  
  7895                                  ;-332         return;
  7896                                  
  7897 00002A95 E93C00                   jmp @@retn
  7898                                  
  7899                                  ;-333     }
  7900                                  
  7901                                  
  7902                                  ;-334     
  7903                                  
  7904                                  
  7905                                  ;-335     if (CodeType == 102) {//section, segment  
  7906                                  
  7907                                  @@process321:
  7908 00002A98 A0[2F00]                 mov al, [CodeType]
  7909 00002A9B 3C66                     cmp al, 102
  7910 00002A9D 0F850C00                 jne @@process323
  7911                                  
  7912                                  ;-336         //getTokeType();//ignore .bss .text .data 
  7913                                  
  7914                                  
  7915                                  ;-337         AbsoluteLab=0;//nasm resets erevy time
  7916                                  
  7917 00002AA1 66B800000000             mov eax, 0
  7918 00002AA7 A3[2700]                 mov word [AbsoluteLab], ax
  7919                                  
  7920                                  ;-338         return;  
  7921                                  
  7922 00002AAA E92700                   jmp @@retn
  7923                                  
  7924                                  ;-339     }
  7925                                  
  7926                                  
  7927                                  ;-340                
  7928                                  
  7929                                  
  7930                                  ;-341     if (CodeType == 110) {//absolute
  7931                                  
  7932                                  @@process323:
  7933 00002AAD A0[2F00]                 mov al, [CodeType]
  7934 00002AB0 3C6E                     cmp al, 110
  7935 00002AB2 0F851500                 jne @@process324
  7936                                  
  7937                                  ;-342         if (TokeType != DIGIT) numbererror();
  7938                                  
  7939 00002AB6 A0[2C00]                 mov al, [TokeType]
  7940 00002AB9 3C01                     cmp al, 1
  7941 00002ABB 0F840300                 je  @@process325
  7942 00002ABF E826F0                   call numbererror
  7943                                  
  7944                                  ;-343         AbsoluteLab=SymbolInt;
  7945                                  
  7946                                  @@process325:
  7947 00002AC2 A1[0E00]                 mov ax, [SymbolInt]
  7948 00002AC5 A3[2700]                 mov word [AbsoluteLab], ax
  7949                                  
  7950                                  ;-344         return;           
  7951                                  
  7952 00002AC8 E90900                   jmp @@retn
  7953                                  
  7954                                  ;-345     }
  7955                                  
  7956                                  
  7957                                  ;-346                
  7958                                  
  7959                                  
  7960                                  ;-347     error1("Command not implemented or syntax error");
  7961                                  
  7962                                  @@process324:
  7963 00002ACB 68[E92A]                 push process_1
  7964 00002ACE E8EBEE                   call error1
  7965 00002AD1 83C402                   add  sp, 2
  7966                                  
  7967                                  ;-348 }    
  7968                                  
  7969 00002AD4 C9                      @@retn: LEAVE
  7970 00002AD5 C3                       ret
  7971                                  ; ENDP
  7972 00002AD6 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7973 00002ADF 7420616C6C6F776564-
  7974 00002AE8 00                 
  7975 00002AE9 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7976 00002AF2 6F7420696D706C656D-
  7977 00002AFB 656E746564206F7220-
  7978 00002B04 73796E746178206572-
  7979 00002B0D 726F7200           
  7980                                   
  7981                                  ; missing functions: 
  7982                                  ; digit
  7983                                  ; strcpy
  7984                                  ; strcpy
  7985                                  ; eqstr
  7986                                  ; strlen
  7987                                  ; eqstr
  7988                                  ; eqstr
  7989                                  ; eqstr
  7990                                  ; eqstr
  7991                                  ; readRL
  7992                                  ; readRL
  7993                                  ; digit
  7994                                  ; digit
  7995                                  ; strcpy
  7996                                  ; toupper
  7997                                  ; strlen
  7998                                  ; strlen
  7999                                  ; eqstr
  8000                                  ; eqstr
  8001                                  ; eqstr
  8002                                  ; eqstr
  8003                                  ; eqstr
  8004                                  ; eqstr
  8005                                  ; eqstr
  8006                                  ; eqstr
  8007                                  ; eqstr
  8008                                  ; eqstr
  8009                                  ; eqstr
  8010                                  ; eqstr
  8011                                  ; eqstr
  8012                                  ; eqstr
  8013                                  ; eqstr
  8014                                  ; eqstr
  8015                                  ; eqstr
  8016                                  ; eqstr
  8017                                  ; eqstr
  8018                                  ; eqstr
  8019                                  ; eqstr
  8020                                  ; eqstr
  8021                                  ; eqstr
  8022                                  ; eqstr
  8023                                  ; eqstr
  8024                                  ; eqstr
  8025                                  ; eqstr
  8026                                  ; eqstr
  8027                                  ; eqstr
  8028                                  ; eqstr
  8029                                  ; writetty
  8030                                  ; writetty
  8031                                  ; fputcR
  8032                                  ; cputs
  8033                                  ; cputs
  8034                                  ; exitR
  8035                                  ; toupper
  8036                                  ; strcpy
  8037                                  ; strcat1
  8038                                  ; strcpy
  8039                                  ; strcat1
  8040                                  ; strcpy
  8041                                  ; strcat1
  8042                                  ; openR
  8043                                  ; cputs
  8044                                  ; cputs
  8045                                  ; exitR
  8046                                  ; creatR
  8047                                  ; cputs
  8048                                  ; cputs
  8049                                  ; exitR
  8050                                  ; creatR
  8051                                  ; cputs
  8052                                  ; cputs
  8053                                  ; exitR
  8054                                  ; strcpy
  8055                                  ; strlen
  8056                                  ; fputcR
  8057                                  ; fcloseR
  8058                                  ; fcloseR
  8059                                  ; fcloseR
  8060                                  ; exitR
  8061                                  ; Number of unresolved CALLs :   79
  8062                                  ;use archive file: AR.C
  8063                                  
  8064                                  ;-349 // AR.C Archive
  8065                                  
  8066                                  ;Number of CALLs:    2 : writetty
  8067                                  
  8068                                  writetty:  ; *** PROC ***
  8069 00002B11 B40E                     mov  ah, 14
  8070 00002B13 BB0000                   mov  bx, 0
  8071 00002B16 CD10                     int  16
  8072                                  
  8073                                  ;-350 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  8074                                  
  8075 00002B18 C3                       ret
  8076                                  ; ENDP
  8077                                  ;Number of CALLs:    8 : cputs
  8078                                  
  8079                                  cputs:  ; *** PROC ***
  8080                                  ;Function : cputs, Number of local variables: 2
  8081                                  ;   # type sign width line used address name   list of local variables
  8082                                  ;  250 ptr sign byte   350 NULL bp+4    s
  8083                                  ;  251 var sign byte   350 NULL bp-2    c;
  8084 00002B19 C8020000                 ENTER  2,0
  8085                                  @@cputs326:
  8086 00002B1D 8B5E04                   mov bx, [bp+4]
  8087 00002B20 8A07                     mov al, [bx]
  8088 00002B22 B400                     mov ah, 0
  8089 00002B24 08C0                     or  al, al
  8090 00002B26 0F841B00                 je @@cputs327
  8091 00002B2A 8B5E04                   mov bx, [bp+4]
  8092 00002B2D 8A07                     mov al, [bx]
  8093 00002B2F B400                     mov ah, 0
  8094 00002B31 8846FE                   mov byte [bp-2], al
  8095 00002B34 8A46FE                   mov al, byte [bp-2]
  8096 00002B37 B400                     mov ah, 0
  8097 00002B39 50                       push ax
  8098 00002B3A E8C401                   call putch
  8099 00002B3D 83C402                   add  sp, 2
  8100 00002B40 FF4604                   inc  word [bp+4]
  8101 00002B43 EBD8                     jmp @@cputs326
  8102                                  @@cputs327:
  8103                                  
  8104                                  ;-351 int mkneg(int n) { n; __asm {neg ax} }
  8105 00002B45 C9                       LEAVE
  8106 00002B46 C3                       ret
  8107                                  ; ENDP
  8108                                  ;Number of CALLs:    2 : toupper
  8109                                  
  8110                                  toupper:  ; *** PROC ***
  8111                                  ;Function : toupper, Number of local variables: 1
  8112                                  ;   # type sign width line used address name   list of local variables
  8113                                  ;  250 ptr sign byte   351 NULL bp+4    s;
  8114 00002B47 C8000000                 ENTER  0,0
  8115                                  @@toupper328:
  8116 00002B4B 8B5E04                   mov bx, [bp+4]
  8117 00002B4E 8A07                     mov al, [bx]
  8118 00002B50 B400                     mov ah, 0
  8119 00002B52 08C0                     or  al, al
  8120 00002B54 0F843000                 je @@toupper329
  8121 00002B58 8B5E04                   mov bx, [bp+4]
  8122 00002B5B 8A07                     mov al, [bx]
  8123 00002B5D B400                     mov ah, 0
  8124 00002B5F 83F861                   cmp ax, 97 ;unsigned : 1
  8125 00002B62 0F8C1D00                 jl  @@toupper330
  8126 00002B66 8B5E04                   mov bx, [bp+4]
  8127 00002B69 8A07                     mov al, [bx]
  8128 00002B6B B400                     mov ah, 0
  8129 00002B6D 83F87A                   cmp ax, 122
  8130 00002B70 0F8F0F00                 jg  @@toupper331
  8131 00002B74 8B5E04                   mov bx, [bp+4]
  8132 00002B77 8A07                     mov al, [bx]
  8133 00002B79 B400                     mov ah, 0
  8134 00002B7B 83E820                   sub ax, 32
  8135 00002B7E 8B5E04                   mov  bx, [bp+4]
  8136 00002B81 8807                     mov  [bx], al
  8137                                  @@toupper331:
  8138                                  @@toupper330:
  8139 00002B83 FF4604                   inc  word [bp+4]
  8140 00002B86 EBC3                     jmp @@toupper328
  8141                                  @@toupper329:
  8142                                  
  8143                                  ;-352 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  8144                                  
  8145                                  
  8146                                  ;-353 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  8147 00002B88 C9                       LEAVE
  8148 00002B89 C3                       ret
  8149                                  ; ENDP
  8150                                  ;Number of CALLs:    4 : strlen
  8151                                  
  8152                                  strlen:  ; *** PROC ***
  8153                                  ;Function : strlen, Number of local variables: 2
  8154                                  ;   # type sign width line used address name   list of local variables
  8155                                  ;  250 ptr sign byte   353 NULL bp+4    s
  8156                                  ;  251 var sign word   353 NULL bp-2    c;
  8157 00002B8A C8020000                 ENTER  2,0
  8158 00002B8E 66B800000000             mov eax, 0
  8159 00002B94 8946FE                   mov word [bp-2], ax
  8160                                  @@strlen332:
  8161 00002B97 8B5E04                   mov bx, [bp+4]
  8162 00002B9A 8A07                     mov al, [bx]
  8163 00002B9C B400                     mov ah, 0
  8164 00002B9E 83F800                   cmp ax, 0
  8165 00002BA1 0F840800                 je  @@strlen333
  8166 00002BA5 FF4604                   inc  word [bp+4]
  8167 00002BA8 FF46FE                   inc  word [bp-2]
  8168 00002BAB EBEA                     jmp @@strlen332
  8169                                  @@strlen333:
  8170 00002BAD 8B46FE                   mov ax, [bp-2]
  8171 00002BB0 E90000                   jmp @@retn
  8172                                  
  8173                                  ;-354 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  8174                                  
  8175 00002BB3 C9                      @@retn: LEAVE
  8176 00002BB4 C3                       ret
  8177                                  ; ENDP
  8178                                  ;Number of CALLs:    7 : strcpy
  8179                                  
  8180                                  strcpy:  ; *** PROC ***
  8181                                  ;Function : strcpy, Number of local variables: 2
  8182                                  ;   # type sign width line used address name   list of local variables
  8183                                  ;  250 ptr sign byte   354 NULL bp+4    s
  8184                                  ;  251 ptr sign byte   354 NULL bp+6    t;
  8185 00002BB5 C8000000                 ENTER  0,0
  8186                                  @@strcpy334:
  8187 00002BB9 8B5E06                   mov bx, [bp+6]
  8188 00002BBC 8A07                     mov al, [bx]
  8189 00002BBE B400                     mov ah, 0
  8190 00002BC0 8B5E04                   mov  bx, [bp+4]
  8191 00002BC3 8807                     mov  [bx], al
  8192 00002BC5 FF4604                   inc  word [bp+4]
  8193 00002BC8 FF4606                   inc  word [bp+6]
  8194                                  
  8195                                  ;-355   while (*t!=0); *s=0; return s; }
  8196                                  
  8197 00002BCB 8B5E06                   mov bx, [bp+6]
  8198 00002BCE 8A07                     mov al, [bx]
  8199 00002BD0 B400                     mov ah, 0
  8200 00002BD2 83F800                   cmp ax, 0
  8201 00002BD5 0F840200                 je  @@strcpy335
  8202 00002BD9 EBDE                     jmp @@strcpy334
  8203                                  @@strcpy335:
  8204 00002BDB 66B800000000             mov eax, 0
  8205 00002BE1 8B5E04                   mov  bx, [bp+4]
  8206 00002BE4 8807                     mov  [bx], al
  8207 00002BE6 8B4604                   mov ax, [bp+4]
  8208 00002BE9 E90000                   jmp @@retn
  8209                                  
  8210                                  ;-356 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  8211                                  
  8212 00002BEC C9                      @@retn: LEAVE
  8213 00002BED C3                       ret
  8214                                  ; ENDP
  8215                                  ;Number of CALLs:    3 : digit
  8216                                  
  8217                                  digit:  ; *** PROC ***
  8218                                  ;Function : digit, Number of local variables: 1
  8219                                  ;   # type sign width line used address name   list of local variables
  8220                                  ;  250 var sign byte   356 NULL bp+4    c;
  8221 00002BEE C8000000                 ENTER  0,0
  8222 00002BF2 8A4604                   mov al, [bp+4]
  8223 00002BF5 3C30                     cmp al, 48
  8224 00002BF7 0F8D0900                 jge @@digit336
  8225 00002BFB 66B800000000             mov eax, 0
  8226 00002C01 E91B00                   jmp @@retn
  8227                                  @@digit336:
  8228 00002C04 8A4604                   mov al, [bp+4]
  8229 00002C07 3C39                     cmp al, 57
  8230 00002C09 0F8E0900                 jle @@digit337
  8231 00002C0D 66B800000000             mov eax, 0
  8232 00002C13 E90900                   jmp @@retn
  8233                                  @@digit337:
  8234 00002C16 66B801000000             mov eax, 1
  8235 00002C1C E90000                   jmp @@retn
  8236                                  
  8237                                  ;-357 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  8238                                  
  8239 00002C1F C9                      @@retn: LEAVE
  8240 00002C20 C3                       ret
  8241                                  ; ENDP
  8242                                  ;Number of CALLs:   35 : eqstr
  8243                                  
  8244                                  eqstr:  ; *** PROC ***
  8245                                  ;Function : eqstr, Number of local variables: 2
  8246                                  ;   # type sign width line used address name   list of local variables
  8247                                  ;  250 ptr sign byte   357 NULL bp+4    p
  8248                                  ;  251 ptr sign byte   357 NULL bp+6    q;
  8249 00002C21 C8000000                 ENTER  0,0
  8250                                  @@eqstr338:
  8251 00002C25 8B5E04                   mov bx, [bp+4]
  8252 00002C28 8A07                     mov al, [bx]
  8253 00002C2A B400                     mov ah, 0
  8254 00002C2C 08C0                     or  al, al
  8255 00002C2E 0F842300                 je @@eqstr339
  8256                                  
  8257                                  ;-358     if (*p != *q) return 0; p++; q++; }
  8258                                  
  8259 00002C32 8B5E04                   mov bx, [bp+4]
  8260 00002C35 8A07                     mov al, [bx]
  8261 00002C37 B400                     mov ah, 0
  8262 00002C39 8B5E06                   mov bx, [bp+6]
  8263 00002C3C 3A07                     cmp al, [bx]
  8264 00002C3E B400                     mov ah, 0
  8265 00002C40 0F840900                 je  @@eqstr340
  8266 00002C44 66B800000000             mov eax, 0
  8267 00002C4A E92700                   jmp @@retn
  8268                                  @@eqstr340:
  8269 00002C4D FF4604                   inc  word [bp+4]
  8270 00002C50 FF4606                   inc  word [bp+6]
  8271                                  
  8272                                  ;-359     if(*q) return 0; return 1; }
  8273                                  
  8274 00002C53 EBD0                     jmp @@eqstr338
  8275                                  @@eqstr339:
  8276 00002C55 8B5E06                   mov bx, [bp+6]
  8277 00002C58 8A07                     mov al, [bx]
  8278 00002C5A B400                     mov ah, 0
  8279 00002C5C 08C0                     or  al, al
  8280 00002C5E 0F840900                 je @@eqstr341
  8281 00002C62 66B800000000             mov eax, 0
  8282 00002C68 E90900                   jmp @@retn
  8283                                  @@eqstr341:
  8284 00002C6B 66B801000000             mov eax, 1
  8285 00002C71 E90000                   jmp @@retn
  8286                                  
  8287                                  ;-360 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  8288                                  
  8289 00002C74 C9                      @@retn: LEAVE
  8290 00002C75 C3                       ret
  8291                                  ; ENDP
  8292                                  ;Number of CALLs:    3 : strcat1
  8293                                  
  8294                                  strcat1:  ; *** PROC ***
  8295                                  ;Function : strcat1, Number of local variables: 2
  8296                                  ;   # type sign width line used address name   list of local variables
  8297                                  ;  250 ptr sign byte   360 NULL bp+4    s
  8298                                  ;  251 ptr sign byte   360 NULL bp+6    t;
  8299 00002C76 C8000000                 ENTER  0,0
  8300                                  @@strcat1342:
  8301 00002C7A 8B5E04                   mov bx, [bp+4]
  8302 00002C7D 8A07                     mov al, [bx]
  8303 00002C7F B400                     mov ah, 0
  8304 00002C81 83F800                   cmp ax, 0
  8305 00002C84 0F840500                 je  @@strcat1343
  8306 00002C88 FF4604                   inc  word [bp+4]
  8307 00002C8B EBED                     jmp @@strcat1342
  8308                                  @@strcat1343:
  8309 00002C8D FF7606                   push word [bp+6]
  8310 00002C90 FF7604                   push word [bp+4]
  8311 00002C93 E81FFF                   call strcpy
  8312 00002C96 83C404                   add  sp, 4
  8313                                  
  8314                                  ;-361 int basename(char *s) { char *p; p=0;
  8315 00002C99 C9                       LEAVE
  8316 00002C9A C3                       ret
  8317                                  ; ENDP
  8318                                  ;Number of CALLs:    1 : openR
  8319                                  
  8320                                  openR:  ; *** PROC ***
  8321                                  ;Function : openR, Number of local variables: 1
  8322                                  ;   # type sign width line used address name   list of local variables
  8323                                  ;  250 ptr sign byte   361 NULL bp+4    s;
  8324 00002C9B C8000000                 ENTER  0,0
  8325 00002C9F 8B5604                   mov  dx, [bp+4]
  8326 00002CA2 B8023D                   mov  ax, 15618
  8327 00002CA5 E87200                   call DosInt
  8328                                  
  8329                                  ;-362 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  8330 00002CA8 C9                       LEAVE
  8331 00002CA9 C3                       ret
  8332                                  ; ENDP
  8333                                  ;Number of CALLs:    2 : creatR
  8334                                  
  8335                                  creatR:  ; *** PROC ***
  8336                                  ;Function : creatR, Number of local variables: 1
  8337                                  ;   # type sign width line used address name   list of local variables
  8338                                  ;  250 ptr sign byte   362 NULL bp+4    s;
  8339 00002CAA C8000000                 ENTER  0,0
  8340 00002CAE 8B5604                   mov  dx, [bp+4]
  8341 00002CB1 B90000                   mov  cx, 0
  8342 00002CB4 B8003C                   mov  ax, 15360
  8343 00002CB7 E86000                   call DosInt
  8344                                  
  8345                                  ;-363 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  8346 00002CBA C9                       LEAVE
  8347 00002CBB C3                       ret
  8348                                  ; ENDP
  8349                                  ;Number of CALLs:    2 : readRL
  8350                                  
  8351                                  readRL:  ; *** PROC ***
  8352                                  ;Function : readRL, Number of local variables: 3
  8353                                  ;   # type sign width line used address name   list of local variables
  8354                                  ;  250 ptr sign byte   363 NULL bp+4    s
  8355                                  ;  251 var sign word   363 NULL bp+6    fd
  8356                                  ;  252 var sign word   363 NULL bp+8    len;
  8357 00002CBC C8000000                 ENTER  0,0
  8358 00002CC0 8B5604                   mov  dx, [bp+4]
  8359 00002CC3 8B4E08                   mov  cx, [bp+8]
  8360 00002CC6 8B5E06                   mov  bx, [bp+6]
  8361 00002CC9 B8003F                   mov  ax, 16128
  8362 00002CCC E84B00                   call DosInt
  8363                                  
  8364                                  ;-364 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  8365 00002CCF C9                       LEAVE
  8366 00002CD0 C3                       ret
  8367                                  ; ENDP
  8368                                  ;Number of CALLs:    2 : fputcR
  8369                                  
  8370                                  fputcR:  ; *** PROC ***
  8371                                  ;Function : fputcR, Number of local variables: 2
  8372                                  ;   # type sign width line used address name   list of local variables
  8373                                  ;  250 ptr sign byte   364 NULL bp+4    n
  8374                                  ;  251 var sign word   364 NULL bp+6    fd;
  8375 00002CD1 C8000000                 ENTER  0,0
  8376 00002CD5 8D5604                  lea dx, [bp+4]
  8377                                  
  8378                                  ;-365   cx=1; bx=fd; ax=0x4000; DosInt(); }
  8379                                  
  8380 00002CD8 B90100                   mov  cx, 1
  8381 00002CDB 8B5E06                   mov  bx, [bp+6]
  8382 00002CDE B80040                   mov  ax, 16384
  8383 00002CE1 E83600                   call DosInt
  8384                                  
  8385                                  ;-366 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  8386 00002CE4 C9                       LEAVE
  8387 00002CE5 C3                       ret
  8388                                  ; ENDP
  8389                                  ;Number of CALLs:    3 : fcloseR
  8390                                  
  8391                                  fcloseR:  ; *** PROC ***
  8392                                  ;Function : fcloseR, Number of local variables: 1
  8393                                  ;   # type sign width line used address name   list of local variables
  8394                                  ;  250 var sign word   366 NULL bp+4    fd;
  8395 00002CE6 C8000000                 ENTER  0,0
  8396 00002CEA 8B5E04                   mov  bx, [bp+4]
  8397 00002CED B8003E                   mov  ax, 15872
  8398 00002CF0 CD21                     int  33
  8399                                  
  8400                                  ;-367 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  8401 00002CF2 C9                       LEAVE
  8402 00002CF3 C3                       ret
  8403                                  ; ENDP
  8404                                  ;Number of CALLs:    5 : exitR
  8405                                  
  8406                                  exitR:  ; *** PROC ***
  8407                                  ;Function : exitR, Number of local variables: 1
  8408                                  ;   # type sign width line used address name   list of local variables
  8409                                  ;  250 var sign byte   367 NULL bp+4    c;
  8410 00002CF4 C8000000                 ENTER  0,0
  8411 00002CF8 B44C                     mov  ah, 76
  8412 00002CFA 8A4604                   mov  al, [bp+4]
  8413 00002CFD CD21                     int  33
  8414                                  
  8415                                  ;-368 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  8416 00002CFF C9                       LEAVE
  8417 00002D00 C3                       ret
  8418                                  ; ENDP
  8419                                  ;End of archive file. 
  8420                                   
  8421                                  ; missing functions: 
  8422                                  ; putch
  8423                                  ; DosInt
  8424                                  ; DosInt
  8425                                  ; DosInt
  8426                                  ; DosInt
  8427                                  ; Number of unresolved CALLs :    5
  8428                                  ;use archive file: AR.C
  8429                                  
  8430                                  ;-369 // AR.C Archive
  8431                                  
  8432                                  ;Number of CALLs:    1 : putch
  8433                                  
  8434                                  putch:  ; *** PROC ***
  8435                                  ;Function : putch, Number of local variables: 1
  8436                                  ;   # type sign width line used address name   list of local variables
  8437                                  ;  250 var sign byte   369 NULL bp+4    c;
  8438 00002D01 C8000000                 ENTER  0,0
  8439 00002D05 807E040A                cmp byte [bp+4], 10
  8440 00002D09 0F850500                 jne @@putch344
  8441 00002D0D B00D                     mov  al, 13
  8442 00002D0F E8FFFD                   call writetty
  8443                                  @@putch344:
  8444 00002D12 8A4604                   mov  al, [bp+4]
  8445 00002D15 E8F9FD                   call writetty
  8446                                  
  8447                                  ;-370 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  8448 00002D18 C9                       LEAVE
  8449 00002D19 C3                       ret
  8450                                  ; ENDP
  8451                                  ;Number of CALLs:    4 : DosInt
  8452                                  
  8453                                  DosInt:  ; *** PROC ***
  8454 00002D1A CD21                     int  33
  8455 00002D1C 7304                     jae short @@DosInt345
  8456 00002D1E FF06[1C00]               inc  word [DOS_ERR]
  8457                                  @@DosInt345:
  8458                                  
  8459                                  ;-371 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  8460                                  
  8461 00002D22 C3                       ret
  8462                                  ; ENDP
  8463                                  ;End of archive file. 
  8464                                   
  8465                                  ; missing functions:  All FUNCTIONs in place
  8466 00002D23 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8467 00002D26 58                      pop ax
  8468 00002D27 C3                      ret
  8469                                   
  8470                                  ;   # type sign width line used  address name   list of global variables
  8471                                  
  8472                                  ;    1 arr sign byte     1    2        0 Version1[9]
  8473                                  ;    2 var sign byte     1    3        0 LIST
  8474                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  8475                                  ;    4 arr sign byte     3   11    30000 Symbol[31]
  8476                                  ;    5 arr sign byte     4   36    30031 SymbolUpper[31]
  8477                                  ;    6 var unsg word     5   24        0 SymbolInt
  8478                                  ;    7 var unsg dwrd     6 NULL        0 SymbolLong
  8479                                  ;    8 def unsg byte     7    -        0 INPUTBUFMAX=255
  8480                                  ;    9 arr sign byte     8    4    30062 InputBuf[255]
  8481                                  ;   10 ptr unsg byte     9   24        0 InputPtr
  8482                                  ;   11 arr sign byte    10    5    30317 namein[67]
  8483                                  ;   12 arr sign byte    11    6    30384 namelst[67]
  8484                                  ;   13 arr sign byte    12    6    30451 namebin[67]
  8485                                  ;   14 var sign word    13    4        0 asm_fd
  8486                                  ;   15 var sign word    14    3        0 lst_fd
  8487                                  ;   16 var sign word    15    3        0 bin_fd
  8488                                  ;   17 var sign word    16    6        0 DOS_ERR
  8489                                  ;   18 var sign word    17    4        0 ErrorCount
  8490                                  ;   19 var sign word    18    4        0 DOS_NoBytes
  8491                                  ;   20 var sign byte    19    4        0 DOS_ByteRead
  8492                                  ;   21 var unsg word    21    7        0 PC
  8493                                  ;   22 var unsg word    22    5        0 Origin
  8494                                  ;   23 var unsg word    23    6        0 AbsoluteLab
  8495                                  ;   24 var unsg word    24    2        0 PCStart
  8496                                  ;   25 var sign byte    25    3        0 isLabel
  8497                                  ;   26 def unsg byte    26    -        0 DIGIT=1
  8498                                  ;   27 def unsg byte    27    -        0 LETTERE=2
  8499                                  ;   28 def unsg byte    28    -        0 ALNUME=3
  8500                                  ;   29 def unsg byte    29    -        0 NOALNUME=4
  8501                                  ;   30 var sign byte    30   27        0 TokeType
  8502                                  ;   31 def unsg byte    31    -        0 BYTE=1
  8503                                  ;   32 def unsg byte    32    -        0 WORD=2
  8504                                  ;   33 def unsg byte    33    -        0 DWORD=3
  8505                                  ;   34 def unsg byte    34    -        0 SEGREG=4
  8506                                  ;   35 def unsg byte    35    -        0 IMM=1
  8507                                  ;   36 def unsg byte    36    -        0 REG=2
  8508                                  ;   37 def unsg byte    37    -        0 ADR=3
  8509                                  ;   38 def unsg byte    38    -        0 MEM=4
  8510                                  ;   39 var sign byte    39   28        0 Op
  8511                                  ;   40 var sign byte    40   31        0 Op2
  8512                                  ;   41 var sign byte    41   27        0 CodeType
  8513                                  ;   42 var sign byte    42   23        0 Code1
  8514                                  ;   43 var sign byte    43    7        0 Code2
  8515                                  ;   44 var sign byte    44    3        0 Code3
  8516                                  ;   45 var sign byte    45   19        0 R2No
  8517                                  ;   46 var sign byte    46   16        0 R1No
  8518                                  ;   47 var sign byte    47   18        0 R2Type
  8519                                  ;   48 var sign byte    48   15        0 R1Type
  8520                                  ;   49 var sign byte    49   14        0 OpSize
  8521                                  ;   50 var sign byte    50    9        0 wflag
  8522                                  ;   51 var sign byte    51    3        0 dflag
  8523                                  ;   52 var sign byte    52    8        0 sflag
  8524                                  ;   53 var sign byte    53   15        0 rm
  8525                                  ;   54 var sign byte    54    5        0 isDirect
  8526                                  ;   55 var sign word    55   48        0 disp
  8527                                  ;   56 var unsg word    56   13        0 imme
  8528                                  ;   57 def unsg byte    58    -        0 OPMAXLEN=5
  8529                                  ;   58 arr sign byte    59    2    30518 OpPos[5]
  8530                                  ;   59 var sign word    60    6        0 OpPrintIndex
  8531                                  ;   60 ptr sign byte    61   19        0 OpCodePtr
  8532                                  ;   61 var sign byte    62    4        0 PrintRA
  8533                                  ;   62 def unsg byte    64    -        0 LABELNAMESMAX=3969
  8534                                  ;   63 arr sign byte    65    3    30523 LabelNames[4000]
  8535                                  ;   64 ptr sign byte    66    5        0 LabelNamePtr
  8536                                  ;   65 def unsg byte    67    -        0 LABELADRMAX=600
  8537                                  ;   66 arr unsg word    68    7    34523 LabelAddr[600]
  8538                                  ;   67 var sign word    69    7        0 LabelMaxIx
  8539                                  ;   68 var sign word    70   10        0 LabelIx
  8540                                  ;   69 def unsg byte    72    -        0 JMPCALLNAMESMAX=1969
  8541                                  ;   70 arr sign byte    73    3    35723 JmpCallNames[2000]
  8542                                  ;   71 ptr sign byte    74    5        0 JmpCallNamePtr
  8543                                  ;   72 def unsg byte    75    -        0 JMPCALLMAX=500
  8544                                  ;   73 arr unsg word    76    2    37723 JmpCallAddr[500]
  8545                                  ;   74 var sign word    77    6        0 JmpCallMaxIx
  8546                                  ;   75 def unsg byte    79    -        0 FILEBINMAX=20000
  8547                                  ;   76 arr sign byte    80    4    38723 FileBin[20000]
  8548                                  ;   77 var unsg word    81    6        0 BinLen
  8549                                  ;   78 ptr sign byte    83    1        0 arglen
  8550                                  ;   79 ptr sign byte    84    4        0 argv
  8551                                  ;   80 var sign byte     1    1        0 I_START
  8552                                  ;   81 arr sign byte     4 NULL        0 I_PUSHA[9]
  8553                                  ;   82 arr sign byte     5 NULL        0 I_POPA[8]
  8554                                  ;   83 arr sign byte     6 NULL        0 I_NOP[7]
  8555                                  ;   84 arr sign byte     7 NULL        0 I_CBW[7]
  8556                                  ;   85 arr sign byte     8 NULL        0 I_CWDE[8]
  8557                                  ;   86 arr sign byte     9 NULL        0 I_CWD[7]
  8558                                  ;   87 arr sign byte    10 NULL        0 I_CDQ[7]
  8559                                  ;   88 arr sign byte    11 NULL        0 I_WAIT[8]
  8560                                  ;   89 arr sign byte    12 NULL        0 I_PUSHF[9]
  8561                                  ;   90 arr sign byte    13 NULL        0 I_POPF[8]
  8562                                  ;   91 arr sign byte    14 NULL        0 I_SAHF[8]
  8563                                  ;   92 arr sign byte    15 NULL        0 I_LAHF[8]
  8564                                  ;   93 arr sign byte    16 NULL        0 I_MOVSB[9]
  8565                                  ;   94 arr sign byte    17 NULL        0 I_MOVSW[9]
  8566                                  ;   95 arr sign byte    18 NULL        0 I_CMPSB[9]
  8567                                  ;   96 arr sign byte    19 NULL        0 I_CMPSW[9]
  8568                                  ;   97 arr sign byte    20 NULL        0 I_STOSB[9]
  8569                                  ;   98 arr sign byte    21 NULL        0 I_STOSW[9]
  8570                                  ;   99 arr sign byte    22 NULL        0 I_LODSB[9]
  8571                                  ;  100 arr sign byte    23 NULL        0 I_LODSW[9]
  8572                                  ;  101 arr sign byte    24 NULL        0 I_SCASB[9]
  8573                                  ;  102 arr sign byte    25 NULL        0 I_SCASW[9]
  8574                                  ;  103 arr sign byte    26 NULL        0 I_LEAVE[9]
  8575                                  ;  104 arr sign byte    27 NULL        0 I_INT3[8]
  8576                                  ;  105 arr sign byte    28 NULL        0 I_INTO[8]
  8577                                  ;  106 arr sign byte    29 NULL        0 I_IRET[8]
  8578                                  ;  107 arr sign byte    30 NULL        0 I_XLAT[8]
  8579                                  ;  108 arr sign byte    31 NULL        0 I_LOCK[8]
  8580                                  ;  109 arr sign byte    32 NULL        0 I_REPNE[9]
  8581                                  ;  110 arr sign byte    33 NULL        0 I_REPNZ[9]
  8582                                  ;  111 arr sign byte    34 NULL        0 I_REPE[8]
  8583                                  ;  112 arr sign byte    35 NULL        0 I_REPZ[8]
  8584                                  ;  113 arr sign byte    36 NULL        0 I_HLT[7]
  8585                                  ;  114 arr sign byte    37 NULL        0 I_CLC[7]
  8586                                  ;  115 arr sign byte    38 NULL        0 I_STC[7]
  8587                                  ;  116 arr sign byte    39 NULL        0 I_CLI[7]
  8588                                  ;  117 arr sign byte    40 NULL        0 I_STI[7]
  8589                                  ;  118 arr sign byte    41 NULL        0 I_CLD[7]
  8590                                  ;  119 arr sign byte    42 NULL        0 I_STD[7]
  8591                                  ;  120 arr sign byte    44 NULL        0 I_INC[9]
  8592                                  ;  121 arr sign byte    45 NULL        0 I_DEC[9]
  8593                                  ;  122 arr sign byte    46 NULL        0 I_NOT[8]
  8594                                  ;  123 arr sign byte    47 NULL        0 I_NEG[8]
  8595                                  ;  124 arr sign byte    48 NULL        0 I_MUL[8]
  8596                                  ;  125 arr sign byte    49 NULL        0 I_IMUL[9]
  8597                                  ;  126 arr sign byte    50 NULL        0 I_DIV[8]
  8598                                  ;  127 arr sign byte    51 NULL        0 I_IDIV[9]
  8599                                  ;  128 arr sign byte    53 NULL        0 I_LES[7]
  8600                                  ;  129 arr sign byte    54 NULL        0 I_LDS[7]
  8601                                  ;  130 arr sign byte    55 NULL        0 I_LEA[7]
  8602                                  ;  131 arr sign byte    56 NULL        0 I_LSS[8]
  8603                                  ;  132 arr sign byte    57 NULL        0 I_LFS[8]
  8604                                  ;  133 arr sign byte    58 NULL        0 I_LGS[8]
  8605                                  ;  134 arr sign byte    60 NULL        0 I_ADD[7]
  8606                                  ;  135 arr sign byte    61 NULL        0 I_OR[6]
  8607                                  ;  136 arr sign byte    62 NULL        0 I_ADC[7]
  8608                                  ;  137 arr sign byte    63 NULL        0 I_SBB[7]
  8609                                  ;  138 arr sign byte    64 NULL        0 I_AND[7]
  8610                                  ;  139 arr sign byte    65 NULL        0 I_SUB[7]
  8611                                  ;  140 arr sign byte    66 NULL        0 I_XOR[7]
  8612                                  ;  141 arr sign byte    67 NULL        0 I_CMP[7]
  8613                                  ;  142 arr sign byte    68 NULL        0 I_TEST[11]
  8614                                  ;  143 arr sign byte    70 NULL        0 I_MOV[6]
  8615                                  ;  144 arr sign byte    71 NULL        0 I_MOVSX[9]
  8616                                  ;  145 arr sign byte    72 NULL        0 I_MOVZX[9]
  8617                                  ;  146 arr sign byte    74 NULL        0 I_JO[6]
  8618                                  ;  147 arr sign byte    75 NULL        0 I_JNO[7]
  8619                                  ;  148 arr sign byte    76 NULL        0 I_JB[6]
  8620                                  ;  149 arr sign byte    77 NULL        0 I_JC[6]
  8621                                  ;  150 arr sign byte    78 NULL        0 I_JNB[7]
  8622                                  ;  151 arr sign byte    79 NULL        0 I_JAE[7]
  8623                                  ;  152 arr sign byte    80 NULL        0 I_JNC[7]
  8624                                  ;  153 arr sign byte    81 NULL        0 I_JE[6]
  8625                                  ;  154 arr sign byte    82 NULL        0 I_JZ[6]
  8626                                  ;  155 arr sign byte    83 NULL        0 I_JNE[7]
  8627                                  ;  156 arr sign byte    84 NULL        0 I_JNZ[7]
  8628                                  ;  157 arr sign byte    85 NULL        0 I_JBE[7]
  8629                                  ;  158 arr sign byte    86 NULL        0 I_JNA[7]
  8630                                  ;  159 arr sign byte    87 NULL        0 I_JA[6]
  8631                                  ;  160 arr sign byte    88 NULL        0 I_JS[6]
  8632                                  ;  161 arr sign byte    89 NULL        0 I_JNS[7]
  8633                                  ;  162 arr sign byte    90 NULL        0 I_JP[6]
  8634                                  ;  163 arr sign byte    91 NULL        0 I_JPE[7]
  8635                                  ;  164 arr sign byte    92 NULL        0 I_JNP[7]
  8636                                  ;  165 arr sign byte    93 NULL        0 I_JPO[7]
  8637                                  ;  166 arr sign byte    94 NULL        0 I_JL[6]
  8638                                  ;  167 arr sign byte    95 NULL        0 I_JNL[7]
  8639                                  ;  168 arr sign byte    96 NULL        0 I_JGE[7]
  8640                                  ;  169 arr sign byte    97 NULL        0 I_JLE[7]
  8641                                  ;  170 arr sign byte    98 NULL        0 I_JNG[7]
  8642                                  ;  171 arr sign byte    99 NULL        0 I_JG[6]
  8643                                  ;  172 arr sign byte   101 NULL        0 I_JMP[8]
  8644                                  ;  173 arr sign byte   102 NULL        0 I_CALL[9]
  8645                                  ;  174 arr sign byte   104 NULL        0 I_RET[8]
  8646                                  ;  175 arr sign byte   105 NULL        0 I_RETF[9]
  8647                                  ;  176 arr sign byte   107 NULL        0 I_PUSH[11]
  8648                                  ;  177 arr sign byte   108 NULL        0 I_POP[10]
  8649                                  ;  178 arr sign byte   110 NULL        0 I_ROL[7]
  8650                                  ;  179 arr sign byte   111 NULL        0 I_ROR[7]
  8651                                  ;  180 arr sign byte   112 NULL        0 I_RCL[7]
  8652                                  ;  181 arr sign byte   113 NULL        0 I_RCR[7]
  8653                                  ;  182 arr sign byte   114 NULL        0 I_SHL[7]
  8654                                  ;  183 arr sign byte   115 NULL        0 I_SAL[7]
  8655                                  ;  184 arr sign byte   116 NULL        0 I_SHR[7]
  8656                                  ;  185 arr sign byte   117 NULL        0 I_SAR[7]
  8657                                  ;  186 arr sign byte   119 NULL        0 I_INT[8]
  8658                                  ;  187 arr sign byte   121 NULL        0 I_IN[7]
  8659                                  ;  188 arr sign byte   122 NULL        0 I_INSB[8]
  8660                                  ;  189 arr sign byte   123 NULL        0 I_INSW[8]
  8661                                  ;  190 arr sign byte   124 NULL        0 I_INSD[8]
  8662                                  ;  191 arr sign byte   125 NULL        0 I_OUT[8]
  8663                                  ;  192 arr sign byte   126 NULL        0 I_OUTSB[8]
  8664                                  ;  193 arr sign byte   127 NULL        0 I_OUTSW[8]
  8665                                  ;  194 arr sign byte   128 NULL        0 I_OUTSD[8]
  8666                                  ;  195 arr sign byte   130 NULL        0 I_XCHG[9]
  8667                                  ;  196 arr sign byte   132 NULL        0 I_LOOPNZ[10]
  8668                                  ;  197 arr sign byte   133 NULL        0 I_LOOPNE[10]
  8669                                  ;  198 arr sign byte   134 NULL        0 I_LOOPZ[9]
  8670                                  ;  199 arr sign byte   135 NULL        0 I_LOOPE[9]
  8671                                  ;  200 arr sign byte   136 NULL        0 I_LOOP[8]
  8672                                  ;  201 arr sign byte   137 NULL        0 I_JCXZ[8]
  8673                                  ;  202 arr sign byte   138 NULL        0 I_JECXZ[9]
  8674                                  ;  203 arr sign byte   140 NULL        0 I_ENTER[8]
  8675                                  ;  204 arr sign byte   142 NULL        0 I_ORG[6]
  8676                                  ;  205 arr sign byte   144 NULL        0 I_SECTION[10]
  8677                                  ;  206 arr sign byte   145 NULL        0 I_SEGMENT[10]
  8678                                  ;  207 arr sign byte   146 NULL        0 I_ABSOLUTE[11]
  8679                                  ;  208 arr sign byte   147 NULL        0 I_DB[5]
  8680                                  ;  209 arr sign byte   148 NULL        0 I_DW[5]
  8681                                  ;  210 arr sign byte   149 NULL        0 I_DD[5]
  8682                                  ;  211 arr sign byte   150 NULL        0 I_RESB[7]
  8683                                  ;  212 arr sign byte   151 NULL        0 I_RESW[7]
  8684                                  ;  213 arr sign byte   152 NULL        0 I_RESD[7]
  8685                                  ;  214 var sign byte   153 NULL        0 I_END
  8686                                  
  8687                                  
  8688                                  ;   # Calls Line Width  Name   list of functions
  8689                                  
  8690                                  ;    0    2    1 word   ChangeDirection
  8691                                  ;    1    2    9 word   checkOpL
  8692                                  ;    2    4   18 word   check2Ops
  8693                                  ;    3    1   27 word   get2Ops
  8694                                  ;    4    3   33 word   getOpL
  8695                                  ;    5    2   41 word   getOpR
  8696                                  ;    6    4   51 word   getOp1
  8697                                  ;    7    1   67 word   getMEM
  8698                                  ;    8    1   90 word   getIndReg1
  8699                                  ;    9    1   98 word   getIndReg2
  8700                                  ;   10    2  108 word   setwflag
  8701                                  ;   11    2  119 word   setsflag
  8702                                  ;   12    2  129 word   checkConstSize
  8703                                  ;   13    1    1 word   parse
  8704                                  ;   14   16   35 word   getTokeType
  8705                                  ;   15    2   46 word   storeJmpCall
  8706                                  ;   16    2   57 word   storeLabel
  8707                                  ;   17    5   69 word   searchLabel
  8708                                  ;   18    1   82 word   getVariable
  8709                                  ;   19    2  135 word   lookCode
  8710                                  ;   20    1  151 word   getCodeSize
  8711                                  ;   21    9  159 word   isToken
  8712                                  ;   22    2  167 word   need
  8713                                  ;   23    1  176 word   skipRest
  8714                                  ;   24    1    1 word   getLine
  8715                                  ;   25    1   17 word   ifEOL
  8716                                  ;   26    3   24 word   skipBlank
  8717                                  ;   27    2   29 word   letterE
  8718                                  ;   28    1   39 word   alnumE
  8719                                  ;   29    1   44 word   getDigit
  8720                                  ;   30    1   56 word   getName
  8721                                  ;   31    1   75 word   testReg
  8722                                  ;   32    1    1 word   printLine
  8723                                  ;   33    7   23 word   prc
  8724                                  ;   34    1   35 word   prscomment
  8725                                  ;   35   28   43 word   prs
  8726                                  ;   36    3   65 word   printhex8a
  8727                                  ;   37    2   70 word   printhex4
  8728                                  ;   38    1   75 word   printhex16
  8729                                  ;   39    5   80 word   printIntU
  8730                                  ;   40   26   91 word   error1
  8731                                  ;   41   12   99 word   errorexit
  8732                                  ;   42 NULL  103 word   allowederror
  8733                                  ;   43    3  104 word   addrerror
  8734                                  ;   44    1  105 word   immeerror
  8735                                  ;   45    2  106 word   implerror
  8736                                  ;   46    4  107 word   indexerror
  8737                                  ;   47    3  108 word   invaloperror
  8738                                  ;   48    6  109 word   numbererror
  8739                                  ;   49    1  110 word   regmemerror
  8740                                  ;   50    3  111 word   reg16error
  8741                                  ;   51    1  112 word   segregerror
  8742                                  ;   52    5  113 word   syntaxerror
  8743                                  ;   53 NULL  115 word   addrexit
  8744                                  ;   54    3  116 word   dataexit
  8745                                  ;   55 NULL  117 word   internexit
  8746                                  ;   56 NULL    1 word   main
  8747                                  ;   57    1    9 word   getarg
  8748                                  ;   58    1   43 word   fixJmpCall
  8749                                  ;   59    1   74 word   epilog
  8750                                  ;   60    2  117 word   end1
  8751                                  ;   61    1    2 word   getCodes
  8752                                  ;   62    1    7 word   gen66h
  8753                                  ;   63    8    9 word   genCode2
  8754                                  ;   64   13   13 word   genCodeW
  8755                                  ;   65   33   17 word   genCode8
  8756                                  ;   66   17   28 word   genCode16
  8757                                  ;   67    1   32 word   genCode32
  8758                                  ;   68   13   36 word   writeEA
  8759                                  ;   69    4   78 word   genImmediate
  8760                                  ;   70    1   11 word   process
  8761                                  ;   71    4  349 word   writetty
  8762                                  ;   72    8  350 word   cputs
  8763                                  ;   73    2  351 word   toupper
  8764                                  ;   74    4  353 word   strlen
  8765                                  ;   75    8  354 word   strcpy
  8766                                  ;   76    3  356 word   digit
  8767                                  ;   77   35  357 word   eqstr
  8768                                  ;   78    3  360 word   strcat1
  8769                                  ;   79    1  361 word   openR
  8770                                  ;   80    2  362 word   creatR
  8771                                  ;   81    2  363 word   readRL
  8772                                  ;   82    2  364 word   fputcR
  8773                                  ;   83    3  366 word   fcloseR
  8774                                  ;   84    5  367 word   exitR
  8775                                  ;   85    1  369 word   putch
  8776                                  ;   86    4  370 word   DosInt
  8777                                  ;   87 NULL  371 word   LastFunctionByt
  8778                                  
  8779                                  ;    #  addr name   list of CALLs
  8780                                  
  8781                                  ;    0  1565 implerror
  8782                                  ;    1  1575 segregerror
  8783                                  ;    2  1587 setwflag
  8784                                  ;    3  1596 error1
  8785                                  ;    4  1603 error1
  8786                                  ;    5  1620 get2Ops
  8787                                  ;    6  1628 addrerror
  8788                                  ;    7  1638 invaloperror
  8789                                  ;    8  1651 immeerror
  8790                                  ;    9  1661 addrerror
  8791                                  ;   10  1671 invaloperror
  8792                                  ;   11  1684 setwflag
  8793                                  ;   12  1701 getOpL
  8794                                  ;   13  1708 need
  8795                                  ;   14  1713 getOpR
  8796                                  ;   15  1727 getOpR
  8797                                  ;   16  1741 getOp1
  8798                                  ;   17  1748 isToken
  8799                                  ;   18  1756 getMEM
  8800                                  ;   19  1763 invaloperror
  8801                                  ;   20  1776 error1
  8802                                  ;   21  1790 testReg
  8803                                  ;   22  1798 searchLabel
  8804                                  ;   23  1810 error1
  8805                                  ;   24  1826 getTokeType
  8806                                  ;   25  1838 getOp1
  8807                                  ;   26  1845 syntaxerror
  8808                                  ;   27  1857 getIndReg2
  8809                                  ;   28  1868 getIndReg1
  8810                                  ;   29  1879 isToken
  8811                                  ;   30  1887 getTokeType
  8812                                  ;   31  1899 numbererror
  8813                                  ;   32  1911 isToken
  8814                                  ;   33  1919 isToken
  8815                                  ;   34  1927 errorexit
  8816                                  ;   35  1948 indexerror
  8817                                  ;   36  1959 indexerror
  8818                                  ;   37  1983 indexerror
  8819                                  ;   38  1994 indexerror
  8820                                  ;   39  2014 gen66h
  8821                                  ;   40  2033 error1
  8822                                  ;   41  2064 getLine
  8823                                  ;   42  2072 getTokeType
  8824                                  ;   43  2084 storeLabel
  8825                                  ;   44  2095 getTokeType
  8826                                  ;   45  2107 lookCode
  8827                                  ;   46  2116 process
  8828                                  ;   47  2124 getVariable
  8829                                  ;   48  2136 skipRest
  8830                                  ;   49  2145 error1
  8831                                  ;   50  2152 error1
  8832                                  ;   51  2159 printLine
  8833                                  ;   52  2183 skipBlank
  8834                                  ;   53  2193 digit
  8835                                  ;   54  2199 getDigit
  8836                                  ;   55  2208 letterE
  8837                                  ;   56  2216 getName
  8838                                  ;   57  2239 errorexit
  8839                                  ;   58  2249 strcpy
  8840                                  ;   59  2256 errorexit
  8841                                  ;   60  2279 errorexit
  8842                                  ;   61  2289 searchLabel
  8843                                  ;   62  2301 error1
  8844                                  ;   63  2308 strcpy
  8845                                  ;   64  2315 errorexit
  8846                                  ;   65  2343 eqstr
  8847                                  ;   66  2349 strlen
  8848                                  ;   67  2370 storeLabel
  8849                                  ;   68  2381 getTokeType
  8850                                  ;   69  2393 lookCode
  8851                                  ;   70  2402 dataexit
  8852                                  ;   71  2411 dataexit
  8853                                  ;   72  2420 getTokeType
  8854                                  ;   73  2432 genCode8
  8855                                  ;   74  2441 skipBlank
  8856                                  ;   75  2451 isToken
  8857                                  ;   76  2459 genCode8
  8858                                  ;   77  2468 isToken
  8859                                  ;   78  2476 getTokeType
  8860                                  ;   79  2488 genCode16
  8861                                  ;   80  2498 isToken
  8862                                  ;   81  2506 getTokeType
  8863                                  ;   82  2518 genCode16
  8864                                  ;   83  2528 genCode16
  8865                                  ;   84  2538 isToken
  8866                                  ;   85  2546 getTokeType
  8867                                  ;   86  2558 syntaxerror
  8868                                  ;   87  2570 error1
  8869                                  ;   88  2577 numbererror
  8870                                  ;   89  2589 dataexit
  8871                                  ;   90  2607 eqstr
  8872                                  ;   91  2625 eqstr
  8873                                  ;   92  2631 getTokeType
  8874                                  ;   93  2643 eqstr
  8875                                  ;   94  2649 getTokeType
  8876                                  ;   95  2661 eqstr
  8877                                  ;   96  2667 getTokeType
  8878                                  ;   97  2689 skipBlank
  8879                                  ;   98  2706 isToken
  8880                                  ;   99  2714 getTokeType
  8881                                  ;  100  2726 error1
  8882                                  ;  101  2733 prs
  8883                                  ;  102  2737 prc
  8884                                  ;  103  2750 getTokeType
  8885                                  ;  104  2762 error1
  8886                                  ;  105  2779 readRL
  8887                                  ;  106  2786 errorexit
  8888                                  ;  107  2796 errorexit
  8889                                  ;  108  2806 ifEOL
  8890                                  ;  109  2820 readRL
  8891                                  ;  110  2856 digit
  8892                                  ;  111  2862 letterE
  8893                                  ;  112  2889 digit
  8894                                  ;  113  2909 alnumE
  8895                                  ;  114  2916 errorexit
  8896                                  ;  115  2926 strcpy
  8897                                  ;  116  2933 toupper
  8898                                  ;  117  2949 strlen
  8899                                  ;  118  2956 strlen
  8900                                  ;  119  2963 eqstr
  8901                                  ;  120  2969 eqstr
  8902                                  ;  121  2975 eqstr
  8903                                  ;  122  2981 eqstr
  8904                                  ;  123  2987 eqstr
  8905                                  ;  124  2993 eqstr
  8906                                  ;  125  2999 eqstr
  8907                                  ;  126  3005 eqstr
  8908                                  ;  127  3011 eqstr
  8909                                  ;  128  3017 eqstr
  8910                                  ;  129  3023 eqstr
  8911                                  ;  130  3029 eqstr
  8912                                  ;  131  3035 eqstr
  8913                                  ;  132  3041 eqstr
  8914                                  ;  133  3047 eqstr
  8915                                  ;  134  3053 eqstr
  8916                                  ;  135  3059 eqstr
  8917                                  ;  136  3065 eqstr
  8918                                  ;  137  3071 eqstr
  8919                                  ;  138  3077 eqstr
  8920                                  ;  139  3083 eqstr
  8921                                  ;  140  3089 eqstr
  8922                                  ;  141  3095 eqstr
  8923                                  ;  142  3101 eqstr
  8924                                  ;  143  3107 eqstr
  8925                                  ;  144  3113 eqstr
  8926                                  ;  145  3119 eqstr
  8927                                  ;  146  3125 eqstr
  8928                                  ;  147  3131 eqstr
  8929                                  ;  148  3137 eqstr
  8930                                  ;  149  3157 prs
  8931                                  ;  150  3161 printhex16
  8932                                  ;  151  3172 prs
  8933                                  ;  152  3176 prc
  8934                                  ;  153  3180 printhex8a
  8935                                  ;  154  3191 prs
  8936                                  ;  155  3195 prc
  8937                                  ;  156  3199 prscomment
  8938                                  ;  157  3216 writetty
  8939                                  ;  158  3225 writetty
  8940                                  ;  159  3234 fputcR
  8941                                  ;  160  3256 prc
  8942                                  ;  161  3272 prc
  8943                                  ;  162  3293 printhex4
  8944                                  ;  163  3303 printhex4
  8945                                  ;  164  3325 prc
  8946                                  ;  165  3347 printhex8a
  8947                                  ;  166  3358 printhex8a
  8948                                  ;  167  3383 printIntU
  8949                                  ;  168  3393 prc
  8950                                  ;  169  3406 prs
  8951                                  ;  170  3410 prs
  8952                                  ;  171  3414 prs
  8953                                  ;  172  3418 prs
  8954                                  ;  173  3434 error1
  8955                                  ;  174  3441 end1
  8956                                  ;  175  3459 error1
  8957                                  ;  176  3476 error1
  8958                                  ;  177  3493 error1
  8959                                  ;  178  3510 error1
  8960                                  ;  179  3528 error1
  8961                                  ;  180  3548 error1
  8962                                  ;  181  3567 error1
  8963                                  ;  182  3586 error1
  8964                                  ;  183  3604 error1
  8965                                  ;  184  3623 error1
  8966                                  ;  185  3642 error1
  8967                                  ;  186  3658 errorexit
  8968                                  ;  187  3677 errorexit
  8969                                  ;  188  3698 errorexit
  8970                                  ;  189  3713 getarg
  8971                                  ;  190  3720 parse
  8972                                  ;  191  3726 fixJmpCall
  8973                                  ;  192  3737 epilog
  8974                                  ;  193  3744 end1
  8975                                  ;  194  3768 cputs
  8976                                  ;  195  3774 cputs
  8977                                  ;  196  3780 exitR
  8978                                  ;  197  3786 toupper
  8979                                  ;  198  3794 strcpy
  8980                                  ;  199  3801 strcat1
  8981                                  ;  200  3809 strcpy
  8982                                  ;  201  3816 strcat1
  8983                                  ;  202  3824 strcpy
  8984                                  ;  203  3831 strcat1
  8985                                  ;  204  3839 openR
  8986                                  ;  205  3845 cputs
  8987                                  ;  206  3851 cputs
  8988                                  ;  207  3857 exitR
  8989                                  ;  208  3863 creatR
  8990                                  ;  209  3870 cputs
  8991                                  ;  210  3876 cputs
  8992                                  ;  211  3882 exitR
  8993                                  ;  212  3888 creatR
  8994                                  ;  213  3895 cputs
  8995                                  ;  214  3901 cputs
  8996                                  ;  215  3907 exitR
  8997                                  ;  216  3913 prs
  8998                                  ;  217  3917 prs
  8999                                  ;  218  3921 prs
  9000                                  ;  219  3925 prs
  9001                                  ;  220  3929 prs
  9002                                  ;  221  3933 prs
  9003                                  ;  222  3937 prs
  9004                                  ;  223  3941 prs
  9005                                  ;  224  3945 prs
  9006                                  ;  225  3973 prs
  9007                                  ;  226  3977 printIntU
  9008                                  ;  227  3987 strcpy
  9009                                  ;  228  3994 strlen
  9010                                  ;  229  4001 searchLabel
  9011                                  ;  230  4013 error1
  9012                                  ;  231  4033 prs
  9013                                  ;  232  4037 printIntU
  9014                                  ;  233  4047 prs
  9015                                  ;  234  4051 prs
  9016                                  ;  235  4055 prs
  9017                                  ;  236  4059 prs
  9018                                  ;  237  4063 prs
  9019                                  ;  238  4067 prs
  9020                                  ;  239  4071 printIntU
  9021                                  ;  240  4081 prs
  9022                                  ;  241  4085 fputcR
  9023                                  ;  242  4092 prs
  9024                                  ;  243  4096 printIntU
  9025                                  ;  244  4106 prs
  9026                                  ;  245  4117 fcloseR
  9027                                  ;  246  4125 fcloseR
  9028                                  ;  247  4133 fcloseR
  9029                                  ;  248  4141 exitR
  9030                                  ;  249  4163 genCode8
  9031                                  ;  250  4185 genCode8
  9032                                  ;  251  4205 genCode8
  9033                                  ;  252  4225 errorexit
  9034                                  ;  253  4247 genCode8
  9035                                  ;  254  4256 genCode8
  9036                                  ;  255  4277 genCode16
  9037                                  ;  256  4287 genCode16
  9038                                  ;  257  4313 genCode8
  9039                                  ;  258  4322 genCode8
  9040                                  ;  259  4331 genCode16
  9041                                  ;  260  4354 genCode32
  9042                                  ;  261  4364 genCode16
  9043                                  ;  262  4374 genCode8
  9044                                  ;  263  4393 getTokeType
  9045                                  ;  264  4405 getCodeSize
  9046                                  ;  265  4417 getCodes
  9047                                  ;  266  4426 genCode8
  9048                                  ;  267  4435 getOpL
  9049                                  ;  268  4442 checkOpL
  9050                                  ;  269  4451 genCode2
  9051                                  ;  270  4460 getTokeType
  9052                                  ;  271  4472 implerror
  9053                                  ;  272  4482 genCodeW
  9054                                  ;  273  4491 writeEA
  9055                                  ;  274  4499 check2Ops
  9056                                  ;  275  4509 reg16error
  9057                                  ;  276  4520 addrerror
  9058                                  ;  277  4530 genCode8
  9059                                  ;  278  4539 genCode8
  9060                                  ;  279  4548 writeEA
  9061                                  ;  280  4556 check2Ops
  9062                                  ;  281  4566 setsflag
  9063                                  ;  282  4575 genCodeW
  9064                                  ;  283  4584 genImmediate
  9065                                  ;  284  4597 genCodeW
  9066                                  ;  285  4606 writeEA
  9067                                  ;  286  4614 genCode8
  9068                                  ;  287  4623 genImmediate
  9069                                  ;  288  4636 genCodeW
  9070                                  ;  289  4645 writeEA
  9071                                  ;  290  4653 genCodeW
  9072                                  ;  291  4662 writeEA
  9073                                  ;  292  4670 syntaxerror
  9074                                  ;  293  4682 check2Ops
  9075                                  ;  294  4692 genCode2
  9076                                  ;  295  4701 genImmediate
  9077                                  ;  296  4714 genCodeW
  9078                                  ;  297  4723 writeEA
  9079                                  ;  298  4731 genImmediate
  9080                                  ;  299  4744 regmemerror
  9081                                  ;  300  4756 ChangeDirection
  9082                                  ;  301  4772 reg16error
  9083                                  ;  302  4783 genCode2
  9084                                  ;  303  4792 writeEA
  9085                                  ;  304  4800 genCodeW
  9086                                  ;  305  4809 genCode16
  9087                                  ;  306  4819 genCodeW
  9088                                  ;  307  4828 genCode16
  9089                                  ;  308  4838 genCodeW
  9090                                  ;  309  4847 writeEA
  9091                                  ;  310  4855 ChangeDirection
  9092                                  ;  311  4871 genCodeW
  9093                                  ;  312  4880 writeEA
  9094                                  ;  313  4888 syntaxerror
  9095                                  ;  314  4900 searchLabel
  9096                                  ;  315  4912 checkConstSize
  9097                                  ;  316  4927 genCode2
  9098                                  ;  317  4936 genCode8
  9099                                  ;  318  4945 genCode8
  9100                                  ;  319  4954 genCode2
  9101                                  ;  320  4963 genCode16
  9102                                  ;  321  4973 genCode8
  9103                                  ;  322  4982 genCode2
  9104                                  ;  323  4991 genCode16
  9105                                  ;  324  5001 storeJmpCall
  9106                                  ;  325  5014 searchLabel
  9107                                  ;  326  5026 checkConstSize
  9108                                  ;  327  5041 genCode8
  9109                                  ;  328  5050 genCode8
  9110                                  ;  329  5059 genCode8
  9111                                  ;  330  5068 genCode16
  9112                                  ;  331  5078 genCode8
  9113                                  ;  332  5087 genCode16
  9114                                  ;  333  5097 genCode8
  9115                                  ;  334  5106 genCode16
  9116                                  ;  335  5116 storeJmpCall
  9117                                  ;  336  5129 genCode8
  9118                                  ;  337  5138 genCode16
  9119                                  ;  338  5148 genCode8
  9120                                  ;  339  5157 getOpL
  9121                                  ;  340  5164 setsflag
  9122                                  ;  341  5173 genCode2
  9123                                  ;  342  5182 genCode8
  9124                                  ;  343  5191 genCode16
  9125                                  ;  344  5201 error1
  9126                                  ;  345  5208 genCode8
  9127                                  ;  346  5217 genCode8
  9128                                  ;  347  5226 checkOpL
  9129                                  ;  348  5235 reg16error
  9130                                  ;  349  5246 genCode2
  9131                                  ;  350  5255 genCode8
  9132                                  ;  351  5264 writeEA
  9133                                  ;  352  5272 syntaxerror
  9134                                  ;  353  5284 check2Ops
  9135                                  ;  354  5294 genCodeW
  9136                                  ;  355  5303 writeEA
  9137                                  ;  356  5311 genCodeW
  9138                                  ;  357  5320 writeEA
  9139                                  ;  358  5328 genCode8
  9140                                  ;  359  5337 genCodeW
  9141                                  ;  360  5346 writeEA
  9142                                  ;  361  5354 genCode8
  9143                                  ;  362  5363 genCode8
  9144                                  ;  363  5372 genCode8
  9145                                  ;  364  5381 getOp1
  9146                                  ;  365  5388 genCode16
  9147                                  ;  366  5398 numbererror
  9148                                  ;  367  5410 need
  9149                                  ;  368  5415 getOp1
  9150                                  ;  369  5422 genCode8
  9151                                  ;  370  5431 numbererror
  9152                                  ;  371  5443 numbererror
  9153                                  ;  372  5455 numbererror
  9154                                  ;  373  5467 error1
  9155                                  ;  374  5493 putch
  9156                                  ;  375  5561 strcpy
  9157                                  ;  376  5576 DosInt
  9158                                  ;  377  5592 DosInt
  9159                                  ;  378  5615 DosInt
  9160                                  ;  379  5634 DosInt
  9161                                  ;  380  5668 writetty
  9162                                  ;  381  5677 writetty
  9163                                  ;Input: AS.C, List: AS.S,  Lines:  372
  9164                                  ;Glob. variables:  214 max.:  250
  9165                                  ;Local variables:    5 max.:   50, in 'fixJmpCall'
  9166                                  ;Functions      :   88 max.:  300
  9167                                  ;Calls          :  382 max.: 2000, NameField: 5709 max.:    65535
  9168                                  ;Code until     :24528 max.: 30000, free: 5472
  9169                                  ;Data (HeapEnd) :58723, resting stacksize:  6812
  9170                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
