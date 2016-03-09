     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E92B28                  jmp main
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
   396                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   397                                  
   398 00000F18 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   399                                  
   400                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   401                                  
   402 00000F20 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   403                                  
   404                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   405                                  
   406 00000F28 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   407                                  
   408                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   409                                  
   410 00000F30 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   411                                  
   412                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   413                                  
   414 00000F38 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   415                                  
   416                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   417                                  
   418 00000F40 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   419                                  
   420                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   421                                  
   422 00000F49 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   423                                  
   424                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   425                                  
   426 00000F52 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   427                                  
   428                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   429                                  
   430 00000F5A 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   431                                  
   432                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   433                                  
   434 00000F62 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   435                                  
   436                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   437                                  
   438 00000F69 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   439                                  
   440                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   441                                  
   442 00000F70 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   443                                  
   444                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   445                                  
   446 00000F77 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   447                                  
   448                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   449                                  
   450 00000F7E 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   451                                  
   452                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   453                                  
   454 00000F85 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   455                                  
   456                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   457                                  
   458 00000F8C 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   459                                  
   460                                  ;-43 // 2: mem reg 16 bit
   461                                  
   462                                  
   463                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   464                                  
   465 00000F93 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   466                                  
   467                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   468                                  
   469 00000F9C 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   470                                  
   471                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   472                                  
   473 00000FA5 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   474                                  
   475                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   476                                  
   477 00000FAD 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   478                                  
   479                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   480                                  
   481 00000FB5 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   482                                  
   483                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   484                                  
   485 00000FBD 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   486                                  
   487                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   488                                  
   489 00000FC6 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   490                                  
   491                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   492                                  
   493 00000FCE 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   494                                  
   495                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   496                                  
   497                                  
   498                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   499                                  
   500 00000FD7 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   501                                  
   502                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   503                                  
   504 00000FDE 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   505                                  
   506                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   507                                  
   508 00000FE5 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   509                                  
   510                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   511                                  
   512 00000FEC 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   513                                  
   514                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   515                                  
   516 00000FF4 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   517                                  
   518                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   519                                  
   520 00000FFC 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   521                                  
   522                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   523                                  
   524                                  
   525                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   526                                  
   527 00001004 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   528                                  
   529                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   530                                  
   531 0000100B 4F52000401F1            I_OR db 79,82,0,4,1,241
   532                                  
   533                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   534                                  
   535 00001011 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   536                                  
   537                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   538                                  
   539 00001018 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   540                                  
   541                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   542                                  
   543 0000101F 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   544                                  
   545                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   546                                  
   547 00001026 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   548                                  
   549                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   550                                  
   551 0000102D 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   552                                  
   553                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   554                                  
   555 00001034 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   556                                  
   557                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   558                                  
   559 0000103B 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   560 00001044 00F1               
   561                                  
   562                                  ;-69 //  5: mov
   563                                  
   564                                  
   565                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   566                                  
   567 00001046 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   568                                  
   569                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   570                                  
   571 0000104C 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   572                                  
   573                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   574                                  
   575 00001055 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   576                                  
   577                                  ;-73 //  6: single byte relative jump
   578                                  
   579                                  
   580                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   581                                  
   582 0000105E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   583                                  
   584                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   585                                  
   586 00001064 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   587                                  
   588                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   589                                  
   590 0000106B 4A42000602F1            I_JB db 74,66,0,6,2,241
   591                                  
   592                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   593                                  
   594 00001071 4A43000602F1            I_JC db 74,67,0,6,2,241
   595                                  
   596                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   597                                  
   598 00001077 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   599                                  
   600                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   601                                  
   602 0000107E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   603                                  
   604                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   605                                  
   606 00001085 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   607                                  
   608                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   609                                  
   610 0000108C 4A45000604F1            I_JE db 74,69,0,6,4,241
   611                                  
   612                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   613                                  
   614 00001092 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   615                                  
   616                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   617                                  
   618 00001098 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   619                                  
   620                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   621                                  
   622 0000109F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   623                                  
   624                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   625                                  
   626 000010A6 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   627                                  
   628                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   629                                  
   630 000010AD 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   631                                  
   632                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   633                                  
   634 000010B4 4A41000607F1            I_JA db 74,65,0,6,7,241
   635                                  
   636                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   637                                  
   638 000010BA 4A53000608F1            I_JS db 74,83,0,6,8,241
   639                                  
   640                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   641                                  
   642 000010C0 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   643                                  
   644                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   645                                  
   646 000010C7 4A5000060AF1            I_JP db 74,80,0,6,10,241
   647                                  
   648                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   649                                  
   650 000010CD 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   651                                  
   652                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   653                                  
   654 000010D4 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   655                                  
   656                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   657                                  
   658 000010DB 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   659                                  
   660                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   661                                  
   662 000010E2 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   663                                  
   664                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   665                                  
   666 000010E8 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   667                                  
   668                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   669                                  
   670 000010EF 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   671                                  
   672                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   673                                  
   674 000010F6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   675                                  
   676                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   677                                  
   678 000010FD 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   679                                  
   680                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   681                                  
   682 00001104 4A4700060FF1            I_JG db 74,71,0,6,15,241
   683                                  
   684                                  ;-100 //  7: jmp, call
   685                                  
   686                                  
   687                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   688                                  
   689 0000110A 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   690                                  
   691                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   692                                  
   693 00001112 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   694                                  
   695                                  ;-103 //  8: ret
   696                                  
   697                                  
   698                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   699                                  
   700 0000111B 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   701                                  
   702                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   703                                  
   704 00001123 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   705                                  
   706                                  ;-106 //  9: seg, r/m
   707                                  
   708                                  
   709                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   710                                  
   711 0000112C 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   712 00001135 06F1               
   713                                  
   714                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   715                                  
   716 00001137 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   717 00001140 F1                 
   718                                  
   719                                  ;-109 //  11: shift, rotates
   720                                  
   721                                  
   722                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   723                                  
   724 00001141 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   725                                  
   726                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   727                                  
   728 00001148 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   729                                  
   730                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   731                                  
   732 0000114F 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   733                                  
   734                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   735                                  
   736 00001156 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   737                                  
   738                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   739                                  
   740 0000115D 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   741                                  
   742                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   743                                  
   744 00001164 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   745                                  
   746                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   747                                  
   748 0000116B 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   749                                  
   750                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   751                                  
   752 00001172 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   753                                  
   754                                  ;-118 //  12: int
   755                                  
   756                                  
   757                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   758                                  
   759 00001179 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   760                                  
   761                                  ;-120 //  14: in/out
   762                                  
   763                                  
   764                                  ;-121 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   765                                  
   766                                  
   767                                  ;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   768                                  
   769                                  
   770                                  ;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   771                                  
   772                                  
   773                                  ;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   774                                  
   775                                  
   776                                  ;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   777                                  
   778                                  
   779                                  ;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   780                                  
   781                                  
   782                                  ;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   783                                  
   784                                  
   785                                  ;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   786                                  
   787                                  
   788                                  ;-129 //  15: xchg
   789                                  
   790                                  
   791                                  ;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   792                                  
   793 00001181 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   794                                  
   795                                  ;-131 //  16: loop, jcxz
   796                                  
   797                                  
   798                                  ;-132 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   799                                  
   800 0000118A 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   801 00001193 F1                 
   802                                  
   803                                  ;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   804                                  
   805 00001194 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   806 0000119D F1                 
   807                                  
   808                                  ;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   809                                  
   810 0000119E 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   811                                  
   812                                  ;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   813                                  
   814 000011A7 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   815                                  
   816                                  ;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   817                                  
   818 000011B0 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   819                                  
   820                                  ;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   821                                  
   822 000011B8 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   823                                  
   824                                  ;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   825                                  
   826 000011C0 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   827                                  
   828                                  ;-139 //  30: enter
   829                                  
   830                                  
   831                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   832                                  
   833 000011C9 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   834                                  
   835                                  ;-141 // 100: directives
   836                                  
   837                                  
   838                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   839                                  
   840 000011D2 4F52470065F1            I_ORG db 79,82,71,0,101,241
   841                                  
   842                                  ;-143 // section, segment .TEXT .DATA .BSS
   843                                  
   844                                  
   845                                  ;-144 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   846                                  
   847                                  
   848                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   849                                  
   850                                  
   851                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   852                                  
   853                                  
   854                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   855                                  
   856 000011D8 444200C8F1              I_DB db 68,66,0,200,241
   857                                  
   858                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   859                                  
   860 000011DD 445700C9F1              I_DW db 68,87,0,201,241
   861                                  
   862                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   863                                  
   864 000011E2 444400CAF1              I_DD db 68,68,0,202,241
   865                                  
   866                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   867                                  
   868 000011E7 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   869                                  
   870                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   871                                  
   872 000011EE 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   873                                  
   874                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   875                                  
   876 000011F5 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   877                                  
   878                                  ;-153 char I_END=0;// end of table char
   879                                  
   880 000011FC 00                      I_END db 0
   881                                  ;Back to main program: AS.C
   882                                  
   883                                  ;-4 #include "OPS.C"
   884                                  
   885                                  ;Use include file: OPS.C
   886                                  
   887                                  ;-1 int ChangeDirection() {
   888                                  
   889                                  
   890                                  ChangeDirection:  ; *** PROC ***
   891                                  
   892                                  ;-2     char c;
   893                                  
   894                                  
   895                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   896                                  
   897                                  ;Function : ChangeDirection, Number of local variables: 1
   898                                  ;   # type sign width line used address name   list of local variables
   899                                  ;  200 var sign byte     2 NULL bp-2    c;
   900 000011FD C8020000                 ENTER  2,0
   901 00001201 A0[AC01]                 mov al, [Op]
   902 00001204 8846FE                   mov byte [bp-2], al
   903 00001207 A0[AD01]                 mov al, [Op2]
   904 0000120A A2[AC01]                 mov byte [Op], al
   905 0000120D 8A46FE                   mov al, [bp-2]
   906 00001210 A2[AD01]                 mov byte [Op2], al
   907                                  
   908                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   909                                  
   910 00001213 A0[B501]                 mov al, [R1Type]
   911 00001216 8846FE                   mov byte [bp-2], al
   912 00001219 A0[B401]                 mov al, [R2Type]
   913 0000121C A2[B501]                 mov byte [R1Type], al
   914 0000121F 8A46FE                   mov al, [bp-2]
   915 00001222 A2[B401]                 mov byte [R2Type], al
   916                                  
   917                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   918                                  
   919 00001225 A0[B301]                 mov al, [R1No]
   920 00001228 8846FE                   mov byte [bp-2], al
   921 0000122B A0[B201]                 mov al, [R2No]
   922 0000122E A2[B301]                 mov byte [R1No], al
   923 00001231 8A46FE                   mov al, [bp-2]
   924 00001234 A2[B201]                 mov byte [R2No], al
   925                                  
   926                                  ;-6     dflag=2;     
   927                                  
   928 00001237 66B802000000             mov eax, 2
   929 0000123D A2[B801]                 mov byte [dflag], al
   930                                  
   931                                  ;-7 }
   932                                  
   933                                  
   934                                  ;-8      
   935                                  
   936                                  
   937                                  ;-9 int checkOpL() {
   938 00001240 C9                       LEAVE
   939 00001241 C3                       ret
   940                                  ; ENDP
   941                                  
   942                                  checkOpL:  ; *** PROC ***
   943                                  
   944                                  ;-10     if (Op == ADR) implerror();
   945                                  
   946 00001242 A0[AC01]                 mov al, [Op]
   947 00001245 3C03                     cmp al, 3
   948 00001247 0F850300                 jne @@checkOpL1
   949 0000124B E8A614                   call implerror
   950                                  
   951                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   952                                  
   953                                  @@checkOpL1:
   954 0000124E A0[B501]                 mov al, [R1Type]
   955 00001251 3C04                     cmp al, 4
   956 00001253 0F850600                 jne @@checkOpL2
   957 00001257 E86215                   call segregerror
   958 0000125A E93E00                   jmp @@retn
   959                                  
   960                                  ;-12     setwflag();
   961                                  
   962                                  @@checkOpL2:
   963 0000125D E8CB03                   call setwflag
   964                                  
   965                                  ;-13     if (OpSize == 0) error1("no op size declared");
   966                                  
   967 00001260 A0[B601]                 mov al, [OpSize]
   968 00001263 3C00                     cmp al, 0
   969 00001265 0F850900                 jne @@checkOpL3
   970 00001269 68[9C12]                 push checkOpL_0
   971 0000126C E8B513                   call error1
   972 0000126F 83C402                   add  sp, 2
   973                                  
   974                                  ;-14     if (OpSize == R1Type) return;
   975                                  
   976                                  @@checkOpL3:
   977 00001272 A0[B601]                 mov al, [OpSize]
   978 00001275 3A06[B501]               cmp al, [R1Type]
   979 00001279 0F850300                 jne @@checkOpL4
   980 0000127D E91B00                   jmp @@retn
   981                                  
   982                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
   983                                  
   984                                  @@checkOpL4:
   985 00001280 A0[AC01]                 mov al, [Op]
   986 00001283 3C02                     cmp al, 2
   987 00001285 0F851200                 jne @@checkOpL5
   988 00001289 A0[B501]                 mov al, [R1Type]
   989 0000128C 3C00                     cmp al, 0
   990 0000128E 0F850900                 jne @@checkOpL6
   991 00001292 68[B012]                 push checkOpL_1
   992 00001295 E88C13                   call error1
   993 00001298 83C402                   add  sp, 2
   994                                  
   995                                  ;-16 }
   996                                  
   997                                  @@checkOpL6:
   998                                  @@checkOpL5:
   999                                  
  1000                                  ;-17     
  1001                                  
  1002                                  
  1003                                  ;-18 int check2Ops() {
  1004                                  
  1005                                  @@retn:
  1006 0000129B C3                       ret
  1007                                  ; ENDP
  1008 0000129C 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1009 000012A5 65206465636C617265-
  1010 000012AE 6400               
  1011 000012B0 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1012 000012B9 657220646566696E65-
  1013 000012C2 6400               
  1014                                  
  1015                                  check2Ops:  ; *** PROC ***
  1016                                  
  1017                                  ;-19     get2Ops();
  1018                                  
  1019 000012C4 E84900                   call get2Ops
  1020                                  
  1021                                  ;-20     if (Op ==   0) addrerror();
  1022                                  
  1023 000012C7 A0[AC01]                 mov al, [Op]
  1024 000012CA 3C00                     cmp al, 0
  1025 000012CC 0F850300                 jne @@check2Ops7
  1026 000012D0 E8E213                   call addrerror
  1027                                  
  1028                                  ;-21     if (Op == ADR) invaloperror(); 
  1029                                  
  1030                                  @@check2Ops7:
  1031 000012D3 A0[AC01]                 mov al, [Op]
  1032 000012D6 3C03                     cmp al, 3
  1033 000012D8 0F850300                 jne @@check2Ops8
  1034 000012DC E85014                   call invaloperror
  1035                                  
  1036                                  ;-22     if (Op == IMM) immeerror();   
  1037                                  
  1038                                  @@check2Ops8:
  1039 000012DF A0[AC01]                 mov al, [Op]
  1040 000012E2 3C01                     cmp al, 1
  1041 000012E4 0F850300                 jne @@check2Ops9
  1042 000012E8 E8E413                   call immeerror
  1043                                  
  1044                                  ;-23     if (Op2==   0) addrerror();
  1045                                  
  1046                                  @@check2Ops9:
  1047 000012EB A0[AD01]                 mov al, [Op2]
  1048 000012EE 3C00                     cmp al, 0
  1049 000012F0 0F850300                 jne @@check2Ops10
  1050 000012F4 E8BE13                   call addrerror
  1051                                  
  1052                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1053                                  
  1054                                  @@check2Ops10:
  1055 000012F7 A0[AE01]                 mov al, [CodeType]
  1056 000012FA 3C05                     cmp al, 5
  1057 000012FC 0F840C00                 je  @@check2Ops11
  1058 00001300 A0[AD01]                 mov al, [Op2]
  1059 00001303 3C03                     cmp al, 3
  1060 00001305 0F850300                 jne @@check2Ops12
  1061 00001309 E82314                   call invaloperror
  1062                                  
  1063                                  ;-25     setwflag();       
  1064                                  
  1065                                  @@check2Ops12:
  1066                                  @@check2Ops11:
  1067 0000130C E81C03                   call setwflag
  1068                                  
  1069                                  ;-26 }    
  1070                                  
  1071                                  
  1072                                  ;-27 int get2Ops() {
  1073                                  
  1074 0000130F C3                       ret
  1075                                  ; ENDP
  1076                                  
  1077                                  get2Ops:  ; *** PROC ***
  1078                                  
  1079                                  ;-28     getOpL();
  1080                                  
  1081 00001310 E80C00                   call getOpL
  1082                                  
  1083                                  ;-29     need(',');    
  1084                                  
  1085 00001313 6A2C                     push 44
  1086 00001315 E8E208                   call need
  1087 00001318 83C402                   add  sp, 2
  1088                                  
  1089                                  ;-30     getOpR();         
  1090                                  
  1091 0000131B E83200                   call getOpR
  1092                                  
  1093                                  ;-31 } 
  1094                                  
  1095                                  
  1096                                  ;-32         
  1097                                  
  1098                                  
  1099                                  ;-33 int getOpL() {
  1100                                  
  1101 0000131E C3                       ret
  1102                                  ; ENDP
  1103                                  
  1104                                  getOpL:  ; *** PROC ***
  1105                                  
  1106                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1107                                  
  1108                                  
  1109                                  ;-35     getOpR();
  1110                                  
  1111 0000131F E82E00                   call getOpR
  1112                                  
  1113                                  ;-36     Op=Op2;         Op2=0;
  1114                                  
  1115 00001322 A0[AD01]                 mov al, [Op2]
  1116 00001325 A2[AC01]                 mov byte [Op], al
  1117 00001328 66B800000000             mov eax, 0
  1118 0000132E A2[AD01]                 mov byte [Op2], al
  1119                                  
  1120                                  ;-37     R1No=R2No;      R2No=0;
  1121                                  
  1122 00001331 A0[B201]                 mov al, [R2No]
  1123 00001334 A2[B301]                 mov byte [R1No], al
  1124 00001337 66B800000000             mov eax, 0
  1125 0000133D A2[B201]                 mov byte [R2No], al
  1126                                  
  1127                                  ;-38     R1Type=R2Type; R2Type=0; 
  1128                                  
  1129 00001340 A0[B401]                 mov al, [R2Type]
  1130 00001343 A2[B501]                 mov byte [R1Type], al
  1131 00001346 66B800000000             mov eax, 0
  1132 0000134C A2[B401]                 mov byte [R2Type], al
  1133                                  
  1134                                  ;-39 }  
  1135                                  
  1136                                  
  1137                                  ;-40 
  1138                                  
  1139                                  
  1140                                  ;-41 int getOpR() {
  1141                                  
  1142 0000134F C3                       ret
  1143                                  ; ENDP
  1144                                  
  1145                                  getOpR:  ; *** PROC ***
  1146                                  
  1147                                  ;-42     Op2=getOp1();
  1148                                  
  1149 00001350 E88900                   call getOp1
  1150 00001353 A2[AD01]                 mov byte [Op2], al
  1151                                  
  1152                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1153                                  
  1154 00001356 6A5B                     push 91
  1155 00001358 E87108                   call isToken
  1156 0000135B 83C402                   add  sp, 2
  1157 0000135E 08C0                     or  al, al
  1158 00001360 0F840F00                 je @@getOpR13
  1159 00001364 66B804000000             mov eax, 4
  1160 0000136A A2[AD01]                 mov byte [Op2], al
  1161 0000136D E8F200                   call getMEM
  1162 00001370 E94F00                   jmp @@retn
  1163                                  
  1164                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1165                                  
  1166                                  @@getOpR13:
  1167 00001373 A0[AD01]                 mov al, [Op2]
  1168 00001376 3C00                     cmp al, 0
  1169 00001378 0F850600                 jne @@getOpR14
  1170 0000137C E8B013                   call invaloperror
  1171 0000137F E94000                   jmp @@retn
  1172                                  
  1173                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1174                                  
  1175                                  @@getOpR14:
  1176 00001382 A0[AD01]                 mov al, [Op2]
  1177 00001385 3C01                     cmp al, 1
  1178 00001387 0F850900                 jne @@getOpR15
  1179 0000138B A1[4D00]                 mov ax, [SymbolInt]
  1180 0000138E A3[BE01]                 mov word [imme], ax
  1181 00001391 E92E00                   jmp @@retn
  1182                                  
  1183                                  ;-46     if (Op2 == REG)                            return;
  1184                                  
  1185                                  @@getOpR15:
  1186 00001394 A0[AD01]                 mov al, [Op2]
  1187 00001397 3C02                     cmp al, 2
  1188 00001399 0F850300                 jne @@getOpR16
  1189 0000139D E92200                   jmp @@retn
  1190                                  
  1191                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1192                                  
  1193                                  @@getOpR16:
  1194 000013A0 A0[AD01]                 mov al, [Op2]
  1195 000013A3 3C03                     cmp al, 3
  1196 000013A5 0F851000                 jne @@getOpR17
  1197 000013A9 8B1E[7E06]               mov bx, [LabelIx]
  1198 000013AD D1E3                     shl bx, 1
  1199 000013AF 8B87[B405]               mov ax, [LabelAddr + bx]
  1200 000013B3 A3[BC01]                 mov word [disp], ax
  1201 000013B6 E90900                   jmp @@retn
  1202                                  
  1203                                  ;-48     error1("Name of operand expected");
  1204                                  
  1205                                  @@getOpR17:
  1206 000013B9 68[C313]                 push getOpR_0
  1207 000013BC E86512                   call error1
  1208 000013BF 83C402                   add  sp, 2
  1209                                  
  1210                                  ;-49 }
  1211                                  
  1212                                  
  1213                                  ;-50 
  1214                                  
  1215                                  
  1216                                  ;-51 int getOp1() {//scan for a single operand
  1217                                  
  1218                                  @@retn:
  1219 000013C2 C3                       ret
  1220                                  ; ENDP
  1221 000013C3 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1222 000013CC 706572616E64206578-
  1223 000013D5 70656374656400     
  1224                                  
  1225                                  getOp1:  ; *** PROC ***
  1226                                  
  1227                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1228                                  
  1229                                  
  1230                                  ;-53 //set   :R2Type, R2No by testReg
  1231                                  
  1232                                  
  1233                                  ;-54 //set   :LabelIx by searchLabel
  1234                                  
  1235                                  
  1236                                  ;-55     if (TokeType == 0)      return 0;
  1237                                  
  1238 000013DC A0[AB01]                 mov al, [TokeType]
  1239 000013DF 3C00                     cmp al, 0
  1240 000013E1 0F850900                 jne @@getOp118
  1241 000013E5 66B800000000             mov eax, 0
  1242 000013EB E96000                   jmp @@retn
  1243                                  
  1244                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1245                                  
  1246                                  @@getOp118:
  1247 000013EE A0[AB01]                 mov al, [TokeType]
  1248 000013F1 3C01                     cmp al, 1
  1249 000013F3 0F850900                 jne @@getOp119
  1250 000013F7 66B801000000             mov eax, 1
  1251 000013FD E94E00                   jmp @@retn
  1252                                  
  1253                                  ;-57     if (TokeType == ALNUME) {
  1254                                  
  1255                                  @@getOp119:
  1256 00001400 A0[AB01]                 mov al, [TokeType]
  1257 00001403 3C03                     cmp al, 3
  1258 00001405 0F853C00                 jne @@getOp120
  1259                                  
  1260                                  ;-58         R2No=testReg();
  1261                                  
  1262 00001409 E86D0B                   call testReg
  1263 0000140C A2[B201]                 mov byte [R2No], al
  1264                                  
  1265                                  ;-59         if (R2Type)        return REG;
  1266                                  
  1267 0000140F A0[B401]                 mov al, [R2Type]
  1268 00001412 08C0                     or  al, al
  1269 00001414 0F840900                 je @@getOp121
  1270 00001418 66B802000000             mov eax, 2
  1271 0000141E E92D00                   jmp @@retn
  1272                                  
  1273                                  ;-60         LabelIx=searchLabel();
  1274                                  
  1275                                  @@getOp121:
  1276 00001421 E81305                   call searchLabel
  1277 00001424 A3[7E06]                 mov word [LabelIx], ax
  1278                                  
  1279                                  ;-61         if (LabelIx)        return ADR;
  1280                                  
  1281 00001427 A1[7E06]                 mov ax, [LabelIx]
  1282 0000142A 08C0                     or  al, al
  1283 0000142C 0F840C00                 je @@getOp122
  1284 00001430 66B803000000             mov eax, 3
  1285 00001436 E91500                   jmp @@retn
  1286                                  
  1287                                  ;-62         else error1("variable not found"); 
  1288                                  
  1289 00001439 E90900                   jmp @@getOp123
  1290                                  @@getOp122:
  1291 0000143C 68[4F14]                 push getOp1_0
  1292 0000143F E8E211                   call error1
  1293 00001442 83C402                   add  sp, 2
  1294                                  
  1295                                  ;-63     }
  1296                                  
  1297                                  @@getOp123:
  1298                                  
  1299                                  ;-64     return 0;
  1300                                  
  1301                                  @@getOp120:
  1302 00001445 66B800000000             mov eax, 0
  1303 0000144B E90000                   jmp @@retn
  1304                                  
  1305                                  ;-65 }
  1306                                  
  1307                                  
  1308                                  ;-66 
  1309                                  
  1310                                  
  1311                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1312                                  
  1313                                  @@retn:
  1314 0000144E C3                       ret
  1315                                  ; ENDP
  1316 0000144F 7661726961626C6520-     getOp1_0 db "variable not found",0
  1317 00001458 6E6F7420666F756E64-
  1318 00001461 00                 
  1319                                  
  1320                                  getMEM:  ; *** PROC ***
  1321                                  
  1322                                  ;-68 //set: disp, rm, R2Type
  1323                                  
  1324                                  
  1325                                  ;-69     char c;
  1326                                  
  1327                                  
  1328                                  ;-70     disp=0; rm=0;
  1329                                  
  1330                                  ;Function : getMEM, Number of local variables: 1
  1331                                  ;   # type sign width line used address name   list of local variables
  1332                                  ;  200 var sign byte    69 NULL bp-2    c;
  1333 00001462 C8020000                 ENTER  2,0
  1334 00001466 66B800000000             mov eax, 0
  1335 0000146C A3[BC01]                 mov word [disp], ax
  1336 0000146F 66B800000000             mov eax, 0
  1337 00001475 A2[BA01]                 mov byte [rm], al
  1338                                  
  1339                                  ;-71     do {
  1340                                  
  1341                                  @@getMEM24:
  1342                                  
  1343                                  ;-72         getTokeType();
  1344                                  
  1345 00001478 E87B03                   call getTokeType
  1346                                  
  1347                                  ;-73         c=getOp1();
  1348                                  
  1349 0000147B E85EFF                   call getOp1
  1350 0000147E 8846FE                   mov byte [bp-2], al
  1351                                  
  1352                                  ;-74         if (c ==   0) syntaxerror();
  1353                                  
  1354 00001481 8A46FE                   mov al, [bp-2]
  1355 00001484 3C00                     cmp al, 0
  1356 00001486 0F850300                 jne @@getMEM25
  1357 0000148A E85613                   call syntaxerror
  1358                                  
  1359                                  ;-75         if (c == REG) {
  1360                                  
  1361                                  @@getMEM25:
  1362 0000148D 8A46FE                   mov al, [bp-2]
  1363 00001490 3C02                     cmp al, 2
  1364 00001492 0F851E00                 jne @@getMEM26
  1365                                  
  1366                                  ;-76             isDirect=0;
  1367                                  
  1368 00001496 66B800000000             mov eax, 0
  1369 0000149C A2[BB01]                 mov byte [isDirect], al
  1370                                  
  1371                                  ;-77             if (rm) rm=getIndReg2();
  1372                                  
  1373 0000149F A0[BA01]                 mov al, [rm]
  1374 000014A2 08C0                     or  al, al
  1375 000014A4 0F840900                 je @@getMEM27
  1376 000014A8 E8F300                   call getIndReg2
  1377 000014AB A2[BA01]                 mov byte [rm], al
  1378                                  
  1379                                  ;-78             else getIndReg1();
  1380                                  
  1381 000014AE E90300                   jmp @@getMEM28
  1382                                  @@getMEM27:
  1383 000014B1 E88900                   call getIndReg1
  1384                                  
  1385                                  ;-79         }
  1386                                  
  1387                                  @@getMEM28:
  1388                                  
  1389                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1390                                  
  1391                                  @@getMEM26:
  1392 000014B4 8A46FE                   mov al, [bp-2]
  1393 000014B7 3C03                     cmp al, 3
  1394 000014B9 0F851000                 jne @@getMEM29
  1395 000014BD A1[BC01]                 mov ax, [disp]
  1396 000014C0 8B1E[7E06]               mov bx, [LabelIx]
  1397 000014C4 D1E3                     shl bx, 1
  1398 000014C6 0387[B405]               add ax, [LabelAddr + bx]
  1399 000014CA A3[BC01]                 mov word [disp], ax
  1400                                  
  1401                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1402                                  
  1403                                  @@getMEM29:
  1404 000014CD 8A46FE                   mov al, [bp-2]
  1405 000014D0 3C01                     cmp al, 1
  1406 000014D2 0F850A00                 jne @@getMEM30
  1407 000014D6 A1[BC01]                 mov ax, [disp]
  1408 000014D9 0306[4D00]               add ax, [SymbolInt]
  1409 000014DD A3[BC01]                 mov word [disp], ax
  1410                                  
  1411                                  ;-82         if (isToken('-')) {
  1412                                  
  1413                                  @@getMEM30:
  1414 000014E0 6A2D                     push 45
  1415 000014E2 E8E706                   call isToken
  1416 000014E5 83C402                   add  sp, 2
  1417 000014E8 08C0                     or  al, al
  1418 000014EA 0F841900                 je @@getMEM31
  1419                                  
  1420                                  ;-83             getTokeType();
  1421                                  
  1422 000014EE E80503                   call getTokeType
  1423                                  
  1424                                  ;-84             if (TokeType != DIGIT) numbererror();
  1425                                  
  1426 000014F1 A0[AB01]                 mov al, [TokeType]
  1427 000014F4 3C01                     cmp al, 1
  1428 000014F6 0F840300                 je  @@getMEM32
  1429 000014FA E85312                   call numbererror
  1430                                  
  1431                                  ;-85             disp = disp - SymbolInt;
  1432                                  
  1433                                  @@getMEM32:
  1434 000014FD A1[BC01]                 mov ax, [disp]
  1435 00001500 2B06[4D00]               sub ax, [SymbolInt]
  1436 00001504 A3[BC01]                 mov word [disp], ax
  1437                                  
  1438                                  ;-86         }
  1439                                  
  1440                                  
  1441                                  ;-87     } while (isToken('+'));
  1442                                  
  1443                                  @@getMEM31:
  1444 00001507 6A2B                     push 43
  1445 00001509 E8C006                   call isToken
  1446 0000150C 83C402                   add  sp, 2
  1447 0000150F 08C0                     or  al, al
  1448 00001511 0F840300                 je @@getMEM33
  1449 00001515 E960FF                   jmp @@getMEM24
  1450                                  @@getMEM33:
  1451                                  
  1452                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1453                                  
  1454 00001518 6A5D                     push 93
  1455 0000151A E8AF06                   call isToken
  1456 0000151D 83C402                   add  sp, 2
  1457 00001520 83F800                   cmp ax, 0
  1458 00001523 0F850900                 jne @@getMEM34
  1459 00001527 68[3215]                 push getMEM_0
  1460 0000152A E85611                   call errorexit
  1461 0000152D 83C402                   add  sp, 2
  1462                                  
  1463                                  ;-89 }
  1464                                  
  1465                                  @@getMEM34:
  1466                                  
  1467                                  ;-90 int getIndReg1() {
  1468 00001530 C9                       LEAVE
  1469 00001531 C3                       ret
  1470                                  ; ENDP
  1471 00001532 5D2065787065637465-     getMEM_0 db "] expected",0
  1472 0000153B 6400               
  1473                                  
  1474                                  getIndReg1:  ; *** PROC ***
  1475                                  
  1476                                  ;-91     if (R2Type !=WORD) indexerror();
  1477                                  
  1478 0000153D A0[B401]                 mov al, [R2Type]
  1479 00001540 3C02                     cmp al, 2
  1480 00001542 0F840300                 je  @@getIndReg135
  1481 00001546 E8C511                   call indexerror
  1482                                  
  1483                                  ;-92     if (R2No==3) rm=7;//BX
  1484                                  
  1485                                  @@getIndReg135:
  1486 00001549 A0[B201]                 mov al, [R2No]
  1487 0000154C 3C03                     cmp al, 3
  1488 0000154E 0F850900                 jne @@getIndReg136
  1489 00001552 66B807000000             mov eax, 7
  1490 00001558 A2[BA01]                 mov byte [rm], al
  1491                                  
  1492                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1493                                  
  1494                                  @@getIndReg136:
  1495 0000155B A0[B201]                 mov al, [R2No]
  1496 0000155E 3C05                     cmp al, 5
  1497 00001560 0F850900                 jne @@getIndReg137
  1498 00001564 66B806000000             mov eax, 6
  1499 0000156A A2[BA01]                 mov byte [rm], al
  1500                                  
  1501                                  ;-94     if (R2No==7) rm=5;//DI
  1502                                  
  1503                                  @@getIndReg137:
  1504 0000156D A0[B201]                 mov al, [R2No]
  1505 00001570 3C07                     cmp al, 7
  1506 00001572 0F850900                 jne @@getIndReg138
  1507 00001576 66B805000000             mov eax, 5
  1508 0000157C A2[BA01]                 mov byte [rm], al
  1509                                  
  1510                                  ;-95     if (R2No==6) rm=4;//SI
  1511                                  
  1512                                  @@getIndReg138:
  1513 0000157F A0[B201]                 mov al, [R2No]
  1514 00001582 3C06                     cmp al, 6
  1515 00001584 0F850900                 jne @@getIndReg139
  1516 00001588 66B804000000             mov eax, 4
  1517 0000158E A2[BA01]                 mov byte [rm], al
  1518                                  
  1519                                  ;-96     if (rm==0) indexerror();
  1520                                  
  1521                                  @@getIndReg139:
  1522 00001591 A0[BA01]                 mov al, [rm]
  1523 00001594 3C00                     cmp al, 0
  1524 00001596 0F850300                 jne @@getIndReg140
  1525 0000159A E87111                   call indexerror
  1526                                  
  1527                                  ;-97 }
  1528                                  
  1529                                  @@getIndReg140:
  1530                                  
  1531                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1532                                  
  1533 0000159D C3                       ret
  1534                                  ; ENDP
  1535                                  
  1536                                  getIndReg2:  ; *** PROC ***
  1537                                  ;Function : getIndReg2, Number of local variables: 1
  1538                                  ;   # type sign width line used address name   list of local variables
  1539                                  ;  200 var sign byte    98 NULL bp-2    m;
  1540 0000159E C8020000                 ENTER  2,0
  1541 000015A2 66B804000000             mov eax, 4
  1542 000015A8 8846FE                   mov byte [bp-2], al
  1543                                  
  1544                                  ;-99     if (R2Type !=WORD) indexerror();
  1545                                  
  1546 000015AB A0[B401]                 mov al, [R2Type]
  1547 000015AE 3C02                     cmp al, 2
  1548 000015B0 0F840300                 je  @@getIndReg241
  1549 000015B4 E85711                   call indexerror
  1550                                  
  1551                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1552                                  
  1553                                  @@getIndReg241:
  1554 000015B7 A0[B201]                 mov al, [R2No]
  1555 000015BA 3C07                     cmp al, 7
  1556 000015BC 0F852700                 jne @@getIndReg242
  1557 000015C0 A0[BA01]                 mov al, [rm]
  1558 000015C3 3C06                     cmp al, 6
  1559 000015C5 0F850C00                 jne @@getIndReg243
  1560 000015C9 66B803000000             mov eax, 3
  1561 000015CF 8846FE                   mov byte [bp-2], al
  1562                                  
  1563                                  ;-101              else if (rm==7) m=1;//BX+DI
  1564                                  
  1565 000015D2 E91200                   jmp @@getIndReg244
  1566                                  @@getIndReg243:
  1567 000015D5 A0[BA01]                 mov al, [rm]
  1568 000015D8 3C07                     cmp al, 7
  1569 000015DA 0F850900                 jne @@getIndReg245
  1570 000015DE 66B801000000             mov eax, 1
  1571 000015E4 8846FE                   mov byte [bp-2], al
  1572                                  
  1573                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1574                                  
  1575                                  @@getIndReg245:
  1576                                  @@getIndReg244:
  1577                                  @@getIndReg242:
  1578 000015E7 A0[B201]                 mov al, [R2No]
  1579 000015EA 3C06                     cmp al, 6
  1580 000015EC 0F852700                 jne @@getIndReg246
  1581 000015F0 A0[BA01]                 mov al, [rm]
  1582 000015F3 3C06                     cmp al, 6
  1583 000015F5 0F850C00                 jne @@getIndReg247
  1584 000015F9 66B802000000             mov eax, 2
  1585 000015FF 8846FE                   mov byte [bp-2], al
  1586                                  
  1587                                  ;-103              else if (rm==7) m=0;//BX+SI
  1588                                  
  1589 00001602 E91200                   jmp @@getIndReg248
  1590                                  @@getIndReg247:
  1591 00001605 A0[BA01]                 mov al, [rm]
  1592 00001608 3C07                     cmp al, 7
  1593 0000160A 0F850900                 jne @@getIndReg249
  1594 0000160E 66B800000000             mov eax, 0
  1595 00001614 8846FE                   mov byte [bp-2], al
  1596                                  
  1597                                  ;-104     if (m > 3) indexerror();
  1598                                  
  1599                                  @@getIndReg249:
  1600                                  @@getIndReg248:
  1601                                  @@getIndReg246:
  1602 00001617 8A46FE                   mov al, [bp-2]
  1603 0000161A 3C03                     cmp al, 3
  1604 0000161C 0F8E0300                 jle @@getIndReg250
  1605 00001620 E8EB10                   call indexerror
  1606                                  
  1607                                  ;-105     return m;
  1608                                  
  1609                                  @@getIndReg250:
  1610 00001623 8A46FE                   mov al, [bp-2]
  1611 00001626 E90000                   jmp @@retn
  1612                                  
  1613                                  ;-106 }
  1614                                  
  1615                                  
  1616                                  ;-107                   
  1617                                  
  1618                                  
  1619                                  ;-108 int setwflag() {//word size, bit 0
  1620                                  
  1621 00001629 C9                      @@retn: LEAVE
  1622 0000162A C3                       ret
  1623                                  ; ENDP
  1624                                  
  1625                                  setwflag:  ; *** PROC ***
  1626                                  
  1627                                  ;-109     wflag=0;
  1628                                  
  1629 0000162B 66B800000000             mov eax, 0
  1630 00001631 A2[B701]                 mov byte [wflag], al
  1631                                  
  1632                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1633                                  
  1634 00001634 A0[B601]                 mov al, [OpSize]
  1635 00001637 3C00                     cmp al, 0
  1636 00001639 0F854200                 jne @@setwflag51
  1637                                  
  1638                                  ;-111         if (Op == REG) OpSize=R1Type;
  1639                                  
  1640 0000163D A0[AC01]                 mov al, [Op]
  1641 00001640 3C02                     cmp al, 2
  1642 00001642 0F850600                 jne @@setwflag52
  1643 00001646 A0[B501]                 mov al, [R1Type]
  1644 00001649 A2[B601]                 mov byte [OpSize], al
  1645                                  
  1646                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1647                                  
  1648                                  @@setwflag52:
  1649 0000164C A0[AD01]                 mov al, [Op2]
  1650 0000164F 3C02                     cmp al, 2
  1651 00001651 0F850600                 jne @@setwflag53
  1652 00001655 A0[B401]                 mov al, [R2Type]
  1653 00001658 A2[B601]                 mov byte [OpSize], al
  1654                                  
  1655                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1656                                  
  1657                                  @@setwflag53:
  1658 0000165B A0[B401]                 mov al, [R2Type]
  1659 0000165E 3C04                     cmp al, 4
  1660 00001660 0F850900                 jne @@setwflag54
  1661 00001664 66B802000000             mov eax, 2
  1662 0000166A A2[B601]                 mov byte [OpSize], al
  1663                                  
  1664                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1665                                  
  1666                                  @@setwflag54:
  1667 0000166D A0[B501]                 mov al, [R1Type]
  1668 00001670 3C04                     cmp al, 4
  1669 00001672 0F850900                 jne @@setwflag55
  1670 00001676 66B802000000             mov eax, 2
  1671 0000167C A2[B601]                 mov byte [OpSize], al
  1672                                  
  1673                                  ;-115     }
  1674                                  
  1675                                  @@setwflag55:
  1676                                  
  1677                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1678                                  
  1679                                  @@setwflag51:
  1680 0000167F A0[B601]                 mov al, [OpSize]
  1681 00001682 3C03                     cmp al, 3
  1682 00001684 0F850C00                 jne @@setwflag56
  1683 00001688 E82E15                   call gen66h
  1684 0000168B 66B801000000             mov eax, 1
  1685 00001691 A2[B701]                 mov byte [wflag], al
  1686                                  
  1687                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1688                                  
  1689                                  @@setwflag56:
  1690 00001694 A0[B601]                 mov al, [OpSize]
  1691 00001697 3C02                     cmp al, 2
  1692 00001699 0F850900                 jne @@setwflag57
  1693 0000169D 66B801000000             mov eax, 1
  1694 000016A3 A2[B701]                 mov byte [wflag], al
  1695                                  
  1696                                  ;-118 }
  1697                                  
  1698                                  @@setwflag57:
  1699                                  
  1700                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1701                                  
  1702 000016A6 C3                       ret
  1703                                  ; ENDP
  1704                                  
  1705                                  setsflag:  ; *** PROC ***
  1706                                  
  1707                                  ;-120     unsigned int ui;    
  1708                                  
  1709                                  
  1710                                  ;-121     sflag=2;   
  1711                                  
  1712                                  ;Function : setsflag, Number of local variables: 1
  1713                                  ;   # type sign width line used address name   list of local variables
  1714                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1715 000016A7 C8020000                 ENTER  2,0
  1716 000016AB 66B802000000             mov eax, 2
  1717 000016B1 A2[B901]                 mov byte [sflag], al
  1718                                  
  1719                                  ;-122     ui = imme & 0xFF80; 
  1720                                  
  1721 000016B4 A1[BE01]                 mov ax, [imme]
  1722 000016B7 2580FF                   and ax, 65408
  1723 000016BA 8946FE                   mov word [bp-2], ax
  1724                                  
  1725                                  ;-123     if(ui != 0) sflag = 0;    //vvv
  1726                                  
  1727 000016BD 8B46FE                   mov ax, [bp-2]
  1728 000016C0 83F800                   cmp ax, 0
  1729 000016C3 0F840900                 je  @@setsflag58
  1730 000016C7 66B800000000             mov eax, 0
  1731 000016CD A2[B901]                 mov byte [sflag], al
  1732                                  
  1733                                  ;-124     if (OpSize == BYTE) {
  1734                                  
  1735                                  @@setsflag58:
  1736 000016D0 A0[B601]                 mov al, [OpSize]
  1737 000016D3 3C01                     cmp al, 1
  1738 000016D5 0F851C00                 jne @@setsflag59
  1739                                  
  1740                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1741                                  
  1742 000016D9 A1[BE01]                 mov ax, [imme]
  1743 000016DC 3DFF00                   cmp ax, 255
  1744 000016DF 0F8E0900                 jle @@setsflag60
  1745 000016E3 68[F716]                 push setsflag_0
  1746 000016E6 E83B0F                   call error1
  1747 000016E9 83C402                   add  sp, 2
  1748                                  
  1749                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1750                                  
  1751                                  @@setsflag60:
  1752 000016EC 66B800000000             mov eax, 0
  1753 000016F2 A2[B901]                 mov byte [sflag], al
  1754                                  
  1755                                  ;-127     }
  1756                                  
  1757                                  
  1758                                  ;-128 }
  1759                                  
  1760 000016F5 C9                      @@setsflag59: LEAVE
  1761 000016F6 C3                       ret
  1762                                  ; ENDP
  1763 000016F7 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1764 00001700 6F7220627974652072-
  1765 00001709 2F6D00             
  1766                                  ;Back to main program: AS.C
  1767                                  
  1768                                  ;-5 #include "PARSE.C"
  1769                                  
  1770                                  ;Use include file: PARSE.C
  1771                                  
  1772                                  ;-1 int parse() {
  1773                                  
  1774                                  
  1775                                  parse:  ; *** PROC ***
  1776                                  
  1777                                  ;-2   LabelNamePtr= &LabelNames;
  1778                                  
  1779 0000170C B8[CA01]                 mov ax, LabelNames
  1780 0000170F A3[B205]                 mov word [LabelNamePtr], ax
  1781                                  
  1782                                  ;-3   do {
  1783                                  
  1784                                  @@parse61:
  1785                                  
  1786                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  1787                                  
  1788 00001712 A1[A601]                 mov ax, [PC]
  1789 00001715 A3[A801]                 mov word [PCStart], ax
  1790 00001718 66B800000000             mov eax, 0
  1791 0000171E A2[B601]                 mov byte [OpSize], al
  1792 00001721 66B800000000             mov eax, 0
  1793 00001727 A3[C501]                 mov word [OpPrintIndex], ax
  1794 0000172A 66B820000000             mov eax, 32
  1795 00001730 A2[C901]                 mov byte [PrintR], al
  1796                                  
  1797                                  ;-5     getLine();
  1798                                  
  1799 00001733 E82C05                   call getLine
  1800                                  
  1801                                  ;-6     InputPtr = &InputBuf;
  1802                                  
  1803 00001736 B8[4F00]                 mov ax, InputBuf
  1804 00001739 A3[CE00]                 mov word [InputPtr], ax
  1805                                  
  1806                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1807                                  
  1808 0000173C E8B700                   call getTokeType
  1809                                  
  1810                                  ;-8     if (TokeType == ALNUME) {
  1811                                  
  1812 0000173F A0[AB01]                 mov al, [TokeType]
  1813 00001742 3C03                     cmp al, 3
  1814 00001744 0F851300                 jne @@parse62
  1815                                  
  1816                                  ;-9       if (isLabel) { //set in getName
  1817                                  
  1818 00001748 A0[AA01]                 mov al, [isLabel]
  1819 0000174B 08C0                     or  al, al
  1820 0000174D 0F840A00                 je @@parse63
  1821                                  
  1822                                  ;-10         storeLabel();
  1823                                  
  1824 00001751 E84001                   call storeLabel
  1825                                  
  1826                                  ;-11         InputPtr++;//remove :
  1827                                  
  1828 00001754 FF06[CE00]               inc  word [InputPtr]
  1829                                  
  1830                                  ;-12         getTokeType();
  1831                                  
  1832 00001758 E89B00                   call getTokeType
  1833                                  
  1834                                  ;-13       }
  1835                                  
  1836                                  
  1837                                  ;-14     }
  1838                                  
  1839                                  @@parse63:
  1840                                  
  1841                                  ;-15     if (TokeType == ALNUME) {
  1842                                  
  1843                                  @@parse62:
  1844 0000175B A0[AB01]                 mov al, [TokeType]
  1845 0000175E 3C03                     cmp al, 3
  1846 00001760 0F851B00                 jne @@parse64
  1847                                  
  1848                                  ;-16       lookCode();// and OpCodePtr
  1849                                  
  1850 00001764 E86803                   call lookCode
  1851                                  
  1852                                  ;-17       if(CodeType) process();
  1853                                  
  1854 00001767 A0[AE01]                 mov al, [CodeType]
  1855 0000176A 08C0                     or  al, al
  1856 0000176C 0F840600                 je @@parse65
  1857 00001770 E83416                   call process
  1858                                  
  1859                                  ;-18       else getVariable();
  1860                                  
  1861 00001773 E90300                   jmp @@parse66
  1862                                  @@parse65:
  1863 00001776 E81E02                   call getVariable
  1864                                  
  1865                                  ;-19       skipRest();
  1866                                  
  1867                                  @@parse66:
  1868 00001779 E8BD04                   call skipRest
  1869                                  
  1870                                  ;-20     }
  1871                                  
  1872                                  
  1873                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1874                                  
  1875 0000177C E92700                   jmp @@parse67
  1876                                  @@parse64:
  1877 0000177F A0[AB01]                 mov al, [TokeType]
  1878 00001782 3C03                     cmp al, 3
  1879 00001784 0F8E0C00                 jle @@parse68
  1880 00001788 68[B717]                 push parse_0
  1881 0000178B E8960E                   call error1
  1882 0000178E 83C402                   add  sp, 2
  1883                                  
  1884                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1885                                  
  1886 00001791 E91200                   jmp @@parse69
  1887                                  @@parse68:
  1888 00001794 A0[AB01]                 mov al, [TokeType]
  1889 00001797 3C01                     cmp al, 1
  1890 00001799 0F850900                 jne @@parse70
  1891 0000179D 68[D517]                 push parse_1
  1892 000017A0 E8810E                   call error1
  1893 000017A3 83C402                   add  sp, 2
  1894                                  
  1895                                  ;-23     printLine();
  1896                                  
  1897                                  @@parse70:
  1898                                  @@parse69:
  1899                                  @@parse67:
  1900 000017A6 E80C0C                   call printLine
  1901                                  
  1902                                  ;-24   } while (DOS_NoBytes != 0 );
  1903                                  
  1904 000017A9 A1[A301]                 mov ax, [DOS_NoBytes]
  1905 000017AC 83F800                   cmp ax, 0
  1906 000017AF 0F840300                 je  @@parse71
  1907 000017B3 E95CFF                   jmp @@parse61
  1908                                  @@parse71:
  1909                                  
  1910                                  ;-25 }
  1911                                  
  1912                                  
  1913                                  ;-26 // scan code .....................................
  1914                                  
  1915                                  
  1916                                  ;-27 int getTokeType() { char c;
  1917                                  
  1918 000017B6 C3                       ret
  1919                                  ; ENDP
  1920 000017B7 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1921 000017C0 696E73747275637469-
  1922 000017C9 6F6E20657870656374-
  1923 000017D2 656400             
  1924 000017D5 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1925 000017DE 616C6C6F7765642040-
  1926 000017E7 207374617274206F66-
  1927 000017F0 206C696E6500       
  1928                                  
  1929                                  getTokeType:  ; *** PROC ***
  1930                                  
  1931                                  ;-28   skipBlank();
  1932                                  
  1933                                  ;Function : getTokeType, Number of local variables: 1
  1934                                  ;   # type sign width line used address name   list of local variables
  1935                                  ;  200 var sign byte    27 NULL bp-2    c;
  1936 000017F6 C8020000                 ENTER  2,0
  1937 000017FA E86705                   call skipBlank
  1938                                  
  1939                                  ;-29   c = *InputPtr;
  1940                                  
  1941 000017FD 8B1E[CE00]               mov bx, [InputPtr]
  1942 00001801 8A07                     mov al, [bx]
  1943 00001803 B400                     mov ah, 0
  1944 00001805 8846FE                   mov byte [bp-2], al
  1945                                  
  1946                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1947                                  
  1948 00001808 8A46FE                   mov al, [bp-2]
  1949 0000180B 3C00                     cmp al, 0
  1950 0000180D 0F850C00                 jne @@getTokeType72
  1951 00001811 66B800000000             mov eax, 0
  1952 00001817 A2[AB01]                 mov byte [TokeType], al
  1953 0000181A E97500                   jmp @@retn
  1954                                  
  1955                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1956                                  
  1957                                  @@getTokeType72:
  1958 0000181D 8A46FE                   mov al, [bp-2]
  1959 00001820 3C3B                     cmp al, 59
  1960 00001822 0F850C00                 jne @@getTokeType73
  1961 00001826 66B800000000             mov eax, 0
  1962 0000182C A2[AB01]                 mov byte [TokeType], al
  1963 0000182F E96000                   jmp @@retn
  1964                                  
  1965                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1966                                  
  1967                                  @@getTokeType73:
  1968 00001832 8A46FE                   mov al, byte [bp-2]
  1969 00001835 B400                     mov ah, 0
  1970 00001837 50                       push ax
  1971 00001838 E8FD1B                   call digit
  1972 0000183B 83C402                   add  sp, 2
  1973 0000183E 08C0                     or  al, al
  1974 00001840 0F841800                 je @@getTokeType74
  1975 00001844 8A46FE                   mov al, byte [bp-2]
  1976 00001847 B400                     mov ah, 0
  1977 00001849 50                       push ax
  1978 0000184A E81D06                   call getDigit
  1979 0000184D 83C402                   add  sp, 2
  1980 00001850 66B801000000             mov eax, 1
  1981 00001856 A2[AB01]                 mov byte [TokeType], al
  1982 00001859 E93600                   jmp @@retn
  1983                                  
  1984                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1985                                  
  1986                                  @@getTokeType74:
  1987 0000185C 8A46FE                   mov al, byte [bp-2]
  1988 0000185F B400                     mov ah, 0
  1989 00001861 50                       push ax
  1990 00001862 E82A05                   call letterE
  1991 00001865 83C402                   add  sp, 2
  1992 00001868 08C0                     or  al, al
  1993 0000186A 0F841800                 je @@getTokeType75
  1994 0000186E 8A46FE                   mov al, byte [bp-2]
  1995 00001871 B400                     mov ah, 0
  1996 00001873 50                       push ax
  1997 00001874 E84A06                   call getName
  1998 00001877 83C402                   add  sp, 2
  1999 0000187A 66B803000000             mov eax, 3
  2000 00001880 A2[AB01]                 mov byte [TokeType], al
  2001 00001883 E90C00                   jmp @@retn
  2002                                  
  2003                                  ;-34   TokeType=NOALNUME; return;
  2004                                  
  2005                                  @@getTokeType75:
  2006 00001886 66B804000000             mov eax, 4
  2007 0000188C A2[AB01]                 mov byte [TokeType], al
  2008 0000188F E90000                   jmp @@retn
  2009                                  
  2010                                  ;-35 }
  2011                                  
  2012                                  
  2013                                  ;-36 int storeLabel() {unsigned int i;
  2014                                  
  2015 00001892 C9                      @@retn: LEAVE
  2016 00001893 C3                       ret
  2017                                  ; ENDP
  2018                                  
  2019                                  storeLabel:  ; *** PROC ***
  2020                                  
  2021                                  ;-37   if(searchLabel()) error1("duplicate label");
  2022                                  
  2023                                  ;Function : storeLabel, Number of local variables: 1
  2024                                  ;   # type sign width line used address name   list of local variables
  2025                                  ;  200 var unsg word    36 NULL bp-2    i;
  2026 00001894 C8020000                 ENTER  2,0
  2027 00001898 E89C00                   call searchLabel
  2028 0000189B 08C0                     or  al, al
  2029 0000189D 0F840900                 je @@storeLabel76
  2030 000018A1 68[0219]                 push storeLabel_0
  2031 000018A4 E87D0D                   call error1
  2032 000018A7 83C402                   add  sp, 2
  2033                                  
  2034                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2035                                  
  2036                                  @@storeLabel76:
  2037 000018AA 8D06[0F00]               lea  ax, [Symbol]
  2038 000018AE 50                       push ax
  2039 000018AF FF36[B205]               push word [LabelNamePtr]
  2040 000018B3 E8491B                   call strcpy
  2041 000018B6 83C404                   add  sp, 4
  2042 000018B9 A3[B205]                 mov word [LabelNamePtr], ax
  2043                                  
  2044                                  ;-39   LabelNamePtr++;
  2045                                  
  2046 000018BC FF06[B205]               inc  word [LabelNamePtr]
  2047                                  
  2048                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  2049                                  
  2050 000018C0 A1[B205]                 mov ax, [LabelNamePtr]
  2051 000018C3 2D[CA01]                 sub ax, LabelNames
  2052 000018C6 8946FE                   mov word [bp-2], ax
  2053                                  
  2054                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  2055                                  
  2056 000018C9 8B46FE                   mov ax, [bp-2]
  2057 000018CC 3DC903                   cmp ax, 969 ;unsigned : 0
  2058 000018CF 0F820900                 jb  @@storeLabel77
  2059 000018D3 68[1219]                 push storeLabel_1
  2060 000018D6 E8AA0D                   call errorexit
  2061 000018D9 83C402                   add  sp, 2
  2062                                  
  2063                                  ;-42   LabelMaxIx++;
  2064                                  
  2065                                  @@storeLabel77:
  2066 000018DC FF06[7C06]               inc  word [LabelMaxIx]
  2067                                  
  2068                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2069                                  
  2070 000018E0 A1[7C06]                 mov ax, [LabelMaxIx]
  2071 000018E3 83F864                   cmp ax, 100 ;unsigned : 1
  2072 000018E6 0F8C0900                 jl  @@storeLabel78
  2073 000018EA 68[2719]                 push storeLabel_2
  2074 000018ED E8930D                   call errorexit
  2075 000018F0 83C402                   add  sp, 2
  2076                                  
  2077                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  2078                                  
  2079                                  @@storeLabel78:
  2080 000018F3 A1[A601]                 mov ax, [PC]
  2081 000018F6 8B1E[7C06]               mov bx, [LabelMaxIx]
  2082 000018FA D1E3                     shl bx, 1
  2083 000018FC 8987[B405]               mov [LabelAddr+bx], ax
  2084                                  
  2085                                  ;-45 }
  2086                                  
  2087                                  
  2088                                  ;-46 int searchLabel() {
  2089 00001900 C9                       LEAVE
  2090 00001901 C3                       ret
  2091                                  ; ENDP
  2092 00001902 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2093 0000190B 206C6162656C00     
  2094 00001912 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2095 0000191B 6C6162656C206E616D-
  2096 00001924 657300             
  2097 00001927 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2098 00001930 6C6162656C7300     
  2099                                  
  2100                                  searchLabel:  ; *** PROC ***
  2101                                  
  2102                                  ;-47   int LIx; char *p; int j;
  2103                                  
  2104                                  
  2105                                  ;-48   p = &LabelNames;
  2106                                  
  2107                                  ;Function : searchLabel, Number of local variables: 3
  2108                                  ;   # type sign width line used address name   list of local variables
  2109                                  ;  200 var sign word    47 NULL bp-2    LIx
  2110                                  ;  201 ptr sign byte    47 NULL bp-4    p
  2111                                  ;  202 var sign word    47 NULL bp-6    j;
  2112 00001937 C8060000                 ENTER  6,0
  2113 0000193B B8[CA01]                 mov ax, LabelNames
  2114 0000193E 8946FC                   mov word [bp-4], ax
  2115                                  
  2116                                  ;-49   LIx=1;
  2117                                  
  2118 00001941 66B801000000             mov eax, 1
  2119 00001947 8946FE                   mov word [bp-2], ax
  2120                                  
  2121                                  ;-50   while (LIx <= LabelMaxIx) {
  2122                                  
  2123                                  @@searchLabel79:
  2124 0000194A 8B46FE                   mov ax, [bp-2]
  2125 0000194D 3B06[7C06]               cmp ax, [LabelMaxIx]
  2126 00001951 0F8F3700                 jg  @@searchLabel80
  2127                                  
  2128                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  2129                                  
  2130 00001955 8D06[0F00]               lea  ax, [Symbol]
  2131 00001959 50                       push ax
  2132 0000195A FF76FC                   push word [bp-4]
  2133 0000195D E80B1B                   call eqstr
  2134 00001960 83C404                   add  sp, 4
  2135 00001963 08C0                     or  al, al
  2136 00001965 0F840600                 je @@searchLabel81
  2137 00001969 8B46FE                   mov ax, [bp-2]
  2138 0000196C E92600                   jmp @@retn
  2139                                  
  2140                                  ;-52     j=strlen(p);
  2141                                  
  2142                                  @@searchLabel81:
  2143 0000196F FF76FC                   push word [bp-4]
  2144 00001972 E85F1A                   call strlen
  2145 00001975 83C402                   add  sp, 2
  2146 00001978 8946FA                   mov word [bp-6], ax
  2147                                  
  2148                                  ;-53     p=p+j; p++; LIx++;
  2149                                  
  2150 0000197B 8B46FC                   mov ax, [bp-4]
  2151 0000197E 0346FA                   add ax, [bp-6]
  2152 00001981 8946FC                   mov word [bp-4], ax
  2153 00001984 FF46FC                   inc  word [bp-4]
  2154 00001987 FF46FE                   inc  word [bp-2]
  2155                                  
  2156                                  ;-54   }
  2157                                  
  2158                                  
  2159                                  ;-55   return 0;
  2160                                  
  2161 0000198A EBBE                     jmp @@searchLabel79
  2162                                  @@searchLabel80:
  2163 0000198C 66B800000000             mov eax, 0
  2164 00001992 E90000                   jmp @@retn
  2165                                  
  2166                                  ;-56 }
  2167                                  
  2168                                  
  2169                                  ;-57 int getVariable() { char c;
  2170                                  
  2171 00001995 C9                      @@retn: LEAVE
  2172 00001996 C3                       ret
  2173                                  ; ENDP
  2174                                  
  2175                                  getVariable:  ; *** PROC ***
  2176                                  
  2177                                  ;-58   storeLabel();
  2178                                  
  2179                                  ;Function : getVariable, Number of local variables: 1
  2180                                  ;   # type sign width line used address name   list of local variables
  2181                                  ;  200 var sign byte    57 NULL bp-2    c;
  2182 00001997 C8020000                 ENTER  2,0
  2183 0000199B E8F6FE                   call storeLabel
  2184                                  
  2185                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  2186                                  
  2187 0000199E E855FE                   call getTokeType
  2188 000019A1 A0[AB01]                 mov al, [TokeType]
  2189 000019A4 3C03                     cmp al, 3
  2190 000019A6 0F85CC00                 jne @@getVariable82
  2191                                  
  2192                                  ;-60     lookCode();
  2193                                  
  2194 000019AA E82201                   call lookCode
  2195                                  
  2196                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2197                                  
  2198 000019AD A0[AE01]                 mov al, [CodeType]
  2199 000019B0 3CC8                     cmp al, 200
  2200 000019B2 0F8D0900                 jge @@getVariable83
  2201 000019B6 68[811A]                 push getVariable_0
  2202 000019B9 E8C70C                   call errorexit
  2203 000019BC 83C402                   add  sp, 2
  2204                                  
  2205                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2206                                  
  2207                                  @@getVariable83:
  2208 000019BF A0[AE01]                 mov al, [CodeType]
  2209 000019C2 3CCF                     cmp al, 207
  2210 000019C4 0F8E0900                 jle @@getVariable84
  2211 000019C8 68[991A]                 push getVariable_1
  2212 000019CB E8B50C                   call errorexit
  2213 000019CE 83C402                   add  sp, 2
  2214                                  
  2215                                  ;-63     if (CodeType== 200) {// DB
  2216                                  
  2217                                  @@getVariable84:
  2218 000019D1 A0[AE01]                 mov al, [CodeType]
  2219 000019D4 3CC8                     cmp al, 200
  2220 000019D6 0F856A00                 jne @@getVariable85
  2221                                  
  2222                                  ;-64       do { getTokeType();
  2223                                  
  2224                                  @@getVariable86:
  2225 000019DA E819FE                   call getTokeType
  2226                                  
  2227                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2228                                  
  2229 000019DD A0[AB01]                 mov al, [TokeType]
  2230 000019E0 3C01                     cmp al, 1
  2231 000019E2 0F850D00                 jne @@getVariable87
  2232 000019E6 FF36[4D00]               push word [SymbolInt]
  2233 000019EA E80C12                   call genCode8
  2234 000019ED 83C402                   add  sp, 2
  2235                                  
  2236                                  ;-66         else {
  2237                                  
  2238 000019F0 E94100                   jmp @@getVariable88
  2239                                  @@getVariable87:
  2240                                  
  2241                                  ;-67           skipBlank();
  2242                                  
  2243 000019F3 E86E03                   call skipBlank
  2244                                  
  2245                                  ;-68           if (isToken('"')) {
  2246                                  
  2247 000019F6 6A22                     push 34
  2248 000019F8 E8D101                   call isToken
  2249 000019FB 83C402                   add  sp, 2
  2250 000019FE 08C0                     or  al, al
  2251 00001A00 0F843000                 je @@getVariable89
  2252                                  
  2253                                  ;-69             do { c= *InputPtr;
  2254                                  
  2255                                  @@getVariable90:
  2256 00001A04 8B1E[CE00]               mov bx, [InputPtr]
  2257 00001A08 8A07                     mov al, [bx]
  2258 00001A0A B400                     mov ah, 0
  2259 00001A0C 8846FE                   mov byte [bp-2], al
  2260                                  
  2261                                  ;-70               genCode8(c);
  2262                                  
  2263 00001A0F 8A46FE                   mov al, byte [bp-2]
  2264 00001A12 B400                     mov ah, 0
  2265 00001A14 50                       push ax
  2266 00001A15 E8E111                   call genCode8
  2267 00001A18 83C402                   add  sp, 2
  2268                                  
  2269                                  ;-71               InputPtr++;
  2270                                  
  2271 00001A1B FF06[CE00]               inc  word [InputPtr]
  2272                                  
  2273                                  ;-72             } while (*InputPtr != '"' );
  2274                                  
  2275 00001A1F 8B1E[CE00]               mov bx, [InputPtr]
  2276 00001A23 8A07                     mov al, [bx]
  2277 00001A25 B400                     mov ah, 0
  2278 00001A27 83F822                   cmp ax, 34
  2279 00001A2A 0F840200                 je  @@getVariable91
  2280 00001A2E EBD4                     jmp @@getVariable90
  2281                                  @@getVariable91:
  2282                                  
  2283                                  ;-73             InputPtr++;
  2284                                  
  2285 00001A30 FF06[CE00]               inc  word [InputPtr]
  2286                                  
  2287                                  ;-74           }
  2288                                  
  2289                                  
  2290                                  ;-75         }
  2291                                  
  2292                                  @@getVariable89:
  2293                                  
  2294                                  ;-76       } while (isToken(','));
  2295                                  
  2296                                  @@getVariable88:
  2297 00001A34 6A2C                     push 44
  2298 00001A36 E89301                   call isToken
  2299 00001A39 83C402                   add  sp, 2
  2300 00001A3C 08C0                     or  al, al
  2301 00001A3E 0F840200                 je @@getVariable92
  2302 00001A42 EB96                     jmp @@getVariable86
  2303                                  @@getVariable92:
  2304                                  
  2305                                  ;-77     }
  2306                                  
  2307                                  
  2308                                  ;-78     if (CodeType== 201) {// DW
  2309                                  
  2310                                  @@getVariable85:
  2311 00001A44 A0[AE01]                 mov al, [CodeType]
  2312 00001A47 3CC9                     cmp al, 201
  2313 00001A49 0F852600                 jne @@getVariable93
  2314                                  
  2315                                  ;-79       do { getTokeType();
  2316                                  
  2317                                  @@getVariable94:
  2318 00001A4D E8A6FD                   call getTokeType
  2319                                  
  2320                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2321                                  
  2322 00001A50 A0[AB01]                 mov al, [TokeType]
  2323 00001A53 3C01                     cmp al, 1
  2324 00001A55 0F850A00                 jne @@getVariable95
  2325 00001A59 FF36[4D00]               push word [SymbolInt]
  2326 00001A5D E8F011                   call genCode16
  2327 00001A60 83C402                   add  sp, 2
  2328                                  
  2329                                  ;-81       } while (isToken(','));
  2330                                  
  2331                                  @@getVariable95:
  2332 00001A63 6A2C                     push 44
  2333 00001A65 E86401                   call isToken
  2334 00001A68 83C402                   add  sp, 2
  2335 00001A6B 08C0                     or  al, al
  2336 00001A6D 0F840200                 je @@getVariable96
  2337 00001A71 EBDA                     jmp @@getVariable94
  2338                                  @@getVariable96:
  2339                                  
  2340                                  ;-82     }
  2341                                  
  2342                                  
  2343                                  ;-83   }
  2344                                  
  2345                                  @@getVariable93:
  2346                                  
  2347                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  2348                                  
  2349 00001A73 E90900                   jmp @@getVariable97
  2350                                  @@getVariable82:
  2351 00001A76 68[B11A]                 push getVariable_2
  2352 00001A79 E8070C                   call errorexit
  2353 00001A7C 83C402                   add  sp, 2
  2354                                  
  2355                                  ;-85 }
  2356                                  
  2357                                  @@getVariable97:
  2358                                  
  2359                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  2360 00001A7F C9                       LEAVE
  2361 00001A80 C3                       ret
  2362                                  ; ENDP
  2363 00001A81 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2364 00001A8A 422C572C4420657870-
  2365 00001A93 656374656400       
  2366 00001A99 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2367 00001AA2 422C572C4420657870-
  2368 00001AAB 656374656400       
  2369 00001AB1 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2370 00001ABA 6F7220524553422C57-
  2371 00001AC3 2C4420657870656374-
  2372 00001ACC 656400             
  2373                                  
  2374                                  lookCode:  ; *** PROC ***
  2375                                  
  2376                                  ;-87   CodeType=0;
  2377                                  
  2378 00001ACF 66B800000000             mov eax, 0
  2379 00001AD5 A2[AE01]                 mov byte [CodeType], al
  2380                                  
  2381                                  ;-88   OpCodePtr= &I_START;
  2382                                  
  2383 00001AD8 B8[560E]                 mov ax, I_START
  2384 00001ADB A3[C701]                 mov word [OpCodePtr], ax
  2385                                  
  2386                                  ;-89   OpCodePtr++;
  2387                                  
  2388 00001ADE FF06[C701]               inc  word [OpCodePtr]
  2389                                  
  2390                                  ;-90   do  {
  2391                                  
  2392                                  @@lookCode98:
  2393                                  
  2394                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  2395                                  
  2396 00001AE2 FF36[C701]               push word [OpCodePtr]
  2397 00001AE6 8D06[2E00]               lea  ax, [SymbolUpper]
  2398 00001AEA 50                       push ax
  2399 00001AEB E87D19                   call eqstr
  2400 00001AEE 83C404                   add  sp, 4
  2401 00001AF1 08C0                     or  al, al
  2402 00001AF3 0F842700                 je @@lookCode99
  2403                                  
  2404                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  2405                                  
  2406                                  @@lookCode100:
  2407 00001AF7 8B1E[C701]               mov bx, [OpCodePtr]
  2408 00001AFB 8A07                     mov al, [bx]
  2409 00001AFD B400                     mov ah, 0
  2410 00001AFF 83F800                   cmp ax, 0
  2411 00001B02 0F840600                 je  @@lookCode101
  2412 00001B06 FF06[C701]               inc  word [OpCodePtr]
  2413                                  
  2414                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  2415                                  
  2416 00001B0A EBEB                     jmp @@lookCode100
  2417                                  @@lookCode101:
  2418 00001B0C FF06[C701]               inc  word [OpCodePtr]
  2419 00001B10 8B1E[C701]               mov bx, [OpCodePtr]
  2420 00001B14 8A07                     mov al, [bx]
  2421 00001B16 B400                     mov ah, 0
  2422 00001B18 A2[AE01]                 mov byte [CodeType], al
  2423                                  
  2424                                  ;-94       return;
  2425                                  
  2426 00001B1B E92A00                   jmp @@retn
  2427                                  
  2428                                  ;-95     }
  2429                                  
  2430                                  
  2431                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2432                                  
  2433                                  @@lookCode99:
  2434                                  @@lookCode102:
  2435 00001B1E 8B1E[C701]               mov bx, [OpCodePtr]
  2436 00001B22 8A07                     mov al, [bx]
  2437 00001B24 B400                     mov ah, 0
  2438 00001B26 3DF100                   cmp ax, 241
  2439 00001B29 0F840600                 je  @@lookCode103
  2440 00001B2D FF06[C701]               inc  word [OpCodePtr]
  2441                                  
  2442                                  ;-97   OpCodePtr++;
  2443                                  
  2444 00001B31 EBEB                     jmp @@lookCode102
  2445                                  @@lookCode103:
  2446 00001B33 FF06[C701]               inc  word [OpCodePtr]
  2447                                  
  2448                                  ;-98   } while(*OpCodePtr!=0);
  2449                                  
  2450 00001B37 8B1E[C701]               mov bx, [OpCodePtr]
  2451 00001B3B 8A07                     mov al, [bx]
  2452 00001B3D B400                     mov ah, 0
  2453 00001B3F 83F800                   cmp ax, 0
  2454 00001B42 0F840200                 je  @@lookCode104
  2455 00001B46 EB9A                     jmp @@lookCode98
  2456                                  @@lookCode104:
  2457                                  
  2458                                  ;-99 }
  2459                                  
  2460                                  
  2461                                  ;-100 
  2462                                  
  2463                                  
  2464                                  ;-101 int getCodeSize() {
  2465                                  
  2466                                  @@retn:
  2467 00001B48 C3                       ret
  2468                                  ; ENDP
  2469                                  
  2470                                  getCodeSize:  ; *** PROC ***
  2471                                  
  2472                                  ;-102   if (TokeType ==ALNUME) {
  2473                                  
  2474 00001B49 A0[AB01]                 mov al, [TokeType]
  2475 00001B4C 3C03                     cmp al, 3
  2476 00001B4E 0F856000                 jne @@getCodeSize105
  2477                                  
  2478                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2479                                  
  2480 00001B52 68[BC1B]                 push getCodeSize_0
  2481 00001B55 8D06[2E00]               lea  ax, [SymbolUpper]
  2482 00001B59 50                       push ax
  2483 00001B5A E80E19                   call eqstr
  2484 00001B5D 83C404                   add  sp, 4
  2485 00001B60 08C0                     or  al, al
  2486 00001B62 0F840C00                 je @@getCodeSize106
  2487 00001B66 E88DFC                   call getTokeType
  2488 00001B69 66B801000000             mov eax, 1
  2489 00001B6F E94900                   jmp @@retn
  2490                                  
  2491                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2492                                  
  2493                                  @@getCodeSize106:
  2494 00001B72 68[C11B]                 push getCodeSize_1
  2495 00001B75 8D06[2E00]               lea  ax, [SymbolUpper]
  2496 00001B79 50                       push ax
  2497 00001B7A E8EE18                   call eqstr
  2498 00001B7D 83C404                   add  sp, 4
  2499 00001B80 08C0                     or  al, al
  2500 00001B82 0F840C00                 je @@getCodeSize107
  2501 00001B86 E86DFC                   call getTokeType
  2502 00001B89 66B802000000             mov eax, 2
  2503 00001B8F E92900                   jmp @@retn
  2504                                  
  2505                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2506                                  
  2507                                  @@getCodeSize107:
  2508 00001B92 68[C61B]                 push getCodeSize_2
  2509 00001B95 8D06[2E00]               lea  ax, [SymbolUpper]
  2510 00001B99 50                       push ax
  2511 00001B9A E8CE18                   call eqstr
  2512 00001B9D 83C404                   add  sp, 4
  2513 00001BA0 08C0                     or  al, al
  2514 00001BA2 0F840C00                 je @@getCodeSize108
  2515 00001BA6 E84DFC                   call getTokeType
  2516 00001BA9 66B803000000             mov eax, 3
  2517 00001BAF E90900                   jmp @@retn
  2518                                  
  2519                                  ;-106   } return 0;
  2520                                  
  2521                                  @@getCodeSize108:
  2522                                  @@getCodeSize105:
  2523 00001BB2 66B800000000             mov eax, 0
  2524 00001BB8 E90000                   jmp @@retn
  2525                                  
  2526                                  ;-107 }
  2527                                  
  2528                                  
  2529                                  ;-108 int isToken(char c) {
  2530                                  
  2531                                  @@retn:
  2532 00001BBB C3                       ret
  2533                                  ; ENDP
  2534 00001BBC 4259544500              getCodeSize_0 db "BYTE",0
  2535 00001BC1 574F524400              getCodeSize_1 db "WORD",0
  2536 00001BC6 44574F524400            getCodeSize_2 db "DWORD",0
  2537                                  
  2538                                  isToken:  ; *** PROC ***
  2539                                  
  2540                                  ;-109   skipBlank();
  2541                                  
  2542                                  ;Function : isToken, Number of local variables: 1
  2543                                  ;   # type sign width line used address name   list of local variables
  2544                                  ;  200 var sign byte   108 NULL bp+4    c;
  2545 00001BCC C8000000                 ENTER  0,0
  2546 00001BD0 E89101                   call skipBlank
  2547                                  
  2548                                  ;-110   if (*InputPtr == c) {
  2549                                  
  2550 00001BD3 8B1E[CE00]               mov bx, [InputPtr]
  2551 00001BD7 8A07                     mov al, [bx]
  2552 00001BD9 B400                     mov ah, 0
  2553 00001BDB 3A4604                   cmp al, [bp+4]
  2554 00001BDE 0F850D00                 jne @@isToken109
  2555                                  
  2556                                  ;-111     InputPtr++; return 1;} return 0;
  2557                                  
  2558 00001BE2 FF06[CE00]               inc  word [InputPtr]
  2559 00001BE6 66B801000000             mov eax, 1
  2560 00001BEC E90900                   jmp @@retn
  2561                                  @@isToken109:
  2562 00001BEF 66B800000000             mov eax, 0
  2563 00001BF5 E90000                   jmp @@retn
  2564                                  
  2565                                  ;-112 }
  2566                                  
  2567                                  
  2568                                  ;-113 int need(char c) {
  2569                                  
  2570 00001BF8 C9                      @@retn: LEAVE
  2571 00001BF9 C3                       ret
  2572                                  ; ENDP
  2573                                  
  2574                                  need:  ; *** PROC ***
  2575                                  
  2576                                  ;-114   if (isToken(c)) {
  2577                                  
  2578                                  ;Function : need, Number of local variables: 1
  2579                                  ;   # type sign width line used address name   list of local variables
  2580                                  ;  200 var sign byte   113 NULL bp+4    c;
  2581 00001BFA C8000000                 ENTER  0,0
  2582 00001BFE 8A4604                   mov al, byte [bp+4]
  2583 00001C01 B400                     mov ah, 0
  2584 00001C03 50                       push ax
  2585 00001C04 E8C5FF                   call isToken
  2586 00001C07 83C402                   add  sp, 2
  2587 00001C0A 08C0                     or  al, al
  2588 00001C0C 0F840600                 je @@need110
  2589                                  
  2590                                  ;-115       getTokeType();
  2591                                  
  2592 00001C10 E8E3FB                   call getTokeType
  2593                                  
  2594                                  ;-116       return;
  2595                                  
  2596 00001C13 E91800                   jmp @@retn
  2597                                  
  2598                                  ;-117       }
  2599                                  
  2600                                  
  2601                                  ;-118   error1();
  2602                                  
  2603                                  @@need110:
  2604 00001C16 E80B0A                   call error1
  2605                                  
  2606                                  ;-119   prs(". need: ");
  2607                                  
  2608 00001C19 68[301C]                 push need_0
  2609 00001C1C E8A408                   call prs
  2610 00001C1F 83C402                   add  sp, 2
  2611                                  
  2612                                  ;-120   prc(c);
  2613                                  
  2614 00001C22 8A4604                   mov al, byte [bp+4]
  2615 00001C25 B400                     mov ah, 0
  2616 00001C27 50                       push ax
  2617 00001C28 E83708                   call prc
  2618 00001C2B 83C402                   add  sp, 2
  2619                                  
  2620                                  ;-121 }
  2621                                  
  2622                                  
  2623                                  ;-122 
  2624                                  
  2625                                  
  2626                                  ;-123 int skipRest() {
  2627                                  
  2628 00001C2E C9                      @@retn: LEAVE
  2629 00001C2F C3                       ret
  2630                                  ; ENDP
  2631 00001C30 2E206E6565643A2000      need_0 db ". need: ",0
  2632                                  
  2633                                  skipRest:  ; *** PROC ***
  2634                                  
  2635                                  ;-124   getTokeType(); 
  2636                                  
  2637 00001C39 E8BAFB                   call getTokeType
  2638                                  
  2639                                  ;-125   if(TokeType)error1("extra char ignored");
  2640                                  
  2641 00001C3C A0[AB01]                 mov al, [TokeType]
  2642 00001C3F 08C0                     or  al, al
  2643 00001C41 0F840900                 je @@skipRest111
  2644 00001C45 68[4F1C]                 push skipRest_0
  2645 00001C48 E8D909                   call error1
  2646 00001C4B 83C402                   add  sp, 2
  2647                                  
  2648                                  ;-126 }
  2649                                  
  2650                                  @@skipRest111:
  2651 00001C4E C3                       ret
  2652                                  ; ENDP
  2653 00001C4F 657874726120636861-     skipRest_0 db "extra char ignored",0
  2654 00001C58 722069676E6F726564-
  2655 00001C61 00                 
  2656                                  ;Back to main program: AS.C
  2657                                  
  2658                                  ;-6 #include "HELPER.C"
  2659                                  
  2660                                  ;Use include file: HELPER.C
  2661                                  
  2662                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2663                                  
  2664                                  
  2665                                  getLine:  ; *** PROC ***
  2666                                  
  2667                                  ;-2   unsigned int i;
  2668                                  
  2669                                  
  2670                                  ;-3   InputPtr= &InputBuf;
  2671                                  
  2672                                  ;Function : getLine, Number of local variables: 1
  2673                                  ;   # type sign width line used address name   list of local variables
  2674                                  ;  200 var unsg word     2 NULL bp-2    i;
  2675 00001C62 C8020000                 ENTER  2,0
  2676 00001C66 B8[4F00]                 mov ax, InputBuf
  2677 00001C69 A3[CE00]                 mov word [InputPtr], ax
  2678                                  
  2679                                  ;-4   *InputPtr=0;//if last line is empty
  2680                                  
  2681 00001C6C 66B800000000             mov eax, 0
  2682 00001C72 8B1E[CE00]               mov  bx, [InputPtr]
  2683 00001C76 8807                     mov  [bx], al
  2684                                  
  2685                                  ;-5   do {
  2686                                  
  2687                                  @@getLine112:
  2688                                  
  2689                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2690                                  
  2691 00001C78 6A01                     push 1
  2692 00001C7A FF36[9901]               push word [asm_fd]
  2693 00001C7E 8D06[A501]               lea  ax, [DOS_ByteRead]
  2694 00001C82 50                       push ax
  2695 00001C83 E88018                   call readRL
  2696 00001C86 83C406                   add  sp, 6
  2697 00001C89 A3[A301]                 mov word [DOS_NoBytes], ax
  2698                                  
  2699                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2700                                  
  2701 00001C8C A1[9F01]                 mov ax, [DOS_ERR]
  2702 00001C8F 08C0                     or  al, al
  2703 00001C91 0F840900                 je @@getLine113
  2704 00001C95 68[FA1C]                 push getLine_0
  2705 00001C98 E8E809                   call errorexit
  2706 00001C9B 83C402                   add  sp, 2
  2707                                  
  2708                                  ;-8     if (DOS_NoBytes == 0) return;
  2709                                  
  2710                                  @@getLine113:
  2711 00001C9E A1[A301]                 mov ax, [DOS_NoBytes]
  2712 00001CA1 83F800                   cmp ax, 0
  2713 00001CA4 0F850300                 jne @@getLine114
  2714 00001CA8 E94D00                   jmp @@retn
  2715                                  
  2716                                  ;-9     *InputPtr = DOS_ByteRead;
  2717                                  
  2718                                  @@getLine114:
  2719 00001CAB A0[A501]                 mov al, [DOS_ByteRead]
  2720 00001CAE 8B1E[CE00]               mov  bx, [InputPtr]
  2721 00001CB2 8807                     mov  [bx], al
  2722                                  
  2723                                  ;-10     InputPtr++;
  2724                                  
  2725 00001CB4 FF06[CE00]               inc  word [InputPtr]
  2726                                  
  2727                                  ;-11     i = InputPtr - &InputBuf;
  2728                                  
  2729 00001CB8 A1[CE00]                 mov ax, [InputPtr]
  2730 00001CBB 2D[4F00]                 sub ax, InputBuf
  2731 00001CBE 8946FE                   mov word [bp-2], ax
  2732                                  
  2733                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2734                                  
  2735 00001CC1 8B46FE                   mov ax, [bp-2]
  2736 00001CC4 83F87F                   cmp ax, 127 ;unsigned : 0
  2737 00001CC7 0F820900                 jb  @@getLine115
  2738 00001CCB 68[091D]                 push getLine_1
  2739 00001CCE E8B209                   call errorexit
  2740 00001CD1 83C402                   add  sp, 2
  2741                                  
  2742                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2743                                  
  2744                                  @@getLine115:
  2745 00001CD4 A0[A501]                 mov al, byte [DOS_ByteRead]
  2746 00001CD7 B400                     mov ah, 0
  2747 00001CD9 50                       push ax
  2748 00001CDA E84000                   call ifEOL
  2749 00001CDD 83C402                   add  sp, 2
  2750 00001CE0 3C00                     cmp al, 0
  2751 00001CE2 0F850200                 jne @@getLine116
  2752 00001CE6 EB90                     jmp @@getLine112
  2753                                  @@getLine116:
  2754                                  
  2755                                  ;-14   InputPtr--;
  2756                                  
  2757 00001CE8 FF0E[CE00]               dec  word [InputPtr]
  2758                                  
  2759                                  ;-15   *InputPtr=0;
  2760                                  
  2761 00001CEC 66B800000000             mov eax, 0
  2762 00001CF2 8B1E[CE00]               mov  bx, [InputPtr]
  2763 00001CF6 8807                     mov  [bx], al
  2764                                  
  2765                                  ;-16 }
  2766                                  
  2767                                  
  2768                                  ;-17 int ifEOL(char c) {
  2769                                  
  2770 00001CF8 C9                      @@retn: LEAVE
  2771 00001CF9 C3                       ret
  2772                                  ; ENDP
  2773 00001CFA 52656164696E672053-     getLine_0 db "Reading Source",0
  2774 00001D03 6F7572636500       
  2775 00001D09 696E707574206C696E-     getLine_1 db "input line too long",0
  2776 00001D12 6520746F6F206C6F6E-
  2777 00001D1B 6700               
  2778                                  
  2779                                  ifEOL:  ; *** PROC ***
  2780                                  
  2781                                  ;-18   if (c == 10) return 1;
  2782                                  
  2783                                  ;Function : ifEOL, Number of local variables: 1
  2784                                  ;   # type sign width line used address name   list of local variables
  2785                                  ;  200 var sign byte    17 NULL bp+4    c;
  2786 00001D1D C8000000                 ENTER  0,0
  2787 00001D21 8A4604                   mov al, [bp+4]
  2788 00001D24 3C0A                     cmp al, 10
  2789 00001D26 0F850900                 jne @@ifEOL117
  2790 00001D2A 66B801000000             mov eax, 1
  2791 00001D30 E92F00                   jmp @@retn
  2792                                  
  2793                                  ;-19   if (c == 13) {
  2794                                  
  2795                                  @@ifEOL117:
  2796 00001D33 8A4604                   mov al, [bp+4]
  2797 00001D36 3C0D                     cmp al, 13
  2798 00001D38 0F851D00                 jne @@ifEOL118
  2799                                  
  2800                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2801                                  
  2802 00001D3C 6A01                     push 1
  2803 00001D3E FF36[9901]               push word [asm_fd]
  2804 00001D42 8D06[A501]               lea  ax, [DOS_ByteRead]
  2805 00001D46 50                       push ax
  2806 00001D47 E8BC17                   call readRL
  2807 00001D4A 83C406                   add  sp, 6
  2808 00001D4D A3[A301]                 mov word [DOS_NoBytes], ax
  2809                                  
  2810                                  ;-21     return 1;}
  2811                                  
  2812 00001D50 66B801000000             mov eax, 1
  2813 00001D56 E90900                   jmp @@retn
  2814                                  
  2815                                  ;-22   return 0;
  2816                                  
  2817                                  @@ifEOL118:
  2818 00001D59 66B800000000             mov eax, 0
  2819 00001D5F E90000                   jmp @@retn
  2820                                  
  2821                                  ;-23 }
  2822                                  
  2823                                  
  2824                                  ;-24 int skipBlank() {
  2825                                  
  2826 00001D62 C9                      @@retn: LEAVE
  2827 00001D63 C3                       ret
  2828                                  ; ENDP
  2829                                  
  2830                                  skipBlank:  ; *** PROC ***
  2831                                  
  2832                                  ;-25   skipblank1:
  2833                                  
  2834                                  @@skipblank1:
  2835                                  
  2836                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2837                                  
  2838 00001D64 8B1E[CE00]               mov bx, [InputPtr]
  2839 00001D68 8A07                     mov al, [bx]
  2840 00001D6A B400                     mov ah, 0
  2841 00001D6C 83F820                   cmp ax, 32
  2842 00001D6F 0F850600                 jne @@skipBlank119
  2843 00001D73 FF06[CE00]               inc  word [InputPtr]
  2844 00001D77 EBEB                     jmp @@skipblank1
  2845                                  
  2846                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2847                                  
  2848                                  @@skipBlank119:
  2849 00001D79 8B1E[CE00]               mov bx, [InputPtr]
  2850 00001D7D 8A07                     mov al, [bx]
  2851 00001D7F B400                     mov ah, 0
  2852 00001D81 83F809                   cmp ax, 9
  2853 00001D84 0F850600                 jne @@skipBlank120
  2854 00001D88 FF06[CE00]               inc  word [InputPtr]
  2855 00001D8C EBD6                     jmp @@skipblank1
  2856                                  
  2857                                  ;-28 }
  2858                                  
  2859                                  @@skipBlank120:
  2860                                  
  2861                                  ;-29 int letterE(char c) {
  2862                                  
  2863 00001D8E C3                       ret
  2864                                  ; ENDP
  2865                                  
  2866                                  letterE:  ; *** PROC ***
  2867                                  
  2868                                  ;-30   if (c=='_') return 1;
  2869                                  
  2870                                  ;Function : letterE, Number of local variables: 1
  2871                                  ;   # type sign width line used address name   list of local variables
  2872                                  ;  200 var sign byte    29 NULL bp+4    c;
  2873 00001D8F C8000000                 ENTER  0,0
  2874 00001D93 8A4604                   mov al, [bp+4]
  2875 00001D96 3C5F                     cmp al, 95
  2876 00001D98 0F850900                 jne @@letterE121
  2877 00001D9C 66B801000000             mov eax, 1
  2878 00001DA2 E97E00                   jmp @@retn
  2879                                  
  2880                                  ;-31   if (c=='.') return 1;
  2881                                  
  2882                                  @@letterE121:
  2883 00001DA5 8A4604                   mov al, [bp+4]
  2884 00001DA8 3C2E                     cmp al, 46
  2885 00001DAA 0F850900                 jne @@letterE122
  2886 00001DAE 66B801000000             mov eax, 1
  2887 00001DB4 E96C00                   jmp @@retn
  2888                                  
  2889                                  ;-32   if (c=='?') return 1;
  2890                                  
  2891                                  @@letterE122:
  2892 00001DB7 8A4604                   mov al, [bp+4]
  2893 00001DBA 3C3F                     cmp al, 63
  2894 00001DBC 0F850900                 jne @@letterE123
  2895 00001DC0 66B801000000             mov eax, 1
  2896 00001DC6 E95A00                   jmp @@retn
  2897                                  
  2898                                  ;-33   if (c=='$') return 1;
  2899                                  
  2900                                  @@letterE123:
  2901 00001DC9 8A4604                   mov al, [bp+4]
  2902 00001DCC 3C24                     cmp al, 36
  2903 00001DCE 0F850900                 jne @@letterE124
  2904 00001DD2 66B801000000             mov eax, 1
  2905 00001DD8 E94800                   jmp @@retn
  2906                                  
  2907                                  ;-34   if (c> 'z') return 0;
  2908                                  
  2909                                  @@letterE124:
  2910 00001DDB 8A4604                   mov al, [bp+4]
  2911 00001DDE 3C7A                     cmp al, 122
  2912 00001DE0 0F8E0900                 jle @@letterE125
  2913 00001DE4 66B800000000             mov eax, 0
  2914 00001DEA E93600                   jmp @@retn
  2915                                  
  2916                                  ;-35   if (c< '@') return 0; // at included
  2917                                  
  2918                                  @@letterE125:
  2919 00001DED 8A4604                   mov al, [bp+4]
  2920 00001DF0 3C40                     cmp al, 64
  2921 00001DF2 0F8D0900                 jge @@letterE126
  2922 00001DF6 66B800000000             mov eax, 0
  2923 00001DFC E92400                   jmp @@retn
  2924                                  
  2925                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2926                                  
  2927                                  @@letterE126:
  2928 00001DFF 8A4604                   mov al, [bp+4]
  2929 00001E02 3C5A                     cmp al, 90
  2930 00001E04 0F8E1200                 jle @@letterE127
  2931 00001E08 8A4604                   mov al, [bp+4]
  2932 00001E0B 3C61                     cmp al, 97
  2933 00001E0D 0F8D0900                 jge @@letterE128
  2934 00001E11 66B800000000             mov eax, 0
  2935 00001E17 E90900                   jmp @@retn
  2936                                  @@letterE128:
  2937                                  
  2938                                  ;-37   return 1;
  2939                                  
  2940                                  @@letterE127:
  2941 00001E1A 66B801000000             mov eax, 1
  2942 00001E20 E90000                   jmp @@retn
  2943                                  
  2944                                  ;-38 }
  2945                                  
  2946                                  
  2947                                  ;-39 int alnumE(char c) {
  2948                                  
  2949 00001E23 C9                      @@retn: LEAVE
  2950 00001E24 C3                       ret
  2951                                  ; ENDP
  2952                                  
  2953                                  alnumE:  ; *** PROC ***
  2954                                  
  2955                                  ;-40   if (digit(c)) return 1;
  2956                                  
  2957                                  ;Function : alnumE, Number of local variables: 1
  2958                                  ;   # type sign width line used address name   list of local variables
  2959                                  ;  200 var sign byte    39 NULL bp+4    c;
  2960 00001E25 C8000000                 ENTER  0,0
  2961 00001E29 8A4604                   mov al, byte [bp+4]
  2962 00001E2C B400                     mov ah, 0
  2963 00001E2E 50                       push ax
  2964 00001E2F E80616                   call digit
  2965 00001E32 83C402                   add  sp, 2
  2966 00001E35 08C0                     or  al, al
  2967 00001E37 0F840900                 je @@alnumE129
  2968 00001E3B 66B801000000             mov eax, 1
  2969 00001E41 E92400                   jmp @@retn
  2970                                  
  2971                                  ;-41   if (letterE(c)) return 1;
  2972                                  
  2973                                  @@alnumE129:
  2974 00001E44 8A4604                   mov al, byte [bp+4]
  2975 00001E47 B400                     mov ah, 0
  2976 00001E49 50                       push ax
  2977 00001E4A E842FF                   call letterE
  2978 00001E4D 83C402                   add  sp, 2
  2979 00001E50 08C0                     or  al, al
  2980 00001E52 0F840900                 je @@alnumE130
  2981 00001E56 66B801000000             mov eax, 1
  2982 00001E5C E90900                   jmp @@retn
  2983                                  
  2984                                  ;-42   return 0;
  2985                                  
  2986                                  @@alnumE130:
  2987 00001E5F 66B800000000             mov eax, 0
  2988 00001E65 E90000                   jmp @@retn
  2989                                  
  2990                                  ;-43 }
  2991                                  
  2992                                  
  2993                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2994                                  
  2995 00001E68 C9                      @@retn: LEAVE
  2996 00001E69 C3                       ret
  2997                                  ; ENDP
  2998                                  
  2999                                  getDigit:  ; *** PROC ***
  3000                                  
  3001                                  ;-45   unsigned int CastInt;
  3002                                  
  3003                                  
  3004                                  ;-46   SymbolInt=0;
  3005                                  
  3006                                  ;Function : getDigit, Number of local variables: 2
  3007                                  ;   # type sign width line used address name   list of local variables
  3008                                  ;  200 var unsg byte    44 NULL bp+4    c
  3009                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3010 00001E6A C8020000                 ENTER  2,0
  3011 00001E6E 66B800000000             mov eax, 0
  3012 00001E74 A3[4D00]                 mov word [SymbolInt], ax
  3013                                  
  3014                                  ;-47   do {
  3015                                  
  3016                                  @@getDigit131:
  3017                                  
  3018                                  ;-48     c-='0';
  3019                                  
  3020 00001E77 806E0430                 sub  byte [bp+4], 48
  3021                                  
  3022                                  ;-49     SymbolInt=SymbolInt*10;
  3023                                  
  3024 00001E7B A1[4D00]                 mov ax, [SymbolInt]
  3025 00001E7E 66BB0A000000             mov ebx, 10
  3026 00001E84 66F7E3                   mul ebx
  3027 00001E87 A3[4D00]                 mov word [SymbolInt], ax
  3028                                  
  3029                                  ;-50     ax=0; CastInt=c; //cast b2w
  3030                                  
  3031 00001E8A B80000                   mov  ax, 0
  3032 00001E8D 8A4604                   mov al, [bp+4]
  3033 00001E90 8946FE                   mov word [bp-2], ax
  3034                                  
  3035                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3036                                  
  3037 00001E93 A1[4D00]                 mov ax, [SymbolInt]
  3038 00001E96 0346FE                   add ax, [bp-2]
  3039 00001E99 A3[4D00]                 mov word [SymbolInt], ax
  3040                                  
  3041                                  ;-52     InputPtr++;
  3042                                  
  3043 00001E9C FF06[CE00]               inc  word [InputPtr]
  3044                                  
  3045                                  ;-53     c = *InputPtr;
  3046                                  
  3047 00001EA0 8B1E[CE00]               mov bx, [InputPtr]
  3048 00001EA4 8A07                     mov al, [bx]
  3049 00001EA6 B400                     mov ah, 0
  3050 00001EA8 884604                   mov byte [bp+4], al
  3051                                  
  3052                                  ;-54   } while(digit(c));
  3053                                  
  3054 00001EAB 8A4604                   mov al, byte [bp+4]
  3055 00001EAE B400                     mov ah, 0
  3056 00001EB0 50                       push ax
  3057 00001EB1 E88415                   call digit
  3058 00001EB4 83C402                   add  sp, 2
  3059 00001EB7 08C0                     or  al, al
  3060 00001EB9 0F840200                 je @@getDigit132
  3061 00001EBD EBB8                     jmp @@getDigit131
  3062                                  @@getDigit132:
  3063                                  
  3064                                  ;-55 }
  3065                                  
  3066                                  
  3067                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3068 00001EBF C9                       LEAVE
  3069 00001EC0 C3                       ret
  3070                                  ; ENDP
  3071                                  
  3072                                  getName:  ; *** PROC ***
  3073                                  
  3074                                  ;-57   char *p; unsigned int i;
  3075                                  
  3076                                  
  3077                                  ;-58   p = &Symbol;
  3078                                  
  3079                                  ;Function : getName, Number of local variables: 3
  3080                                  ;   # type sign width line used address name   list of local variables
  3081                                  ;  200 var unsg byte    56 NULL bp+4    c
  3082                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3083                                  ;  202 var unsg word    57 NULL bp-4    i;
  3084 00001EC1 C8040000                 ENTER  4,0
  3085 00001EC5 B8[0F00]                 mov ax, Symbol
  3086 00001EC8 8946FE                   mov word [bp-2], ax
  3087                                  
  3088                                  ;-59   *p = c;
  3089                                  
  3090 00001ECB 8A4604                   mov al, [bp+4]
  3091 00001ECE 8B5EFE                   mov  bx, [bp-2]
  3092 00001ED1 8807                     mov  [bx], al
  3093                                  
  3094                                  ;-60   p++;
  3095                                  
  3096 00001ED3 FF46FE                   inc  word [bp-2]
  3097                                  
  3098                                  ;-61   while (alnumE(c)) {
  3099                                  
  3100                                  @@getName133:
  3101 00001ED6 8A4604                   mov al, byte [bp+4]
  3102 00001ED9 B400                     mov ah, 0
  3103 00001EDB 50                       push ax
  3104 00001EDC E846FF                   call alnumE
  3105 00001EDF 83C402                   add  sp, 2
  3106 00001EE2 08C0                     or  al, al
  3107 00001EE4 0F843800                 je @@getName134
  3108                                  
  3109                                  ;-62     InputPtr++;
  3110                                  
  3111 00001EE8 FF06[CE00]               inc  word [InputPtr]
  3112                                  
  3113                                  ;-63     c = *InputPtr;
  3114                                  
  3115 00001EEC 8B1E[CE00]               mov bx, [InputPtr]
  3116 00001EF0 8A07                     mov al, [bx]
  3117 00001EF2 B400                     mov ah, 0
  3118 00001EF4 884604                   mov byte [bp+4], al
  3119                                  
  3120                                  ;-64     *p = c;
  3121                                  
  3122 00001EF7 8A4604                   mov al, [bp+4]
  3123 00001EFA 8B5EFE                   mov  bx, [bp-2]
  3124 00001EFD 8807                     mov  [bx], al
  3125                                  
  3126                                  ;-65     p++;
  3127                                  
  3128 00001EFF FF46FE                   inc  word [bp-2]
  3129                                  
  3130                                  ;-66     i = p - &Symbol;
  3131                                  
  3132 00001F02 8B46FE                   mov ax, [bp-2]
  3133 00001F05 2D[0F00]                 sub ax, Symbol
  3134 00001F08 8946FC                   mov word [bp-4], ax
  3135                                  
  3136                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3137                                  
  3138 00001F0B 8B46FC                   mov ax, [bp-4]
  3139 00001F0E 83F81F                   cmp ax, 31 ;unsigned : 0
  3140 00001F11 0F820900                 jb  @@getName135
  3141 00001F15 68[691F]                 push getName_0
  3142 00001F18 E86807                   call errorexit
  3143 00001F1B 83C402                   add  sp, 2
  3144                                  
  3145                                  ;-68   }
  3146                                  
  3147                                  @@getName135:
  3148                                  
  3149                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3150                                  
  3151 00001F1E EBB6                     jmp @@getName133
  3152                                  @@getName134:
  3153 00001F20 8A4604                   mov al, [bp+4]
  3154 00001F23 3C3A                     cmp al, 58
  3155 00001F25 0F850C00                 jne @@getName136
  3156 00001F29 66B801000000             mov eax, 1
  3157 00001F2F A2[AA01]                 mov byte [isLabel], al
  3158 00001F32 E90900                   jmp @@getName137
  3159                                  @@getName136:
  3160 00001F35 66B800000000             mov eax, 0
  3161 00001F3B A2[AA01]                 mov byte [isLabel], al
  3162                                  
  3163                                  ;-70   p--;
  3164                                  
  3165                                  @@getName137:
  3166 00001F3E FF4EFE                   dec  word [bp-2]
  3167                                  
  3168                                  ;-71   *p = 0;
  3169                                  
  3170 00001F41 66B800000000             mov eax, 0
  3171 00001F47 8B5EFE                   mov  bx, [bp-2]
  3172 00001F4A 8807                     mov  [bx], al
  3173                                  
  3174                                  ;-72   strcpy(SymbolUpper, Symbol);
  3175                                  
  3176 00001F4C 8D06[0F00]               lea  ax, [Symbol]
  3177 00001F50 50                       push ax
  3178 00001F51 8D06[2E00]               lea  ax, [SymbolUpper]
  3179 00001F55 50                       push ax
  3180 00001F56 E8A614                   call strcpy
  3181 00001F59 83C404                   add  sp, 4
  3182                                  
  3183                                  ;-73   toupper(SymbolUpper);
  3184                                  
  3185 00001F5C 8D06[2E00]               lea  ax, [SymbolUpper]
  3186 00001F60 50                       push ax
  3187 00001F61 E82D14                   call toupper
  3188 00001F64 83C402                   add  sp, 2
  3189                                  
  3190                                  ;-74 }
  3191                                  
  3192                                  
  3193                                  ;-75 int testReg() {
  3194 00001F67 C9                       LEAVE
  3195 00001F68 C3                       ret
  3196                                  ; ENDP
  3197 00001F69 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3198 00001F72 6F206C6F6E6700     
  3199                                  
  3200                                  testReg:  ; *** PROC ***
  3201                                  
  3202                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3203                                  
  3204                                  
  3205                                  ;-77   R2Type=0;
  3206                                  
  3207 00001F79 66B800000000             mov eax, 0
  3208 00001F7F A2[B401]                 mov byte [R2Type], al
  3209                                  
  3210                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3211                                  
  3212 00001F82 8D06[0F00]               lea  ax, [Symbol]
  3213 00001F86 50                       push ax
  3214 00001F87 E84A14                   call strlen
  3215 00001F8A 83C402                   add  sp, 2
  3216 00001F8D 3C02                     cmp al, 2
  3217 00001F8F 0F8D0900                 jge @@testReg138
  3218 00001F93 66B800000000             mov eax, 0
  3219 00001F99 E9B603                   jmp @@retn
  3220                                  
  3221                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3222                                  
  3223                                  @@testReg138:
  3224 00001F9C 8D06[0F00]               lea  ax, [Symbol]
  3225 00001FA0 50                       push ax
  3226 00001FA1 E83014                   call strlen
  3227 00001FA4 83C402                   add  sp, 2
  3228 00001FA7 3C03                     cmp al, 3
  3229 00001FA9 0F8E0900                 jle @@testReg139
  3230 00001FAD 66B800000000             mov eax, 0
  3231 00001FB3 E99C03                   jmp @@retn
  3232                                  
  3233                                  ;-80   R2Type=BYTE;
  3234                                  
  3235                                  @@testReg139:
  3236 00001FB6 66B801000000             mov eax, 1
  3237 00001FBC A2[B401]                 mov byte [R2Type], al
  3238                                  
  3239                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3240                                  
  3241 00001FBF 68[5323]                 push testReg_0
  3242 00001FC2 8D06[2E00]               lea  ax, [SymbolUpper]
  3243 00001FC6 50                       push ax
  3244 00001FC7 E8A114                   call eqstr
  3245 00001FCA 83C404                   add  sp, 4
  3246 00001FCD 08C0                     or  al, al
  3247 00001FCF 0F840900                 je @@testReg140
  3248 00001FD3 66B800000000             mov eax, 0
  3249 00001FD9 E97603                   jmp @@retn
  3250                                  
  3251                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3252                                  
  3253                                  @@testReg140:
  3254 00001FDC 68[5623]                 push testReg_1
  3255 00001FDF 8D06[2E00]               lea  ax, [SymbolUpper]
  3256 00001FE3 50                       push ax
  3257 00001FE4 E88414                   call eqstr
  3258 00001FE7 83C404                   add  sp, 4
  3259 00001FEA 08C0                     or  al, al
  3260 00001FEC 0F840900                 je @@testReg141
  3261 00001FF0 66B801000000             mov eax, 1
  3262 00001FF6 E95903                   jmp @@retn
  3263                                  
  3264                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3265                                  
  3266                                  @@testReg141:
  3267 00001FF9 68[5923]                 push testReg_2
  3268 00001FFC 8D06[2E00]               lea  ax, [SymbolUpper]
  3269 00002000 50                       push ax
  3270 00002001 E86714                   call eqstr
  3271 00002004 83C404                   add  sp, 4
  3272 00002007 08C0                     or  al, al
  3273 00002009 0F840900                 je @@testReg142
  3274 0000200D 66B802000000             mov eax, 2
  3275 00002013 E93C03                   jmp @@retn
  3276                                  
  3277                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3278                                  
  3279                                  @@testReg142:
  3280 00002016 68[5C23]                 push testReg_3
  3281 00002019 8D06[2E00]               lea  ax, [SymbolUpper]
  3282 0000201D 50                       push ax
  3283 0000201E E84A14                   call eqstr
  3284 00002021 83C404                   add  sp, 4
  3285 00002024 08C0                     or  al, al
  3286 00002026 0F840900                 je @@testReg143
  3287 0000202A 66B803000000             mov eax, 3
  3288 00002030 E91F03                   jmp @@retn
  3289                                  
  3290                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3291                                  
  3292                                  @@testReg143:
  3293 00002033 68[5F23]                 push testReg_4
  3294 00002036 8D06[2E00]               lea  ax, [SymbolUpper]
  3295 0000203A 50                       push ax
  3296 0000203B E82D14                   call eqstr
  3297 0000203E 83C404                   add  sp, 4
  3298 00002041 08C0                     or  al, al
  3299 00002043 0F840900                 je @@testReg144
  3300 00002047 66B804000000             mov eax, 4
  3301 0000204D E90203                   jmp @@retn
  3302                                  
  3303                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3304                                  
  3305                                  @@testReg144:
  3306 00002050 68[6223]                 push testReg_5
  3307 00002053 8D06[2E00]               lea  ax, [SymbolUpper]
  3308 00002057 50                       push ax
  3309 00002058 E81014                   call eqstr
  3310 0000205B 83C404                   add  sp, 4
  3311 0000205E 08C0                     or  al, al
  3312 00002060 0F840900                 je @@testReg145
  3313 00002064 66B805000000             mov eax, 5
  3314 0000206A E9E502                   jmp @@retn
  3315                                  
  3316                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3317                                  
  3318                                  @@testReg145:
  3319 0000206D 68[6523]                 push testReg_6
  3320 00002070 8D06[2E00]               lea  ax, [SymbolUpper]
  3321 00002074 50                       push ax
  3322 00002075 E8F313                   call eqstr
  3323 00002078 83C404                   add  sp, 4
  3324 0000207B 08C0                     or  al, al
  3325 0000207D 0F840900                 je @@testReg146
  3326 00002081 66B806000000             mov eax, 6
  3327 00002087 E9C802                   jmp @@retn
  3328                                  
  3329                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3330                                  
  3331                                  @@testReg146:
  3332 0000208A 68[6823]                 push testReg_7
  3333 0000208D 8D06[2E00]               lea  ax, [SymbolUpper]
  3334 00002091 50                       push ax
  3335 00002092 E8D613                   call eqstr
  3336 00002095 83C404                   add  sp, 4
  3337 00002098 08C0                     or  al, al
  3338 0000209A 0F840900                 je @@testReg147
  3339 0000209E 66B807000000             mov eax, 7
  3340 000020A4 E9AB02                   jmp @@retn
  3341                                  
  3342                                  ;-89   R2Type=WORD;
  3343                                  
  3344                                  @@testReg147:
  3345 000020A7 66B802000000             mov eax, 2
  3346 000020AD A2[B401]                 mov byte [R2Type], al
  3347                                  
  3348                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3349                                  
  3350 000020B0 68[6B23]                 push testReg_8
  3351 000020B3 8D06[2E00]               lea  ax, [SymbolUpper]
  3352 000020B7 50                       push ax
  3353 000020B8 E8B013                   call eqstr
  3354 000020BB 83C404                   add  sp, 4
  3355 000020BE 08C0                     or  al, al
  3356 000020C0 0F840900                 je @@testReg148
  3357 000020C4 66B800000000             mov eax, 0
  3358 000020CA E98502                   jmp @@retn
  3359                                  
  3360                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3361                                  
  3362                                  @@testReg148:
  3363 000020CD 68[6E23]                 push testReg_9
  3364 000020D0 8D06[2E00]               lea  ax, [SymbolUpper]
  3365 000020D4 50                       push ax
  3366 000020D5 E89313                   call eqstr
  3367 000020D8 83C404                   add  sp, 4
  3368 000020DB 08C0                     or  al, al
  3369 000020DD 0F840900                 je @@testReg149
  3370 000020E1 66B801000000             mov eax, 1
  3371 000020E7 E96802                   jmp @@retn
  3372                                  
  3373                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3374                                  
  3375                                  @@testReg149:
  3376 000020EA 68[7123]                 push testReg_10
  3377 000020ED 8D06[2E00]               lea  ax, [SymbolUpper]
  3378 000020F1 50                       push ax
  3379 000020F2 E87613                   call eqstr
  3380 000020F5 83C404                   add  sp, 4
  3381 000020F8 08C0                     or  al, al
  3382 000020FA 0F840900                 je @@testReg150
  3383 000020FE 66B802000000             mov eax, 2
  3384 00002104 E94B02                   jmp @@retn
  3385                                  
  3386                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3387                                  
  3388                                  @@testReg150:
  3389 00002107 68[7423]                 push testReg_11
  3390 0000210A 8D06[2E00]               lea  ax, [SymbolUpper]
  3391 0000210E 50                       push ax
  3392 0000210F E85913                   call eqstr
  3393 00002112 83C404                   add  sp, 4
  3394 00002115 08C0                     or  al, al
  3395 00002117 0F840900                 je @@testReg151
  3396 0000211B 66B803000000             mov eax, 3
  3397 00002121 E92E02                   jmp @@retn
  3398                                  
  3399                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3400                                  
  3401                                  @@testReg151:
  3402 00002124 68[7723]                 push testReg_12
  3403 00002127 8D06[2E00]               lea  ax, [SymbolUpper]
  3404 0000212B 50                       push ax
  3405 0000212C E83C13                   call eqstr
  3406 0000212F 83C404                   add  sp, 4
  3407 00002132 08C0                     or  al, al
  3408 00002134 0F840900                 je @@testReg152
  3409 00002138 66B804000000             mov eax, 4
  3410 0000213E E91102                   jmp @@retn
  3411                                  
  3412                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3413                                  
  3414                                  @@testReg152:
  3415 00002141 68[7A23]                 push testReg_13
  3416 00002144 8D06[2E00]               lea  ax, [SymbolUpper]
  3417 00002148 50                       push ax
  3418 00002149 E81F13                   call eqstr
  3419 0000214C 83C404                   add  sp, 4
  3420 0000214F 08C0                     or  al, al
  3421 00002151 0F840900                 je @@testReg153
  3422 00002155 66B805000000             mov eax, 5
  3423 0000215B E9F401                   jmp @@retn
  3424                                  
  3425                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3426                                  
  3427                                  @@testReg153:
  3428 0000215E 68[7D23]                 push testReg_14
  3429 00002161 8D06[2E00]               lea  ax, [SymbolUpper]
  3430 00002165 50                       push ax
  3431 00002166 E80213                   call eqstr
  3432 00002169 83C404                   add  sp, 4
  3433 0000216C 08C0                     or  al, al
  3434 0000216E 0F840900                 je @@testReg154
  3435 00002172 66B806000000             mov eax, 6
  3436 00002178 E9D701                   jmp @@retn
  3437                                  
  3438                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3439                                  
  3440                                  @@testReg154:
  3441 0000217B 68[8023]                 push testReg_15
  3442 0000217E 8D06[2E00]               lea  ax, [SymbolUpper]
  3443 00002182 50                       push ax
  3444 00002183 E8E512                   call eqstr
  3445 00002186 83C404                   add  sp, 4
  3446 00002189 08C0                     or  al, al
  3447 0000218B 0F840900                 je @@testReg155
  3448 0000218F 66B807000000             mov eax, 7
  3449 00002195 E9BA01                   jmp @@retn
  3450                                  
  3451                                  ;-98   R2Type=SEGREG;
  3452                                  
  3453                                  @@testReg155:
  3454 00002198 66B804000000             mov eax, 4
  3455 0000219E A2[B401]                 mov byte [R2Type], al
  3456                                  
  3457                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3458                                  
  3459 000021A1 68[8323]                 push testReg_16
  3460 000021A4 8D06[2E00]               lea  ax, [SymbolUpper]
  3461 000021A8 50                       push ax
  3462 000021A9 E8BF12                   call eqstr
  3463 000021AC 83C404                   add  sp, 4
  3464 000021AF 08C0                     or  al, al
  3465 000021B1 0F840900                 je @@testReg156
  3466 000021B5 66B800000000             mov eax, 0
  3467 000021BB E99401                   jmp @@retn
  3468                                  
  3469                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3470                                  
  3471                                  @@testReg156:
  3472 000021BE 68[8623]                 push testReg_17
  3473 000021C1 8D06[2E00]               lea  ax, [SymbolUpper]
  3474 000021C5 50                       push ax
  3475 000021C6 E8A212                   call eqstr
  3476 000021C9 83C404                   add  sp, 4
  3477 000021CC 08C0                     or  al, al
  3478 000021CE 0F840900                 je @@testReg157
  3479 000021D2 66B801000000             mov eax, 1
  3480 000021D8 E97701                   jmp @@retn
  3481                                  
  3482                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3483                                  
  3484                                  @@testReg157:
  3485 000021DB 68[8923]                 push testReg_18
  3486 000021DE 8D06[2E00]               lea  ax, [SymbolUpper]
  3487 000021E2 50                       push ax
  3488 000021E3 E88512                   call eqstr
  3489 000021E6 83C404                   add  sp, 4
  3490 000021E9 08C0                     or  al, al
  3491 000021EB 0F840900                 je @@testReg158
  3492 000021EF 66B802000000             mov eax, 2
  3493 000021F5 E95A01                   jmp @@retn
  3494                                  
  3495                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3496                                  
  3497                                  @@testReg158:
  3498 000021F8 68[8C23]                 push testReg_19
  3499 000021FB 8D06[2E00]               lea  ax, [SymbolUpper]
  3500 000021FF 50                       push ax
  3501 00002200 E86812                   call eqstr
  3502 00002203 83C404                   add  sp, 4
  3503 00002206 08C0                     or  al, al
  3504 00002208 0F840900                 je @@testReg159
  3505 0000220C 66B803000000             mov eax, 3
  3506 00002212 E93D01                   jmp @@retn
  3507                                  
  3508                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3509                                  
  3510                                  @@testReg159:
  3511 00002215 68[8F23]                 push testReg_20
  3512 00002218 8D06[2E00]               lea  ax, [SymbolUpper]
  3513 0000221C 50                       push ax
  3514 0000221D E84B12                   call eqstr
  3515 00002220 83C404                   add  sp, 4
  3516 00002223 08C0                     or  al, al
  3517 00002225 0F840900                 je @@testReg160
  3518 00002229 66B804000000             mov eax, 4
  3519 0000222F E92001                   jmp @@retn
  3520                                  
  3521                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3522                                  
  3523                                  @@testReg160:
  3524 00002232 68[9223]                 push testReg_21
  3525 00002235 8D06[2E00]               lea  ax, [SymbolUpper]
  3526 00002239 50                       push ax
  3527 0000223A E82E12                   call eqstr
  3528 0000223D 83C404                   add  sp, 4
  3529 00002240 08C0                     or  al, al
  3530 00002242 0F840900                 je @@testReg161
  3531 00002246 66B805000000             mov eax, 5
  3532 0000224C E90301                   jmp @@retn
  3533                                  
  3534                                  ;-105   R2Type=DWORD;                         
  3535                                  
  3536                                  @@testReg161:
  3537 0000224F 66B803000000             mov eax, 3
  3538 00002255 A2[B401]                 mov byte [R2Type], al
  3539                                  
  3540                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3541                                  
  3542 00002258 68[9523]                 push testReg_22
  3543 0000225B 8D06[2E00]               lea  ax, [SymbolUpper]
  3544 0000225F 50                       push ax
  3545 00002260 E80812                   call eqstr
  3546 00002263 83C404                   add  sp, 4
  3547 00002266 08C0                     or  al, al
  3548 00002268 0F840900                 je @@testReg162
  3549 0000226C 66B800000000             mov eax, 0
  3550 00002272 E9DD00                   jmp @@retn
  3551                                  
  3552                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3553                                  
  3554                                  @@testReg162:
  3555 00002275 68[9923]                 push testReg_23
  3556 00002278 8D06[2E00]               lea  ax, [SymbolUpper]
  3557 0000227C 50                       push ax
  3558 0000227D E8EB11                   call eqstr
  3559 00002280 83C404                   add  sp, 4
  3560 00002283 08C0                     or  al, al
  3561 00002285 0F840900                 je @@testReg163
  3562 00002289 66B801000000             mov eax, 1
  3563 0000228F E9C000                   jmp @@retn
  3564                                  
  3565                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3566                                  
  3567                                  @@testReg163:
  3568 00002292 68[9D23]                 push testReg_24
  3569 00002295 8D06[2E00]               lea  ax, [SymbolUpper]
  3570 00002299 50                       push ax
  3571 0000229A E8CE11                   call eqstr
  3572 0000229D 83C404                   add  sp, 4
  3573 000022A0 08C0                     or  al, al
  3574 000022A2 0F840900                 je @@testReg164
  3575 000022A6 66B802000000             mov eax, 2
  3576 000022AC E9A300                   jmp @@retn
  3577                                  
  3578                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3579                                  
  3580                                  @@testReg164:
  3581 000022AF 68[A123]                 push testReg_25
  3582 000022B2 8D06[2E00]               lea  ax, [SymbolUpper]
  3583 000022B6 50                       push ax
  3584 000022B7 E8B111                   call eqstr
  3585 000022BA 83C404                   add  sp, 4
  3586 000022BD 08C0                     or  al, al
  3587 000022BF 0F840900                 je @@testReg165
  3588 000022C3 66B803000000             mov eax, 3
  3589 000022C9 E98600                   jmp @@retn
  3590                                  
  3591                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3592                                  
  3593                                  @@testReg165:
  3594 000022CC 68[A523]                 push testReg_26
  3595 000022CF 8D06[2E00]               lea  ax, [SymbolUpper]
  3596 000022D3 50                       push ax
  3597 000022D4 E89411                   call eqstr
  3598 000022D7 83C404                   add  sp, 4
  3599 000022DA 08C0                     or  al, al
  3600 000022DC 0F840900                 je @@testReg166
  3601 000022E0 66B804000000             mov eax, 4
  3602 000022E6 E96900                   jmp @@retn
  3603                                  
  3604                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3605                                  
  3606                                  @@testReg166:
  3607 000022E9 68[A923]                 push testReg_27
  3608 000022EC 8D06[2E00]               lea  ax, [SymbolUpper]
  3609 000022F0 50                       push ax
  3610 000022F1 E87711                   call eqstr
  3611 000022F4 83C404                   add  sp, 4
  3612 000022F7 08C0                     or  al, al
  3613 000022F9 0F840900                 je @@testReg167
  3614 000022FD 66B805000000             mov eax, 5
  3615 00002303 E94C00                   jmp @@retn
  3616                                  
  3617                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3618                                  
  3619                                  @@testReg167:
  3620 00002306 68[AD23]                 push testReg_28
  3621 00002309 8D06[2E00]               lea  ax, [SymbolUpper]
  3622 0000230D 50                       push ax
  3623 0000230E E85A11                   call eqstr
  3624 00002311 83C404                   add  sp, 4
  3625 00002314 08C0                     or  al, al
  3626 00002316 0F840900                 je @@testReg168
  3627 0000231A 66B806000000             mov eax, 6
  3628 00002320 E92F00                   jmp @@retn
  3629                                  
  3630                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3631                                  
  3632                                  @@testReg168:
  3633 00002323 68[B123]                 push testReg_29
  3634 00002326 8D06[2E00]               lea  ax, [SymbolUpper]
  3635 0000232A 50                       push ax
  3636 0000232B E83D11                   call eqstr
  3637 0000232E 83C404                   add  sp, 4
  3638 00002331 08C0                     or  al, al
  3639 00002333 0F840900                 je @@testReg169
  3640 00002337 66B807000000             mov eax, 7
  3641 0000233D E91200                   jmp @@retn
  3642                                  
  3643                                  ;-114   R2Type=0; return 0;
  3644                                  
  3645                                  @@testReg169:
  3646 00002340 66B800000000             mov eax, 0
  3647 00002346 A2[B401]                 mov byte [R2Type], al
  3648 00002349 66B800000000             mov eax, 0
  3649 0000234F E90000                   jmp @@retn
  3650                                  
  3651                                  ;-115 }
  3652                                  
  3653                                  @@retn:
  3654 00002352 C3                       ret
  3655                                  ; ENDP
  3656 00002353 414C00                  testReg_0 db "AL",0
  3657 00002356 434C00                  testReg_1 db "CL",0
  3658 00002359 444C00                  testReg_2 db "DL",0
  3659 0000235C 424C00                  testReg_3 db "BL",0
  3660 0000235F 414800                  testReg_4 db "AH",0
  3661 00002362 434800                  testReg_5 db "CH",0
  3662 00002365 444800                  testReg_6 db "DH",0
  3663 00002368 424800                  testReg_7 db "BH",0
  3664 0000236B 415800                  testReg_8 db "AX",0
  3665 0000236E 435800                  testReg_9 db "CX",0
  3666 00002371 445800                  testReg_10 db "DX",0
  3667 00002374 425800                  testReg_11 db "BX",0
  3668 00002377 535000                  testReg_12 db "SP",0
  3669 0000237A 425000                  testReg_13 db "BP",0
  3670 0000237D 534900                  testReg_14 db "SI",0
  3671 00002380 444900                  testReg_15 db "DI",0
  3672 00002383 455300                  testReg_16 db "ES",0
  3673 00002386 435300                  testReg_17 db "CS",0
  3674 00002389 535300                  testReg_18 db "SS",0
  3675 0000238C 445300                  testReg_19 db "DS",0
  3676 0000238F 465300                  testReg_20 db "FS",0
  3677 00002392 475300                  testReg_21 db "GS",0
  3678 00002395 45415800                testReg_22 db "EAX",0
  3679 00002399 45435800                testReg_23 db "ECX",0
  3680 0000239D 45445800                testReg_24 db "EDX",0
  3681 000023A1 45425800                testReg_25 db "EBX",0
  3682 000023A5 45535000                testReg_26 db "ESP",0
  3683 000023A9 45425000                testReg_27 db "EBP",0
  3684 000023AD 45534900                testReg_28 db "ESI",0
  3685 000023B1 45444900                testReg_29 db "EDI",0
  3686                                  ;Back to main program: AS.C
  3687                                  
  3688                                  ;-7 #include "OUTPUT.C"
  3689                                  
  3690                                  ;Use include file: OUTPUT.C
  3691                                  
  3692                                  ;-1 int printLine() { 
  3693                                  
  3694                                  
  3695                                  printLine:  ; *** PROC ***
  3696                                  
  3697                                  ;-2     int i; char c;
  3698                                  
  3699                                  
  3700                                  ;-3     prs("\n"); 
  3701                                  
  3702                                  ;Function : printLine, Number of local variables: 2
  3703                                  ;   # type sign width line used address name   list of local variables
  3704                                  ;  200 var sign word     2 NULL bp-2    i
  3705                                  ;  201 var sign byte     2 NULL bp-4    c;
  3706 000023B5 C8040000                 ENTER  4,0
  3707 000023B9 68[4A24]                 push printLine_0
  3708 000023BC E80401                   call prs
  3709 000023BF 83C402                   add  sp, 2
  3710                                  
  3711                                  ;-4     printhex16(PCStart);
  3712                                  
  3713 000023C2 FF36[A801]               push word [PCStart]
  3714 000023C6 E8EF01                   call printhex16
  3715 000023C9 83C402                   add  sp, 2
  3716                                  
  3717                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3718                                  
  3719 000023CC A1[C501]                 mov ax, [OpPrintIndex]
  3720 000023CF 83F800                   cmp ax, 0
  3721 000023D2 0F850C00                 jne @@printLine170
  3722 000023D6 68[4D24]                 push printLine_1
  3723 000023D9 E8E700                   call prs
  3724 000023DC 83C402                   add  sp, 2
  3725                                  
  3726                                  ;-6     else {
  3727                                  
  3728 000023DF E95B00                   jmp @@printLine171
  3729                                  @@printLine170:
  3730                                  
  3731                                  ;-7         prc(PrintR);
  3732                                  
  3733 000023E2 A0[C901]                 mov al, byte [PrintR]
  3734 000023E5 B400                     mov ah, 0
  3735 000023E7 50                       push ax
  3736 000023E8 E87700                   call prc
  3737 000023EB 83C402                   add  sp, 2
  3738                                  
  3739                                  ;-8         i=0;
  3740                                  
  3741 000023EE 66B800000000             mov eax, 0
  3742 000023F4 8946FE                   mov word [bp-2], ax
  3743                                  
  3744                                  ;-9         do {
  3745                                  
  3746                                  @@printLine172:
  3747                                  
  3748                                  ;-10             c=OpPos[i];
  3749                                  
  3750 000023F7 8B5EFE                   mov bx, [bp-2]
  3751 000023FA 8A87[C001]               mov al, [OpPos + bx]
  3752 000023FE 8846FC                   mov byte [bp-4], al
  3753                                  
  3754                                  ;-11             printhex8a(c); 
  3755                                  
  3756 00002401 8A46FC                   mov al, byte [bp-4]
  3757 00002404 B400                     mov ah, 0
  3758 00002406 50                       push ax
  3759 00002407 E85C01                   call printhex8a
  3760 0000240A 83C402                   add  sp, 2
  3761                                  
  3762                                  ;-12             prc(' ');
  3763                                  
  3764 0000240D 6A20                     push 32
  3765 0000240F E85000                   call prc
  3766 00002412 83C402                   add  sp, 2
  3767                                  
  3768                                  ;-13             i++;
  3769                                  
  3770 00002415 FF46FE                   inc  word [bp-2]
  3771                                  
  3772                                  ;-14         } while (i < OpPrintIndex);
  3773                                  
  3774 00002418 8B46FE                   mov ax, [bp-2]
  3775 0000241B 3B06[C501]               cmp ax, [OpPrintIndex]
  3776 0000241F 0F8D0200                 jge @@printLine173
  3777 00002423 EBD2                     jmp @@printLine172
  3778                                  @@printLine173:
  3779                                  
  3780                                  ;-15         do {// fill rest with blank
  3781                                  
  3782                                  @@printLine174:
  3783                                  
  3784                                  ;-16             prs("   ");
  3785                                  
  3786 00002425 68[5E24]                 push printLine_2
  3787 00002428 E89800                   call prs
  3788 0000242B 83C402                   add  sp, 2
  3789                                  
  3790                                  ;-17             i++;
  3791                                  
  3792 0000242E FF46FE                   inc  word [bp-2]
  3793                                  
  3794                                  ;-18         } while (i < OPMAXLEN);
  3795                                  
  3796 00002431 8B46FE                   mov ax, [bp-2]
  3797 00002434 83F805                   cmp ax, 5
  3798 00002437 0F8D0200                 jge @@printLine175
  3799 0000243B EBE8                     jmp @@printLine174
  3800                                  @@printLine175:
  3801                                  
  3802                                  ;-19     }
  3803                                  
  3804                                  
  3805                                  ;-20     prscomment(InputBuf);
  3806                                  
  3807                                  @@printLine171:
  3808 0000243D 8D06[4F00]               lea  ax, [InputBuf]
  3809 00002441 50                       push ax
  3810 00002442 E85000                   call prscomment
  3811 00002445 83C402                   add  sp, 2
  3812                                  
  3813                                  ;-21 }
  3814                                  
  3815                                  
  3816                                  ;-22 int prc(unsigned char c) {//print char 
  3817 00002448 C9                       LEAVE
  3818 00002449 C3                       ret
  3819                                  ; ENDP
  3820 0000244A 5C6E00                  printLine_0 db "\n",0
  3821 0000244D 202020202020202020-     printLine_1 db "                ",0
  3822 00002456 2020202020202000   
  3823 0000245E 20202000                printLine_2 db "   ",0
  3824                                  
  3825                                  prc:  ; *** PROC ***
  3826                                  
  3827                                  ;-23     if (LIST) { 
  3828                                  
  3829                                  ;Function : prc, Number of local variables: 1
  3830                                  ;   # type sign width line used address name   list of local variables
  3831                                  ;  200 var unsg byte    22 NULL bp+4    c;
  3832 00002462 C8000000                 ENTER  0,0
  3833 00002466 A0[0E00]                 mov al, [LIST]
  3834 00002469 08C0                     or  al, al
  3835 0000246B 0F841400                 je @@prc176
  3836                                  
  3837                                  ;-24         if ( _ c==10) {
  3838                                  
  3839 0000246F 807E040A                cmp byte [bp+4], 10
  3840 00002473 0F850600                 jne @@prc177
  3841                                  
  3842                                  ;-25             ax=13; 
  3843                                  
  3844 00002477 B80D00                   mov  ax, 13
  3845                                  
  3846                                  ;-26             writetty(); 
  3847                                  
  3848 0000247A E8DE0E                   call writetty
  3849                                  
  3850                                  ;-27             }
  3851                                  
  3852                                  
  3853                                  ;-28         al=c; 
  3854                                  
  3855                                  @@prc177:
  3856 0000247D 8A4604                   mov  al, [bp+4]
  3857                                  
  3858                                  ;-29         writetty(); 
  3859                                  
  3860 00002480 E8D80E                   call writetty
  3861                                  
  3862                                  ;-30         }
  3863                                  
  3864                                  
  3865                                  ;-31     fputcR(c,lst_fd); 
  3866                                  
  3867                                  @@prc176:
  3868 00002483 FF36[9B01]               push word [lst_fd]
  3869 00002487 8A4604                   mov al, byte [bp+4]
  3870 0000248A B400                     mov ah, 0
  3871 0000248C 50                       push ax
  3872 0000248D E88B10                   call fputcR
  3873 00002490 83C404                   add  sp, 4
  3874                                  
  3875                                  ;-32 }
  3876                                  
  3877                                  
  3878                                  ;-33 
  3879                                  
  3880                                  
  3881                                  ;-34 int prscomment(unsigned char *s) {
  3882 00002493 C9                       LEAVE
  3883 00002494 C3                       ret
  3884                                  ; ENDP
  3885                                  
  3886                                  prscomment:  ; *** PROC ***
  3887                                  
  3888                                  ;-35     unsigned char c;
  3889                                  
  3890                                  
  3891                                  ;-36     while (*s){
  3892                                  
  3893                                  ;Function : prscomment, Number of local variables: 2
  3894                                  ;   # type sign width line used address name   list of local variables
  3895                                  ;  200 ptr unsg byte    34 NULL bp+4    s
  3896                                  ;  201 var unsg byte    35 NULL bp-2    c;
  3897 00002495 C8020000                 ENTER  2,0
  3898                                  @@prscomment178:
  3899 00002499 8B5E04                   mov bx, [bp+4]
  3900 0000249C 8A07                     mov al, [bx]
  3901 0000249E B400                     mov ah, 0
  3902 000024A0 08C0                     or  al, al
  3903 000024A2 0F841B00                 je @@prscomment179
  3904                                  
  3905                                  ;-37         c=*s;
  3906                                  
  3907 000024A6 8B5E04                   mov bx, [bp+4]
  3908 000024A9 8A07                     mov al, [bx]
  3909 000024AB B400                     mov ah, 0
  3910 000024AD 8846FE                   mov byte [bp-2], al
  3911                                  
  3912                                  ;-38         prc(c);
  3913                                  
  3914 000024B0 8A46FE                   mov al, byte [bp-2]
  3915 000024B3 B400                     mov ah, 0
  3916 000024B5 50                       push ax
  3917 000024B6 E8A9FF                   call prc
  3918 000024B9 83C402                   add  sp, 2
  3919                                  
  3920                                  ;-39         s++;
  3921                                  
  3922 000024BC FF4604                   inc  word [bp+4]
  3923                                  
  3924                                  ;-40     }
  3925                                  
  3926                                  
  3927                                  ;-41 }
  3928                                  
  3929 000024BF EBD8                     jmp @@prscomment178
  3930                                  @@prscomment179:
  3931                                  
  3932                                  ;-42 int prs(unsigned char *s) {
  3933 000024C1 C9                       LEAVE
  3934 000024C2 C3                       ret
  3935                                  ; ENDP
  3936                                  
  3937                                  prs:  ; *** PROC ***
  3938                                  
  3939                                  ;-43     unsigned char c; 
  3940                                  
  3941                                  
  3942                                  ;-44     int com; 
  3943                                  
  3944                                  
  3945                                  ;-45     com=0;
  3946                                  
  3947                                  ;Function : prs, Number of local variables: 3
  3948                                  ;   # type sign width line used address name   list of local variables
  3949                                  ;  200 ptr unsg byte    42 NULL bp+4    s
  3950                                  ;  201 var unsg byte    43 NULL bp-2    c
  3951                                  ;  202 var sign word    44 NULL bp-4    com;
  3952 000024C3 C8040000                 ENTER  4,0
  3953 000024C7 66B800000000             mov eax, 0
  3954 000024CD 8946FC                   mov word [bp-4], ax
  3955                                  
  3956                                  ;-46     while (*s) { 
  3957                                  
  3958                                  @@prs180:
  3959 000024D0 8B5E04                   mov bx, [bp+4]
  3960 000024D3 8A07                     mov al, [bx]
  3961 000024D5 B400                     mov ah, 0
  3962 000024D7 08C0                     or  al, al
  3963 000024D9 0F848700                 je @@prs181
  3964                                  
  3965                                  ;-47         c=*s; 
  3966                                  
  3967 000024DD 8B5E04                   mov bx, [bp+4]
  3968 000024E0 8A07                     mov al, [bx]
  3969 000024E2 B400                     mov ah, 0
  3970 000024E4 8846FE                   mov byte [bp-2], al
  3971                                  
  3972                                  ;-48         if (c==34) {
  3973                                  
  3974 000024E7 8A46FE                   mov al, [bp-2]
  3975 000024EA 3C22                     cmp al, 34
  3976 000024EC 0F851E00                 jne @@prs182
  3977                                  
  3978                                  ;-49             if (com) com=0; 
  3979                                  
  3980 000024F0 8B46FC                   mov ax, [bp-4]
  3981 000024F3 08C0                     or  al, al
  3982 000024F5 0F840C00                 je @@prs183
  3983 000024F9 66B800000000             mov eax, 0
  3984 000024FF 8946FC                   mov word [bp-4], ax
  3985                                  
  3986                                  ;-50                 else com=1;  
  3987                                  
  3988 00002502 E90900                   jmp @@prs184
  3989                                  @@prs183:
  3990 00002505 66B801000000             mov eax, 1
  3991 0000250B 8946FC                   mov word [bp-4], ax
  3992                                  
  3993                                  ;-51         }
  3994                                  
  3995                                  @@prs184:
  3996                                  
  3997                                  ;-52         if (c==92) { 
  3998                                  
  3999                                  @@prs182:
  4000 0000250E 8A46FE                   mov al, [bp-2]
  4001 00002511 3C5C                     cmp al, 92
  4002 00002513 0F853B00                 jne @@prs185
  4003                                  
  4004                                  ;-53             if (com==0) { 
  4005                                  
  4006 00002517 8B46FC                   mov ax, [bp-4]
  4007 0000251A 83F800                   cmp ax, 0
  4008 0000251D 0F853100                 jne @@prs186
  4009                                  
  4010                                  ;-54                 s++; 
  4011                                  
  4012 00002521 FF4604                   inc  word [bp+4]
  4013                                  
  4014                                  ;-55                 c=*s;
  4015                                  
  4016 00002524 8B5E04                   mov bx, [bp+4]
  4017 00002527 8A07                     mov al, [bx]
  4018 00002529 B400                     mov ah, 0
  4019 0000252B 8846FE                   mov byte [bp-2], al
  4020                                  
  4021                                  ;-56                 if (c=='n') c=10; 
  4022                                  
  4023 0000252E 8A46FE                   mov al, [bp-2]
  4024 00002531 3C6E                     cmp al, 110
  4025 00002533 0F850900                 jne @@prs187
  4026 00002537 66B80A000000             mov eax, 10
  4027 0000253D 8846FE                   mov byte [bp-2], al
  4028                                  
  4029                                  ;-57                 if (c=='t') c= 9; 
  4030                                  
  4031                                  @@prs187:
  4032 00002540 8A46FE                   mov al, [bp-2]
  4033 00002543 3C74                     cmp al, 116
  4034 00002545 0F850900                 jne @@prs188
  4035 00002549 66B809000000             mov eax, 9
  4036 0000254F 8846FE                   mov byte [bp-2], al
  4037                                  
  4038                                  ;-58             } 
  4039                                  
  4040                                  @@prs188:
  4041                                  
  4042                                  ;-59         } 
  4043                                  
  4044                                  @@prs186:
  4045                                  
  4046                                  ;-60         prc(c); 
  4047                                  
  4048                                  @@prs185:
  4049 00002552 8A46FE                   mov al, byte [bp-2]
  4050 00002555 B400                     mov ah, 0
  4051 00002557 50                       push ax
  4052 00002558 E807FF                   call prc
  4053 0000255B 83C402                   add  sp, 2
  4054                                  
  4055                                  ;-61         s++;  
  4056                                  
  4057 0000255E FF4604                   inc  word [bp+4]
  4058                                  
  4059                                  ;-62     }
  4060                                  
  4061                                  
  4062                                  ;-63 }
  4063                                  
  4064 00002561 E96CFF                   jmp @@prs180
  4065                                  @@prs181:
  4066                                  
  4067                                  ;-64 int printhex8a(unsigned char c) { 
  4068 00002564 C9                       LEAVE
  4069 00002565 C3                       ret
  4070                                  ; ENDP
  4071                                  
  4072                                  printhex8a:  ; *** PROC ***
  4073                                  
  4074                                  ;-65     unsigned char nib;
  4075                                  
  4076                                  
  4077                                  ;-66     nib = c >> 4; printhex4(nib);                    
  4078                                  
  4079                                  ;Function : printhex8a, Number of local variables: 2
  4080                                  ;   # type sign width line used address name   list of local variables
  4081                                  ;  200 var unsg byte    64 NULL bp+4    c
  4082                                  ;  201 var unsg byte    65 NULL bp-2    nib;
  4083 00002566 C8020000                 ENTER  2,0
  4084 0000256A 8A4604                   mov al, [bp+4]
  4085 0000256D C0E804                   shr al, 4
  4086 00002570 8846FE                   mov byte [bp-2], al
  4087 00002573 8A46FE                   mov al, byte [bp-2]
  4088 00002576 B400                     mov ah, 0
  4089 00002578 50                       push ax
  4090 00002579 E81900                   call printhex4
  4091 0000257C 83C402                   add  sp, 2
  4092                                  
  4093                                  ;-67     nib = c & 15; printhex4(nib);                    
  4094                                  
  4095 0000257F 8A4604                   mov al, [bp+4]
  4096 00002582 240F                     and al, 15
  4097 00002584 8846FE                   mov byte [bp-2], al
  4098 00002587 8A46FE                   mov al, byte [bp-2]
  4099 0000258A B400                     mov ah, 0
  4100 0000258C 50                       push ax
  4101 0000258D E80500                   call printhex4
  4102 00002590 83C402                   add  sp, 2
  4103                                  
  4104                                  ;-68 } 
  4105                                  
  4106                                  
  4107                                  ;-69 int printhex4(unsigned char c) {
  4108 00002593 C9                       LEAVE
  4109 00002594 C3                       ret
  4110                                  ; ENDP
  4111                                  
  4112                                  printhex4:  ; *** PROC ***
  4113                                  
  4114                                  ;-70     c += 48; 
  4115                                  
  4116                                  ;Function : printhex4, Number of local variables: 1
  4117                                  ;   # type sign width line used address name   list of local variables
  4118                                  ;  200 var unsg byte    69 NULL bp+4    c;
  4119 00002595 C8000000                 ENTER  0,0
  4120 00002599 80460430                 add  byte [bp+4], 48
  4121                                  
  4122                                  ;-71     if (c > 57) c += 7; 
  4123                                  
  4124 0000259D 8A4604                   mov al, [bp+4]
  4125 000025A0 3C39                     cmp al, 57
  4126 000025A2 0F8E0400                 jle @@printhex4189
  4127 000025A6 80460407                 add  byte [bp+4], 7
  4128                                  
  4129                                  ;-72     prc(c);      
  4130                                  
  4131                                  @@printhex4189:
  4132 000025AA 8A4604                   mov al, byte [bp+4]
  4133 000025AD B400                     mov ah, 0
  4134 000025AF 50                       push ax
  4135 000025B0 E8AFFE                   call prc
  4136 000025B3 83C402                   add  sp, 2
  4137                                  
  4138                                  ;-73 }
  4139                                  
  4140                                  
  4141                                  ;-74 int printhex16(unsigned int i) {
  4142 000025B6 C9                       LEAVE
  4143 000025B7 C3                       ret
  4144                                  ; ENDP
  4145                                  
  4146                                  printhex16:  ; *** PROC ***
  4147                                  
  4148                                  ;-75     unsigned int half;
  4149                                  
  4150                                  
  4151                                  ;-76     half = i >>  8; printhex8a(half); 
  4152                                  
  4153                                  ;Function : printhex16, Number of local variables: 2
  4154                                  ;   # type sign width line used address name   list of local variables
  4155                                  ;  200 var unsg word    74 NULL bp+4    i
  4156                                  ;  201 var unsg word    75 NULL bp-2    half;
  4157 000025B8 C8020000                 ENTER  2,0
  4158 000025BC 8B4604                   mov ax, [bp+4]
  4159 000025BF C1E808                   shr ax, 8
  4160 000025C2 8946FE                   mov word [bp-2], ax
  4161 000025C5 FF76FE                   push word [bp-2]
  4162 000025C8 E89BFF                   call printhex8a
  4163 000025CB 83C402                   add  sp, 2
  4164                                  
  4165                                  ;-77     half = i & 255; printhex8a(half);
  4166                                  
  4167 000025CE 8B4604                   mov ax, [bp+4]
  4168 000025D1 25FF00                   and ax, 255
  4169 000025D4 8946FE                   mov word [bp-2], ax
  4170 000025D7 FF76FE                   push word [bp-2]
  4171 000025DA E889FF                   call printhex8a
  4172 000025DD 83C402                   add  sp, 2
  4173                                  
  4174                                  ;-78 }
  4175                                  
  4176                                  
  4177                                  ;-79 int printIntU(unsigned int n) { 
  4178 000025E0 C9                       LEAVE
  4179 000025E1 C3                       ret
  4180                                  ; ENDP
  4181                                  
  4182                                  printIntU:  ; *** PROC ***
  4183                                  
  4184                                  ;-80     unsigned int e;
  4185                                  
  4186                                  
  4187                                  ;-81     if ( _ n >= 10) {  
  4188                                  
  4189                                  ;Function : printIntU, Number of local variables: 2
  4190                                  ;   # type sign width line used address name   list of local variables
  4191                                  ;  200 var unsg word    79 NULL bp+4    n
  4192                                  ;  201 var unsg word    80 NULL bp-2    e;
  4193 000025E2 C8020000                 ENTER  2,0
  4194 000025E6 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4195 000025EA 0F821700                 jb  @@printIntU190
  4196                                  
  4197                                  ;-82         e=n/10; //DIV
  4198                                  
  4199 000025EE 8B4604                   mov ax, [bp+4]
  4200 000025F1 BB0A00                   mov bx, 10
  4201 000025F4 BA0000                   mov dx, 0
  4202 000025F7 F7F3                     div bx
  4203 000025F9 8946FE                   mov word [bp-2], ax
  4204                                  
  4205                                  ;-83         printIntU(e); 
  4206                                  
  4207 000025FC FF76FE                   push word [bp-2]
  4208 000025FF E8E0FF                   call printIntU
  4209 00002602 83C402                   add  sp, 2
  4210                                  
  4211                                  ;-84     }
  4212                                  
  4213                                  
  4214                                  ;-85     n = n % 10; //unsigned mod
  4215                                  
  4216                                  @@printIntU190:
  4217 00002605 8B4604                   mov ax, [bp+4]
  4218 00002608 BB0A00                   mov bx, 10
  4219 0000260B BA0000                   mov dx, 0
  4220 0000260E F7F3                     div bx
  4221 00002610 89D0                     mov ax, dx
  4222 00002612 894604                   mov word [bp+4], ax
  4223                                  
  4224                                  ;-86     n += '0'; 
  4225                                  
  4226 00002615 83460430                 add  word [bp+4], 48
  4227                                  
  4228                                  ;-87     prc(n);
  4229                                  
  4230 00002619 FF7604                   push word [bp+4]
  4231 0000261C E843FE                   call prc
  4232 0000261F 83C402                   add  sp, 2
  4233                                  
  4234                                  ;-88 }
  4235                                  
  4236                                  
  4237                                  ;-89 
  4238                                  
  4239                                  
  4240                                  ;-90 int error1(char *s) { 
  4241 00002622 C9                       LEAVE
  4242 00002623 C3                       ret
  4243                                  ; ENDP
  4244                                  
  4245                                  error1:  ; *** PROC ***
  4246                                  
  4247                                  ;-91     LIST=1; 
  4248                                  
  4249                                  ;Function : error1, Number of local variables: 1
  4250                                  ;   # type sign width line used address name   list of local variables
  4251                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  4252 00002624 C8000000                 ENTER  0,0
  4253 00002628 66B801000000             mov eax, 1
  4254 0000262E A2[0E00]                 mov byte [LIST], al
  4255                                  
  4256                                  ;-92     ErrorCount++;
  4257                                  
  4258 00002631 FF06[A101]               inc  word [ErrorCount]
  4259                                  
  4260                                  ;-93     prs("\n;***** next line ERROR: "); 
  4261                                  
  4262 00002635 68[5D26]                 push error1_0
  4263 00002638 E888FE                   call prs
  4264 0000263B 83C402                   add  sp, 2
  4265                                  
  4266                                  ;-94     prs(s);
  4267                                  
  4268 0000263E FF7604                   push word [bp+4]
  4269 00002641 E87FFE                   call prs
  4270 00002644 83C402                   add  sp, 2
  4271                                  
  4272                                  ;-95     prs(", Symbol: "); 
  4273                                  
  4274 00002647 68[7826]                 push error1_1
  4275 0000264A E876FE                   call prs
  4276 0000264D 83C402                   add  sp, 2
  4277                                  
  4278                                  ;-96     prs(Symbol);
  4279                                  
  4280 00002650 8D06[0F00]               lea  ax, [Symbol]
  4281 00002654 50                       push ax
  4282 00002655 E86BFE                   call prs
  4283 00002658 83C402                   add  sp, 2
  4284                                  
  4285                                  ;-97 }
  4286                                  
  4287                                  
  4288                                  ;-98 int errorexit(char *s) { 
  4289 0000265B C9                       LEAVE
  4290 0000265C C3                       ret
  4291                                  ; ENDP
  4292 0000265D 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4293 00002666 6E657874206C696E65-
  4294 0000266F 204552524F523A2000 
  4295 00002678 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4296 00002681 2000               
  4297                                  
  4298                                  errorexit:  ; *** PROC ***
  4299                                  
  4300                                  ;-99     error1(s); 
  4301                                  
  4302                                  ;Function : errorexit, Number of local variables: 1
  4303                                  ;   # type sign width line used address name   list of local variables
  4304                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  4305 00002683 C8000000                 ENTER  0,0
  4306 00002687 FF7604                   push word [bp+4]
  4307 0000268A E897FF                   call error1
  4308 0000268D 83C402                   add  sp, 2
  4309                                  
  4310                                  ;-100     end1(1);
  4311                                  
  4312 00002690 6A01                     push 1
  4313 00002692 E8C904                   call end1
  4314 00002695 83C402                   add  sp, 2
  4315                                  
  4316                                  ;-101 }
  4317                                  
  4318                                  
  4319                                  ;-102 int allowederror() {error1("not allowed here"); }
  4320 00002698 C9                       LEAVE
  4321 00002699 C3                       ret
  4322                                  ; ENDP
  4323                                  
  4324                                  allowederror:  ; *** PROC ***
  4325 0000269A 68[A426]                 push allowederror_0
  4326 0000269D E884FF                   call error1
  4327 000026A0 83C402                   add  sp, 2
  4328                                  
  4329                                  ;-103 int addrerror()    {error1("address missing");} 
  4330                                  
  4331 000026A3 C3                       ret
  4332                                  ; ENDP
  4333 000026A4 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4334 000026AD 6564206865726500   
  4335                                  
  4336                                  addrerror:  ; *** PROC ***
  4337 000026B5 68[BF26]                 push addrerror_0
  4338 000026B8 E869FF                   call error1
  4339 000026BB 83C402                   add  sp, 2
  4340                                  
  4341                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  4342                                  
  4343 000026BE C3                       ret
  4344                                  ; ENDP
  4345 000026BF 61646472657373206D-     addrerror_0 db "address missing",0
  4346 000026C8 697373696E6700     
  4347                                  
  4348                                  immeerror:  ; *** PROC ***
  4349 000026CF 68[D926]                 push immeerror_0
  4350 000026D2 E84FFF                   call error1
  4351 000026D5 83C402                   add  sp, 2
  4352                                  
  4353                                  ;-105 int implerror()    {error1("not implemented");}
  4354                                  
  4355 000026D8 C3                       ret
  4356                                  ; ENDP
  4357 000026D9 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4358 000026E2 206E6F7420616C6C6F-
  4359 000026EB 776564206865726500 
  4360                                  
  4361                                  implerror:  ; *** PROC ***
  4362 000026F4 68[FE26]                 push implerror_0
  4363 000026F7 E82AFF                   call error1
  4364 000026FA 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-106 int indexerror()   {error1("invalid index register");}
  4367                                  
  4368 000026FD C3                       ret
  4369                                  ; ENDP
  4370 000026FE 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4371 00002707 6D656E74656400     
  4372                                  
  4373                                  indexerror:  ; *** PROC ***
  4374 0000270E 68[1827]                 push indexerror_0
  4375 00002711 E810FF                   call error1
  4376 00002714 83C402                   add  sp, 2
  4377                                  
  4378                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  4379                                  
  4380 00002717 C3                       ret
  4381                                  ; ENDP
  4382 00002718 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4383 00002721 6E6465782072656769-
  4384 0000272A 7374657200         
  4385                                  
  4386                                  invaloperror:  ; *** PROC ***
  4387 0000272F 68[3927]                 push invaloperror_0
  4388 00002732 E8EFFE                   call error1
  4389 00002735 83C402                   add  sp, 2
  4390                                  
  4391                                  ;-108 int numbererror()  {error1("number expected");}
  4392                                  
  4393 00002738 C3                       ret
  4394                                  ; ENDP
  4395 00002739 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4396 00002742 72206E6F206F706572-
  4397 0000274B 616E647300         
  4398                                  
  4399                                  numbererror:  ; *** PROC ***
  4400 00002750 68[5A27]                 push numbererror_0
  4401 00002753 E8CEFE                   call error1
  4402 00002756 83C402                   add  sp, 2
  4403                                  
  4404                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  4405                                  
  4406 00002759 C3                       ret
  4407                                  ; ENDP
  4408 0000275A 6E756D626572206578-     numbererror_0 db "number expected",0
  4409 00002763 70656374656400     
  4410                                  
  4411                                  regmemerror:  ; *** PROC ***
  4412 0000276A 68[7427]                 push regmemerror_0
  4413 0000276D E8B4FE                   call error1
  4414 00002770 83C402                   add  sp, 2
  4415                                  
  4416                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  4417                                  
  4418 00002773 C3                       ret
  4419                                  ; ENDP
  4420 00002774 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4421 0000277D 73746572206F72206D-
  4422 00002786 656D6F727920616C6C-
  4423 0000278F 6F77656400         
  4424                                  
  4425                                  reg16error:  ; *** PROC ***
  4426 00002794 68[9E27]                 push reg16error_0
  4427 00002797 E88AFE                   call error1
  4428 0000279A 83C402                   add  sp, 2
  4429                                  
  4430                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  4431                                  
  4432 0000279D C3                       ret
  4433                                  ; ENDP
  4434 0000279E 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4435 000027A7 362C206E6F20736567-
  4436 000027B0 72656720616C6C6F77-
  4437 000027B9 656400             
  4438                                  
  4439                                  segregerror:  ; *** PROC ***
  4440 000027BC 68[C627]                 push segregerror_0
  4441 000027BF E862FE                   call error1
  4442 000027C2 83C402                   add  sp, 2
  4443                                  
  4444                                  ;-112 int syntaxerror()  {error1("syntax");}
  4445                                  
  4446 000027C5 C3                       ret
  4447                                  ; ENDP
  4448 000027C6 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4449 000027CF 65676973746572206E-
  4450 000027D8 6F7420616C6C6F7765-
  4451 000027E1 6400               
  4452                                  
  4453                                  syntaxerror:  ; *** PROC ***
  4454 000027E3 68[ED27]                 push syntaxerror_0
  4455 000027E6 E83BFE                   call error1
  4456 000027E9 83C402                   add  sp, 2
  4457                                  
  4458                                  ;-113          
  4459                                  
  4460                                  
  4461                                  ;-114 int addrexit()     {errorexit("illegal address");}
  4462                                  
  4463 000027EC C3                       ret
  4464                                  ; ENDP
  4465 000027ED 73796E74617800          syntaxerror_0 db "syntax",0
  4466                                  
  4467                                  addrexit:  ; *** PROC ***
  4468 000027F4 68[FE27]                 push addrexit_0
  4469 000027F7 E889FE                   call errorexit
  4470 000027FA 83C402                   add  sp, 2
  4471                                  
  4472                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  4473                                  
  4474 000027FD C3                       ret
  4475                                  ; ENDP
  4476 000027FE 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4477 00002807 64647265737300     
  4478                                  
  4479                                  internexit:  ; *** PROC ***
  4480 0000280E 68[1828]                 push internexit_0
  4481 00002811 E86FFE                   call errorexit
  4482 00002814 83C402                   add  sp, 2
  4483 00002817 C3                       ret
  4484                                  ; ENDP
  4485 00002818 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4486 00002821 6D70696C6572206572-
  4487 0000282A 726F7200           
  4488                                  ;Back to main program: AS.C
  4489                                  
  4490                                  ;-8 #include "MAIN.C"
  4491                                  
  4492                                  ;Use include file: MAIN.C
  4493                                  
  4494                                  ;-1 int main() {
  4495                                  
  4496                                  
  4497                                  main:  ; *** PROC ***
  4498                                  
  4499                                  ;-2     getarg(); 
  4500                                  
  4501 0000282E E80A00                   call getarg
  4502                                  
  4503                                  ;-3     parse(); 
  4504                                  
  4505 00002831 E8D8EE                   call parse
  4506                                  
  4507                                  ;-4     epilog(); 
  4508                                  
  4509 00002834 E85C02                   call epilog
  4510                                  
  4511                                  ;-5     end1();
  4512                                  
  4513 00002837 E82403                   call end1
  4514                                  
  4515                                  ;-6 }
  4516                                  
  4517                                  
  4518                                  ;-7 
  4519                                  
  4520                                  
  4521                                  ;-8 int getarg() { 
  4522                                  
  4523 0000283A C3                       ret
  4524                                  ; ENDP
  4525                                  
  4526                                  getarg:  ; *** PROC ***
  4527                                  
  4528                                  ;-9     int arglen1; int i; char *c;
  4529                                  
  4530                                  
  4531                                  ;-10     arglen1=*arglen;
  4532                                  
  4533                                  ;Function : getarg, Number of local variables: 3
  4534                                  ;   # type sign width line used address name   list of local variables
  4535                                  ;  200 var sign word     9 NULL bp-2    arglen1
  4536                                  ;  201 var sign word     9 NULL bp-4    i
  4537                                  ;  202 ptr sign byte     9 NULL bp-6    c;
  4538 0000283B C8060000                 ENTER  6,0
  4539 0000283F 8B1E[520E]               mov bx, [arglen]
  4540 00002843 8A07                     mov al, [bx]
  4541 00002845 B400                     mov ah, 0
  4542 00002847 8946FE                   mov word [bp-2], ax
  4543                                  
  4544                                  ;-11     if (arglen1==0) {
  4545                                  
  4546 0000284A 8B46FE                   mov ax, [bp-2]
  4547 0000284D 83F800                   cmp ax, 0
  4548 00002850 0F851C00                 jne @@getarg191
  4549                                  
  4550                                  ;-12         cputs(Version1);
  4551                                  
  4552 00002854 8D06[0300]               lea  ax, [Version1]
  4553 00002858 50                       push ax
  4554 00002859 E8070B                   call cputs
  4555 0000285C 83C402                   add  sp, 2
  4556                                  
  4557                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4558                                  
  4559 0000285F 68[002A]                 push getarg_0
  4560 00002862 E8FE0A                   call cputs
  4561 00002865 83C402                   add  sp, 2
  4562                                  
  4563                                  ;-14         exitR(3);
  4564                                  
  4565 00002868 6A03                     push 3
  4566 0000286A E8D10C                   call exitR
  4567 0000286D 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-15     }
  4570                                  
  4571                                  
  4572                                  ;-16     i=arglen1+129; 
  4573                                  
  4574                                  @@getarg191:
  4575 00002870 8B46FE                   mov ax, [bp-2]
  4576 00002873 058100                   add ax, 129
  4577 00002876 8946FC                   mov word [bp-4], ax
  4578                                  
  4579                                  ;-17     *i=0;  
  4580                                  
  4581 00002879 66B800000000             mov eax, 0
  4582 0000287F 8B5EFC                   mov  bx, [bp-4]
  4583 00002882 8907                     mov  [bx], ax
  4584                                  
  4585                                  ;-18     arglen1--;
  4586                                  
  4587 00002884 FF4EFE                   dec  word [bp-2]
  4588                                  
  4589                                  ;-19     toupper(argv);
  4590                                  
  4591 00002887 FF36[540E]               push word [argv]
  4592 0000288B E8030B                   call toupper
  4593 0000288E 83C402                   add  sp, 2
  4594                                  
  4595                                  ;-20   
  4596                                  
  4597                                  
  4598                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4599                                  
  4600 00002891 FF36[540E]               push word [argv]
  4601 00002895 8D06[D000]               lea  ax, [namein]
  4602 00002899 50                       push ax
  4603 0000289A E8620B                   call strcpy
  4604 0000289D 83C404                   add  sp, 4
  4605 000028A0 68[252A]                 push getarg_1
  4606 000028A3 8D06[D000]               lea  ax, [namein]
  4607 000028A7 50                       push ax
  4608 000028A8 E8150C                   call strcat1
  4609 000028AB 83C404                   add  sp, 4
  4610                                  
  4611                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4612                                  
  4613 000028AE FF36[540E]               push word [argv]
  4614 000028B2 8D06[1301]               lea  ax, [namelst]
  4615 000028B6 50                       push ax
  4616 000028B7 E8450B                   call strcpy
  4617 000028BA 83C404                   add  sp, 4
  4618 000028BD 68[282A]                 push getarg_2
  4619 000028C0 8D06[1301]               lea  ax, [namelst]
  4620 000028C4 50                       push ax
  4621 000028C5 E8F80B                   call strcat1
  4622 000028C8 83C404                   add  sp, 4
  4623                                  
  4624                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4625                                  
  4626 000028CB FF36[540E]               push word [argv]
  4627 000028CF 8D06[5601]               lea  ax, [namebin]
  4628 000028D3 50                       push ax
  4629 000028D4 E8280B                   call strcpy
  4630 000028D7 83C404                   add  sp, 4
  4631 000028DA 68[2D2A]                 push getarg_3
  4632 000028DD 8D06[5601]               lea  ax, [namebin]
  4633 000028E1 50                       push ax
  4634 000028E2 E8DB0B                   call strcat1
  4635 000028E5 83C404                   add  sp, 4
  4636                                  
  4637                                  ;-24 
  4638                                  
  4639                                  
  4640                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4641                                  
  4642 000028E8 66B801000000             mov eax, 1
  4643 000028EE A2[0E00]                 mov byte [LIST], al
  4644 000028F1 66B800000000             mov eax, 0
  4645 000028F7 A3[9F01]                 mov word [DOS_ERR], ax
  4646 000028FA 66B800000000             mov eax, 0
  4647 00002900 A3[A601]                 mov word [PC], ax
  4648 00002903 66B800000000             mov eax, 0
  4649 00002909 A3[A101]                 mov word [ErrorCount], ax
  4650                                  
  4651                                  ;-26   
  4652                                  
  4653                                  
  4654                                  ;-27     asm_fd=openR (namein);
  4655                                  
  4656 0000290C 8D06[D000]               lea  ax, [namein]
  4657 00002910 50                       push ax
  4658 00002911 E8D10B                   call openR
  4659 00002914 83C402                   add  sp, 2
  4660 00002917 A3[9901]                 mov word [asm_fd], ax
  4661                                  
  4662                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4663                                  
  4664 0000291A A1[9F01]                 mov ax, [DOS_ERR]
  4665 0000291D 08C0                     or  al, al
  4666 0000291F 0F841C00                 je @@getarg192
  4667 00002923 68[322A]                 push getarg_4
  4668 00002926 E83A0A                   call cputs
  4669 00002929 83C402                   add  sp, 2
  4670 0000292C 8D06[D000]               lea  ax, [namein]
  4671 00002930 50                       push ax
  4672 00002931 E82F0A                   call cputs
  4673 00002934 83C402                   add  sp, 2
  4674 00002937 6A01                     push 1
  4675 00002939 E8020C                   call exitR
  4676 0000293C 83C402                   add  sp, 2
  4677                                  
  4678                                  ;-29     lst_fd=creatR(namelst);
  4679                                  
  4680                                  @@getarg192:
  4681 0000293F 8D06[1301]               lea  ax, [namelst]
  4682 00002943 50                       push ax
  4683 00002944 E8AD0B                   call creatR
  4684 00002947 83C402                   add  sp, 2
  4685 0000294A A3[9B01]                 mov word [lst_fd], ax
  4686                                  
  4687                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4688                                  
  4689 0000294D A1[9F01]                 mov ax, [DOS_ERR]
  4690 00002950 08C0                     or  al, al
  4691 00002952 0F841C00                 je @@getarg193
  4692 00002956 68[482A]                 push getarg_5
  4693 00002959 E8070A                   call cputs
  4694 0000295C 83C402                   add  sp, 2
  4695 0000295F 8D06[1301]               lea  ax, [namelst]
  4696 00002963 50                       push ax
  4697 00002964 E8FC09                   call cputs
  4698 00002967 83C402                   add  sp, 2
  4699 0000296A 6A02                     push 2
  4700 0000296C E8CF0B                   call exitR
  4701 0000296F 83C402                   add  sp, 2
  4702                                  
  4703                                  ;-31     bin_fd=creatR(namebin);
  4704                                  
  4705                                  @@getarg193:
  4706 00002972 8D06[5601]               lea  ax, [namebin]
  4707 00002976 50                       push ax
  4708 00002977 E87A0B                   call creatR
  4709 0000297A 83C402                   add  sp, 2
  4710 0000297D A3[9D01]                 mov word [bin_fd], ax
  4711                                  
  4712                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4713                                  
  4714 00002980 A1[9F01]                 mov ax, [DOS_ERR]
  4715 00002983 08C0                     or  al, al
  4716 00002985 0F841C00                 je @@getarg194
  4717 00002989 68[5F2A]                 push getarg_6
  4718 0000298C E8D409                   call cputs
  4719 0000298F 83C402                   add  sp, 2
  4720 00002992 8D06[5601]               lea  ax, [namebin]
  4721 00002996 50                       push ax
  4722 00002997 E8C909                   call cputs
  4723 0000299A 83C402                   add  sp, 2
  4724 0000299D 6A02                     push 2
  4725 0000299F E89C0B                   call exitR
  4726 000029A2 83C402                   add  sp, 2
  4727                                  
  4728                                  ;-33   
  4729                                  
  4730                                  
  4731                                  ;-34     prs(";"); 
  4732                                  
  4733                                  @@getarg194:
  4734 000029A5 68[752A]                 push getarg_7
  4735 000029A8 E818FB                   call prs
  4736 000029AB 83C402                   add  sp, 2
  4737                                  
  4738                                  ;-35     prs(Version1);
  4739                                  
  4740 000029AE 8D06[0300]               lea  ax, [Version1]
  4741 000029B2 50                       push ax
  4742 000029B3 E80DFB                   call prs
  4743 000029B6 83C402                   add  sp, 2
  4744                                  
  4745                                  ;-36     prs(", Source: "); prs(namein);  
  4746                                  
  4747 000029B9 68[772A]                 push getarg_8
  4748 000029BC E804FB                   call prs
  4749 000029BF 83C402                   add  sp, 2
  4750 000029C2 8D06[D000]               lea  ax, [namein]
  4751 000029C6 50                       push ax
  4752 000029C7 E8F9FA                   call prs
  4753 000029CA 83C402                   add  sp, 2
  4754                                  
  4755                                  ;-37     prs(", Output: "); prs(namelst);
  4756                                  
  4757 000029CD 68[822A]                 push getarg_9
  4758 000029D0 E8F0FA                   call prs
  4759 000029D3 83C402                   add  sp, 2
  4760 000029D6 8D06[1301]               lea  ax, [namelst]
  4761 000029DA 50                       push ax
  4762 000029DB E8E5FA                   call prs
  4763 000029DE 83C402                   add  sp, 2
  4764                                  
  4765                                  ;-38     prs(", "); prs(namebin);
  4766                                  
  4767 000029E1 68[8D2A]                 push getarg_10
  4768 000029E4 E8DCFA                   call prs
  4769 000029E7 83C402                   add  sp, 2
  4770 000029EA 8D06[5601]               lea  ax, [namebin]
  4771 000029EE 50                       push ax
  4772 000029EF E8D1FA                   call prs
  4773 000029F2 83C402                   add  sp, 2
  4774                                  
  4775                                  ;-39     prs("\n");
  4776                                  
  4777 000029F5 68[902A]                 push getarg_11
  4778 000029F8 E8C8FA                   call prs
  4779 000029FB 83C402                   add  sp, 2
  4780                                  
  4781                                  ;-40 }
  4782                                  
  4783                                  
  4784                                  ;-41 
  4785                                  
  4786                                  
  4787                                  ;-42 int epilog() { 
  4788 000029FE C9                       LEAVE
  4789 000029FF C3                       ret
  4790                                  ; ENDP
  4791 00002A00 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4792 00002A09 41532E434F4D206669-
  4793 00002A12 6C656E616D65205B77-
  4794 00002A1B 2F6F202E535D203A20-
  4795 00002A24 00                 
  4796 00002A25 2E5300                  getarg_1 db ".S",0
  4797 00002A28 2E4C535400              getarg_2 db ".LST",0
  4798 00002A2D 2E434F4D00              getarg_3 db ".COM",0
  4799 00002A32 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4800 00002A3B 6C65206D697373696E-
  4801 00002A44 673A2000           
  4802 00002A48 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4803 00002A51 206E6F742063726561-
  4804 00002A5A 74653A2000         
  4805 00002A5F 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4806 00002A68 6E6F74206372656174-
  4807 00002A71 653A2000           
  4808 00002A75 3B00                    getarg_7 db ";",0
  4809 00002A77 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4810 00002A80 2000               
  4811 00002A82 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4812 00002A8B 2000               
  4813 00002A8D 2C2000                  getarg_10 db ", ",0
  4814 00002A90 5C6E00                  getarg_11 db "\n",0
  4815                                  
  4816                                  epilog:  ; *** PROC ***
  4817                                  
  4818                                  ;-43     int i; int j; char c;
  4819                                  
  4820                                  
  4821                                  ;-44     prs("\n;END Errors: "); 
  4822                                  
  4823                                  ;Function : epilog, Number of local variables: 3
  4824                                  ;   # type sign width line used address name   list of local variables
  4825                                  ;  200 var sign word    43 NULL bp-2    i
  4826                                  ;  201 var sign word    43 NULL bp-4    j
  4827                                  ;  202 var sign byte    43 NULL bp-6    c;
  4828 00002A93 C8060000                 ENTER  6,0
  4829 00002A97 68[212B]                 push epilog_0
  4830 00002A9A E826FA                   call prs
  4831 00002A9D 83C402                   add  sp, 2
  4832                                  
  4833                                  ;-45     printIntU(ErrorCount);
  4834                                  
  4835 00002AA0 FF36[A101]               push word [ErrorCount]
  4836 00002AA4 E83BFB                   call printIntU
  4837 00002AA7 83C402                   add  sp, 2
  4838                                  
  4839                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  4840                                  
  4841 00002AAA A1[A101]                 mov ax, [ErrorCount]
  4842 00002AAD 08C0                     or  al, al
  4843 00002AAF 0F840900                 je @@epilog195
  4844 00002AB3 68[312B]                 push epilog_1
  4845 00002AB6 E80AFA                   call prs
  4846 00002AB9 83C402                   add  sp, 2
  4847                                  
  4848                                  ;-47     prs(", Output: "); prs(namelst);
  4849                                  
  4850                                  @@epilog195:
  4851 00002ABC 68[3F2B]                 push epilog_2
  4852 00002ABF E801FA                   call prs
  4853 00002AC2 83C402                   add  sp, 2
  4854 00002AC5 8D06[1301]               lea  ax, [namelst]
  4855 00002AC9 50                       push ax
  4856 00002ACA E8F6F9                   call prs
  4857 00002ACD 83C402                   add  sp, 2
  4858                                  
  4859                                  ;-48     prs(", COM file "); 
  4860                                  
  4861 00002AD0 68[4A2B]                 push epilog_3
  4862 00002AD3 E8EDF9                   call prs
  4863 00002AD6 83C402                   add  sp, 2
  4864                                  
  4865                                  ;-49     printIntU(BinLen); 
  4866                                  
  4867 00002AD9 FF36[500E]               push word [BinLen]
  4868 00002ADD E802FB                   call printIntU
  4869 00002AE0 83C402                   add  sp, 2
  4870                                  
  4871                                  ;-50     prs(" bytes.");
  4872                                  
  4873 00002AE3 68[562B]                 push epilog_4
  4874 00002AE6 E8DAF9                   call prs
  4875 00002AE9 83C402                   add  sp, 2
  4876                                  
  4877                                  ;-51 
  4878                                  
  4879                                  
  4880                                  ;-52     i=0;
  4881                                  
  4882 00002AEC 66B800000000             mov eax, 0
  4883 00002AF2 8946FE                   mov word [bp-2], ax
  4884                                  
  4885                                  ;-53     do {
  4886                                  
  4887                                  @@epilog196:
  4888                                  
  4889                                  ;-54         c = FileBin[i];
  4890                                  
  4891 00002AF5 8B5EFE                   mov bx, [bp-2]
  4892 00002AF8 8A87[8006]               mov al, [FileBin + bx]
  4893 00002AFC 8846FA                   mov byte [bp-6], al
  4894                                  
  4895                                  ;-55         fputcR(c, bin_fd);
  4896                                  
  4897 00002AFF FF36[9D01]               push word [bin_fd]
  4898 00002B03 8A46FA                   mov al, byte [bp-6]
  4899 00002B06 B400                     mov ah, 0
  4900 00002B08 50                       push ax
  4901 00002B09 E80F0A                   call fputcR
  4902 00002B0C 83C404                   add  sp, 4
  4903                                  
  4904                                  ;-56         i++;
  4905                                  
  4906 00002B0F FF46FE                   inc  word [bp-2]
  4907                                  
  4908                                  ;-57     } while (i < BinLen);
  4909                                  
  4910 00002B12 8B46FE                   mov ax, [bp-2]
  4911 00002B15 3B06[500E]               cmp ax, [BinLen]
  4912 00002B19 0F8D0200                 jge @@epilog197
  4913 00002B1D EBD6                     jmp @@epilog196
  4914                                  @@epilog197:
  4915                                  
  4916                                  ;-58 }
  4917                                  
  4918                                  
  4919                                  ;-59 
  4920                                  
  4921                                  
  4922                                  ;-60 int end1(int n) {
  4923 00002B1F C9                       LEAVE
  4924 00002B20 C3                       ret
  4925                                  ; ENDP
  4926 00002B21 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4927 00002B2A 726F72733A2000     
  4928 00002B31 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4929 00002B3A 2A2A2A2000         
  4930 00002B3F 2C204F75747075743A-     epilog_2 db ", Output: ",0
  4931 00002B48 2000               
  4932 00002B4A 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  4933 00002B53 652000             
  4934 00002B56 2062797465732E00        epilog_4 db " bytes.",0
  4935                                  
  4936                                  end1:  ; *** PROC ***
  4937                                  
  4938                                  ;-61   fcloseR(asm_fd);
  4939                                  
  4940                                  ;Function : end1, Number of local variables: 1
  4941                                  ;   # type sign width line used address name   list of local variables
  4942                                  ;  200 var sign word    60 NULL bp+4    n;
  4943 00002B5E C8000000                 ENTER  0,0
  4944 00002B62 FF36[9901]               push word [asm_fd]
  4945 00002B66 E8C709                   call fcloseR
  4946 00002B69 83C402                   add  sp, 2
  4947                                  
  4948                                  ;-62   fcloseR(lst_fd);
  4949                                  
  4950 00002B6C FF36[9B01]               push word [lst_fd]
  4951 00002B70 E8BD09                   call fcloseR
  4952 00002B73 83C402                   add  sp, 2
  4953                                  
  4954                                  ;-63   fcloseR(bin_fd);
  4955                                  
  4956 00002B76 FF36[9D01]               push word [bin_fd]
  4957 00002B7A E8B309                   call fcloseR
  4958 00002B7D 83C402                   add  sp, 2
  4959                                  
  4960                                  ;-64   exitR(n);
  4961                                  
  4962 00002B80 FF7604                   push word [bp+4]
  4963 00002B83 E8B809                   call exitR
  4964 00002B86 83C402                   add  sp, 2
  4965                                  
  4966                                  ;-65 }
  4967 00002B89 C9                       LEAVE
  4968 00002B8A C3                       ret
  4969                                  ; ENDP
  4970                                  ;Back to main program: AS.C
  4971                                  
  4972                                  ;-9 #include "GENCODE.C"
  4973                                  
  4974                                  ;Use include file: GENCODE.C
  4975                                  
  4976                                  ;-1 // generate code
  4977                                  
  4978                                  
  4979                                  ;-2 int getCodes() {
  4980                                  
  4981                                  
  4982                                  getCodes:  ; *** PROC ***
  4983                                  
  4984                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  4985                                  
  4986 00002B8B FF06[C701]               inc  word [OpCodePtr]
  4987 00002B8F 8B1E[C701]               mov bx, [OpCodePtr]
  4988 00002B93 8A07                     mov al, [bx]
  4989 00002B95 B400                     mov ah, 0
  4990 00002B97 A2[AF01]                 mov byte [Code1], al
  4991                                  
  4992                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4993                                  
  4994 00002B9A FF06[C701]               inc  word [OpCodePtr]
  4995 00002B9E 8B1E[C701]               mov bx, [OpCodePtr]
  4996 00002BA2 8A07                     mov al, [bx]
  4997 00002BA4 B400                     mov ah, 0
  4998 00002BA6 A2[B001]                 mov byte [Code2], al
  4999                                  
  5000                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5001                                  
  5002 00002BA9 FF06[C701]               inc  word [OpCodePtr]
  5003 00002BAD 8B1E[C701]               mov bx, [OpCodePtr]
  5004 00002BB1 8A07                     mov al, [bx]
  5005 00002BB3 B400                     mov ah, 0
  5006 00002BB5 A2[B101]                 mov byte [Code3], al
  5007                                  
  5008                                  ;-6 }
  5009                                  
  5010                                  
  5011                                  ;-7 int gen66h() {genCode8(0x66);
  5012                                  
  5013 00002BB8 C3                       ret
  5014                                  ; ENDP
  5015                                  
  5016                                  gen66h:  ; *** PROC ***
  5017 00002BB9 6A66                     push 102
  5018 00002BBB E83B00                   call genCode8
  5019 00002BBE 83C402                   add  sp, 2
  5020                                  
  5021                                  ;-8 }
  5022                                  
  5023                                  
  5024                                  ;-9 int genCode2(char c, char d) {
  5025                                  
  5026 00002BC1 C3                       ret
  5027                                  ; ENDP
  5028                                  
  5029                                  genCode2:  ; *** PROC ***
  5030                                  
  5031                                  ;-10     c = c + d;
  5032                                  
  5033                                  ;Function : genCode2, Number of local variables: 2
  5034                                  ;   # type sign width line used address name   list of local variables
  5035                                  ;  200 var sign byte     9 NULL bp+4    c
  5036                                  ;  201 var sign byte     9 NULL bp+6    d;
  5037 00002BC2 C8000000                 ENTER  0,0
  5038 00002BC6 8A4604                   mov al, [bp+4]
  5039 00002BC9 024606                   add al, [bp+6]
  5040 00002BCC 884604                   mov byte [bp+4], al
  5041                                  
  5042                                  ;-11     genCode8(c);
  5043                                  
  5044 00002BCF 8A4604                   mov al, byte [bp+4]
  5045 00002BD2 B400                     mov ah, 0
  5046 00002BD4 50                       push ax
  5047 00002BD5 E82100                   call genCode8
  5048 00002BD8 83C402                   add  sp, 2
  5049                                  
  5050                                  ;-12 }                             
  5051                                  
  5052                                  
  5053                                  ;-13 int genCodeW(char c) {
  5054 00002BDB C9                       LEAVE
  5055 00002BDC C3                       ret
  5056                                  ; ENDP
  5057                                  
  5058                                  genCodeW:  ; *** PROC ***
  5059                                  
  5060                                  ;-14     c = c + wflag;  
  5061                                  
  5062                                  ;Function : genCodeW, Number of local variables: 1
  5063                                  ;   # type sign width line used address name   list of local variables
  5064                                  ;  200 var sign byte    13 NULL bp+4    c;
  5065 00002BDD C8000000                 ENTER  0,0
  5066 00002BE1 8A4604                   mov al, [bp+4]
  5067 00002BE4 0206[B701]               add al, [wflag]
  5068 00002BE8 884604                   mov byte [bp+4], al
  5069                                  
  5070                                  ;-15     genCode8(c);
  5071                                  
  5072 00002BEB 8A4604                   mov al, byte [bp+4]
  5073 00002BEE B400                     mov ah, 0
  5074 00002BF0 50                       push ax
  5075 00002BF1 E80500                   call genCode8
  5076 00002BF4 83C402                   add  sp, 2
  5077                                  
  5078                                  ;-16 }   
  5079                                  
  5080                                  
  5081                                  ;-17 int genCode8(char c) {
  5082 00002BF7 C9                       LEAVE
  5083 00002BF8 C3                       ret
  5084                                  ; ENDP
  5085                                  
  5086                                  genCode8:  ; *** PROC ***
  5087                                  
  5088                                  ;-18 //set: BinLen++, OpPrintIndex++
  5089                                  
  5090                                  
  5091                                  ;-19     FileBin[BinLen]=c;
  5092                                  
  5093                                  ;Function : genCode8, Number of local variables: 1
  5094                                  ;   # type sign width line used address name   list of local variables
  5095                                  ;  200 var sign byte    17 NULL bp+4    c;
  5096 00002BF9 C8000000                 ENTER  0,0
  5097 00002BFD 8A4604                   mov al, [bp+4]
  5098 00002C00 8B1E[500E]               mov bx, [BinLen]
  5099 00002C04 8887[8006]               mov [FileBin+bx], al
  5100                                  
  5101                                  ;-20     BinLen++;
  5102                                  
  5103 00002C08 FF06[500E]               inc  word [BinLen]
  5104                                  
  5105                                  ;-21     PC++;
  5106                                  
  5107 00002C0C FF06[A601]               inc  word [PC]
  5108                                  
  5109                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5110                                  
  5111 00002C10 A1[500E]                 mov ax, [BinLen]
  5112 00002C13 3DD007                   cmp ax, 2000 ;unsigned : 0
  5113 00002C16 0F820900                 jb  @@genCode8198
  5114 00002C1A 68[3E2C]                 push genCode8_0
  5115 00002C1D E863FA                   call errorexit
  5116 00002C20 83C402                   add  sp, 2
  5117                                  
  5118                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5119                                  
  5120                                  @@genCode8198:
  5121 00002C23 A1[C501]                 mov ax, [OpPrintIndex]
  5122 00002C26 83F805                   cmp ax, 5
  5123 00002C29 0F8D0F00                 jge @@genCode8199
  5124                                  
  5125                                  ;-24         OpPos[OpPrintIndex]=c;
  5126                                  
  5127 00002C2D 8A4604                   mov al, [bp+4]
  5128 00002C30 8B1E[C501]               mov bx, [OpPrintIndex]
  5129 00002C34 8887[C001]               mov [OpPos+bx], al
  5130                                  
  5131                                  ;-25         OpPrintIndex++;
  5132                                  
  5133 00002C38 FF06[C501]               inc  word [OpPrintIndex]
  5134                                  
  5135                                  ;-26     }
  5136                                  
  5137                                  
  5138                                  ;-27 }
  5139                                  
  5140                                  @@genCode8199:
  5141                                  
  5142                                  ;-28 int genCode16(unsigned int i) {
  5143 00002C3C C9                       LEAVE
  5144 00002C3D C3                       ret
  5145                                  ; ENDP
  5146 00002C3E 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5147 00002C47 746F6F206C6F6E6700 
  5148                                  
  5149                                  genCode16:  ; *** PROC ***
  5150                                  
  5151                                  ;-29     genCode8(i); i=i >> 8;
  5152                                  
  5153                                  ;Function : genCode16, Number of local variables: 1
  5154                                  ;   # type sign width line used address name   list of local variables
  5155                                  ;  200 var unsg word    28 NULL bp+4    i;
  5156 00002C50 C8000000                 ENTER  0,0
  5157 00002C54 FF7604                   push word [bp+4]
  5158 00002C57 E89FFF                   call genCode8
  5159 00002C5A 83C402                   add  sp, 2
  5160 00002C5D 8B4604                   mov ax, [bp+4]
  5161 00002C60 C1E808                   shr ax, 8
  5162 00002C63 894604                   mov word [bp+4], ax
  5163                                  
  5164                                  ;-30     genCode8(i);
  5165                                  
  5166 00002C66 FF7604                   push word [bp+4]
  5167 00002C69 E88DFF                   call genCode8
  5168 00002C6C 83C402                   add  sp, 2
  5169                                  
  5170                                  ;-31 }
  5171                                  
  5172                                  
  5173                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5174 00002C6F C9                       LEAVE
  5175 00002C70 C3                       ret
  5176                                  ; ENDP
  5177                                  
  5178                                  writeEA:  ; *** PROC ***
  5179                                  
  5180                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5181                                  
  5182                                  
  5183                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5184                                  
  5185                                  
  5186                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5187                                  
  5188                                  
  5189                                  ;-36     char len;
  5190                                  
  5191                                  
  5192                                  ;-37     len=0;   
  5193                                  
  5194                                  ;Function : writeEA, Number of local variables: 2
  5195                                  ;   # type sign width line used address name   list of local variables
  5196                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5197                                  ;  201 var sign byte    36 NULL bp-2    len;
  5198 00002C71 C8020000                 ENTER  2,0
  5199 00002C75 66B800000000             mov eax, 0
  5200 00002C7B 8846FE                   mov byte [bp-2], al
  5201                                  
  5202                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5203                                  
  5204 00002C7E 8A4604                   mov al, [bp+4]
  5205 00002C81 C0E003                   shl al, 3
  5206 00002C84 884604                   mov byte [bp+4], al
  5207                                  
  5208                                  ;-39     if (Op == REG) {
  5209                                  
  5210 00002C87 A0[AC01]                 mov al, [Op]
  5211 00002C8A 3C02                     cmp al, 2
  5212 00002C8C 0F853A00                 jne @@writeEA200
  5213                                  
  5214                                  ;-40         xxx |= 0xC0;     
  5215                                  
  5216 00002C90 804E04C0                 or  byte [bp+4], 192
  5217                                  
  5218                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5219                                  
  5220 00002C94 A0[AD01]                 mov al, [Op2]
  5221 00002C97 3C01                     cmp al, 1
  5222 00002C99 0F8F0D00                 jg  @@writeEA201
  5223 00002C9D 8A4604                   mov al, [bp+4]
  5224 00002CA0 0206[B301]               add al, [R1No]
  5225 00002CA4 884604                   mov byte [bp+4], al
  5226                                  
  5227                                  ;-42             else {
  5228                                  
  5229 00002CA7 E92000                   jmp @@writeEA202
  5230                                  @@writeEA201:
  5231                                  
  5232                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5233                                  
  5234 00002CAA A0[AD01]                 mov al, [Op2]
  5235 00002CAD 3C02                     cmp al, 2
  5236 00002CAF 0F850D00                 jne @@writeEA203
  5237 00002CB3 8A4604                   mov al, [bp+4]
  5238 00002CB6 0206[B301]               add al, [R1No]
  5239 00002CBA 884604                   mov byte [bp+4], al
  5240                                  
  5241                                  ;-44                 else            xxx = xxx + R2No;  
  5242                                  
  5243 00002CBD E90A00                   jmp @@writeEA204
  5244                                  @@writeEA203:
  5245 00002CC0 8A4604                   mov al, [bp+4]
  5246 00002CC3 0206[B201]               add al, [R2No]
  5247 00002CC7 884604                   mov byte [bp+4], al
  5248                                  
  5249                                  ;-45             }
  5250                                  
  5251                                  @@writeEA204:
  5252                                  
  5253                                  ;-46         } 
  5254                                  
  5255                                  @@writeEA202:
  5256                                  
  5257                                  ;-47     if (Op == MEM) {
  5258                                  
  5259                                  @@writeEA200:
  5260 00002CCA A0[AC01]                 mov al, [Op]
  5261 00002CCD 3C04                     cmp al, 4
  5262 00002CCF 0F857F00                 jne @@writeEA205
  5263                                  
  5264                                  ;-48         if (isDirect) {
  5265                                  
  5266 00002CD3 A0[BB01]                 mov al, [isDirect]
  5267 00002CD6 08C0                     or  al, al
  5268 00002CD8 0F841000                 je @@writeEA206
  5269                                  
  5270                                  ;-49             xxx |= 6;
  5271                                  
  5272 00002CDC 804E0406                 or  byte [bp+4], 6
  5273                                  
  5274                                  ;-50             len = 2;
  5275                                  
  5276 00002CE0 66B802000000             mov eax, 2
  5277 00002CE6 8846FE                   mov byte [bp-2], al
  5278                                  
  5279                                  ;-51         }
  5280                                  
  5281                                  
  5282                                  ;-52         else { 
  5283                                  
  5284 00002CE9 E96600                   jmp @@writeEA207
  5285                                  @@writeEA206:
  5286                                  
  5287                                  ;-53             xxx = xxx + rm;   
  5288                                  
  5289 00002CEC 8A4604                   mov al, [bp+4]
  5290 00002CEF 0206[BA01]               add al, [rm]
  5291 00002CF3 884604                   mov byte [bp+4], al
  5292                                  
  5293                                  ;-54             if (rm == 6) {//make [BP+00]
  5294                                  
  5295 00002CF6 A0[BA01]                 mov al, [rm]
  5296 00002CF9 3C06                     cmp al, 6
  5297 00002CFB 0F851700                 jne @@writeEA208
  5298                                  
  5299                                  ;-55                 len=1;
  5300                                  
  5301 00002CFF 66B801000000             mov eax, 1
  5302 00002D05 8846FE                   mov byte [bp-2], al
  5303                                  
  5304                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5305                                  
  5306 00002D08 A1[BC01]                 mov ax, [disp]
  5307 00002D0B 83F800                   cmp ax, 0
  5308 00002D0E 0F850400                 jne @@writeEA209
  5309 00002D12 804E0440                 or  byte [bp+4], 64
  5310                                  
  5311                                  ;-57             }
  5312                                  
  5313                                  @@writeEA209:
  5314                                  
  5315                                  ;-58 
  5316                                  
  5317                                  
  5318                                  ;-59             if (disp) {
  5319                                  
  5320                                  @@writeEA208:
  5321 00002D16 A1[BC01]                 mov ax, [disp]
  5322 00002D19 08C0                     or  al, al
  5323 00002D1B 0F843300                 je @@writeEA210
  5324                                  
  5325                                  ;-60                 ax = disp;
  5326                                  
  5327 00002D1F A1[BC01]                 mov  ax, [disp]
  5328                                  
  5329                                  ;-61                 if(ax > 127) len=2;
  5330                                  
  5331 00002D22 83F87F                   cmp  ax, 127
  5332 00002D25 0F8E0C00                 jle @@writeEA211
  5333 00002D29 66B802000000             mov eax, 2
  5334 00002D2F 8846FE                   mov byte [bp-2], al
  5335                                  
  5336                                  ;-62                 else len=1;
  5337                                  
  5338 00002D32 E90900                   jmp @@writeEA212
  5339                                  @@writeEA211:
  5340 00002D35 66B801000000             mov eax, 1
  5341 00002D3B 8846FE                   mov byte [bp-2], al
  5342                                  
  5343                                  ;-63                 if (len == 1) xxx |= 0x40;
  5344                                  
  5345                                  @@writeEA212:
  5346 00002D3E 8A46FE                   mov al, [bp-2]
  5347 00002D41 3C01                     cmp al, 1
  5348 00002D43 0F850700                 jne @@writeEA213
  5349 00002D47 804E0440                 or  byte [bp+4], 64
  5350                                  
  5351                                  ;-64                 else xxx |= 0x80;
  5352                                  
  5353 00002D4B E90400                   jmp @@writeEA214
  5354                                  @@writeEA213:
  5355 00002D4E 804E0480                 or  byte [bp+4], 128
  5356                                  
  5357                                  ;-65             }
  5358                                  
  5359                                  @@writeEA214:
  5360                                  
  5361                                  ;-66         }
  5362                                  
  5363                                  @@writeEA210:
  5364                                  
  5365                                  ;-67     }  
  5366                                  
  5367                                  @@writeEA207:
  5368                                  
  5369                                  ;-68     
  5370                                  
  5371                                  
  5372                                  ;-69     genCode8(xxx);// gen second byte
  5373                                  
  5374                                  @@writeEA205:
  5375 00002D52 8A4604                   mov al, byte [bp+4]
  5376 00002D55 B400                     mov ah, 0
  5377 00002D57 50                       push ax
  5378 00002D58 E89EFE                   call genCode8
  5379 00002D5B 83C402                   add  sp, 2
  5380                                  
  5381                                  ;-70     if (len == 1) genCode8 (disp);
  5382                                  
  5383 00002D5E 8A46FE                   mov al, [bp-2]
  5384 00002D61 3C01                     cmp al, 1
  5385 00002D63 0F850A00                 jne @@writeEA215
  5386 00002D67 FF36[BC01]               push word [disp]
  5387 00002D6B E88BFE                   call genCode8
  5388 00002D6E 83C402                   add  sp, 2
  5389                                  
  5390                                  ;-71     if (len == 2) genCode16(disp);
  5391                                  
  5392                                  @@writeEA215:
  5393 00002D71 8A46FE                   mov al, [bp-2]
  5394 00002D74 3C02                     cmp al, 2
  5395 00002D76 0F850A00                 jne @@writeEA216
  5396 00002D7A FF36[BC01]               push word [disp]
  5397 00002D7E E8CFFE                   call genCode16
  5398 00002D81 83C402                   add  sp, 2
  5399                                  
  5400                                  ;-72 }
  5401                                  
  5402                                  @@writeEA216:
  5403                                  
  5404                                  ;-73 
  5405                                  
  5406                                  
  5407                                  ;-74 int genImmediate() { 
  5408 00002D84 C9                       LEAVE
  5409 00002D85 C3                       ret
  5410                                  ; ENDP
  5411                                  
  5412                                  genImmediate:  ; *** PROC ***
  5413                                  
  5414                                  ;-75     if (wflag) genCode16(imme);
  5415                                  
  5416 00002D86 A0[B701]                 mov al, [wflag]
  5417 00002D89 08C0                     or  al, al
  5418 00002D8B 0F840D00                 je @@genImmediate217
  5419 00002D8F FF36[BE01]               push word [imme]
  5420 00002D93 E8BAFE                   call genCode16
  5421 00002D96 83C402                   add  sp, 2
  5422                                  
  5423                                  ;-76     else       genCode8 (imme);  
  5424                                  
  5425 00002D99 E90A00                   jmp @@genImmediate218
  5426                                  @@genImmediate217:
  5427 00002D9C FF36[BE01]               push word [imme]
  5428 00002DA0 E856FE                   call genCode8
  5429 00002DA3 83C402                   add  sp, 2
  5430                                  
  5431                                  ;-77 }    
  5432                                  
  5433                                  @@genImmediate218:
  5434 00002DA6 C3                       ret
  5435                                  ; ENDP
  5436                                  ;Back to main program: AS.C
  5437                                  
  5438                                  ;-10 
  5439                                  
  5440                                  
  5441                                  ;-11 int process() { 
  5442                                  
  5443                                  
  5444                                  process:  ; *** PROC ***
  5445                                  
  5446                                  ;-12     char c;           
  5447                                  
  5448                                  
  5449                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  5450                                  
  5451                                  ;Function : process, Number of local variables: 1
  5452                                  ;   # type sign width line used address name   list of local variables
  5453                                  ;  200 var sign byte    12 NULL bp-2    c;
  5454 00002DA7 C8020000                 ENTER  2,0
  5455 00002DAB 66B800000000             mov eax, 0
  5456 00002DB1 A2[BA01]                 mov byte [rm], al
  5457 00002DB4 A2[B701]                 mov byte [wflag], al
  5458 00002DB7 A2[B801]                 mov byte [dflag], al
  5459 00002DBA A2[B201]                 mov byte [R2No], al
  5460 00002DBD A2[B301]                 mov byte [R1No], al
  5461 00002DC0 A2[B401]                 mov byte [R2Type], al
  5462 00002DC3 A2[B501]                 mov byte [R1Type], al
  5463 00002DC6 A2[AD01]                 mov byte [Op2], al
  5464 00002DC9 A2[AC01]                 mov byte [Op], al
  5465                                  
  5466                                  ;-14     disp=imme=0;//int
  5467                                  
  5468 00002DCC 66B800000000             mov eax, 0
  5469 00002DD2 A3[BE01]                 mov word [imme], ax
  5470 00002DD5 A3[BC01]                 mov word [disp], ax
  5471                                  
  5472                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5473                                  
  5474 00002DD8 66B801000000             mov eax, 1
  5475 00002DDE A2[BB01]                 mov byte [isDirect], al
  5476                                  
  5477                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5478                                  
  5479 00002DE1 E812EA                   call getTokeType
  5480                                  
  5481                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5482                                  
  5483 00002DE4 E862ED                   call getCodeSize
  5484 00002DE7 A2[B601]                 mov byte [OpSize], al
  5485                                  
  5486                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5487                                  
  5488 00002DEA E89EFD                   call getCodes
  5489                                  
  5490                                  ;-19 
  5491                                  
  5492                                  
  5493                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5494                                  
  5495 00002DED A0[AE01]                 mov al, [CodeType]
  5496 00002DF0 3C01                     cmp al, 1
  5497 00002DF2 0F850F00                 jne @@process219
  5498                                  
  5499                                  ;-21         genCode8(Code1);
  5500                                  
  5501 00002DF6 A0[AF01]                 mov al, byte [Code1]
  5502 00002DF9 B400                     mov ah, 0
  5503 00002DFB 50                       push ax
  5504 00002DFC E8FAFD                   call genCode8
  5505 00002DFF 83C402                   add  sp, 2
  5506                                  
  5507                                  ;-22         return;
  5508                                  
  5509 00002E02 E90605                   jmp @@retn
  5510                                  
  5511                                  ;-23     }
  5512                                  
  5513                                  
  5514                                  ;-24   
  5515                                  
  5516                                  
  5517                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  5518                                  
  5519                                  @@process219:
  5520 00002E05 A0[AE01]                 mov al, [CodeType]
  5521 00002E08 3C02                     cmp al, 2
  5522 00002E0A 0F856900                 jne @@process220
  5523                                  
  5524                                  ;-26         getOpL();    
  5525                                  
  5526 00002E0E E80EE5                   call getOpL
  5527                                  
  5528                                  ;-27         checkOpL();        
  5529                                  
  5530 00002E11 E82EE4                   call checkOpL
  5531                                  
  5532                                  ;-28         if (Code2 <= 1) {//inc,dec
  5533                                  
  5534 00002E14 A0[B001]                 mov al, [Code2]
  5535 00002E17 3C01                     cmp al, 1
  5536 00002E19 0F8F2700                 jg  @@process221
  5537                                  
  5538                                  ;-29   	        if (Op == REG) {//short
  5539                                  
  5540 00002E1D A0[AC01]                 mov al, [Op]
  5541 00002E20 3C02                     cmp al, 2
  5542 00002E22 0F851E00                 jne @@process222
  5543                                  
  5544                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5545                                  
  5546 00002E26 A0[B701]                 mov al, [wflag]
  5547 00002E29 08C0                     or  al, al
  5548 00002E2B 0F841500                 je @@process223
  5549 00002E2F A0[B301]                 mov al, byte [R1No]
  5550 00002E32 B400                     mov ah, 0
  5551 00002E34 50                       push ax
  5552 00002E35 A0[B101]                 mov al, byte [Code3]
  5553 00002E38 B400                     mov ah, 0
  5554 00002E3A 50                       push ax
  5555 00002E3B E884FD                   call genCode2
  5556 00002E3E 83C404                   add  sp, 4
  5557 00002E41 E9C704                   jmp @@retn
  5558                                  
  5559                                  ;-31             }
  5560                                  
  5561                                  @@process223:
  5562                                  
  5563                                  ;-32         }
  5564                                  
  5565                                  @@process222:
  5566                                  
  5567                                  ;-33         if (Code2 == 5) {//imul extension?
  5568                                  
  5569                                  @@process221:
  5570 00002E44 A0[B001]                 mov al, [Code2]
  5571 00002E47 3C05                     cmp al, 5
  5572 00002E49 0F850F00                 jne @@process224
  5573                                  
  5574                                  ;-34             getTokeType();
  5575                                  
  5576 00002E4D E8A6E9                   call getTokeType
  5577                                  
  5578                                  ;-35             if (TokeType) implerror();
  5579                                  
  5580 00002E50 A0[AB01]                 mov al, [TokeType]
  5581 00002E53 08C0                     or  al, al
  5582 00002E55 0F840300                 je @@process225
  5583 00002E59 E898F8                   call implerror
  5584                                  
  5585                                  ;-36         }
  5586                                  
  5587                                  @@process225:
  5588                                  
  5589                                  ;-37         genCodeW(Code1);           
  5590                                  
  5591                                  @@process224:
  5592 00002E5C A0[AF01]                 mov al, byte [Code1]
  5593 00002E5F B400                     mov ah, 0
  5594 00002E61 50                       push ax
  5595 00002E62 E878FD                   call genCodeW
  5596 00002E65 83C402                   add  sp, 2
  5597                                  
  5598                                  ;-38         writeEA(Code2);
  5599                                  
  5600 00002E68 A0[B001]                 mov al, byte [Code2]
  5601 00002E6B B400                     mov ah, 0
  5602 00002E6D 50                       push ax
  5603 00002E6E E800FE                   call writeEA
  5604 00002E71 83C402                   add  sp, 2
  5605                                  
  5606                                  ;-39         return;
  5607                                  
  5608 00002E74 E99404                   jmp @@retn
  5609                                  
  5610                                  ;-40     }
  5611                                  
  5612                                  
  5613                                  ;-41   
  5614                                  
  5615                                  
  5616                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5617                                  
  5618                                  @@process220:
  5619 00002E77 A0[AE01]                 mov al, [CodeType]
  5620 00002E7A 3C03                     cmp al, 3
  5621 00002E7C 0F855100                 jne @@process226
  5622                                  
  5623                                  ;-43         check2Ops();    //setwflag not applicable
  5624                                  
  5625 00002E80 E841E4                   call check2Ops
  5626                                  
  5627                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5628                                  
  5629 00002E83 A0[B501]                 mov al, [R1Type]
  5630 00002E86 3C02                     cmp al, 2
  5631 00002E88 0F840300                 je  @@process227
  5632 00002E8C E805F9                   call reg16error
  5633                                  
  5634                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  5635                                  
  5636                                  @@process227:
  5637 00002E8F A0[AD01]                 mov al, [Op2]
  5638 00002E92 3C04                     cmp al, 4
  5639 00002E94 0F840300                 je  @@process228
  5640 00002E98 E81AF8                   call addrerror
  5641                                  
  5642                                  ;-46         
  5643                                  
  5644                                  
  5645                                  ;-47         genCode8(Code1);//les,lds,lea
  5646                                  
  5647                                  @@process228:
  5648 00002E9B A0[AF01]                 mov al, byte [Code1]
  5649 00002E9E B400                     mov ah, 0
  5650 00002EA0 50                       push ax
  5651 00002EA1 E855FD                   call genCode8
  5652 00002EA4 83C402                   add  sp, 2
  5653                                  
  5654                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5655                                  
  5656 00002EA7 A0[AF01]                 mov al, [Code1]
  5657 00002EAA 3C0F                     cmp al, 15
  5658 00002EAC 0F850C00                 jne @@process229
  5659 00002EB0 A0[B001]                 mov al, byte [Code2]
  5660 00002EB3 B400                     mov ah, 0
  5661 00002EB5 50                       push ax
  5662 00002EB6 E840FD                   call genCode8
  5663 00002EB9 83C402                   add  sp, 2
  5664                                  
  5665                                  ;-49         Op=Op2;//set MEM for writeEA
  5666                                  
  5667                                  @@process229:
  5668 00002EBC A0[AD01]                 mov al, [Op2]
  5669 00002EBF A2[AC01]                 mov byte [Op], al
  5670                                  
  5671                                  ;-50         writeEA(R1No);           
  5672                                  
  5673 00002EC2 A0[B301]                 mov al, byte [R1No]
  5674 00002EC5 B400                     mov ah, 0
  5675 00002EC7 50                       push ax
  5676 00002EC8 E8A6FD                   call writeEA
  5677 00002ECB 83C402                   add  sp, 2
  5678                                  
  5679                                  ;-51         return;
  5680                                  
  5681 00002ECE E93A04                   jmp @@retn
  5682                                  
  5683                                  ;-52     }
  5684                                  
  5685                                  
  5686                                  ;-53 
  5687                                  
  5688                                  
  5689                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  5690                                  
  5691                                  @@process226:
  5692 00002ED1 A0[AE01]                 mov al, [CodeType]
  5693 00002ED4 3C04                     cmp al, 4
  5694 00002ED6 0F85EF00                 jne @@process230
  5695                                  
  5696                                  ;-55         check2Ops();    
  5697                                  
  5698 00002EDA E8E7E3                   call check2Ops
  5699                                  
  5700                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  5701                                  
  5702 00002EDD A0[AD01]                 mov al, [Op2]
  5703 00002EE0 3C01                     cmp al, 1
  5704 00002EE2 0F857900                 jne @@process231
  5705                                  
  5706                                  ;-57             setsflag();   
  5707                                  
  5708 00002EE6 E8BEE7                   call setsflag
  5709                                  
  5710                                  ;-58             if (Op == REG) {                
  5711                                  
  5712 00002EE9 A0[AC01]                 mov al, [Op]
  5713 00002EEC 3C02                     cmp al, 2
  5714 00002EEE 0F853100                 jne @@process232
  5715                                  
  5716                                  ;-59                 if (R1No == 0) {// acc,imm   
  5717                                  
  5718 00002EF2 A0[B301]                 mov al, [R1No]
  5719 00002EF5 3C00                     cmp al, 0
  5720 00002EF7 0F852800                 jne @@process233
  5721                                  
  5722                                  ;-60                     if (sflag == 0) {                        
  5723                                  
  5724 00002EFB A0[B901]                 mov al, [sflag]
  5725 00002EFE 3C00                     cmp al, 0
  5726 00002F00 0F851F00                 jne @@process234
  5727                                  
  5728                                  ;-61                         c = Code1 << 3;
  5729                                  
  5730 00002F04 A0[AF01]                 mov al, [Code1]
  5731 00002F07 C0E003                   shl al, 3
  5732 00002F0A 8846FE                   mov byte [bp-2], al
  5733                                  
  5734                                  ;-62                         c += 4;    
  5735                                  
  5736 00002F0D 8046FE04                 add  byte [bp-2], 4
  5737                                  
  5738                                  ;-63                         genCodeW(c);
  5739                                  
  5740 00002F11 8A46FE                   mov al, byte [bp-2]
  5741 00002F14 B400                     mov ah, 0
  5742 00002F16 50                       push ax
  5743 00002F17 E8C3FC                   call genCodeW
  5744 00002F1A 83C402                   add  sp, 2
  5745                                  
  5746                                  ;-64                         genImmediate();
  5747                                  
  5748 00002F1D E866FE                   call genImmediate
  5749                                  
  5750                                  ;-65                         return;
  5751                                  
  5752 00002F20 E9E803                   jmp @@retn
  5753                                  
  5754                                  ;-66                     }
  5755                                  
  5756                                  
  5757                                  ;-67                 }
  5758                                  
  5759                                  @@process234:
  5760                                  
  5761                                  ;-68             }
  5762                                  
  5763                                  @@process233:
  5764                                  
  5765                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  5766                                  
  5767                                  
  5768                                  ;-70             c = sflag + 0x80;   
  5769                                  
  5770                                  @@process232:
  5771 00002F23 A0[B901]                 mov al, [sflag]
  5772 00002F26 0480                     add al, 128
  5773 00002F28 8846FE                   mov byte [bp-2], al
  5774                                  
  5775                                  ;-71             genCodeW(c); 
  5776                                  
  5777 00002F2B 8A46FE                   mov al, byte [bp-2]
  5778 00002F2E B400                     mov ah, 0
  5779 00002F30 50                       push ax
  5780 00002F31 E8A9FC                   call genCodeW
  5781 00002F34 83C402                   add  sp, 2
  5782                                  
  5783                                  ;-72             writeEA(Code1);  
  5784                                  
  5785 00002F37 A0[AF01]                 mov al, byte [Code1]
  5786 00002F3A B400                     mov ah, 0
  5787 00002F3C 50                       push ax
  5788 00002F3D E831FD                   call writeEA
  5789 00002F40 83C402                   add  sp, 2
  5790                                  
  5791                                  ;-73             if (sflag) genCode8(imme);
  5792                                  
  5793 00002F43 A0[B901]                 mov al, [sflag]
  5794 00002F46 08C0                     or  al, al
  5795 00002F48 0F840D00                 je @@process235
  5796 00002F4C FF36[BE01]               push word [imme]
  5797 00002F50 E8A6FC                   call genCode8
  5798 00002F53 83C402                   add  sp, 2
  5799                                  
  5800                                  ;-74             else genImmediate();    
  5801                                  
  5802 00002F56 E90300                   jmp @@process236
  5803                                  @@process235:
  5804 00002F59 E82AFE                   call genImmediate
  5805                                  
  5806                                  ;-75             return;     
  5807                                  
  5808                                  @@process236:
  5809 00002F5C E9AC03                   jmp @@retn
  5810                                  
  5811                                  ;-76         }  
  5812                                  
  5813                                  
  5814                                  ;-77         c = Code1 << 3;//r/m, r/r  
  5815                                  
  5816                                  @@process231:
  5817 00002F5F A0[AF01]                 mov al, [Code1]
  5818 00002F62 C0E003                   shl al, 3
  5819 00002F65 8846FE                   mov byte [bp-2], al
  5820                                  
  5821                                  ;-78         if (Op == REG) {
  5822                                  
  5823 00002F68 A0[AC01]                 mov al, [Op]
  5824 00002F6B 3C02                     cmp al, 2
  5825 00002F6D 0F852E00                 jne @@process237
  5826                                  
  5827                                  ;-79             if (Op2 == MEM) {//reg, mem      
  5828                                  
  5829 00002F71 A0[AD01]                 mov al, [Op2]
  5830 00002F74 3C04                     cmp al, 4
  5831 00002F76 0F852500                 jne @@process238
  5832                                  
  5833                                  ;-80                 c += 2;//add direction flag
  5834                                  
  5835 00002F7A 8046FE02                 add  byte [bp-2], 2
  5836                                  
  5837                                  ;-81                 genCodeW(c);
  5838                                  
  5839 00002F7E 8A46FE                   mov al, byte [bp-2]
  5840 00002F81 B400                     mov ah, 0
  5841 00002F83 50                       push ax
  5842 00002F84 E856FC                   call genCodeW
  5843 00002F87 83C402                   add  sp, 2
  5844                                  
  5845                                  ;-82                 Op=Op2;//set MEM for writeEA                
  5846                                  
  5847 00002F8A A0[AD01]                 mov al, [Op2]
  5848 00002F8D A2[AC01]                 mov byte [Op], al
  5849                                  
  5850                                  ;-83                 writeEA(R1No);
  5851                                  
  5852 00002F90 A0[B301]                 mov al, byte [R1No]
  5853 00002F93 B400                     mov ah, 0
  5854 00002F95 50                       push ax
  5855 00002F96 E8D8FC                   call writeEA
  5856 00002F99 83C402                   add  sp, 2
  5857                                  
  5858                                  ;-84                 return;    
  5859                                  
  5860 00002F9C E96C03                   jmp @@retn
  5861                                  
  5862                                  ;-85             }
  5863                                  
  5864                                  
  5865                                  ;-86         }
  5866                                  
  5867                                  @@process238:
  5868                                  
  5869                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  5870                                  
  5871                                  @@process237:
  5872 00002F9F A0[AD01]                 mov al, [Op2]
  5873 00002FA2 3C02                     cmp al, 2
  5874 00002FA4 0F851B00                 jne @@process239
  5875                                  
  5876                                  ;-88             genCodeW(c);
  5877                                  
  5878 00002FA8 8A46FE                   mov al, byte [bp-2]
  5879 00002FAB B400                     mov ah, 0
  5880 00002FAD 50                       push ax
  5881 00002FAE E82CFC                   call genCodeW
  5882 00002FB1 83C402                   add  sp, 2
  5883                                  
  5884                                  ;-89             writeEA(R2No);//2. Op in reg-field
  5885                                  
  5886 00002FB4 A0[B201]                 mov al, byte [R2No]
  5887 00002FB7 B400                     mov ah, 0
  5888 00002FB9 50                       push ax
  5889 00002FBA E8B4FC                   call writeEA
  5890 00002FBD 83C402                   add  sp, 2
  5891                                  
  5892                                  ;-90             return;            
  5893                                  
  5894 00002FC0 E94803                   jmp @@retn
  5895                                  
  5896                                  ;-91         }          
  5897                                  
  5898                                  
  5899                                  ;-92         syntaxerror();        
  5900                                  
  5901                                  @@process239:
  5902 00002FC3 E81DF8                   call syntaxerror
  5903                                  
  5904                                  ;-93         return;
  5905                                  
  5906 00002FC6 E94203                   jmp @@retn
  5907                                  
  5908                                  ;-94     }
  5909                                  
  5910                                  
  5911                                  ;-95  
  5912                                  
  5913                                  
  5914                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  5915                                  
  5916                                  @@process230:
  5917 00002FC9 A0[AE01]                 mov al, [CodeType]
  5918 00002FCC 3C05                     cmp al, 5
  5919 00002FCE 0F857F01                 jne @@process240
  5920                                  
  5921                                  ;-97         check2Ops();    
  5922                                  
  5923 00002FD2 E8EFE2                   call check2Ops
  5924                                  
  5925                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  5926                                  
  5927                                  
  5928                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  5929                                  
  5930                                  
  5931                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  5932                                  
  5933                                  
  5934                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  5935                                  
  5936                                  
  5937                                  ;-102         if (Op2 == ADR) {
  5938                                  
  5939 00002FD5 A0[AD01]                 mov al, [Op2]
  5940 00002FD8 3C03                     cmp al, 3
  5941 00002FDA 0F850F00                 jne @@process241
  5942                                  
  5943                                  ;-103             imme=disp;
  5944                                  
  5945 00002FDE A1[BC01]                 mov ax, [disp]
  5946 00002FE1 A3[BE01]                 mov word [imme], ax
  5947                                  
  5948                                  ;-104             Op2=IMM;//continue with IMM    
  5949                                  
  5950 00002FE4 66B801000000             mov eax, 1
  5951 00002FEA A2[AD01]                 mov byte [Op2], al
  5952                                  
  5953                                  ;-105         }  
  5954                                  
  5955                                  
  5956                                  ;-106         if (Op2 == IMM) {// r,i     
  5957                                  
  5958                                  @@process241:
  5959 00002FED A0[AD01]                 mov al, [Op2]
  5960 00002FF0 3C01                     cmp al, 1
  5961 00002FF2 0F855400                 jne @@process242
  5962                                  
  5963                                  ;-107             if (Op == REG) {               
  5964                                  
  5965 00002FF6 A0[AC01]                 mov al, [Op]
  5966 00002FF9 3C02                     cmp al, 2
  5967 00002FFB 0F852500                 jne @@process243
  5968                                  
  5969                                  ;-108                 c = wflag << 3;   
  5970                                  
  5971 00002FFF A0[B701]                 mov al, [wflag]
  5972 00003002 C0E003                   shl al, 3
  5973 00003005 8846FE                   mov byte [bp-2], al
  5974                                  
  5975                                  ;-109                 c += 0xB0;                                     
  5976                                  
  5977 00003008 8046FEB0                 add  byte [bp-2], 176
  5978                                  
  5979                                  ;-110                 genCode2(c, R1No);   
  5980                                  
  5981 0000300C A0[B301]                 mov al, byte [R1No]
  5982 0000300F B400                     mov ah, 0
  5983 00003011 50                       push ax
  5984 00003012 8A46FE                   mov al, byte [bp-2]
  5985 00003015 B400                     mov ah, 0
  5986 00003017 50                       push ax
  5987 00003018 E8A7FB                   call genCode2
  5988 0000301B 83C404                   add  sp, 4
  5989                                  
  5990                                  ;-111                 genImmediate();
  5991                                  
  5992 0000301E E865FD                   call genImmediate
  5993                                  
  5994                                  ;-112                 return; 
  5995                                  
  5996 00003021 E9E702                   jmp @@retn
  5997                                  
  5998                                  ;-113             }
  5999                                  
  6000                                  
  6001                                  ;-114             if (Op == MEM) {// m,i  
  6002                                  
  6003                                  @@process243:
  6004 00003024 A0[AC01]                 mov al, [Op]
  6005 00003027 3C04                     cmp al, 4
  6006 00003029 0F851700                 jne @@process244
  6007                                  
  6008                                  ;-115                 genCodeW(0xC6);
  6009                                  
  6010 0000302D 68C600                   push 198
  6011 00003030 E8AAFB                   call genCodeW
  6012 00003033 83C402                   add  sp, 2
  6013                                  
  6014                                  ;-116                 writeEA( 0 );
  6015                                  
  6016 00003036 6A00                     push 0
  6017 00003038 E836FC                   call writeEA
  6018 0000303B 83C402                   add  sp, 2
  6019                                  
  6020                                  ;-117                 genImmediate();
  6021                                  
  6022 0000303E E845FD                   call genImmediate
  6023                                  
  6024                                  ;-118                 return;  
  6025                                  
  6026 00003041 E9C702                   jmp @@retn
  6027                                  
  6028                                  ;-119             }
  6029                                  
  6030                                  
  6031                                  ;-120             regmemerror();
  6032                                  
  6033                                  @@process244:
  6034 00003044 E823F7                   call regmemerror
  6035                                  
  6036                                  ;-121             return;
  6037                                  
  6038 00003047 E9C102                   jmp @@retn
  6039                                  
  6040                                  ;-122         }      
  6041                                  
  6042                                  
  6043                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6044                                  
  6045                                  @@process242:
  6046 0000304A A0[B501]                 mov al, [R1Type]
  6047 0000304D 3C04                     cmp al, 4
  6048 0000304F 0F850300                 jne @@process245
  6049 00003053 E8A7E1                   call ChangeDirection
  6050                                  
  6051                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6052                                  
  6053                                  @@process245:
  6054 00003056 A0[B401]                 mov al, [R2Type]
  6055 00003059 3C04                     cmp al, 4
  6056 0000305B 0F852A00                 jne @@process246
  6057                                  
  6058                                  ;-125             if (OpSize != WORD) reg16error();
  6059                                  
  6060 0000305F A0[B601]                 mov al, [OpSize]
  6061 00003062 3C02                     cmp al, 2
  6062 00003064 0F840300                 je  @@process247
  6063 00003068 E829F7                   call reg16error
  6064                                  
  6065                                  ;-126                 genCode2(0x8C, dflag);
  6066                                  
  6067                                  @@process247:
  6068 0000306B A0[B801]                 mov al, byte [dflag]
  6069 0000306E B400                     mov ah, 0
  6070 00003070 50                       push ax
  6071 00003071 688C00                   push 140
  6072 00003074 E84BFB                   call genCode2
  6073 00003077 83C404                   add  sp, 4
  6074                                  
  6075                                  ;-127                 writeEA(R2No);
  6076                                  
  6077 0000307A A0[B201]                 mov al, byte [R2No]
  6078 0000307D B400                     mov ah, 0
  6079 0000307F 50                       push ax
  6080 00003080 E8EEFB                   call writeEA
  6081 00003083 83C402                   add  sp, 2
  6082                                  
  6083                                  ;-128                 return;   
  6084                                  
  6085 00003086 E98202                   jmp @@retn
  6086                                  
  6087                                  ;-129         }          
  6088                                  
  6089                                  
  6090                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6091                                  
  6092                                  @@process246:
  6093 00003089 A0[AD01]                 mov al, [Op2]
  6094 0000308C 3C04                     cmp al, 4
  6095 0000308E 0F853100                 jne @@process248
  6096                                  
  6097                                  ;-131             if (Op == REG) {
  6098                                  
  6099 00003092 A0[AC01]                 mov al, [Op]
  6100 00003095 3C02                     cmp al, 2
  6101 00003097 0F852800                 jne @@process249
  6102                                  
  6103                                  ;-132                 if (R1No == 0) {
  6104                                  
  6105 0000309B A0[B301]                 mov al, [R1No]
  6106 0000309E 3C00                     cmp al, 0
  6107 000030A0 0F851F00                 jne @@process250
  6108                                  
  6109                                  ;-133                     if (isDirect) {
  6110                                  
  6111 000030A4 A0[BB01]                 mov al, [isDirect]
  6112 000030A7 08C0                     or  al, al
  6113 000030A9 0F841600                 je @@process251
  6114                                  
  6115                                  ;-134                         genCodeW(0xA0);
  6116                                  
  6117 000030AD 68A000                   push 160
  6118 000030B0 E82AFB                   call genCodeW
  6119 000030B3 83C402                   add  sp, 2
  6120                                  
  6121                                  ;-135                         genCode16(disp);
  6122                                  
  6123 000030B6 FF36[BC01]               push word [disp]
  6124 000030BA E893FB                   call genCode16
  6125 000030BD 83C402                   add  sp, 2
  6126                                  
  6127                                  ;-136                         return;   
  6128                                  
  6129 000030C0 E94802                   jmp @@retn
  6130                                  
  6131                                  ;-137                     }   
  6132                                  
  6133                                  
  6134                                  ;-138                 }   
  6135                                  
  6136                                  @@process251:
  6137                                  
  6138                                  ;-139             }   
  6139                                  
  6140                                  @@process250:
  6141                                  
  6142                                  ;-140         } 
  6143                                  
  6144                                  @@process249:
  6145                                  
  6146                                  ;-141         if (Op == MEM) {//moffs16, acc
  6147                                  
  6148                                  @@process248:
  6149 000030C3 A0[AC01]                 mov al, [Op]
  6150 000030C6 3C04                     cmp al, 4
  6151 000030C8 0F853100                 jne @@process252
  6152                                  
  6153                                  ;-142             if (Op2 == REG) {
  6154                                  
  6155 000030CC A0[AD01]                 mov al, [Op2]
  6156 000030CF 3C02                     cmp al, 2
  6157 000030D1 0F852800                 jne @@process253
  6158                                  
  6159                                  ;-143                 if (R2No == 0) {
  6160                                  
  6161 000030D5 A0[B201]                 mov al, [R2No]
  6162 000030D8 3C00                     cmp al, 0
  6163 000030DA 0F851F00                 jne @@process254
  6164                                  
  6165                                  ;-144                     if (isDirect) {
  6166                                  
  6167 000030DE A0[BB01]                 mov al, [isDirect]
  6168 000030E1 08C0                     or  al, al
  6169 000030E3 0F841600                 je @@process255
  6170                                  
  6171                                  ;-145                         genCodeW(0xA2);
  6172                                  
  6173 000030E7 68A200                   push 162
  6174 000030EA E8F0FA                   call genCodeW
  6175 000030ED 83C402                   add  sp, 2
  6176                                  
  6177                                  ;-146                         genCode16(disp);
  6178                                  
  6179 000030F0 FF36[BC01]               push word [disp]
  6180 000030F4 E859FB                   call genCode16
  6181 000030F7 83C402                   add  sp, 2
  6182                                  
  6183                                  ;-147                         return;   
  6184                                  
  6185 000030FA E90E02                   jmp @@retn
  6186                                  
  6187                                  ;-148                     }   
  6188                                  
  6189                                  
  6190                                  ;-149                 }   
  6191                                  
  6192                                  @@process255:
  6193                                  
  6194                                  ;-150             }
  6195                                  
  6196                                  @@process254:
  6197                                  
  6198                                  ;-151         
  6199                                  
  6200                                  
  6201                                  ;-152         }
  6202                                  
  6203                                  @@process253:
  6204                                  
  6205                                  ;-153         if (Op2 == REG) {//rm, r
  6206                                  
  6207                                  @@process252:
  6208 000030FD A0[AD01]                 mov al, [Op2]
  6209 00003100 3C02                     cmp al, 2
  6210 00003102 0F851800                 jne @@process256
  6211                                  
  6212                                  ;-154             genCodeW(0x88);     
  6213                                  
  6214 00003106 688800                   push 136
  6215 00003109 E8D1FA                   call genCodeW
  6216 0000310C 83C402                   add  sp, 2
  6217                                  
  6218                                  ;-155             writeEA(R2No);
  6219                                  
  6220 0000310F A0[B201]                 mov al, byte [R2No]
  6221 00003112 B400                     mov ah, 0
  6222 00003114 50                       push ax
  6223 00003115 E859FB                   call writeEA
  6224 00003118 83C402                   add  sp, 2
  6225                                  
  6226                                  ;-156             return;
  6227                                  
  6228 0000311B E9ED01                   jmp @@retn
  6229                                  
  6230                                  ;-157         }
  6231                                  
  6232                                  
  6233                                  ;-158         if (Op2 == MEM) {//r, m
  6234                                  
  6235                                  @@process256:
  6236 0000311E A0[AD01]                 mov al, [Op2]
  6237 00003121 3C04                     cmp al, 4
  6238 00003123 0F852400                 jne @@process257
  6239                                  
  6240                                  ;-159             if (Op == REG) {
  6241                                  
  6242 00003127 A0[AC01]                 mov al, [Op]
  6243 0000312A 3C02                     cmp al, 2
  6244 0000312C 0F851B00                 jne @@process258
  6245                                  
  6246                                  ;-160                 ChangeDirection();
  6247                                  
  6248 00003130 E8CAE0                   call ChangeDirection
  6249                                  
  6250                                  ;-161                 genCodeW(0x8A);
  6251                                  
  6252 00003133 688A00                   push 138
  6253 00003136 E8A4FA                   call genCodeW
  6254 00003139 83C402                   add  sp, 2
  6255                                  
  6256                                  ;-162                 writeEA(R2No);
  6257                                  
  6258 0000313C A0[B201]                 mov al, byte [R2No]
  6259 0000313F B400                     mov ah, 0
  6260 00003141 50                       push ax
  6261 00003142 E82CFB                   call writeEA
  6262 00003145 83C402                   add  sp, 2
  6263                                  
  6264                                  ;-163                 return;   
  6265                                  
  6266 00003148 E9C001                   jmp @@retn
  6267                                  
  6268                                  ;-164             }   
  6269                                  
  6270                                  
  6271                                  ;-165         }         
  6272                                  
  6273                                  @@process258:
  6274                                  
  6275                                  ;-166         syntaxerror();
  6276                                  
  6277                                  @@process257:
  6278 0000314B E895F6                   call syntaxerror
  6279                                  
  6280                                  ;-167         return;
  6281                                  
  6282 0000314E E9BA01                   jmp @@retn
  6283                                  
  6284                                  ;-168     }    
  6285                                  
  6286                                  
  6287                                  ;-169     
  6288                                  
  6289                                  
  6290                                  ;-170     if (CodeType ==  8) {//ret,retf
  6291                                  
  6292                                  @@process240:
  6293 00003151 A0[AE01]                 mov al, [CodeType]
  6294 00003154 3C08                     cmp al, 8
  6295 00003156 0F853100                 jne @@process259
  6296                                  
  6297                                  ;-171         if (TokeType == DIGIT) {
  6298                                  
  6299 0000315A A0[AB01]                 mov al, [TokeType]
  6300 0000315D 3C01                     cmp al, 1
  6301 0000315F 0F851900                 jne @@process260
  6302                                  
  6303                                  ;-172             genCode8(Code2);
  6304                                  
  6305 00003163 A0[B001]                 mov al, byte [Code2]
  6306 00003166 B400                     mov ah, 0
  6307 00003168 50                       push ax
  6308 00003169 E88DFA                   call genCode8
  6309 0000316C 83C402                   add  sp, 2
  6310                                  
  6311                                  ;-173             genCode16(SymbolInt);
  6312                                  
  6313 0000316F FF36[4D00]               push word [SymbolInt]
  6314 00003173 E8DAFA                   call genCode16
  6315 00003176 83C402                   add  sp, 2
  6316                                  
  6317                                  ;-174             return;
  6318                                  
  6319 00003179 E98F01                   jmp @@retn
  6320                                  
  6321                                  ;-175         }
  6322                                  
  6323                                  
  6324                                  ;-176         genCode8(Code1); 
  6325                                  
  6326                                  @@process260:
  6327 0000317C A0[AF01]                 mov al, byte [Code1]
  6328 0000317F B400                     mov ah, 0
  6329 00003181 50                       push ax
  6330 00003182 E874FA                   call genCode8
  6331 00003185 83C402                   add  sp, 2
  6332                                  
  6333                                  ;-177         return;
  6334                                  
  6335 00003188 E98001                   jmp @@retn
  6336                                  
  6337                                  ;-178     }
  6338                                  
  6339                                  
  6340                                  ;-179        
  6341                                  
  6342                                  
  6343                                  ;-180     if (CodeType == 9) {//push, pop  
  6344                                  
  6345                                  @@process259:
  6346 0000318B A0[AE01]                 mov al, [CodeType]
  6347 0000318E 3C09                     cmp al, 9
  6348 00003190 0F850301                 jne @@process261
  6349                                  
  6350                                  ;-181         getOpL();
  6351                                  
  6352 00003194 E888E1                   call getOpL
  6353                                  
  6354                                  ;-182         if (Code1 == 0x50) {//push only
  6355                                  
  6356 00003197 A0[AF01]                 mov al, [Code1]
  6357 0000319A 3C50                     cmp al, 80
  6358 0000319C 0F853D00                 jne @@process262
  6359                                  
  6360                                  ;-183             if (Op == IMM) {//push imm8,16
  6361                                  
  6362 000031A0 A0[AC01]                 mov al, [Op]
  6363 000031A3 3C01                     cmp al, 1
  6364 000031A5 0F853400                 jne @@process263
  6365                                  
  6366                                  ;-184                 setsflag();
  6367                                  
  6368 000031A9 E8FBE4                   call setsflag
  6369                                  
  6370                                  ;-185                 genCode2(0x68, sflag);     
  6371                                  
  6372 000031AC A0[B901]                 mov al, byte [sflag]
  6373 000031AF B400                     mov ah, 0
  6374 000031B1 50                       push ax
  6375 000031B2 6A68                     push 104
  6376 000031B4 E80BFA                   call genCode2
  6377 000031B7 83C404                   add  sp, 4
  6378                                  
  6379                                  ;-186                 if (sflag) genCode8 (imme);
  6380                                  
  6381 000031BA A0[B901]                 mov al, [sflag]
  6382 000031BD 08C0                     or  al, al
  6383 000031BF 0F840D00                 je @@process264
  6384 000031C3 FF36[BE01]               push word [imme]
  6385 000031C7 E82FFA                   call genCode8
  6386 000031CA 83C402                   add  sp, 2
  6387                                  
  6388                                  ;-187                 else       genCode16(imme);    
  6389                                  
  6390 000031CD E90A00                   jmp @@process265
  6391                                  @@process264:
  6392 000031D0 FF36[BE01]               push word [imme]
  6393 000031D4 E879FA                   call genCode16
  6394 000031D7 83C402                   add  sp, 2
  6395                                  
  6396                                  ;-188                 return;   
  6397                                  
  6398                                  @@process265:
  6399 000031DA E92E01                   jmp @@retn
  6400                                  
  6401                                  ;-189             }   
  6402                                  
  6403                                  
  6404                                  ;-190         }
  6405                                  
  6406                                  @@process263:
  6407                                  
  6408                                  ;-191         if (R1Type == SEGREG) {
  6409                                  
  6410                                  @@process262:
  6411 000031DD A0[B501]                 mov al, [R1Type]
  6412 000031E0 3C04                     cmp al, 4
  6413 000031E2 0F855A00                 jne @@process266
  6414                                  
  6415                                  ;-192             if (Code1 == 0x58) {
  6416                                  
  6417 000031E6 A0[AF01]                 mov al, [Code1]
  6418 000031E9 3C58                     cmp al, 88
  6419 000031EB 0F851200                 jne @@process267
  6420                                  
  6421                                  ;-193                 if (R1No == 1) error1("pop cs not allowed");   
  6422                                  
  6423 000031EF A0[B301]                 mov al, [R1No]
  6424 000031F2 3C01                     cmp al, 1
  6425 000031F4 0F850900                 jne @@process268
  6426 000031F8 68[0D33]                 push process_0
  6427 000031FB E826F4                   call error1
  6428 000031FE 83C402                   add  sp, 2
  6429                                  
  6430                                  ;-194             }
  6431                                  
  6432                                  @@process268:
  6433                                  
  6434                                  ;-195             c = R1No <<3;
  6435                                  
  6436                                  @@process267:
  6437 00003201 A0[B301]                 mov al, [R1No]
  6438 00003204 C0E003                   shl al, 3
  6439 00003207 8846FE                   mov byte [bp-2], al
  6440                                  
  6441                                  ;-196             if (R1No > 3) {//FS, GS
  6442                                  
  6443 0000320A A0[B301]                 mov al, [R1No]
  6444 0000320D 3C03                     cmp al, 3
  6445 0000320F 0F8E0C00                 jle @@process269
  6446                                  
  6447                                  ;-197                 c += 122;
  6448                                  
  6449 00003213 8046FE7A                 add  byte [bp-2], 122
  6450                                  
  6451                                  ;-198                 genCode8(0x0F);
  6452                                  
  6453 00003217 6A0F                     push 15
  6454 00003219 E8DDF9                   call genCode8
  6455 0000321C 83C402                   add  sp, 2
  6456                                  
  6457                                  ;-199             }
  6458                                  
  6459                                  
  6460                                  ;-200             OpCodePtr++;
  6461                                  
  6462                                  @@process269:
  6463 0000321F FF06[C701]               inc  word [OpCodePtr]
  6464                                  
  6465                                  ;-201             c = c + *OpCodePtr;//is Code4   
  6466                                  
  6467 00003223 8A46FE                   mov al, [bp-2]
  6468 00003226 8B1E[C701]               mov bx, [OpCodePtr]
  6469 0000322A 0207                     add al, [bx]
  6470 0000322C B400                     mov ah, 0
  6471 0000322E 8846FE                   mov byte [bp-2], al
  6472                                  
  6473                                  ;-202             genCode8(c);  
  6474                                  
  6475 00003231 8A46FE                   mov al, byte [bp-2]
  6476 00003234 B400                     mov ah, 0
  6477 00003236 50                       push ax
  6478 00003237 E8BFF9                   call genCode8
  6479 0000323A 83C402                   add  sp, 2
  6480                                  
  6481                                  ;-203             return; 
  6482                                  
  6483 0000323D E9CB00                   jmp @@retn
  6484                                  
  6485                                  ;-204         }  
  6486                                  
  6487                                  
  6488                                  ;-205   
  6489                                  
  6490                                  
  6491                                  ;-206         checkOpL();    
  6492                                  
  6493                                  @@process266:
  6494 00003240 E8FFDF                   call checkOpL
  6495                                  
  6496                                  ;-207         if (R1Type == BYTE) reg16error();
  6497                                  
  6498 00003243 A0[B501]                 mov al, [R1Type]
  6499 00003246 3C01                     cmp al, 1
  6500 00003248 0F850300                 jne @@process270
  6501 0000324C E845F5                   call reg16error
  6502                                  
  6503                                  ;-208         if (R1Type == WORD) {
  6504                                  
  6505                                  @@process270:
  6506 0000324F A0[B501]                 mov al, [R1Type]
  6507 00003252 3C02                     cmp al, 2
  6508 00003254 0F851500                 jne @@process271
  6509                                  
  6510                                  ;-209             genCode2(Code1, R1No);
  6511                                  
  6512 00003258 A0[B301]                 mov al, byte [R1No]
  6513 0000325B B400                     mov ah, 0
  6514 0000325D 50                       push ax
  6515 0000325E A0[AF01]                 mov al, byte [Code1]
  6516 00003261 B400                     mov ah, 0
  6517 00003263 50                       push ax
  6518 00003264 E85BF9                   call genCode2
  6519 00003267 83C404                   add  sp, 4
  6520                                  
  6521                                  ;-210             return;   
  6522                                  
  6523 0000326A E99E00                   jmp @@retn
  6524                                  
  6525                                  ;-211         }                
  6526                                  
  6527                                  
  6528                                  ;-212         if (Op == MEM) {
  6529                                  
  6530                                  @@process271:
  6531 0000326D A0[AC01]                 mov al, [Op]
  6532 00003270 3C04                     cmp al, 4
  6533 00003272 0F851B00                 jne @@process272
  6534                                  
  6535                                  ;-213             genCode8(Code2);
  6536                                  
  6537 00003276 A0[B001]                 mov al, byte [Code2]
  6538 00003279 B400                     mov ah, 0
  6539 0000327B 50                       push ax
  6540 0000327C E87AF9                   call genCode8
  6541 0000327F 83C402                   add  sp, 2
  6542                                  
  6543                                  ;-214             writeEA(Code3);
  6544                                  
  6545 00003282 A0[B101]                 mov al, byte [Code3]
  6546 00003285 B400                     mov ah, 0
  6547 00003287 50                       push ax
  6548 00003288 E8E6F9                   call writeEA
  6549 0000328B 83C402                   add  sp, 2
  6550                                  
  6551                                  ;-215             return;   
  6552                                  
  6553 0000328E E97A00                   jmp @@retn
  6554                                  
  6555                                  ;-216         }
  6556                                  
  6557                                  
  6558                                  ;-217       
  6559                                  
  6560                                  
  6561                                  ;-218         syntaxerror();
  6562                                  
  6563                                  @@process272:
  6564 00003291 E84FF5                   call syntaxerror
  6565                                  
  6566                                  ;-219         return;        
  6567                                  
  6568 00003294 E97400                   jmp @@retn
  6569                                  
  6570                                  ;-220     }
  6571                                  
  6572                                  
  6573                                  ;-221     
  6574                                  
  6575                                  
  6576                                  ;-222     if (CodeType == 12) {//int, int3
  6577                                  
  6578                                  @@process261:
  6579 00003297 A0[AE01]                 mov al, [CodeType]
  6580 0000329A 3C0C                     cmp al, 12
  6581 0000329C 0F853E00                 jne @@process273
  6582                                  
  6583                                  ;-223         if (TokeType == DIGIT) {
  6584                                  
  6585 000032A0 A0[AB01]                 mov al, [TokeType]
  6586 000032A3 3C01                     cmp al, 1
  6587 000032A5 0F853500                 jne @@process274
  6588                                  
  6589                                  ;-224             if (SymbolInt == 3) {
  6590                                  
  6591 000032A9 A1[4D00]                 mov ax, [SymbolInt]
  6592 000032AC 83F803                   cmp ax, 3
  6593 000032AF 0F851200                 jne @@process275
  6594                                  
  6595                                  ;-225                 genCode8(Code2);
  6596                                  
  6597 000032B3 A0[B001]                 mov al, byte [Code2]
  6598 000032B6 B400                     mov ah, 0
  6599 000032B8 50                       push ax
  6600 000032B9 E83DF9                   call genCode8
  6601 000032BC 83C402                   add  sp, 2
  6602                                  
  6603                                  ;-226                 return;   
  6604                                  
  6605 000032BF E94900                   jmp @@retn
  6606                                  
  6607                                  ;-227             }
  6608                                  
  6609                                  
  6610                                  ;-228             else {
  6611                                  
  6612 000032C2 E91900                   jmp @@process276
  6613                                  @@process275:
  6614                                  
  6615                                  ;-229                 genCode8(Code1);
  6616                                  
  6617 000032C5 A0[AF01]                 mov al, byte [Code1]
  6618 000032C8 B400                     mov ah, 0
  6619 000032CA 50                       push ax
  6620 000032CB E82BF9                   call genCode8
  6621 000032CE 83C402                   add  sp, 2
  6622                                  
  6623                                  ;-230                 genCode8(SymbolInt);
  6624                                  
  6625 000032D1 FF36[4D00]               push word [SymbolInt]
  6626 000032D5 E821F9                   call genCode8
  6627 000032D8 83C402                   add  sp, 2
  6628                                  
  6629                                  ;-231                 return;   
  6630                                  
  6631 000032DB E92D00                   jmp @@retn
  6632                                  
  6633                                  ;-232             }
  6634                                  
  6635                                  
  6636                                  ;-233         }
  6637                                  
  6638                                  @@process276:
  6639                                  
  6640                                  ;-234     }
  6641                                  
  6642                                  @@process274:
  6643                                  
  6644                                  ;-235        
  6645                                  
  6646                                  
  6647                                  ;-236     if (CodeType==101) {// ORG nn
  6648                                  
  6649                                  @@process273:
  6650 000032DE A0[AE01]                 mov al, [CodeType]
  6651 000032E1 3C65                     cmp al, 101
  6652 000032E3 0F851B00                 jne @@process277
  6653                                  
  6654                                  ;-237         if (TokeType != DIGIT) error1("only digit allowed");
  6655                                  
  6656 000032E7 A0[AB01]                 mov al, [TokeType]
  6657 000032EA 3C01                     cmp al, 1
  6658 000032EC 0F840900                 je  @@process278
  6659 000032F0 68[2033]                 push process_1
  6660 000032F3 E82EF3                   call error1
  6661 000032F6 83C402                   add  sp, 2
  6662                                  
  6663                                  ;-238         PC=SymbolInt;
  6664                                  
  6665                                  @@process278:
  6666 000032F9 A1[4D00]                 mov ax, [SymbolInt]
  6667 000032FC A3[A601]                 mov word [PC], ax
  6668                                  
  6669                                  ;-239         return;
  6670                                  
  6671 000032FF E90900                   jmp @@retn
  6672                                  
  6673                                  ;-240     }
  6674                                  
  6675                                  
  6676                                  ;-241     error1("Command not implemented or syntax error");
  6677                                  
  6678                                  @@process277:
  6679 00003302 68[3333]                 push process_2
  6680 00003305 E81CF3                   call error1
  6681 00003308 83C402                   add  sp, 2
  6682                                  
  6683                                  ;-242 }    
  6684                                  
  6685 0000330B C9                      @@retn: LEAVE
  6686 0000330C C3                       ret
  6687                                  ; ENDP
  6688 0000330D 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  6689 00003316 7420616C6C6F776564-
  6690 0000331F 00                 
  6691 00003320 6F6E6C792064696769-     process_1 db "only digit allowed",0
  6692 00003329 7420616C6C6F776564-
  6693 00003332 00                 
  6694 00003333 436F6D6D616E64206E-     process_2 db "Command not implemented or syntax error",0
  6695 0000333C 6F7420696D706C656D-
  6696 00003345 656E746564206F7220-
  6697 0000334E 73796E746178206572-
  6698 00003357 726F7200           
  6699                                   
  6700                                  ; missing functions: 
  6701                                  ; digit
  6702                                  ; strcpy
  6703                                  ; eqstr
  6704                                  ; strlen
  6705                                  ; eqstr
  6706                                  ; eqstr
  6707                                  ; eqstr
  6708                                  ; eqstr
  6709                                  ; readRL
  6710                                  ; readRL
  6711                                  ; digit
  6712                                  ; digit
  6713                                  ; strcpy
  6714                                  ; toupper
  6715                                  ; strlen
  6716                                  ; strlen
  6717                                  ; eqstr
  6718                                  ; eqstr
  6719                                  ; eqstr
  6720                                  ; eqstr
  6721                                  ; eqstr
  6722                                  ; eqstr
  6723                                  ; eqstr
  6724                                  ; eqstr
  6725                                  ; eqstr
  6726                                  ; eqstr
  6727                                  ; eqstr
  6728                                  ; eqstr
  6729                                  ; eqstr
  6730                                  ; eqstr
  6731                                  ; eqstr
  6732                                  ; eqstr
  6733                                  ; eqstr
  6734                                  ; eqstr
  6735                                  ; eqstr
  6736                                  ; eqstr
  6737                                  ; eqstr
  6738                                  ; eqstr
  6739                                  ; eqstr
  6740                                  ; eqstr
  6741                                  ; eqstr
  6742                                  ; eqstr
  6743                                  ; eqstr
  6744                                  ; eqstr
  6745                                  ; eqstr
  6746                                  ; eqstr
  6747                                  ; writetty
  6748                                  ; writetty
  6749                                  ; fputcR
  6750                                  ; cputs
  6751                                  ; cputs
  6752                                  ; exitR
  6753                                  ; toupper
  6754                                  ; strcpy
  6755                                  ; strcat1
  6756                                  ; strcpy
  6757                                  ; strcat1
  6758                                  ; strcpy
  6759                                  ; strcat1
  6760                                  ; openR
  6761                                  ; cputs
  6762                                  ; cputs
  6763                                  ; exitR
  6764                                  ; creatR
  6765                                  ; cputs
  6766                                  ; cputs
  6767                                  ; exitR
  6768                                  ; creatR
  6769                                  ; cputs
  6770                                  ; cputs
  6771                                  ; exitR
  6772                                  ; fputcR
  6773                                  ; fcloseR
  6774                                  ; fcloseR
  6775                                  ; fcloseR
  6776                                  ; exitR
  6777                                  ; Number of unresolved CALLs :   76
  6778                                  ;use archive file: AR.C
  6779                                  
  6780                                  ;-243 // AR.C Archive
  6781                                  
  6782                                  ;Number of CALLs:    2 : writetty
  6783                                  
  6784                                  writetty:  ; *** PROC ***
  6785 0000335B B40E                     mov  ah, 14
  6786 0000335D BB0000                   mov  bx, 0
  6787 00003360 CD10                     int  16
  6788                                  
  6789                                  ;-244 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6790                                  
  6791 00003362 C3                       ret
  6792                                  ; ENDP
  6793                                  ;Number of CALLs:    8 : cputs
  6794                                  
  6795                                  cputs:  ; *** PROC ***
  6796                                  ;Function : cputs, Number of local variables: 2
  6797                                  ;   # type sign width line used address name   list of local variables
  6798                                  ;  200 ptr sign byte   244 NULL bp+4    s
  6799                                  ;  201 var sign byte   244 NULL bp-2    c;
  6800 00003363 C8020000                 ENTER  2,0
  6801                                  @@cputs279:
  6802 00003367 8B5E04                   mov bx, [bp+4]
  6803 0000336A 8A07                     mov al, [bx]
  6804 0000336C B400                     mov ah, 0
  6805 0000336E 08C0                     or  al, al
  6806 00003370 0F841B00                 je @@cputs280
  6807 00003374 8B5E04                   mov bx, [bp+4]
  6808 00003377 8A07                     mov al, [bx]
  6809 00003379 B400                     mov ah, 0
  6810 0000337B 8846FE                   mov byte [bp-2], al
  6811 0000337E 8A46FE                   mov al, byte [bp-2]
  6812 00003381 B400                     mov ah, 0
  6813 00003383 50                       push ax
  6814 00003384 E8C401                   call putch
  6815 00003387 83C402                   add  sp, 2
  6816 0000338A FF4604                   inc  word [bp+4]
  6817 0000338D EBD8                     jmp @@cputs279
  6818                                  @@cputs280:
  6819                                  
  6820                                  ;-245 int mkneg(int n) { n; __asm {neg ax} }
  6821 0000338F C9                       LEAVE
  6822 00003390 C3                       ret
  6823                                  ; ENDP
  6824                                  ;Number of CALLs:    2 : toupper
  6825                                  
  6826                                  toupper:  ; *** PROC ***
  6827                                  ;Function : toupper, Number of local variables: 1
  6828                                  ;   # type sign width line used address name   list of local variables
  6829                                  ;  200 ptr sign byte   245 NULL bp+4    s;
  6830 00003391 C8000000                 ENTER  0,0
  6831                                  @@toupper281:
  6832 00003395 8B5E04                   mov bx, [bp+4]
  6833 00003398 8A07                     mov al, [bx]
  6834 0000339A B400                     mov ah, 0
  6835 0000339C 08C0                     or  al, al
  6836 0000339E 0F843000                 je @@toupper282
  6837 000033A2 8B5E04                   mov bx, [bp+4]
  6838 000033A5 8A07                     mov al, [bx]
  6839 000033A7 B400                     mov ah, 0
  6840 000033A9 83F861                   cmp ax, 97 ;unsigned : 1
  6841 000033AC 0F8C1D00                 jl  @@toupper283
  6842 000033B0 8B5E04                   mov bx, [bp+4]
  6843 000033B3 8A07                     mov al, [bx]
  6844 000033B5 B400                     mov ah, 0
  6845 000033B7 83F87A                   cmp ax, 122
  6846 000033BA 0F8F0F00                 jg  @@toupper284
  6847 000033BE 8B5E04                   mov bx, [bp+4]
  6848 000033C1 8A07                     mov al, [bx]
  6849 000033C3 B400                     mov ah, 0
  6850 000033C5 83E820                   sub ax, 32
  6851 000033C8 8B5E04                   mov  bx, [bp+4]
  6852 000033CB 8807                     mov  [bx], al
  6853                                  @@toupper284:
  6854                                  @@toupper283:
  6855 000033CD FF4604                   inc  word [bp+4]
  6856 000033D0 EBC3                     jmp @@toupper281
  6857                                  @@toupper282:
  6858                                  
  6859                                  ;-246 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6860                                  
  6861                                  
  6862                                  ;-247 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6863 000033D2 C9                       LEAVE
  6864 000033D3 C3                       ret
  6865                                  ; ENDP
  6866                                  ;Number of CALLs:    3 : strlen
  6867                                  
  6868                                  strlen:  ; *** PROC ***
  6869                                  ;Function : strlen, Number of local variables: 2
  6870                                  ;   # type sign width line used address name   list of local variables
  6871                                  ;  200 ptr sign byte   247 NULL bp+4    s
  6872                                  ;  201 var sign word   247 NULL bp-2    c;
  6873 000033D4 C8020000                 ENTER  2,0
  6874 000033D8 66B800000000             mov eax, 0
  6875 000033DE 8946FE                   mov word [bp-2], ax
  6876                                  @@strlen285:
  6877 000033E1 8B5E04                   mov bx, [bp+4]
  6878 000033E4 8A07                     mov al, [bx]
  6879 000033E6 B400                     mov ah, 0
  6880 000033E8 83F800                   cmp ax, 0
  6881 000033EB 0F840800                 je  @@strlen286
  6882 000033EF FF4604                   inc  word [bp+4]
  6883 000033F2 FF46FE                   inc  word [bp-2]
  6884 000033F5 EBEA                     jmp @@strlen285
  6885                                  @@strlen286:
  6886 000033F7 8B46FE                   mov ax, [bp-2]
  6887 000033FA E90000                   jmp @@retn
  6888                                  
  6889                                  ;-248 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6890                                  
  6891 000033FD C9                      @@retn: LEAVE
  6892 000033FE C3                       ret
  6893                                  ; ENDP
  6894                                  ;Number of CALLs:    5 : strcpy
  6895                                  
  6896                                  strcpy:  ; *** PROC ***
  6897                                  ;Function : strcpy, Number of local variables: 2
  6898                                  ;   # type sign width line used address name   list of local variables
  6899                                  ;  200 ptr sign byte   248 NULL bp+4    s
  6900                                  ;  201 ptr sign byte   248 NULL bp+6    t;
  6901 000033FF C8000000                 ENTER  0,0
  6902                                  @@strcpy287:
  6903 00003403 8B5E06                   mov bx, [bp+6]
  6904 00003406 8A07                     mov al, [bx]
  6905 00003408 B400                     mov ah, 0
  6906 0000340A 8B5E04                   mov  bx, [bp+4]
  6907 0000340D 8807                     mov  [bx], al
  6908 0000340F FF4604                   inc  word [bp+4]
  6909 00003412 FF4606                   inc  word [bp+6]
  6910                                  
  6911                                  ;-249   while (*t!=0); *s=0; return s; }
  6912                                  
  6913 00003415 8B5E06                   mov bx, [bp+6]
  6914 00003418 8A07                     mov al, [bx]
  6915 0000341A B400                     mov ah, 0
  6916 0000341C 83F800                   cmp ax, 0
  6917 0000341F 0F840200                 je  @@strcpy288
  6918 00003423 EBDE                     jmp @@strcpy287
  6919                                  @@strcpy288:
  6920 00003425 66B800000000             mov eax, 0
  6921 0000342B 8B5E04                   mov  bx, [bp+4]
  6922 0000342E 8807                     mov  [bx], al
  6923 00003430 8B4604                   mov ax, [bp+4]
  6924 00003433 E90000                   jmp @@retn
  6925                                  
  6926                                  ;-250 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6927                                  
  6928 00003436 C9                      @@retn: LEAVE
  6929 00003437 C3                       ret
  6930                                  ; ENDP
  6931                                  ;Number of CALLs:    3 : digit
  6932                                  
  6933                                  digit:  ; *** PROC ***
  6934                                  ;Function : digit, Number of local variables: 1
  6935                                  ;   # type sign width line used address name   list of local variables
  6936                                  ;  200 var sign byte   250 NULL bp+4    c;
  6937 00003438 C8000000                 ENTER  0,0
  6938 0000343C 8A4604                   mov al, [bp+4]
  6939 0000343F 3C30                     cmp al, 48
  6940 00003441 0F8D0900                 jge @@digit289
  6941 00003445 66B800000000             mov eax, 0
  6942 0000344B E91B00                   jmp @@retn
  6943                                  @@digit289:
  6944 0000344E 8A4604                   mov al, [bp+4]
  6945 00003451 3C39                     cmp al, 57
  6946 00003453 0F8E0900                 jle @@digit290
  6947 00003457 66B800000000             mov eax, 0
  6948 0000345D E90900                   jmp @@retn
  6949                                  @@digit290:
  6950 00003460 66B801000000             mov eax, 1
  6951 00003466 E90000                   jmp @@retn
  6952                                  
  6953                                  ;-251 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6954                                  
  6955 00003469 C9                      @@retn: LEAVE
  6956 0000346A C3                       ret
  6957                                  ; ENDP
  6958                                  ;Number of CALLs:   35 : eqstr
  6959                                  
  6960                                  eqstr:  ; *** PROC ***
  6961                                  ;Function : eqstr, Number of local variables: 2
  6962                                  ;   # type sign width line used address name   list of local variables
  6963                                  ;  200 ptr sign byte   251 NULL bp+4    p
  6964                                  ;  201 ptr sign byte   251 NULL bp+6    q;
  6965 0000346B C8000000                 ENTER  0,0
  6966                                  @@eqstr291:
  6967 0000346F 8B5E04                   mov bx, [bp+4]
  6968 00003472 8A07                     mov al, [bx]
  6969 00003474 B400                     mov ah, 0
  6970 00003476 08C0                     or  al, al
  6971 00003478 0F842300                 je @@eqstr292
  6972                                  
  6973                                  ;-252     if (*p != *q) return 0; p++; q++; }
  6974                                  
  6975 0000347C 8B5E04                   mov bx, [bp+4]
  6976 0000347F 8A07                     mov al, [bx]
  6977 00003481 B400                     mov ah, 0
  6978 00003483 8B5E06                   mov bx, [bp+6]
  6979 00003486 3A07                     cmp al, [bx]
  6980 00003488 B400                     mov ah, 0
  6981 0000348A 0F840900                 je  @@eqstr293
  6982 0000348E 66B800000000             mov eax, 0
  6983 00003494 E92700                   jmp @@retn
  6984                                  @@eqstr293:
  6985 00003497 FF4604                   inc  word [bp+4]
  6986 0000349A FF4606                   inc  word [bp+6]
  6987                                  
  6988                                  ;-253     if(*q) return 0; return 1; }
  6989                                  
  6990 0000349D EBD0                     jmp @@eqstr291
  6991                                  @@eqstr292:
  6992 0000349F 8B5E06                   mov bx, [bp+6]
  6993 000034A2 8A07                     mov al, [bx]
  6994 000034A4 B400                     mov ah, 0
  6995 000034A6 08C0                     or  al, al
  6996 000034A8 0F840900                 je @@eqstr294
  6997 000034AC 66B800000000             mov eax, 0
  6998 000034B2 E90900                   jmp @@retn
  6999                                  @@eqstr294:
  7000 000034B5 66B801000000             mov eax, 1
  7001 000034BB E90000                   jmp @@retn
  7002                                  
  7003                                  ;-254 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7004                                  
  7005 000034BE C9                      @@retn: LEAVE
  7006 000034BF C3                       ret
  7007                                  ; ENDP
  7008                                  ;Number of CALLs:    3 : strcat1
  7009                                  
  7010                                  strcat1:  ; *** PROC ***
  7011                                  ;Function : strcat1, Number of local variables: 2
  7012                                  ;   # type sign width line used address name   list of local variables
  7013                                  ;  200 ptr sign byte   254 NULL bp+4    s
  7014                                  ;  201 ptr sign byte   254 NULL bp+6    t;
  7015 000034C0 C8000000                 ENTER  0,0
  7016                                  @@strcat1295:
  7017 000034C4 8B5E04                   mov bx, [bp+4]
  7018 000034C7 8A07                     mov al, [bx]
  7019 000034C9 B400                     mov ah, 0
  7020 000034CB 83F800                   cmp ax, 0
  7021 000034CE 0F840500                 je  @@strcat1296
  7022 000034D2 FF4604                   inc  word [bp+4]
  7023 000034D5 EBED                     jmp @@strcat1295
  7024                                  @@strcat1296:
  7025 000034D7 FF7606                   push word [bp+6]
  7026 000034DA FF7604                   push word [bp+4]
  7027 000034DD E81FFF                   call strcpy
  7028 000034E0 83C404                   add  sp, 4
  7029                                  
  7030                                  ;-255 int basename(char *s) { char *p; p=0;
  7031 000034E3 C9                       LEAVE
  7032 000034E4 C3                       ret
  7033                                  ; ENDP
  7034                                  ;Number of CALLs:    1 : openR
  7035                                  
  7036                                  openR:  ; *** PROC ***
  7037                                  ;Function : openR, Number of local variables: 1
  7038                                  ;   # type sign width line used address name   list of local variables
  7039                                  ;  200 ptr sign byte   255 NULL bp+4    s;
  7040 000034E5 C8000000                 ENTER  0,0
  7041 000034E9 8B5604                   mov  dx, [bp+4]
  7042 000034EC B8023D                   mov  ax, 15618
  7043 000034EF E87200                   call DosInt
  7044                                  
  7045                                  ;-256 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7046 000034F2 C9                       LEAVE
  7047 000034F3 C3                       ret
  7048                                  ; ENDP
  7049                                  ;Number of CALLs:    2 : creatR
  7050                                  
  7051                                  creatR:  ; *** PROC ***
  7052                                  ;Function : creatR, Number of local variables: 1
  7053                                  ;   # type sign width line used address name   list of local variables
  7054                                  ;  200 ptr sign byte   256 NULL bp+4    s;
  7055 000034F4 C8000000                 ENTER  0,0
  7056 000034F8 8B5604                   mov  dx, [bp+4]
  7057 000034FB B90000                   mov  cx, 0
  7058 000034FE B8003C                   mov  ax, 15360
  7059 00003501 E86000                   call DosInt
  7060                                  
  7061                                  ;-257 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7062 00003504 C9                       LEAVE
  7063 00003505 C3                       ret
  7064                                  ; ENDP
  7065                                  ;Number of CALLs:    2 : readRL
  7066                                  
  7067                                  readRL:  ; *** PROC ***
  7068                                  ;Function : readRL, Number of local variables: 3
  7069                                  ;   # type sign width line used address name   list of local variables
  7070                                  ;  200 ptr sign byte   257 NULL bp+4    s
  7071                                  ;  201 var sign word   257 NULL bp+6    fd
  7072                                  ;  202 var sign word   257 NULL bp+8    len;
  7073 00003506 C8000000                 ENTER  0,0
  7074 0000350A 8B5604                   mov  dx, [bp+4]
  7075 0000350D 8B4E08                   mov  cx, [bp+8]
  7076 00003510 8B5E06                   mov  bx, [bp+6]
  7077 00003513 B8003F                   mov  ax, 16128
  7078 00003516 E84B00                   call DosInt
  7079                                  
  7080                                  ;-258 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7081 00003519 C9                       LEAVE
  7082 0000351A C3                       ret
  7083                                  ; ENDP
  7084                                  ;Number of CALLs:    2 : fputcR
  7085                                  
  7086                                  fputcR:  ; *** PROC ***
  7087                                  ;Function : fputcR, Number of local variables: 2
  7088                                  ;   # type sign width line used address name   list of local variables
  7089                                  ;  200 ptr sign byte   258 NULL bp+4    n
  7090                                  ;  201 var sign word   258 NULL bp+6    fd;
  7091 0000351B C8000000                 ENTER  0,0
  7092 0000351F 8D5604                  lea dx, [bp+4]
  7093                                  
  7094                                  ;-259   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7095                                  
  7096 00003522 B90100                   mov  cx, 1
  7097 00003525 8B5E06                   mov  bx, [bp+6]
  7098 00003528 B80040                   mov  ax, 16384
  7099 0000352B E83600                   call DosInt
  7100                                  
  7101                                  ;-260 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7102 0000352E C9                       LEAVE
  7103 0000352F C3                       ret
  7104                                  ; ENDP
  7105                                  ;Number of CALLs:    3 : fcloseR
  7106                                  
  7107                                  fcloseR:  ; *** PROC ***
  7108                                  ;Function : fcloseR, Number of local variables: 1
  7109                                  ;   # type sign width line used address name   list of local variables
  7110                                  ;  200 var sign word   260 NULL bp+4    fd;
  7111 00003530 C8000000                 ENTER  0,0
  7112 00003534 8B5E04                   mov  bx, [bp+4]
  7113 00003537 B8003E                   mov  ax, 15872
  7114 0000353A CD21                     int  33
  7115                                  
  7116                                  ;-261 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7117 0000353C C9                       LEAVE
  7118 0000353D C3                       ret
  7119                                  ; ENDP
  7120                                  ;Number of CALLs:    5 : exitR
  7121                                  
  7122                                  exitR:  ; *** PROC ***
  7123                                  ;Function : exitR, Number of local variables: 1
  7124                                  ;   # type sign width line used address name   list of local variables
  7125                                  ;  200 var sign byte   261 NULL bp+4    c;
  7126 0000353E C8000000                 ENTER  0,0
  7127 00003542 B44C                     mov  ah, 76
  7128 00003544 8A4604                   mov  al, [bp+4]
  7129 00003547 CD21                     int  33
  7130                                  
  7131                                  ;-262 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7132 00003549 C9                       LEAVE
  7133 0000354A C3                       ret
  7134                                  ; ENDP
  7135                                  ;End of archive file. 
  7136                                   
  7137                                  ; missing functions: 
  7138                                  ; putch
  7139                                  ; DosInt
  7140                                  ; DosInt
  7141                                  ; DosInt
  7142                                  ; DosInt
  7143                                  ; Number of unresolved CALLs :    5
  7144                                  ;use archive file: AR.C
  7145                                  
  7146                                  ;-263 // AR.C Archive
  7147                                  
  7148                                  ;Number of CALLs:    1 : putch
  7149                                  
  7150                                  putch:  ; *** PROC ***
  7151                                  ;Function : putch, Number of local variables: 1
  7152                                  ;   # type sign width line used address name   list of local variables
  7153                                  ;  200 var sign byte   263 NULL bp+4    c;
  7154 0000354B C8000000                 ENTER  0,0
  7155 0000354F 807E040A                cmp byte [bp+4], 10
  7156 00003553 0F850500                 jne @@putch297
  7157 00003557 B00D                     mov  al, 13
  7158 00003559 E8FFFD                   call writetty
  7159                                  @@putch297:
  7160 0000355C 8A4604                   mov  al, [bp+4]
  7161 0000355F E8F9FD                   call writetty
  7162                                  
  7163                                  ;-264 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7164 00003562 C9                       LEAVE
  7165 00003563 C3                       ret
  7166                                  ; ENDP
  7167                                  ;Number of CALLs:    4 : DosInt
  7168                                  
  7169                                  DosInt:  ; *** PROC ***
  7170 00003564 CD21                     int  33
  7171 00003566 7304                     jae short @@DosInt298
  7172 00003568 FF06[9F01]               inc  word [DOS_ERR]
  7173                                  @@DosInt298:
  7174                                  
  7175                                  ;-265 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7176                                  
  7177 0000356C C3                       ret
  7178                                  ; ENDP
  7179                                  ;End of archive file. 
  7180                                   
  7181                                  ; missing functions:  All FUNCTIONs in place
  7182 0000356D E80000                  LastFunctionByt:db 0E8h, 0, 0
  7183 00003570 58                      pop ax
  7184 00003571 C3                      ret
  7185                                   
  7186                                  ;   # type sign width line used  address name   list of global variables
  7187                                  
  7188                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7189                                  ;    2 var sign byte     1    3        0 LIST
  7190                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7191                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  7192                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7193                                  ;    6 var unsg word     5   14        0 SymbolInt
  7194                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7195                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7196                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7197                                  ;   10 arr sign byte     9    5        0 namein[67]
  7198                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7199                                  ;   12 arr sign byte    11    5        0 namebin[67]
  7200                                  ;   13 var sign word    12    4        0 asm_fd
  7201                                  ;   14 var sign word    13    3        0 lst_fd
  7202                                  ;   15 var sign word    14    3        0 bin_fd
  7203                                  ;   16 var sign word    15    6        0 DOS_ERR
  7204                                  ;   17 var sign word    16    4        0 ErrorCount
  7205                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7206                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7207                                  ;   20 var unsg word    20    5        0 PC
  7208                                  ;   21 var unsg word    21    2        0 PCStart
  7209                                  ;   22 var sign byte    22    3        0 isLabel
  7210                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7211                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7212                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7213                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7214                                  ;   27 var sign byte    27   22        0 TokeType
  7215                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7216                                  ;   29 def unsg byte    29    -        0 WORD=2
  7217                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7218                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7219                                  ;   32 def unsg byte    32    -        0 IMM=1
  7220                                  ;   33 def unsg byte    33    -        0 REG=2
  7221                                  ;   34 def unsg byte    34    -        0 ADR=3
  7222                                  ;   35 def unsg byte    35    -        0 MEM=4
  7223                                  ;   36 var sign byte    36   24        0 Op
  7224                                  ;   37 var sign byte    37   29        0 Op2
  7225                                  ;   38 var sign byte    38   17        0 CodeType
  7226                                  ;   39 var sign byte    39   13        0 Code1
  7227                                  ;   40 var sign byte    40    8        0 Code2
  7228                                  ;   41 var sign byte    41    3        0 Code3
  7229                                  ;   42 var sign byte    42   18        0 R2No
  7230                                  ;   43 var sign byte    43   16        0 R1No
  7231                                  ;   44 var sign byte    44   17        0 R2Type
  7232                                  ;   45 var sign byte    45   14        0 R1Type
  7233                                  ;   46 var sign byte    46   13        0 OpSize
  7234                                  ;   47 var sign byte    47    8        0 wflag
  7235                                  ;   48 var sign byte    48    3        0 dflag
  7236                                  ;   49 var sign byte    49    8        0 sflag
  7237                                  ;   50 var sign byte    50   15        0 rm
  7238                                  ;   51 var sign byte    51    5        0 isDirect
  7239                                  ;   52 var sign word    52   17        0 disp
  7240                                  ;   53 var unsg word    53   10        0 imme
  7241                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7242                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7243                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7244                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7245                                  ;   58 var sign byte    59    2        0 PrintR
  7246                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7247                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7248                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7249                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7250                                  ;   63 arr unsg word    65    3        0 LabelAddr[100]
  7251                                  ;   64 var sign word    66    4        0 LabelMaxIx
  7252                                  ;   65 var sign word    67    4        0 LabelIx
  7253                                  ;   66 def unsg byte    69    -        0 FILEBINMAX=2000
  7254                                  ;   67 arr sign byte    70    2        0 FileBin[2000]
  7255                                  ;   68 var unsg word    71    5        0 BinLen
  7256                                  ;   69 ptr sign byte    73    1        0 arglen
  7257                                  ;   70 ptr sign byte    74    4        0 argv
  7258                                  ;   71 var sign byte     1    1        0 I_START
  7259                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  7260                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  7261                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  7262                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  7263                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  7264                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  7265                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  7266                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  7267                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  7268                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  7269                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  7270                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  7271                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  7272                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  7273                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  7274                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  7275                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  7276                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  7277                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  7278                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  7279                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  7280                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  7281                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  7282                                  ;   95 arr sign byte    27 NULL        0 I_INT3[8]
  7283                                  ;   96 arr sign byte    28 NULL        0 I_INTO[8]
  7284                                  ;   97 arr sign byte    29 NULL        0 I_IRET[8]
  7285                                  ;   98 arr sign byte    30 NULL        0 I_XLAT[8]
  7286                                  ;   99 arr sign byte    31 NULL        0 I_LOCK[8]
  7287                                  ;  100 arr sign byte    32 NULL        0 I_REPNE[9]
  7288                                  ;  101 arr sign byte    33 NULL        0 I_REPNZ[9]
  7289                                  ;  102 arr sign byte    34 NULL        0 I_REPE[8]
  7290                                  ;  103 arr sign byte    35 NULL        0 I_REPZ[8]
  7291                                  ;  104 arr sign byte    36 NULL        0 I_HLT[7]
  7292                                  ;  105 arr sign byte    37 NULL        0 I_CLC[7]
  7293                                  ;  106 arr sign byte    38 NULL        0 I_STC[7]
  7294                                  ;  107 arr sign byte    39 NULL        0 I_CLI[7]
  7295                                  ;  108 arr sign byte    40 NULL        0 I_STI[7]
  7296                                  ;  109 arr sign byte    41 NULL        0 I_CLD[7]
  7297                                  ;  110 arr sign byte    42 NULL        0 I_STD[7]
  7298                                  ;  111 arr sign byte    44 NULL        0 I_INC[9]
  7299                                  ;  112 arr sign byte    45 NULL        0 I_DEC[9]
  7300                                  ;  113 arr sign byte    46 NULL        0 I_NOT[8]
  7301                                  ;  114 arr sign byte    47 NULL        0 I_NEG[8]
  7302                                  ;  115 arr sign byte    48 NULL        0 I_MUL[8]
  7303                                  ;  116 arr sign byte    49 NULL        0 I_IMUL[9]
  7304                                  ;  117 arr sign byte    50 NULL        0 I_DIV[8]
  7305                                  ;  118 arr sign byte    51 NULL        0 I_IDIV[9]
  7306                                  ;  119 arr sign byte    53 NULL        0 I_LES[7]
  7307                                  ;  120 arr sign byte    54 NULL        0 I_LDS[7]
  7308                                  ;  121 arr sign byte    55 NULL        0 I_LEA[7]
  7309                                  ;  122 arr sign byte    56 NULL        0 I_LSS[8]
  7310                                  ;  123 arr sign byte    57 NULL        0 I_LFS[8]
  7311                                  ;  124 arr sign byte    58 NULL        0 I_LGS[8]
  7312                                  ;  125 arr sign byte    60 NULL        0 I_ADD[7]
  7313                                  ;  126 arr sign byte    61 NULL        0 I_OR[6]
  7314                                  ;  127 arr sign byte    62 NULL        0 I_ADC[7]
  7315                                  ;  128 arr sign byte    63 NULL        0 I_SBB[7]
  7316                                  ;  129 arr sign byte    64 NULL        0 I_AND[7]
  7317                                  ;  130 arr sign byte    65 NULL        0 I_SUB[7]
  7318                                  ;  131 arr sign byte    66 NULL        0 I_XOR[7]
  7319                                  ;  132 arr sign byte    67 NULL        0 I_CMP[7]
  7320                                  ;  133 arr sign byte    68 NULL        0 I_TEST[11]
  7321                                  ;  134 arr sign byte    70 NULL        0 I_MOV[6]
  7322                                  ;  135 arr sign byte    71 NULL        0 I_MOVSX[9]
  7323                                  ;  136 arr sign byte    72 NULL        0 I_MOVZX[9]
  7324                                  ;  137 arr sign byte    74 NULL        0 I_JO[6]
  7325                                  ;  138 arr sign byte    75 NULL        0 I_JNO[7]
  7326                                  ;  139 arr sign byte    76 NULL        0 I_JB[6]
  7327                                  ;  140 arr sign byte    77 NULL        0 I_JC[6]
  7328                                  ;  141 arr sign byte    78 NULL        0 I_JNB[7]
  7329                                  ;  142 arr sign byte    79 NULL        0 I_JAE[7]
  7330                                  ;  143 arr sign byte    80 NULL        0 I_JNC[7]
  7331                                  ;  144 arr sign byte    81 NULL        0 I_JE[6]
  7332                                  ;  145 arr sign byte    82 NULL        0 I_JZ[6]
  7333                                  ;  146 arr sign byte    83 NULL        0 I_JNE[7]
  7334                                  ;  147 arr sign byte    84 NULL        0 I_JNZ[7]
  7335                                  ;  148 arr sign byte    85 NULL        0 I_JBE[7]
  7336                                  ;  149 arr sign byte    86 NULL        0 I_JNA[7]
  7337                                  ;  150 arr sign byte    87 NULL        0 I_JA[6]
  7338                                  ;  151 arr sign byte    88 NULL        0 I_JS[6]
  7339                                  ;  152 arr sign byte    89 NULL        0 I_JNS[7]
  7340                                  ;  153 arr sign byte    90 NULL        0 I_JP[6]
  7341                                  ;  154 arr sign byte    91 NULL        0 I_JPE[7]
  7342                                  ;  155 arr sign byte    92 NULL        0 I_JNP[7]
  7343                                  ;  156 arr sign byte    93 NULL        0 I_JPO[7]
  7344                                  ;  157 arr sign byte    94 NULL        0 I_JL[6]
  7345                                  ;  158 arr sign byte    95 NULL        0 I_JNL[7]
  7346                                  ;  159 arr sign byte    96 NULL        0 I_JGE[7]
  7347                                  ;  160 arr sign byte    97 NULL        0 I_JLE[7]
  7348                                  ;  161 arr sign byte    98 NULL        0 I_JNG[7]
  7349                                  ;  162 arr sign byte    99 NULL        0 I_JG[6]
  7350                                  ;  163 arr sign byte   101 NULL        0 I_JMP[8]
  7351                                  ;  164 arr sign byte   102 NULL        0 I_CALL[9]
  7352                                  ;  165 arr sign byte   104 NULL        0 I_RET[8]
  7353                                  ;  166 arr sign byte   105 NULL        0 I_RETF[9]
  7354                                  ;  167 arr sign byte   107 NULL        0 I_PUSH[11]
  7355                                  ;  168 arr sign byte   108 NULL        0 I_POP[10]
  7356                                  ;  169 arr sign byte   110 NULL        0 I_ROL[7]
  7357                                  ;  170 arr sign byte   111 NULL        0 I_ROR[7]
  7358                                  ;  171 arr sign byte   112 NULL        0 I_RCL[7]
  7359                                  ;  172 arr sign byte   113 NULL        0 I_RCR[7]
  7360                                  ;  173 arr sign byte   114 NULL        0 I_SHL[7]
  7361                                  ;  174 arr sign byte   115 NULL        0 I_SAL[7]
  7362                                  ;  175 arr sign byte   116 NULL        0 I_SHR[7]
  7363                                  ;  176 arr sign byte   117 NULL        0 I_SAR[7]
  7364                                  ;  177 arr sign byte   119 NULL        0 I_INT[8]
  7365                                  ;  178 arr sign byte   130 NULL        0 I_XCHG[9]
  7366                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNZ[10]
  7367                                  ;  180 arr sign byte   133 NULL        0 I_LOOPNE[10]
  7368                                  ;  181 arr sign byte   134 NULL        0 I_LOOPZ[9]
  7369                                  ;  182 arr sign byte   135 NULL        0 I_LOOPE[9]
  7370                                  ;  183 arr sign byte   136 NULL        0 I_LOOP[8]
  7371                                  ;  184 arr sign byte   137 NULL        0 I_JCXZ[8]
  7372                                  ;  185 arr sign byte   138 NULL        0 I_JECXZ[9]
  7373                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[9]
  7374                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  7375                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  7376                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  7377                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  7378                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  7379                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  7380                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  7381                                  ;  194 var sign byte   153 NULL        0 I_END
  7382                                  
  7383                                  
  7384                                  ;   # Calls Line Width  Name   list of functions
  7385                                  
  7386                                  ;    0    2    1 word   ChangeDirection
  7387                                  ;    1    2    9 word   checkOpL
  7388                                  ;    2    3   18 word   check2Ops
  7389                                  ;    3    1   27 word   get2Ops
  7390                                  ;    4    3   33 word   getOpL
  7391                                  ;    5    2   41 word   getOpR
  7392                                  ;    6    2   51 word   getOp1
  7393                                  ;    7    1   67 word   getMEM
  7394                                  ;    8    1   90 word   getIndReg1
  7395                                  ;    9    1   98 word   getIndReg2
  7396                                  ;   10    2  108 word   setwflag
  7397                                  ;   11    2  119 word   setsflag
  7398                                  ;   12    1    1 word   parse
  7399                                  ;   13   14   27 word   getTokeType
  7400                                  ;   14    2   36 word   storeLabel
  7401                                  ;   15    2   46 word   searchLabel
  7402                                  ;   16    1   57 word   getVariable
  7403                                  ;   17    2   86 word   lookCode
  7404                                  ;   18    1  101 word   getCodeSize
  7405                                  ;   19    8  108 word   isToken
  7406                                  ;   20    1  113 word   need
  7407                                  ;   21    1  123 word   skipRest
  7408                                  ;   22    1    1 word   getLine
  7409                                  ;   23    1   17 word   ifEOL
  7410                                  ;   24    3   24 word   skipBlank
  7411                                  ;   25    2   29 word   letterE
  7412                                  ;   26    1   39 word   alnumE
  7413                                  ;   27    1   44 word   getDigit
  7414                                  ;   28    1   56 word   getName
  7415                                  ;   29    1   75 word   testReg
  7416                                  ;   30    1    1 word   printLine
  7417                                  ;   31    7   22 word   prc
  7418                                  ;   32    1   34 word   prscomment
  7419                                  ;   33   23   42 word   prs
  7420                                  ;   34    3   64 word   printhex8a
  7421                                  ;   35    2   69 word   printhex4
  7422                                  ;   36    1   74 word   printhex16
  7423                                  ;   37    3   79 word   printIntU
  7424                                  ;   38   25   90 word   error1
  7425                                  ;   39   12   98 word   errorexit
  7426                                  ;   40 NULL  102 word   allowederror
  7427                                  ;   41    3  103 word   addrerror
  7428                                  ;   42    1  104 word   immeerror
  7429                                  ;   43    2  105 word   implerror
  7430                                  ;   44    4  106 word   indexerror
  7431                                  ;   45    3  107 word   invaloperror
  7432                                  ;   46    1  108 word   numbererror
  7433                                  ;   47    1  109 word   regmemerror
  7434                                  ;   48    3  110 word   reg16error
  7435                                  ;   49    1  111 word   segregerror
  7436                                  ;   50    4  112 word   syntaxerror
  7437                                  ;   51 NULL  114 word   addrexit
  7438                                  ;   52 NULL  115 word   internexit
  7439                                  ;   53 NULL    1 word   main
  7440                                  ;   54    1    8 word   getarg
  7441                                  ;   55    1   42 word   epilog
  7442                                  ;   56    2   60 word   end1
  7443                                  ;   57    1    2 word   getCodes
  7444                                  ;   58    1    7 word   gen66h
  7445                                  ;   59    5    9 word   genCode2
  7446                                  ;   60   10   13 word   genCodeW
  7447                                  ;   61   23   17 word   genCode8
  7448                                  ;   62    7   28 word   genCode16
  7449                                  ;   63   10   32 word   writeEA
  7450                                  ;   64    4   74 word   genImmediate
  7451                                  ;   65    1   11 word   process
  7452                                  ;   66    4  243 word   writetty
  7453                                  ;   67    8  244 word   cputs
  7454                                  ;   68    2  245 word   toupper
  7455                                  ;   69    3  247 word   strlen
  7456                                  ;   70    6  248 word   strcpy
  7457                                  ;   71    3  250 word   digit
  7458                                  ;   72   35  251 word   eqstr
  7459                                  ;   73    3  254 word   strcat1
  7460                                  ;   74    1  255 word   openR
  7461                                  ;   75    2  256 word   creatR
  7462                                  ;   76    2  257 word   readRL
  7463                                  ;   77    2  258 word   fputcR
  7464                                  ;   78    3  260 word   fcloseR
  7465                                  ;   79    5  261 word   exitR
  7466                                  ;   80    1  263 word   putch
  7467                                  ;   81    4  264 word   DosInt
  7468                                  ;   82 NULL  265 word   LastFunctionByt
  7469                                  
  7470                                  ;    #  addr name   list of CALLs
  7471                                  
  7472                                  ;    0  1367 implerror
  7473                                  ;    1  1377 segregerror
  7474                                  ;    2  1389 setwflag
  7475                                  ;    3  1398 error1
  7476                                  ;    4  1405 error1
  7477                                  ;    5  1422 get2Ops
  7478                                  ;    6  1430 addrerror
  7479                                  ;    7  1440 invaloperror
  7480                                  ;    8  1453 immeerror
  7481                                  ;    9  1463 addrerror
  7482                                  ;   10  1473 invaloperror
  7483                                  ;   11  1486 setwflag
  7484                                  ;   12  1503 getOpL
  7485                                  ;   13  1510 need
  7486                                  ;   14  1515 getOpR
  7487                                  ;   15  1529 getOpR
  7488                                  ;   16  1543 getOp1
  7489                                  ;   17  1550 isToken
  7490                                  ;   18  1558 getMEM
  7491                                  ;   19  1565 invaloperror
  7492                                  ;   20  1578 error1
  7493                                  ;   21  1592 testReg
  7494                                  ;   22  1600 searchLabel
  7495                                  ;   23  1612 error1
  7496                                  ;   24  1628 getTokeType
  7497                                  ;   25  1640 getOp1
  7498                                  ;   26  1647 syntaxerror
  7499                                  ;   27  1659 getIndReg2
  7500                                  ;   28  1670 getIndReg1
  7501                                  ;   29  1681 isToken
  7502                                  ;   30  1689 getTokeType
  7503                                  ;   31  1701 numbererror
  7504                                  ;   32  1713 isToken
  7505                                  ;   33  1721 isToken
  7506                                  ;   34  1729 errorexit
  7507                                  ;   35  1750 indexerror
  7508                                  ;   36  1761 indexerror
  7509                                  ;   37  1785 indexerror
  7510                                  ;   38  1796 indexerror
  7511                                  ;   39  1816 gen66h
  7512                                  ;   40  1835 error1
  7513                                  ;   41  1848 getLine
  7514                                  ;   42  1856 getTokeType
  7515                                  ;   43  1868 storeLabel
  7516                                  ;   44  1879 getTokeType
  7517                                  ;   45  1891 lookCode
  7518                                  ;   46  1900 process
  7519                                  ;   47  1908 getVariable
  7520                                  ;   48  1920 skipRest
  7521                                  ;   49  1929 error1
  7522                                  ;   50  1936 error1
  7523                                  ;   51  1943 printLine
  7524                                  ;   52  1967 skipBlank
  7525                                  ;   53  1977 digit
  7526                                  ;   54  1983 getDigit
  7527                                  ;   55  1992 letterE
  7528                                  ;   56  2000 getName
  7529                                  ;   57  2021 searchLabel
  7530                                  ;   58  2033 error1
  7531                                  ;   59  2040 strcpy
  7532                                  ;   60  2047 errorexit
  7533                                  ;   61  2057 errorexit
  7534                                  ;   62  2087 eqstr
  7535                                  ;   63  2093 strlen
  7536                                  ;   64  2114 storeLabel
  7537                                  ;   65  2125 getTokeType
  7538                                  ;   66  2137 lookCode
  7539                                  ;   67  2146 errorexit
  7540                                  ;   68  2156 errorexit
  7541                                  ;   69  2166 getTokeType
  7542                                  ;   70  2178 genCode8
  7543                                  ;   71  2187 skipBlank
  7544                                  ;   72  2197 isToken
  7545                                  ;   73  2205 genCode8
  7546                                  ;   74  2214 isToken
  7547                                  ;   75  2222 getTokeType
  7548                                  ;   76  2234 genCode16
  7549                                  ;   77  2244 isToken
  7550                                  ;   78  2252 errorexit
  7551                                  ;   79  2271 eqstr
  7552                                  ;   80  2289 eqstr
  7553                                  ;   81  2295 getTokeType
  7554                                  ;   82  2307 eqstr
  7555                                  ;   83  2313 getTokeType
  7556                                  ;   84  2325 eqstr
  7557                                  ;   85  2331 getTokeType
  7558                                  ;   86  2353 skipBlank
  7559                                  ;   87  2370 isToken
  7560                                  ;   88  2378 getTokeType
  7561                                  ;   89  2390 error1
  7562                                  ;   90  2397 prs
  7563                                  ;   91  2401 prc
  7564                                  ;   92  2414 getTokeType
  7565                                  ;   93  2426 error1
  7566                                  ;   94  2443 readRL
  7567                                  ;   95  2450 errorexit
  7568                                  ;   96  2460 errorexit
  7569                                  ;   97  2470 ifEOL
  7570                                  ;   98  2484 readRL
  7571                                  ;   99  2520 digit
  7572                                  ;  100  2526 letterE
  7573                                  ;  101  2553 digit
  7574                                  ;  102  2573 alnumE
  7575                                  ;  103  2580 errorexit
  7576                                  ;  104  2590 strcpy
  7577                                  ;  105  2597 toupper
  7578                                  ;  106  2613 strlen
  7579                                  ;  107  2620 strlen
  7580                                  ;  108  2627 eqstr
  7581                                  ;  109  2633 eqstr
  7582                                  ;  110  2639 eqstr
  7583                                  ;  111  2645 eqstr
  7584                                  ;  112  2651 eqstr
  7585                                  ;  113  2657 eqstr
  7586                                  ;  114  2663 eqstr
  7587                                  ;  115  2669 eqstr
  7588                                  ;  116  2675 eqstr
  7589                                  ;  117  2681 eqstr
  7590                                  ;  118  2687 eqstr
  7591                                  ;  119  2693 eqstr
  7592                                  ;  120  2699 eqstr
  7593                                  ;  121  2705 eqstr
  7594                                  ;  122  2711 eqstr
  7595                                  ;  123  2717 eqstr
  7596                                  ;  124  2723 eqstr
  7597                                  ;  125  2729 eqstr
  7598                                  ;  126  2735 eqstr
  7599                                  ;  127  2741 eqstr
  7600                                  ;  128  2747 eqstr
  7601                                  ;  129  2753 eqstr
  7602                                  ;  130  2759 eqstr
  7603                                  ;  131  2765 eqstr
  7604                                  ;  132  2771 eqstr
  7605                                  ;  133  2777 eqstr
  7606                                  ;  134  2783 eqstr
  7607                                  ;  135  2789 eqstr
  7608                                  ;  136  2795 eqstr
  7609                                  ;  137  2801 eqstr
  7610                                  ;  138  2821 prs
  7611                                  ;  139  2825 printhex16
  7612                                  ;  140  2836 prs
  7613                                  ;  141  2840 prc
  7614                                  ;  142  2844 printhex8a
  7615                                  ;  143  2855 prc
  7616                                  ;  144  2859 prs
  7617                                  ;  145  2863 prscomment
  7618                                  ;  146  2880 writetty
  7619                                  ;  147  2889 writetty
  7620                                  ;  148  2898 fputcR
  7621                                  ;  149  2920 prc
  7622                                  ;  150  2936 prc
  7623                                  ;  151  2957 printhex4
  7624                                  ;  152  2967 printhex4
  7625                                  ;  153  2989 prc
  7626                                  ;  154  3011 printhex8a
  7627                                  ;  155  3022 printhex8a
  7628                                  ;  156  3047 printIntU
  7629                                  ;  157  3057 prc
  7630                                  ;  158  3070 prs
  7631                                  ;  159  3074 prs
  7632                                  ;  160  3078 prs
  7633                                  ;  161  3082 prs
  7634                                  ;  162  3098 error1
  7635                                  ;  163  3105 end1
  7636                                  ;  164  3123 error1
  7637                                  ;  165  3140 error1
  7638                                  ;  166  3157 error1
  7639                                  ;  167  3174 error1
  7640                                  ;  168  3192 error1
  7641                                  ;  169  3212 error1
  7642                                  ;  170  3231 error1
  7643                                  ;  171  3250 error1
  7644                                  ;  172  3268 error1
  7645                                  ;  173  3287 error1
  7646                                  ;  174  3306 error1
  7647                                  ;  175  3322 errorexit
  7648                                  ;  176  3343 errorexit
  7649                                  ;  177  3358 getarg
  7650                                  ;  178  3365 parse
  7651                                  ;  179  3371 epilog
  7652                                  ;  180  3378 end1
  7653                                  ;  181  3402 cputs
  7654                                  ;  182  3408 cputs
  7655                                  ;  183  3414 exitR
  7656                                  ;  184  3420 toupper
  7657                                  ;  185  3428 strcpy
  7658                                  ;  186  3435 strcat1
  7659                                  ;  187  3443 strcpy
  7660                                  ;  188  3450 strcat1
  7661                                  ;  189  3458 strcpy
  7662                                  ;  190  3465 strcat1
  7663                                  ;  191  3473 openR
  7664                                  ;  192  3479 cputs
  7665                                  ;  193  3485 cputs
  7666                                  ;  194  3491 exitR
  7667                                  ;  195  3497 creatR
  7668                                  ;  196  3504 cputs
  7669                                  ;  197  3510 cputs
  7670                                  ;  198  3516 exitR
  7671                                  ;  199  3522 creatR
  7672                                  ;  200  3529 cputs
  7673                                  ;  201  3535 cputs
  7674                                  ;  202  3541 exitR
  7675                                  ;  203  3547 prs
  7676                                  ;  204  3551 prs
  7677                                  ;  205  3555 prs
  7678                                  ;  206  3559 prs
  7679                                  ;  207  3563 prs
  7680                                  ;  208  3567 prs
  7681                                  ;  209  3571 prs
  7682                                  ;  210  3575 prs
  7683                                  ;  211  3579 prs
  7684                                  ;  212  3596 prs
  7685                                  ;  213  3600 printIntU
  7686                                  ;  214  3610 prs
  7687                                  ;  215  3614 prs
  7688                                  ;  216  3618 prs
  7689                                  ;  217  3622 prs
  7690                                  ;  218  3626 printIntU
  7691                                  ;  219  3636 prs
  7692                                  ;  220  3640 fputcR
  7693                                  ;  221  3654 fcloseR
  7694                                  ;  222  3662 fcloseR
  7695                                  ;  223  3670 fcloseR
  7696                                  ;  224  3678 exitR
  7697                                  ;  225  3700 genCode8
  7698                                  ;  226  3722 genCode8
  7699                                  ;  227  3742 genCode8
  7700                                  ;  228  3762 errorexit
  7701                                  ;  229  3784 genCode8
  7702                                  ;  230  3793 genCode8
  7703                                  ;  231  3818 genCode8
  7704                                  ;  232  3827 genCode8
  7705                                  ;  233  3836 genCode16
  7706                                  ;  234  3859 genCode16
  7707                                  ;  235  3869 genCode8
  7708                                  ;  236  3888 getTokeType
  7709                                  ;  237  3900 getCodeSize
  7710                                  ;  238  3912 getCodes
  7711                                  ;  239  3921 genCode8
  7712                                  ;  240  3930 getOpL
  7713                                  ;  241  3937 checkOpL
  7714                                  ;  242  3946 genCode2
  7715                                  ;  243  3955 getTokeType
  7716                                  ;  244  3967 implerror
  7717                                  ;  245  3977 genCodeW
  7718                                  ;  246  3986 writeEA
  7719                                  ;  247  3994 check2Ops
  7720                                  ;  248  4004 reg16error
  7721                                  ;  249  4015 addrerror
  7722                                  ;  250  4025 genCode8
  7723                                  ;  251  4034 genCode8
  7724                                  ;  252  4043 writeEA
  7725                                  ;  253  4051 check2Ops
  7726                                  ;  254  4061 setsflag
  7727                                  ;  255  4070 genCodeW
  7728                                  ;  256  4079 genImmediate
  7729                                  ;  257  4092 genCodeW
  7730                                  ;  258  4101 writeEA
  7731                                  ;  259  4109 genCode8
  7732                                  ;  260  4118 genImmediate
  7733                                  ;  261  4131 genCodeW
  7734                                  ;  262  4140 writeEA
  7735                                  ;  263  4148 genCodeW
  7736                                  ;  264  4157 writeEA
  7737                                  ;  265  4165 syntaxerror
  7738                                  ;  266  4177 check2Ops
  7739                                  ;  267  4187 genCode2
  7740                                  ;  268  4196 genImmediate
  7741                                  ;  269  4209 genCodeW
  7742                                  ;  270  4218 writeEA
  7743                                  ;  271  4226 genImmediate
  7744                                  ;  272  4239 regmemerror
  7745                                  ;  273  4251 ChangeDirection
  7746                                  ;  274  4267 reg16error
  7747                                  ;  275  4278 genCode2
  7748                                  ;  276  4287 writeEA
  7749                                  ;  277  4295 genCodeW
  7750                                  ;  278  4304 genCode16
  7751                                  ;  279  4314 genCodeW
  7752                                  ;  280  4323 genCode16
  7753                                  ;  281  4333 genCodeW
  7754                                  ;  282  4342 writeEA
  7755                                  ;  283  4350 ChangeDirection
  7756                                  ;  284  4366 genCodeW
  7757                                  ;  285  4375 writeEA
  7758                                  ;  286  4383 syntaxerror
  7759                                  ;  287  4395 genCode8
  7760                                  ;  288  4404 genCode16
  7761                                  ;  289  4414 genCode8
  7762                                  ;  290  4423 getOpL
  7763                                  ;  291  4430 setsflag
  7764                                  ;  292  4439 genCode2
  7765                                  ;  293  4448 genCode8
  7766                                  ;  294  4457 genCode16
  7767                                  ;  295  4467 error1
  7768                                  ;  296  4474 genCode8
  7769                                  ;  297  4483 genCode8
  7770                                  ;  298  4492 checkOpL
  7771                                  ;  299  4501 reg16error
  7772                                  ;  300  4512 genCode2
  7773                                  ;  301  4521 genCode8
  7774                                  ;  302  4530 writeEA
  7775                                  ;  303  4538 syntaxerror
  7776                                  ;  304  4550 genCode8
  7777                                  ;  305  4559 genCode8
  7778                                  ;  306  4568 genCode8
  7779                                  ;  307  4577 error1
  7780                                  ;  308  4584 error1
  7781                                  ;  309  4610 putch
  7782                                  ;  310  4678 strcpy
  7783                                  ;  311  4693 DosInt
  7784                                  ;  312  4709 DosInt
  7785                                  ;  313  4732 DosInt
  7786                                  ;  314  4751 DosInt
  7787                                  ;  315  4785 writetty
  7788                                  ;  316  4794 writetty
  7789                                  ;Input: AS.C, List: AS.S,  Lines:  266
  7790                                  ;Glob. variables:  194 max.:  200
  7791                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7792                                  ;Functions      :   83 max.:  300
  7793                                  ;Calls          :  317 max.: 2000, NameField: 4826 max.:    65535
  7794                                  ;Code until     :25998 max.: 30000, free: 4002
  7795                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7796                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
