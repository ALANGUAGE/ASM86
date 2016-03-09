     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E92328                  jmp main
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
   201                                  ;-51 char isDirect;          //set in process and getMeM, need in WriteEA
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
   701                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   702                                  
   703 0000111C 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   704 00001125 06F1               
   705                                  
   706                                  ;-106 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   707                                  
   708 00001127 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   709 00001130 F1                 
   710                                  
   711                                  ;-107 //  11: shift, rotates
   712                                  
   713                                  
   714                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   715                                  
   716 00001131 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   717                                  
   718                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   719                                  
   720 00001138 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   721                                  
   722                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   723                                  
   724 0000113F 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   725                                  
   726                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   727                                  
   728 00001146 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   729                                  
   730                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   731                                  
   732 0000114D 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   733                                  
   734                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   735                                  
   736 00001154 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   737                                  
   738                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   739                                  
   740 0000115B 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   741                                  
   742                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   743                                  
   744 00001162 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   745                                  
   746                                  ;-116 //  12: int
   747                                  
   748                                  
   749                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   750                                  
   751 00001169 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   752                                  
   753                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   754                                  
   755 00001171 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   756                                  
   757                                  ;-119 //  14: in/out
   758                                  
   759                                  
   760                                  ;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   761                                  
   762                                  
   763                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   764                                  
   765                                  
   766                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   767                                  
   768                                  
   769                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   770                                  
   771                                  
   772                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   773                                  
   774                                  
   775                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   776                                  
   777                                  
   778                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   779                                  
   780                                  
   781                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   782                                  
   783                                  
   784                                  ;-128 //  15: xchg
   785                                  
   786                                  
   787                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   788                                  
   789 00001179 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   790                                  
   791                                  ;-130 //  16: loop, jcxz
   792                                  
   793                                  
   794                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   795                                  
   796 00001182 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   797 0000118B F1                 
   798                                  
   799                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   800                                  
   801 0000118C 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   802 00001195 F1                 
   803                                  
   804                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   805                                  
   806 00001196 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   807                                  
   808                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   809                                  
   810 0000119F 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   811                                  
   812                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   813                                  
   814 000011A8 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   815                                  
   816                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   817                                  
   818 000011B0 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   819                                  
   820                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   821                                  
   822 000011B8 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   823                                  
   824                                  ;-138 //  30: enter
   825                                  
   826                                  
   827                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   828                                  
   829 000011C1 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   830                                  
   831                                  ;-140 // 100: directives
   832                                  
   833                                  
   834                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   835                                  
   836 000011CA 4F52470065F1            I_ORG db 79,82,71,0,101,241
   837                                  
   838                                  ;-142 // section, segment .TEXT .DATA .BSS
   839                                  
   840                                  
   841                                  ;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   842                                  
   843                                  
   844                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   845                                  
   846                                  
   847                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   848                                  
   849                                  
   850                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   851                                  
   852 000011D0 444200C8F1              I_DB db 68,66,0,200,241
   853                                  
   854                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   855                                  
   856 000011D5 445700C9F1              I_DW db 68,87,0,201,241
   857                                  
   858                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   859                                  
   860 000011DA 444400CAF1              I_DD db 68,68,0,202,241
   861                                  
   862                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   863                                  
   864 000011DF 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   865                                  
   866                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   867                                  
   868 000011E6 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   869                                  
   870                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   871                                  
   872 000011ED 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   873                                  
   874                                  ;-152 char I_END=0;// end of table char
   875                                  
   876 000011F4 00                      I_END db 0
   877                                  ;Back to main program: AS.C
   878                                  
   879                                  ;-4 #include "OPS.C"
   880                                  
   881                                  ;Use include file: OPS.C
   882                                  
   883                                  ;-1 int ChangeDirection() {
   884                                  
   885                                  
   886                                  ChangeDirection:  ; *** PROC ***
   887                                  
   888                                  ;-2     char c;
   889                                  
   890                                  
   891                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   892                                  
   893                                  ;Function : ChangeDirection, Number of local variables: 1
   894                                  ;   # type sign width line used address name   list of local variables
   895                                  ;  200 var sign byte     2 NULL bp-2    c;
   896 000011F5 C8020000                 ENTER  2,0
   897 000011F9 A0[AC01]                 mov al, [Op]
   898 000011FC 8846FE                   mov byte [bp-2], al
   899 000011FF A0[AD01]                 mov al, [Op2]
   900 00001202 A2[AC01]                 mov byte [Op], al
   901 00001205 8A46FE                   mov al, [bp-2]
   902 00001208 A2[AD01]                 mov byte [Op2], al
   903                                  
   904                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   905                                  
   906 0000120B A0[B501]                 mov al, [R1Type]
   907 0000120E 8846FE                   mov byte [bp-2], al
   908 00001211 A0[B401]                 mov al, [R2Type]
   909 00001214 A2[B501]                 mov byte [R1Type], al
   910 00001217 8A46FE                   mov al, [bp-2]
   911 0000121A A2[B401]                 mov byte [R2Type], al
   912                                  
   913                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   914                                  
   915 0000121D A0[B301]                 mov al, [R1No]
   916 00001220 8846FE                   mov byte [bp-2], al
   917 00001223 A0[B201]                 mov al, [R2No]
   918 00001226 A2[B301]                 mov byte [R1No], al
   919 00001229 8A46FE                   mov al, [bp-2]
   920 0000122C A2[B201]                 mov byte [R2No], al
   921                                  
   922                                  ;-6     dflag=2;     
   923                                  
   924 0000122F 66B802000000             mov eax, 2
   925 00001235 A2[B801]                 mov byte [dflag], al
   926                                  
   927                                  ;-7 }
   928                                  
   929                                  
   930                                  ;-8      
   931                                  
   932                                  
   933                                  ;-9 int checkOpL() {
   934 00001238 C9                       LEAVE
   935 00001239 C3                       ret
   936                                  ; ENDP
   937                                  
   938                                  checkOpL:  ; *** PROC ***
   939                                  
   940                                  ;-10     if (Op == ADR) implerror();
   941                                  
   942 0000123A A0[AC01]                 mov al, [Op]
   943 0000123D 3C03                     cmp al, 3
   944 0000123F 0F850300                 jne @@checkOpL1
   945 00001243 E8A614                   call implerror
   946                                  
   947                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   948                                  
   949                                  @@checkOpL1:
   950 00001246 A0[B501]                 mov al, [R1Type]
   951 00001249 3C04                     cmp al, 4
   952 0000124B 0F850600                 jne @@checkOpL2
   953 0000124F E86215                   call segregerror
   954 00001252 E93E00                   jmp @@retn
   955                                  
   956                                  ;-12     setwflag();
   957                                  
   958                                  @@checkOpL2:
   959 00001255 E8CB03                   call setwflag
   960                                  
   961                                  ;-13     if (OpSize == 0) error1("no op size declared");
   962                                  
   963 00001258 A0[B601]                 mov al, [OpSize]
   964 0000125B 3C00                     cmp al, 0
   965 0000125D 0F850900                 jne @@checkOpL3
   966 00001261 68[9412]                 push checkOpL_0
   967 00001264 E8B513                   call error1
   968 00001267 83C402                   add  sp, 2
   969                                  
   970                                  ;-14     if (OpSize == R1Type) return;
   971                                  
   972                                  @@checkOpL3:
   973 0000126A A0[B601]                 mov al, [OpSize]
   974 0000126D 3A06[B501]               cmp al, [R1Type]
   975 00001271 0F850300                 jne @@checkOpL4
   976 00001275 E91B00                   jmp @@retn
   977                                  
   978                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
   979                                  
   980                                  @@checkOpL4:
   981 00001278 A0[AC01]                 mov al, [Op]
   982 0000127B 3C02                     cmp al, 2
   983 0000127D 0F851200                 jne @@checkOpL5
   984 00001281 A0[B501]                 mov al, [R1Type]
   985 00001284 3C00                     cmp al, 0
   986 00001286 0F850900                 jne @@checkOpL6
   987 0000128A 68[A812]                 push checkOpL_1
   988 0000128D E88C13                   call error1
   989 00001290 83C402                   add  sp, 2
   990                                  
   991                                  ;-16 }
   992                                  
   993                                  @@checkOpL6:
   994                                  @@checkOpL5:
   995                                  
   996                                  ;-17     
   997                                  
   998                                  
   999                                  ;-18 int check2Ops() {
  1000                                  
  1001                                  @@retn:
  1002 00001293 C3                       ret
  1003                                  ; ENDP
  1004 00001294 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1005 0000129D 65206465636C617265-
  1006 000012A6 6400               
  1007 000012A8 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1008 000012B1 657220646566696E65-
  1009 000012BA 6400               
  1010                                  
  1011                                  check2Ops:  ; *** PROC ***
  1012                                  
  1013                                  ;-19     get2Ops();
  1014                                  
  1015 000012BC E84900                   call get2Ops
  1016                                  
  1017                                  ;-20     if (Op ==   0) addrerror();
  1018                                  
  1019 000012BF A0[AC01]                 mov al, [Op]
  1020 000012C2 3C00                     cmp al, 0
  1021 000012C4 0F850300                 jne @@check2Ops7
  1022 000012C8 E8E213                   call addrerror
  1023                                  
  1024                                  ;-21     if (Op == ADR) invaloperror(); 
  1025                                  
  1026                                  @@check2Ops7:
  1027 000012CB A0[AC01]                 mov al, [Op]
  1028 000012CE 3C03                     cmp al, 3
  1029 000012D0 0F850300                 jne @@check2Ops8
  1030 000012D4 E85014                   call invaloperror
  1031                                  
  1032                                  ;-22     if (Op == IMM) immeerror();   
  1033                                  
  1034                                  @@check2Ops8:
  1035 000012D7 A0[AC01]                 mov al, [Op]
  1036 000012DA 3C01                     cmp al, 1
  1037 000012DC 0F850300                 jne @@check2Ops9
  1038 000012E0 E8E413                   call immeerror
  1039                                  
  1040                                  ;-23     if (Op2==   0) addrerror();
  1041                                  
  1042                                  @@check2Ops9:
  1043 000012E3 A0[AD01]                 mov al, [Op2]
  1044 000012E6 3C00                     cmp al, 0
  1045 000012E8 0F850300                 jne @@check2Ops10
  1046 000012EC E8BE13                   call addrerror
  1047                                  
  1048                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1049                                  
  1050                                  @@check2Ops10:
  1051 000012EF A0[AE01]                 mov al, [CodeType]
  1052 000012F2 3C05                     cmp al, 5
  1053 000012F4 0F840C00                 je  @@check2Ops11
  1054 000012F8 A0[AD01]                 mov al, [Op2]
  1055 000012FB 3C03                     cmp al, 3
  1056 000012FD 0F850300                 jne @@check2Ops12
  1057 00001301 E82314                   call invaloperror
  1058                                  
  1059                                  ;-25     setwflag();       
  1060                                  
  1061                                  @@check2Ops12:
  1062                                  @@check2Ops11:
  1063 00001304 E81C03                   call setwflag
  1064                                  
  1065                                  ;-26 }    
  1066                                  
  1067                                  
  1068                                  ;-27 int get2Ops() {
  1069                                  
  1070 00001307 C3                       ret
  1071                                  ; ENDP
  1072                                  
  1073                                  get2Ops:  ; *** PROC ***
  1074                                  
  1075                                  ;-28     getOpL();
  1076                                  
  1077 00001308 E80C00                   call getOpL
  1078                                  
  1079                                  ;-29     need(',');    
  1080                                  
  1081 0000130B 6A2C                     push 44
  1082 0000130D E8E208                   call need
  1083 00001310 83C402                   add  sp, 2
  1084                                  
  1085                                  ;-30     getOpR();         
  1086                                  
  1087 00001313 E83200                   call getOpR
  1088                                  
  1089                                  ;-31 } 
  1090                                  
  1091                                  
  1092                                  ;-32         
  1093                                  
  1094                                  
  1095                                  ;-33 int getOpL() {
  1096                                  
  1097 00001316 C3                       ret
  1098                                  ; ENDP
  1099                                  
  1100                                  getOpL:  ; *** PROC ***
  1101                                  
  1102                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1103                                  
  1104                                  
  1105                                  ;-35     getOpR();
  1106                                  
  1107 00001317 E82E00                   call getOpR
  1108                                  
  1109                                  ;-36     Op=Op2;         Op2=0;
  1110                                  
  1111 0000131A A0[AD01]                 mov al, [Op2]
  1112 0000131D A2[AC01]                 mov byte [Op], al
  1113 00001320 66B800000000             mov eax, 0
  1114 00001326 A2[AD01]                 mov byte [Op2], al
  1115                                  
  1116                                  ;-37     R1No=R2No;      R2No=0;
  1117                                  
  1118 00001329 A0[B201]                 mov al, [R2No]
  1119 0000132C A2[B301]                 mov byte [R1No], al
  1120 0000132F 66B800000000             mov eax, 0
  1121 00001335 A2[B201]                 mov byte [R2No], al
  1122                                  
  1123                                  ;-38     R1Type=R2Type; R2Type=0; 
  1124                                  
  1125 00001338 A0[B401]                 mov al, [R2Type]
  1126 0000133B A2[B501]                 mov byte [R1Type], al
  1127 0000133E 66B800000000             mov eax, 0
  1128 00001344 A2[B401]                 mov byte [R2Type], al
  1129                                  
  1130                                  ;-39 }  
  1131                                  
  1132                                  
  1133                                  ;-40 
  1134                                  
  1135                                  
  1136                                  ;-41 int getOpR() {
  1137                                  
  1138 00001347 C3                       ret
  1139                                  ; ENDP
  1140                                  
  1141                                  getOpR:  ; *** PROC ***
  1142                                  
  1143                                  ;-42     Op2=getOp1();
  1144                                  
  1145 00001348 E88900                   call getOp1
  1146 0000134B A2[AD01]                 mov byte [Op2], al
  1147                                  
  1148                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1149                                  
  1150 0000134E 6A5B                     push 91
  1151 00001350 E87108                   call isToken
  1152 00001353 83C402                   add  sp, 2
  1153 00001356 08C0                     or  al, al
  1154 00001358 0F840F00                 je @@getOpR13
  1155 0000135C 66B804000000             mov eax, 4
  1156 00001362 A2[AD01]                 mov byte [Op2], al
  1157 00001365 E8F200                   call getMEM
  1158 00001368 E94F00                   jmp @@retn
  1159                                  
  1160                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1161                                  
  1162                                  @@getOpR13:
  1163 0000136B A0[AD01]                 mov al, [Op2]
  1164 0000136E 3C00                     cmp al, 0
  1165 00001370 0F850600                 jne @@getOpR14
  1166 00001374 E8B013                   call invaloperror
  1167 00001377 E94000                   jmp @@retn
  1168                                  
  1169                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1170                                  
  1171                                  @@getOpR14:
  1172 0000137A A0[AD01]                 mov al, [Op2]
  1173 0000137D 3C01                     cmp al, 1
  1174 0000137F 0F850900                 jne @@getOpR15
  1175 00001383 A1[4D00]                 mov ax, [SymbolInt]
  1176 00001386 A3[BE01]                 mov word [imme], ax
  1177 00001389 E92E00                   jmp @@retn
  1178                                  
  1179                                  ;-46     if (Op2 == REG)                            return;
  1180                                  
  1181                                  @@getOpR15:
  1182 0000138C A0[AD01]                 mov al, [Op2]
  1183 0000138F 3C02                     cmp al, 2
  1184 00001391 0F850300                 jne @@getOpR16
  1185 00001395 E92200                   jmp @@retn
  1186                                  
  1187                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1188                                  
  1189                                  @@getOpR16:
  1190 00001398 A0[AD01]                 mov al, [Op2]
  1191 0000139B 3C03                     cmp al, 3
  1192 0000139D 0F851000                 jne @@getOpR17
  1193 000013A1 8B1E[7E06]               mov bx, [LabelIx]
  1194 000013A5 D1E3                     shl bx, 1
  1195 000013A7 8B87[B405]               mov ax, [LabelAddr + bx]
  1196 000013AB A3[BC01]                 mov word [disp], ax
  1197 000013AE E90900                   jmp @@retn
  1198                                  
  1199                                  ;-48     error1("Name of operand expected");
  1200                                  
  1201                                  @@getOpR17:
  1202 000013B1 68[BB13]                 push getOpR_0
  1203 000013B4 E86512                   call error1
  1204 000013B7 83C402                   add  sp, 2
  1205                                  
  1206                                  ;-49 }
  1207                                  
  1208                                  
  1209                                  ;-50 
  1210                                  
  1211                                  
  1212                                  ;-51 int getOp1() {//scan for a single operand
  1213                                  
  1214                                  @@retn:
  1215 000013BA C3                       ret
  1216                                  ; ENDP
  1217 000013BB 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1218 000013C4 706572616E64206578-
  1219 000013CD 70656374656400     
  1220                                  
  1221                                  getOp1:  ; *** PROC ***
  1222                                  
  1223                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1224                                  
  1225                                  
  1226                                  ;-53 //set   :R2Type, R2No by testReg
  1227                                  
  1228                                  
  1229                                  ;-54 //set   :LabelIx by searchLabel
  1230                                  
  1231                                  
  1232                                  ;-55     if (TokeType == 0)      return 0;
  1233                                  
  1234 000013D4 A0[AB01]                 mov al, [TokeType]
  1235 000013D7 3C00                     cmp al, 0
  1236 000013D9 0F850900                 jne @@getOp118
  1237 000013DD 66B800000000             mov eax, 0
  1238 000013E3 E96000                   jmp @@retn
  1239                                  
  1240                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1241                                  
  1242                                  @@getOp118:
  1243 000013E6 A0[AB01]                 mov al, [TokeType]
  1244 000013E9 3C01                     cmp al, 1
  1245 000013EB 0F850900                 jne @@getOp119
  1246 000013EF 66B801000000             mov eax, 1
  1247 000013F5 E94E00                   jmp @@retn
  1248                                  
  1249                                  ;-57     if (TokeType == ALNUME) {
  1250                                  
  1251                                  @@getOp119:
  1252 000013F8 A0[AB01]                 mov al, [TokeType]
  1253 000013FB 3C03                     cmp al, 3
  1254 000013FD 0F853C00                 jne @@getOp120
  1255                                  
  1256                                  ;-58         R2No=testReg();
  1257                                  
  1258 00001401 E86D0B                   call testReg
  1259 00001404 A2[B201]                 mov byte [R2No], al
  1260                                  
  1261                                  ;-59         if (R2Type)        return REG;
  1262                                  
  1263 00001407 A0[B401]                 mov al, [R2Type]
  1264 0000140A 08C0                     or  al, al
  1265 0000140C 0F840900                 je @@getOp121
  1266 00001410 66B802000000             mov eax, 2
  1267 00001416 E92D00                   jmp @@retn
  1268                                  
  1269                                  ;-60         LabelIx=searchLabel();
  1270                                  
  1271                                  @@getOp121:
  1272 00001419 E81305                   call searchLabel
  1273 0000141C A3[7E06]                 mov word [LabelIx], ax
  1274                                  
  1275                                  ;-61         if (LabelIx)        return ADR;
  1276                                  
  1277 0000141F A1[7E06]                 mov ax, [LabelIx]
  1278 00001422 08C0                     or  al, al
  1279 00001424 0F840C00                 je @@getOp122
  1280 00001428 66B803000000             mov eax, 3
  1281 0000142E E91500                   jmp @@retn
  1282                                  
  1283                                  ;-62         else error1("variable not found"); 
  1284                                  
  1285 00001431 E90900                   jmp @@getOp123
  1286                                  @@getOp122:
  1287 00001434 68[4714]                 push getOp1_0
  1288 00001437 E8E211                   call error1
  1289 0000143A 83C402                   add  sp, 2
  1290                                  
  1291                                  ;-63     }
  1292                                  
  1293                                  @@getOp123:
  1294                                  
  1295                                  ;-64     return 0;
  1296                                  
  1297                                  @@getOp120:
  1298 0000143D 66B800000000             mov eax, 0
  1299 00001443 E90000                   jmp @@retn
  1300                                  
  1301                                  ;-65 }
  1302                                  
  1303                                  
  1304                                  ;-66 
  1305                                  
  1306                                  
  1307                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1308                                  
  1309                                  @@retn:
  1310 00001446 C3                       ret
  1311                                  ; ENDP
  1312 00001447 7661726961626C6520-     getOp1_0 db "variable not found",0
  1313 00001450 6E6F7420666F756E64-
  1314 00001459 00                 
  1315                                  
  1316                                  getMEM:  ; *** PROC ***
  1317                                  
  1318                                  ;-68 //set: disp, rm, R2Type
  1319                                  
  1320                                  
  1321                                  ;-69     char c;
  1322                                  
  1323                                  
  1324                                  ;-70     disp=0; rm=0;
  1325                                  
  1326                                  ;Function : getMEM, Number of local variables: 1
  1327                                  ;   # type sign width line used address name   list of local variables
  1328                                  ;  200 var sign byte    69 NULL bp-2    c;
  1329 0000145A C8020000                 ENTER  2,0
  1330 0000145E 66B800000000             mov eax, 0
  1331 00001464 A3[BC01]                 mov word [disp], ax
  1332 00001467 66B800000000             mov eax, 0
  1333 0000146D A2[BA01]                 mov byte [rm], al
  1334                                  
  1335                                  ;-71     do {
  1336                                  
  1337                                  @@getMEM24:
  1338                                  
  1339                                  ;-72         getTokeType();
  1340                                  
  1341 00001470 E87B03                   call getTokeType
  1342                                  
  1343                                  ;-73         c=getOp1();
  1344                                  
  1345 00001473 E85EFF                   call getOp1
  1346 00001476 8846FE                   mov byte [bp-2], al
  1347                                  
  1348                                  ;-74         if (c ==   0) syntaxerror();
  1349                                  
  1350 00001479 8A46FE                   mov al, [bp-2]
  1351 0000147C 3C00                     cmp al, 0
  1352 0000147E 0F850300                 jne @@getMEM25
  1353 00001482 E85613                   call syntaxerror
  1354                                  
  1355                                  ;-75         if (c == REG) {
  1356                                  
  1357                                  @@getMEM25:
  1358 00001485 8A46FE                   mov al, [bp-2]
  1359 00001488 3C02                     cmp al, 2
  1360 0000148A 0F851E00                 jne @@getMEM26
  1361                                  
  1362                                  ;-76             isDirect=0;
  1363                                  
  1364 0000148E 66B800000000             mov eax, 0
  1365 00001494 A2[BB01]                 mov byte [isDirect], al
  1366                                  
  1367                                  ;-77             if (rm) rm=getIndReg2();
  1368                                  
  1369 00001497 A0[BA01]                 mov al, [rm]
  1370 0000149A 08C0                     or  al, al
  1371 0000149C 0F840900                 je @@getMEM27
  1372 000014A0 E8F300                   call getIndReg2
  1373 000014A3 A2[BA01]                 mov byte [rm], al
  1374                                  
  1375                                  ;-78             else getIndReg1();
  1376                                  
  1377 000014A6 E90300                   jmp @@getMEM28
  1378                                  @@getMEM27:
  1379 000014A9 E88900                   call getIndReg1
  1380                                  
  1381                                  ;-79         }
  1382                                  
  1383                                  @@getMEM28:
  1384                                  
  1385                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1386                                  
  1387                                  @@getMEM26:
  1388 000014AC 8A46FE                   mov al, [bp-2]
  1389 000014AF 3C03                     cmp al, 3
  1390 000014B1 0F851000                 jne @@getMEM29
  1391 000014B5 A1[BC01]                 mov ax, [disp]
  1392 000014B8 8B1E[7E06]               mov bx, [LabelIx]
  1393 000014BC D1E3                     shl bx, 1
  1394 000014BE 0387[B405]               add ax, [LabelAddr + bx]
  1395 000014C2 A3[BC01]                 mov word [disp], ax
  1396                                  
  1397                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1398                                  
  1399                                  @@getMEM29:
  1400 000014C5 8A46FE                   mov al, [bp-2]
  1401 000014C8 3C01                     cmp al, 1
  1402 000014CA 0F850A00                 jne @@getMEM30
  1403 000014CE A1[BC01]                 mov ax, [disp]
  1404 000014D1 0306[4D00]               add ax, [SymbolInt]
  1405 000014D5 A3[BC01]                 mov word [disp], ax
  1406                                  
  1407                                  ;-82         if (isToken('-')) {
  1408                                  
  1409                                  @@getMEM30:
  1410 000014D8 6A2D                     push 45
  1411 000014DA E8E706                   call isToken
  1412 000014DD 83C402                   add  sp, 2
  1413 000014E0 08C0                     or  al, al
  1414 000014E2 0F841900                 je @@getMEM31
  1415                                  
  1416                                  ;-83             getTokeType();
  1417                                  
  1418 000014E6 E80503                   call getTokeType
  1419                                  
  1420                                  ;-84             if (TokeType != DIGIT) numbererror();
  1421                                  
  1422 000014E9 A0[AB01]                 mov al, [TokeType]
  1423 000014EC 3C01                     cmp al, 1
  1424 000014EE 0F840300                 je  @@getMEM32
  1425 000014F2 E85312                   call numbererror
  1426                                  
  1427                                  ;-85             disp = disp - SymbolInt;
  1428                                  
  1429                                  @@getMEM32:
  1430 000014F5 A1[BC01]                 mov ax, [disp]
  1431 000014F8 2B06[4D00]               sub ax, [SymbolInt]
  1432 000014FC A3[BC01]                 mov word [disp], ax
  1433                                  
  1434                                  ;-86         }
  1435                                  
  1436                                  
  1437                                  ;-87     } while (isToken('+'));
  1438                                  
  1439                                  @@getMEM31:
  1440 000014FF 6A2B                     push 43
  1441 00001501 E8C006                   call isToken
  1442 00001504 83C402                   add  sp, 2
  1443 00001507 08C0                     or  al, al
  1444 00001509 0F840300                 je @@getMEM33
  1445 0000150D E960FF                   jmp @@getMEM24
  1446                                  @@getMEM33:
  1447                                  
  1448                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1449                                  
  1450 00001510 6A5D                     push 93
  1451 00001512 E8AF06                   call isToken
  1452 00001515 83C402                   add  sp, 2
  1453 00001518 83F800                   cmp ax, 0
  1454 0000151B 0F850900                 jne @@getMEM34
  1455 0000151F 68[2A15]                 push getMEM_0
  1456 00001522 E85611                   call errorexit
  1457 00001525 83C402                   add  sp, 2
  1458                                  
  1459                                  ;-89 }
  1460                                  
  1461                                  @@getMEM34:
  1462                                  
  1463                                  ;-90 int getIndReg1() {
  1464 00001528 C9                       LEAVE
  1465 00001529 C3                       ret
  1466                                  ; ENDP
  1467 0000152A 5D2065787065637465-     getMEM_0 db "] expected",0
  1468 00001533 6400               
  1469                                  
  1470                                  getIndReg1:  ; *** PROC ***
  1471                                  
  1472                                  ;-91     if (R2Type !=WORD) indexerror();
  1473                                  
  1474 00001535 A0[B401]                 mov al, [R2Type]
  1475 00001538 3C02                     cmp al, 2
  1476 0000153A 0F840300                 je  @@getIndReg135
  1477 0000153E E8C511                   call indexerror
  1478                                  
  1479                                  ;-92     if (R2No==3) rm=7;//BX
  1480                                  
  1481                                  @@getIndReg135:
  1482 00001541 A0[B201]                 mov al, [R2No]
  1483 00001544 3C03                     cmp al, 3
  1484 00001546 0F850900                 jne @@getIndReg136
  1485 0000154A 66B807000000             mov eax, 7
  1486 00001550 A2[BA01]                 mov byte [rm], al
  1487                                  
  1488                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1489                                  
  1490                                  @@getIndReg136:
  1491 00001553 A0[B201]                 mov al, [R2No]
  1492 00001556 3C05                     cmp al, 5
  1493 00001558 0F850900                 jne @@getIndReg137
  1494 0000155C 66B806000000             mov eax, 6
  1495 00001562 A2[BA01]                 mov byte [rm], al
  1496                                  
  1497                                  ;-94     if (R2No==7) rm=5;//DI
  1498                                  
  1499                                  @@getIndReg137:
  1500 00001565 A0[B201]                 mov al, [R2No]
  1501 00001568 3C07                     cmp al, 7
  1502 0000156A 0F850900                 jne @@getIndReg138
  1503 0000156E 66B805000000             mov eax, 5
  1504 00001574 A2[BA01]                 mov byte [rm], al
  1505                                  
  1506                                  ;-95     if (R2No==6) rm=4;//SI
  1507                                  
  1508                                  @@getIndReg138:
  1509 00001577 A0[B201]                 mov al, [R2No]
  1510 0000157A 3C06                     cmp al, 6
  1511 0000157C 0F850900                 jne @@getIndReg139
  1512 00001580 66B804000000             mov eax, 4
  1513 00001586 A2[BA01]                 mov byte [rm], al
  1514                                  
  1515                                  ;-96     if (rm==0) indexerror();
  1516                                  
  1517                                  @@getIndReg139:
  1518 00001589 A0[BA01]                 mov al, [rm]
  1519 0000158C 3C00                     cmp al, 0
  1520 0000158E 0F850300                 jne @@getIndReg140
  1521 00001592 E87111                   call indexerror
  1522                                  
  1523                                  ;-97 }
  1524                                  
  1525                                  @@getIndReg140:
  1526                                  
  1527                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1528                                  
  1529 00001595 C3                       ret
  1530                                  ; ENDP
  1531                                  
  1532                                  getIndReg2:  ; *** PROC ***
  1533                                  ;Function : getIndReg2, Number of local variables: 1
  1534                                  ;   # type sign width line used address name   list of local variables
  1535                                  ;  200 var sign byte    98 NULL bp-2    m;
  1536 00001596 C8020000                 ENTER  2,0
  1537 0000159A 66B804000000             mov eax, 4
  1538 000015A0 8846FE                   mov byte [bp-2], al
  1539                                  
  1540                                  ;-99     if (R2Type !=WORD) indexerror();
  1541                                  
  1542 000015A3 A0[B401]                 mov al, [R2Type]
  1543 000015A6 3C02                     cmp al, 2
  1544 000015A8 0F840300                 je  @@getIndReg241
  1545 000015AC E85711                   call indexerror
  1546                                  
  1547                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1548                                  
  1549                                  @@getIndReg241:
  1550 000015AF A0[B201]                 mov al, [R2No]
  1551 000015B2 3C07                     cmp al, 7
  1552 000015B4 0F852700                 jne @@getIndReg242
  1553 000015B8 A0[BA01]                 mov al, [rm]
  1554 000015BB 3C06                     cmp al, 6
  1555 000015BD 0F850C00                 jne @@getIndReg243
  1556 000015C1 66B803000000             mov eax, 3
  1557 000015C7 8846FE                   mov byte [bp-2], al
  1558                                  
  1559                                  ;-101              else if (rm==7) m=1;//BX+DI
  1560                                  
  1561 000015CA E91200                   jmp @@getIndReg244
  1562                                  @@getIndReg243:
  1563 000015CD A0[BA01]                 mov al, [rm]
  1564 000015D0 3C07                     cmp al, 7
  1565 000015D2 0F850900                 jne @@getIndReg245
  1566 000015D6 66B801000000             mov eax, 1
  1567 000015DC 8846FE                   mov byte [bp-2], al
  1568                                  
  1569                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1570                                  
  1571                                  @@getIndReg245:
  1572                                  @@getIndReg244:
  1573                                  @@getIndReg242:
  1574 000015DF A0[B201]                 mov al, [R2No]
  1575 000015E2 3C06                     cmp al, 6
  1576 000015E4 0F852700                 jne @@getIndReg246
  1577 000015E8 A0[BA01]                 mov al, [rm]
  1578 000015EB 3C06                     cmp al, 6
  1579 000015ED 0F850C00                 jne @@getIndReg247
  1580 000015F1 66B802000000             mov eax, 2
  1581 000015F7 8846FE                   mov byte [bp-2], al
  1582                                  
  1583                                  ;-103              else if (rm==7) m=0;//BX+SI
  1584                                  
  1585 000015FA E91200                   jmp @@getIndReg248
  1586                                  @@getIndReg247:
  1587 000015FD A0[BA01]                 mov al, [rm]
  1588 00001600 3C07                     cmp al, 7
  1589 00001602 0F850900                 jne @@getIndReg249
  1590 00001606 66B800000000             mov eax, 0
  1591 0000160C 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-104     if (m > 3) indexerror();
  1594                                  
  1595                                  @@getIndReg249:
  1596                                  @@getIndReg248:
  1597                                  @@getIndReg246:
  1598 0000160F 8A46FE                   mov al, [bp-2]
  1599 00001612 3C03                     cmp al, 3
  1600 00001614 0F8E0300                 jle @@getIndReg250
  1601 00001618 E8EB10                   call indexerror
  1602                                  
  1603                                  ;-105     return m;
  1604                                  
  1605                                  @@getIndReg250:
  1606 0000161B 8A46FE                   mov al, [bp-2]
  1607 0000161E E90000                   jmp @@retn
  1608                                  
  1609                                  ;-106 }
  1610                                  
  1611                                  
  1612                                  ;-107                   
  1613                                  
  1614                                  
  1615                                  ;-108 int setwflag() {//word size, bit 0
  1616                                  
  1617 00001621 C9                      @@retn: LEAVE
  1618 00001622 C3                       ret
  1619                                  ; ENDP
  1620                                  
  1621                                  setwflag:  ; *** PROC ***
  1622                                  
  1623                                  ;-109     wflag=0;
  1624                                  
  1625 00001623 66B800000000             mov eax, 0
  1626 00001629 A2[B701]                 mov byte [wflag], al
  1627                                  
  1628                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1629                                  
  1630 0000162C A0[B601]                 mov al, [OpSize]
  1631 0000162F 3C00                     cmp al, 0
  1632 00001631 0F854200                 jne @@setwflag51
  1633                                  
  1634                                  ;-111         if (Op == REG) OpSize=R1Type;
  1635                                  
  1636 00001635 A0[AC01]                 mov al, [Op]
  1637 00001638 3C02                     cmp al, 2
  1638 0000163A 0F850600                 jne @@setwflag52
  1639 0000163E A0[B501]                 mov al, [R1Type]
  1640 00001641 A2[B601]                 mov byte [OpSize], al
  1641                                  
  1642                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1643                                  
  1644                                  @@setwflag52:
  1645 00001644 A0[AD01]                 mov al, [Op2]
  1646 00001647 3C02                     cmp al, 2
  1647 00001649 0F850600                 jne @@setwflag53
  1648 0000164D A0[B401]                 mov al, [R2Type]
  1649 00001650 A2[B601]                 mov byte [OpSize], al
  1650                                  
  1651                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1652                                  
  1653                                  @@setwflag53:
  1654 00001653 A0[B401]                 mov al, [R2Type]
  1655 00001656 3C04                     cmp al, 4
  1656 00001658 0F850900                 jne @@setwflag54
  1657 0000165C 66B802000000             mov eax, 2
  1658 00001662 A2[B601]                 mov byte [OpSize], al
  1659                                  
  1660                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1661                                  
  1662                                  @@setwflag54:
  1663 00001665 A0[B501]                 mov al, [R1Type]
  1664 00001668 3C04                     cmp al, 4
  1665 0000166A 0F850900                 jne @@setwflag55
  1666 0000166E 66B802000000             mov eax, 2
  1667 00001674 A2[B601]                 mov byte [OpSize], al
  1668                                  
  1669                                  ;-115     }
  1670                                  
  1671                                  @@setwflag55:
  1672                                  
  1673                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1674                                  
  1675                                  @@setwflag51:
  1676 00001677 A0[B601]                 mov al, [OpSize]
  1677 0000167A 3C03                     cmp al, 3
  1678 0000167C 0F850C00                 jne @@setwflag56
  1679 00001680 E82E15                   call gen66h
  1680 00001683 66B801000000             mov eax, 1
  1681 00001689 A2[B701]                 mov byte [wflag], al
  1682                                  
  1683                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1684                                  
  1685                                  @@setwflag56:
  1686 0000168C A0[B601]                 mov al, [OpSize]
  1687 0000168F 3C02                     cmp al, 2
  1688 00001691 0F850900                 jne @@setwflag57
  1689 00001695 66B801000000             mov eax, 1
  1690 0000169B A2[B701]                 mov byte [wflag], al
  1691                                  
  1692                                  ;-118 }
  1693                                  
  1694                                  @@setwflag57:
  1695                                  
  1696                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1697                                  
  1698 0000169E C3                       ret
  1699                                  ; ENDP
  1700                                  
  1701                                  setsflag:  ; *** PROC ***
  1702                                  
  1703                                  ;-120     unsigned int ui;    
  1704                                  
  1705                                  
  1706                                  ;-121     sflag=2;   
  1707                                  
  1708                                  ;Function : setsflag, Number of local variables: 1
  1709                                  ;   # type sign width line used address name   list of local variables
  1710                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1711 0000169F C8020000                 ENTER  2,0
  1712 000016A3 66B802000000             mov eax, 2
  1713 000016A9 A2[B901]                 mov byte [sflag], al
  1714                                  
  1715                                  ;-122     ui = imme & 0xFF80; 
  1716                                  
  1717 000016AC A1[BE01]                 mov ax, [imme]
  1718 000016AF 2580FF                   and ax, 65408
  1719 000016B2 8946FE                   mov word [bp-2], ax
  1720                                  
  1721                                  ;-123     if(ui != 0) sflag = 0;    //vvv
  1722                                  
  1723 000016B5 8B46FE                   mov ax, [bp-2]
  1724 000016B8 83F800                   cmp ax, 0
  1725 000016BB 0F840900                 je  @@setsflag58
  1726 000016BF 66B800000000             mov eax, 0
  1727 000016C5 A2[B901]                 mov byte [sflag], al
  1728                                  
  1729                                  ;-124     if (OpSize == BYTE) {
  1730                                  
  1731                                  @@setsflag58:
  1732 000016C8 A0[B601]                 mov al, [OpSize]
  1733 000016CB 3C01                     cmp al, 1
  1734 000016CD 0F851C00                 jne @@setsflag59
  1735                                  
  1736                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1737                                  
  1738 000016D1 A1[BE01]                 mov ax, [imme]
  1739 000016D4 3DFF00                   cmp ax, 255
  1740 000016D7 0F8E0900                 jle @@setsflag60
  1741 000016DB 68[EF16]                 push setsflag_0
  1742 000016DE E83B0F                   call error1
  1743 000016E1 83C402                   add  sp, 2
  1744                                  
  1745                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1746                                  
  1747                                  @@setsflag60:
  1748 000016E4 66B800000000             mov eax, 0
  1749 000016EA A2[B901]                 mov byte [sflag], al
  1750                                  
  1751                                  ;-127     }
  1752                                  
  1753                                  
  1754                                  ;-128 }
  1755                                  
  1756 000016ED C9                      @@setsflag59: LEAVE
  1757 000016EE C3                       ret
  1758                                  ; ENDP
  1759 000016EF 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1760 000016F8 6F7220627974652072-
  1761 00001701 2F6D00             
  1762                                  ;Back to main program: AS.C
  1763                                  
  1764                                  ;-5 #include "PARSE.C"
  1765                                  
  1766                                  ;Use include file: PARSE.C
  1767                                  
  1768                                  ;-1 int parse() {
  1769                                  
  1770                                  
  1771                                  parse:  ; *** PROC ***
  1772                                  
  1773                                  ;-2   LabelNamePtr= &LabelNames;
  1774                                  
  1775 00001704 B8[CA01]                 mov ax, LabelNames
  1776 00001707 A3[B205]                 mov word [LabelNamePtr], ax
  1777                                  
  1778                                  ;-3   do {
  1779                                  
  1780                                  @@parse61:
  1781                                  
  1782                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  1783                                  
  1784 0000170A A1[A601]                 mov ax, [PC]
  1785 0000170D A3[A801]                 mov word [PCStart], ax
  1786 00001710 66B800000000             mov eax, 0
  1787 00001716 A2[B601]                 mov byte [OpSize], al
  1788 00001719 66B800000000             mov eax, 0
  1789 0000171F A3[C501]                 mov word [OpPrintIndex], ax
  1790 00001722 66B820000000             mov eax, 32
  1791 00001728 A2[C901]                 mov byte [PrintR], al
  1792                                  
  1793                                  ;-5     getLine();
  1794                                  
  1795 0000172B E82C05                   call getLine
  1796                                  
  1797                                  ;-6     InputPtr = &InputBuf;
  1798                                  
  1799 0000172E B8[4F00]                 mov ax, InputBuf
  1800 00001731 A3[CE00]                 mov word [InputPtr], ax
  1801                                  
  1802                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1803                                  
  1804 00001734 E8B700                   call getTokeType
  1805                                  
  1806                                  ;-8     if (TokeType == ALNUME) {
  1807                                  
  1808 00001737 A0[AB01]                 mov al, [TokeType]
  1809 0000173A 3C03                     cmp al, 3
  1810 0000173C 0F851300                 jne @@parse62
  1811                                  
  1812                                  ;-9       if (isLabel) { //set in getName
  1813                                  
  1814 00001740 A0[AA01]                 mov al, [isLabel]
  1815 00001743 08C0                     or  al, al
  1816 00001745 0F840A00                 je @@parse63
  1817                                  
  1818                                  ;-10         storeLabel();
  1819                                  
  1820 00001749 E84001                   call storeLabel
  1821                                  
  1822                                  ;-11         InputPtr++;//remove :
  1823                                  
  1824 0000174C FF06[CE00]               inc  word [InputPtr]
  1825                                  
  1826                                  ;-12         getTokeType();
  1827                                  
  1828 00001750 E89B00                   call getTokeType
  1829                                  
  1830                                  ;-13       }
  1831                                  
  1832                                  
  1833                                  ;-14     }
  1834                                  
  1835                                  @@parse63:
  1836                                  
  1837                                  ;-15     if (TokeType == ALNUME) {
  1838                                  
  1839                                  @@parse62:
  1840 00001753 A0[AB01]                 mov al, [TokeType]
  1841 00001756 3C03                     cmp al, 3
  1842 00001758 0F851B00                 jne @@parse64
  1843                                  
  1844                                  ;-16       lookCode();// and OpCodePtr
  1845                                  
  1846 0000175C E86803                   call lookCode
  1847                                  
  1848                                  ;-17       if(CodeType) process();
  1849                                  
  1850 0000175F A0[AE01]                 mov al, [CodeType]
  1851 00001762 08C0                     or  al, al
  1852 00001764 0F840600                 je @@parse65
  1853 00001768 E83416                   call process
  1854                                  
  1855                                  ;-18       else getVariable();
  1856                                  
  1857 0000176B E90300                   jmp @@parse66
  1858                                  @@parse65:
  1859 0000176E E81E02                   call getVariable
  1860                                  
  1861                                  ;-19       skipRest();
  1862                                  
  1863                                  @@parse66:
  1864 00001771 E8BD04                   call skipRest
  1865                                  
  1866                                  ;-20     }
  1867                                  
  1868                                  
  1869                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1870                                  
  1871 00001774 E92700                   jmp @@parse67
  1872                                  @@parse64:
  1873 00001777 A0[AB01]                 mov al, [TokeType]
  1874 0000177A 3C03                     cmp al, 3
  1875 0000177C 0F8E0C00                 jle @@parse68
  1876 00001780 68[AF17]                 push parse_0
  1877 00001783 E8960E                   call error1
  1878 00001786 83C402                   add  sp, 2
  1879                                  
  1880                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1881                                  
  1882 00001789 E91200                   jmp @@parse69
  1883                                  @@parse68:
  1884 0000178C A0[AB01]                 mov al, [TokeType]
  1885 0000178F 3C01                     cmp al, 1
  1886 00001791 0F850900                 jne @@parse70
  1887 00001795 68[CD17]                 push parse_1
  1888 00001798 E8810E                   call error1
  1889 0000179B 83C402                   add  sp, 2
  1890                                  
  1891                                  ;-23     printLine();
  1892                                  
  1893                                  @@parse70:
  1894                                  @@parse69:
  1895                                  @@parse67:
  1896 0000179E E80C0C                   call printLine
  1897                                  
  1898                                  ;-24   } while (DOS_NoBytes != 0 );
  1899                                  
  1900 000017A1 A1[A301]                 mov ax, [DOS_NoBytes]
  1901 000017A4 83F800                   cmp ax, 0
  1902 000017A7 0F840300                 je  @@parse71
  1903 000017AB E95CFF                   jmp @@parse61
  1904                                  @@parse71:
  1905                                  
  1906                                  ;-25 }
  1907                                  
  1908                                  
  1909                                  ;-26 // scan code .....................................
  1910                                  
  1911                                  
  1912                                  ;-27 int getTokeType() { char c;
  1913                                  
  1914 000017AE C3                       ret
  1915                                  ; ENDP
  1916 000017AF 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1917 000017B8 696E73747275637469-
  1918 000017C1 6F6E20657870656374-
  1919 000017CA 656400             
  1920 000017CD 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1921 000017D6 616C6C6F7765642040-
  1922 000017DF 207374617274206F66-
  1923 000017E8 206C696E6500       
  1924                                  
  1925                                  getTokeType:  ; *** PROC ***
  1926                                  
  1927                                  ;-28   skipBlank();
  1928                                  
  1929                                  ;Function : getTokeType, Number of local variables: 1
  1930                                  ;   # type sign width line used address name   list of local variables
  1931                                  ;  200 var sign byte    27 NULL bp-2    c;
  1932 000017EE C8020000                 ENTER  2,0
  1933 000017F2 E86705                   call skipBlank
  1934                                  
  1935                                  ;-29   c = *InputPtr;
  1936                                  
  1937 000017F5 8B1E[CE00]               mov bx, [InputPtr]
  1938 000017F9 8A07                     mov al, [bx]
  1939 000017FB B400                     mov ah, 0
  1940 000017FD 8846FE                   mov byte [bp-2], al
  1941                                  
  1942                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1943                                  
  1944 00001800 8A46FE                   mov al, [bp-2]
  1945 00001803 3C00                     cmp al, 0
  1946 00001805 0F850C00                 jne @@getTokeType72
  1947 00001809 66B800000000             mov eax, 0
  1948 0000180F A2[AB01]                 mov byte [TokeType], al
  1949 00001812 E97500                   jmp @@retn
  1950                                  
  1951                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1952                                  
  1953                                  @@getTokeType72:
  1954 00001815 8A46FE                   mov al, [bp-2]
  1955 00001818 3C3B                     cmp al, 59
  1956 0000181A 0F850C00                 jne @@getTokeType73
  1957 0000181E 66B800000000             mov eax, 0
  1958 00001824 A2[AB01]                 mov byte [TokeType], al
  1959 00001827 E96000                   jmp @@retn
  1960                                  
  1961                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1962                                  
  1963                                  @@getTokeType73:
  1964 0000182A 8A46FE                   mov al, byte [bp-2]
  1965 0000182D B400                     mov ah, 0
  1966 0000182F 50                       push ax
  1967 00001830 E8A61B                   call digit
  1968 00001833 83C402                   add  sp, 2
  1969 00001836 08C0                     or  al, al
  1970 00001838 0F841800                 je @@getTokeType74
  1971 0000183C 8A46FE                   mov al, byte [bp-2]
  1972 0000183F B400                     mov ah, 0
  1973 00001841 50                       push ax
  1974 00001842 E81D06                   call getDigit
  1975 00001845 83C402                   add  sp, 2
  1976 00001848 66B801000000             mov eax, 1
  1977 0000184E A2[AB01]                 mov byte [TokeType], al
  1978 00001851 E93600                   jmp @@retn
  1979                                  
  1980                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1981                                  
  1982                                  @@getTokeType74:
  1983 00001854 8A46FE                   mov al, byte [bp-2]
  1984 00001857 B400                     mov ah, 0
  1985 00001859 50                       push ax
  1986 0000185A E82A05                   call letterE
  1987 0000185D 83C402                   add  sp, 2
  1988 00001860 08C0                     or  al, al
  1989 00001862 0F841800                 je @@getTokeType75
  1990 00001866 8A46FE                   mov al, byte [bp-2]
  1991 00001869 B400                     mov ah, 0
  1992 0000186B 50                       push ax
  1993 0000186C E84A06                   call getName
  1994 0000186F 83C402                   add  sp, 2
  1995 00001872 66B803000000             mov eax, 3
  1996 00001878 A2[AB01]                 mov byte [TokeType], al
  1997 0000187B E90C00                   jmp @@retn
  1998                                  
  1999                                  ;-34   TokeType=NOALNUME; return;
  2000                                  
  2001                                  @@getTokeType75:
  2002 0000187E 66B804000000             mov eax, 4
  2003 00001884 A2[AB01]                 mov byte [TokeType], al
  2004 00001887 E90000                   jmp @@retn
  2005                                  
  2006                                  ;-35 }
  2007                                  
  2008                                  
  2009                                  ;-36 int storeLabel() {unsigned int i;
  2010                                  
  2011 0000188A C9                      @@retn: LEAVE
  2012 0000188B C3                       ret
  2013                                  ; ENDP
  2014                                  
  2015                                  storeLabel:  ; *** PROC ***
  2016                                  
  2017                                  ;-37   if(searchLabel()) error1("duplicate label");
  2018                                  
  2019                                  ;Function : storeLabel, Number of local variables: 1
  2020                                  ;   # type sign width line used address name   list of local variables
  2021                                  ;  200 var unsg word    36 NULL bp-2    i;
  2022 0000188C C8020000                 ENTER  2,0
  2023 00001890 E89C00                   call searchLabel
  2024 00001893 08C0                     or  al, al
  2025 00001895 0F840900                 je @@storeLabel76
  2026 00001899 68[FA18]                 push storeLabel_0
  2027 0000189C E87D0D                   call error1
  2028 0000189F 83C402                   add  sp, 2
  2029                                  
  2030                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2031                                  
  2032                                  @@storeLabel76:
  2033 000018A2 8D06[0F00]               lea  ax, [Symbol]
  2034 000018A6 50                       push ax
  2035 000018A7 FF36[B205]               push word [LabelNamePtr]
  2036 000018AB E8F21A                   call strcpy
  2037 000018AE 83C404                   add  sp, 4
  2038 000018B1 A3[B205]                 mov word [LabelNamePtr], ax
  2039                                  
  2040                                  ;-39   LabelNamePtr++;
  2041                                  
  2042 000018B4 FF06[B205]               inc  word [LabelNamePtr]
  2043                                  
  2044                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  2045                                  
  2046 000018B8 A1[B205]                 mov ax, [LabelNamePtr]
  2047 000018BB 2D[CA01]                 sub ax, LabelNames
  2048 000018BE 8946FE                   mov word [bp-2], ax
  2049                                  
  2050                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  2051                                  
  2052 000018C1 8B46FE                   mov ax, [bp-2]
  2053 000018C4 3DC903                   cmp ax, 969 ;unsigned : 0
  2054 000018C7 0F820900                 jb  @@storeLabel77
  2055 000018CB 68[0A19]                 push storeLabel_1
  2056 000018CE E8AA0D                   call errorexit
  2057 000018D1 83C402                   add  sp, 2
  2058                                  
  2059                                  ;-42   LabelMaxIx++;
  2060                                  
  2061                                  @@storeLabel77:
  2062 000018D4 FF06[7C06]               inc  word [LabelMaxIx]
  2063                                  
  2064                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2065                                  
  2066 000018D8 A1[7C06]                 mov ax, [LabelMaxIx]
  2067 000018DB 83F864                   cmp ax, 100 ;unsigned : 1
  2068 000018DE 0F8C0900                 jl  @@storeLabel78
  2069 000018E2 68[1F19]                 push storeLabel_2
  2070 000018E5 E8930D                   call errorexit
  2071 000018E8 83C402                   add  sp, 2
  2072                                  
  2073                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  2074                                  
  2075                                  @@storeLabel78:
  2076 000018EB A1[A601]                 mov ax, [PC]
  2077 000018EE 8B1E[7C06]               mov bx, [LabelMaxIx]
  2078 000018F2 D1E3                     shl bx, 1
  2079 000018F4 8987[B405]               mov [LabelAddr+bx], ax
  2080                                  
  2081                                  ;-45 }
  2082                                  
  2083                                  
  2084                                  ;-46 int searchLabel() {
  2085 000018F8 C9                       LEAVE
  2086 000018F9 C3                       ret
  2087                                  ; ENDP
  2088 000018FA 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2089 00001903 206C6162656C00     
  2090 0000190A 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2091 00001913 6C6162656C206E616D-
  2092 0000191C 657300             
  2093 0000191F 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2094 00001928 6C6162656C7300     
  2095                                  
  2096                                  searchLabel:  ; *** PROC ***
  2097                                  
  2098                                  ;-47   int LIx; char *p; int j;
  2099                                  
  2100                                  
  2101                                  ;-48   p = &LabelNames;
  2102                                  
  2103                                  ;Function : searchLabel, Number of local variables: 3
  2104                                  ;   # type sign width line used address name   list of local variables
  2105                                  ;  200 var sign word    47 NULL bp-2    LIx
  2106                                  ;  201 ptr sign byte    47 NULL bp-4    p
  2107                                  ;  202 var sign word    47 NULL bp-6    j;
  2108 0000192F C8060000                 ENTER  6,0
  2109 00001933 B8[CA01]                 mov ax, LabelNames
  2110 00001936 8946FC                   mov word [bp-4], ax
  2111                                  
  2112                                  ;-49   LIx=1;
  2113                                  
  2114 00001939 66B801000000             mov eax, 1
  2115 0000193F 8946FE                   mov word [bp-2], ax
  2116                                  
  2117                                  ;-50   while (LIx <= LabelMaxIx) {
  2118                                  
  2119                                  @@searchLabel79:
  2120 00001942 8B46FE                   mov ax, [bp-2]
  2121 00001945 3B06[7C06]               cmp ax, [LabelMaxIx]
  2122 00001949 0F8F3700                 jg  @@searchLabel80
  2123                                  
  2124                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  2125                                  
  2126 0000194D 8D06[0F00]               lea  ax, [Symbol]
  2127 00001951 50                       push ax
  2128 00001952 FF76FC                   push word [bp-4]
  2129 00001955 E8B41A                   call eqstr
  2130 00001958 83C404                   add  sp, 4
  2131 0000195B 08C0                     or  al, al
  2132 0000195D 0F840600                 je @@searchLabel81
  2133 00001961 8B46FE                   mov ax, [bp-2]
  2134 00001964 E92600                   jmp @@retn
  2135                                  
  2136                                  ;-52     j=strlen(p);
  2137                                  
  2138                                  @@searchLabel81:
  2139 00001967 FF76FC                   push word [bp-4]
  2140 0000196A E8081A                   call strlen
  2141 0000196D 83C402                   add  sp, 2
  2142 00001970 8946FA                   mov word [bp-6], ax
  2143                                  
  2144                                  ;-53     p=p+j; p++; LIx++;
  2145                                  
  2146 00001973 8B46FC                   mov ax, [bp-4]
  2147 00001976 0346FA                   add ax, [bp-6]
  2148 00001979 8946FC                   mov word [bp-4], ax
  2149 0000197C FF46FC                   inc  word [bp-4]
  2150 0000197F FF46FE                   inc  word [bp-2]
  2151                                  
  2152                                  ;-54   }
  2153                                  
  2154                                  
  2155                                  ;-55   return 0;
  2156                                  
  2157 00001982 EBBE                     jmp @@searchLabel79
  2158                                  @@searchLabel80:
  2159 00001984 66B800000000             mov eax, 0
  2160 0000198A E90000                   jmp @@retn
  2161                                  
  2162                                  ;-56 }
  2163                                  
  2164                                  
  2165                                  ;-57 int getVariable() { char c;
  2166                                  
  2167 0000198D C9                      @@retn: LEAVE
  2168 0000198E C3                       ret
  2169                                  ; ENDP
  2170                                  
  2171                                  getVariable:  ; *** PROC ***
  2172                                  
  2173                                  ;-58   storeLabel();
  2174                                  
  2175                                  ;Function : getVariable, Number of local variables: 1
  2176                                  ;   # type sign width line used address name   list of local variables
  2177                                  ;  200 var sign byte    57 NULL bp-2    c;
  2178 0000198F C8020000                 ENTER  2,0
  2179 00001993 E8F6FE                   call storeLabel
  2180                                  
  2181                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  2182                                  
  2183 00001996 E855FE                   call getTokeType
  2184 00001999 A0[AB01]                 mov al, [TokeType]
  2185 0000199C 3C03                     cmp al, 3
  2186 0000199E 0F85CC00                 jne @@getVariable82
  2187                                  
  2188                                  ;-60     lookCode();
  2189                                  
  2190 000019A2 E82201                   call lookCode
  2191                                  
  2192                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2193                                  
  2194 000019A5 A0[AE01]                 mov al, [CodeType]
  2195 000019A8 3CC8                     cmp al, 200
  2196 000019AA 0F8D0900                 jge @@getVariable83
  2197 000019AE 68[791A]                 push getVariable_0
  2198 000019B1 E8C70C                   call errorexit
  2199 000019B4 83C402                   add  sp, 2
  2200                                  
  2201                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2202                                  
  2203                                  @@getVariable83:
  2204 000019B7 A0[AE01]                 mov al, [CodeType]
  2205 000019BA 3CCF                     cmp al, 207
  2206 000019BC 0F8E0900                 jle @@getVariable84
  2207 000019C0 68[911A]                 push getVariable_1
  2208 000019C3 E8B50C                   call errorexit
  2209 000019C6 83C402                   add  sp, 2
  2210                                  
  2211                                  ;-63     if (CodeType== 200) {// DB
  2212                                  
  2213                                  @@getVariable84:
  2214 000019C9 A0[AE01]                 mov al, [CodeType]
  2215 000019CC 3CC8                     cmp al, 200
  2216 000019CE 0F856A00                 jne @@getVariable85
  2217                                  
  2218                                  ;-64       do { getTokeType();
  2219                                  
  2220                                  @@getVariable86:
  2221 000019D2 E819FE                   call getTokeType
  2222                                  
  2223                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2224                                  
  2225 000019D5 A0[AB01]                 mov al, [TokeType]
  2226 000019D8 3C01                     cmp al, 1
  2227 000019DA 0F850D00                 jne @@getVariable87
  2228 000019DE FF36[4D00]               push word [SymbolInt]
  2229 000019E2 E80C12                   call genCode8
  2230 000019E5 83C402                   add  sp, 2
  2231                                  
  2232                                  ;-66         else {
  2233                                  
  2234 000019E8 E94100                   jmp @@getVariable88
  2235                                  @@getVariable87:
  2236                                  
  2237                                  ;-67           skipBlank();
  2238                                  
  2239 000019EB E86E03                   call skipBlank
  2240                                  
  2241                                  ;-68           if (isToken('"')) {
  2242                                  
  2243 000019EE 6A22                     push 34
  2244 000019F0 E8D101                   call isToken
  2245 000019F3 83C402                   add  sp, 2
  2246 000019F6 08C0                     or  al, al
  2247 000019F8 0F843000                 je @@getVariable89
  2248                                  
  2249                                  ;-69             do { c= *InputPtr;
  2250                                  
  2251                                  @@getVariable90:
  2252 000019FC 8B1E[CE00]               mov bx, [InputPtr]
  2253 00001A00 8A07                     mov al, [bx]
  2254 00001A02 B400                     mov ah, 0
  2255 00001A04 8846FE                   mov byte [bp-2], al
  2256                                  
  2257                                  ;-70               genCode8(c);
  2258                                  
  2259 00001A07 8A46FE                   mov al, byte [bp-2]
  2260 00001A0A B400                     mov ah, 0
  2261 00001A0C 50                       push ax
  2262 00001A0D E8E111                   call genCode8
  2263 00001A10 83C402                   add  sp, 2
  2264                                  
  2265                                  ;-71               InputPtr++;
  2266                                  
  2267 00001A13 FF06[CE00]               inc  word [InputPtr]
  2268                                  
  2269                                  ;-72             } while (*InputPtr != '"' );
  2270                                  
  2271 00001A17 8B1E[CE00]               mov bx, [InputPtr]
  2272 00001A1B 8A07                     mov al, [bx]
  2273 00001A1D B400                     mov ah, 0
  2274 00001A1F 83F822                   cmp ax, 34
  2275 00001A22 0F840200                 je  @@getVariable91
  2276 00001A26 EBD4                     jmp @@getVariable90
  2277                                  @@getVariable91:
  2278                                  
  2279                                  ;-73             InputPtr++;
  2280                                  
  2281 00001A28 FF06[CE00]               inc  word [InputPtr]
  2282                                  
  2283                                  ;-74           }
  2284                                  
  2285                                  
  2286                                  ;-75         }
  2287                                  
  2288                                  @@getVariable89:
  2289                                  
  2290                                  ;-76       } while (isToken(','));
  2291                                  
  2292                                  @@getVariable88:
  2293 00001A2C 6A2C                     push 44
  2294 00001A2E E89301                   call isToken
  2295 00001A31 83C402                   add  sp, 2
  2296 00001A34 08C0                     or  al, al
  2297 00001A36 0F840200                 je @@getVariable92
  2298 00001A3A EB96                     jmp @@getVariable86
  2299                                  @@getVariable92:
  2300                                  
  2301                                  ;-77     }
  2302                                  
  2303                                  
  2304                                  ;-78     if (CodeType== 201) {// DW
  2305                                  
  2306                                  @@getVariable85:
  2307 00001A3C A0[AE01]                 mov al, [CodeType]
  2308 00001A3F 3CC9                     cmp al, 201
  2309 00001A41 0F852600                 jne @@getVariable93
  2310                                  
  2311                                  ;-79       do { getTokeType();
  2312                                  
  2313                                  @@getVariable94:
  2314 00001A45 E8A6FD                   call getTokeType
  2315                                  
  2316                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2317                                  
  2318 00001A48 A0[AB01]                 mov al, [TokeType]
  2319 00001A4B 3C01                     cmp al, 1
  2320 00001A4D 0F850A00                 jne @@getVariable95
  2321 00001A51 FF36[4D00]               push word [SymbolInt]
  2322 00001A55 E8F011                   call genCode16
  2323 00001A58 83C402                   add  sp, 2
  2324                                  
  2325                                  ;-81       } while (isToken(','));
  2326                                  
  2327                                  @@getVariable95:
  2328 00001A5B 6A2C                     push 44
  2329 00001A5D E86401                   call isToken
  2330 00001A60 83C402                   add  sp, 2
  2331 00001A63 08C0                     or  al, al
  2332 00001A65 0F840200                 je @@getVariable96
  2333 00001A69 EBDA                     jmp @@getVariable94
  2334                                  @@getVariable96:
  2335                                  
  2336                                  ;-82     }
  2337                                  
  2338                                  
  2339                                  ;-83   }
  2340                                  
  2341                                  @@getVariable93:
  2342                                  
  2343                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  2344                                  
  2345 00001A6B E90900                   jmp @@getVariable97
  2346                                  @@getVariable82:
  2347 00001A6E 68[A91A]                 push getVariable_2
  2348 00001A71 E8070C                   call errorexit
  2349 00001A74 83C402                   add  sp, 2
  2350                                  
  2351                                  ;-85 }
  2352                                  
  2353                                  @@getVariable97:
  2354                                  
  2355                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  2356 00001A77 C9                       LEAVE
  2357 00001A78 C3                       ret
  2358                                  ; ENDP
  2359 00001A79 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2360 00001A82 422C572C4420657870-
  2361 00001A8B 656374656400       
  2362 00001A91 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2363 00001A9A 422C572C4420657870-
  2364 00001AA3 656374656400       
  2365 00001AA9 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2366 00001AB2 6F7220524553422C57-
  2367 00001ABB 2C4420657870656374-
  2368 00001AC4 656400             
  2369                                  
  2370                                  lookCode:  ; *** PROC ***
  2371                                  
  2372                                  ;-87   CodeType=0;
  2373                                  
  2374 00001AC7 66B800000000             mov eax, 0
  2375 00001ACD A2[AE01]                 mov byte [CodeType], al
  2376                                  
  2377                                  ;-88   OpCodePtr= &I_START;
  2378                                  
  2379 00001AD0 B8[560E]                 mov ax, I_START
  2380 00001AD3 A3[C701]                 mov word [OpCodePtr], ax
  2381                                  
  2382                                  ;-89   OpCodePtr++;
  2383                                  
  2384 00001AD6 FF06[C701]               inc  word [OpCodePtr]
  2385                                  
  2386                                  ;-90   do  {
  2387                                  
  2388                                  @@lookCode98:
  2389                                  
  2390                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  2391                                  
  2392 00001ADA FF36[C701]               push word [OpCodePtr]
  2393 00001ADE 8D06[2E00]               lea  ax, [SymbolUpper]
  2394 00001AE2 50                       push ax
  2395 00001AE3 E82619                   call eqstr
  2396 00001AE6 83C404                   add  sp, 4
  2397 00001AE9 08C0                     or  al, al
  2398 00001AEB 0F842700                 je @@lookCode99
  2399                                  
  2400                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  2401                                  
  2402                                  @@lookCode100:
  2403 00001AEF 8B1E[C701]               mov bx, [OpCodePtr]
  2404 00001AF3 8A07                     mov al, [bx]
  2405 00001AF5 B400                     mov ah, 0
  2406 00001AF7 83F800                   cmp ax, 0
  2407 00001AFA 0F840600                 je  @@lookCode101
  2408 00001AFE FF06[C701]               inc  word [OpCodePtr]
  2409                                  
  2410                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  2411                                  
  2412 00001B02 EBEB                     jmp @@lookCode100
  2413                                  @@lookCode101:
  2414 00001B04 FF06[C701]               inc  word [OpCodePtr]
  2415 00001B08 8B1E[C701]               mov bx, [OpCodePtr]
  2416 00001B0C 8A07                     mov al, [bx]
  2417 00001B0E B400                     mov ah, 0
  2418 00001B10 A2[AE01]                 mov byte [CodeType], al
  2419                                  
  2420                                  ;-94       return;
  2421                                  
  2422 00001B13 E92A00                   jmp @@retn
  2423                                  
  2424                                  ;-95     }
  2425                                  
  2426                                  
  2427                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2428                                  
  2429                                  @@lookCode99:
  2430                                  @@lookCode102:
  2431 00001B16 8B1E[C701]               mov bx, [OpCodePtr]
  2432 00001B1A 8A07                     mov al, [bx]
  2433 00001B1C B400                     mov ah, 0
  2434 00001B1E 3DF100                   cmp ax, 241
  2435 00001B21 0F840600                 je  @@lookCode103
  2436 00001B25 FF06[C701]               inc  word [OpCodePtr]
  2437                                  
  2438                                  ;-97   OpCodePtr++;
  2439                                  
  2440 00001B29 EBEB                     jmp @@lookCode102
  2441                                  @@lookCode103:
  2442 00001B2B FF06[C701]               inc  word [OpCodePtr]
  2443                                  
  2444                                  ;-98   } while(*OpCodePtr!=0);
  2445                                  
  2446 00001B2F 8B1E[C701]               mov bx, [OpCodePtr]
  2447 00001B33 8A07                     mov al, [bx]
  2448 00001B35 B400                     mov ah, 0
  2449 00001B37 83F800                   cmp ax, 0
  2450 00001B3A 0F840200                 je  @@lookCode104
  2451 00001B3E EB9A                     jmp @@lookCode98
  2452                                  @@lookCode104:
  2453                                  
  2454                                  ;-99 }
  2455                                  
  2456                                  
  2457                                  ;-100 
  2458                                  
  2459                                  
  2460                                  ;-101 int getCodeSize() {
  2461                                  
  2462                                  @@retn:
  2463 00001B40 C3                       ret
  2464                                  ; ENDP
  2465                                  
  2466                                  getCodeSize:  ; *** PROC ***
  2467                                  
  2468                                  ;-102   if (TokeType ==ALNUME) {
  2469                                  
  2470 00001B41 A0[AB01]                 mov al, [TokeType]
  2471 00001B44 3C03                     cmp al, 3
  2472 00001B46 0F856000                 jne @@getCodeSize105
  2473                                  
  2474                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2475                                  
  2476 00001B4A 68[B41B]                 push getCodeSize_0
  2477 00001B4D 8D06[2E00]               lea  ax, [SymbolUpper]
  2478 00001B51 50                       push ax
  2479 00001B52 E8B718                   call eqstr
  2480 00001B55 83C404                   add  sp, 4
  2481 00001B58 08C0                     or  al, al
  2482 00001B5A 0F840C00                 je @@getCodeSize106
  2483 00001B5E E88DFC                   call getTokeType
  2484 00001B61 66B801000000             mov eax, 1
  2485 00001B67 E94900                   jmp @@retn
  2486                                  
  2487                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2488                                  
  2489                                  @@getCodeSize106:
  2490 00001B6A 68[B91B]                 push getCodeSize_1
  2491 00001B6D 8D06[2E00]               lea  ax, [SymbolUpper]
  2492 00001B71 50                       push ax
  2493 00001B72 E89718                   call eqstr
  2494 00001B75 83C404                   add  sp, 4
  2495 00001B78 08C0                     or  al, al
  2496 00001B7A 0F840C00                 je @@getCodeSize107
  2497 00001B7E E86DFC                   call getTokeType
  2498 00001B81 66B802000000             mov eax, 2
  2499 00001B87 E92900                   jmp @@retn
  2500                                  
  2501                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2502                                  
  2503                                  @@getCodeSize107:
  2504 00001B8A 68[BE1B]                 push getCodeSize_2
  2505 00001B8D 8D06[2E00]               lea  ax, [SymbolUpper]
  2506 00001B91 50                       push ax
  2507 00001B92 E87718                   call eqstr
  2508 00001B95 83C404                   add  sp, 4
  2509 00001B98 08C0                     or  al, al
  2510 00001B9A 0F840C00                 je @@getCodeSize108
  2511 00001B9E E84DFC                   call getTokeType
  2512 00001BA1 66B803000000             mov eax, 3
  2513 00001BA7 E90900                   jmp @@retn
  2514                                  
  2515                                  ;-106   } return 0;
  2516                                  
  2517                                  @@getCodeSize108:
  2518                                  @@getCodeSize105:
  2519 00001BAA 66B800000000             mov eax, 0
  2520 00001BB0 E90000                   jmp @@retn
  2521                                  
  2522                                  ;-107 }
  2523                                  
  2524                                  
  2525                                  ;-108 int isToken(char c) {
  2526                                  
  2527                                  @@retn:
  2528 00001BB3 C3                       ret
  2529                                  ; ENDP
  2530 00001BB4 4259544500              getCodeSize_0 db "BYTE",0
  2531 00001BB9 574F524400              getCodeSize_1 db "WORD",0
  2532 00001BBE 44574F524400            getCodeSize_2 db "DWORD",0
  2533                                  
  2534                                  isToken:  ; *** PROC ***
  2535                                  
  2536                                  ;-109   skipBlank();
  2537                                  
  2538                                  ;Function : isToken, Number of local variables: 1
  2539                                  ;   # type sign width line used address name   list of local variables
  2540                                  ;  200 var sign byte   108 NULL bp+4    c;
  2541 00001BC4 C8000000                 ENTER  0,0
  2542 00001BC8 E89101                   call skipBlank
  2543                                  
  2544                                  ;-110   if (*InputPtr == c) {
  2545                                  
  2546 00001BCB 8B1E[CE00]               mov bx, [InputPtr]
  2547 00001BCF 8A07                     mov al, [bx]
  2548 00001BD1 B400                     mov ah, 0
  2549 00001BD3 3A4604                   cmp al, [bp+4]
  2550 00001BD6 0F850D00                 jne @@isToken109
  2551                                  
  2552                                  ;-111     InputPtr++; return 1;} return 0;
  2553                                  
  2554 00001BDA FF06[CE00]               inc  word [InputPtr]
  2555 00001BDE 66B801000000             mov eax, 1
  2556 00001BE4 E90900                   jmp @@retn
  2557                                  @@isToken109:
  2558 00001BE7 66B800000000             mov eax, 0
  2559 00001BED E90000                   jmp @@retn
  2560                                  
  2561                                  ;-112 }
  2562                                  
  2563                                  
  2564                                  ;-113 int need(char c) {
  2565                                  
  2566 00001BF0 C9                      @@retn: LEAVE
  2567 00001BF1 C3                       ret
  2568                                  ; ENDP
  2569                                  
  2570                                  need:  ; *** PROC ***
  2571                                  
  2572                                  ;-114   if (isToken(c)) {
  2573                                  
  2574                                  ;Function : need, Number of local variables: 1
  2575                                  ;   # type sign width line used address name   list of local variables
  2576                                  ;  200 var sign byte   113 NULL bp+4    c;
  2577 00001BF2 C8000000                 ENTER  0,0
  2578 00001BF6 8A4604                   mov al, byte [bp+4]
  2579 00001BF9 B400                     mov ah, 0
  2580 00001BFB 50                       push ax
  2581 00001BFC E8C5FF                   call isToken
  2582 00001BFF 83C402                   add  sp, 2
  2583 00001C02 08C0                     or  al, al
  2584 00001C04 0F840600                 je @@need110
  2585                                  
  2586                                  ;-115       getTokeType();
  2587                                  
  2588 00001C08 E8E3FB                   call getTokeType
  2589                                  
  2590                                  ;-116       return;
  2591                                  
  2592 00001C0B E91800                   jmp @@retn
  2593                                  
  2594                                  ;-117       }
  2595                                  
  2596                                  
  2597                                  ;-118   error1();
  2598                                  
  2599                                  @@need110:
  2600 00001C0E E80B0A                   call error1
  2601                                  
  2602                                  ;-119   prs(". need: ");
  2603                                  
  2604 00001C11 68[281C]                 push need_0
  2605 00001C14 E8A408                   call prs
  2606 00001C17 83C402                   add  sp, 2
  2607                                  
  2608                                  ;-120   prc(c);
  2609                                  
  2610 00001C1A 8A4604                   mov al, byte [bp+4]
  2611 00001C1D B400                     mov ah, 0
  2612 00001C1F 50                       push ax
  2613 00001C20 E83708                   call prc
  2614 00001C23 83C402                   add  sp, 2
  2615                                  
  2616                                  ;-121 }
  2617                                  
  2618                                  
  2619                                  ;-122 
  2620                                  
  2621                                  
  2622                                  ;-123 int skipRest() {
  2623                                  
  2624 00001C26 C9                      @@retn: LEAVE
  2625 00001C27 C3                       ret
  2626                                  ; ENDP
  2627 00001C28 2E206E6565643A2000      need_0 db ". need: ",0
  2628                                  
  2629                                  skipRest:  ; *** PROC ***
  2630                                  
  2631                                  ;-124   getTokeType(); 
  2632                                  
  2633 00001C31 E8BAFB                   call getTokeType
  2634                                  
  2635                                  ;-125   if(TokeType)error1("extra char ignored");
  2636                                  
  2637 00001C34 A0[AB01]                 mov al, [TokeType]
  2638 00001C37 08C0                     or  al, al
  2639 00001C39 0F840900                 je @@skipRest111
  2640 00001C3D 68[471C]                 push skipRest_0
  2641 00001C40 E8D909                   call error1
  2642 00001C43 83C402                   add  sp, 2
  2643                                  
  2644                                  ;-126 }
  2645                                  
  2646                                  @@skipRest111:
  2647 00001C46 C3                       ret
  2648                                  ; ENDP
  2649 00001C47 657874726120636861-     skipRest_0 db "extra char ignored",0
  2650 00001C50 722069676E6F726564-
  2651 00001C59 00                 
  2652                                  ;Back to main program: AS.C
  2653                                  
  2654                                  ;-6 #include "HELPER.C"
  2655                                  
  2656                                  ;Use include file: HELPER.C
  2657                                  
  2658                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2659                                  
  2660                                  
  2661                                  getLine:  ; *** PROC ***
  2662                                  
  2663                                  ;-2   unsigned int i;
  2664                                  
  2665                                  
  2666                                  ;-3   InputPtr= &InputBuf;
  2667                                  
  2668                                  ;Function : getLine, Number of local variables: 1
  2669                                  ;   # type sign width line used address name   list of local variables
  2670                                  ;  200 var unsg word     2 NULL bp-2    i;
  2671 00001C5A C8020000                 ENTER  2,0
  2672 00001C5E B8[4F00]                 mov ax, InputBuf
  2673 00001C61 A3[CE00]                 mov word [InputPtr], ax
  2674                                  
  2675                                  ;-4   *InputPtr=0;//if last line is empty
  2676                                  
  2677 00001C64 66B800000000             mov eax, 0
  2678 00001C6A 8B1E[CE00]               mov  bx, [InputPtr]
  2679 00001C6E 8807                     mov  [bx], al
  2680                                  
  2681                                  ;-5   do {
  2682                                  
  2683                                  @@getLine112:
  2684                                  
  2685                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2686                                  
  2687 00001C70 6A01                     push 1
  2688 00001C72 FF36[9901]               push word [asm_fd]
  2689 00001C76 8D06[A501]               lea  ax, [DOS_ByteRead]
  2690 00001C7A 50                       push ax
  2691 00001C7B E82918                   call readRL
  2692 00001C7E 83C406                   add  sp, 6
  2693 00001C81 A3[A301]                 mov word [DOS_NoBytes], ax
  2694                                  
  2695                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2696                                  
  2697 00001C84 A1[9F01]                 mov ax, [DOS_ERR]
  2698 00001C87 08C0                     or  al, al
  2699 00001C89 0F840900                 je @@getLine113
  2700 00001C8D 68[F21C]                 push getLine_0
  2701 00001C90 E8E809                   call errorexit
  2702 00001C93 83C402                   add  sp, 2
  2703                                  
  2704                                  ;-8     if (DOS_NoBytes == 0) return;
  2705                                  
  2706                                  @@getLine113:
  2707 00001C96 A1[A301]                 mov ax, [DOS_NoBytes]
  2708 00001C99 83F800                   cmp ax, 0
  2709 00001C9C 0F850300                 jne @@getLine114
  2710 00001CA0 E94D00                   jmp @@retn
  2711                                  
  2712                                  ;-9     *InputPtr = DOS_ByteRead;
  2713                                  
  2714                                  @@getLine114:
  2715 00001CA3 A0[A501]                 mov al, [DOS_ByteRead]
  2716 00001CA6 8B1E[CE00]               mov  bx, [InputPtr]
  2717 00001CAA 8807                     mov  [bx], al
  2718                                  
  2719                                  ;-10     InputPtr++;
  2720                                  
  2721 00001CAC FF06[CE00]               inc  word [InputPtr]
  2722                                  
  2723                                  ;-11     i = InputPtr - &InputBuf;
  2724                                  
  2725 00001CB0 A1[CE00]                 mov ax, [InputPtr]
  2726 00001CB3 2D[4F00]                 sub ax, InputBuf
  2727 00001CB6 8946FE                   mov word [bp-2], ax
  2728                                  
  2729                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2730                                  
  2731 00001CB9 8B46FE                   mov ax, [bp-2]
  2732 00001CBC 83F87F                   cmp ax, 127 ;unsigned : 0
  2733 00001CBF 0F820900                 jb  @@getLine115
  2734 00001CC3 68[011D]                 push getLine_1
  2735 00001CC6 E8B209                   call errorexit
  2736 00001CC9 83C402                   add  sp, 2
  2737                                  
  2738                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2739                                  
  2740                                  @@getLine115:
  2741 00001CCC A0[A501]                 mov al, byte [DOS_ByteRead]
  2742 00001CCF B400                     mov ah, 0
  2743 00001CD1 50                       push ax
  2744 00001CD2 E84000                   call ifEOL
  2745 00001CD5 83C402                   add  sp, 2
  2746 00001CD8 3C00                     cmp al, 0
  2747 00001CDA 0F850200                 jne @@getLine116
  2748 00001CDE EB90                     jmp @@getLine112
  2749                                  @@getLine116:
  2750                                  
  2751                                  ;-14   InputPtr--;
  2752                                  
  2753 00001CE0 FF0E[CE00]               dec  word [InputPtr]
  2754                                  
  2755                                  ;-15   *InputPtr=0;
  2756                                  
  2757 00001CE4 66B800000000             mov eax, 0
  2758 00001CEA 8B1E[CE00]               mov  bx, [InputPtr]
  2759 00001CEE 8807                     mov  [bx], al
  2760                                  
  2761                                  ;-16 }
  2762                                  
  2763                                  
  2764                                  ;-17 int ifEOL(char c) {
  2765                                  
  2766 00001CF0 C9                      @@retn: LEAVE
  2767 00001CF1 C3                       ret
  2768                                  ; ENDP
  2769 00001CF2 52656164696E672053-     getLine_0 db "Reading Source",0
  2770 00001CFB 6F7572636500       
  2771 00001D01 696E707574206C696E-     getLine_1 db "input line too long",0
  2772 00001D0A 6520746F6F206C6F6E-
  2773 00001D13 6700               
  2774                                  
  2775                                  ifEOL:  ; *** PROC ***
  2776                                  
  2777                                  ;-18   if (c == 10) return 1;
  2778                                  
  2779                                  ;Function : ifEOL, Number of local variables: 1
  2780                                  ;   # type sign width line used address name   list of local variables
  2781                                  ;  200 var sign byte    17 NULL bp+4    c;
  2782 00001D15 C8000000                 ENTER  0,0
  2783 00001D19 8A4604                   mov al, [bp+4]
  2784 00001D1C 3C0A                     cmp al, 10
  2785 00001D1E 0F850900                 jne @@ifEOL117
  2786 00001D22 66B801000000             mov eax, 1
  2787 00001D28 E92F00                   jmp @@retn
  2788                                  
  2789                                  ;-19   if (c == 13) {
  2790                                  
  2791                                  @@ifEOL117:
  2792 00001D2B 8A4604                   mov al, [bp+4]
  2793 00001D2E 3C0D                     cmp al, 13
  2794 00001D30 0F851D00                 jne @@ifEOL118
  2795                                  
  2796                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2797                                  
  2798 00001D34 6A01                     push 1
  2799 00001D36 FF36[9901]               push word [asm_fd]
  2800 00001D3A 8D06[A501]               lea  ax, [DOS_ByteRead]
  2801 00001D3E 50                       push ax
  2802 00001D3F E86517                   call readRL
  2803 00001D42 83C406                   add  sp, 6
  2804 00001D45 A3[A301]                 mov word [DOS_NoBytes], ax
  2805                                  
  2806                                  ;-21     return 1;}
  2807                                  
  2808 00001D48 66B801000000             mov eax, 1
  2809 00001D4E E90900                   jmp @@retn
  2810                                  
  2811                                  ;-22   return 0;
  2812                                  
  2813                                  @@ifEOL118:
  2814 00001D51 66B800000000             mov eax, 0
  2815 00001D57 E90000                   jmp @@retn
  2816                                  
  2817                                  ;-23 }
  2818                                  
  2819                                  
  2820                                  ;-24 int skipBlank() {
  2821                                  
  2822 00001D5A C9                      @@retn: LEAVE
  2823 00001D5B C3                       ret
  2824                                  ; ENDP
  2825                                  
  2826                                  skipBlank:  ; *** PROC ***
  2827                                  
  2828                                  ;-25   skipblank1:
  2829                                  
  2830                                  @@skipblank1:
  2831                                  
  2832                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2833                                  
  2834 00001D5C 8B1E[CE00]               mov bx, [InputPtr]
  2835 00001D60 8A07                     mov al, [bx]
  2836 00001D62 B400                     mov ah, 0
  2837 00001D64 83F820                   cmp ax, 32
  2838 00001D67 0F850600                 jne @@skipBlank119
  2839 00001D6B FF06[CE00]               inc  word [InputPtr]
  2840 00001D6F EBEB                     jmp @@skipblank1
  2841                                  
  2842                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2843                                  
  2844                                  @@skipBlank119:
  2845 00001D71 8B1E[CE00]               mov bx, [InputPtr]
  2846 00001D75 8A07                     mov al, [bx]
  2847 00001D77 B400                     mov ah, 0
  2848 00001D79 83F809                   cmp ax, 9
  2849 00001D7C 0F850600                 jne @@skipBlank120
  2850 00001D80 FF06[CE00]               inc  word [InputPtr]
  2851 00001D84 EBD6                     jmp @@skipblank1
  2852                                  
  2853                                  ;-28 }
  2854                                  
  2855                                  @@skipBlank120:
  2856                                  
  2857                                  ;-29 int letterE(char c) {
  2858                                  
  2859 00001D86 C3                       ret
  2860                                  ; ENDP
  2861                                  
  2862                                  letterE:  ; *** PROC ***
  2863                                  
  2864                                  ;-30   if (c=='_') return 1;
  2865                                  
  2866                                  ;Function : letterE, Number of local variables: 1
  2867                                  ;   # type sign width line used address name   list of local variables
  2868                                  ;  200 var sign byte    29 NULL bp+4    c;
  2869 00001D87 C8000000                 ENTER  0,0
  2870 00001D8B 8A4604                   mov al, [bp+4]
  2871 00001D8E 3C5F                     cmp al, 95
  2872 00001D90 0F850900                 jne @@letterE121
  2873 00001D94 66B801000000             mov eax, 1
  2874 00001D9A E97E00                   jmp @@retn
  2875                                  
  2876                                  ;-31   if (c=='.') return 1;
  2877                                  
  2878                                  @@letterE121:
  2879 00001D9D 8A4604                   mov al, [bp+4]
  2880 00001DA0 3C2E                     cmp al, 46
  2881 00001DA2 0F850900                 jne @@letterE122
  2882 00001DA6 66B801000000             mov eax, 1
  2883 00001DAC E96C00                   jmp @@retn
  2884                                  
  2885                                  ;-32   if (c=='?') return 1;
  2886                                  
  2887                                  @@letterE122:
  2888 00001DAF 8A4604                   mov al, [bp+4]
  2889 00001DB2 3C3F                     cmp al, 63
  2890 00001DB4 0F850900                 jne @@letterE123
  2891 00001DB8 66B801000000             mov eax, 1
  2892 00001DBE E95A00                   jmp @@retn
  2893                                  
  2894                                  ;-33   if (c=='$') return 1;
  2895                                  
  2896                                  @@letterE123:
  2897 00001DC1 8A4604                   mov al, [bp+4]
  2898 00001DC4 3C24                     cmp al, 36
  2899 00001DC6 0F850900                 jne @@letterE124
  2900 00001DCA 66B801000000             mov eax, 1
  2901 00001DD0 E94800                   jmp @@retn
  2902                                  
  2903                                  ;-34   if (c> 'z') return 0;
  2904                                  
  2905                                  @@letterE124:
  2906 00001DD3 8A4604                   mov al, [bp+4]
  2907 00001DD6 3C7A                     cmp al, 122
  2908 00001DD8 0F8E0900                 jle @@letterE125
  2909 00001DDC 66B800000000             mov eax, 0
  2910 00001DE2 E93600                   jmp @@retn
  2911                                  
  2912                                  ;-35   if (c< '@') return 0; // at included
  2913                                  
  2914                                  @@letterE125:
  2915 00001DE5 8A4604                   mov al, [bp+4]
  2916 00001DE8 3C40                     cmp al, 64
  2917 00001DEA 0F8D0900                 jge @@letterE126
  2918 00001DEE 66B800000000             mov eax, 0
  2919 00001DF4 E92400                   jmp @@retn
  2920                                  
  2921                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2922                                  
  2923                                  @@letterE126:
  2924 00001DF7 8A4604                   mov al, [bp+4]
  2925 00001DFA 3C5A                     cmp al, 90
  2926 00001DFC 0F8E1200                 jle @@letterE127
  2927 00001E00 8A4604                   mov al, [bp+4]
  2928 00001E03 3C61                     cmp al, 97
  2929 00001E05 0F8D0900                 jge @@letterE128
  2930 00001E09 66B800000000             mov eax, 0
  2931 00001E0F E90900                   jmp @@retn
  2932                                  @@letterE128:
  2933                                  
  2934                                  ;-37   return 1;
  2935                                  
  2936                                  @@letterE127:
  2937 00001E12 66B801000000             mov eax, 1
  2938 00001E18 E90000                   jmp @@retn
  2939                                  
  2940                                  ;-38 }
  2941                                  
  2942                                  
  2943                                  ;-39 int alnumE(char c) {
  2944                                  
  2945 00001E1B C9                      @@retn: LEAVE
  2946 00001E1C C3                       ret
  2947                                  ; ENDP
  2948                                  
  2949                                  alnumE:  ; *** PROC ***
  2950                                  
  2951                                  ;-40   if (digit(c)) return 1;
  2952                                  
  2953                                  ;Function : alnumE, Number of local variables: 1
  2954                                  ;   # type sign width line used address name   list of local variables
  2955                                  ;  200 var sign byte    39 NULL bp+4    c;
  2956 00001E1D C8000000                 ENTER  0,0
  2957 00001E21 8A4604                   mov al, byte [bp+4]
  2958 00001E24 B400                     mov ah, 0
  2959 00001E26 50                       push ax
  2960 00001E27 E8AF15                   call digit
  2961 00001E2A 83C402                   add  sp, 2
  2962 00001E2D 08C0                     or  al, al
  2963 00001E2F 0F840900                 je @@alnumE129
  2964 00001E33 66B801000000             mov eax, 1
  2965 00001E39 E92400                   jmp @@retn
  2966                                  
  2967                                  ;-41   if (letterE(c)) return 1;
  2968                                  
  2969                                  @@alnumE129:
  2970 00001E3C 8A4604                   mov al, byte [bp+4]
  2971 00001E3F B400                     mov ah, 0
  2972 00001E41 50                       push ax
  2973 00001E42 E842FF                   call letterE
  2974 00001E45 83C402                   add  sp, 2
  2975 00001E48 08C0                     or  al, al
  2976 00001E4A 0F840900                 je @@alnumE130
  2977 00001E4E 66B801000000             mov eax, 1
  2978 00001E54 E90900                   jmp @@retn
  2979                                  
  2980                                  ;-42   return 0;
  2981                                  
  2982                                  @@alnumE130:
  2983 00001E57 66B800000000             mov eax, 0
  2984 00001E5D E90000                   jmp @@retn
  2985                                  
  2986                                  ;-43 }
  2987                                  
  2988                                  
  2989                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2990                                  
  2991 00001E60 C9                      @@retn: LEAVE
  2992 00001E61 C3                       ret
  2993                                  ; ENDP
  2994                                  
  2995                                  getDigit:  ; *** PROC ***
  2996                                  
  2997                                  ;-45   unsigned int CastInt;
  2998                                  
  2999                                  
  3000                                  ;-46   SymbolInt=0;
  3001                                  
  3002                                  ;Function : getDigit, Number of local variables: 2
  3003                                  ;   # type sign width line used address name   list of local variables
  3004                                  ;  200 var unsg byte    44 NULL bp+4    c
  3005                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3006 00001E62 C8020000                 ENTER  2,0
  3007 00001E66 66B800000000             mov eax, 0
  3008 00001E6C A3[4D00]                 mov word [SymbolInt], ax
  3009                                  
  3010                                  ;-47   do {
  3011                                  
  3012                                  @@getDigit131:
  3013                                  
  3014                                  ;-48     c-='0';
  3015                                  
  3016 00001E6F 806E0430                 sub  byte [bp+4], 48
  3017                                  
  3018                                  ;-49     SymbolInt=SymbolInt*10;
  3019                                  
  3020 00001E73 A1[4D00]                 mov ax, [SymbolInt]
  3021 00001E76 66BB0A000000             mov ebx, 10
  3022 00001E7C 66F7E3                   mul ebx
  3023 00001E7F A3[4D00]                 mov word [SymbolInt], ax
  3024                                  
  3025                                  ;-50     ax=0; CastInt=c; //cast b2w
  3026                                  
  3027 00001E82 B80000                   mov  ax, 0
  3028 00001E85 8A4604                   mov al, [bp+4]
  3029 00001E88 8946FE                   mov word [bp-2], ax
  3030                                  
  3031                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3032                                  
  3033 00001E8B A1[4D00]                 mov ax, [SymbolInt]
  3034 00001E8E 0346FE                   add ax, [bp-2]
  3035 00001E91 A3[4D00]                 mov word [SymbolInt], ax
  3036                                  
  3037                                  ;-52     InputPtr++;
  3038                                  
  3039 00001E94 FF06[CE00]               inc  word [InputPtr]
  3040                                  
  3041                                  ;-53     c = *InputPtr;
  3042                                  
  3043 00001E98 8B1E[CE00]               mov bx, [InputPtr]
  3044 00001E9C 8A07                     mov al, [bx]
  3045 00001E9E B400                     mov ah, 0
  3046 00001EA0 884604                   mov byte [bp+4], al
  3047                                  
  3048                                  ;-54   } while(digit(c));
  3049                                  
  3050 00001EA3 8A4604                   mov al, byte [bp+4]
  3051 00001EA6 B400                     mov ah, 0
  3052 00001EA8 50                       push ax
  3053 00001EA9 E82D15                   call digit
  3054 00001EAC 83C402                   add  sp, 2
  3055 00001EAF 08C0                     or  al, al
  3056 00001EB1 0F840200                 je @@getDigit132
  3057 00001EB5 EBB8                     jmp @@getDigit131
  3058                                  @@getDigit132:
  3059                                  
  3060                                  ;-55 }
  3061                                  
  3062                                  
  3063                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3064 00001EB7 C9                       LEAVE
  3065 00001EB8 C3                       ret
  3066                                  ; ENDP
  3067                                  
  3068                                  getName:  ; *** PROC ***
  3069                                  
  3070                                  ;-57   char *p; unsigned int i;
  3071                                  
  3072                                  
  3073                                  ;-58   p = &Symbol;
  3074                                  
  3075                                  ;Function : getName, Number of local variables: 3
  3076                                  ;   # type sign width line used address name   list of local variables
  3077                                  ;  200 var unsg byte    56 NULL bp+4    c
  3078                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3079                                  ;  202 var unsg word    57 NULL bp-4    i;
  3080 00001EB9 C8040000                 ENTER  4,0
  3081 00001EBD B8[0F00]                 mov ax, Symbol
  3082 00001EC0 8946FE                   mov word [bp-2], ax
  3083                                  
  3084                                  ;-59   *p = c;
  3085                                  
  3086 00001EC3 8A4604                   mov al, [bp+4]
  3087 00001EC6 8B5EFE                   mov  bx, [bp-2]
  3088 00001EC9 8807                     mov  [bx], al
  3089                                  
  3090                                  ;-60   p++;
  3091                                  
  3092 00001ECB FF46FE                   inc  word [bp-2]
  3093                                  
  3094                                  ;-61   while (alnumE(c)) {
  3095                                  
  3096                                  @@getName133:
  3097 00001ECE 8A4604                   mov al, byte [bp+4]
  3098 00001ED1 B400                     mov ah, 0
  3099 00001ED3 50                       push ax
  3100 00001ED4 E846FF                   call alnumE
  3101 00001ED7 83C402                   add  sp, 2
  3102 00001EDA 08C0                     or  al, al
  3103 00001EDC 0F843800                 je @@getName134
  3104                                  
  3105                                  ;-62     InputPtr++;
  3106                                  
  3107 00001EE0 FF06[CE00]               inc  word [InputPtr]
  3108                                  
  3109                                  ;-63     c = *InputPtr;
  3110                                  
  3111 00001EE4 8B1E[CE00]               mov bx, [InputPtr]
  3112 00001EE8 8A07                     mov al, [bx]
  3113 00001EEA B400                     mov ah, 0
  3114 00001EEC 884604                   mov byte [bp+4], al
  3115                                  
  3116                                  ;-64     *p = c;
  3117                                  
  3118 00001EEF 8A4604                   mov al, [bp+4]
  3119 00001EF2 8B5EFE                   mov  bx, [bp-2]
  3120 00001EF5 8807                     mov  [bx], al
  3121                                  
  3122                                  ;-65     p++;
  3123                                  
  3124 00001EF7 FF46FE                   inc  word [bp-2]
  3125                                  
  3126                                  ;-66     i = p - &Symbol;
  3127                                  
  3128 00001EFA 8B46FE                   mov ax, [bp-2]
  3129 00001EFD 2D[0F00]                 sub ax, Symbol
  3130 00001F00 8946FC                   mov word [bp-4], ax
  3131                                  
  3132                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3133                                  
  3134 00001F03 8B46FC                   mov ax, [bp-4]
  3135 00001F06 83F81F                   cmp ax, 31 ;unsigned : 0
  3136 00001F09 0F820900                 jb  @@getName135
  3137 00001F0D 68[611F]                 push getName_0
  3138 00001F10 E86807                   call errorexit
  3139 00001F13 83C402                   add  sp, 2
  3140                                  
  3141                                  ;-68   }
  3142                                  
  3143                                  @@getName135:
  3144                                  
  3145                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3146                                  
  3147 00001F16 EBB6                     jmp @@getName133
  3148                                  @@getName134:
  3149 00001F18 8A4604                   mov al, [bp+4]
  3150 00001F1B 3C3A                     cmp al, 58
  3151 00001F1D 0F850C00                 jne @@getName136
  3152 00001F21 66B801000000             mov eax, 1
  3153 00001F27 A2[AA01]                 mov byte [isLabel], al
  3154 00001F2A E90900                   jmp @@getName137
  3155                                  @@getName136:
  3156 00001F2D 66B800000000             mov eax, 0
  3157 00001F33 A2[AA01]                 mov byte [isLabel], al
  3158                                  
  3159                                  ;-70   p--;
  3160                                  
  3161                                  @@getName137:
  3162 00001F36 FF4EFE                   dec  word [bp-2]
  3163                                  
  3164                                  ;-71   *p = 0;
  3165                                  
  3166 00001F39 66B800000000             mov eax, 0
  3167 00001F3F 8B5EFE                   mov  bx, [bp-2]
  3168 00001F42 8807                     mov  [bx], al
  3169                                  
  3170                                  ;-72   strcpy(SymbolUpper, Symbol);
  3171                                  
  3172 00001F44 8D06[0F00]               lea  ax, [Symbol]
  3173 00001F48 50                       push ax
  3174 00001F49 8D06[2E00]               lea  ax, [SymbolUpper]
  3175 00001F4D 50                       push ax
  3176 00001F4E E84F14                   call strcpy
  3177 00001F51 83C404                   add  sp, 4
  3178                                  
  3179                                  ;-73   toupper(SymbolUpper);
  3180                                  
  3181 00001F54 8D06[2E00]               lea  ax, [SymbolUpper]
  3182 00001F58 50                       push ax
  3183 00001F59 E8D613                   call toupper
  3184 00001F5C 83C402                   add  sp, 2
  3185                                  
  3186                                  ;-74 }
  3187                                  
  3188                                  
  3189                                  ;-75 int testReg() {
  3190 00001F5F C9                       LEAVE
  3191 00001F60 C3                       ret
  3192                                  ; ENDP
  3193 00001F61 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3194 00001F6A 6F206C6F6E6700     
  3195                                  
  3196                                  testReg:  ; *** PROC ***
  3197                                  
  3198                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3199                                  
  3200                                  
  3201                                  ;-77   R2Type=0;
  3202                                  
  3203 00001F71 66B800000000             mov eax, 0
  3204 00001F77 A2[B401]                 mov byte [R2Type], al
  3205                                  
  3206                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3207                                  
  3208 00001F7A 8D06[0F00]               lea  ax, [Symbol]
  3209 00001F7E 50                       push ax
  3210 00001F7F E8F313                   call strlen
  3211 00001F82 83C402                   add  sp, 2
  3212 00001F85 3C02                     cmp al, 2
  3213 00001F87 0F8D0900                 jge @@testReg138
  3214 00001F8B 66B800000000             mov eax, 0
  3215 00001F91 E9B603                   jmp @@retn
  3216                                  
  3217                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3218                                  
  3219                                  @@testReg138:
  3220 00001F94 8D06[0F00]               lea  ax, [Symbol]
  3221 00001F98 50                       push ax
  3222 00001F99 E8D913                   call strlen
  3223 00001F9C 83C402                   add  sp, 2
  3224 00001F9F 3C03                     cmp al, 3
  3225 00001FA1 0F8E0900                 jle @@testReg139
  3226 00001FA5 66B800000000             mov eax, 0
  3227 00001FAB E99C03                   jmp @@retn
  3228                                  
  3229                                  ;-80   R2Type=BYTE;
  3230                                  
  3231                                  @@testReg139:
  3232 00001FAE 66B801000000             mov eax, 1
  3233 00001FB4 A2[B401]                 mov byte [R2Type], al
  3234                                  
  3235                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3236                                  
  3237 00001FB7 68[4B23]                 push testReg_0
  3238 00001FBA 8D06[2E00]               lea  ax, [SymbolUpper]
  3239 00001FBE 50                       push ax
  3240 00001FBF E84A14                   call eqstr
  3241 00001FC2 83C404                   add  sp, 4
  3242 00001FC5 08C0                     or  al, al
  3243 00001FC7 0F840900                 je @@testReg140
  3244 00001FCB 66B800000000             mov eax, 0
  3245 00001FD1 E97603                   jmp @@retn
  3246                                  
  3247                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3248                                  
  3249                                  @@testReg140:
  3250 00001FD4 68[4E23]                 push testReg_1
  3251 00001FD7 8D06[2E00]               lea  ax, [SymbolUpper]
  3252 00001FDB 50                       push ax
  3253 00001FDC E82D14                   call eqstr
  3254 00001FDF 83C404                   add  sp, 4
  3255 00001FE2 08C0                     or  al, al
  3256 00001FE4 0F840900                 je @@testReg141
  3257 00001FE8 66B801000000             mov eax, 1
  3258 00001FEE E95903                   jmp @@retn
  3259                                  
  3260                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3261                                  
  3262                                  @@testReg141:
  3263 00001FF1 68[5123]                 push testReg_2
  3264 00001FF4 8D06[2E00]               lea  ax, [SymbolUpper]
  3265 00001FF8 50                       push ax
  3266 00001FF9 E81014                   call eqstr
  3267 00001FFC 83C404                   add  sp, 4
  3268 00001FFF 08C0                     or  al, al
  3269 00002001 0F840900                 je @@testReg142
  3270 00002005 66B802000000             mov eax, 2
  3271 0000200B E93C03                   jmp @@retn
  3272                                  
  3273                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3274                                  
  3275                                  @@testReg142:
  3276 0000200E 68[5423]                 push testReg_3
  3277 00002011 8D06[2E00]               lea  ax, [SymbolUpper]
  3278 00002015 50                       push ax
  3279 00002016 E8F313                   call eqstr
  3280 00002019 83C404                   add  sp, 4
  3281 0000201C 08C0                     or  al, al
  3282 0000201E 0F840900                 je @@testReg143
  3283 00002022 66B803000000             mov eax, 3
  3284 00002028 E91F03                   jmp @@retn
  3285                                  
  3286                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3287                                  
  3288                                  @@testReg143:
  3289 0000202B 68[5723]                 push testReg_4
  3290 0000202E 8D06[2E00]               lea  ax, [SymbolUpper]
  3291 00002032 50                       push ax
  3292 00002033 E8D613                   call eqstr
  3293 00002036 83C404                   add  sp, 4
  3294 00002039 08C0                     or  al, al
  3295 0000203B 0F840900                 je @@testReg144
  3296 0000203F 66B804000000             mov eax, 4
  3297 00002045 E90203                   jmp @@retn
  3298                                  
  3299                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3300                                  
  3301                                  @@testReg144:
  3302 00002048 68[5A23]                 push testReg_5
  3303 0000204B 8D06[2E00]               lea  ax, [SymbolUpper]
  3304 0000204F 50                       push ax
  3305 00002050 E8B913                   call eqstr
  3306 00002053 83C404                   add  sp, 4
  3307 00002056 08C0                     or  al, al
  3308 00002058 0F840900                 je @@testReg145
  3309 0000205C 66B805000000             mov eax, 5
  3310 00002062 E9E502                   jmp @@retn
  3311                                  
  3312                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3313                                  
  3314                                  @@testReg145:
  3315 00002065 68[5D23]                 push testReg_6
  3316 00002068 8D06[2E00]               lea  ax, [SymbolUpper]
  3317 0000206C 50                       push ax
  3318 0000206D E89C13                   call eqstr
  3319 00002070 83C404                   add  sp, 4
  3320 00002073 08C0                     or  al, al
  3321 00002075 0F840900                 je @@testReg146
  3322 00002079 66B806000000             mov eax, 6
  3323 0000207F E9C802                   jmp @@retn
  3324                                  
  3325                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3326                                  
  3327                                  @@testReg146:
  3328 00002082 68[6023]                 push testReg_7
  3329 00002085 8D06[2E00]               lea  ax, [SymbolUpper]
  3330 00002089 50                       push ax
  3331 0000208A E87F13                   call eqstr
  3332 0000208D 83C404                   add  sp, 4
  3333 00002090 08C0                     or  al, al
  3334 00002092 0F840900                 je @@testReg147
  3335 00002096 66B807000000             mov eax, 7
  3336 0000209C E9AB02                   jmp @@retn
  3337                                  
  3338                                  ;-89   R2Type=WORD;
  3339                                  
  3340                                  @@testReg147:
  3341 0000209F 66B802000000             mov eax, 2
  3342 000020A5 A2[B401]                 mov byte [R2Type], al
  3343                                  
  3344                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3345                                  
  3346 000020A8 68[6323]                 push testReg_8
  3347 000020AB 8D06[2E00]               lea  ax, [SymbolUpper]
  3348 000020AF 50                       push ax
  3349 000020B0 E85913                   call eqstr
  3350 000020B3 83C404                   add  sp, 4
  3351 000020B6 08C0                     or  al, al
  3352 000020B8 0F840900                 je @@testReg148
  3353 000020BC 66B800000000             mov eax, 0
  3354 000020C2 E98502                   jmp @@retn
  3355                                  
  3356                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3357                                  
  3358                                  @@testReg148:
  3359 000020C5 68[6623]                 push testReg_9
  3360 000020C8 8D06[2E00]               lea  ax, [SymbolUpper]
  3361 000020CC 50                       push ax
  3362 000020CD E83C13                   call eqstr
  3363 000020D0 83C404                   add  sp, 4
  3364 000020D3 08C0                     or  al, al
  3365 000020D5 0F840900                 je @@testReg149
  3366 000020D9 66B801000000             mov eax, 1
  3367 000020DF E96802                   jmp @@retn
  3368                                  
  3369                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3370                                  
  3371                                  @@testReg149:
  3372 000020E2 68[6923]                 push testReg_10
  3373 000020E5 8D06[2E00]               lea  ax, [SymbolUpper]
  3374 000020E9 50                       push ax
  3375 000020EA E81F13                   call eqstr
  3376 000020ED 83C404                   add  sp, 4
  3377 000020F0 08C0                     or  al, al
  3378 000020F2 0F840900                 je @@testReg150
  3379 000020F6 66B802000000             mov eax, 2
  3380 000020FC E94B02                   jmp @@retn
  3381                                  
  3382                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3383                                  
  3384                                  @@testReg150:
  3385 000020FF 68[6C23]                 push testReg_11
  3386 00002102 8D06[2E00]               lea  ax, [SymbolUpper]
  3387 00002106 50                       push ax
  3388 00002107 E80213                   call eqstr
  3389 0000210A 83C404                   add  sp, 4
  3390 0000210D 08C0                     or  al, al
  3391 0000210F 0F840900                 je @@testReg151
  3392 00002113 66B803000000             mov eax, 3
  3393 00002119 E92E02                   jmp @@retn
  3394                                  
  3395                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3396                                  
  3397                                  @@testReg151:
  3398 0000211C 68[6F23]                 push testReg_12
  3399 0000211F 8D06[2E00]               lea  ax, [SymbolUpper]
  3400 00002123 50                       push ax
  3401 00002124 E8E512                   call eqstr
  3402 00002127 83C404                   add  sp, 4
  3403 0000212A 08C0                     or  al, al
  3404 0000212C 0F840900                 je @@testReg152
  3405 00002130 66B804000000             mov eax, 4
  3406 00002136 E91102                   jmp @@retn
  3407                                  
  3408                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3409                                  
  3410                                  @@testReg152:
  3411 00002139 68[7223]                 push testReg_13
  3412 0000213C 8D06[2E00]               lea  ax, [SymbolUpper]
  3413 00002140 50                       push ax
  3414 00002141 E8C812                   call eqstr
  3415 00002144 83C404                   add  sp, 4
  3416 00002147 08C0                     or  al, al
  3417 00002149 0F840900                 je @@testReg153
  3418 0000214D 66B805000000             mov eax, 5
  3419 00002153 E9F401                   jmp @@retn
  3420                                  
  3421                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3422                                  
  3423                                  @@testReg153:
  3424 00002156 68[7523]                 push testReg_14
  3425 00002159 8D06[2E00]               lea  ax, [SymbolUpper]
  3426 0000215D 50                       push ax
  3427 0000215E E8AB12                   call eqstr
  3428 00002161 83C404                   add  sp, 4
  3429 00002164 08C0                     or  al, al
  3430 00002166 0F840900                 je @@testReg154
  3431 0000216A 66B806000000             mov eax, 6
  3432 00002170 E9D701                   jmp @@retn
  3433                                  
  3434                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3435                                  
  3436                                  @@testReg154:
  3437 00002173 68[7823]                 push testReg_15
  3438 00002176 8D06[2E00]               lea  ax, [SymbolUpper]
  3439 0000217A 50                       push ax
  3440 0000217B E88E12                   call eqstr
  3441 0000217E 83C404                   add  sp, 4
  3442 00002181 08C0                     or  al, al
  3443 00002183 0F840900                 je @@testReg155
  3444 00002187 66B807000000             mov eax, 7
  3445 0000218D E9BA01                   jmp @@retn
  3446                                  
  3447                                  ;-98   R2Type=SEGREG;
  3448                                  
  3449                                  @@testReg155:
  3450 00002190 66B804000000             mov eax, 4
  3451 00002196 A2[B401]                 mov byte [R2Type], al
  3452                                  
  3453                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3454                                  
  3455 00002199 68[7B23]                 push testReg_16
  3456 0000219C 8D06[2E00]               lea  ax, [SymbolUpper]
  3457 000021A0 50                       push ax
  3458 000021A1 E86812                   call eqstr
  3459 000021A4 83C404                   add  sp, 4
  3460 000021A7 08C0                     or  al, al
  3461 000021A9 0F840900                 je @@testReg156
  3462 000021AD 66B800000000             mov eax, 0
  3463 000021B3 E99401                   jmp @@retn
  3464                                  
  3465                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3466                                  
  3467                                  @@testReg156:
  3468 000021B6 68[7E23]                 push testReg_17
  3469 000021B9 8D06[2E00]               lea  ax, [SymbolUpper]
  3470 000021BD 50                       push ax
  3471 000021BE E84B12                   call eqstr
  3472 000021C1 83C404                   add  sp, 4
  3473 000021C4 08C0                     or  al, al
  3474 000021C6 0F840900                 je @@testReg157
  3475 000021CA 66B801000000             mov eax, 1
  3476 000021D0 E97701                   jmp @@retn
  3477                                  
  3478                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3479                                  
  3480                                  @@testReg157:
  3481 000021D3 68[8123]                 push testReg_18
  3482 000021D6 8D06[2E00]               lea  ax, [SymbolUpper]
  3483 000021DA 50                       push ax
  3484 000021DB E82E12                   call eqstr
  3485 000021DE 83C404                   add  sp, 4
  3486 000021E1 08C0                     or  al, al
  3487 000021E3 0F840900                 je @@testReg158
  3488 000021E7 66B802000000             mov eax, 2
  3489 000021ED E95A01                   jmp @@retn
  3490                                  
  3491                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3492                                  
  3493                                  @@testReg158:
  3494 000021F0 68[8423]                 push testReg_19
  3495 000021F3 8D06[2E00]               lea  ax, [SymbolUpper]
  3496 000021F7 50                       push ax
  3497 000021F8 E81112                   call eqstr
  3498 000021FB 83C404                   add  sp, 4
  3499 000021FE 08C0                     or  al, al
  3500 00002200 0F840900                 je @@testReg159
  3501 00002204 66B803000000             mov eax, 3
  3502 0000220A E93D01                   jmp @@retn
  3503                                  
  3504                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3505                                  
  3506                                  @@testReg159:
  3507 0000220D 68[8723]                 push testReg_20
  3508 00002210 8D06[2E00]               lea  ax, [SymbolUpper]
  3509 00002214 50                       push ax
  3510 00002215 E8F411                   call eqstr
  3511 00002218 83C404                   add  sp, 4
  3512 0000221B 08C0                     or  al, al
  3513 0000221D 0F840900                 je @@testReg160
  3514 00002221 66B804000000             mov eax, 4
  3515 00002227 E92001                   jmp @@retn
  3516                                  
  3517                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3518                                  
  3519                                  @@testReg160:
  3520 0000222A 68[8A23]                 push testReg_21
  3521 0000222D 8D06[2E00]               lea  ax, [SymbolUpper]
  3522 00002231 50                       push ax
  3523 00002232 E8D711                   call eqstr
  3524 00002235 83C404                   add  sp, 4
  3525 00002238 08C0                     or  al, al
  3526 0000223A 0F840900                 je @@testReg161
  3527 0000223E 66B805000000             mov eax, 5
  3528 00002244 E90301                   jmp @@retn
  3529                                  
  3530                                  ;-105   R2Type=DWORD;                         
  3531                                  
  3532                                  @@testReg161:
  3533 00002247 66B803000000             mov eax, 3
  3534 0000224D A2[B401]                 mov byte [R2Type], al
  3535                                  
  3536                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3537                                  
  3538 00002250 68[8D23]                 push testReg_22
  3539 00002253 8D06[2E00]               lea  ax, [SymbolUpper]
  3540 00002257 50                       push ax
  3541 00002258 E8B111                   call eqstr
  3542 0000225B 83C404                   add  sp, 4
  3543 0000225E 08C0                     or  al, al
  3544 00002260 0F840900                 je @@testReg162
  3545 00002264 66B800000000             mov eax, 0
  3546 0000226A E9DD00                   jmp @@retn
  3547                                  
  3548                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3549                                  
  3550                                  @@testReg162:
  3551 0000226D 68[9123]                 push testReg_23
  3552 00002270 8D06[2E00]               lea  ax, [SymbolUpper]
  3553 00002274 50                       push ax
  3554 00002275 E89411                   call eqstr
  3555 00002278 83C404                   add  sp, 4
  3556 0000227B 08C0                     or  al, al
  3557 0000227D 0F840900                 je @@testReg163
  3558 00002281 66B801000000             mov eax, 1
  3559 00002287 E9C000                   jmp @@retn
  3560                                  
  3561                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3562                                  
  3563                                  @@testReg163:
  3564 0000228A 68[9523]                 push testReg_24
  3565 0000228D 8D06[2E00]               lea  ax, [SymbolUpper]
  3566 00002291 50                       push ax
  3567 00002292 E87711                   call eqstr
  3568 00002295 83C404                   add  sp, 4
  3569 00002298 08C0                     or  al, al
  3570 0000229A 0F840900                 je @@testReg164
  3571 0000229E 66B802000000             mov eax, 2
  3572 000022A4 E9A300                   jmp @@retn
  3573                                  
  3574                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3575                                  
  3576                                  @@testReg164:
  3577 000022A7 68[9923]                 push testReg_25
  3578 000022AA 8D06[2E00]               lea  ax, [SymbolUpper]
  3579 000022AE 50                       push ax
  3580 000022AF E85A11                   call eqstr
  3581 000022B2 83C404                   add  sp, 4
  3582 000022B5 08C0                     or  al, al
  3583 000022B7 0F840900                 je @@testReg165
  3584 000022BB 66B803000000             mov eax, 3
  3585 000022C1 E98600                   jmp @@retn
  3586                                  
  3587                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3588                                  
  3589                                  @@testReg165:
  3590 000022C4 68[9D23]                 push testReg_26
  3591 000022C7 8D06[2E00]               lea  ax, [SymbolUpper]
  3592 000022CB 50                       push ax
  3593 000022CC E83D11                   call eqstr
  3594 000022CF 83C404                   add  sp, 4
  3595 000022D2 08C0                     or  al, al
  3596 000022D4 0F840900                 je @@testReg166
  3597 000022D8 66B804000000             mov eax, 4
  3598 000022DE E96900                   jmp @@retn
  3599                                  
  3600                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3601                                  
  3602                                  @@testReg166:
  3603 000022E1 68[A123]                 push testReg_27
  3604 000022E4 8D06[2E00]               lea  ax, [SymbolUpper]
  3605 000022E8 50                       push ax
  3606 000022E9 E82011                   call eqstr
  3607 000022EC 83C404                   add  sp, 4
  3608 000022EF 08C0                     or  al, al
  3609 000022F1 0F840900                 je @@testReg167
  3610 000022F5 66B805000000             mov eax, 5
  3611 000022FB E94C00                   jmp @@retn
  3612                                  
  3613                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3614                                  
  3615                                  @@testReg167:
  3616 000022FE 68[A523]                 push testReg_28
  3617 00002301 8D06[2E00]               lea  ax, [SymbolUpper]
  3618 00002305 50                       push ax
  3619 00002306 E80311                   call eqstr
  3620 00002309 83C404                   add  sp, 4
  3621 0000230C 08C0                     or  al, al
  3622 0000230E 0F840900                 je @@testReg168
  3623 00002312 66B806000000             mov eax, 6
  3624 00002318 E92F00                   jmp @@retn
  3625                                  
  3626                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3627                                  
  3628                                  @@testReg168:
  3629 0000231B 68[A923]                 push testReg_29
  3630 0000231E 8D06[2E00]               lea  ax, [SymbolUpper]
  3631 00002322 50                       push ax
  3632 00002323 E8E610                   call eqstr
  3633 00002326 83C404                   add  sp, 4
  3634 00002329 08C0                     or  al, al
  3635 0000232B 0F840900                 je @@testReg169
  3636 0000232F 66B807000000             mov eax, 7
  3637 00002335 E91200                   jmp @@retn
  3638                                  
  3639                                  ;-114   R2Type=0; return 0;
  3640                                  
  3641                                  @@testReg169:
  3642 00002338 66B800000000             mov eax, 0
  3643 0000233E A2[B401]                 mov byte [R2Type], al
  3644 00002341 66B800000000             mov eax, 0
  3645 00002347 E90000                   jmp @@retn
  3646                                  
  3647                                  ;-115 }
  3648                                  
  3649                                  @@retn:
  3650 0000234A C3                       ret
  3651                                  ; ENDP
  3652 0000234B 414C00                  testReg_0 db "AL",0
  3653 0000234E 434C00                  testReg_1 db "CL",0
  3654 00002351 444C00                  testReg_2 db "DL",0
  3655 00002354 424C00                  testReg_3 db "BL",0
  3656 00002357 414800                  testReg_4 db "AH",0
  3657 0000235A 434800                  testReg_5 db "CH",0
  3658 0000235D 444800                  testReg_6 db "DH",0
  3659 00002360 424800                  testReg_7 db "BH",0
  3660 00002363 415800                  testReg_8 db "AX",0
  3661 00002366 435800                  testReg_9 db "CX",0
  3662 00002369 445800                  testReg_10 db "DX",0
  3663 0000236C 425800                  testReg_11 db "BX",0
  3664 0000236F 535000                  testReg_12 db "SP",0
  3665 00002372 425000                  testReg_13 db "BP",0
  3666 00002375 534900                  testReg_14 db "SI",0
  3667 00002378 444900                  testReg_15 db "DI",0
  3668 0000237B 455300                  testReg_16 db "ES",0
  3669 0000237E 435300                  testReg_17 db "CS",0
  3670 00002381 535300                  testReg_18 db "SS",0
  3671 00002384 445300                  testReg_19 db "DS",0
  3672 00002387 465300                  testReg_20 db "FS",0
  3673 0000238A 475300                  testReg_21 db "GS",0
  3674 0000238D 45415800                testReg_22 db "EAX",0
  3675 00002391 45435800                testReg_23 db "ECX",0
  3676 00002395 45445800                testReg_24 db "EDX",0
  3677 00002399 45425800                testReg_25 db "EBX",0
  3678 0000239D 45535000                testReg_26 db "ESP",0
  3679 000023A1 45425000                testReg_27 db "EBP",0
  3680 000023A5 45534900                testReg_28 db "ESI",0
  3681 000023A9 45444900                testReg_29 db "EDI",0
  3682                                  ;Back to main program: AS.C
  3683                                  
  3684                                  ;-7 #include "OUTPUT.C"
  3685                                  
  3686                                  ;Use include file: OUTPUT.C
  3687                                  
  3688                                  ;-1 int printLine() { 
  3689                                  
  3690                                  
  3691                                  printLine:  ; *** PROC ***
  3692                                  
  3693                                  ;-2     int i; char c;
  3694                                  
  3695                                  
  3696                                  ;-3     prs("\n"); 
  3697                                  
  3698                                  ;Function : printLine, Number of local variables: 2
  3699                                  ;   # type sign width line used address name   list of local variables
  3700                                  ;  200 var sign word     2 NULL bp-2    i
  3701                                  ;  201 var sign byte     2 NULL bp-4    c;
  3702 000023AD C8040000                 ENTER  4,0
  3703 000023B1 68[4224]                 push printLine_0
  3704 000023B4 E80401                   call prs
  3705 000023B7 83C402                   add  sp, 2
  3706                                  
  3707                                  ;-4     printhex16(PCStart);
  3708                                  
  3709 000023BA FF36[A801]               push word [PCStart]
  3710 000023BE E8EF01                   call printhex16
  3711 000023C1 83C402                   add  sp, 2
  3712                                  
  3713                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3714                                  
  3715 000023C4 A1[C501]                 mov ax, [OpPrintIndex]
  3716 000023C7 83F800                   cmp ax, 0
  3717 000023CA 0F850C00                 jne @@printLine170
  3718 000023CE 68[4524]                 push printLine_1
  3719 000023D1 E8E700                   call prs
  3720 000023D4 83C402                   add  sp, 2
  3721                                  
  3722                                  ;-6     else {
  3723                                  
  3724 000023D7 E95B00                   jmp @@printLine171
  3725                                  @@printLine170:
  3726                                  
  3727                                  ;-7         prc(PrintR);
  3728                                  
  3729 000023DA A0[C901]                 mov al, byte [PrintR]
  3730 000023DD B400                     mov ah, 0
  3731 000023DF 50                       push ax
  3732 000023E0 E87700                   call prc
  3733 000023E3 83C402                   add  sp, 2
  3734                                  
  3735                                  ;-8         i=0;
  3736                                  
  3737 000023E6 66B800000000             mov eax, 0
  3738 000023EC 8946FE                   mov word [bp-2], ax
  3739                                  
  3740                                  ;-9         do {
  3741                                  
  3742                                  @@printLine172:
  3743                                  
  3744                                  ;-10             c=OpPos[i];
  3745                                  
  3746 000023EF 8B5EFE                   mov bx, [bp-2]
  3747 000023F2 8A87[C001]               mov al, [OpPos + bx]
  3748 000023F6 8846FC                   mov byte [bp-4], al
  3749                                  
  3750                                  ;-11             printhex8a(c); 
  3751                                  
  3752 000023F9 8A46FC                   mov al, byte [bp-4]
  3753 000023FC B400                     mov ah, 0
  3754 000023FE 50                       push ax
  3755 000023FF E85C01                   call printhex8a
  3756 00002402 83C402                   add  sp, 2
  3757                                  
  3758                                  ;-12             prc(' ');
  3759                                  
  3760 00002405 6A20                     push 32
  3761 00002407 E85000                   call prc
  3762 0000240A 83C402                   add  sp, 2
  3763                                  
  3764                                  ;-13             i++;
  3765                                  
  3766 0000240D FF46FE                   inc  word [bp-2]
  3767                                  
  3768                                  ;-14         } while (i < OpPrintIndex);
  3769                                  
  3770 00002410 8B46FE                   mov ax, [bp-2]
  3771 00002413 3B06[C501]               cmp ax, [OpPrintIndex]
  3772 00002417 0F8D0200                 jge @@printLine173
  3773 0000241B EBD2                     jmp @@printLine172
  3774                                  @@printLine173:
  3775                                  
  3776                                  ;-15         do {// fill rest with blank
  3777                                  
  3778                                  @@printLine174:
  3779                                  
  3780                                  ;-16             prs("   ");
  3781                                  
  3782 0000241D 68[5624]                 push printLine_2
  3783 00002420 E89800                   call prs
  3784 00002423 83C402                   add  sp, 2
  3785                                  
  3786                                  ;-17             i++;
  3787                                  
  3788 00002426 FF46FE                   inc  word [bp-2]
  3789                                  
  3790                                  ;-18         } while (i < OPMAXLEN);
  3791                                  
  3792 00002429 8B46FE                   mov ax, [bp-2]
  3793 0000242C 83F805                   cmp ax, 5
  3794 0000242F 0F8D0200                 jge @@printLine175
  3795 00002433 EBE8                     jmp @@printLine174
  3796                                  @@printLine175:
  3797                                  
  3798                                  ;-19     }
  3799                                  
  3800                                  
  3801                                  ;-20     prscomment(InputBuf);
  3802                                  
  3803                                  @@printLine171:
  3804 00002435 8D06[4F00]               lea  ax, [InputBuf]
  3805 00002439 50                       push ax
  3806 0000243A E85000                   call prscomment
  3807 0000243D 83C402                   add  sp, 2
  3808                                  
  3809                                  ;-21 }
  3810                                  
  3811                                  
  3812                                  ;-22 int prc(unsigned char c) {//print char 
  3813 00002440 C9                       LEAVE
  3814 00002441 C3                       ret
  3815                                  ; ENDP
  3816 00002442 5C6E00                  printLine_0 db "\n",0
  3817 00002445 202020202020202020-     printLine_1 db "                ",0
  3818 0000244E 2020202020202000   
  3819 00002456 20202000                printLine_2 db "   ",0
  3820                                  
  3821                                  prc:  ; *** PROC ***
  3822                                  
  3823                                  ;-23     if (LIST) { 
  3824                                  
  3825                                  ;Function : prc, Number of local variables: 1
  3826                                  ;   # type sign width line used address name   list of local variables
  3827                                  ;  200 var unsg byte    22 NULL bp+4    c;
  3828 0000245A C8000000                 ENTER  0,0
  3829 0000245E A0[0E00]                 mov al, [LIST]
  3830 00002461 08C0                     or  al, al
  3831 00002463 0F841400                 je @@prc176
  3832                                  
  3833                                  ;-24         if ( _ c==10) {
  3834                                  
  3835 00002467 807E040A                cmp byte [bp+4], 10
  3836 0000246B 0F850600                 jne @@prc177
  3837                                  
  3838                                  ;-25             ax=13; 
  3839                                  
  3840 0000246F B80D00                   mov  ax, 13
  3841                                  
  3842                                  ;-26             writetty(); 
  3843                                  
  3844 00002472 E8870E                   call writetty
  3845                                  
  3846                                  ;-27             }
  3847                                  
  3848                                  
  3849                                  ;-28         al=c; 
  3850                                  
  3851                                  @@prc177:
  3852 00002475 8A4604                   mov  al, [bp+4]
  3853                                  
  3854                                  ;-29         writetty(); 
  3855                                  
  3856 00002478 E8810E                   call writetty
  3857                                  
  3858                                  ;-30         }
  3859                                  
  3860                                  
  3861                                  ;-31     fputcR(c,lst_fd); 
  3862                                  
  3863                                  @@prc176:
  3864 0000247B FF36[9B01]               push word [lst_fd]
  3865 0000247F 8A4604                   mov al, byte [bp+4]
  3866 00002482 B400                     mov ah, 0
  3867 00002484 50                       push ax
  3868 00002485 E83410                   call fputcR
  3869 00002488 83C404                   add  sp, 4
  3870                                  
  3871                                  ;-32 }
  3872                                  
  3873                                  
  3874                                  ;-33 
  3875                                  
  3876                                  
  3877                                  ;-34 int prscomment(unsigned char *s) {
  3878 0000248B C9                       LEAVE
  3879 0000248C C3                       ret
  3880                                  ; ENDP
  3881                                  
  3882                                  prscomment:  ; *** PROC ***
  3883                                  
  3884                                  ;-35     unsigned char c;
  3885                                  
  3886                                  
  3887                                  ;-36     while (*s){
  3888                                  
  3889                                  ;Function : prscomment, Number of local variables: 2
  3890                                  ;   # type sign width line used address name   list of local variables
  3891                                  ;  200 ptr unsg byte    34 NULL bp+4    s
  3892                                  ;  201 var unsg byte    35 NULL bp-2    c;
  3893 0000248D C8020000                 ENTER  2,0
  3894                                  @@prscomment178:
  3895 00002491 8B5E04                   mov bx, [bp+4]
  3896 00002494 8A07                     mov al, [bx]
  3897 00002496 B400                     mov ah, 0
  3898 00002498 08C0                     or  al, al
  3899 0000249A 0F841B00                 je @@prscomment179
  3900                                  
  3901                                  ;-37         c=*s;
  3902                                  
  3903 0000249E 8B5E04                   mov bx, [bp+4]
  3904 000024A1 8A07                     mov al, [bx]
  3905 000024A3 B400                     mov ah, 0
  3906 000024A5 8846FE                   mov byte [bp-2], al
  3907                                  
  3908                                  ;-38         prc(c);
  3909                                  
  3910 000024A8 8A46FE                   mov al, byte [bp-2]
  3911 000024AB B400                     mov ah, 0
  3912 000024AD 50                       push ax
  3913 000024AE E8A9FF                   call prc
  3914 000024B1 83C402                   add  sp, 2
  3915                                  
  3916                                  ;-39         s++;
  3917                                  
  3918 000024B4 FF4604                   inc  word [bp+4]
  3919                                  
  3920                                  ;-40     }
  3921                                  
  3922                                  
  3923                                  ;-41 }
  3924                                  
  3925 000024B7 EBD8                     jmp @@prscomment178
  3926                                  @@prscomment179:
  3927                                  
  3928                                  ;-42 int prs(unsigned char *s) {
  3929 000024B9 C9                       LEAVE
  3930 000024BA C3                       ret
  3931                                  ; ENDP
  3932                                  
  3933                                  prs:  ; *** PROC ***
  3934                                  
  3935                                  ;-43     unsigned char c; 
  3936                                  
  3937                                  
  3938                                  ;-44     int com; 
  3939                                  
  3940                                  
  3941                                  ;-45     com=0;
  3942                                  
  3943                                  ;Function : prs, Number of local variables: 3
  3944                                  ;   # type sign width line used address name   list of local variables
  3945                                  ;  200 ptr unsg byte    42 NULL bp+4    s
  3946                                  ;  201 var unsg byte    43 NULL bp-2    c
  3947                                  ;  202 var sign word    44 NULL bp-4    com;
  3948 000024BB C8040000                 ENTER  4,0
  3949 000024BF 66B800000000             mov eax, 0
  3950 000024C5 8946FC                   mov word [bp-4], ax
  3951                                  
  3952                                  ;-46     while (*s) { 
  3953                                  
  3954                                  @@prs180:
  3955 000024C8 8B5E04                   mov bx, [bp+4]
  3956 000024CB 8A07                     mov al, [bx]
  3957 000024CD B400                     mov ah, 0
  3958 000024CF 08C0                     or  al, al
  3959 000024D1 0F848700                 je @@prs181
  3960                                  
  3961                                  ;-47         c=*s; 
  3962                                  
  3963 000024D5 8B5E04                   mov bx, [bp+4]
  3964 000024D8 8A07                     mov al, [bx]
  3965 000024DA B400                     mov ah, 0
  3966 000024DC 8846FE                   mov byte [bp-2], al
  3967                                  
  3968                                  ;-48         if (c==34) {
  3969                                  
  3970 000024DF 8A46FE                   mov al, [bp-2]
  3971 000024E2 3C22                     cmp al, 34
  3972 000024E4 0F851E00                 jne @@prs182
  3973                                  
  3974                                  ;-49             if (com) com=0; 
  3975                                  
  3976 000024E8 8B46FC                   mov ax, [bp-4]
  3977 000024EB 08C0                     or  al, al
  3978 000024ED 0F840C00                 je @@prs183
  3979 000024F1 66B800000000             mov eax, 0
  3980 000024F7 8946FC                   mov word [bp-4], ax
  3981                                  
  3982                                  ;-50                 else com=1;  
  3983                                  
  3984 000024FA E90900                   jmp @@prs184
  3985                                  @@prs183:
  3986 000024FD 66B801000000             mov eax, 1
  3987 00002503 8946FC                   mov word [bp-4], ax
  3988                                  
  3989                                  ;-51         }
  3990                                  
  3991                                  @@prs184:
  3992                                  
  3993                                  ;-52         if (c==92) { 
  3994                                  
  3995                                  @@prs182:
  3996 00002506 8A46FE                   mov al, [bp-2]
  3997 00002509 3C5C                     cmp al, 92
  3998 0000250B 0F853B00                 jne @@prs185
  3999                                  
  4000                                  ;-53             if (com==0) { 
  4001                                  
  4002 0000250F 8B46FC                   mov ax, [bp-4]
  4003 00002512 83F800                   cmp ax, 0
  4004 00002515 0F853100                 jne @@prs186
  4005                                  
  4006                                  ;-54                 s++; 
  4007                                  
  4008 00002519 FF4604                   inc  word [bp+4]
  4009                                  
  4010                                  ;-55                 c=*s;
  4011                                  
  4012 0000251C 8B5E04                   mov bx, [bp+4]
  4013 0000251F 8A07                     mov al, [bx]
  4014 00002521 B400                     mov ah, 0
  4015 00002523 8846FE                   mov byte [bp-2], al
  4016                                  
  4017                                  ;-56                 if (c=='n') c=10; 
  4018                                  
  4019 00002526 8A46FE                   mov al, [bp-2]
  4020 00002529 3C6E                     cmp al, 110
  4021 0000252B 0F850900                 jne @@prs187
  4022 0000252F 66B80A000000             mov eax, 10
  4023 00002535 8846FE                   mov byte [bp-2], al
  4024                                  
  4025                                  ;-57                 if (c=='t') c= 9; 
  4026                                  
  4027                                  @@prs187:
  4028 00002538 8A46FE                   mov al, [bp-2]
  4029 0000253B 3C74                     cmp al, 116
  4030 0000253D 0F850900                 jne @@prs188
  4031 00002541 66B809000000             mov eax, 9
  4032 00002547 8846FE                   mov byte [bp-2], al
  4033                                  
  4034                                  ;-58             } 
  4035                                  
  4036                                  @@prs188:
  4037                                  
  4038                                  ;-59         } 
  4039                                  
  4040                                  @@prs186:
  4041                                  
  4042                                  ;-60         prc(c); 
  4043                                  
  4044                                  @@prs185:
  4045 0000254A 8A46FE                   mov al, byte [bp-2]
  4046 0000254D B400                     mov ah, 0
  4047 0000254F 50                       push ax
  4048 00002550 E807FF                   call prc
  4049 00002553 83C402                   add  sp, 2
  4050                                  
  4051                                  ;-61         s++;  
  4052                                  
  4053 00002556 FF4604                   inc  word [bp+4]
  4054                                  
  4055                                  ;-62     }
  4056                                  
  4057                                  
  4058                                  ;-63 }
  4059                                  
  4060 00002559 E96CFF                   jmp @@prs180
  4061                                  @@prs181:
  4062                                  
  4063                                  ;-64 int printhex8a(unsigned char c) { 
  4064 0000255C C9                       LEAVE
  4065 0000255D C3                       ret
  4066                                  ; ENDP
  4067                                  
  4068                                  printhex8a:  ; *** PROC ***
  4069                                  
  4070                                  ;-65     unsigned char nib;
  4071                                  
  4072                                  
  4073                                  ;-66     nib = c >> 4; printhex4(nib);                    
  4074                                  
  4075                                  ;Function : printhex8a, Number of local variables: 2
  4076                                  ;   # type sign width line used address name   list of local variables
  4077                                  ;  200 var unsg byte    64 NULL bp+4    c
  4078                                  ;  201 var unsg byte    65 NULL bp-2    nib;
  4079 0000255E C8020000                 ENTER  2,0
  4080 00002562 8A4604                   mov al, [bp+4]
  4081 00002565 C0E804                   shr al, 4
  4082 00002568 8846FE                   mov byte [bp-2], al
  4083 0000256B 8A46FE                   mov al, byte [bp-2]
  4084 0000256E B400                     mov ah, 0
  4085 00002570 50                       push ax
  4086 00002571 E81900                   call printhex4
  4087 00002574 83C402                   add  sp, 2
  4088                                  
  4089                                  ;-67     nib = c & 15; printhex4(nib);                    
  4090                                  
  4091 00002577 8A4604                   mov al, [bp+4]
  4092 0000257A 240F                     and al, 15
  4093 0000257C 8846FE                   mov byte [bp-2], al
  4094 0000257F 8A46FE                   mov al, byte [bp-2]
  4095 00002582 B400                     mov ah, 0
  4096 00002584 50                       push ax
  4097 00002585 E80500                   call printhex4
  4098 00002588 83C402                   add  sp, 2
  4099                                  
  4100                                  ;-68 } 
  4101                                  
  4102                                  
  4103                                  ;-69 int printhex4(unsigned char c) {
  4104 0000258B C9                       LEAVE
  4105 0000258C C3                       ret
  4106                                  ; ENDP
  4107                                  
  4108                                  printhex4:  ; *** PROC ***
  4109                                  
  4110                                  ;-70     c += 48; 
  4111                                  
  4112                                  ;Function : printhex4, Number of local variables: 1
  4113                                  ;   # type sign width line used address name   list of local variables
  4114                                  ;  200 var unsg byte    69 NULL bp+4    c;
  4115 0000258D C8000000                 ENTER  0,0
  4116 00002591 80460430                 add  byte [bp+4], 48
  4117                                  
  4118                                  ;-71     if (c > 57) c += 7; 
  4119                                  
  4120 00002595 8A4604                   mov al, [bp+4]
  4121 00002598 3C39                     cmp al, 57
  4122 0000259A 0F8E0400                 jle @@printhex4189
  4123 0000259E 80460407                 add  byte [bp+4], 7
  4124                                  
  4125                                  ;-72     prc(c);      
  4126                                  
  4127                                  @@printhex4189:
  4128 000025A2 8A4604                   mov al, byte [bp+4]
  4129 000025A5 B400                     mov ah, 0
  4130 000025A7 50                       push ax
  4131 000025A8 E8AFFE                   call prc
  4132 000025AB 83C402                   add  sp, 2
  4133                                  
  4134                                  ;-73 }
  4135                                  
  4136                                  
  4137                                  ;-74 int printhex16(unsigned int i) {
  4138 000025AE C9                       LEAVE
  4139 000025AF C3                       ret
  4140                                  ; ENDP
  4141                                  
  4142                                  printhex16:  ; *** PROC ***
  4143                                  
  4144                                  ;-75     unsigned int half;
  4145                                  
  4146                                  
  4147                                  ;-76     half = i >>  8; printhex8a(half); 
  4148                                  
  4149                                  ;Function : printhex16, Number of local variables: 2
  4150                                  ;   # type sign width line used address name   list of local variables
  4151                                  ;  200 var unsg word    74 NULL bp+4    i
  4152                                  ;  201 var unsg word    75 NULL bp-2    half;
  4153 000025B0 C8020000                 ENTER  2,0
  4154 000025B4 8B4604                   mov ax, [bp+4]
  4155 000025B7 C1E808                   shr ax, 8
  4156 000025BA 8946FE                   mov word [bp-2], ax
  4157 000025BD FF76FE                   push word [bp-2]
  4158 000025C0 E89BFF                   call printhex8a
  4159 000025C3 83C402                   add  sp, 2
  4160                                  
  4161                                  ;-77     half = i & 255; printhex8a(half);
  4162                                  
  4163 000025C6 8B4604                   mov ax, [bp+4]
  4164 000025C9 25FF00                   and ax, 255
  4165 000025CC 8946FE                   mov word [bp-2], ax
  4166 000025CF FF76FE                   push word [bp-2]
  4167 000025D2 E889FF                   call printhex8a
  4168 000025D5 83C402                   add  sp, 2
  4169                                  
  4170                                  ;-78 }
  4171                                  
  4172                                  
  4173                                  ;-79 int printIntU(unsigned int n) { 
  4174 000025D8 C9                       LEAVE
  4175 000025D9 C3                       ret
  4176                                  ; ENDP
  4177                                  
  4178                                  printIntU:  ; *** PROC ***
  4179                                  
  4180                                  ;-80     unsigned int e;
  4181                                  
  4182                                  
  4183                                  ;-81     if ( _ n >= 10) {  
  4184                                  
  4185                                  ;Function : printIntU, Number of local variables: 2
  4186                                  ;   # type sign width line used address name   list of local variables
  4187                                  ;  200 var unsg word    79 NULL bp+4    n
  4188                                  ;  201 var unsg word    80 NULL bp-2    e;
  4189 000025DA C8020000                 ENTER  2,0
  4190 000025DE 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4191 000025E2 0F821700                 jb  @@printIntU190
  4192                                  
  4193                                  ;-82         e=n/10; //DIV
  4194                                  
  4195 000025E6 8B4604                   mov ax, [bp+4]
  4196 000025E9 BB0A00                   mov bx, 10
  4197 000025EC BA0000                   mov dx, 0
  4198 000025EF F7F3                     div bx
  4199 000025F1 8946FE                   mov word [bp-2], ax
  4200                                  
  4201                                  ;-83         printIntU(e); 
  4202                                  
  4203 000025F4 FF76FE                   push word [bp-2]
  4204 000025F7 E8E0FF                   call printIntU
  4205 000025FA 83C402                   add  sp, 2
  4206                                  
  4207                                  ;-84     }
  4208                                  
  4209                                  
  4210                                  ;-85     n = n % 10; //unsigned mod
  4211                                  
  4212                                  @@printIntU190:
  4213 000025FD 8B4604                   mov ax, [bp+4]
  4214 00002600 BB0A00                   mov bx, 10
  4215 00002603 BA0000                   mov dx, 0
  4216 00002606 F7F3                     div bx
  4217 00002608 89D0                     mov ax, dx
  4218 0000260A 894604                   mov word [bp+4], ax
  4219                                  
  4220                                  ;-86     n += '0'; 
  4221                                  
  4222 0000260D 83460430                 add  word [bp+4], 48
  4223                                  
  4224                                  ;-87     prc(n);
  4225                                  
  4226 00002611 FF7604                   push word [bp+4]
  4227 00002614 E843FE                   call prc
  4228 00002617 83C402                   add  sp, 2
  4229                                  
  4230                                  ;-88 }
  4231                                  
  4232                                  
  4233                                  ;-89 
  4234                                  
  4235                                  
  4236                                  ;-90 int error1(char *s) { 
  4237 0000261A C9                       LEAVE
  4238 0000261B C3                       ret
  4239                                  ; ENDP
  4240                                  
  4241                                  error1:  ; *** PROC ***
  4242                                  
  4243                                  ;-91     LIST=1; 
  4244                                  
  4245                                  ;Function : error1, Number of local variables: 1
  4246                                  ;   # type sign width line used address name   list of local variables
  4247                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  4248 0000261C C8000000                 ENTER  0,0
  4249 00002620 66B801000000             mov eax, 1
  4250 00002626 A2[0E00]                 mov byte [LIST], al
  4251                                  
  4252                                  ;-92     ErrorCount++;
  4253                                  
  4254 00002629 FF06[A101]               inc  word [ErrorCount]
  4255                                  
  4256                                  ;-93     prs("\n;***** next line ERROR: "); 
  4257                                  
  4258 0000262D 68[5526]                 push error1_0
  4259 00002630 E888FE                   call prs
  4260 00002633 83C402                   add  sp, 2
  4261                                  
  4262                                  ;-94     prs(s);
  4263                                  
  4264 00002636 FF7604                   push word [bp+4]
  4265 00002639 E87FFE                   call prs
  4266 0000263C 83C402                   add  sp, 2
  4267                                  
  4268                                  ;-95     prs(", Symbol: "); 
  4269                                  
  4270 0000263F 68[7026]                 push error1_1
  4271 00002642 E876FE                   call prs
  4272 00002645 83C402                   add  sp, 2
  4273                                  
  4274                                  ;-96     prs(Symbol);
  4275                                  
  4276 00002648 8D06[0F00]               lea  ax, [Symbol]
  4277 0000264C 50                       push ax
  4278 0000264D E86BFE                   call prs
  4279 00002650 83C402                   add  sp, 2
  4280                                  
  4281                                  ;-97 }
  4282                                  
  4283                                  
  4284                                  ;-98 int errorexit(char *s) { 
  4285 00002653 C9                       LEAVE
  4286 00002654 C3                       ret
  4287                                  ; ENDP
  4288 00002655 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4289 0000265E 6E657874206C696E65-
  4290 00002667 204552524F523A2000 
  4291 00002670 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4292 00002679 2000               
  4293                                  
  4294                                  errorexit:  ; *** PROC ***
  4295                                  
  4296                                  ;-99     error1(s); 
  4297                                  
  4298                                  ;Function : errorexit, Number of local variables: 1
  4299                                  ;   # type sign width line used address name   list of local variables
  4300                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  4301 0000267B C8000000                 ENTER  0,0
  4302 0000267F FF7604                   push word [bp+4]
  4303 00002682 E897FF                   call error1
  4304 00002685 83C402                   add  sp, 2
  4305                                  
  4306                                  ;-100     end1(1);
  4307                                  
  4308 00002688 6A01                     push 1
  4309 0000268A E8C904                   call end1
  4310 0000268D 83C402                   add  sp, 2
  4311                                  
  4312                                  ;-101 }
  4313                                  
  4314                                  
  4315                                  ;-102 int allowederror() {error1("not allowed here"); }
  4316 00002690 C9                       LEAVE
  4317 00002691 C3                       ret
  4318                                  ; ENDP
  4319                                  
  4320                                  allowederror:  ; *** PROC ***
  4321 00002692 68[9C26]                 push allowederror_0
  4322 00002695 E884FF                   call error1
  4323 00002698 83C402                   add  sp, 2
  4324                                  
  4325                                  ;-103 int addrerror()    {error1("address missing");} 
  4326                                  
  4327 0000269B C3                       ret
  4328                                  ; ENDP
  4329 0000269C 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4330 000026A5 6564206865726500   
  4331                                  
  4332                                  addrerror:  ; *** PROC ***
  4333 000026AD 68[B726]                 push addrerror_0
  4334 000026B0 E869FF                   call error1
  4335 000026B3 83C402                   add  sp, 2
  4336                                  
  4337                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  4338                                  
  4339 000026B6 C3                       ret
  4340                                  ; ENDP
  4341 000026B7 61646472657373206D-     addrerror_0 db "address missing",0
  4342 000026C0 697373696E6700     
  4343                                  
  4344                                  immeerror:  ; *** PROC ***
  4345 000026C7 68[D126]                 push immeerror_0
  4346 000026CA E84FFF                   call error1
  4347 000026CD 83C402                   add  sp, 2
  4348                                  
  4349                                  ;-105 int implerror()    {error1("not implemented");}
  4350                                  
  4351 000026D0 C3                       ret
  4352                                  ; ENDP
  4353 000026D1 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4354 000026DA 206E6F7420616C6C6F-
  4355 000026E3 776564206865726500 
  4356                                  
  4357                                  implerror:  ; *** PROC ***
  4358 000026EC 68[F626]                 push implerror_0
  4359 000026EF E82AFF                   call error1
  4360 000026F2 83C402                   add  sp, 2
  4361                                  
  4362                                  ;-106 int indexerror()   {error1("invalid index register");}
  4363                                  
  4364 000026F5 C3                       ret
  4365                                  ; ENDP
  4366 000026F6 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4367 000026FF 6D656E74656400     
  4368                                  
  4369                                  indexerror:  ; *** PROC ***
  4370 00002706 68[1027]                 push indexerror_0
  4371 00002709 E810FF                   call error1
  4372 0000270C 83C402                   add  sp, 2
  4373                                  
  4374                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  4375                                  
  4376 0000270F C3                       ret
  4377                                  ; ENDP
  4378 00002710 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4379 00002719 6E6465782072656769-
  4380 00002722 7374657200         
  4381                                  
  4382                                  invaloperror:  ; *** PROC ***
  4383 00002727 68[3127]                 push invaloperror_0
  4384 0000272A E8EFFE                   call error1
  4385 0000272D 83C402                   add  sp, 2
  4386                                  
  4387                                  ;-108 int numbererror()  {error1("number expected");}
  4388                                  
  4389 00002730 C3                       ret
  4390                                  ; ENDP
  4391 00002731 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4392 0000273A 72206E6F206F706572-
  4393 00002743 616E647300         
  4394                                  
  4395                                  numbererror:  ; *** PROC ***
  4396 00002748 68[5227]                 push numbererror_0
  4397 0000274B E8CEFE                   call error1
  4398 0000274E 83C402                   add  sp, 2
  4399                                  
  4400                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  4401                                  
  4402 00002751 C3                       ret
  4403                                  ; ENDP
  4404 00002752 6E756D626572206578-     numbererror_0 db "number expected",0
  4405 0000275B 70656374656400     
  4406                                  
  4407                                  regmemerror:  ; *** PROC ***
  4408 00002762 68[6C27]                 push regmemerror_0
  4409 00002765 E8B4FE                   call error1
  4410 00002768 83C402                   add  sp, 2
  4411                                  
  4412                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  4413                                  
  4414 0000276B C3                       ret
  4415                                  ; ENDP
  4416 0000276C 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4417 00002775 73746572206F72206D-
  4418 0000277E 656D6F727920616C6C-
  4419 00002787 6F77656400         
  4420                                  
  4421                                  reg16error:  ; *** PROC ***
  4422 0000278C 68[9627]                 push reg16error_0
  4423 0000278F E88AFE                   call error1
  4424 00002792 83C402                   add  sp, 2
  4425                                  
  4426                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  4427                                  
  4428 00002795 C3                       ret
  4429                                  ; ENDP
  4430 00002796 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4431 0000279F 362C206E6F20736567-
  4432 000027A8 72656720616C6C6F77-
  4433 000027B1 656400             
  4434                                  
  4435                                  segregerror:  ; *** PROC ***
  4436 000027B4 68[BE27]                 push segregerror_0
  4437 000027B7 E862FE                   call error1
  4438 000027BA 83C402                   add  sp, 2
  4439                                  
  4440                                  ;-112 int syntaxerror()  {error1("syntax");}
  4441                                  
  4442 000027BD C3                       ret
  4443                                  ; ENDP
  4444 000027BE 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4445 000027C7 65676973746572206E-
  4446 000027D0 6F7420616C6C6F7765-
  4447 000027D9 6400               
  4448                                  
  4449                                  syntaxerror:  ; *** PROC ***
  4450 000027DB 68[E527]                 push syntaxerror_0
  4451 000027DE E83BFE                   call error1
  4452 000027E1 83C402                   add  sp, 2
  4453                                  
  4454                                  ;-113          
  4455                                  
  4456                                  
  4457                                  ;-114 int addrexit()     {errorexit("illegal address");}
  4458                                  
  4459 000027E4 C3                       ret
  4460                                  ; ENDP
  4461 000027E5 73796E74617800          syntaxerror_0 db "syntax",0
  4462                                  
  4463                                  addrexit:  ; *** PROC ***
  4464 000027EC 68[F627]                 push addrexit_0
  4465 000027EF E889FE                   call errorexit
  4466 000027F2 83C402                   add  sp, 2
  4467                                  
  4468                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  4469                                  
  4470 000027F5 C3                       ret
  4471                                  ; ENDP
  4472 000027F6 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4473 000027FF 64647265737300     
  4474                                  
  4475                                  internexit:  ; *** PROC ***
  4476 00002806 68[1028]                 push internexit_0
  4477 00002809 E86FFE                   call errorexit
  4478 0000280C 83C402                   add  sp, 2
  4479 0000280F C3                       ret
  4480                                  ; ENDP
  4481 00002810 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4482 00002819 6D70696C6572206572-
  4483 00002822 726F7200           
  4484                                  ;Back to main program: AS.C
  4485                                  
  4486                                  ;-8 #include "MAIN.C"
  4487                                  
  4488                                  ;Use include file: MAIN.C
  4489                                  
  4490                                  ;-1 int main() {
  4491                                  
  4492                                  
  4493                                  main:  ; *** PROC ***
  4494                                  
  4495                                  ;-2     getarg(); 
  4496                                  
  4497 00002826 E80A00                   call getarg
  4498                                  
  4499                                  ;-3     parse(); 
  4500                                  
  4501 00002829 E8D8EE                   call parse
  4502                                  
  4503                                  ;-4     epilog(); 
  4504                                  
  4505 0000282C E85C02                   call epilog
  4506                                  
  4507                                  ;-5     end1();
  4508                                  
  4509 0000282F E82403                   call end1
  4510                                  
  4511                                  ;-6 }
  4512                                  
  4513                                  
  4514                                  ;-7 
  4515                                  
  4516                                  
  4517                                  ;-8 int getarg() { 
  4518                                  
  4519 00002832 C3                       ret
  4520                                  ; ENDP
  4521                                  
  4522                                  getarg:  ; *** PROC ***
  4523                                  
  4524                                  ;-9     int arglen1; int i; char *c;
  4525                                  
  4526                                  
  4527                                  ;-10     arglen1=*arglen;
  4528                                  
  4529                                  ;Function : getarg, Number of local variables: 3
  4530                                  ;   # type sign width line used address name   list of local variables
  4531                                  ;  200 var sign word     9 NULL bp-2    arglen1
  4532                                  ;  201 var sign word     9 NULL bp-4    i
  4533                                  ;  202 ptr sign byte     9 NULL bp-6    c;
  4534 00002833 C8060000                 ENTER  6,0
  4535 00002837 8B1E[520E]               mov bx, [arglen]
  4536 0000283B 8A07                     mov al, [bx]
  4537 0000283D B400                     mov ah, 0
  4538 0000283F 8946FE                   mov word [bp-2], ax
  4539                                  
  4540                                  ;-11     if (arglen1==0) {
  4541                                  
  4542 00002842 8B46FE                   mov ax, [bp-2]
  4543 00002845 83F800                   cmp ax, 0
  4544 00002848 0F851C00                 jne @@getarg191
  4545                                  
  4546                                  ;-12         cputs(Version1);
  4547                                  
  4548 0000284C 8D06[0300]               lea  ax, [Version1]
  4549 00002850 50                       push ax
  4550 00002851 E8B00A                   call cputs
  4551 00002854 83C402                   add  sp, 2
  4552                                  
  4553                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4554                                  
  4555 00002857 68[F829]                 push getarg_0
  4556 0000285A E8A70A                   call cputs
  4557 0000285D 83C402                   add  sp, 2
  4558                                  
  4559                                  ;-14         exitR(3);
  4560                                  
  4561 00002860 6A03                     push 3
  4562 00002862 E87A0C                   call exitR
  4563 00002865 83C402                   add  sp, 2
  4564                                  
  4565                                  ;-15     }
  4566                                  
  4567                                  
  4568                                  ;-16     i=arglen1+129; 
  4569                                  
  4570                                  @@getarg191:
  4571 00002868 8B46FE                   mov ax, [bp-2]
  4572 0000286B 058100                   add ax, 129
  4573 0000286E 8946FC                   mov word [bp-4], ax
  4574                                  
  4575                                  ;-17     *i=0;  
  4576                                  
  4577 00002871 66B800000000             mov eax, 0
  4578 00002877 8B5EFC                   mov  bx, [bp-4]
  4579 0000287A 8907                     mov  [bx], ax
  4580                                  
  4581                                  ;-18     arglen1--;
  4582                                  
  4583 0000287C FF4EFE                   dec  word [bp-2]
  4584                                  
  4585                                  ;-19     toupper(argv);
  4586                                  
  4587 0000287F FF36[540E]               push word [argv]
  4588 00002883 E8AC0A                   call toupper
  4589 00002886 83C402                   add  sp, 2
  4590                                  
  4591                                  ;-20   
  4592                                  
  4593                                  
  4594                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4595                                  
  4596 00002889 FF36[540E]               push word [argv]
  4597 0000288D 8D06[D000]               lea  ax, [namein]
  4598 00002891 50                       push ax
  4599 00002892 E80B0B                   call strcpy
  4600 00002895 83C404                   add  sp, 4
  4601 00002898 68[1D2A]                 push getarg_1
  4602 0000289B 8D06[D000]               lea  ax, [namein]
  4603 0000289F 50                       push ax
  4604 000028A0 E8BE0B                   call strcat1
  4605 000028A3 83C404                   add  sp, 4
  4606                                  
  4607                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4608                                  
  4609 000028A6 FF36[540E]               push word [argv]
  4610 000028AA 8D06[1301]               lea  ax, [namelst]
  4611 000028AE 50                       push ax
  4612 000028AF E8EE0A                   call strcpy
  4613 000028B2 83C404                   add  sp, 4
  4614 000028B5 68[202A]                 push getarg_2
  4615 000028B8 8D06[1301]               lea  ax, [namelst]
  4616 000028BC 50                       push ax
  4617 000028BD E8A10B                   call strcat1
  4618 000028C0 83C404                   add  sp, 4
  4619                                  
  4620                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4621                                  
  4622 000028C3 FF36[540E]               push word [argv]
  4623 000028C7 8D06[5601]               lea  ax, [namebin]
  4624 000028CB 50                       push ax
  4625 000028CC E8D10A                   call strcpy
  4626 000028CF 83C404                   add  sp, 4
  4627 000028D2 68[252A]                 push getarg_3
  4628 000028D5 8D06[5601]               lea  ax, [namebin]
  4629 000028D9 50                       push ax
  4630 000028DA E8840B                   call strcat1
  4631 000028DD 83C404                   add  sp, 4
  4632                                  
  4633                                  ;-24 
  4634                                  
  4635                                  
  4636                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4637                                  
  4638 000028E0 66B801000000             mov eax, 1
  4639 000028E6 A2[0E00]                 mov byte [LIST], al
  4640 000028E9 66B800000000             mov eax, 0
  4641 000028EF A3[9F01]                 mov word [DOS_ERR], ax
  4642 000028F2 66B800000000             mov eax, 0
  4643 000028F8 A3[A601]                 mov word [PC], ax
  4644 000028FB 66B800000000             mov eax, 0
  4645 00002901 A3[A101]                 mov word [ErrorCount], ax
  4646                                  
  4647                                  ;-26   
  4648                                  
  4649                                  
  4650                                  ;-27     asm_fd=openR (namein);
  4651                                  
  4652 00002904 8D06[D000]               lea  ax, [namein]
  4653 00002908 50                       push ax
  4654 00002909 E87A0B                   call openR
  4655 0000290C 83C402                   add  sp, 2
  4656 0000290F A3[9901]                 mov word [asm_fd], ax
  4657                                  
  4658                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4659                                  
  4660 00002912 A1[9F01]                 mov ax, [DOS_ERR]
  4661 00002915 08C0                     or  al, al
  4662 00002917 0F841C00                 je @@getarg192
  4663 0000291B 68[2A2A]                 push getarg_4
  4664 0000291E E8E309                   call cputs
  4665 00002921 83C402                   add  sp, 2
  4666 00002924 8D06[D000]               lea  ax, [namein]
  4667 00002928 50                       push ax
  4668 00002929 E8D809                   call cputs
  4669 0000292C 83C402                   add  sp, 2
  4670 0000292F 6A01                     push 1
  4671 00002931 E8AB0B                   call exitR
  4672 00002934 83C402                   add  sp, 2
  4673                                  
  4674                                  ;-29     lst_fd=creatR(namelst);
  4675                                  
  4676                                  @@getarg192:
  4677 00002937 8D06[1301]               lea  ax, [namelst]
  4678 0000293B 50                       push ax
  4679 0000293C E8560B                   call creatR
  4680 0000293F 83C402                   add  sp, 2
  4681 00002942 A3[9B01]                 mov word [lst_fd], ax
  4682                                  
  4683                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4684                                  
  4685 00002945 A1[9F01]                 mov ax, [DOS_ERR]
  4686 00002948 08C0                     or  al, al
  4687 0000294A 0F841C00                 je @@getarg193
  4688 0000294E 68[402A]                 push getarg_5
  4689 00002951 E8B009                   call cputs
  4690 00002954 83C402                   add  sp, 2
  4691 00002957 8D06[1301]               lea  ax, [namelst]
  4692 0000295B 50                       push ax
  4693 0000295C E8A509                   call cputs
  4694 0000295F 83C402                   add  sp, 2
  4695 00002962 6A02                     push 2
  4696 00002964 E8780B                   call exitR
  4697 00002967 83C402                   add  sp, 2
  4698                                  
  4699                                  ;-31     bin_fd=creatR(namebin);
  4700                                  
  4701                                  @@getarg193:
  4702 0000296A 8D06[5601]               lea  ax, [namebin]
  4703 0000296E 50                       push ax
  4704 0000296F E8230B                   call creatR
  4705 00002972 83C402                   add  sp, 2
  4706 00002975 A3[9D01]                 mov word [bin_fd], ax
  4707                                  
  4708                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4709                                  
  4710 00002978 A1[9F01]                 mov ax, [DOS_ERR]
  4711 0000297B 08C0                     or  al, al
  4712 0000297D 0F841C00                 je @@getarg194
  4713 00002981 68[572A]                 push getarg_6
  4714 00002984 E87D09                   call cputs
  4715 00002987 83C402                   add  sp, 2
  4716 0000298A 8D06[5601]               lea  ax, [namebin]
  4717 0000298E 50                       push ax
  4718 0000298F E87209                   call cputs
  4719 00002992 83C402                   add  sp, 2
  4720 00002995 6A02                     push 2
  4721 00002997 E8450B                   call exitR
  4722 0000299A 83C402                   add  sp, 2
  4723                                  
  4724                                  ;-33   
  4725                                  
  4726                                  
  4727                                  ;-34     prs(";"); 
  4728                                  
  4729                                  @@getarg194:
  4730 0000299D 68[6D2A]                 push getarg_7
  4731 000029A0 E818FB                   call prs
  4732 000029A3 83C402                   add  sp, 2
  4733                                  
  4734                                  ;-35     prs(Version1);
  4735                                  
  4736 000029A6 8D06[0300]               lea  ax, [Version1]
  4737 000029AA 50                       push ax
  4738 000029AB E80DFB                   call prs
  4739 000029AE 83C402                   add  sp, 2
  4740                                  
  4741                                  ;-36     prs(", Source: "); prs(namein);  
  4742                                  
  4743 000029B1 68[6F2A]                 push getarg_8
  4744 000029B4 E804FB                   call prs
  4745 000029B7 83C402                   add  sp, 2
  4746 000029BA 8D06[D000]               lea  ax, [namein]
  4747 000029BE 50                       push ax
  4748 000029BF E8F9FA                   call prs
  4749 000029C2 83C402                   add  sp, 2
  4750                                  
  4751                                  ;-37     prs(", Output: "); prs(namelst);
  4752                                  
  4753 000029C5 68[7A2A]                 push getarg_9
  4754 000029C8 E8F0FA                   call prs
  4755 000029CB 83C402                   add  sp, 2
  4756 000029CE 8D06[1301]               lea  ax, [namelst]
  4757 000029D2 50                       push ax
  4758 000029D3 E8E5FA                   call prs
  4759 000029D6 83C402                   add  sp, 2
  4760                                  
  4761                                  ;-38     prs(", "); prs(namebin);
  4762                                  
  4763 000029D9 68[852A]                 push getarg_10
  4764 000029DC E8DCFA                   call prs
  4765 000029DF 83C402                   add  sp, 2
  4766 000029E2 8D06[5601]               lea  ax, [namebin]
  4767 000029E6 50                       push ax
  4768 000029E7 E8D1FA                   call prs
  4769 000029EA 83C402                   add  sp, 2
  4770                                  
  4771                                  ;-39     prs("\n");
  4772                                  
  4773 000029ED 68[882A]                 push getarg_11
  4774 000029F0 E8C8FA                   call prs
  4775 000029F3 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-40 }
  4778                                  
  4779                                  
  4780                                  ;-41 
  4781                                  
  4782                                  
  4783                                  ;-42 int epilog() { 
  4784 000029F6 C9                       LEAVE
  4785 000029F7 C3                       ret
  4786                                  ; ENDP
  4787 000029F8 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4788 00002A01 41532E434F4D206669-
  4789 00002A0A 6C656E616D65205B77-
  4790 00002A13 2F6F202E535D203A20-
  4791 00002A1C 00                 
  4792 00002A1D 2E5300                  getarg_1 db ".S",0
  4793 00002A20 2E4C535400              getarg_2 db ".LST",0
  4794 00002A25 2E434F4D00              getarg_3 db ".COM",0
  4795 00002A2A 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4796 00002A33 6C65206D697373696E-
  4797 00002A3C 673A2000           
  4798 00002A40 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4799 00002A49 206E6F742063726561-
  4800 00002A52 74653A2000         
  4801 00002A57 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4802 00002A60 6E6F74206372656174-
  4803 00002A69 653A2000           
  4804 00002A6D 3B00                    getarg_7 db ";",0
  4805 00002A6F 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4806 00002A78 2000               
  4807 00002A7A 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4808 00002A83 2000               
  4809 00002A85 2C2000                  getarg_10 db ", ",0
  4810 00002A88 5C6E00                  getarg_11 db "\n",0
  4811                                  
  4812                                  epilog:  ; *** PROC ***
  4813                                  
  4814                                  ;-43     int i; int j; char c;
  4815                                  
  4816                                  
  4817                                  ;-44     prs("\n;END Errors: "); 
  4818                                  
  4819                                  ;Function : epilog, Number of local variables: 3
  4820                                  ;   # type sign width line used address name   list of local variables
  4821                                  ;  200 var sign word    43 NULL bp-2    i
  4822                                  ;  201 var sign word    43 NULL bp-4    j
  4823                                  ;  202 var sign byte    43 NULL bp-6    c;
  4824 00002A8B C8060000                 ENTER  6,0
  4825 00002A8F 68[192B]                 push epilog_0
  4826 00002A92 E826FA                   call prs
  4827 00002A95 83C402                   add  sp, 2
  4828                                  
  4829                                  ;-45     printIntU(ErrorCount);
  4830                                  
  4831 00002A98 FF36[A101]               push word [ErrorCount]
  4832 00002A9C E83BFB                   call printIntU
  4833 00002A9F 83C402                   add  sp, 2
  4834                                  
  4835                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  4836                                  
  4837 00002AA2 A1[A101]                 mov ax, [ErrorCount]
  4838 00002AA5 08C0                     or  al, al
  4839 00002AA7 0F840900                 je @@epilog195
  4840 00002AAB 68[292B]                 push epilog_1
  4841 00002AAE E80AFA                   call prs
  4842 00002AB1 83C402                   add  sp, 2
  4843                                  
  4844                                  ;-47     prs(", Output: "); prs(namelst);
  4845                                  
  4846                                  @@epilog195:
  4847 00002AB4 68[372B]                 push epilog_2
  4848 00002AB7 E801FA                   call prs
  4849 00002ABA 83C402                   add  sp, 2
  4850 00002ABD 8D06[1301]               lea  ax, [namelst]
  4851 00002AC1 50                       push ax
  4852 00002AC2 E8F6F9                   call prs
  4853 00002AC5 83C402                   add  sp, 2
  4854                                  
  4855                                  ;-48     prs(", COM file "); 
  4856                                  
  4857 00002AC8 68[422B]                 push epilog_3
  4858 00002ACB E8EDF9                   call prs
  4859 00002ACE 83C402                   add  sp, 2
  4860                                  
  4861                                  ;-49     printIntU(BinLen); 
  4862                                  
  4863 00002AD1 FF36[500E]               push word [BinLen]
  4864 00002AD5 E802FB                   call printIntU
  4865 00002AD8 83C402                   add  sp, 2
  4866                                  
  4867                                  ;-50     prs(" bytes.");
  4868                                  
  4869 00002ADB 68[4E2B]                 push epilog_4
  4870 00002ADE E8DAF9                   call prs
  4871 00002AE1 83C402                   add  sp, 2
  4872                                  
  4873                                  ;-51 
  4874                                  
  4875                                  
  4876                                  ;-52     i=0;
  4877                                  
  4878 00002AE4 66B800000000             mov eax, 0
  4879 00002AEA 8946FE                   mov word [bp-2], ax
  4880                                  
  4881                                  ;-53     do {
  4882                                  
  4883                                  @@epilog196:
  4884                                  
  4885                                  ;-54         c = FileBin[i];
  4886                                  
  4887 00002AED 8B5EFE                   mov bx, [bp-2]
  4888 00002AF0 8A87[8006]               mov al, [FileBin + bx]
  4889 00002AF4 8846FA                   mov byte [bp-6], al
  4890                                  
  4891                                  ;-55         fputcR(c, bin_fd);
  4892                                  
  4893 00002AF7 FF36[9D01]               push word [bin_fd]
  4894 00002AFB 8A46FA                   mov al, byte [bp-6]
  4895 00002AFE B400                     mov ah, 0
  4896 00002B00 50                       push ax
  4897 00002B01 E8B809                   call fputcR
  4898 00002B04 83C404                   add  sp, 4
  4899                                  
  4900                                  ;-56         i++;
  4901                                  
  4902 00002B07 FF46FE                   inc  word [bp-2]
  4903                                  
  4904                                  ;-57     } while (i < BinLen);
  4905                                  
  4906 00002B0A 8B46FE                   mov ax, [bp-2]
  4907 00002B0D 3B06[500E]               cmp ax, [BinLen]
  4908 00002B11 0F8D0200                 jge @@epilog197
  4909 00002B15 EBD6                     jmp @@epilog196
  4910                                  @@epilog197:
  4911                                  
  4912                                  ;-58 }
  4913                                  
  4914                                  
  4915                                  ;-59 
  4916                                  
  4917                                  
  4918                                  ;-60 int end1(int n) {
  4919 00002B17 C9                       LEAVE
  4920 00002B18 C3                       ret
  4921                                  ; ENDP
  4922 00002B19 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4923 00002B22 726F72733A2000     
  4924 00002B29 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4925 00002B32 2A2A2A2000         
  4926 00002B37 2C204F75747075743A-     epilog_2 db ", Output: ",0
  4927 00002B40 2000               
  4928 00002B42 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  4929 00002B4B 652000             
  4930 00002B4E 2062797465732E00        epilog_4 db " bytes.",0
  4931                                  
  4932                                  end1:  ; *** PROC ***
  4933                                  
  4934                                  ;-61   fcloseR(asm_fd);
  4935                                  
  4936                                  ;Function : end1, Number of local variables: 1
  4937                                  ;   # type sign width line used address name   list of local variables
  4938                                  ;  200 var sign word    60 NULL bp+4    n;
  4939 00002B56 C8000000                 ENTER  0,0
  4940 00002B5A FF36[9901]               push word [asm_fd]
  4941 00002B5E E87009                   call fcloseR
  4942 00002B61 83C402                   add  sp, 2
  4943                                  
  4944                                  ;-62   fcloseR(lst_fd);
  4945                                  
  4946 00002B64 FF36[9B01]               push word [lst_fd]
  4947 00002B68 E86609                   call fcloseR
  4948 00002B6B 83C402                   add  sp, 2
  4949                                  
  4950                                  ;-63   fcloseR(bin_fd);
  4951                                  
  4952 00002B6E FF36[9D01]               push word [bin_fd]
  4953 00002B72 E85C09                   call fcloseR
  4954 00002B75 83C402                   add  sp, 2
  4955                                  
  4956                                  ;-64   exitR(n);
  4957                                  
  4958 00002B78 FF7604                   push word [bp+4]
  4959 00002B7B E86109                   call exitR
  4960 00002B7E 83C402                   add  sp, 2
  4961                                  
  4962                                  ;-65 }
  4963 00002B81 C9                       LEAVE
  4964 00002B82 C3                       ret
  4965                                  ; ENDP
  4966                                  ;Back to main program: AS.C
  4967                                  
  4968                                  ;-9 #include "GENCODE.C"
  4969                                  
  4970                                  ;Use include file: GENCODE.C
  4971                                  
  4972                                  ;-1 // generate code
  4973                                  
  4974                                  
  4975                                  ;-2 int getCodes() {
  4976                                  
  4977                                  
  4978                                  getCodes:  ; *** PROC ***
  4979                                  
  4980                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  4981                                  
  4982 00002B83 FF06[C701]               inc  word [OpCodePtr]
  4983 00002B87 8B1E[C701]               mov bx, [OpCodePtr]
  4984 00002B8B 8A07                     mov al, [bx]
  4985 00002B8D B400                     mov ah, 0
  4986 00002B8F A2[AF01]                 mov byte [Code1], al
  4987                                  
  4988                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4989                                  
  4990 00002B92 FF06[C701]               inc  word [OpCodePtr]
  4991 00002B96 8B1E[C701]               mov bx, [OpCodePtr]
  4992 00002B9A 8A07                     mov al, [bx]
  4993 00002B9C B400                     mov ah, 0
  4994 00002B9E A2[B001]                 mov byte [Code2], al
  4995                                  
  4996                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  4997                                  
  4998 00002BA1 FF06[C701]               inc  word [OpCodePtr]
  4999 00002BA5 8B1E[C701]               mov bx, [OpCodePtr]
  5000 00002BA9 8A07                     mov al, [bx]
  5001 00002BAB B400                     mov ah, 0
  5002 00002BAD A2[B101]                 mov byte [Code3], al
  5003                                  
  5004                                  ;-6 }
  5005                                  
  5006                                  
  5007                                  ;-7 int gen66h() {genCode8(0x66);
  5008                                  
  5009 00002BB0 C3                       ret
  5010                                  ; ENDP
  5011                                  
  5012                                  gen66h:  ; *** PROC ***
  5013 00002BB1 6A66                     push 102
  5014 00002BB3 E83B00                   call genCode8
  5015 00002BB6 83C402                   add  sp, 2
  5016                                  
  5017                                  ;-8 }
  5018                                  
  5019                                  
  5020                                  ;-9 int genCode2(char c, char d) {
  5021                                  
  5022 00002BB9 C3                       ret
  5023                                  ; ENDP
  5024                                  
  5025                                  genCode2:  ; *** PROC ***
  5026                                  
  5027                                  ;-10     c = c + d;
  5028                                  
  5029                                  ;Function : genCode2, Number of local variables: 2
  5030                                  ;   # type sign width line used address name   list of local variables
  5031                                  ;  200 var sign byte     9 NULL bp+4    c
  5032                                  ;  201 var sign byte     9 NULL bp+6    d;
  5033 00002BBA C8000000                 ENTER  0,0
  5034 00002BBE 8A4604                   mov al, [bp+4]
  5035 00002BC1 024606                   add al, [bp+6]
  5036 00002BC4 884604                   mov byte [bp+4], al
  5037                                  
  5038                                  ;-11     genCode8(c);
  5039                                  
  5040 00002BC7 8A4604                   mov al, byte [bp+4]
  5041 00002BCA B400                     mov ah, 0
  5042 00002BCC 50                       push ax
  5043 00002BCD E82100                   call genCode8
  5044 00002BD0 83C402                   add  sp, 2
  5045                                  
  5046                                  ;-12 }                             
  5047                                  
  5048                                  
  5049                                  ;-13 int genCodeW(char c) {
  5050 00002BD3 C9                       LEAVE
  5051 00002BD4 C3                       ret
  5052                                  ; ENDP
  5053                                  
  5054                                  genCodeW:  ; *** PROC ***
  5055                                  
  5056                                  ;-14     c = c + wflag;  
  5057                                  
  5058                                  ;Function : genCodeW, Number of local variables: 1
  5059                                  ;   # type sign width line used address name   list of local variables
  5060                                  ;  200 var sign byte    13 NULL bp+4    c;
  5061 00002BD5 C8000000                 ENTER  0,0
  5062 00002BD9 8A4604                   mov al, [bp+4]
  5063 00002BDC 0206[B701]               add al, [wflag]
  5064 00002BE0 884604                   mov byte [bp+4], al
  5065                                  
  5066                                  ;-15     genCode8(c);
  5067                                  
  5068 00002BE3 8A4604                   mov al, byte [bp+4]
  5069 00002BE6 B400                     mov ah, 0
  5070 00002BE8 50                       push ax
  5071 00002BE9 E80500                   call genCode8
  5072 00002BEC 83C402                   add  sp, 2
  5073                                  
  5074                                  ;-16 }   
  5075                                  
  5076                                  
  5077                                  ;-17 int genCode8(char c) {
  5078 00002BEF C9                       LEAVE
  5079 00002BF0 C3                       ret
  5080                                  ; ENDP
  5081                                  
  5082                                  genCode8:  ; *** PROC ***
  5083                                  
  5084                                  ;-18 //set: BinLen++, OpPrintIndex++
  5085                                  
  5086                                  
  5087                                  ;-19     FileBin[BinLen]=c;
  5088                                  
  5089                                  ;Function : genCode8, Number of local variables: 1
  5090                                  ;   # type sign width line used address name   list of local variables
  5091                                  ;  200 var sign byte    17 NULL bp+4    c;
  5092 00002BF1 C8000000                 ENTER  0,0
  5093 00002BF5 8A4604                   mov al, [bp+4]
  5094 00002BF8 8B1E[500E]               mov bx, [BinLen]
  5095 00002BFC 8887[8006]               mov [FileBin+bx], al
  5096                                  
  5097                                  ;-20     BinLen++;
  5098                                  
  5099 00002C00 FF06[500E]               inc  word [BinLen]
  5100                                  
  5101                                  ;-21     PC++;
  5102                                  
  5103 00002C04 FF06[A601]               inc  word [PC]
  5104                                  
  5105                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5106                                  
  5107 00002C08 A1[500E]                 mov ax, [BinLen]
  5108 00002C0B 3DD007                   cmp ax, 2000 ;unsigned : 0
  5109 00002C0E 0F820900                 jb  @@genCode8198
  5110 00002C12 68[362C]                 push genCode8_0
  5111 00002C15 E863FA                   call errorexit
  5112 00002C18 83C402                   add  sp, 2
  5113                                  
  5114                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5115                                  
  5116                                  @@genCode8198:
  5117 00002C1B A1[C501]                 mov ax, [OpPrintIndex]
  5118 00002C1E 83F805                   cmp ax, 5
  5119 00002C21 0F8D0F00                 jge @@genCode8199
  5120                                  
  5121                                  ;-24         OpPos[OpPrintIndex]=c;
  5122                                  
  5123 00002C25 8A4604                   mov al, [bp+4]
  5124 00002C28 8B1E[C501]               mov bx, [OpPrintIndex]
  5125 00002C2C 8887[C001]               mov [OpPos+bx], al
  5126                                  
  5127                                  ;-25         OpPrintIndex++;
  5128                                  
  5129 00002C30 FF06[C501]               inc  word [OpPrintIndex]
  5130                                  
  5131                                  ;-26     }
  5132                                  
  5133                                  
  5134                                  ;-27 }
  5135                                  
  5136                                  @@genCode8199:
  5137                                  
  5138                                  ;-28 int genCode16(unsigned int i) {
  5139 00002C34 C9                       LEAVE
  5140 00002C35 C3                       ret
  5141                                  ; ENDP
  5142 00002C36 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5143 00002C3F 746F6F206C6F6E6700 
  5144                                  
  5145                                  genCode16:  ; *** PROC ***
  5146                                  
  5147                                  ;-29     genCode8(i); i=i >> 8;
  5148                                  
  5149                                  ;Function : genCode16, Number of local variables: 1
  5150                                  ;   # type sign width line used address name   list of local variables
  5151                                  ;  200 var unsg word    28 NULL bp+4    i;
  5152 00002C48 C8000000                 ENTER  0,0
  5153 00002C4C FF7604                   push word [bp+4]
  5154 00002C4F E89FFF                   call genCode8
  5155 00002C52 83C402                   add  sp, 2
  5156 00002C55 8B4604                   mov ax, [bp+4]
  5157 00002C58 C1E808                   shr ax, 8
  5158 00002C5B 894604                   mov word [bp+4], ax
  5159                                  
  5160                                  ;-30     genCode8(i);
  5161                                  
  5162 00002C5E FF7604                   push word [bp+4]
  5163 00002C61 E88DFF                   call genCode8
  5164 00002C64 83C402                   add  sp, 2
  5165                                  
  5166                                  ;-31 }
  5167                                  
  5168                                  
  5169                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5170 00002C67 C9                       LEAVE
  5171 00002C68 C3                       ret
  5172                                  ; ENDP
  5173                                  
  5174                                  writeEA:  ; *** PROC ***
  5175                                  
  5176                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5177                                  
  5178                                  
  5179                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5180                                  
  5181                                  
  5182                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5183                                  
  5184                                  
  5185                                  ;-36     char len;
  5186                                  
  5187                                  
  5188                                  ;-37     len=0;   
  5189                                  
  5190                                  ;Function : writeEA, Number of local variables: 2
  5191                                  ;   # type sign width line used address name   list of local variables
  5192                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5193                                  ;  201 var sign byte    36 NULL bp-2    len;
  5194 00002C69 C8020000                 ENTER  2,0
  5195 00002C6D 66B800000000             mov eax, 0
  5196 00002C73 8846FE                   mov byte [bp-2], al
  5197                                  
  5198                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5199                                  
  5200 00002C76 8A4604                   mov al, [bp+4]
  5201 00002C79 C0E003                   shl al, 3
  5202 00002C7C 884604                   mov byte [bp+4], al
  5203                                  
  5204                                  ;-39     if (Op == REG) {
  5205                                  
  5206 00002C7F A0[AC01]                 mov al, [Op]
  5207 00002C82 3C02                     cmp al, 2
  5208 00002C84 0F853A00                 jne @@writeEA200
  5209                                  
  5210                                  ;-40         xxx |= 0xC0;     
  5211                                  
  5212 00002C88 804E04C0                 or  byte [bp+4], 192
  5213                                  
  5214                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5215                                  
  5216 00002C8C A0[AD01]                 mov al, [Op2]
  5217 00002C8F 3C01                     cmp al, 1
  5218 00002C91 0F8F0D00                 jg  @@writeEA201
  5219 00002C95 8A4604                   mov al, [bp+4]
  5220 00002C98 0206[B301]               add al, [R1No]
  5221 00002C9C 884604                   mov byte [bp+4], al
  5222                                  
  5223                                  ;-42             else {
  5224                                  
  5225 00002C9F E92000                   jmp @@writeEA202
  5226                                  @@writeEA201:
  5227                                  
  5228                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5229                                  
  5230 00002CA2 A0[AD01]                 mov al, [Op2]
  5231 00002CA5 3C02                     cmp al, 2
  5232 00002CA7 0F850D00                 jne @@writeEA203
  5233 00002CAB 8A4604                   mov al, [bp+4]
  5234 00002CAE 0206[B301]               add al, [R1No]
  5235 00002CB2 884604                   mov byte [bp+4], al
  5236                                  
  5237                                  ;-44                 else            xxx = xxx + R2No;  
  5238                                  
  5239 00002CB5 E90A00                   jmp @@writeEA204
  5240                                  @@writeEA203:
  5241 00002CB8 8A4604                   mov al, [bp+4]
  5242 00002CBB 0206[B201]               add al, [R2No]
  5243 00002CBF 884604                   mov byte [bp+4], al
  5244                                  
  5245                                  ;-45             }
  5246                                  
  5247                                  @@writeEA204:
  5248                                  
  5249                                  ;-46         } 
  5250                                  
  5251                                  @@writeEA202:
  5252                                  
  5253                                  ;-47     if (Op == MEM) {
  5254                                  
  5255                                  @@writeEA200:
  5256 00002CC2 A0[AC01]                 mov al, [Op]
  5257 00002CC5 3C04                     cmp al, 4
  5258 00002CC7 0F857F00                 jne @@writeEA205
  5259                                  
  5260                                  ;-48         if (isDirect) {
  5261                                  
  5262 00002CCB A0[BB01]                 mov al, [isDirect]
  5263 00002CCE 08C0                     or  al, al
  5264 00002CD0 0F841000                 je @@writeEA206
  5265                                  
  5266                                  ;-49             xxx |= 6;
  5267                                  
  5268 00002CD4 804E0406                 or  byte [bp+4], 6
  5269                                  
  5270                                  ;-50             len = 2;
  5271                                  
  5272 00002CD8 66B802000000             mov eax, 2
  5273 00002CDE 8846FE                   mov byte [bp-2], al
  5274                                  
  5275                                  ;-51         }
  5276                                  
  5277                                  
  5278                                  ;-52         else { 
  5279                                  
  5280 00002CE1 E96600                   jmp @@writeEA207
  5281                                  @@writeEA206:
  5282                                  
  5283                                  ;-53             xxx = xxx + rm;   
  5284                                  
  5285 00002CE4 8A4604                   mov al, [bp+4]
  5286 00002CE7 0206[BA01]               add al, [rm]
  5287 00002CEB 884604                   mov byte [bp+4], al
  5288                                  
  5289                                  ;-54             if (rm == 6) {//make [BP+00]
  5290                                  
  5291 00002CEE A0[BA01]                 mov al, [rm]
  5292 00002CF1 3C06                     cmp al, 6
  5293 00002CF3 0F851700                 jne @@writeEA208
  5294                                  
  5295                                  ;-55                 len=1;
  5296                                  
  5297 00002CF7 66B801000000             mov eax, 1
  5298 00002CFD 8846FE                   mov byte [bp-2], al
  5299                                  
  5300                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5301                                  
  5302 00002D00 A1[BC01]                 mov ax, [disp]
  5303 00002D03 83F800                   cmp ax, 0
  5304 00002D06 0F850400                 jne @@writeEA209
  5305 00002D0A 804E0440                 or  byte [bp+4], 64
  5306                                  
  5307                                  ;-57             }
  5308                                  
  5309                                  @@writeEA209:
  5310                                  
  5311                                  ;-58 
  5312                                  
  5313                                  
  5314                                  ;-59             if (disp) {
  5315                                  
  5316                                  @@writeEA208:
  5317 00002D0E A1[BC01]                 mov ax, [disp]
  5318 00002D11 08C0                     or  al, al
  5319 00002D13 0F843300                 je @@writeEA210
  5320                                  
  5321                                  ;-60                 ax = disp;
  5322                                  
  5323 00002D17 A1[BC01]                 mov  ax, [disp]
  5324                                  
  5325                                  ;-61                 if(ax > 127) len=2;
  5326                                  
  5327 00002D1A 83F87F                   cmp  ax, 127
  5328 00002D1D 0F8E0C00                 jle @@writeEA211
  5329 00002D21 66B802000000             mov eax, 2
  5330 00002D27 8846FE                   mov byte [bp-2], al
  5331                                  
  5332                                  ;-62                 else len=1;
  5333                                  
  5334 00002D2A E90900                   jmp @@writeEA212
  5335                                  @@writeEA211:
  5336 00002D2D 66B801000000             mov eax, 1
  5337 00002D33 8846FE                   mov byte [bp-2], al
  5338                                  
  5339                                  ;-63                 if (len == 1) xxx |= 0x40;
  5340                                  
  5341                                  @@writeEA212:
  5342 00002D36 8A46FE                   mov al, [bp-2]
  5343 00002D39 3C01                     cmp al, 1
  5344 00002D3B 0F850700                 jne @@writeEA213
  5345 00002D3F 804E0440                 or  byte [bp+4], 64
  5346                                  
  5347                                  ;-64                 else xxx |= 0x80;
  5348                                  
  5349 00002D43 E90400                   jmp @@writeEA214
  5350                                  @@writeEA213:
  5351 00002D46 804E0480                 or  byte [bp+4], 128
  5352                                  
  5353                                  ;-65             }
  5354                                  
  5355                                  @@writeEA214:
  5356                                  
  5357                                  ;-66         }
  5358                                  
  5359                                  @@writeEA210:
  5360                                  
  5361                                  ;-67     }  
  5362                                  
  5363                                  @@writeEA207:
  5364                                  
  5365                                  ;-68     
  5366                                  
  5367                                  
  5368                                  ;-69     genCode8(xxx);// gen second byte
  5369                                  
  5370                                  @@writeEA205:
  5371 00002D4A 8A4604                   mov al, byte [bp+4]
  5372 00002D4D B400                     mov ah, 0
  5373 00002D4F 50                       push ax
  5374 00002D50 E89EFE                   call genCode8
  5375 00002D53 83C402                   add  sp, 2
  5376                                  
  5377                                  ;-70     if (len == 1) genCode8 (disp);
  5378                                  
  5379 00002D56 8A46FE                   mov al, [bp-2]
  5380 00002D59 3C01                     cmp al, 1
  5381 00002D5B 0F850A00                 jne @@writeEA215
  5382 00002D5F FF36[BC01]               push word [disp]
  5383 00002D63 E88BFE                   call genCode8
  5384 00002D66 83C402                   add  sp, 2
  5385                                  
  5386                                  ;-71     if (len == 2) genCode16(disp);
  5387                                  
  5388                                  @@writeEA215:
  5389 00002D69 8A46FE                   mov al, [bp-2]
  5390 00002D6C 3C02                     cmp al, 2
  5391 00002D6E 0F850A00                 jne @@writeEA216
  5392 00002D72 FF36[BC01]               push word [disp]
  5393 00002D76 E8CFFE                   call genCode16
  5394 00002D79 83C402                   add  sp, 2
  5395                                  
  5396                                  ;-72 }
  5397                                  
  5398                                  @@writeEA216:
  5399                                  
  5400                                  ;-73 
  5401                                  
  5402                                  
  5403                                  ;-74 int genImmediate() { 
  5404 00002D7C C9                       LEAVE
  5405 00002D7D C3                       ret
  5406                                  ; ENDP
  5407                                  
  5408                                  genImmediate:  ; *** PROC ***
  5409                                  
  5410                                  ;-75     if (wflag) genCode16(imme);
  5411                                  
  5412 00002D7E A0[B701]                 mov al, [wflag]
  5413 00002D81 08C0                     or  al, al
  5414 00002D83 0F840D00                 je @@genImmediate217
  5415 00002D87 FF36[BE01]               push word [imme]
  5416 00002D8B E8BAFE                   call genCode16
  5417 00002D8E 83C402                   add  sp, 2
  5418                                  
  5419                                  ;-76     else       genCode8 (imme);  
  5420                                  
  5421 00002D91 E90A00                   jmp @@genImmediate218
  5422                                  @@genImmediate217:
  5423 00002D94 FF36[BE01]               push word [imme]
  5424 00002D98 E856FE                   call genCode8
  5425 00002D9B 83C402                   add  sp, 2
  5426                                  
  5427                                  ;-77 }    
  5428                                  
  5429                                  @@genImmediate218:
  5430 00002D9E C3                       ret
  5431                                  ; ENDP
  5432                                  ;Back to main program: AS.C
  5433                                  
  5434                                  ;-10 
  5435                                  
  5436                                  
  5437                                  ;-11 int process() { 
  5438                                  
  5439                                  
  5440                                  process:  ; *** PROC ***
  5441                                  
  5442                                  ;-12     char c;           
  5443                                  
  5444                                  
  5445                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  5446                                  
  5447                                  ;Function : process, Number of local variables: 1
  5448                                  ;   # type sign width line used address name   list of local variables
  5449                                  ;  200 var sign byte    12 NULL bp-2    c;
  5450 00002D9F C8020000                 ENTER  2,0
  5451 00002DA3 66B800000000             mov eax, 0
  5452 00002DA9 A2[BA01]                 mov byte [rm], al
  5453 00002DAC A2[B701]                 mov byte [wflag], al
  5454 00002DAF A2[B801]                 mov byte [dflag], al
  5455 00002DB2 A2[B201]                 mov byte [R2No], al
  5456 00002DB5 A2[B301]                 mov byte [R1No], al
  5457 00002DB8 A2[B401]                 mov byte [R2Type], al
  5458 00002DBB A2[B501]                 mov byte [R1Type], al
  5459 00002DBE A2[AD01]                 mov byte [Op2], al
  5460 00002DC1 A2[AC01]                 mov byte [Op], al
  5461                                  
  5462                                  ;-14     disp=imme=0;//int
  5463                                  
  5464 00002DC4 66B800000000             mov eax, 0
  5465 00002DCA A3[BE01]                 mov word [imme], ax
  5466 00002DCD A3[BC01]                 mov word [disp], ax
  5467                                  
  5468                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5469                                  
  5470 00002DD0 66B801000000             mov eax, 1
  5471 00002DD6 A2[BB01]                 mov byte [isDirect], al
  5472                                  
  5473                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5474                                  
  5475 00002DD9 E812EA                   call getTokeType
  5476                                  
  5477                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5478                                  
  5479 00002DDC E862ED                   call getCodeSize
  5480 00002DDF A2[B601]                 mov byte [OpSize], al
  5481                                  
  5482                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5483                                  
  5484 00002DE2 E89EFD                   call getCodes
  5485                                  
  5486                                  ;-19 
  5487                                  
  5488                                  
  5489                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5490                                  
  5491 00002DE5 A0[AE01]                 mov al, [CodeType]
  5492 00002DE8 3C01                     cmp al, 1
  5493 00002DEA 0F850F00                 jne @@process219
  5494                                  
  5495                                  ;-21         genCode8(Code1);
  5496                                  
  5497 00002DEE A0[AF01]                 mov al, byte [Code1]
  5498 00002DF1 B400                     mov ah, 0
  5499 00002DF3 50                       push ax
  5500 00002DF4 E8FAFD                   call genCode8
  5501 00002DF7 83C402                   add  sp, 2
  5502                                  
  5503                                  ;-22         return;
  5504                                  
  5505 00002DFA E9BF04                   jmp @@retn
  5506                                  
  5507                                  ;-23     }
  5508                                  
  5509                                  
  5510                                  ;-24   
  5511                                  
  5512                                  
  5513                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  5514                                  
  5515                                  @@process219:
  5516 00002DFD A0[AE01]                 mov al, [CodeType]
  5517 00002E00 3C02                     cmp al, 2
  5518 00002E02 0F856900                 jne @@process220
  5519                                  
  5520                                  ;-26         getOpL();    
  5521                                  
  5522 00002E06 E80EE5                   call getOpL
  5523                                  
  5524                                  ;-27         checkOpL();        
  5525                                  
  5526 00002E09 E82EE4                   call checkOpL
  5527                                  
  5528                                  ;-28         if (Code2 <= 1) {//inc,dec
  5529                                  
  5530 00002E0C A0[B001]                 mov al, [Code2]
  5531 00002E0F 3C01                     cmp al, 1
  5532 00002E11 0F8F2700                 jg  @@process221
  5533                                  
  5534                                  ;-29   	        if (Op == REG) {//short
  5535                                  
  5536 00002E15 A0[AC01]                 mov al, [Op]
  5537 00002E18 3C02                     cmp al, 2
  5538 00002E1A 0F851E00                 jne @@process222
  5539                                  
  5540                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5541                                  
  5542 00002E1E A0[B701]                 mov al, [wflag]
  5543 00002E21 08C0                     or  al, al
  5544 00002E23 0F841500                 je @@process223
  5545 00002E27 A0[B301]                 mov al, byte [R1No]
  5546 00002E2A B400                     mov ah, 0
  5547 00002E2C 50                       push ax
  5548 00002E2D A0[B101]                 mov al, byte [Code3]
  5549 00002E30 B400                     mov ah, 0
  5550 00002E32 50                       push ax
  5551 00002E33 E884FD                   call genCode2
  5552 00002E36 83C404                   add  sp, 4
  5553 00002E39 E98004                   jmp @@retn
  5554                                  
  5555                                  ;-31             }
  5556                                  
  5557                                  @@process223:
  5558                                  
  5559                                  ;-32         }
  5560                                  
  5561                                  @@process222:
  5562                                  
  5563                                  ;-33         if (Code2 == 5) {//imul extension?
  5564                                  
  5565                                  @@process221:
  5566 00002E3C A0[B001]                 mov al, [Code2]
  5567 00002E3F 3C05                     cmp al, 5
  5568 00002E41 0F850F00                 jne @@process224
  5569                                  
  5570                                  ;-34             getTokeType();
  5571                                  
  5572 00002E45 E8A6E9                   call getTokeType
  5573                                  
  5574                                  ;-35             if (TokeType) implerror();
  5575                                  
  5576 00002E48 A0[AB01]                 mov al, [TokeType]
  5577 00002E4B 08C0                     or  al, al
  5578 00002E4D 0F840300                 je @@process225
  5579 00002E51 E898F8                   call implerror
  5580                                  
  5581                                  ;-36         }
  5582                                  
  5583                                  @@process225:
  5584                                  
  5585                                  ;-37         genCodeW(Code1);           
  5586                                  
  5587                                  @@process224:
  5588 00002E54 A0[AF01]                 mov al, byte [Code1]
  5589 00002E57 B400                     mov ah, 0
  5590 00002E59 50                       push ax
  5591 00002E5A E878FD                   call genCodeW
  5592 00002E5D 83C402                   add  sp, 2
  5593                                  
  5594                                  ;-38         writeEA(Code2);
  5595                                  
  5596 00002E60 A0[B001]                 mov al, byte [Code2]
  5597 00002E63 B400                     mov ah, 0
  5598 00002E65 50                       push ax
  5599 00002E66 E800FE                   call writeEA
  5600 00002E69 83C402                   add  sp, 2
  5601                                  
  5602                                  ;-39         return;
  5603                                  
  5604 00002E6C E94D04                   jmp @@retn
  5605                                  
  5606                                  ;-40     }
  5607                                  
  5608                                  
  5609                                  ;-41   
  5610                                  
  5611                                  
  5612                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5613                                  
  5614                                  @@process220:
  5615 00002E6F A0[AE01]                 mov al, [CodeType]
  5616 00002E72 3C03                     cmp al, 3
  5617 00002E74 0F855100                 jne @@process226
  5618                                  
  5619                                  ;-43         check2Ops();    //setwflag not applicable
  5620                                  
  5621 00002E78 E841E4                   call check2Ops
  5622                                  
  5623                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5624                                  
  5625 00002E7B A0[B501]                 mov al, [R1Type]
  5626 00002E7E 3C02                     cmp al, 2
  5627 00002E80 0F840300                 je  @@process227
  5628 00002E84 E805F9                   call reg16error
  5629                                  
  5630                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  5631                                  
  5632                                  @@process227:
  5633 00002E87 A0[AD01]                 mov al, [Op2]
  5634 00002E8A 3C04                     cmp al, 4
  5635 00002E8C 0F840300                 je  @@process228
  5636 00002E90 E81AF8                   call addrerror
  5637                                  
  5638                                  ;-46         
  5639                                  
  5640                                  
  5641                                  ;-47         genCode8(Code1);//les,lds,lea
  5642                                  
  5643                                  @@process228:
  5644 00002E93 A0[AF01]                 mov al, byte [Code1]
  5645 00002E96 B400                     mov ah, 0
  5646 00002E98 50                       push ax
  5647 00002E99 E855FD                   call genCode8
  5648 00002E9C 83C402                   add  sp, 2
  5649                                  
  5650                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5651                                  
  5652 00002E9F A0[AF01]                 mov al, [Code1]
  5653 00002EA2 3C0F                     cmp al, 15
  5654 00002EA4 0F850C00                 jne @@process229
  5655 00002EA8 A0[B001]                 mov al, byte [Code2]
  5656 00002EAB B400                     mov ah, 0
  5657 00002EAD 50                       push ax
  5658 00002EAE E840FD                   call genCode8
  5659 00002EB1 83C402                   add  sp, 2
  5660                                  
  5661                                  ;-49         Op=Op2;//set MEM for writeEA
  5662                                  
  5663                                  @@process229:
  5664 00002EB4 A0[AD01]                 mov al, [Op2]
  5665 00002EB7 A2[AC01]                 mov byte [Op], al
  5666                                  
  5667                                  ;-50         writeEA(R1No);           
  5668                                  
  5669 00002EBA A0[B301]                 mov al, byte [R1No]
  5670 00002EBD B400                     mov ah, 0
  5671 00002EBF 50                       push ax
  5672 00002EC0 E8A6FD                   call writeEA
  5673 00002EC3 83C402                   add  sp, 2
  5674                                  
  5675                                  ;-51         return;
  5676                                  
  5677 00002EC6 E9F303                   jmp @@retn
  5678                                  
  5679                                  ;-52     }
  5680                                  
  5681                                  
  5682                                  ;-53 
  5683                                  
  5684                                  
  5685                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  5686                                  
  5687                                  @@process226:
  5688 00002EC9 A0[AE01]                 mov al, [CodeType]
  5689 00002ECC 3C04                     cmp al, 4
  5690 00002ECE 0F85EF00                 jne @@process230
  5691                                  
  5692                                  ;-55         check2Ops();    
  5693                                  
  5694 00002ED2 E8E7E3                   call check2Ops
  5695                                  
  5696                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  5697                                  
  5698 00002ED5 A0[AD01]                 mov al, [Op2]
  5699 00002ED8 3C01                     cmp al, 1
  5700 00002EDA 0F857900                 jne @@process231
  5701                                  
  5702                                  ;-57             setsflag();   
  5703                                  
  5704 00002EDE E8BEE7                   call setsflag
  5705                                  
  5706                                  ;-58             if (Op == REG) {                
  5707                                  
  5708 00002EE1 A0[AC01]                 mov al, [Op]
  5709 00002EE4 3C02                     cmp al, 2
  5710 00002EE6 0F853100                 jne @@process232
  5711                                  
  5712                                  ;-59                 if (R1No == 0) {// acc,imm   
  5713                                  
  5714 00002EEA A0[B301]                 mov al, [R1No]
  5715 00002EED 3C00                     cmp al, 0
  5716 00002EEF 0F852800                 jne @@process233
  5717                                  
  5718                                  ;-60                     if (sflag == 0) {                        
  5719                                  
  5720 00002EF3 A0[B901]                 mov al, [sflag]
  5721 00002EF6 3C00                     cmp al, 0
  5722 00002EF8 0F851F00                 jne @@process234
  5723                                  
  5724                                  ;-61                         c = Code1 << 3;
  5725                                  
  5726 00002EFC A0[AF01]                 mov al, [Code1]
  5727 00002EFF C0E003                   shl al, 3
  5728 00002F02 8846FE                   mov byte [bp-2], al
  5729                                  
  5730                                  ;-62                         c += 4;    
  5731                                  
  5732 00002F05 8046FE04                 add  byte [bp-2], 4
  5733                                  
  5734                                  ;-63                         genCodeW(c);
  5735                                  
  5736 00002F09 8A46FE                   mov al, byte [bp-2]
  5737 00002F0C B400                     mov ah, 0
  5738 00002F0E 50                       push ax
  5739 00002F0F E8C3FC                   call genCodeW
  5740 00002F12 83C402                   add  sp, 2
  5741                                  
  5742                                  ;-64                         genImmediate();
  5743                                  
  5744 00002F15 E866FE                   call genImmediate
  5745                                  
  5746                                  ;-65                         return;
  5747                                  
  5748 00002F18 E9A103                   jmp @@retn
  5749                                  
  5750                                  ;-66                     }
  5751                                  
  5752                                  
  5753                                  ;-67                 }
  5754                                  
  5755                                  @@process234:
  5756                                  
  5757                                  ;-68             }
  5758                                  
  5759                                  @@process233:
  5760                                  
  5761                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  5762                                  
  5763                                  
  5764                                  ;-70             c = sflag + 0x80;   
  5765                                  
  5766                                  @@process232:
  5767 00002F1B A0[B901]                 mov al, [sflag]
  5768 00002F1E 0480                     add al, 128
  5769 00002F20 8846FE                   mov byte [bp-2], al
  5770                                  
  5771                                  ;-71             genCodeW(c); 
  5772                                  
  5773 00002F23 8A46FE                   mov al, byte [bp-2]
  5774 00002F26 B400                     mov ah, 0
  5775 00002F28 50                       push ax
  5776 00002F29 E8A9FC                   call genCodeW
  5777 00002F2C 83C402                   add  sp, 2
  5778                                  
  5779                                  ;-72             writeEA(Code1);  
  5780                                  
  5781 00002F2F A0[AF01]                 mov al, byte [Code1]
  5782 00002F32 B400                     mov ah, 0
  5783 00002F34 50                       push ax
  5784 00002F35 E831FD                   call writeEA
  5785 00002F38 83C402                   add  sp, 2
  5786                                  
  5787                                  ;-73             if (sflag) genCode8(imme);
  5788                                  
  5789 00002F3B A0[B901]                 mov al, [sflag]
  5790 00002F3E 08C0                     or  al, al
  5791 00002F40 0F840D00                 je @@process235
  5792 00002F44 FF36[BE01]               push word [imme]
  5793 00002F48 E8A6FC                   call genCode8
  5794 00002F4B 83C402                   add  sp, 2
  5795                                  
  5796                                  ;-74             else genImmediate();    
  5797                                  
  5798 00002F4E E90300                   jmp @@process236
  5799                                  @@process235:
  5800 00002F51 E82AFE                   call genImmediate
  5801                                  
  5802                                  ;-75             return;     
  5803                                  
  5804                                  @@process236:
  5805 00002F54 E96503                   jmp @@retn
  5806                                  
  5807                                  ;-76         }  
  5808                                  
  5809                                  
  5810                                  ;-77         c = Code1 << 3;//r/m, r/r  
  5811                                  
  5812                                  @@process231:
  5813 00002F57 A0[AF01]                 mov al, [Code1]
  5814 00002F5A C0E003                   shl al, 3
  5815 00002F5D 8846FE                   mov byte [bp-2], al
  5816                                  
  5817                                  ;-78         if (Op == REG) {
  5818                                  
  5819 00002F60 A0[AC01]                 mov al, [Op]
  5820 00002F63 3C02                     cmp al, 2
  5821 00002F65 0F852E00                 jne @@process237
  5822                                  
  5823                                  ;-79             if (Op2 == MEM) {//reg, mem      
  5824                                  
  5825 00002F69 A0[AD01]                 mov al, [Op2]
  5826 00002F6C 3C04                     cmp al, 4
  5827 00002F6E 0F852500                 jne @@process238
  5828                                  
  5829                                  ;-80                 c += 2;//add direction flag
  5830                                  
  5831 00002F72 8046FE02                 add  byte [bp-2], 2
  5832                                  
  5833                                  ;-81                 genCodeW(c);
  5834                                  
  5835 00002F76 8A46FE                   mov al, byte [bp-2]
  5836 00002F79 B400                     mov ah, 0
  5837 00002F7B 50                       push ax
  5838 00002F7C E856FC                   call genCodeW
  5839 00002F7F 83C402                   add  sp, 2
  5840                                  
  5841                                  ;-82                 Op=Op2;//set MEM for writeEA                
  5842                                  
  5843 00002F82 A0[AD01]                 mov al, [Op2]
  5844 00002F85 A2[AC01]                 mov byte [Op], al
  5845                                  
  5846                                  ;-83                 writeEA(R1No);
  5847                                  
  5848 00002F88 A0[B301]                 mov al, byte [R1No]
  5849 00002F8B B400                     mov ah, 0
  5850 00002F8D 50                       push ax
  5851 00002F8E E8D8FC                   call writeEA
  5852 00002F91 83C402                   add  sp, 2
  5853                                  
  5854                                  ;-84                 return;    
  5855                                  
  5856 00002F94 E92503                   jmp @@retn
  5857                                  
  5858                                  ;-85             }
  5859                                  
  5860                                  
  5861                                  ;-86         }
  5862                                  
  5863                                  @@process238:
  5864                                  
  5865                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  5866                                  
  5867                                  @@process237:
  5868 00002F97 A0[AD01]                 mov al, [Op2]
  5869 00002F9A 3C02                     cmp al, 2
  5870 00002F9C 0F851B00                 jne @@process239
  5871                                  
  5872                                  ;-88             genCodeW(c);
  5873                                  
  5874 00002FA0 8A46FE                   mov al, byte [bp-2]
  5875 00002FA3 B400                     mov ah, 0
  5876 00002FA5 50                       push ax
  5877 00002FA6 E82CFC                   call genCodeW
  5878 00002FA9 83C402                   add  sp, 2
  5879                                  
  5880                                  ;-89             writeEA(R2No);//2. Op in reg-field
  5881                                  
  5882 00002FAC A0[B201]                 mov al, byte [R2No]
  5883 00002FAF B400                     mov ah, 0
  5884 00002FB1 50                       push ax
  5885 00002FB2 E8B4FC                   call writeEA
  5886 00002FB5 83C402                   add  sp, 2
  5887                                  
  5888                                  ;-90             return;            
  5889                                  
  5890 00002FB8 E90103                   jmp @@retn
  5891                                  
  5892                                  ;-91         }          
  5893                                  
  5894                                  
  5895                                  ;-92         syntaxerror();        
  5896                                  
  5897                                  @@process239:
  5898 00002FBB E81DF8                   call syntaxerror
  5899                                  
  5900                                  ;-93         return;
  5901                                  
  5902 00002FBE E9FB02                   jmp @@retn
  5903                                  
  5904                                  ;-94     }
  5905                                  
  5906                                  
  5907                                  ;-95  
  5908                                  
  5909                                  
  5910                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  5911                                  
  5912                                  @@process230:
  5913 00002FC1 A0[AE01]                 mov al, [CodeType]
  5914 00002FC4 3C05                     cmp al, 5
  5915 00002FC6 0F857F01                 jne @@process240
  5916                                  
  5917                                  ;-97         check2Ops();    
  5918                                  
  5919 00002FCA E8EFE2                   call check2Ops
  5920                                  
  5921                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  5922                                  
  5923                                  
  5924                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  5925                                  
  5926                                  
  5927                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  5928                                  
  5929                                  
  5930                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  5931                                  
  5932                                  
  5933                                  ;-102         if (Op2 == ADR) {
  5934                                  
  5935 00002FCD A0[AD01]                 mov al, [Op2]
  5936 00002FD0 3C03                     cmp al, 3
  5937 00002FD2 0F850F00                 jne @@process241
  5938                                  
  5939                                  ;-103             imme=disp;
  5940                                  
  5941 00002FD6 A1[BC01]                 mov ax, [disp]
  5942 00002FD9 A3[BE01]                 mov word [imme], ax
  5943                                  
  5944                                  ;-104             Op2=IMM;//continue with IMM    
  5945                                  
  5946 00002FDC 66B801000000             mov eax, 1
  5947 00002FE2 A2[AD01]                 mov byte [Op2], al
  5948                                  
  5949                                  ;-105         }  
  5950                                  
  5951                                  
  5952                                  ;-106         if (Op2 == IMM) {// r,i     
  5953                                  
  5954                                  @@process241:
  5955 00002FE5 A0[AD01]                 mov al, [Op2]
  5956 00002FE8 3C01                     cmp al, 1
  5957 00002FEA 0F855400                 jne @@process242
  5958                                  
  5959                                  ;-107             if (Op == REG) {               
  5960                                  
  5961 00002FEE A0[AC01]                 mov al, [Op]
  5962 00002FF1 3C02                     cmp al, 2
  5963 00002FF3 0F852500                 jne @@process243
  5964                                  
  5965                                  ;-108                 c = wflag << 3;   
  5966                                  
  5967 00002FF7 A0[B701]                 mov al, [wflag]
  5968 00002FFA C0E003                   shl al, 3
  5969 00002FFD 8846FE                   mov byte [bp-2], al
  5970                                  
  5971                                  ;-109                 c += 0xB0;                                     
  5972                                  
  5973 00003000 8046FEB0                 add  byte [bp-2], 176
  5974                                  
  5975                                  ;-110                 genCode2(c, R1No);   
  5976                                  
  5977 00003004 A0[B301]                 mov al, byte [R1No]
  5978 00003007 B400                     mov ah, 0
  5979 00003009 50                       push ax
  5980 0000300A 8A46FE                   mov al, byte [bp-2]
  5981 0000300D B400                     mov ah, 0
  5982 0000300F 50                       push ax
  5983 00003010 E8A7FB                   call genCode2
  5984 00003013 83C404                   add  sp, 4
  5985                                  
  5986                                  ;-111                 genImmediate();
  5987                                  
  5988 00003016 E865FD                   call genImmediate
  5989                                  
  5990                                  ;-112                 return; 
  5991                                  
  5992 00003019 E9A002                   jmp @@retn
  5993                                  
  5994                                  ;-113             }
  5995                                  
  5996                                  
  5997                                  ;-114             if (Op == MEM) {// m,i  
  5998                                  
  5999                                  @@process243:
  6000 0000301C A0[AC01]                 mov al, [Op]
  6001 0000301F 3C04                     cmp al, 4
  6002 00003021 0F851700                 jne @@process244
  6003                                  
  6004                                  ;-115                 genCodeW(0xC6);
  6005                                  
  6006 00003025 68C600                   push 198
  6007 00003028 E8AAFB                   call genCodeW
  6008 0000302B 83C402                   add  sp, 2
  6009                                  
  6010                                  ;-116                 writeEA( 0 );
  6011                                  
  6012 0000302E 6A00                     push 0
  6013 00003030 E836FC                   call writeEA
  6014 00003033 83C402                   add  sp, 2
  6015                                  
  6016                                  ;-117                 genImmediate();
  6017                                  
  6018 00003036 E845FD                   call genImmediate
  6019                                  
  6020                                  ;-118                 return;  
  6021                                  
  6022 00003039 E98002                   jmp @@retn
  6023                                  
  6024                                  ;-119             }
  6025                                  
  6026                                  
  6027                                  ;-120             regmemerror();
  6028                                  
  6029                                  @@process244:
  6030 0000303C E823F7                   call regmemerror
  6031                                  
  6032                                  ;-121             return;
  6033                                  
  6034 0000303F E97A02                   jmp @@retn
  6035                                  
  6036                                  ;-122         }      
  6037                                  
  6038                                  
  6039                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6040                                  
  6041                                  @@process242:
  6042 00003042 A0[B501]                 mov al, [R1Type]
  6043 00003045 3C04                     cmp al, 4
  6044 00003047 0F850300                 jne @@process245
  6045 0000304B E8A7E1                   call ChangeDirection
  6046                                  
  6047                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6048                                  
  6049                                  @@process245:
  6050 0000304E A0[B401]                 mov al, [R2Type]
  6051 00003051 3C04                     cmp al, 4
  6052 00003053 0F852A00                 jne @@process246
  6053                                  
  6054                                  ;-125             if (OpSize != WORD) reg16error();
  6055                                  
  6056 00003057 A0[B601]                 mov al, [OpSize]
  6057 0000305A 3C02                     cmp al, 2
  6058 0000305C 0F840300                 je  @@process247
  6059 00003060 E829F7                   call reg16error
  6060                                  
  6061                                  ;-126                 genCode2(0x8C, dflag);
  6062                                  
  6063                                  @@process247:
  6064 00003063 A0[B801]                 mov al, byte [dflag]
  6065 00003066 B400                     mov ah, 0
  6066 00003068 50                       push ax
  6067 00003069 688C00                   push 140
  6068 0000306C E84BFB                   call genCode2
  6069 0000306F 83C404                   add  sp, 4
  6070                                  
  6071                                  ;-127                 writeEA(R2No);
  6072                                  
  6073 00003072 A0[B201]                 mov al, byte [R2No]
  6074 00003075 B400                     mov ah, 0
  6075 00003077 50                       push ax
  6076 00003078 E8EEFB                   call writeEA
  6077 0000307B 83C402                   add  sp, 2
  6078                                  
  6079                                  ;-128                 return;   
  6080                                  
  6081 0000307E E93B02                   jmp @@retn
  6082                                  
  6083                                  ;-129         }          
  6084                                  
  6085                                  
  6086                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6087                                  
  6088                                  @@process246:
  6089 00003081 A0[AD01]                 mov al, [Op2]
  6090 00003084 3C04                     cmp al, 4
  6091 00003086 0F853100                 jne @@process248
  6092                                  
  6093                                  ;-131             if (Op == REG) {
  6094                                  
  6095 0000308A A0[AC01]                 mov al, [Op]
  6096 0000308D 3C02                     cmp al, 2
  6097 0000308F 0F852800                 jne @@process249
  6098                                  
  6099                                  ;-132                 if (R1No == 0) {
  6100                                  
  6101 00003093 A0[B301]                 mov al, [R1No]
  6102 00003096 3C00                     cmp al, 0
  6103 00003098 0F851F00                 jne @@process250
  6104                                  
  6105                                  ;-133                     if (isDirect) {
  6106                                  
  6107 0000309C A0[BB01]                 mov al, [isDirect]
  6108 0000309F 08C0                     or  al, al
  6109 000030A1 0F841600                 je @@process251
  6110                                  
  6111                                  ;-134                         genCodeW(0xA0);
  6112                                  
  6113 000030A5 68A000                   push 160
  6114 000030A8 E82AFB                   call genCodeW
  6115 000030AB 83C402                   add  sp, 2
  6116                                  
  6117                                  ;-135                         genCode16(disp);
  6118                                  
  6119 000030AE FF36[BC01]               push word [disp]
  6120 000030B2 E893FB                   call genCode16
  6121 000030B5 83C402                   add  sp, 2
  6122                                  
  6123                                  ;-136                         return;   
  6124                                  
  6125 000030B8 E90102                   jmp @@retn
  6126                                  
  6127                                  ;-137                     }   
  6128                                  
  6129                                  
  6130                                  ;-138                 }   
  6131                                  
  6132                                  @@process251:
  6133                                  
  6134                                  ;-139             }   
  6135                                  
  6136                                  @@process250:
  6137                                  
  6138                                  ;-140         } 
  6139                                  
  6140                                  @@process249:
  6141                                  
  6142                                  ;-141         if (Op == MEM) {//moffs16, acc
  6143                                  
  6144                                  @@process248:
  6145 000030BB A0[AC01]                 mov al, [Op]
  6146 000030BE 3C04                     cmp al, 4
  6147 000030C0 0F853100                 jne @@process252
  6148                                  
  6149                                  ;-142             if (Op2 == REG) {
  6150                                  
  6151 000030C4 A0[AD01]                 mov al, [Op2]
  6152 000030C7 3C02                     cmp al, 2
  6153 000030C9 0F852800                 jne @@process253
  6154                                  
  6155                                  ;-143                 if (R2No == 0) {
  6156                                  
  6157 000030CD A0[B201]                 mov al, [R2No]
  6158 000030D0 3C00                     cmp al, 0
  6159 000030D2 0F851F00                 jne @@process254
  6160                                  
  6161                                  ;-144                     if (isDirect) {
  6162                                  
  6163 000030D6 A0[BB01]                 mov al, [isDirect]
  6164 000030D9 08C0                     or  al, al
  6165 000030DB 0F841600                 je @@process255
  6166                                  
  6167                                  ;-145                         genCodeW(0xA2);
  6168                                  
  6169 000030DF 68A200                   push 162
  6170 000030E2 E8F0FA                   call genCodeW
  6171 000030E5 83C402                   add  sp, 2
  6172                                  
  6173                                  ;-146                         genCode16(disp);
  6174                                  
  6175 000030E8 FF36[BC01]               push word [disp]
  6176 000030EC E859FB                   call genCode16
  6177 000030EF 83C402                   add  sp, 2
  6178                                  
  6179                                  ;-147                         return;   
  6180                                  
  6181 000030F2 E9C701                   jmp @@retn
  6182                                  
  6183                                  ;-148                     }   
  6184                                  
  6185                                  
  6186                                  ;-149                 }   
  6187                                  
  6188                                  @@process255:
  6189                                  
  6190                                  ;-150             }
  6191                                  
  6192                                  @@process254:
  6193                                  
  6194                                  ;-151         
  6195                                  
  6196                                  
  6197                                  ;-152         }
  6198                                  
  6199                                  @@process253:
  6200                                  
  6201                                  ;-153         if (Op2 == REG) {//rm, r
  6202                                  
  6203                                  @@process252:
  6204 000030F5 A0[AD01]                 mov al, [Op2]
  6205 000030F8 3C02                     cmp al, 2
  6206 000030FA 0F851800                 jne @@process256
  6207                                  
  6208                                  ;-154             genCodeW(0x88);     
  6209                                  
  6210 000030FE 688800                   push 136
  6211 00003101 E8D1FA                   call genCodeW
  6212 00003104 83C402                   add  sp, 2
  6213                                  
  6214                                  ;-155             writeEA(R2No);
  6215                                  
  6216 00003107 A0[B201]                 mov al, byte [R2No]
  6217 0000310A B400                     mov ah, 0
  6218 0000310C 50                       push ax
  6219 0000310D E859FB                   call writeEA
  6220 00003110 83C402                   add  sp, 2
  6221                                  
  6222                                  ;-156             return;
  6223                                  
  6224 00003113 E9A601                   jmp @@retn
  6225                                  
  6226                                  ;-157         }
  6227                                  
  6228                                  
  6229                                  ;-158         if (Op2 == MEM) {//r, m
  6230                                  
  6231                                  @@process256:
  6232 00003116 A0[AD01]                 mov al, [Op2]
  6233 00003119 3C04                     cmp al, 4
  6234 0000311B 0F852400                 jne @@process257
  6235                                  
  6236                                  ;-159             if (Op == REG) {
  6237                                  
  6238 0000311F A0[AC01]                 mov al, [Op]
  6239 00003122 3C02                     cmp al, 2
  6240 00003124 0F851B00                 jne @@process258
  6241                                  
  6242                                  ;-160                 ChangeDirection();
  6243                                  
  6244 00003128 E8CAE0                   call ChangeDirection
  6245                                  
  6246                                  ;-161                 genCodeW(0x8A);
  6247                                  
  6248 0000312B 688A00                   push 138
  6249 0000312E E8A4FA                   call genCodeW
  6250 00003131 83C402                   add  sp, 2
  6251                                  
  6252                                  ;-162                 writeEA(R2No);
  6253                                  
  6254 00003134 A0[B201]                 mov al, byte [R2No]
  6255 00003137 B400                     mov ah, 0
  6256 00003139 50                       push ax
  6257 0000313A E82CFB                   call writeEA
  6258 0000313D 83C402                   add  sp, 2
  6259                                  
  6260                                  ;-163                 return;   
  6261                                  
  6262 00003140 E97901                   jmp @@retn
  6263                                  
  6264                                  ;-164             }   
  6265                                  
  6266                                  
  6267                                  ;-165         }         
  6268                                  
  6269                                  @@process258:
  6270                                  
  6271                                  ;-166         syntaxerror();
  6272                                  
  6273                                  @@process257:
  6274 00003143 E895F6                   call syntaxerror
  6275                                  
  6276                                  ;-167         return;
  6277                                  
  6278 00003146 E97301                   jmp @@retn
  6279                                  
  6280                                  ;-168     }    
  6281                                  
  6282                                  
  6283                                  ;-169     
  6284                                  
  6285                                  
  6286                                  ;-170     if (CodeType ==  8) {//ret,retf
  6287                                  
  6288                                  @@process240:
  6289 00003149 A0[AE01]                 mov al, [CodeType]
  6290 0000314C 3C08                     cmp al, 8
  6291 0000314E 0F853100                 jne @@process259
  6292                                  
  6293                                  ;-171         if (TokeType == DIGIT) {
  6294                                  
  6295 00003152 A0[AB01]                 mov al, [TokeType]
  6296 00003155 3C01                     cmp al, 1
  6297 00003157 0F851900                 jne @@process260
  6298                                  
  6299                                  ;-172             genCode8(Code2);
  6300                                  
  6301 0000315B A0[B001]                 mov al, byte [Code2]
  6302 0000315E B400                     mov ah, 0
  6303 00003160 50                       push ax
  6304 00003161 E88DFA                   call genCode8
  6305 00003164 83C402                   add  sp, 2
  6306                                  
  6307                                  ;-173             genCode16(SymbolInt);
  6308                                  
  6309 00003167 FF36[4D00]               push word [SymbolInt]
  6310 0000316B E8DAFA                   call genCode16
  6311 0000316E 83C402                   add  sp, 2
  6312                                  
  6313                                  ;-174             return;
  6314                                  
  6315 00003171 E94801                   jmp @@retn
  6316                                  
  6317                                  ;-175         }
  6318                                  
  6319                                  
  6320                                  ;-176         genCode8(Code1); 
  6321                                  
  6322                                  @@process260:
  6323 00003174 A0[AF01]                 mov al, byte [Code1]
  6324 00003177 B400                     mov ah, 0
  6325 00003179 50                       push ax
  6326 0000317A E874FA                   call genCode8
  6327 0000317D 83C402                   add  sp, 2
  6328                                  
  6329                                  ;-177         return;
  6330                                  
  6331 00003180 E93901                   jmp @@retn
  6332                                  
  6333                                  ;-178     }
  6334                                  
  6335                                  
  6336                                  ;-179        
  6337                                  
  6338                                  
  6339                                  ;-180     if (CodeType == 9) {//push, pop  
  6340                                  
  6341                                  @@process259:
  6342 00003183 A0[AE01]                 mov al, [CodeType]
  6343 00003186 3C09                     cmp al, 9
  6344 00003188 0F850301                 jne @@process261
  6345                                  
  6346                                  ;-181         getOpL();
  6347                                  
  6348 0000318C E888E1                   call getOpL
  6349                                  
  6350                                  ;-182         if (Code1 == 0x50) {//push only
  6351                                  
  6352 0000318F A0[AF01]                 mov al, [Code1]
  6353 00003192 3C50                     cmp al, 80
  6354 00003194 0F853D00                 jne @@process262
  6355                                  
  6356                                  ;-183             if (Op == IMM) {//push imm8,16
  6357                                  
  6358 00003198 A0[AC01]                 mov al, [Op]
  6359 0000319B 3C01                     cmp al, 1
  6360 0000319D 0F853400                 jne @@process263
  6361                                  
  6362                                  ;-184                 setsflag();
  6363                                  
  6364 000031A1 E8FBE4                   call setsflag
  6365                                  
  6366                                  ;-185                 genCode2(0x68, sflag);     
  6367                                  
  6368 000031A4 A0[B901]                 mov al, byte [sflag]
  6369 000031A7 B400                     mov ah, 0
  6370 000031A9 50                       push ax
  6371 000031AA 6A68                     push 104
  6372 000031AC E80BFA                   call genCode2
  6373 000031AF 83C404                   add  sp, 4
  6374                                  
  6375                                  ;-186                 if (sflag) genCode8 (imme);
  6376                                  
  6377 000031B2 A0[B901]                 mov al, [sflag]
  6378 000031B5 08C0                     or  al, al
  6379 000031B7 0F840D00                 je @@process264
  6380 000031BB FF36[BE01]               push word [imme]
  6381 000031BF E82FFA                   call genCode8
  6382 000031C2 83C402                   add  sp, 2
  6383                                  
  6384                                  ;-187                 else       genCode16(imme);    
  6385                                  
  6386 000031C5 E90A00                   jmp @@process265
  6387                                  @@process264:
  6388 000031C8 FF36[BE01]               push word [imme]
  6389 000031CC E879FA                   call genCode16
  6390 000031CF 83C402                   add  sp, 2
  6391                                  
  6392                                  ;-188                 return;   
  6393                                  
  6394                                  @@process265:
  6395 000031D2 E9E700                   jmp @@retn
  6396                                  
  6397                                  ;-189             }   
  6398                                  
  6399                                  
  6400                                  ;-190         }
  6401                                  
  6402                                  @@process263:
  6403                                  
  6404                                  ;-191         if (R1Type == SEGREG) {
  6405                                  
  6406                                  @@process262:
  6407 000031D5 A0[B501]                 mov al, [R1Type]
  6408 000031D8 3C04                     cmp al, 4
  6409 000031DA 0F855A00                 jne @@process266
  6410                                  
  6411                                  ;-192             if (Code1 == 0x58) {
  6412                                  
  6413 000031DE A0[AF01]                 mov al, [Code1]
  6414 000031E1 3C58                     cmp al, 88
  6415 000031E3 0F851200                 jne @@process267
  6416                                  
  6417                                  ;-193                 if (R1No == 1) error1("pop cs not allowed");   
  6418                                  
  6419 000031E7 A0[B301]                 mov al, [R1No]
  6420 000031EA 3C01                     cmp al, 1
  6421 000031EC 0F850900                 jne @@process268
  6422 000031F0 68[BE32]                 push process_0
  6423 000031F3 E826F4                   call error1
  6424 000031F6 83C402                   add  sp, 2
  6425                                  
  6426                                  ;-194             }
  6427                                  
  6428                                  @@process268:
  6429                                  
  6430                                  ;-195             c = R1No <<3;
  6431                                  
  6432                                  @@process267:
  6433 000031F9 A0[B301]                 mov al, [R1No]
  6434 000031FC C0E003                   shl al, 3
  6435 000031FF 8846FE                   mov byte [bp-2], al
  6436                                  
  6437                                  ;-196             if (R1No > 3) {//FS, GS
  6438                                  
  6439 00003202 A0[B301]                 mov al, [R1No]
  6440 00003205 3C03                     cmp al, 3
  6441 00003207 0F8E0C00                 jle @@process269
  6442                                  
  6443                                  ;-197                 c += 122;
  6444                                  
  6445 0000320B 8046FE7A                 add  byte [bp-2], 122
  6446                                  
  6447                                  ;-198                 genCode8(0x0F);
  6448                                  
  6449 0000320F 6A0F                     push 15
  6450 00003211 E8DDF9                   call genCode8
  6451 00003214 83C402                   add  sp, 2
  6452                                  
  6453                                  ;-199             }
  6454                                  
  6455                                  
  6456                                  ;-200             OpCodePtr++;
  6457                                  
  6458                                  @@process269:
  6459 00003217 FF06[C701]               inc  word [OpCodePtr]
  6460                                  
  6461                                  ;-201             c = c + *OpCodePtr;//is Code4   
  6462                                  
  6463 0000321B 8A46FE                   mov al, [bp-2]
  6464 0000321E 8B1E[C701]               mov bx, [OpCodePtr]
  6465 00003222 0207                     add al, [bx]
  6466 00003224 B400                     mov ah, 0
  6467 00003226 8846FE                   mov byte [bp-2], al
  6468                                  
  6469                                  ;-202             genCode8(c);  
  6470                                  
  6471 00003229 8A46FE                   mov al, byte [bp-2]
  6472 0000322C B400                     mov ah, 0
  6473 0000322E 50                       push ax
  6474 0000322F E8BFF9                   call genCode8
  6475 00003232 83C402                   add  sp, 2
  6476                                  
  6477                                  ;-203             return; 
  6478                                  
  6479 00003235 E98400                   jmp @@retn
  6480                                  
  6481                                  ;-204         }  
  6482                                  
  6483                                  
  6484                                  ;-205   
  6485                                  
  6486                                  
  6487                                  ;-206         checkOpL();    
  6488                                  
  6489                                  @@process266:
  6490 00003238 E8FFDF                   call checkOpL
  6491                                  
  6492                                  ;-207         if (R1Type == BYTE) reg16error();
  6493                                  
  6494 0000323B A0[B501]                 mov al, [R1Type]
  6495 0000323E 3C01                     cmp al, 1
  6496 00003240 0F850300                 jne @@process270
  6497 00003244 E845F5                   call reg16error
  6498                                  
  6499                                  ;-208         if (R1Type == WORD) {
  6500                                  
  6501                                  @@process270:
  6502 00003247 A0[B501]                 mov al, [R1Type]
  6503 0000324A 3C02                     cmp al, 2
  6504 0000324C 0F851500                 jne @@process271
  6505                                  
  6506                                  ;-209             genCode2(Code1, R1No);
  6507                                  
  6508 00003250 A0[B301]                 mov al, byte [R1No]
  6509 00003253 B400                     mov ah, 0
  6510 00003255 50                       push ax
  6511 00003256 A0[AF01]                 mov al, byte [Code1]
  6512 00003259 B400                     mov ah, 0
  6513 0000325B 50                       push ax
  6514 0000325C E85BF9                   call genCode2
  6515 0000325F 83C404                   add  sp, 4
  6516                                  
  6517                                  ;-210             return;   
  6518                                  
  6519 00003262 E95700                   jmp @@retn
  6520                                  
  6521                                  ;-211         }                
  6522                                  
  6523                                  
  6524                                  ;-212         if (Op == MEM) {
  6525                                  
  6526                                  @@process271:
  6527 00003265 A0[AC01]                 mov al, [Op]
  6528 00003268 3C04                     cmp al, 4
  6529 0000326A 0F851B00                 jne @@process272
  6530                                  
  6531                                  ;-213             genCode8(Code2);
  6532                                  
  6533 0000326E A0[B001]                 mov al, byte [Code2]
  6534 00003271 B400                     mov ah, 0
  6535 00003273 50                       push ax
  6536 00003274 E87AF9                   call genCode8
  6537 00003277 83C402                   add  sp, 2
  6538                                  
  6539                                  ;-214             writeEA(Code3);
  6540                                  
  6541 0000327A A0[B101]                 mov al, byte [Code3]
  6542 0000327D B400                     mov ah, 0
  6543 0000327F 50                       push ax
  6544 00003280 E8E6F9                   call writeEA
  6545 00003283 83C402                   add  sp, 2
  6546                                  
  6547                                  ;-215             return;   
  6548                                  
  6549 00003286 E93300                   jmp @@retn
  6550                                  
  6551                                  ;-216         }
  6552                                  
  6553                                  
  6554                                  ;-217       
  6555                                  
  6556                                  
  6557                                  ;-218         syntaxerror();
  6558                                  
  6559                                  @@process272:
  6560 00003289 E84FF5                   call syntaxerror
  6561                                  
  6562                                  ;-219         return;        
  6563                                  
  6564 0000328C E92D00                   jmp @@retn
  6565                                  
  6566                                  ;-220     }
  6567                                  
  6568                                  
  6569                                  ;-221        
  6570                                  
  6571                                  
  6572                                  ;-222     if (CodeType==101) {// ORG nn
  6573                                  
  6574                                  @@process261:
  6575 0000328F A0[AE01]                 mov al, [CodeType]
  6576 00003292 3C65                     cmp al, 101
  6577 00003294 0F851B00                 jne @@process273
  6578                                  
  6579                                  ;-223         if (TokeType != DIGIT) error1("only digit allowed");
  6580                                  
  6581 00003298 A0[AB01]                 mov al, [TokeType]
  6582 0000329B 3C01                     cmp al, 1
  6583 0000329D 0F840900                 je  @@process274
  6584 000032A1 68[D132]                 push process_1
  6585 000032A4 E875F3                   call error1
  6586 000032A7 83C402                   add  sp, 2
  6587                                  
  6588                                  ;-224         PC=SymbolInt;
  6589                                  
  6590                                  @@process274:
  6591 000032AA A1[4D00]                 mov ax, [SymbolInt]
  6592 000032AD A3[A601]                 mov word [PC], ax
  6593                                  
  6594                                  ;-225         return;
  6595                                  
  6596 000032B0 E90900                   jmp @@retn
  6597                                  
  6598                                  ;-226     }
  6599                                  
  6600                                  
  6601                                  ;-227     error1("Command not implemented");
  6602                                  
  6603                                  @@process273:
  6604 000032B3 68[E432]                 push process_2
  6605 000032B6 E863F3                   call error1
  6606 000032B9 83C402                   add  sp, 2
  6607                                  
  6608                                  ;-228 }    
  6609                                  
  6610 000032BC C9                      @@retn: LEAVE
  6611 000032BD C3                       ret
  6612                                  ; ENDP
  6613 000032BE 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  6614 000032C7 7420616C6C6F776564-
  6615 000032D0 00                 
  6616 000032D1 6F6E6C792064696769-     process_1 db "only digit allowed",0
  6617 000032DA 7420616C6C6F776564-
  6618 000032E3 00                 
  6619 000032E4 436F6D6D616E64206E-     process_2 db "Command not implemented",0
  6620 000032ED 6F7420696D706C656D-
  6621 000032F6 656E74656400       
  6622                                   
  6623                                  ; missing functions: 
  6624                                  ; digit
  6625                                  ; strcpy
  6626                                  ; eqstr
  6627                                  ; strlen
  6628                                  ; eqstr
  6629                                  ; eqstr
  6630                                  ; eqstr
  6631                                  ; eqstr
  6632                                  ; readRL
  6633                                  ; readRL
  6634                                  ; digit
  6635                                  ; digit
  6636                                  ; strcpy
  6637                                  ; toupper
  6638                                  ; strlen
  6639                                  ; strlen
  6640                                  ; eqstr
  6641                                  ; eqstr
  6642                                  ; eqstr
  6643                                  ; eqstr
  6644                                  ; eqstr
  6645                                  ; eqstr
  6646                                  ; eqstr
  6647                                  ; eqstr
  6648                                  ; eqstr
  6649                                  ; eqstr
  6650                                  ; eqstr
  6651                                  ; eqstr
  6652                                  ; eqstr
  6653                                  ; eqstr
  6654                                  ; eqstr
  6655                                  ; eqstr
  6656                                  ; eqstr
  6657                                  ; eqstr
  6658                                  ; eqstr
  6659                                  ; eqstr
  6660                                  ; eqstr
  6661                                  ; eqstr
  6662                                  ; eqstr
  6663                                  ; eqstr
  6664                                  ; eqstr
  6665                                  ; eqstr
  6666                                  ; eqstr
  6667                                  ; eqstr
  6668                                  ; eqstr
  6669                                  ; eqstr
  6670                                  ; writetty
  6671                                  ; writetty
  6672                                  ; fputcR
  6673                                  ; cputs
  6674                                  ; cputs
  6675                                  ; exitR
  6676                                  ; toupper
  6677                                  ; strcpy
  6678                                  ; strcat1
  6679                                  ; strcpy
  6680                                  ; strcat1
  6681                                  ; strcpy
  6682                                  ; strcat1
  6683                                  ; openR
  6684                                  ; cputs
  6685                                  ; cputs
  6686                                  ; exitR
  6687                                  ; creatR
  6688                                  ; cputs
  6689                                  ; cputs
  6690                                  ; exitR
  6691                                  ; creatR
  6692                                  ; cputs
  6693                                  ; cputs
  6694                                  ; exitR
  6695                                  ; fputcR
  6696                                  ; fcloseR
  6697                                  ; fcloseR
  6698                                  ; fcloseR
  6699                                  ; exitR
  6700                                  ; Number of unresolved CALLs :   76
  6701                                  ;use archive file: AR.C
  6702                                  
  6703                                  ;-229 // AR.C Archive
  6704                                  
  6705                                  ;Number of CALLs:    2 : writetty
  6706                                  
  6707                                  writetty:  ; *** PROC ***
  6708 000032FC B40E                     mov  ah, 14
  6709 000032FE BB0000                   mov  bx, 0
  6710 00003301 CD10                     int  16
  6711                                  
  6712                                  ;-230 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6713                                  
  6714 00003303 C3                       ret
  6715                                  ; ENDP
  6716                                  ;Number of CALLs:    8 : cputs
  6717                                  
  6718                                  cputs:  ; *** PROC ***
  6719                                  ;Function : cputs, Number of local variables: 2
  6720                                  ;   # type sign width line used address name   list of local variables
  6721                                  ;  200 ptr sign byte   230 NULL bp+4    s
  6722                                  ;  201 var sign byte   230 NULL bp-2    c;
  6723 00003304 C8020000                 ENTER  2,0
  6724                                  @@cputs275:
  6725 00003308 8B5E04                   mov bx, [bp+4]
  6726 0000330B 8A07                     mov al, [bx]
  6727 0000330D B400                     mov ah, 0
  6728 0000330F 08C0                     or  al, al
  6729 00003311 0F841B00                 je @@cputs276
  6730 00003315 8B5E04                   mov bx, [bp+4]
  6731 00003318 8A07                     mov al, [bx]
  6732 0000331A B400                     mov ah, 0
  6733 0000331C 8846FE                   mov byte [bp-2], al
  6734 0000331F 8A46FE                   mov al, byte [bp-2]
  6735 00003322 B400                     mov ah, 0
  6736 00003324 50                       push ax
  6737 00003325 E8C401                   call putch
  6738 00003328 83C402                   add  sp, 2
  6739 0000332B FF4604                   inc  word [bp+4]
  6740 0000332E EBD8                     jmp @@cputs275
  6741                                  @@cputs276:
  6742                                  
  6743                                  ;-231 int mkneg(int n) { n; __asm {neg ax} }
  6744 00003330 C9                       LEAVE
  6745 00003331 C3                       ret
  6746                                  ; ENDP
  6747                                  ;Number of CALLs:    2 : toupper
  6748                                  
  6749                                  toupper:  ; *** PROC ***
  6750                                  ;Function : toupper, Number of local variables: 1
  6751                                  ;   # type sign width line used address name   list of local variables
  6752                                  ;  200 ptr sign byte   231 NULL bp+4    s;
  6753 00003332 C8000000                 ENTER  0,0
  6754                                  @@toupper277:
  6755 00003336 8B5E04                   mov bx, [bp+4]
  6756 00003339 8A07                     mov al, [bx]
  6757 0000333B B400                     mov ah, 0
  6758 0000333D 08C0                     or  al, al
  6759 0000333F 0F843000                 je @@toupper278
  6760 00003343 8B5E04                   mov bx, [bp+4]
  6761 00003346 8A07                     mov al, [bx]
  6762 00003348 B400                     mov ah, 0
  6763 0000334A 83F861                   cmp ax, 97 ;unsigned : 1
  6764 0000334D 0F8C1D00                 jl  @@toupper279
  6765 00003351 8B5E04                   mov bx, [bp+4]
  6766 00003354 8A07                     mov al, [bx]
  6767 00003356 B400                     mov ah, 0
  6768 00003358 83F87A                   cmp ax, 122
  6769 0000335B 0F8F0F00                 jg  @@toupper280
  6770 0000335F 8B5E04                   mov bx, [bp+4]
  6771 00003362 8A07                     mov al, [bx]
  6772 00003364 B400                     mov ah, 0
  6773 00003366 83E820                   sub ax, 32
  6774 00003369 8B5E04                   mov  bx, [bp+4]
  6775 0000336C 8807                     mov  [bx], al
  6776                                  @@toupper280:
  6777                                  @@toupper279:
  6778 0000336E FF4604                   inc  word [bp+4]
  6779 00003371 EBC3                     jmp @@toupper277
  6780                                  @@toupper278:
  6781                                  
  6782                                  ;-232 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6783                                  
  6784                                  
  6785                                  ;-233 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6786 00003373 C9                       LEAVE
  6787 00003374 C3                       ret
  6788                                  ; ENDP
  6789                                  ;Number of CALLs:    3 : strlen
  6790                                  
  6791                                  strlen:  ; *** PROC ***
  6792                                  ;Function : strlen, Number of local variables: 2
  6793                                  ;   # type sign width line used address name   list of local variables
  6794                                  ;  200 ptr sign byte   233 NULL bp+4    s
  6795                                  ;  201 var sign word   233 NULL bp-2    c;
  6796 00003375 C8020000                 ENTER  2,0
  6797 00003379 66B800000000             mov eax, 0
  6798 0000337F 8946FE                   mov word [bp-2], ax
  6799                                  @@strlen281:
  6800 00003382 8B5E04                   mov bx, [bp+4]
  6801 00003385 8A07                     mov al, [bx]
  6802 00003387 B400                     mov ah, 0
  6803 00003389 83F800                   cmp ax, 0
  6804 0000338C 0F840800                 je  @@strlen282
  6805 00003390 FF4604                   inc  word [bp+4]
  6806 00003393 FF46FE                   inc  word [bp-2]
  6807 00003396 EBEA                     jmp @@strlen281
  6808                                  @@strlen282:
  6809 00003398 8B46FE                   mov ax, [bp-2]
  6810 0000339B E90000                   jmp @@retn
  6811                                  
  6812                                  ;-234 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6813                                  
  6814 0000339E C9                      @@retn: LEAVE
  6815 0000339F C3                       ret
  6816                                  ; ENDP
  6817                                  ;Number of CALLs:    5 : strcpy
  6818                                  
  6819                                  strcpy:  ; *** PROC ***
  6820                                  ;Function : strcpy, Number of local variables: 2
  6821                                  ;   # type sign width line used address name   list of local variables
  6822                                  ;  200 ptr sign byte   234 NULL bp+4    s
  6823                                  ;  201 ptr sign byte   234 NULL bp+6    t;
  6824 000033A0 C8000000                 ENTER  0,0
  6825                                  @@strcpy283:
  6826 000033A4 8B5E06                   mov bx, [bp+6]
  6827 000033A7 8A07                     mov al, [bx]
  6828 000033A9 B400                     mov ah, 0
  6829 000033AB 8B5E04                   mov  bx, [bp+4]
  6830 000033AE 8807                     mov  [bx], al
  6831 000033B0 FF4604                   inc  word [bp+4]
  6832 000033B3 FF4606                   inc  word [bp+6]
  6833                                  
  6834                                  ;-235   while (*t!=0); *s=0; return s; }
  6835                                  
  6836 000033B6 8B5E06                   mov bx, [bp+6]
  6837 000033B9 8A07                     mov al, [bx]
  6838 000033BB B400                     mov ah, 0
  6839 000033BD 83F800                   cmp ax, 0
  6840 000033C0 0F840200                 je  @@strcpy284
  6841 000033C4 EBDE                     jmp @@strcpy283
  6842                                  @@strcpy284:
  6843 000033C6 66B800000000             mov eax, 0
  6844 000033CC 8B5E04                   mov  bx, [bp+4]
  6845 000033CF 8807                     mov  [bx], al
  6846 000033D1 8B4604                   mov ax, [bp+4]
  6847 000033D4 E90000                   jmp @@retn
  6848                                  
  6849                                  ;-236 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6850                                  
  6851 000033D7 C9                      @@retn: LEAVE
  6852 000033D8 C3                       ret
  6853                                  ; ENDP
  6854                                  ;Number of CALLs:    3 : digit
  6855                                  
  6856                                  digit:  ; *** PROC ***
  6857                                  ;Function : digit, Number of local variables: 1
  6858                                  ;   # type sign width line used address name   list of local variables
  6859                                  ;  200 var sign byte   236 NULL bp+4    c;
  6860 000033D9 C8000000                 ENTER  0,0
  6861 000033DD 8A4604                   mov al, [bp+4]
  6862 000033E0 3C30                     cmp al, 48
  6863 000033E2 0F8D0900                 jge @@digit285
  6864 000033E6 66B800000000             mov eax, 0
  6865 000033EC E91B00                   jmp @@retn
  6866                                  @@digit285:
  6867 000033EF 8A4604                   mov al, [bp+4]
  6868 000033F2 3C39                     cmp al, 57
  6869 000033F4 0F8E0900                 jle @@digit286
  6870 000033F8 66B800000000             mov eax, 0
  6871 000033FE E90900                   jmp @@retn
  6872                                  @@digit286:
  6873 00003401 66B801000000             mov eax, 1
  6874 00003407 E90000                   jmp @@retn
  6875                                  
  6876                                  ;-237 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6877                                  
  6878 0000340A C9                      @@retn: LEAVE
  6879 0000340B C3                       ret
  6880                                  ; ENDP
  6881                                  ;Number of CALLs:   35 : eqstr
  6882                                  
  6883                                  eqstr:  ; *** PROC ***
  6884                                  ;Function : eqstr, Number of local variables: 2
  6885                                  ;   # type sign width line used address name   list of local variables
  6886                                  ;  200 ptr sign byte   237 NULL bp+4    p
  6887                                  ;  201 ptr sign byte   237 NULL bp+6    q;
  6888 0000340C C8000000                 ENTER  0,0
  6889                                  @@eqstr287:
  6890 00003410 8B5E04                   mov bx, [bp+4]
  6891 00003413 8A07                     mov al, [bx]
  6892 00003415 B400                     mov ah, 0
  6893 00003417 08C0                     or  al, al
  6894 00003419 0F842300                 je @@eqstr288
  6895                                  
  6896                                  ;-238     if (*p != *q) return 0; p++; q++; }
  6897                                  
  6898 0000341D 8B5E04                   mov bx, [bp+4]
  6899 00003420 8A07                     mov al, [bx]
  6900 00003422 B400                     mov ah, 0
  6901 00003424 8B5E06                   mov bx, [bp+6]
  6902 00003427 3A07                     cmp al, [bx]
  6903 00003429 B400                     mov ah, 0
  6904 0000342B 0F840900                 je  @@eqstr289
  6905 0000342F 66B800000000             mov eax, 0
  6906 00003435 E92700                   jmp @@retn
  6907                                  @@eqstr289:
  6908 00003438 FF4604                   inc  word [bp+4]
  6909 0000343B FF4606                   inc  word [bp+6]
  6910                                  
  6911                                  ;-239     if(*q) return 0; return 1; }
  6912                                  
  6913 0000343E EBD0                     jmp @@eqstr287
  6914                                  @@eqstr288:
  6915 00003440 8B5E06                   mov bx, [bp+6]
  6916 00003443 8A07                     mov al, [bx]
  6917 00003445 B400                     mov ah, 0
  6918 00003447 08C0                     or  al, al
  6919 00003449 0F840900                 je @@eqstr290
  6920 0000344D 66B800000000             mov eax, 0
  6921 00003453 E90900                   jmp @@retn
  6922                                  @@eqstr290:
  6923 00003456 66B801000000             mov eax, 1
  6924 0000345C E90000                   jmp @@retn
  6925                                  
  6926                                  ;-240 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6927                                  
  6928 0000345F C9                      @@retn: LEAVE
  6929 00003460 C3                       ret
  6930                                  ; ENDP
  6931                                  ;Number of CALLs:    3 : strcat1
  6932                                  
  6933                                  strcat1:  ; *** PROC ***
  6934                                  ;Function : strcat1, Number of local variables: 2
  6935                                  ;   # type sign width line used address name   list of local variables
  6936                                  ;  200 ptr sign byte   240 NULL bp+4    s
  6937                                  ;  201 ptr sign byte   240 NULL bp+6    t;
  6938 00003461 C8000000                 ENTER  0,0
  6939                                  @@strcat1291:
  6940 00003465 8B5E04                   mov bx, [bp+4]
  6941 00003468 8A07                     mov al, [bx]
  6942 0000346A B400                     mov ah, 0
  6943 0000346C 83F800                   cmp ax, 0
  6944 0000346F 0F840500                 je  @@strcat1292
  6945 00003473 FF4604                   inc  word [bp+4]
  6946 00003476 EBED                     jmp @@strcat1291
  6947                                  @@strcat1292:
  6948 00003478 FF7606                   push word [bp+6]
  6949 0000347B FF7604                   push word [bp+4]
  6950 0000347E E81FFF                   call strcpy
  6951 00003481 83C404                   add  sp, 4
  6952                                  
  6953                                  ;-241 int basename(char *s) { char *p; p=0;
  6954 00003484 C9                       LEAVE
  6955 00003485 C3                       ret
  6956                                  ; ENDP
  6957                                  ;Number of CALLs:    1 : openR
  6958                                  
  6959                                  openR:  ; *** PROC ***
  6960                                  ;Function : openR, Number of local variables: 1
  6961                                  ;   # type sign width line used address name   list of local variables
  6962                                  ;  200 ptr sign byte   241 NULL bp+4    s;
  6963 00003486 C8000000                 ENTER  0,0
  6964 0000348A 8B5604                   mov  dx, [bp+4]
  6965 0000348D B8023D                   mov  ax, 15618
  6966 00003490 E87200                   call DosInt
  6967                                  
  6968                                  ;-242 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6969 00003493 C9                       LEAVE
  6970 00003494 C3                       ret
  6971                                  ; ENDP
  6972                                  ;Number of CALLs:    2 : creatR
  6973                                  
  6974                                  creatR:  ; *** PROC ***
  6975                                  ;Function : creatR, Number of local variables: 1
  6976                                  ;   # type sign width line used address name   list of local variables
  6977                                  ;  200 ptr sign byte   242 NULL bp+4    s;
  6978 00003495 C8000000                 ENTER  0,0
  6979 00003499 8B5604                   mov  dx, [bp+4]
  6980 0000349C B90000                   mov  cx, 0
  6981 0000349F B8003C                   mov  ax, 15360
  6982 000034A2 E86000                   call DosInt
  6983                                  
  6984                                  ;-243 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6985 000034A5 C9                       LEAVE
  6986 000034A6 C3                       ret
  6987                                  ; ENDP
  6988                                  ;Number of CALLs:    2 : readRL
  6989                                  
  6990                                  readRL:  ; *** PROC ***
  6991                                  ;Function : readRL, Number of local variables: 3
  6992                                  ;   # type sign width line used address name   list of local variables
  6993                                  ;  200 ptr sign byte   243 NULL bp+4    s
  6994                                  ;  201 var sign word   243 NULL bp+6    fd
  6995                                  ;  202 var sign word   243 NULL bp+8    len;
  6996 000034A7 C8000000                 ENTER  0,0
  6997 000034AB 8B5604                   mov  dx, [bp+4]
  6998 000034AE 8B4E08                   mov  cx, [bp+8]
  6999 000034B1 8B5E06                   mov  bx, [bp+6]
  7000 000034B4 B8003F                   mov  ax, 16128
  7001 000034B7 E84B00                   call DosInt
  7002                                  
  7003                                  ;-244 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7004 000034BA C9                       LEAVE
  7005 000034BB C3                       ret
  7006                                  ; ENDP
  7007                                  ;Number of CALLs:    2 : fputcR
  7008                                  
  7009                                  fputcR:  ; *** PROC ***
  7010                                  ;Function : fputcR, Number of local variables: 2
  7011                                  ;   # type sign width line used address name   list of local variables
  7012                                  ;  200 ptr sign byte   244 NULL bp+4    n
  7013                                  ;  201 var sign word   244 NULL bp+6    fd;
  7014 000034BC C8000000                 ENTER  0,0
  7015 000034C0 8D5604                  lea dx, [bp+4]
  7016                                  
  7017                                  ;-245   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7018                                  
  7019 000034C3 B90100                   mov  cx, 1
  7020 000034C6 8B5E06                   mov  bx, [bp+6]
  7021 000034C9 B80040                   mov  ax, 16384
  7022 000034CC E83600                   call DosInt
  7023                                  
  7024                                  ;-246 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7025 000034CF C9                       LEAVE
  7026 000034D0 C3                       ret
  7027                                  ; ENDP
  7028                                  ;Number of CALLs:    3 : fcloseR
  7029                                  
  7030                                  fcloseR:  ; *** PROC ***
  7031                                  ;Function : fcloseR, Number of local variables: 1
  7032                                  ;   # type sign width line used address name   list of local variables
  7033                                  ;  200 var sign word   246 NULL bp+4    fd;
  7034 000034D1 C8000000                 ENTER  0,0
  7035 000034D5 8B5E04                   mov  bx, [bp+4]
  7036 000034D8 B8003E                   mov  ax, 15872
  7037 000034DB CD21                     int  33
  7038                                  
  7039                                  ;-247 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7040 000034DD C9                       LEAVE
  7041 000034DE C3                       ret
  7042                                  ; ENDP
  7043                                  ;Number of CALLs:    5 : exitR
  7044                                  
  7045                                  exitR:  ; *** PROC ***
  7046                                  ;Function : exitR, Number of local variables: 1
  7047                                  ;   # type sign width line used address name   list of local variables
  7048                                  ;  200 var sign byte   247 NULL bp+4    c;
  7049 000034DF C8000000                 ENTER  0,0
  7050 000034E3 B44C                     mov  ah, 76
  7051 000034E5 8A4604                   mov  al, [bp+4]
  7052 000034E8 CD21                     int  33
  7053                                  
  7054                                  ;-248 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7055 000034EA C9                       LEAVE
  7056 000034EB C3                       ret
  7057                                  ; ENDP
  7058                                  ;End of archive file. 
  7059                                   
  7060                                  ; missing functions: 
  7061                                  ; putch
  7062                                  ; DosInt
  7063                                  ; DosInt
  7064                                  ; DosInt
  7065                                  ; DosInt
  7066                                  ; Number of unresolved CALLs :    5
  7067                                  ;use archive file: AR.C
  7068                                  
  7069                                  ;-249 // AR.C Archive
  7070                                  
  7071                                  ;Number of CALLs:    1 : putch
  7072                                  
  7073                                  putch:  ; *** PROC ***
  7074                                  ;Function : putch, Number of local variables: 1
  7075                                  ;   # type sign width line used address name   list of local variables
  7076                                  ;  200 var sign byte   249 NULL bp+4    c;
  7077 000034EC C8000000                 ENTER  0,0
  7078 000034F0 807E040A                cmp byte [bp+4], 10
  7079 000034F4 0F850500                 jne @@putch293
  7080 000034F8 B00D                     mov  al, 13
  7081 000034FA E8FFFD                   call writetty
  7082                                  @@putch293:
  7083 000034FD 8A4604                   mov  al, [bp+4]
  7084 00003500 E8F9FD                   call writetty
  7085                                  
  7086                                  ;-250 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7087 00003503 C9                       LEAVE
  7088 00003504 C3                       ret
  7089                                  ; ENDP
  7090                                  ;Number of CALLs:    4 : DosInt
  7091                                  
  7092                                  DosInt:  ; *** PROC ***
  7093 00003505 CD21                     int  33
  7094 00003507 7304                     jae short @@DosInt294
  7095 00003509 FF06[9F01]               inc  word [DOS_ERR]
  7096                                  @@DosInt294:
  7097                                  
  7098                                  ;-251 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7099                                  
  7100 0000350D C3                       ret
  7101                                  ; ENDP
  7102                                  ;End of archive file. 
  7103                                   
  7104                                  ; missing functions:  All FUNCTIONs in place
  7105 0000350E E80000                  LastFunctionByt:db 0E8h, 0, 0
  7106 00003511 58                      pop ax
  7107 00003512 C3                      ret
  7108                                   
  7109                                  ;   # type sign width line used  address name   list of global variables
  7110                                  
  7111                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7112                                  ;    2 var sign byte     1    3        0 LIST
  7113                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7114                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  7115                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7116                                  ;    6 var unsg word     5   12        0 SymbolInt
  7117                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7118                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7119                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7120                                  ;   10 arr sign byte     9    5        0 namein[67]
  7121                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7122                                  ;   12 arr sign byte    11    5        0 namebin[67]
  7123                                  ;   13 var sign word    12    4        0 asm_fd
  7124                                  ;   14 var sign word    13    3        0 lst_fd
  7125                                  ;   15 var sign word    14    3        0 bin_fd
  7126                                  ;   16 var sign word    15    6        0 DOS_ERR
  7127                                  ;   17 var sign word    16    4        0 ErrorCount
  7128                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7129                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7130                                  ;   20 var unsg word    20    5        0 PC
  7131                                  ;   21 var unsg word    21    2        0 PCStart
  7132                                  ;   22 var sign byte    22    3        0 isLabel
  7133                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7134                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7135                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7136                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7137                                  ;   27 var sign byte    27   21        0 TokeType
  7138                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7139                                  ;   29 def unsg byte    29    -        0 WORD=2
  7140                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7141                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7142                                  ;   32 def unsg byte    32    -        0 IMM=1
  7143                                  ;   33 def unsg byte    33    -        0 REG=2
  7144                                  ;   34 def unsg byte    34    -        0 ADR=3
  7145                                  ;   35 def unsg byte    35    -        0 MEM=4
  7146                                  ;   36 var sign byte    36   24        0 Op
  7147                                  ;   37 var sign byte    37   29        0 Op2
  7148                                  ;   38 var sign byte    38   16        0 CodeType
  7149                                  ;   39 var sign byte    39   12        0 Code1
  7150                                  ;   40 var sign byte    40    7        0 Code2
  7151                                  ;   41 var sign byte    41    3        0 Code3
  7152                                  ;   42 var sign byte    42   18        0 R2No
  7153                                  ;   43 var sign byte    43   16        0 R1No
  7154                                  ;   44 var sign byte    44   17        0 R2Type
  7155                                  ;   45 var sign byte    45   14        0 R1Type
  7156                                  ;   46 var sign byte    46   13        0 OpSize
  7157                                  ;   47 var sign byte    47    8        0 wflag
  7158                                  ;   48 var sign byte    48    3        0 dflag
  7159                                  ;   49 var sign byte    49    8        0 sflag
  7160                                  ;   50 var sign byte    50   15        0 rm
  7161                                  ;   51 var sign byte    51    5        0 isDirect
  7162                                  ;   52 var sign word    52   17        0 disp
  7163                                  ;   53 var unsg word    53   10        0 imme
  7164                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7165                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7166                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7167                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7168                                  ;   58 var sign byte    59    2        0 PrintR
  7169                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7170                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7171                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7172                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7173                                  ;   63 arr unsg word    65    3        0 LabelAddr[100]
  7174                                  ;   64 var sign word    66    4        0 LabelMaxIx
  7175                                  ;   65 var sign word    67    4        0 LabelIx
  7176                                  ;   66 def unsg byte    69    -        0 FILEBINMAX=2000
  7177                                  ;   67 arr sign byte    70    2        0 FileBin[2000]
  7178                                  ;   68 var unsg word    71    5        0 BinLen
  7179                                  ;   69 ptr sign byte    73    1        0 arglen
  7180                                  ;   70 ptr sign byte    74    4        0 argv
  7181                                  ;   71 var sign byte     1    1        0 I_START
  7182                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  7183                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  7184                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  7185                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  7186                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  7187                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  7188                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  7189                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  7190                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  7191                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  7192                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  7193                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  7194                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  7195                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  7196                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  7197                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  7198                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  7199                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  7200                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  7201                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  7202                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  7203                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  7204                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  7205                                  ;   95 arr sign byte    27 NULL        0 I_IRET[8]
  7206                                  ;   96 arr sign byte    28 NULL        0 I_XLAT[8]
  7207                                  ;   97 arr sign byte    29 NULL        0 I_LOCK[8]
  7208                                  ;   98 arr sign byte    30 NULL        0 I_REPNE[9]
  7209                                  ;   99 arr sign byte    31 NULL        0 I_REPNZ[9]
  7210                                  ;  100 arr sign byte    32 NULL        0 I_REPE[8]
  7211                                  ;  101 arr sign byte    33 NULL        0 I_REPZ[8]
  7212                                  ;  102 arr sign byte    34 NULL        0 I_HLT[7]
  7213                                  ;  103 arr sign byte    35 NULL        0 I_CLC[7]
  7214                                  ;  104 arr sign byte    36 NULL        0 I_STC[7]
  7215                                  ;  105 arr sign byte    37 NULL        0 I_CLI[7]
  7216                                  ;  106 arr sign byte    38 NULL        0 I_STI[7]
  7217                                  ;  107 arr sign byte    39 NULL        0 I_CLD[7]
  7218                                  ;  108 arr sign byte    40 NULL        0 I_STD[7]
  7219                                  ;  109 arr sign byte    42 NULL        0 I_INC[9]
  7220                                  ;  110 arr sign byte    43 NULL        0 I_DEC[9]
  7221                                  ;  111 arr sign byte    44 NULL        0 I_NOT[8]
  7222                                  ;  112 arr sign byte    45 NULL        0 I_NEG[8]
  7223                                  ;  113 arr sign byte    46 NULL        0 I_MUL[8]
  7224                                  ;  114 arr sign byte    47 NULL        0 I_IMUL[9]
  7225                                  ;  115 arr sign byte    48 NULL        0 I_DIV[8]
  7226                                  ;  116 arr sign byte    49 NULL        0 I_IDIV[9]
  7227                                  ;  117 arr sign byte    51 NULL        0 I_LES[7]
  7228                                  ;  118 arr sign byte    52 NULL        0 I_LDS[7]
  7229                                  ;  119 arr sign byte    53 NULL        0 I_LEA[7]
  7230                                  ;  120 arr sign byte    54 NULL        0 I_LSS[8]
  7231                                  ;  121 arr sign byte    55 NULL        0 I_LFS[8]
  7232                                  ;  122 arr sign byte    56 NULL        0 I_LGS[8]
  7233                                  ;  123 arr sign byte    58 NULL        0 I_ADD[7]
  7234                                  ;  124 arr sign byte    59 NULL        0 I_OR[6]
  7235                                  ;  125 arr sign byte    60 NULL        0 I_ADC[7]
  7236                                  ;  126 arr sign byte    61 NULL        0 I_SBB[7]
  7237                                  ;  127 arr sign byte    62 NULL        0 I_AND[7]
  7238                                  ;  128 arr sign byte    63 NULL        0 I_SUB[7]
  7239                                  ;  129 arr sign byte    64 NULL        0 I_XOR[7]
  7240                                  ;  130 arr sign byte    65 NULL        0 I_CMP[7]
  7241                                  ;  131 arr sign byte    66 NULL        0 I_TEST[11]
  7242                                  ;  132 arr sign byte    68 NULL        0 I_MOV[6]
  7243                                  ;  133 arr sign byte    69 NULL        0 I_MOVSX[9]
  7244                                  ;  134 arr sign byte    70 NULL        0 I_MOVZX[9]
  7245                                  ;  135 arr sign byte    72 NULL        0 I_JO[6]
  7246                                  ;  136 arr sign byte    73 NULL        0 I_JNO[7]
  7247                                  ;  137 arr sign byte    74 NULL        0 I_JB[6]
  7248                                  ;  138 arr sign byte    75 NULL        0 I_JC[6]
  7249                                  ;  139 arr sign byte    76 NULL        0 I_JNB[7]
  7250                                  ;  140 arr sign byte    77 NULL        0 I_JAE[7]
  7251                                  ;  141 arr sign byte    78 NULL        0 I_JNC[7]
  7252                                  ;  142 arr sign byte    79 NULL        0 I_JE[6]
  7253                                  ;  143 arr sign byte    80 NULL        0 I_JZ[6]
  7254                                  ;  144 arr sign byte    81 NULL        0 I_JNE[7]
  7255                                  ;  145 arr sign byte    82 NULL        0 I_JNZ[7]
  7256                                  ;  146 arr sign byte    83 NULL        0 I_JBE[7]
  7257                                  ;  147 arr sign byte    84 NULL        0 I_JNA[7]
  7258                                  ;  148 arr sign byte    85 NULL        0 I_JA[6]
  7259                                  ;  149 arr sign byte    86 NULL        0 I_JS[6]
  7260                                  ;  150 arr sign byte    87 NULL        0 I_JNS[7]
  7261                                  ;  151 arr sign byte    88 NULL        0 I_JP[6]
  7262                                  ;  152 arr sign byte    89 NULL        0 I_JPE[7]
  7263                                  ;  153 arr sign byte    90 NULL        0 I_JNP[7]
  7264                                  ;  154 arr sign byte    91 NULL        0 I_JPO[7]
  7265                                  ;  155 arr sign byte    92 NULL        0 I_JL[6]
  7266                                  ;  156 arr sign byte    93 NULL        0 I_JNL[7]
  7267                                  ;  157 arr sign byte    94 NULL        0 I_JGE[7]
  7268                                  ;  158 arr sign byte    95 NULL        0 I_JLE[7]
  7269                                  ;  159 arr sign byte    96 NULL        0 I_JNG[7]
  7270                                  ;  160 arr sign byte    97 NULL        0 I_JG[6]
  7271                                  ;  161 arr sign byte    99 NULL        0 I_JMP[8]
  7272                                  ;  162 arr sign byte   100 NULL        0 I_CALL[9]
  7273                                  ;  163 arr sign byte   102 NULL        0 I_RET[8]
  7274                                  ;  164 arr sign byte   103 NULL        0 I_RETF[9]
  7275                                  ;  165 arr sign byte   105 NULL        0 I_PUSH[11]
  7276                                  ;  166 arr sign byte   106 NULL        0 I_POP[10]
  7277                                  ;  167 arr sign byte   108 NULL        0 I_ROL[7]
  7278                                  ;  168 arr sign byte   109 NULL        0 I_ROR[7]
  7279                                  ;  169 arr sign byte   110 NULL        0 I_RCL[7]
  7280                                  ;  170 arr sign byte   111 NULL        0 I_RCR[7]
  7281                                  ;  171 arr sign byte   112 NULL        0 I_SHL[7]
  7282                                  ;  172 arr sign byte   113 NULL        0 I_SAL[7]
  7283                                  ;  173 arr sign byte   114 NULL        0 I_SHR[7]
  7284                                  ;  174 arr sign byte   115 NULL        0 I_SAR[7]
  7285                                  ;  175 arr sign byte   117 NULL        0 I_INT[8]
  7286                                  ;  176 arr sign byte   118 NULL        0 I_INTO[8]
  7287                                  ;  177 arr sign byte   129 NULL        0 I_XCHG[9]
  7288                                  ;  178 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  7289                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNE[10]
  7290                                  ;  180 arr sign byte   133 NULL        0 I_LOOPZ[9]
  7291                                  ;  181 arr sign byte   134 NULL        0 I_LOOPE[9]
  7292                                  ;  182 arr sign byte   135 NULL        0 I_LOOP[8]
  7293                                  ;  183 arr sign byte   136 NULL        0 I_JCXZ[8]
  7294                                  ;  184 arr sign byte   137 NULL        0 I_JECXZ[9]
  7295                                  ;  185 arr sign byte   139 NULL        0 I_ENTER[9]
  7296                                  ;  186 arr sign byte   141 NULL        0 I_ORG[6]
  7297                                  ;  187 arr sign byte   146 NULL        0 I_DB[5]
  7298                                  ;  188 arr sign byte   147 NULL        0 I_DW[5]
  7299                                  ;  189 arr sign byte   148 NULL        0 I_DD[5]
  7300                                  ;  190 arr sign byte   149 NULL        0 I_RESB[7]
  7301                                  ;  191 arr sign byte   150 NULL        0 I_RESW[7]
  7302                                  ;  192 arr sign byte   151 NULL        0 I_RESD[7]
  7303                                  ;  193 var sign byte   152 NULL        0 I_END
  7304                                  
  7305                                  
  7306                                  ;   # Calls Line Width  Name   list of functions
  7307                                  
  7308                                  ;    0    2    1 word   ChangeDirection
  7309                                  ;    1    2    9 word   checkOpL
  7310                                  ;    2    3   18 word   check2Ops
  7311                                  ;    3    1   27 word   get2Ops
  7312                                  ;    4    3   33 word   getOpL
  7313                                  ;    5    2   41 word   getOpR
  7314                                  ;    6    2   51 word   getOp1
  7315                                  ;    7    1   67 word   getMEM
  7316                                  ;    8    1   90 word   getIndReg1
  7317                                  ;    9    1   98 word   getIndReg2
  7318                                  ;   10    2  108 word   setwflag
  7319                                  ;   11    2  119 word   setsflag
  7320                                  ;   12    1    1 word   parse
  7321                                  ;   13   14   27 word   getTokeType
  7322                                  ;   14    2   36 word   storeLabel
  7323                                  ;   15    2   46 word   searchLabel
  7324                                  ;   16    1   57 word   getVariable
  7325                                  ;   17    2   86 word   lookCode
  7326                                  ;   18    1  101 word   getCodeSize
  7327                                  ;   19    8  108 word   isToken
  7328                                  ;   20    1  113 word   need
  7329                                  ;   21    1  123 word   skipRest
  7330                                  ;   22    1    1 word   getLine
  7331                                  ;   23    1   17 word   ifEOL
  7332                                  ;   24    3   24 word   skipBlank
  7333                                  ;   25    2   29 word   letterE
  7334                                  ;   26    1   39 word   alnumE
  7335                                  ;   27    1   44 word   getDigit
  7336                                  ;   28    1   56 word   getName
  7337                                  ;   29    1   75 word   testReg
  7338                                  ;   30    1    1 word   printLine
  7339                                  ;   31    7   22 word   prc
  7340                                  ;   32    1   34 word   prscomment
  7341                                  ;   33   23   42 word   prs
  7342                                  ;   34    3   64 word   printhex8a
  7343                                  ;   35    2   69 word   printhex4
  7344                                  ;   36    1   74 word   printhex16
  7345                                  ;   37    3   79 word   printIntU
  7346                                  ;   38   25   90 word   error1
  7347                                  ;   39   12   98 word   errorexit
  7348                                  ;   40 NULL  102 word   allowederror
  7349                                  ;   41    3  103 word   addrerror
  7350                                  ;   42    1  104 word   immeerror
  7351                                  ;   43    2  105 word   implerror
  7352                                  ;   44    4  106 word   indexerror
  7353                                  ;   45    3  107 word   invaloperror
  7354                                  ;   46    1  108 word   numbererror
  7355                                  ;   47    1  109 word   regmemerror
  7356                                  ;   48    3  110 word   reg16error
  7357                                  ;   49    1  111 word   segregerror
  7358                                  ;   50    4  112 word   syntaxerror
  7359                                  ;   51 NULL  114 word   addrexit
  7360                                  ;   52 NULL  115 word   internexit
  7361                                  ;   53 NULL    1 word   main
  7362                                  ;   54    1    8 word   getarg
  7363                                  ;   55    1   42 word   epilog
  7364                                  ;   56    2   60 word   end1
  7365                                  ;   57    1    2 word   getCodes
  7366                                  ;   58    1    7 word   gen66h
  7367                                  ;   59    5    9 word   genCode2
  7368                                  ;   60   10   13 word   genCodeW
  7369                                  ;   61   20   17 word   genCode8
  7370                                  ;   62    7   28 word   genCode16
  7371                                  ;   63   10   32 word   writeEA
  7372                                  ;   64    4   74 word   genImmediate
  7373                                  ;   65    1   11 word   process
  7374                                  ;   66    4  229 word   writetty
  7375                                  ;   67    8  230 word   cputs
  7376                                  ;   68    2  231 word   toupper
  7377                                  ;   69    3  233 word   strlen
  7378                                  ;   70    6  234 word   strcpy
  7379                                  ;   71    3  236 word   digit
  7380                                  ;   72   35  237 word   eqstr
  7381                                  ;   73    3  240 word   strcat1
  7382                                  ;   74    1  241 word   openR
  7383                                  ;   75    2  242 word   creatR
  7384                                  ;   76    2  243 word   readRL
  7385                                  ;   77    2  244 word   fputcR
  7386                                  ;   78    3  246 word   fcloseR
  7387                                  ;   79    5  247 word   exitR
  7388                                  ;   80    1  249 word   putch
  7389                                  ;   81    4  250 word   DosInt
  7390                                  ;   82 NULL  251 word   LastFunctionByt
  7391                                  
  7392                                  ;    #  addr name   list of CALLs
  7393                                  
  7394                                  ;    0  1360 implerror
  7395                                  ;    1  1370 segregerror
  7396                                  ;    2  1382 setwflag
  7397                                  ;    3  1391 error1
  7398                                  ;    4  1398 error1
  7399                                  ;    5  1415 get2Ops
  7400                                  ;    6  1423 addrerror
  7401                                  ;    7  1433 invaloperror
  7402                                  ;    8  1446 immeerror
  7403                                  ;    9  1456 addrerror
  7404                                  ;   10  1466 invaloperror
  7405                                  ;   11  1479 setwflag
  7406                                  ;   12  1496 getOpL
  7407                                  ;   13  1503 need
  7408                                  ;   14  1508 getOpR
  7409                                  ;   15  1522 getOpR
  7410                                  ;   16  1536 getOp1
  7411                                  ;   17  1543 isToken
  7412                                  ;   18  1551 getMEM
  7413                                  ;   19  1558 invaloperror
  7414                                  ;   20  1571 error1
  7415                                  ;   21  1585 testReg
  7416                                  ;   22  1593 searchLabel
  7417                                  ;   23  1605 error1
  7418                                  ;   24  1621 getTokeType
  7419                                  ;   25  1633 getOp1
  7420                                  ;   26  1640 syntaxerror
  7421                                  ;   27  1652 getIndReg2
  7422                                  ;   28  1663 getIndReg1
  7423                                  ;   29  1674 isToken
  7424                                  ;   30  1682 getTokeType
  7425                                  ;   31  1694 numbererror
  7426                                  ;   32  1706 isToken
  7427                                  ;   33  1714 isToken
  7428                                  ;   34  1722 errorexit
  7429                                  ;   35  1743 indexerror
  7430                                  ;   36  1754 indexerror
  7431                                  ;   37  1778 indexerror
  7432                                  ;   38  1789 indexerror
  7433                                  ;   39  1809 gen66h
  7434                                  ;   40  1828 error1
  7435                                  ;   41  1841 getLine
  7436                                  ;   42  1849 getTokeType
  7437                                  ;   43  1861 storeLabel
  7438                                  ;   44  1872 getTokeType
  7439                                  ;   45  1884 lookCode
  7440                                  ;   46  1893 process
  7441                                  ;   47  1901 getVariable
  7442                                  ;   48  1913 skipRest
  7443                                  ;   49  1922 error1
  7444                                  ;   50  1929 error1
  7445                                  ;   51  1936 printLine
  7446                                  ;   52  1960 skipBlank
  7447                                  ;   53  1970 digit
  7448                                  ;   54  1976 getDigit
  7449                                  ;   55  1985 letterE
  7450                                  ;   56  1993 getName
  7451                                  ;   57  2014 searchLabel
  7452                                  ;   58  2026 error1
  7453                                  ;   59  2033 strcpy
  7454                                  ;   60  2040 errorexit
  7455                                  ;   61  2050 errorexit
  7456                                  ;   62  2080 eqstr
  7457                                  ;   63  2086 strlen
  7458                                  ;   64  2107 storeLabel
  7459                                  ;   65  2118 getTokeType
  7460                                  ;   66  2130 lookCode
  7461                                  ;   67  2139 errorexit
  7462                                  ;   68  2149 errorexit
  7463                                  ;   69  2159 getTokeType
  7464                                  ;   70  2171 genCode8
  7465                                  ;   71  2180 skipBlank
  7466                                  ;   72  2190 isToken
  7467                                  ;   73  2198 genCode8
  7468                                  ;   74  2207 isToken
  7469                                  ;   75  2215 getTokeType
  7470                                  ;   76  2227 genCode16
  7471                                  ;   77  2237 isToken
  7472                                  ;   78  2245 errorexit
  7473                                  ;   79  2264 eqstr
  7474                                  ;   80  2282 eqstr
  7475                                  ;   81  2288 getTokeType
  7476                                  ;   82  2300 eqstr
  7477                                  ;   83  2306 getTokeType
  7478                                  ;   84  2318 eqstr
  7479                                  ;   85  2324 getTokeType
  7480                                  ;   86  2346 skipBlank
  7481                                  ;   87  2363 isToken
  7482                                  ;   88  2371 getTokeType
  7483                                  ;   89  2383 error1
  7484                                  ;   90  2390 prs
  7485                                  ;   91  2394 prc
  7486                                  ;   92  2407 getTokeType
  7487                                  ;   93  2419 error1
  7488                                  ;   94  2436 readRL
  7489                                  ;   95  2443 errorexit
  7490                                  ;   96  2453 errorexit
  7491                                  ;   97  2463 ifEOL
  7492                                  ;   98  2477 readRL
  7493                                  ;   99  2513 digit
  7494                                  ;  100  2519 letterE
  7495                                  ;  101  2546 digit
  7496                                  ;  102  2566 alnumE
  7497                                  ;  103  2573 errorexit
  7498                                  ;  104  2583 strcpy
  7499                                  ;  105  2590 toupper
  7500                                  ;  106  2606 strlen
  7501                                  ;  107  2613 strlen
  7502                                  ;  108  2620 eqstr
  7503                                  ;  109  2626 eqstr
  7504                                  ;  110  2632 eqstr
  7505                                  ;  111  2638 eqstr
  7506                                  ;  112  2644 eqstr
  7507                                  ;  113  2650 eqstr
  7508                                  ;  114  2656 eqstr
  7509                                  ;  115  2662 eqstr
  7510                                  ;  116  2668 eqstr
  7511                                  ;  117  2674 eqstr
  7512                                  ;  118  2680 eqstr
  7513                                  ;  119  2686 eqstr
  7514                                  ;  120  2692 eqstr
  7515                                  ;  121  2698 eqstr
  7516                                  ;  122  2704 eqstr
  7517                                  ;  123  2710 eqstr
  7518                                  ;  124  2716 eqstr
  7519                                  ;  125  2722 eqstr
  7520                                  ;  126  2728 eqstr
  7521                                  ;  127  2734 eqstr
  7522                                  ;  128  2740 eqstr
  7523                                  ;  129  2746 eqstr
  7524                                  ;  130  2752 eqstr
  7525                                  ;  131  2758 eqstr
  7526                                  ;  132  2764 eqstr
  7527                                  ;  133  2770 eqstr
  7528                                  ;  134  2776 eqstr
  7529                                  ;  135  2782 eqstr
  7530                                  ;  136  2788 eqstr
  7531                                  ;  137  2794 eqstr
  7532                                  ;  138  2814 prs
  7533                                  ;  139  2818 printhex16
  7534                                  ;  140  2829 prs
  7535                                  ;  141  2833 prc
  7536                                  ;  142  2837 printhex8a
  7537                                  ;  143  2848 prc
  7538                                  ;  144  2852 prs
  7539                                  ;  145  2856 prscomment
  7540                                  ;  146  2873 writetty
  7541                                  ;  147  2882 writetty
  7542                                  ;  148  2891 fputcR
  7543                                  ;  149  2913 prc
  7544                                  ;  150  2929 prc
  7545                                  ;  151  2950 printhex4
  7546                                  ;  152  2960 printhex4
  7547                                  ;  153  2982 prc
  7548                                  ;  154  3004 printhex8a
  7549                                  ;  155  3015 printhex8a
  7550                                  ;  156  3040 printIntU
  7551                                  ;  157  3050 prc
  7552                                  ;  158  3063 prs
  7553                                  ;  159  3067 prs
  7554                                  ;  160  3071 prs
  7555                                  ;  161  3075 prs
  7556                                  ;  162  3091 error1
  7557                                  ;  163  3098 end1
  7558                                  ;  164  3116 error1
  7559                                  ;  165  3133 error1
  7560                                  ;  166  3150 error1
  7561                                  ;  167  3167 error1
  7562                                  ;  168  3185 error1
  7563                                  ;  169  3205 error1
  7564                                  ;  170  3224 error1
  7565                                  ;  171  3243 error1
  7566                                  ;  172  3261 error1
  7567                                  ;  173  3280 error1
  7568                                  ;  174  3299 error1
  7569                                  ;  175  3315 errorexit
  7570                                  ;  176  3336 errorexit
  7571                                  ;  177  3351 getarg
  7572                                  ;  178  3358 parse
  7573                                  ;  179  3364 epilog
  7574                                  ;  180  3371 end1
  7575                                  ;  181  3395 cputs
  7576                                  ;  182  3401 cputs
  7577                                  ;  183  3407 exitR
  7578                                  ;  184  3413 toupper
  7579                                  ;  185  3421 strcpy
  7580                                  ;  186  3428 strcat1
  7581                                  ;  187  3436 strcpy
  7582                                  ;  188  3443 strcat1
  7583                                  ;  189  3451 strcpy
  7584                                  ;  190  3458 strcat1
  7585                                  ;  191  3466 openR
  7586                                  ;  192  3472 cputs
  7587                                  ;  193  3478 cputs
  7588                                  ;  194  3484 exitR
  7589                                  ;  195  3490 creatR
  7590                                  ;  196  3497 cputs
  7591                                  ;  197  3503 cputs
  7592                                  ;  198  3509 exitR
  7593                                  ;  199  3515 creatR
  7594                                  ;  200  3522 cputs
  7595                                  ;  201  3528 cputs
  7596                                  ;  202  3534 exitR
  7597                                  ;  203  3540 prs
  7598                                  ;  204  3544 prs
  7599                                  ;  205  3548 prs
  7600                                  ;  206  3552 prs
  7601                                  ;  207  3556 prs
  7602                                  ;  208  3560 prs
  7603                                  ;  209  3564 prs
  7604                                  ;  210  3568 prs
  7605                                  ;  211  3572 prs
  7606                                  ;  212  3589 prs
  7607                                  ;  213  3593 printIntU
  7608                                  ;  214  3603 prs
  7609                                  ;  215  3607 prs
  7610                                  ;  216  3611 prs
  7611                                  ;  217  3615 prs
  7612                                  ;  218  3619 printIntU
  7613                                  ;  219  3629 prs
  7614                                  ;  220  3633 fputcR
  7615                                  ;  221  3647 fcloseR
  7616                                  ;  222  3655 fcloseR
  7617                                  ;  223  3663 fcloseR
  7618                                  ;  224  3671 exitR
  7619                                  ;  225  3693 genCode8
  7620                                  ;  226  3715 genCode8
  7621                                  ;  227  3735 genCode8
  7622                                  ;  228  3755 errorexit
  7623                                  ;  229  3777 genCode8
  7624                                  ;  230  3786 genCode8
  7625                                  ;  231  3811 genCode8
  7626                                  ;  232  3820 genCode8
  7627                                  ;  233  3829 genCode16
  7628                                  ;  234  3852 genCode16
  7629                                  ;  235  3862 genCode8
  7630                                  ;  236  3881 getTokeType
  7631                                  ;  237  3893 getCodeSize
  7632                                  ;  238  3905 getCodes
  7633                                  ;  239  3914 genCode8
  7634                                  ;  240  3923 getOpL
  7635                                  ;  241  3930 checkOpL
  7636                                  ;  242  3939 genCode2
  7637                                  ;  243  3948 getTokeType
  7638                                  ;  244  3960 implerror
  7639                                  ;  245  3970 genCodeW
  7640                                  ;  246  3979 writeEA
  7641                                  ;  247  3987 check2Ops
  7642                                  ;  248  3997 reg16error
  7643                                  ;  249  4008 addrerror
  7644                                  ;  250  4018 genCode8
  7645                                  ;  251  4027 genCode8
  7646                                  ;  252  4036 writeEA
  7647                                  ;  253  4044 check2Ops
  7648                                  ;  254  4054 setsflag
  7649                                  ;  255  4063 genCodeW
  7650                                  ;  256  4072 genImmediate
  7651                                  ;  257  4085 genCodeW
  7652                                  ;  258  4094 writeEA
  7653                                  ;  259  4102 genCode8
  7654                                  ;  260  4111 genImmediate
  7655                                  ;  261  4124 genCodeW
  7656                                  ;  262  4133 writeEA
  7657                                  ;  263  4141 genCodeW
  7658                                  ;  264  4150 writeEA
  7659                                  ;  265  4158 syntaxerror
  7660                                  ;  266  4170 check2Ops
  7661                                  ;  267  4180 genCode2
  7662                                  ;  268  4189 genImmediate
  7663                                  ;  269  4202 genCodeW
  7664                                  ;  270  4211 writeEA
  7665                                  ;  271  4219 genImmediate
  7666                                  ;  272  4232 regmemerror
  7667                                  ;  273  4244 ChangeDirection
  7668                                  ;  274  4260 reg16error
  7669                                  ;  275  4271 genCode2
  7670                                  ;  276  4280 writeEA
  7671                                  ;  277  4288 genCodeW
  7672                                  ;  278  4297 genCode16
  7673                                  ;  279  4307 genCodeW
  7674                                  ;  280  4316 genCode16
  7675                                  ;  281  4326 genCodeW
  7676                                  ;  282  4335 writeEA
  7677                                  ;  283  4343 ChangeDirection
  7678                                  ;  284  4359 genCodeW
  7679                                  ;  285  4368 writeEA
  7680                                  ;  286  4376 syntaxerror
  7681                                  ;  287  4388 genCode8
  7682                                  ;  288  4397 genCode16
  7683                                  ;  289  4407 genCode8
  7684                                  ;  290  4416 getOpL
  7685                                  ;  291  4423 setsflag
  7686                                  ;  292  4432 genCode2
  7687                                  ;  293  4441 genCode8
  7688                                  ;  294  4450 genCode16
  7689                                  ;  295  4460 error1
  7690                                  ;  296  4467 genCode8
  7691                                  ;  297  4476 genCode8
  7692                                  ;  298  4485 checkOpL
  7693                                  ;  299  4494 reg16error
  7694                                  ;  300  4505 genCode2
  7695                                  ;  301  4514 genCode8
  7696                                  ;  302  4523 writeEA
  7697                                  ;  303  4531 syntaxerror
  7698                                  ;  304  4543 error1
  7699                                  ;  305  4550 error1
  7700                                  ;  306  4576 putch
  7701                                  ;  307  4644 strcpy
  7702                                  ;  308  4659 DosInt
  7703                                  ;  309  4675 DosInt
  7704                                  ;  310  4698 DosInt
  7705                                  ;  311  4717 DosInt
  7706                                  ;  312  4751 writetty
  7707                                  ;  313  4760 writetty
  7708                                  ;Input: AS.C, List: AS.S,  Lines:  252
  7709                                  ;Glob. variables:  193 max.:  200
  7710                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7711                                  ;Functions      :   83 max.:  300
  7712                                  ;Calls          :  314 max.: 2000, NameField: 4792 max.:    65535
  7713                                  ;Code until     :25998 max.: 30000, free: 4002
  7714                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7715                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
