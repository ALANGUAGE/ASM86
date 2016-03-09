     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E92A28                  jmp main
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
   831                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};
   832                                  
   833 000011C9 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   834                                  
   835                                  ;-141 // 100: directives
   836                                  
   837                                  
   838                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   839                                  
   840 000011D1 4F52470065F1            I_ORG db 79,82,71,0,101,241
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
   856 000011D7 444200C8F1              I_DB db 68,66,0,200,241
   857                                  
   858                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   859                                  
   860 000011DC 445700C9F1              I_DW db 68,87,0,201,241
   861                                  
   862                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   863                                  
   864 000011E1 444400CAF1              I_DD db 68,68,0,202,241
   865                                  
   866                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   867                                  
   868 000011E6 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   869                                  
   870                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   871                                  
   872 000011ED 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   873                                  
   874                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   875                                  
   876 000011F4 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   877                                  
   878                                  ;-153 char I_END=0;// end of table char
   879                                  
   880 000011FB 00                      I_END db 0
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
   900 000011FC C8020000                 ENTER  2,0
   901 00001200 A0[AC01]                 mov al, [Op]
   902 00001203 8846FE                   mov byte [bp-2], al
   903 00001206 A0[AD01]                 mov al, [Op2]
   904 00001209 A2[AC01]                 mov byte [Op], al
   905 0000120C 8A46FE                   mov al, [bp-2]
   906 0000120F A2[AD01]                 mov byte [Op2], al
   907                                  
   908                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   909                                  
   910 00001212 A0[B501]                 mov al, [R1Type]
   911 00001215 8846FE                   mov byte [bp-2], al
   912 00001218 A0[B401]                 mov al, [R2Type]
   913 0000121B A2[B501]                 mov byte [R1Type], al
   914 0000121E 8A46FE                   mov al, [bp-2]
   915 00001221 A2[B401]                 mov byte [R2Type], al
   916                                  
   917                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   918                                  
   919 00001224 A0[B301]                 mov al, [R1No]
   920 00001227 8846FE                   mov byte [bp-2], al
   921 0000122A A0[B201]                 mov al, [R2No]
   922 0000122D A2[B301]                 mov byte [R1No], al
   923 00001230 8A46FE                   mov al, [bp-2]
   924 00001233 A2[B201]                 mov byte [R2No], al
   925                                  
   926                                  ;-6     dflag=2;     
   927                                  
   928 00001236 66B802000000             mov eax, 2
   929 0000123C A2[B801]                 mov byte [dflag], al
   930                                  
   931                                  ;-7 }
   932                                  
   933                                  
   934                                  ;-8      
   935                                  
   936                                  
   937                                  ;-9 int checkOpL() {
   938 0000123F C9                       LEAVE
   939 00001240 C3                       ret
   940                                  ; ENDP
   941                                  
   942                                  checkOpL:  ; *** PROC ***
   943                                  
   944                                  ;-10     if (Op == ADR) implerror();
   945                                  
   946 00001241 A0[AC01]                 mov al, [Op]
   947 00001244 3C03                     cmp al, 3
   948 00001246 0F850300                 jne @@checkOpL1
   949 0000124A E8A614                   call implerror
   950                                  
   951                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   952                                  
   953                                  @@checkOpL1:
   954 0000124D A0[B501]                 mov al, [R1Type]
   955 00001250 3C04                     cmp al, 4
   956 00001252 0F850600                 jne @@checkOpL2
   957 00001256 E86215                   call segregerror
   958 00001259 E93E00                   jmp @@retn
   959                                  
   960                                  ;-12     setwflag();
   961                                  
   962                                  @@checkOpL2:
   963 0000125C E8CB03                   call setwflag
   964                                  
   965                                  ;-13     if (OpSize == 0) error1("no op size declared");
   966                                  
   967 0000125F A0[B601]                 mov al, [OpSize]
   968 00001262 3C00                     cmp al, 0
   969 00001264 0F850900                 jne @@checkOpL3
   970 00001268 68[9B12]                 push checkOpL_0
   971 0000126B E8B513                   call error1
   972 0000126E 83C402                   add  sp, 2
   973                                  
   974                                  ;-14     if (OpSize == R1Type) return;
   975                                  
   976                                  @@checkOpL3:
   977 00001271 A0[B601]                 mov al, [OpSize]
   978 00001274 3A06[B501]               cmp al, [R1Type]
   979 00001278 0F850300                 jne @@checkOpL4
   980 0000127C E91B00                   jmp @@retn
   981                                  
   982                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
   983                                  
   984                                  @@checkOpL4:
   985 0000127F A0[AC01]                 mov al, [Op]
   986 00001282 3C02                     cmp al, 2
   987 00001284 0F851200                 jne @@checkOpL5
   988 00001288 A0[B501]                 mov al, [R1Type]
   989 0000128B 3C00                     cmp al, 0
   990 0000128D 0F850900                 jne @@checkOpL6
   991 00001291 68[AF12]                 push checkOpL_1
   992 00001294 E88C13                   call error1
   993 00001297 83C402                   add  sp, 2
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
  1006 0000129A C3                       ret
  1007                                  ; ENDP
  1008 0000129B 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1009 000012A4 65206465636C617265-
  1010 000012AD 6400               
  1011 000012AF 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1012 000012B8 657220646566696E65-
  1013 000012C1 6400               
  1014                                  
  1015                                  check2Ops:  ; *** PROC ***
  1016                                  
  1017                                  ;-19     get2Ops();
  1018                                  
  1019 000012C3 E84900                   call get2Ops
  1020                                  
  1021                                  ;-20     if (Op ==   0) addrerror();
  1022                                  
  1023 000012C6 A0[AC01]                 mov al, [Op]
  1024 000012C9 3C00                     cmp al, 0
  1025 000012CB 0F850300                 jne @@check2Ops7
  1026 000012CF E8E213                   call addrerror
  1027                                  
  1028                                  ;-21     if (Op == ADR) invaloperror(); 
  1029                                  
  1030                                  @@check2Ops7:
  1031 000012D2 A0[AC01]                 mov al, [Op]
  1032 000012D5 3C03                     cmp al, 3
  1033 000012D7 0F850300                 jne @@check2Ops8
  1034 000012DB E85014                   call invaloperror
  1035                                  
  1036                                  ;-22     if (Op == IMM) immeerror();   
  1037                                  
  1038                                  @@check2Ops8:
  1039 000012DE A0[AC01]                 mov al, [Op]
  1040 000012E1 3C01                     cmp al, 1
  1041 000012E3 0F850300                 jne @@check2Ops9
  1042 000012E7 E8E413                   call immeerror
  1043                                  
  1044                                  ;-23     if (Op2==   0) addrerror();
  1045                                  
  1046                                  @@check2Ops9:
  1047 000012EA A0[AD01]                 mov al, [Op2]
  1048 000012ED 3C00                     cmp al, 0
  1049 000012EF 0F850300                 jne @@check2Ops10
  1050 000012F3 E8BE13                   call addrerror
  1051                                  
  1052                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1053                                  
  1054                                  @@check2Ops10:
  1055 000012F6 A0[AE01]                 mov al, [CodeType]
  1056 000012F9 3C05                     cmp al, 5
  1057 000012FB 0F840C00                 je  @@check2Ops11
  1058 000012FF A0[AD01]                 mov al, [Op2]
  1059 00001302 3C03                     cmp al, 3
  1060 00001304 0F850300                 jne @@check2Ops12
  1061 00001308 E82314                   call invaloperror
  1062                                  
  1063                                  ;-25     setwflag();       
  1064                                  
  1065                                  @@check2Ops12:
  1066                                  @@check2Ops11:
  1067 0000130B E81C03                   call setwflag
  1068                                  
  1069                                  ;-26 }    
  1070                                  
  1071                                  
  1072                                  ;-27 int get2Ops() {
  1073                                  
  1074 0000130E C3                       ret
  1075                                  ; ENDP
  1076                                  
  1077                                  get2Ops:  ; *** PROC ***
  1078                                  
  1079                                  ;-28     getOpL();
  1080                                  
  1081 0000130F E80C00                   call getOpL
  1082                                  
  1083                                  ;-29     need(',');    
  1084                                  
  1085 00001312 6A2C                     push 44
  1086 00001314 E8E208                   call need
  1087 00001317 83C402                   add  sp, 2
  1088                                  
  1089                                  ;-30     getOpR();         
  1090                                  
  1091 0000131A E83200                   call getOpR
  1092                                  
  1093                                  ;-31 } 
  1094                                  
  1095                                  
  1096                                  ;-32         
  1097                                  
  1098                                  
  1099                                  ;-33 int getOpL() {
  1100                                  
  1101 0000131D C3                       ret
  1102                                  ; ENDP
  1103                                  
  1104                                  getOpL:  ; *** PROC ***
  1105                                  
  1106                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1107                                  
  1108                                  
  1109                                  ;-35     getOpR();
  1110                                  
  1111 0000131E E82E00                   call getOpR
  1112                                  
  1113                                  ;-36     Op=Op2;         Op2=0;
  1114                                  
  1115 00001321 A0[AD01]                 mov al, [Op2]
  1116 00001324 A2[AC01]                 mov byte [Op], al
  1117 00001327 66B800000000             mov eax, 0
  1118 0000132D A2[AD01]                 mov byte [Op2], al
  1119                                  
  1120                                  ;-37     R1No=R2No;      R2No=0;
  1121                                  
  1122 00001330 A0[B201]                 mov al, [R2No]
  1123 00001333 A2[B301]                 mov byte [R1No], al
  1124 00001336 66B800000000             mov eax, 0
  1125 0000133C A2[B201]                 mov byte [R2No], al
  1126                                  
  1127                                  ;-38     R1Type=R2Type; R2Type=0; 
  1128                                  
  1129 0000133F A0[B401]                 mov al, [R2Type]
  1130 00001342 A2[B501]                 mov byte [R1Type], al
  1131 00001345 66B800000000             mov eax, 0
  1132 0000134B A2[B401]                 mov byte [R2Type], al
  1133                                  
  1134                                  ;-39 }  
  1135                                  
  1136                                  
  1137                                  ;-40 
  1138                                  
  1139                                  
  1140                                  ;-41 int getOpR() {
  1141                                  
  1142 0000134E C3                       ret
  1143                                  ; ENDP
  1144                                  
  1145                                  getOpR:  ; *** PROC ***
  1146                                  
  1147                                  ;-42     Op2=getOp1();
  1148                                  
  1149 0000134F E88900                   call getOp1
  1150 00001352 A2[AD01]                 mov byte [Op2], al
  1151                                  
  1152                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1153                                  
  1154 00001355 6A5B                     push 91
  1155 00001357 E87108                   call isToken
  1156 0000135A 83C402                   add  sp, 2
  1157 0000135D 08C0                     or  al, al
  1158 0000135F 0F840F00                 je @@getOpR13
  1159 00001363 66B804000000             mov eax, 4
  1160 00001369 A2[AD01]                 mov byte [Op2], al
  1161 0000136C E8F200                   call getMEM
  1162 0000136F E94F00                   jmp @@retn
  1163                                  
  1164                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1165                                  
  1166                                  @@getOpR13:
  1167 00001372 A0[AD01]                 mov al, [Op2]
  1168 00001375 3C00                     cmp al, 0
  1169 00001377 0F850600                 jne @@getOpR14
  1170 0000137B E8B013                   call invaloperror
  1171 0000137E E94000                   jmp @@retn
  1172                                  
  1173                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1174                                  
  1175                                  @@getOpR14:
  1176 00001381 A0[AD01]                 mov al, [Op2]
  1177 00001384 3C01                     cmp al, 1
  1178 00001386 0F850900                 jne @@getOpR15
  1179 0000138A A1[4D00]                 mov ax, [SymbolInt]
  1180 0000138D A3[BE01]                 mov word [imme], ax
  1181 00001390 E92E00                   jmp @@retn
  1182                                  
  1183                                  ;-46     if (Op2 == REG)                            return;
  1184                                  
  1185                                  @@getOpR15:
  1186 00001393 A0[AD01]                 mov al, [Op2]
  1187 00001396 3C02                     cmp al, 2
  1188 00001398 0F850300                 jne @@getOpR16
  1189 0000139C E92200                   jmp @@retn
  1190                                  
  1191                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1192                                  
  1193                                  @@getOpR16:
  1194 0000139F A0[AD01]                 mov al, [Op2]
  1195 000013A2 3C03                     cmp al, 3
  1196 000013A4 0F851000                 jne @@getOpR17
  1197 000013A8 8B1E[7E06]               mov bx, [LabelIx]
  1198 000013AC D1E3                     shl bx, 1
  1199 000013AE 8B87[B405]               mov ax, [LabelAddr + bx]
  1200 000013B2 A3[BC01]                 mov word [disp], ax
  1201 000013B5 E90900                   jmp @@retn
  1202                                  
  1203                                  ;-48     error1("Name of operand expected");
  1204                                  
  1205                                  @@getOpR17:
  1206 000013B8 68[C213]                 push getOpR_0
  1207 000013BB E86512                   call error1
  1208 000013BE 83C402                   add  sp, 2
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
  1219 000013C1 C3                       ret
  1220                                  ; ENDP
  1221 000013C2 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1222 000013CB 706572616E64206578-
  1223 000013D4 70656374656400     
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
  1238 000013DB A0[AB01]                 mov al, [TokeType]
  1239 000013DE 3C00                     cmp al, 0
  1240 000013E0 0F850900                 jne @@getOp118
  1241 000013E4 66B800000000             mov eax, 0
  1242 000013EA E96000                   jmp @@retn
  1243                                  
  1244                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1245                                  
  1246                                  @@getOp118:
  1247 000013ED A0[AB01]                 mov al, [TokeType]
  1248 000013F0 3C01                     cmp al, 1
  1249 000013F2 0F850900                 jne @@getOp119
  1250 000013F6 66B801000000             mov eax, 1
  1251 000013FC E94E00                   jmp @@retn
  1252                                  
  1253                                  ;-57     if (TokeType == ALNUME) {
  1254                                  
  1255                                  @@getOp119:
  1256 000013FF A0[AB01]                 mov al, [TokeType]
  1257 00001402 3C03                     cmp al, 3
  1258 00001404 0F853C00                 jne @@getOp120
  1259                                  
  1260                                  ;-58         R2No=testReg();
  1261                                  
  1262 00001408 E86D0B                   call testReg
  1263 0000140B A2[B201]                 mov byte [R2No], al
  1264                                  
  1265                                  ;-59         if (R2Type)        return REG;
  1266                                  
  1267 0000140E A0[B401]                 mov al, [R2Type]
  1268 00001411 08C0                     or  al, al
  1269 00001413 0F840900                 je @@getOp121
  1270 00001417 66B802000000             mov eax, 2
  1271 0000141D E92D00                   jmp @@retn
  1272                                  
  1273                                  ;-60         LabelIx=searchLabel();
  1274                                  
  1275                                  @@getOp121:
  1276 00001420 E81305                   call searchLabel
  1277 00001423 A3[7E06]                 mov word [LabelIx], ax
  1278                                  
  1279                                  ;-61         if (LabelIx)        return ADR;
  1280                                  
  1281 00001426 A1[7E06]                 mov ax, [LabelIx]
  1282 00001429 08C0                     or  al, al
  1283 0000142B 0F840C00                 je @@getOp122
  1284 0000142F 66B803000000             mov eax, 3
  1285 00001435 E91500                   jmp @@retn
  1286                                  
  1287                                  ;-62         else error1("variable not found"); 
  1288                                  
  1289 00001438 E90900                   jmp @@getOp123
  1290                                  @@getOp122:
  1291 0000143B 68[4E14]                 push getOp1_0
  1292 0000143E E8E211                   call error1
  1293 00001441 83C402                   add  sp, 2
  1294                                  
  1295                                  ;-63     }
  1296                                  
  1297                                  @@getOp123:
  1298                                  
  1299                                  ;-64     return 0;
  1300                                  
  1301                                  @@getOp120:
  1302 00001444 66B800000000             mov eax, 0
  1303 0000144A E90000                   jmp @@retn
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
  1314 0000144D C3                       ret
  1315                                  ; ENDP
  1316 0000144E 7661726961626C6520-     getOp1_0 db "variable not found",0
  1317 00001457 6E6F7420666F756E64-
  1318 00001460 00                 
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
  1333 00001461 C8020000                 ENTER  2,0
  1334 00001465 66B800000000             mov eax, 0
  1335 0000146B A3[BC01]                 mov word [disp], ax
  1336 0000146E 66B800000000             mov eax, 0
  1337 00001474 A2[BA01]                 mov byte [rm], al
  1338                                  
  1339                                  ;-71     do {
  1340                                  
  1341                                  @@getMEM24:
  1342                                  
  1343                                  ;-72         getTokeType();
  1344                                  
  1345 00001477 E87B03                   call getTokeType
  1346                                  
  1347                                  ;-73         c=getOp1();
  1348                                  
  1349 0000147A E85EFF                   call getOp1
  1350 0000147D 8846FE                   mov byte [bp-2], al
  1351                                  
  1352                                  ;-74         if (c ==   0) syntaxerror();
  1353                                  
  1354 00001480 8A46FE                   mov al, [bp-2]
  1355 00001483 3C00                     cmp al, 0
  1356 00001485 0F850300                 jne @@getMEM25
  1357 00001489 E85613                   call syntaxerror
  1358                                  
  1359                                  ;-75         if (c == REG) {
  1360                                  
  1361                                  @@getMEM25:
  1362 0000148C 8A46FE                   mov al, [bp-2]
  1363 0000148F 3C02                     cmp al, 2
  1364 00001491 0F851E00                 jne @@getMEM26
  1365                                  
  1366                                  ;-76             isDirect=0;
  1367                                  
  1368 00001495 66B800000000             mov eax, 0
  1369 0000149B A2[BB01]                 mov byte [isDirect], al
  1370                                  
  1371                                  ;-77             if (rm) rm=getIndReg2();
  1372                                  
  1373 0000149E A0[BA01]                 mov al, [rm]
  1374 000014A1 08C0                     or  al, al
  1375 000014A3 0F840900                 je @@getMEM27
  1376 000014A7 E8F300                   call getIndReg2
  1377 000014AA A2[BA01]                 mov byte [rm], al
  1378                                  
  1379                                  ;-78             else getIndReg1();
  1380                                  
  1381 000014AD E90300                   jmp @@getMEM28
  1382                                  @@getMEM27:
  1383 000014B0 E88900                   call getIndReg1
  1384                                  
  1385                                  ;-79         }
  1386                                  
  1387                                  @@getMEM28:
  1388                                  
  1389                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1390                                  
  1391                                  @@getMEM26:
  1392 000014B3 8A46FE                   mov al, [bp-2]
  1393 000014B6 3C03                     cmp al, 3
  1394 000014B8 0F851000                 jne @@getMEM29
  1395 000014BC A1[BC01]                 mov ax, [disp]
  1396 000014BF 8B1E[7E06]               mov bx, [LabelIx]
  1397 000014C3 D1E3                     shl bx, 1
  1398 000014C5 0387[B405]               add ax, [LabelAddr + bx]
  1399 000014C9 A3[BC01]                 mov word [disp], ax
  1400                                  
  1401                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1402                                  
  1403                                  @@getMEM29:
  1404 000014CC 8A46FE                   mov al, [bp-2]
  1405 000014CF 3C01                     cmp al, 1
  1406 000014D1 0F850A00                 jne @@getMEM30
  1407 000014D5 A1[BC01]                 mov ax, [disp]
  1408 000014D8 0306[4D00]               add ax, [SymbolInt]
  1409 000014DC A3[BC01]                 mov word [disp], ax
  1410                                  
  1411                                  ;-82         if (isToken('-')) {
  1412                                  
  1413                                  @@getMEM30:
  1414 000014DF 6A2D                     push 45
  1415 000014E1 E8E706                   call isToken
  1416 000014E4 83C402                   add  sp, 2
  1417 000014E7 08C0                     or  al, al
  1418 000014E9 0F841900                 je @@getMEM31
  1419                                  
  1420                                  ;-83             getTokeType();
  1421                                  
  1422 000014ED E80503                   call getTokeType
  1423                                  
  1424                                  ;-84             if (TokeType != DIGIT) numbererror();
  1425                                  
  1426 000014F0 A0[AB01]                 mov al, [TokeType]
  1427 000014F3 3C01                     cmp al, 1
  1428 000014F5 0F840300                 je  @@getMEM32
  1429 000014F9 E85312                   call numbererror
  1430                                  
  1431                                  ;-85             disp = disp - SymbolInt;
  1432                                  
  1433                                  @@getMEM32:
  1434 000014FC A1[BC01]                 mov ax, [disp]
  1435 000014FF 2B06[4D00]               sub ax, [SymbolInt]
  1436 00001503 A3[BC01]                 mov word [disp], ax
  1437                                  
  1438                                  ;-86         }
  1439                                  
  1440                                  
  1441                                  ;-87     } while (isToken('+'));
  1442                                  
  1443                                  @@getMEM31:
  1444 00001506 6A2B                     push 43
  1445 00001508 E8C006                   call isToken
  1446 0000150B 83C402                   add  sp, 2
  1447 0000150E 08C0                     or  al, al
  1448 00001510 0F840300                 je @@getMEM33
  1449 00001514 E960FF                   jmp @@getMEM24
  1450                                  @@getMEM33:
  1451                                  
  1452                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1453                                  
  1454 00001517 6A5D                     push 93
  1455 00001519 E8AF06                   call isToken
  1456 0000151C 83C402                   add  sp, 2
  1457 0000151F 83F800                   cmp ax, 0
  1458 00001522 0F850900                 jne @@getMEM34
  1459 00001526 68[3115]                 push getMEM_0
  1460 00001529 E85611                   call errorexit
  1461 0000152C 83C402                   add  sp, 2
  1462                                  
  1463                                  ;-89 }
  1464                                  
  1465                                  @@getMEM34:
  1466                                  
  1467                                  ;-90 int getIndReg1() {
  1468 0000152F C9                       LEAVE
  1469 00001530 C3                       ret
  1470                                  ; ENDP
  1471 00001531 5D2065787065637465-     getMEM_0 db "] expected",0
  1472 0000153A 6400               
  1473                                  
  1474                                  getIndReg1:  ; *** PROC ***
  1475                                  
  1476                                  ;-91     if (R2Type !=WORD) indexerror();
  1477                                  
  1478 0000153C A0[B401]                 mov al, [R2Type]
  1479 0000153F 3C02                     cmp al, 2
  1480 00001541 0F840300                 je  @@getIndReg135
  1481 00001545 E8C511                   call indexerror
  1482                                  
  1483                                  ;-92     if (R2No==3) rm=7;//BX
  1484                                  
  1485                                  @@getIndReg135:
  1486 00001548 A0[B201]                 mov al, [R2No]
  1487 0000154B 3C03                     cmp al, 3
  1488 0000154D 0F850900                 jne @@getIndReg136
  1489 00001551 66B807000000             mov eax, 7
  1490 00001557 A2[BA01]                 mov byte [rm], al
  1491                                  
  1492                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1493                                  
  1494                                  @@getIndReg136:
  1495 0000155A A0[B201]                 mov al, [R2No]
  1496 0000155D 3C05                     cmp al, 5
  1497 0000155F 0F850900                 jne @@getIndReg137
  1498 00001563 66B806000000             mov eax, 6
  1499 00001569 A2[BA01]                 mov byte [rm], al
  1500                                  
  1501                                  ;-94     if (R2No==7) rm=5;//DI
  1502                                  
  1503                                  @@getIndReg137:
  1504 0000156C A0[B201]                 mov al, [R2No]
  1505 0000156F 3C07                     cmp al, 7
  1506 00001571 0F850900                 jne @@getIndReg138
  1507 00001575 66B805000000             mov eax, 5
  1508 0000157B A2[BA01]                 mov byte [rm], al
  1509                                  
  1510                                  ;-95     if (R2No==6) rm=4;//SI
  1511                                  
  1512                                  @@getIndReg138:
  1513 0000157E A0[B201]                 mov al, [R2No]
  1514 00001581 3C06                     cmp al, 6
  1515 00001583 0F850900                 jne @@getIndReg139
  1516 00001587 66B804000000             mov eax, 4
  1517 0000158D A2[BA01]                 mov byte [rm], al
  1518                                  
  1519                                  ;-96     if (rm==0) indexerror();
  1520                                  
  1521                                  @@getIndReg139:
  1522 00001590 A0[BA01]                 mov al, [rm]
  1523 00001593 3C00                     cmp al, 0
  1524 00001595 0F850300                 jne @@getIndReg140
  1525 00001599 E87111                   call indexerror
  1526                                  
  1527                                  ;-97 }
  1528                                  
  1529                                  @@getIndReg140:
  1530                                  
  1531                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1532                                  
  1533 0000159C C3                       ret
  1534                                  ; ENDP
  1535                                  
  1536                                  getIndReg2:  ; *** PROC ***
  1537                                  ;Function : getIndReg2, Number of local variables: 1
  1538                                  ;   # type sign width line used address name   list of local variables
  1539                                  ;  200 var sign byte    98 NULL bp-2    m;
  1540 0000159D C8020000                 ENTER  2,0
  1541 000015A1 66B804000000             mov eax, 4
  1542 000015A7 8846FE                   mov byte [bp-2], al
  1543                                  
  1544                                  ;-99     if (R2Type !=WORD) indexerror();
  1545                                  
  1546 000015AA A0[B401]                 mov al, [R2Type]
  1547 000015AD 3C02                     cmp al, 2
  1548 000015AF 0F840300                 je  @@getIndReg241
  1549 000015B3 E85711                   call indexerror
  1550                                  
  1551                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1552                                  
  1553                                  @@getIndReg241:
  1554 000015B6 A0[B201]                 mov al, [R2No]
  1555 000015B9 3C07                     cmp al, 7
  1556 000015BB 0F852700                 jne @@getIndReg242
  1557 000015BF A0[BA01]                 mov al, [rm]
  1558 000015C2 3C06                     cmp al, 6
  1559 000015C4 0F850C00                 jne @@getIndReg243
  1560 000015C8 66B803000000             mov eax, 3
  1561 000015CE 8846FE                   mov byte [bp-2], al
  1562                                  
  1563                                  ;-101              else if (rm==7) m=1;//BX+DI
  1564                                  
  1565 000015D1 E91200                   jmp @@getIndReg244
  1566                                  @@getIndReg243:
  1567 000015D4 A0[BA01]                 mov al, [rm]
  1568 000015D7 3C07                     cmp al, 7
  1569 000015D9 0F850900                 jne @@getIndReg245
  1570 000015DD 66B801000000             mov eax, 1
  1571 000015E3 8846FE                   mov byte [bp-2], al
  1572                                  
  1573                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1574                                  
  1575                                  @@getIndReg245:
  1576                                  @@getIndReg244:
  1577                                  @@getIndReg242:
  1578 000015E6 A0[B201]                 mov al, [R2No]
  1579 000015E9 3C06                     cmp al, 6
  1580 000015EB 0F852700                 jne @@getIndReg246
  1581 000015EF A0[BA01]                 mov al, [rm]
  1582 000015F2 3C06                     cmp al, 6
  1583 000015F4 0F850C00                 jne @@getIndReg247
  1584 000015F8 66B802000000             mov eax, 2
  1585 000015FE 8846FE                   mov byte [bp-2], al
  1586                                  
  1587                                  ;-103              else if (rm==7) m=0;//BX+SI
  1588                                  
  1589 00001601 E91200                   jmp @@getIndReg248
  1590                                  @@getIndReg247:
  1591 00001604 A0[BA01]                 mov al, [rm]
  1592 00001607 3C07                     cmp al, 7
  1593 00001609 0F850900                 jne @@getIndReg249
  1594 0000160D 66B800000000             mov eax, 0
  1595 00001613 8846FE                   mov byte [bp-2], al
  1596                                  
  1597                                  ;-104     if (m > 3) indexerror();
  1598                                  
  1599                                  @@getIndReg249:
  1600                                  @@getIndReg248:
  1601                                  @@getIndReg246:
  1602 00001616 8A46FE                   mov al, [bp-2]
  1603 00001619 3C03                     cmp al, 3
  1604 0000161B 0F8E0300                 jle @@getIndReg250
  1605 0000161F E8EB10                   call indexerror
  1606                                  
  1607                                  ;-105     return m;
  1608                                  
  1609                                  @@getIndReg250:
  1610 00001622 8A46FE                   mov al, [bp-2]
  1611 00001625 E90000                   jmp @@retn
  1612                                  
  1613                                  ;-106 }
  1614                                  
  1615                                  
  1616                                  ;-107                   
  1617                                  
  1618                                  
  1619                                  ;-108 int setwflag() {//word size, bit 0
  1620                                  
  1621 00001628 C9                      @@retn: LEAVE
  1622 00001629 C3                       ret
  1623                                  ; ENDP
  1624                                  
  1625                                  setwflag:  ; *** PROC ***
  1626                                  
  1627                                  ;-109     wflag=0;
  1628                                  
  1629 0000162A 66B800000000             mov eax, 0
  1630 00001630 A2[B701]                 mov byte [wflag], al
  1631                                  
  1632                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1633                                  
  1634 00001633 A0[B601]                 mov al, [OpSize]
  1635 00001636 3C00                     cmp al, 0
  1636 00001638 0F854200                 jne @@setwflag51
  1637                                  
  1638                                  ;-111         if (Op == REG) OpSize=R1Type;
  1639                                  
  1640 0000163C A0[AC01]                 mov al, [Op]
  1641 0000163F 3C02                     cmp al, 2
  1642 00001641 0F850600                 jne @@setwflag52
  1643 00001645 A0[B501]                 mov al, [R1Type]
  1644 00001648 A2[B601]                 mov byte [OpSize], al
  1645                                  
  1646                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1647                                  
  1648                                  @@setwflag52:
  1649 0000164B A0[AD01]                 mov al, [Op2]
  1650 0000164E 3C02                     cmp al, 2
  1651 00001650 0F850600                 jne @@setwflag53
  1652 00001654 A0[B401]                 mov al, [R2Type]
  1653 00001657 A2[B601]                 mov byte [OpSize], al
  1654                                  
  1655                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1656                                  
  1657                                  @@setwflag53:
  1658 0000165A A0[B401]                 mov al, [R2Type]
  1659 0000165D 3C04                     cmp al, 4
  1660 0000165F 0F850900                 jne @@setwflag54
  1661 00001663 66B802000000             mov eax, 2
  1662 00001669 A2[B601]                 mov byte [OpSize], al
  1663                                  
  1664                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1665                                  
  1666                                  @@setwflag54:
  1667 0000166C A0[B501]                 mov al, [R1Type]
  1668 0000166F 3C04                     cmp al, 4
  1669 00001671 0F850900                 jne @@setwflag55
  1670 00001675 66B802000000             mov eax, 2
  1671 0000167B A2[B601]                 mov byte [OpSize], al
  1672                                  
  1673                                  ;-115     }
  1674                                  
  1675                                  @@setwflag55:
  1676                                  
  1677                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1678                                  
  1679                                  @@setwflag51:
  1680 0000167E A0[B601]                 mov al, [OpSize]
  1681 00001681 3C03                     cmp al, 3
  1682 00001683 0F850C00                 jne @@setwflag56
  1683 00001687 E82E15                   call gen66h
  1684 0000168A 66B801000000             mov eax, 1
  1685 00001690 A2[B701]                 mov byte [wflag], al
  1686                                  
  1687                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1688                                  
  1689                                  @@setwflag56:
  1690 00001693 A0[B601]                 mov al, [OpSize]
  1691 00001696 3C02                     cmp al, 2
  1692 00001698 0F850900                 jne @@setwflag57
  1693 0000169C 66B801000000             mov eax, 1
  1694 000016A2 A2[B701]                 mov byte [wflag], al
  1695                                  
  1696                                  ;-118 }
  1697                                  
  1698                                  @@setwflag57:
  1699                                  
  1700                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1701                                  
  1702 000016A5 C3                       ret
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
  1715 000016A6 C8020000                 ENTER  2,0
  1716 000016AA 66B802000000             mov eax, 2
  1717 000016B0 A2[B901]                 mov byte [sflag], al
  1718                                  
  1719                                  ;-122     ui = imme & 0xFF80; 
  1720                                  
  1721 000016B3 A1[BE01]                 mov ax, [imme]
  1722 000016B6 2580FF                   and ax, 65408
  1723 000016B9 8946FE                   mov word [bp-2], ax
  1724                                  
  1725                                  ;-123     if(ui != 0) sflag = 0;    //vvv
  1726                                  
  1727 000016BC 8B46FE                   mov ax, [bp-2]
  1728 000016BF 83F800                   cmp ax, 0
  1729 000016C2 0F840900                 je  @@setsflag58
  1730 000016C6 66B800000000             mov eax, 0
  1731 000016CC A2[B901]                 mov byte [sflag], al
  1732                                  
  1733                                  ;-124     if (OpSize == BYTE) {
  1734                                  
  1735                                  @@setsflag58:
  1736 000016CF A0[B601]                 mov al, [OpSize]
  1737 000016D2 3C01                     cmp al, 1
  1738 000016D4 0F851C00                 jne @@setsflag59
  1739                                  
  1740                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1741                                  
  1742 000016D8 A1[BE01]                 mov ax, [imme]
  1743 000016DB 3DFF00                   cmp ax, 255
  1744 000016DE 0F8E0900                 jle @@setsflag60
  1745 000016E2 68[F616]                 push setsflag_0
  1746 000016E5 E83B0F                   call error1
  1747 000016E8 83C402                   add  sp, 2
  1748                                  
  1749                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1750                                  
  1751                                  @@setsflag60:
  1752 000016EB 66B800000000             mov eax, 0
  1753 000016F1 A2[B901]                 mov byte [sflag], al
  1754                                  
  1755                                  ;-127     }
  1756                                  
  1757                                  
  1758                                  ;-128 }
  1759                                  
  1760 000016F4 C9                      @@setsflag59: LEAVE
  1761 000016F5 C3                       ret
  1762                                  ; ENDP
  1763 000016F6 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1764 000016FF 6F7220627974652072-
  1765 00001708 2F6D00             
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
  1779 0000170B B8[CA01]                 mov ax, LabelNames
  1780 0000170E A3[B205]                 mov word [LabelNamePtr], ax
  1781                                  
  1782                                  ;-3   do {
  1783                                  
  1784                                  @@parse61:
  1785                                  
  1786                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
  1787                                  
  1788 00001711 A1[A601]                 mov ax, [PC]
  1789 00001714 A3[A801]                 mov word [PCStart], ax
  1790 00001717 66B800000000             mov eax, 0
  1791 0000171D A2[B601]                 mov byte [OpSize], al
  1792 00001720 66B800000000             mov eax, 0
  1793 00001726 A3[C501]                 mov word [OpPrintIndex], ax
  1794 00001729 66B820000000             mov eax, 32
  1795 0000172F A2[C901]                 mov byte [PrintR], al
  1796                                  
  1797                                  ;-5     getLine();
  1798                                  
  1799 00001732 E82C05                   call getLine
  1800                                  
  1801                                  ;-6     InputPtr = &InputBuf;
  1802                                  
  1803 00001735 B8[4F00]                 mov ax, InputBuf
  1804 00001738 A3[CE00]                 mov word [InputPtr], ax
  1805                                  
  1806                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1807                                  
  1808 0000173B E8B700                   call getTokeType
  1809                                  
  1810                                  ;-8     if (TokeType == ALNUME) {
  1811                                  
  1812 0000173E A0[AB01]                 mov al, [TokeType]
  1813 00001741 3C03                     cmp al, 3
  1814 00001743 0F851300                 jne @@parse62
  1815                                  
  1816                                  ;-9       if (isLabel) { //set in getName
  1817                                  
  1818 00001747 A0[AA01]                 mov al, [isLabel]
  1819 0000174A 08C0                     or  al, al
  1820 0000174C 0F840A00                 je @@parse63
  1821                                  
  1822                                  ;-10         storeLabel();
  1823                                  
  1824 00001750 E84001                   call storeLabel
  1825                                  
  1826                                  ;-11         InputPtr++;//remove :
  1827                                  
  1828 00001753 FF06[CE00]               inc  word [InputPtr]
  1829                                  
  1830                                  ;-12         getTokeType();
  1831                                  
  1832 00001757 E89B00                   call getTokeType
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
  1844 0000175A A0[AB01]                 mov al, [TokeType]
  1845 0000175D 3C03                     cmp al, 3
  1846 0000175F 0F851B00                 jne @@parse64
  1847                                  
  1848                                  ;-16       lookCode();// and OpCodePtr
  1849                                  
  1850 00001763 E86803                   call lookCode
  1851                                  
  1852                                  ;-17       if(CodeType) process();
  1853                                  
  1854 00001766 A0[AE01]                 mov al, [CodeType]
  1855 00001769 08C0                     or  al, al
  1856 0000176B 0F840600                 je @@parse65
  1857 0000176F E83416                   call process
  1858                                  
  1859                                  ;-18       else getVariable();
  1860                                  
  1861 00001772 E90300                   jmp @@parse66
  1862                                  @@parse65:
  1863 00001775 E81E02                   call getVariable
  1864                                  
  1865                                  ;-19       skipRest();
  1866                                  
  1867                                  @@parse66:
  1868 00001778 E8BD04                   call skipRest
  1869                                  
  1870                                  ;-20     }
  1871                                  
  1872                                  
  1873                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
  1874                                  
  1875 0000177B E92700                   jmp @@parse67
  1876                                  @@parse64:
  1877 0000177E A0[AB01]                 mov al, [TokeType]
  1878 00001781 3C03                     cmp al, 3
  1879 00001783 0F8E0C00                 jle @@parse68
  1880 00001787 68[B617]                 push parse_0
  1881 0000178A E8960E                   call error1
  1882 0000178D 83C402                   add  sp, 2
  1883                                  
  1884                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1885                                  
  1886 00001790 E91200                   jmp @@parse69
  1887                                  @@parse68:
  1888 00001793 A0[AB01]                 mov al, [TokeType]
  1889 00001796 3C01                     cmp al, 1
  1890 00001798 0F850900                 jne @@parse70
  1891 0000179C 68[D417]                 push parse_1
  1892 0000179F E8810E                   call error1
  1893 000017A2 83C402                   add  sp, 2
  1894                                  
  1895                                  ;-23     printLine();
  1896                                  
  1897                                  @@parse70:
  1898                                  @@parse69:
  1899                                  @@parse67:
  1900 000017A5 E80C0C                   call printLine
  1901                                  
  1902                                  ;-24   } while (DOS_NoBytes != 0 );
  1903                                  
  1904 000017A8 A1[A301]                 mov ax, [DOS_NoBytes]
  1905 000017AB 83F800                   cmp ax, 0
  1906 000017AE 0F840300                 je  @@parse71
  1907 000017B2 E95CFF                   jmp @@parse61
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
  1918 000017B5 C3                       ret
  1919                                  ; ENDP
  1920 000017B6 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1921 000017BF 696E73747275637469-
  1922 000017C8 6F6E20657870656374-
  1923 000017D1 656400             
  1924 000017D4 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1925 000017DD 616C6C6F7765642040-
  1926 000017E6 207374617274206F66-
  1927 000017EF 206C696E6500       
  1928                                  
  1929                                  getTokeType:  ; *** PROC ***
  1930                                  
  1931                                  ;-28   skipBlank();
  1932                                  
  1933                                  ;Function : getTokeType, Number of local variables: 1
  1934                                  ;   # type sign width line used address name   list of local variables
  1935                                  ;  200 var sign byte    27 NULL bp-2    c;
  1936 000017F5 C8020000                 ENTER  2,0
  1937 000017F9 E86705                   call skipBlank
  1938                                  
  1939                                  ;-29   c = *InputPtr;
  1940                                  
  1941 000017FC 8B1E[CE00]               mov bx, [InputPtr]
  1942 00001800 8A07                     mov al, [bx]
  1943 00001802 B400                     mov ah, 0
  1944 00001804 8846FE                   mov byte [bp-2], al
  1945                                  
  1946                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1947                                  
  1948 00001807 8A46FE                   mov al, [bp-2]
  1949 0000180A 3C00                     cmp al, 0
  1950 0000180C 0F850C00                 jne @@getTokeType72
  1951 00001810 66B800000000             mov eax, 0
  1952 00001816 A2[AB01]                 mov byte [TokeType], al
  1953 00001819 E97500                   jmp @@retn
  1954                                  
  1955                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1956                                  
  1957                                  @@getTokeType72:
  1958 0000181C 8A46FE                   mov al, [bp-2]
  1959 0000181F 3C3B                     cmp al, 59
  1960 00001821 0F850C00                 jne @@getTokeType73
  1961 00001825 66B800000000             mov eax, 0
  1962 0000182B A2[AB01]                 mov byte [TokeType], al
  1963 0000182E E96000                   jmp @@retn
  1964                                  
  1965                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1966                                  
  1967                                  @@getTokeType73:
  1968 00001831 8A46FE                   mov al, byte [bp-2]
  1969 00001834 B400                     mov ah, 0
  1970 00001836 50                       push ax
  1971 00001837 E8581C                   call digit
  1972 0000183A 83C402                   add  sp, 2
  1973 0000183D 08C0                     or  al, al
  1974 0000183F 0F841800                 je @@getTokeType74
  1975 00001843 8A46FE                   mov al, byte [bp-2]
  1976 00001846 B400                     mov ah, 0
  1977 00001848 50                       push ax
  1978 00001849 E81D06                   call getDigit
  1979 0000184C 83C402                   add  sp, 2
  1980 0000184F 66B801000000             mov eax, 1
  1981 00001855 A2[AB01]                 mov byte [TokeType], al
  1982 00001858 E93600                   jmp @@retn
  1983                                  
  1984                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1985                                  
  1986                                  @@getTokeType74:
  1987 0000185B 8A46FE                   mov al, byte [bp-2]
  1988 0000185E B400                     mov ah, 0
  1989 00001860 50                       push ax
  1990 00001861 E82A05                   call letterE
  1991 00001864 83C402                   add  sp, 2
  1992 00001867 08C0                     or  al, al
  1993 00001869 0F841800                 je @@getTokeType75
  1994 0000186D 8A46FE                   mov al, byte [bp-2]
  1995 00001870 B400                     mov ah, 0
  1996 00001872 50                       push ax
  1997 00001873 E84A06                   call getName
  1998 00001876 83C402                   add  sp, 2
  1999 00001879 66B803000000             mov eax, 3
  2000 0000187F A2[AB01]                 mov byte [TokeType], al
  2001 00001882 E90C00                   jmp @@retn
  2002                                  
  2003                                  ;-34   TokeType=NOALNUME; return;
  2004                                  
  2005                                  @@getTokeType75:
  2006 00001885 66B804000000             mov eax, 4
  2007 0000188B A2[AB01]                 mov byte [TokeType], al
  2008 0000188E E90000                   jmp @@retn
  2009                                  
  2010                                  ;-35 }
  2011                                  
  2012                                  
  2013                                  ;-36 int storeLabel() {unsigned int i;
  2014                                  
  2015 00001891 C9                      @@retn: LEAVE
  2016 00001892 C3                       ret
  2017                                  ; ENDP
  2018                                  
  2019                                  storeLabel:  ; *** PROC ***
  2020                                  
  2021                                  ;-37   if(searchLabel()) error1("duplicate label");
  2022                                  
  2023                                  ;Function : storeLabel, Number of local variables: 1
  2024                                  ;   # type sign width line used address name   list of local variables
  2025                                  ;  200 var unsg word    36 NULL bp-2    i;
  2026 00001893 C8020000                 ENTER  2,0
  2027 00001897 E89C00                   call searchLabel
  2028 0000189A 08C0                     or  al, al
  2029 0000189C 0F840900                 je @@storeLabel76
  2030 000018A0 68[0119]                 push storeLabel_0
  2031 000018A3 E87D0D                   call error1
  2032 000018A6 83C402                   add  sp, 2
  2033                                  
  2034                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2035                                  
  2036                                  @@storeLabel76:
  2037 000018A9 8D06[0F00]               lea  ax, [Symbol]
  2038 000018AD 50                       push ax
  2039 000018AE FF36[B205]               push word [LabelNamePtr]
  2040 000018B2 E8A41B                   call strcpy
  2041 000018B5 83C404                   add  sp, 4
  2042 000018B8 A3[B205]                 mov word [LabelNamePtr], ax
  2043                                  
  2044                                  ;-39   LabelNamePtr++;
  2045                                  
  2046 000018BB FF06[B205]               inc  word [LabelNamePtr]
  2047                                  
  2048                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  2049                                  
  2050 000018BF A1[B205]                 mov ax, [LabelNamePtr]
  2051 000018C2 2D[CA01]                 sub ax, LabelNames
  2052 000018C5 8946FE                   mov word [bp-2], ax
  2053                                  
  2054                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  2055                                  
  2056 000018C8 8B46FE                   mov ax, [bp-2]
  2057 000018CB 3DC903                   cmp ax, 969 ;unsigned : 0
  2058 000018CE 0F820900                 jb  @@storeLabel77
  2059 000018D2 68[1119]                 push storeLabel_1
  2060 000018D5 E8AA0D                   call errorexit
  2061 000018D8 83C402                   add  sp, 2
  2062                                  
  2063                                  ;-42   LabelMaxIx++;
  2064                                  
  2065                                  @@storeLabel77:
  2066 000018DB FF06[7C06]               inc  word [LabelMaxIx]
  2067                                  
  2068                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2069                                  
  2070 000018DF A1[7C06]                 mov ax, [LabelMaxIx]
  2071 000018E2 83F864                   cmp ax, 100 ;unsigned : 1
  2072 000018E5 0F8C0900                 jl  @@storeLabel78
  2073 000018E9 68[2619]                 push storeLabel_2
  2074 000018EC E8930D                   call errorexit
  2075 000018EF 83C402                   add  sp, 2
  2076                                  
  2077                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  2078                                  
  2079                                  @@storeLabel78:
  2080 000018F2 A1[A601]                 mov ax, [PC]
  2081 000018F5 8B1E[7C06]               mov bx, [LabelMaxIx]
  2082 000018F9 D1E3                     shl bx, 1
  2083 000018FB 8987[B405]               mov [LabelAddr+bx], ax
  2084                                  
  2085                                  ;-45 }
  2086                                  
  2087                                  
  2088                                  ;-46 int searchLabel() {
  2089 000018FF C9                       LEAVE
  2090 00001900 C3                       ret
  2091                                  ; ENDP
  2092 00001901 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2093 0000190A 206C6162656C00     
  2094 00001911 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  2095 0000191A 6C6162656C206E616D-
  2096 00001923 657300             
  2097 00001926 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  2098 0000192F 6C6162656C7300     
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
  2112 00001936 C8060000                 ENTER  6,0
  2113 0000193A B8[CA01]                 mov ax, LabelNames
  2114 0000193D 8946FC                   mov word [bp-4], ax
  2115                                  
  2116                                  ;-49   LIx=1;
  2117                                  
  2118 00001940 66B801000000             mov eax, 1
  2119 00001946 8946FE                   mov word [bp-2], ax
  2120                                  
  2121                                  ;-50   while (LIx <= LabelMaxIx) {
  2122                                  
  2123                                  @@searchLabel79:
  2124 00001949 8B46FE                   mov ax, [bp-2]
  2125 0000194C 3B06[7C06]               cmp ax, [LabelMaxIx]
  2126 00001950 0F8F3700                 jg  @@searchLabel80
  2127                                  
  2128                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  2129                                  
  2130 00001954 8D06[0F00]               lea  ax, [Symbol]
  2131 00001958 50                       push ax
  2132 00001959 FF76FC                   push word [bp-4]
  2133 0000195C E8661B                   call eqstr
  2134 0000195F 83C404                   add  sp, 4
  2135 00001962 08C0                     or  al, al
  2136 00001964 0F840600                 je @@searchLabel81
  2137 00001968 8B46FE                   mov ax, [bp-2]
  2138 0000196B E92600                   jmp @@retn
  2139                                  
  2140                                  ;-52     j=strlen(p);
  2141                                  
  2142                                  @@searchLabel81:
  2143 0000196E FF76FC                   push word [bp-4]
  2144 00001971 E8BA1A                   call strlen
  2145 00001974 83C402                   add  sp, 2
  2146 00001977 8946FA                   mov word [bp-6], ax
  2147                                  
  2148                                  ;-53     p=p+j; p++; LIx++;
  2149                                  
  2150 0000197A 8B46FC                   mov ax, [bp-4]
  2151 0000197D 0346FA                   add ax, [bp-6]
  2152 00001980 8946FC                   mov word [bp-4], ax
  2153 00001983 FF46FC                   inc  word [bp-4]
  2154 00001986 FF46FE                   inc  word [bp-2]
  2155                                  
  2156                                  ;-54   }
  2157                                  
  2158                                  
  2159                                  ;-55   return 0;
  2160                                  
  2161 00001989 EBBE                     jmp @@searchLabel79
  2162                                  @@searchLabel80:
  2163 0000198B 66B800000000             mov eax, 0
  2164 00001991 E90000                   jmp @@retn
  2165                                  
  2166                                  ;-56 }
  2167                                  
  2168                                  
  2169                                  ;-57 int getVariable() { char c;
  2170                                  
  2171 00001994 C9                      @@retn: LEAVE
  2172 00001995 C3                       ret
  2173                                  ; ENDP
  2174                                  
  2175                                  getVariable:  ; *** PROC ***
  2176                                  
  2177                                  ;-58   storeLabel();
  2178                                  
  2179                                  ;Function : getVariable, Number of local variables: 1
  2180                                  ;   # type sign width line used address name   list of local variables
  2181                                  ;  200 var sign byte    57 NULL bp-2    c;
  2182 00001996 C8020000                 ENTER  2,0
  2183 0000199A E8F6FE                   call storeLabel
  2184                                  
  2185                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  2186                                  
  2187 0000199D E855FE                   call getTokeType
  2188 000019A0 A0[AB01]                 mov al, [TokeType]
  2189 000019A3 3C03                     cmp al, 3
  2190 000019A5 0F85CC00                 jne @@getVariable82
  2191                                  
  2192                                  ;-60     lookCode();
  2193                                  
  2194 000019A9 E82201                   call lookCode
  2195                                  
  2196                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2197                                  
  2198 000019AC A0[AE01]                 mov al, [CodeType]
  2199 000019AF 3CC8                     cmp al, 200
  2200 000019B1 0F8D0900                 jge @@getVariable83
  2201 000019B5 68[801A]                 push getVariable_0
  2202 000019B8 E8C70C                   call errorexit
  2203 000019BB 83C402                   add  sp, 2
  2204                                  
  2205                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2206                                  
  2207                                  @@getVariable83:
  2208 000019BE A0[AE01]                 mov al, [CodeType]
  2209 000019C1 3CCF                     cmp al, 207
  2210 000019C3 0F8E0900                 jle @@getVariable84
  2211 000019C7 68[981A]                 push getVariable_1
  2212 000019CA E8B50C                   call errorexit
  2213 000019CD 83C402                   add  sp, 2
  2214                                  
  2215                                  ;-63     if (CodeType== 200) {// DB
  2216                                  
  2217                                  @@getVariable84:
  2218 000019D0 A0[AE01]                 mov al, [CodeType]
  2219 000019D3 3CC8                     cmp al, 200
  2220 000019D5 0F856A00                 jne @@getVariable85
  2221                                  
  2222                                  ;-64       do { getTokeType();
  2223                                  
  2224                                  @@getVariable86:
  2225 000019D9 E819FE                   call getTokeType
  2226                                  
  2227                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  2228                                  
  2229 000019DC A0[AB01]                 mov al, [TokeType]
  2230 000019DF 3C01                     cmp al, 1
  2231 000019E1 0F850D00                 jne @@getVariable87
  2232 000019E5 FF36[4D00]               push word [SymbolInt]
  2233 000019E9 E80C12                   call genCode8
  2234 000019EC 83C402                   add  sp, 2
  2235                                  
  2236                                  ;-66         else {
  2237                                  
  2238 000019EF E94100                   jmp @@getVariable88
  2239                                  @@getVariable87:
  2240                                  
  2241                                  ;-67           skipBlank();
  2242                                  
  2243 000019F2 E86E03                   call skipBlank
  2244                                  
  2245                                  ;-68           if (isToken('"')) {
  2246                                  
  2247 000019F5 6A22                     push 34
  2248 000019F7 E8D101                   call isToken
  2249 000019FA 83C402                   add  sp, 2
  2250 000019FD 08C0                     or  al, al
  2251 000019FF 0F843000                 je @@getVariable89
  2252                                  
  2253                                  ;-69             do { c= *InputPtr;
  2254                                  
  2255                                  @@getVariable90:
  2256 00001A03 8B1E[CE00]               mov bx, [InputPtr]
  2257 00001A07 8A07                     mov al, [bx]
  2258 00001A09 B400                     mov ah, 0
  2259 00001A0B 8846FE                   mov byte [bp-2], al
  2260                                  
  2261                                  ;-70               genCode8(c);
  2262                                  
  2263 00001A0E 8A46FE                   mov al, byte [bp-2]
  2264 00001A11 B400                     mov ah, 0
  2265 00001A13 50                       push ax
  2266 00001A14 E8E111                   call genCode8
  2267 00001A17 83C402                   add  sp, 2
  2268                                  
  2269                                  ;-71               InputPtr++;
  2270                                  
  2271 00001A1A FF06[CE00]               inc  word [InputPtr]
  2272                                  
  2273                                  ;-72             } while (*InputPtr != '"' );
  2274                                  
  2275 00001A1E 8B1E[CE00]               mov bx, [InputPtr]
  2276 00001A22 8A07                     mov al, [bx]
  2277 00001A24 B400                     mov ah, 0
  2278 00001A26 83F822                   cmp ax, 34
  2279 00001A29 0F840200                 je  @@getVariable91
  2280 00001A2D EBD4                     jmp @@getVariable90
  2281                                  @@getVariable91:
  2282                                  
  2283                                  ;-73             InputPtr++;
  2284                                  
  2285 00001A2F FF06[CE00]               inc  word [InputPtr]
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
  2297 00001A33 6A2C                     push 44
  2298 00001A35 E89301                   call isToken
  2299 00001A38 83C402                   add  sp, 2
  2300 00001A3B 08C0                     or  al, al
  2301 00001A3D 0F840200                 je @@getVariable92
  2302 00001A41 EB96                     jmp @@getVariable86
  2303                                  @@getVariable92:
  2304                                  
  2305                                  ;-77     }
  2306                                  
  2307                                  
  2308                                  ;-78     if (CodeType== 201) {// DW
  2309                                  
  2310                                  @@getVariable85:
  2311 00001A43 A0[AE01]                 mov al, [CodeType]
  2312 00001A46 3CC9                     cmp al, 201
  2313 00001A48 0F852600                 jne @@getVariable93
  2314                                  
  2315                                  ;-79       do { getTokeType();
  2316                                  
  2317                                  @@getVariable94:
  2318 00001A4C E8A6FD                   call getTokeType
  2319                                  
  2320                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  2321                                  
  2322 00001A4F A0[AB01]                 mov al, [TokeType]
  2323 00001A52 3C01                     cmp al, 1
  2324 00001A54 0F850A00                 jne @@getVariable95
  2325 00001A58 FF36[4D00]               push word [SymbolInt]
  2326 00001A5C E8F011                   call genCode16
  2327 00001A5F 83C402                   add  sp, 2
  2328                                  
  2329                                  ;-81       } while (isToken(','));
  2330                                  
  2331                                  @@getVariable95:
  2332 00001A62 6A2C                     push 44
  2333 00001A64 E86401                   call isToken
  2334 00001A67 83C402                   add  sp, 2
  2335 00001A6A 08C0                     or  al, al
  2336 00001A6C 0F840200                 je @@getVariable96
  2337 00001A70 EBDA                     jmp @@getVariable94
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
  2349 00001A72 E90900                   jmp @@getVariable97
  2350                                  @@getVariable82:
  2351 00001A75 68[B01A]                 push getVariable_2
  2352 00001A78 E8070C                   call errorexit
  2353 00001A7B 83C402                   add  sp, 2
  2354                                  
  2355                                  ;-85 }
  2356                                  
  2357                                  @@getVariable97:
  2358                                  
  2359                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  2360 00001A7E C9                       LEAVE
  2361 00001A7F C3                       ret
  2362                                  ; ENDP
  2363 00001A80 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2364 00001A89 422C572C4420657870-
  2365 00001A92 656374656400       
  2366 00001A98 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2367 00001AA1 422C572C4420657870-
  2368 00001AAA 656374656400       
  2369 00001AB0 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2370 00001AB9 6F7220524553422C57-
  2371 00001AC2 2C4420657870656374-
  2372 00001ACB 656400             
  2373                                  
  2374                                  lookCode:  ; *** PROC ***
  2375                                  
  2376                                  ;-87   CodeType=0;
  2377                                  
  2378 00001ACE 66B800000000             mov eax, 0
  2379 00001AD4 A2[AE01]                 mov byte [CodeType], al
  2380                                  
  2381                                  ;-88   OpCodePtr= &I_START;
  2382                                  
  2383 00001AD7 B8[560E]                 mov ax, I_START
  2384 00001ADA A3[C701]                 mov word [OpCodePtr], ax
  2385                                  
  2386                                  ;-89   OpCodePtr++;
  2387                                  
  2388 00001ADD FF06[C701]               inc  word [OpCodePtr]
  2389                                  
  2390                                  ;-90   do  {
  2391                                  
  2392                                  @@lookCode98:
  2393                                  
  2394                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  2395                                  
  2396 00001AE1 FF36[C701]               push word [OpCodePtr]
  2397 00001AE5 8D06[2E00]               lea  ax, [SymbolUpper]
  2398 00001AE9 50                       push ax
  2399 00001AEA E8D819                   call eqstr
  2400 00001AED 83C404                   add  sp, 4
  2401 00001AF0 08C0                     or  al, al
  2402 00001AF2 0F842700                 je @@lookCode99
  2403                                  
  2404                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  2405                                  
  2406                                  @@lookCode100:
  2407 00001AF6 8B1E[C701]               mov bx, [OpCodePtr]
  2408 00001AFA 8A07                     mov al, [bx]
  2409 00001AFC B400                     mov ah, 0
  2410 00001AFE 83F800                   cmp ax, 0
  2411 00001B01 0F840600                 je  @@lookCode101
  2412 00001B05 FF06[C701]               inc  word [OpCodePtr]
  2413                                  
  2414                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  2415                                  
  2416 00001B09 EBEB                     jmp @@lookCode100
  2417                                  @@lookCode101:
  2418 00001B0B FF06[C701]               inc  word [OpCodePtr]
  2419 00001B0F 8B1E[C701]               mov bx, [OpCodePtr]
  2420 00001B13 8A07                     mov al, [bx]
  2421 00001B15 B400                     mov ah, 0
  2422 00001B17 A2[AE01]                 mov byte [CodeType], al
  2423                                  
  2424                                  ;-94       return;
  2425                                  
  2426 00001B1A E92A00                   jmp @@retn
  2427                                  
  2428                                  ;-95     }
  2429                                  
  2430                                  
  2431                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  2432                                  
  2433                                  @@lookCode99:
  2434                                  @@lookCode102:
  2435 00001B1D 8B1E[C701]               mov bx, [OpCodePtr]
  2436 00001B21 8A07                     mov al, [bx]
  2437 00001B23 B400                     mov ah, 0
  2438 00001B25 3DF100                   cmp ax, 241
  2439 00001B28 0F840600                 je  @@lookCode103
  2440 00001B2C FF06[C701]               inc  word [OpCodePtr]
  2441                                  
  2442                                  ;-97   OpCodePtr++;
  2443                                  
  2444 00001B30 EBEB                     jmp @@lookCode102
  2445                                  @@lookCode103:
  2446 00001B32 FF06[C701]               inc  word [OpCodePtr]
  2447                                  
  2448                                  ;-98   } while(*OpCodePtr!=0);
  2449                                  
  2450 00001B36 8B1E[C701]               mov bx, [OpCodePtr]
  2451 00001B3A 8A07                     mov al, [bx]
  2452 00001B3C B400                     mov ah, 0
  2453 00001B3E 83F800                   cmp ax, 0
  2454 00001B41 0F840200                 je  @@lookCode104
  2455 00001B45 EB9A                     jmp @@lookCode98
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
  2467 00001B47 C3                       ret
  2468                                  ; ENDP
  2469                                  
  2470                                  getCodeSize:  ; *** PROC ***
  2471                                  
  2472                                  ;-102   if (TokeType ==ALNUME) {
  2473                                  
  2474 00001B48 A0[AB01]                 mov al, [TokeType]
  2475 00001B4B 3C03                     cmp al, 3
  2476 00001B4D 0F856000                 jne @@getCodeSize105
  2477                                  
  2478                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2479                                  
  2480 00001B51 68[BB1B]                 push getCodeSize_0
  2481 00001B54 8D06[2E00]               lea  ax, [SymbolUpper]
  2482 00001B58 50                       push ax
  2483 00001B59 E86919                   call eqstr
  2484 00001B5C 83C404                   add  sp, 4
  2485 00001B5F 08C0                     or  al, al
  2486 00001B61 0F840C00                 je @@getCodeSize106
  2487 00001B65 E88DFC                   call getTokeType
  2488 00001B68 66B801000000             mov eax, 1
  2489 00001B6E E94900                   jmp @@retn
  2490                                  
  2491                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2492                                  
  2493                                  @@getCodeSize106:
  2494 00001B71 68[C01B]                 push getCodeSize_1
  2495 00001B74 8D06[2E00]               lea  ax, [SymbolUpper]
  2496 00001B78 50                       push ax
  2497 00001B79 E84919                   call eqstr
  2498 00001B7C 83C404                   add  sp, 4
  2499 00001B7F 08C0                     or  al, al
  2500 00001B81 0F840C00                 je @@getCodeSize107
  2501 00001B85 E86DFC                   call getTokeType
  2502 00001B88 66B802000000             mov eax, 2
  2503 00001B8E E92900                   jmp @@retn
  2504                                  
  2505                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2506                                  
  2507                                  @@getCodeSize107:
  2508 00001B91 68[C51B]                 push getCodeSize_2
  2509 00001B94 8D06[2E00]               lea  ax, [SymbolUpper]
  2510 00001B98 50                       push ax
  2511 00001B99 E82919                   call eqstr
  2512 00001B9C 83C404                   add  sp, 4
  2513 00001B9F 08C0                     or  al, al
  2514 00001BA1 0F840C00                 je @@getCodeSize108
  2515 00001BA5 E84DFC                   call getTokeType
  2516 00001BA8 66B803000000             mov eax, 3
  2517 00001BAE E90900                   jmp @@retn
  2518                                  
  2519                                  ;-106   } return 0;
  2520                                  
  2521                                  @@getCodeSize108:
  2522                                  @@getCodeSize105:
  2523 00001BB1 66B800000000             mov eax, 0
  2524 00001BB7 E90000                   jmp @@retn
  2525                                  
  2526                                  ;-107 }
  2527                                  
  2528                                  
  2529                                  ;-108 int isToken(char c) {
  2530                                  
  2531                                  @@retn:
  2532 00001BBA C3                       ret
  2533                                  ; ENDP
  2534 00001BBB 4259544500              getCodeSize_0 db "BYTE",0
  2535 00001BC0 574F524400              getCodeSize_1 db "WORD",0
  2536 00001BC5 44574F524400            getCodeSize_2 db "DWORD",0
  2537                                  
  2538                                  isToken:  ; *** PROC ***
  2539                                  
  2540                                  ;-109   skipBlank();
  2541                                  
  2542                                  ;Function : isToken, Number of local variables: 1
  2543                                  ;   # type sign width line used address name   list of local variables
  2544                                  ;  200 var sign byte   108 NULL bp+4    c;
  2545 00001BCB C8000000                 ENTER  0,0
  2546 00001BCF E89101                   call skipBlank
  2547                                  
  2548                                  ;-110   if (*InputPtr == c) {
  2549                                  
  2550 00001BD2 8B1E[CE00]               mov bx, [InputPtr]
  2551 00001BD6 8A07                     mov al, [bx]
  2552 00001BD8 B400                     mov ah, 0
  2553 00001BDA 3A4604                   cmp al, [bp+4]
  2554 00001BDD 0F850D00                 jne @@isToken109
  2555                                  
  2556                                  ;-111     InputPtr++; return 1;} return 0;
  2557                                  
  2558 00001BE1 FF06[CE00]               inc  word [InputPtr]
  2559 00001BE5 66B801000000             mov eax, 1
  2560 00001BEB E90900                   jmp @@retn
  2561                                  @@isToken109:
  2562 00001BEE 66B800000000             mov eax, 0
  2563 00001BF4 E90000                   jmp @@retn
  2564                                  
  2565                                  ;-112 }
  2566                                  
  2567                                  
  2568                                  ;-113 int need(char c) {
  2569                                  
  2570 00001BF7 C9                      @@retn: LEAVE
  2571 00001BF8 C3                       ret
  2572                                  ; ENDP
  2573                                  
  2574                                  need:  ; *** PROC ***
  2575                                  
  2576                                  ;-114   if (isToken(c)) {
  2577                                  
  2578                                  ;Function : need, Number of local variables: 1
  2579                                  ;   # type sign width line used address name   list of local variables
  2580                                  ;  200 var sign byte   113 NULL bp+4    c;
  2581 00001BF9 C8000000                 ENTER  0,0
  2582 00001BFD 8A4604                   mov al, byte [bp+4]
  2583 00001C00 B400                     mov ah, 0
  2584 00001C02 50                       push ax
  2585 00001C03 E8C5FF                   call isToken
  2586 00001C06 83C402                   add  sp, 2
  2587 00001C09 08C0                     or  al, al
  2588 00001C0B 0F840600                 je @@need110
  2589                                  
  2590                                  ;-115       getTokeType();
  2591                                  
  2592 00001C0F E8E3FB                   call getTokeType
  2593                                  
  2594                                  ;-116       return;
  2595                                  
  2596 00001C12 E91800                   jmp @@retn
  2597                                  
  2598                                  ;-117       }
  2599                                  
  2600                                  
  2601                                  ;-118   error1();
  2602                                  
  2603                                  @@need110:
  2604 00001C15 E80B0A                   call error1
  2605                                  
  2606                                  ;-119   prs(". need: ");
  2607                                  
  2608 00001C18 68[2F1C]                 push need_0
  2609 00001C1B E8A408                   call prs
  2610 00001C1E 83C402                   add  sp, 2
  2611                                  
  2612                                  ;-120   prc(c);
  2613                                  
  2614 00001C21 8A4604                   mov al, byte [bp+4]
  2615 00001C24 B400                     mov ah, 0
  2616 00001C26 50                       push ax
  2617 00001C27 E83708                   call prc
  2618 00001C2A 83C402                   add  sp, 2
  2619                                  
  2620                                  ;-121 }
  2621                                  
  2622                                  
  2623                                  ;-122 
  2624                                  
  2625                                  
  2626                                  ;-123 int skipRest() {
  2627                                  
  2628 00001C2D C9                      @@retn: LEAVE
  2629 00001C2E C3                       ret
  2630                                  ; ENDP
  2631 00001C2F 2E206E6565643A2000      need_0 db ". need: ",0
  2632                                  
  2633                                  skipRest:  ; *** PROC ***
  2634                                  
  2635                                  ;-124   getTokeType(); 
  2636                                  
  2637 00001C38 E8BAFB                   call getTokeType
  2638                                  
  2639                                  ;-125   if(TokeType)error1("extra char ignored");
  2640                                  
  2641 00001C3B A0[AB01]                 mov al, [TokeType]
  2642 00001C3E 08C0                     or  al, al
  2643 00001C40 0F840900                 je @@skipRest111
  2644 00001C44 68[4E1C]                 push skipRest_0
  2645 00001C47 E8D909                   call error1
  2646 00001C4A 83C402                   add  sp, 2
  2647                                  
  2648                                  ;-126 }
  2649                                  
  2650                                  @@skipRest111:
  2651 00001C4D C3                       ret
  2652                                  ; ENDP
  2653 00001C4E 657874726120636861-     skipRest_0 db "extra char ignored",0
  2654 00001C57 722069676E6F726564-
  2655 00001C60 00                 
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
  2675 00001C61 C8020000                 ENTER  2,0
  2676 00001C65 B8[4F00]                 mov ax, InputBuf
  2677 00001C68 A3[CE00]                 mov word [InputPtr], ax
  2678                                  
  2679                                  ;-4   *InputPtr=0;//if last line is empty
  2680                                  
  2681 00001C6B 66B800000000             mov eax, 0
  2682 00001C71 8B1E[CE00]               mov  bx, [InputPtr]
  2683 00001C75 8807                     mov  [bx], al
  2684                                  
  2685                                  ;-5   do {
  2686                                  
  2687                                  @@getLine112:
  2688                                  
  2689                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2690                                  
  2691 00001C77 6A01                     push 1
  2692 00001C79 FF36[9901]               push word [asm_fd]
  2693 00001C7D 8D06[A501]               lea  ax, [DOS_ByteRead]
  2694 00001C81 50                       push ax
  2695 00001C82 E8DB18                   call readRL
  2696 00001C85 83C406                   add  sp, 6
  2697 00001C88 A3[A301]                 mov word [DOS_NoBytes], ax
  2698                                  
  2699                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2700                                  
  2701 00001C8B A1[9F01]                 mov ax, [DOS_ERR]
  2702 00001C8E 08C0                     or  al, al
  2703 00001C90 0F840900                 je @@getLine113
  2704 00001C94 68[F91C]                 push getLine_0
  2705 00001C97 E8E809                   call errorexit
  2706 00001C9A 83C402                   add  sp, 2
  2707                                  
  2708                                  ;-8     if (DOS_NoBytes == 0) return;
  2709                                  
  2710                                  @@getLine113:
  2711 00001C9D A1[A301]                 mov ax, [DOS_NoBytes]
  2712 00001CA0 83F800                   cmp ax, 0
  2713 00001CA3 0F850300                 jne @@getLine114
  2714 00001CA7 E94D00                   jmp @@retn
  2715                                  
  2716                                  ;-9     *InputPtr = DOS_ByteRead;
  2717                                  
  2718                                  @@getLine114:
  2719 00001CAA A0[A501]                 mov al, [DOS_ByteRead]
  2720 00001CAD 8B1E[CE00]               mov  bx, [InputPtr]
  2721 00001CB1 8807                     mov  [bx], al
  2722                                  
  2723                                  ;-10     InputPtr++;
  2724                                  
  2725 00001CB3 FF06[CE00]               inc  word [InputPtr]
  2726                                  
  2727                                  ;-11     i = InputPtr - &InputBuf;
  2728                                  
  2729 00001CB7 A1[CE00]                 mov ax, [InputPtr]
  2730 00001CBA 2D[4F00]                 sub ax, InputBuf
  2731 00001CBD 8946FE                   mov word [bp-2], ax
  2732                                  
  2733                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2734                                  
  2735 00001CC0 8B46FE                   mov ax, [bp-2]
  2736 00001CC3 83F87F                   cmp ax, 127 ;unsigned : 0
  2737 00001CC6 0F820900                 jb  @@getLine115
  2738 00001CCA 68[081D]                 push getLine_1
  2739 00001CCD E8B209                   call errorexit
  2740 00001CD0 83C402                   add  sp, 2
  2741                                  
  2742                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2743                                  
  2744                                  @@getLine115:
  2745 00001CD3 A0[A501]                 mov al, byte [DOS_ByteRead]
  2746 00001CD6 B400                     mov ah, 0
  2747 00001CD8 50                       push ax
  2748 00001CD9 E84000                   call ifEOL
  2749 00001CDC 83C402                   add  sp, 2
  2750 00001CDF 3C00                     cmp al, 0
  2751 00001CE1 0F850200                 jne @@getLine116
  2752 00001CE5 EB90                     jmp @@getLine112
  2753                                  @@getLine116:
  2754                                  
  2755                                  ;-14   InputPtr--;
  2756                                  
  2757 00001CE7 FF0E[CE00]               dec  word [InputPtr]
  2758                                  
  2759                                  ;-15   *InputPtr=0;
  2760                                  
  2761 00001CEB 66B800000000             mov eax, 0
  2762 00001CF1 8B1E[CE00]               mov  bx, [InputPtr]
  2763 00001CF5 8807                     mov  [bx], al
  2764                                  
  2765                                  ;-16 }
  2766                                  
  2767                                  
  2768                                  ;-17 int ifEOL(char c) {
  2769                                  
  2770 00001CF7 C9                      @@retn: LEAVE
  2771 00001CF8 C3                       ret
  2772                                  ; ENDP
  2773 00001CF9 52656164696E672053-     getLine_0 db "Reading Source",0
  2774 00001D02 6F7572636500       
  2775 00001D08 696E707574206C696E-     getLine_1 db "input line too long",0
  2776 00001D11 6520746F6F206C6F6E-
  2777 00001D1A 6700               
  2778                                  
  2779                                  ifEOL:  ; *** PROC ***
  2780                                  
  2781                                  ;-18   if (c == 10) return 1;
  2782                                  
  2783                                  ;Function : ifEOL, Number of local variables: 1
  2784                                  ;   # type sign width line used address name   list of local variables
  2785                                  ;  200 var sign byte    17 NULL bp+4    c;
  2786 00001D1C C8000000                 ENTER  0,0
  2787 00001D20 8A4604                   mov al, [bp+4]
  2788 00001D23 3C0A                     cmp al, 10
  2789 00001D25 0F850900                 jne @@ifEOL117
  2790 00001D29 66B801000000             mov eax, 1
  2791 00001D2F E92F00                   jmp @@retn
  2792                                  
  2793                                  ;-19   if (c == 13) {
  2794                                  
  2795                                  @@ifEOL117:
  2796 00001D32 8A4604                   mov al, [bp+4]
  2797 00001D35 3C0D                     cmp al, 13
  2798 00001D37 0F851D00                 jne @@ifEOL118
  2799                                  
  2800                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2801                                  
  2802 00001D3B 6A01                     push 1
  2803 00001D3D FF36[9901]               push word [asm_fd]
  2804 00001D41 8D06[A501]               lea  ax, [DOS_ByteRead]
  2805 00001D45 50                       push ax
  2806 00001D46 E81718                   call readRL
  2807 00001D49 83C406                   add  sp, 6
  2808 00001D4C A3[A301]                 mov word [DOS_NoBytes], ax
  2809                                  
  2810                                  ;-21     return 1;}
  2811                                  
  2812 00001D4F 66B801000000             mov eax, 1
  2813 00001D55 E90900                   jmp @@retn
  2814                                  
  2815                                  ;-22   return 0;
  2816                                  
  2817                                  @@ifEOL118:
  2818 00001D58 66B800000000             mov eax, 0
  2819 00001D5E E90000                   jmp @@retn
  2820                                  
  2821                                  ;-23 }
  2822                                  
  2823                                  
  2824                                  ;-24 int skipBlank() {
  2825                                  
  2826 00001D61 C9                      @@retn: LEAVE
  2827 00001D62 C3                       ret
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
  2838 00001D63 8B1E[CE00]               mov bx, [InputPtr]
  2839 00001D67 8A07                     mov al, [bx]
  2840 00001D69 B400                     mov ah, 0
  2841 00001D6B 83F820                   cmp ax, 32
  2842 00001D6E 0F850600                 jne @@skipBlank119
  2843 00001D72 FF06[CE00]               inc  word [InputPtr]
  2844 00001D76 EBEB                     jmp @@skipblank1
  2845                                  
  2846                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2847                                  
  2848                                  @@skipBlank119:
  2849 00001D78 8B1E[CE00]               mov bx, [InputPtr]
  2850 00001D7C 8A07                     mov al, [bx]
  2851 00001D7E B400                     mov ah, 0
  2852 00001D80 83F809                   cmp ax, 9
  2853 00001D83 0F850600                 jne @@skipBlank120
  2854 00001D87 FF06[CE00]               inc  word [InputPtr]
  2855 00001D8B EBD6                     jmp @@skipblank1
  2856                                  
  2857                                  ;-28 }
  2858                                  
  2859                                  @@skipBlank120:
  2860                                  
  2861                                  ;-29 int letterE(char c) {
  2862                                  
  2863 00001D8D C3                       ret
  2864                                  ; ENDP
  2865                                  
  2866                                  letterE:  ; *** PROC ***
  2867                                  
  2868                                  ;-30   if (c=='_') return 1;
  2869                                  
  2870                                  ;Function : letterE, Number of local variables: 1
  2871                                  ;   # type sign width line used address name   list of local variables
  2872                                  ;  200 var sign byte    29 NULL bp+4    c;
  2873 00001D8E C8000000                 ENTER  0,0
  2874 00001D92 8A4604                   mov al, [bp+4]
  2875 00001D95 3C5F                     cmp al, 95
  2876 00001D97 0F850900                 jne @@letterE121
  2877 00001D9B 66B801000000             mov eax, 1
  2878 00001DA1 E97E00                   jmp @@retn
  2879                                  
  2880                                  ;-31   if (c=='.') return 1;
  2881                                  
  2882                                  @@letterE121:
  2883 00001DA4 8A4604                   mov al, [bp+4]
  2884 00001DA7 3C2E                     cmp al, 46
  2885 00001DA9 0F850900                 jne @@letterE122
  2886 00001DAD 66B801000000             mov eax, 1
  2887 00001DB3 E96C00                   jmp @@retn
  2888                                  
  2889                                  ;-32   if (c=='?') return 1;
  2890                                  
  2891                                  @@letterE122:
  2892 00001DB6 8A4604                   mov al, [bp+4]
  2893 00001DB9 3C3F                     cmp al, 63
  2894 00001DBB 0F850900                 jne @@letterE123
  2895 00001DBF 66B801000000             mov eax, 1
  2896 00001DC5 E95A00                   jmp @@retn
  2897                                  
  2898                                  ;-33   if (c=='$') return 1;
  2899                                  
  2900                                  @@letterE123:
  2901 00001DC8 8A4604                   mov al, [bp+4]
  2902 00001DCB 3C24                     cmp al, 36
  2903 00001DCD 0F850900                 jne @@letterE124
  2904 00001DD1 66B801000000             mov eax, 1
  2905 00001DD7 E94800                   jmp @@retn
  2906                                  
  2907                                  ;-34   if (c> 'z') return 0;
  2908                                  
  2909                                  @@letterE124:
  2910 00001DDA 8A4604                   mov al, [bp+4]
  2911 00001DDD 3C7A                     cmp al, 122
  2912 00001DDF 0F8E0900                 jle @@letterE125
  2913 00001DE3 66B800000000             mov eax, 0
  2914 00001DE9 E93600                   jmp @@retn
  2915                                  
  2916                                  ;-35   if (c< '@') return 0; // at included
  2917                                  
  2918                                  @@letterE125:
  2919 00001DEC 8A4604                   mov al, [bp+4]
  2920 00001DEF 3C40                     cmp al, 64
  2921 00001DF1 0F8D0900                 jge @@letterE126
  2922 00001DF5 66B800000000             mov eax, 0
  2923 00001DFB E92400                   jmp @@retn
  2924                                  
  2925                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2926                                  
  2927                                  @@letterE126:
  2928 00001DFE 8A4604                   mov al, [bp+4]
  2929 00001E01 3C5A                     cmp al, 90
  2930 00001E03 0F8E1200                 jle @@letterE127
  2931 00001E07 8A4604                   mov al, [bp+4]
  2932 00001E0A 3C61                     cmp al, 97
  2933 00001E0C 0F8D0900                 jge @@letterE128
  2934 00001E10 66B800000000             mov eax, 0
  2935 00001E16 E90900                   jmp @@retn
  2936                                  @@letterE128:
  2937                                  
  2938                                  ;-37   return 1;
  2939                                  
  2940                                  @@letterE127:
  2941 00001E19 66B801000000             mov eax, 1
  2942 00001E1F E90000                   jmp @@retn
  2943                                  
  2944                                  ;-38 }
  2945                                  
  2946                                  
  2947                                  ;-39 int alnumE(char c) {
  2948                                  
  2949 00001E22 C9                      @@retn: LEAVE
  2950 00001E23 C3                       ret
  2951                                  ; ENDP
  2952                                  
  2953                                  alnumE:  ; *** PROC ***
  2954                                  
  2955                                  ;-40   if (digit(c)) return 1;
  2956                                  
  2957                                  ;Function : alnumE, Number of local variables: 1
  2958                                  ;   # type sign width line used address name   list of local variables
  2959                                  ;  200 var sign byte    39 NULL bp+4    c;
  2960 00001E24 C8000000                 ENTER  0,0
  2961 00001E28 8A4604                   mov al, byte [bp+4]
  2962 00001E2B B400                     mov ah, 0
  2963 00001E2D 50                       push ax
  2964 00001E2E E86116                   call digit
  2965 00001E31 83C402                   add  sp, 2
  2966 00001E34 08C0                     or  al, al
  2967 00001E36 0F840900                 je @@alnumE129
  2968 00001E3A 66B801000000             mov eax, 1
  2969 00001E40 E92400                   jmp @@retn
  2970                                  
  2971                                  ;-41   if (letterE(c)) return 1;
  2972                                  
  2973                                  @@alnumE129:
  2974 00001E43 8A4604                   mov al, byte [bp+4]
  2975 00001E46 B400                     mov ah, 0
  2976 00001E48 50                       push ax
  2977 00001E49 E842FF                   call letterE
  2978 00001E4C 83C402                   add  sp, 2
  2979 00001E4F 08C0                     or  al, al
  2980 00001E51 0F840900                 je @@alnumE130
  2981 00001E55 66B801000000             mov eax, 1
  2982 00001E5B E90900                   jmp @@retn
  2983                                  
  2984                                  ;-42   return 0;
  2985                                  
  2986                                  @@alnumE130:
  2987 00001E5E 66B800000000             mov eax, 0
  2988 00001E64 E90000                   jmp @@retn
  2989                                  
  2990                                  ;-43 }
  2991                                  
  2992                                  
  2993                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2994                                  
  2995 00001E67 C9                      @@retn: LEAVE
  2996 00001E68 C3                       ret
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
  3010 00001E69 C8020000                 ENTER  2,0
  3011 00001E6D 66B800000000             mov eax, 0
  3012 00001E73 A3[4D00]                 mov word [SymbolInt], ax
  3013                                  
  3014                                  ;-47   do {
  3015                                  
  3016                                  @@getDigit131:
  3017                                  
  3018                                  ;-48     c-='0';
  3019                                  
  3020 00001E76 806E0430                 sub  byte [bp+4], 48
  3021                                  
  3022                                  ;-49     SymbolInt=SymbolInt*10;
  3023                                  
  3024 00001E7A A1[4D00]                 mov ax, [SymbolInt]
  3025 00001E7D 66BB0A000000             mov ebx, 10
  3026 00001E83 66F7E3                   mul ebx
  3027 00001E86 A3[4D00]                 mov word [SymbolInt], ax
  3028                                  
  3029                                  ;-50     ax=0; CastInt=c; //cast b2w
  3030                                  
  3031 00001E89 B80000                   mov  ax, 0
  3032 00001E8C 8A4604                   mov al, [bp+4]
  3033 00001E8F 8946FE                   mov word [bp-2], ax
  3034                                  
  3035                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3036                                  
  3037 00001E92 A1[4D00]                 mov ax, [SymbolInt]
  3038 00001E95 0346FE                   add ax, [bp-2]
  3039 00001E98 A3[4D00]                 mov word [SymbolInt], ax
  3040                                  
  3041                                  ;-52     InputPtr++;
  3042                                  
  3043 00001E9B FF06[CE00]               inc  word [InputPtr]
  3044                                  
  3045                                  ;-53     c = *InputPtr;
  3046                                  
  3047 00001E9F 8B1E[CE00]               mov bx, [InputPtr]
  3048 00001EA3 8A07                     mov al, [bx]
  3049 00001EA5 B400                     mov ah, 0
  3050 00001EA7 884604                   mov byte [bp+4], al
  3051                                  
  3052                                  ;-54   } while(digit(c));
  3053                                  
  3054 00001EAA 8A4604                   mov al, byte [bp+4]
  3055 00001EAD B400                     mov ah, 0
  3056 00001EAF 50                       push ax
  3057 00001EB0 E8DF15                   call digit
  3058 00001EB3 83C402                   add  sp, 2
  3059 00001EB6 08C0                     or  al, al
  3060 00001EB8 0F840200                 je @@getDigit132
  3061 00001EBC EBB8                     jmp @@getDigit131
  3062                                  @@getDigit132:
  3063                                  
  3064                                  ;-55 }
  3065                                  
  3066                                  
  3067                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3068 00001EBE C9                       LEAVE
  3069 00001EBF C3                       ret
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
  3084 00001EC0 C8040000                 ENTER  4,0
  3085 00001EC4 B8[0F00]                 mov ax, Symbol
  3086 00001EC7 8946FE                   mov word [bp-2], ax
  3087                                  
  3088                                  ;-59   *p = c;
  3089                                  
  3090 00001ECA 8A4604                   mov al, [bp+4]
  3091 00001ECD 8B5EFE                   mov  bx, [bp-2]
  3092 00001ED0 8807                     mov  [bx], al
  3093                                  
  3094                                  ;-60   p++;
  3095                                  
  3096 00001ED2 FF46FE                   inc  word [bp-2]
  3097                                  
  3098                                  ;-61   while (alnumE(c)) {
  3099                                  
  3100                                  @@getName133:
  3101 00001ED5 8A4604                   mov al, byte [bp+4]
  3102 00001ED8 B400                     mov ah, 0
  3103 00001EDA 50                       push ax
  3104 00001EDB E846FF                   call alnumE
  3105 00001EDE 83C402                   add  sp, 2
  3106 00001EE1 08C0                     or  al, al
  3107 00001EE3 0F843800                 je @@getName134
  3108                                  
  3109                                  ;-62     InputPtr++;
  3110                                  
  3111 00001EE7 FF06[CE00]               inc  word [InputPtr]
  3112                                  
  3113                                  ;-63     c = *InputPtr;
  3114                                  
  3115 00001EEB 8B1E[CE00]               mov bx, [InputPtr]
  3116 00001EEF 8A07                     mov al, [bx]
  3117 00001EF1 B400                     mov ah, 0
  3118 00001EF3 884604                   mov byte [bp+4], al
  3119                                  
  3120                                  ;-64     *p = c;
  3121                                  
  3122 00001EF6 8A4604                   mov al, [bp+4]
  3123 00001EF9 8B5EFE                   mov  bx, [bp-2]
  3124 00001EFC 8807                     mov  [bx], al
  3125                                  
  3126                                  ;-65     p++;
  3127                                  
  3128 00001EFE FF46FE                   inc  word [bp-2]
  3129                                  
  3130                                  ;-66     i = p - &Symbol;
  3131                                  
  3132 00001F01 8B46FE                   mov ax, [bp-2]
  3133 00001F04 2D[0F00]                 sub ax, Symbol
  3134 00001F07 8946FC                   mov word [bp-4], ax
  3135                                  
  3136                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3137                                  
  3138 00001F0A 8B46FC                   mov ax, [bp-4]
  3139 00001F0D 83F81F                   cmp ax, 31 ;unsigned : 0
  3140 00001F10 0F820900                 jb  @@getName135
  3141 00001F14 68[681F]                 push getName_0
  3142 00001F17 E86807                   call errorexit
  3143 00001F1A 83C402                   add  sp, 2
  3144                                  
  3145                                  ;-68   }
  3146                                  
  3147                                  @@getName135:
  3148                                  
  3149                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3150                                  
  3151 00001F1D EBB6                     jmp @@getName133
  3152                                  @@getName134:
  3153 00001F1F 8A4604                   mov al, [bp+4]
  3154 00001F22 3C3A                     cmp al, 58
  3155 00001F24 0F850C00                 jne @@getName136
  3156 00001F28 66B801000000             mov eax, 1
  3157 00001F2E A2[AA01]                 mov byte [isLabel], al
  3158 00001F31 E90900                   jmp @@getName137
  3159                                  @@getName136:
  3160 00001F34 66B800000000             mov eax, 0
  3161 00001F3A A2[AA01]                 mov byte [isLabel], al
  3162                                  
  3163                                  ;-70   p--;
  3164                                  
  3165                                  @@getName137:
  3166 00001F3D FF4EFE                   dec  word [bp-2]
  3167                                  
  3168                                  ;-71   *p = 0;
  3169                                  
  3170 00001F40 66B800000000             mov eax, 0
  3171 00001F46 8B5EFE                   mov  bx, [bp-2]
  3172 00001F49 8807                     mov  [bx], al
  3173                                  
  3174                                  ;-72   strcpy(SymbolUpper, Symbol);
  3175                                  
  3176 00001F4B 8D06[0F00]               lea  ax, [Symbol]
  3177 00001F4F 50                       push ax
  3178 00001F50 8D06[2E00]               lea  ax, [SymbolUpper]
  3179 00001F54 50                       push ax
  3180 00001F55 E80115                   call strcpy
  3181 00001F58 83C404                   add  sp, 4
  3182                                  
  3183                                  ;-73   toupper(SymbolUpper);
  3184                                  
  3185 00001F5B 8D06[2E00]               lea  ax, [SymbolUpper]
  3186 00001F5F 50                       push ax
  3187 00001F60 E88814                   call toupper
  3188 00001F63 83C402                   add  sp, 2
  3189                                  
  3190                                  ;-74 }
  3191                                  
  3192                                  
  3193                                  ;-75 int testReg() {
  3194 00001F66 C9                       LEAVE
  3195 00001F67 C3                       ret
  3196                                  ; ENDP
  3197 00001F68 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3198 00001F71 6F206C6F6E6700     
  3199                                  
  3200                                  testReg:  ; *** PROC ***
  3201                                  
  3202                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3203                                  
  3204                                  
  3205                                  ;-77   R2Type=0;
  3206                                  
  3207 00001F78 66B800000000             mov eax, 0
  3208 00001F7E A2[B401]                 mov byte [R2Type], al
  3209                                  
  3210                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3211                                  
  3212 00001F81 8D06[0F00]               lea  ax, [Symbol]
  3213 00001F85 50                       push ax
  3214 00001F86 E8A514                   call strlen
  3215 00001F89 83C402                   add  sp, 2
  3216 00001F8C 3C02                     cmp al, 2
  3217 00001F8E 0F8D0900                 jge @@testReg138
  3218 00001F92 66B800000000             mov eax, 0
  3219 00001F98 E9B603                   jmp @@retn
  3220                                  
  3221                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3222                                  
  3223                                  @@testReg138:
  3224 00001F9B 8D06[0F00]               lea  ax, [Symbol]
  3225 00001F9F 50                       push ax
  3226 00001FA0 E88B14                   call strlen
  3227 00001FA3 83C402                   add  sp, 2
  3228 00001FA6 3C03                     cmp al, 3
  3229 00001FA8 0F8E0900                 jle @@testReg139
  3230 00001FAC 66B800000000             mov eax, 0
  3231 00001FB2 E99C03                   jmp @@retn
  3232                                  
  3233                                  ;-80   R2Type=BYTE;
  3234                                  
  3235                                  @@testReg139:
  3236 00001FB5 66B801000000             mov eax, 1
  3237 00001FBB A2[B401]                 mov byte [R2Type], al
  3238                                  
  3239                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3240                                  
  3241 00001FBE 68[5223]                 push testReg_0
  3242 00001FC1 8D06[2E00]               lea  ax, [SymbolUpper]
  3243 00001FC5 50                       push ax
  3244 00001FC6 E8FC14                   call eqstr
  3245 00001FC9 83C404                   add  sp, 4
  3246 00001FCC 08C0                     or  al, al
  3247 00001FCE 0F840900                 je @@testReg140
  3248 00001FD2 66B800000000             mov eax, 0
  3249 00001FD8 E97603                   jmp @@retn
  3250                                  
  3251                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3252                                  
  3253                                  @@testReg140:
  3254 00001FDB 68[5523]                 push testReg_1
  3255 00001FDE 8D06[2E00]               lea  ax, [SymbolUpper]
  3256 00001FE2 50                       push ax
  3257 00001FE3 E8DF14                   call eqstr
  3258 00001FE6 83C404                   add  sp, 4
  3259 00001FE9 08C0                     or  al, al
  3260 00001FEB 0F840900                 je @@testReg141
  3261 00001FEF 66B801000000             mov eax, 1
  3262 00001FF5 E95903                   jmp @@retn
  3263                                  
  3264                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3265                                  
  3266                                  @@testReg141:
  3267 00001FF8 68[5823]                 push testReg_2
  3268 00001FFB 8D06[2E00]               lea  ax, [SymbolUpper]
  3269 00001FFF 50                       push ax
  3270 00002000 E8C214                   call eqstr
  3271 00002003 83C404                   add  sp, 4
  3272 00002006 08C0                     or  al, al
  3273 00002008 0F840900                 je @@testReg142
  3274 0000200C 66B802000000             mov eax, 2
  3275 00002012 E93C03                   jmp @@retn
  3276                                  
  3277                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3278                                  
  3279                                  @@testReg142:
  3280 00002015 68[5B23]                 push testReg_3
  3281 00002018 8D06[2E00]               lea  ax, [SymbolUpper]
  3282 0000201C 50                       push ax
  3283 0000201D E8A514                   call eqstr
  3284 00002020 83C404                   add  sp, 4
  3285 00002023 08C0                     or  al, al
  3286 00002025 0F840900                 je @@testReg143
  3287 00002029 66B803000000             mov eax, 3
  3288 0000202F E91F03                   jmp @@retn
  3289                                  
  3290                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3291                                  
  3292                                  @@testReg143:
  3293 00002032 68[5E23]                 push testReg_4
  3294 00002035 8D06[2E00]               lea  ax, [SymbolUpper]
  3295 00002039 50                       push ax
  3296 0000203A E88814                   call eqstr
  3297 0000203D 83C404                   add  sp, 4
  3298 00002040 08C0                     or  al, al
  3299 00002042 0F840900                 je @@testReg144
  3300 00002046 66B804000000             mov eax, 4
  3301 0000204C E90203                   jmp @@retn
  3302                                  
  3303                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3304                                  
  3305                                  @@testReg144:
  3306 0000204F 68[6123]                 push testReg_5
  3307 00002052 8D06[2E00]               lea  ax, [SymbolUpper]
  3308 00002056 50                       push ax
  3309 00002057 E86B14                   call eqstr
  3310 0000205A 83C404                   add  sp, 4
  3311 0000205D 08C0                     or  al, al
  3312 0000205F 0F840900                 je @@testReg145
  3313 00002063 66B805000000             mov eax, 5
  3314 00002069 E9E502                   jmp @@retn
  3315                                  
  3316                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3317                                  
  3318                                  @@testReg145:
  3319 0000206C 68[6423]                 push testReg_6
  3320 0000206F 8D06[2E00]               lea  ax, [SymbolUpper]
  3321 00002073 50                       push ax
  3322 00002074 E84E14                   call eqstr
  3323 00002077 83C404                   add  sp, 4
  3324 0000207A 08C0                     or  al, al
  3325 0000207C 0F840900                 je @@testReg146
  3326 00002080 66B806000000             mov eax, 6
  3327 00002086 E9C802                   jmp @@retn
  3328                                  
  3329                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3330                                  
  3331                                  @@testReg146:
  3332 00002089 68[6723]                 push testReg_7
  3333 0000208C 8D06[2E00]               lea  ax, [SymbolUpper]
  3334 00002090 50                       push ax
  3335 00002091 E83114                   call eqstr
  3336 00002094 83C404                   add  sp, 4
  3337 00002097 08C0                     or  al, al
  3338 00002099 0F840900                 je @@testReg147
  3339 0000209D 66B807000000             mov eax, 7
  3340 000020A3 E9AB02                   jmp @@retn
  3341                                  
  3342                                  ;-89   R2Type=WORD;
  3343                                  
  3344                                  @@testReg147:
  3345 000020A6 66B802000000             mov eax, 2
  3346 000020AC A2[B401]                 mov byte [R2Type], al
  3347                                  
  3348                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3349                                  
  3350 000020AF 68[6A23]                 push testReg_8
  3351 000020B2 8D06[2E00]               lea  ax, [SymbolUpper]
  3352 000020B6 50                       push ax
  3353 000020B7 E80B14                   call eqstr
  3354 000020BA 83C404                   add  sp, 4
  3355 000020BD 08C0                     or  al, al
  3356 000020BF 0F840900                 je @@testReg148
  3357 000020C3 66B800000000             mov eax, 0
  3358 000020C9 E98502                   jmp @@retn
  3359                                  
  3360                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3361                                  
  3362                                  @@testReg148:
  3363 000020CC 68[6D23]                 push testReg_9
  3364 000020CF 8D06[2E00]               lea  ax, [SymbolUpper]
  3365 000020D3 50                       push ax
  3366 000020D4 E8EE13                   call eqstr
  3367 000020D7 83C404                   add  sp, 4
  3368 000020DA 08C0                     or  al, al
  3369 000020DC 0F840900                 je @@testReg149
  3370 000020E0 66B801000000             mov eax, 1
  3371 000020E6 E96802                   jmp @@retn
  3372                                  
  3373                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3374                                  
  3375                                  @@testReg149:
  3376 000020E9 68[7023]                 push testReg_10
  3377 000020EC 8D06[2E00]               lea  ax, [SymbolUpper]
  3378 000020F0 50                       push ax
  3379 000020F1 E8D113                   call eqstr
  3380 000020F4 83C404                   add  sp, 4
  3381 000020F7 08C0                     or  al, al
  3382 000020F9 0F840900                 je @@testReg150
  3383 000020FD 66B802000000             mov eax, 2
  3384 00002103 E94B02                   jmp @@retn
  3385                                  
  3386                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3387                                  
  3388                                  @@testReg150:
  3389 00002106 68[7323]                 push testReg_11
  3390 00002109 8D06[2E00]               lea  ax, [SymbolUpper]
  3391 0000210D 50                       push ax
  3392 0000210E E8B413                   call eqstr
  3393 00002111 83C404                   add  sp, 4
  3394 00002114 08C0                     or  al, al
  3395 00002116 0F840900                 je @@testReg151
  3396 0000211A 66B803000000             mov eax, 3
  3397 00002120 E92E02                   jmp @@retn
  3398                                  
  3399                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3400                                  
  3401                                  @@testReg151:
  3402 00002123 68[7623]                 push testReg_12
  3403 00002126 8D06[2E00]               lea  ax, [SymbolUpper]
  3404 0000212A 50                       push ax
  3405 0000212B E89713                   call eqstr
  3406 0000212E 83C404                   add  sp, 4
  3407 00002131 08C0                     or  al, al
  3408 00002133 0F840900                 je @@testReg152
  3409 00002137 66B804000000             mov eax, 4
  3410 0000213D E91102                   jmp @@retn
  3411                                  
  3412                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3413                                  
  3414                                  @@testReg152:
  3415 00002140 68[7923]                 push testReg_13
  3416 00002143 8D06[2E00]               lea  ax, [SymbolUpper]
  3417 00002147 50                       push ax
  3418 00002148 E87A13                   call eqstr
  3419 0000214B 83C404                   add  sp, 4
  3420 0000214E 08C0                     or  al, al
  3421 00002150 0F840900                 je @@testReg153
  3422 00002154 66B805000000             mov eax, 5
  3423 0000215A E9F401                   jmp @@retn
  3424                                  
  3425                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3426                                  
  3427                                  @@testReg153:
  3428 0000215D 68[7C23]                 push testReg_14
  3429 00002160 8D06[2E00]               lea  ax, [SymbolUpper]
  3430 00002164 50                       push ax
  3431 00002165 E85D13                   call eqstr
  3432 00002168 83C404                   add  sp, 4
  3433 0000216B 08C0                     or  al, al
  3434 0000216D 0F840900                 je @@testReg154
  3435 00002171 66B806000000             mov eax, 6
  3436 00002177 E9D701                   jmp @@retn
  3437                                  
  3438                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3439                                  
  3440                                  @@testReg154:
  3441 0000217A 68[7F23]                 push testReg_15
  3442 0000217D 8D06[2E00]               lea  ax, [SymbolUpper]
  3443 00002181 50                       push ax
  3444 00002182 E84013                   call eqstr
  3445 00002185 83C404                   add  sp, 4
  3446 00002188 08C0                     or  al, al
  3447 0000218A 0F840900                 je @@testReg155
  3448 0000218E 66B807000000             mov eax, 7
  3449 00002194 E9BA01                   jmp @@retn
  3450                                  
  3451                                  ;-98   R2Type=SEGREG;
  3452                                  
  3453                                  @@testReg155:
  3454 00002197 66B804000000             mov eax, 4
  3455 0000219D A2[B401]                 mov byte [R2Type], al
  3456                                  
  3457                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3458                                  
  3459 000021A0 68[8223]                 push testReg_16
  3460 000021A3 8D06[2E00]               lea  ax, [SymbolUpper]
  3461 000021A7 50                       push ax
  3462 000021A8 E81A13                   call eqstr
  3463 000021AB 83C404                   add  sp, 4
  3464 000021AE 08C0                     or  al, al
  3465 000021B0 0F840900                 je @@testReg156
  3466 000021B4 66B800000000             mov eax, 0
  3467 000021BA E99401                   jmp @@retn
  3468                                  
  3469                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3470                                  
  3471                                  @@testReg156:
  3472 000021BD 68[8523]                 push testReg_17
  3473 000021C0 8D06[2E00]               lea  ax, [SymbolUpper]
  3474 000021C4 50                       push ax
  3475 000021C5 E8FD12                   call eqstr
  3476 000021C8 83C404                   add  sp, 4
  3477 000021CB 08C0                     or  al, al
  3478 000021CD 0F840900                 je @@testReg157
  3479 000021D1 66B801000000             mov eax, 1
  3480 000021D7 E97701                   jmp @@retn
  3481                                  
  3482                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3483                                  
  3484                                  @@testReg157:
  3485 000021DA 68[8823]                 push testReg_18
  3486 000021DD 8D06[2E00]               lea  ax, [SymbolUpper]
  3487 000021E1 50                       push ax
  3488 000021E2 E8E012                   call eqstr
  3489 000021E5 83C404                   add  sp, 4
  3490 000021E8 08C0                     or  al, al
  3491 000021EA 0F840900                 je @@testReg158
  3492 000021EE 66B802000000             mov eax, 2
  3493 000021F4 E95A01                   jmp @@retn
  3494                                  
  3495                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3496                                  
  3497                                  @@testReg158:
  3498 000021F7 68[8B23]                 push testReg_19
  3499 000021FA 8D06[2E00]               lea  ax, [SymbolUpper]
  3500 000021FE 50                       push ax
  3501 000021FF E8C312                   call eqstr
  3502 00002202 83C404                   add  sp, 4
  3503 00002205 08C0                     or  al, al
  3504 00002207 0F840900                 je @@testReg159
  3505 0000220B 66B803000000             mov eax, 3
  3506 00002211 E93D01                   jmp @@retn
  3507                                  
  3508                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3509                                  
  3510                                  @@testReg159:
  3511 00002214 68[8E23]                 push testReg_20
  3512 00002217 8D06[2E00]               lea  ax, [SymbolUpper]
  3513 0000221B 50                       push ax
  3514 0000221C E8A612                   call eqstr
  3515 0000221F 83C404                   add  sp, 4
  3516 00002222 08C0                     or  al, al
  3517 00002224 0F840900                 je @@testReg160
  3518 00002228 66B804000000             mov eax, 4
  3519 0000222E E92001                   jmp @@retn
  3520                                  
  3521                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3522                                  
  3523                                  @@testReg160:
  3524 00002231 68[9123]                 push testReg_21
  3525 00002234 8D06[2E00]               lea  ax, [SymbolUpper]
  3526 00002238 50                       push ax
  3527 00002239 E88912                   call eqstr
  3528 0000223C 83C404                   add  sp, 4
  3529 0000223F 08C0                     or  al, al
  3530 00002241 0F840900                 je @@testReg161
  3531 00002245 66B805000000             mov eax, 5
  3532 0000224B E90301                   jmp @@retn
  3533                                  
  3534                                  ;-105   R2Type=DWORD;                         
  3535                                  
  3536                                  @@testReg161:
  3537 0000224E 66B803000000             mov eax, 3
  3538 00002254 A2[B401]                 mov byte [R2Type], al
  3539                                  
  3540                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3541                                  
  3542 00002257 68[9423]                 push testReg_22
  3543 0000225A 8D06[2E00]               lea  ax, [SymbolUpper]
  3544 0000225E 50                       push ax
  3545 0000225F E86312                   call eqstr
  3546 00002262 83C404                   add  sp, 4
  3547 00002265 08C0                     or  al, al
  3548 00002267 0F840900                 je @@testReg162
  3549 0000226B 66B800000000             mov eax, 0
  3550 00002271 E9DD00                   jmp @@retn
  3551                                  
  3552                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3553                                  
  3554                                  @@testReg162:
  3555 00002274 68[9823]                 push testReg_23
  3556 00002277 8D06[2E00]               lea  ax, [SymbolUpper]
  3557 0000227B 50                       push ax
  3558 0000227C E84612                   call eqstr
  3559 0000227F 83C404                   add  sp, 4
  3560 00002282 08C0                     or  al, al
  3561 00002284 0F840900                 je @@testReg163
  3562 00002288 66B801000000             mov eax, 1
  3563 0000228E E9C000                   jmp @@retn
  3564                                  
  3565                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3566                                  
  3567                                  @@testReg163:
  3568 00002291 68[9C23]                 push testReg_24
  3569 00002294 8D06[2E00]               lea  ax, [SymbolUpper]
  3570 00002298 50                       push ax
  3571 00002299 E82912                   call eqstr
  3572 0000229C 83C404                   add  sp, 4
  3573 0000229F 08C0                     or  al, al
  3574 000022A1 0F840900                 je @@testReg164
  3575 000022A5 66B802000000             mov eax, 2
  3576 000022AB E9A300                   jmp @@retn
  3577                                  
  3578                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3579                                  
  3580                                  @@testReg164:
  3581 000022AE 68[A023]                 push testReg_25
  3582 000022B1 8D06[2E00]               lea  ax, [SymbolUpper]
  3583 000022B5 50                       push ax
  3584 000022B6 E80C12                   call eqstr
  3585 000022B9 83C404                   add  sp, 4
  3586 000022BC 08C0                     or  al, al
  3587 000022BE 0F840900                 je @@testReg165
  3588 000022C2 66B803000000             mov eax, 3
  3589 000022C8 E98600                   jmp @@retn
  3590                                  
  3591                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3592                                  
  3593                                  @@testReg165:
  3594 000022CB 68[A423]                 push testReg_26
  3595 000022CE 8D06[2E00]               lea  ax, [SymbolUpper]
  3596 000022D2 50                       push ax
  3597 000022D3 E8EF11                   call eqstr
  3598 000022D6 83C404                   add  sp, 4
  3599 000022D9 08C0                     or  al, al
  3600 000022DB 0F840900                 je @@testReg166
  3601 000022DF 66B804000000             mov eax, 4
  3602 000022E5 E96900                   jmp @@retn
  3603                                  
  3604                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3605                                  
  3606                                  @@testReg166:
  3607 000022E8 68[A823]                 push testReg_27
  3608 000022EB 8D06[2E00]               lea  ax, [SymbolUpper]
  3609 000022EF 50                       push ax
  3610 000022F0 E8D211                   call eqstr
  3611 000022F3 83C404                   add  sp, 4
  3612 000022F6 08C0                     or  al, al
  3613 000022F8 0F840900                 je @@testReg167
  3614 000022FC 66B805000000             mov eax, 5
  3615 00002302 E94C00                   jmp @@retn
  3616                                  
  3617                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3618                                  
  3619                                  @@testReg167:
  3620 00002305 68[AC23]                 push testReg_28
  3621 00002308 8D06[2E00]               lea  ax, [SymbolUpper]
  3622 0000230C 50                       push ax
  3623 0000230D E8B511                   call eqstr
  3624 00002310 83C404                   add  sp, 4
  3625 00002313 08C0                     or  al, al
  3626 00002315 0F840900                 je @@testReg168
  3627 00002319 66B806000000             mov eax, 6
  3628 0000231F E92F00                   jmp @@retn
  3629                                  
  3630                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3631                                  
  3632                                  @@testReg168:
  3633 00002322 68[B023]                 push testReg_29
  3634 00002325 8D06[2E00]               lea  ax, [SymbolUpper]
  3635 00002329 50                       push ax
  3636 0000232A E89811                   call eqstr
  3637 0000232D 83C404                   add  sp, 4
  3638 00002330 08C0                     or  al, al
  3639 00002332 0F840900                 je @@testReg169
  3640 00002336 66B807000000             mov eax, 7
  3641 0000233C E91200                   jmp @@retn
  3642                                  
  3643                                  ;-114   R2Type=0; return 0;
  3644                                  
  3645                                  @@testReg169:
  3646 0000233F 66B800000000             mov eax, 0
  3647 00002345 A2[B401]                 mov byte [R2Type], al
  3648 00002348 66B800000000             mov eax, 0
  3649 0000234E E90000                   jmp @@retn
  3650                                  
  3651                                  ;-115 }
  3652                                  
  3653                                  @@retn:
  3654 00002351 C3                       ret
  3655                                  ; ENDP
  3656 00002352 414C00                  testReg_0 db "AL",0
  3657 00002355 434C00                  testReg_1 db "CL",0
  3658 00002358 444C00                  testReg_2 db "DL",0
  3659 0000235B 424C00                  testReg_3 db "BL",0
  3660 0000235E 414800                  testReg_4 db "AH",0
  3661 00002361 434800                  testReg_5 db "CH",0
  3662 00002364 444800                  testReg_6 db "DH",0
  3663 00002367 424800                  testReg_7 db "BH",0
  3664 0000236A 415800                  testReg_8 db "AX",0
  3665 0000236D 435800                  testReg_9 db "CX",0
  3666 00002370 445800                  testReg_10 db "DX",0
  3667 00002373 425800                  testReg_11 db "BX",0
  3668 00002376 535000                  testReg_12 db "SP",0
  3669 00002379 425000                  testReg_13 db "BP",0
  3670 0000237C 534900                  testReg_14 db "SI",0
  3671 0000237F 444900                  testReg_15 db "DI",0
  3672 00002382 455300                  testReg_16 db "ES",0
  3673 00002385 435300                  testReg_17 db "CS",0
  3674 00002388 535300                  testReg_18 db "SS",0
  3675 0000238B 445300                  testReg_19 db "DS",0
  3676 0000238E 465300                  testReg_20 db "FS",0
  3677 00002391 475300                  testReg_21 db "GS",0
  3678 00002394 45415800                testReg_22 db "EAX",0
  3679 00002398 45435800                testReg_23 db "ECX",0
  3680 0000239C 45445800                testReg_24 db "EDX",0
  3681 000023A0 45425800                testReg_25 db "EBX",0
  3682 000023A4 45535000                testReg_26 db "ESP",0
  3683 000023A8 45425000                testReg_27 db "EBP",0
  3684 000023AC 45534900                testReg_28 db "ESI",0
  3685 000023B0 45444900                testReg_29 db "EDI",0
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
  3706 000023B4 C8040000                 ENTER  4,0
  3707 000023B8 68[4924]                 push printLine_0
  3708 000023BB E80401                   call prs
  3709 000023BE 83C402                   add  sp, 2
  3710                                  
  3711                                  ;-4     printhex16(PCStart);
  3712                                  
  3713 000023C1 FF36[A801]               push word [PCStart]
  3714 000023C5 E8EF01                   call printhex16
  3715 000023C8 83C402                   add  sp, 2
  3716                                  
  3717                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  3718                                  
  3719 000023CB A1[C501]                 mov ax, [OpPrintIndex]
  3720 000023CE 83F800                   cmp ax, 0
  3721 000023D1 0F850C00                 jne @@printLine170
  3722 000023D5 68[4C24]                 push printLine_1
  3723 000023D8 E8E700                   call prs
  3724 000023DB 83C402                   add  sp, 2
  3725                                  
  3726                                  ;-6     else {
  3727                                  
  3728 000023DE E95B00                   jmp @@printLine171
  3729                                  @@printLine170:
  3730                                  
  3731                                  ;-7         prc(PrintR);
  3732                                  
  3733 000023E1 A0[C901]                 mov al, byte [PrintR]
  3734 000023E4 B400                     mov ah, 0
  3735 000023E6 50                       push ax
  3736 000023E7 E87700                   call prc
  3737 000023EA 83C402                   add  sp, 2
  3738                                  
  3739                                  ;-8         i=0;
  3740                                  
  3741 000023ED 66B800000000             mov eax, 0
  3742 000023F3 8946FE                   mov word [bp-2], ax
  3743                                  
  3744                                  ;-9         do {
  3745                                  
  3746                                  @@printLine172:
  3747                                  
  3748                                  ;-10             c=OpPos[i];
  3749                                  
  3750 000023F6 8B5EFE                   mov bx, [bp-2]
  3751 000023F9 8A87[C001]               mov al, [OpPos + bx]
  3752 000023FD 8846FC                   mov byte [bp-4], al
  3753                                  
  3754                                  ;-11             printhex8a(c); 
  3755                                  
  3756 00002400 8A46FC                   mov al, byte [bp-4]
  3757 00002403 B400                     mov ah, 0
  3758 00002405 50                       push ax
  3759 00002406 E85C01                   call printhex8a
  3760 00002409 83C402                   add  sp, 2
  3761                                  
  3762                                  ;-12             prc(' ');
  3763                                  
  3764 0000240C 6A20                     push 32
  3765 0000240E E85000                   call prc
  3766 00002411 83C402                   add  sp, 2
  3767                                  
  3768                                  ;-13             i++;
  3769                                  
  3770 00002414 FF46FE                   inc  word [bp-2]
  3771                                  
  3772                                  ;-14         } while (i < OpPrintIndex);
  3773                                  
  3774 00002417 8B46FE                   mov ax, [bp-2]
  3775 0000241A 3B06[C501]               cmp ax, [OpPrintIndex]
  3776 0000241E 0F8D0200                 jge @@printLine173
  3777 00002422 EBD2                     jmp @@printLine172
  3778                                  @@printLine173:
  3779                                  
  3780                                  ;-15         do {// fill rest with blank
  3781                                  
  3782                                  @@printLine174:
  3783                                  
  3784                                  ;-16             prs("   ");
  3785                                  
  3786 00002424 68[5D24]                 push printLine_2
  3787 00002427 E89800                   call prs
  3788 0000242A 83C402                   add  sp, 2
  3789                                  
  3790                                  ;-17             i++;
  3791                                  
  3792 0000242D FF46FE                   inc  word [bp-2]
  3793                                  
  3794                                  ;-18         } while (i < OPMAXLEN);
  3795                                  
  3796 00002430 8B46FE                   mov ax, [bp-2]
  3797 00002433 83F805                   cmp ax, 5
  3798 00002436 0F8D0200                 jge @@printLine175
  3799 0000243A EBE8                     jmp @@printLine174
  3800                                  @@printLine175:
  3801                                  
  3802                                  ;-19     }
  3803                                  
  3804                                  
  3805                                  ;-20     prscomment(InputBuf);
  3806                                  
  3807                                  @@printLine171:
  3808 0000243C 8D06[4F00]               lea  ax, [InputBuf]
  3809 00002440 50                       push ax
  3810 00002441 E85000                   call prscomment
  3811 00002444 83C402                   add  sp, 2
  3812                                  
  3813                                  ;-21 }
  3814                                  
  3815                                  
  3816                                  ;-22 int prc(unsigned char c) {//print char 
  3817 00002447 C9                       LEAVE
  3818 00002448 C3                       ret
  3819                                  ; ENDP
  3820 00002449 5C6E00                  printLine_0 db "\n",0
  3821 0000244C 202020202020202020-     printLine_1 db "                ",0
  3822 00002455 2020202020202000   
  3823 0000245D 20202000                printLine_2 db "   ",0
  3824                                  
  3825                                  prc:  ; *** PROC ***
  3826                                  
  3827                                  ;-23     if (LIST) { 
  3828                                  
  3829                                  ;Function : prc, Number of local variables: 1
  3830                                  ;   # type sign width line used address name   list of local variables
  3831                                  ;  200 var unsg byte    22 NULL bp+4    c;
  3832 00002461 C8000000                 ENTER  0,0
  3833 00002465 A0[0E00]                 mov al, [LIST]
  3834 00002468 08C0                     or  al, al
  3835 0000246A 0F841400                 je @@prc176
  3836                                  
  3837                                  ;-24         if ( _ c==10) {
  3838                                  
  3839 0000246E 807E040A                cmp byte [bp+4], 10
  3840 00002472 0F850600                 jne @@prc177
  3841                                  
  3842                                  ;-25             ax=13; 
  3843                                  
  3844 00002476 B80D00                   mov  ax, 13
  3845                                  
  3846                                  ;-26             writetty(); 
  3847                                  
  3848 00002479 E8390F                   call writetty
  3849                                  
  3850                                  ;-27             }
  3851                                  
  3852                                  
  3853                                  ;-28         al=c; 
  3854                                  
  3855                                  @@prc177:
  3856 0000247C 8A4604                   mov  al, [bp+4]
  3857                                  
  3858                                  ;-29         writetty(); 
  3859                                  
  3860 0000247F E8330F                   call writetty
  3861                                  
  3862                                  ;-30         }
  3863                                  
  3864                                  
  3865                                  ;-31     fputcR(c,lst_fd); 
  3866                                  
  3867                                  @@prc176:
  3868 00002482 FF36[9B01]               push word [lst_fd]
  3869 00002486 8A4604                   mov al, byte [bp+4]
  3870 00002489 B400                     mov ah, 0
  3871 0000248B 50                       push ax
  3872 0000248C E8E610                   call fputcR
  3873 0000248F 83C404                   add  sp, 4
  3874                                  
  3875                                  ;-32 }
  3876                                  
  3877                                  
  3878                                  ;-33 
  3879                                  
  3880                                  
  3881                                  ;-34 int prscomment(unsigned char *s) {
  3882 00002492 C9                       LEAVE
  3883 00002493 C3                       ret
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
  3897 00002494 C8020000                 ENTER  2,0
  3898                                  @@prscomment178:
  3899 00002498 8B5E04                   mov bx, [bp+4]
  3900 0000249B 8A07                     mov al, [bx]
  3901 0000249D B400                     mov ah, 0
  3902 0000249F 08C0                     or  al, al
  3903 000024A1 0F841B00                 je @@prscomment179
  3904                                  
  3905                                  ;-37         c=*s;
  3906                                  
  3907 000024A5 8B5E04                   mov bx, [bp+4]
  3908 000024A8 8A07                     mov al, [bx]
  3909 000024AA B400                     mov ah, 0
  3910 000024AC 8846FE                   mov byte [bp-2], al
  3911                                  
  3912                                  ;-38         prc(c);
  3913                                  
  3914 000024AF 8A46FE                   mov al, byte [bp-2]
  3915 000024B2 B400                     mov ah, 0
  3916 000024B4 50                       push ax
  3917 000024B5 E8A9FF                   call prc
  3918 000024B8 83C402                   add  sp, 2
  3919                                  
  3920                                  ;-39         s++;
  3921                                  
  3922 000024BB FF4604                   inc  word [bp+4]
  3923                                  
  3924                                  ;-40     }
  3925                                  
  3926                                  
  3927                                  ;-41 }
  3928                                  
  3929 000024BE EBD8                     jmp @@prscomment178
  3930                                  @@prscomment179:
  3931                                  
  3932                                  ;-42 int prs(unsigned char *s) {
  3933 000024C0 C9                       LEAVE
  3934 000024C1 C3                       ret
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
  3952 000024C2 C8040000                 ENTER  4,0
  3953 000024C6 66B800000000             mov eax, 0
  3954 000024CC 8946FC                   mov word [bp-4], ax
  3955                                  
  3956                                  ;-46     while (*s) { 
  3957                                  
  3958                                  @@prs180:
  3959 000024CF 8B5E04                   mov bx, [bp+4]
  3960 000024D2 8A07                     mov al, [bx]
  3961 000024D4 B400                     mov ah, 0
  3962 000024D6 08C0                     or  al, al
  3963 000024D8 0F848700                 je @@prs181
  3964                                  
  3965                                  ;-47         c=*s; 
  3966                                  
  3967 000024DC 8B5E04                   mov bx, [bp+4]
  3968 000024DF 8A07                     mov al, [bx]
  3969 000024E1 B400                     mov ah, 0
  3970 000024E3 8846FE                   mov byte [bp-2], al
  3971                                  
  3972                                  ;-48         if (c==34) {
  3973                                  
  3974 000024E6 8A46FE                   mov al, [bp-2]
  3975 000024E9 3C22                     cmp al, 34
  3976 000024EB 0F851E00                 jne @@prs182
  3977                                  
  3978                                  ;-49             if (com) com=0; 
  3979                                  
  3980 000024EF 8B46FC                   mov ax, [bp-4]
  3981 000024F2 08C0                     or  al, al
  3982 000024F4 0F840C00                 je @@prs183
  3983 000024F8 66B800000000             mov eax, 0
  3984 000024FE 8946FC                   mov word [bp-4], ax
  3985                                  
  3986                                  ;-50                 else com=1;  
  3987                                  
  3988 00002501 E90900                   jmp @@prs184
  3989                                  @@prs183:
  3990 00002504 66B801000000             mov eax, 1
  3991 0000250A 8946FC                   mov word [bp-4], ax
  3992                                  
  3993                                  ;-51         }
  3994                                  
  3995                                  @@prs184:
  3996                                  
  3997                                  ;-52         if (c==92) { 
  3998                                  
  3999                                  @@prs182:
  4000 0000250D 8A46FE                   mov al, [bp-2]
  4001 00002510 3C5C                     cmp al, 92
  4002 00002512 0F853B00                 jne @@prs185
  4003                                  
  4004                                  ;-53             if (com==0) { 
  4005                                  
  4006 00002516 8B46FC                   mov ax, [bp-4]
  4007 00002519 83F800                   cmp ax, 0
  4008 0000251C 0F853100                 jne @@prs186
  4009                                  
  4010                                  ;-54                 s++; 
  4011                                  
  4012 00002520 FF4604                   inc  word [bp+4]
  4013                                  
  4014                                  ;-55                 c=*s;
  4015                                  
  4016 00002523 8B5E04                   mov bx, [bp+4]
  4017 00002526 8A07                     mov al, [bx]
  4018 00002528 B400                     mov ah, 0
  4019 0000252A 8846FE                   mov byte [bp-2], al
  4020                                  
  4021                                  ;-56                 if (c=='n') c=10; 
  4022                                  
  4023 0000252D 8A46FE                   mov al, [bp-2]
  4024 00002530 3C6E                     cmp al, 110
  4025 00002532 0F850900                 jne @@prs187
  4026 00002536 66B80A000000             mov eax, 10
  4027 0000253C 8846FE                   mov byte [bp-2], al
  4028                                  
  4029                                  ;-57                 if (c=='t') c= 9; 
  4030                                  
  4031                                  @@prs187:
  4032 0000253F 8A46FE                   mov al, [bp-2]
  4033 00002542 3C74                     cmp al, 116
  4034 00002544 0F850900                 jne @@prs188
  4035 00002548 66B809000000             mov eax, 9
  4036 0000254E 8846FE                   mov byte [bp-2], al
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
  4049 00002551 8A46FE                   mov al, byte [bp-2]
  4050 00002554 B400                     mov ah, 0
  4051 00002556 50                       push ax
  4052 00002557 E807FF                   call prc
  4053 0000255A 83C402                   add  sp, 2
  4054                                  
  4055                                  ;-61         s++;  
  4056                                  
  4057 0000255D FF4604                   inc  word [bp+4]
  4058                                  
  4059                                  ;-62     }
  4060                                  
  4061                                  
  4062                                  ;-63 }
  4063                                  
  4064 00002560 E96CFF                   jmp @@prs180
  4065                                  @@prs181:
  4066                                  
  4067                                  ;-64 int printhex8a(unsigned char c) { 
  4068 00002563 C9                       LEAVE
  4069 00002564 C3                       ret
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
  4083 00002565 C8020000                 ENTER  2,0
  4084 00002569 8A4604                   mov al, [bp+4]
  4085 0000256C C0E804                   shr al, 4
  4086 0000256F 8846FE                   mov byte [bp-2], al
  4087 00002572 8A46FE                   mov al, byte [bp-2]
  4088 00002575 B400                     mov ah, 0
  4089 00002577 50                       push ax
  4090 00002578 E81900                   call printhex4
  4091 0000257B 83C402                   add  sp, 2
  4092                                  
  4093                                  ;-67     nib = c & 15; printhex4(nib);                    
  4094                                  
  4095 0000257E 8A4604                   mov al, [bp+4]
  4096 00002581 240F                     and al, 15
  4097 00002583 8846FE                   mov byte [bp-2], al
  4098 00002586 8A46FE                   mov al, byte [bp-2]
  4099 00002589 B400                     mov ah, 0
  4100 0000258B 50                       push ax
  4101 0000258C E80500                   call printhex4
  4102 0000258F 83C402                   add  sp, 2
  4103                                  
  4104                                  ;-68 } 
  4105                                  
  4106                                  
  4107                                  ;-69 int printhex4(unsigned char c) {
  4108 00002592 C9                       LEAVE
  4109 00002593 C3                       ret
  4110                                  ; ENDP
  4111                                  
  4112                                  printhex4:  ; *** PROC ***
  4113                                  
  4114                                  ;-70     c += 48; 
  4115                                  
  4116                                  ;Function : printhex4, Number of local variables: 1
  4117                                  ;   # type sign width line used address name   list of local variables
  4118                                  ;  200 var unsg byte    69 NULL bp+4    c;
  4119 00002594 C8000000                 ENTER  0,0
  4120 00002598 80460430                 add  byte [bp+4], 48
  4121                                  
  4122                                  ;-71     if (c > 57) c += 7; 
  4123                                  
  4124 0000259C 8A4604                   mov al, [bp+4]
  4125 0000259F 3C39                     cmp al, 57
  4126 000025A1 0F8E0400                 jle @@printhex4189
  4127 000025A5 80460407                 add  byte [bp+4], 7
  4128                                  
  4129                                  ;-72     prc(c);      
  4130                                  
  4131                                  @@printhex4189:
  4132 000025A9 8A4604                   mov al, byte [bp+4]
  4133 000025AC B400                     mov ah, 0
  4134 000025AE 50                       push ax
  4135 000025AF E8AFFE                   call prc
  4136 000025B2 83C402                   add  sp, 2
  4137                                  
  4138                                  ;-73 }
  4139                                  
  4140                                  
  4141                                  ;-74 int printhex16(unsigned int i) {
  4142 000025B5 C9                       LEAVE
  4143 000025B6 C3                       ret
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
  4157 000025B7 C8020000                 ENTER  2,0
  4158 000025BB 8B4604                   mov ax, [bp+4]
  4159 000025BE C1E808                   shr ax, 8
  4160 000025C1 8946FE                   mov word [bp-2], ax
  4161 000025C4 FF76FE                   push word [bp-2]
  4162 000025C7 E89BFF                   call printhex8a
  4163 000025CA 83C402                   add  sp, 2
  4164                                  
  4165                                  ;-77     half = i & 255; printhex8a(half);
  4166                                  
  4167 000025CD 8B4604                   mov ax, [bp+4]
  4168 000025D0 25FF00                   and ax, 255
  4169 000025D3 8946FE                   mov word [bp-2], ax
  4170 000025D6 FF76FE                   push word [bp-2]
  4171 000025D9 E889FF                   call printhex8a
  4172 000025DC 83C402                   add  sp, 2
  4173                                  
  4174                                  ;-78 }
  4175                                  
  4176                                  
  4177                                  ;-79 int printIntU(unsigned int n) { 
  4178 000025DF C9                       LEAVE
  4179 000025E0 C3                       ret
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
  4193 000025E1 C8020000                 ENTER  2,0
  4194 000025E5 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4195 000025E9 0F821700                 jb  @@printIntU190
  4196                                  
  4197                                  ;-82         e=n/10; //DIV
  4198                                  
  4199 000025ED 8B4604                   mov ax, [bp+4]
  4200 000025F0 BB0A00                   mov bx, 10
  4201 000025F3 BA0000                   mov dx, 0
  4202 000025F6 F7F3                     div bx
  4203 000025F8 8946FE                   mov word [bp-2], ax
  4204                                  
  4205                                  ;-83         printIntU(e); 
  4206                                  
  4207 000025FB FF76FE                   push word [bp-2]
  4208 000025FE E8E0FF                   call printIntU
  4209 00002601 83C402                   add  sp, 2
  4210                                  
  4211                                  ;-84     }
  4212                                  
  4213                                  
  4214                                  ;-85     n = n % 10; //unsigned mod
  4215                                  
  4216                                  @@printIntU190:
  4217 00002604 8B4604                   mov ax, [bp+4]
  4218 00002607 BB0A00                   mov bx, 10
  4219 0000260A BA0000                   mov dx, 0
  4220 0000260D F7F3                     div bx
  4221 0000260F 89D0                     mov ax, dx
  4222 00002611 894604                   mov word [bp+4], ax
  4223                                  
  4224                                  ;-86     n += '0'; 
  4225                                  
  4226 00002614 83460430                 add  word [bp+4], 48
  4227                                  
  4228                                  ;-87     prc(n);
  4229                                  
  4230 00002618 FF7604                   push word [bp+4]
  4231 0000261B E843FE                   call prc
  4232 0000261E 83C402                   add  sp, 2
  4233                                  
  4234                                  ;-88 }
  4235                                  
  4236                                  
  4237                                  ;-89 
  4238                                  
  4239                                  
  4240                                  ;-90 int error1(char *s) { 
  4241 00002621 C9                       LEAVE
  4242 00002622 C3                       ret
  4243                                  ; ENDP
  4244                                  
  4245                                  error1:  ; *** PROC ***
  4246                                  
  4247                                  ;-91     LIST=1; 
  4248                                  
  4249                                  ;Function : error1, Number of local variables: 1
  4250                                  ;   # type sign width line used address name   list of local variables
  4251                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  4252 00002623 C8000000                 ENTER  0,0
  4253 00002627 66B801000000             mov eax, 1
  4254 0000262D A2[0E00]                 mov byte [LIST], al
  4255                                  
  4256                                  ;-92     ErrorCount++;
  4257                                  
  4258 00002630 FF06[A101]               inc  word [ErrorCount]
  4259                                  
  4260                                  ;-93     prs("\n;***** next line ERROR: "); 
  4261                                  
  4262 00002634 68[5C26]                 push error1_0
  4263 00002637 E888FE                   call prs
  4264 0000263A 83C402                   add  sp, 2
  4265                                  
  4266                                  ;-94     prs(s);
  4267                                  
  4268 0000263D FF7604                   push word [bp+4]
  4269 00002640 E87FFE                   call prs
  4270 00002643 83C402                   add  sp, 2
  4271                                  
  4272                                  ;-95     prs(", Symbol: "); 
  4273                                  
  4274 00002646 68[7726]                 push error1_1
  4275 00002649 E876FE                   call prs
  4276 0000264C 83C402                   add  sp, 2
  4277                                  
  4278                                  ;-96     prs(Symbol);
  4279                                  
  4280 0000264F 8D06[0F00]               lea  ax, [Symbol]
  4281 00002653 50                       push ax
  4282 00002654 E86BFE                   call prs
  4283 00002657 83C402                   add  sp, 2
  4284                                  
  4285                                  ;-97 }
  4286                                  
  4287                                  
  4288                                  ;-98 int errorexit(char *s) { 
  4289 0000265A C9                       LEAVE
  4290 0000265B C3                       ret
  4291                                  ; ENDP
  4292 0000265C 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4293 00002665 6E657874206C696E65-
  4294 0000266E 204552524F523A2000 
  4295 00002677 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4296 00002680 2000               
  4297                                  
  4298                                  errorexit:  ; *** PROC ***
  4299                                  
  4300                                  ;-99     error1(s); 
  4301                                  
  4302                                  ;Function : errorexit, Number of local variables: 1
  4303                                  ;   # type sign width line used address name   list of local variables
  4304                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  4305 00002682 C8000000                 ENTER  0,0
  4306 00002686 FF7604                   push word [bp+4]
  4307 00002689 E897FF                   call error1
  4308 0000268C 83C402                   add  sp, 2
  4309                                  
  4310                                  ;-100     end1(1);
  4311                                  
  4312 0000268F 6A01                     push 1
  4313 00002691 E8C904                   call end1
  4314 00002694 83C402                   add  sp, 2
  4315                                  
  4316                                  ;-101 }
  4317                                  
  4318                                  
  4319                                  ;-102 int allowederror() {error1("not allowed here"); }
  4320 00002697 C9                       LEAVE
  4321 00002698 C3                       ret
  4322                                  ; ENDP
  4323                                  
  4324                                  allowederror:  ; *** PROC ***
  4325 00002699 68[A326]                 push allowederror_0
  4326 0000269C E884FF                   call error1
  4327 0000269F 83C402                   add  sp, 2
  4328                                  
  4329                                  ;-103 int addrerror()    {error1("address missing");} 
  4330                                  
  4331 000026A2 C3                       ret
  4332                                  ; ENDP
  4333 000026A3 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4334 000026AC 6564206865726500   
  4335                                  
  4336                                  addrerror:  ; *** PROC ***
  4337 000026B4 68[BE26]                 push addrerror_0
  4338 000026B7 E869FF                   call error1
  4339 000026BA 83C402                   add  sp, 2
  4340                                  
  4341                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  4342                                  
  4343 000026BD C3                       ret
  4344                                  ; ENDP
  4345 000026BE 61646472657373206D-     addrerror_0 db "address missing",0
  4346 000026C7 697373696E6700     
  4347                                  
  4348                                  immeerror:  ; *** PROC ***
  4349 000026CE 68[D826]                 push immeerror_0
  4350 000026D1 E84FFF                   call error1
  4351 000026D4 83C402                   add  sp, 2
  4352                                  
  4353                                  ;-105 int implerror()    {error1("not implemented");}
  4354                                  
  4355 000026D7 C3                       ret
  4356                                  ; ENDP
  4357 000026D8 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4358 000026E1 206E6F7420616C6C6F-
  4359 000026EA 776564206865726500 
  4360                                  
  4361                                  implerror:  ; *** PROC ***
  4362 000026F3 68[FD26]                 push implerror_0
  4363 000026F6 E82AFF                   call error1
  4364 000026F9 83C402                   add  sp, 2
  4365                                  
  4366                                  ;-106 int indexerror()   {error1("invalid index register");}
  4367                                  
  4368 000026FC C3                       ret
  4369                                  ; ENDP
  4370 000026FD 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4371 00002706 6D656E74656400     
  4372                                  
  4373                                  indexerror:  ; *** PROC ***
  4374 0000270D 68[1727]                 push indexerror_0
  4375 00002710 E810FF                   call error1
  4376 00002713 83C402                   add  sp, 2
  4377                                  
  4378                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  4379                                  
  4380 00002716 C3                       ret
  4381                                  ; ENDP
  4382 00002717 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4383 00002720 6E6465782072656769-
  4384 00002729 7374657200         
  4385                                  
  4386                                  invaloperror:  ; *** PROC ***
  4387 0000272E 68[3827]                 push invaloperror_0
  4388 00002731 E8EFFE                   call error1
  4389 00002734 83C402                   add  sp, 2
  4390                                  
  4391                                  ;-108 int numbererror()  {error1("number expected");}
  4392                                  
  4393 00002737 C3                       ret
  4394                                  ; ENDP
  4395 00002738 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4396 00002741 72206E6F206F706572-
  4397 0000274A 616E647300         
  4398                                  
  4399                                  numbererror:  ; *** PROC ***
  4400 0000274F 68[5927]                 push numbererror_0
  4401 00002752 E8CEFE                   call error1
  4402 00002755 83C402                   add  sp, 2
  4403                                  
  4404                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  4405                                  
  4406 00002758 C3                       ret
  4407                                  ; ENDP
  4408 00002759 6E756D626572206578-     numbererror_0 db "number expected",0
  4409 00002762 70656374656400     
  4410                                  
  4411                                  regmemerror:  ; *** PROC ***
  4412 00002769 68[7327]                 push regmemerror_0
  4413 0000276C E8B4FE                   call error1
  4414 0000276F 83C402                   add  sp, 2
  4415                                  
  4416                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  4417                                  
  4418 00002772 C3                       ret
  4419                                  ; ENDP
  4420 00002773 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4421 0000277C 73746572206F72206D-
  4422 00002785 656D6F727920616C6C-
  4423 0000278E 6F77656400         
  4424                                  
  4425                                  reg16error:  ; *** PROC ***
  4426 00002793 68[9D27]                 push reg16error_0
  4427 00002796 E88AFE                   call error1
  4428 00002799 83C402                   add  sp, 2
  4429                                  
  4430                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  4431                                  
  4432 0000279C C3                       ret
  4433                                  ; ENDP
  4434 0000279D 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4435 000027A6 362C206E6F20736567-
  4436 000027AF 72656720616C6C6F77-
  4437 000027B8 656400             
  4438                                  
  4439                                  segregerror:  ; *** PROC ***
  4440 000027BB 68[C527]                 push segregerror_0
  4441 000027BE E862FE                   call error1
  4442 000027C1 83C402                   add  sp, 2
  4443                                  
  4444                                  ;-112 int syntaxerror()  {error1("syntax");}
  4445                                  
  4446 000027C4 C3                       ret
  4447                                  ; ENDP
  4448 000027C5 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4449 000027CE 65676973746572206E-
  4450 000027D7 6F7420616C6C6F7765-
  4451 000027E0 6400               
  4452                                  
  4453                                  syntaxerror:  ; *** PROC ***
  4454 000027E2 68[EC27]                 push syntaxerror_0
  4455 000027E5 E83BFE                   call error1
  4456 000027E8 83C402                   add  sp, 2
  4457                                  
  4458                                  ;-113          
  4459                                  
  4460                                  
  4461                                  ;-114 int addrexit()     {errorexit("illegal address");}
  4462                                  
  4463 000027EB C3                       ret
  4464                                  ; ENDP
  4465 000027EC 73796E74617800          syntaxerror_0 db "syntax",0
  4466                                  
  4467                                  addrexit:  ; *** PROC ***
  4468 000027F3 68[FD27]                 push addrexit_0
  4469 000027F6 E889FE                   call errorexit
  4470 000027F9 83C402                   add  sp, 2
  4471                                  
  4472                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  4473                                  
  4474 000027FC C3                       ret
  4475                                  ; ENDP
  4476 000027FD 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4477 00002806 64647265737300     
  4478                                  
  4479                                  internexit:  ; *** PROC ***
  4480 0000280D 68[1728]                 push internexit_0
  4481 00002810 E86FFE                   call errorexit
  4482 00002813 83C402                   add  sp, 2
  4483 00002816 C3                       ret
  4484                                  ; ENDP
  4485 00002817 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4486 00002820 6D70696C6572206572-
  4487 00002829 726F7200           
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
  4501 0000282D E80A00                   call getarg
  4502                                  
  4503                                  ;-3     parse(); 
  4504                                  
  4505 00002830 E8D8EE                   call parse
  4506                                  
  4507                                  ;-4     epilog(); 
  4508                                  
  4509 00002833 E85C02                   call epilog
  4510                                  
  4511                                  ;-5     end1();
  4512                                  
  4513 00002836 E82403                   call end1
  4514                                  
  4515                                  ;-6 }
  4516                                  
  4517                                  
  4518                                  ;-7 
  4519                                  
  4520                                  
  4521                                  ;-8 int getarg() { 
  4522                                  
  4523 00002839 C3                       ret
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
  4538 0000283A C8060000                 ENTER  6,0
  4539 0000283E 8B1E[520E]               mov bx, [arglen]
  4540 00002842 8A07                     mov al, [bx]
  4541 00002844 B400                     mov ah, 0
  4542 00002846 8946FE                   mov word [bp-2], ax
  4543                                  
  4544                                  ;-11     if (arglen1==0) {
  4545                                  
  4546 00002849 8B46FE                   mov ax, [bp-2]
  4547 0000284C 83F800                   cmp ax, 0
  4548 0000284F 0F851C00                 jne @@getarg191
  4549                                  
  4550                                  ;-12         cputs(Version1);
  4551                                  
  4552 00002853 8D06[0300]               lea  ax, [Version1]
  4553 00002857 50                       push ax
  4554 00002858 E8620B                   call cputs
  4555 0000285B 83C402                   add  sp, 2
  4556                                  
  4557                                  ;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4558                                  
  4559 0000285E 68[FF29]                 push getarg_0
  4560 00002861 E8590B                   call cputs
  4561 00002864 83C402                   add  sp, 2
  4562                                  
  4563                                  ;-14         exitR(3);
  4564                                  
  4565 00002867 6A03                     push 3
  4566 00002869 E82C0D                   call exitR
  4567 0000286C 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-15     }
  4570                                  
  4571                                  
  4572                                  ;-16     i=arglen1+129; 
  4573                                  
  4574                                  @@getarg191:
  4575 0000286F 8B46FE                   mov ax, [bp-2]
  4576 00002872 058100                   add ax, 129
  4577 00002875 8946FC                   mov word [bp-4], ax
  4578                                  
  4579                                  ;-17     *i=0;  
  4580                                  
  4581 00002878 66B800000000             mov eax, 0
  4582 0000287E 8B5EFC                   mov  bx, [bp-4]
  4583 00002881 8907                     mov  [bx], ax
  4584                                  
  4585                                  ;-18     arglen1--;
  4586                                  
  4587 00002883 FF4EFE                   dec  word [bp-2]
  4588                                  
  4589                                  ;-19     toupper(argv);
  4590                                  
  4591 00002886 FF36[540E]               push word [argv]
  4592 0000288A E85E0B                   call toupper
  4593 0000288D 83C402                   add  sp, 2
  4594                                  
  4595                                  ;-20   
  4596                                  
  4597                                  
  4598                                  ;-21     strcpy(namein, argv); strcat1(namein, ".S");
  4599                                  
  4600 00002890 FF36[540E]               push word [argv]
  4601 00002894 8D06[D000]               lea  ax, [namein]
  4602 00002898 50                       push ax
  4603 00002899 E8BD0B                   call strcpy
  4604 0000289C 83C404                   add  sp, 4
  4605 0000289F 68[242A]                 push getarg_1
  4606 000028A2 8D06[D000]               lea  ax, [namein]
  4607 000028A6 50                       push ax
  4608 000028A7 E8700C                   call strcat1
  4609 000028AA 83C404                   add  sp, 4
  4610                                  
  4611                                  ;-22     strcpy(namelst,argv); strcat1(namelst,".LST");
  4612                                  
  4613 000028AD FF36[540E]               push word [argv]
  4614 000028B1 8D06[1301]               lea  ax, [namelst]
  4615 000028B5 50                       push ax
  4616 000028B6 E8A00B                   call strcpy
  4617 000028B9 83C404                   add  sp, 4
  4618 000028BC 68[272A]                 push getarg_2
  4619 000028BF 8D06[1301]               lea  ax, [namelst]
  4620 000028C3 50                       push ax
  4621 000028C4 E8530C                   call strcat1
  4622 000028C7 83C404                   add  sp, 4
  4623                                  
  4624                                  ;-23     strcpy(namebin,argv); strcat1(namebin,".COM");
  4625                                  
  4626 000028CA FF36[540E]               push word [argv]
  4627 000028CE 8D06[5601]               lea  ax, [namebin]
  4628 000028D2 50                       push ax
  4629 000028D3 E8830B                   call strcpy
  4630 000028D6 83C404                   add  sp, 4
  4631 000028D9 68[2C2A]                 push getarg_3
  4632 000028DC 8D06[5601]               lea  ax, [namebin]
  4633 000028E0 50                       push ax
  4634 000028E1 E8360C                   call strcat1
  4635 000028E4 83C404                   add  sp, 4
  4636                                  
  4637                                  ;-24 
  4638                                  
  4639                                  
  4640                                  ;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4641                                  
  4642 000028E7 66B801000000             mov eax, 1
  4643 000028ED A2[0E00]                 mov byte [LIST], al
  4644 000028F0 66B800000000             mov eax, 0
  4645 000028F6 A3[9F01]                 mov word [DOS_ERR], ax
  4646 000028F9 66B800000000             mov eax, 0
  4647 000028FF A3[A601]                 mov word [PC], ax
  4648 00002902 66B800000000             mov eax, 0
  4649 00002908 A3[A101]                 mov word [ErrorCount], ax
  4650                                  
  4651                                  ;-26   
  4652                                  
  4653                                  
  4654                                  ;-27     asm_fd=openR (namein);
  4655                                  
  4656 0000290B 8D06[D000]               lea  ax, [namein]
  4657 0000290F 50                       push ax
  4658 00002910 E82C0C                   call openR
  4659 00002913 83C402                   add  sp, 2
  4660 00002916 A3[9901]                 mov word [asm_fd], ax
  4661                                  
  4662                                  ;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4663                                  
  4664 00002919 A1[9F01]                 mov ax, [DOS_ERR]
  4665 0000291C 08C0                     or  al, al
  4666 0000291E 0F841C00                 je @@getarg192
  4667 00002922 68[312A]                 push getarg_4
  4668 00002925 E8950A                   call cputs
  4669 00002928 83C402                   add  sp, 2
  4670 0000292B 8D06[D000]               lea  ax, [namein]
  4671 0000292F 50                       push ax
  4672 00002930 E88A0A                   call cputs
  4673 00002933 83C402                   add  sp, 2
  4674 00002936 6A01                     push 1
  4675 00002938 E85D0C                   call exitR
  4676 0000293B 83C402                   add  sp, 2
  4677                                  
  4678                                  ;-29     lst_fd=creatR(namelst);
  4679                                  
  4680                                  @@getarg192:
  4681 0000293E 8D06[1301]               lea  ax, [namelst]
  4682 00002942 50                       push ax
  4683 00002943 E8080C                   call creatR
  4684 00002946 83C402                   add  sp, 2
  4685 00002949 A3[9B01]                 mov word [lst_fd], ax
  4686                                  
  4687                                  ;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4688                                  
  4689 0000294C A1[9F01]                 mov ax, [DOS_ERR]
  4690 0000294F 08C0                     or  al, al
  4691 00002951 0F841C00                 je @@getarg193
  4692 00002955 68[472A]                 push getarg_5
  4693 00002958 E8620A                   call cputs
  4694 0000295B 83C402                   add  sp, 2
  4695 0000295E 8D06[1301]               lea  ax, [namelst]
  4696 00002962 50                       push ax
  4697 00002963 E8570A                   call cputs
  4698 00002966 83C402                   add  sp, 2
  4699 00002969 6A02                     push 2
  4700 0000296B E82A0C                   call exitR
  4701 0000296E 83C402                   add  sp, 2
  4702                                  
  4703                                  ;-31     bin_fd=creatR(namebin);
  4704                                  
  4705                                  @@getarg193:
  4706 00002971 8D06[5601]               lea  ax, [namebin]
  4707 00002975 50                       push ax
  4708 00002976 E8D50B                   call creatR
  4709 00002979 83C402                   add  sp, 2
  4710 0000297C A3[9D01]                 mov word [bin_fd], ax
  4711                                  
  4712                                  ;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4713                                  
  4714 0000297F A1[9F01]                 mov ax, [DOS_ERR]
  4715 00002982 08C0                     or  al, al
  4716 00002984 0F841C00                 je @@getarg194
  4717 00002988 68[5E2A]                 push getarg_6
  4718 0000298B E82F0A                   call cputs
  4719 0000298E 83C402                   add  sp, 2
  4720 00002991 8D06[5601]               lea  ax, [namebin]
  4721 00002995 50                       push ax
  4722 00002996 E8240A                   call cputs
  4723 00002999 83C402                   add  sp, 2
  4724 0000299C 6A02                     push 2
  4725 0000299E E8F70B                   call exitR
  4726 000029A1 83C402                   add  sp, 2
  4727                                  
  4728                                  ;-33   
  4729                                  
  4730                                  
  4731                                  ;-34     prs(";"); 
  4732                                  
  4733                                  @@getarg194:
  4734 000029A4 68[742A]                 push getarg_7
  4735 000029A7 E818FB                   call prs
  4736 000029AA 83C402                   add  sp, 2
  4737                                  
  4738                                  ;-35     prs(Version1);
  4739                                  
  4740 000029AD 8D06[0300]               lea  ax, [Version1]
  4741 000029B1 50                       push ax
  4742 000029B2 E80DFB                   call prs
  4743 000029B5 83C402                   add  sp, 2
  4744                                  
  4745                                  ;-36     prs(", Source: "); prs(namein);  
  4746                                  
  4747 000029B8 68[762A]                 push getarg_8
  4748 000029BB E804FB                   call prs
  4749 000029BE 83C402                   add  sp, 2
  4750 000029C1 8D06[D000]               lea  ax, [namein]
  4751 000029C5 50                       push ax
  4752 000029C6 E8F9FA                   call prs
  4753 000029C9 83C402                   add  sp, 2
  4754                                  
  4755                                  ;-37     prs(", Output: "); prs(namelst);
  4756                                  
  4757 000029CC 68[812A]                 push getarg_9
  4758 000029CF E8F0FA                   call prs
  4759 000029D2 83C402                   add  sp, 2
  4760 000029D5 8D06[1301]               lea  ax, [namelst]
  4761 000029D9 50                       push ax
  4762 000029DA E8E5FA                   call prs
  4763 000029DD 83C402                   add  sp, 2
  4764                                  
  4765                                  ;-38     prs(", "); prs(namebin);
  4766                                  
  4767 000029E0 68[8C2A]                 push getarg_10
  4768 000029E3 E8DCFA                   call prs
  4769 000029E6 83C402                   add  sp, 2
  4770 000029E9 8D06[5601]               lea  ax, [namebin]
  4771 000029ED 50                       push ax
  4772 000029EE E8D1FA                   call prs
  4773 000029F1 83C402                   add  sp, 2
  4774                                  
  4775                                  ;-39     prs("\n");
  4776                                  
  4777 000029F4 68[8F2A]                 push getarg_11
  4778 000029F7 E8C8FA                   call prs
  4779 000029FA 83C402                   add  sp, 2
  4780                                  
  4781                                  ;-40 }
  4782                                  
  4783                                  
  4784                                  ;-41 
  4785                                  
  4786                                  
  4787                                  ;-42 int epilog() { 
  4788 000029FD C9                       LEAVE
  4789 000029FE C3                       ret
  4790                                  ; ENDP
  4791 000029FF 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  4792 00002A08 41532E434F4D206669-
  4793 00002A11 6C656E616D65205B77-
  4794 00002A1A 2F6F202E535D203A20-
  4795 00002A23 00                 
  4796 00002A24 2E5300                  getarg_1 db ".S",0
  4797 00002A27 2E4C535400              getarg_2 db ".LST",0
  4798 00002A2C 2E434F4D00              getarg_3 db ".COM",0
  4799 00002A31 536F75726365206669-     getarg_4 db "Source file missing: ",0
  4800 00002A3A 6C65206D697373696E-
  4801 00002A43 673A2000           
  4802 00002A47 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  4803 00002A50 206E6F742063726561-
  4804 00002A59 74653A2000         
  4805 00002A5E 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  4806 00002A67 6E6F74206372656174-
  4807 00002A70 653A2000           
  4808 00002A74 3B00                    getarg_7 db ";",0
  4809 00002A76 2C20536F757263653A-     getarg_8 db ", Source: ",0
  4810 00002A7F 2000               
  4811 00002A81 2C204F75747075743A-     getarg_9 db ", Output: ",0
  4812 00002A8A 2000               
  4813 00002A8C 2C2000                  getarg_10 db ", ",0
  4814 00002A8F 5C6E00                  getarg_11 db "\n",0
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
  4828 00002A92 C8060000                 ENTER  6,0
  4829 00002A96 68[202B]                 push epilog_0
  4830 00002A99 E826FA                   call prs
  4831 00002A9C 83C402                   add  sp, 2
  4832                                  
  4833                                  ;-45     printIntU(ErrorCount);
  4834                                  
  4835 00002A9F FF36[A101]               push word [ErrorCount]
  4836 00002AA3 E83BFB                   call printIntU
  4837 00002AA6 83C402                   add  sp, 2
  4838                                  
  4839                                  ;-46     if (ErrorCount) prs(" ***ERROR*** ");
  4840                                  
  4841 00002AA9 A1[A101]                 mov ax, [ErrorCount]
  4842 00002AAC 08C0                     or  al, al
  4843 00002AAE 0F840900                 je @@epilog195
  4844 00002AB2 68[302B]                 push epilog_1
  4845 00002AB5 E80AFA                   call prs
  4846 00002AB8 83C402                   add  sp, 2
  4847                                  
  4848                                  ;-47     prs(", Output: "); prs(namelst);
  4849                                  
  4850                                  @@epilog195:
  4851 00002ABB 68[3E2B]                 push epilog_2
  4852 00002ABE E801FA                   call prs
  4853 00002AC1 83C402                   add  sp, 2
  4854 00002AC4 8D06[1301]               lea  ax, [namelst]
  4855 00002AC8 50                       push ax
  4856 00002AC9 E8F6F9                   call prs
  4857 00002ACC 83C402                   add  sp, 2
  4858                                  
  4859                                  ;-48     prs(", COM file "); 
  4860                                  
  4861 00002ACF 68[492B]                 push epilog_3
  4862 00002AD2 E8EDF9                   call prs
  4863 00002AD5 83C402                   add  sp, 2
  4864                                  
  4865                                  ;-49     printIntU(BinLen); 
  4866                                  
  4867 00002AD8 FF36[500E]               push word [BinLen]
  4868 00002ADC E802FB                   call printIntU
  4869 00002ADF 83C402                   add  sp, 2
  4870                                  
  4871                                  ;-50     prs(" bytes.");
  4872                                  
  4873 00002AE2 68[552B]                 push epilog_4
  4874 00002AE5 E8DAF9                   call prs
  4875 00002AE8 83C402                   add  sp, 2
  4876                                  
  4877                                  ;-51 
  4878                                  
  4879                                  
  4880                                  ;-52     i=0;
  4881                                  
  4882 00002AEB 66B800000000             mov eax, 0
  4883 00002AF1 8946FE                   mov word [bp-2], ax
  4884                                  
  4885                                  ;-53     do {
  4886                                  
  4887                                  @@epilog196:
  4888                                  
  4889                                  ;-54         c = FileBin[i];
  4890                                  
  4891 00002AF4 8B5EFE                   mov bx, [bp-2]
  4892 00002AF7 8A87[8006]               mov al, [FileBin + bx]
  4893 00002AFB 8846FA                   mov byte [bp-6], al
  4894                                  
  4895                                  ;-55         fputcR(c, bin_fd);
  4896                                  
  4897 00002AFE FF36[9D01]               push word [bin_fd]
  4898 00002B02 8A46FA                   mov al, byte [bp-6]
  4899 00002B05 B400                     mov ah, 0
  4900 00002B07 50                       push ax
  4901 00002B08 E86A0A                   call fputcR
  4902 00002B0B 83C404                   add  sp, 4
  4903                                  
  4904                                  ;-56         i++;
  4905                                  
  4906 00002B0E FF46FE                   inc  word [bp-2]
  4907                                  
  4908                                  ;-57     } while (i < BinLen);
  4909                                  
  4910 00002B11 8B46FE                   mov ax, [bp-2]
  4911 00002B14 3B06[500E]               cmp ax, [BinLen]
  4912 00002B18 0F8D0200                 jge @@epilog197
  4913 00002B1C EBD6                     jmp @@epilog196
  4914                                  @@epilog197:
  4915                                  
  4916                                  ;-58 }
  4917                                  
  4918                                  
  4919                                  ;-59 
  4920                                  
  4921                                  
  4922                                  ;-60 int end1(int n) {
  4923 00002B1E C9                       LEAVE
  4924 00002B1F C3                       ret
  4925                                  ; ENDP
  4926 00002B20 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4927 00002B29 726F72733A2000     
  4928 00002B30 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4929 00002B39 2A2A2A2000         
  4930 00002B3E 2C204F75747075743A-     epilog_2 db ", Output: ",0
  4931 00002B47 2000               
  4932 00002B49 2C20434F4D2066696C-     epilog_3 db ", COM file ",0
  4933 00002B52 652000             
  4934 00002B55 2062797465732E00        epilog_4 db " bytes.",0
  4935                                  
  4936                                  end1:  ; *** PROC ***
  4937                                  
  4938                                  ;-61   fcloseR(asm_fd);
  4939                                  
  4940                                  ;Function : end1, Number of local variables: 1
  4941                                  ;   # type sign width line used address name   list of local variables
  4942                                  ;  200 var sign word    60 NULL bp+4    n;
  4943 00002B5D C8000000                 ENTER  0,0
  4944 00002B61 FF36[9901]               push word [asm_fd]
  4945 00002B65 E8220A                   call fcloseR
  4946 00002B68 83C402                   add  sp, 2
  4947                                  
  4948                                  ;-62   fcloseR(lst_fd);
  4949                                  
  4950 00002B6B FF36[9B01]               push word [lst_fd]
  4951 00002B6F E8180A                   call fcloseR
  4952 00002B72 83C402                   add  sp, 2
  4953                                  
  4954                                  ;-63   fcloseR(bin_fd);
  4955                                  
  4956 00002B75 FF36[9D01]               push word [bin_fd]
  4957 00002B79 E80E0A                   call fcloseR
  4958 00002B7C 83C402                   add  sp, 2
  4959                                  
  4960                                  ;-64   exitR(n);
  4961                                  
  4962 00002B7F FF7604                   push word [bp+4]
  4963 00002B82 E8130A                   call exitR
  4964 00002B85 83C402                   add  sp, 2
  4965                                  
  4966                                  ;-65 }
  4967 00002B88 C9                       LEAVE
  4968 00002B89 C3                       ret
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
  4986 00002B8A FF06[C701]               inc  word [OpCodePtr]
  4987 00002B8E 8B1E[C701]               mov bx, [OpCodePtr]
  4988 00002B92 8A07                     mov al, [bx]
  4989 00002B94 B400                     mov ah, 0
  4990 00002B96 A2[AF01]                 mov byte [Code1], al
  4991                                  
  4992                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4993                                  
  4994 00002B99 FF06[C701]               inc  word [OpCodePtr]
  4995 00002B9D 8B1E[C701]               mov bx, [OpCodePtr]
  4996 00002BA1 8A07                     mov al, [bx]
  4997 00002BA3 B400                     mov ah, 0
  4998 00002BA5 A2[B001]                 mov byte [Code2], al
  4999                                  
  5000                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5001                                  
  5002 00002BA8 FF06[C701]               inc  word [OpCodePtr]
  5003 00002BAC 8B1E[C701]               mov bx, [OpCodePtr]
  5004 00002BB0 8A07                     mov al, [bx]
  5005 00002BB2 B400                     mov ah, 0
  5006 00002BB4 A2[B101]                 mov byte [Code3], al
  5007                                  
  5008                                  ;-6 }
  5009                                  
  5010                                  
  5011                                  ;-7 int gen66h() {genCode8(0x66);
  5012                                  
  5013 00002BB7 C3                       ret
  5014                                  ; ENDP
  5015                                  
  5016                                  gen66h:  ; *** PROC ***
  5017 00002BB8 6A66                     push 102
  5018 00002BBA E83B00                   call genCode8
  5019 00002BBD 83C402                   add  sp, 2
  5020                                  
  5021                                  ;-8 }
  5022                                  
  5023                                  
  5024                                  ;-9 int genCode2(char c, char d) {
  5025                                  
  5026 00002BC0 C3                       ret
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
  5037 00002BC1 C8000000                 ENTER  0,0
  5038 00002BC5 8A4604                   mov al, [bp+4]
  5039 00002BC8 024606                   add al, [bp+6]
  5040 00002BCB 884604                   mov byte [bp+4], al
  5041                                  
  5042                                  ;-11     genCode8(c);
  5043                                  
  5044 00002BCE 8A4604                   mov al, byte [bp+4]
  5045 00002BD1 B400                     mov ah, 0
  5046 00002BD3 50                       push ax
  5047 00002BD4 E82100                   call genCode8
  5048 00002BD7 83C402                   add  sp, 2
  5049                                  
  5050                                  ;-12 }                             
  5051                                  
  5052                                  
  5053                                  ;-13 int genCodeW(char c) {
  5054 00002BDA C9                       LEAVE
  5055 00002BDB C3                       ret
  5056                                  ; ENDP
  5057                                  
  5058                                  genCodeW:  ; *** PROC ***
  5059                                  
  5060                                  ;-14     c = c + wflag;  
  5061                                  
  5062                                  ;Function : genCodeW, Number of local variables: 1
  5063                                  ;   # type sign width line used address name   list of local variables
  5064                                  ;  200 var sign byte    13 NULL bp+4    c;
  5065 00002BDC C8000000                 ENTER  0,0
  5066 00002BE0 8A4604                   mov al, [bp+4]
  5067 00002BE3 0206[B701]               add al, [wflag]
  5068 00002BE7 884604                   mov byte [bp+4], al
  5069                                  
  5070                                  ;-15     genCode8(c);
  5071                                  
  5072 00002BEA 8A4604                   mov al, byte [bp+4]
  5073 00002BED B400                     mov ah, 0
  5074 00002BEF 50                       push ax
  5075 00002BF0 E80500                   call genCode8
  5076 00002BF3 83C402                   add  sp, 2
  5077                                  
  5078                                  ;-16 }   
  5079                                  
  5080                                  
  5081                                  ;-17 int genCode8(char c) {
  5082 00002BF6 C9                       LEAVE
  5083 00002BF7 C3                       ret
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
  5096 00002BF8 C8000000                 ENTER  0,0
  5097 00002BFC 8A4604                   mov al, [bp+4]
  5098 00002BFF 8B1E[500E]               mov bx, [BinLen]
  5099 00002C03 8887[8006]               mov [FileBin+bx], al
  5100                                  
  5101                                  ;-20     BinLen++;
  5102                                  
  5103 00002C07 FF06[500E]               inc  word [BinLen]
  5104                                  
  5105                                  ;-21     PC++;
  5106                                  
  5107 00002C0B FF06[A601]               inc  word [PC]
  5108                                  
  5109                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5110                                  
  5111 00002C0F A1[500E]                 mov ax, [BinLen]
  5112 00002C12 3DD007                   cmp ax, 2000 ;unsigned : 0
  5113 00002C15 0F820900                 jb  @@genCode8198
  5114 00002C19 68[3D2C]                 push genCode8_0
  5115 00002C1C E863FA                   call errorexit
  5116 00002C1F 83C402                   add  sp, 2
  5117                                  
  5118                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5119                                  
  5120                                  @@genCode8198:
  5121 00002C22 A1[C501]                 mov ax, [OpPrintIndex]
  5122 00002C25 83F805                   cmp ax, 5
  5123 00002C28 0F8D0F00                 jge @@genCode8199
  5124                                  
  5125                                  ;-24         OpPos[OpPrintIndex]=c;
  5126                                  
  5127 00002C2C 8A4604                   mov al, [bp+4]
  5128 00002C2F 8B1E[C501]               mov bx, [OpPrintIndex]
  5129 00002C33 8887[C001]               mov [OpPos+bx], al
  5130                                  
  5131                                  ;-25         OpPrintIndex++;
  5132                                  
  5133 00002C37 FF06[C501]               inc  word [OpPrintIndex]
  5134                                  
  5135                                  ;-26     }
  5136                                  
  5137                                  
  5138                                  ;-27 }
  5139                                  
  5140                                  @@genCode8199:
  5141                                  
  5142                                  ;-28 int genCode16(unsigned int i) {
  5143 00002C3B C9                       LEAVE
  5144 00002C3C C3                       ret
  5145                                  ; ENDP
  5146 00002C3D 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5147 00002C46 746F6F206C6F6E6700 
  5148                                  
  5149                                  genCode16:  ; *** PROC ***
  5150                                  
  5151                                  ;-29     genCode8(i); i=i >> 8;
  5152                                  
  5153                                  ;Function : genCode16, Number of local variables: 1
  5154                                  ;   # type sign width line used address name   list of local variables
  5155                                  ;  200 var unsg word    28 NULL bp+4    i;
  5156 00002C4F C8000000                 ENTER  0,0
  5157 00002C53 FF7604                   push word [bp+4]
  5158 00002C56 E89FFF                   call genCode8
  5159 00002C59 83C402                   add  sp, 2
  5160 00002C5C 8B4604                   mov ax, [bp+4]
  5161 00002C5F C1E808                   shr ax, 8
  5162 00002C62 894604                   mov word [bp+4], ax
  5163                                  
  5164                                  ;-30     genCode8(i);
  5165                                  
  5166 00002C65 FF7604                   push word [bp+4]
  5167 00002C68 E88DFF                   call genCode8
  5168 00002C6B 83C402                   add  sp, 2
  5169                                  
  5170                                  ;-31 }
  5171                                  
  5172                                  
  5173                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5174 00002C6E C9                       LEAVE
  5175 00002C6F C3                       ret
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
  5198 00002C70 C8020000                 ENTER  2,0
  5199 00002C74 66B800000000             mov eax, 0
  5200 00002C7A 8846FE                   mov byte [bp-2], al
  5201                                  
  5202                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5203                                  
  5204 00002C7D 8A4604                   mov al, [bp+4]
  5205 00002C80 C0E003                   shl al, 3
  5206 00002C83 884604                   mov byte [bp+4], al
  5207                                  
  5208                                  ;-39     if (Op == REG) {
  5209                                  
  5210 00002C86 A0[AC01]                 mov al, [Op]
  5211 00002C89 3C02                     cmp al, 2
  5212 00002C8B 0F853A00                 jne @@writeEA200
  5213                                  
  5214                                  ;-40         xxx |= 0xC0;     
  5215                                  
  5216 00002C8F 804E04C0                 or  byte [bp+4], 192
  5217                                  
  5218                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5219                                  
  5220 00002C93 A0[AD01]                 mov al, [Op2]
  5221 00002C96 3C01                     cmp al, 1
  5222 00002C98 0F8F0D00                 jg  @@writeEA201
  5223 00002C9C 8A4604                   mov al, [bp+4]
  5224 00002C9F 0206[B301]               add al, [R1No]
  5225 00002CA3 884604                   mov byte [bp+4], al
  5226                                  
  5227                                  ;-42             else {
  5228                                  
  5229 00002CA6 E92000                   jmp @@writeEA202
  5230                                  @@writeEA201:
  5231                                  
  5232                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5233                                  
  5234 00002CA9 A0[AD01]                 mov al, [Op2]
  5235 00002CAC 3C02                     cmp al, 2
  5236 00002CAE 0F850D00                 jne @@writeEA203
  5237 00002CB2 8A4604                   mov al, [bp+4]
  5238 00002CB5 0206[B301]               add al, [R1No]
  5239 00002CB9 884604                   mov byte [bp+4], al
  5240                                  
  5241                                  ;-44                 else            xxx = xxx + R2No;  
  5242                                  
  5243 00002CBC E90A00                   jmp @@writeEA204
  5244                                  @@writeEA203:
  5245 00002CBF 8A4604                   mov al, [bp+4]
  5246 00002CC2 0206[B201]               add al, [R2No]
  5247 00002CC6 884604                   mov byte [bp+4], al
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
  5260 00002CC9 A0[AC01]                 mov al, [Op]
  5261 00002CCC 3C04                     cmp al, 4
  5262 00002CCE 0F857F00                 jne @@writeEA205
  5263                                  
  5264                                  ;-48         if (isDirect) {
  5265                                  
  5266 00002CD2 A0[BB01]                 mov al, [isDirect]
  5267 00002CD5 08C0                     or  al, al
  5268 00002CD7 0F841000                 je @@writeEA206
  5269                                  
  5270                                  ;-49             xxx |= 6;
  5271                                  
  5272 00002CDB 804E0406                 or  byte [bp+4], 6
  5273                                  
  5274                                  ;-50             len = 2;
  5275                                  
  5276 00002CDF 66B802000000             mov eax, 2
  5277 00002CE5 8846FE                   mov byte [bp-2], al
  5278                                  
  5279                                  ;-51         }
  5280                                  
  5281                                  
  5282                                  ;-52         else { 
  5283                                  
  5284 00002CE8 E96600                   jmp @@writeEA207
  5285                                  @@writeEA206:
  5286                                  
  5287                                  ;-53             xxx = xxx + rm;   
  5288                                  
  5289 00002CEB 8A4604                   mov al, [bp+4]
  5290 00002CEE 0206[BA01]               add al, [rm]
  5291 00002CF2 884604                   mov byte [bp+4], al
  5292                                  
  5293                                  ;-54             if (rm == 6) {//make [BP+00]
  5294                                  
  5295 00002CF5 A0[BA01]                 mov al, [rm]
  5296 00002CF8 3C06                     cmp al, 6
  5297 00002CFA 0F851700                 jne @@writeEA208
  5298                                  
  5299                                  ;-55                 len=1;
  5300                                  
  5301 00002CFE 66B801000000             mov eax, 1
  5302 00002D04 8846FE                   mov byte [bp-2], al
  5303                                  
  5304                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5305                                  
  5306 00002D07 A1[BC01]                 mov ax, [disp]
  5307 00002D0A 83F800                   cmp ax, 0
  5308 00002D0D 0F850400                 jne @@writeEA209
  5309 00002D11 804E0440                 or  byte [bp+4], 64
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
  5321 00002D15 A1[BC01]                 mov ax, [disp]
  5322 00002D18 08C0                     or  al, al
  5323 00002D1A 0F843300                 je @@writeEA210
  5324                                  
  5325                                  ;-60                 ax = disp;
  5326                                  
  5327 00002D1E A1[BC01]                 mov  ax, [disp]
  5328                                  
  5329                                  ;-61                 if(ax > 127) len=2;
  5330                                  
  5331 00002D21 83F87F                   cmp  ax, 127
  5332 00002D24 0F8E0C00                 jle @@writeEA211
  5333 00002D28 66B802000000             mov eax, 2
  5334 00002D2E 8846FE                   mov byte [bp-2], al
  5335                                  
  5336                                  ;-62                 else len=1;
  5337                                  
  5338 00002D31 E90900                   jmp @@writeEA212
  5339                                  @@writeEA211:
  5340 00002D34 66B801000000             mov eax, 1
  5341 00002D3A 8846FE                   mov byte [bp-2], al
  5342                                  
  5343                                  ;-63                 if (len == 1) xxx |= 0x40;
  5344                                  
  5345                                  @@writeEA212:
  5346 00002D3D 8A46FE                   mov al, [bp-2]
  5347 00002D40 3C01                     cmp al, 1
  5348 00002D42 0F850700                 jne @@writeEA213
  5349 00002D46 804E0440                 or  byte [bp+4], 64
  5350                                  
  5351                                  ;-64                 else xxx |= 0x80;
  5352                                  
  5353 00002D4A E90400                   jmp @@writeEA214
  5354                                  @@writeEA213:
  5355 00002D4D 804E0480                 or  byte [bp+4], 128
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
  5375 00002D51 8A4604                   mov al, byte [bp+4]
  5376 00002D54 B400                     mov ah, 0
  5377 00002D56 50                       push ax
  5378 00002D57 E89EFE                   call genCode8
  5379 00002D5A 83C402                   add  sp, 2
  5380                                  
  5381                                  ;-70     if (len == 1) genCode8 (disp);
  5382                                  
  5383 00002D5D 8A46FE                   mov al, [bp-2]
  5384 00002D60 3C01                     cmp al, 1
  5385 00002D62 0F850A00                 jne @@writeEA215
  5386 00002D66 FF36[BC01]               push word [disp]
  5387 00002D6A E88BFE                   call genCode8
  5388 00002D6D 83C402                   add  sp, 2
  5389                                  
  5390                                  ;-71     if (len == 2) genCode16(disp);
  5391                                  
  5392                                  @@writeEA215:
  5393 00002D70 8A46FE                   mov al, [bp-2]
  5394 00002D73 3C02                     cmp al, 2
  5395 00002D75 0F850A00                 jne @@writeEA216
  5396 00002D79 FF36[BC01]               push word [disp]
  5397 00002D7D E8CFFE                   call genCode16
  5398 00002D80 83C402                   add  sp, 2
  5399                                  
  5400                                  ;-72 }
  5401                                  
  5402                                  @@writeEA216:
  5403                                  
  5404                                  ;-73 
  5405                                  
  5406                                  
  5407                                  ;-74 int genImmediate() { 
  5408 00002D83 C9                       LEAVE
  5409 00002D84 C3                       ret
  5410                                  ; ENDP
  5411                                  
  5412                                  genImmediate:  ; *** PROC ***
  5413                                  
  5414                                  ;-75     if (wflag) genCode16(imme);
  5415                                  
  5416 00002D85 A0[B701]                 mov al, [wflag]
  5417 00002D88 08C0                     or  al, al
  5418 00002D8A 0F840D00                 je @@genImmediate217
  5419 00002D8E FF36[BE01]               push word [imme]
  5420 00002D92 E8BAFE                   call genCode16
  5421 00002D95 83C402                   add  sp, 2
  5422                                  
  5423                                  ;-76     else       genCode8 (imme);  
  5424                                  
  5425 00002D98 E90A00                   jmp @@genImmediate218
  5426                                  @@genImmediate217:
  5427 00002D9B FF36[BE01]               push word [imme]
  5428 00002D9F E856FE                   call genCode8
  5429 00002DA2 83C402                   add  sp, 2
  5430                                  
  5431                                  ;-77 }    
  5432                                  
  5433                                  @@genImmediate218:
  5434 00002DA5 C3                       ret
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
  5454 00002DA6 C8020000                 ENTER  2,0
  5455 00002DAA 66B800000000             mov eax, 0
  5456 00002DB0 A2[BA01]                 mov byte [rm], al
  5457 00002DB3 A2[B701]                 mov byte [wflag], al
  5458 00002DB6 A2[B801]                 mov byte [dflag], al
  5459 00002DB9 A2[B201]                 mov byte [R2No], al
  5460 00002DBC A2[B301]                 mov byte [R1No], al
  5461 00002DBF A2[B401]                 mov byte [R2Type], al
  5462 00002DC2 A2[B501]                 mov byte [R1Type], al
  5463 00002DC5 A2[AD01]                 mov byte [Op2], al
  5464 00002DC8 A2[AC01]                 mov byte [Op], al
  5465                                  
  5466                                  ;-14     disp=imme=0;//int
  5467                                  
  5468 00002DCB 66B800000000             mov eax, 0
  5469 00002DD1 A3[BE01]                 mov word [imme], ax
  5470 00002DD4 A3[BC01]                 mov word [disp], ax
  5471                                  
  5472                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5473                                  
  5474 00002DD7 66B801000000             mov eax, 1
  5475 00002DDD A2[BB01]                 mov byte [isDirect], al
  5476                                  
  5477                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5478                                  
  5479 00002DE0 E812EA                   call getTokeType
  5480                                  
  5481                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5482                                  
  5483 00002DE3 E862ED                   call getCodeSize
  5484 00002DE6 A2[B601]                 mov byte [OpSize], al
  5485                                  
  5486                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5487                                  
  5488 00002DE9 E89EFD                   call getCodes
  5489                                  
  5490                                  ;-19 
  5491                                  
  5492                                  
  5493                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5494                                  
  5495 00002DEC A0[AE01]                 mov al, [CodeType]
  5496 00002DEF 3C01                     cmp al, 1
  5497 00002DF1 0F850F00                 jne @@process219
  5498                                  
  5499                                  ;-21         genCode8(Code1);
  5500                                  
  5501 00002DF5 A0[AF01]                 mov al, byte [Code1]
  5502 00002DF8 B400                     mov ah, 0
  5503 00002DFA 50                       push ax
  5504 00002DFB E8FAFD                   call genCode8
  5505 00002DFE 83C402                   add  sp, 2
  5506                                  
  5507                                  ;-22         return;
  5508                                  
  5509 00002E01 E96105                   jmp @@retn
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
  5520 00002E04 A0[AE01]                 mov al, [CodeType]
  5521 00002E07 3C02                     cmp al, 2
  5522 00002E09 0F856900                 jne @@process220
  5523                                  
  5524                                  ;-26         getOpL();    
  5525                                  
  5526 00002E0D E80EE5                   call getOpL
  5527                                  
  5528                                  ;-27         checkOpL();        
  5529                                  
  5530 00002E10 E82EE4                   call checkOpL
  5531                                  
  5532                                  ;-28         if (Code2 <= 1) {//inc,dec
  5533                                  
  5534 00002E13 A0[B001]                 mov al, [Code2]
  5535 00002E16 3C01                     cmp al, 1
  5536 00002E18 0F8F2700                 jg  @@process221
  5537                                  
  5538                                  ;-29   	        if (Op == REG) {//short
  5539                                  
  5540 00002E1C A0[AC01]                 mov al, [Op]
  5541 00002E1F 3C02                     cmp al, 2
  5542 00002E21 0F851E00                 jne @@process222
  5543                                  
  5544                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5545                                  
  5546 00002E25 A0[B701]                 mov al, [wflag]
  5547 00002E28 08C0                     or  al, al
  5548 00002E2A 0F841500                 je @@process223
  5549 00002E2E A0[B301]                 mov al, byte [R1No]
  5550 00002E31 B400                     mov ah, 0
  5551 00002E33 50                       push ax
  5552 00002E34 A0[B101]                 mov al, byte [Code3]
  5553 00002E37 B400                     mov ah, 0
  5554 00002E39 50                       push ax
  5555 00002E3A E884FD                   call genCode2
  5556 00002E3D 83C404                   add  sp, 4
  5557 00002E40 E92205                   jmp @@retn
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
  5570 00002E43 A0[B001]                 mov al, [Code2]
  5571 00002E46 3C05                     cmp al, 5
  5572 00002E48 0F850F00                 jne @@process224
  5573                                  
  5574                                  ;-34             getTokeType();
  5575                                  
  5576 00002E4C E8A6E9                   call getTokeType
  5577                                  
  5578                                  ;-35             if (TokeType) implerror();
  5579                                  
  5580 00002E4F A0[AB01]                 mov al, [TokeType]
  5581 00002E52 08C0                     or  al, al
  5582 00002E54 0F840300                 je @@process225
  5583 00002E58 E898F8                   call implerror
  5584                                  
  5585                                  ;-36         }
  5586                                  
  5587                                  @@process225:
  5588                                  
  5589                                  ;-37         genCodeW(Code1);           
  5590                                  
  5591                                  @@process224:
  5592 00002E5B A0[AF01]                 mov al, byte [Code1]
  5593 00002E5E B400                     mov ah, 0
  5594 00002E60 50                       push ax
  5595 00002E61 E878FD                   call genCodeW
  5596 00002E64 83C402                   add  sp, 2
  5597                                  
  5598                                  ;-38         writeEA(Code2);
  5599                                  
  5600 00002E67 A0[B001]                 mov al, byte [Code2]
  5601 00002E6A B400                     mov ah, 0
  5602 00002E6C 50                       push ax
  5603 00002E6D E800FE                   call writeEA
  5604 00002E70 83C402                   add  sp, 2
  5605                                  
  5606                                  ;-39         return;
  5607                                  
  5608 00002E73 E9EF04                   jmp @@retn
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
  5619 00002E76 A0[AE01]                 mov al, [CodeType]
  5620 00002E79 3C03                     cmp al, 3
  5621 00002E7B 0F855100                 jne @@process226
  5622                                  
  5623                                  ;-43         check2Ops();    //setwflag not applicable
  5624                                  
  5625 00002E7F E841E4                   call check2Ops
  5626                                  
  5627                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5628                                  
  5629 00002E82 A0[B501]                 mov al, [R1Type]
  5630 00002E85 3C02                     cmp al, 2
  5631 00002E87 0F840300                 je  @@process227
  5632 00002E8B E805F9                   call reg16error
  5633                                  
  5634                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  5635                                  
  5636                                  @@process227:
  5637 00002E8E A0[AD01]                 mov al, [Op2]
  5638 00002E91 3C04                     cmp al, 4
  5639 00002E93 0F840300                 je  @@process228
  5640 00002E97 E81AF8                   call addrerror
  5641                                  
  5642                                  ;-46         
  5643                                  
  5644                                  
  5645                                  ;-47         genCode8(Code1);//les,lds,lea
  5646                                  
  5647                                  @@process228:
  5648 00002E9A A0[AF01]                 mov al, byte [Code1]
  5649 00002E9D B400                     mov ah, 0
  5650 00002E9F 50                       push ax
  5651 00002EA0 E855FD                   call genCode8
  5652 00002EA3 83C402                   add  sp, 2
  5653                                  
  5654                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  5655                                  
  5656 00002EA6 A0[AF01]                 mov al, [Code1]
  5657 00002EA9 3C0F                     cmp al, 15
  5658 00002EAB 0F850C00                 jne @@process229
  5659 00002EAF A0[B001]                 mov al, byte [Code2]
  5660 00002EB2 B400                     mov ah, 0
  5661 00002EB4 50                       push ax
  5662 00002EB5 E840FD                   call genCode8
  5663 00002EB8 83C402                   add  sp, 2
  5664                                  
  5665                                  ;-49         Op=Op2;//set MEM for writeEA
  5666                                  
  5667                                  @@process229:
  5668 00002EBB A0[AD01]                 mov al, [Op2]
  5669 00002EBE A2[AC01]                 mov byte [Op], al
  5670                                  
  5671                                  ;-50         writeEA(R1No);           
  5672                                  
  5673 00002EC1 A0[B301]                 mov al, byte [R1No]
  5674 00002EC4 B400                     mov ah, 0
  5675 00002EC6 50                       push ax
  5676 00002EC7 E8A6FD                   call writeEA
  5677 00002ECA 83C402                   add  sp, 2
  5678                                  
  5679                                  ;-51         return;
  5680                                  
  5681 00002ECD E99504                   jmp @@retn
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
  5692 00002ED0 A0[AE01]                 mov al, [CodeType]
  5693 00002ED3 3C04                     cmp al, 4
  5694 00002ED5 0F85EF00                 jne @@process230
  5695                                  
  5696                                  ;-55         check2Ops();    
  5697                                  
  5698 00002ED9 E8E7E3                   call check2Ops
  5699                                  
  5700                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  5701                                  
  5702 00002EDC A0[AD01]                 mov al, [Op2]
  5703 00002EDF 3C01                     cmp al, 1
  5704 00002EE1 0F857900                 jne @@process231
  5705                                  
  5706                                  ;-57             setsflag();   
  5707                                  
  5708 00002EE5 E8BEE7                   call setsflag
  5709                                  
  5710                                  ;-58             if (Op == REG) {                
  5711                                  
  5712 00002EE8 A0[AC01]                 mov al, [Op]
  5713 00002EEB 3C02                     cmp al, 2
  5714 00002EED 0F853100                 jne @@process232
  5715                                  
  5716                                  ;-59                 if (R1No == 0) {// acc,imm   
  5717                                  
  5718 00002EF1 A0[B301]                 mov al, [R1No]
  5719 00002EF4 3C00                     cmp al, 0
  5720 00002EF6 0F852800                 jne @@process233
  5721                                  
  5722                                  ;-60                     if (sflag == 0) {                        
  5723                                  
  5724 00002EFA A0[B901]                 mov al, [sflag]
  5725 00002EFD 3C00                     cmp al, 0
  5726 00002EFF 0F851F00                 jne @@process234
  5727                                  
  5728                                  ;-61                         c = Code1 << 3;
  5729                                  
  5730 00002F03 A0[AF01]                 mov al, [Code1]
  5731 00002F06 C0E003                   shl al, 3
  5732 00002F09 8846FE                   mov byte [bp-2], al
  5733                                  
  5734                                  ;-62                         c += 4;    
  5735                                  
  5736 00002F0C 8046FE04                 add  byte [bp-2], 4
  5737                                  
  5738                                  ;-63                         genCodeW(c);
  5739                                  
  5740 00002F10 8A46FE                   mov al, byte [bp-2]
  5741 00002F13 B400                     mov ah, 0
  5742 00002F15 50                       push ax
  5743 00002F16 E8C3FC                   call genCodeW
  5744 00002F19 83C402                   add  sp, 2
  5745                                  
  5746                                  ;-64                         genImmediate();
  5747                                  
  5748 00002F1C E866FE                   call genImmediate
  5749                                  
  5750                                  ;-65                         return;
  5751                                  
  5752 00002F1F E94304                   jmp @@retn
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
  5771 00002F22 A0[B901]                 mov al, [sflag]
  5772 00002F25 0480                     add al, 128
  5773 00002F27 8846FE                   mov byte [bp-2], al
  5774                                  
  5775                                  ;-71             genCodeW(c); 
  5776                                  
  5777 00002F2A 8A46FE                   mov al, byte [bp-2]
  5778 00002F2D B400                     mov ah, 0
  5779 00002F2F 50                       push ax
  5780 00002F30 E8A9FC                   call genCodeW
  5781 00002F33 83C402                   add  sp, 2
  5782                                  
  5783                                  ;-72             writeEA(Code1);  
  5784                                  
  5785 00002F36 A0[AF01]                 mov al, byte [Code1]
  5786 00002F39 B400                     mov ah, 0
  5787 00002F3B 50                       push ax
  5788 00002F3C E831FD                   call writeEA
  5789 00002F3F 83C402                   add  sp, 2
  5790                                  
  5791                                  ;-73             if (sflag) genCode8(imme);
  5792                                  
  5793 00002F42 A0[B901]                 mov al, [sflag]
  5794 00002F45 08C0                     or  al, al
  5795 00002F47 0F840D00                 je @@process235
  5796 00002F4B FF36[BE01]               push word [imme]
  5797 00002F4F E8A6FC                   call genCode8
  5798 00002F52 83C402                   add  sp, 2
  5799                                  
  5800                                  ;-74             else genImmediate();    
  5801                                  
  5802 00002F55 E90300                   jmp @@process236
  5803                                  @@process235:
  5804 00002F58 E82AFE                   call genImmediate
  5805                                  
  5806                                  ;-75             return;     
  5807                                  
  5808                                  @@process236:
  5809 00002F5B E90704                   jmp @@retn
  5810                                  
  5811                                  ;-76         }  
  5812                                  
  5813                                  
  5814                                  ;-77         c = Code1 << 3;//r/m, r/r  
  5815                                  
  5816                                  @@process231:
  5817 00002F5E A0[AF01]                 mov al, [Code1]
  5818 00002F61 C0E003                   shl al, 3
  5819 00002F64 8846FE                   mov byte [bp-2], al
  5820                                  
  5821                                  ;-78         if (Op == REG) {
  5822                                  
  5823 00002F67 A0[AC01]                 mov al, [Op]
  5824 00002F6A 3C02                     cmp al, 2
  5825 00002F6C 0F852E00                 jne @@process237
  5826                                  
  5827                                  ;-79             if (Op2 == MEM) {//reg, mem      
  5828                                  
  5829 00002F70 A0[AD01]                 mov al, [Op2]
  5830 00002F73 3C04                     cmp al, 4
  5831 00002F75 0F852500                 jne @@process238
  5832                                  
  5833                                  ;-80                 c += 2;//add direction flag
  5834                                  
  5835 00002F79 8046FE02                 add  byte [bp-2], 2
  5836                                  
  5837                                  ;-81                 genCodeW(c);
  5838                                  
  5839 00002F7D 8A46FE                   mov al, byte [bp-2]
  5840 00002F80 B400                     mov ah, 0
  5841 00002F82 50                       push ax
  5842 00002F83 E856FC                   call genCodeW
  5843 00002F86 83C402                   add  sp, 2
  5844                                  
  5845                                  ;-82                 Op=Op2;//set MEM for writeEA                
  5846                                  
  5847 00002F89 A0[AD01]                 mov al, [Op2]
  5848 00002F8C A2[AC01]                 mov byte [Op], al
  5849                                  
  5850                                  ;-83                 writeEA(R1No);
  5851                                  
  5852 00002F8F A0[B301]                 mov al, byte [R1No]
  5853 00002F92 B400                     mov ah, 0
  5854 00002F94 50                       push ax
  5855 00002F95 E8D8FC                   call writeEA
  5856 00002F98 83C402                   add  sp, 2
  5857                                  
  5858                                  ;-84                 return;    
  5859                                  
  5860 00002F9B E9C703                   jmp @@retn
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
  5872 00002F9E A0[AD01]                 mov al, [Op2]
  5873 00002FA1 3C02                     cmp al, 2
  5874 00002FA3 0F851B00                 jne @@process239
  5875                                  
  5876                                  ;-88             genCodeW(c);
  5877                                  
  5878 00002FA7 8A46FE                   mov al, byte [bp-2]
  5879 00002FAA B400                     mov ah, 0
  5880 00002FAC 50                       push ax
  5881 00002FAD E82CFC                   call genCodeW
  5882 00002FB0 83C402                   add  sp, 2
  5883                                  
  5884                                  ;-89             writeEA(R2No);//2. Op in reg-field
  5885                                  
  5886 00002FB3 A0[B201]                 mov al, byte [R2No]
  5887 00002FB6 B400                     mov ah, 0
  5888 00002FB8 50                       push ax
  5889 00002FB9 E8B4FC                   call writeEA
  5890 00002FBC 83C402                   add  sp, 2
  5891                                  
  5892                                  ;-90             return;            
  5893                                  
  5894 00002FBF E9A303                   jmp @@retn
  5895                                  
  5896                                  ;-91         }          
  5897                                  
  5898                                  
  5899                                  ;-92         syntaxerror();        
  5900                                  
  5901                                  @@process239:
  5902 00002FC2 E81DF8                   call syntaxerror
  5903                                  
  5904                                  ;-93         return;
  5905                                  
  5906 00002FC5 E99D03                   jmp @@retn
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
  5917 00002FC8 A0[AE01]                 mov al, [CodeType]
  5918 00002FCB 3C05                     cmp al, 5
  5919 00002FCD 0F857F01                 jne @@process240
  5920                                  
  5921                                  ;-97         check2Ops();    
  5922                                  
  5923 00002FD1 E8EFE2                   call check2Ops
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
  5939 00002FD4 A0[AD01]                 mov al, [Op2]
  5940 00002FD7 3C03                     cmp al, 3
  5941 00002FD9 0F850F00                 jne @@process241
  5942                                  
  5943                                  ;-103             imme=disp;
  5944                                  
  5945 00002FDD A1[BC01]                 mov ax, [disp]
  5946 00002FE0 A3[BE01]                 mov word [imme], ax
  5947                                  
  5948                                  ;-104             Op2=IMM;//continue with IMM    
  5949                                  
  5950 00002FE3 66B801000000             mov eax, 1
  5951 00002FE9 A2[AD01]                 mov byte [Op2], al
  5952                                  
  5953                                  ;-105         }  
  5954                                  
  5955                                  
  5956                                  ;-106         if (Op2 == IMM) {// r,i     
  5957                                  
  5958                                  @@process241:
  5959 00002FEC A0[AD01]                 mov al, [Op2]
  5960 00002FEF 3C01                     cmp al, 1
  5961 00002FF1 0F855400                 jne @@process242
  5962                                  
  5963                                  ;-107             if (Op == REG) {               
  5964                                  
  5965 00002FF5 A0[AC01]                 mov al, [Op]
  5966 00002FF8 3C02                     cmp al, 2
  5967 00002FFA 0F852500                 jne @@process243
  5968                                  
  5969                                  ;-108                 c = wflag << 3;   
  5970                                  
  5971 00002FFE A0[B701]                 mov al, [wflag]
  5972 00003001 C0E003                   shl al, 3
  5973 00003004 8846FE                   mov byte [bp-2], al
  5974                                  
  5975                                  ;-109                 c += 0xB0;                                     
  5976                                  
  5977 00003007 8046FEB0                 add  byte [bp-2], 176
  5978                                  
  5979                                  ;-110                 genCode2(c, R1No);   
  5980                                  
  5981 0000300B A0[B301]                 mov al, byte [R1No]
  5982 0000300E B400                     mov ah, 0
  5983 00003010 50                       push ax
  5984 00003011 8A46FE                   mov al, byte [bp-2]
  5985 00003014 B400                     mov ah, 0
  5986 00003016 50                       push ax
  5987 00003017 E8A7FB                   call genCode2
  5988 0000301A 83C404                   add  sp, 4
  5989                                  
  5990                                  ;-111                 genImmediate();
  5991                                  
  5992 0000301D E865FD                   call genImmediate
  5993                                  
  5994                                  ;-112                 return; 
  5995                                  
  5996 00003020 E94203                   jmp @@retn
  5997                                  
  5998                                  ;-113             }
  5999                                  
  6000                                  
  6001                                  ;-114             if (Op == MEM) {// m,i  
  6002                                  
  6003                                  @@process243:
  6004 00003023 A0[AC01]                 mov al, [Op]
  6005 00003026 3C04                     cmp al, 4
  6006 00003028 0F851700                 jne @@process244
  6007                                  
  6008                                  ;-115                 genCodeW(0xC6);
  6009                                  
  6010 0000302C 68C600                   push 198
  6011 0000302F E8AAFB                   call genCodeW
  6012 00003032 83C402                   add  sp, 2
  6013                                  
  6014                                  ;-116                 writeEA( 0 );
  6015                                  
  6016 00003035 6A00                     push 0
  6017 00003037 E836FC                   call writeEA
  6018 0000303A 83C402                   add  sp, 2
  6019                                  
  6020                                  ;-117                 genImmediate();
  6021                                  
  6022 0000303D E845FD                   call genImmediate
  6023                                  
  6024                                  ;-118                 return;  
  6025                                  
  6026 00003040 E92203                   jmp @@retn
  6027                                  
  6028                                  ;-119             }
  6029                                  
  6030                                  
  6031                                  ;-120             regmemerror();
  6032                                  
  6033                                  @@process244:
  6034 00003043 E823F7                   call regmemerror
  6035                                  
  6036                                  ;-121             return;
  6037                                  
  6038 00003046 E91C03                   jmp @@retn
  6039                                  
  6040                                  ;-122         }      
  6041                                  
  6042                                  
  6043                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6044                                  
  6045                                  @@process242:
  6046 00003049 A0[B501]                 mov al, [R1Type]
  6047 0000304C 3C04                     cmp al, 4
  6048 0000304E 0F850300                 jne @@process245
  6049 00003052 E8A7E1                   call ChangeDirection
  6050                                  
  6051                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6052                                  
  6053                                  @@process245:
  6054 00003055 A0[B401]                 mov al, [R2Type]
  6055 00003058 3C04                     cmp al, 4
  6056 0000305A 0F852A00                 jne @@process246
  6057                                  
  6058                                  ;-125             if (OpSize != WORD) reg16error();
  6059                                  
  6060 0000305E A0[B601]                 mov al, [OpSize]
  6061 00003061 3C02                     cmp al, 2
  6062 00003063 0F840300                 je  @@process247
  6063 00003067 E829F7                   call reg16error
  6064                                  
  6065                                  ;-126                 genCode2(0x8C, dflag);
  6066                                  
  6067                                  @@process247:
  6068 0000306A A0[B801]                 mov al, byte [dflag]
  6069 0000306D B400                     mov ah, 0
  6070 0000306F 50                       push ax
  6071 00003070 688C00                   push 140
  6072 00003073 E84BFB                   call genCode2
  6073 00003076 83C404                   add  sp, 4
  6074                                  
  6075                                  ;-127                 writeEA(R2No);
  6076                                  
  6077 00003079 A0[B201]                 mov al, byte [R2No]
  6078 0000307C B400                     mov ah, 0
  6079 0000307E 50                       push ax
  6080 0000307F E8EEFB                   call writeEA
  6081 00003082 83C402                   add  sp, 2
  6082                                  
  6083                                  ;-128                 return;   
  6084                                  
  6085 00003085 E9DD02                   jmp @@retn
  6086                                  
  6087                                  ;-129         }          
  6088                                  
  6089                                  
  6090                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6091                                  
  6092                                  @@process246:
  6093 00003088 A0[AD01]                 mov al, [Op2]
  6094 0000308B 3C04                     cmp al, 4
  6095 0000308D 0F853100                 jne @@process248
  6096                                  
  6097                                  ;-131             if (Op == REG) {
  6098                                  
  6099 00003091 A0[AC01]                 mov al, [Op]
  6100 00003094 3C02                     cmp al, 2
  6101 00003096 0F852800                 jne @@process249
  6102                                  
  6103                                  ;-132                 if (R1No == 0) {
  6104                                  
  6105 0000309A A0[B301]                 mov al, [R1No]
  6106 0000309D 3C00                     cmp al, 0
  6107 0000309F 0F851F00                 jne @@process250
  6108                                  
  6109                                  ;-133                     if (isDirect) {
  6110                                  
  6111 000030A3 A0[BB01]                 mov al, [isDirect]
  6112 000030A6 08C0                     or  al, al
  6113 000030A8 0F841600                 je @@process251
  6114                                  
  6115                                  ;-134                         genCodeW(0xA0);
  6116                                  
  6117 000030AC 68A000                   push 160
  6118 000030AF E82AFB                   call genCodeW
  6119 000030B2 83C402                   add  sp, 2
  6120                                  
  6121                                  ;-135                         genCode16(disp);
  6122                                  
  6123 000030B5 FF36[BC01]               push word [disp]
  6124 000030B9 E893FB                   call genCode16
  6125 000030BC 83C402                   add  sp, 2
  6126                                  
  6127                                  ;-136                         return;   
  6128                                  
  6129 000030BF E9A302                   jmp @@retn
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
  6149 000030C2 A0[AC01]                 mov al, [Op]
  6150 000030C5 3C04                     cmp al, 4
  6151 000030C7 0F853100                 jne @@process252
  6152                                  
  6153                                  ;-142             if (Op2 == REG) {
  6154                                  
  6155 000030CB A0[AD01]                 mov al, [Op2]
  6156 000030CE 3C02                     cmp al, 2
  6157 000030D0 0F852800                 jne @@process253
  6158                                  
  6159                                  ;-143                 if (R2No == 0) {
  6160                                  
  6161 000030D4 A0[B201]                 mov al, [R2No]
  6162 000030D7 3C00                     cmp al, 0
  6163 000030D9 0F851F00                 jne @@process254
  6164                                  
  6165                                  ;-144                     if (isDirect) {
  6166                                  
  6167 000030DD A0[BB01]                 mov al, [isDirect]
  6168 000030E0 08C0                     or  al, al
  6169 000030E2 0F841600                 je @@process255
  6170                                  
  6171                                  ;-145                         genCodeW(0xA2);
  6172                                  
  6173 000030E6 68A200                   push 162
  6174 000030E9 E8F0FA                   call genCodeW
  6175 000030EC 83C402                   add  sp, 2
  6176                                  
  6177                                  ;-146                         genCode16(disp);
  6178                                  
  6179 000030EF FF36[BC01]               push word [disp]
  6180 000030F3 E859FB                   call genCode16
  6181 000030F6 83C402                   add  sp, 2
  6182                                  
  6183                                  ;-147                         return;   
  6184                                  
  6185 000030F9 E96902                   jmp @@retn
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
  6208 000030FC A0[AD01]                 mov al, [Op2]
  6209 000030FF 3C02                     cmp al, 2
  6210 00003101 0F851800                 jne @@process256
  6211                                  
  6212                                  ;-154             genCodeW(0x88);     
  6213                                  
  6214 00003105 688800                   push 136
  6215 00003108 E8D1FA                   call genCodeW
  6216 0000310B 83C402                   add  sp, 2
  6217                                  
  6218                                  ;-155             writeEA(R2No);
  6219                                  
  6220 0000310E A0[B201]                 mov al, byte [R2No]
  6221 00003111 B400                     mov ah, 0
  6222 00003113 50                       push ax
  6223 00003114 E859FB                   call writeEA
  6224 00003117 83C402                   add  sp, 2
  6225                                  
  6226                                  ;-156             return;
  6227                                  
  6228 0000311A E94802                   jmp @@retn
  6229                                  
  6230                                  ;-157         }
  6231                                  
  6232                                  
  6233                                  ;-158         if (Op2 == MEM) {//r, m
  6234                                  
  6235                                  @@process256:
  6236 0000311D A0[AD01]                 mov al, [Op2]
  6237 00003120 3C04                     cmp al, 4
  6238 00003122 0F852400                 jne @@process257
  6239                                  
  6240                                  ;-159             if (Op == REG) {
  6241                                  
  6242 00003126 A0[AC01]                 mov al, [Op]
  6243 00003129 3C02                     cmp al, 2
  6244 0000312B 0F851B00                 jne @@process258
  6245                                  
  6246                                  ;-160                 ChangeDirection();
  6247                                  
  6248 0000312F E8CAE0                   call ChangeDirection
  6249                                  
  6250                                  ;-161                 genCodeW(0x8A);
  6251                                  
  6252 00003132 688A00                   push 138
  6253 00003135 E8A4FA                   call genCodeW
  6254 00003138 83C402                   add  sp, 2
  6255                                  
  6256                                  ;-162                 writeEA(R2No);
  6257                                  
  6258 0000313B A0[B201]                 mov al, byte [R2No]
  6259 0000313E B400                     mov ah, 0
  6260 00003140 50                       push ax
  6261 00003141 E82CFB                   call writeEA
  6262 00003144 83C402                   add  sp, 2
  6263                                  
  6264                                  ;-163                 return;   
  6265                                  
  6266 00003147 E91B02                   jmp @@retn
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
  6278 0000314A E895F6                   call syntaxerror
  6279                                  
  6280                                  ;-167         return;
  6281                                  
  6282 0000314D E91502                   jmp @@retn
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
  6293 00003150 A0[AE01]                 mov al, [CodeType]
  6294 00003153 3C08                     cmp al, 8
  6295 00003155 0F853100                 jne @@process259
  6296                                  
  6297                                  ;-171         if (TokeType == DIGIT) {
  6298                                  
  6299 00003159 A0[AB01]                 mov al, [TokeType]
  6300 0000315C 3C01                     cmp al, 1
  6301 0000315E 0F851900                 jne @@process260
  6302                                  
  6303                                  ;-172             genCode8(Code2);
  6304                                  
  6305 00003162 A0[B001]                 mov al, byte [Code2]
  6306 00003165 B400                     mov ah, 0
  6307 00003167 50                       push ax
  6308 00003168 E88DFA                   call genCode8
  6309 0000316B 83C402                   add  sp, 2
  6310                                  
  6311                                  ;-173             genCode16(SymbolInt);
  6312                                  
  6313 0000316E FF36[4D00]               push word [SymbolInt]
  6314 00003172 E8DAFA                   call genCode16
  6315 00003175 83C402                   add  sp, 2
  6316                                  
  6317                                  ;-174             return;
  6318                                  
  6319 00003178 E9EA01                   jmp @@retn
  6320                                  
  6321                                  ;-175         }
  6322                                  
  6323                                  
  6324                                  ;-176         genCode8(Code1); 
  6325                                  
  6326                                  @@process260:
  6327 0000317B A0[AF01]                 mov al, byte [Code1]
  6328 0000317E B400                     mov ah, 0
  6329 00003180 50                       push ax
  6330 00003181 E874FA                   call genCode8
  6331 00003184 83C402                   add  sp, 2
  6332                                  
  6333                                  ;-177         return;
  6334                                  
  6335 00003187 E9DB01                   jmp @@retn
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
  6346 0000318A A0[AE01]                 mov al, [CodeType]
  6347 0000318D 3C09                     cmp al, 9
  6348 0000318F 0F850301                 jne @@process261
  6349                                  
  6350                                  ;-181         getOpL();
  6351                                  
  6352 00003193 E888E1                   call getOpL
  6353                                  
  6354                                  ;-182         if (Code1 == 0x50) {//push only
  6355                                  
  6356 00003196 A0[AF01]                 mov al, [Code1]
  6357 00003199 3C50                     cmp al, 80
  6358 0000319B 0F853D00                 jne @@process262
  6359                                  
  6360                                  ;-183             if (Op == IMM) {//push imm8,16
  6361                                  
  6362 0000319F A0[AC01]                 mov al, [Op]
  6363 000031A2 3C01                     cmp al, 1
  6364 000031A4 0F853400                 jne @@process263
  6365                                  
  6366                                  ;-184                 setsflag();
  6367                                  
  6368 000031A8 E8FBE4                   call setsflag
  6369                                  
  6370                                  ;-185                 genCode2(0x68, sflag);     
  6371                                  
  6372 000031AB A0[B901]                 mov al, byte [sflag]
  6373 000031AE B400                     mov ah, 0
  6374 000031B0 50                       push ax
  6375 000031B1 6A68                     push 104
  6376 000031B3 E80BFA                   call genCode2
  6377 000031B6 83C404                   add  sp, 4
  6378                                  
  6379                                  ;-186                 if (sflag) genCode8 (imme);
  6380                                  
  6381 000031B9 A0[B901]                 mov al, [sflag]
  6382 000031BC 08C0                     or  al, al
  6383 000031BE 0F840D00                 je @@process264
  6384 000031C2 FF36[BE01]               push word [imme]
  6385 000031C6 E82FFA                   call genCode8
  6386 000031C9 83C402                   add  sp, 2
  6387                                  
  6388                                  ;-187                 else       genCode16(imme);    
  6389                                  
  6390 000031CC E90A00                   jmp @@process265
  6391                                  @@process264:
  6392 000031CF FF36[BE01]               push word [imme]
  6393 000031D3 E879FA                   call genCode16
  6394 000031D6 83C402                   add  sp, 2
  6395                                  
  6396                                  ;-188                 return;   
  6397                                  
  6398                                  @@process265:
  6399 000031D9 E98901                   jmp @@retn
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
  6411 000031DC A0[B501]                 mov al, [R1Type]
  6412 000031DF 3C04                     cmp al, 4
  6413 000031E1 0F855A00                 jne @@process266
  6414                                  
  6415                                  ;-192             if (Code1 == 0x58) {
  6416                                  
  6417 000031E5 A0[AF01]                 mov al, [Code1]
  6418 000031E8 3C58                     cmp al, 88
  6419 000031EA 0F851200                 jne @@process267
  6420                                  
  6421                                  ;-193                 if (R1No == 1) error1("pop cs not allowed");   
  6422                                  
  6423 000031EE A0[B301]                 mov al, [R1No]
  6424 000031F1 3C01                     cmp al, 1
  6425 000031F3 0F850900                 jne @@process268
  6426 000031F7 68[6733]                 push process_0
  6427 000031FA E826F4                   call error1
  6428 000031FD 83C402                   add  sp, 2
  6429                                  
  6430                                  ;-194             }
  6431                                  
  6432                                  @@process268:
  6433                                  
  6434                                  ;-195             c = R1No <<3;
  6435                                  
  6436                                  @@process267:
  6437 00003200 A0[B301]                 mov al, [R1No]
  6438 00003203 C0E003                   shl al, 3
  6439 00003206 8846FE                   mov byte [bp-2], al
  6440                                  
  6441                                  ;-196             if (R1No > 3) {//FS, GS
  6442                                  
  6443 00003209 A0[B301]                 mov al, [R1No]
  6444 0000320C 3C03                     cmp al, 3
  6445 0000320E 0F8E0C00                 jle @@process269
  6446                                  
  6447                                  ;-197                 c += 122;
  6448                                  
  6449 00003212 8046FE7A                 add  byte [bp-2], 122
  6450                                  
  6451                                  ;-198                 genCode8(0x0F);
  6452                                  
  6453 00003216 6A0F                     push 15
  6454 00003218 E8DDF9                   call genCode8
  6455 0000321B 83C402                   add  sp, 2
  6456                                  
  6457                                  ;-199             }
  6458                                  
  6459                                  
  6460                                  ;-200             OpCodePtr++;
  6461                                  
  6462                                  @@process269:
  6463 0000321E FF06[C701]               inc  word [OpCodePtr]
  6464                                  
  6465                                  ;-201             c = c + *OpCodePtr;//is Code4   
  6466                                  
  6467 00003222 8A46FE                   mov al, [bp-2]
  6468 00003225 8B1E[C701]               mov bx, [OpCodePtr]
  6469 00003229 0207                     add al, [bx]
  6470 0000322B B400                     mov ah, 0
  6471 0000322D 8846FE                   mov byte [bp-2], al
  6472                                  
  6473                                  ;-202             genCode8(c);  
  6474                                  
  6475 00003230 8A46FE                   mov al, byte [bp-2]
  6476 00003233 B400                     mov ah, 0
  6477 00003235 50                       push ax
  6478 00003236 E8BFF9                   call genCode8
  6479 00003239 83C402                   add  sp, 2
  6480                                  
  6481                                  ;-203             return; 
  6482                                  
  6483 0000323C E92601                   jmp @@retn
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
  6494 0000323F E8FFDF                   call checkOpL
  6495                                  
  6496                                  ;-207         if (R1Type == BYTE) reg16error();
  6497                                  
  6498 00003242 A0[B501]                 mov al, [R1Type]
  6499 00003245 3C01                     cmp al, 1
  6500 00003247 0F850300                 jne @@process270
  6501 0000324B E845F5                   call reg16error
  6502                                  
  6503                                  ;-208         if (R1Type == WORD) {
  6504                                  
  6505                                  @@process270:
  6506 0000324E A0[B501]                 mov al, [R1Type]
  6507 00003251 3C02                     cmp al, 2
  6508 00003253 0F851500                 jne @@process271
  6509                                  
  6510                                  ;-209             genCode2(Code1, R1No);
  6511                                  
  6512 00003257 A0[B301]                 mov al, byte [R1No]
  6513 0000325A B400                     mov ah, 0
  6514 0000325C 50                       push ax
  6515 0000325D A0[AF01]                 mov al, byte [Code1]
  6516 00003260 B400                     mov ah, 0
  6517 00003262 50                       push ax
  6518 00003263 E85BF9                   call genCode2
  6519 00003266 83C404                   add  sp, 4
  6520                                  
  6521                                  ;-210             return;   
  6522                                  
  6523 00003269 E9F900                   jmp @@retn
  6524                                  
  6525                                  ;-211         }                
  6526                                  
  6527                                  
  6528                                  ;-212         if (Op == MEM) {
  6529                                  
  6530                                  @@process271:
  6531 0000326C A0[AC01]                 mov al, [Op]
  6532 0000326F 3C04                     cmp al, 4
  6533 00003271 0F851B00                 jne @@process272
  6534                                  
  6535                                  ;-213             genCode8(Code2);
  6536                                  
  6537 00003275 A0[B001]                 mov al, byte [Code2]
  6538 00003278 B400                     mov ah, 0
  6539 0000327A 50                       push ax
  6540 0000327B E87AF9                   call genCode8
  6541 0000327E 83C402                   add  sp, 2
  6542                                  
  6543                                  ;-214             writeEA(Code3);
  6544                                  
  6545 00003281 A0[B101]                 mov al, byte [Code3]
  6546 00003284 B400                     mov ah, 0
  6547 00003286 50                       push ax
  6548 00003287 E8E6F9                   call writeEA
  6549 0000328A 83C402                   add  sp, 2
  6550                                  
  6551                                  ;-215             return;   
  6552                                  
  6553 0000328D E9D500                   jmp @@retn
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
  6564 00003290 E84FF5                   call syntaxerror
  6565                                  
  6566                                  ;-219         return;        
  6567                                  
  6568 00003293 E9CF00                   jmp @@retn
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
  6579 00003296 A0[AE01]                 mov al, [CodeType]
  6580 00003299 3C0C                     cmp al, 12
  6581 0000329B 0F853E00                 jne @@process273
  6582                                  
  6583                                  ;-223         if (TokeType == DIGIT) {
  6584                                  
  6585 0000329F A0[AB01]                 mov al, [TokeType]
  6586 000032A2 3C01                     cmp al, 1
  6587 000032A4 0F853500                 jne @@process274
  6588                                  
  6589                                  ;-224             if (SymbolInt == 3) {
  6590                                  
  6591 000032A8 A1[4D00]                 mov ax, [SymbolInt]
  6592 000032AB 83F803                   cmp ax, 3
  6593 000032AE 0F851200                 jne @@process275
  6594                                  
  6595                                  ;-225                 genCode8(Code2);
  6596                                  
  6597 000032B2 A0[B001]                 mov al, byte [Code2]
  6598 000032B5 B400                     mov ah, 0
  6599 000032B7 50                       push ax
  6600 000032B8 E83DF9                   call genCode8
  6601 000032BB 83C402                   add  sp, 2
  6602                                  
  6603                                  ;-226                 return;   
  6604                                  
  6605 000032BE E9A400                   jmp @@retn
  6606                                  
  6607                                  ;-227             }
  6608                                  
  6609                                  
  6610                                  ;-228             else {
  6611                                  
  6612 000032C1 E91900                   jmp @@process276
  6613                                  @@process275:
  6614                                  
  6615                                  ;-229                 genCode8(Code1);
  6616                                  
  6617 000032C4 A0[AF01]                 mov al, byte [Code1]
  6618 000032C7 B400                     mov ah, 0
  6619 000032C9 50                       push ax
  6620 000032CA E82BF9                   call genCode8
  6621 000032CD 83C402                   add  sp, 2
  6622                                  
  6623                                  ;-230                 genCode8(SymbolInt);
  6624                                  
  6625 000032D0 FF36[4D00]               push word [SymbolInt]
  6626 000032D4 E821F9                   call genCode8
  6627 000032D7 83C402                   add  sp, 2
  6628                                  
  6629                                  ;-231                 return;   
  6630                                  
  6631 000032DA E98800                   jmp @@retn
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
  6647                                  ;-236     if (CodeType == 30) {//enter i18,i8
  6648                                  
  6649                                  @@process273:
  6650 000032DD A0[AE01]                 mov al, [CodeType]
  6651 000032E0 3C1E                     cmp al, 30
  6652 000032E2 0F855200                 jne @@process277
  6653                                  
  6654                                  ;-237         genCode8(0xC8);
  6655                                  
  6656 000032E6 68C800                   push 200
  6657 000032E9 E80CF9                   call genCode8
  6658 000032EC 83C402                   add  sp, 2
  6659                                  
  6660                                  ;-238         Op=getOp1();
  6661                                  
  6662 000032EF E8E9E0                   call getOp1
  6663 000032F2 A2[AC01]                 mov byte [Op], al
  6664                                  
  6665                                  ;-239         if (Op == IMM) genCode16(SymbolInt);
  6666                                  
  6667 000032F5 A0[AC01]                 mov al, [Op]
  6668 000032F8 3C01                     cmp al, 1
  6669 000032FA 0F850D00                 jne @@process278
  6670 000032FE FF36[4D00]               push word [SymbolInt]
  6671 00003302 E84AF9                   call genCode16
  6672 00003305 83C402                   add  sp, 2
  6673                                  
  6674                                  ;-240         else numbererror();
  6675                                  
  6676 00003308 E90300                   jmp @@process279
  6677                                  @@process278:
  6678 0000330B E841F4                   call numbererror
  6679                                  
  6680                                  ;-241         need(',');
  6681                                  
  6682                                  @@process279:
  6683 0000330E 6A2C                     push 44
  6684 00003310 E8E6E8                   call need
  6685 00003313 83C402                   add  sp, 2
  6686                                  
  6687                                  ;-242         Op=getOp1();
  6688                                  
  6689 00003316 E8C2E0                   call getOp1
  6690 00003319 A2[AC01]                 mov byte [Op], al
  6691                                  
  6692                                  ;-243         if (Op == IMM) genCode8 (SymbolInt);
  6693                                  
  6694 0000331C A0[AC01]                 mov al, [Op]
  6695 0000331F 3C01                     cmp al, 1
  6696 00003321 0F850D00                 jne @@process280
  6697 00003325 FF36[4D00]               push word [SymbolInt]
  6698 00003329 E8CCF8                   call genCode8
  6699 0000332C 83C402                   add  sp, 2
  6700                                  
  6701                                  ;-244         else numbererror();           
  6702                                  
  6703 0000332F E90300                   jmp @@process281
  6704                                  @@process280:
  6705 00003332 E81AF4                   call numbererror
  6706                                  
  6707                                  ;-245         return;
  6708                                  
  6709                                  @@process281:
  6710 00003335 E92D00                   jmp @@retn
  6711                                  
  6712                                  ;-246     }
  6713                                  
  6714                                  
  6715                                  ;-247        
  6716                                  
  6717                                  
  6718                                  ;-248     if (CodeType==101) {// ORG nn
  6719                                  
  6720                                  @@process277:
  6721 00003338 A0[AE01]                 mov al, [CodeType]
  6722 0000333B 3C65                     cmp al, 101
  6723 0000333D 0F851B00                 jne @@process282
  6724                                  
  6725                                  ;-249         if (TokeType != DIGIT) error1("only digit allowed");
  6726                                  
  6727 00003341 A0[AB01]                 mov al, [TokeType]
  6728 00003344 3C01                     cmp al, 1
  6729 00003346 0F840900                 je  @@process283
  6730 0000334A 68[7A33]                 push process_1
  6731 0000334D E8D3F2                   call error1
  6732 00003350 83C402                   add  sp, 2
  6733                                  
  6734                                  ;-250         PC=SymbolInt;
  6735                                  
  6736                                  @@process283:
  6737 00003353 A1[4D00]                 mov ax, [SymbolInt]
  6738 00003356 A3[A601]                 mov word [PC], ax
  6739                                  
  6740                                  ;-251         return;
  6741                                  
  6742 00003359 E90900                   jmp @@retn
  6743                                  
  6744                                  ;-252     }
  6745                                  
  6746                                  
  6747                                  ;-253     error1("Command not implemented or syntax error");
  6748                                  
  6749                                  @@process282:
  6750 0000335C 68[8D33]                 push process_2
  6751 0000335F E8C1F2                   call error1
  6752 00003362 83C402                   add  sp, 2
  6753                                  
  6754                                  ;-254 }    
  6755                                  
  6756 00003365 C9                      @@retn: LEAVE
  6757 00003366 C3                       ret
  6758                                  ; ENDP
  6759 00003367 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  6760 00003370 7420616C6C6F776564-
  6761 00003379 00                 
  6762 0000337A 6F6E6C792064696769-     process_1 db "only digit allowed",0
  6763 00003383 7420616C6C6F776564-
  6764 0000338C 00                 
  6765 0000338D 436F6D6D616E64206E-     process_2 db "Command not implemented or syntax error",0
  6766 00003396 6F7420696D706C656D-
  6767 0000339F 656E746564206F7220-
  6768 000033A8 73796E746178206572-
  6769 000033B1 726F7200           
  6770                                   
  6771                                  ; missing functions: 
  6772                                  ; digit
  6773                                  ; strcpy
  6774                                  ; eqstr
  6775                                  ; strlen
  6776                                  ; eqstr
  6777                                  ; eqstr
  6778                                  ; eqstr
  6779                                  ; eqstr
  6780                                  ; readRL
  6781                                  ; readRL
  6782                                  ; digit
  6783                                  ; digit
  6784                                  ; strcpy
  6785                                  ; toupper
  6786                                  ; strlen
  6787                                  ; strlen
  6788                                  ; eqstr
  6789                                  ; eqstr
  6790                                  ; eqstr
  6791                                  ; eqstr
  6792                                  ; eqstr
  6793                                  ; eqstr
  6794                                  ; eqstr
  6795                                  ; eqstr
  6796                                  ; eqstr
  6797                                  ; eqstr
  6798                                  ; eqstr
  6799                                  ; eqstr
  6800                                  ; eqstr
  6801                                  ; eqstr
  6802                                  ; eqstr
  6803                                  ; eqstr
  6804                                  ; eqstr
  6805                                  ; eqstr
  6806                                  ; eqstr
  6807                                  ; eqstr
  6808                                  ; eqstr
  6809                                  ; eqstr
  6810                                  ; eqstr
  6811                                  ; eqstr
  6812                                  ; eqstr
  6813                                  ; eqstr
  6814                                  ; eqstr
  6815                                  ; eqstr
  6816                                  ; eqstr
  6817                                  ; eqstr
  6818                                  ; writetty
  6819                                  ; writetty
  6820                                  ; fputcR
  6821                                  ; cputs
  6822                                  ; cputs
  6823                                  ; exitR
  6824                                  ; toupper
  6825                                  ; strcpy
  6826                                  ; strcat1
  6827                                  ; strcpy
  6828                                  ; strcat1
  6829                                  ; strcpy
  6830                                  ; strcat1
  6831                                  ; openR
  6832                                  ; cputs
  6833                                  ; cputs
  6834                                  ; exitR
  6835                                  ; creatR
  6836                                  ; cputs
  6837                                  ; cputs
  6838                                  ; exitR
  6839                                  ; creatR
  6840                                  ; cputs
  6841                                  ; cputs
  6842                                  ; exitR
  6843                                  ; fputcR
  6844                                  ; fcloseR
  6845                                  ; fcloseR
  6846                                  ; fcloseR
  6847                                  ; exitR
  6848                                  ; Number of unresolved CALLs :   76
  6849                                  ;use archive file: AR.C
  6850                                  
  6851                                  ;-255 // AR.C Archive
  6852                                  
  6853                                  ;Number of CALLs:    2 : writetty
  6854                                  
  6855                                  writetty:  ; *** PROC ***
  6856 000033B5 B40E                     mov  ah, 14
  6857 000033B7 BB0000                   mov  bx, 0
  6858 000033BA CD10                     int  16
  6859                                  
  6860                                  ;-256 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6861                                  
  6862 000033BC C3                       ret
  6863                                  ; ENDP
  6864                                  ;Number of CALLs:    8 : cputs
  6865                                  
  6866                                  cputs:  ; *** PROC ***
  6867                                  ;Function : cputs, Number of local variables: 2
  6868                                  ;   # type sign width line used address name   list of local variables
  6869                                  ;  200 ptr sign byte   256 NULL bp+4    s
  6870                                  ;  201 var sign byte   256 NULL bp-2    c;
  6871 000033BD C8020000                 ENTER  2,0
  6872                                  @@cputs284:
  6873 000033C1 8B5E04                   mov bx, [bp+4]
  6874 000033C4 8A07                     mov al, [bx]
  6875 000033C6 B400                     mov ah, 0
  6876 000033C8 08C0                     or  al, al
  6877 000033CA 0F841B00                 je @@cputs285
  6878 000033CE 8B5E04                   mov bx, [bp+4]
  6879 000033D1 8A07                     mov al, [bx]
  6880 000033D3 B400                     mov ah, 0
  6881 000033D5 8846FE                   mov byte [bp-2], al
  6882 000033D8 8A46FE                   mov al, byte [bp-2]
  6883 000033DB B400                     mov ah, 0
  6884 000033DD 50                       push ax
  6885 000033DE E8C401                   call putch
  6886 000033E1 83C402                   add  sp, 2
  6887 000033E4 FF4604                   inc  word [bp+4]
  6888 000033E7 EBD8                     jmp @@cputs284
  6889                                  @@cputs285:
  6890                                  
  6891                                  ;-257 int mkneg(int n) { n; __asm {neg ax} }
  6892 000033E9 C9                       LEAVE
  6893 000033EA C3                       ret
  6894                                  ; ENDP
  6895                                  ;Number of CALLs:    2 : toupper
  6896                                  
  6897                                  toupper:  ; *** PROC ***
  6898                                  ;Function : toupper, Number of local variables: 1
  6899                                  ;   # type sign width line used address name   list of local variables
  6900                                  ;  200 ptr sign byte   257 NULL bp+4    s;
  6901 000033EB C8000000                 ENTER  0,0
  6902                                  @@toupper286:
  6903 000033EF 8B5E04                   mov bx, [bp+4]
  6904 000033F2 8A07                     mov al, [bx]
  6905 000033F4 B400                     mov ah, 0
  6906 000033F6 08C0                     or  al, al
  6907 000033F8 0F843000                 je @@toupper287
  6908 000033FC 8B5E04                   mov bx, [bp+4]
  6909 000033FF 8A07                     mov al, [bx]
  6910 00003401 B400                     mov ah, 0
  6911 00003403 83F861                   cmp ax, 97 ;unsigned : 1
  6912 00003406 0F8C1D00                 jl  @@toupper288
  6913 0000340A 8B5E04                   mov bx, [bp+4]
  6914 0000340D 8A07                     mov al, [bx]
  6915 0000340F B400                     mov ah, 0
  6916 00003411 83F87A                   cmp ax, 122
  6917 00003414 0F8F0F00                 jg  @@toupper289
  6918 00003418 8B5E04                   mov bx, [bp+4]
  6919 0000341B 8A07                     mov al, [bx]
  6920 0000341D B400                     mov ah, 0
  6921 0000341F 83E820                   sub ax, 32
  6922 00003422 8B5E04                   mov  bx, [bp+4]
  6923 00003425 8807                     mov  [bx], al
  6924                                  @@toupper289:
  6925                                  @@toupper288:
  6926 00003427 FF4604                   inc  word [bp+4]
  6927 0000342A EBC3                     jmp @@toupper286
  6928                                  @@toupper287:
  6929                                  
  6930                                  ;-258 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6931                                  
  6932                                  
  6933                                  ;-259 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6934 0000342C C9                       LEAVE
  6935 0000342D C3                       ret
  6936                                  ; ENDP
  6937                                  ;Number of CALLs:    3 : strlen
  6938                                  
  6939                                  strlen:  ; *** PROC ***
  6940                                  ;Function : strlen, Number of local variables: 2
  6941                                  ;   # type sign width line used address name   list of local variables
  6942                                  ;  200 ptr sign byte   259 NULL bp+4    s
  6943                                  ;  201 var sign word   259 NULL bp-2    c;
  6944 0000342E C8020000                 ENTER  2,0
  6945 00003432 66B800000000             mov eax, 0
  6946 00003438 8946FE                   mov word [bp-2], ax
  6947                                  @@strlen290:
  6948 0000343B 8B5E04                   mov bx, [bp+4]
  6949 0000343E 8A07                     mov al, [bx]
  6950 00003440 B400                     mov ah, 0
  6951 00003442 83F800                   cmp ax, 0
  6952 00003445 0F840800                 je  @@strlen291
  6953 00003449 FF4604                   inc  word [bp+4]
  6954 0000344C FF46FE                   inc  word [bp-2]
  6955 0000344F EBEA                     jmp @@strlen290
  6956                                  @@strlen291:
  6957 00003451 8B46FE                   mov ax, [bp-2]
  6958 00003454 E90000                   jmp @@retn
  6959                                  
  6960                                  ;-260 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6961                                  
  6962 00003457 C9                      @@retn: LEAVE
  6963 00003458 C3                       ret
  6964                                  ; ENDP
  6965                                  ;Number of CALLs:    5 : strcpy
  6966                                  
  6967                                  strcpy:  ; *** PROC ***
  6968                                  ;Function : strcpy, Number of local variables: 2
  6969                                  ;   # type sign width line used address name   list of local variables
  6970                                  ;  200 ptr sign byte   260 NULL bp+4    s
  6971                                  ;  201 ptr sign byte   260 NULL bp+6    t;
  6972 00003459 C8000000                 ENTER  0,0
  6973                                  @@strcpy292:
  6974 0000345D 8B5E06                   mov bx, [bp+6]
  6975 00003460 8A07                     mov al, [bx]
  6976 00003462 B400                     mov ah, 0
  6977 00003464 8B5E04                   mov  bx, [bp+4]
  6978 00003467 8807                     mov  [bx], al
  6979 00003469 FF4604                   inc  word [bp+4]
  6980 0000346C FF4606                   inc  word [bp+6]
  6981                                  
  6982                                  ;-261   while (*t!=0); *s=0; return s; }
  6983                                  
  6984 0000346F 8B5E06                   mov bx, [bp+6]
  6985 00003472 8A07                     mov al, [bx]
  6986 00003474 B400                     mov ah, 0
  6987 00003476 83F800                   cmp ax, 0
  6988 00003479 0F840200                 je  @@strcpy293
  6989 0000347D EBDE                     jmp @@strcpy292
  6990                                  @@strcpy293:
  6991 0000347F 66B800000000             mov eax, 0
  6992 00003485 8B5E04                   mov  bx, [bp+4]
  6993 00003488 8807                     mov  [bx], al
  6994 0000348A 8B4604                   mov ax, [bp+4]
  6995 0000348D E90000                   jmp @@retn
  6996                                  
  6997                                  ;-262 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6998                                  
  6999 00003490 C9                      @@retn: LEAVE
  7000 00003491 C3                       ret
  7001                                  ; ENDP
  7002                                  ;Number of CALLs:    3 : digit
  7003                                  
  7004                                  digit:  ; *** PROC ***
  7005                                  ;Function : digit, Number of local variables: 1
  7006                                  ;   # type sign width line used address name   list of local variables
  7007                                  ;  200 var sign byte   262 NULL bp+4    c;
  7008 00003492 C8000000                 ENTER  0,0
  7009 00003496 8A4604                   mov al, [bp+4]
  7010 00003499 3C30                     cmp al, 48
  7011 0000349B 0F8D0900                 jge @@digit294
  7012 0000349F 66B800000000             mov eax, 0
  7013 000034A5 E91B00                   jmp @@retn
  7014                                  @@digit294:
  7015 000034A8 8A4604                   mov al, [bp+4]
  7016 000034AB 3C39                     cmp al, 57
  7017 000034AD 0F8E0900                 jle @@digit295
  7018 000034B1 66B800000000             mov eax, 0
  7019 000034B7 E90900                   jmp @@retn
  7020                                  @@digit295:
  7021 000034BA 66B801000000             mov eax, 1
  7022 000034C0 E90000                   jmp @@retn
  7023                                  
  7024                                  ;-263 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7025                                  
  7026 000034C3 C9                      @@retn: LEAVE
  7027 000034C4 C3                       ret
  7028                                  ; ENDP
  7029                                  ;Number of CALLs:   35 : eqstr
  7030                                  
  7031                                  eqstr:  ; *** PROC ***
  7032                                  ;Function : eqstr, Number of local variables: 2
  7033                                  ;   # type sign width line used address name   list of local variables
  7034                                  ;  200 ptr sign byte   263 NULL bp+4    p
  7035                                  ;  201 ptr sign byte   263 NULL bp+6    q;
  7036 000034C5 C8000000                 ENTER  0,0
  7037                                  @@eqstr296:
  7038 000034C9 8B5E04                   mov bx, [bp+4]
  7039 000034CC 8A07                     mov al, [bx]
  7040 000034CE B400                     mov ah, 0
  7041 000034D0 08C0                     or  al, al
  7042 000034D2 0F842300                 je @@eqstr297
  7043                                  
  7044                                  ;-264     if (*p != *q) return 0; p++; q++; }
  7045                                  
  7046 000034D6 8B5E04                   mov bx, [bp+4]
  7047 000034D9 8A07                     mov al, [bx]
  7048 000034DB B400                     mov ah, 0
  7049 000034DD 8B5E06                   mov bx, [bp+6]
  7050 000034E0 3A07                     cmp al, [bx]
  7051 000034E2 B400                     mov ah, 0
  7052 000034E4 0F840900                 je  @@eqstr298
  7053 000034E8 66B800000000             mov eax, 0
  7054 000034EE E92700                   jmp @@retn
  7055                                  @@eqstr298:
  7056 000034F1 FF4604                   inc  word [bp+4]
  7057 000034F4 FF4606                   inc  word [bp+6]
  7058                                  
  7059                                  ;-265     if(*q) return 0; return 1; }
  7060                                  
  7061 000034F7 EBD0                     jmp @@eqstr296
  7062                                  @@eqstr297:
  7063 000034F9 8B5E06                   mov bx, [bp+6]
  7064 000034FC 8A07                     mov al, [bx]
  7065 000034FE B400                     mov ah, 0
  7066 00003500 08C0                     or  al, al
  7067 00003502 0F840900                 je @@eqstr299
  7068 00003506 66B800000000             mov eax, 0
  7069 0000350C E90900                   jmp @@retn
  7070                                  @@eqstr299:
  7071 0000350F 66B801000000             mov eax, 1
  7072 00003515 E90000                   jmp @@retn
  7073                                  
  7074                                  ;-266 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7075                                  
  7076 00003518 C9                      @@retn: LEAVE
  7077 00003519 C3                       ret
  7078                                  ; ENDP
  7079                                  ;Number of CALLs:    3 : strcat1
  7080                                  
  7081                                  strcat1:  ; *** PROC ***
  7082                                  ;Function : strcat1, Number of local variables: 2
  7083                                  ;   # type sign width line used address name   list of local variables
  7084                                  ;  200 ptr sign byte   266 NULL bp+4    s
  7085                                  ;  201 ptr sign byte   266 NULL bp+6    t;
  7086 0000351A C8000000                 ENTER  0,0
  7087                                  @@strcat1300:
  7088 0000351E 8B5E04                   mov bx, [bp+4]
  7089 00003521 8A07                     mov al, [bx]
  7090 00003523 B400                     mov ah, 0
  7091 00003525 83F800                   cmp ax, 0
  7092 00003528 0F840500                 je  @@strcat1301
  7093 0000352C FF4604                   inc  word [bp+4]
  7094 0000352F EBED                     jmp @@strcat1300
  7095                                  @@strcat1301:
  7096 00003531 FF7606                   push word [bp+6]
  7097 00003534 FF7604                   push word [bp+4]
  7098 00003537 E81FFF                   call strcpy
  7099 0000353A 83C404                   add  sp, 4
  7100                                  
  7101                                  ;-267 int basename(char *s) { char *p; p=0;
  7102 0000353D C9                       LEAVE
  7103 0000353E C3                       ret
  7104                                  ; ENDP
  7105                                  ;Number of CALLs:    1 : openR
  7106                                  
  7107                                  openR:  ; *** PROC ***
  7108                                  ;Function : openR, Number of local variables: 1
  7109                                  ;   # type sign width line used address name   list of local variables
  7110                                  ;  200 ptr sign byte   267 NULL bp+4    s;
  7111 0000353F C8000000                 ENTER  0,0
  7112 00003543 8B5604                   mov  dx, [bp+4]
  7113 00003546 B8023D                   mov  ax, 15618
  7114 00003549 E87200                   call DosInt
  7115                                  
  7116                                  ;-268 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7117 0000354C C9                       LEAVE
  7118 0000354D C3                       ret
  7119                                  ; ENDP
  7120                                  ;Number of CALLs:    2 : creatR
  7121                                  
  7122                                  creatR:  ; *** PROC ***
  7123                                  ;Function : creatR, Number of local variables: 1
  7124                                  ;   # type sign width line used address name   list of local variables
  7125                                  ;  200 ptr sign byte   268 NULL bp+4    s;
  7126 0000354E C8000000                 ENTER  0,0
  7127 00003552 8B5604                   mov  dx, [bp+4]
  7128 00003555 B90000                   mov  cx, 0
  7129 00003558 B8003C                   mov  ax, 15360
  7130 0000355B E86000                   call DosInt
  7131                                  
  7132                                  ;-269 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7133 0000355E C9                       LEAVE
  7134 0000355F C3                       ret
  7135                                  ; ENDP
  7136                                  ;Number of CALLs:    2 : readRL
  7137                                  
  7138                                  readRL:  ; *** PROC ***
  7139                                  ;Function : readRL, Number of local variables: 3
  7140                                  ;   # type sign width line used address name   list of local variables
  7141                                  ;  200 ptr sign byte   269 NULL bp+4    s
  7142                                  ;  201 var sign word   269 NULL bp+6    fd
  7143                                  ;  202 var sign word   269 NULL bp+8    len;
  7144 00003560 C8000000                 ENTER  0,0
  7145 00003564 8B5604                   mov  dx, [bp+4]
  7146 00003567 8B4E08                   mov  cx, [bp+8]
  7147 0000356A 8B5E06                   mov  bx, [bp+6]
  7148 0000356D B8003F                   mov  ax, 16128
  7149 00003570 E84B00                   call DosInt
  7150                                  
  7151                                  ;-270 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7152 00003573 C9                       LEAVE
  7153 00003574 C3                       ret
  7154                                  ; ENDP
  7155                                  ;Number of CALLs:    2 : fputcR
  7156                                  
  7157                                  fputcR:  ; *** PROC ***
  7158                                  ;Function : fputcR, Number of local variables: 2
  7159                                  ;   # type sign width line used address name   list of local variables
  7160                                  ;  200 ptr sign byte   270 NULL bp+4    n
  7161                                  ;  201 var sign word   270 NULL bp+6    fd;
  7162 00003575 C8000000                 ENTER  0,0
  7163 00003579 8D5604                  lea dx, [bp+4]
  7164                                  
  7165                                  ;-271   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7166                                  
  7167 0000357C B90100                   mov  cx, 1
  7168 0000357F 8B5E06                   mov  bx, [bp+6]
  7169 00003582 B80040                   mov  ax, 16384
  7170 00003585 E83600                   call DosInt
  7171                                  
  7172                                  ;-272 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7173 00003588 C9                       LEAVE
  7174 00003589 C3                       ret
  7175                                  ; ENDP
  7176                                  ;Number of CALLs:    3 : fcloseR
  7177                                  
  7178                                  fcloseR:  ; *** PROC ***
  7179                                  ;Function : fcloseR, Number of local variables: 1
  7180                                  ;   # type sign width line used address name   list of local variables
  7181                                  ;  200 var sign word   272 NULL bp+4    fd;
  7182 0000358A C8000000                 ENTER  0,0
  7183 0000358E 8B5E04                   mov  bx, [bp+4]
  7184 00003591 B8003E                   mov  ax, 15872
  7185 00003594 CD21                     int  33
  7186                                  
  7187                                  ;-273 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7188 00003596 C9                       LEAVE
  7189 00003597 C3                       ret
  7190                                  ; ENDP
  7191                                  ;Number of CALLs:    5 : exitR
  7192                                  
  7193                                  exitR:  ; *** PROC ***
  7194                                  ;Function : exitR, Number of local variables: 1
  7195                                  ;   # type sign width line used address name   list of local variables
  7196                                  ;  200 var sign byte   273 NULL bp+4    c;
  7197 00003598 C8000000                 ENTER  0,0
  7198 0000359C B44C                     mov  ah, 76
  7199 0000359E 8A4604                   mov  al, [bp+4]
  7200 000035A1 CD21                     int  33
  7201                                  
  7202                                  ;-274 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7203 000035A3 C9                       LEAVE
  7204 000035A4 C3                       ret
  7205                                  ; ENDP
  7206                                  ;End of archive file. 
  7207                                   
  7208                                  ; missing functions: 
  7209                                  ; putch
  7210                                  ; DosInt
  7211                                  ; DosInt
  7212                                  ; DosInt
  7213                                  ; DosInt
  7214                                  ; Number of unresolved CALLs :    5
  7215                                  ;use archive file: AR.C
  7216                                  
  7217                                  ;-275 // AR.C Archive
  7218                                  
  7219                                  ;Number of CALLs:    1 : putch
  7220                                  
  7221                                  putch:  ; *** PROC ***
  7222                                  ;Function : putch, Number of local variables: 1
  7223                                  ;   # type sign width line used address name   list of local variables
  7224                                  ;  200 var sign byte   275 NULL bp+4    c;
  7225 000035A5 C8000000                 ENTER  0,0
  7226 000035A9 807E040A                cmp byte [bp+4], 10
  7227 000035AD 0F850500                 jne @@putch302
  7228 000035B1 B00D                     mov  al, 13
  7229 000035B3 E8FFFD                   call writetty
  7230                                  @@putch302:
  7231 000035B6 8A4604                   mov  al, [bp+4]
  7232 000035B9 E8F9FD                   call writetty
  7233                                  
  7234                                  ;-276 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7235 000035BC C9                       LEAVE
  7236 000035BD C3                       ret
  7237                                  ; ENDP
  7238                                  ;Number of CALLs:    4 : DosInt
  7239                                  
  7240                                  DosInt:  ; *** PROC ***
  7241 000035BE CD21                     int  33
  7242 000035C0 7304                     jae short @@DosInt303
  7243 000035C2 FF06[9F01]               inc  word [DOS_ERR]
  7244                                  @@DosInt303:
  7245                                  
  7246                                  ;-277 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7247                                  
  7248 000035C6 C3                       ret
  7249                                  ; ENDP
  7250                                  ;End of archive file. 
  7251                                   
  7252                                  ; missing functions:  All FUNCTIONs in place
  7253 000035C7 E80000                  LastFunctionByt:db 0E8h, 0, 0
  7254 000035CA 58                      pop ax
  7255 000035CB C3                      ret
  7256                                   
  7257                                  ;   # type sign width line used  address name   list of global variables
  7258                                  
  7259                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7260                                  ;    2 var sign byte     1    3        0 LIST
  7261                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7262                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  7263                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7264                                  ;    6 var unsg word     5   16        0 SymbolInt
  7265                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7266                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7267                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7268                                  ;   10 arr sign byte     9    5        0 namein[67]
  7269                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7270                                  ;   12 arr sign byte    11    5        0 namebin[67]
  7271                                  ;   13 var sign word    12    4        0 asm_fd
  7272                                  ;   14 var sign word    13    3        0 lst_fd
  7273                                  ;   15 var sign word    14    3        0 bin_fd
  7274                                  ;   16 var sign word    15    6        0 DOS_ERR
  7275                                  ;   17 var sign word    16    4        0 ErrorCount
  7276                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7277                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7278                                  ;   20 var unsg word    20    5        0 PC
  7279                                  ;   21 var unsg word    21    2        0 PCStart
  7280                                  ;   22 var sign byte    22    3        0 isLabel
  7281                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7282                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7283                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7284                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7285                                  ;   27 var sign byte    27   22        0 TokeType
  7286                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7287                                  ;   29 def unsg byte    29    -        0 WORD=2
  7288                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7289                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7290                                  ;   32 def unsg byte    32    -        0 IMM=1
  7291                                  ;   33 def unsg byte    33    -        0 REG=2
  7292                                  ;   34 def unsg byte    34    -        0 ADR=3
  7293                                  ;   35 def unsg byte    35    -        0 MEM=4
  7294                                  ;   36 var sign byte    36   28        0 Op
  7295                                  ;   37 var sign byte    37   29        0 Op2
  7296                                  ;   38 var sign byte    38   18        0 CodeType
  7297                                  ;   39 var sign byte    39   13        0 Code1
  7298                                  ;   40 var sign byte    40    8        0 Code2
  7299                                  ;   41 var sign byte    41    3        0 Code3
  7300                                  ;   42 var sign byte    42   18        0 R2No
  7301                                  ;   43 var sign byte    43   16        0 R1No
  7302                                  ;   44 var sign byte    44   17        0 R2Type
  7303                                  ;   45 var sign byte    45   14        0 R1Type
  7304                                  ;   46 var sign byte    46   13        0 OpSize
  7305                                  ;   47 var sign byte    47    8        0 wflag
  7306                                  ;   48 var sign byte    48    3        0 dflag
  7307                                  ;   49 var sign byte    49    8        0 sflag
  7308                                  ;   50 var sign byte    50   15        0 rm
  7309                                  ;   51 var sign byte    51    5        0 isDirect
  7310                                  ;   52 var sign word    52   17        0 disp
  7311                                  ;   53 var unsg word    53   10        0 imme
  7312                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7313                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7314                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7315                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7316                                  ;   58 var sign byte    59    2        0 PrintR
  7317                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7318                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7319                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7320                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7321                                  ;   63 arr unsg word    65    3        0 LabelAddr[100]
  7322                                  ;   64 var sign word    66    4        0 LabelMaxIx
  7323                                  ;   65 var sign word    67    4        0 LabelIx
  7324                                  ;   66 def unsg byte    69    -        0 FILEBINMAX=2000
  7325                                  ;   67 arr sign byte    70    2        0 FileBin[2000]
  7326                                  ;   68 var unsg word    71    5        0 BinLen
  7327                                  ;   69 ptr sign byte    73    1        0 arglen
  7328                                  ;   70 ptr sign byte    74    4        0 argv
  7329                                  ;   71 var sign byte     1    1        0 I_START
  7330                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  7331                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  7332                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  7333                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  7334                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  7335                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  7336                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  7337                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  7338                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  7339                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  7340                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  7341                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  7342                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  7343                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  7344                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  7345                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  7346                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  7347                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  7348                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  7349                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  7350                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  7351                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  7352                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  7353                                  ;   95 arr sign byte    27 NULL        0 I_INT3[8]
  7354                                  ;   96 arr sign byte    28 NULL        0 I_INTO[8]
  7355                                  ;   97 arr sign byte    29 NULL        0 I_IRET[8]
  7356                                  ;   98 arr sign byte    30 NULL        0 I_XLAT[8]
  7357                                  ;   99 arr sign byte    31 NULL        0 I_LOCK[8]
  7358                                  ;  100 arr sign byte    32 NULL        0 I_REPNE[9]
  7359                                  ;  101 arr sign byte    33 NULL        0 I_REPNZ[9]
  7360                                  ;  102 arr sign byte    34 NULL        0 I_REPE[8]
  7361                                  ;  103 arr sign byte    35 NULL        0 I_REPZ[8]
  7362                                  ;  104 arr sign byte    36 NULL        0 I_HLT[7]
  7363                                  ;  105 arr sign byte    37 NULL        0 I_CLC[7]
  7364                                  ;  106 arr sign byte    38 NULL        0 I_STC[7]
  7365                                  ;  107 arr sign byte    39 NULL        0 I_CLI[7]
  7366                                  ;  108 arr sign byte    40 NULL        0 I_STI[7]
  7367                                  ;  109 arr sign byte    41 NULL        0 I_CLD[7]
  7368                                  ;  110 arr sign byte    42 NULL        0 I_STD[7]
  7369                                  ;  111 arr sign byte    44 NULL        0 I_INC[9]
  7370                                  ;  112 arr sign byte    45 NULL        0 I_DEC[9]
  7371                                  ;  113 arr sign byte    46 NULL        0 I_NOT[8]
  7372                                  ;  114 arr sign byte    47 NULL        0 I_NEG[8]
  7373                                  ;  115 arr sign byte    48 NULL        0 I_MUL[8]
  7374                                  ;  116 arr sign byte    49 NULL        0 I_IMUL[9]
  7375                                  ;  117 arr sign byte    50 NULL        0 I_DIV[8]
  7376                                  ;  118 arr sign byte    51 NULL        0 I_IDIV[9]
  7377                                  ;  119 arr sign byte    53 NULL        0 I_LES[7]
  7378                                  ;  120 arr sign byte    54 NULL        0 I_LDS[7]
  7379                                  ;  121 arr sign byte    55 NULL        0 I_LEA[7]
  7380                                  ;  122 arr sign byte    56 NULL        0 I_LSS[8]
  7381                                  ;  123 arr sign byte    57 NULL        0 I_LFS[8]
  7382                                  ;  124 arr sign byte    58 NULL        0 I_LGS[8]
  7383                                  ;  125 arr sign byte    60 NULL        0 I_ADD[7]
  7384                                  ;  126 arr sign byte    61 NULL        0 I_OR[6]
  7385                                  ;  127 arr sign byte    62 NULL        0 I_ADC[7]
  7386                                  ;  128 arr sign byte    63 NULL        0 I_SBB[7]
  7387                                  ;  129 arr sign byte    64 NULL        0 I_AND[7]
  7388                                  ;  130 arr sign byte    65 NULL        0 I_SUB[7]
  7389                                  ;  131 arr sign byte    66 NULL        0 I_XOR[7]
  7390                                  ;  132 arr sign byte    67 NULL        0 I_CMP[7]
  7391                                  ;  133 arr sign byte    68 NULL        0 I_TEST[11]
  7392                                  ;  134 arr sign byte    70 NULL        0 I_MOV[6]
  7393                                  ;  135 arr sign byte    71 NULL        0 I_MOVSX[9]
  7394                                  ;  136 arr sign byte    72 NULL        0 I_MOVZX[9]
  7395                                  ;  137 arr sign byte    74 NULL        0 I_JO[6]
  7396                                  ;  138 arr sign byte    75 NULL        0 I_JNO[7]
  7397                                  ;  139 arr sign byte    76 NULL        0 I_JB[6]
  7398                                  ;  140 arr sign byte    77 NULL        0 I_JC[6]
  7399                                  ;  141 arr sign byte    78 NULL        0 I_JNB[7]
  7400                                  ;  142 arr sign byte    79 NULL        0 I_JAE[7]
  7401                                  ;  143 arr sign byte    80 NULL        0 I_JNC[7]
  7402                                  ;  144 arr sign byte    81 NULL        0 I_JE[6]
  7403                                  ;  145 arr sign byte    82 NULL        0 I_JZ[6]
  7404                                  ;  146 arr sign byte    83 NULL        0 I_JNE[7]
  7405                                  ;  147 arr sign byte    84 NULL        0 I_JNZ[7]
  7406                                  ;  148 arr sign byte    85 NULL        0 I_JBE[7]
  7407                                  ;  149 arr sign byte    86 NULL        0 I_JNA[7]
  7408                                  ;  150 arr sign byte    87 NULL        0 I_JA[6]
  7409                                  ;  151 arr sign byte    88 NULL        0 I_JS[6]
  7410                                  ;  152 arr sign byte    89 NULL        0 I_JNS[7]
  7411                                  ;  153 arr sign byte    90 NULL        0 I_JP[6]
  7412                                  ;  154 arr sign byte    91 NULL        0 I_JPE[7]
  7413                                  ;  155 arr sign byte    92 NULL        0 I_JNP[7]
  7414                                  ;  156 arr sign byte    93 NULL        0 I_JPO[7]
  7415                                  ;  157 arr sign byte    94 NULL        0 I_JL[6]
  7416                                  ;  158 arr sign byte    95 NULL        0 I_JNL[7]
  7417                                  ;  159 arr sign byte    96 NULL        0 I_JGE[7]
  7418                                  ;  160 arr sign byte    97 NULL        0 I_JLE[7]
  7419                                  ;  161 arr sign byte    98 NULL        0 I_JNG[7]
  7420                                  ;  162 arr sign byte    99 NULL        0 I_JG[6]
  7421                                  ;  163 arr sign byte   101 NULL        0 I_JMP[8]
  7422                                  ;  164 arr sign byte   102 NULL        0 I_CALL[9]
  7423                                  ;  165 arr sign byte   104 NULL        0 I_RET[8]
  7424                                  ;  166 arr sign byte   105 NULL        0 I_RETF[9]
  7425                                  ;  167 arr sign byte   107 NULL        0 I_PUSH[11]
  7426                                  ;  168 arr sign byte   108 NULL        0 I_POP[10]
  7427                                  ;  169 arr sign byte   110 NULL        0 I_ROL[7]
  7428                                  ;  170 arr sign byte   111 NULL        0 I_ROR[7]
  7429                                  ;  171 arr sign byte   112 NULL        0 I_RCL[7]
  7430                                  ;  172 arr sign byte   113 NULL        0 I_RCR[7]
  7431                                  ;  173 arr sign byte   114 NULL        0 I_SHL[7]
  7432                                  ;  174 arr sign byte   115 NULL        0 I_SAL[7]
  7433                                  ;  175 arr sign byte   116 NULL        0 I_SHR[7]
  7434                                  ;  176 arr sign byte   117 NULL        0 I_SAR[7]
  7435                                  ;  177 arr sign byte   119 NULL        0 I_INT[8]
  7436                                  ;  178 arr sign byte   130 NULL        0 I_XCHG[9]
  7437                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNZ[10]
  7438                                  ;  180 arr sign byte   133 NULL        0 I_LOOPNE[10]
  7439                                  ;  181 arr sign byte   134 NULL        0 I_LOOPZ[9]
  7440                                  ;  182 arr sign byte   135 NULL        0 I_LOOPE[9]
  7441                                  ;  183 arr sign byte   136 NULL        0 I_LOOP[8]
  7442                                  ;  184 arr sign byte   137 NULL        0 I_JCXZ[8]
  7443                                  ;  185 arr sign byte   138 NULL        0 I_JECXZ[9]
  7444                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  7445                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  7446                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  7447                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  7448                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  7449                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  7450                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  7451                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  7452                                  ;  194 var sign byte   153 NULL        0 I_END
  7453                                  
  7454                                  
  7455                                  ;   # Calls Line Width  Name   list of functions
  7456                                  
  7457                                  ;    0    2    1 word   ChangeDirection
  7458                                  ;    1    2    9 word   checkOpL
  7459                                  ;    2    3   18 word   check2Ops
  7460                                  ;    3    1   27 word   get2Ops
  7461                                  ;    4    3   33 word   getOpL
  7462                                  ;    5    2   41 word   getOpR
  7463                                  ;    6    4   51 word   getOp1
  7464                                  ;    7    1   67 word   getMEM
  7465                                  ;    8    1   90 word   getIndReg1
  7466                                  ;    9    1   98 word   getIndReg2
  7467                                  ;   10    2  108 word   setwflag
  7468                                  ;   11    2  119 word   setsflag
  7469                                  ;   12    1    1 word   parse
  7470                                  ;   13   14   27 word   getTokeType
  7471                                  ;   14    2   36 word   storeLabel
  7472                                  ;   15    2   46 word   searchLabel
  7473                                  ;   16    1   57 word   getVariable
  7474                                  ;   17    2   86 word   lookCode
  7475                                  ;   18    1  101 word   getCodeSize
  7476                                  ;   19    8  108 word   isToken
  7477                                  ;   20    2  113 word   need
  7478                                  ;   21    1  123 word   skipRest
  7479                                  ;   22    1    1 word   getLine
  7480                                  ;   23    1   17 word   ifEOL
  7481                                  ;   24    3   24 word   skipBlank
  7482                                  ;   25    2   29 word   letterE
  7483                                  ;   26    1   39 word   alnumE
  7484                                  ;   27    1   44 word   getDigit
  7485                                  ;   28    1   56 word   getName
  7486                                  ;   29    1   75 word   testReg
  7487                                  ;   30    1    1 word   printLine
  7488                                  ;   31    7   22 word   prc
  7489                                  ;   32    1   34 word   prscomment
  7490                                  ;   33   23   42 word   prs
  7491                                  ;   34    3   64 word   printhex8a
  7492                                  ;   35    2   69 word   printhex4
  7493                                  ;   36    1   74 word   printhex16
  7494                                  ;   37    3   79 word   printIntU
  7495                                  ;   38   25   90 word   error1
  7496                                  ;   39   12   98 word   errorexit
  7497                                  ;   40 NULL  102 word   allowederror
  7498                                  ;   41    3  103 word   addrerror
  7499                                  ;   42    1  104 word   immeerror
  7500                                  ;   43    2  105 word   implerror
  7501                                  ;   44    4  106 word   indexerror
  7502                                  ;   45    3  107 word   invaloperror
  7503                                  ;   46    3  108 word   numbererror
  7504                                  ;   47    1  109 word   regmemerror
  7505                                  ;   48    3  110 word   reg16error
  7506                                  ;   49    1  111 word   segregerror
  7507                                  ;   50    4  112 word   syntaxerror
  7508                                  ;   51 NULL  114 word   addrexit
  7509                                  ;   52 NULL  115 word   internexit
  7510                                  ;   53 NULL    1 word   main
  7511                                  ;   54    1    8 word   getarg
  7512                                  ;   55    1   42 word   epilog
  7513                                  ;   56    2   60 word   end1
  7514                                  ;   57    1    2 word   getCodes
  7515                                  ;   58    1    7 word   gen66h
  7516                                  ;   59    5    9 word   genCode2
  7517                                  ;   60   10   13 word   genCodeW
  7518                                  ;   61   25   17 word   genCode8
  7519                                  ;   62    8   28 word   genCode16
  7520                                  ;   63   10   32 word   writeEA
  7521                                  ;   64    4   74 word   genImmediate
  7522                                  ;   65    1   11 word   process
  7523                                  ;   66    4  255 word   writetty
  7524                                  ;   67    8  256 word   cputs
  7525                                  ;   68    2  257 word   toupper
  7526                                  ;   69    3  259 word   strlen
  7527                                  ;   70    6  260 word   strcpy
  7528                                  ;   71    3  262 word   digit
  7529                                  ;   72   35  263 word   eqstr
  7530                                  ;   73    3  266 word   strcat1
  7531                                  ;   74    1  267 word   openR
  7532                                  ;   75    2  268 word   creatR
  7533                                  ;   76    2  269 word   readRL
  7534                                  ;   77    2  270 word   fputcR
  7535                                  ;   78    3  272 word   fcloseR
  7536                                  ;   79    5  273 word   exitR
  7537                                  ;   80    1  275 word   putch
  7538                                  ;   81    4  276 word   DosInt
  7539                                  ;   82 NULL  277 word   LastFunctionByt
  7540                                  
  7541                                  ;    #  addr name   list of CALLs
  7542                                  
  7543                                  ;    0  1367 implerror
  7544                                  ;    1  1377 segregerror
  7545                                  ;    2  1389 setwflag
  7546                                  ;    3  1398 error1
  7547                                  ;    4  1405 error1
  7548                                  ;    5  1422 get2Ops
  7549                                  ;    6  1430 addrerror
  7550                                  ;    7  1440 invaloperror
  7551                                  ;    8  1453 immeerror
  7552                                  ;    9  1463 addrerror
  7553                                  ;   10  1473 invaloperror
  7554                                  ;   11  1486 setwflag
  7555                                  ;   12  1503 getOpL
  7556                                  ;   13  1510 need
  7557                                  ;   14  1515 getOpR
  7558                                  ;   15  1529 getOpR
  7559                                  ;   16  1543 getOp1
  7560                                  ;   17  1550 isToken
  7561                                  ;   18  1558 getMEM
  7562                                  ;   19  1565 invaloperror
  7563                                  ;   20  1578 error1
  7564                                  ;   21  1592 testReg
  7565                                  ;   22  1600 searchLabel
  7566                                  ;   23  1612 error1
  7567                                  ;   24  1628 getTokeType
  7568                                  ;   25  1640 getOp1
  7569                                  ;   26  1647 syntaxerror
  7570                                  ;   27  1659 getIndReg2
  7571                                  ;   28  1670 getIndReg1
  7572                                  ;   29  1681 isToken
  7573                                  ;   30  1689 getTokeType
  7574                                  ;   31  1701 numbererror
  7575                                  ;   32  1713 isToken
  7576                                  ;   33  1721 isToken
  7577                                  ;   34  1729 errorexit
  7578                                  ;   35  1750 indexerror
  7579                                  ;   36  1761 indexerror
  7580                                  ;   37  1785 indexerror
  7581                                  ;   38  1796 indexerror
  7582                                  ;   39  1816 gen66h
  7583                                  ;   40  1835 error1
  7584                                  ;   41  1848 getLine
  7585                                  ;   42  1856 getTokeType
  7586                                  ;   43  1868 storeLabel
  7587                                  ;   44  1879 getTokeType
  7588                                  ;   45  1891 lookCode
  7589                                  ;   46  1900 process
  7590                                  ;   47  1908 getVariable
  7591                                  ;   48  1920 skipRest
  7592                                  ;   49  1929 error1
  7593                                  ;   50  1936 error1
  7594                                  ;   51  1943 printLine
  7595                                  ;   52  1967 skipBlank
  7596                                  ;   53  1977 digit
  7597                                  ;   54  1983 getDigit
  7598                                  ;   55  1992 letterE
  7599                                  ;   56  2000 getName
  7600                                  ;   57  2021 searchLabel
  7601                                  ;   58  2033 error1
  7602                                  ;   59  2040 strcpy
  7603                                  ;   60  2047 errorexit
  7604                                  ;   61  2057 errorexit
  7605                                  ;   62  2087 eqstr
  7606                                  ;   63  2093 strlen
  7607                                  ;   64  2114 storeLabel
  7608                                  ;   65  2125 getTokeType
  7609                                  ;   66  2137 lookCode
  7610                                  ;   67  2146 errorexit
  7611                                  ;   68  2156 errorexit
  7612                                  ;   69  2166 getTokeType
  7613                                  ;   70  2178 genCode8
  7614                                  ;   71  2187 skipBlank
  7615                                  ;   72  2197 isToken
  7616                                  ;   73  2205 genCode8
  7617                                  ;   74  2214 isToken
  7618                                  ;   75  2222 getTokeType
  7619                                  ;   76  2234 genCode16
  7620                                  ;   77  2244 isToken
  7621                                  ;   78  2252 errorexit
  7622                                  ;   79  2271 eqstr
  7623                                  ;   80  2289 eqstr
  7624                                  ;   81  2295 getTokeType
  7625                                  ;   82  2307 eqstr
  7626                                  ;   83  2313 getTokeType
  7627                                  ;   84  2325 eqstr
  7628                                  ;   85  2331 getTokeType
  7629                                  ;   86  2353 skipBlank
  7630                                  ;   87  2370 isToken
  7631                                  ;   88  2378 getTokeType
  7632                                  ;   89  2390 error1
  7633                                  ;   90  2397 prs
  7634                                  ;   91  2401 prc
  7635                                  ;   92  2414 getTokeType
  7636                                  ;   93  2426 error1
  7637                                  ;   94  2443 readRL
  7638                                  ;   95  2450 errorexit
  7639                                  ;   96  2460 errorexit
  7640                                  ;   97  2470 ifEOL
  7641                                  ;   98  2484 readRL
  7642                                  ;   99  2520 digit
  7643                                  ;  100  2526 letterE
  7644                                  ;  101  2553 digit
  7645                                  ;  102  2573 alnumE
  7646                                  ;  103  2580 errorexit
  7647                                  ;  104  2590 strcpy
  7648                                  ;  105  2597 toupper
  7649                                  ;  106  2613 strlen
  7650                                  ;  107  2620 strlen
  7651                                  ;  108  2627 eqstr
  7652                                  ;  109  2633 eqstr
  7653                                  ;  110  2639 eqstr
  7654                                  ;  111  2645 eqstr
  7655                                  ;  112  2651 eqstr
  7656                                  ;  113  2657 eqstr
  7657                                  ;  114  2663 eqstr
  7658                                  ;  115  2669 eqstr
  7659                                  ;  116  2675 eqstr
  7660                                  ;  117  2681 eqstr
  7661                                  ;  118  2687 eqstr
  7662                                  ;  119  2693 eqstr
  7663                                  ;  120  2699 eqstr
  7664                                  ;  121  2705 eqstr
  7665                                  ;  122  2711 eqstr
  7666                                  ;  123  2717 eqstr
  7667                                  ;  124  2723 eqstr
  7668                                  ;  125  2729 eqstr
  7669                                  ;  126  2735 eqstr
  7670                                  ;  127  2741 eqstr
  7671                                  ;  128  2747 eqstr
  7672                                  ;  129  2753 eqstr
  7673                                  ;  130  2759 eqstr
  7674                                  ;  131  2765 eqstr
  7675                                  ;  132  2771 eqstr
  7676                                  ;  133  2777 eqstr
  7677                                  ;  134  2783 eqstr
  7678                                  ;  135  2789 eqstr
  7679                                  ;  136  2795 eqstr
  7680                                  ;  137  2801 eqstr
  7681                                  ;  138  2821 prs
  7682                                  ;  139  2825 printhex16
  7683                                  ;  140  2836 prs
  7684                                  ;  141  2840 prc
  7685                                  ;  142  2844 printhex8a
  7686                                  ;  143  2855 prc
  7687                                  ;  144  2859 prs
  7688                                  ;  145  2863 prscomment
  7689                                  ;  146  2880 writetty
  7690                                  ;  147  2889 writetty
  7691                                  ;  148  2898 fputcR
  7692                                  ;  149  2920 prc
  7693                                  ;  150  2936 prc
  7694                                  ;  151  2957 printhex4
  7695                                  ;  152  2967 printhex4
  7696                                  ;  153  2989 prc
  7697                                  ;  154  3011 printhex8a
  7698                                  ;  155  3022 printhex8a
  7699                                  ;  156  3047 printIntU
  7700                                  ;  157  3057 prc
  7701                                  ;  158  3070 prs
  7702                                  ;  159  3074 prs
  7703                                  ;  160  3078 prs
  7704                                  ;  161  3082 prs
  7705                                  ;  162  3098 error1
  7706                                  ;  163  3105 end1
  7707                                  ;  164  3123 error1
  7708                                  ;  165  3140 error1
  7709                                  ;  166  3157 error1
  7710                                  ;  167  3174 error1
  7711                                  ;  168  3192 error1
  7712                                  ;  169  3212 error1
  7713                                  ;  170  3231 error1
  7714                                  ;  171  3250 error1
  7715                                  ;  172  3268 error1
  7716                                  ;  173  3287 error1
  7717                                  ;  174  3306 error1
  7718                                  ;  175  3322 errorexit
  7719                                  ;  176  3343 errorexit
  7720                                  ;  177  3358 getarg
  7721                                  ;  178  3365 parse
  7722                                  ;  179  3371 epilog
  7723                                  ;  180  3378 end1
  7724                                  ;  181  3402 cputs
  7725                                  ;  182  3408 cputs
  7726                                  ;  183  3414 exitR
  7727                                  ;  184  3420 toupper
  7728                                  ;  185  3428 strcpy
  7729                                  ;  186  3435 strcat1
  7730                                  ;  187  3443 strcpy
  7731                                  ;  188  3450 strcat1
  7732                                  ;  189  3458 strcpy
  7733                                  ;  190  3465 strcat1
  7734                                  ;  191  3473 openR
  7735                                  ;  192  3479 cputs
  7736                                  ;  193  3485 cputs
  7737                                  ;  194  3491 exitR
  7738                                  ;  195  3497 creatR
  7739                                  ;  196  3504 cputs
  7740                                  ;  197  3510 cputs
  7741                                  ;  198  3516 exitR
  7742                                  ;  199  3522 creatR
  7743                                  ;  200  3529 cputs
  7744                                  ;  201  3535 cputs
  7745                                  ;  202  3541 exitR
  7746                                  ;  203  3547 prs
  7747                                  ;  204  3551 prs
  7748                                  ;  205  3555 prs
  7749                                  ;  206  3559 prs
  7750                                  ;  207  3563 prs
  7751                                  ;  208  3567 prs
  7752                                  ;  209  3571 prs
  7753                                  ;  210  3575 prs
  7754                                  ;  211  3579 prs
  7755                                  ;  212  3596 prs
  7756                                  ;  213  3600 printIntU
  7757                                  ;  214  3610 prs
  7758                                  ;  215  3614 prs
  7759                                  ;  216  3618 prs
  7760                                  ;  217  3622 prs
  7761                                  ;  218  3626 printIntU
  7762                                  ;  219  3636 prs
  7763                                  ;  220  3640 fputcR
  7764                                  ;  221  3654 fcloseR
  7765                                  ;  222  3662 fcloseR
  7766                                  ;  223  3670 fcloseR
  7767                                  ;  224  3678 exitR
  7768                                  ;  225  3700 genCode8
  7769                                  ;  226  3722 genCode8
  7770                                  ;  227  3742 genCode8
  7771                                  ;  228  3762 errorexit
  7772                                  ;  229  3784 genCode8
  7773                                  ;  230  3793 genCode8
  7774                                  ;  231  3818 genCode8
  7775                                  ;  232  3827 genCode8
  7776                                  ;  233  3836 genCode16
  7777                                  ;  234  3859 genCode16
  7778                                  ;  235  3869 genCode8
  7779                                  ;  236  3888 getTokeType
  7780                                  ;  237  3900 getCodeSize
  7781                                  ;  238  3912 getCodes
  7782                                  ;  239  3921 genCode8
  7783                                  ;  240  3930 getOpL
  7784                                  ;  241  3937 checkOpL
  7785                                  ;  242  3946 genCode2
  7786                                  ;  243  3955 getTokeType
  7787                                  ;  244  3967 implerror
  7788                                  ;  245  3977 genCodeW
  7789                                  ;  246  3986 writeEA
  7790                                  ;  247  3994 check2Ops
  7791                                  ;  248  4004 reg16error
  7792                                  ;  249  4015 addrerror
  7793                                  ;  250  4025 genCode8
  7794                                  ;  251  4034 genCode8
  7795                                  ;  252  4043 writeEA
  7796                                  ;  253  4051 check2Ops
  7797                                  ;  254  4061 setsflag
  7798                                  ;  255  4070 genCodeW
  7799                                  ;  256  4079 genImmediate
  7800                                  ;  257  4092 genCodeW
  7801                                  ;  258  4101 writeEA
  7802                                  ;  259  4109 genCode8
  7803                                  ;  260  4118 genImmediate
  7804                                  ;  261  4131 genCodeW
  7805                                  ;  262  4140 writeEA
  7806                                  ;  263  4148 genCodeW
  7807                                  ;  264  4157 writeEA
  7808                                  ;  265  4165 syntaxerror
  7809                                  ;  266  4177 check2Ops
  7810                                  ;  267  4187 genCode2
  7811                                  ;  268  4196 genImmediate
  7812                                  ;  269  4209 genCodeW
  7813                                  ;  270  4218 writeEA
  7814                                  ;  271  4226 genImmediate
  7815                                  ;  272  4239 regmemerror
  7816                                  ;  273  4251 ChangeDirection
  7817                                  ;  274  4267 reg16error
  7818                                  ;  275  4278 genCode2
  7819                                  ;  276  4287 writeEA
  7820                                  ;  277  4295 genCodeW
  7821                                  ;  278  4304 genCode16
  7822                                  ;  279  4314 genCodeW
  7823                                  ;  280  4323 genCode16
  7824                                  ;  281  4333 genCodeW
  7825                                  ;  282  4342 writeEA
  7826                                  ;  283  4350 ChangeDirection
  7827                                  ;  284  4366 genCodeW
  7828                                  ;  285  4375 writeEA
  7829                                  ;  286  4383 syntaxerror
  7830                                  ;  287  4395 genCode8
  7831                                  ;  288  4404 genCode16
  7832                                  ;  289  4414 genCode8
  7833                                  ;  290  4423 getOpL
  7834                                  ;  291  4430 setsflag
  7835                                  ;  292  4439 genCode2
  7836                                  ;  293  4448 genCode8
  7837                                  ;  294  4457 genCode16
  7838                                  ;  295  4467 error1
  7839                                  ;  296  4474 genCode8
  7840                                  ;  297  4483 genCode8
  7841                                  ;  298  4492 checkOpL
  7842                                  ;  299  4501 reg16error
  7843                                  ;  300  4512 genCode2
  7844                                  ;  301  4521 genCode8
  7845                                  ;  302  4530 writeEA
  7846                                  ;  303  4538 syntaxerror
  7847                                  ;  304  4550 genCode8
  7848                                  ;  305  4559 genCode8
  7849                                  ;  306  4568 genCode8
  7850                                  ;  307  4577 genCode8
  7851                                  ;  308  4586 getOp1
  7852                                  ;  309  4593 genCode16
  7853                                  ;  310  4603 numbererror
  7854                                  ;  311  4615 need
  7855                                  ;  312  4620 getOp1
  7856                                  ;  313  4627 genCode8
  7857                                  ;  314  4636 numbererror
  7858                                  ;  315  4648 error1
  7859                                  ;  316  4655 error1
  7860                                  ;  317  4681 putch
  7861                                  ;  318  4749 strcpy
  7862                                  ;  319  4764 DosInt
  7863                                  ;  320  4780 DosInt
  7864                                  ;  321  4803 DosInt
  7865                                  ;  322  4822 DosInt
  7866                                  ;  323  4856 writetty
  7867                                  ;  324  4865 writetty
  7868                                  ;Input: AS.C, List: AS.S,  Lines:  278
  7869                                  ;Glob. variables:  194 max.:  200
  7870                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7871                                  ;Functions      :   83 max.:  300
  7872                                  ;Calls          :  325 max.: 2000, NameField: 4897 max.:    65535
  7873                                  ;Code until     :25998 max.: 30000, free: 4002
  7874                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7875                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
