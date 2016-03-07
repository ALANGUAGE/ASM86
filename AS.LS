     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E94628                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07",0
    10 0000000C 3700               
    11                                  
    12                                  ;-2 #include "DECL.C"
    13                                  
    14                                  ;Use include file: DECL.C
    15                                  
    16                                  ;-1 char LIST;              //listing on/off     
    17                                  
    18 0000000E 00                      LIST db 0
    19                                  
    20                                  ;-2 #define SYMBOLMAX    31
    21                                  
    22                                  
    23                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    24                                  
    25 0000000F <res 0000001F>          Symbol resb 31
    26                                  
    27                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    28                                  
    29 0000002E <res 0000001F>          SymbolUpper resb 31
    30                                  
    31                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    32                                  
    33 0000004D 0000                    SymbolInt dw 0
    34                                  
    35                                  ;-6 #define INPUTBUFMAX 127
    36                                  
    37                                  
    38                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    39                                  
    40 0000004F <res 0000007F>          InputBuf resb 127
    41                                  
    42                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    43                                  
    44 000000CE 0000                    InputPtr dw 0
    45                                  
    46                                  ;-9 char namein [67];       //input file name  .S
    47                                  
    48 000000D0 <res 00000043>          namein resb 67
    49                                  
    50                                  ;-10 char namelst[67];       //list file name   .LST
    51                                  
    52 00000113 <res 00000043>          namelst resb 67
    53                                  
    54                                  ;-11 char namebin[67];       //output file name .COM
    55                                  
    56 00000156 <res 00000043>          namebin resb 67
    57                                  
    58                                  ;-12 int  asm_fd;            //input file descriptor
    59                                  
    60 00000199 0000                    asm_fd dw 0
    61                                  
    62                                  ;-13 int lst_fd;             //list file descriptor
    63                                  
    64 0000019B 0000                    lst_fd dw 0
    65                                  
    66                                  ;-14 int bin_fd;             //output file descriptor
    67                                  
    68 0000019D 0000                    bin_fd dw 0
    69                                  
    70                                  ;-15 int DOS_ERR;            //global var
    71                                  
    72 0000019F 0000                    DOS_ERR dw 0
    73                                  
    74                                  ;-16 int ErrorCount;         //number of errors
    75                                  
    76 000001A1 0000                    ErrorCount dw 0
    77                                  
    78                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    79                                  
    80 000001A3 0000                    DOS_NoBytes dw 0
    81                                  
    82                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    83                                  
    84 000001A5 00                      DOS_ByteRead db 0
    85                                  
    86                                  ;-19 
    87                                  
    88                                  
    89                                  ;-20 unsigned int PC;        //program counter, ORG nn
    90                                  
    91 000001A6 0000                    PC dw 0
    92                                  
    93                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
    94                                  
    95 000001A8 0000                    PCStart dw 0
    96                                  
    97                                  ;-22 char isLabel;           //by getName()
    98                                  
    99 000001AA 00                      isLabel db 0
   100                                  
   101                                  ;-23 #define DIGIT    1      //0-9
   102                                  
   103                                  
   104                                  ;-24 #define LETTERE  2      //a-z A-Z @ . _
   105                                  
   106                                  
   107                                  ;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9
   108                                  
   109                                  
   110                                  ;-26 #define NOALNUME 4      //other char
   111                                  
   112                                  
   113                                  ;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   114                                  
   115 000001AB 00                      TokeType db 0
   116                                  
   117                                  ;-28 #define BYTE     1
   118                                  
   119                                  
   120                                  ;-29 #define WORD     2
   121                                  
   122                                  
   123                                  ;-30 #define DWORD    3
   124                                  
   125                                  
   126                                  ;-31 #define SEGREG   4
   127                                  
   128                                  
   129                                  ;-32 #define IMM      1      //const  ,123
   130                                  
   131                                  
   132                                  ;-33 #define REG      2      //       ,BX    mode=11
   133                                  
   134                                  
   135                                  ;-34 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   136                                  
   137                                  
   138                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   139                                  
   140                                  
   141                                  ;-36 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   142                                  
   143 000001AC 00                      Op db 0
   144                                  
   145                                  ;-37 char Op2;               //2. operand
   146                                  
   147 000001AD 00                      Op2 db 0
   148                                  
   149                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   150                                  
   151 000001AE 00                      CodeType db 0
   152                                  
   153                                  ;-39 char Code1;             //1. Opcode
   154                                  
   155 000001AF 00                      Code1 db 0
   156                                  
   157                                  ;-40 char Code2;             //2. Opcode
   158                                  
   159 000001B0 00                      Code2 db 0
   160                                  
   161                                  ;-41 char Code3;             //3. Opcode
   162                                  
   163 000001B1 00                      Code3 db 0
   164                                  
   165                                  ;-42 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   166                                  
   167 000001B2 00                      R2No db 0
   168                                  
   169                                  ;-43 char R1No;              //temp for 1. register
   170                                  
   171 000001B3 00                      R1No db 0
   172                                  
   173                                  ;-44 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   174                                  
   175 000001B4 00                      R2Type db 0
   176                                  
   177                                  ;-45 char R1Type;            //temp for 1. register 
   178                                  
   179 000001B5 00                      R1Type db 0
   180                                  
   181                                  ;-46 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   182                                  
   183 000001B6 00                      OpSize db 0
   184                                  
   185                                  ;-47 char wflag;             //wordflag: 0=byte, 1=word/dword
   186                                  
   187 000001B7 00                      wflag db 0
   188                                  
   189                                  ;-48 char dflag;             //directionflag: 1=to reg MOV,ALU    
   190                                  
   191 000001B8 00                      dflag db 0
   192                                  
   193                                  ;-49 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   194                                  
   195 000001B9 00                      sflag db 0
   196                                  
   197                                  ;-50 char rm;                //combination of index and base reg
   198                                  
   199 000001BA 00                      rm db 0
   200                                  
   201                                  ;-51 char isDirect;          //set in getOpL and getMeM, need in WriteEA
   202                                  
   203 000001BB 00                      isDirect db 0
   204                                  
   205                                  ;-52 int disp;               //displacement      0-8 bytes
   206                                  
   207 000001BC 0000                    disp dw 0
   208                                  
   209                                  ;-53 unsigned int imme;      //immediate         0-8 bytes
   210                                  
   211 000001BE 0000                    imme dw 0
   212                                  
   213                                  ;-54 
   214                                  
   215                                  
   216                                  ;-55 #define OPMAXLEN 5
   217                                  
   218                                  
   219                                  ;-56 char OpPos[OPMAXLEN];   //array for one opcode to list
   220                                  
   221 000001C0 <res 00000005>          OpPos resb 5
   222                                  
   223                                  ;-57 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   224                                  
   225 000001C5 0000                    OpPrintIndex dw 0
   226                                  
   227                                  ;-58 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   228                                  
   229 000001C7 0000                    OpCodePtr dw 0
   230                                  
   231                                  ;-59 char PrintR;            //print 'R' if relocative
   232                                  
   233 000001C9 00                      PrintR db 0
   234                                  
   235                                  ;-60 
   236                                  
   237                                  
   238                                  ;-61 #define LABELNAMESMAX 969//next number - 31
   239                                  
   240                                  
   241                                  ;-62 char LabelNames[1000];  //space for names of all labels
   242                                  
   243 000001CA <res 000003E8>          LabelNames resb 1000
   244                                  
   245                                  ;-63 char *LabelNamePtr;     // first free position
   246                                  
   247 000005B2 0000                    LabelNamePtr dw 0
   248                                  
   249                                  ;-64 #define LABELADRMAX 100
   250                                  
   251                                  
   252                                  ;-65 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   253                                  
   254 000005B4 <res 000000C8>          LabelAddr resw 100
   255                                  
   256                                  ;-66 int LabelMaxIx=0;       //actual number of stored labels
   257                                  
   258 0000067C 0000                    LabelMaxIx dw 0
   259                                  
   260                                  ;-67 int LabelIx;            //actual number of just searched label
   261                                  
   262 0000067E 0000                    LabelIx dw 0
   263                                  
   264                                  ;-68 
   265                                  
   266                                  
   267                                  ;-69 #define FILEBINMAX 2000 //next number - max. oplength
   268                                  
   269                                  
   270                                  ;-70 char FileBin  [FILEBINMAX];//output binary file
   271                                  
   272 00000680 <res 000007D0>          FileBin resb 2000
   273                                  
   274                                  ;-71 unsigned int BinLen=0;  //length of binary file
   275                                  
   276 00000E50 0000                    BinLen dw 0
   277                                  
   278                                  ;-72 
   279                                  
   280                                  
   281                                  ;-73 char *arglen=0x80;      // for main only
   282                                  
   283 00000E52 8000                    arglen dw 128
   284                                  
   285                                  ;-74 char *argv=0x82;        // for main only
   286                                  
   287 00000E54 8200                    argv dw 130
   288                                  ;Back to main program: AS.C
   289                                  
   290                                  ;-3 #include "OPTABL.C"   
   291                                  
   292                                  ;Use include file: OPTABL.C
   293                                  
   294                                  ;-1 char I_START=0xF1;
   295                                  
   296 00000E56 F1                      I_START db 241
   297                                  
   298                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   299                                  
   300                                  
   301                                  ;-3 //  1:   1 byte opcode
   302                                  
   303                                  
   304                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   305                                  
   306 00000E57 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   307                                  
   308                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   309                                  
   310 00000E60 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   311                                  
   312                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   313                                  
   314 00000E68 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   315                                  
   316                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   317                                  
   318 00000E6F 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   319                                  
   320                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   321                                  
   322 00000E76 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   323                                  
   324                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   325                                  
   326 00000E7E 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   327                                  
   328                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   329                                  
   330 00000E85 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   331                                  
   332                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   333                                  
   334 00000E8C 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   335                                  
   336                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   337                                  
   338 00000E94 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   339                                  
   340                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   341                                  
   342 00000E9D 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   343                                  
   344                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   345                                  
   346 00000EA5 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   347                                  
   348                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   349                                  
   350 00000EAD 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   351                                  
   352                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   353                                  
   354 00000EB5 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   355                                  
   356                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   357                                  
   358 00000EBE 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   359                                  
   360                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   361                                  
   362 00000EC7 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   363                                  
   364                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   365                                  
   366 00000ED0 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   367                                  
   368                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   369                                  
   370 00000ED9 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   371                                  
   372                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   373                                  
   374 00000EE2 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   375                                  
   376                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   377                                  
   378 00000EEB 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   379                                  
   380                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   381                                  
   382 00000EF4 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   383                                  
   384                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   385                                  
   386 00000EFD 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   387                                  
   388                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   389                                  
   390 00000F06 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   391                                  
   392                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   393                                  
   394 00000F0F 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   395                                  
   396                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   397                                  
   398 00000F18 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   399                                  
   400                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   401                                  
   402 00000F20 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   403                                  
   404                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   405                                  
   406 00000F28 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   407                                  
   408                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   409                                  
   410 00000F30 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   411                                  
   412                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   413                                  
   414 00000F39 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   415                                  
   416                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   417                                  
   418 00000F42 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   419                                  
   420                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   421                                  
   422 00000F4A 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   423                                  
   424                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   425                                  
   426 00000F52 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   427                                  
   428                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   429                                  
   430 00000F59 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   431                                  
   432                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   433                                  
   434 00000F60 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   435                                  
   436                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   437                                  
   438 00000F67 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   439                                  
   440                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   441                                  
   442 00000F6E 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   443                                  
   444                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   445                                  
   446 00000F75 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   447                                  
   448                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   449                                  
   450 00000F7C 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   451                                  
   452                                  ;-41 // 2: mem reg 16 bit
   453                                  
   454                                  
   455                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   456                                  
   457 00000F83 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   458                                  
   459                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   460                                  
   461 00000F8C 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   462                                  
   463                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   464                                  
   465 00000F95 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   466                                  
   467                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   468                                  
   469 00000F9D 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   470                                  
   471                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   472                                  
   473 00000FA5 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   474                                  
   475                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   476                                  
   477 00000FAD 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   478                                  
   479                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   480                                  
   481 00000FB6 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   482                                  
   483                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   484                                  
   485 00000FBE 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   486                                  
   487                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   488                                  
   489                                  
   490                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   491                                  
   492 00000FC7 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   493                                  
   494                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   495                                  
   496 00000FCE 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   497                                  
   498                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   499                                  
   500 00000FD5 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   501                                  
   502                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   503                                  
   504 00000FDC 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   505                                  
   506                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   507                                  
   508 00000FE4 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   509                                  
   510                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   511                                  
   512 00000FEC 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   513                                  
   514                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   515                                  
   516                                  
   517                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   518                                  
   519 00000FF4 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   520                                  
   521                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   522                                  
   523 00000FFB 4F52000401F1            I_OR db 79,82,0,4,1,241
   524                                  
   525                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   526                                  
   527 00001001 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   528                                  
   529                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   530                                  
   531 00001008 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   532                                  
   533                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   534                                  
   535 0000100F 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   536                                  
   537                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   538                                  
   539 00001016 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   540                                  
   541                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   542                                  
   543 0000101D 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   544                                  
   545                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   546                                  
   547 00001024 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   548                                  
   549                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   550                                  
   551 0000102B 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   552 00001034 00F1               
   553                                  
   554                                  ;-67 //  5: mov
   555                                  
   556                                  
   557                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   558                                  
   559 00001036 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   560                                  
   561                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   562                                  
   563 0000103C 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   564                                  
   565                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   566                                  
   567 00001045 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   568                                  
   569                                  ;-71 //  6: single byte relative jump
   570                                  
   571                                  
   572                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   573                                  
   574 0000104E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   575                                  
   576                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   577                                  
   578 00001054 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   579                                  
   580                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   581                                  
   582 0000105B 4A42000602F1            I_JB db 74,66,0,6,2,241
   583                                  
   584                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   585                                  
   586 00001061 4A43000602F1            I_JC db 74,67,0,6,2,241
   587                                  
   588                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   589                                  
   590 00001067 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   591                                  
   592                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   593                                  
   594 0000106E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   595                                  
   596                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   597                                  
   598 00001075 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   599                                  
   600                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   601                                  
   602 0000107C 4A45000604F1            I_JE db 74,69,0,6,4,241
   603                                  
   604                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   605                                  
   606 00001082 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   607                                  
   608                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   609                                  
   610 00001088 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   611                                  
   612                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   613                                  
   614 0000108F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   615                                  
   616                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   617                                  
   618 00001096 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   619                                  
   620                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   621                                  
   622 0000109D 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   623                                  
   624                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   625                                  
   626 000010A4 4A41000607F1            I_JA db 74,65,0,6,7,241
   627                                  
   628                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   629                                  
   630 000010AA 4A53000608F1            I_JS db 74,83,0,6,8,241
   631                                  
   632                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   633                                  
   634 000010B0 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   635                                  
   636                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   637                                  
   638 000010B7 4A5000060AF1            I_JP db 74,80,0,6,10,241
   639                                  
   640                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   641                                  
   642 000010BD 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   643                                  
   644                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   645                                  
   646 000010C4 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   647                                  
   648                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   649                                  
   650 000010CB 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   651                                  
   652                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   653                                  
   654 000010D2 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   655                                  
   656                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   657                                  
   658 000010D8 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   659                                  
   660                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   661                                  
   662 000010DF 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   663                                  
   664                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   665                                  
   666 000010E6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   667                                  
   668                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   669                                  
   670 000010ED 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   671                                  
   672                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   673                                  
   674 000010F4 4A4700060FF1            I_JG db 74,71,0,6,15,241
   675                                  
   676                                  ;-98 //  7: jmp, call
   677                                  
   678                                  
   679                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   680                                  
   681 000010FA 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   682                                  
   683                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   684                                  
   685 00001102 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   686                                  
   687                                  ;-101 //  8: ret
   688                                  
   689                                  
   690                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   691                                  
   692 0000110B 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   693                                  
   694                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   695                                  
   696 00001113 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   697                                  
   698                                  ;-104 //  9: seg, r/m
   699                                  
   700                                  
   701                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   702                                  
   703 0000111C 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   704                                  
   705                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   706                                  
   707 00001124 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   708                                  
   709                                  ;-107 //  11: shift, rotates
   710                                  
   711                                  
   712                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   713                                  
   714 0000112B 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   715                                  
   716                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   717                                  
   718 00001132 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   719                                  
   720                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   721                                  
   722 00001139 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   723                                  
   724                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   725                                  
   726 00001140 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   727                                  
   728                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   729                                  
   730 00001147 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   731                                  
   732                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   733                                  
   734 0000114E 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   735                                  
   736                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   737                                  
   738 00001155 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   739                                  
   740                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   741                                  
   742 0000115C 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   743                                  
   744                                  ;-116 //  12: int
   745                                  
   746                                  
   747                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   748                                  
   749 00001163 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   750                                  
   751                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   752                                  
   753 0000116B 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   754                                  
   755                                  ;-119 //  14: in/out
   756                                  
   757                                  
   758                                  ;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   759                                  
   760                                  
   761                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   762                                  
   763                                  
   764                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   765                                  
   766                                  
   767                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   768                                  
   769                                  
   770                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   771                                  
   772                                  
   773                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   774                                  
   775                                  
   776                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   777                                  
   778                                  
   779                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   780                                  
   781                                  
   782                                  ;-128 //  15: xchg
   783                                  
   784                                  
   785                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   786                                  
   787 00001173 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   788                                  
   789                                  ;-130 //  16: loop, jcxz
   790                                  
   791                                  
   792                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   793                                  
   794 0000117C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   795 00001185 F1                 
   796                                  
   797                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   798                                  
   799 00001186 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   800 0000118F F1                 
   801                                  
   802                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   803                                  
   804 00001190 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   805                                  
   806                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   807                                  
   808 00001199 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   809                                  
   810                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   811                                  
   812 000011A2 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   813                                  
   814                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   815                                  
   816 000011AA 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   817                                  
   818                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   819                                  
   820 000011B2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   821                                  
   822                                  ;-138 //  30: enter
   823                                  
   824                                  
   825                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   826                                  
   827 000011BB 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   828                                  
   829                                  ;-140 // 100: directives
   830                                  
   831                                  
   832                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   833                                  
   834 000011C4 4F52470065F1            I_ORG db 79,82,71,0,101,241
   835                                  
   836                                  ;-142 // section, segment .TEXT .DATA .BSS
   837                                  
   838                                  
   839                                  ;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   840                                  
   841                                  
   842                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   843                                  
   844                                  
   845                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   846                                  
   847                                  
   848                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   849                                  
   850 000011CA 444200C8F1              I_DB db 68,66,0,200,241
   851                                  
   852                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   853                                  
   854 000011CF 445700C9F1              I_DW db 68,87,0,201,241
   855                                  
   856                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   857                                  
   858 000011D4 444400CAF1              I_DD db 68,68,0,202,241
   859                                  
   860                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   861                                  
   862 000011D9 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   863                                  
   864                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   865                                  
   866 000011E0 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   867                                  
   868                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   869                                  
   870 000011E7 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   871                                  
   872                                  ;-152 char I_END=0;// end of table char
   873                                  
   874 000011EE 00                      I_END db 0
   875                                  ;Back to main program: AS.C
   876                                  
   877                                  ;-4 #include "OPS.C"
   878                                  
   879                                  ;Use include file: OPS.C
   880                                  
   881                                  ;-1 int ChangeDirection() {
   882                                  
   883                                  
   884                                  ChangeDirection:  ; *** PROC ***
   885                                  
   886                                  ;-2     char c;
   887                                  
   888                                  
   889                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   890                                  
   891                                  ;Function : ChangeDirection, Number of local variables: 1
   892                                  ;   # type sign width line used address name   list of local variables
   893                                  ;  200 var sign byte     2 NULL bp-2    c;
   894 000011EF C8020000                 ENTER  2,0
   895 000011F3 A0[AC01]                 mov al, [Op]
   896 000011F6 8846FE                   mov byte [bp-2], al
   897 000011F9 A0[AD01]                 mov al, [Op2]
   898 000011FC A2[AC01]                 mov byte [Op], al
   899 000011FF 8A46FE                   mov al, [bp-2]
   900 00001202 A2[AD01]                 mov byte [Op2], al
   901                                  
   902                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   903                                  
   904 00001205 A0[B501]                 mov al, [R1Type]
   905 00001208 8846FE                   mov byte [bp-2], al
   906 0000120B A0[B401]                 mov al, [R2Type]
   907 0000120E A2[B501]                 mov byte [R1Type], al
   908 00001211 8A46FE                   mov al, [bp-2]
   909 00001214 A2[B401]                 mov byte [R2Type], al
   910                                  
   911                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   912                                  
   913 00001217 A0[B301]                 mov al, [R1No]
   914 0000121A 8846FE                   mov byte [bp-2], al
   915 0000121D A0[B201]                 mov al, [R2No]
   916 00001220 A2[B301]                 mov byte [R1No], al
   917 00001223 8A46FE                   mov al, [bp-2]
   918 00001226 A2[B201]                 mov byte [R2No], al
   919                                  
   920                                  ;-6     dflag=2;     
   921                                  
   922 00001229 66B802000000             mov eax, 2
   923 0000122F A2[B801]                 mov byte [dflag], al
   924                                  
   925                                  ;-7 }
   926                                  
   927                                  
   928                                  ;-8      
   929                                  
   930                                  
   931                                  ;-9 int checkOpL() {
   932 00001232 C9                       LEAVE
   933 00001233 C3                       ret
   934                                  ; ENDP
   935                                  
   936                                  checkOpL:  ; *** PROC ***
   937                                  
   938                                  ;-10     if (Op == ADR) implerror();
   939                                  
   940 00001234 A0[AC01]                 mov al, [Op]
   941 00001237 3C03                     cmp al, 3
   942 00001239 0F850300                 jne @@checkOpL1
   943 0000123D E8CF14                   call implerror
   944                                  
   945                                  ;-11     if (R2Type == SEGREG) {segregerror(); return;}//only move,push,pop
   946                                  
   947                                  @@checkOpL1:
   948 00001240 A0[B401]                 mov al, [R2Type]
   949 00001243 3C04                     cmp al, 4
   950 00001245 0F850600                 jne @@checkOpL2
   951 00001249 E88B15                   call segregerror
   952 0000124C E95300                   jmp @@retn
   953                                  
   954                                  ;-12     setwflag();
   955                                  
   956                                  @@checkOpL2:
   957 0000124F E80204                   call setwflag
   958                                  
   959                                  ;-13     if (OpSize == 0) error1("no op size declared");
   960                                  
   961 00001252 A0[B601]                 mov al, [OpSize]
   962 00001255 3C00                     cmp al, 0
   963 00001257 0F850900                 jne @@checkOpL3
   964 0000125B 68[A312]                 push checkOpL_0
   965 0000125E E8DE13                   call error1
   966 00001261 83C402                   add  sp, 2
   967                                  
   968                                  ;-14     if (OpSize == R1Type) return;
   969                                  
   970                                  @@checkOpL3:
   971 00001264 A0[B601]                 mov al, [OpSize]
   972 00001267 3A06[B501]               cmp al, [R1Type]
   973 0000126B 0F850300                 jne @@checkOpL4
   974 0000126F E93000                   jmp @@retn
   975                                  
   976                                  ;-15     if (OpSize){
   977                                  
   978                                  @@checkOpL4:
   979 00001272 A0[B601]                 mov al, [OpSize]
   980 00001275 08C0                     or  al, al
   981 00001277 0F841500                 je @@checkOpL5
   982                                  
   983                                  ;-16         if (Op == MEM) return;
   984                                  
   985 0000127B A0[AC01]                 mov al, [Op]
   986 0000127E 3C04                     cmp al, 4
   987 00001280 0F850300                 jne @@checkOpL6
   988 00001284 E91B00                   jmp @@retn
   989                                  
   990                                  ;-17         error1("Conflict OpSize and RegSize"); 
   991                                  
   992                                  @@checkOpL6:
   993 00001287 68[B712]                 push checkOpL_1
   994 0000128A E8B213                   call error1
   995 0000128D 83C402                   add  sp, 2
   996                                  
   997                                  ;-18         }
   998                                  
   999                                  
  1000                                  ;-19     if (R1Type==0) error1("no register defined");
  1001                                  
  1002                                  @@checkOpL5:
  1003 00001290 A0[B501]                 mov al, [R1Type]
  1004 00001293 3C00                     cmp al, 0
  1005 00001295 0F850900                 jne @@checkOpL7
  1006 00001299 68[D312]                 push checkOpL_2
  1007 0000129C E8A013                   call error1
  1008 0000129F 83C402                   add  sp, 2
  1009                                  
  1010                                  ;-20 }
  1011                                  
  1012                                  @@checkOpL7:
  1013                                  
  1014                                  ;-21     
  1015                                  
  1016                                  
  1017                                  ;-22 int check2Ops() {
  1018                                  
  1019                                  @@retn:
  1020 000012A2 C3                       ret
  1021                                  ; ENDP
  1022 000012A3 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1023 000012AC 65206465636C617265-
  1024 000012B5 6400               
  1025 000012B7 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  1026 000012C0 4F7053697A6520616E-
  1027 000012C9 642052656753697A65-
  1028 000012D2 00                 
  1029 000012D3 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  1030 000012DC 657220646566696E65-
  1031 000012E5 6400               
  1032                                  
  1033                                  check2Ops:  ; *** PROC ***
  1034                                  
  1035                                  ;-23     get2Ops();
  1036                                  
  1037 000012E7 E83400                   call get2Ops
  1038                                  
  1039                                  ;-24     if (Op ==   0) addrerror();
  1040                                  
  1041 000012EA A0[AC01]                 mov al, [Op]
  1042 000012ED 3C00                     cmp al, 0
  1043 000012EF 0F850300                 jne @@check2Ops8
  1044 000012F3 E8DA13                   call addrerror
  1045                                  
  1046                                  ;-25     if (Op == ADR) invaloperror(); 
  1047                                  
  1048                                  @@check2Ops8:
  1049 000012F6 A0[AC01]                 mov al, [Op]
  1050 000012F9 3C03                     cmp al, 3
  1051 000012FB 0F850300                 jne @@check2Ops9
  1052 000012FF E84814                   call invaloperror
  1053                                  
  1054                                  ;-26     if (Op == IMM) immeerror();   
  1055                                  
  1056                                  @@check2Ops9:
  1057 00001302 A0[AC01]                 mov al, [Op]
  1058 00001305 3C01                     cmp al, 1
  1059 00001307 0F850300                 jne @@check2Ops10
  1060 0000130B E8DC13                   call immeerror
  1061                                  
  1062                                  ;-27     if (Op2==   0) addrerror();
  1063                                  
  1064                                  @@check2Ops10:
  1065 0000130E A0[AD01]                 mov al, [Op2]
  1066 00001311 3C00                     cmp al, 0
  1067 00001313 0F850300                 jne @@check2Ops11
  1068 00001317 E8B613                   call addrerror
  1069                                  
  1070                                  ;-28 //    if (Op2== ADR) invaloperror();//allowed in mov           
  1071                                  
  1072                                  
  1073                                  ;-29     setwflag();       
  1074                                  
  1075                                  @@check2Ops11:
  1076 0000131A E83703                   call setwflag
  1077                                  
  1078                                  ;-30 }    
  1079                                  
  1080                                  
  1081                                  ;-31 int get2Ops() {
  1082                                  
  1083 0000131D C3                       ret
  1084                                  ; ENDP
  1085                                  
  1086                                  get2Ops:  ; *** PROC ***
  1087                                  
  1088                                  ;-32     getOpL();
  1089                                  
  1090 0000131E E80C00                   call getOpL
  1091                                  
  1092                                  ;-33     need(',');    
  1093                                  
  1094 00001321 6A2C                     push 44
  1095 00001323 E8EF08                   call need
  1096 00001326 83C402                   add  sp, 2
  1097                                  
  1098                                  ;-34     getOpR();         
  1099                                  
  1100 00001329 E84D00                   call getOpR
  1101                                  
  1102                                  ;-35 } 
  1103                                  
  1104                                  
  1105                                  ;-36         
  1106                                  
  1107                                  
  1108                                  ;-37 int getOpL() {
  1109                                  
  1110 0000132C C3                       ret
  1111                                  ; ENDP
  1112                                  
  1113                                  getOpL:  ; *** PROC ***
  1114                                  
  1115                                  ;-38 //set: op=0,IMM,REG,ADR,MEM
  1116                                  
  1117                                  
  1118                                  ;-39     disp=0; imme=0; isDirect=1; 
  1119                                  
  1120 0000132D 66B800000000             mov eax, 0
  1121 00001333 A3[BC01]                 mov word [disp], ax
  1122 00001336 66B800000000             mov eax, 0
  1123 0000133C A3[BE01]                 mov word [imme], ax
  1124 0000133F 66B801000000             mov eax, 1
  1125 00001345 A2[BB01]                 mov byte [isDirect], al
  1126                                  
  1127                                  ;-40     getOpR();
  1128                                  
  1129 00001348 E82E00                   call getOpR
  1130                                  
  1131                                  ;-41     Op=Op2;         Op2=0;
  1132                                  
  1133 0000134B A0[AD01]                 mov al, [Op2]
  1134 0000134E A2[AC01]                 mov byte [Op], al
  1135 00001351 66B800000000             mov eax, 0
  1136 00001357 A2[AD01]                 mov byte [Op2], al
  1137                                  
  1138                                  ;-42     R1No=R2No;      R2No=0;
  1139                                  
  1140 0000135A A0[B201]                 mov al, [R2No]
  1141 0000135D A2[B301]                 mov byte [R1No], al
  1142 00001360 66B800000000             mov eax, 0
  1143 00001366 A2[B201]                 mov byte [R2No], al
  1144                                  
  1145                                  ;-43     R1Type=R2Type; R2Type=0; 
  1146                                  
  1147 00001369 A0[B401]                 mov al, [R2Type]
  1148 0000136C A2[B501]                 mov byte [R1Type], al
  1149 0000136F 66B800000000             mov eax, 0
  1150 00001375 A2[B401]                 mov byte [R2Type], al
  1151                                  
  1152                                  ;-44 }  
  1153                                  
  1154                                  
  1155                                  ;-45 
  1156                                  
  1157                                  
  1158                                  ;-46 int getOpR() {
  1159                                  
  1160 00001378 C3                       ret
  1161                                  ; ENDP
  1162                                  
  1163                                  getOpR:  ; *** PROC ***
  1164                                  
  1165                                  ;-47     Op2=getOp1();
  1166                                  
  1167 00001379 E88900                   call getOp1
  1168 0000137C A2[AD01]                 mov byte [Op2], al
  1169                                  
  1170                                  ;-48     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1171                                  
  1172 0000137F 6A5B                     push 91
  1173 00001381 E86308                   call isToken
  1174 00001384 83C402                   add  sp, 2
  1175 00001387 08C0                     or  al, al
  1176 00001389 0F840F00                 je @@getOpR12
  1177 0000138D 66B804000000             mov eax, 4
  1178 00001393 A2[AD01]                 mov byte [Op2], al
  1179 00001396 E8F200                   call getMEM
  1180 00001399 E94F00                   jmp @@retn
  1181                                  
  1182                                  ;-49     if (Op2 == 0)     {invaloperror();         return;}
  1183                                  
  1184                                  @@getOpR12:
  1185 0000139C A0[AD01]                 mov al, [Op2]
  1186 0000139F 3C00                     cmp al, 0
  1187 000013A1 0F850600                 jne @@getOpR13
  1188 000013A5 E8A213                   call invaloperror
  1189 000013A8 E94000                   jmp @@retn
  1190                                  
  1191                                  ;-50     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1192                                  
  1193                                  @@getOpR13:
  1194 000013AB A0[AD01]                 mov al, [Op2]
  1195 000013AE 3C01                     cmp al, 1
  1196 000013B0 0F850900                 jne @@getOpR14
  1197 000013B4 A1[4D00]                 mov ax, [SymbolInt]
  1198 000013B7 A3[BE01]                 mov word [imme], ax
  1199 000013BA E92E00                   jmp @@retn
  1200                                  
  1201                                  ;-51     if (Op2 == REG)                            return;
  1202                                  
  1203                                  @@getOpR14:
  1204 000013BD A0[AD01]                 mov al, [Op2]
  1205 000013C0 3C02                     cmp al, 2
  1206 000013C2 0F850300                 jne @@getOpR15
  1207 000013C6 E92200                   jmp @@retn
  1208                                  
  1209                                  ;-52     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1210                                  
  1211                                  @@getOpR15:
  1212 000013C9 A0[AD01]                 mov al, [Op2]
  1213 000013CC 3C03                     cmp al, 3
  1214 000013CE 0F851000                 jne @@getOpR16
  1215 000013D2 8B1E[7E06]               mov bx, [LabelIx]
  1216 000013D6 D1E3                     shl bx, 1
  1217 000013D8 8B87[B405]               mov ax, [LabelAddr + bx]
  1218 000013DC A3[BC01]                 mov word [disp], ax
  1219 000013DF E90900                   jmp @@retn
  1220                                  
  1221                                  ;-53     error1("Name of operand expected");
  1222                                  
  1223                                  @@getOpR16:
  1224 000013E2 68[EC13]                 push getOpR_0
  1225 000013E5 E85712                   call error1
  1226 000013E8 83C402                   add  sp, 2
  1227                                  
  1228                                  ;-54 }
  1229                                  
  1230                                  
  1231                                  ;-55 
  1232                                  
  1233                                  
  1234                                  ;-56 int getOp1() {//scan for a single operand
  1235                                  
  1236                                  @@retn:
  1237 000013EB C3                       ret
  1238                                  ; ENDP
  1239 000013EC 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1240 000013F5 706572616E64206578-
  1241 000013FE 70656374656400     
  1242                                  
  1243                                  getOp1:  ; *** PROC ***
  1244                                  
  1245                                  ;-57 //return:0, IMM, REG, ADR (not MEM)
  1246                                  
  1247                                  
  1248                                  ;-58 //set   :R2Type, R2No by testReg
  1249                                  
  1250                                  
  1251                                  ;-59 //set   :LabelIx by searchLabel
  1252                                  
  1253                                  
  1254                                  ;-60     if (TokeType == 0)      return 0;
  1255                                  
  1256 00001405 A0[AB01]                 mov al, [TokeType]
  1257 00001408 3C00                     cmp al, 0
  1258 0000140A 0F850900                 jne @@getOp117
  1259 0000140E 66B800000000             mov eax, 0
  1260 00001414 E96000                   jmp @@retn
  1261                                  
  1262                                  ;-61     if (TokeType == DIGIT)  return IMM;
  1263                                  
  1264                                  @@getOp117:
  1265 00001417 A0[AB01]                 mov al, [TokeType]
  1266 0000141A 3C01                     cmp al, 1
  1267 0000141C 0F850900                 jne @@getOp118
  1268 00001420 66B801000000             mov eax, 1
  1269 00001426 E94E00                   jmp @@retn
  1270                                  
  1271                                  ;-62     if (TokeType == ALNUME) {
  1272                                  
  1273                                  @@getOp118:
  1274 00001429 A0[AB01]                 mov al, [TokeType]
  1275 0000142C 3C03                     cmp al, 3
  1276 0000142E 0F853C00                 jne @@getOp119
  1277                                  
  1278                                  ;-63         R2No=testReg();
  1279                                  
  1280 00001432 E85F0B                   call testReg
  1281 00001435 A2[B201]                 mov byte [R2No], al
  1282                                  
  1283                                  ;-64         if (R2Type)        return REG;
  1284                                  
  1285 00001438 A0[B401]                 mov al, [R2Type]
  1286 0000143B 08C0                     or  al, al
  1287 0000143D 0F840900                 je @@getOp120
  1288 00001441 66B802000000             mov eax, 2
  1289 00001447 E92D00                   jmp @@retn
  1290                                  
  1291                                  ;-65         LabelIx=searchLabel();
  1292                                  
  1293                                  @@getOp120:
  1294 0000144A E80505                   call searchLabel
  1295 0000144D A3[7E06]                 mov word [LabelIx], ax
  1296                                  
  1297                                  ;-66         if (LabelIx)        return ADR;
  1298                                  
  1299 00001450 A1[7E06]                 mov ax, [LabelIx]
  1300 00001453 08C0                     or  al, al
  1301 00001455 0F840C00                 je @@getOp121
  1302 00001459 66B803000000             mov eax, 3
  1303 0000145F E91500                   jmp @@retn
  1304                                  
  1305                                  ;-67         else error1("variable not found"); 
  1306                                  
  1307 00001462 E90900                   jmp @@getOp122
  1308                                  @@getOp121:
  1309 00001465 68[7814]                 push getOp1_0
  1310 00001468 E8D411                   call error1
  1311 0000146B 83C402                   add  sp, 2
  1312                                  
  1313                                  ;-68     }
  1314                                  
  1315                                  @@getOp122:
  1316                                  
  1317                                  ;-69     return 0;
  1318                                  
  1319                                  @@getOp119:
  1320 0000146E 66B800000000             mov eax, 0
  1321 00001474 E90000                   jmp @@retn
  1322                                  
  1323                                  ;-70 }
  1324                                  
  1325                                  
  1326                                  ;-71 
  1327                                  
  1328                                  
  1329                                  ;-72 int getMEM() {// e.g. [array+bp+si-4]
  1330                                  
  1331                                  @@retn:
  1332 00001477 C3                       ret
  1333                                  ; ENDP
  1334 00001478 7661726961626C6520-     getOp1_0 db "variable not found",0
  1335 00001481 6E6F7420666F756E64-
  1336 0000148A 00                 
  1337                                  
  1338                                  getMEM:  ; *** PROC ***
  1339                                  
  1340                                  ;-73 //set: disp, rm, R2Type
  1341                                  
  1342                                  
  1343                                  ;-74     char c;
  1344                                  
  1345                                  
  1346                                  ;-75     disp=0; rm=0;
  1347                                  
  1348                                  ;Function : getMEM, Number of local variables: 1
  1349                                  ;   # type sign width line used address name   list of local variables
  1350                                  ;  200 var sign byte    74 NULL bp-2    c;
  1351 0000148B C8020000                 ENTER  2,0
  1352 0000148F 66B800000000             mov eax, 0
  1353 00001495 A3[BC01]                 mov word [disp], ax
  1354 00001498 66B800000000             mov eax, 0
  1355 0000149E A2[BA01]                 mov byte [rm], al
  1356                                  
  1357                                  ;-76     do {
  1358                                  
  1359                                  @@getMEM23:
  1360                                  
  1361                                  ;-77         getTokeType();
  1362                                  
  1363 000014A1 E86D03                   call getTokeType
  1364                                  
  1365                                  ;-78         c=getOp1();
  1366                                  
  1367 000014A4 E85EFF                   call getOp1
  1368 000014A7 8846FE                   mov byte [bp-2], al
  1369                                  
  1370                                  ;-79         if (c ==   0) syntaxerror();
  1371                                  
  1372 000014AA 8A46FE                   mov al, [bp-2]
  1373 000014AD 3C00                     cmp al, 0
  1374 000014AF 0F850300                 jne @@getMEM24
  1375 000014B3 E84813                   call syntaxerror
  1376                                  
  1377                                  ;-80         if (c == REG) {isDirect=0;
  1378                                  
  1379                                  @@getMEM24:
  1380 000014B6 8A46FE                   mov al, [bp-2]
  1381 000014B9 3C02                     cmp al, 2
  1382 000014BB 0F851E00                 jne @@getMEM25
  1383 000014BF 66B800000000             mov eax, 0
  1384 000014C5 A2[BB01]                 mov byte [isDirect], al
  1385                                  
  1386                                  ;-81             if (rm) rm=getIndReg2();
  1387                                  
  1388 000014C8 A0[BA01]                 mov al, [rm]
  1389 000014CB 08C0                     or  al, al
  1390 000014CD 0F840900                 je @@getMEM26
  1391 000014D1 E8F300                   call getIndReg2
  1392 000014D4 A2[BA01]                 mov byte [rm], al
  1393                                  
  1394                                  ;-82             else getIndReg1();
  1395                                  
  1396 000014D7 E90300                   jmp @@getMEM27
  1397                                  @@getMEM26:
  1398 000014DA E88900                   call getIndReg1
  1399                                  
  1400                                  ;-83         }
  1401                                  
  1402                                  @@getMEM27:
  1403                                  
  1404                                  ;-84         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1405                                  
  1406                                  @@getMEM25:
  1407 000014DD 8A46FE                   mov al, [bp-2]
  1408 000014E0 3C03                     cmp al, 3
  1409 000014E2 0F851000                 jne @@getMEM28
  1410 000014E6 A1[BC01]                 mov ax, [disp]
  1411 000014E9 8B1E[7E06]               mov bx, [LabelIx]
  1412 000014ED D1E3                     shl bx, 1
  1413 000014EF 0387[B405]               add ax, [LabelAddr + bx]
  1414 000014F3 A3[BC01]                 mov word [disp], ax
  1415                                  
  1416                                  ;-85         if (c == IMM) disp=disp+SymbolInt;
  1417                                  
  1418                                  @@getMEM28:
  1419 000014F6 8A46FE                   mov al, [bp-2]
  1420 000014F9 3C01                     cmp al, 1
  1421 000014FB 0F850A00                 jne @@getMEM29
  1422 000014FF A1[BC01]                 mov ax, [disp]
  1423 00001502 0306[4D00]               add ax, [SymbolInt]
  1424 00001506 A3[BC01]                 mov word [disp], ax
  1425                                  
  1426                                  ;-86         if (isToken('-')) {
  1427                                  
  1428                                  @@getMEM29:
  1429 00001509 6A2D                     push 45
  1430 0000150B E8D906                   call isToken
  1431 0000150E 83C402                   add  sp, 2
  1432 00001511 08C0                     or  al, al
  1433 00001513 0F841900                 je @@getMEM30
  1434                                  
  1435                                  ;-87             getTokeType();
  1436                                  
  1437 00001517 E8F702                   call getTokeType
  1438                                  
  1439                                  ;-88             if (TokeType != DIGIT) numbererror();
  1440                                  
  1441 0000151A A0[AB01]                 mov al, [TokeType]
  1442 0000151D 3C01                     cmp al, 1
  1443 0000151F 0F840300                 je  @@getMEM31
  1444 00001523 E84512                   call numbererror
  1445                                  
  1446                                  ;-89             disp = disp - SymbolInt;
  1447                                  
  1448                                  @@getMEM31:
  1449 00001526 A1[BC01]                 mov ax, [disp]
  1450 00001529 2B06[4D00]               sub ax, [SymbolInt]
  1451 0000152D A3[BC01]                 mov word [disp], ax
  1452                                  
  1453                                  ;-90         }
  1454                                  
  1455                                  
  1456                                  ;-91     } while (isToken('+'));
  1457                                  
  1458                                  @@getMEM30:
  1459 00001530 6A2B                     push 43
  1460 00001532 E8B206                   call isToken
  1461 00001535 83C402                   add  sp, 2
  1462 00001538 08C0                     or  al, al
  1463 0000153A 0F840300                 je @@getMEM32
  1464 0000153E E960FF                   jmp @@getMEM23
  1465                                  @@getMEM32:
  1466                                  
  1467                                  ;-92     if (isToken(']') == 0) errorexit("] expected");
  1468                                  
  1469 00001541 6A5D                     push 93
  1470 00001543 E8A106                   call isToken
  1471 00001546 83C402                   add  sp, 2
  1472 00001549 83F800                   cmp ax, 0
  1473 0000154C 0F850900                 jne @@getMEM33
  1474 00001550 68[5B15]                 push getMEM_0
  1475 00001553 E84811                   call errorexit
  1476 00001556 83C402                   add  sp, 2
  1477                                  
  1478                                  ;-93 }
  1479                                  
  1480                                  @@getMEM33:
  1481                                  
  1482                                  ;-94 int getIndReg1() {
  1483 00001559 C9                       LEAVE
  1484 0000155A C3                       ret
  1485                                  ; ENDP
  1486 0000155B 5D2065787065637465-     getMEM_0 db "] expected",0
  1487 00001564 6400               
  1488                                  
  1489                                  getIndReg1:  ; *** PROC ***
  1490                                  
  1491                                  ;-95     if (R2Type !=WORD) indexerror();
  1492                                  
  1493 00001566 A0[B401]                 mov al, [R2Type]
  1494 00001569 3C02                     cmp al, 2
  1495 0000156B 0F840300                 je  @@getIndReg134
  1496 0000156F E8B711                   call indexerror
  1497                                  
  1498                                  ;-96     if (R2No==3) rm=7;//BX
  1499                                  
  1500                                  @@getIndReg134:
  1501 00001572 A0[B201]                 mov al, [R2No]
  1502 00001575 3C03                     cmp al, 3
  1503 00001577 0F850900                 jne @@getIndReg135
  1504 0000157B 66B807000000             mov eax, 7
  1505 00001581 A2[BA01]                 mov byte [rm], al
  1506                                  
  1507                                  ;-97     if (R2No==5) rm=6;//BP, change to BP+0
  1508                                  
  1509                                  @@getIndReg135:
  1510 00001584 A0[B201]                 mov al, [R2No]
  1511 00001587 3C05                     cmp al, 5
  1512 00001589 0F850900                 jne @@getIndReg136
  1513 0000158D 66B806000000             mov eax, 6
  1514 00001593 A2[BA01]                 mov byte [rm], al
  1515                                  
  1516                                  ;-98     if (R2No==7) rm=5;//DI
  1517                                  
  1518                                  @@getIndReg136:
  1519 00001596 A0[B201]                 mov al, [R2No]
  1520 00001599 3C07                     cmp al, 7
  1521 0000159B 0F850900                 jne @@getIndReg137
  1522 0000159F 66B805000000             mov eax, 5
  1523 000015A5 A2[BA01]                 mov byte [rm], al
  1524                                  
  1525                                  ;-99     if (R2No==6) rm=4;//SI
  1526                                  
  1527                                  @@getIndReg137:
  1528 000015A8 A0[B201]                 mov al, [R2No]
  1529 000015AB 3C06                     cmp al, 6
  1530 000015AD 0F850900                 jne @@getIndReg138
  1531 000015B1 66B804000000             mov eax, 4
  1532 000015B7 A2[BA01]                 mov byte [rm], al
  1533                                  
  1534                                  ;-100     if (rm==0) indexerror();
  1535                                  
  1536                                  @@getIndReg138:
  1537 000015BA A0[BA01]                 mov al, [rm]
  1538 000015BD 3C00                     cmp al, 0
  1539 000015BF 0F850300                 jne @@getIndReg139
  1540 000015C3 E86311                   call indexerror
  1541                                  
  1542                                  ;-101 }
  1543                                  
  1544                                  @@getIndReg139:
  1545                                  
  1546                                  ;-102 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1547                                  
  1548 000015C6 C3                       ret
  1549                                  ; ENDP
  1550                                  
  1551                                  getIndReg2:  ; *** PROC ***
  1552                                  ;Function : getIndReg2, Number of local variables: 1
  1553                                  ;   # type sign width line used address name   list of local variables
  1554                                  ;  200 var sign byte   102 NULL bp-2    m;
  1555 000015C7 C8020000                 ENTER  2,0
  1556 000015CB 66B804000000             mov eax, 4
  1557 000015D1 8846FE                   mov byte [bp-2], al
  1558                                  
  1559                                  ;-103     if (R2Type !=WORD) indexerror();
  1560                                  
  1561 000015D4 A0[B401]                 mov al, [R2Type]
  1562 000015D7 3C02                     cmp al, 2
  1563 000015D9 0F840300                 je  @@getIndReg240
  1564 000015DD E84911                   call indexerror
  1565                                  
  1566                                  ;-104     if (R2No==7) if (rm==6) m=3;//BP+DI
  1567                                  
  1568                                  @@getIndReg240:
  1569 000015E0 A0[B201]                 mov al, [R2No]
  1570 000015E3 3C07                     cmp al, 7
  1571 000015E5 0F852700                 jne @@getIndReg241
  1572 000015E9 A0[BA01]                 mov al, [rm]
  1573 000015EC 3C06                     cmp al, 6
  1574 000015EE 0F850C00                 jne @@getIndReg242
  1575 000015F2 66B803000000             mov eax, 3
  1576 000015F8 8846FE                   mov byte [bp-2], al
  1577                                  
  1578                                  ;-105              else if (rm==7) m=1;//BX+DI
  1579                                  
  1580 000015FB E91200                   jmp @@getIndReg243
  1581                                  @@getIndReg242:
  1582 000015FE A0[BA01]                 mov al, [rm]
  1583 00001601 3C07                     cmp al, 7
  1584 00001603 0F850900                 jne @@getIndReg244
  1585 00001607 66B801000000             mov eax, 1
  1586 0000160D 8846FE                   mov byte [bp-2], al
  1587                                  
  1588                                  ;-106     if (R2No==6) if (rm==6) m=2;//BP+SI
  1589                                  
  1590                                  @@getIndReg244:
  1591                                  @@getIndReg243:
  1592                                  @@getIndReg241:
  1593 00001610 A0[B201]                 mov al, [R2No]
  1594 00001613 3C06                     cmp al, 6
  1595 00001615 0F852700                 jne @@getIndReg245
  1596 00001619 A0[BA01]                 mov al, [rm]
  1597 0000161C 3C06                     cmp al, 6
  1598 0000161E 0F850C00                 jne @@getIndReg246
  1599 00001622 66B802000000             mov eax, 2
  1600 00001628 8846FE                   mov byte [bp-2], al
  1601                                  
  1602                                  ;-107              else if (rm==7) m=0;//BX+SI
  1603                                  
  1604 0000162B E91200                   jmp @@getIndReg247
  1605                                  @@getIndReg246:
  1606 0000162E A0[BA01]                 mov al, [rm]
  1607 00001631 3C07                     cmp al, 7
  1608 00001633 0F850900                 jne @@getIndReg248
  1609 00001637 66B800000000             mov eax, 0
  1610 0000163D 8846FE                   mov byte [bp-2], al
  1611                                  
  1612                                  ;-108     if (m > 3) indexerror();
  1613                                  
  1614                                  @@getIndReg248:
  1615                                  @@getIndReg247:
  1616                                  @@getIndReg245:
  1617 00001640 8A46FE                   mov al, [bp-2]
  1618 00001643 3C03                     cmp al, 3
  1619 00001645 0F8E0300                 jle @@getIndReg249
  1620 00001649 E8DD10                   call indexerror
  1621                                  
  1622                                  ;-109     return m;
  1623                                  
  1624                                  @@getIndReg249:
  1625 0000164C 8A46FE                   mov al, [bp-2]
  1626 0000164F E90000                   jmp @@retn
  1627                                  
  1628                                  ;-110 }
  1629                                  
  1630                                  
  1631                                  ;-111                   
  1632                                  
  1633                                  
  1634                                  ;-112 int setwflag() {//word size, bit 0
  1635                                  
  1636 00001652 C9                      @@retn: LEAVE
  1637 00001653 C3                       ret
  1638                                  ; ENDP
  1639                                  
  1640                                  setwflag:  ; *** PROC ***
  1641                                  
  1642                                  ;-113     wflag=0;
  1643                                  
  1644 00001654 66B800000000             mov eax, 0
  1645 0000165A A2[B701]                 mov byte [wflag], al
  1646                                  
  1647                                  ;-114     if (OpSize == 0) {//do not override OpSize
  1648                                  
  1649 0000165D A0[B601]                 mov al, [OpSize]
  1650 00001660 3C00                     cmp al, 0
  1651 00001662 0F854200                 jne @@setwflag50
  1652                                  
  1653                                  ;-115         if (Op == REG) OpSize=R1Type;
  1654                                  
  1655 00001666 A0[AC01]                 mov al, [Op]
  1656 00001669 3C02                     cmp al, 2
  1657 0000166B 0F850600                 jne @@setwflag51
  1658 0000166F A0[B501]                 mov al, [R1Type]
  1659 00001672 A2[B601]                 mov byte [OpSize], al
  1660                                  
  1661                                  ;-116         if (Op2== REG) OpSize=R2Type;        
  1662                                  
  1663                                  @@setwflag51:
  1664 00001675 A0[AD01]                 mov al, [Op2]
  1665 00001678 3C02                     cmp al, 2
  1666 0000167A 0F850600                 jne @@setwflag52
  1667 0000167E A0[B401]                 mov al, [R2Type]
  1668 00001681 A2[B601]                 mov byte [OpSize], al
  1669                                  
  1670                                  ;-117         if (R2Type== SEGREG) OpSize=WORD;
  1671                                  
  1672                                  @@setwflag52:
  1673 00001684 A0[B401]                 mov al, [R2Type]
  1674 00001687 3C04                     cmp al, 4
  1675 00001689 0F850900                 jne @@setwflag53
  1676 0000168D 66B802000000             mov eax, 2
  1677 00001693 A2[B601]                 mov byte [OpSize], al
  1678                                  
  1679                                  ;-118         if (R1Type == SEGREG) OpSize=WORD;        
  1680                                  
  1681                                  @@setwflag53:
  1682 00001696 A0[B501]                 mov al, [R1Type]
  1683 00001699 3C04                     cmp al, 4
  1684 0000169B 0F850900                 jne @@setwflag54
  1685 0000169F 66B802000000             mov eax, 2
  1686 000016A5 A2[B601]                 mov byte [OpSize], al
  1687                                  
  1688                                  ;-119     }
  1689                                  
  1690                                  @@setwflag54:
  1691                                  
  1692                                  ;-120     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1693                                  
  1694                                  @@setwflag50:
  1695 000016A8 A0[B601]                 mov al, [OpSize]
  1696 000016AB 3C03                     cmp al, 3
  1697 000016AD 0F850C00                 jne @@setwflag55
  1698 000016B1 E82015                   call gen66h
  1699 000016B4 66B801000000             mov eax, 1
  1700 000016BA A2[B701]                 mov byte [wflag], al
  1701                                  
  1702                                  ;-121     if (OpSize  ==  WORD) wflag=1;
  1703                                  
  1704                                  @@setwflag55:
  1705 000016BD A0[B601]                 mov al, [OpSize]
  1706 000016C0 3C02                     cmp al, 2
  1707 000016C2 0F850900                 jne @@setwflag56
  1708 000016C6 66B801000000             mov eax, 1
  1709 000016CC A2[B701]                 mov byte [wflag], al
  1710                                  
  1711                                  ;-122 }
  1712                                  
  1713                                  @@setwflag56:
  1714                                  
  1715                                  ;-123 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3     
  1716                                  
  1717 000016CF C3                       ret
  1718                                  ; ENDP
  1719                                  
  1720                                  setsflag:  ; *** PROC ***
  1721                                  
  1722                                  ;-124     sflag=2;  
  1723                                  
  1724 000016D0 66B802000000             mov eax, 2
  1725 000016D6 A2[B901]                 mov byte [sflag], al
  1726                                  
  1727                                  ;-125     if(imme > 127) sflag = 0;
  1728                                  
  1729 000016D9 A1[BE01]                 mov ax, [imme]
  1730 000016DC 83F87F                   cmp ax, 127
  1731 000016DF 0F8E0900                 jle @@setsflag57
  1732 000016E3 66B800000000             mov eax, 0
  1733 000016E9 A2[B901]                 mov byte [sflag], al
  1734                                  
  1735                                  ;-126     if (OpSize == BYTE) {
  1736                                  
  1737                                  @@setsflag57:
  1738 000016EC A0[B601]                 mov al, [OpSize]
  1739 000016EF 3C01                     cmp al, 1
  1740 000016F1 0F851C00                 jne @@setsflag58
  1741                                  
  1742                                  ;-127         if (imme > 255) error1("too big for byte r/m");
  1743                                  
  1744 000016F5 A1[BE01]                 mov ax, [imme]
  1745 000016F8 3DFF00                   cmp ax, 255
  1746 000016FB 0F8E0900                 jle @@setsflag59
  1747 000016FF 68[1217]                 push setsflag_0
  1748 00001702 E83A0F                   call error1
  1749 00001705 83C402                   add  sp, 2
  1750                                  
  1751                                  ;-128         sflag=0;//byte reg does not need sign extended   
  1752                                  
  1753                                  @@setsflag59:
  1754 00001708 66B800000000             mov eax, 0
  1755 0000170E A2[B901]                 mov byte [sflag], al
  1756                                  
  1757                                  ;-129     }
  1758                                  
  1759                                  
  1760                                  ;-130 }
  1761                                  
  1762                                  @@setsflag58:
  1763 00001711 C3                       ret
  1764                                  ; ENDP
  1765 00001712 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1766 0000171B 6F7220627974652072-
  1767 00001724 2F6D00             
  1768                                  ;Back to main program: AS.C
  1769                                  
  1770                                  ;-5 #include "PARSE.C"
  1771                                  
  1772                                  ;Use include file: PARSE.C
  1773                                  
  1774                                  ;-1 int parse() {
  1775                                  
  1776                                  
  1777                                  parse:  ; *** PROC ***
  1778                                  
  1779                                  ;-2   LabelNamePtr= &LabelNames;
  1780                                  
  1781 00001727 B8[CA01]                 mov ax, LabelNames
  1782 0000172A A3[B205]                 mov word [LabelNamePtr], ax
  1783                                  
  1784                                  ;-3   do {
  1785                                  
  1786                                  @@parse60:
  1787                                  
  1788                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  1789                                  
  1790 0000172D A1[A601]                 mov ax, [PC]
  1791 00001730 A3[A801]                 mov word [PCStart], ax
  1792 00001733 66B800000000             mov eax, 0
  1793 00001739 A2[B601]                 mov byte [OpSize], al
  1794 0000173C 66B800000000             mov eax, 0
  1795 00001742 A3[C501]                 mov word [OpPrintIndex], ax
  1796 00001745 66B820000000             mov eax, 32
  1797 0000174B A2[C901]                 mov byte [PrintR], al
  1798                                  
  1799                                  ;-5     getLine();
  1800                                  
  1801 0000174E E82C05                   call getLine
  1802                                  
  1803                                  ;-6     InputPtr = &InputBuf;
  1804                                  
  1805 00001751 B8[4F00]                 mov ax, InputBuf
  1806 00001754 A3[CE00]                 mov word [InputPtr], ax
  1807                                  
  1808                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1809                                  
  1810 00001757 E8B700                   call getTokeType
  1811                                  
  1812                                  ;-8     if (TokeType == ALNUME) {
  1813                                  
  1814 0000175A A0[AB01]                 mov al, [TokeType]
  1815 0000175D 3C03                     cmp al, 3
  1816 0000175F 0F851300                 jne @@parse61
  1817                                  
  1818                                  ;-9       if (isLabel) { //set in getName
  1819                                  
  1820 00001763 A0[AA01]                 mov al, [isLabel]
  1821 00001766 08C0                     or  al, al
  1822 00001768 0F840A00                 je @@parse62
  1823                                  
  1824                                  ;-10         storeLabel();
  1825                                  
  1826 0000176C E84001                   call storeLabel
  1827                                  
  1828                                  ;-11         InputPtr++;//remove :
  1829                                  
  1830 0000176F FF06[CE00]               inc  word [InputPtr]
  1831                                  
  1832                                  ;-12         getTokeType();
  1833                                  
  1834 00001773 E89B00                   call getTokeType
  1835                                  
  1836                                  ;-13       }
  1837                                  
  1838                                  
  1839                                  ;-14     }
  1840                                  
  1841                                  @@parse62:
  1842                                  
  1843                                  ;-15     if (TokeType == ALNUME) {
  1844                                  
  1845                                  @@parse61:
  1846 00001776 A0[AB01]                 mov al, [TokeType]
  1847 00001779 3C03                     cmp al, 3
  1848 0000177B 0F851B00                 jne @@parse63
  1849                                  
  1850                                  ;-16       lookCode();// and OpCodePtr
  1851                                  
  1852 0000177F E86803                   call lookCode
  1853                                  
  1854                                  ;-17       if(CodeType) process();
  1855                                  
  1856 00001782 A0[AE01]                 mov al, [CodeType]
  1857 00001785 08C0                     or  al, al
  1858 00001787 0F840600                 je @@parse64
  1859 0000178B E84E16                   call process
  1860                                  
  1861                                  ;-18       else getVariable();
  1862                                  
  1863 0000178E E90300                   jmp @@parse65
  1864                                  @@parse64:
  1865 00001791 E81E02                   call getVariable
  1866                                  
  1867                                  ;-19       skipRest();
  1868                                  
  1869                                  @@parse65:
  1870 00001794 E8BD04                   call skipRest
  1871                                  
  1872                                  ;-20     }
  1873                                  
  1874                                  
  1875                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1876                                  
  1877 00001797 E92700                   jmp @@parse66
  1878                                  @@parse63:
  1879 0000179A A0[AB01]                 mov al, [TokeType]
  1880 0000179D 3C03                     cmp al, 3
  1881 0000179F 0F8E0C00                 jle @@parse67
  1882 000017A3 68[D217]                 push parse_0
  1883 000017A6 E8960E                   call error1
  1884 000017A9 83C402                   add  sp, 2
  1885                                  
  1886                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1887                                  
  1888 000017AC E91200                   jmp @@parse68
  1889                                  @@parse67:
  1890 000017AF A0[AB01]                 mov al, [TokeType]
  1891 000017B2 3C01                     cmp al, 1
  1892 000017B4 0F850900                 jne @@parse69
  1893 000017B8 68[F017]                 push parse_1
  1894 000017BB E8810E                   call error1
  1895 000017BE 83C402                   add  sp, 2
  1896                                  
  1897                                  ;-23     printLine();
  1898                                  
  1899                                  @@parse69:
  1900                                  @@parse68:
  1901                                  @@parse66:
  1902 000017C1 E80C0C                   call printLine
  1903                                  
  1904                                  ;-24   } while (DOS_NoBytes != 0 );
  1905                                  
  1906 000017C4 A1[A301]                 mov ax, [DOS_NoBytes]
  1907 000017C7 83F800                   cmp ax, 0
  1908 000017CA 0F840300                 je  @@parse70
  1909 000017CE E95CFF                   jmp @@parse60
  1910                                  @@parse70:
  1911                                  
  1912                                  ;-25 }
  1913                                  
  1914                                  
  1915                                  ;-26 // scan code .....................................
  1916                                  
  1917                                  
  1918                                  ;-27 int getTokeType() { char c;
  1919                                  
  1920 000017D1 C3                       ret
  1921                                  ; ENDP
  1922 000017D2 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1923 000017DB 696E73747275637469-
  1924 000017E4 6F6E20657870656374-
  1925 000017ED 656400             
  1926 000017F0 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1927 000017F9 616C6C6F7765642040-
  1928 00001802 207374617274206F66-
  1929 0000180B 206C696E6500       
  1930                                  
  1931                                  getTokeType:  ; *** PROC ***
  1932                                  
  1933                                  ;-28   skipBlank();
  1934                                  
  1935                                  ;Function : getTokeType, Number of local variables: 1
  1936                                  ;   # type sign width line used address name   list of local variables
  1937                                  ;  200 var sign byte    27 NULL bp-2    c;
  1938 00001811 C8020000                 ENTER  2,0
  1939 00001815 E86705                   call skipBlank
  1940                                  
  1941                                  ;-29   c = *InputPtr;
  1942                                  
  1943 00001818 8B1E[CE00]               mov bx, [InputPtr]
  1944 0000181C 8A07                     mov al, [bx]
  1945 0000181E B400                     mov ah, 0
  1946 00001820 8846FE                   mov byte [bp-2], al
  1947                                  
  1948                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1949                                  
  1950 00001823 8A46FE                   mov al, [bp-2]
  1951 00001826 3C00                     cmp al, 0
  1952 00001828 0F850C00                 jne @@getTokeType71
  1953 0000182C 66B800000000             mov eax, 0
  1954 00001832 A2[AB01]                 mov byte [TokeType], al
  1955 00001835 E97500                   jmp @@retn
  1956                                  
  1957                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1958                                  
  1959                                  @@getTokeType71:
  1960 00001838 8A46FE                   mov al, [bp-2]
  1961 0000183B 3C3B                     cmp al, 59
  1962 0000183D 0F850C00                 jne @@getTokeType72
  1963 00001841 66B800000000             mov eax, 0
  1964 00001847 A2[AB01]                 mov byte [TokeType], al
  1965 0000184A E96000                   jmp @@retn
  1966                                  
  1967                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1968                                  
  1969                                  @@getTokeType72:
  1970 0000184D 8A46FE                   mov al, byte [bp-2]
  1971 00001850 B400                     mov ah, 0
  1972 00001852 50                       push ax
  1973 00001853 E85E1A                   call digit
  1974 00001856 83C402                   add  sp, 2
  1975 00001859 08C0                     or  al, al
  1976 0000185B 0F841800                 je @@getTokeType73
  1977 0000185F 8A46FE                   mov al, byte [bp-2]
  1978 00001862 B400                     mov ah, 0
  1979 00001864 50                       push ax
  1980 00001865 E81D06                   call getDigit
  1981 00001868 83C402                   add  sp, 2
  1982 0000186B 66B801000000             mov eax, 1
  1983 00001871 A2[AB01]                 mov byte [TokeType], al
  1984 00001874 E93600                   jmp @@retn
  1985                                  
  1986                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1987                                  
  1988                                  @@getTokeType73:
  1989 00001877 8A46FE                   mov al, byte [bp-2]
  1990 0000187A B400                     mov ah, 0
  1991 0000187C 50                       push ax
  1992 0000187D E82A05                   call letterE
  1993 00001880 83C402                   add  sp, 2
  1994 00001883 08C0                     or  al, al
  1995 00001885 0F841800                 je @@getTokeType74
  1996 00001889 8A46FE                   mov al, byte [bp-2]
  1997 0000188C B400                     mov ah, 0
  1998 0000188E 50                       push ax
  1999 0000188F E84A06                   call getName
  2000 00001892 83C402                   add  sp, 2
  2001 00001895 66B803000000             mov eax, 3
  2002 0000189B A2[AB01]                 mov byte [TokeType], al
  2003 0000189E E90C00                   jmp @@retn
  2004                                  
  2005                                  ;-34   TokeType=NOALNUME; return;
  2006                                  
  2007                                  @@getTokeType74:
  2008 000018A1 66B804000000             mov eax, 4
  2009 000018A7 A2[AB01]                 mov byte [TokeType], al
  2010 000018AA E90000                   jmp @@retn
  2011                                  
  2012                                  ;-35 }
  2013                                  
  2014                                  
  2015                                  ;-36 int storeLabel() {unsigned int i;
  2016                                  
  2017 000018AD C9                      @@retn: LEAVE
  2018 000018AE C3                       ret
  2019                                  ; ENDP
  2020                                  
  2021                                  storeLabel:  ; *** PROC ***
  2022                                  
  2023                                  ;-37   if(searchLabel()) error1("duplicate label");
  2024                                  
  2025                                  ;Function : storeLabel, Number of local variables: 1
  2026                                  ;   # type sign width line used address name   list of local variables
  2027                                  ;  200 var unsg word    36 NULL bp-2    i;
  2028 000018AF C8020000                 ENTER  2,0
  2029 000018B3 E89C00                   call searchLabel
  2030 000018B6 08C0                     or  al, al
  2031 000018B8 0F840900                 je @@storeLabel75
  2032 000018BC 68[1D19]                 push storeLabel_0
  2033 000018BF E87D0D                   call error1
  2034 000018C2 83C402                   add  sp, 2
  2035                                  
  2036                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2037                                  
  2038                                  @@storeLabel75:
  2039 000018C5 8D06[0F00]               lea  ax, [Symbol]
  2040 000018C9 50                       push ax
  2041 000018CA FF36[B205]               push word [LabelNamePtr]
  2042 000018CE E8AA19                   call strcpy
  2043 000018D1 83C404                   add  sp, 4
  2044 000018D4 A3[B205]                 mov word [LabelNamePtr], ax
  2045                                  
  2046                                  ;-39   LabelNamePtr++;
  2047                                  
  2048 000018D7 FF06[B205]               inc  word [LabelNamePtr]
  2049                                  
  2050                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  2051                                  
  2052 000018DB A1[B205]                 mov ax, [LabelNamePtr]
  2053 000018DE 2D[CA01]                 sub ax, LabelNames
  2054 000018E1 8946FE                   mov word [bp-2], ax
  2055                                  
  2056                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  2057                                  
  2058 000018E4 8B46FE                   mov ax, [bp-2]
  2059 000018E7 3DC903                   cmp ax, 969 ;unsigned : 0
  2060 000018EA 0F820900                 jb  @@storeLabel76
  2061 000018EE 68[2D19]                 push storeLabel_1
  2062 000018F1 E8AA0D                   call errorexit
  2063 000018F4 83C402                   add  sp, 2
  2064                                  
  2065                                  ;-42   LabelMaxIx++;
  2066                                  
  2067                                  @@storeLabel76:
  2068 000018F7 FF06[7C06]               inc  word [LabelMaxIx]
  2069                                  
  2070                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2071                                  
  2072 000018FB A1[7C06]                 mov ax, [LabelMaxIx]
  2073 000018FE 83F864                   cmp ax, 100 ;unsigned : 1
  2074 00001901 0F8C0900                 jl  @@storeLabel77
  2075 00001905 68[4219]                 push storeLabel_2
  2076 00001908 E8930D                   call errorexit
  2077 0000190B 83C402                   add  sp, 2
  2078                                  
  2079                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  2080                                  
  2081                                  @@storeLabel77:
  2082 0000190E A1[A601]                 mov ax, [PC]
  2083 00001911 8B1E[7C06]               mov bx, [LabelMaxIx]
  2084 00001915 D1E3                     shl bx, 1
  2085 00001917 8987[B405]               mov [LabelAddr+bx], ax
  2086                                  
  2087                                  ;-45 }
  2088                                  
  2089                                  
  2090                                  ;-46 int searchLabel() {
  2091 0000191B C9                       LEAVE
  2092 0000191C C3                       ret
  2093                                  ; ENDP
  2094 0000191D 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2095 00001926 206C6162656C00     
  2096 0000192D 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2097 00001936 6C6162656C206E616D-
  2098 0000193F 657300             
  2099 00001942 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2100 0000194B 6C6162656C7300     
  2101                                  
  2102                                  searchLabel:  ; *** PROC ***
  2103                                  
  2104                                  ;-47   int LIx; char *p; int j;
  2105                                  
  2106                                  
  2107                                  ;-48   p = &LabelNames;
  2108                                  
  2109                                  ;Function : searchLabel, Number of local variables: 3
  2110                                  ;   # type sign width line used address name   list of local variables
  2111                                  ;  200 var sign word    47 NULL bp-2    LIx
  2112                                  ;  201 ptr sign byte    47 NULL bp-4    p
  2113                                  ;  202 var sign word    47 NULL bp-6    j;
  2114 00001952 C8060000                 ENTER  6,0
  2115 00001956 B8[CA01]                 mov ax, LabelNames
  2116 00001959 8946FC                   mov word [bp-4], ax
  2117                                  
  2118                                  ;-49   LIx=1;
  2119                                  
  2120 0000195C 66B801000000             mov eax, 1
  2121 00001962 8946FE                   mov word [bp-2], ax
  2122                                  
  2123                                  ;-50   while (LIx <= LabelMaxIx) {
  2124                                  
  2125                                  @@searchLabel78:
  2126 00001965 8B46FE                   mov ax, [bp-2]
  2127 00001968 3B06[7C06]               cmp ax, [LabelMaxIx]
  2128 0000196C 0F8F3700                 jg  @@searchLabel79
  2129                                  
  2130                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  2131                                  
  2132 00001970 8D06[0F00]               lea  ax, [Symbol]
  2133 00001974 50                       push ax
  2134 00001975 FF76FC                   push word [bp-4]
  2135 00001978 E86C19                   call eqstr
  2136 0000197B 83C404                   add  sp, 4
  2137 0000197E 08C0                     or  al, al
  2138 00001980 0F840600                 je @@searchLabel80
  2139 00001984 8B46FE                   mov ax, [bp-2]
  2140 00001987 E92600                   jmp @@retn
  2141                                  
  2142                                  ;-52     j=strlen(p);
  2143                                  
  2144                                  @@searchLabel80:
  2145 0000198A FF76FC                   push word [bp-4]
  2146 0000198D E8C018                   call strlen
  2147 00001990 83C402                   add  sp, 2
  2148 00001993 8946FA                   mov word [bp-6], ax
  2149                                  
  2150                                  ;-53     p=p+j; p++; LIx++;
  2151                                  
  2152 00001996 8B46FC                   mov ax, [bp-4]
  2153 00001999 0346FA                   add ax, [bp-6]
  2154 0000199C 8946FC                   mov word [bp-4], ax
  2155 0000199F FF46FC                   inc  word [bp-4]
  2156 000019A2 FF46FE                   inc  word [bp-2]
  2157                                  
  2158                                  ;-54   }
  2159                                  
  2160                                  
  2161                                  ;-55   return 0;
  2162                                  
  2163 000019A5 EBBE                     jmp @@searchLabel78
  2164                                  @@searchLabel79:
  2165 000019A7 66B800000000             mov eax, 0
  2166 000019AD E90000                   jmp @@retn
  2167                                  
  2168                                  ;-56 }
  2169                                  
  2170                                  
  2171                                  ;-57 int getVariable() { char c;
  2172                                  
  2173 000019B0 C9                      @@retn: LEAVE
  2174 000019B1 C3                       ret
  2175                                  ; ENDP
  2176                                  
  2177                                  getVariable:  ; *** PROC ***
  2178                                  
  2179                                  ;-58   storeLabel();
  2180                                  
  2181                                  ;Function : getVariable, Number of local variables: 1
  2182                                  ;   # type sign width line used address name   list of local variables
  2183                                  ;  200 var sign byte    57 NULL bp-2    c;
  2184 000019B2 C8020000                 ENTER  2,0
  2185 000019B6 E8F6FE                   call storeLabel
  2186                                  
  2187                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  2188                                  
  2189 000019B9 E855FE                   call getTokeType
  2190 000019BC A0[AB01]                 mov al, [TokeType]
  2191 000019BF 3C03                     cmp al, 3
  2192 000019C1 0F85CC00                 jne @@getVariable81
  2193                                  
  2194                                  ;-60     lookCode();
  2195                                  
  2196 000019C5 E82201                   call lookCode
  2197                                  
  2198                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2199                                  
  2200 000019C8 A0[AE01]                 mov al, [CodeType]
  2201 000019CB 3CC8                     cmp al, 200
  2202 000019CD 0F8D0900                 jge @@getVariable82
  2203 000019D1 68[9C1A]                 push getVariable_0
  2204 000019D4 E8C70C                   call errorexit
  2205 000019D7 83C402                   add  sp, 2
  2206                                  
  2207                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2208                                  
  2209                                  @@getVariable82:
  2210 000019DA A0[AE01]                 mov al, [CodeType]
  2211 000019DD 3CCF                     cmp al, 207
  2212 000019DF 0F8E0900                 jle @@getVariable83
  2213 000019E3 68[B41A]                 push getVariable_1
  2214 000019E6 E8B50C                   call errorexit
  2215 000019E9 83C402                   add  sp, 2
  2216                                  
  2217                                  ;-63     if (CodeType== 200) {// DB
  2218                                  
  2219                                  @@getVariable83:
  2220 000019EC A0[AE01]                 mov al, [CodeType]
  2221 000019EF 3CC8                     cmp al, 200
  2222 000019F1 0F856A00                 jne @@getVariable84
  2223                                  
  2224                                  ;-64       do { getTokeType();
  2225                                  
  2226                                  @@getVariable85:
  2227 000019F5 E819FE                   call getTokeType
  2228                                  
  2229                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2230                                  
  2231 000019F8 A0[AB01]                 mov al, [TokeType]
  2232 000019FB 3C01                     cmp al, 1
  2233 000019FD 0F850D00                 jne @@getVariable86
  2234 00001A01 FF36[4D00]               push word [SymbolInt]
  2235 00001A05 E80C12                   call genCode8
  2236 00001A08 83C402                   add  sp, 2
  2237                                  
  2238                                  ;-66         else {
  2239                                  
  2240 00001A0B E94100                   jmp @@getVariable87
  2241                                  @@getVariable86:
  2242                                  
  2243                                  ;-67           skipBlank();
  2244                                  
  2245 00001A0E E86E03                   call skipBlank
  2246                                  
  2247                                  ;-68           if (isToken('"')) {
  2248                                  
  2249 00001A11 6A22                     push 34
  2250 00001A13 E8D101                   call isToken
  2251 00001A16 83C402                   add  sp, 2
  2252 00001A19 08C0                     or  al, al
  2253 00001A1B 0F843000                 je @@getVariable88
  2254                                  
  2255                                  ;-69             do { c= *InputPtr;
  2256                                  
  2257                                  @@getVariable89:
  2258 00001A1F 8B1E[CE00]               mov bx, [InputPtr]
  2259 00001A23 8A07                     mov al, [bx]
  2260 00001A25 B400                     mov ah, 0
  2261 00001A27 8846FE                   mov byte [bp-2], al
  2262                                  
  2263                                  ;-70               genCode8(c);
  2264                                  
  2265 00001A2A 8A46FE                   mov al, byte [bp-2]
  2266 00001A2D B400                     mov ah, 0
  2267 00001A2F 50                       push ax
  2268 00001A30 E8E111                   call genCode8
  2269 00001A33 83C402                   add  sp, 2
  2270                                  
  2271                                  ;-71               InputPtr++;
  2272                                  
  2273 00001A36 FF06[CE00]               inc  word [InputPtr]
  2274                                  
  2275                                  ;-72             } while (*InputPtr != '"' );
  2276                                  
  2277 00001A3A 8B1E[CE00]               mov bx, [InputPtr]
  2278 00001A3E 8A07                     mov al, [bx]
  2279 00001A40 B400                     mov ah, 0
  2280 00001A42 83F822                   cmp ax, 34
  2281 00001A45 0F840200                 je  @@getVariable90
  2282 00001A49 EBD4                     jmp @@getVariable89
  2283                                  @@getVariable90:
  2284                                  
  2285                                  ;-73             InputPtr++;
  2286                                  
  2287 00001A4B FF06[CE00]               inc  word [InputPtr]
  2288                                  
  2289                                  ;-74           }
  2290                                  
  2291                                  
  2292                                  ;-75         }
  2293                                  
  2294                                  @@getVariable88:
  2295                                  
  2296                                  ;-76       } while (isToken(','));
  2297                                  
  2298                                  @@getVariable87:
  2299 00001A4F 6A2C                     push 44
  2300 00001A51 E89301                   call isToken
  2301 00001A54 83C402                   add  sp, 2
  2302 00001A57 08C0                     or  al, al
  2303 00001A59 0F840200                 je @@getVariable91
  2304 00001A5D EB96                     jmp @@getVariable85
  2305                                  @@getVariable91:
  2306                                  
  2307                                  ;-77     }
  2308                                  
  2309                                  
  2310                                  ;-78     if (CodeType== 201) {// DW
  2311                                  
  2312                                  @@getVariable84:
  2313 00001A5F A0[AE01]                 mov al, [CodeType]
  2314 00001A62 3CC9                     cmp al, 201
  2315 00001A64 0F852600                 jne @@getVariable92
  2316                                  
  2317                                  ;-79       do { getTokeType();
  2318                                  
  2319                                  @@getVariable93:
  2320 00001A68 E8A6FD                   call getTokeType
  2321                                  
  2322                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2323                                  
  2324 00001A6B A0[AB01]                 mov al, [TokeType]
  2325 00001A6E 3C01                     cmp al, 1
  2326 00001A70 0F850A00                 jne @@getVariable94
  2327 00001A74 FF36[4D00]               push word [SymbolInt]
  2328 00001A78 E8F011                   call genCode16
  2329 00001A7B 83C402                   add  sp, 2
  2330                                  
  2331                                  ;-81       } while (isToken(','));
  2332                                  
  2333                                  @@getVariable94:
  2334 00001A7E 6A2C                     push 44
  2335 00001A80 E86401                   call isToken
  2336 00001A83 83C402                   add  sp, 2
  2337 00001A86 08C0                     or  al, al
  2338 00001A88 0F840200                 je @@getVariable95
  2339 00001A8C EBDA                     jmp @@getVariable93
  2340                                  @@getVariable95:
  2341                                  
  2342                                  ;-82     }
  2343                                  
  2344                                  
  2345                                  ;-83   }
  2346                                  
  2347                                  @@getVariable92:
  2348                                  
  2349                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  2350                                  
  2351 00001A8E E90900                   jmp @@getVariable96
  2352                                  @@getVariable81:
  2353 00001A91 68[CC1A]                 push getVariable_2
  2354 00001A94 E8070C                   call errorexit
  2355 00001A97 83C402                   add  sp, 2
  2356                                  
  2357                                  ;-85 }
  2358                                  
  2359                                  @@getVariable96:
  2360                                  
  2361                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  2362 00001A9A C9                       LEAVE
  2363 00001A9B C3                       ret
  2364                                  ; ENDP
  2365 00001A9C 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2366 00001AA5 422C572C4420657870-
  2367 00001AAE 656374656400       
  2368 00001AB4 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2369 00001ABD 422C572C4420657870-
  2370 00001AC6 656374656400       
  2371 00001ACC 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2372 00001AD5 6F7220524553422C57-
  2373 00001ADE 2C4420657870656374-
  2374 00001AE7 656400             
  2375                                  
  2376                                  lookCode:  ; *** PROC ***
  2377                                  
  2378                                  ;-87   CodeType=0;
  2379                                  
  2380 00001AEA 66B800000000             mov eax, 0
  2381 00001AF0 A2[AE01]                 mov byte [CodeType], al
  2382                                  
  2383                                  ;-88   OpCodePtr= &I_START;
  2384                                  
  2385 00001AF3 B8[560E]                 mov ax, I_START
  2386 00001AF6 A3[C701]                 mov word [OpCodePtr], ax
  2387                                  
  2388                                  ;-89   OpCodePtr++;
  2389                                  
  2390 00001AF9 FF06[C701]               inc  word [OpCodePtr]
  2391                                  
  2392                                  ;-90   do  {
  2393                                  
  2394                                  @@lookCode97:
  2395                                  
  2396                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  2397                                  
  2398 00001AFD FF36[C701]               push word [OpCodePtr]
  2399 00001B01 8D06[2E00]               lea  ax, [SymbolUpper]
  2400 00001B05 50                       push ax
  2401 00001B06 E8DE17                   call eqstr
  2402 00001B09 83C404                   add  sp, 4
  2403 00001B0C 08C0                     or  al, al
  2404 00001B0E 0F842700                 je @@lookCode98
  2405                                  
  2406                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  2407                                  
  2408                                  @@lookCode99:
  2409 00001B12 8B1E[C701]               mov bx, [OpCodePtr]
  2410 00001B16 8A07                     mov al, [bx]
  2411 00001B18 B400                     mov ah, 0
  2412 00001B1A 83F800                   cmp ax, 0
  2413 00001B1D 0F840600                 je  @@lookCode100
  2414 00001B21 FF06[C701]               inc  word [OpCodePtr]
  2415                                  
  2416                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  2417                                  
  2418 00001B25 EBEB                     jmp @@lookCode99
  2419                                  @@lookCode100:
  2420 00001B27 FF06[C701]               inc  word [OpCodePtr]
  2421 00001B2B 8B1E[C701]               mov bx, [OpCodePtr]
  2422 00001B2F 8A07                     mov al, [bx]
  2423 00001B31 B400                     mov ah, 0
  2424 00001B33 A2[AE01]                 mov byte [CodeType], al
  2425                                  
  2426                                  ;-94       return;
  2427                                  
  2428 00001B36 E92A00                   jmp @@retn
  2429                                  
  2430                                  ;-95     }
  2431                                  
  2432                                  
  2433                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2434                                  
  2435                                  @@lookCode98:
  2436                                  @@lookCode101:
  2437 00001B39 8B1E[C701]               mov bx, [OpCodePtr]
  2438 00001B3D 8A07                     mov al, [bx]
  2439 00001B3F B400                     mov ah, 0
  2440 00001B41 3DF100                   cmp ax, 241
  2441 00001B44 0F840600                 je  @@lookCode102
  2442 00001B48 FF06[C701]               inc  word [OpCodePtr]
  2443                                  
  2444                                  ;-97   OpCodePtr++;
  2445                                  
  2446 00001B4C EBEB                     jmp @@lookCode101
  2447                                  @@lookCode102:
  2448 00001B4E FF06[C701]               inc  word [OpCodePtr]
  2449                                  
  2450                                  ;-98   } while(*OpCodePtr!=0);
  2451                                  
  2452 00001B52 8B1E[C701]               mov bx, [OpCodePtr]
  2453 00001B56 8A07                     mov al, [bx]
  2454 00001B58 B400                     mov ah, 0
  2455 00001B5A 83F800                   cmp ax, 0
  2456 00001B5D 0F840200                 je  @@lookCode103
  2457 00001B61 EB9A                     jmp @@lookCode97
  2458                                  @@lookCode103:
  2459                                  
  2460                                  ;-99 }
  2461                                  
  2462                                  
  2463                                  ;-100 
  2464                                  
  2465                                  
  2466                                  ;-101 int getCodeSize() {
  2467                                  
  2468                                  @@retn:
  2469 00001B63 C3                       ret
  2470                                  ; ENDP
  2471                                  
  2472                                  getCodeSize:  ; *** PROC ***
  2473                                  
  2474                                  ;-102   if (TokeType ==ALNUME) {
  2475                                  
  2476 00001B64 A0[AB01]                 mov al, [TokeType]
  2477 00001B67 3C03                     cmp al, 3
  2478 00001B69 0F856000                 jne @@getCodeSize104
  2479                                  
  2480                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2481                                  
  2482 00001B6D 68[D71B]                 push getCodeSize_0
  2483 00001B70 8D06[2E00]               lea  ax, [SymbolUpper]
  2484 00001B74 50                       push ax
  2485 00001B75 E86F17                   call eqstr
  2486 00001B78 83C404                   add  sp, 4
  2487 00001B7B 08C0                     or  al, al
  2488 00001B7D 0F840C00                 je @@getCodeSize105
  2489 00001B81 E88DFC                   call getTokeType
  2490 00001B84 66B801000000             mov eax, 1
  2491 00001B8A E94900                   jmp @@retn
  2492                                  
  2493                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2494                                  
  2495                                  @@getCodeSize105:
  2496 00001B8D 68[DC1B]                 push getCodeSize_1
  2497 00001B90 8D06[2E00]               lea  ax, [SymbolUpper]
  2498 00001B94 50                       push ax
  2499 00001B95 E84F17                   call eqstr
  2500 00001B98 83C404                   add  sp, 4
  2501 00001B9B 08C0                     or  al, al
  2502 00001B9D 0F840C00                 je @@getCodeSize106
  2503 00001BA1 E86DFC                   call getTokeType
  2504 00001BA4 66B802000000             mov eax, 2
  2505 00001BAA E92900                   jmp @@retn
  2506                                  
  2507                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2508                                  
  2509                                  @@getCodeSize106:
  2510 00001BAD 68[E11B]                 push getCodeSize_2
  2511 00001BB0 8D06[2E00]               lea  ax, [SymbolUpper]
  2512 00001BB4 50                       push ax
  2513 00001BB5 E82F17                   call eqstr
  2514 00001BB8 83C404                   add  sp, 4
  2515 00001BBB 08C0                     or  al, al
  2516 00001BBD 0F840C00                 je @@getCodeSize107
  2517 00001BC1 E84DFC                   call getTokeType
  2518 00001BC4 66B803000000             mov eax, 3
  2519 00001BCA E90900                   jmp @@retn
  2520                                  
  2521                                  ;-106   } return 0;
  2522                                  
  2523                                  @@getCodeSize107:
  2524                                  @@getCodeSize104:
  2525 00001BCD 66B800000000             mov eax, 0
  2526 00001BD3 E90000                   jmp @@retn
  2527                                  
  2528                                  ;-107 }
  2529                                  
  2530                                  
  2531                                  ;-108 int isToken(char c) {
  2532                                  
  2533                                  @@retn:
  2534 00001BD6 C3                       ret
  2535                                  ; ENDP
  2536 00001BD7 4259544500              getCodeSize_0 db "BYTE",0
  2537 00001BDC 574F524400              getCodeSize_1 db "WORD",0
  2538 00001BE1 44574F524400            getCodeSize_2 db "DWORD",0
  2539                                  
  2540                                  isToken:  ; *** PROC ***
  2541                                  
  2542                                  ;-109   skipBlank();
  2543                                  
  2544                                  ;Function : isToken, Number of local variables: 1
  2545                                  ;   # type sign width line used address name   list of local variables
  2546                                  ;  200 var sign byte   108 NULL bp+4    c;
  2547 00001BE7 C8000000                 ENTER  0,0
  2548 00001BEB E89101                   call skipBlank
  2549                                  
  2550                                  ;-110   if (*InputPtr == c) {
  2551                                  
  2552 00001BEE 8B1E[CE00]               mov bx, [InputPtr]
  2553 00001BF2 8A07                     mov al, [bx]
  2554 00001BF4 B400                     mov ah, 0
  2555 00001BF6 3A4604                   cmp al, [bp+4]
  2556 00001BF9 0F850D00                 jne @@isToken108
  2557                                  
  2558                                  ;-111     InputPtr++; return 1;} return 0;
  2559                                  
  2560 00001BFD FF06[CE00]               inc  word [InputPtr]
  2561 00001C01 66B801000000             mov eax, 1
  2562 00001C07 E90900                   jmp @@retn
  2563                                  @@isToken108:
  2564 00001C0A 66B800000000             mov eax, 0
  2565 00001C10 E90000                   jmp @@retn
  2566                                  
  2567                                  ;-112 }
  2568                                  
  2569                                  
  2570                                  ;-113 int need(char c) {
  2571                                  
  2572 00001C13 C9                      @@retn: LEAVE
  2573 00001C14 C3                       ret
  2574                                  ; ENDP
  2575                                  
  2576                                  need:  ; *** PROC ***
  2577                                  
  2578                                  ;-114   if (isToken(c)) {
  2579                                  
  2580                                  ;Function : need, Number of local variables: 1
  2581                                  ;   # type sign width line used address name   list of local variables
  2582                                  ;  200 var sign byte   113 NULL bp+4    c;
  2583 00001C15 C8000000                 ENTER  0,0
  2584 00001C19 8A4604                   mov al, byte [bp+4]
  2585 00001C1C B400                     mov ah, 0
  2586 00001C1E 50                       push ax
  2587 00001C1F E8C5FF                   call isToken
  2588 00001C22 83C402                   add  sp, 2
  2589 00001C25 08C0                     or  al, al
  2590 00001C27 0F840600                 je @@need109
  2591                                  
  2592                                  ;-115       getTokeType();
  2593                                  
  2594 00001C2B E8E3FB                   call getTokeType
  2595                                  
  2596                                  ;-116       return;
  2597                                  
  2598 00001C2E E91800                   jmp @@retn
  2599                                  
  2600                                  ;-117       }
  2601                                  
  2602                                  
  2603                                  ;-118   error1();
  2604                                  
  2605                                  @@need109:
  2606 00001C31 E80B0A                   call error1
  2607                                  
  2608                                  ;-119   prs(". need: ");
  2609                                  
  2610 00001C34 68[4B1C]                 push need_0
  2611 00001C37 E8A408                   call prs
  2612 00001C3A 83C402                   add  sp, 2
  2613                                  
  2614                                  ;-120   prc(c);
  2615                                  
  2616 00001C3D 8A4604                   mov al, byte [bp+4]
  2617 00001C40 B400                     mov ah, 0
  2618 00001C42 50                       push ax
  2619 00001C43 E83708                   call prc
  2620 00001C46 83C402                   add  sp, 2
  2621                                  
  2622                                  ;-121 }
  2623                                  
  2624                                  
  2625                                  ;-122 
  2626                                  
  2627                                  
  2628                                  ;-123 int skipRest() {
  2629                                  
  2630 00001C49 C9                      @@retn: LEAVE
  2631 00001C4A C3                       ret
  2632                                  ; ENDP
  2633 00001C4B 2E206E6565643A2000      need_0 db ". need: ",0
  2634                                  
  2635                                  skipRest:  ; *** PROC ***
  2636                                  
  2637                                  ;-124   getTokeType(); 
  2638                                  
  2639 00001C54 E8BAFB                   call getTokeType
  2640                                  
  2641                                  ;-125   if(TokeType)error1("extra char ignored");
  2642                                  
  2643 00001C57 A0[AB01]                 mov al, [TokeType]
  2644 00001C5A 08C0                     or  al, al
  2645 00001C5C 0F840900                 je @@skipRest110
  2646 00001C60 68[6A1C]                 push skipRest_0
  2647 00001C63 E8D909                   call error1
  2648 00001C66 83C402                   add  sp, 2
  2649                                  
  2650                                  ;-126 }
  2651                                  
  2652                                  @@skipRest110:
  2653 00001C69 C3                       ret
  2654                                  ; ENDP
  2655 00001C6A 657874726120636861-     skipRest_0 db "extra char ignored",0
  2656 00001C73 722069676E6F726564-
  2657 00001C7C 00                 
  2658                                  ;Back to main program: AS.C
  2659                                  
  2660                                  ;-6 #include "HELPER.C"
  2661                                  
  2662                                  ;Use include file: HELPER.C
  2663                                  
  2664                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2665                                  
  2666                                  
  2667                                  getLine:  ; *** PROC ***
  2668                                  
  2669                                  ;-2   unsigned int i;
  2670                                  
  2671                                  
  2672                                  ;-3   InputPtr= &InputBuf;
  2673                                  
  2674                                  ;Function : getLine, Number of local variables: 1
  2675                                  ;   # type sign width line used address name   list of local variables
  2676                                  ;  200 var unsg word     2 NULL bp-2    i;
  2677 00001C7D C8020000                 ENTER  2,0
  2678 00001C81 B8[4F00]                 mov ax, InputBuf
  2679 00001C84 A3[CE00]                 mov word [InputPtr], ax
  2680                                  
  2681                                  ;-4   *InputPtr=0;//if last line is empty
  2682                                  
  2683 00001C87 66B800000000             mov eax, 0
  2684 00001C8D 8B1E[CE00]               mov  bx, [InputPtr]
  2685 00001C91 8807                     mov  [bx], al
  2686                                  
  2687                                  ;-5   do {
  2688                                  
  2689                                  @@getLine111:
  2690                                  
  2691                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2692                                  
  2693 00001C93 6A01                     push 1
  2694 00001C95 FF36[9901]               push word [asm_fd]
  2695 00001C99 8D06[A501]               lea  ax, [DOS_ByteRead]
  2696 00001C9D 50                       push ax
  2697 00001C9E E8E116                   call readRL
  2698 00001CA1 83C406                   add  sp, 6
  2699 00001CA4 A3[A301]                 mov word [DOS_NoBytes], ax
  2700                                  
  2701                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2702                                  
  2703 00001CA7 A1[9F01]                 mov ax, [DOS_ERR]
  2704 00001CAA 08C0                     or  al, al
  2705 00001CAC 0F840900                 je @@getLine112
  2706 00001CB0 68[151D]                 push getLine_0
  2707 00001CB3 E8E809                   call errorexit
  2708 00001CB6 83C402                   add  sp, 2
  2709                                  
  2710                                  ;-8     if (DOS_NoBytes == 0) return;
  2711                                  
  2712                                  @@getLine112:
  2713 00001CB9 A1[A301]                 mov ax, [DOS_NoBytes]
  2714 00001CBC 83F800                   cmp ax, 0
  2715 00001CBF 0F850300                 jne @@getLine113
  2716 00001CC3 E94D00                   jmp @@retn
  2717                                  
  2718                                  ;-9     *InputPtr = DOS_ByteRead;
  2719                                  
  2720                                  @@getLine113:
  2721 00001CC6 A0[A501]                 mov al, [DOS_ByteRead]
  2722 00001CC9 8B1E[CE00]               mov  bx, [InputPtr]
  2723 00001CCD 8807                     mov  [bx], al
  2724                                  
  2725                                  ;-10     InputPtr++;
  2726                                  
  2727 00001CCF FF06[CE00]               inc  word [InputPtr]
  2728                                  
  2729                                  ;-11     i = InputPtr - &InputBuf;
  2730                                  
  2731 00001CD3 A1[CE00]                 mov ax, [InputPtr]
  2732 00001CD6 2D[4F00]                 sub ax, InputBuf
  2733 00001CD9 8946FE                   mov word [bp-2], ax
  2734                                  
  2735                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2736                                  
  2737 00001CDC 8B46FE                   mov ax, [bp-2]
  2738 00001CDF 83F87F                   cmp ax, 127 ;unsigned : 0
  2739 00001CE2 0F820900                 jb  @@getLine114
  2740 00001CE6 68[241D]                 push getLine_1
  2741 00001CE9 E8B209                   call errorexit
  2742 00001CEC 83C402                   add  sp, 2
  2743                                  
  2744                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2745                                  
  2746                                  @@getLine114:
  2747 00001CEF A0[A501]                 mov al, byte [DOS_ByteRead]
  2748 00001CF2 B400                     mov ah, 0
  2749 00001CF4 50                       push ax
  2750 00001CF5 E84000                   call ifEOL
  2751 00001CF8 83C402                   add  sp, 2
  2752 00001CFB 3C00                     cmp al, 0
  2753 00001CFD 0F850200                 jne @@getLine115
  2754 00001D01 EB90                     jmp @@getLine111
  2755                                  @@getLine115:
  2756                                  
  2757                                  ;-14   InputPtr--;
  2758                                  
  2759 00001D03 FF0E[CE00]               dec  word [InputPtr]
  2760                                  
  2761                                  ;-15   *InputPtr=0;
  2762                                  
  2763 00001D07 66B800000000             mov eax, 0
  2764 00001D0D 8B1E[CE00]               mov  bx, [InputPtr]
  2765 00001D11 8807                     mov  [bx], al
  2766                                  
  2767                                  ;-16 }
  2768                                  
  2769                                  
  2770                                  ;-17 int ifEOL(char c) {
  2771                                  
  2772 00001D13 C9                      @@retn: LEAVE
  2773 00001D14 C3                       ret
  2774                                  ; ENDP
  2775 00001D15 52656164696E672053-     getLine_0 db "Reading Source",0
  2776 00001D1E 6F7572636500       
  2777 00001D24 696E707574206C696E-     getLine_1 db "input line too long",0
  2778 00001D2D 6520746F6F206C6F6E-
  2779 00001D36 6700               
  2780                                  
  2781                                  ifEOL:  ; *** PROC ***
  2782                                  
  2783                                  ;-18   if (c == 10) return 1;
  2784                                  
  2785                                  ;Function : ifEOL, Number of local variables: 1
  2786                                  ;   # type sign width line used address name   list of local variables
  2787                                  ;  200 var sign byte    17 NULL bp+4    c;
  2788 00001D38 C8000000                 ENTER  0,0
  2789 00001D3C 8A4604                   mov al, [bp+4]
  2790 00001D3F 3C0A                     cmp al, 10
  2791 00001D41 0F850900                 jne @@ifEOL116
  2792 00001D45 66B801000000             mov eax, 1
  2793 00001D4B E92F00                   jmp @@retn
  2794                                  
  2795                                  ;-19   if (c == 13) {
  2796                                  
  2797                                  @@ifEOL116:
  2798 00001D4E 8A4604                   mov al, [bp+4]
  2799 00001D51 3C0D                     cmp al, 13
  2800 00001D53 0F851D00                 jne @@ifEOL117
  2801                                  
  2802                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2803                                  
  2804 00001D57 6A01                     push 1
  2805 00001D59 FF36[9901]               push word [asm_fd]
  2806 00001D5D 8D06[A501]               lea  ax, [DOS_ByteRead]
  2807 00001D61 50                       push ax
  2808 00001D62 E81D16                   call readRL
  2809 00001D65 83C406                   add  sp, 6
  2810 00001D68 A3[A301]                 mov word [DOS_NoBytes], ax
  2811                                  
  2812                                  ;-21     return 1;}
  2813                                  
  2814 00001D6B 66B801000000             mov eax, 1
  2815 00001D71 E90900                   jmp @@retn
  2816                                  
  2817                                  ;-22   return 0;
  2818                                  
  2819                                  @@ifEOL117:
  2820 00001D74 66B800000000             mov eax, 0
  2821 00001D7A E90000                   jmp @@retn
  2822                                  
  2823                                  ;-23 }
  2824                                  
  2825                                  
  2826                                  ;-24 int skipBlank() {
  2827                                  
  2828 00001D7D C9                      @@retn: LEAVE
  2829 00001D7E C3                       ret
  2830                                  ; ENDP
  2831                                  
  2832                                  skipBlank:  ; *** PROC ***
  2833                                  
  2834                                  ;-25   skipblank1:
  2835                                  
  2836                                  @@skipblank1:
  2837                                  
  2838                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2839                                  
  2840 00001D7F 8B1E[CE00]               mov bx, [InputPtr]
  2841 00001D83 8A07                     mov al, [bx]
  2842 00001D85 B400                     mov ah, 0
  2843 00001D87 83F820                   cmp ax, 32
  2844 00001D8A 0F850600                 jne @@skipBlank118
  2845 00001D8E FF06[CE00]               inc  word [InputPtr]
  2846 00001D92 EBEB                     jmp @@skipblank1
  2847                                  
  2848                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2849                                  
  2850                                  @@skipBlank118:
  2851 00001D94 8B1E[CE00]               mov bx, [InputPtr]
  2852 00001D98 8A07                     mov al, [bx]
  2853 00001D9A B400                     mov ah, 0
  2854 00001D9C 83F809                   cmp ax, 9
  2855 00001D9F 0F850600                 jne @@skipBlank119
  2856 00001DA3 FF06[CE00]               inc  word [InputPtr]
  2857 00001DA7 EBD6                     jmp @@skipblank1
  2858                                  
  2859                                  ;-28 }
  2860                                  
  2861                                  @@skipBlank119:
  2862                                  
  2863                                  ;-29 int letterE(char c) {
  2864                                  
  2865 00001DA9 C3                       ret
  2866                                  ; ENDP
  2867                                  
  2868                                  letterE:  ; *** PROC ***
  2869                                  
  2870                                  ;-30   if (c=='_') return 1;
  2871                                  
  2872                                  ;Function : letterE, Number of local variables: 1
  2873                                  ;   # type sign width line used address name   list of local variables
  2874                                  ;  200 var sign byte    29 NULL bp+4    c;
  2875 00001DAA C8000000                 ENTER  0,0
  2876 00001DAE 8A4604                   mov al, [bp+4]
  2877 00001DB1 3C5F                     cmp al, 95
  2878 00001DB3 0F850900                 jne @@letterE120
  2879 00001DB7 66B801000000             mov eax, 1
  2880 00001DBD E97E00                   jmp @@retn
  2881                                  
  2882                                  ;-31   if (c=='.') return 1;
  2883                                  
  2884                                  @@letterE120:
  2885 00001DC0 8A4604                   mov al, [bp+4]
  2886 00001DC3 3C2E                     cmp al, 46
  2887 00001DC5 0F850900                 jne @@letterE121
  2888 00001DC9 66B801000000             mov eax, 1
  2889 00001DCF E96C00                   jmp @@retn
  2890                                  
  2891                                  ;-32   if (c=='?') return 1;
  2892                                  
  2893                                  @@letterE121:
  2894 00001DD2 8A4604                   mov al, [bp+4]
  2895 00001DD5 3C3F                     cmp al, 63
  2896 00001DD7 0F850900                 jne @@letterE122
  2897 00001DDB 66B801000000             mov eax, 1
  2898 00001DE1 E95A00                   jmp @@retn
  2899                                  
  2900                                  ;-33   if (c=='$') return 1;
  2901                                  
  2902                                  @@letterE122:
  2903 00001DE4 8A4604                   mov al, [bp+4]
  2904 00001DE7 3C24                     cmp al, 36
  2905 00001DE9 0F850900                 jne @@letterE123
  2906 00001DED 66B801000000             mov eax, 1
  2907 00001DF3 E94800                   jmp @@retn
  2908                                  
  2909                                  ;-34   if (c> 'z') return 0;
  2910                                  
  2911                                  @@letterE123:
  2912 00001DF6 8A4604                   mov al, [bp+4]
  2913 00001DF9 3C7A                     cmp al, 122
  2914 00001DFB 0F8E0900                 jle @@letterE124
  2915 00001DFF 66B800000000             mov eax, 0
  2916 00001E05 E93600                   jmp @@retn
  2917                                  
  2918                                  ;-35   if (c< '@') return 0; // at included
  2919                                  
  2920                                  @@letterE124:
  2921 00001E08 8A4604                   mov al, [bp+4]
  2922 00001E0B 3C40                     cmp al, 64
  2923 00001E0D 0F8D0900                 jge @@letterE125
  2924 00001E11 66B800000000             mov eax, 0
  2925 00001E17 E92400                   jmp @@retn
  2926                                  
  2927                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2928                                  
  2929                                  @@letterE125:
  2930 00001E1A 8A4604                   mov al, [bp+4]
  2931 00001E1D 3C5A                     cmp al, 90
  2932 00001E1F 0F8E1200                 jle @@letterE126
  2933 00001E23 8A4604                   mov al, [bp+4]
  2934 00001E26 3C61                     cmp al, 97
  2935 00001E28 0F8D0900                 jge @@letterE127
  2936 00001E2C 66B800000000             mov eax, 0
  2937 00001E32 E90900                   jmp @@retn
  2938                                  @@letterE127:
  2939                                  
  2940                                  ;-37   return 1;
  2941                                  
  2942                                  @@letterE126:
  2943 00001E35 66B801000000             mov eax, 1
  2944 00001E3B E90000                   jmp @@retn
  2945                                  
  2946                                  ;-38 }
  2947                                  
  2948                                  
  2949                                  ;-39 int alnumE(char c) {
  2950                                  
  2951 00001E3E C9                      @@retn: LEAVE
  2952 00001E3F C3                       ret
  2953                                  ; ENDP
  2954                                  
  2955                                  alnumE:  ; *** PROC ***
  2956                                  
  2957                                  ;-40   if (digit(c)) return 1;
  2958                                  
  2959                                  ;Function : alnumE, Number of local variables: 1
  2960                                  ;   # type sign width line used address name   list of local variables
  2961                                  ;  200 var sign byte    39 NULL bp+4    c;
  2962 00001E40 C8000000                 ENTER  0,0
  2963 00001E44 8A4604                   mov al, byte [bp+4]
  2964 00001E47 B400                     mov ah, 0
  2965 00001E49 50                       push ax
  2966 00001E4A E86714                   call digit
  2967 00001E4D 83C402                   add  sp, 2
  2968 00001E50 08C0                     or  al, al
  2969 00001E52 0F840900                 je @@alnumE128
  2970 00001E56 66B801000000             mov eax, 1
  2971 00001E5C E92400                   jmp @@retn
  2972                                  
  2973                                  ;-41   if (letterE(c)) return 1;
  2974                                  
  2975                                  @@alnumE128:
  2976 00001E5F 8A4604                   mov al, byte [bp+4]
  2977 00001E62 B400                     mov ah, 0
  2978 00001E64 50                       push ax
  2979 00001E65 E842FF                   call letterE
  2980 00001E68 83C402                   add  sp, 2
  2981 00001E6B 08C0                     or  al, al
  2982 00001E6D 0F840900                 je @@alnumE129
  2983 00001E71 66B801000000             mov eax, 1
  2984 00001E77 E90900                   jmp @@retn
  2985                                  
  2986                                  ;-42   return 0;
  2987                                  
  2988                                  @@alnumE129:
  2989 00001E7A 66B800000000             mov eax, 0
  2990 00001E80 E90000                   jmp @@retn
  2991                                  
  2992                                  ;-43 }
  2993                                  
  2994                                  
  2995                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2996                                  
  2997 00001E83 C9                      @@retn: LEAVE
  2998 00001E84 C3                       ret
  2999                                  ; ENDP
  3000                                  
  3001                                  getDigit:  ; *** PROC ***
  3002                                  
  3003                                  ;-45   unsigned int CastInt;
  3004                                  
  3005                                  
  3006                                  ;-46   SymbolInt=0;
  3007                                  
  3008                                  ;Function : getDigit, Number of local variables: 2
  3009                                  ;   # type sign width line used address name   list of local variables
  3010                                  ;  200 var unsg byte    44 NULL bp+4    c
  3011                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3012 00001E85 C8020000                 ENTER  2,0
  3013 00001E89 66B800000000             mov eax, 0
  3014 00001E8F A3[4D00]                 mov word [SymbolInt], ax
  3015                                  
  3016                                  ;-47   do {
  3017                                  
  3018                                  @@getDigit130:
  3019                                  
  3020                                  ;-48     c-='0';
  3021                                  
  3022 00001E92 806E0430                 sub  byte [bp+4], 48
  3023                                  
  3024                                  ;-49     SymbolInt=SymbolInt*10;
  3025                                  
  3026 00001E96 A1[4D00]                 mov ax, [SymbolInt]
  3027 00001E99 66BB0A000000             mov ebx, 10
  3028 00001E9F 66F7E3                   mul ebx
  3029 00001EA2 A3[4D00]                 mov word [SymbolInt], ax
  3030                                  
  3031                                  ;-50     ax=0; CastInt=c; //cast b2w
  3032                                  
  3033 00001EA5 B80000                   mov  ax, 0
  3034 00001EA8 8A4604                   mov al, [bp+4]
  3035 00001EAB 8946FE                   mov word [bp-2], ax
  3036                                  
  3037                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3038                                  
  3039 00001EAE A1[4D00]                 mov ax, [SymbolInt]
  3040 00001EB1 0346FE                   add ax, [bp-2]
  3041 00001EB4 A3[4D00]                 mov word [SymbolInt], ax
  3042                                  
  3043                                  ;-52     InputPtr++;
  3044                                  
  3045 00001EB7 FF06[CE00]               inc  word [InputPtr]
  3046                                  
  3047                                  ;-53     c = *InputPtr;
  3048                                  
  3049 00001EBB 8B1E[CE00]               mov bx, [InputPtr]
  3050 00001EBF 8A07                     mov al, [bx]
  3051 00001EC1 B400                     mov ah, 0
  3052 00001EC3 884604                   mov byte [bp+4], al
  3053                                  
  3054                                  ;-54   } while(digit(c));
  3055                                  
  3056 00001EC6 8A4604                   mov al, byte [bp+4]
  3057 00001EC9 B400                     mov ah, 0
  3058 00001ECB 50                       push ax
  3059 00001ECC E8E513                   call digit
  3060 00001ECF 83C402                   add  sp, 2
  3061 00001ED2 08C0                     or  al, al
  3062 00001ED4 0F840200                 je @@getDigit131
  3063 00001ED8 EBB8                     jmp @@getDigit130
  3064                                  @@getDigit131:
  3065                                  
  3066                                  ;-55 }
  3067                                  
  3068                                  
  3069                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3070 00001EDA C9                       LEAVE
  3071 00001EDB C3                       ret
  3072                                  ; ENDP
  3073                                  
  3074                                  getName:  ; *** PROC ***
  3075                                  
  3076                                  ;-57   char *p; unsigned int i;
  3077                                  
  3078                                  
  3079                                  ;-58   p = &Symbol;
  3080                                  
  3081                                  ;Function : getName, Number of local variables: 3
  3082                                  ;   # type sign width line used address name   list of local variables
  3083                                  ;  200 var unsg byte    56 NULL bp+4    c
  3084                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3085                                  ;  202 var unsg word    57 NULL bp-4    i;
  3086 00001EDC C8040000                 ENTER  4,0
  3087 00001EE0 B8[0F00]                 mov ax, Symbol
  3088 00001EE3 8946FE                   mov word [bp-2], ax
  3089                                  
  3090                                  ;-59   *p = c;
  3091                                  
  3092 00001EE6 8A4604                   mov al, [bp+4]
  3093 00001EE9 8B5EFE                   mov  bx, [bp-2]
  3094 00001EEC 8807                     mov  [bx], al
  3095                                  
  3096                                  ;-60   p++;
  3097                                  
  3098 00001EEE FF46FE                   inc  word [bp-2]
  3099                                  
  3100                                  ;-61   while (alnumE(c)) {
  3101                                  
  3102                                  @@getName132:
  3103 00001EF1 8A4604                   mov al, byte [bp+4]
  3104 00001EF4 B400                     mov ah, 0
  3105 00001EF6 50                       push ax
  3106 00001EF7 E846FF                   call alnumE
  3107 00001EFA 83C402                   add  sp, 2
  3108 00001EFD 08C0                     or  al, al
  3109 00001EFF 0F843800                 je @@getName133
  3110                                  
  3111                                  ;-62     InputPtr++;
  3112                                  
  3113 00001F03 FF06[CE00]               inc  word [InputPtr]
  3114                                  
  3115                                  ;-63     c = *InputPtr;
  3116                                  
  3117 00001F07 8B1E[CE00]               mov bx, [InputPtr]
  3118 00001F0B 8A07                     mov al, [bx]
  3119 00001F0D B400                     mov ah, 0
  3120 00001F0F 884604                   mov byte [bp+4], al
  3121                                  
  3122                                  ;-64     *p = c;
  3123                                  
  3124 00001F12 8A4604                   mov al, [bp+4]
  3125 00001F15 8B5EFE                   mov  bx, [bp-2]
  3126 00001F18 8807                     mov  [bx], al
  3127                                  
  3128                                  ;-65     p++;
  3129                                  
  3130 00001F1A FF46FE                   inc  word [bp-2]
  3131                                  
  3132                                  ;-66     i = p - &Symbol;
  3133                                  
  3134 00001F1D 8B46FE                   mov ax, [bp-2]
  3135 00001F20 2D[0F00]                 sub ax, Symbol
  3136 00001F23 8946FC                   mov word [bp-4], ax
  3137                                  
  3138                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3139                                  
  3140 00001F26 8B46FC                   mov ax, [bp-4]
  3141 00001F29 83F81F                   cmp ax, 31 ;unsigned : 0
  3142 00001F2C 0F820900                 jb  @@getName134
  3143 00001F30 68[841F]                 push getName_0
  3144 00001F33 E86807                   call errorexit
  3145 00001F36 83C402                   add  sp, 2
  3146                                  
  3147                                  ;-68   }
  3148                                  
  3149                                  @@getName134:
  3150                                  
  3151                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3152                                  
  3153 00001F39 EBB6                     jmp @@getName132
  3154                                  @@getName133:
  3155 00001F3B 8A4604                   mov al, [bp+4]
  3156 00001F3E 3C3A                     cmp al, 58
  3157 00001F40 0F850C00                 jne @@getName135
  3158 00001F44 66B801000000             mov eax, 1
  3159 00001F4A A2[AA01]                 mov byte [isLabel], al
  3160 00001F4D E90900                   jmp @@getName136
  3161                                  @@getName135:
  3162 00001F50 66B800000000             mov eax, 0
  3163 00001F56 A2[AA01]                 mov byte [isLabel], al
  3164                                  
  3165                                  ;-70   p--;
  3166                                  
  3167                                  @@getName136:
  3168 00001F59 FF4EFE                   dec  word [bp-2]
  3169                                  
  3170                                  ;-71   *p = 0;
  3171                                  
  3172 00001F5C 66B800000000             mov eax, 0
  3173 00001F62 8B5EFE                   mov  bx, [bp-2]
  3174 00001F65 8807                     mov  [bx], al
  3175                                  
  3176                                  ;-72   strcpy(SymbolUpper, Symbol);
  3177                                  
  3178 00001F67 8D06[0F00]               lea  ax, [Symbol]
  3179 00001F6B 50                       push ax
  3180 00001F6C 8D06[2E00]               lea  ax, [SymbolUpper]
  3181 00001F70 50                       push ax
  3182 00001F71 E80713                   call strcpy
  3183 00001F74 83C404                   add  sp, 4
  3184                                  
  3185                                  ;-73   toupper(SymbolUpper);
  3186                                  
  3187 00001F77 8D06[2E00]               lea  ax, [SymbolUpper]
  3188 00001F7B 50                       push ax
  3189 00001F7C E88E12                   call toupper
  3190 00001F7F 83C402                   add  sp, 2
  3191                                  
  3192                                  ;-74 }
  3193                                  
  3194                                  
  3195                                  ;-75 int testReg() {
  3196 00001F82 C9                       LEAVE
  3197 00001F83 C3                       ret
  3198                                  ; ENDP
  3199 00001F84 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3200 00001F8D 6F206C6F6E6700     
  3201                                  
  3202                                  testReg:  ; *** PROC ***
  3203                                  
  3204                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3205                                  
  3206                                  
  3207                                  ;-77   R2Type=0;
  3208                                  
  3209 00001F94 66B800000000             mov eax, 0
  3210 00001F9A A2[B401]                 mov byte [R2Type], al
  3211                                  
  3212                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3213                                  
  3214 00001F9D 8D06[0F00]               lea  ax, [Symbol]
  3215 00001FA1 50                       push ax
  3216 00001FA2 E8AB12                   call strlen
  3217 00001FA5 83C402                   add  sp, 2
  3218 00001FA8 3C02                     cmp al, 2
  3219 00001FAA 0F8D0900                 jge @@testReg137
  3220 00001FAE 66B800000000             mov eax, 0
  3221 00001FB4 E9B603                   jmp @@retn
  3222                                  
  3223                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3224                                  
  3225                                  @@testReg137:
  3226 00001FB7 8D06[0F00]               lea  ax, [Symbol]
  3227 00001FBB 50                       push ax
  3228 00001FBC E89112                   call strlen
  3229 00001FBF 83C402                   add  sp, 2
  3230 00001FC2 3C03                     cmp al, 3
  3231 00001FC4 0F8E0900                 jle @@testReg138
  3232 00001FC8 66B800000000             mov eax, 0
  3233 00001FCE E99C03                   jmp @@retn
  3234                                  
  3235                                  ;-80   R2Type=BYTE;
  3236                                  
  3237                                  @@testReg138:
  3238 00001FD1 66B801000000             mov eax, 1
  3239 00001FD7 A2[B401]                 mov byte [R2Type], al
  3240                                  
  3241                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3242                                  
  3243 00001FDA 68[6E23]                 push testReg_0
  3244 00001FDD 8D06[2E00]               lea  ax, [SymbolUpper]
  3245 00001FE1 50                       push ax
  3246 00001FE2 E80213                   call eqstr
  3247 00001FE5 83C404                   add  sp, 4
  3248 00001FE8 08C0                     or  al, al
  3249 00001FEA 0F840900                 je @@testReg139
  3250 00001FEE 66B800000000             mov eax, 0
  3251 00001FF4 E97603                   jmp @@retn
  3252                                  
  3253                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3254                                  
  3255                                  @@testReg139:
  3256 00001FF7 68[7123]                 push testReg_1
  3257 00001FFA 8D06[2E00]               lea  ax, [SymbolUpper]
  3258 00001FFE 50                       push ax
  3259 00001FFF E8E512                   call eqstr
  3260 00002002 83C404                   add  sp, 4
  3261 00002005 08C0                     or  al, al
  3262 00002007 0F840900                 je @@testReg140
  3263 0000200B 66B801000000             mov eax, 1
  3264 00002011 E95903                   jmp @@retn
  3265                                  
  3266                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3267                                  
  3268                                  @@testReg140:
  3269 00002014 68[7423]                 push testReg_2
  3270 00002017 8D06[2E00]               lea  ax, [SymbolUpper]
  3271 0000201B 50                       push ax
  3272 0000201C E8C812                   call eqstr
  3273 0000201F 83C404                   add  sp, 4
  3274 00002022 08C0                     or  al, al
  3275 00002024 0F840900                 je @@testReg141
  3276 00002028 66B802000000             mov eax, 2
  3277 0000202E E93C03                   jmp @@retn
  3278                                  
  3279                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3280                                  
  3281                                  @@testReg141:
  3282 00002031 68[7723]                 push testReg_3
  3283 00002034 8D06[2E00]               lea  ax, [SymbolUpper]
  3284 00002038 50                       push ax
  3285 00002039 E8AB12                   call eqstr
  3286 0000203C 83C404                   add  sp, 4
  3287 0000203F 08C0                     or  al, al
  3288 00002041 0F840900                 je @@testReg142
  3289 00002045 66B803000000             mov eax, 3
  3290 0000204B E91F03                   jmp @@retn
  3291                                  
  3292                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3293                                  
  3294                                  @@testReg142:
  3295 0000204E 68[7A23]                 push testReg_4
  3296 00002051 8D06[2E00]               lea  ax, [SymbolUpper]
  3297 00002055 50                       push ax
  3298 00002056 E88E12                   call eqstr
  3299 00002059 83C404                   add  sp, 4
  3300 0000205C 08C0                     or  al, al
  3301 0000205E 0F840900                 je @@testReg143
  3302 00002062 66B804000000             mov eax, 4
  3303 00002068 E90203                   jmp @@retn
  3304                                  
  3305                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3306                                  
  3307                                  @@testReg143:
  3308 0000206B 68[7D23]                 push testReg_5
  3309 0000206E 8D06[2E00]               lea  ax, [SymbolUpper]
  3310 00002072 50                       push ax
  3311 00002073 E87112                   call eqstr
  3312 00002076 83C404                   add  sp, 4
  3313 00002079 08C0                     or  al, al
  3314 0000207B 0F840900                 je @@testReg144
  3315 0000207F 66B805000000             mov eax, 5
  3316 00002085 E9E502                   jmp @@retn
  3317                                  
  3318                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3319                                  
  3320                                  @@testReg144:
  3321 00002088 68[8023]                 push testReg_6
  3322 0000208B 8D06[2E00]               lea  ax, [SymbolUpper]
  3323 0000208F 50                       push ax
  3324 00002090 E85412                   call eqstr
  3325 00002093 83C404                   add  sp, 4
  3326 00002096 08C0                     or  al, al
  3327 00002098 0F840900                 je @@testReg145
  3328 0000209C 66B806000000             mov eax, 6
  3329 000020A2 E9C802                   jmp @@retn
  3330                                  
  3331                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3332                                  
  3333                                  @@testReg145:
  3334 000020A5 68[8323]                 push testReg_7
  3335 000020A8 8D06[2E00]               lea  ax, [SymbolUpper]
  3336 000020AC 50                       push ax
  3337 000020AD E83712                   call eqstr
  3338 000020B0 83C404                   add  sp, 4
  3339 000020B3 08C0                     or  al, al
  3340 000020B5 0F840900                 je @@testReg146
  3341 000020B9 66B807000000             mov eax, 7
  3342 000020BF E9AB02                   jmp @@retn
  3343                                  
  3344                                  ;-89   R2Type=WORD;
  3345                                  
  3346                                  @@testReg146:
  3347 000020C2 66B802000000             mov eax, 2
  3348 000020C8 A2[B401]                 mov byte [R2Type], al
  3349                                  
  3350                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3351                                  
  3352 000020CB 68[8623]                 push testReg_8
  3353 000020CE 8D06[2E00]               lea  ax, [SymbolUpper]
  3354 000020D2 50                       push ax
  3355 000020D3 E81112                   call eqstr
  3356 000020D6 83C404                   add  sp, 4
  3357 000020D9 08C0                     or  al, al
  3358 000020DB 0F840900                 je @@testReg147
  3359 000020DF 66B800000000             mov eax, 0
  3360 000020E5 E98502                   jmp @@retn
  3361                                  
  3362                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3363                                  
  3364                                  @@testReg147:
  3365 000020E8 68[8923]                 push testReg_9
  3366 000020EB 8D06[2E00]               lea  ax, [SymbolUpper]
  3367 000020EF 50                       push ax
  3368 000020F0 E8F411                   call eqstr
  3369 000020F3 83C404                   add  sp, 4
  3370 000020F6 08C0                     or  al, al
  3371 000020F8 0F840900                 je @@testReg148
  3372 000020FC 66B801000000             mov eax, 1
  3373 00002102 E96802                   jmp @@retn
  3374                                  
  3375                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3376                                  
  3377                                  @@testReg148:
  3378 00002105 68[8C23]                 push testReg_10
  3379 00002108 8D06[2E00]               lea  ax, [SymbolUpper]
  3380 0000210C 50                       push ax
  3381 0000210D E8D711                   call eqstr
  3382 00002110 83C404                   add  sp, 4
  3383 00002113 08C0                     or  al, al
  3384 00002115 0F840900                 je @@testReg149
  3385 00002119 66B802000000             mov eax, 2
  3386 0000211F E94B02                   jmp @@retn
  3387                                  
  3388                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3389                                  
  3390                                  @@testReg149:
  3391 00002122 68[8F23]                 push testReg_11
  3392 00002125 8D06[2E00]               lea  ax, [SymbolUpper]
  3393 00002129 50                       push ax
  3394 0000212A E8BA11                   call eqstr
  3395 0000212D 83C404                   add  sp, 4
  3396 00002130 08C0                     or  al, al
  3397 00002132 0F840900                 je @@testReg150
  3398 00002136 66B803000000             mov eax, 3
  3399 0000213C E92E02                   jmp @@retn
  3400                                  
  3401                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3402                                  
  3403                                  @@testReg150:
  3404 0000213F 68[9223]                 push testReg_12
  3405 00002142 8D06[2E00]               lea  ax, [SymbolUpper]
  3406 00002146 50                       push ax
  3407 00002147 E89D11                   call eqstr
  3408 0000214A 83C404                   add  sp, 4
  3409 0000214D 08C0                     or  al, al
  3410 0000214F 0F840900                 je @@testReg151
  3411 00002153 66B804000000             mov eax, 4
  3412 00002159 E91102                   jmp @@retn
  3413                                  
  3414                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3415                                  
  3416                                  @@testReg151:
  3417 0000215C 68[9523]                 push testReg_13
  3418 0000215F 8D06[2E00]               lea  ax, [SymbolUpper]
  3419 00002163 50                       push ax
  3420 00002164 E88011                   call eqstr
  3421 00002167 83C404                   add  sp, 4
  3422 0000216A 08C0                     or  al, al
  3423 0000216C 0F840900                 je @@testReg152
  3424 00002170 66B805000000             mov eax, 5
  3425 00002176 E9F401                   jmp @@retn
  3426                                  
  3427                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3428                                  
  3429                                  @@testReg152:
  3430 00002179 68[9823]                 push testReg_14
  3431 0000217C 8D06[2E00]               lea  ax, [SymbolUpper]
  3432 00002180 50                       push ax
  3433 00002181 E86311                   call eqstr
  3434 00002184 83C404                   add  sp, 4
  3435 00002187 08C0                     or  al, al
  3436 00002189 0F840900                 je @@testReg153
  3437 0000218D 66B806000000             mov eax, 6
  3438 00002193 E9D701                   jmp @@retn
  3439                                  
  3440                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3441                                  
  3442                                  @@testReg153:
  3443 00002196 68[9B23]                 push testReg_15
  3444 00002199 8D06[2E00]               lea  ax, [SymbolUpper]
  3445 0000219D 50                       push ax
  3446 0000219E E84611                   call eqstr
  3447 000021A1 83C404                   add  sp, 4
  3448 000021A4 08C0                     or  al, al
  3449 000021A6 0F840900                 je @@testReg154
  3450 000021AA 66B807000000             mov eax, 7
  3451 000021B0 E9BA01                   jmp @@retn
  3452                                  
  3453                                  ;-98   R2Type=SEGREG;
  3454                                  
  3455                                  @@testReg154:
  3456 000021B3 66B804000000             mov eax, 4
  3457 000021B9 A2[B401]                 mov byte [R2Type], al
  3458                                  
  3459                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3460                                  
  3461 000021BC 68[9E23]                 push testReg_16
  3462 000021BF 8D06[2E00]               lea  ax, [SymbolUpper]
  3463 000021C3 50                       push ax
  3464 000021C4 E82011                   call eqstr
  3465 000021C7 83C404                   add  sp, 4
  3466 000021CA 08C0                     or  al, al
  3467 000021CC 0F840900                 je @@testReg155
  3468 000021D0 66B800000000             mov eax, 0
  3469 000021D6 E99401                   jmp @@retn
  3470                                  
  3471                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3472                                  
  3473                                  @@testReg155:
  3474 000021D9 68[A123]                 push testReg_17
  3475 000021DC 8D06[2E00]               lea  ax, [SymbolUpper]
  3476 000021E0 50                       push ax
  3477 000021E1 E80311                   call eqstr
  3478 000021E4 83C404                   add  sp, 4
  3479 000021E7 08C0                     or  al, al
  3480 000021E9 0F840900                 je @@testReg156
  3481 000021ED 66B801000000             mov eax, 1
  3482 000021F3 E97701                   jmp @@retn
  3483                                  
  3484                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3485                                  
  3486                                  @@testReg156:
  3487 000021F6 68[A423]                 push testReg_18
  3488 000021F9 8D06[2E00]               lea  ax, [SymbolUpper]
  3489 000021FD 50                       push ax
  3490 000021FE E8E610                   call eqstr
  3491 00002201 83C404                   add  sp, 4
  3492 00002204 08C0                     or  al, al
  3493 00002206 0F840900                 je @@testReg157
  3494 0000220A 66B802000000             mov eax, 2
  3495 00002210 E95A01                   jmp @@retn
  3496                                  
  3497                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3498                                  
  3499                                  @@testReg157:
  3500 00002213 68[A723]                 push testReg_19
  3501 00002216 8D06[2E00]               lea  ax, [SymbolUpper]
  3502 0000221A 50                       push ax
  3503 0000221B E8C910                   call eqstr
  3504 0000221E 83C404                   add  sp, 4
  3505 00002221 08C0                     or  al, al
  3506 00002223 0F840900                 je @@testReg158
  3507 00002227 66B803000000             mov eax, 3
  3508 0000222D E93D01                   jmp @@retn
  3509                                  
  3510                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3511                                  
  3512                                  @@testReg158:
  3513 00002230 68[AA23]                 push testReg_20
  3514 00002233 8D06[2E00]               lea  ax, [SymbolUpper]
  3515 00002237 50                       push ax
  3516 00002238 E8AC10                   call eqstr
  3517 0000223B 83C404                   add  sp, 4
  3518 0000223E 08C0                     or  al, al
  3519 00002240 0F840900                 je @@testReg159
  3520 00002244 66B804000000             mov eax, 4
  3521 0000224A E92001                   jmp @@retn
  3522                                  
  3523                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3524                                  
  3525                                  @@testReg159:
  3526 0000224D 68[AD23]                 push testReg_21
  3527 00002250 8D06[2E00]               lea  ax, [SymbolUpper]
  3528 00002254 50                       push ax
  3529 00002255 E88F10                   call eqstr
  3530 00002258 83C404                   add  sp, 4
  3531 0000225B 08C0                     or  al, al
  3532 0000225D 0F840900                 je @@testReg160
  3533 00002261 66B805000000             mov eax, 5
  3534 00002267 E90301                   jmp @@retn
  3535                                  
  3536                                  ;-105   R2Type=DWORD;                         
  3537                                  
  3538                                  @@testReg160:
  3539 0000226A 66B803000000             mov eax, 3
  3540 00002270 A2[B401]                 mov byte [R2Type], al
  3541                                  
  3542                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3543                                  
  3544 00002273 68[B023]                 push testReg_22
  3545 00002276 8D06[2E00]               lea  ax, [SymbolUpper]
  3546 0000227A 50                       push ax
  3547 0000227B E86910                   call eqstr
  3548 0000227E 83C404                   add  sp, 4
  3549 00002281 08C0                     or  al, al
  3550 00002283 0F840900                 je @@testReg161
  3551 00002287 66B800000000             mov eax, 0
  3552 0000228D E9DD00                   jmp @@retn
  3553                                  
  3554                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3555                                  
  3556                                  @@testReg161:
  3557 00002290 68[B423]                 push testReg_23
  3558 00002293 8D06[2E00]               lea  ax, [SymbolUpper]
  3559 00002297 50                       push ax
  3560 00002298 E84C10                   call eqstr
  3561 0000229B 83C404                   add  sp, 4
  3562 0000229E 08C0                     or  al, al
  3563 000022A0 0F840900                 je @@testReg162
  3564 000022A4 66B801000000             mov eax, 1
  3565 000022AA E9C000                   jmp @@retn
  3566                                  
  3567                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3568                                  
  3569                                  @@testReg162:
  3570 000022AD 68[B823]                 push testReg_24
  3571 000022B0 8D06[2E00]               lea  ax, [SymbolUpper]
  3572 000022B4 50                       push ax
  3573 000022B5 E82F10                   call eqstr
  3574 000022B8 83C404                   add  sp, 4
  3575 000022BB 08C0                     or  al, al
  3576 000022BD 0F840900                 je @@testReg163
  3577 000022C1 66B802000000             mov eax, 2
  3578 000022C7 E9A300                   jmp @@retn
  3579                                  
  3580                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3581                                  
  3582                                  @@testReg163:
  3583 000022CA 68[BC23]                 push testReg_25
  3584 000022CD 8D06[2E00]               lea  ax, [SymbolUpper]
  3585 000022D1 50                       push ax
  3586 000022D2 E81210                   call eqstr
  3587 000022D5 83C404                   add  sp, 4
  3588 000022D8 08C0                     or  al, al
  3589 000022DA 0F840900                 je @@testReg164
  3590 000022DE 66B803000000             mov eax, 3
  3591 000022E4 E98600                   jmp @@retn
  3592                                  
  3593                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3594                                  
  3595                                  @@testReg164:
  3596 000022E7 68[C023]                 push testReg_26
  3597 000022EA 8D06[2E00]               lea  ax, [SymbolUpper]
  3598 000022EE 50                       push ax
  3599 000022EF E8F50F                   call eqstr
  3600 000022F2 83C404                   add  sp, 4
  3601 000022F5 08C0                     or  al, al
  3602 000022F7 0F840900                 je @@testReg165
  3603 000022FB 66B804000000             mov eax, 4
  3604 00002301 E96900                   jmp @@retn
  3605                                  
  3606                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3607                                  
  3608                                  @@testReg165:
  3609 00002304 68[C423]                 push testReg_27
  3610 00002307 8D06[2E00]               lea  ax, [SymbolUpper]
  3611 0000230B 50                       push ax
  3612 0000230C E8D80F                   call eqstr
  3613 0000230F 83C404                   add  sp, 4
  3614 00002312 08C0                     or  al, al
  3615 00002314 0F840900                 je @@testReg166
  3616 00002318 66B805000000             mov eax, 5
  3617 0000231E E94C00                   jmp @@retn
  3618                                  
  3619                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3620                                  
  3621                                  @@testReg166:
  3622 00002321 68[C823]                 push testReg_28
  3623 00002324 8D06[2E00]               lea  ax, [SymbolUpper]
  3624 00002328 50                       push ax
  3625 00002329 E8BB0F                   call eqstr
  3626 0000232C 83C404                   add  sp, 4
  3627 0000232F 08C0                     or  al, al
  3628 00002331 0F840900                 je @@testReg167
  3629 00002335 66B806000000             mov eax, 6
  3630 0000233B E92F00                   jmp @@retn
  3631                                  
  3632                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3633                                  
  3634                                  @@testReg167:
  3635 0000233E 68[CC23]                 push testReg_29
  3636 00002341 8D06[2E00]               lea  ax, [SymbolUpper]
  3637 00002345 50                       push ax
  3638 00002346 E89E0F                   call eqstr
  3639 00002349 83C404                   add  sp, 4
  3640 0000234C 08C0                     or  al, al
  3641 0000234E 0F840900                 je @@testReg168
  3642 00002352 66B807000000             mov eax, 7
  3643 00002358 E91200                   jmp @@retn
  3644                                  
  3645                                  ;-114   R2Type=0; return 0;
  3646                                  
  3647                                  @@testReg168:
  3648 0000235B 66B800000000             mov eax, 0
  3649 00002361 A2[B401]                 mov byte [R2Type], al
  3650 00002364 66B800000000             mov eax, 0
  3651 0000236A E90000                   jmp @@retn
  3652                                  
  3653                                  ;-115 }
  3654                                  
  3655                                  @@retn:
  3656 0000236D C3                       ret
  3657                                  ; ENDP
  3658 0000236E 414C00                  testReg_0 db "AL",0
  3659 00002371 434C00                  testReg_1 db "CL",0
  3660 00002374 444C00                  testReg_2 db "DL",0
  3661 00002377 424C00                  testReg_3 db "BL",0
  3662 0000237A 414800                  testReg_4 db "AH",0
  3663 0000237D 434800                  testReg_5 db "CH",0
  3664 00002380 444800                  testReg_6 db "DH",0
  3665 00002383 424800                  testReg_7 db "BH",0
  3666 00002386 415800                  testReg_8 db "AX",0
  3667 00002389 435800                  testReg_9 db "CX",0
  3668 0000238C 445800                  testReg_10 db "DX",0
  3669 0000238F 425800                  testReg_11 db "BX",0
  3670 00002392 535000                  testReg_12 db "SP",0
  3671 00002395 425000                  testReg_13 db "BP",0
  3672 00002398 534900                  testReg_14 db "SI",0
  3673 0000239B 444900                  testReg_15 db "DI",0
  3674 0000239E 455300                  testReg_16 db "ES",0
  3675 000023A1 435300                  testReg_17 db "CS",0
  3676 000023A4 535300                  testReg_18 db "SS",0
  3677 000023A7 445300                  testReg_19 db "DS",0
  3678 000023AA 465300                  testReg_20 db "FS",0
  3679 000023AD 475300                  testReg_21 db "GS",0
  3680 000023B0 45415800                testReg_22 db "EAX",0
  3681 000023B4 45435800                testReg_23 db "ECX",0
  3682 000023B8 45445800                testReg_24 db "EDX",0
  3683 000023BC 45425800                testReg_25 db "EBX",0
  3684 000023C0 45535000                testReg_26 db "ESP",0
  3685 000023C4 45425000                testReg_27 db "EBP",0
  3686 000023C8 45534900                testReg_28 db "ESI",0
  3687 000023CC 45444900                testReg_29 db "EDI",0
  3688                                  ;Back to main program: AS.C
  3689                                  
  3690                                  ;-7 #include "OUTPUT.C"
  3691                                  
  3692                                  ;Use include file: OUTPUT.C
  3693                                  
  3694                                  ;-1 int printLine() { 
  3695                                  
  3696                                  
  3697                                  printLine:  ; *** PROC ***
  3698                                  
  3699                                  ;-2     int i; char c;
  3700                                  
  3701                                  
  3702                                  ;-3     prs("\n"); 
  3703                                  
  3704                                  ;Function : printLine, Number of local variables: 2
  3705                                  ;   # type sign width line used address name   list of local variables
  3706                                  ;  200 var sign word     2 NULL bp-2    i
  3707                                  ;  201 var sign byte     2 NULL bp-4    c;
  3708 000023D0 C8040000                 ENTER  4,0
  3709 000023D4 68[6524]                 push printLine_0
  3710 000023D7 E80401                   call prs
  3711 000023DA 83C402                   add  sp, 2
  3712                                  
  3713                                  ;-4     printhex16(PCStart);
  3714                                  
  3715 000023DD FF36[A801]               push word [PCStart]
  3716 000023E1 E8EF01                   call printhex16
  3717 000023E4 83C402                   add  sp, 2
  3718                                  
  3719                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3720                                  
  3721 000023E7 A1[C501]                 mov ax, [OpPrintIndex]
  3722 000023EA 83F800                   cmp ax, 0
  3723 000023ED 0F850C00                 jne @@printLine169
  3724 000023F1 68[6824]                 push printLine_1
  3725 000023F4 E8E700                   call prs
  3726 000023F7 83C402                   add  sp, 2
  3727                                  
  3728                                  ;-6     else {
  3729                                  
  3730 000023FA E95B00                   jmp @@printLine170
  3731                                  @@printLine169:
  3732                                  
  3733                                  ;-7         prc(PrintR);
  3734                                  
  3735 000023FD A0[C901]                 mov al, byte [PrintR]
  3736 00002400 B400                     mov ah, 0
  3737 00002402 50                       push ax
  3738 00002403 E87700                   call prc
  3739 00002406 83C402                   add  sp, 2
  3740                                  
  3741                                  ;-8         i=0;
  3742                                  
  3743 00002409 66B800000000             mov eax, 0
  3744 0000240F 8946FE                   mov word [bp-2], ax
  3745                                  
  3746                                  ;-9         do {
  3747                                  
  3748                                  @@printLine171:
  3749                                  
  3750                                  ;-10             c=OpPos[i];
  3751                                  
  3752 00002412 8B5EFE                   mov bx, [bp-2]
  3753 00002415 8A87[C001]               mov al, [OpPos + bx]
  3754 00002419 8846FC                   mov byte [bp-4], al
  3755                                  
  3756                                  ;-11             printhex8a(c); 
  3757                                  
  3758 0000241C 8A46FC                   mov al, byte [bp-4]
  3759 0000241F B400                     mov ah, 0
  3760 00002421 50                       push ax
  3761 00002422 E85C01                   call printhex8a
  3762 00002425 83C402                   add  sp, 2
  3763                                  
  3764                                  ;-12             prc(' ');
  3765                                  
  3766 00002428 6A20                     push 32
  3767 0000242A E85000                   call prc
  3768 0000242D 83C402                   add  sp, 2
  3769                                  
  3770                                  ;-13             i++;
  3771                                  
  3772 00002430 FF46FE                   inc  word [bp-2]
  3773                                  
  3774                                  ;-14         } while (i < OpPrintIndex);
  3775                                  
  3776 00002433 8B46FE                   mov ax, [bp-2]
  3777 00002436 3B06[C501]               cmp ax, [OpPrintIndex]
  3778 0000243A 0F8D0200                 jge @@printLine172
  3779 0000243E EBD2                     jmp @@printLine171
  3780                                  @@printLine172:
  3781                                  
  3782                                  ;-15         do {// fill rest with blank
  3783                                  
  3784                                  @@printLine173:
  3785                                  
  3786                                  ;-16             prs("   ");
  3787                                  
  3788 00002440 68[7924]                 push printLine_2
  3789 00002443 E89800                   call prs
  3790 00002446 83C402                   add  sp, 2
  3791                                  
  3792                                  ;-17             i++;
  3793                                  
  3794 00002449 FF46FE                   inc  word [bp-2]
  3795                                  
  3796                                  ;-18         } while (i < OPMAXLEN);
  3797                                  
  3798 0000244C 8B46FE                   mov ax, [bp-2]
  3799 0000244F 83F805                   cmp ax, 5
  3800 00002452 0F8D0200                 jge @@printLine174
  3801 00002456 EBE8                     jmp @@printLine173
  3802                                  @@printLine174:
  3803                                  
  3804                                  ;-19     }
  3805                                  
  3806                                  
  3807                                  ;-20     prscomment(InputBuf);
  3808                                  
  3809                                  @@printLine170:
  3810 00002458 8D06[4F00]               lea  ax, [InputBuf]
  3811 0000245C 50                       push ax
  3812 0000245D E85000                   call prscomment
  3813 00002460 83C402                   add  sp, 2
  3814                                  
  3815                                  ;-21 }
  3816                                  
  3817                                  
  3818                                  ;-22 int prc(unsigned char c) {//print char 
  3819 00002463 C9                       LEAVE
  3820 00002464 C3                       ret
  3821                                  ; ENDP
  3822 00002465 5C6E00                  printLine_0 db "\n",0
  3823 00002468 202020202020202020-     printLine_1 db "                ",0
  3824 00002471 2020202020202000   
  3825 00002479 20202000                printLine_2 db "   ",0
  3826                                  
  3827                                  prc:  ; *** PROC ***
  3828                                  
  3829                                  ;-23     if (LIST) { 
  3830                                  
  3831                                  ;Function : prc, Number of local variables: 1
  3832                                  ;   # type sign width line used address name   list of local variables
  3833                                  ;  200 var unsg byte    22 NULL bp+4    c;
  3834 0000247D C8000000                 ENTER  0,0
  3835 00002481 A0[0E00]                 mov al, [LIST]
  3836 00002484 08C0                     or  al, al
  3837 00002486 0F841400                 je @@prc175
  3838                                  
  3839                                  ;-24         if ( _ c==10) {
  3840                                  
  3841 0000248A 807E040A                cmp byte [bp+4], 10
  3842 0000248E 0F850600                 jne @@prc176
  3843                                  
  3844                                  ;-25             ax=13; 
  3845                                  
  3846 00002492 B80D00                   mov  ax, 13
  3847                                  
  3848                                  ;-26             writetty(); 
  3849                                  
  3850 00002495 E83F0D                   call writetty
  3851                                  
  3852                                  ;-27             }
  3853                                  
  3854                                  
  3855                                  ;-28         al=c; 
  3856                                  
  3857                                  @@prc176:
  3858 00002498 8A4604                   mov  al, [bp+4]
  3859                                  
  3860                                  ;-29         writetty(); 
  3861                                  
  3862 0000249B E8390D                   call writetty
  3863                                  
  3864                                  ;-30         }
  3865                                  
  3866                                  
  3867                                  ;-31     fputcR(c,lst_fd); 
  3868                                  
  3869                                  @@prc175:
  3870 0000249E FF36[9B01]               push word [lst_fd]
  3871 000024A2 8A4604                   mov al, byte [bp+4]
  3872 000024A5 B400                     mov ah, 0
  3873 000024A7 50                       push ax
  3874 000024A8 E8EC0E                   call fputcR
  3875 000024AB 83C404                   add  sp, 4
  3876                                  
  3877                                  ;-32 }
  3878                                  
  3879                                  
  3880                                  ;-33 
  3881                                  
  3882                                  
  3883                                  ;-34 int prscomment(unsigned char *s) {
  3884 000024AE C9                       LEAVE
  3885 000024AF C3                       ret
  3886                                  ; ENDP
  3887                                  
  3888                                  prscomment:  ; *** PROC ***
  3889                                  
  3890                                  ;-35     unsigned char c;
  3891                                  
  3892                                  
  3893                                  ;-36     while (*s){
  3894                                  
  3895                                  ;Function : prscomment, Number of local variables: 2
  3896                                  ;   # type sign width line used address name   list of local variables
  3897                                  ;  200 ptr unsg byte    34 NULL bp+4    s
  3898                                  ;  201 var unsg byte    35 NULL bp-2    c;
  3899 000024B0 C8020000                 ENTER  2,0
  3900                                  @@prscomment177:
  3901 000024B4 8B5E04                   mov bx, [bp+4]
  3902 000024B7 8A07                     mov al, [bx]
  3903 000024B9 B400                     mov ah, 0
  3904 000024BB 08C0                     or  al, al
  3905 000024BD 0F841B00                 je @@prscomment178
  3906                                  
  3907                                  ;-37         c=*s;
  3908                                  
  3909 000024C1 8B5E04                   mov bx, [bp+4]
  3910 000024C4 8A07                     mov al, [bx]
  3911 000024C6 B400                     mov ah, 0
  3912 000024C8 8846FE                   mov byte [bp-2], al
  3913                                  
  3914                                  ;-38         prc(c);
  3915                                  
  3916 000024CB 8A46FE                   mov al, byte [bp-2]
  3917 000024CE B400                     mov ah, 0
  3918 000024D0 50                       push ax
  3919 000024D1 E8A9FF                   call prc
  3920 000024D4 83C402                   add  sp, 2
  3921                                  
  3922                                  ;-39         s++;
  3923                                  
  3924 000024D7 FF4604                   inc  word [bp+4]
  3925                                  
  3926                                  ;-40     }
  3927                                  
  3928                                  
  3929                                  ;-41 }
  3930                                  
  3931 000024DA EBD8                     jmp @@prscomment177
  3932                                  @@prscomment178:
  3933                                  
  3934                                  ;-42 int prs(unsigned char *s) {
  3935 000024DC C9                       LEAVE
  3936 000024DD C3                       ret
  3937                                  ; ENDP
  3938                                  
  3939                                  prs:  ; *** PROC ***
  3940                                  
  3941                                  ;-43     unsigned char c; 
  3942                                  
  3943                                  
  3944                                  ;-44     int com; 
  3945                                  
  3946                                  
  3947                                  ;-45     com=0;
  3948                                  
  3949                                  ;Function : prs, Number of local variables: 3
  3950                                  ;   # type sign width line used address name   list of local variables
  3951                                  ;  200 ptr unsg byte    42 NULL bp+4    s
  3952                                  ;  201 var unsg byte    43 NULL bp-2    c
  3953                                  ;  202 var sign word    44 NULL bp-4    com;
  3954 000024DE C8040000                 ENTER  4,0
  3955 000024E2 66B800000000             mov eax, 0
  3956 000024E8 8946FC                   mov word [bp-4], ax
  3957                                  
  3958                                  ;-46     while (*s) { 
  3959                                  
  3960                                  @@prs179:
  3961 000024EB 8B5E04                   mov bx, [bp+4]
  3962 000024EE 8A07                     mov al, [bx]
  3963 000024F0 B400                     mov ah, 0
  3964 000024F2 08C0                     or  al, al
  3965 000024F4 0F848700                 je @@prs180
  3966                                  
  3967                                  ;-47         c=*s; 
  3968                                  
  3969 000024F8 8B5E04                   mov bx, [bp+4]
  3970 000024FB 8A07                     mov al, [bx]
  3971 000024FD B400                     mov ah, 0
  3972 000024FF 8846FE                   mov byte [bp-2], al
  3973                                  
  3974                                  ;-48         if (c==34) {
  3975                                  
  3976 00002502 8A46FE                   mov al, [bp-2]
  3977 00002505 3C22                     cmp al, 34
  3978 00002507 0F851E00                 jne @@prs181
  3979                                  
  3980                                  ;-49             if (com) com=0; 
  3981                                  
  3982 0000250B 8B46FC                   mov ax, [bp-4]
  3983 0000250E 08C0                     or  al, al
  3984 00002510 0F840C00                 je @@prs182
  3985 00002514 66B800000000             mov eax, 0
  3986 0000251A 8946FC                   mov word [bp-4], ax
  3987                                  
  3988                                  ;-50                 else com=1;  
  3989                                  
  3990 0000251D E90900                   jmp @@prs183
  3991                                  @@prs182:
  3992 00002520 66B801000000             mov eax, 1
  3993 00002526 8946FC                   mov word [bp-4], ax
  3994                                  
  3995                                  ;-51         }
  3996                                  
  3997                                  @@prs183:
  3998                                  
  3999                                  ;-52         if (c==92) { 
  4000                                  
  4001                                  @@prs181:
  4002 00002529 8A46FE                   mov al, [bp-2]
  4003 0000252C 3C5C                     cmp al, 92
  4004 0000252E 0F853B00                 jne @@prs184
  4005                                  
  4006                                  ;-53             if (com==0) { 
  4007                                  
  4008 00002532 8B46FC                   mov ax, [bp-4]
  4009 00002535 83F800                   cmp ax, 0
  4010 00002538 0F853100                 jne @@prs185
  4011                                  
  4012                                  ;-54                 s++; 
  4013                                  
  4014 0000253C FF4604                   inc  word [bp+4]
  4015                                  
  4016                                  ;-55                 c=*s;
  4017                                  
  4018 0000253F 8B5E04                   mov bx, [bp+4]
  4019 00002542 8A07                     mov al, [bx]
  4020 00002544 B400                     mov ah, 0
  4021 00002546 8846FE                   mov byte [bp-2], al
  4022                                  
  4023                                  ;-56                 if (c=='n') c=10; 
  4024                                  
  4025 00002549 8A46FE                   mov al, [bp-2]
  4026 0000254C 3C6E                     cmp al, 110
  4027 0000254E 0F850900                 jne @@prs186
  4028 00002552 66B80A000000             mov eax, 10
  4029 00002558 8846FE                   mov byte [bp-2], al
  4030                                  
  4031                                  ;-57                 if (c=='t') c= 9; 
  4032                                  
  4033                                  @@prs186:
  4034 0000255B 8A46FE                   mov al, [bp-2]
  4035 0000255E 3C74                     cmp al, 116
  4036 00002560 0F850900                 jne @@prs187
  4037 00002564 66B809000000             mov eax, 9
  4038 0000256A 8846FE                   mov byte [bp-2], al
  4039                                  
  4040                                  ;-58             } 
  4041                                  
  4042                                  @@prs187:
  4043                                  
  4044                                  ;-59         } 
  4045                                  
  4046                                  @@prs185:
  4047                                  
  4048                                  ;-60         prc(c); 
  4049                                  
  4050                                  @@prs184:
  4051 0000256D 8A46FE                   mov al, byte [bp-2]
  4052 00002570 B400                     mov ah, 0
  4053 00002572 50                       push ax
  4054 00002573 E807FF                   call prc
  4055 00002576 83C402                   add  sp, 2
  4056                                  
  4057                                  ;-61         s++;  
  4058                                  
  4059 00002579 FF4604                   inc  word [bp+4]
  4060                                  
  4061                                  ;-62     }
  4062                                  
  4063                                  
  4064                                  ;-63 }
  4065                                  
  4066 0000257C E96CFF                   jmp @@prs179
  4067                                  @@prs180:
  4068                                  
  4069                                  ;-64 int printhex8a(unsigned char c) { 
  4070 0000257F C9                       LEAVE
  4071 00002580 C3                       ret
  4072                                  ; ENDP
  4073                                  
  4074                                  printhex8a:  ; *** PROC ***
  4075                                  
  4076                                  ;-65     unsigned char nib;
  4077                                  
  4078                                  
  4079                                  ;-66     nib = c >> 4; printhex4(nib);                    
  4080                                  
  4081                                  ;Function : printhex8a, Number of local variables: 2
  4082                                  ;   # type sign width line used address name   list of local variables
  4083                                  ;  200 var unsg byte    64 NULL bp+4    c
  4084                                  ;  201 var unsg byte    65 NULL bp-2    nib;
  4085 00002581 C8020000                 ENTER  2,0
  4086 00002585 8A4604                   mov al, [bp+4]
  4087 00002588 C0E804                   shr al, 4
  4088 0000258B 8846FE                   mov byte [bp-2], al
  4089 0000258E 8A46FE                   mov al, byte [bp-2]
  4090 00002591 B400                     mov ah, 0
  4091 00002593 50                       push ax
  4092 00002594 E81900                   call printhex4
  4093 00002597 83C402                   add  sp, 2
  4094                                  
  4095                                  ;-67     nib = c & 15; printhex4(nib);                    
  4096                                  
  4097 0000259A 8A4604                   mov al, [bp+4]
  4098 0000259D 240F                     and al, 15
  4099 0000259F 8846FE                   mov byte [bp-2], al
  4100 000025A2 8A46FE                   mov al, byte [bp-2]
  4101 000025A5 B400                     mov ah, 0
  4102 000025A7 50                       push ax
  4103 000025A8 E80500                   call printhex4
  4104 000025AB 83C402                   add  sp, 2
  4105                                  
  4106                                  ;-68 } 
  4107                                  
  4108                                  
  4109                                  ;-69 int printhex4(unsigned char c) {
  4110 000025AE C9                       LEAVE
  4111 000025AF C3                       ret
  4112                                  ; ENDP
  4113                                  
  4114                                  printhex4:  ; *** PROC ***
  4115                                  
  4116                                  ;-70     c += 48; 
  4117                                  
  4118                                  ;Function : printhex4, Number of local variables: 1
  4119                                  ;   # type sign width line used address name   list of local variables
  4120                                  ;  200 var unsg byte    69 NULL bp+4    c;
  4121 000025B0 C8000000                 ENTER  0,0
  4122 000025B4 80460430                 add  byte [bp+4], 48
  4123                                  
  4124                                  ;-71     if (c > 57) c += 7; 
  4125                                  
  4126 000025B8 8A4604                   mov al, [bp+4]
  4127 000025BB 3C39                     cmp al, 57
  4128 000025BD 0F8E0400                 jle @@printhex4188
  4129 000025C1 80460407                 add  byte [bp+4], 7
  4130                                  
  4131                                  ;-72     prc(c);      
  4132                                  
  4133                                  @@printhex4188:
  4134 000025C5 8A4604                   mov al, byte [bp+4]
  4135 000025C8 B400                     mov ah, 0
  4136 000025CA 50                       push ax
  4137 000025CB E8AFFE                   call prc
  4138 000025CE 83C402                   add  sp, 2
  4139                                  
  4140                                  ;-73 }
  4141                                  
  4142                                  
  4143                                  ;-74 int printhex16(unsigned int i) {
  4144 000025D1 C9                       LEAVE
  4145 000025D2 C3                       ret
  4146                                  ; ENDP
  4147                                  
  4148                                  printhex16:  ; *** PROC ***
  4149                                  
  4150                                  ;-75     unsigned int half;
  4151                                  
  4152                                  
  4153                                  ;-76     half = i >>  8; printhex8a(half); 
  4154                                  
  4155                                  ;Function : printhex16, Number of local variables: 2
  4156                                  ;   # type sign width line used address name   list of local variables
  4157                                  ;  200 var unsg word    74 NULL bp+4    i
  4158                                  ;  201 var unsg word    75 NULL bp-2    half;
  4159 000025D3 C8020000                 ENTER  2,0
  4160 000025D7 8B4604                   mov ax, [bp+4]
  4161 000025DA C1E808                   shr ax, 8
  4162 000025DD 8946FE                   mov word [bp-2], ax
  4163 000025E0 FF76FE                   push word [bp-2]
  4164 000025E3 E89BFF                   call printhex8a
  4165 000025E6 83C402                   add  sp, 2
  4166                                  
  4167                                  ;-77     half = i & 255; printhex8a(half);
  4168                                  
  4169 000025E9 8B4604                   mov ax, [bp+4]
  4170 000025EC 25FF00                   and ax, 255
  4171 000025EF 8946FE                   mov word [bp-2], ax
  4172 000025F2 FF76FE                   push word [bp-2]
  4173 000025F5 E889FF                   call printhex8a
  4174 000025F8 83C402                   add  sp, 2
  4175                                  
  4176                                  ;-78 }
  4177                                  
  4178                                  
  4179                                  ;-79 int printIntU(unsigned int n) { 
  4180 000025FB C9                       LEAVE
  4181 000025FC C3                       ret
  4182                                  ; ENDP
  4183                                  
  4184                                  printIntU:  ; *** PROC ***
  4185                                  
  4186                                  ;-80     unsigned int e;
  4187                                  
  4188                                  
  4189                                  ;-81     if ( _ n >= 10) {  
  4190                                  
  4191                                  ;Function : printIntU, Number of local variables: 2
  4192                                  ;   # type sign width line used address name   list of local variables
  4193                                  ;  200 var unsg word    79 NULL bp+4    n
  4194                                  ;  201 var unsg word    80 NULL bp-2    e;
  4195 000025FD C8020000                 ENTER  2,0
  4196 00002601 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4197 00002605 0F821700                 jb  @@printIntU189
  4198                                  
  4199                                  ;-82         e=n/10; //DIV
  4200                                  
  4201 00002609 8B4604                   mov ax, [bp+4]
  4202 0000260C BB0A00                   mov bx, 10
  4203 0000260F BA0000                   mov dx, 0
  4204 00002612 F7F3                     div bx
  4205 00002614 8946FE                   mov word [bp-2], ax
  4206                                  
  4207                                  ;-83         printIntU(e); 
  4208                                  
  4209 00002617 FF76FE                   push word [bp-2]
  4210 0000261A E8E0FF                   call printIntU
  4211 0000261D 83C402                   add  sp, 2
  4212                                  
  4213                                  ;-84     }
  4214                                  
  4215                                  
  4216                                  ;-85     n = n % 10; //unsigned mod
  4217                                  
  4218                                  @@printIntU189:
  4219 00002620 8B4604                   mov ax, [bp+4]
  4220 00002623 BB0A00                   mov bx, 10
  4221 00002626 BA0000                   mov dx, 0
  4222 00002629 F7F3                     div bx
  4223 0000262B 89D0                     mov ax, dx
  4224 0000262D 894604                   mov word [bp+4], ax
  4225                                  
  4226                                  ;-86     n += '0'; 
  4227                                  
  4228 00002630 83460430                 add  word [bp+4], 48
  4229                                  
  4230                                  ;-87     prc(n);
  4231                                  
  4232 00002634 FF7604                   push word [bp+4]
  4233 00002637 E843FE                   call prc
  4234 0000263A 83C402                   add  sp, 2
  4235                                  
  4236                                  ;-88 }
  4237                                  
  4238                                  
  4239                                  ;-89 
  4240                                  
  4241                                  
  4242                                  ;-90 int error1(char *s) { 
  4243 0000263D C9                       LEAVE
  4244 0000263E C3                       ret
  4245                                  ; ENDP
  4246                                  
  4247                                  error1:  ; *** PROC ***
  4248                                  
  4249                                  ;-91     LIST=1; 
  4250                                  
  4251                                  ;Function : error1, Number of local variables: 1
  4252                                  ;   # type sign width line used address name   list of local variables
  4253                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  4254 0000263F C8000000                 ENTER  0,0
  4255 00002643 66B801000000             mov eax, 1
  4256 00002649 A2[0E00]                 mov byte [LIST], al
  4257                                  
  4258                                  ;-92     ErrorCount++;
  4259                                  
  4260 0000264C FF06[A101]               inc  word [ErrorCount]
  4261                                  
  4262                                  ;-93     prs("\n;***** next line ERROR: "); 
  4263                                  
  4264 00002650 68[7826]                 push error1_0
  4265 00002653 E888FE                   call prs
  4266 00002656 83C402                   add  sp, 2
  4267                                  
  4268                                  ;-94     prs(s);
  4269                                  
  4270 00002659 FF7604                   push word [bp+4]
  4271 0000265C E87FFE                   call prs
  4272 0000265F 83C402                   add  sp, 2
  4273                                  
  4274                                  ;-95     prs(", Symbol: "); 
  4275                                  
  4276 00002662 68[9326]                 push error1_1
  4277 00002665 E876FE                   call prs
  4278 00002668 83C402                   add  sp, 2
  4279                                  
  4280                                  ;-96     prs(Symbol);
  4281                                  
  4282 0000266B 8D06[0F00]               lea  ax, [Symbol]
  4283 0000266F 50                       push ax
  4284 00002670 E86BFE                   call prs
  4285 00002673 83C402                   add  sp, 2
  4286                                  
  4287                                  ;-97 }
  4288                                  
  4289                                  
  4290                                  ;-98 int errorexit(char *s) { 
  4291 00002676 C9                       LEAVE
  4292 00002677 C3                       ret
  4293                                  ; ENDP
  4294 00002678 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4295 00002681 6E657874206C696E65-
  4296 0000268A 204552524F523A2000 
  4297 00002693 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4298 0000269C 2000               
  4299                                  
  4300                                  errorexit:  ; *** PROC ***
  4301                                  
  4302                                  ;-99     error1(s); 
  4303                                  
  4304                                  ;Function : errorexit, Number of local variables: 1
  4305                                  ;   # type sign width line used address name   list of local variables
  4306                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  4307 0000269E C8000000                 ENTER  0,0
  4308 000026A2 FF7604                   push word [bp+4]
  4309 000026A5 E897FF                   call error1
  4310 000026A8 83C402                   add  sp, 2
  4311                                  
  4312                                  ;-100     end1(1);
  4313                                  
  4314 000026AB 6A01                     push 1
  4315 000026AD E8C904                   call end1
  4316 000026B0 83C402                   add  sp, 2
  4317                                  
  4318                                  ;-101 }
  4319                                  
  4320                                  
  4321                                  ;-102 int allowederror() {error1("not allowed here"); }
  4322 000026B3 C9                       LEAVE
  4323 000026B4 C3                       ret
  4324                                  ; ENDP
  4325                                  
  4326                                  allowederror:  ; *** PROC ***
  4327 000026B5 68[BF26]                 push allowederror_0
  4328 000026B8 E884FF                   call error1
  4329 000026BB 83C402                   add  sp, 2
  4330                                  
  4331                                  ;-103 int addrerror()    {error1("address missing");} 
  4332                                  
  4333 000026BE C3                       ret
  4334                                  ; ENDP
  4335 000026BF 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4336 000026C8 6564206865726500   
  4337                                  
  4338                                  addrerror:  ; *** PROC ***
  4339 000026D0 68[DA26]                 push addrerror_0
  4340 000026D3 E869FF                   call error1
  4341 000026D6 83C402                   add  sp, 2
  4342                                  
  4343                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  4344                                  
  4345 000026D9 C3                       ret
  4346                                  ; ENDP
  4347 000026DA 61646472657373206D-     addrerror_0 db "address missing",0
  4348 000026E3 697373696E6700     
  4349                                  
  4350                                  immeerror:  ; *** PROC ***
  4351 000026EA 68[F426]                 push immeerror_0
  4352 000026ED E84FFF                   call error1
  4353 000026F0 83C402                   add  sp, 2
  4354                                  
  4355                                  ;-105 int implerror()    {error1("not implemented");}
  4356                                  
  4357 000026F3 C3                       ret
  4358                                  ; ENDP
  4359 000026F4 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4360 000026FD 206E6F7420616C6C6F-
  4361 00002706 776564206865726500 
  4362                                  
  4363                                  implerror:  ; *** PROC ***
  4364 0000270F 68[1927]                 push implerror_0
  4365 00002712 E82AFF                   call error1
  4366 00002715 83C402                   add  sp, 2
  4367                                  
  4368                                  ;-106 int indexerror()   {error1("invalid index register");}
  4369                                  
  4370 00002718 C3                       ret
  4371                                  ; ENDP
  4372 00002719 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4373 00002722 6D656E74656400     
  4374                                  
  4375                                  indexerror:  ; *** PROC ***
  4376 00002729 68[3327]                 push indexerror_0
  4377 0000272C E810FF                   call error1
  4378 0000272F 83C402                   add  sp, 2
  4379                                  
  4380                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  4381                                  
  4382 00002732 C3                       ret
  4383                                  ; ENDP
  4384 00002733 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4385 0000273C 6E6465782072656769-
  4386 00002745 7374657200         
  4387                                  
  4388                                  invaloperror:  ; *** PROC ***
  4389 0000274A 68[5427]                 push invaloperror_0
  4390 0000274D E8EFFE                   call error1
  4391 00002750 83C402                   add  sp, 2
  4392                                  
  4393                                  ;-108 int numbererror()  {error1("number expected");}
  4394                                  
  4395 00002753 C3                       ret
  4396                                  ; ENDP
  4397 00002754 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4398 0000275D 72206E6F206F706572-
  4399 00002766 616E647300         
  4400                                  
  4401                                  numbererror:  ; *** PROC ***
  4402 0000276B 68[7527]                 push numbererror_0
  4403 0000276E E8CEFE                   call error1
  4404 00002771 83C402                   add  sp, 2
  4405                                  
  4406                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  4407                                  
  4408 00002774 C3                       ret
  4409                                  ; ENDP
  4410 00002775 6E756D626572206578-     numbererror_0 db "number expected",0
  4411 0000277E 70656374656400     
  4412                                  
  4413                                  regmemerror:  ; *** PROC ***
  4414 00002785 68[8F27]                 push regmemerror_0
  4415 00002788 E8B4FE                   call error1
  4416 0000278B 83C402                   add  sp, 2
  4417                                  
  4418                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  4419                                  
  4420 0000278E C3                       ret
  4421                                  ; ENDP
  4422 0000278F 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4423 00002798 73746572206F72206D-
  4424 000027A1 656D6F727920616C6C-
  4425 000027AA 6F77656400         
  4426                                  
  4427                                  reg16error:  ; *** PROC ***
  4428 000027AF 68[B927]                 push reg16error_0
  4429 000027B2 E88AFE                   call error1
  4430 000027B5 83C402                   add  sp, 2
  4431                                  
  4432                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  4433                                  
  4434 000027B8 C3                       ret
  4435                                  ; ENDP
  4436 000027B9 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4437 000027C2 362C206E6F20736567-
  4438 000027CB 72656720616C6C6F77-
  4439 000027D4 656400             
  4440                                  
  4441                                  segregerror:  ; *** PROC ***
  4442 000027D7 68[E127]                 push segregerror_0
  4443 000027DA E862FE                   call error1
  4444 000027DD 83C402                   add  sp, 2
  4445                                  
  4446                                  ;-112 int syntaxerror()  {error1("syntax");}
  4447                                  
  4448 000027E0 C3                       ret
  4449                                  ; ENDP
  4450 000027E1 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4451 000027EA 65676973746572206E-
  4452 000027F3 6F7420616C6C6F7765-
  4453 000027FC 6400               
  4454                                  
  4455                                  syntaxerror:  ; *** PROC ***
  4456 000027FE 68[0828]                 push syntaxerror_0
  4457 00002801 E83BFE                   call error1
  4458 00002804 83C402                   add  sp, 2
  4459                                  
  4460                                  ;-113          
  4461                                  
  4462                                  
  4463                                  ;-114 int addrexit()     {errorexit("illegal address");}
  4464                                  
  4465 00002807 C3                       ret
  4466                                  ; ENDP
  4467 00002808 73796E74617800          syntaxerror_0 db "syntax",0
  4468                                  
  4469                                  addrexit:  ; *** PROC ***
  4470 0000280F 68[1928]                 push addrexit_0
  4471 00002812 E889FE                   call errorexit
  4472 00002815 83C402                   add  sp, 2
  4473                                  
  4474                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  4475                                  
  4476 00002818 C3                       ret
  4477                                  ; ENDP
  4478 00002819 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4479 00002822 64647265737300     
  4480                                  
  4481                                  internexit:  ; *** PROC ***
  4482 00002829 68[3328]                 push internexit_0
  4483 0000282C E86FFE                   call errorexit
  4484 0000282F 83C402                   add  sp, 2
  4485 00002832 C3                       ret
  4486                                  ; ENDP
  4487 00002833 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4488 0000283C 6D70696C6572206572-
  4489 00002845 726F7200           
  4490                                  ;Back to main program: AS.C
  4491                                  
  4492                                  ;-8 #include "MAIN.C"
  4493                                  
  4494                                  ;Use include file: MAIN.C
  4495                                  
  4496                                  ;-1 int main() {
  4497                                  
  4498                                  
  4499                                  main:  ; *** PROC ***
  4500                                  
  4501                                  ;-2     getarg(); 
  4502                                  
  4503 00002849 E80A00                   call getarg
  4504                                  
  4505                                  ;-3     parse(); 
  4506                                  
  4507 0000284C E8D8EE                   call parse
  4508                                  
  4509                                  ;-4     epilog(); 
  4510                                  
  4511 0000284F E85C02                   call epilog
  4512                                  
  4513                                  ;-5     end1();
  4514                                  
  4515 00002852 E82403                   call end1
  4516                                  
  4517                                  ;-6 }
  4518                                  
  4519                                  
  4520                                  ;-7 
  4521                                  
  4522                                  
  4523                                  ;-8 int getarg() { 
  4524                                  
  4525 00002855 C3                       ret
  4526                                  ; ENDP
  4527                                  
  4528                                  getarg:  ; *** PROC ***
  4529                                  
  4530                                  ;-9     int arglen1; int i; char *c;
  4531                                  
  4532                                  
  4533                                  ;-10     arglen1=*arglen;
  4534                                  
  4535                                  ;Function : getarg, Number of local variables: 3
  4536                                  ;   # type sign width line used address name   list of local variables
  4537                                  ;  200 var sign word     9 NULL bp-2    arglen1
  4538                                  ;  201 var sign word     9 NULL bp-4    i
  4539                                  ;  202 ptr sign byte     9 NULL bp-6    c;
  4540 00002856 C8060000                 ENTER  6,0
  4541 0000285A 8B1E[520E]               mov bx, [arglen]
  4542 0000285E 8A07                     mov al, [bx]
  4543 00002860 B400                     mov ah, 0
  4544 00002862 8946FE                   mov word [bp-2], ax
  4545                                  
  4546                                  ;-11     if (arglen1==0) {
  4547                                  
  4548 00002865 8B46FE                   mov ax, [bp-2]
  4549 00002868 83F800                   cmp ax, 0
  4550 0000286B 0F851C00                 jne @@getarg190
  4551                                  
  4552                                  ;-12         cputs(Version1);
  4553                                  
  4554 0000286F 8D06[0300]               lea  ax, [Version1]
  4555 00002873 50                       push ax
  4556 00002874 E86809                   call cputs
  4557 00002877 83C402                   add  sp, 2
  4558                                  
  4559                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4560                                  
  4561 0000287A 68[1B2A]                 push getarg_0
  4562 0000287D E85F09                   call cputs
  4563 00002880 83C402                   add  sp, 2
  4564                                  
  4565                                  ;-14         exitR(3);
  4566                                  
  4567 00002883 6A03                     push 3
  4568 00002885 E8320B                   call exitR
  4569 00002888 83C402                   add  sp, 2
  4570                                  
  4571                                  ;-15     }
  4572                                  
  4573                                  
  4574                                  ;-16     i=arglen1+129; 
  4575                                  
  4576                                  @@getarg190:
  4577 0000288B 8B46FE                   mov ax, [bp-2]
  4578 0000288E 058100                   add ax, 129
  4579 00002891 8946FC                   mov word [bp-4], ax
  4580                                  
  4581                                  ;-17     *i=0;  
  4582                                  
  4583 00002894 66B800000000             mov eax, 0
  4584 0000289A 8B5EFC                   mov  bx, [bp-4]
  4585 0000289D 8907                     mov  [bx], ax
  4586                                  
  4587                                  ;-18     arglen1--;
  4588                                  
  4589 0000289F FF4EFE                   dec  word [bp-2]
  4590                                  
  4591                                  ;-19     toupper(argv);
  4592                                  
  4593 000028A2 FF36[540E]               push word [argv]
  4594 000028A6 E86409                   call toupper
  4595 000028A9 83C402                   add  sp, 2
  4596                                  
  4597                                  ;-20   
  4598                                  
  4599                                  
  4600                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4601                                  
  4602 000028AC FF36[540E]               push word [argv]
  4603 000028B0 8D06[D000]               lea  ax, [namein]
  4604 000028B4 50                       push ax
  4605 000028B5 E8C309                   call strcpy
  4606 000028B8 83C404                   add  sp, 4
  4607 000028BB 68[402A]                 push getarg_1
  4608 000028BE 8D06[D000]               lea  ax, [namein]
  4609 000028C2 50                       push ax
  4610 000028C3 E8760A                   call strcat1
  4611 000028C6 83C404                   add  sp, 4
  4612                                  
  4613                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4614                                  
  4615 000028C9 FF36[540E]               push word [argv]
  4616 000028CD 8D06[1301]               lea  ax, [namelst]
  4617 000028D1 50                       push ax
  4618 000028D2 E8A609                   call strcpy
  4619 000028D5 83C404                   add  sp, 4
  4620 000028D8 68[432A]                 push getarg_2
  4621 000028DB 8D06[1301]               lea  ax, [namelst]
  4622 000028DF 50                       push ax
  4623 000028E0 E8590A                   call strcat1
  4624 000028E3 83C404                   add  sp, 4
  4625                                  
  4626                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4627                                  
  4628 000028E6 FF36[540E]               push word [argv]
  4629 000028EA 8D06[5601]               lea  ax, [namebin]
  4630 000028EE 50                       push ax
  4631 000028EF E88909                   call strcpy
  4632 000028F2 83C404                   add  sp, 4
  4633 000028F5 68[482A]                 push getarg_3
  4634 000028F8 8D06[5601]               lea  ax, [namebin]
  4635 000028FC 50                       push ax
  4636 000028FD E83C0A                   call strcat1
  4637 00002900 83C404                   add  sp, 4
  4638                                  
  4639                                  ;-24 
  4640                                  
  4641                                  
  4642                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4643                                  
  4644 00002903 66B801000000             mov eax, 1
  4645 00002909 A2[0E00]                 mov byte [LIST], al
  4646 0000290C 66B800000000             mov eax, 0
  4647 00002912 A3[9F01]                 mov word [DOS_ERR], ax
  4648 00002915 66B800000000             mov eax, 0
  4649 0000291B A3[A601]                 mov word [PC], ax
  4650 0000291E 66B800000000             mov eax, 0
  4651 00002924 A3[A101]                 mov word [ErrorCount], ax
  4652                                  
  4653                                  ;-26   
  4654                                  
  4655                                  
  4656                                  ;-27     asm_fd=openR (namein);
  4657                                  
  4658 00002927 8D06[D000]               lea  ax, [namein]
  4659 0000292B 50                       push ax
  4660 0000292C E8320A                   call openR
  4661 0000292F 83C402                   add  sp, 2
  4662 00002932 A3[9901]                 mov word [asm_fd], ax
  4663                                  
  4664                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4665                                  
  4666 00002935 A1[9F01]                 mov ax, [DOS_ERR]
  4667 00002938 08C0                     or  al, al
  4668 0000293A 0F841C00                 je @@getarg191
  4669 0000293E 68[4D2A]                 push getarg_4
  4670 00002941 E89B08                   call cputs
  4671 00002944 83C402                   add  sp, 2
  4672 00002947 8D06[D000]               lea  ax, [namein]
  4673 0000294B 50                       push ax
  4674 0000294C E89008                   call cputs
  4675 0000294F 83C402                   add  sp, 2
  4676 00002952 6A01                     push 1
  4677 00002954 E8630A                   call exitR
  4678 00002957 83C402                   add  sp, 2
  4679                                  
  4680                                  ;-29     lst_fd=creatR(namelst);
  4681                                  
  4682                                  @@getarg191:
  4683 0000295A 8D06[1301]               lea  ax, [namelst]
  4684 0000295E 50                       push ax
  4685 0000295F E80E0A                   call creatR
  4686 00002962 83C402                   add  sp, 2
  4687 00002965 A3[9B01]                 mov word [lst_fd], ax
  4688                                  
  4689                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4690                                  
  4691 00002968 A1[9F01]                 mov ax, [DOS_ERR]
  4692 0000296B 08C0                     or  al, al
  4693 0000296D 0F841C00                 je @@getarg192
  4694 00002971 68[632A]                 push getarg_5
  4695 00002974 E86808                   call cputs
  4696 00002977 83C402                   add  sp, 2
  4697 0000297A 8D06[1301]               lea  ax, [namelst]
  4698 0000297E 50                       push ax
  4699 0000297F E85D08                   call cputs
  4700 00002982 83C402                   add  sp, 2
  4701 00002985 6A02                     push 2
  4702 00002987 E8300A                   call exitR
  4703 0000298A 83C402                   add  sp, 2
  4704                                  
  4705                                  ;-31     bin_fd=creatR(namebin);
  4706                                  
  4707                                  @@getarg192:
  4708 0000298D 8D06[5601]               lea  ax, [namebin]
  4709 00002991 50                       push ax
  4710 00002992 E8DB09                   call creatR
  4711 00002995 83C402                   add  sp, 2
  4712 00002998 A3[9D01]                 mov word [bin_fd], ax
  4713                                  
  4714                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4715                                  
  4716 0000299B A1[9F01]                 mov ax, [DOS_ERR]
  4717 0000299E 08C0                     or  al, al
  4718 000029A0 0F841C00                 je @@getarg193
  4719 000029A4 68[7A2A]                 push getarg_6
  4720 000029A7 E83508                   call cputs
  4721 000029AA 83C402                   add  sp, 2
  4722 000029AD 8D06[5601]               lea  ax, [namebin]
  4723 000029B1 50                       push ax
  4724 000029B2 E82A08                   call cputs
  4725 000029B5 83C402                   add  sp, 2
  4726 000029B8 6A02                     push 2
  4727 000029BA E8FD09                   call exitR
  4728 000029BD 83C402                   add  sp, 2
  4729                                  
  4730                                  ;-33   
  4731                                  
  4732                                  
  4733                                  ;-34     prs(";"); 
  4734                                  
  4735                                  @@getarg193:
  4736 000029C0 68[902A]                 push getarg_7
  4737 000029C3 E818FB                   call prs
  4738 000029C6 83C402                   add  sp, 2
  4739                                  
  4740                                  ;-35     prs(Version1);
  4741                                  
  4742 000029C9 8D06[0300]               lea  ax, [Version1]
  4743 000029CD 50                       push ax
  4744 000029CE E80DFB                   call prs
  4745 000029D1 83C402                   add  sp, 2
  4746                                  
  4747                                  ;-36     prs(", Source: "); prs(namein);  
  4748                                  
  4749 000029D4 68[922A]                 push getarg_8
  4750 000029D7 E804FB                   call prs
  4751 000029DA 83C402                   add  sp, 2
  4752 000029DD 8D06[D000]               lea  ax, [namein]
  4753 000029E1 50                       push ax
  4754 000029E2 E8F9FA                   call prs
  4755 000029E5 83C402                   add  sp, 2
  4756                                  
  4757                                  ;-37     prs(", Output: "); prs(namelst);
  4758                                  
  4759 000029E8 68[9D2A]                 push getarg_9
  4760 000029EB E8F0FA                   call prs
  4761 000029EE 83C402                   add  sp, 2
  4762 000029F1 8D06[1301]               lea  ax, [namelst]
  4763 000029F5 50                       push ax
  4764 000029F6 E8E5FA                   call prs
  4765 000029F9 83C402                   add  sp, 2
  4766                                  
  4767                                  ;-38     prs(", "); prs(namebin);
  4768                                  
  4769 000029FC 68[A82A]                 push getarg_10
  4770 000029FF E8DCFA                   call prs
  4771 00002A02 83C402                   add  sp, 2
  4772 00002A05 8D06[5601]               lea  ax, [namebin]
  4773 00002A09 50                       push ax
  4774 00002A0A E8D1FA                   call prs
  4775 00002A0D 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-39     prs("\n");
  4778                                  
  4779 00002A10 68[AB2A]                 push getarg_11
  4780 00002A13 E8C8FA                   call prs
  4781 00002A16 83C402                   add  sp, 2
  4782                                  
  4783                                  ;-40 }
  4784                                  
  4785                                  
  4786                                  ;-41 
  4787                                  
  4788                                  
  4789                                  ;-42 int epilog() { 
  4790 00002A19 C9                       LEAVE
  4791 00002A1A C3                       ret
  4792                                  ; ENDP
  4793 00002A1B 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4794 00002A24 41532E434F4D206669-
  4795 00002A2D 6C656E616D65205B77-
  4796 00002A36 2F6F202E535D203A20-
  4797 00002A3F 00                 
  4798 00002A40 2E5300                  getarg_1 db ".S",0
  4799 00002A43 2E4C535400              getarg_2 db ".LST",0
  4800 00002A48 2E434F4D00              getarg_3 db ".COM",0
  4801 00002A4D 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4802 00002A56 6C65206D697373696E-
  4803 00002A5F 673A2000           
  4804 00002A63 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4805 00002A6C 206E6F742063726561-
  4806 00002A75 74653A2000         
  4807 00002A7A 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4808 00002A83 6E6F74206372656174-
  4809 00002A8C 653A2000           
  4810 00002A90 3B00                    getarg_7 db ";",0
  4811 00002A92 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4812 00002A9B 2000               
  4813 00002A9D 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4814 00002AA6 2000               
  4815 00002AA8 2C2000                  getarg_10 db ", ",0
  4816 00002AAB 5C6E00                  getarg_11 db "\n",0
  4817                                  
  4818                                  epilog:  ; *** PROC ***
  4819                                  
  4820                                  ;-43     int i; int j; char c;
  4821                                  
  4822                                  
  4823                                  ;-44     prs("\n;END Errors: "); 
  4824                                  
  4825                                  ;Function : epilog, Number of local variables: 3
  4826                                  ;   # type sign width line used address name   list of local variables
  4827                                  ;  200 var sign word    43 NULL bp-2    i
  4828                                  ;  201 var sign word    43 NULL bp-4    j
  4829                                  ;  202 var sign byte    43 NULL bp-6    c;
  4830 00002AAE C8060000                 ENTER  6,0
  4831 00002AB2 68[3C2B]                 push epilog_0
  4832 00002AB5 E826FA                   call prs
  4833 00002AB8 83C402                   add  sp, 2
  4834                                  
  4835                                  ;-45     printIntU(ErrorCount);
  4836                                  
  4837 00002ABB FF36[A101]               push word [ErrorCount]
  4838 00002ABF E83BFB                   call printIntU
  4839 00002AC2 83C402                   add  sp, 2
  4840                                  
  4841                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  4842                                  
  4843 00002AC5 A1[A101]                 mov ax, [ErrorCount]
  4844 00002AC8 08C0                     or  al, al
  4845 00002ACA 0F840900                 je @@epilog194
  4846 00002ACE 68[4C2B]                 push epilog_1
  4847 00002AD1 E80AFA                   call prs
  4848 00002AD4 83C402                   add  sp, 2
  4849                                  
  4850                                  ;-47     prs(", Output: "); prs(namelst);
  4851                                  
  4852                                  @@epilog194:
  4853 00002AD7 68[5A2B]                 push epilog_2
  4854 00002ADA E801FA                   call prs
  4855 00002ADD 83C402                   add  sp, 2
  4856 00002AE0 8D06[1301]               lea  ax, [namelst]
  4857 00002AE4 50                       push ax
  4858 00002AE5 E8F6F9                   call prs
  4859 00002AE8 83C402                   add  sp, 2
  4860                                  
  4861                                  ;-48     prs(", COM file "); 
  4862                                  
  4863 00002AEB 68[652B]                 push epilog_3
  4864 00002AEE E8EDF9                   call prs
  4865 00002AF1 83C402                   add  sp, 2
  4866                                  
  4867                                  ;-49     printIntU(BinLen); 
  4868                                  
  4869 00002AF4 FF36[500E]               push word [BinLen]
  4870 00002AF8 E802FB                   call printIntU
  4871 00002AFB 83C402                   add  sp, 2
  4872                                  
  4873                                  ;-50     prs(" bytes.");
  4874                                  
  4875 00002AFE 68[712B]                 push epilog_4
  4876 00002B01 E8DAF9                   call prs
  4877 00002B04 83C402                   add  sp, 2
  4878                                  
  4879                                  ;-51 
  4880                                  
  4881                                  
  4882                                  ;-52     i=0;
  4883                                  
  4884 00002B07 66B800000000             mov eax, 0
  4885 00002B0D 8946FE                   mov word [bp-2], ax
  4886                                  
  4887                                  ;-53     do {
  4888                                  
  4889                                  @@epilog195:
  4890                                  
  4891                                  ;-54         c = FileBin[i];
  4892                                  
  4893 00002B10 8B5EFE                   mov bx, [bp-2]
  4894 00002B13 8A87[8006]               mov al, [FileBin + bx]
  4895 00002B17 8846FA                   mov byte [bp-6], al
  4896                                  
  4897                                  ;-55         fputcR(c, bin_fd);
  4898                                  
  4899 00002B1A FF36[9D01]               push word [bin_fd]
  4900 00002B1E 8A46FA                   mov al, byte [bp-6]
  4901 00002B21 B400                     mov ah, 0
  4902 00002B23 50                       push ax
  4903 00002B24 E87008                   call fputcR
  4904 00002B27 83C404                   add  sp, 4
  4905                                  
  4906                                  ;-56         i++;
  4907                                  
  4908 00002B2A FF46FE                   inc  word [bp-2]
  4909                                  
  4910                                  ;-57     } while (i < BinLen);
  4911                                  
  4912 00002B2D 8B46FE                   mov ax, [bp-2]
  4913 00002B30 3B06[500E]               cmp ax, [BinLen]
  4914 00002B34 0F8D0200                 jge @@epilog196
  4915 00002B38 EBD6                     jmp @@epilog195
  4916                                  @@epilog196:
  4917                                  
  4918                                  ;-58 }
  4919                                  
  4920                                  
  4921                                  ;-59 
  4922                                  
  4923                                  
  4924                                  ;-60 int end1(int n) {
  4925 00002B3A C9                       LEAVE
  4926 00002B3B C3                       ret
  4927                                  ; ENDP
  4928 00002B3C 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4929 00002B45 726F72733A2000     
  4930 00002B4C 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4931 00002B55 2A2A2A2000         
  4932 00002B5A 2C204F75747075743A-     epilog_2 db ", Output: ",0
  4933 00002B63 2000               
  4934 00002B65 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  4935 00002B6E 652000             
  4936 00002B71 2062797465732E00        epilog_4 db " bytes.",0
  4937                                  
  4938                                  end1:  ; *** PROC ***
  4939                                  
  4940                                  ;-61   fcloseR(asm_fd);
  4941                                  
  4942                                  ;Function : end1, Number of local variables: 1
  4943                                  ;   # type sign width line used address name   list of local variables
  4944                                  ;  200 var sign word    60 NULL bp+4    n;
  4945 00002B79 C8000000                 ENTER  0,0
  4946 00002B7D FF36[9901]               push word [asm_fd]
  4947 00002B81 E82808                   call fcloseR
  4948 00002B84 83C402                   add  sp, 2
  4949                                  
  4950                                  ;-62   fcloseR(lst_fd);
  4951                                  
  4952 00002B87 FF36[9B01]               push word [lst_fd]
  4953 00002B8B E81E08                   call fcloseR
  4954 00002B8E 83C402                   add  sp, 2
  4955                                  
  4956                                  ;-63   fcloseR(bin_fd);
  4957                                  
  4958 00002B91 FF36[9D01]               push word [bin_fd]
  4959 00002B95 E81408                   call fcloseR
  4960 00002B98 83C402                   add  sp, 2
  4961                                  
  4962                                  ;-64   exitR(n);
  4963                                  
  4964 00002B9B FF7604                   push word [bp+4]
  4965 00002B9E E81908                   call exitR
  4966 00002BA1 83C402                   add  sp, 2
  4967                                  
  4968                                  ;-65 }
  4969 00002BA4 C9                       LEAVE
  4970 00002BA5 C3                       ret
  4971                                  ; ENDP
  4972                                  ;Back to main program: AS.C
  4973                                  
  4974                                  ;-9 #include "GENCODE.C"
  4975                                  
  4976                                  ;Use include file: GENCODE.C
  4977                                  
  4978                                  ;-1 // generate code
  4979                                  
  4980                                  
  4981                                  ;-2 int getCodes() {
  4982                                  
  4983                                  
  4984                                  getCodes:  ; *** PROC ***
  4985                                  
  4986                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  4987                                  
  4988 00002BA6 FF06[C701]               inc  word [OpCodePtr]
  4989 00002BAA 8B1E[C701]               mov bx, [OpCodePtr]
  4990 00002BAE 8A07                     mov al, [bx]
  4991 00002BB0 B400                     mov ah, 0
  4992 00002BB2 A2[AF01]                 mov byte [Code1], al
  4993                                  
  4994                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4995                                  
  4996 00002BB5 FF06[C701]               inc  word [OpCodePtr]
  4997 00002BB9 8B1E[C701]               mov bx, [OpCodePtr]
  4998 00002BBD 8A07                     mov al, [bx]
  4999 00002BBF B400                     mov ah, 0
  5000 00002BC1 A2[B001]                 mov byte [Code2], al
  5001                                  
  5002                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5003                                  
  5004 00002BC4 FF06[C701]               inc  word [OpCodePtr]
  5005 00002BC8 8B1E[C701]               mov bx, [OpCodePtr]
  5006 00002BCC 8A07                     mov al, [bx]
  5007 00002BCE B400                     mov ah, 0
  5008 00002BD0 A2[B101]                 mov byte [Code3], al
  5009                                  
  5010                                  ;-6 }
  5011                                  
  5012                                  
  5013                                  ;-7 int gen66h() {genCode8(0x66);
  5014                                  
  5015 00002BD3 C3                       ret
  5016                                  ; ENDP
  5017                                  
  5018                                  gen66h:  ; *** PROC ***
  5019 00002BD4 6A66                     push 102
  5020 00002BD6 E83B00                   call genCode8
  5021 00002BD9 83C402                   add  sp, 2
  5022                                  
  5023                                  ;-8 }
  5024                                  
  5025                                  
  5026                                  ;-9 int genCode2(char c, char d) {
  5027                                  
  5028 00002BDC C3                       ret
  5029                                  ; ENDP
  5030                                  
  5031                                  genCode2:  ; *** PROC ***
  5032                                  
  5033                                  ;-10     c = c + d;
  5034                                  
  5035                                  ;Function : genCode2, Number of local variables: 2
  5036                                  ;   # type sign width line used address name   list of local variables
  5037                                  ;  200 var sign byte     9 NULL bp+4    c
  5038                                  ;  201 var sign byte     9 NULL bp+6    d;
  5039 00002BDD C8000000                 ENTER  0,0
  5040 00002BE1 8A4604                   mov al, [bp+4]
  5041 00002BE4 024606                   add al, [bp+6]
  5042 00002BE7 884604                   mov byte [bp+4], al
  5043                                  
  5044                                  ;-11     genCode8(c);
  5045                                  
  5046 00002BEA 8A4604                   mov al, byte [bp+4]
  5047 00002BED B400                     mov ah, 0
  5048 00002BEF 50                       push ax
  5049 00002BF0 E82100                   call genCode8
  5050 00002BF3 83C402                   add  sp, 2
  5051                                  
  5052                                  ;-12 }                             
  5053                                  
  5054                                  
  5055                                  ;-13 int genCodeW(char c) {
  5056 00002BF6 C9                       LEAVE
  5057 00002BF7 C3                       ret
  5058                                  ; ENDP
  5059                                  
  5060                                  genCodeW:  ; *** PROC ***
  5061                                  
  5062                                  ;-14     c = c + wflag;  
  5063                                  
  5064                                  ;Function : genCodeW, Number of local variables: 1
  5065                                  ;   # type sign width line used address name   list of local variables
  5066                                  ;  200 var sign byte    13 NULL bp+4    c;
  5067 00002BF8 C8000000                 ENTER  0,0
  5068 00002BFC 8A4604                   mov al, [bp+4]
  5069 00002BFF 0206[B701]               add al, [wflag]
  5070 00002C03 884604                   mov byte [bp+4], al
  5071                                  
  5072                                  ;-15     genCode8(c);
  5073                                  
  5074 00002C06 8A4604                   mov al, byte [bp+4]
  5075 00002C09 B400                     mov ah, 0
  5076 00002C0B 50                       push ax
  5077 00002C0C E80500                   call genCode8
  5078 00002C0F 83C402                   add  sp, 2
  5079                                  
  5080                                  ;-16 }   
  5081                                  
  5082                                  
  5083                                  ;-17 int genCode8(char c) {
  5084 00002C12 C9                       LEAVE
  5085 00002C13 C3                       ret
  5086                                  ; ENDP
  5087                                  
  5088                                  genCode8:  ; *** PROC ***
  5089                                  
  5090                                  ;-18 //set: BinLen++, OpPrintIndex++
  5091                                  
  5092                                  
  5093                                  ;-19     FileBin[BinLen]=c;
  5094                                  
  5095                                  ;Function : genCode8, Number of local variables: 1
  5096                                  ;   # type sign width line used address name   list of local variables
  5097                                  ;  200 var sign byte    17 NULL bp+4    c;
  5098 00002C14 C8000000                 ENTER  0,0
  5099 00002C18 8A4604                   mov al, [bp+4]
  5100 00002C1B 8B1E[500E]               mov bx, [BinLen]
  5101 00002C1F 8887[8006]               mov [FileBin+bx], al
  5102                                  
  5103                                  ;-20     BinLen++;
  5104                                  
  5105 00002C23 FF06[500E]               inc  word [BinLen]
  5106                                  
  5107                                  ;-21     PC++;
  5108                                  
  5109 00002C27 FF06[A601]               inc  word [PC]
  5110                                  
  5111                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5112                                  
  5113 00002C2B A1[500E]                 mov ax, [BinLen]
  5114 00002C2E 3DD007                   cmp ax, 2000 ;unsigned : 0
  5115 00002C31 0F820900                 jb  @@genCode8197
  5116 00002C35 68[592C]                 push genCode8_0
  5117 00002C38 E863FA                   call errorexit
  5118 00002C3B 83C402                   add  sp, 2
  5119                                  
  5120                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5121                                  
  5122                                  @@genCode8197:
  5123 00002C3E A1[C501]                 mov ax, [OpPrintIndex]
  5124 00002C41 83F805                   cmp ax, 5
  5125 00002C44 0F8D0F00                 jge @@genCode8198
  5126                                  
  5127                                  ;-24         OpPos[OpPrintIndex]=c;
  5128                                  
  5129 00002C48 8A4604                   mov al, [bp+4]
  5130 00002C4B 8B1E[C501]               mov bx, [OpPrintIndex]
  5131 00002C4F 8887[C001]               mov [OpPos+bx], al
  5132                                  
  5133                                  ;-25         OpPrintIndex++;
  5134                                  
  5135 00002C53 FF06[C501]               inc  word [OpPrintIndex]
  5136                                  
  5137                                  ;-26     }
  5138                                  
  5139                                  
  5140                                  ;-27 }
  5141                                  
  5142                                  @@genCode8198:
  5143                                  
  5144                                  ;-28 int genCode16(unsigned int i) {
  5145 00002C57 C9                       LEAVE
  5146 00002C58 C3                       ret
  5147                                  ; ENDP
  5148 00002C59 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5149 00002C62 746F6F206C6F6E6700 
  5150                                  
  5151                                  genCode16:  ; *** PROC ***
  5152                                  
  5153                                  ;-29     genCode8(i); i=i >> 8;
  5154                                  
  5155                                  ;Function : genCode16, Number of local variables: 1
  5156                                  ;   # type sign width line used address name   list of local variables
  5157                                  ;  200 var unsg word    28 NULL bp+4    i;
  5158 00002C6B C8000000                 ENTER  0,0
  5159 00002C6F FF7604                   push word [bp+4]
  5160 00002C72 E89FFF                   call genCode8
  5161 00002C75 83C402                   add  sp, 2
  5162 00002C78 8B4604                   mov ax, [bp+4]
  5163 00002C7B C1E808                   shr ax, 8
  5164 00002C7E 894604                   mov word [bp+4], ax
  5165                                  
  5166                                  ;-30     genCode8(i);
  5167                                  
  5168 00002C81 FF7604                   push word [bp+4]
  5169 00002C84 E88DFF                   call genCode8
  5170 00002C87 83C402                   add  sp, 2
  5171                                  
  5172                                  ;-31 }
  5173                                  
  5174                                  
  5175                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5176 00002C8A C9                       LEAVE
  5177 00002C8B C3                       ret
  5178                                  ; ENDP
  5179                                  
  5180                                  writeEA:  ; *** PROC ***
  5181                                  
  5182                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5183                                  
  5184                                  
  5185                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5186                                  
  5187                                  
  5188                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5189                                  
  5190                                  
  5191                                  ;-36     char len;
  5192                                  
  5193                                  
  5194                                  ;-37     len=0;   
  5195                                  
  5196                                  ;Function : writeEA, Number of local variables: 2
  5197                                  ;   # type sign width line used address name   list of local variables
  5198                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5199                                  ;  201 var sign byte    36 NULL bp-2    len;
  5200 00002C8C C8020000                 ENTER  2,0
  5201 00002C90 66B800000000             mov eax, 0
  5202 00002C96 8846FE                   mov byte [bp-2], al
  5203                                  
  5204                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5205                                  
  5206 00002C99 8A4604                   mov al, [bp+4]
  5207 00002C9C C0E003                   shl al, 3
  5208 00002C9F 884604                   mov byte [bp+4], al
  5209                                  
  5210                                  ;-39     if (Op == REG) {
  5211                                  
  5212 00002CA2 A0[AC01]                 mov al, [Op]
  5213 00002CA5 3C02                     cmp al, 2
  5214 00002CA7 0F853A00                 jne @@writeEA199
  5215                                  
  5216                                  ;-40         xxx |= 0xC0;     
  5217                                  
  5218 00002CAB 804E04C0                 or  byte [bp+4], 192
  5219                                  
  5220                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5221                                  
  5222 00002CAF A0[AD01]                 mov al, [Op2]
  5223 00002CB2 3C01                     cmp al, 1
  5224 00002CB4 0F8F0D00                 jg  @@writeEA200
  5225 00002CB8 8A4604                   mov al, [bp+4]
  5226 00002CBB 0206[B301]               add al, [R1No]
  5227 00002CBF 884604                   mov byte [bp+4], al
  5228                                  
  5229                                  ;-42             else {
  5230                                  
  5231 00002CC2 E92000                   jmp @@writeEA201
  5232                                  @@writeEA200:
  5233                                  
  5234                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5235                                  
  5236 00002CC5 A0[AD01]                 mov al, [Op2]
  5237 00002CC8 3C02                     cmp al, 2
  5238 00002CCA 0F850D00                 jne @@writeEA202
  5239 00002CCE 8A4604                   mov al, [bp+4]
  5240 00002CD1 0206[B301]               add al, [R1No]
  5241 00002CD5 884604                   mov byte [bp+4], al
  5242                                  
  5243                                  ;-44                 else            xxx = xxx + R2No;  
  5244                                  
  5245 00002CD8 E90A00                   jmp @@writeEA203
  5246                                  @@writeEA202:
  5247 00002CDB 8A4604                   mov al, [bp+4]
  5248 00002CDE 0206[B201]               add al, [R2No]
  5249 00002CE2 884604                   mov byte [bp+4], al
  5250                                  
  5251                                  ;-45             }
  5252                                  
  5253                                  @@writeEA203:
  5254                                  
  5255                                  ;-46         } 
  5256                                  
  5257                                  @@writeEA201:
  5258                                  
  5259                                  ;-47     if (Op == MEM) {
  5260                                  
  5261                                  @@writeEA199:
  5262 00002CE5 A0[AC01]                 mov al, [Op]
  5263 00002CE8 3C04                     cmp al, 4
  5264 00002CEA 0F857F00                 jne @@writeEA204
  5265                                  
  5266                                  ;-48         if (isDirect) {
  5267                                  
  5268 00002CEE A0[BB01]                 mov al, [isDirect]
  5269 00002CF1 08C0                     or  al, al
  5270 00002CF3 0F841000                 je @@writeEA205
  5271                                  
  5272                                  ;-49             xxx |= 6;
  5273                                  
  5274 00002CF7 804E0406                 or  byte [bp+4], 6
  5275                                  
  5276                                  ;-50             len = 2;
  5277                                  
  5278 00002CFB 66B802000000             mov eax, 2
  5279 00002D01 8846FE                   mov byte [bp-2], al
  5280                                  
  5281                                  ;-51         }
  5282                                  
  5283                                  
  5284                                  ;-52         else { 
  5285                                  
  5286 00002D04 E96600                   jmp @@writeEA206
  5287                                  @@writeEA205:
  5288                                  
  5289                                  ;-53             xxx = xxx + rm;   
  5290                                  
  5291 00002D07 8A4604                   mov al, [bp+4]
  5292 00002D0A 0206[BA01]               add al, [rm]
  5293 00002D0E 884604                   mov byte [bp+4], al
  5294                                  
  5295                                  ;-54             if (rm == 6) {//make [BP+00]
  5296                                  
  5297 00002D11 A0[BA01]                 mov al, [rm]
  5298 00002D14 3C06                     cmp al, 6
  5299 00002D16 0F851700                 jne @@writeEA207
  5300                                  
  5301                                  ;-55                 len=1;
  5302                                  
  5303 00002D1A 66B801000000             mov eax, 1
  5304 00002D20 8846FE                   mov byte [bp-2], al
  5305                                  
  5306                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5307                                  
  5308 00002D23 A1[BC01]                 mov ax, [disp]
  5309 00002D26 83F800                   cmp ax, 0
  5310 00002D29 0F850400                 jne @@writeEA208
  5311 00002D2D 804E0440                 or  byte [bp+4], 64
  5312                                  
  5313                                  ;-57             }
  5314                                  
  5315                                  @@writeEA208:
  5316                                  
  5317                                  ;-58 
  5318                                  
  5319                                  
  5320                                  ;-59             if (disp) {
  5321                                  
  5322                                  @@writeEA207:
  5323 00002D31 A1[BC01]                 mov ax, [disp]
  5324 00002D34 08C0                     or  al, al
  5325 00002D36 0F843300                 je @@writeEA209
  5326                                  
  5327                                  ;-60                 ax = disp;
  5328                                  
  5329 00002D3A A1[BC01]                 mov  ax, [disp]
  5330                                  
  5331                                  ;-61                 if(ax > 127) len=2;
  5332                                  
  5333 00002D3D 83F87F                   cmp  ax, 127
  5334 00002D40 0F8E0C00                 jle @@writeEA210
  5335 00002D44 66B802000000             mov eax, 2
  5336 00002D4A 8846FE                   mov byte [bp-2], al
  5337                                  
  5338                                  ;-62                 else len=1;
  5339                                  
  5340 00002D4D E90900                   jmp @@writeEA211
  5341                                  @@writeEA210:
  5342 00002D50 66B801000000             mov eax, 1
  5343 00002D56 8846FE                   mov byte [bp-2], al
  5344                                  
  5345                                  ;-63                 if (len == 1) xxx |= 0x40;
  5346                                  
  5347                                  @@writeEA211:
  5348 00002D59 8A46FE                   mov al, [bp-2]
  5349 00002D5C 3C01                     cmp al, 1
  5350 00002D5E 0F850700                 jne @@writeEA212
  5351 00002D62 804E0440                 or  byte [bp+4], 64
  5352                                  
  5353                                  ;-64                 else xxx |= 0x80;
  5354                                  
  5355 00002D66 E90400                   jmp @@writeEA213
  5356                                  @@writeEA212:
  5357 00002D69 804E0480                 or  byte [bp+4], 128
  5358                                  
  5359                                  ;-65             }
  5360                                  
  5361                                  @@writeEA213:
  5362                                  
  5363                                  ;-66         }
  5364                                  
  5365                                  @@writeEA209:
  5366                                  
  5367                                  ;-67     }  
  5368                                  
  5369                                  @@writeEA206:
  5370                                  
  5371                                  ;-68     
  5372                                  
  5373                                  
  5374                                  ;-69     genCode8(xxx);// gen second byte
  5375                                  
  5376                                  @@writeEA204:
  5377 00002D6D 8A4604                   mov al, byte [bp+4]
  5378 00002D70 B400                     mov ah, 0
  5379 00002D72 50                       push ax
  5380 00002D73 E89EFE                   call genCode8
  5381 00002D76 83C402                   add  sp, 2
  5382                                  
  5383                                  ;-70     if (len == 1) genCode8 (disp);
  5384                                  
  5385 00002D79 8A46FE                   mov al, [bp-2]
  5386 00002D7C 3C01                     cmp al, 1
  5387 00002D7E 0F850A00                 jne @@writeEA214
  5388 00002D82 FF36[BC01]               push word [disp]
  5389 00002D86 E88BFE                   call genCode8
  5390 00002D89 83C402                   add  sp, 2
  5391                                  
  5392                                  ;-71     if (len == 2) genCode16(disp);
  5393                                  
  5394                                  @@writeEA214:
  5395 00002D8C 8A46FE                   mov al, [bp-2]
  5396 00002D8F 3C02                     cmp al, 2
  5397 00002D91 0F850A00                 jne @@writeEA215
  5398 00002D95 FF36[BC01]               push word [disp]
  5399 00002D99 E8CFFE                   call genCode16
  5400 00002D9C 83C402                   add  sp, 2
  5401                                  
  5402                                  ;-72 }
  5403                                  
  5404                                  @@writeEA215:
  5405                                  
  5406                                  ;-73 
  5407                                  
  5408                                  
  5409                                  ;-74 int genImmediateSE() {
  5410 00002D9F C9                       LEAVE
  5411 00002DA0 C3                       ret
  5412                                  ; ENDP
  5413                                  
  5414                                  genImmediateSE:  ; *** PROC ***
  5415                                  
  5416                                  ;-75     if (sflag) genCode8(imme);
  5417                                  
  5418 00002DA1 A0[B901]                 mov al, [sflag]
  5419 00002DA4 08C0                     or  al, al
  5420 00002DA6 0F840D00                 je @@genImmediateSE216
  5421 00002DAA FF36[BE01]               push word [imme]
  5422 00002DAE E863FE                   call genCode8
  5423 00002DB1 83C402                   add  sp, 2
  5424                                  
  5425                                  ;-76     else genImmediate();    
  5426                                  
  5427 00002DB4 E90300                   jmp @@genImmediateSE217
  5428                                  @@genImmediateSE216:
  5429 00002DB7 E80100                   call genImmediate
  5430                                  
  5431                                  ;-77 }
  5432                                  
  5433                                  @@genImmediateSE217:
  5434                                  
  5435                                  ;-78 int genImmediate() { 
  5436                                  
  5437 00002DBA C3                       ret
  5438                                  ; ENDP
  5439                                  
  5440                                  genImmediate:  ; *** PROC ***
  5441                                  
  5442                                  ;-79     if (wflag) genCode16(imme);
  5443                                  
  5444 00002DBB A0[B701]                 mov al, [wflag]
  5445 00002DBE 08C0                     or  al, al
  5446 00002DC0 0F840D00                 je @@genImmediate218
  5447 00002DC4 FF36[BE01]               push word [imme]
  5448 00002DC8 E8A0FE                   call genCode16
  5449 00002DCB 83C402                   add  sp, 2
  5450                                  
  5451                                  ;-80     else       genCode8 (imme);  
  5452                                  
  5453 00002DCE E90A00                   jmp @@genImmediate219
  5454                                  @@genImmediate218:
  5455 00002DD1 FF36[BE01]               push word [imme]
  5456 00002DD5 E83CFE                   call genCode8
  5457 00002DD8 83C402                   add  sp, 2
  5458                                  
  5459                                  ;-81 }    
  5460                                  
  5461                                  @@genImmediate219:
  5462 00002DDB C3                       ret
  5463                                  ; ENDP
  5464                                  ;Back to main program: AS.C
  5465                                  
  5466                                  ;-10 
  5467                                  
  5468                                  
  5469                                  ;-11 int process() { 
  5470                                  
  5471                                  
  5472                                  process:  ; *** PROC ***
  5473                                  
  5474                                  ;-12     char c;
  5475                                  
  5476                                  
  5477                                  ;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5478                                  
  5479                                  ;Function : process, Number of local variables: 1
  5480                                  ;   # type sign width line used address name   list of local variables
  5481                                  ;  200 var sign byte    12 NULL bp-2    c;
  5482 00002DDC C8020000                 ENTER  2,0
  5483 00002DE0 E82EEA                   call getTokeType
  5484                                  
  5485                                  ;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5486                                  
  5487 00002DE3 E87EED                   call getCodeSize
  5488 00002DE6 A2[B601]                 mov byte [OpSize], al
  5489                                  
  5490                                  ;-15     getCodes();//set: Code1, Code2, Code3
  5491                                  
  5492 00002DE9 E8BAFD                   call getCodes
  5493                                  
  5494                                  ;-16 
  5495                                  
  5496                                  
  5497                                  ;-17     if (CodeType ==  1) {//1 byte opcode
  5498                                  
  5499 00002DEC A0[AE01]                 mov al, [CodeType]
  5500 00002DEF 3C01                     cmp al, 1
  5501 00002DF1 0F850F00                 jne @@process220
  5502                                  
  5503                                  ;-18         genCode8(Code1);
  5504                                  
  5505 00002DF5 A0[AF01]                 mov al, byte [Code1]
  5506 00002DF8 B400                     mov ah, 0
  5507 00002DFA 50                       push ax
  5508 00002DFB E816FE                   call genCode8
  5509 00002DFE 83C402                   add  sp, 2
  5510                                  
  5511                                  ;-19         return;
  5512                                  
  5513 00002E01 E9A603                   jmp @@retn
  5514                                  
  5515                                  ;-20     }
  5516                                  
  5517                                  
  5518                                  ;-21   
  5519                                  
  5520                                  
  5521                                  ;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  5522                                  
  5523                                  @@process220:
  5524 00002E04 A0[AE01]                 mov al, [CodeType]
  5525 00002E07 3C02                     cmp al, 2
  5526 00002E09 0F856900                 jne @@process221
  5527                                  
  5528                                  ;-23         getOpL();
  5529                                  
  5530 00002E0D E81DE5                   call getOpL
  5531                                  
  5532                                  ;-24         checkOpL();        
  5533                                  
  5534 00002E10 E821E4                   call checkOpL
  5535                                  
  5536                                  ;-25         if (Code2 <= 1) {//inc,dec
  5537                                  
  5538 00002E13 A0[B001]                 mov al, [Code2]
  5539 00002E16 3C01                     cmp al, 1
  5540 00002E18 0F8F2700                 jg  @@process222
  5541                                  
  5542                                  ;-26   	        if (Op == REG) {//short
  5543                                  
  5544 00002E1C A0[AC01]                 mov al, [Op]
  5545 00002E1F 3C02                     cmp al, 2
  5546 00002E21 0F851E00                 jne @@process223
  5547                                  
  5548                                  ;-27                 if (wflag) {genCode2(Code3, R1No); return; }
  5549                                  
  5550 00002E25 A0[B701]                 mov al, [wflag]
  5551 00002E28 08C0                     or  al, al
  5552 00002E2A 0F841500                 je @@process224
  5553 00002E2E A0[B301]                 mov al, byte [R1No]
  5554 00002E31 B400                     mov ah, 0
  5555 00002E33 50                       push ax
  5556 00002E34 A0[B101]                 mov al, byte [Code3]
  5557 00002E37 B400                     mov ah, 0
  5558 00002E39 50                       push ax
  5559 00002E3A E8A0FD                   call genCode2
  5560 00002E3D 83C404                   add  sp, 4
  5561 00002E40 E96703                   jmp @@retn
  5562                                  
  5563                                  ;-28             }
  5564                                  
  5565                                  @@process224:
  5566                                  
  5567                                  ;-29         }
  5568                                  
  5569                                  @@process223:
  5570                                  
  5571                                  ;-30         if (Code2 == 5) {//imul extension?
  5572                                  
  5573                                  @@process222:
  5574 00002E43 A0[B001]                 mov al, [Code2]
  5575 00002E46 3C05                     cmp al, 5
  5576 00002E48 0F850F00                 jne @@process225
  5577                                  
  5578                                  ;-31             getTokeType();
  5579                                  
  5580 00002E4C E8C2E9                   call getTokeType
  5581                                  
  5582                                  ;-32             if (TokeType) implerror();
  5583                                  
  5584 00002E4F A0[AB01]                 mov al, [TokeType]
  5585 00002E52 08C0                     or  al, al
  5586 00002E54 0F840300                 je @@process226
  5587 00002E58 E8B4F8                   call implerror
  5588                                  
  5589                                  ;-33         }
  5590                                  
  5591                                  @@process226:
  5592                                  
  5593                                  ;-34         genCodeW(Code1);           
  5594                                  
  5595                                  @@process225:
  5596 00002E5B A0[AF01]                 mov al, byte [Code1]
  5597 00002E5E B400                     mov ah, 0
  5598 00002E60 50                       push ax
  5599 00002E61 E894FD                   call genCodeW
  5600 00002E64 83C402                   add  sp, 2
  5601                                  
  5602                                  ;-35         writeEA(Code2);
  5603                                  
  5604 00002E67 A0[B001]                 mov al, byte [Code2]
  5605 00002E6A B400                     mov ah, 0
  5606 00002E6C 50                       push ax
  5607 00002E6D E81CFE                   call writeEA
  5608 00002E70 83C402                   add  sp, 2
  5609                                  
  5610                                  ;-36         return;
  5611                                  
  5612 00002E73 E93403                   jmp @@retn
  5613                                  
  5614                                  ;-37     }
  5615                                  
  5616                                  
  5617                                  ;-38   
  5618                                  
  5619                                  
  5620                                  ;-39     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5621                                  
  5622                                  @@process221:
  5623 00002E76 A0[AE01]                 mov al, [CodeType]
  5624 00002E79 3C03                     cmp al, 3
  5625 00002E7B 0F855100                 jne @@process227
  5626                                  
  5627                                  ;-40         check2Ops();    //setwflag not applicable
  5628                                  
  5629 00002E7F E865E4                   call check2Ops
  5630                                  
  5631                                  ;-41         if (R1Type != WORD) reg16error();//only r16
  5632                                  
  5633 00002E82 A0[B501]                 mov al, [R1Type]
  5634 00002E85 3C02                     cmp al, 2
  5635 00002E87 0F840300                 je  @@process228
  5636 00002E8B E821F9                   call reg16error
  5637                                  
  5638                                  ;-42         if (Op2 != MEM) addrerror();//only m16 
  5639                                  
  5640                                  @@process228:
  5641 00002E8E A0[AD01]                 mov al, [Op2]
  5642 00002E91 3C04                     cmp al, 4
  5643 00002E93 0F840300                 je  @@process229
  5644 00002E97 E836F8                   call addrerror
  5645                                  
  5646                                  ;-43         
  5647                                  
  5648                                  
  5649                                  ;-44         genCode8(Code1);//les,lds,lea
  5650                                  
  5651                                  @@process229:
  5652 00002E9A A0[AF01]                 mov al, byte [Code1]
  5653 00002E9D B400                     mov ah, 0
  5654 00002E9F 50                       push ax
  5655 00002EA0 E871FD                   call genCode8
  5656 00002EA3 83C402                   add  sp, 2
  5657                                  
  5658                                  ;-45         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5659                                  
  5660 00002EA6 A0[AF01]                 mov al, [Code1]
  5661 00002EA9 3C0F                     cmp al, 15
  5662 00002EAB 0F850C00                 jne @@process230
  5663 00002EAF A0[B001]                 mov al, byte [Code2]
  5664 00002EB2 B400                     mov ah, 0
  5665 00002EB4 50                       push ax
  5666 00002EB5 E85CFD                   call genCode8
  5667 00002EB8 83C402                   add  sp, 2
  5668                                  
  5669                                  ;-46         Op=Op2;//set MEM for writeEA
  5670                                  
  5671                                  @@process230:
  5672 00002EBB A0[AD01]                 mov al, [Op2]
  5673 00002EBE A2[AC01]                 mov byte [Op], al
  5674                                  
  5675                                  ;-47         writeEA(R1No);           
  5676                                  
  5677 00002EC1 A0[B301]                 mov al, byte [R1No]
  5678 00002EC4 B400                     mov ah, 0
  5679 00002EC6 50                       push ax
  5680 00002EC7 E8C2FD                   call writeEA
  5681 00002ECA 83C402                   add  sp, 2
  5682                                  
  5683                                  ;-48         return;
  5684                                  
  5685 00002ECD E9DA02                   jmp @@retn
  5686                                  
  5687                                  ;-49     }
  5688                                  
  5689                                  
  5690                                  ;-50 
  5691                                  
  5692                                  
  5693                                  ;-51     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  5694                                  
  5695                                  @@process227:
  5696 00002ED0 A0[AE01]                 mov al, [CodeType]
  5697 00002ED3 3C04                     cmp al, 4
  5698 00002ED5 0F85D900                 jne @@process231
  5699                                  
  5700                                  ;-52         check2Ops();    
  5701                                  
  5702 00002ED9 E80BE4                   call check2Ops
  5703                                  
  5704                                  ;-53         if (Op2 == IMM) {//second operand is imm     
  5705                                  
  5706 00002EDC A0[AD01]                 mov al, [Op2]
  5707 00002EDF 3C01                     cmp al, 1
  5708 00002EE1 0F856300                 jne @@process232
  5709                                  
  5710                                  ;-54             setsflag();   
  5711                                  
  5712 00002EE5 E8E8E7                   call setsflag
  5713                                  
  5714                                  ;-55             if (Op == REG) {                
  5715                                  
  5716 00002EE8 A0[AC01]                 mov al, [Op]
  5717 00002EEB 3C02                     cmp al, 2
  5718 00002EED 0F853100                 jne @@process233
  5719                                  
  5720                                  ;-56                 if (R1No == 0) {// acc,imm   
  5721                                  
  5722 00002EF1 A0[B301]                 mov al, [R1No]
  5723 00002EF4 3C00                     cmp al, 0
  5724 00002EF6 0F852800                 jne @@process234
  5725                                  
  5726                                  ;-57                     if (sflag == 0) {                        
  5727                                  
  5728 00002EFA A0[B901]                 mov al, [sflag]
  5729 00002EFD 3C00                     cmp al, 0
  5730 00002EFF 0F851F00                 jne @@process235
  5731                                  
  5732                                  ;-58                         c = Code1 << 3;
  5733                                  
  5734 00002F03 A0[AF01]                 mov al, [Code1]
  5735 00002F06 C0E003                   shl al, 3
  5736 00002F09 8846FE                   mov byte [bp-2], al
  5737                                  
  5738                                  ;-59                         c += 4;    
  5739                                  
  5740 00002F0C 8046FE04                 add  byte [bp-2], 4
  5741                                  
  5742                                  ;-60                         genCodeW(c);
  5743                                  
  5744 00002F10 8A46FE                   mov al, byte [bp-2]
  5745 00002F13 B400                     mov ah, 0
  5746 00002F15 50                       push ax
  5747 00002F16 E8DFFC                   call genCodeW
  5748 00002F19 83C402                   add  sp, 2
  5749                                  
  5750                                  ;-61                         genImmediate();
  5751                                  
  5752 00002F1C E89CFE                   call genImmediate
  5753                                  
  5754                                  ;-62                         return;
  5755                                  
  5756 00002F1F E98802                   jmp @@retn
  5757                                  
  5758                                  ;-63                     }
  5759                                  
  5760                                  
  5761                                  ;-64                 }
  5762                                  
  5763                                  @@process235:
  5764                                  
  5765                                  ;-65             }
  5766                                  
  5767                                  @@process234:
  5768                                  
  5769                                  ;-66             //r/m, imm: 80 sign-extended,TTT,imm
  5770                                  
  5771                                  
  5772                                  ;-67             c = sflag + 0x80;   
  5773                                  
  5774                                  @@process233:
  5775 00002F22 A0[B901]                 mov al, [sflag]
  5776 00002F25 0480                     add al, 128
  5777 00002F27 8846FE                   mov byte [bp-2], al
  5778                                  
  5779                                  ;-68             genCodeW(c); 
  5780                                  
  5781 00002F2A 8A46FE                   mov al, byte [bp-2]
  5782 00002F2D B400                     mov ah, 0
  5783 00002F2F 50                       push ax
  5784 00002F30 E8C5FC                   call genCodeW
  5785 00002F33 83C402                   add  sp, 2
  5786                                  
  5787                                  ;-69             writeEA(Code1);  
  5788                                  
  5789 00002F36 A0[AF01]                 mov al, byte [Code1]
  5790 00002F39 B400                     mov ah, 0
  5791 00002F3B 50                       push ax
  5792 00002F3C E84DFD                   call writeEA
  5793 00002F3F 83C402                   add  sp, 2
  5794                                  
  5795                                  ;-70             genImmediateSE();
  5796                                  
  5797 00002F42 E85CFE                   call genImmediateSE
  5798                                  
  5799                                  ;-71             return;     
  5800                                  
  5801 00002F45 E96202                   jmp @@retn
  5802                                  
  5803                                  ;-72         }  
  5804                                  
  5805                                  
  5806                                  ;-73         c = Code1 << 3;//r/m, r/r  
  5807                                  
  5808                                  @@process232:
  5809 00002F48 A0[AF01]                 mov al, [Code1]
  5810 00002F4B C0E003                   shl al, 3
  5811 00002F4E 8846FE                   mov byte [bp-2], al
  5812                                  
  5813                                  ;-74         if (Op == REG) {
  5814                                  
  5815 00002F51 A0[AC01]                 mov al, [Op]
  5816 00002F54 3C02                     cmp al, 2
  5817 00002F56 0F852E00                 jne @@process236
  5818                                  
  5819                                  ;-75             if (Op2 == MEM) {//reg, mem      
  5820                                  
  5821 00002F5A A0[AD01]                 mov al, [Op2]
  5822 00002F5D 3C04                     cmp al, 4
  5823 00002F5F 0F852500                 jne @@process237
  5824                                  
  5825                                  ;-76                 c += 2;//add direction flag
  5826                                  
  5827 00002F63 8046FE02                 add  byte [bp-2], 2
  5828                                  
  5829                                  ;-77                 genCodeW(c);
  5830                                  
  5831 00002F67 8A46FE                   mov al, byte [bp-2]
  5832 00002F6A B400                     mov ah, 0
  5833 00002F6C 50                       push ax
  5834 00002F6D E888FC                   call genCodeW
  5835 00002F70 83C402                   add  sp, 2
  5836                                  
  5837                                  ;-78                 Op=Op2;//set MEM for writeEA                
  5838                                  
  5839 00002F73 A0[AD01]                 mov al, [Op2]
  5840 00002F76 A2[AC01]                 mov byte [Op], al
  5841                                  
  5842                                  ;-79                 writeEA(R1No);
  5843                                  
  5844 00002F79 A0[B301]                 mov al, byte [R1No]
  5845 00002F7C B400                     mov ah, 0
  5846 00002F7E 50                       push ax
  5847 00002F7F E80AFD                   call writeEA
  5848 00002F82 83C402                   add  sp, 2
  5849                                  
  5850                                  ;-80                 return;    
  5851                                  
  5852 00002F85 E92202                   jmp @@retn
  5853                                  
  5854                                  ;-81             }
  5855                                  
  5856                                  
  5857                                  ;-82         }
  5858                                  
  5859                                  @@process237:
  5860                                  
  5861                                  ;-83         if (Op2 == REG) {//mem,reg    reg,reg
  5862                                  
  5863                                  @@process236:
  5864 00002F88 A0[AD01]                 mov al, [Op2]
  5865 00002F8B 3C02                     cmp al, 2
  5866 00002F8D 0F851B00                 jne @@process238
  5867                                  
  5868                                  ;-84             genCodeW(c);
  5869                                  
  5870 00002F91 8A46FE                   mov al, byte [bp-2]
  5871 00002F94 B400                     mov ah, 0
  5872 00002F96 50                       push ax
  5873 00002F97 E85EFC                   call genCodeW
  5874 00002F9A 83C402                   add  sp, 2
  5875                                  
  5876                                  ;-85             writeEA(R2No);//2. Op in reg-field
  5877                                  
  5878 00002F9D A0[B201]                 mov al, byte [R2No]
  5879 00002FA0 B400                     mov ah, 0
  5880 00002FA2 50                       push ax
  5881 00002FA3 E8E6FC                   call writeEA
  5882 00002FA6 83C402                   add  sp, 2
  5883                                  
  5884                                  ;-86             return;            
  5885                                  
  5886 00002FA9 E9FE01                   jmp @@retn
  5887                                  
  5888                                  ;-87         }          
  5889                                  
  5890                                  
  5891                                  ;-88         syntaxerror();        
  5892                                  
  5893                                  @@process238:
  5894 00002FAC E84FF8                   call syntaxerror
  5895                                  
  5896                                  ;-89         return;
  5897                                  
  5898 00002FAF E9F801                   jmp @@retn
  5899                                  
  5900                                  ;-90     }
  5901                                  
  5902                                  
  5903                                  ;-91  
  5904                                  
  5905                                  
  5906                                  ;-92     if (CodeType == 5) {//mov (movsx, movzx=51)
  5907                                  
  5908                                  @@process231:
  5909 00002FB2 A0[AE01]                 mov al, [CodeType]
  5910 00002FB5 3C05                     cmp al, 5
  5911 00002FB7 0F858801                 jne @@process239
  5912                                  
  5913                                  ;-93         dflag=0;
  5914                                  
  5915 00002FBB 66B800000000             mov eax, 0
  5916 00002FC1 A2[B801]                 mov byte [dflag], al
  5917                                  
  5918                                  ;-94         check2Ops();    
  5919                                  
  5920 00002FC4 E820E3                   call check2Ops
  5921                                  
  5922                                  ;-95 /*    prs("\n Op:"); printhex8a(Op);
  5923                                  
  5924                                  
  5925                                  ;-96     prs(", Op2:"); printhex8a(Op2);
  5926                                  
  5927                                  
  5928                                  ;-97     prs(", R1No:"); printhex8a(R1No);
  5929                                  
  5930                                  
  5931                                  ;-98     prs(", R2No:"); printhex8a(R2No);   */  
  5932                                  
  5933                                  
  5934                                  ;-99         if (Op2 == ADR) {
  5935                                  
  5936 00002FC7 A0[AD01]                 mov al, [Op2]
  5937 00002FCA 3C03                     cmp al, 3
  5938 00002FCC 0F850F00                 jne @@process240
  5939                                  
  5940                                  ;-100             imme=disp;
  5941                                  
  5942 00002FD0 A1[BC01]                 mov ax, [disp]
  5943 00002FD3 A3[BE01]                 mov word [imme], ax
  5944                                  
  5945                                  ;-101             Op2=IMM;//continue with IMM    
  5946                                  
  5947 00002FD6 66B801000000             mov eax, 1
  5948 00002FDC A2[AD01]                 mov byte [Op2], al
  5949                                  
  5950                                  ;-102         }  
  5951                                  
  5952                                  
  5953                                  ;-103         if (Op2 == IMM) {// r,i     
  5954                                  
  5955                                  @@process240:
  5956 00002FDF A0[AD01]                 mov al, [Op2]
  5957 00002FE2 3C01                     cmp al, 1
  5958 00002FE4 0F855400                 jne @@process241
  5959                                  
  5960                                  ;-104             if (Op == REG) {               
  5961                                  
  5962 00002FE8 A0[AC01]                 mov al, [Op]
  5963 00002FEB 3C02                     cmp al, 2
  5964 00002FED 0F852500                 jne @@process242
  5965                                  
  5966                                  ;-105                 c = wflag << 3;   
  5967                                  
  5968 00002FF1 A0[B701]                 mov al, [wflag]
  5969 00002FF4 C0E003                   shl al, 3
  5970 00002FF7 8846FE                   mov byte [bp-2], al
  5971                                  
  5972                                  ;-106                 c += 0xB0;                                     
  5973                                  
  5974 00002FFA 8046FEB0                 add  byte [bp-2], 176
  5975                                  
  5976                                  ;-107                 genCode2(c, R1No);   
  5977                                  
  5978 00002FFE A0[B301]                 mov al, byte [R1No]
  5979 00003001 B400                     mov ah, 0
  5980 00003003 50                       push ax
  5981 00003004 8A46FE                   mov al, byte [bp-2]
  5982 00003007 B400                     mov ah, 0
  5983 00003009 50                       push ax
  5984 0000300A E8D0FB                   call genCode2
  5985 0000300D 83C404                   add  sp, 4
  5986                                  
  5987                                  ;-108                 genImmediate();
  5988                                  
  5989 00003010 E8A8FD                   call genImmediate
  5990                                  
  5991                                  ;-109                 return; 
  5992                                  
  5993 00003013 E99401                   jmp @@retn
  5994                                  
  5995                                  ;-110             }
  5996                                  
  5997                                  
  5998                                  ;-111             if (Op == MEM) {// m,i  
  5999                                  
  6000                                  @@process242:
  6001 00003016 A0[AC01]                 mov al, [Op]
  6002 00003019 3C04                     cmp al, 4
  6003 0000301B 0F851700                 jne @@process243
  6004                                  
  6005                                  ;-112                 genCodeW(0xC6);
  6006                                  
  6007 0000301F 68C600                   push 198
  6008 00003022 E8D3FB                   call genCodeW
  6009 00003025 83C402                   add  sp, 2
  6010                                  
  6011                                  ;-113                 writeEA( 0 );
  6012                                  
  6013 00003028 6A00                     push 0
  6014 0000302A E85FFC                   call writeEA
  6015 0000302D 83C402                   add  sp, 2
  6016                                  
  6017                                  ;-114                 genImmediate();
  6018                                  
  6019 00003030 E888FD                   call genImmediate
  6020                                  
  6021                                  ;-115                 return;  
  6022                                  
  6023 00003033 E97401                   jmp @@retn
  6024                                  
  6025                                  ;-116             }
  6026                                  
  6027                                  
  6028                                  ;-117             regmemerror();
  6029                                  
  6030                                  @@process243:
  6031 00003036 E84CF7                   call regmemerror
  6032                                  
  6033                                  ;-118             return;
  6034                                  
  6035 00003039 E96E01                   jmp @@retn
  6036                                  
  6037                                  ;-119         }      
  6038                                  
  6039                                  
  6040                                  ;-120         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6041                                  
  6042                                  @@process241:
  6043 0000303C A0[B501]                 mov al, [R1Type]
  6044 0000303F 3C04                     cmp al, 4
  6045 00003041 0F850300                 jne @@process244
  6046 00003045 E8A7E1                   call ChangeDirection
  6047                                  
  6048                                  ;-121         if (R2Type == SEGREG) {//rm,sreg
  6049                                  
  6050                                  @@process244:
  6051 00003048 A0[B401]                 mov al, [R2Type]
  6052 0000304B 3C04                     cmp al, 4
  6053 0000304D 0F852A00                 jne @@process245
  6054                                  
  6055                                  ;-122             if (OpSize != WORD) reg16error();
  6056                                  
  6057 00003051 A0[B601]                 mov al, [OpSize]
  6058 00003054 3C02                     cmp al, 2
  6059 00003056 0F840300                 je  @@process246
  6060 0000305A E852F7                   call reg16error
  6061                                  
  6062                                  ;-123                 genCode2(0x8C, dflag);
  6063                                  
  6064                                  @@process246:
  6065 0000305D A0[B801]                 mov al, byte [dflag]
  6066 00003060 B400                     mov ah, 0
  6067 00003062 50                       push ax
  6068 00003063 688C00                   push 140
  6069 00003066 E874FB                   call genCode2
  6070 00003069 83C404                   add  sp, 4
  6071                                  
  6072                                  ;-124                 writeEA(R2No);
  6073                                  
  6074 0000306C A0[B201]                 mov al, byte [R2No]
  6075 0000306F B400                     mov ah, 0
  6076 00003071 50                       push ax
  6077 00003072 E817FC                   call writeEA
  6078 00003075 83C402                   add  sp, 2
  6079                                  
  6080                                  ;-125                 return;   
  6081                                  
  6082 00003078 E92F01                   jmp @@retn
  6083                                  
  6084                                  ;-126         }          
  6085                                  
  6086                                  
  6087                                  ;-127         if (Op2 == MEM) {//acc, moffs16
  6088                                  
  6089                                  @@process245:
  6090 0000307B A0[AD01]                 mov al, [Op2]
  6091 0000307E 3C04                     cmp al, 4
  6092 00003080 0F853100                 jne @@process247
  6093                                  
  6094                                  ;-128             if (Op == REG) {
  6095                                  
  6096 00003084 A0[AC01]                 mov al, [Op]
  6097 00003087 3C02                     cmp al, 2
  6098 00003089 0F852800                 jne @@process248
  6099                                  
  6100                                  ;-129                 if (R1No == 0) {
  6101                                  
  6102 0000308D A0[B301]                 mov al, [R1No]
  6103 00003090 3C00                     cmp al, 0
  6104 00003092 0F851F00                 jne @@process249
  6105                                  
  6106                                  ;-130                     if (isDirect) {
  6107                                  
  6108 00003096 A0[BB01]                 mov al, [isDirect]
  6109 00003099 08C0                     or  al, al
  6110 0000309B 0F841600                 je @@process250
  6111                                  
  6112                                  ;-131                         genCodeW(0xA0);
  6113                                  
  6114 0000309F 68A000                   push 160
  6115 000030A2 E853FB                   call genCodeW
  6116 000030A5 83C402                   add  sp, 2
  6117                                  
  6118                                  ;-132                         genCode16(disp);
  6119                                  
  6120 000030A8 FF36[BC01]               push word [disp]
  6121 000030AC E8BCFB                   call genCode16
  6122 000030AF 83C402                   add  sp, 2
  6123                                  
  6124                                  ;-133                         return;   
  6125                                  
  6126 000030B2 E9F500                   jmp @@retn
  6127                                  
  6128                                  ;-134                     }   
  6129                                  
  6130                                  
  6131                                  ;-135                 }   
  6132                                  
  6133                                  @@process250:
  6134                                  
  6135                                  ;-136             }   
  6136                                  
  6137                                  @@process249:
  6138                                  
  6139                                  ;-137         } 
  6140                                  
  6141                                  @@process248:
  6142                                  
  6143                                  ;-138         if (Op == MEM) {//moffs16, acc
  6144                                  
  6145                                  @@process247:
  6146 000030B5 A0[AC01]                 mov al, [Op]
  6147 000030B8 3C04                     cmp al, 4
  6148 000030BA 0F853100                 jne @@process251
  6149                                  
  6150                                  ;-139             if (Op2 == REG) {
  6151                                  
  6152 000030BE A0[AD01]                 mov al, [Op2]
  6153 000030C1 3C02                     cmp al, 2
  6154 000030C3 0F852800                 jne @@process252
  6155                                  
  6156                                  ;-140                 if (R2No == 0) {
  6157                                  
  6158 000030C7 A0[B201]                 mov al, [R2No]
  6159 000030CA 3C00                     cmp al, 0
  6160 000030CC 0F851F00                 jne @@process253
  6161                                  
  6162                                  ;-141                     if (isDirect) {
  6163                                  
  6164 000030D0 A0[BB01]                 mov al, [isDirect]
  6165 000030D3 08C0                     or  al, al
  6166 000030D5 0F841600                 je @@process254
  6167                                  
  6168                                  ;-142                         genCodeW(0xA2);
  6169                                  
  6170 000030D9 68A200                   push 162
  6171 000030DC E819FB                   call genCodeW
  6172 000030DF 83C402                   add  sp, 2
  6173                                  
  6174                                  ;-143                         genCode16(disp);
  6175                                  
  6176 000030E2 FF36[BC01]               push word [disp]
  6177 000030E6 E882FB                   call genCode16
  6178 000030E9 83C402                   add  sp, 2
  6179                                  
  6180                                  ;-144                         return;   
  6181                                  
  6182 000030EC E9BB00                   jmp @@retn
  6183                                  
  6184                                  ;-145                     }   
  6185                                  
  6186                                  
  6187                                  ;-146                 }   
  6188                                  
  6189                                  @@process254:
  6190                                  
  6191                                  ;-147             }
  6192                                  
  6193                                  @@process253:
  6194                                  
  6195                                  ;-148         
  6196                                  
  6197                                  
  6198                                  ;-149         }
  6199                                  
  6200                                  @@process252:
  6201                                  
  6202                                  ;-150         if (Op2 == REG) {//rm, r
  6203                                  
  6204                                  @@process251:
  6205 000030EF A0[AD01]                 mov al, [Op2]
  6206 000030F2 3C02                     cmp al, 2
  6207 000030F4 0F851800                 jne @@process255
  6208                                  
  6209                                  ;-151             genCodeW(0x88);     
  6210                                  
  6211 000030F8 688800                   push 136
  6212 000030FB E8FAFA                   call genCodeW
  6213 000030FE 83C402                   add  sp, 2
  6214                                  
  6215                                  ;-152             writeEA(R2No);
  6216                                  
  6217 00003101 A0[B201]                 mov al, byte [R2No]
  6218 00003104 B400                     mov ah, 0
  6219 00003106 50                       push ax
  6220 00003107 E882FB                   call writeEA
  6221 0000310A 83C402                   add  sp, 2
  6222                                  
  6223                                  ;-153             return;
  6224                                  
  6225 0000310D E99A00                   jmp @@retn
  6226                                  
  6227                                  ;-154         }
  6228                                  
  6229                                  
  6230                                  ;-155         if (Op2 == MEM) {//r, m
  6231                                  
  6232                                  @@process255:
  6233 00003110 A0[AD01]                 mov al, [Op2]
  6234 00003113 3C04                     cmp al, 4
  6235 00003115 0F852400                 jne @@process256
  6236                                  
  6237                                  ;-156             if (Op == REG) {
  6238                                  
  6239 00003119 A0[AC01]                 mov al, [Op]
  6240 0000311C 3C02                     cmp al, 2
  6241 0000311E 0F851B00                 jne @@process257
  6242                                  
  6243                                  ;-157                 ChangeDirection();
  6244                                  
  6245 00003122 E8CAE0                   call ChangeDirection
  6246                                  
  6247                                  ;-158                 genCodeW(0x8A);
  6248                                  
  6249 00003125 688A00                   push 138
  6250 00003128 E8CDFA                   call genCodeW
  6251 0000312B 83C402                   add  sp, 2
  6252                                  
  6253                                  ;-159                 writeEA(R2No);
  6254                                  
  6255 0000312E A0[B201]                 mov al, byte [R2No]
  6256 00003131 B400                     mov ah, 0
  6257 00003133 50                       push ax
  6258 00003134 E855FB                   call writeEA
  6259 00003137 83C402                   add  sp, 2
  6260                                  
  6261                                  ;-160                 return;   
  6262                                  
  6263 0000313A E96D00                   jmp @@retn
  6264                                  
  6265                                  ;-161             }   
  6266                                  
  6267                                  
  6268                                  ;-162         }         
  6269                                  
  6270                                  @@process257:
  6271                                  
  6272                                  ;-163         syntaxerror();
  6273                                  
  6274                                  @@process256:
  6275 0000313D E8BEF6                   call syntaxerror
  6276                                  
  6277                                  ;-164         return;
  6278                                  
  6279 00003140 E96700                   jmp @@retn
  6280                                  
  6281                                  ;-165     }    
  6282                                  
  6283                                  
  6284                                  ;-166     
  6285                                  
  6286                                  
  6287                                  ;-167     if (CodeType ==  8) {//ret,retf
  6288                                  
  6289                                  @@process239:
  6290 00003143 A0[AE01]                 mov al, [CodeType]
  6291 00003146 3C08                     cmp al, 8
  6292 00003148 0F853100                 jne @@process258
  6293                                  
  6294                                  ;-168         if (TokeType == DIGIT) {
  6295                                  
  6296 0000314C A0[AB01]                 mov al, [TokeType]
  6297 0000314F 3C01                     cmp al, 1
  6298 00003151 0F851900                 jne @@process259
  6299                                  
  6300                                  ;-169             genCode8(Code2);
  6301                                  
  6302 00003155 A0[B001]                 mov al, byte [Code2]
  6303 00003158 B400                     mov ah, 0
  6304 0000315A 50                       push ax
  6305 0000315B E8B6FA                   call genCode8
  6306 0000315E 83C402                   add  sp, 2
  6307                                  
  6308                                  ;-170             genCode16(SymbolInt);
  6309                                  
  6310 00003161 FF36[4D00]               push word [SymbolInt]
  6311 00003165 E803FB                   call genCode16
  6312 00003168 83C402                   add  sp, 2
  6313                                  
  6314                                  ;-171             return;
  6315                                  
  6316 0000316B E93C00                   jmp @@retn
  6317                                  
  6318                                  ;-172         }
  6319                                  
  6320                                  
  6321                                  ;-173         genCode8(Code1); 
  6322                                  
  6323                                  @@process259:
  6324 0000316E A0[AF01]                 mov al, byte [Code1]
  6325 00003171 B400                     mov ah, 0
  6326 00003173 50                       push ax
  6327 00003174 E89DFA                   call genCode8
  6328 00003177 83C402                   add  sp, 2
  6329                                  
  6330                                  ;-174         return;
  6331                                  
  6332 0000317A E92D00                   jmp @@retn
  6333                                  
  6334                                  ;-175     }
  6335                                  
  6336                                  
  6337                                  ;-176 
  6338                                  
  6339                                  
  6340                                  ;-177     if (CodeType==101) {// ORG nn
  6341                                  
  6342                                  @@process258:
  6343 0000317D A0[AE01]                 mov al, [CodeType]
  6344 00003180 3C65                     cmp al, 101
  6345 00003182 0F851B00                 jne @@process260
  6346                                  
  6347                                  ;-178         if (TokeType != DIGIT) error1("only digit allowed");
  6348                                  
  6349 00003186 A0[AB01]                 mov al, [TokeType]
  6350 00003189 3C01                     cmp al, 1
  6351 0000318B 0F840900                 je  @@process261
  6352 0000318F 68[AC31]                 push process_0
  6353 00003192 E8AAF4                   call error1
  6354 00003195 83C402                   add  sp, 2
  6355                                  
  6356                                  ;-179         PC=SymbolInt;
  6357                                  
  6358                                  @@process261:
  6359 00003198 A1[4D00]                 mov ax, [SymbolInt]
  6360 0000319B A3[A601]                 mov word [PC], ax
  6361                                  
  6362                                  ;-180         return;
  6363                                  
  6364 0000319E E90900                   jmp @@retn
  6365                                  
  6366                                  ;-181     }
  6367                                  
  6368                                  
  6369                                  ;-182     error1("Command not implemented");
  6370                                  
  6371                                  @@process260:
  6372 000031A1 68[BF31]                 push process_1
  6373 000031A4 E898F4                   call error1
  6374 000031A7 83C402                   add  sp, 2
  6375                                  
  6376                                  ;-183 }    
  6377                                  
  6378 000031AA C9                      @@retn: LEAVE
  6379 000031AB C3                       ret
  6380                                  ; ENDP
  6381 000031AC 6F6E6C792064696769-     process_0 db "only digit allowed",0
  6382 000031B5 7420616C6C6F776564-
  6383 000031BE 00                 
  6384 000031BF 436F6D6D616E64206E-     process_1 db "Command not implemented",0
  6385 000031C8 6F7420696D706C656D-
  6386 000031D1 656E74656400       
  6387                                   
  6388                                  ; missing functions: 
  6389                                  ; digit
  6390                                  ; strcpy
  6391                                  ; eqstr
  6392                                  ; strlen
  6393                                  ; eqstr
  6394                                  ; eqstr
  6395                                  ; eqstr
  6396                                  ; eqstr
  6397                                  ; readRL
  6398                                  ; readRL
  6399                                  ; digit
  6400                                  ; digit
  6401                                  ; strcpy
  6402                                  ; toupper
  6403                                  ; strlen
  6404                                  ; strlen
  6405                                  ; eqstr
  6406                                  ; eqstr
  6407                                  ; eqstr
  6408                                  ; eqstr
  6409                                  ; eqstr
  6410                                  ; eqstr
  6411                                  ; eqstr
  6412                                  ; eqstr
  6413                                  ; eqstr
  6414                                  ; eqstr
  6415                                  ; eqstr
  6416                                  ; eqstr
  6417                                  ; eqstr
  6418                                  ; eqstr
  6419                                  ; eqstr
  6420                                  ; eqstr
  6421                                  ; eqstr
  6422                                  ; eqstr
  6423                                  ; eqstr
  6424                                  ; eqstr
  6425                                  ; eqstr
  6426                                  ; eqstr
  6427                                  ; eqstr
  6428                                  ; eqstr
  6429                                  ; eqstr
  6430                                  ; eqstr
  6431                                  ; eqstr
  6432                                  ; eqstr
  6433                                  ; eqstr
  6434                                  ; eqstr
  6435                                  ; writetty
  6436                                  ; writetty
  6437                                  ; fputcR
  6438                                  ; cputs
  6439                                  ; cputs
  6440                                  ; exitR
  6441                                  ; toupper
  6442                                  ; strcpy
  6443                                  ; strcat1
  6444                                  ; strcpy
  6445                                  ; strcat1
  6446                                  ; strcpy
  6447                                  ; strcat1
  6448                                  ; openR
  6449                                  ; cputs
  6450                                  ; cputs
  6451                                  ; exitR
  6452                                  ; creatR
  6453                                  ; cputs
  6454                                  ; cputs
  6455                                  ; exitR
  6456                                  ; creatR
  6457                                  ; cputs
  6458                                  ; cputs
  6459                                  ; exitR
  6460                                  ; fputcR
  6461                                  ; fcloseR
  6462                                  ; fcloseR
  6463                                  ; fcloseR
  6464                                  ; exitR
  6465                                  ; Number of unresolved CALLs :   76
  6466                                  ;use archive file: AR.C
  6467                                  
  6468                                  ;-184 // AR.C Archive
  6469                                  
  6470                                  ;Number of CALLs:    2 : writetty
  6471                                  
  6472                                  writetty:  ; *** PROC ***
  6473 000031D7 B40E                     mov  ah, 14
  6474 000031D9 BB0000                   mov  bx, 0
  6475 000031DC CD10                     int  16
  6476                                  
  6477                                  ;-185 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6478                                  
  6479 000031DE C3                       ret
  6480                                  ; ENDP
  6481                                  ;Number of CALLs:    8 : cputs
  6482                                  
  6483                                  cputs:  ; *** PROC ***
  6484                                  ;Function : cputs, Number of local variables: 2
  6485                                  ;   # type sign width line used address name   list of local variables
  6486                                  ;  200 ptr sign byte   185 NULL bp+4    s
  6487                                  ;  201 var sign byte   185 NULL bp-2    c;
  6488 000031DF C8020000                 ENTER  2,0
  6489                                  @@cputs262:
  6490 000031E3 8B5E04                   mov bx, [bp+4]
  6491 000031E6 8A07                     mov al, [bx]
  6492 000031E8 B400                     mov ah, 0
  6493 000031EA 08C0                     or  al, al
  6494 000031EC 0F841B00                 je @@cputs263
  6495 000031F0 8B5E04                   mov bx, [bp+4]
  6496 000031F3 8A07                     mov al, [bx]
  6497 000031F5 B400                     mov ah, 0
  6498 000031F7 8846FE                   mov byte [bp-2], al
  6499 000031FA 8A46FE                   mov al, byte [bp-2]
  6500 000031FD B400                     mov ah, 0
  6501 000031FF 50                       push ax
  6502 00003200 E8C401                   call putch
  6503 00003203 83C402                   add  sp, 2
  6504 00003206 FF4604                   inc  word [bp+4]
  6505 00003209 EBD8                     jmp @@cputs262
  6506                                  @@cputs263:
  6507                                  
  6508                                  ;-186 int mkneg(int n) { n; __asm {neg ax} }
  6509 0000320B C9                       LEAVE
  6510 0000320C C3                       ret
  6511                                  ; ENDP
  6512                                  ;Number of CALLs:    2 : toupper
  6513                                  
  6514                                  toupper:  ; *** PROC ***
  6515                                  ;Function : toupper, Number of local variables: 1
  6516                                  ;   # type sign width line used address name   list of local variables
  6517                                  ;  200 ptr sign byte   186 NULL bp+4    s;
  6518 0000320D C8000000                 ENTER  0,0
  6519                                  @@toupper264:
  6520 00003211 8B5E04                   mov bx, [bp+4]
  6521 00003214 8A07                     mov al, [bx]
  6522 00003216 B400                     mov ah, 0
  6523 00003218 08C0                     or  al, al
  6524 0000321A 0F843000                 je @@toupper265
  6525 0000321E 8B5E04                   mov bx, [bp+4]
  6526 00003221 8A07                     mov al, [bx]
  6527 00003223 B400                     mov ah, 0
  6528 00003225 83F861                   cmp ax, 97 ;unsigned : 1
  6529 00003228 0F8C1D00                 jl  @@toupper266
  6530 0000322C 8B5E04                   mov bx, [bp+4]
  6531 0000322F 8A07                     mov al, [bx]
  6532 00003231 B400                     mov ah, 0
  6533 00003233 83F87A                   cmp ax, 122
  6534 00003236 0F8F0F00                 jg  @@toupper267
  6535 0000323A 8B5E04                   mov bx, [bp+4]
  6536 0000323D 8A07                     mov al, [bx]
  6537 0000323F B400                     mov ah, 0
  6538 00003241 83E820                   sub ax, 32
  6539 00003244 8B5E04                   mov  bx, [bp+4]
  6540 00003247 8807                     mov  [bx], al
  6541                                  @@toupper267:
  6542                                  @@toupper266:
  6543 00003249 FF4604                   inc  word [bp+4]
  6544 0000324C EBC3                     jmp @@toupper264
  6545                                  @@toupper265:
  6546                                  
  6547                                  ;-187 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6548                                  
  6549                                  
  6550                                  ;-188 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6551 0000324E C9                       LEAVE
  6552 0000324F C3                       ret
  6553                                  ; ENDP
  6554                                  ;Number of CALLs:    3 : strlen
  6555                                  
  6556                                  strlen:  ; *** PROC ***
  6557                                  ;Function : strlen, Number of local variables: 2
  6558                                  ;   # type sign width line used address name   list of local variables
  6559                                  ;  200 ptr sign byte   188 NULL bp+4    s
  6560                                  ;  201 var sign word   188 NULL bp-2    c;
  6561 00003250 C8020000                 ENTER  2,0
  6562 00003254 66B800000000             mov eax, 0
  6563 0000325A 8946FE                   mov word [bp-2], ax
  6564                                  @@strlen268:
  6565 0000325D 8B5E04                   mov bx, [bp+4]
  6566 00003260 8A07                     mov al, [bx]
  6567 00003262 B400                     mov ah, 0
  6568 00003264 83F800                   cmp ax, 0
  6569 00003267 0F840800                 je  @@strlen269
  6570 0000326B FF4604                   inc  word [bp+4]
  6571 0000326E FF46FE                   inc  word [bp-2]
  6572 00003271 EBEA                     jmp @@strlen268
  6573                                  @@strlen269:
  6574 00003273 8B46FE                   mov ax, [bp-2]
  6575 00003276 E90000                   jmp @@retn
  6576                                  
  6577                                  ;-189 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6578                                  
  6579 00003279 C9                      @@retn: LEAVE
  6580 0000327A C3                       ret
  6581                                  ; ENDP
  6582                                  ;Number of CALLs:    5 : strcpy
  6583                                  
  6584                                  strcpy:  ; *** PROC ***
  6585                                  ;Function : strcpy, Number of local variables: 2
  6586                                  ;   # type sign width line used address name   list of local variables
  6587                                  ;  200 ptr sign byte   189 NULL bp+4    s
  6588                                  ;  201 ptr sign byte   189 NULL bp+6    t;
  6589 0000327B C8000000                 ENTER  0,0
  6590                                  @@strcpy270:
  6591 0000327F 8B5E06                   mov bx, [bp+6]
  6592 00003282 8A07                     mov al, [bx]
  6593 00003284 B400                     mov ah, 0
  6594 00003286 8B5E04                   mov  bx, [bp+4]
  6595 00003289 8807                     mov  [bx], al
  6596 0000328B FF4604                   inc  word [bp+4]
  6597 0000328E FF4606                   inc  word [bp+6]
  6598                                  
  6599                                  ;-190   while (*t!=0); *s=0; return s; }
  6600                                  
  6601 00003291 8B5E06                   mov bx, [bp+6]
  6602 00003294 8A07                     mov al, [bx]
  6603 00003296 B400                     mov ah, 0
  6604 00003298 83F800                   cmp ax, 0
  6605 0000329B 0F840200                 je  @@strcpy271
  6606 0000329F EBDE                     jmp @@strcpy270
  6607                                  @@strcpy271:
  6608 000032A1 66B800000000             mov eax, 0
  6609 000032A7 8B5E04                   mov  bx, [bp+4]
  6610 000032AA 8807                     mov  [bx], al
  6611 000032AC 8B4604                   mov ax, [bp+4]
  6612 000032AF E90000                   jmp @@retn
  6613                                  
  6614                                  ;-191 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6615                                  
  6616 000032B2 C9                      @@retn: LEAVE
  6617 000032B3 C3                       ret
  6618                                  ; ENDP
  6619                                  ;Number of CALLs:    3 : digit
  6620                                  
  6621                                  digit:  ; *** PROC ***
  6622                                  ;Function : digit, Number of local variables: 1
  6623                                  ;   # type sign width line used address name   list of local variables
  6624                                  ;  200 var sign byte   191 NULL bp+4    c;
  6625 000032B4 C8000000                 ENTER  0,0
  6626 000032B8 8A4604                   mov al, [bp+4]
  6627 000032BB 3C30                     cmp al, 48
  6628 000032BD 0F8D0900                 jge @@digit272
  6629 000032C1 66B800000000             mov eax, 0
  6630 000032C7 E91B00                   jmp @@retn
  6631                                  @@digit272:
  6632 000032CA 8A4604                   mov al, [bp+4]
  6633 000032CD 3C39                     cmp al, 57
  6634 000032CF 0F8E0900                 jle @@digit273
  6635 000032D3 66B800000000             mov eax, 0
  6636 000032D9 E90900                   jmp @@retn
  6637                                  @@digit273:
  6638 000032DC 66B801000000             mov eax, 1
  6639 000032E2 E90000                   jmp @@retn
  6640                                  
  6641                                  ;-192 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6642                                  
  6643 000032E5 C9                      @@retn: LEAVE
  6644 000032E6 C3                       ret
  6645                                  ; ENDP
  6646                                  ;Number of CALLs:   35 : eqstr
  6647                                  
  6648                                  eqstr:  ; *** PROC ***
  6649                                  ;Function : eqstr, Number of local variables: 2
  6650                                  ;   # type sign width line used address name   list of local variables
  6651                                  ;  200 ptr sign byte   192 NULL bp+4    p
  6652                                  ;  201 ptr sign byte   192 NULL bp+6    q;
  6653 000032E7 C8000000                 ENTER  0,0
  6654                                  @@eqstr274:
  6655 000032EB 8B5E04                   mov bx, [bp+4]
  6656 000032EE 8A07                     mov al, [bx]
  6657 000032F0 B400                     mov ah, 0
  6658 000032F2 08C0                     or  al, al
  6659 000032F4 0F842300                 je @@eqstr275
  6660                                  
  6661                                  ;-193     if (*p != *q) return 0; p++; q++; }
  6662                                  
  6663 000032F8 8B5E04                   mov bx, [bp+4]
  6664 000032FB 8A07                     mov al, [bx]
  6665 000032FD B400                     mov ah, 0
  6666 000032FF 8B5E06                   mov bx, [bp+6]
  6667 00003302 3A07                     cmp al, [bx]
  6668 00003304 B400                     mov ah, 0
  6669 00003306 0F840900                 je  @@eqstr276
  6670 0000330A 66B800000000             mov eax, 0
  6671 00003310 E92700                   jmp @@retn
  6672                                  @@eqstr276:
  6673 00003313 FF4604                   inc  word [bp+4]
  6674 00003316 FF4606                   inc  word [bp+6]
  6675                                  
  6676                                  ;-194     if(*q) return 0; return 1; }
  6677                                  
  6678 00003319 EBD0                     jmp @@eqstr274
  6679                                  @@eqstr275:
  6680 0000331B 8B5E06                   mov bx, [bp+6]
  6681 0000331E 8A07                     mov al, [bx]
  6682 00003320 B400                     mov ah, 0
  6683 00003322 08C0                     or  al, al
  6684 00003324 0F840900                 je @@eqstr277
  6685 00003328 66B800000000             mov eax, 0
  6686 0000332E E90900                   jmp @@retn
  6687                                  @@eqstr277:
  6688 00003331 66B801000000             mov eax, 1
  6689 00003337 E90000                   jmp @@retn
  6690                                  
  6691                                  ;-195 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6692                                  
  6693 0000333A C9                      @@retn: LEAVE
  6694 0000333B C3                       ret
  6695                                  ; ENDP
  6696                                  ;Number of CALLs:    3 : strcat1
  6697                                  
  6698                                  strcat1:  ; *** PROC ***
  6699                                  ;Function : strcat1, Number of local variables: 2
  6700                                  ;   # type sign width line used address name   list of local variables
  6701                                  ;  200 ptr sign byte   195 NULL bp+4    s
  6702                                  ;  201 ptr sign byte   195 NULL bp+6    t;
  6703 0000333C C8000000                 ENTER  0,0
  6704                                  @@strcat1278:
  6705 00003340 8B5E04                   mov bx, [bp+4]
  6706 00003343 8A07                     mov al, [bx]
  6707 00003345 B400                     mov ah, 0
  6708 00003347 83F800                   cmp ax, 0
  6709 0000334A 0F840500                 je  @@strcat1279
  6710 0000334E FF4604                   inc  word [bp+4]
  6711 00003351 EBED                     jmp @@strcat1278
  6712                                  @@strcat1279:
  6713 00003353 FF7606                   push word [bp+6]
  6714 00003356 FF7604                   push word [bp+4]
  6715 00003359 E81FFF                   call strcpy
  6716 0000335C 83C404                   add  sp, 4
  6717                                  
  6718                                  ;-196 int basename(char *s) { char *p; p=0;
  6719 0000335F C9                       LEAVE
  6720 00003360 C3                       ret
  6721                                  ; ENDP
  6722                                  ;Number of CALLs:    1 : openR
  6723                                  
  6724                                  openR:  ; *** PROC ***
  6725                                  ;Function : openR, Number of local variables: 1
  6726                                  ;   # type sign width line used address name   list of local variables
  6727                                  ;  200 ptr sign byte   196 NULL bp+4    s;
  6728 00003361 C8000000                 ENTER  0,0
  6729 00003365 8B5604                   mov  dx, [bp+4]
  6730 00003368 B8023D                   mov  ax, 15618
  6731 0000336B E87200                   call DosInt
  6732                                  
  6733                                  ;-197 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6734 0000336E C9                       LEAVE
  6735 0000336F C3                       ret
  6736                                  ; ENDP
  6737                                  ;Number of CALLs:    2 : creatR
  6738                                  
  6739                                  creatR:  ; *** PROC ***
  6740                                  ;Function : creatR, Number of local variables: 1
  6741                                  ;   # type sign width line used address name   list of local variables
  6742                                  ;  200 ptr sign byte   197 NULL bp+4    s;
  6743 00003370 C8000000                 ENTER  0,0
  6744 00003374 8B5604                   mov  dx, [bp+4]
  6745 00003377 B90000                   mov  cx, 0
  6746 0000337A B8003C                   mov  ax, 15360
  6747 0000337D E86000                   call DosInt
  6748                                  
  6749                                  ;-198 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6750 00003380 C9                       LEAVE
  6751 00003381 C3                       ret
  6752                                  ; ENDP
  6753                                  ;Number of CALLs:    2 : readRL
  6754                                  
  6755                                  readRL:  ; *** PROC ***
  6756                                  ;Function : readRL, Number of local variables: 3
  6757                                  ;   # type sign width line used address name   list of local variables
  6758                                  ;  200 ptr sign byte   198 NULL bp+4    s
  6759                                  ;  201 var sign word   198 NULL bp+6    fd
  6760                                  ;  202 var sign word   198 NULL bp+8    len;
  6761 00003382 C8000000                 ENTER  0,0
  6762 00003386 8B5604                   mov  dx, [bp+4]
  6763 00003389 8B4E08                   mov  cx, [bp+8]
  6764 0000338C 8B5E06                   mov  bx, [bp+6]
  6765 0000338F B8003F                   mov  ax, 16128
  6766 00003392 E84B00                   call DosInt
  6767                                  
  6768                                  ;-199 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6769 00003395 C9                       LEAVE
  6770 00003396 C3                       ret
  6771                                  ; ENDP
  6772                                  ;Number of CALLs:    2 : fputcR
  6773                                  
  6774                                  fputcR:  ; *** PROC ***
  6775                                  ;Function : fputcR, Number of local variables: 2
  6776                                  ;   # type sign width line used address name   list of local variables
  6777                                  ;  200 ptr sign byte   199 NULL bp+4    n
  6778                                  ;  201 var sign word   199 NULL bp+6    fd;
  6779 00003397 C8000000                 ENTER  0,0
  6780 0000339B 8D5604                  lea dx, [bp+4]
  6781                                  
  6782                                  ;-200   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6783                                  
  6784 0000339E B90100                   mov  cx, 1
  6785 000033A1 8B5E06                   mov  bx, [bp+6]
  6786 000033A4 B80040                   mov  ax, 16384
  6787 000033A7 E83600                   call DosInt
  6788                                  
  6789                                  ;-201 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6790 000033AA C9                       LEAVE
  6791 000033AB C3                       ret
  6792                                  ; ENDP
  6793                                  ;Number of CALLs:    3 : fcloseR
  6794                                  
  6795                                  fcloseR:  ; *** PROC ***
  6796                                  ;Function : fcloseR, Number of local variables: 1
  6797                                  ;   # type sign width line used address name   list of local variables
  6798                                  ;  200 var sign word   201 NULL bp+4    fd;
  6799 000033AC C8000000                 ENTER  0,0
  6800 000033B0 8B5E04                   mov  bx, [bp+4]
  6801 000033B3 B8003E                   mov  ax, 15872
  6802 000033B6 CD21                     int  33
  6803                                  
  6804                                  ;-202 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6805 000033B8 C9                       LEAVE
  6806 000033B9 C3                       ret
  6807                                  ; ENDP
  6808                                  ;Number of CALLs:    5 : exitR
  6809                                  
  6810                                  exitR:  ; *** PROC ***
  6811                                  ;Function : exitR, Number of local variables: 1
  6812                                  ;   # type sign width line used address name   list of local variables
  6813                                  ;  200 var sign byte   202 NULL bp+4    c;
  6814 000033BA C8000000                 ENTER  0,0
  6815 000033BE B44C                     mov  ah, 76
  6816 000033C0 8A4604                   mov  al, [bp+4]
  6817 000033C3 CD21                     int  33
  6818                                  
  6819                                  ;-203 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6820 000033C5 C9                       LEAVE
  6821 000033C6 C3                       ret
  6822                                  ; ENDP
  6823                                  ;End of archive file. 
  6824                                   
  6825                                  ; missing functions: 
  6826                                  ; putch
  6827                                  ; DosInt
  6828                                  ; DosInt
  6829                                  ; DosInt
  6830                                  ; DosInt
  6831                                  ; Number of unresolved CALLs :    5
  6832                                  ;use archive file: AR.C
  6833                                  
  6834                                  ;-204 // AR.C Archive
  6835                                  
  6836                                  ;Number of CALLs:    1 : putch
  6837                                  
  6838                                  putch:  ; *** PROC ***
  6839                                  ;Function : putch, Number of local variables: 1
  6840                                  ;   # type sign width line used address name   list of local variables
  6841                                  ;  200 var sign byte   204 NULL bp+4    c;
  6842 000033C7 C8000000                 ENTER  0,0
  6843 000033CB 807E040A                cmp byte [bp+4], 10
  6844 000033CF 0F850500                 jne @@putch280
  6845 000033D3 B00D                     mov  al, 13
  6846 000033D5 E8FFFD                   call writetty
  6847                                  @@putch280:
  6848 000033D8 8A4604                   mov  al, [bp+4]
  6849 000033DB E8F9FD                   call writetty
  6850                                  
  6851                                  ;-205 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6852 000033DE C9                       LEAVE
  6853 000033DF C3                       ret
  6854                                  ; ENDP
  6855                                  ;Number of CALLs:    4 : DosInt
  6856                                  
  6857                                  DosInt:  ; *** PROC ***
  6858 000033E0 CD21                     int  33
  6859 000033E2 7304                     jae short @@DosInt281
  6860 000033E4 FF06[9F01]               inc  word [DOS_ERR]
  6861                                  @@DosInt281:
  6862                                  
  6863                                  ;-206 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6864                                  
  6865 000033E8 C3                       ret
  6866                                  ; ENDP
  6867                                  ;End of archive file. 
  6868                                   
  6869                                  ; missing functions:  All FUNCTIONs in place
  6870 000033E9 E80000                  LastFunctionByt:db 0E8h, 0, 0
  6871 000033EC 58                      pop ax
  6872 000033ED C3                      ret
  6873                                   
  6874                                  ;   # type sign width line used  address name   list of global variables
  6875                                  
  6876                                  ;    1 arr sign byte     1    2        0 Version1[10]
  6877                                  ;    2 var sign byte     1    3        0 LIST
  6878                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6879                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6880                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6881                                  ;    6 var unsg word     5   12        0 SymbolInt
  6882                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6883                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6884                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6885                                  ;   10 arr sign byte     9    5        0 namein[67]
  6886                                  ;   11 arr sign byte    10    6        0 namelst[67]
  6887                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6888                                  ;   13 var sign word    12    4        0 asm_fd
  6889                                  ;   14 var sign word    13    3        0 lst_fd
  6890                                  ;   15 var sign word    14    3        0 bin_fd
  6891                                  ;   16 var sign word    15    6        0 DOS_ERR
  6892                                  ;   17 var sign word    16    4        0 ErrorCount
  6893                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6894                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6895                                  ;   20 var unsg word    20    5        0 PC
  6896                                  ;   21 var unsg word    21    2        0 PCStart
  6897                                  ;   22 var sign byte    22    3        0 isLabel
  6898                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6899                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6900                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6901                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6902                                  ;   27 var sign byte    27   21        0 TokeType
  6903                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6904                                  ;   29 def unsg byte    29    -        0 WORD=2
  6905                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6906                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6907                                  ;   32 def unsg byte    32    -        0 IMM=1
  6908                                  ;   33 def unsg byte    33    -        0 REG=2
  6909                                  ;   34 def unsg byte    34    -        0 ADR=3
  6910                                  ;   35 def unsg byte    35    -        0 MEM=4
  6911                                  ;   36 var sign byte    36   21        0 Op
  6912                                  ;   37 var sign byte    37   27        0 Op2
  6913                                  ;   38 var sign byte    38   14        0 CodeType
  6914                                  ;   39 var sign byte    39    9        0 Code1
  6915                                  ;   40 var sign byte    40    6        0 Code2
  6916                                  ;   41 var sign byte    41    2        0 Code3
  6917                                  ;   42 var sign byte    42   17        0 R2No
  6918                                  ;   43 var sign byte    43   11        0 R1No
  6919                                  ;   44 var sign byte    44   17        0 R2Type
  6920                                  ;   45 var sign byte    45    9        0 R1Type
  6921                                  ;   46 var sign byte    46   14        0 OpSize
  6922                                  ;   47 var sign byte    47    7        0 wflag
  6923                                  ;   48 var sign byte    48    3        0 dflag
  6924                                  ;   49 var sign byte    49    6        0 sflag
  6925                                  ;   50 var sign byte    50   14        0 rm
  6926                                  ;   51 var sign byte    51    5        0 isDirect
  6927                                  ;   52 var sign word    52   17        0 disp
  6928                                  ;   53 var unsg word    53    8        0 imme
  6929                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  6930                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  6931                                  ;   56 var sign word    57    6        0 OpPrintIndex
  6932                                  ;   57 ptr sign byte    58   17        0 OpCodePtr
  6933                                  ;   58 var sign byte    59    2        0 PrintR
  6934                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  6935                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  6936                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  6937                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  6938                                  ;   63 arr unsg word    65    3        0 LabelAddr[100]
  6939                                  ;   64 var sign word    66    4        0 LabelMaxIx
  6940                                  ;   65 var sign word    67    4        0 LabelIx
  6941                                  ;   66 def unsg byte    69    -        0 FILEBINMAX=2000
  6942                                  ;   67 arr sign byte    70    2        0 FileBin[2000]
  6943                                  ;   68 var unsg word    71    5        0 BinLen
  6944                                  ;   69 ptr sign byte    73    1        0 arglen
  6945                                  ;   70 ptr sign byte    74    4        0 argv
  6946                                  ;   71 var sign byte     1    1        0 I_START
  6947                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  6948                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  6949                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  6950                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  6951                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  6952                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  6953                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  6954                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  6955                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  6956                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  6957                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  6958                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  6959                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  6960                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  6961                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  6962                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  6963                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  6964                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  6965                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  6966                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  6967                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  6968                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  6969                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  6970                                  ;   95 arr sign byte    27 NULL        0 I_IRET[8]
  6971                                  ;   96 arr sign byte    28 NULL        0 I_XLAT[8]
  6972                                  ;   97 arr sign byte    29 NULL        0 I_LOCK[8]
  6973                                  ;   98 arr sign byte    30 NULL        0 I_REPNE[9]
  6974                                  ;   99 arr sign byte    31 NULL        0 I_REPNZ[9]
  6975                                  ;  100 arr sign byte    32 NULL        0 I_REPE[8]
  6976                                  ;  101 arr sign byte    33 NULL        0 I_REPZ[8]
  6977                                  ;  102 arr sign byte    34 NULL        0 I_HLT[7]
  6978                                  ;  103 arr sign byte    35 NULL        0 I_CLC[7]
  6979                                  ;  104 arr sign byte    36 NULL        0 I_STC[7]
  6980                                  ;  105 arr sign byte    37 NULL        0 I_CLI[7]
  6981                                  ;  106 arr sign byte    38 NULL        0 I_STI[7]
  6982                                  ;  107 arr sign byte    39 NULL        0 I_CLD[7]
  6983                                  ;  108 arr sign byte    40 NULL        0 I_STD[7]
  6984                                  ;  109 arr sign byte    42 NULL        0 I_INC[9]
  6985                                  ;  110 arr sign byte    43 NULL        0 I_DEC[9]
  6986                                  ;  111 arr sign byte    44 NULL        0 I_NOT[8]
  6987                                  ;  112 arr sign byte    45 NULL        0 I_NEG[8]
  6988                                  ;  113 arr sign byte    46 NULL        0 I_MUL[8]
  6989                                  ;  114 arr sign byte    47 NULL        0 I_IMUL[9]
  6990                                  ;  115 arr sign byte    48 NULL        0 I_DIV[8]
  6991                                  ;  116 arr sign byte    49 NULL        0 I_IDIV[9]
  6992                                  ;  117 arr sign byte    51 NULL        0 I_LES[7]
  6993                                  ;  118 arr sign byte    52 NULL        0 I_LDS[7]
  6994                                  ;  119 arr sign byte    53 NULL        0 I_LEA[7]
  6995                                  ;  120 arr sign byte    54 NULL        0 I_LSS[8]
  6996                                  ;  121 arr sign byte    55 NULL        0 I_LFS[8]
  6997                                  ;  122 arr sign byte    56 NULL        0 I_LGS[8]
  6998                                  ;  123 arr sign byte    58 NULL        0 I_ADD[7]
  6999                                  ;  124 arr sign byte    59 NULL        0 I_OR[6]
  7000                                  ;  125 arr sign byte    60 NULL        0 I_ADC[7]
  7001                                  ;  126 arr sign byte    61 NULL        0 I_SBB[7]
  7002                                  ;  127 arr sign byte    62 NULL        0 I_AND[7]
  7003                                  ;  128 arr sign byte    63 NULL        0 I_SUB[7]
  7004                                  ;  129 arr sign byte    64 NULL        0 I_XOR[7]
  7005                                  ;  130 arr sign byte    65 NULL        0 I_CMP[7]
  7006                                  ;  131 arr sign byte    66 NULL        0 I_TEST[11]
  7007                                  ;  132 arr sign byte    68 NULL        0 I_MOV[6]
  7008                                  ;  133 arr sign byte    69 NULL        0 I_MOVSX[9]
  7009                                  ;  134 arr sign byte    70 NULL        0 I_MOVZX[9]
  7010                                  ;  135 arr sign byte    72 NULL        0 I_JO[6]
  7011                                  ;  136 arr sign byte    73 NULL        0 I_JNO[7]
  7012                                  ;  137 arr sign byte    74 NULL        0 I_JB[6]
  7013                                  ;  138 arr sign byte    75 NULL        0 I_JC[6]
  7014                                  ;  139 arr sign byte    76 NULL        0 I_JNB[7]
  7015                                  ;  140 arr sign byte    77 NULL        0 I_JAE[7]
  7016                                  ;  141 arr sign byte    78 NULL        0 I_JNC[7]
  7017                                  ;  142 arr sign byte    79 NULL        0 I_JE[6]
  7018                                  ;  143 arr sign byte    80 NULL        0 I_JZ[6]
  7019                                  ;  144 arr sign byte    81 NULL        0 I_JNE[7]
  7020                                  ;  145 arr sign byte    82 NULL        0 I_JNZ[7]
  7021                                  ;  146 arr sign byte    83 NULL        0 I_JBE[7]
  7022                                  ;  147 arr sign byte    84 NULL        0 I_JNA[7]
  7023                                  ;  148 arr sign byte    85 NULL        0 I_JA[6]
  7024                                  ;  149 arr sign byte    86 NULL        0 I_JS[6]
  7025                                  ;  150 arr sign byte    87 NULL        0 I_JNS[7]
  7026                                  ;  151 arr sign byte    88 NULL        0 I_JP[6]
  7027                                  ;  152 arr sign byte    89 NULL        0 I_JPE[7]
  7028                                  ;  153 arr sign byte    90 NULL        0 I_JNP[7]
  7029                                  ;  154 arr sign byte    91 NULL        0 I_JPO[7]
  7030                                  ;  155 arr sign byte    92 NULL        0 I_JL[6]
  7031                                  ;  156 arr sign byte    93 NULL        0 I_JNL[7]
  7032                                  ;  157 arr sign byte    94 NULL        0 I_JGE[7]
  7033                                  ;  158 arr sign byte    95 NULL        0 I_JLE[7]
  7034                                  ;  159 arr sign byte    96 NULL        0 I_JNG[7]
  7035                                  ;  160 arr sign byte    97 NULL        0 I_JG[6]
  7036                                  ;  161 arr sign byte    99 NULL        0 I_JMP[8]
  7037                                  ;  162 arr sign byte   100 NULL        0 I_CALL[9]
  7038                                  ;  163 arr sign byte   102 NULL        0 I_RET[8]
  7039                                  ;  164 arr sign byte   103 NULL        0 I_RETF[9]
  7040                                  ;  165 arr sign byte   105 NULL        0 I_PUSH[8]
  7041                                  ;  166 arr sign byte   106 NULL        0 I_POP[7]
  7042                                  ;  167 arr sign byte   108 NULL        0 I_ROL[7]
  7043                                  ;  168 arr sign byte   109 NULL        0 I_ROR[7]
  7044                                  ;  169 arr sign byte   110 NULL        0 I_RCL[7]
  7045                                  ;  170 arr sign byte   111 NULL        0 I_RCR[7]
  7046                                  ;  171 arr sign byte   112 NULL        0 I_SHL[7]
  7047                                  ;  172 arr sign byte   113 NULL        0 I_SAL[7]
  7048                                  ;  173 arr sign byte   114 NULL        0 I_SHR[7]
  7049                                  ;  174 arr sign byte   115 NULL        0 I_SAR[7]
  7050                                  ;  175 arr sign byte   117 NULL        0 I_INT[8]
  7051                                  ;  176 arr sign byte   118 NULL        0 I_INTO[8]
  7052                                  ;  177 arr sign byte   129 NULL        0 I_XCHG[9]
  7053                                  ;  178 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  7054                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNE[10]
  7055                                  ;  180 arr sign byte   133 NULL        0 I_LOOPZ[9]
  7056                                  ;  181 arr sign byte   134 NULL        0 I_LOOPE[9]
  7057                                  ;  182 arr sign byte   135 NULL        0 I_LOOP[8]
  7058                                  ;  183 arr sign byte   136 NULL        0 I_JCXZ[8]
  7059                                  ;  184 arr sign byte   137 NULL        0 I_JECXZ[9]
  7060                                  ;  185 arr sign byte   139 NULL        0 I_ENTER[9]
  7061                                  ;  186 arr sign byte   141 NULL        0 I_ORG[6]
  7062                                  ;  187 arr sign byte   146 NULL        0 I_DB[5]
  7063                                  ;  188 arr sign byte   147 NULL        0 I_DW[5]
  7064                                  ;  189 arr sign byte   148 NULL        0 I_DD[5]
  7065                                  ;  190 arr sign byte   149 NULL        0 I_RESB[7]
  7066                                  ;  191 arr sign byte   150 NULL        0 I_RESW[7]
  7067                                  ;  192 arr sign byte   151 NULL        0 I_RESD[7]
  7068                                  ;  193 var sign byte   152 NULL        0 I_END
  7069                                  
  7070                                  
  7071                                  ;   # Calls Line Width  Name   list of functions
  7072                                  
  7073                                  ;    0    2    1 word   ChangeDirection
  7074                                  ;    1    1    9 word   checkOpL
  7075                                  ;    2    3   22 word   check2Ops
  7076                                  ;    3    1   31 word   get2Ops
  7077                                  ;    4    2   37 word   getOpL
  7078                                  ;    5    2   46 word   getOpR
  7079                                  ;    6    2   56 word   getOp1
  7080                                  ;    7    1   72 word   getMEM
  7081                                  ;    8    1   94 word   getIndReg1
  7082                                  ;    9    1  102 word   getIndReg2
  7083                                  ;   10    2  112 word   setwflag
  7084                                  ;   11    1  123 word   setsflag
  7085                                  ;   12    1    1 word   parse
  7086                                  ;   13   14   27 word   getTokeType
  7087                                  ;   14    2   36 word   storeLabel
  7088                                  ;   15    2   46 word   searchLabel
  7089                                  ;   16    1   57 word   getVariable
  7090                                  ;   17    2   86 word   lookCode
  7091                                  ;   18    1  101 word   getCodeSize
  7092                                  ;   19    8  108 word   isToken
  7093                                  ;   20    1  113 word   need
  7094                                  ;   21    1  123 word   skipRest
  7095                                  ;   22    1    1 word   getLine
  7096                                  ;   23    1   17 word   ifEOL
  7097                                  ;   24    3   24 word   skipBlank
  7098                                  ;   25    2   29 word   letterE
  7099                                  ;   26    1   39 word   alnumE
  7100                                  ;   27    1   44 word   getDigit
  7101                                  ;   28    1   56 word   getName
  7102                                  ;   29    1   75 word   testReg
  7103                                  ;   30    1    1 word   printLine
  7104                                  ;   31    7   22 word   prc
  7105                                  ;   32    1   34 word   prscomment
  7106                                  ;   33   23   42 word   prs
  7107                                  ;   34    3   64 word   printhex8a
  7108                                  ;   35    2   69 word   printhex4
  7109                                  ;   36    1   74 word   printhex16
  7110                                  ;   37    3   79 word   printIntU
  7111                                  ;   38   25   90 word   error1
  7112                                  ;   39   12   98 word   errorexit
  7113                                  ;   40 NULL  102 word   allowederror
  7114                                  ;   41    3  103 word   addrerror
  7115                                  ;   42    1  104 word   immeerror
  7116                                  ;   43    2  105 word   implerror
  7117                                  ;   44    4  106 word   indexerror
  7118                                  ;   45    2  107 word   invaloperror
  7119                                  ;   46    1  108 word   numbererror
  7120                                  ;   47    1  109 word   regmemerror
  7121                                  ;   48    2  110 word   reg16error
  7122                                  ;   49    1  111 word   segregerror
  7123                                  ;   50    3  112 word   syntaxerror
  7124                                  ;   51 NULL  114 word   addrexit
  7125                                  ;   52 NULL  115 word   internexit
  7126                                  ;   53 NULL    1 word   main
  7127                                  ;   54    1    8 word   getarg
  7128                                  ;   55    1   42 word   epilog
  7129                                  ;   56    2   60 word   end1
  7130                                  ;   57    1    2 word   getCodes
  7131                                  ;   58    1    7 word   gen66h
  7132                                  ;   59    3    9 word   genCode2
  7133                                  ;   60   10   13 word   genCodeW
  7134                                  ;   61   16   17 word   genCode8
  7135                                  ;   62    6   28 word   genCode16
  7136                                  ;   63    9   32 word   writeEA
  7137                                  ;   64    1   74 word   genImmediateSE
  7138                                  ;   65    4   78 word   genImmediate
  7139                                  ;   66    1   11 word   process
  7140                                  ;   67    4  184 word   writetty
  7141                                  ;   68    8  185 word   cputs
  7142                                  ;   69    2  186 word   toupper
  7143                                  ;   70    3  188 word   strlen
  7144                                  ;   71    6  189 word   strcpy
  7145                                  ;   72    3  191 word   digit
  7146                                  ;   73   35  192 word   eqstr
  7147                                  ;   74    3  195 word   strcat1
  7148                                  ;   75    1  196 word   openR
  7149                                  ;   76    2  197 word   creatR
  7150                                  ;   77    2  198 word   readRL
  7151                                  ;   78    2  199 word   fputcR
  7152                                  ;   79    3  201 word   fcloseR
  7153                                  ;   80    5  202 word   exitR
  7154                                  ;   81    1  204 word   putch
  7155                                  ;   82    4  205 word   DosInt
  7156                                  ;   83 NULL  206 word   LastFunctionByt
  7157                                  
  7158                                  ;    #  addr name   list of CALLs
  7159                                  
  7160                                  ;    0  1360 implerror
  7161                                  ;    1  1370 segregerror
  7162                                  ;    2  1382 setwflag
  7163                                  ;    3  1391 error1
  7164                                  ;    4  1398 error1
  7165                                  ;    5  1405 error1
  7166                                  ;    6  1422 get2Ops
  7167                                  ;    7  1430 addrerror
  7168                                  ;    8  1440 invaloperror
  7169                                  ;    9  1453 immeerror
  7170                                  ;   10  1463 addrerror
  7171                                  ;   11  1473 setwflag
  7172                                  ;   12  1490 getOpL
  7173                                  ;   13  1497 need
  7174                                  ;   14  1502 getOpR
  7175                                  ;   15  1516 getOpR
  7176                                  ;   16  1530 getOp1
  7177                                  ;   17  1537 isToken
  7178                                  ;   18  1545 getMEM
  7179                                  ;   19  1552 invaloperror
  7180                                  ;   20  1565 error1
  7181                                  ;   21  1579 testReg
  7182                                  ;   22  1587 searchLabel
  7183                                  ;   23  1599 error1
  7184                                  ;   24  1615 getTokeType
  7185                                  ;   25  1627 getOp1
  7186                                  ;   26  1634 syntaxerror
  7187                                  ;   27  1646 getIndReg2
  7188                                  ;   28  1657 getIndReg1
  7189                                  ;   29  1668 isToken
  7190                                  ;   30  1676 getTokeType
  7191                                  ;   31  1688 numbererror
  7192                                  ;   32  1700 isToken
  7193                                  ;   33  1708 isToken
  7194                                  ;   34  1716 errorexit
  7195                                  ;   35  1737 indexerror
  7196                                  ;   36  1748 indexerror
  7197                                  ;   37  1772 indexerror
  7198                                  ;   38  1783 indexerror
  7199                                  ;   39  1803 gen66h
  7200                                  ;   40  1819 error1
  7201                                  ;   41  1832 getLine
  7202                                  ;   42  1840 getTokeType
  7203                                  ;   43  1852 storeLabel
  7204                                  ;   44  1863 getTokeType
  7205                                  ;   45  1875 lookCode
  7206                                  ;   46  1884 process
  7207                                  ;   47  1892 getVariable
  7208                                  ;   48  1904 skipRest
  7209                                  ;   49  1913 error1
  7210                                  ;   50  1920 error1
  7211                                  ;   51  1927 printLine
  7212                                  ;   52  1951 skipBlank
  7213                                  ;   53  1961 digit
  7214                                  ;   54  1967 getDigit
  7215                                  ;   55  1976 letterE
  7216                                  ;   56  1984 getName
  7217                                  ;   57  2005 searchLabel
  7218                                  ;   58  2017 error1
  7219                                  ;   59  2024 strcpy
  7220                                  ;   60  2031 errorexit
  7221                                  ;   61  2041 errorexit
  7222                                  ;   62  2071 eqstr
  7223                                  ;   63  2077 strlen
  7224                                  ;   64  2098 storeLabel
  7225                                  ;   65  2109 getTokeType
  7226                                  ;   66  2121 lookCode
  7227                                  ;   67  2130 errorexit
  7228                                  ;   68  2140 errorexit
  7229                                  ;   69  2150 getTokeType
  7230                                  ;   70  2162 genCode8
  7231                                  ;   71  2171 skipBlank
  7232                                  ;   72  2181 isToken
  7233                                  ;   73  2189 genCode8
  7234                                  ;   74  2198 isToken
  7235                                  ;   75  2206 getTokeType
  7236                                  ;   76  2218 genCode16
  7237                                  ;   77  2228 isToken
  7238                                  ;   78  2236 errorexit
  7239                                  ;   79  2255 eqstr
  7240                                  ;   80  2273 eqstr
  7241                                  ;   81  2279 getTokeType
  7242                                  ;   82  2291 eqstr
  7243                                  ;   83  2297 getTokeType
  7244                                  ;   84  2309 eqstr
  7245                                  ;   85  2315 getTokeType
  7246                                  ;   86  2337 skipBlank
  7247                                  ;   87  2354 isToken
  7248                                  ;   88  2362 getTokeType
  7249                                  ;   89  2374 error1
  7250                                  ;   90  2381 prs
  7251                                  ;   91  2385 prc
  7252                                  ;   92  2398 getTokeType
  7253                                  ;   93  2410 error1
  7254                                  ;   94  2427 readRL
  7255                                  ;   95  2434 errorexit
  7256                                  ;   96  2444 errorexit
  7257                                  ;   97  2454 ifEOL
  7258                                  ;   98  2468 readRL
  7259                                  ;   99  2504 digit
  7260                                  ;  100  2510 letterE
  7261                                  ;  101  2537 digit
  7262                                  ;  102  2557 alnumE
  7263                                  ;  103  2564 errorexit
  7264                                  ;  104  2574 strcpy
  7265                                  ;  105  2581 toupper
  7266                                  ;  106  2597 strlen
  7267                                  ;  107  2604 strlen
  7268                                  ;  108  2611 eqstr
  7269                                  ;  109  2617 eqstr
  7270                                  ;  110  2623 eqstr
  7271                                  ;  111  2629 eqstr
  7272                                  ;  112  2635 eqstr
  7273                                  ;  113  2641 eqstr
  7274                                  ;  114  2647 eqstr
  7275                                  ;  115  2653 eqstr
  7276                                  ;  116  2659 eqstr
  7277                                  ;  117  2665 eqstr
  7278                                  ;  118  2671 eqstr
  7279                                  ;  119  2677 eqstr
  7280                                  ;  120  2683 eqstr
  7281                                  ;  121  2689 eqstr
  7282                                  ;  122  2695 eqstr
  7283                                  ;  123  2701 eqstr
  7284                                  ;  124  2707 eqstr
  7285                                  ;  125  2713 eqstr
  7286                                  ;  126  2719 eqstr
  7287                                  ;  127  2725 eqstr
  7288                                  ;  128  2731 eqstr
  7289                                  ;  129  2737 eqstr
  7290                                  ;  130  2743 eqstr
  7291                                  ;  131  2749 eqstr
  7292                                  ;  132  2755 eqstr
  7293                                  ;  133  2761 eqstr
  7294                                  ;  134  2767 eqstr
  7295                                  ;  135  2773 eqstr
  7296                                  ;  136  2779 eqstr
  7297                                  ;  137  2785 eqstr
  7298                                  ;  138  2805 prs
  7299                                  ;  139  2809 printhex16
  7300                                  ;  140  2820 prs
  7301                                  ;  141  2824 prc
  7302                                  ;  142  2828 printhex8a
  7303                                  ;  143  2839 prc
  7304                                  ;  144  2843 prs
  7305                                  ;  145  2847 prscomment
  7306                                  ;  146  2864 writetty
  7307                                  ;  147  2873 writetty
  7308                                  ;  148  2882 fputcR
  7309                                  ;  149  2904 prc
  7310                                  ;  150  2920 prc
  7311                                  ;  151  2941 printhex4
  7312                                  ;  152  2951 printhex4
  7313                                  ;  153  2973 prc
  7314                                  ;  154  2995 printhex8a
  7315                                  ;  155  3006 printhex8a
  7316                                  ;  156  3031 printIntU
  7317                                  ;  157  3041 prc
  7318                                  ;  158  3054 prs
  7319                                  ;  159  3058 prs
  7320                                  ;  160  3062 prs
  7321                                  ;  161  3066 prs
  7322                                  ;  162  3082 error1
  7323                                  ;  163  3089 end1
  7324                                  ;  164  3107 error1
  7325                                  ;  165  3124 error1
  7326                                  ;  166  3141 error1
  7327                                  ;  167  3158 error1
  7328                                  ;  168  3176 error1
  7329                                  ;  169  3196 error1
  7330                                  ;  170  3215 error1
  7331                                  ;  171  3234 error1
  7332                                  ;  172  3252 error1
  7333                                  ;  173  3271 error1
  7334                                  ;  174  3290 error1
  7335                                  ;  175  3306 errorexit
  7336                                  ;  176  3327 errorexit
  7337                                  ;  177  3342 getarg
  7338                                  ;  178  3349 parse
  7339                                  ;  179  3355 epilog
  7340                                  ;  180  3362 end1
  7341                                  ;  181  3386 cputs
  7342                                  ;  182  3392 cputs
  7343                                  ;  183  3398 exitR
  7344                                  ;  184  3404 toupper
  7345                                  ;  185  3412 strcpy
  7346                                  ;  186  3419 strcat1
  7347                                  ;  187  3427 strcpy
  7348                                  ;  188  3434 strcat1
  7349                                  ;  189  3442 strcpy
  7350                                  ;  190  3449 strcat1
  7351                                  ;  191  3457 openR
  7352                                  ;  192  3463 cputs
  7353                                  ;  193  3469 cputs
  7354                                  ;  194  3475 exitR
  7355                                  ;  195  3481 creatR
  7356                                  ;  196  3488 cputs
  7357                                  ;  197  3494 cputs
  7358                                  ;  198  3500 exitR
  7359                                  ;  199  3506 creatR
  7360                                  ;  200  3513 cputs
  7361                                  ;  201  3519 cputs
  7362                                  ;  202  3525 exitR
  7363                                  ;  203  3531 prs
  7364                                  ;  204  3535 prs
  7365                                  ;  205  3539 prs
  7366                                  ;  206  3543 prs
  7367                                  ;  207  3547 prs
  7368                                  ;  208  3551 prs
  7369                                  ;  209  3555 prs
  7370                                  ;  210  3559 prs
  7371                                  ;  211  3563 prs
  7372                                  ;  212  3580 prs
  7373                                  ;  213  3584 printIntU
  7374                                  ;  214  3594 prs
  7375                                  ;  215  3598 prs
  7376                                  ;  216  3602 prs
  7377                                  ;  217  3606 prs
  7378                                  ;  218  3610 printIntU
  7379                                  ;  219  3620 prs
  7380                                  ;  220  3624 fputcR
  7381                                  ;  221  3638 fcloseR
  7382                                  ;  222  3646 fcloseR
  7383                                  ;  223  3654 fcloseR
  7384                                  ;  224  3662 exitR
  7385                                  ;  225  3684 genCode8
  7386                                  ;  226  3706 genCode8
  7387                                  ;  227  3726 genCode8
  7388                                  ;  228  3746 errorexit
  7389                                  ;  229  3768 genCode8
  7390                                  ;  230  3777 genCode8
  7391                                  ;  231  3802 genCode8
  7392                                  ;  232  3811 genCode8
  7393                                  ;  233  3820 genCode16
  7394                                  ;  234  3845 genCode8
  7395                                  ;  235  3854 genImmediate
  7396                                  ;  236  3880 genCode16
  7397                                  ;  237  3890 genCode8
  7398                                  ;  238  3909 getTokeType
  7399                                  ;  239  3921 getCodeSize
  7400                                  ;  240  3933 getCodes
  7401                                  ;  241  3942 genCode8
  7402                                  ;  242  3951 getOpL
  7403                                  ;  243  3958 checkOpL
  7404                                  ;  244  3967 genCode2
  7405                                  ;  245  3976 getTokeType
  7406                                  ;  246  3988 implerror
  7407                                  ;  247  3998 genCodeW
  7408                                  ;  248  4007 writeEA
  7409                                  ;  249  4015 check2Ops
  7410                                  ;  250  4025 reg16error
  7411                                  ;  251  4036 addrerror
  7412                                  ;  252  4046 genCode8
  7413                                  ;  253  4055 genCode8
  7414                                  ;  254  4064 writeEA
  7415                                  ;  255  4072 check2Ops
  7416                                  ;  256  4082 setsflag
  7417                                  ;  257  4091 genCodeW
  7418                                  ;  258  4100 genImmediate
  7419                                  ;  259  4113 genCodeW
  7420                                  ;  260  4122 writeEA
  7421                                  ;  261  4130 genImmediateSE
  7422                                  ;  262  4145 genCodeW
  7423                                  ;  263  4154 writeEA
  7424                                  ;  264  4162 genCodeW
  7425                                  ;  265  4171 writeEA
  7426                                  ;  266  4179 syntaxerror
  7427                                  ;  267  4191 check2Ops
  7428                                  ;  268  4201 genCode2
  7429                                  ;  269  4210 genImmediate
  7430                                  ;  270  4223 genCodeW
  7431                                  ;  271  4232 writeEA
  7432                                  ;  272  4240 genImmediate
  7433                                  ;  273  4253 regmemerror
  7434                                  ;  274  4265 ChangeDirection
  7435                                  ;  275  4281 reg16error
  7436                                  ;  276  4292 genCode2
  7437                                  ;  277  4301 writeEA
  7438                                  ;  278  4309 genCodeW
  7439                                  ;  279  4318 genCode16
  7440                                  ;  280  4328 genCodeW
  7441                                  ;  281  4337 genCode16
  7442                                  ;  282  4347 genCodeW
  7443                                  ;  283  4356 writeEA
  7444                                  ;  284  4364 ChangeDirection
  7445                                  ;  285  4380 genCodeW
  7446                                  ;  286  4389 writeEA
  7447                                  ;  287  4397 syntaxerror
  7448                                  ;  288  4409 genCode8
  7449                                  ;  289  4418 genCode16
  7450                                  ;  290  4428 genCode8
  7451                                  ;  291  4437 error1
  7452                                  ;  292  4444 error1
  7453                                  ;  293  4470 putch
  7454                                  ;  294  4538 strcpy
  7455                                  ;  295  4553 DosInt
  7456                                  ;  296  4569 DosInt
  7457                                  ;  297  4592 DosInt
  7458                                  ;  298  4611 DosInt
  7459                                  ;  299  4645 writetty
  7460                                  ;  300  4654 writetty
  7461                                  ;Input: AS.C, List: AS.S,  Lines:  207
  7462                                  ;Glob. variables:  193 max.:  200
  7463                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7464                                  ;Functions      :   84 max.:  300
  7465                                  ;Calls          :  301 max.: 2000, NameField: 4686 max.:    65535
  7466                                  ;Code until     :25998 max.: 30000, free: 4002
  7467                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7468                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
