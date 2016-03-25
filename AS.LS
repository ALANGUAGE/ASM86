     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E9718B                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.1";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E31-     Version1 db "AS.C V0.1",0
    10 0000000C 00                 
    11                                  
    12                                  ;-2 #include "DECL.C"
    13                                  
    14                                  ;Use include file: DECL.C
    15                                  
    16                                  ;-1 char LIST;              //listing on/off     
    17                                  
    18 0000000D 00                      LIST db 0
    19                                  
    20                                  ;-2 #define SYMBOLMAX    31
    21                                  
    22                                  
    23                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    24                                  
    25 0000000E <res 0000001F>          Symbol resb 31
    26                                  
    27                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    28                                  
    29 0000002D <res 0000001F>          SymbolUpper resb 31
    30                                  
    31                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    32                                  
    33 0000004C 0000                    SymbolInt dw 0
    34                                  
    35                                  ;-6 #define INPUTBUFMAX 255
    36                                  
    37                                  
    38                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    39                                  
    40 0000004E <res 000000FF>          InputBuf resb 255
    41                                  
    42                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    43                                  
    44 0000014D 0000                    InputPtr dw 0
    45                                  
    46                                  ;-9 char namein [67];       //input file name  .S
    47                                  
    48 0000014F <res 00000043>          namein resb 67
    49                                  
    50                                  ;-10 char namelst[67];       //list file name   .LST
    51                                  
    52 00000192 <res 00000043>          namelst resb 67
    53                                  
    54                                  ;-11 char namebin[67];       //output file name .COM
    55                                  
    56 000001D5 <res 00000043>          namebin resb 67
    57                                  
    58                                  ;-12 int  asm_fd;            //input file descriptor
    59                                  
    60 00000218 0000                    asm_fd dw 0
    61                                  
    62                                  ;-13 int lst_fd;             //list file descriptor
    63                                  
    64 0000021A 0000                    lst_fd dw 0
    65                                  
    66                                  ;-14 int bin_fd;             //output file descriptor
    67                                  
    68 0000021C 0000                    bin_fd dw 0
    69                                  
    70                                  ;-15 int DOS_ERR=0;          //global var
    71                                  
    72 0000021E 0000                    DOS_ERR dw 0
    73                                  
    74                                  ;-16 int ErrorCount=0;       //number of errors
    75                                  
    76 00000220 0000                    ErrorCount dw 0
    77                                  
    78                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    79                                  
    80 00000222 0000                    DOS_NoBytes dw 0
    81                                  
    82                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    83                                  
    84 00000224 00                      DOS_ByteRead db 0
    85                                  
    86                                  ;-19 
    87                                  
    88                                  
    89                                  ;-20 unsigned int PC=0;      //program counter
    90                                  
    91 00000225 0000                    PC dw 0
    92                                  
    93                                  ;-21 unsigned int Origin=0;  //ORG nn   
    94                                  
    95 00000227 0000                    Origin dw 0
    96                                  
    97                                  ;-22 unsigned int AbsoluteLab=0;//uninitialised data
    98                                  
    99 00000229 0000                    AbsoluteLab dw 0
   100                                  
   101                                  ;-23 unsigned int PCStart;   //PC at start of line by PrintLine()
   102                                  
   103 0000022B 0000                    PCStart dw 0
   104                                  
   105                                  ;-24 char isLabel;           //by getName()
   106                                  
   107 0000022D 00                      isLabel db 0
   108                                  
   109                                  ;-25 #define DIGIT    1      //0-9
   110                                  
   111                                  
   112                                  ;-26 #define LETTERE  2      //a-z A-Z @ . _
   113                                  
   114                                  
   115                                  ;-27 #define ALNUME   3      //a-z A-Z @ . _  0-9
   116                                  
   117                                  
   118                                  ;-28 #define NOALNUME 4      //other char
   119                                  
   120                                  
   121                                  ;-29 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   122                                  
   123 0000022E 00                      TokeType db 0
   124                                  
   125                                  ;-30 #define BYTE     1
   126                                  
   127                                  
   128                                  ;-31 #define WORD     2
   129                                  
   130                                  
   131                                  ;-32 #define DWORD    3
   132                                  
   133                                  
   134                                  ;-33 #define SEGREG   4
   135                                  
   136                                  
   137                                  ;-34 #define IMM      1      //const  ,123
   138                                  
   139                                  
   140                                  ;-35 #define REG      2      //       ,BX    mode=11
   141                                  
   142                                  
   143                                  ;-36 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   144                                  
   145                                  
   146                                  ;-37 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   147                                  
   148                                  
   149                                  ;-38 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   150                                  
   151 0000022F 00                      Op db 0
   152                                  
   153                                  ;-39 char Op2;               //2. operand
   154                                  
   155 00000230 00                      Op2 db 0
   156                                  
   157                                  ;-40 char CodeType;          //1-207 by searchSymbol(), must be byte size
   158                                  
   159 00000231 00                      CodeType db 0
   160                                  
   161                                  ;-41 char Code1;             //1. Opcode
   162                                  
   163 00000232 00                      Code1 db 0
   164                                  
   165                                  ;-42 char Code2;             //2. Opcode
   166                                  
   167 00000233 00                      Code2 db 0
   168                                  
   169                                  ;-43 char Code3;             //3. Opcode
   170                                  
   171 00000234 00                      Code3 db 0
   172                                  
   173                                  ;-44 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   174                                  
   175 00000235 00                      R2No db 0
   176                                  
   177                                  ;-45 char R1No;              //temp for 1. register
   178                                  
   179 00000236 00                      R1No db 0
   180                                  
   181                                  ;-46 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   182                                  
   183 00000237 00                      R2Type db 0
   184                                  
   185                                  ;-47 char R1Type;            //temp for 1. register 
   186                                  
   187 00000238 00                      R1Type db 0
   188                                  
   189                                  ;-48 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   190                                  
   191 00000239 00                      OpSize db 0
   192                                  
   193                                  ;-49 char wflag;             //wordflag: 0=byte, 1=word/dword
   194                                  
   195 0000023A 00                      wflag db 0
   196                                  
   197                                  ;-50 char dflag;             //directionflag: 1=to reg MOV,ALU    
   198                                  
   199 0000023B 00                      dflag db 0
   200                                  
   201                                  ;-51 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   202                                  
   203 0000023C 00                      sflag db 0
   204                                  
   205                                  ;-52 char rm;                //combination of index and base reg
   206                                  
   207 0000023D 00                      rm db 0
   208                                  
   209                                  ;-53 char isDirect;          //set in process and getMeM, need in WriteEA
   210                                  
   211 0000023E 00                      isDirect db 0
   212                                  
   213                                  ;-54 int disp;               //displacement      0-8 bytes
   214                                  
   215 0000023F 0000                    disp dw 0
   216                                  
   217                                  ;-55 unsigned int imme;      //immediate         0-8 bytes
   218                                  
   219 00000241 0000                    imme dw 0
   220                                  
   221                                  ;-56 
   222                                  
   223                                  
   224                                  ;-57 #define OPMAXLEN 5
   225                                  
   226                                  
   227                                  ;-58 char OpPos[OPMAXLEN];   //array for one opcode to list
   228                                  
   229 00000243 <res 00000005>          OpPos resb 5
   230                                  
   231                                  ;-59 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   232                                  
   233 00000248 0000                    OpPrintIndex dw 0
   234                                  
   235                                  ;-60 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   236                                  
   237 0000024A 0000                    OpCodePtr dw 0
   238                                  
   239                                  ;-61 char PrintRA;           //print * for forward relocative jmp
   240                                  
   241 0000024C 00                      PrintRA db 0
   242                                  
   243                                  ;-62 
   244                                  
   245                                  
   246                                  ;-63 #define LABELNAMESMAX 3969//next number - SYMBOLMAX
   247                                  
   248                                  
   249                                  ;-64 char LabelNames[4000];  //space for names of all labels
   250                                  
   251 0000024D <res 00000FA0>          LabelNames resb 4000
   252                                  
   253                                  ;-65 char *LabelNamePtr;     //first free position
   254                                  
   255 000011ED 0000                    LabelNamePtr dw 0
   256                                  
   257                                  ;-66 #define LABELADRMAX 600
   258                                  
   259                                  
   260                                  ;-67 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   261                                  
   262 000011EF <res 000004B0>          LabelAddr resw 600
   263                                  
   264                                  ;-68 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   265                                  
   266 0000169F 0000                    LabelMaxIx dw 0
   267                                  
   268                                  ;-69 int LabelIx;            //actual # of just searched label
   269                                  
   270 000016A1 0000                    LabelIx dw 0
   271                                  
   272                                  ;-70 
   273                                  
   274                                  
   275                                  ;-71 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   276                                  
   277                                  
   278                                  ;-72 char JmpCallNames[2000];//space for names of jmp, call
   279                                  
   280 000016A3 <res 000007D0>          JmpCallNames resb 2000
   281                                  
   282                                  ;-73 char *JmpCallNamePtr;   //first free position 
   283                                  
   284 00001E73 0000                    JmpCallNamePtr dw 0
   285                                  
   286                                  ;-74 #define JMPCALLMAX 500  //max. jmp and call
   287                                  
   288                                  
   289                                  ;-75 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   290                                  
   291 00001E75 <res 000003E8>          JmpCallAddr resw 500
   292                                  
   293                                  ;-76 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   294                                  
   295 0000225D 0000                    JmpCallMaxIx dw 0
   296                                  
   297                                  ;-77  
   298                                  
   299                                  
   300                                  ;-78 #define FILEBINMAX 20000 
   301                                  
   302                                  
   303                                  ;-79 char FileBin  [FILEBINMAX];//output binary file
   304                                  
   305 0000225F <res 00004E20>          FileBin resb 20000
   306                                  
   307                                  ;-80 unsigned int BinLen=0;  //length of binary file
   308                                  
   309 0000707F 0000                    BinLen dw 0
   310                                  
   311                                  ;-81 
   312                                  
   313                                  
   314                                  ;-82 char *arglen=0x80;      // for main only
   315                                  
   316 00007081 8000                    arglen dw 128
   317                                  
   318                                  ;-83 char *argv=0x82;        // for main only
   319                                  
   320 00007083 8200                    argv dw 130
   321                                  ;Back to main program: AS.C
   322                                  
   323                                  ;-3 #include "OPTABL.C"   
   324                                  
   325                                  ;Use include file: OPTABL.C
   326                                  
   327                                  ;-1 char I_START=0xF1;
   328                                  
   329 00007085 F1                      I_START db 241
   330                                  
   331                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   332                                  
   333                                  
   334                                  ;-3 //  1:   1 byte opcode
   335                                  
   336                                  
   337                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   338                                  
   339 00007086 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   340                                  
   341                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   342                                  
   343 0000708F 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   344                                  
   345                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   346                                  
   347 00007097 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   348                                  
   349                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   350                                  
   351 0000709E 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   352                                  
   353                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   354                                  
   355 000070A5 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   356                                  
   357                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   358                                  
   359 000070AD 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   360                                  
   361                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   362                                  
   363 000070B4 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   364                                  
   365                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   366                                  
   367 000070BB 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   368                                  
   369                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   370                                  
   371 000070C3 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   372                                  
   373                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   374                                  
   375 000070CC 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   376                                  
   377                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   378                                  
   379 000070D4 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   380                                  
   381                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   382                                  
   383 000070DC 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   384                                  
   385                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   386                                  
   387 000070E4 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   388                                  
   389                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   390                                  
   391 000070ED 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   392                                  
   393                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   394                                  
   395 000070F6 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   396                                  
   397                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   398                                  
   399 000070FF 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   400                                  
   401                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   402                                  
   403 00007108 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   404                                  
   405                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   406                                  
   407 00007111 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   408                                  
   409                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   410                                  
   411 0000711A 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   412                                  
   413                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   414                                  
   415 00007123 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   416                                  
   417                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   418                                  
   419 0000712C 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   420                                  
   421                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   422                                  
   423 00007135 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   424                                  
   425                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   426                                  
   427 0000713E 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   428                                  
   429                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   430                                  
   431 00007147 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   432                                  
   433                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   434                                  
   435 0000714F 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   436                                  
   437                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   438                                  
   439 00007157 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   440                                  
   441                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   442                                  
   443 0000715F 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   444                                  
   445                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   446                                  
   447 00007167 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   448                                  
   449                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   450                                  
   451 0000716F 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   452                                  
   453                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   454                                  
   455 00007178 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   456                                  
   457                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   458                                  
   459 00007181 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   460                                  
   461                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   462                                  
   463 00007189 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   464                                  
   465                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   466                                  
   467 00007191 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   468                                  
   469                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   470                                  
   471 00007198 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   472                                  
   473                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   474                                  
   475 0000719F 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   476                                  
   477                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   478                                  
   479 000071A6 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   480                                  
   481                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   482                                  
   483 000071AD 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   484                                  
   485                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   486                                  
   487 000071B4 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   488                                  
   489                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   490                                  
   491 000071BB 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   492                                  
   493                                  ;-43 // 2: mem reg 16 bit
   494                                  
   495                                  
   496                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   497                                  
   498 000071C2 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   499                                  
   500                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   501                                  
   502 000071CB 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   503                                  
   504                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   505                                  
   506 000071D4 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   507                                  
   508                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   509                                  
   510 000071DC 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   511                                  
   512                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   513                                  
   514 000071E4 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   515                                  
   516                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   517                                  
   518 000071EC 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   519                                  
   520                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   521                                  
   522 000071F5 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   523                                  
   524                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   525                                  
   526 000071FD 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   527                                  
   528                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   529                                  
   530                                  
   531                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   532                                  
   533 00007206 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   534                                  
   535                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   536                                  
   537 0000720D 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   538                                  
   539                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   540                                  
   541 00007214 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   542                                  
   543                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   544                                  
   545 0000721B 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   546                                  
   547                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   548                                  
   549 00007223 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   550                                  
   551                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   552                                  
   553 0000722B 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   554                                  
   555                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   556                                  
   557                                  
   558                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   559                                  
   560 00007233 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   561                                  
   562                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   563                                  
   564 0000723A 4F52000401F1            I_OR db 79,82,0,4,1,241
   565                                  
   566                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   567                                  
   568 00007240 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   569                                  
   570                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   571                                  
   572 00007247 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   573                                  
   574                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   575                                  
   576 0000724E 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   577                                  
   578                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   579                                  
   580 00007255 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   581                                  
   582                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   583                                  
   584 0000725C 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   585                                  
   586                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   587                                  
   588 00007263 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   589                                  
   590                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   591                                  
   592 0000726A 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   593 00007273 00F1               
   594                                  
   595                                  ;-69 //  5: mov
   596                                  
   597                                  
   598                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   599                                  
   600 00007275 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   601                                  
   602                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   603                                  
   604 0000727B 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   605                                  
   606                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   607                                  
   608 00007284 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   609                                  
   610                                  ;-73 //  6: single byte relative jump
   611                                  
   612                                  
   613                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   614                                  
   615 0000728D 4A4F000600F1            I_JO db 74,79,0,6,0,241
   616                                  
   617                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   618                                  
   619 00007293 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   620                                  
   621                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   622                                  
   623 0000729A 4A42000602F1            I_JB db 74,66,0,6,2,241
   624                                  
   625                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   626                                  
   627 000072A0 4A43000602F1            I_JC db 74,67,0,6,2,241
   628                                  
   629                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   630                                  
   631 000072A6 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   632                                  
   633                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   634                                  
   635 000072AD 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   636                                  
   637                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   638                                  
   639 000072B4 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   640                                  
   641                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   642                                  
   643 000072BB 4A45000604F1            I_JE db 74,69,0,6,4,241
   644                                  
   645                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   646                                  
   647 000072C1 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   648                                  
   649                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   650                                  
   651 000072C7 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   652                                  
   653                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   654                                  
   655 000072CE 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   656                                  
   657                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   658                                  
   659 000072D5 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   660                                  
   661                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   662                                  
   663 000072DC 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   664                                  
   665                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   666                                  
   667 000072E3 4A41000607F1            I_JA db 74,65,0,6,7,241
   668                                  
   669                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   670                                  
   671 000072E9 4A53000608F1            I_JS db 74,83,0,6,8,241
   672                                  
   673                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   674                                  
   675 000072EF 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   676                                  
   677                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   678                                  
   679 000072F6 4A5000060AF1            I_JP db 74,80,0,6,10,241
   680                                  
   681                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   682                                  
   683 000072FC 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   684                                  
   685                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   686                                  
   687 00007303 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   688                                  
   689                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   690                                  
   691 0000730A 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   692                                  
   693                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   694                                  
   695 00007311 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   696                                  
   697                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   698                                  
   699 00007317 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   700                                  
   701                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   702                                  
   703 0000731E 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   704                                  
   705                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   706                                  
   707 00007325 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   708                                  
   709                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   710                                  
   711 0000732C 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   712                                  
   713                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   714                                  
   715 00007333 4A4700060FF1            I_JG db 74,71,0,6,15,241
   716                                  
   717                                  ;-100 //  7: jmp, call
   718                                  
   719                                  
   720                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   721                                  
   722 00007339 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   723                                  
   724                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   725                                  
   726 00007341 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   727                                  
   728                                  ;-103 //  8: ret
   729                                  
   730                                  
   731                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   732                                  
   733 0000734A 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   734                                  
   735                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   736                                  
   737 00007352 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   738                                  
   739                                  ;-106 //  9: seg, r/m
   740                                  
   741                                  
   742                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   743                                  
   744 0000735B 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   745 00007364 06F1               
   746                                  
   747                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   748                                  
   749 00007366 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   750 0000736F F1                 
   751                                  
   752                                  ;-109 //  11: shift, rotates
   753                                  
   754                                  
   755                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   756                                  
   757 00007370 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   758                                  
   759                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   760                                  
   761 00007377 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   762                                  
   763                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   764                                  
   765 0000737E 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   766                                  
   767                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   768                                  
   769 00007385 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   770                                  
   771                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   772                                  
   773 0000738C 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   774                                  
   775                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 4,    0xF1};
   776                                  
   777 00007393 53414C000B04F1          I_SAL db 83,65,76,0,11,4,241
   778                                  
   779                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 5,    0xF1};
   780                                  
   781 0000739A 534852000B05F1          I_SHR db 83,72,82,0,11,5,241
   782                                  
   783                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   784                                  
   785 000073A1 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   786                                  
   787                                  ;-118 //  12: int
   788                                  
   789                                  
   790                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   791                                  
   792 000073A8 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   793                                  
   794                                  ;-120 //  14: in/out
   795                                  
   796                                  
   797                                  ;-121 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   798                                  
   799                                  
   800                                  ;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   801                                  
   802                                  
   803                                  ;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   804                                  
   805                                  
   806                                  ;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   807                                  
   808                                  
   809                                  ;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   810                                  
   811                                  
   812                                  ;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   813                                  
   814                                  
   815                                  ;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   816                                  
   817                                  
   818                                  ;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   819                                  
   820                                  
   821                                  ;-129 //  15: xchg
   822                                  
   823                                  
   824                                  ;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   825                                  
   826 000073B0 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   827                                  
   828                                  ;-131 //  16: loop, jcxz
   829                                  
   830                                  
   831                                  ;-132 /*char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   832                                  
   833                                  
   834                                  ;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   835                                  
   836                                  
   837                                  ;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   838                                  
   839                                  
   840                                  ;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   841                                  
   842                                  
   843                                  ;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   844                                  
   845                                  
   846                                  ;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   847                                  
   848                                  
   849                                  ;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};*/
   850                                  
   851                                  
   852                                  ;-139 //  30: enter
   853                                  
   854                                  
   855                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};
   856                                  
   857 000073B9 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   858                                  
   859                                  ;-141 // 100: directives
   860                                  
   861                                  
   862                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   863                                  
   864 000073C1 4F52470065F1            I_ORG db 79,82,71,0,101,241
   865                                  
   866                                  ;-143 // section, segment .TEXT .DATA .BSS
   867                                  
   868                                  
   869                                  ;-144 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   870                                  
   871 000073C7 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   872 000073D0 F1                 
   873                                  
   874                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   875                                  
   876 000073D1 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   877 000073DA F1                 
   878                                  
   879                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   880                                  
   881 000073DB 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   882 000073E4 6EF1               
   883                                  
   884                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   885                                  
   886 000073E6 444200C8F1              I_DB db 68,66,0,200,241
   887                                  
   888                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   889                                  
   890 000073EB 445700C9F1              I_DW db 68,87,0,201,241
   891                                  
   892                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   893                                  
   894 000073F0 444400CAF1              I_DD db 68,68,0,202,241
   895                                  
   896                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   897                                  
   898 000073F5 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   899                                  
   900                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   901                                  
   902 000073FC 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   903                                  
   904                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   905                                  
   906 00007403 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   907                                  
   908                                  ;-153 char I_END=0;// end of table char
   909                                  
   910 0000740A 00                      I_END db 0
   911                                  ;Back to main program: AS.C
   912                                  
   913                                  ;-4 #include "OPS.C"
   914                                  
   915                                  ;Use include file: OPS.C
   916                                  
   917                                  ;-1 int ChangeDirection() {
   918                                  
   919                                  
   920                                  ChangeDirection:  ; *** PROC ***
   921                                  
   922                                  ;-2     char c;
   923                                  
   924                                  
   925                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   926                                  
   927                                  ;Function : ChangeDirection, Number of local variables: 1
   928                                  ;   # type sign width line used address name   list of local variables
   929                                  ;  200 var sign byte     2 NULL bp-2    c;
   930 0000740B C8020000                 ENTER  2,0
   931 0000740F A0[2F02]                 mov al, [Op]
   932 00007412 8846FE                   mov byte [bp-2], al
   933 00007415 A0[3002]                 mov al, [Op2]
   934 00007418 A2[2F02]                 mov byte [Op], al
   935 0000741B 8A46FE                   mov al, [bp-2]
   936 0000741E A2[3002]                 mov byte [Op2], al
   937                                  
   938                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   939                                  
   940 00007421 A0[3802]                 mov al, [R1Type]
   941 00007424 8846FE                   mov byte [bp-2], al
   942 00007427 A0[3702]                 mov al, [R2Type]
   943 0000742A A2[3802]                 mov byte [R1Type], al
   944 0000742D 8A46FE                   mov al, [bp-2]
   945 00007430 A2[3702]                 mov byte [R2Type], al
   946                                  
   947                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   948                                  
   949 00007433 A0[3602]                 mov al, [R1No]
   950 00007436 8846FE                   mov byte [bp-2], al
   951 00007439 A0[3502]                 mov al, [R2No]
   952 0000743C A2[3602]                 mov byte [R1No], al
   953 0000743F 8A46FE                   mov al, [bp-2]
   954 00007442 A2[3502]                 mov byte [R2No], al
   955                                  
   956                                  ;-6     dflag=2;     
   957                                  
   958 00007445 66B802000000             mov eax, 2
   959 0000744B A2[3B02]                 mov byte [dflag], al
   960                                  
   961                                  ;-7 }
   962                                  
   963                                  
   964                                  ;-8      
   965                                  
   966                                  
   967                                  ;-9 int checkOpL() {
   968 0000744E C9                       LEAVE
   969 0000744F C3                       ret
   970                                  ; ENDP
   971                                  
   972                                  checkOpL:  ; *** PROC ***
   973                                  
   974                                  ;-10     if (Op == ADR) implerror();
   975                                  
   976 00007450 A0[2F02]                 mov al, [Op]
   977 00007453 3C03                     cmp al, 3
   978 00007455 0F850300                 jne @@checkOpL1
   979 00007459 E8B615                   call implerror
   980                                  
   981                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   982                                  
   983                                  @@checkOpL1:
   984 0000745C A0[3802]                 mov al, [R1Type]
   985 0000745F 3C04                     cmp al, 4
   986 00007461 0F850600                 jne @@checkOpL2
   987 00007465 E87216                   call segregerror
   988 00007468 E93E00                   jmp @@retn
   989                                  
   990                                  ;-12     setwflag();
   991                                  
   992                                  @@checkOpL2:
   993 0000746B E8CB03                   call setwflag
   994                                  
   995                                  ;-13     if (OpSize == 0) error1("no op size declared");
   996                                  
   997 0000746E A0[3902]                 mov al, [OpSize]
   998 00007471 3C00                     cmp al, 0
   999 00007473 0F850900                 jne @@checkOpL3
  1000 00007477 68[AA74]                 push checkOpL_0
  1001 0000747A E8C514                   call error1
  1002 0000747D 83C402                   add  sp, 2
  1003                                  
  1004                                  ;-14     if (OpSize == R1Type) return;
  1005                                  
  1006                                  @@checkOpL3:
  1007 00007480 A0[3902]                 mov al, [OpSize]
  1008 00007483 3A06[3802]               cmp al, [R1Type]
  1009 00007487 0F850300                 jne @@checkOpL4
  1010 0000748B E91B00                   jmp @@retn
  1011                                  
  1012                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1013                                  
  1014                                  @@checkOpL4:
  1015 0000748E A0[2F02]                 mov al, [Op]
  1016 00007491 3C02                     cmp al, 2
  1017 00007493 0F851200                 jne @@checkOpL5
  1018 00007497 A0[3802]                 mov al, [R1Type]
  1019 0000749A 3C00                     cmp al, 0
  1020 0000749C 0F850900                 jne @@checkOpL6
  1021 000074A0 68[BE74]                 push checkOpL_1
  1022 000074A3 E89C14                   call error1
  1023 000074A6 83C402                   add  sp, 2
  1024                                  
  1025                                  ;-16 }
  1026                                  
  1027                                  @@checkOpL6:
  1028                                  @@checkOpL5:
  1029                                  
  1030                                  ;-17     
  1031                                  
  1032                                  
  1033                                  ;-18 int check2Ops() {
  1034                                  
  1035                                  @@retn:
  1036 000074A9 C3                       ret
  1037                                  ; ENDP
  1038 000074AA 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1039 000074B3 65206465636C617265-
  1040 000074BC 6400               
  1041 000074BE 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1042 000074C7 657220646566696E65-
  1043 000074D0 6400               
  1044                                  
  1045                                  check2Ops:  ; *** PROC ***
  1046                                  
  1047                                  ;-19     get2Ops();
  1048                                  
  1049 000074D2 E84900                   call get2Ops
  1050                                  
  1051                                  ;-20     if (Op ==   0) addrerror();
  1052                                  
  1053 000074D5 A0[2F02]                 mov al, [Op]
  1054 000074D8 3C00                     cmp al, 0
  1055 000074DA 0F850300                 jne @@check2Ops7
  1056 000074DE E8F214                   call addrerror
  1057                                  
  1058                                  ;-21     if (Op == ADR) invaloperror(); 
  1059                                  
  1060                                  @@check2Ops7:
  1061 000074E1 A0[2F02]                 mov al, [Op]
  1062 000074E4 3C03                     cmp al, 3
  1063 000074E6 0F850300                 jne @@check2Ops8
  1064 000074EA E86015                   call invaloperror
  1065                                  
  1066                                  ;-22     if (Op == IMM) immeerror();   
  1067                                  
  1068                                  @@check2Ops8:
  1069 000074ED A0[2F02]                 mov al, [Op]
  1070 000074F0 3C01                     cmp al, 1
  1071 000074F2 0F850300                 jne @@check2Ops9
  1072 000074F6 E8F414                   call immeerror
  1073                                  
  1074                                  ;-23     if (Op2==   0) addrerror();
  1075                                  
  1076                                  @@check2Ops9:
  1077 000074F9 A0[3002]                 mov al, [Op2]
  1078 000074FC 3C00                     cmp al, 0
  1079 000074FE 0F850300                 jne @@check2Ops10
  1080 00007502 E8CE14                   call addrerror
  1081                                  
  1082                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           
  1083                                  
  1084                                  @@check2Ops10:
  1085 00007505 A0[3102]                 mov al, [CodeType]
  1086 00007508 3C05                     cmp al, 5
  1087 0000750A 0F840C00                 je  @@check2Ops11
  1088 0000750E A0[3002]                 mov al, [Op2]
  1089 00007511 3C03                     cmp al, 3
  1090 00007513 0F850300                 jne @@check2Ops12
  1091 00007517 E83315                   call invaloperror
  1092                                  
  1093                                  ;-25     setwflag();       
  1094                                  
  1095                                  @@check2Ops12:
  1096                                  @@check2Ops11:
  1097 0000751A E81C03                   call setwflag
  1098                                  
  1099                                  ;-26 }    
  1100                                  
  1101                                  
  1102                                  ;-27 int get2Ops() {
  1103                                  
  1104 0000751D C3                       ret
  1105                                  ; ENDP
  1106                                  
  1107                                  get2Ops:  ; *** PROC ***
  1108                                  
  1109                                  ;-28     getOpL();
  1110                                  
  1111 0000751E E80C00                   call getOpL
  1112                                  
  1113                                  ;-29     need(',');    
  1114                                  
  1115 00007521 6A2C                     push 44
  1116 00007523 E8F309                   call need
  1117 00007526 83C402                   add  sp, 2
  1118                                  
  1119                                  ;-30     getOpR();         
  1120                                  
  1121 00007529 E83200                   call getOpR
  1122                                  
  1123                                  ;-31 } 
  1124                                  
  1125                                  
  1126                                  ;-32         
  1127                                  
  1128                                  
  1129                                  ;-33 int getOpL() {
  1130                                  
  1131 0000752C C3                       ret
  1132                                  ; ENDP
  1133                                  
  1134                                  getOpL:  ; *** PROC ***
  1135                                  
  1136                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1137                                  
  1138                                  
  1139                                  ;-35     getOpR();
  1140                                  
  1141 0000752D E82E00                   call getOpR
  1142                                  
  1143                                  ;-36     Op=Op2;         Op2=0;
  1144                                  
  1145 00007530 A0[3002]                 mov al, [Op2]
  1146 00007533 A2[2F02]                 mov byte [Op], al
  1147 00007536 66B800000000             mov eax, 0
  1148 0000753C A2[3002]                 mov byte [Op2], al
  1149                                  
  1150                                  ;-37     R1No=R2No;      R2No=0;
  1151                                  
  1152 0000753F A0[3502]                 mov al, [R2No]
  1153 00007542 A2[3602]                 mov byte [R1No], al
  1154 00007545 66B800000000             mov eax, 0
  1155 0000754B A2[3502]                 mov byte [R2No], al
  1156                                  
  1157                                  ;-38     R1Type=R2Type; R2Type=0; 
  1158                                  
  1159 0000754E A0[3702]                 mov al, [R2Type]
  1160 00007551 A2[3802]                 mov byte [R1Type], al
  1161 00007554 66B800000000             mov eax, 0
  1162 0000755A A2[3702]                 mov byte [R2Type], al
  1163                                  
  1164                                  ;-39 }  
  1165                                  
  1166                                  
  1167                                  ;-40 
  1168                                  
  1169                                  
  1170                                  ;-41 int getOpR() {
  1171                                  
  1172 0000755D C3                       ret
  1173                                  ; ENDP
  1174                                  
  1175                                  getOpR:  ; *** PROC ***
  1176                                  
  1177                                  ;-42     Op2=getOp1();
  1178                                  
  1179 0000755E E88900                   call getOp1
  1180 00007561 A2[3002]                 mov byte [Op2], al
  1181                                  
  1182                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1183                                  
  1184 00007564 6A5B                     push 91
  1185 00007566 E88209                   call isToken
  1186 00007569 83C402                   add  sp, 2
  1187 0000756C 08C0                     or  al, al
  1188 0000756E 0F840F00                 je @@getOpR13
  1189 00007572 66B804000000             mov eax, 4
  1190 00007578 A2[3002]                 mov byte [Op2], al
  1191 0000757B E8F200                   call getMEM
  1192 0000757E E94F00                   jmp @@retn
  1193                                  
  1194                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1195                                  
  1196                                  @@getOpR13:
  1197 00007581 A0[3002]                 mov al, [Op2]
  1198 00007584 3C00                     cmp al, 0
  1199 00007586 0F850600                 jne @@getOpR14
  1200 0000758A E8C014                   call invaloperror
  1201 0000758D E94000                   jmp @@retn
  1202                                  
  1203                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1204                                  
  1205                                  @@getOpR14:
  1206 00007590 A0[3002]                 mov al, [Op2]
  1207 00007593 3C01                     cmp al, 1
  1208 00007595 0F850900                 jne @@getOpR15
  1209 00007599 A1[4C00]                 mov ax, [SymbolInt]
  1210 0000759C A3[4102]                 mov word [imme], ax
  1211 0000759F E92E00                   jmp @@retn
  1212                                  
  1213                                  ;-46     if (Op2 == REG)                            return;
  1214                                  
  1215                                  @@getOpR15:
  1216 000075A2 A0[3002]                 mov al, [Op2]
  1217 000075A5 3C02                     cmp al, 2
  1218 000075A7 0F850300                 jne @@getOpR16
  1219 000075AB E92200                   jmp @@retn
  1220                                  
  1221                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1222                                  
  1223                                  @@getOpR16:
  1224 000075AE A0[3002]                 mov al, [Op2]
  1225 000075B1 3C03                     cmp al, 3
  1226 000075B3 0F851000                 jne @@getOpR17
  1227 000075B7 8B1E[A116]               mov bx, [LabelIx]
  1228 000075BB D1E3                     shl bx, 1
  1229 000075BD 8B87[EF11]               mov ax, [LabelAddr + bx]
  1230 000075C1 A3[3F02]                 mov word [disp], ax
  1231 000075C4 E90900                   jmp @@retn
  1232                                  
  1233                                  ;-48     error1("Name of operand expected");
  1234                                  
  1235                                  @@getOpR17:
  1236 000075C7 68[D175]                 push getOpR_0
  1237 000075CA E87513                   call error1
  1238 000075CD 83C402                   add  sp, 2
  1239                                  
  1240                                  ;-49 }
  1241                                  
  1242                                  
  1243                                  ;-50 
  1244                                  
  1245                                  
  1246                                  ;-51 int getOp1() {//scan for a single operand
  1247                                  
  1248                                  @@retn:
  1249 000075D0 C3                       ret
  1250                                  ; ENDP
  1251 000075D1 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1252 000075DA 706572616E64206578-
  1253 000075E3 70656374656400     
  1254                                  
  1255                                  getOp1:  ; *** PROC ***
  1256                                  
  1257                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1258                                  
  1259                                  
  1260                                  ;-53 //set   :R2Type, R2No by testReg
  1261                                  
  1262                                  
  1263                                  ;-54 //set   :LabelIx by searchLabel
  1264                                  
  1265                                  
  1266                                  ;-55     if (TokeType == 0)      return 0;
  1267                                  
  1268 000075EA A0[2E02]                 mov al, [TokeType]
  1269 000075ED 3C00                     cmp al, 0
  1270 000075EF 0F850900                 jne @@getOp118
  1271 000075F3 66B800000000             mov eax, 0
  1272 000075F9 E96000                   jmp @@retn
  1273                                  
  1274                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1275                                  
  1276                                  @@getOp118:
  1277 000075FC A0[2E02]                 mov al, [TokeType]
  1278 000075FF 3C01                     cmp al, 1
  1279 00007601 0F850900                 jne @@getOp119
  1280 00007605 66B801000000             mov eax, 1
  1281 0000760B E94E00                   jmp @@retn
  1282                                  
  1283                                  ;-57     if (TokeType == ALNUME) {
  1284                                  
  1285                                  @@getOp119:
  1286 0000760E A0[2E02]                 mov al, [TokeType]
  1287 00007611 3C03                     cmp al, 3
  1288 00007613 0F853C00                 jne @@getOp120
  1289                                  
  1290                                  ;-58         R2No=testReg();
  1291                                  
  1292 00007617 E87E0C                   call testReg
  1293 0000761A A2[3502]                 mov byte [R2No], al
  1294                                  
  1295                                  ;-59         if (R2Type)        return REG;
  1296                                  
  1297 0000761D A0[3702]                 mov al, [R2Type]
  1298 00007620 08C0                     or  al, al
  1299 00007622 0F840900                 je @@getOp121
  1300 00007626 66B802000000             mov eax, 2
  1301 0000762C E92D00                   jmp @@retn
  1302                                  
  1303                                  ;-60         LabelIx=searchLabel();
  1304                                  
  1305                                  @@getOp121:
  1306 0000762F E8F005                   call searchLabel
  1307 00007632 A3[A116]                 mov word [LabelIx], ax
  1308                                  
  1309                                  ;-61         if (LabelIx)        return ADR;
  1310                                  
  1311 00007635 A1[A116]                 mov ax, [LabelIx]
  1312 00007638 08C0                     or  al, al
  1313 0000763A 0F840C00                 je @@getOp122
  1314 0000763E 66B803000000             mov eax, 3
  1315 00007644 E91500                   jmp @@retn
  1316                                  
  1317                                  ;-62         else error1("variable not found"); 
  1318                                  
  1319 00007647 E90900                   jmp @@getOp123
  1320                                  @@getOp122:
  1321 0000764A 68[5D76]                 push getOp1_0
  1322 0000764D E8F212                   call error1
  1323 00007650 83C402                   add  sp, 2
  1324                                  
  1325                                  ;-63     }
  1326                                  
  1327                                  @@getOp123:
  1328                                  
  1329                                  ;-64     return 0;
  1330                                  
  1331                                  @@getOp120:
  1332 00007653 66B800000000             mov eax, 0
  1333 00007659 E90000                   jmp @@retn
  1334                                  
  1335                                  ;-65 }
  1336                                  
  1337                                  
  1338                                  ;-66 
  1339                                  
  1340                                  
  1341                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1342                                  
  1343                                  @@retn:
  1344 0000765C C3                       ret
  1345                                  ; ENDP
  1346 0000765D 7661726961626C6520-     getOp1_0 db "variable not found",0
  1347 00007666 6E6F7420666F756E64-
  1348 0000766F 00                 
  1349                                  
  1350                                  getMEM:  ; *** PROC ***
  1351                                  
  1352                                  ;-68 //set: disp, rm, R2Type
  1353                                  
  1354                                  
  1355                                  ;-69     char c;
  1356                                  
  1357                                  
  1358                                  ;-70     disp=0; rm=0;
  1359                                  
  1360                                  ;Function : getMEM, Number of local variables: 1
  1361                                  ;   # type sign width line used address name   list of local variables
  1362                                  ;  200 var sign byte    69 NULL bp-2    c;
  1363 00007670 C8020000                 ENTER  2,0
  1364 00007674 66B800000000             mov eax, 0
  1365 0000767A A3[3F02]                 mov word [disp], ax
  1366 0000767D 66B800000000             mov eax, 0
  1367 00007683 A2[3D02]                 mov byte [rm], al
  1368                                  
  1369                                  ;-71     do {
  1370                                  
  1371                                  @@getMEM24:
  1372                                  
  1373                                  ;-72         getTokeType();
  1374                                  
  1375 00007686 E8D203                   call getTokeType
  1376                                  
  1377                                  ;-73         c=getOp1();
  1378                                  
  1379 00007689 E85EFF                   call getOp1
  1380 0000768C 8846FE                   mov byte [bp-2], al
  1381                                  
  1382                                  ;-74         if (c ==   0) syntaxerror();
  1383                                  
  1384 0000768F 8A46FE                   mov al, [bp-2]
  1385 00007692 3C00                     cmp al, 0
  1386 00007694 0F850300                 jne @@getMEM25
  1387 00007698 E86614                   call syntaxerror
  1388                                  
  1389                                  ;-75         if (c == REG) {
  1390                                  
  1391                                  @@getMEM25:
  1392 0000769B 8A46FE                   mov al, [bp-2]
  1393 0000769E 3C02                     cmp al, 2
  1394 000076A0 0F851E00                 jne @@getMEM26
  1395                                  
  1396                                  ;-76             isDirect=0;
  1397                                  
  1398 000076A4 66B800000000             mov eax, 0
  1399 000076AA A2[3E02]                 mov byte [isDirect], al
  1400                                  
  1401                                  ;-77             if (rm) rm=getIndReg2();
  1402                                  
  1403 000076AD A0[3D02]                 mov al, [rm]
  1404 000076B0 08C0                     or  al, al
  1405 000076B2 0F840900                 je @@getMEM27
  1406 000076B6 E8F300                   call getIndReg2
  1407 000076B9 A2[3D02]                 mov byte [rm], al
  1408                                  
  1409                                  ;-78             else getIndReg1();
  1410                                  
  1411 000076BC E90300                   jmp @@getMEM28
  1412                                  @@getMEM27:
  1413 000076BF E88900                   call getIndReg1
  1414                                  
  1415                                  ;-79         }
  1416                                  
  1417                                  @@getMEM28:
  1418                                  
  1419                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1420                                  
  1421                                  @@getMEM26:
  1422 000076C2 8A46FE                   mov al, [bp-2]
  1423 000076C5 3C03                     cmp al, 3
  1424 000076C7 0F851000                 jne @@getMEM29
  1425 000076CB A1[3F02]                 mov ax, [disp]
  1426 000076CE 8B1E[A116]               mov bx, [LabelIx]
  1427 000076D2 D1E3                     shl bx, 1
  1428 000076D4 0387[EF11]               add ax, [LabelAddr + bx]
  1429 000076D8 A3[3F02]                 mov word [disp], ax
  1430                                  
  1431                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1432                                  
  1433                                  @@getMEM29:
  1434 000076DB 8A46FE                   mov al, [bp-2]
  1435 000076DE 3C01                     cmp al, 1
  1436 000076E0 0F850A00                 jne @@getMEM30
  1437 000076E4 A1[3F02]                 mov ax, [disp]
  1438 000076E7 0306[4C00]               add ax, [SymbolInt]
  1439 000076EB A3[3F02]                 mov word [disp], ax
  1440                                  
  1441                                  ;-82         if (isToken('-')) {
  1442                                  
  1443                                  @@getMEM30:
  1444 000076EE 6A2D                     push 45
  1445 000076F0 E8F807                   call isToken
  1446 000076F3 83C402                   add  sp, 2
  1447 000076F6 08C0                     or  al, al
  1448 000076F8 0F841900                 je @@getMEM31
  1449                                  
  1450                                  ;-83             getTokeType();
  1451                                  
  1452 000076FC E85C03                   call getTokeType
  1453                                  
  1454                                  ;-84             if (TokeType != DIGIT) numbererror();
  1455                                  
  1456 000076FF A0[2E02]                 mov al, [TokeType]
  1457 00007702 3C01                     cmp al, 1
  1458 00007704 0F840300                 je  @@getMEM32
  1459 00007708 E86313                   call numbererror
  1460                                  
  1461                                  ;-85             disp = disp - SymbolInt;
  1462                                  
  1463                                  @@getMEM32:
  1464 0000770B A1[3F02]                 mov ax, [disp]
  1465 0000770E 2B06[4C00]               sub ax, [SymbolInt]
  1466 00007712 A3[3F02]                 mov word [disp], ax
  1467                                  
  1468                                  ;-86         }
  1469                                  
  1470                                  
  1471                                  ;-87     } while (isToken('+'));
  1472                                  
  1473                                  @@getMEM31:
  1474 00007715 6A2B                     push 43
  1475 00007717 E8D107                   call isToken
  1476 0000771A 83C402                   add  sp, 2
  1477 0000771D 08C0                     or  al, al
  1478 0000771F 0F840300                 je @@getMEM33
  1479 00007723 E960FF                   jmp @@getMEM24
  1480                                  @@getMEM33:
  1481                                  
  1482                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1483                                  
  1484 00007726 6A5D                     push 93
  1485 00007728 E8C007                   call isToken
  1486 0000772B 83C402                   add  sp, 2
  1487 0000772E 83F800                   cmp ax, 0
  1488 00007731 0F850900                 jne @@getMEM34
  1489 00007735 68[4077]                 push getMEM_0
  1490 00007738 E86612                   call errorexit
  1491 0000773B 83C402                   add  sp, 2
  1492                                  
  1493                                  ;-89 }
  1494                                  
  1495                                  @@getMEM34:
  1496                                  
  1497                                  ;-90 int getIndReg1() {
  1498 0000773E C9                       LEAVE
  1499 0000773F C3                       ret
  1500                                  ; ENDP
  1501 00007740 5D2065787065637465-     getMEM_0 db "] expected",0
  1502 00007749 6400               
  1503                                  
  1504                                  getIndReg1:  ; *** PROC ***
  1505                                  
  1506                                  ;-91     if (R2Type !=WORD) indexerror();
  1507                                  
  1508 0000774B A0[3702]                 mov al, [R2Type]
  1509 0000774E 3C02                     cmp al, 2
  1510 00007750 0F840300                 je  @@getIndReg135
  1511 00007754 E8D512                   call indexerror
  1512                                  
  1513                                  ;-92     if (R2No==3) rm=7;//BX
  1514                                  
  1515                                  @@getIndReg135:
  1516 00007757 A0[3502]                 mov al, [R2No]
  1517 0000775A 3C03                     cmp al, 3
  1518 0000775C 0F850900                 jne @@getIndReg136
  1519 00007760 66B807000000             mov eax, 7
  1520 00007766 A2[3D02]                 mov byte [rm], al
  1521                                  
  1522                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1523                                  
  1524                                  @@getIndReg136:
  1525 00007769 A0[3502]                 mov al, [R2No]
  1526 0000776C 3C05                     cmp al, 5
  1527 0000776E 0F850900                 jne @@getIndReg137
  1528 00007772 66B806000000             mov eax, 6
  1529 00007778 A2[3D02]                 mov byte [rm], al
  1530                                  
  1531                                  ;-94     if (R2No==7) rm=5;//DI
  1532                                  
  1533                                  @@getIndReg137:
  1534 0000777B A0[3502]                 mov al, [R2No]
  1535 0000777E 3C07                     cmp al, 7
  1536 00007780 0F850900                 jne @@getIndReg138
  1537 00007784 66B805000000             mov eax, 5
  1538 0000778A A2[3D02]                 mov byte [rm], al
  1539                                  
  1540                                  ;-95     if (R2No==6) rm=4;//SI
  1541                                  
  1542                                  @@getIndReg138:
  1543 0000778D A0[3502]                 mov al, [R2No]
  1544 00007790 3C06                     cmp al, 6
  1545 00007792 0F850900                 jne @@getIndReg139
  1546 00007796 66B804000000             mov eax, 4
  1547 0000779C A2[3D02]                 mov byte [rm], al
  1548                                  
  1549                                  ;-96     if (rm==0) indexerror();
  1550                                  
  1551                                  @@getIndReg139:
  1552 0000779F A0[3D02]                 mov al, [rm]
  1553 000077A2 3C00                     cmp al, 0
  1554 000077A4 0F850300                 jne @@getIndReg140
  1555 000077A8 E88112                   call indexerror
  1556                                  
  1557                                  ;-97 }
  1558                                  
  1559                                  @@getIndReg140:
  1560                                  
  1561                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1562                                  
  1563 000077AB C3                       ret
  1564                                  ; ENDP
  1565                                  
  1566                                  getIndReg2:  ; *** PROC ***
  1567                                  ;Function : getIndReg2, Number of local variables: 1
  1568                                  ;   # type sign width line used address name   list of local variables
  1569                                  ;  200 var sign byte    98 NULL bp-2    m;
  1570 000077AC C8020000                 ENTER  2,0
  1571 000077B0 66B804000000             mov eax, 4
  1572 000077B6 8846FE                   mov byte [bp-2], al
  1573                                  
  1574                                  ;-99     if (R2Type !=WORD) indexerror();
  1575                                  
  1576 000077B9 A0[3702]                 mov al, [R2Type]
  1577 000077BC 3C02                     cmp al, 2
  1578 000077BE 0F840300                 je  @@getIndReg241
  1579 000077C2 E86712                   call indexerror
  1580                                  
  1581                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1582                                  
  1583                                  @@getIndReg241:
  1584 000077C5 A0[3502]                 mov al, [R2No]
  1585 000077C8 3C07                     cmp al, 7
  1586 000077CA 0F852700                 jne @@getIndReg242
  1587 000077CE A0[3D02]                 mov al, [rm]
  1588 000077D1 3C06                     cmp al, 6
  1589 000077D3 0F850C00                 jne @@getIndReg243
  1590 000077D7 66B803000000             mov eax, 3
  1591 000077DD 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-101              else if (rm==7) m=1;//BX+DI
  1594                                  
  1595 000077E0 E91200                   jmp @@getIndReg244
  1596                                  @@getIndReg243:
  1597 000077E3 A0[3D02]                 mov al, [rm]
  1598 000077E6 3C07                     cmp al, 7
  1599 000077E8 0F850900                 jne @@getIndReg245
  1600 000077EC 66B801000000             mov eax, 1
  1601 000077F2 8846FE                   mov byte [bp-2], al
  1602                                  
  1603                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1604                                  
  1605                                  @@getIndReg245:
  1606                                  @@getIndReg244:
  1607                                  @@getIndReg242:
  1608 000077F5 A0[3502]                 mov al, [R2No]
  1609 000077F8 3C06                     cmp al, 6
  1610 000077FA 0F852700                 jne @@getIndReg246
  1611 000077FE A0[3D02]                 mov al, [rm]
  1612 00007801 3C06                     cmp al, 6
  1613 00007803 0F850C00                 jne @@getIndReg247
  1614 00007807 66B802000000             mov eax, 2
  1615 0000780D 8846FE                   mov byte [bp-2], al
  1616                                  
  1617                                  ;-103              else if (rm==7) m=0;//BX+SI
  1618                                  
  1619 00007810 E91200                   jmp @@getIndReg248
  1620                                  @@getIndReg247:
  1621 00007813 A0[3D02]                 mov al, [rm]
  1622 00007816 3C07                     cmp al, 7
  1623 00007818 0F850900                 jne @@getIndReg249
  1624 0000781C 66B800000000             mov eax, 0
  1625 00007822 8846FE                   mov byte [bp-2], al
  1626                                  
  1627                                  ;-104     if (m > 3) indexerror();
  1628                                  
  1629                                  @@getIndReg249:
  1630                                  @@getIndReg248:
  1631                                  @@getIndReg246:
  1632 00007825 8A46FE                   mov al, [bp-2]
  1633 00007828 3C03                     cmp al, 3
  1634 0000782A 0F8E0300                 jle @@getIndReg250
  1635 0000782E E8FB11                   call indexerror
  1636                                  
  1637                                  ;-105     return m;
  1638                                  
  1639                                  @@getIndReg250:
  1640 00007831 8A46FE                   mov al, [bp-2]
  1641 00007834 E90000                   jmp @@retn
  1642                                  
  1643                                  ;-106 }
  1644                                  
  1645                                  
  1646                                  ;-107                   
  1647                                  
  1648                                  
  1649                                  ;-108 int setwflag() {//word size, bit 0
  1650                                  
  1651 00007837 C9                      @@retn: LEAVE
  1652 00007838 C3                       ret
  1653                                  ; ENDP
  1654                                  
  1655                                  setwflag:  ; *** PROC ***
  1656                                  
  1657                                  ;-109     wflag=0;
  1658                                  
  1659 00007839 66B800000000             mov eax, 0
  1660 0000783F A2[3A02]                 mov byte [wflag], al
  1661                                  
  1662                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1663                                  
  1664 00007842 A0[3902]                 mov al, [OpSize]
  1665 00007845 3C00                     cmp al, 0
  1666 00007847 0F854200                 jne @@setwflag51
  1667                                  
  1668                                  ;-111         if (Op == REG) OpSize=R1Type;
  1669                                  
  1670 0000784B A0[2F02]                 mov al, [Op]
  1671 0000784E 3C02                     cmp al, 2
  1672 00007850 0F850600                 jne @@setwflag52
  1673 00007854 A0[3802]                 mov al, [R1Type]
  1674 00007857 A2[3902]                 mov byte [OpSize], al
  1675                                  
  1676                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1677                                  
  1678                                  @@setwflag52:
  1679 0000785A A0[3002]                 mov al, [Op2]
  1680 0000785D 3C02                     cmp al, 2
  1681 0000785F 0F850600                 jne @@setwflag53
  1682 00007863 A0[3702]                 mov al, [R2Type]
  1683 00007866 A2[3902]                 mov byte [OpSize], al
  1684                                  
  1685                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1686                                  
  1687                                  @@setwflag53:
  1688 00007869 A0[3702]                 mov al, [R2Type]
  1689 0000786C 3C04                     cmp al, 4
  1690 0000786E 0F850900                 jne @@setwflag54
  1691 00007872 66B802000000             mov eax, 2
  1692 00007878 A2[3902]                 mov byte [OpSize], al
  1693                                  
  1694                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1695                                  
  1696                                  @@setwflag54:
  1697 0000787B A0[3802]                 mov al, [R1Type]
  1698 0000787E 3C04                     cmp al, 4
  1699 00007880 0F850900                 jne @@setwflag55
  1700 00007884 66B802000000             mov eax, 2
  1701 0000788A A2[3902]                 mov byte [OpSize], al
  1702                                  
  1703                                  ;-115     }
  1704                                  
  1705                                  @@setwflag55:
  1706                                  
  1707                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1708                                  
  1709                                  @@setwflag51:
  1710 0000788D A0[3902]                 mov al, [OpSize]
  1711 00007890 3C03                     cmp al, 3
  1712 00007892 0F850C00                 jne @@setwflag56
  1713 00007896 E88917                   call gen66h
  1714 00007899 66B801000000             mov eax, 1
  1715 0000789F A2[3A02]                 mov byte [wflag], al
  1716                                  
  1717                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1718                                  
  1719                                  @@setwflag56:
  1720 000078A2 A0[3902]                 mov al, [OpSize]
  1721 000078A5 3C02                     cmp al, 2
  1722 000078A7 0F850900                 jne @@setwflag57
  1723 000078AB 66B801000000             mov eax, 1
  1724 000078B1 A2[3A02]                 mov byte [wflag], al
  1725                                  
  1726                                  ;-118 }
  1727                                  
  1728                                  @@setwflag57:
  1729                                  
  1730                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1731                                  
  1732 000078B4 C3                       ret
  1733                                  ; ENDP
  1734                                  
  1735                                  setsflag:  ; *** PROC ***
  1736                                  
  1737                                  ;-120     unsigned int ui;    
  1738                                  
  1739                                  
  1740                                  ;-121     sflag=2;   
  1741                                  
  1742                                  ;Function : setsflag, Number of local variables: 1
  1743                                  ;   # type sign width line used address name   list of local variables
  1744                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1745 000078B5 C8020000                 ENTER  2,0
  1746 000078B9 66B802000000             mov eax, 2
  1747 000078BF A2[3C02]                 mov byte [sflag], al
  1748                                  
  1749                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1750                                  
  1751 000078C2 A1[4102]                 mov ax, [imme]
  1752 000078C5 2580FF                   and ax, 65408
  1753 000078C8 8946FE                   mov word [bp-2], ax
  1754                                  
  1755                                  ;-123     if(ui != 0) sflag = 0;
  1756                                  
  1757 000078CB 8B46FE                   mov ax, [bp-2]
  1758 000078CE 83F800                   cmp ax, 0
  1759 000078D1 0F840900                 je  @@setsflag58
  1760 000078D5 66B800000000             mov eax, 0
  1761 000078DB A2[3C02]                 mov byte [sflag], al
  1762                                  
  1763                                  ;-124     if (OpSize == BYTE) {
  1764                                  
  1765                                  @@setsflag58:
  1766 000078DE A0[3902]                 mov al, [OpSize]
  1767 000078E1 3C01                     cmp al, 1
  1768 000078E3 0F851C00                 jne @@setsflag59
  1769                                  
  1770                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1771                                  
  1772 000078E7 A1[4102]                 mov ax, [imme]
  1773 000078EA 3DFF00                   cmp ax, 255
  1774 000078ED 0F8E0900                 jle @@setsflag60
  1775 000078F1 68[0579]                 push setsflag_0
  1776 000078F4 E84B10                   call error1
  1777 000078F7 83C402                   add  sp, 2
  1778                                  
  1779                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1780                                  
  1781                                  @@setsflag60:
  1782 000078FA 66B800000000             mov eax, 0
  1783 00007900 A2[3C02]                 mov byte [sflag], al
  1784                                  
  1785                                  ;-127     }
  1786                                  
  1787                                  
  1788                                  ;-128 }
  1789                                  
  1790                                  @@setsflag59:
  1791                                  
  1792                                  ;-129 int checkConstSize(unsigned int ui) {    
  1793 00007903 C9                       LEAVE
  1794 00007904 C3                       ret
  1795                                  ; ENDP
  1796 00007905 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1797 0000790E 6F7220627974652072-
  1798 00007917 2F6D00             
  1799                                  
  1800                                  checkConstSize:  ; *** PROC ***
  1801                                  
  1802                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1803                                  
  1804                                  ;Function : checkConstSize, Number of local variables: 1
  1805                                  ;   # type sign width line used address name   list of local variables
  1806                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1807 0000791A C8000000                 ENTER  0,0
  1808 0000791E 8B4604                   mov ax, [bp+4]
  1809 00007921 83F87F                   cmp ax, 127
  1810 00007924 0F8E0900                 jle @@checkConstSize61
  1811 00007928 66B800000000             mov eax, 0
  1812 0000792E E91C00                   jmp @@retn
  1813                                  
  1814                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1815                                  
  1816                                  @@checkConstSize61:
  1817 00007931 8B4604                   mov ax, [bp+4]
  1818 00007934 3D80FF                   cmp ax, 65408
  1819 00007937 0F8D0900                 jge @@checkConstSize62
  1820 0000793B 66B800000000             mov eax, 0
  1821 00007941 E90900                   jmp @@retn
  1822                                  
  1823                                  ;-132     return 2;// is short        
  1824                                  
  1825                                  @@checkConstSize62:
  1826 00007944 66B802000000             mov eax, 2
  1827 0000794A E90000                   jmp @@retn
  1828                                  
  1829                                  ;-133 }
  1830                                  
  1831 0000794D C9                      @@retn: LEAVE
  1832 0000794E C3                       ret
  1833                                  ; ENDP
  1834                                  ;Back to main program: AS.C
  1835                                  
  1836                                  ;-5 #include "PARSE.C"
  1837                                  
  1838                                  ;Use include file: PARSE.C
  1839                                  
  1840                                  ;-1 int parse() {
  1841                                  
  1842                                  
  1843                                  parse:  ; *** PROC ***
  1844                                  
  1845                                  ;-2     LabelNamePtr  = &LabelNames;    
  1846                                  
  1847 0000794F B8[4D02]                 mov ax, LabelNames
  1848 00007952 A3[ED11]                 mov word [LabelNamePtr], ax
  1849                                  
  1850                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1851                                  
  1852 00007955 B8[A316]                 mov ax, JmpCallNames
  1853 00007958 A3[731E]                 mov word [JmpCallNamePtr], ax
  1854                                  
  1855                                  ;-4     LabelMaxIx=0;    
  1856                                  
  1857 0000795B 66B800000000             mov eax, 0
  1858 00007961 A3[9F16]                 mov word [LabelMaxIx], ax
  1859                                  
  1860                                  ;-5     JmpCallMaxIx=0;  
  1861                                  
  1862 00007964 66B800000000             mov eax, 0
  1863 0000796A A3[5D22]                 mov word [JmpCallMaxIx], ax
  1864                                  
  1865                                  ;-6     BinLen=0;
  1866                                  
  1867 0000796D 66B800000000             mov eax, 0
  1868 00007973 A3[7F70]                 mov word [BinLen], ax
  1869                                  
  1870                                  ;-7     
  1871                                  
  1872                                  
  1873                                  ;-8     do {//process a new line
  1874                                  
  1875                                  @@parse63:
  1876                                  
  1877                                  ;-9         PCStart=PC; 
  1878                                  
  1879 00007976 A1[2502]                 mov ax, [PC]
  1880 00007979 A3[2B02]                 mov word [PCStart], ax
  1881                                  
  1882                                  ;-10         OpSize=0;
  1883                                  
  1884 0000797C 66B800000000             mov eax, 0
  1885 00007982 A2[3902]                 mov byte [OpSize], al
  1886                                  
  1887                                  ;-11         OpPrintIndex=0; 
  1888                                  
  1889 00007985 66B800000000             mov eax, 0
  1890 0000798B A3[4802]                 mov word [OpPrintIndex], ax
  1891                                  
  1892                                  ;-12         PrintRA=' ';
  1893                                  
  1894 0000798E 66B820000000             mov eax, 32
  1895 00007994 A2[4C02]                 mov byte [PrintRA], al
  1896                                  
  1897                                  ;-13         getLine();
  1898                                  
  1899 00007997 E8E705                   call getLine
  1900                                  
  1901                                  ;-14         InputPtr = &InputBuf;
  1902                                  
  1903 0000799A B8[4E00]                 mov ax, InputBuf
  1904 0000799D A3[4D01]                 mov word [InputPtr], ax
  1905                                  
  1906                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1907                                  
  1908 000079A0 E8B800                   call getTokeType
  1909                                  
  1910                                  ;-16         if (TokeType == ALNUME) {
  1911                                  
  1912 000079A3 A0[2E02]                 mov al, [TokeType]
  1913 000079A6 3C03                     cmp al, 3
  1914 000079A8 0F851300                 jne @@parse64
  1915                                  
  1916                                  ;-17             if (isLabel) {//set in getName
  1917                                  
  1918 000079AC A0[2D02]                 mov al, [isLabel]
  1919 000079AF 08C0                     or  al, al
  1920 000079B1 0F840A00                 je @@parse65
  1921                                  
  1922                                  ;-18                 storeLabel();
  1923                                  
  1924 000079B5 E8C301                   call storeLabel
  1925                                  
  1926                                  ;-19                 InputPtr++;//remove :
  1927                                  
  1928 000079B8 FF06[4D01]               inc  word [InputPtr]
  1929                                  
  1930                                  ;-20                 getTokeType();
  1931                                  
  1932 000079BC E89C00                   call getTokeType
  1933                                  
  1934                                  ;-21             }
  1935                                  
  1936                                  
  1937                                  ;-22         }
  1938                                  
  1939                                  @@parse65:
  1940                                  
  1941                                  ;-23         if (TokeType == ALNUME) {
  1942                                  
  1943                                  @@parse64:
  1944 000079BF A0[2E02]                 mov al, [TokeType]
  1945 000079C2 3C03                     cmp al, 3
  1946 000079C4 0F851B00                 jne @@parse66
  1947                                  
  1948                                  ;-24             lookCode();// and OpCodePtr
  1949                                  
  1950 000079C8 E82304                   call lookCode
  1951                                  
  1952                                  ;-25             if(CodeType) process();
  1953                                  
  1954 000079CB A0[3102]                 mov al, [CodeType]
  1955 000079CE 08C0                     or  al, al
  1956 000079D0 0F840600                 je @@parse67
  1957 000079D4 E83918                   call process
  1958                                  
  1959                                  ;-26             else getVariable();
  1960                                  
  1961 000079D7 E90300                   jmp @@parse68
  1962                                  @@parse67:
  1963 000079DA E89F02                   call getVariable
  1964                                  
  1965                                  ;-27             skipRest();
  1966                                  
  1967                                  @@parse68:
  1968 000079DD E87805                   call skipRest
  1969                                  
  1970                                  ;-28         }
  1971                                  
  1972                                  
  1973                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1974                                  
  1975 000079E0 E92700                   jmp @@parse69
  1976                                  @@parse66:
  1977 000079E3 A0[2E02]                 mov al, [TokeType]
  1978 000079E6 3C03                     cmp al, 3
  1979 000079E8 0F8E0C00                 jle @@parse70
  1980 000079EC 68[1B7A]                 push parse_0
  1981 000079EF E8500F                   call error1
  1982 000079F2 83C402                   add  sp, 2
  1983                                  
  1984                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1985                                  
  1986 000079F5 E91200                   jmp @@parse71
  1987                                  @@parse70:
  1988 000079F8 A0[2E02]                 mov al, [TokeType]
  1989 000079FB 3C01                     cmp al, 1
  1990 000079FD 0F850900                 jne @@parse72
  1991 00007A01 68[397A]                 push parse_1
  1992 00007A04 E83B0F                   call error1
  1993 00007A07 83C402                   add  sp, 2
  1994                                  
  1995                                  ;-31         printLine();
  1996                                  
  1997                                  @@parse72:
  1998                                  @@parse71:
  1999                                  @@parse69:
  2000 00007A0A E8C70C                   call printLine
  2001                                  
  2002                                  ;-32     } while (DOS_NoBytes != 0 );
  2003                                  
  2004 00007A0D A1[2202]                 mov ax, [DOS_NoBytes]
  2005 00007A10 83F800                   cmp ax, 0
  2006 00007A13 0F840300                 je  @@parse73
  2007 00007A17 E95CFF                   jmp @@parse63
  2008                                  @@parse73:
  2009                                  
  2010                                  ;-33 }
  2011                                  
  2012                                  
  2013                                  ;-34 
  2014                                  
  2015                                  
  2016                                  ;-35 int getTokeType() { 
  2017                                  
  2018 00007A1A C3                       ret
  2019                                  ; ENDP
  2020 00007A1B 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2021 00007A24 696E73747275637469-
  2022 00007A2D 6F6E20657870656374-
  2023 00007A36 656400             
  2024 00007A39 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2025 00007A42 616C6C6F7765642061-
  2026 00007A4B 74207374617274206F-
  2027 00007A54 66206C696E6500     
  2028                                  
  2029                                  getTokeType:  ; *** PROC ***
  2030                                  
  2031                                  ;-36     char c;
  2032                                  
  2033                                  
  2034                                  ;-37     skipBlank();
  2035                                  
  2036                                  ;Function : getTokeType, Number of local variables: 1
  2037                                  ;   # type sign width line used address name   list of local variables
  2038                                  ;  200 var sign byte    36 NULL bp-2    c;
  2039 00007A5B C8020000                 ENTER  2,0
  2040 00007A5F E82106                   call skipBlank
  2041                                  
  2042                                  ;-38     c = *InputPtr;
  2043                                  
  2044 00007A62 8B1E[4D01]               mov bx, [InputPtr]
  2045 00007A66 8A07                     mov al, [bx]
  2046 00007A68 B400                     mov ah, 0
  2047 00007A6A 8846FE                   mov byte [bp-2], al
  2048                                  
  2049                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2050                                  
  2051 00007A6D 8A46FE                   mov al, [bp-2]
  2052 00007A70 3C00                     cmp al, 0
  2053 00007A72 0F850C00                 jne @@getTokeType74
  2054 00007A76 66B800000000             mov eax, 0
  2055 00007A7C A2[2E02]                 mov byte [TokeType], al
  2056 00007A7F E97200                   jmp @@retn
  2057                                  
  2058                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2059                                  
  2060                                  @@getTokeType74:
  2061 00007A82 8A46FE                   mov al, [bp-2]
  2062 00007A85 3C3B                     cmp al, 59
  2063 00007A87 0F850C00                 jne @@getTokeType75
  2064 00007A8B 66B800000000             mov eax, 0
  2065 00007A91 A2[2E02]                 mov byte [TokeType], al
  2066 00007A94 E95D00                   jmp @@retn
  2067                                  
  2068                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2069                                  
  2070                                  @@getTokeType75:
  2071 00007A97 8A46FE                   mov al, byte [bp-2]
  2072 00007A9A B400                     mov ah, 0
  2073 00007A9C 50                       push ax
  2074 00007A9D E89820                   call digit
  2075 00007AA0 83C402                   add  sp, 2
  2076 00007AA3 08C0                     or  al, al
  2077 00007AA5 0F841800                 je @@getTokeType76
  2078 00007AA9 8A46FE                   mov al, byte [bp-2]
  2079 00007AAC B400                     mov ah, 0
  2080 00007AAE 50                       push ax
  2081 00007AAF E8D706                   call getDigit
  2082 00007AB2 83C402                   add  sp, 2
  2083 00007AB5 66B801000000             mov eax, 1
  2084 00007ABB A2[2E02]                 mov byte [TokeType], al
  2085 00007ABE E93300                   jmp @@retn
  2086                                  
  2087                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2088                                  
  2089                                  @@getTokeType76:
  2090 00007AC1 8A46FE                   mov al, byte [bp-2]
  2091 00007AC4 B400                     mov ah, 0
  2092 00007AC6 50                       push ax
  2093 00007AC7 E8E405                   call letterE
  2094 00007ACA 83C402                   add  sp, 2
  2095 00007ACD 08C0                     or  al, al
  2096 00007ACF 0F841800                 je @@getTokeType77
  2097 00007AD3 8A46FE                   mov al, byte [bp-2]
  2098 00007AD6 B400                     mov ah, 0
  2099 00007AD8 50                       push ax
  2100 00007AD9 E80407                   call getName
  2101 00007ADC 83C402                   add  sp, 2
  2102 00007ADF 66B803000000             mov eax, 3
  2103 00007AE5 A2[2E02]                 mov byte [TokeType], al
  2104 00007AE8 E90900                   jmp @@retn
  2105                                  
  2106                                  ;-43     TokeType=NOALNUME;
  2107                                  
  2108                                  @@getTokeType77:
  2109 00007AEB 66B804000000             mov eax, 4
  2110 00007AF1 A2[2E02]                 mov byte [TokeType], al
  2111                                  
  2112                                  ;-44 }                     
  2113                                  
  2114                                  
  2115                                  ;-45 
  2116                                  
  2117                                  
  2118                                  ;-46 int storeJmpCall() {
  2119                                  
  2120 00007AF4 C9                      @@retn: LEAVE
  2121 00007AF5 C3                       ret
  2122                                  ; ENDP
  2123                                  
  2124                                  storeJmpCall:  ; *** PROC ***
  2125                                  
  2126                                  ;-47     unsigned int i;
  2127                                  
  2128                                  
  2129                                  ;-48     JmpCallMaxIx++;
  2130                                  
  2131                                  ;Function : storeJmpCall, Number of local variables: 1
  2132                                  ;   # type sign width line used address name   list of local variables
  2133                                  ;  200 var unsg word    47 NULL bp-2    i;
  2134 00007AF6 C8020000                 ENTER  2,0
  2135 00007AFA FF06[5D22]               inc  word [JmpCallMaxIx]
  2136                                  
  2137                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2138                                  
  2139 00007AFE A1[5D22]                 mov ax, [JmpCallMaxIx]
  2140 00007B01 3DF401                   cmp ax, 500 ;unsigned : 1
  2141 00007B04 0F8C0900                 jl  @@storeJmpCall78
  2142 00007B08 68[527B]                 push storeJmpCall_0
  2143 00007B0B E8930E                   call errorexit
  2144 00007B0E 83C402                   add  sp, 2
  2145                                  
  2146                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2147                                  
  2148                                  @@storeJmpCall78:
  2149 00007B11 8D06[0E00]               lea  ax, [Symbol]
  2150 00007B15 50                       push ax
  2151 00007B16 FF36[731E]               push word [JmpCallNamePtr]
  2152 00007B1A E8E21F                   call strcpy
  2153 00007B1D 83C404                   add  sp, 4
  2154 00007B20 A3[731E]                 mov word [JmpCallNamePtr], ax
  2155                                  
  2156                                  ;-51     JmpCallNamePtr++;
  2157                                  
  2158 00007B23 FF06[731E]               inc  word [JmpCallNamePtr]
  2159                                  
  2160                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2161                                  
  2162 00007B27 A1[731E]                 mov ax, [JmpCallNamePtr]
  2163 00007B2A 2D[A316]                 sub ax, JmpCallNames
  2164 00007B2D 8946FE                   mov word [bp-2], ax
  2165                                  
  2166                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2167                                  
  2168 00007B30 8B46FE                   mov ax, [bp-2]
  2169 00007B33 3DB107                   cmp ax, 1969 ;unsigned : 0
  2170 00007B36 0F820900                 jb  @@storeJmpCall79
  2171 00007B3A 68[647B]                 push storeJmpCall_1
  2172 00007B3D E8610E                   call errorexit
  2173 00007B40 83C402                   add  sp, 2
  2174                                  
  2175                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2176                                  
  2177                                  @@storeJmpCall79:
  2178 00007B43 A1[2502]                 mov ax, [PC]
  2179 00007B46 8B1E[5D22]               mov bx, [JmpCallMaxIx]
  2180 00007B4A D1E3                     shl bx, 1
  2181 00007B4C 8987[751E]               mov [JmpCallAddr+bx], ax
  2182                                  
  2183                                  ;-55 }
  2184                                  
  2185                                  
  2186                                  ;-56 
  2187                                  
  2188                                  
  2189                                  ;-57 int storeLabel() {
  2190 00007B50 C9                       LEAVE
  2191 00007B51 C3                       ret
  2192                                  ; ENDP
  2193 00007B52 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2194 00007B5B 4A6D7043616C6C7300 
  2195 00007B64 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2196 00007B6D 4A6D7043616C6C206E-
  2197 00007B76 616D657300         
  2198                                  
  2199                                  storeLabel:  ; *** PROC ***
  2200                                  
  2201                                  ;-58     unsigned int i;
  2202                                  
  2203                                  
  2204                                  ;-59     LabelMaxIx++;
  2205                                  
  2206                                  ;Function : storeLabel, Number of local variables: 1
  2207                                  ;   # type sign width line used address name   list of local variables
  2208                                  ;  200 var unsg word    58 NULL bp-2    i;
  2209 00007B7B C8020000                 ENTER  2,0
  2210 00007B7F FF06[9F16]               inc  word [LabelMaxIx]
  2211                                  
  2212                                  ;-60     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2213                                  
  2214 00007B83 A1[9F16]                 mov ax, [LabelMaxIx]
  2215 00007B86 3D5802                   cmp ax, 600 ;unsigned : 1
  2216 00007B89 0F8C0900                 jl  @@storeLabel80
  2217 00007B8D 68[ED7B]                 push storeLabel_0
  2218 00007B90 E80E0E                   call errorexit
  2219 00007B93 83C402                   add  sp, 2
  2220                                  
  2221                                  ;-61     if(searchLabel()) error1("duplicate label");
  2222                                  
  2223                                  @@storeLabel80:
  2224 00007B96 E88900                   call searchLabel
  2225 00007B99 08C0                     or  al, al
  2226 00007B9B 0F840900                 je @@storeLabel81
  2227 00007B9F 68[FD7B]                 push storeLabel_1
  2228 00007BA2 E89D0D                   call error1
  2229 00007BA5 83C402                   add  sp, 2
  2230                                  
  2231                                  ;-62     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2232                                  
  2233                                  @@storeLabel81:
  2234 00007BA8 8D06[0E00]               lea  ax, [Symbol]
  2235 00007BAC 50                       push ax
  2236 00007BAD FF36[ED11]               push word [LabelNamePtr]
  2237 00007BB1 E84B1F                   call strcpy
  2238 00007BB4 83C404                   add  sp, 4
  2239 00007BB7 A3[ED11]                 mov word [LabelNamePtr], ax
  2240                                  
  2241                                  ;-63     LabelNamePtr++;
  2242                                  
  2243 00007BBA FF06[ED11]               inc  word [LabelNamePtr]
  2244                                  
  2245                                  ;-64     i = LabelNamePtr - &LabelNames;
  2246                                  
  2247 00007BBE A1[ED11]                 mov ax, [LabelNamePtr]
  2248 00007BC1 2D[4D02]                 sub ax, LabelNames
  2249 00007BC4 8946FE                   mov word [bp-2], ax
  2250                                  
  2251                                  ;-65     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2252                                  
  2253 00007BC7 8B46FE                   mov ax, [bp-2]
  2254 00007BCA 3D810F                   cmp ax, 3969 ;unsigned : 0
  2255 00007BCD 0F820900                 jb  @@storeLabel82
  2256 00007BD1 68[0D7C]                 push storeLabel_2
  2257 00007BD4 E8CA0D                   call errorexit
  2258 00007BD7 83C402                   add  sp, 2
  2259                                  
  2260                                  ;-66     LabelAddr[LabelMaxIx] = PC + Origin;
  2261                                  
  2262                                  @@storeLabel82:
  2263 00007BDA A1[2502]                 mov ax, [PC]
  2264 00007BDD 0306[2702]               add ax, [Origin]
  2265 00007BE1 8B1E[9F16]               mov bx, [LabelMaxIx]
  2266 00007BE5 D1E3                     shl bx, 1
  2267 00007BE7 8987[EF11]               mov [LabelAddr+bx], ax
  2268                                  
  2269                                  ;-67 }   
  2270                                  
  2271                                  
  2272                                  ;-68 
  2273                                  
  2274                                  
  2275                                  ;-69 int searchLabel() {
  2276 00007BEB C9                       LEAVE
  2277 00007BEC C3                       ret
  2278                                  ; ENDP
  2279 00007BED 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2280 00007BF6 6C6162656C7300     
  2281 00007BFD 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2282 00007C06 206C6162656C00     
  2283 00007C0D 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2284 00007C16 6C6162656C206E616D-
  2285 00007C1F 657300             
  2286                                  
  2287                                  searchLabel:  ; *** PROC ***
  2288                                  
  2289                                  ;-70     int LIx; char *p;
  2290                                  
  2291                                  
  2292                                  ;-71     p = &LabelNames;
  2293                                  
  2294                                  ;Function : searchLabel, Number of local variables: 2
  2295                                  ;   # type sign width line used address name   list of local variables
  2296                                  ;  200 var sign word    70 NULL bp-2    LIx
  2297                                  ;  201 ptr sign byte    70 NULL bp-4    p;
  2298 00007C22 C8040000                 ENTER  4,0
  2299 00007C26 B8[4D02]                 mov ax, LabelNames
  2300 00007C29 8946FC                   mov word [bp-4], ax
  2301                                  
  2302                                  ;-72     LIx = 1;
  2303                                  
  2304 00007C2C 66B801000000             mov eax, 1
  2305 00007C32 8946FE                   mov word [bp-2], ax
  2306                                  
  2307                                  ;-73     while (LIx <= LabelMaxIx) {
  2308                                  
  2309                                  @@searchLabel83:
  2310 00007C35 8B46FE                   mov ax, [bp-2]
  2311 00007C38 3B06[9F16]               cmp ax, [LabelMaxIx]
  2312 00007C3C 0F8F3100                 jg  @@searchLabel84
  2313                                  
  2314                                  ;-74         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2315                                  
  2316 00007C40 8D06[0E00]               lea  ax, [Symbol]
  2317 00007C44 50                       push ax
  2318 00007C45 FF76FC                   push word [bp-4]
  2319 00007C48 E8201F                   call eqstr
  2320 00007C4B 83C404                   add  sp, 4
  2321 00007C4E 08C0                     or  al, al
  2322 00007C50 0F840600                 je @@searchLabel85
  2323 00007C54 8B46FE                   mov ax, [bp-2]
  2324 00007C57 E92000                   jmp @@retn
  2325                                  
  2326                                  ;-75         p=strlen(p) + p;                  
  2327                                  
  2328                                  @@searchLabel85:
  2329 00007C5A FF76FC                   push word [bp-4]
  2330 00007C5D E8741E                   call strlen
  2331 00007C60 83C402                   add  sp, 2
  2332 00007C63 0346FC                   add ax, [bp-4]
  2333 00007C66 8946FC                   mov word [bp-4], ax
  2334                                  
  2335                                  ;-76         p++; 
  2336                                  
  2337 00007C69 FF46FC                   inc  word [bp-4]
  2338                                  
  2339                                  ;-77         LIx++;
  2340                                  
  2341 00007C6C FF46FE                   inc  word [bp-2]
  2342                                  
  2343                                  ;-78     }
  2344                                  
  2345                                  
  2346                                  ;-79     return 0;
  2347                                  
  2348 00007C6F EBC4                     jmp @@searchLabel83
  2349                                  @@searchLabel84:
  2350 00007C71 66B800000000             mov eax, 0
  2351 00007C77 E90000                   jmp @@retn
  2352                                  
  2353                                  ;-80 }   
  2354                                  
  2355                                  
  2356                                  ;-81 
  2357                                  
  2358                                  
  2359                                  ;-82 int getVariable() { 
  2360                                  
  2361 00007C7A C9                      @@retn: LEAVE
  2362 00007C7B C3                       ret
  2363                                  ; ENDP
  2364                                  
  2365                                  getVariable:  ; *** PROC ***
  2366                                  
  2367                                  ;-83     char c; 
  2368                                  
  2369                                  
  2370                                  ;-84     storeLabel();
  2371                                  
  2372                                  ;Function : getVariable, Number of local variables: 1
  2373                                  ;   # type sign width line used address name   list of local variables
  2374                                  ;  200 var sign byte    83 NULL bp-2    c;
  2375 00007C7C C8020000                 ENTER  2,0
  2376 00007C80 E8F8FE                   call storeLabel
  2377                                  
  2378                                  ;-85     getTokeType(); 
  2379                                  
  2380 00007C83 E8D5FD                   call getTokeType
  2381                                  
  2382                                  ;-86     if(TokeType==ALNUME) {//getName
  2383                                  
  2384 00007C86 A0[2E02]                 mov al, [TokeType]
  2385 00007C89 3C03                     cmp al, 3
  2386 00007C8B 0F854901                 jne @@getVariable86
  2387                                  
  2388                                  ;-87         lookCode();
  2389                                  
  2390 00007C8F E85C01                   call lookCode
  2391                                  
  2392                                  ;-88         if (CodeType < 200) dataexit();
  2393                                  
  2394 00007C92 A0[3102]                 mov al, [CodeType]
  2395 00007C95 3CC8                     cmp al, 200
  2396 00007C97 0F8D0300                 jge @@getVariable87
  2397 00007C9B E88E0E                   call dataexit
  2398                                  
  2399                                  ;-89         if (CodeType > 205) dataexit();
  2400                                  
  2401                                  @@getVariable87:
  2402 00007C9E A0[3102]                 mov al, [CodeType]
  2403 00007CA1 3CCD                     cmp al, 205
  2404 00007CA3 0F8E0300                 jle @@getVariable88
  2405 00007CA7 E8820E                   call dataexit
  2406                                  
  2407                                  ;-90         if (CodeType== 200) {//DB
  2408                                  
  2409                                  @@getVariable88:
  2410 00007CAA A0[3102]                 mov al, [CodeType]
  2411 00007CAD 3CC8                     cmp al, 200
  2412 00007CAF 0F856A00                 jne @@getVariable89
  2413                                  
  2414                                  ;-91             do { 
  2415                                  
  2416                                  @@getVariable90:
  2417                                  
  2418                                  ;-92                 getTokeType();
  2419                                  
  2420 00007CB3 E8A5FD                   call getTokeType
  2421                                  
  2422                                  ;-93                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2423                                  
  2424 00007CB6 A0[2E02]                 mov al, [TokeType]
  2425 00007CB9 3C01                     cmp al, 1
  2426 00007CBB 0F850D00                 jne @@getVariable91
  2427 00007CBF FF36[4C00]               push word [SymbolInt]
  2428 00007CC3 E89C13                   call genCode8
  2429 00007CC6 83C402                   add  sp, 2
  2430                                  
  2431                                  ;-94                 else {
  2432                                  
  2433 00007CC9 E94100                   jmp @@getVariable92
  2434                                  @@getVariable91:
  2435                                  
  2436                                  ;-95                     skipBlank();
  2437                                  
  2438 00007CCC E8B403                   call skipBlank
  2439                                  
  2440                                  ;-96                     if (isToken('"')) {
  2441                                  
  2442 00007CCF 6A22                     push 34
  2443 00007CD1 E81702                   call isToken
  2444 00007CD4 83C402                   add  sp, 2
  2445 00007CD7 08C0                     or  al, al
  2446 00007CD9 0F843000                 je @@getVariable93
  2447                                  
  2448                                  ;-97                         do { 
  2449                                  
  2450                                  @@getVariable94:
  2451                                  
  2452                                  ;-98                             c= *InputPtr;
  2453                                  
  2454 00007CDD 8B1E[4D01]               mov bx, [InputPtr]
  2455 00007CE1 8A07                     mov al, [bx]
  2456 00007CE3 B400                     mov ah, 0
  2457 00007CE5 8846FE                   mov byte [bp-2], al
  2458                                  
  2459                                  ;-99                             genCode8(c);
  2460                                  
  2461 00007CE8 8A46FE                   mov al, byte [bp-2]
  2462 00007CEB B400                     mov ah, 0
  2463 00007CED 50                       push ax
  2464 00007CEE E87113                   call genCode8
  2465 00007CF1 83C402                   add  sp, 2
  2466                                  
  2467                                  ;-100                             InputPtr++;
  2468                                  
  2469 00007CF4 FF06[4D01]               inc  word [InputPtr]
  2470                                  
  2471                                  ;-101                         } while (*InputPtr != '"' );
  2472                                  
  2473 00007CF8 8B1E[4D01]               mov bx, [InputPtr]
  2474 00007CFC 8A07                     mov al, [bx]
  2475 00007CFE B400                     mov ah, 0
  2476 00007D00 83F822                   cmp ax, 34
  2477 00007D03 0F840200                 je  @@getVariable95
  2478 00007D07 EBD4                     jmp @@getVariable94
  2479                                  @@getVariable95:
  2480                                  
  2481                                  ;-102                         InputPtr++;
  2482                                  
  2483 00007D09 FF06[4D01]               inc  word [InputPtr]
  2484                                  
  2485                                  ;-103                     }
  2486                                  
  2487                                  
  2488                                  ;-104                 }
  2489                                  
  2490                                  @@getVariable93:
  2491                                  
  2492                                  ;-105             } while (isToken(','));
  2493                                  
  2494                                  @@getVariable92:
  2495 00007D0D 6A2C                     push 44
  2496 00007D0F E8D901                   call isToken
  2497 00007D12 83C402                   add  sp, 2
  2498 00007D15 08C0                     or  al, al
  2499 00007D17 0F840200                 je @@getVariable96
  2500 00007D1B EB96                     jmp @@getVariable90
  2501                                  @@getVariable96:
  2502                                  
  2503                                  ;-106         }
  2504                                  
  2505                                  
  2506                                  ;-107         if (CodeType== 201) {//DW
  2507                                  
  2508                                  @@getVariable89:
  2509 00007D1D A0[3102]                 mov al, [CodeType]
  2510 00007D20 3CC9                     cmp al, 201
  2511 00007D22 0F852600                 jne @@getVariable97
  2512                                  
  2513                                  ;-108             do { 
  2514                                  
  2515                                  @@getVariable98:
  2516                                  
  2517                                  ;-109                 getTokeType();
  2518                                  
  2519 00007D26 E832FD                   call getTokeType
  2520                                  
  2521                                  ;-110                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2522                                  
  2523 00007D29 A0[2E02]                 mov al, [TokeType]
  2524 00007D2C 3C01                     cmp al, 1
  2525 00007D2E 0F850A00                 jne @@getVariable99
  2526 00007D32 FF36[4C00]               push word [SymbolInt]
  2527 00007D36 E88013                   call genCode16
  2528 00007D39 83C402                   add  sp, 2
  2529                                  
  2530                                  ;-111             } while (isToken(','));
  2531                                  
  2532                                  @@getVariable99:
  2533 00007D3C 6A2C                     push 44
  2534 00007D3E E8AA01                   call isToken
  2535 00007D41 83C402                   add  sp, 2
  2536 00007D44 08C0                     or  al, al
  2537 00007D46 0F840200                 je @@getVariable100
  2538 00007D4A EBDA                     jmp @@getVariable98
  2539                                  @@getVariable100:
  2540                                  
  2541                                  ;-112         } 
  2542                                  
  2543                                  
  2544                                  ;-113         if (CodeType == 202) implerror();
  2545                                  
  2546                                  @@getVariable97:
  2547 00007D4C A0[3102]                 mov al, [CodeType]
  2548 00007D4F 3CCA                     cmp al, 202
  2549 00007D51 0F850300                 jne @@getVariable101
  2550 00007D55 E8BA0C                   call implerror
  2551                                  
  2552                                  ;-114         if (CodeType >= 203) {//resb, resw, resd
  2553                                  
  2554                                  @@getVariable101:
  2555 00007D58 A0[3102]                 mov al, [CodeType]
  2556 00007D5B 3CCB                     cmp al, 203 ;unsigned : 1
  2557 00007D5D 0F8C7400                 jl  @@getVariable102
  2558                                  
  2559                                  ;-115             getTokeType();
  2560                                  
  2561 00007D61 E8F7FC                   call getTokeType
  2562                                  
  2563                                  ;-116             if (TokeType == DIGIT) {
  2564                                  
  2565 00007D64 A0[2E02]                 mov al, [TokeType]
  2566 00007D67 3C01                     cmp al, 1
  2567 00007D69 0F856500                 jne @@getVariable103
  2568                                  
  2569                                  ;-117                 if (SymbolInt <= 0) syntaxerror();   
  2570                                  
  2571 00007D6D A1[4C00]                 mov ax, [SymbolInt]
  2572 00007D70 83F800                   cmp ax, 0
  2573 00007D73 0F870300                 ja  @@getVariable104
  2574 00007D77 E8870D                   call syntaxerror
  2575                                  
  2576                                  ;-118                 if (AbsoluteLab == 0) error1("Absolute is null");
  2577                                  
  2578                                  @@getVariable104:
  2579 00007D7A A1[2902]                 mov ax, [AbsoluteLab]
  2580 00007D7D 83F800                   cmp ax, 0
  2581 00007D80 0F850900                 jne @@getVariable105
  2582 00007D84 68[DD7D]                 push getVariable_0
  2583 00007D87 E8B80B                   call error1
  2584 00007D8A 83C402                   add  sp, 2
  2585                                  
  2586                                  ;-119                 LabelAddr[LabelMaxIx] = AbsoluteLab; 
  2587                                  
  2588                                  @@getVariable105:
  2589 00007D8D A1[2902]                 mov ax, [AbsoluteLab]
  2590 00007D90 8B1E[9F16]               mov bx, [LabelMaxIx]
  2591 00007D94 D1E3                     shl bx, 1
  2592 00007D96 8987[EF11]               mov [LabelAddr+bx], ax
  2593                                  
  2594                                  ;-120                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2595                                  
  2596 00007D9A A0[3102]                 mov al, [CodeType]
  2597 00007D9D 3CCC                     cmp al, 204
  2598 00007D9F 0F850A00                 jne @@getVariable106
  2599 00007DA3 A1[4C00]                 mov ax, [SymbolInt]
  2600 00007DA6 0306[4C00]               add ax, [SymbolInt]
  2601 00007DAA A3[4C00]                 mov word [SymbolInt], ax
  2602                                  
  2603                                  ;-121                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd                  
  2604                                  
  2605                                  @@getVariable106:
  2606 00007DAD A0[3102]                 mov al, [CodeType]
  2607 00007DB0 3CCD                     cmp al, 205
  2608 00007DB2 0F850F00                 jne @@getVariable107
  2609 00007DB6 A1[4C00]                 mov ax, [SymbolInt]
  2610 00007DB9 66BB04000000             mov ebx, 4
  2611 00007DBF 66F7E3                   mul ebx
  2612 00007DC2 A3[4C00]                 mov word [SymbolInt], ax
  2613                                  
  2614                                  ;-122                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2615                                  
  2616                                  @@getVariable107:
  2617 00007DC5 A1[2902]                 mov ax, [AbsoluteLab]
  2618 00007DC8 0306[4C00]               add ax, [SymbolInt]
  2619 00007DCC A3[2902]                 mov word [AbsoluteLab], ax
  2620                                  
  2621                                  ;-123             } else numbererror();  
  2622                                  
  2623 00007DCF E90300                   jmp @@getVariable108
  2624                                  @@getVariable103:
  2625 00007DD2 E8990C                   call numbererror
  2626                                  
  2627                                  ;-124         }    
  2628                                  
  2629                                  @@getVariable108:
  2630                                  
  2631                                  ;-125     }
  2632                                  
  2633                                  @@getVariable102:
  2634                                  
  2635                                  ;-126     else dataexit();
  2636                                  
  2637 00007DD5 E90300                   jmp @@getVariable109
  2638                                  @@getVariable86:
  2639 00007DD8 E8510D                   call dataexit
  2640                                  
  2641                                  ;-127 }
  2642                                  
  2643                                  @@getVariable109:
  2644                                  
  2645                                  ;-128 
  2646                                  
  2647                                  
  2648                                  ;-129 int lookCode() {//ret: CodeType, *OpCodePtr
  2649 00007DDB C9                       LEAVE
  2650 00007DDC C3                       ret
  2651                                  ; ENDP
  2652 00007DDD 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2653 00007DE6 6973206E756C6C00   
  2654                                  
  2655                                  lookCode:  ; *** PROC ***
  2656                                  
  2657                                  ;-130     CodeType=0;
  2658                                  
  2659 00007DEE 66B800000000             mov eax, 0
  2660 00007DF4 A2[3102]                 mov byte [CodeType], al
  2661                                  
  2662                                  ;-131     OpCodePtr= &I_START;
  2663                                  
  2664 00007DF7 B8[8570]                 mov ax, I_START
  2665 00007DFA A3[4A02]                 mov word [OpCodePtr], ax
  2666                                  
  2667                                  ;-132     OpCodePtr++;
  2668                                  
  2669 00007DFD FF06[4A02]               inc  word [OpCodePtr]
  2670                                  
  2671                                  ;-133     do  {
  2672                                  
  2673                                  @@lookCode110:
  2674                                  
  2675                                  ;-134         if (eqstr(SymbolUpper, OpCodePtr))  {
  2676                                  
  2677 00007E01 FF36[4A02]               push word [OpCodePtr]
  2678 00007E05 8D06[2D00]               lea  ax, [SymbolUpper]
  2679 00007E09 50                       push ax
  2680 00007E0A E85E1D                   call eqstr
  2681 00007E0D 83C404                   add  sp, 4
  2682 00007E10 08C0                     or  al, al
  2683 00007E12 0F842700                 je @@lookCode111
  2684                                  
  2685                                  ;-135             while(*OpCodePtr!=0) OpCodePtr++;
  2686                                  
  2687                                  @@lookCode112:
  2688 00007E16 8B1E[4A02]               mov bx, [OpCodePtr]
  2689 00007E1A 8A07                     mov al, [bx]
  2690 00007E1C B400                     mov ah, 0
  2691 00007E1E 83F800                   cmp ax, 0
  2692 00007E21 0F840600                 je  @@lookCode113
  2693 00007E25 FF06[4A02]               inc  word [OpCodePtr]
  2694                                  
  2695                                  ;-136             OpCodePtr++; 
  2696                                  
  2697 00007E29 EBEB                     jmp @@lookCode112
  2698                                  @@lookCode113:
  2699 00007E2B FF06[4A02]               inc  word [OpCodePtr]
  2700                                  
  2701                                  ;-137             CodeType =*OpCodePtr;
  2702                                  
  2703 00007E2F 8B1E[4A02]               mov bx, [OpCodePtr]
  2704 00007E33 8A07                     mov al, [bx]
  2705 00007E35 B400                     mov ah, 0
  2706 00007E37 A2[3102]                 mov byte [CodeType], al
  2707                                  
  2708                                  ;-138             return;
  2709                                  
  2710 00007E3A E92A00                   jmp @@retn
  2711                                  
  2712                                  ;-139         }
  2713                                  
  2714                                  
  2715                                  ;-140     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2716                                  
  2717                                  @@lookCode111:
  2718                                  @@lookCode114:
  2719 00007E3D 8B1E[4A02]               mov bx, [OpCodePtr]
  2720 00007E41 8A07                     mov al, [bx]
  2721 00007E43 B400                     mov ah, 0
  2722 00007E45 3DF100                   cmp ax, 241
  2723 00007E48 0F840600                 je  @@lookCode115
  2724 00007E4C FF06[4A02]               inc  word [OpCodePtr]
  2725                                  
  2726                                  ;-141     OpCodePtr++;
  2727                                  
  2728 00007E50 EBEB                     jmp @@lookCode114
  2729                                  @@lookCode115:
  2730 00007E52 FF06[4A02]               inc  word [OpCodePtr]
  2731                                  
  2732                                  ;-142     } while(*OpCodePtr!=0);
  2733                                  
  2734 00007E56 8B1E[4A02]               mov bx, [OpCodePtr]
  2735 00007E5A 8A07                     mov al, [bx]
  2736 00007E5C B400                     mov ah, 0
  2737 00007E5E 83F800                   cmp ax, 0
  2738 00007E61 0F840200                 je  @@lookCode116
  2739 00007E65 EB9A                     jmp @@lookCode110
  2740                                  @@lookCode116:
  2741                                  
  2742                                  ;-143 }
  2743                                  
  2744                                  
  2745                                  ;-144 
  2746                                  
  2747                                  
  2748                                  ;-145 int getCodeSize() {
  2749                                  
  2750                                  @@retn:
  2751 00007E67 C3                       ret
  2752                                  ; ENDP
  2753                                  
  2754                                  getCodeSize:  ; *** PROC ***
  2755                                  
  2756                                  ;-146     if (TokeType ==ALNUME) {
  2757                                  
  2758 00007E68 A0[2E02]                 mov al, [TokeType]
  2759 00007E6B 3C03                     cmp al, 3
  2760 00007E6D 0F856000                 jne @@getCodeSize117
  2761                                  
  2762                                  ;-147         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2763                                  
  2764 00007E71 68[DB7E]                 push getCodeSize_0
  2765 00007E74 8D06[2D00]               lea  ax, [SymbolUpper]
  2766 00007E78 50                       push ax
  2767 00007E79 E8EF1C                   call eqstr
  2768 00007E7C 83C404                   add  sp, 4
  2769 00007E7F 08C0                     or  al, al
  2770 00007E81 0F840C00                 je @@getCodeSize118
  2771 00007E85 E8D3FB                   call getTokeType
  2772 00007E88 66B801000000             mov eax, 1
  2773 00007E8E E94900                   jmp @@retn
  2774                                  
  2775                                  ;-148         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2776                                  
  2777                                  @@getCodeSize118:
  2778 00007E91 68[E07E]                 push getCodeSize_1
  2779 00007E94 8D06[2D00]               lea  ax, [SymbolUpper]
  2780 00007E98 50                       push ax
  2781 00007E99 E8CF1C                   call eqstr
  2782 00007E9C 83C404                   add  sp, 4
  2783 00007E9F 08C0                     or  al, al
  2784 00007EA1 0F840C00                 je @@getCodeSize119
  2785 00007EA5 E8B3FB                   call getTokeType
  2786 00007EA8 66B802000000             mov eax, 2
  2787 00007EAE E92900                   jmp @@retn
  2788                                  
  2789                                  ;-149         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2790                                  
  2791                                  @@getCodeSize119:
  2792 00007EB1 68[E57E]                 push getCodeSize_2
  2793 00007EB4 8D06[2D00]               lea  ax, [SymbolUpper]
  2794 00007EB8 50                       push ax
  2795 00007EB9 E8AF1C                   call eqstr
  2796 00007EBC 83C404                   add  sp, 4
  2797 00007EBF 08C0                     or  al, al
  2798 00007EC1 0F840C00                 je @@getCodeSize120
  2799 00007EC5 E893FB                   call getTokeType
  2800 00007EC8 66B803000000             mov eax, 3
  2801 00007ECE E90900                   jmp @@retn
  2802                                  
  2803                                  ;-150     } 
  2804                                  
  2805                                  @@getCodeSize120:
  2806                                  
  2807                                  ;-151     return 0;
  2808                                  
  2809                                  @@getCodeSize117:
  2810 00007ED1 66B800000000             mov eax, 0
  2811 00007ED7 E90000                   jmp @@retn
  2812                                  
  2813                                  ;-152 }
  2814                                  
  2815                                  
  2816                                  ;-153 int isToken(char c) {
  2817                                  
  2818                                  @@retn:
  2819 00007EDA C3                       ret
  2820                                  ; ENDP
  2821 00007EDB 4259544500              getCodeSize_0 db "BYTE",0
  2822 00007EE0 574F524400              getCodeSize_1 db "WORD",0
  2823 00007EE5 44574F524400            getCodeSize_2 db "DWORD",0
  2824                                  
  2825                                  isToken:  ; *** PROC ***
  2826                                  
  2827                                  ;-154     skipBlank();
  2828                                  
  2829                                  ;Function : isToken, Number of local variables: 1
  2830                                  ;   # type sign width line used address name   list of local variables
  2831                                  ;  200 var sign byte   153 NULL bp+4    c;
  2832 00007EEB C8000000                 ENTER  0,0
  2833 00007EEF E89101                   call skipBlank
  2834                                  
  2835                                  ;-155     if (*InputPtr == c) {
  2836                                  
  2837 00007EF2 8B1E[4D01]               mov bx, [InputPtr]
  2838 00007EF6 8A07                     mov al, [bx]
  2839 00007EF8 B400                     mov ah, 0
  2840 00007EFA 3A4604                   cmp al, [bp+4]
  2841 00007EFD 0F850D00                 jne @@isToken121
  2842                                  
  2843                                  ;-156         InputPtr++; 
  2844                                  
  2845 00007F01 FF06[4D01]               inc  word [InputPtr]
  2846                                  
  2847                                  ;-157         return 1;
  2848                                  
  2849 00007F05 66B801000000             mov eax, 1
  2850 00007F0B E90900                   jmp @@retn
  2851                                  
  2852                                  ;-158         } 
  2853                                  
  2854                                  
  2855                                  ;-159     return 0;
  2856                                  
  2857                                  @@isToken121:
  2858 00007F0E 66B800000000             mov eax, 0
  2859 00007F14 E90000                   jmp @@retn
  2860                                  
  2861                                  ;-160 }
  2862                                  
  2863                                  
  2864                                  ;-161 int need(char c) {
  2865                                  
  2866 00007F17 C9                      @@retn: LEAVE
  2867 00007F18 C3                       ret
  2868                                  ; ENDP
  2869                                  
  2870                                  need:  ; *** PROC ***
  2871                                  
  2872                                  ;-162     if (isToken(c)) {
  2873                                  
  2874                                  ;Function : need, Number of local variables: 1
  2875                                  ;   # type sign width line used address name   list of local variables
  2876                                  ;  200 var sign byte   161 NULL bp+4    c;
  2877 00007F19 C8000000                 ENTER  0,0
  2878 00007F1D 8A4604                   mov al, byte [bp+4]
  2879 00007F20 B400                     mov ah, 0
  2880 00007F22 50                       push ax
  2881 00007F23 E8C5FF                   call isToken
  2882 00007F26 83C402                   add  sp, 2
  2883 00007F29 08C0                     or  al, al
  2884 00007F2B 0F840600                 je @@need122
  2885                                  
  2886                                  ;-163         getTokeType();
  2887                                  
  2888 00007F2F E829FB                   call getTokeType
  2889                                  
  2890                                  ;-164         return;
  2891                                  
  2892 00007F32 E91800                   jmp @@retn
  2893                                  
  2894                                  ;-165         }
  2895                                  
  2896                                  
  2897                                  ;-166     error1();
  2898                                  
  2899                                  @@need122:
  2900 00007F35 E80A0A                   call error1
  2901                                  
  2902                                  ;-167     prs(". need: ");
  2903                                  
  2904 00007F38 68[4F7F]                 push need_0
  2905 00007F3B E8A308                   call prs
  2906 00007F3E 83C402                   add  sp, 2
  2907                                  
  2908                                  ;-168     prc(c);
  2909                                  
  2910 00007F41 8A4604                   mov al, byte [bp+4]
  2911 00007F44 B400                     mov ah, 0
  2912 00007F46 50                       push ax
  2913 00007F47 E83608                   call prc
  2914 00007F4A 83C402                   add  sp, 2
  2915                                  
  2916                                  ;-169 }
  2917                                  
  2918                                  
  2919                                  ;-170 int skipRest() {
  2920                                  
  2921 00007F4D C9                      @@retn: LEAVE
  2922 00007F4E C3                       ret
  2923                                  ; ENDP
  2924 00007F4F 2E206E6565643A2000      need_0 db ". need: ",0
  2925                                  
  2926                                  skipRest:  ; *** PROC ***
  2927                                  
  2928                                  ;-171     getTokeType(); 
  2929                                  
  2930 00007F58 E800FB                   call getTokeType
  2931                                  
  2932                                  ;-172     if(TokeType)error1("extra char ignored");
  2933                                  
  2934 00007F5B A0[2E02]                 mov al, [TokeType]
  2935 00007F5E 08C0                     or  al, al
  2936 00007F60 0F840900                 je @@skipRest123
  2937 00007F64 68[6E7F]                 push skipRest_0
  2938 00007F67 E8D809                   call error1
  2939 00007F6A 83C402                   add  sp, 2
  2940                                  
  2941                                  ;-173 }
  2942                                  
  2943                                  @@skipRest123:
  2944 00007F6D C3                       ret
  2945                                  ; ENDP
  2946 00007F6E 657874726120636861-     skipRest_0 db "extra char ignored",0
  2947 00007F77 722069676E6F726564-
  2948 00007F80 00                 
  2949                                  ;Back to main program: AS.C
  2950                                  
  2951                                  ;-6 #include "HELPER.C"
  2952                                  
  2953                                  ;Use include file: HELPER.C
  2954                                  
  2955                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2956                                  
  2957                                  
  2958                                  getLine:  ; *** PROC ***
  2959                                  
  2960                                  ;-2   unsigned int i;
  2961                                  
  2962                                  
  2963                                  ;-3   InputPtr= &InputBuf;
  2964                                  
  2965                                  ;Function : getLine, Number of local variables: 1
  2966                                  ;   # type sign width line used address name   list of local variables
  2967                                  ;  200 var unsg word     2 NULL bp-2    i;
  2968 00007F81 C8020000                 ENTER  2,0
  2969 00007F85 B8[4E00]                 mov ax, InputBuf
  2970 00007F88 A3[4D01]                 mov word [InputPtr], ax
  2971                                  
  2972                                  ;-4   *InputPtr=0;//if last line is empty
  2973                                  
  2974 00007F8B 66B800000000             mov eax, 0
  2975 00007F91 8B1E[4D01]               mov  bx, [InputPtr]
  2976 00007F95 8807                     mov  [bx], al
  2977                                  
  2978                                  ;-5   do {
  2979                                  
  2980                                  @@getLine124:
  2981                                  
  2982                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2983                                  
  2984 00007F97 6A01                     push 1
  2985 00007F99 FF36[1802]               push word [asm_fd]
  2986 00007F9D 8D06[2402]               lea  ax, [DOS_ByteRead]
  2987 00007FA1 50                       push ax
  2988 00007FA2 E8611C                   call readRL
  2989 00007FA5 83C406                   add  sp, 6
  2990 00007FA8 A3[2202]                 mov word [DOS_NoBytes], ax
  2991                                  
  2992                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2993                                  
  2994 00007FAB A1[1E02]                 mov ax, [DOS_ERR]
  2995 00007FAE 08C0                     or  al, al
  2996 00007FB0 0F840900                 je @@getLine125
  2997 00007FB4 68[1980]                 push getLine_0
  2998 00007FB7 E8E709                   call errorexit
  2999 00007FBA 83C402                   add  sp, 2
  3000                                  
  3001                                  ;-8     if (DOS_NoBytes == 0) return;
  3002                                  
  3003                                  @@getLine125:
  3004 00007FBD A1[2202]                 mov ax, [DOS_NoBytes]
  3005 00007FC0 83F800                   cmp ax, 0
  3006 00007FC3 0F850300                 jne @@getLine126
  3007 00007FC7 E94D00                   jmp @@retn
  3008                                  
  3009                                  ;-9     *InputPtr = DOS_ByteRead;
  3010                                  
  3011                                  @@getLine126:
  3012 00007FCA A0[2402]                 mov al, [DOS_ByteRead]
  3013 00007FCD 8B1E[4D01]               mov  bx, [InputPtr]
  3014 00007FD1 8807                     mov  [bx], al
  3015                                  
  3016                                  ;-10     InputPtr++;
  3017                                  
  3018 00007FD3 FF06[4D01]               inc  word [InputPtr]
  3019                                  
  3020                                  ;-11     i = InputPtr - &InputBuf;
  3021                                  
  3022 00007FD7 A1[4D01]                 mov ax, [InputPtr]
  3023 00007FDA 2D[4E00]                 sub ax, InputBuf
  3024 00007FDD 8946FE                   mov word [bp-2], ax
  3025                                  
  3026                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3027                                  
  3028 00007FE0 8B46FE                   mov ax, [bp-2]
  3029 00007FE3 3DFF00                   cmp ax, 255 ;unsigned : 0
  3030 00007FE6 0F820900                 jb  @@getLine127
  3031 00007FEA 68[2880]                 push getLine_1
  3032 00007FED E8B109                   call errorexit
  3033 00007FF0 83C402                   add  sp, 2
  3034                                  
  3035                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  3036                                  
  3037                                  @@getLine127:
  3038 00007FF3 A0[2402]                 mov al, byte [DOS_ByteRead]
  3039 00007FF6 B400                     mov ah, 0
  3040 00007FF8 50                       push ax
  3041 00007FF9 E84000                   call ifEOL
  3042 00007FFC 83C402                   add  sp, 2
  3043 00007FFF 3C00                     cmp al, 0
  3044 00008001 0F850200                 jne @@getLine128
  3045 00008005 EB90                     jmp @@getLine124
  3046                                  @@getLine128:
  3047                                  
  3048                                  ;-14   InputPtr--;
  3049                                  
  3050 00008007 FF0E[4D01]               dec  word [InputPtr]
  3051                                  
  3052                                  ;-15   *InputPtr=0;
  3053                                  
  3054 0000800B 66B800000000             mov eax, 0
  3055 00008011 8B1E[4D01]               mov  bx, [InputPtr]
  3056 00008015 8807                     mov  [bx], al
  3057                                  
  3058                                  ;-16 }
  3059                                  
  3060                                  
  3061                                  ;-17 int ifEOL(char c) {
  3062                                  
  3063 00008017 C9                      @@retn: LEAVE
  3064 00008018 C3                       ret
  3065                                  ; ENDP
  3066 00008019 52656164696E672053-     getLine_0 db "Reading Source",0
  3067 00008022 6F7572636500       
  3068 00008028 696E707574206C696E-     getLine_1 db "input line too long",0
  3069 00008031 6520746F6F206C6F6E-
  3070 0000803A 6700               
  3071                                  
  3072                                  ifEOL:  ; *** PROC ***
  3073                                  
  3074                                  ;-18   if (c == 10) return 1;
  3075                                  
  3076                                  ;Function : ifEOL, Number of local variables: 1
  3077                                  ;   # type sign width line used address name   list of local variables
  3078                                  ;  200 var sign byte    17 NULL bp+4    c;
  3079 0000803C C8000000                 ENTER  0,0
  3080 00008040 8A4604                   mov al, [bp+4]
  3081 00008043 3C0A                     cmp al, 10
  3082 00008045 0F850900                 jne @@ifEOL129
  3083 00008049 66B801000000             mov eax, 1
  3084 0000804F E92F00                   jmp @@retn
  3085                                  
  3086                                  ;-19   if (c == 13) {
  3087                                  
  3088                                  @@ifEOL129:
  3089 00008052 8A4604                   mov al, [bp+4]
  3090 00008055 3C0D                     cmp al, 13
  3091 00008057 0F851D00                 jne @@ifEOL130
  3092                                  
  3093                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3094                                  
  3095 0000805B 6A01                     push 1
  3096 0000805D FF36[1802]               push word [asm_fd]
  3097 00008061 8D06[2402]               lea  ax, [DOS_ByteRead]
  3098 00008065 50                       push ax
  3099 00008066 E89D1B                   call readRL
  3100 00008069 83C406                   add  sp, 6
  3101 0000806C A3[2202]                 mov word [DOS_NoBytes], ax
  3102                                  
  3103                                  ;-21     return 1;}
  3104                                  
  3105 0000806F 66B801000000             mov eax, 1
  3106 00008075 E90900                   jmp @@retn
  3107                                  
  3108                                  ;-22   return 0;
  3109                                  
  3110                                  @@ifEOL130:
  3111 00008078 66B800000000             mov eax, 0
  3112 0000807E E90000                   jmp @@retn
  3113                                  
  3114                                  ;-23 }
  3115                                  
  3116                                  
  3117                                  ;-24 int skipBlank() {
  3118                                  
  3119 00008081 C9                      @@retn: LEAVE
  3120 00008082 C3                       ret
  3121                                  ; ENDP
  3122                                  
  3123                                  skipBlank:  ; *** PROC ***
  3124                                  
  3125                                  ;-25   skipblank1:
  3126                                  
  3127                                  @@skipblank1:
  3128                                  
  3129                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3130                                  
  3131 00008083 8B1E[4D01]               mov bx, [InputPtr]
  3132 00008087 8A07                     mov al, [bx]
  3133 00008089 B400                     mov ah, 0
  3134 0000808B 83F820                   cmp ax, 32
  3135 0000808E 0F850600                 jne @@skipBlank131
  3136 00008092 FF06[4D01]               inc  word [InputPtr]
  3137 00008096 EBEB                     jmp @@skipblank1
  3138                                  
  3139                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3140                                  
  3141                                  @@skipBlank131:
  3142 00008098 8B1E[4D01]               mov bx, [InputPtr]
  3143 0000809C 8A07                     mov al, [bx]
  3144 0000809E B400                     mov ah, 0
  3145 000080A0 83F809                   cmp ax, 9
  3146 000080A3 0F850600                 jne @@skipBlank132
  3147 000080A7 FF06[4D01]               inc  word [InputPtr]
  3148 000080AB EBD6                     jmp @@skipblank1
  3149                                  
  3150                                  ;-28 }
  3151                                  
  3152                                  @@skipBlank132:
  3153                                  
  3154                                  ;-29 int letterE(char c) {
  3155                                  
  3156 000080AD C3                       ret
  3157                                  ; ENDP
  3158                                  
  3159                                  letterE:  ; *** PROC ***
  3160                                  
  3161                                  ;-30   if (c=='_') return 1;
  3162                                  
  3163                                  ;Function : letterE, Number of local variables: 1
  3164                                  ;   # type sign width line used address name   list of local variables
  3165                                  ;  200 var sign byte    29 NULL bp+4    c;
  3166 000080AE C8000000                 ENTER  0,0
  3167 000080B2 8A4604                   mov al, [bp+4]
  3168 000080B5 3C5F                     cmp al, 95
  3169 000080B7 0F850900                 jne @@letterE133
  3170 000080BB 66B801000000             mov eax, 1
  3171 000080C1 E97E00                   jmp @@retn
  3172                                  
  3173                                  ;-31   if (c=='.') return 1;
  3174                                  
  3175                                  @@letterE133:
  3176 000080C4 8A4604                   mov al, [bp+4]
  3177 000080C7 3C2E                     cmp al, 46
  3178 000080C9 0F850900                 jne @@letterE134
  3179 000080CD 66B801000000             mov eax, 1
  3180 000080D3 E96C00                   jmp @@retn
  3181                                  
  3182                                  ;-32   if (c=='?') return 1;
  3183                                  
  3184                                  @@letterE134:
  3185 000080D6 8A4604                   mov al, [bp+4]
  3186 000080D9 3C3F                     cmp al, 63
  3187 000080DB 0F850900                 jne @@letterE135
  3188 000080DF 66B801000000             mov eax, 1
  3189 000080E5 E95A00                   jmp @@retn
  3190                                  
  3191                                  ;-33   if (c=='$') return 1;
  3192                                  
  3193                                  @@letterE135:
  3194 000080E8 8A4604                   mov al, [bp+4]
  3195 000080EB 3C24                     cmp al, 36
  3196 000080ED 0F850900                 jne @@letterE136
  3197 000080F1 66B801000000             mov eax, 1
  3198 000080F7 E94800                   jmp @@retn
  3199                                  
  3200                                  ;-34   if (c> 'z') return 0;
  3201                                  
  3202                                  @@letterE136:
  3203 000080FA 8A4604                   mov al, [bp+4]
  3204 000080FD 3C7A                     cmp al, 122
  3205 000080FF 0F8E0900                 jle @@letterE137
  3206 00008103 66B800000000             mov eax, 0
  3207 00008109 E93600                   jmp @@retn
  3208                                  
  3209                                  ;-35   if (c< '@') return 0; // at included
  3210                                  
  3211                                  @@letterE137:
  3212 0000810C 8A4604                   mov al, [bp+4]
  3213 0000810F 3C40                     cmp al, 64
  3214 00008111 0F8D0900                 jge @@letterE138
  3215 00008115 66B800000000             mov eax, 0
  3216 0000811B E92400                   jmp @@retn
  3217                                  
  3218                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3219                                  
  3220                                  @@letterE138:
  3221 0000811E 8A4604                   mov al, [bp+4]
  3222 00008121 3C5A                     cmp al, 90
  3223 00008123 0F8E1200                 jle @@letterE139
  3224 00008127 8A4604                   mov al, [bp+4]
  3225 0000812A 3C61                     cmp al, 97
  3226 0000812C 0F8D0900                 jge @@letterE140
  3227 00008130 66B800000000             mov eax, 0
  3228 00008136 E90900                   jmp @@retn
  3229                                  @@letterE140:
  3230                                  
  3231                                  ;-37   return 1;
  3232                                  
  3233                                  @@letterE139:
  3234 00008139 66B801000000             mov eax, 1
  3235 0000813F E90000                   jmp @@retn
  3236                                  
  3237                                  ;-38 }
  3238                                  
  3239                                  
  3240                                  ;-39 int alnumE(char c) {
  3241                                  
  3242 00008142 C9                      @@retn: LEAVE
  3243 00008143 C3                       ret
  3244                                  ; ENDP
  3245                                  
  3246                                  alnumE:  ; *** PROC ***
  3247                                  
  3248                                  ;-40   if (digit(c)) return 1;
  3249                                  
  3250                                  ;Function : alnumE, Number of local variables: 1
  3251                                  ;   # type sign width line used address name   list of local variables
  3252                                  ;  200 var sign byte    39 NULL bp+4    c;
  3253 00008144 C8000000                 ENTER  0,0
  3254 00008148 8A4604                   mov al, byte [bp+4]
  3255 0000814B B400                     mov ah, 0
  3256 0000814D 50                       push ax
  3257 0000814E E8E719                   call digit
  3258 00008151 83C402                   add  sp, 2
  3259 00008154 08C0                     or  al, al
  3260 00008156 0F840900                 je @@alnumE141
  3261 0000815A 66B801000000             mov eax, 1
  3262 00008160 E92400                   jmp @@retn
  3263                                  
  3264                                  ;-41   if (letterE(c)) return 1;
  3265                                  
  3266                                  @@alnumE141:
  3267 00008163 8A4604                   mov al, byte [bp+4]
  3268 00008166 B400                     mov ah, 0
  3269 00008168 50                       push ax
  3270 00008169 E842FF                   call letterE
  3271 0000816C 83C402                   add  sp, 2
  3272 0000816F 08C0                     or  al, al
  3273 00008171 0F840900                 je @@alnumE142
  3274 00008175 66B801000000             mov eax, 1
  3275 0000817B E90900                   jmp @@retn
  3276                                  
  3277                                  ;-42   return 0;
  3278                                  
  3279                                  @@alnumE142:
  3280 0000817E 66B800000000             mov eax, 0
  3281 00008184 E90000                   jmp @@retn
  3282                                  
  3283                                  ;-43 }
  3284                                  
  3285                                  
  3286                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3287                                  
  3288 00008187 C9                      @@retn: LEAVE
  3289 00008188 C3                       ret
  3290                                  ; ENDP
  3291                                  
  3292                                  getDigit:  ; *** PROC ***
  3293                                  
  3294                                  ;-45   unsigned int CastInt;
  3295                                  
  3296                                  
  3297                                  ;-46   SymbolInt=0;
  3298                                  
  3299                                  ;Function : getDigit, Number of local variables: 2
  3300                                  ;   # type sign width line used address name   list of local variables
  3301                                  ;  200 var unsg byte    44 NULL bp+4    c
  3302                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3303 00008189 C8020000                 ENTER  2,0
  3304 0000818D 66B800000000             mov eax, 0
  3305 00008193 A3[4C00]                 mov word [SymbolInt], ax
  3306                                  
  3307                                  ;-47   do {
  3308                                  
  3309                                  @@getDigit143:
  3310                                  
  3311                                  ;-48     c-='0';
  3312                                  
  3313 00008196 806E0430                 sub  byte [bp+4], 48
  3314                                  
  3315                                  ;-49     SymbolInt=SymbolInt*10;
  3316                                  
  3317 0000819A A1[4C00]                 mov ax, [SymbolInt]
  3318 0000819D 66BB0A000000             mov ebx, 10
  3319 000081A3 66F7E3                   mul ebx
  3320 000081A6 A3[4C00]                 mov word [SymbolInt], ax
  3321                                  
  3322                                  ;-50     ax=0; CastInt=c; //cast b2w
  3323                                  
  3324 000081A9 B80000                   mov  ax, 0
  3325 000081AC 8A4604                   mov al, [bp+4]
  3326 000081AF 8946FE                   mov word [bp-2], ax
  3327                                  
  3328                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3329                                  
  3330 000081B2 A1[4C00]                 mov ax, [SymbolInt]
  3331 000081B5 0346FE                   add ax, [bp-2]
  3332 000081B8 A3[4C00]                 mov word [SymbolInt], ax
  3333                                  
  3334                                  ;-52     InputPtr++;
  3335                                  
  3336 000081BB FF06[4D01]               inc  word [InputPtr]
  3337                                  
  3338                                  ;-53     c = *InputPtr;
  3339                                  
  3340 000081BF 8B1E[4D01]               mov bx, [InputPtr]
  3341 000081C3 8A07                     mov al, [bx]
  3342 000081C5 B400                     mov ah, 0
  3343 000081C7 884604                   mov byte [bp+4], al
  3344                                  
  3345                                  ;-54   } while(digit(c));
  3346                                  
  3347 000081CA 8A4604                   mov al, byte [bp+4]
  3348 000081CD B400                     mov ah, 0
  3349 000081CF 50                       push ax
  3350 000081D0 E86519                   call digit
  3351 000081D3 83C402                   add  sp, 2
  3352 000081D6 08C0                     or  al, al
  3353 000081D8 0F840200                 je @@getDigit144
  3354 000081DC EBB8                     jmp @@getDigit143
  3355                                  @@getDigit144:
  3356                                  
  3357                                  ;-55 }
  3358                                  
  3359                                  
  3360                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3361 000081DE C9                       LEAVE
  3362 000081DF C3                       ret
  3363                                  ; ENDP
  3364                                  
  3365                                  getName:  ; *** PROC ***
  3366                                  
  3367                                  ;-57   char *p; unsigned int i;
  3368                                  
  3369                                  
  3370                                  ;-58   p = &Symbol;
  3371                                  
  3372                                  ;Function : getName, Number of local variables: 3
  3373                                  ;   # type sign width line used address name   list of local variables
  3374                                  ;  200 var unsg byte    56 NULL bp+4    c
  3375                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3376                                  ;  202 var unsg word    57 NULL bp-4    i;
  3377 000081E0 C8040000                 ENTER  4,0
  3378 000081E4 B8[0E00]                 mov ax, Symbol
  3379 000081E7 8946FE                   mov word [bp-2], ax
  3380                                  
  3381                                  ;-59   *p = c;
  3382                                  
  3383 000081EA 8A4604                   mov al, [bp+4]
  3384 000081ED 8B5EFE                   mov  bx, [bp-2]
  3385 000081F0 8807                     mov  [bx], al
  3386                                  
  3387                                  ;-60   p++;
  3388                                  
  3389 000081F2 FF46FE                   inc  word [bp-2]
  3390                                  
  3391                                  ;-61   while (alnumE(c)) {
  3392                                  
  3393                                  @@getName145:
  3394 000081F5 8A4604                   mov al, byte [bp+4]
  3395 000081F8 B400                     mov ah, 0
  3396 000081FA 50                       push ax
  3397 000081FB E846FF                   call alnumE
  3398 000081FE 83C402                   add  sp, 2
  3399 00008201 08C0                     or  al, al
  3400 00008203 0F843800                 je @@getName146
  3401                                  
  3402                                  ;-62     InputPtr++;
  3403                                  
  3404 00008207 FF06[4D01]               inc  word [InputPtr]
  3405                                  
  3406                                  ;-63     c = *InputPtr;
  3407                                  
  3408 0000820B 8B1E[4D01]               mov bx, [InputPtr]
  3409 0000820F 8A07                     mov al, [bx]
  3410 00008211 B400                     mov ah, 0
  3411 00008213 884604                   mov byte [bp+4], al
  3412                                  
  3413                                  ;-64     *p = c;
  3414                                  
  3415 00008216 8A4604                   mov al, [bp+4]
  3416 00008219 8B5EFE                   mov  bx, [bp-2]
  3417 0000821C 8807                     mov  [bx], al
  3418                                  
  3419                                  ;-65     p++;
  3420                                  
  3421 0000821E FF46FE                   inc  word [bp-2]
  3422                                  
  3423                                  ;-66     i = p - &Symbol;
  3424                                  
  3425 00008221 8B46FE                   mov ax, [bp-2]
  3426 00008224 2D[0E00]                 sub ax, Symbol
  3427 00008227 8946FC                   mov word [bp-4], ax
  3428                                  
  3429                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3430                                  
  3431 0000822A 8B46FC                   mov ax, [bp-4]
  3432 0000822D 83F81F                   cmp ax, 31 ;unsigned : 0
  3433 00008230 0F820900                 jb  @@getName147
  3434 00008234 68[8882]                 push getName_0
  3435 00008237 E86707                   call errorexit
  3436 0000823A 83C402                   add  sp, 2
  3437                                  
  3438                                  ;-68   }
  3439                                  
  3440                                  @@getName147:
  3441                                  
  3442                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3443                                  
  3444 0000823D EBB6                     jmp @@getName145
  3445                                  @@getName146:
  3446 0000823F 8A4604                   mov al, [bp+4]
  3447 00008242 3C3A                     cmp al, 58
  3448 00008244 0F850C00                 jne @@getName148
  3449 00008248 66B801000000             mov eax, 1
  3450 0000824E A2[2D02]                 mov byte [isLabel], al
  3451 00008251 E90900                   jmp @@getName149
  3452                                  @@getName148:
  3453 00008254 66B800000000             mov eax, 0
  3454 0000825A A2[2D02]                 mov byte [isLabel], al
  3455                                  
  3456                                  ;-70   p--;
  3457                                  
  3458                                  @@getName149:
  3459 0000825D FF4EFE                   dec  word [bp-2]
  3460                                  
  3461                                  ;-71   *p = 0;
  3462                                  
  3463 00008260 66B800000000             mov eax, 0
  3464 00008266 8B5EFE                   mov  bx, [bp-2]
  3465 00008269 8807                     mov  [bx], al
  3466                                  
  3467                                  ;-72   strcpy(SymbolUpper, Symbol);
  3468                                  
  3469 0000826B 8D06[0E00]               lea  ax, [Symbol]
  3470 0000826F 50                       push ax
  3471 00008270 8D06[2D00]               lea  ax, [SymbolUpper]
  3472 00008274 50                       push ax
  3473 00008275 E88718                   call strcpy
  3474 00008278 83C404                   add  sp, 4
  3475                                  
  3476                                  ;-73   toupper(SymbolUpper);
  3477                                  
  3478 0000827B 8D06[2D00]               lea  ax, [SymbolUpper]
  3479 0000827F 50                       push ax
  3480 00008280 E80E18                   call toupper
  3481 00008283 83C402                   add  sp, 2
  3482                                  
  3483                                  ;-74 }
  3484                                  
  3485                                  
  3486                                  ;-75 int testReg() {
  3487 00008286 C9                       LEAVE
  3488 00008287 C3                       ret
  3489                                  ; ENDP
  3490 00008288 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3491 00008291 6F206C6F6E6700     
  3492                                  
  3493                                  testReg:  ; *** PROC ***
  3494                                  
  3495                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3496                                  
  3497                                  
  3498                                  ;-77   R2Type=0;
  3499                                  
  3500 00008298 66B800000000             mov eax, 0
  3501 0000829E A2[3702]                 mov byte [R2Type], al
  3502                                  
  3503                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3504                                  
  3505 000082A1 8D06[0E00]               lea  ax, [Symbol]
  3506 000082A5 50                       push ax
  3507 000082A6 E82B18                   call strlen
  3508 000082A9 83C402                   add  sp, 2
  3509 000082AC 3C02                     cmp al, 2
  3510 000082AE 0F8D0900                 jge @@testReg150
  3511 000082B2 66B800000000             mov eax, 0
  3512 000082B8 E9B603                   jmp @@retn
  3513                                  
  3514                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3515                                  
  3516                                  @@testReg150:
  3517 000082BB 8D06[0E00]               lea  ax, [Symbol]
  3518 000082BF 50                       push ax
  3519 000082C0 E81118                   call strlen
  3520 000082C3 83C402                   add  sp, 2
  3521 000082C6 3C03                     cmp al, 3
  3522 000082C8 0F8E0900                 jle @@testReg151
  3523 000082CC 66B800000000             mov eax, 0
  3524 000082D2 E99C03                   jmp @@retn
  3525                                  
  3526                                  ;-80   R2Type=BYTE;
  3527                                  
  3528                                  @@testReg151:
  3529 000082D5 66B801000000             mov eax, 1
  3530 000082DB A2[3702]                 mov byte [R2Type], al
  3531                                  
  3532                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3533                                  
  3534 000082DE 68[7286]                 push testReg_0
  3535 000082E1 8D06[2D00]               lea  ax, [SymbolUpper]
  3536 000082E5 50                       push ax
  3537 000082E6 E88218                   call eqstr
  3538 000082E9 83C404                   add  sp, 4
  3539 000082EC 08C0                     or  al, al
  3540 000082EE 0F840900                 je @@testReg152
  3541 000082F2 66B800000000             mov eax, 0
  3542 000082F8 E97603                   jmp @@retn
  3543                                  
  3544                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3545                                  
  3546                                  @@testReg152:
  3547 000082FB 68[7586]                 push testReg_1
  3548 000082FE 8D06[2D00]               lea  ax, [SymbolUpper]
  3549 00008302 50                       push ax
  3550 00008303 E86518                   call eqstr
  3551 00008306 83C404                   add  sp, 4
  3552 00008309 08C0                     or  al, al
  3553 0000830B 0F840900                 je @@testReg153
  3554 0000830F 66B801000000             mov eax, 1
  3555 00008315 E95903                   jmp @@retn
  3556                                  
  3557                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3558                                  
  3559                                  @@testReg153:
  3560 00008318 68[7886]                 push testReg_2
  3561 0000831B 8D06[2D00]               lea  ax, [SymbolUpper]
  3562 0000831F 50                       push ax
  3563 00008320 E84818                   call eqstr
  3564 00008323 83C404                   add  sp, 4
  3565 00008326 08C0                     or  al, al
  3566 00008328 0F840900                 je @@testReg154
  3567 0000832C 66B802000000             mov eax, 2
  3568 00008332 E93C03                   jmp @@retn
  3569                                  
  3570                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3571                                  
  3572                                  @@testReg154:
  3573 00008335 68[7B86]                 push testReg_3
  3574 00008338 8D06[2D00]               lea  ax, [SymbolUpper]
  3575 0000833C 50                       push ax
  3576 0000833D E82B18                   call eqstr
  3577 00008340 83C404                   add  sp, 4
  3578 00008343 08C0                     or  al, al
  3579 00008345 0F840900                 je @@testReg155
  3580 00008349 66B803000000             mov eax, 3
  3581 0000834F E91F03                   jmp @@retn
  3582                                  
  3583                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3584                                  
  3585                                  @@testReg155:
  3586 00008352 68[7E86]                 push testReg_4
  3587 00008355 8D06[2D00]               lea  ax, [SymbolUpper]
  3588 00008359 50                       push ax
  3589 0000835A E80E18                   call eqstr
  3590 0000835D 83C404                   add  sp, 4
  3591 00008360 08C0                     or  al, al
  3592 00008362 0F840900                 je @@testReg156
  3593 00008366 66B804000000             mov eax, 4
  3594 0000836C E90203                   jmp @@retn
  3595                                  
  3596                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3597                                  
  3598                                  @@testReg156:
  3599 0000836F 68[8186]                 push testReg_5
  3600 00008372 8D06[2D00]               lea  ax, [SymbolUpper]
  3601 00008376 50                       push ax
  3602 00008377 E8F117                   call eqstr
  3603 0000837A 83C404                   add  sp, 4
  3604 0000837D 08C0                     or  al, al
  3605 0000837F 0F840900                 je @@testReg157
  3606 00008383 66B805000000             mov eax, 5
  3607 00008389 E9E502                   jmp @@retn
  3608                                  
  3609                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3610                                  
  3611                                  @@testReg157:
  3612 0000838C 68[8486]                 push testReg_6
  3613 0000838F 8D06[2D00]               lea  ax, [SymbolUpper]
  3614 00008393 50                       push ax
  3615 00008394 E8D417                   call eqstr
  3616 00008397 83C404                   add  sp, 4
  3617 0000839A 08C0                     or  al, al
  3618 0000839C 0F840900                 je @@testReg158
  3619 000083A0 66B806000000             mov eax, 6
  3620 000083A6 E9C802                   jmp @@retn
  3621                                  
  3622                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3623                                  
  3624                                  @@testReg158:
  3625 000083A9 68[8786]                 push testReg_7
  3626 000083AC 8D06[2D00]               lea  ax, [SymbolUpper]
  3627 000083B0 50                       push ax
  3628 000083B1 E8B717                   call eqstr
  3629 000083B4 83C404                   add  sp, 4
  3630 000083B7 08C0                     or  al, al
  3631 000083B9 0F840900                 je @@testReg159
  3632 000083BD 66B807000000             mov eax, 7
  3633 000083C3 E9AB02                   jmp @@retn
  3634                                  
  3635                                  ;-89   R2Type=WORD;
  3636                                  
  3637                                  @@testReg159:
  3638 000083C6 66B802000000             mov eax, 2
  3639 000083CC A2[3702]                 mov byte [R2Type], al
  3640                                  
  3641                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3642                                  
  3643 000083CF 68[8A86]                 push testReg_8
  3644 000083D2 8D06[2D00]               lea  ax, [SymbolUpper]
  3645 000083D6 50                       push ax
  3646 000083D7 E89117                   call eqstr
  3647 000083DA 83C404                   add  sp, 4
  3648 000083DD 08C0                     or  al, al
  3649 000083DF 0F840900                 je @@testReg160
  3650 000083E3 66B800000000             mov eax, 0
  3651 000083E9 E98502                   jmp @@retn
  3652                                  
  3653                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3654                                  
  3655                                  @@testReg160:
  3656 000083EC 68[8D86]                 push testReg_9
  3657 000083EF 8D06[2D00]               lea  ax, [SymbolUpper]
  3658 000083F3 50                       push ax
  3659 000083F4 E87417                   call eqstr
  3660 000083F7 83C404                   add  sp, 4
  3661 000083FA 08C0                     or  al, al
  3662 000083FC 0F840900                 je @@testReg161
  3663 00008400 66B801000000             mov eax, 1
  3664 00008406 E96802                   jmp @@retn
  3665                                  
  3666                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3667                                  
  3668                                  @@testReg161:
  3669 00008409 68[9086]                 push testReg_10
  3670 0000840C 8D06[2D00]               lea  ax, [SymbolUpper]
  3671 00008410 50                       push ax
  3672 00008411 E85717                   call eqstr
  3673 00008414 83C404                   add  sp, 4
  3674 00008417 08C0                     or  al, al
  3675 00008419 0F840900                 je @@testReg162
  3676 0000841D 66B802000000             mov eax, 2
  3677 00008423 E94B02                   jmp @@retn
  3678                                  
  3679                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3680                                  
  3681                                  @@testReg162:
  3682 00008426 68[9386]                 push testReg_11
  3683 00008429 8D06[2D00]               lea  ax, [SymbolUpper]
  3684 0000842D 50                       push ax
  3685 0000842E E83A17                   call eqstr
  3686 00008431 83C404                   add  sp, 4
  3687 00008434 08C0                     or  al, al
  3688 00008436 0F840900                 je @@testReg163
  3689 0000843A 66B803000000             mov eax, 3
  3690 00008440 E92E02                   jmp @@retn
  3691                                  
  3692                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3693                                  
  3694                                  @@testReg163:
  3695 00008443 68[9686]                 push testReg_12
  3696 00008446 8D06[2D00]               lea  ax, [SymbolUpper]
  3697 0000844A 50                       push ax
  3698 0000844B E81D17                   call eqstr
  3699 0000844E 83C404                   add  sp, 4
  3700 00008451 08C0                     or  al, al
  3701 00008453 0F840900                 je @@testReg164
  3702 00008457 66B804000000             mov eax, 4
  3703 0000845D E91102                   jmp @@retn
  3704                                  
  3705                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3706                                  
  3707                                  @@testReg164:
  3708 00008460 68[9986]                 push testReg_13
  3709 00008463 8D06[2D00]               lea  ax, [SymbolUpper]
  3710 00008467 50                       push ax
  3711 00008468 E80017                   call eqstr
  3712 0000846B 83C404                   add  sp, 4
  3713 0000846E 08C0                     or  al, al
  3714 00008470 0F840900                 je @@testReg165
  3715 00008474 66B805000000             mov eax, 5
  3716 0000847A E9F401                   jmp @@retn
  3717                                  
  3718                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3719                                  
  3720                                  @@testReg165:
  3721 0000847D 68[9C86]                 push testReg_14
  3722 00008480 8D06[2D00]               lea  ax, [SymbolUpper]
  3723 00008484 50                       push ax
  3724 00008485 E8E316                   call eqstr
  3725 00008488 83C404                   add  sp, 4
  3726 0000848B 08C0                     or  al, al
  3727 0000848D 0F840900                 je @@testReg166
  3728 00008491 66B806000000             mov eax, 6
  3729 00008497 E9D701                   jmp @@retn
  3730                                  
  3731                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3732                                  
  3733                                  @@testReg166:
  3734 0000849A 68[9F86]                 push testReg_15
  3735 0000849D 8D06[2D00]               lea  ax, [SymbolUpper]
  3736 000084A1 50                       push ax
  3737 000084A2 E8C616                   call eqstr
  3738 000084A5 83C404                   add  sp, 4
  3739 000084A8 08C0                     or  al, al
  3740 000084AA 0F840900                 je @@testReg167
  3741 000084AE 66B807000000             mov eax, 7
  3742 000084B4 E9BA01                   jmp @@retn
  3743                                  
  3744                                  ;-98   R2Type=SEGREG;
  3745                                  
  3746                                  @@testReg167:
  3747 000084B7 66B804000000             mov eax, 4
  3748 000084BD A2[3702]                 mov byte [R2Type], al
  3749                                  
  3750                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3751                                  
  3752 000084C0 68[A286]                 push testReg_16
  3753 000084C3 8D06[2D00]               lea  ax, [SymbolUpper]
  3754 000084C7 50                       push ax
  3755 000084C8 E8A016                   call eqstr
  3756 000084CB 83C404                   add  sp, 4
  3757 000084CE 08C0                     or  al, al
  3758 000084D0 0F840900                 je @@testReg168
  3759 000084D4 66B800000000             mov eax, 0
  3760 000084DA E99401                   jmp @@retn
  3761                                  
  3762                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3763                                  
  3764                                  @@testReg168:
  3765 000084DD 68[A586]                 push testReg_17
  3766 000084E0 8D06[2D00]               lea  ax, [SymbolUpper]
  3767 000084E4 50                       push ax
  3768 000084E5 E88316                   call eqstr
  3769 000084E8 83C404                   add  sp, 4
  3770 000084EB 08C0                     or  al, al
  3771 000084ED 0F840900                 je @@testReg169
  3772 000084F1 66B801000000             mov eax, 1
  3773 000084F7 E97701                   jmp @@retn
  3774                                  
  3775                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3776                                  
  3777                                  @@testReg169:
  3778 000084FA 68[A886]                 push testReg_18
  3779 000084FD 8D06[2D00]               lea  ax, [SymbolUpper]
  3780 00008501 50                       push ax
  3781 00008502 E86616                   call eqstr
  3782 00008505 83C404                   add  sp, 4
  3783 00008508 08C0                     or  al, al
  3784 0000850A 0F840900                 je @@testReg170
  3785 0000850E 66B802000000             mov eax, 2
  3786 00008514 E95A01                   jmp @@retn
  3787                                  
  3788                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3789                                  
  3790                                  @@testReg170:
  3791 00008517 68[AB86]                 push testReg_19
  3792 0000851A 8D06[2D00]               lea  ax, [SymbolUpper]
  3793 0000851E 50                       push ax
  3794 0000851F E84916                   call eqstr
  3795 00008522 83C404                   add  sp, 4
  3796 00008525 08C0                     or  al, al
  3797 00008527 0F840900                 je @@testReg171
  3798 0000852B 66B803000000             mov eax, 3
  3799 00008531 E93D01                   jmp @@retn
  3800                                  
  3801                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3802                                  
  3803                                  @@testReg171:
  3804 00008534 68[AE86]                 push testReg_20
  3805 00008537 8D06[2D00]               lea  ax, [SymbolUpper]
  3806 0000853B 50                       push ax
  3807 0000853C E82C16                   call eqstr
  3808 0000853F 83C404                   add  sp, 4
  3809 00008542 08C0                     or  al, al
  3810 00008544 0F840900                 je @@testReg172
  3811 00008548 66B804000000             mov eax, 4
  3812 0000854E E92001                   jmp @@retn
  3813                                  
  3814                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3815                                  
  3816                                  @@testReg172:
  3817 00008551 68[B186]                 push testReg_21
  3818 00008554 8D06[2D00]               lea  ax, [SymbolUpper]
  3819 00008558 50                       push ax
  3820 00008559 E80F16                   call eqstr
  3821 0000855C 83C404                   add  sp, 4
  3822 0000855F 08C0                     or  al, al
  3823 00008561 0F840900                 je @@testReg173
  3824 00008565 66B805000000             mov eax, 5
  3825 0000856B E90301                   jmp @@retn
  3826                                  
  3827                                  ;-105   R2Type=DWORD;                         
  3828                                  
  3829                                  @@testReg173:
  3830 0000856E 66B803000000             mov eax, 3
  3831 00008574 A2[3702]                 mov byte [R2Type], al
  3832                                  
  3833                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3834                                  
  3835 00008577 68[B486]                 push testReg_22
  3836 0000857A 8D06[2D00]               lea  ax, [SymbolUpper]
  3837 0000857E 50                       push ax
  3838 0000857F E8E915                   call eqstr
  3839 00008582 83C404                   add  sp, 4
  3840 00008585 08C0                     or  al, al
  3841 00008587 0F840900                 je @@testReg174
  3842 0000858B 66B800000000             mov eax, 0
  3843 00008591 E9DD00                   jmp @@retn
  3844                                  
  3845                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3846                                  
  3847                                  @@testReg174:
  3848 00008594 68[B886]                 push testReg_23
  3849 00008597 8D06[2D00]               lea  ax, [SymbolUpper]
  3850 0000859B 50                       push ax
  3851 0000859C E8CC15                   call eqstr
  3852 0000859F 83C404                   add  sp, 4
  3853 000085A2 08C0                     or  al, al
  3854 000085A4 0F840900                 je @@testReg175
  3855 000085A8 66B801000000             mov eax, 1
  3856 000085AE E9C000                   jmp @@retn
  3857                                  
  3858                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3859                                  
  3860                                  @@testReg175:
  3861 000085B1 68[BC86]                 push testReg_24
  3862 000085B4 8D06[2D00]               lea  ax, [SymbolUpper]
  3863 000085B8 50                       push ax
  3864 000085B9 E8AF15                   call eqstr
  3865 000085BC 83C404                   add  sp, 4
  3866 000085BF 08C0                     or  al, al
  3867 000085C1 0F840900                 je @@testReg176
  3868 000085C5 66B802000000             mov eax, 2
  3869 000085CB E9A300                   jmp @@retn
  3870                                  
  3871                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3872                                  
  3873                                  @@testReg176:
  3874 000085CE 68[C086]                 push testReg_25
  3875 000085D1 8D06[2D00]               lea  ax, [SymbolUpper]
  3876 000085D5 50                       push ax
  3877 000085D6 E89215                   call eqstr
  3878 000085D9 83C404                   add  sp, 4
  3879 000085DC 08C0                     or  al, al
  3880 000085DE 0F840900                 je @@testReg177
  3881 000085E2 66B803000000             mov eax, 3
  3882 000085E8 E98600                   jmp @@retn
  3883                                  
  3884                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3885                                  
  3886                                  @@testReg177:
  3887 000085EB 68[C486]                 push testReg_26
  3888 000085EE 8D06[2D00]               lea  ax, [SymbolUpper]
  3889 000085F2 50                       push ax
  3890 000085F3 E87515                   call eqstr
  3891 000085F6 83C404                   add  sp, 4
  3892 000085F9 08C0                     or  al, al
  3893 000085FB 0F840900                 je @@testReg178
  3894 000085FF 66B804000000             mov eax, 4
  3895 00008605 E96900                   jmp @@retn
  3896                                  
  3897                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3898                                  
  3899                                  @@testReg178:
  3900 00008608 68[C886]                 push testReg_27
  3901 0000860B 8D06[2D00]               lea  ax, [SymbolUpper]
  3902 0000860F 50                       push ax
  3903 00008610 E85815                   call eqstr
  3904 00008613 83C404                   add  sp, 4
  3905 00008616 08C0                     or  al, al
  3906 00008618 0F840900                 je @@testReg179
  3907 0000861C 66B805000000             mov eax, 5
  3908 00008622 E94C00                   jmp @@retn
  3909                                  
  3910                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3911                                  
  3912                                  @@testReg179:
  3913 00008625 68[CC86]                 push testReg_28
  3914 00008628 8D06[2D00]               lea  ax, [SymbolUpper]
  3915 0000862C 50                       push ax
  3916 0000862D E83B15                   call eqstr
  3917 00008630 83C404                   add  sp, 4
  3918 00008633 08C0                     or  al, al
  3919 00008635 0F840900                 je @@testReg180
  3920 00008639 66B806000000             mov eax, 6
  3921 0000863F E92F00                   jmp @@retn
  3922                                  
  3923                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3924                                  
  3925                                  @@testReg180:
  3926 00008642 68[D086]                 push testReg_29
  3927 00008645 8D06[2D00]               lea  ax, [SymbolUpper]
  3928 00008649 50                       push ax
  3929 0000864A E81E15                   call eqstr
  3930 0000864D 83C404                   add  sp, 4
  3931 00008650 08C0                     or  al, al
  3932 00008652 0F840900                 je @@testReg181
  3933 00008656 66B807000000             mov eax, 7
  3934 0000865C E91200                   jmp @@retn
  3935                                  
  3936                                  ;-114   R2Type=0; return 0;
  3937                                  
  3938                                  @@testReg181:
  3939 0000865F 66B800000000             mov eax, 0
  3940 00008665 A2[3702]                 mov byte [R2Type], al
  3941 00008668 66B800000000             mov eax, 0
  3942 0000866E E90000                   jmp @@retn
  3943                                  
  3944                                  ;-115 }
  3945                                  
  3946                                  @@retn:
  3947 00008671 C3                       ret
  3948                                  ; ENDP
  3949 00008672 414C00                  testReg_0 db "AL",0
  3950 00008675 434C00                  testReg_1 db "CL",0
  3951 00008678 444C00                  testReg_2 db "DL",0
  3952 0000867B 424C00                  testReg_3 db "BL",0
  3953 0000867E 414800                  testReg_4 db "AH",0
  3954 00008681 434800                  testReg_5 db "CH",0
  3955 00008684 444800                  testReg_6 db "DH",0
  3956 00008687 424800                  testReg_7 db "BH",0
  3957 0000868A 415800                  testReg_8 db "AX",0
  3958 0000868D 435800                  testReg_9 db "CX",0
  3959 00008690 445800                  testReg_10 db "DX",0
  3960 00008693 425800                  testReg_11 db "BX",0
  3961 00008696 535000                  testReg_12 db "SP",0
  3962 00008699 425000                  testReg_13 db "BP",0
  3963 0000869C 534900                  testReg_14 db "SI",0
  3964 0000869F 444900                  testReg_15 db "DI",0
  3965 000086A2 455300                  testReg_16 db "ES",0
  3966 000086A5 435300                  testReg_17 db "CS",0
  3967 000086A8 535300                  testReg_18 db "SS",0
  3968 000086AB 445300                  testReg_19 db "DS",0
  3969 000086AE 465300                  testReg_20 db "FS",0
  3970 000086B1 475300                  testReg_21 db "GS",0
  3971 000086B4 45415800                testReg_22 db "EAX",0
  3972 000086B8 45435800                testReg_23 db "ECX",0
  3973 000086BC 45445800                testReg_24 db "EDX",0
  3974 000086C0 45425800                testReg_25 db "EBX",0
  3975 000086C4 45535000                testReg_26 db "ESP",0
  3976 000086C8 45425000                testReg_27 db "EBP",0
  3977 000086CC 45534900                testReg_28 db "ESI",0
  3978 000086D0 45444900                testReg_29 db "EDI",0
  3979                                  ;Back to main program: AS.C
  3980                                  
  3981                                  ;-7 #include "OUTPUT.C"
  3982                                  
  3983                                  ;Use include file: OUTPUT.C
  3984                                  
  3985                                  ;-1 int printLine() { 
  3986                                  
  3987                                  
  3988                                  printLine:  ; *** PROC ***
  3989                                  
  3990                                  ;-2     int i; char c;
  3991                                  
  3992                                  
  3993                                  ;-3     prs("\n"); 
  3994                                  
  3995                                  ;Function : printLine, Number of local variables: 2
  3996                                  ;   # type sign width line used address name   list of local variables
  3997                                  ;  200 var sign word     2 NULL bp-2    i
  3998                                  ;  201 var sign byte     2 NULL bp-4    c;
  3999 000086D4 C8040000                 ENTER  4,0
  4000 000086D8 68[6987]                 push printLine_0
  4001 000086DB E80301                   call prs
  4002 000086DE 83C402                   add  sp, 2
  4003                                  
  4004                                  ;-4     printhex16(PCStart);
  4005                                  
  4006 000086E1 FF36[2B02]               push word [PCStart]
  4007 000086E5 E8EE01                   call printhex16
  4008 000086E8 83C402                   add  sp, 2
  4009                                  
  4010                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4011                                  
  4012 000086EB A1[4802]                 mov ax, [OpPrintIndex]
  4013 000086EE 83F800                   cmp ax, 0
  4014 000086F1 0F850C00                 jne @@printLine182
  4015 000086F5 68[6C87]                 push printLine_1
  4016 000086F8 E8E600                   call prs
  4017 000086FB 83C402                   add  sp, 2
  4018                                  
  4019                                  ;-6     else {
  4020                                  
  4021 000086FE E94F00                   jmp @@printLine183
  4022                                  @@printLine182:
  4023                                  
  4024                                  ;-7 //        prc(' ');
  4025                                  
  4026                                  
  4027                                  ;-8         i=0;
  4028                                  
  4029 00008701 66B800000000             mov eax, 0
  4030 00008707 8946FE                   mov word [bp-2], ax
  4031                                  
  4032                                  ;-9         do {
  4033                                  
  4034                                  @@printLine184:
  4035                                  
  4036                                  ;-10             c=OpPos[i];
  4037                                  
  4038 0000870A 8B5EFE                   mov bx, [bp-2]
  4039 0000870D 8A87[4302]               mov al, [OpPos + bx]
  4040 00008711 8846FC                   mov byte [bp-4], al
  4041                                  
  4042                                  ;-11             prc(' ');
  4043                                  
  4044 00008714 6A20                     push 32
  4045 00008716 E86700                   call prc
  4046 00008719 83C402                   add  sp, 2
  4047                                  
  4048                                  ;-12             printhex8a(c); 
  4049                                  
  4050 0000871C 8A46FC                   mov al, byte [bp-4]
  4051 0000871F B400                     mov ah, 0
  4052 00008721 50                       push ax
  4053 00008722 E85F01                   call printhex8a
  4054 00008725 83C402                   add  sp, 2
  4055                                  
  4056                                  ;-13             i++;
  4057                                  
  4058 00008728 FF46FE                   inc  word [bp-2]
  4059                                  
  4060                                  ;-14         } while (i < OpPrintIndex);
  4061                                  
  4062 0000872B 8B46FE                   mov ax, [bp-2]
  4063 0000872E 3B06[4802]               cmp ax, [OpPrintIndex]
  4064 00008732 0F8D0200                 jge @@printLine185
  4065 00008736 EBD2                     jmp @@printLine184
  4066                                  @@printLine185:
  4067                                  
  4068                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4069                                  
  4070                                  @@printLine186:
  4071 00008738 8B46FE                   mov ax, [bp-2]
  4072 0000873B 83F805                   cmp ax, 5
  4073 0000873E 0F8D0E00                 jge @@printLine187
  4074                                  
  4075                                  ;-16             prs("   ");
  4076                                  
  4077 00008742 68[7C87]                 push printLine_2
  4078 00008745 E89900                   call prs
  4079 00008748 83C402                   add  sp, 2
  4080                                  
  4081                                  ;-17             i++;
  4082                                  
  4083 0000874B FF46FE                   inc  word [bp-2]
  4084                                  
  4085                                  ;-18         }
  4086                                  
  4087                                  
  4088                                  ;-19     }
  4089                                  
  4090 0000874E EBE8                     jmp @@printLine186
  4091                                  @@printLine187:
  4092                                  
  4093                                  ;-20     prc(PrintRA);
  4094                                  
  4095                                  @@printLine183:
  4096 00008750 A0[4C02]                 mov al, byte [PrintRA]
  4097 00008753 B400                     mov ah, 0
  4098 00008755 50                       push ax
  4099 00008756 E82700                   call prc
  4100 00008759 83C402                   add  sp, 2
  4101                                  
  4102                                  ;-21     prscomment(InputBuf);
  4103                                  
  4104 0000875C 8D06[4E00]               lea  ax, [InputBuf]
  4105 00008760 50                       push ax
  4106 00008761 E84F00                   call prscomment
  4107 00008764 83C402                   add  sp, 2
  4108                                  
  4109                                  ;-22 }
  4110                                  
  4111                                  
  4112                                  ;-23 int prc(unsigned char c) {//print char 
  4113 00008767 C9                       LEAVE
  4114 00008768 C3                       ret
  4115                                  ; ENDP
  4116 00008769 5C6E00                  printLine_0 db "\n",0
  4117 0000876C 202020202020202020-     printLine_1 db "               ",0
  4118 00008775 20202020202000     
  4119 0000877C 20202000                printLine_2 db "   ",0
  4120                                  
  4121                                  prc:  ; *** PROC ***
  4122                                  
  4123                                  ;-24     if (LIST) { 
  4124                                  
  4125                                  ;Function : prc, Number of local variables: 1
  4126                                  ;   # type sign width line used address name   list of local variables
  4127                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4128 00008780 C8000000                 ENTER  0,0
  4129 00008784 A0[0D00]                 mov al, [LIST]
  4130 00008787 08C0                     or  al, al
  4131 00008789 0F841400                 je @@prc188
  4132                                  
  4133                                  ;-25         if ( _ c==10) {
  4134                                  
  4135 0000878D 807E040A                cmp byte [bp+4], 10
  4136 00008791 0F850600                 jne @@prc189
  4137                                  
  4138                                  ;-26             ax=13; 
  4139                                  
  4140 00008795 B80D00                   mov  ax, 13
  4141                                  
  4142                                  ;-27             writetty(); 
  4143                                  
  4144 00008798 E8C012                   call writetty
  4145                                  
  4146                                  ;-28             }
  4147                                  
  4148                                  
  4149                                  ;-29         al=c; 
  4150                                  
  4151                                  @@prc189:
  4152 0000879B 8A4604                   mov  al, [bp+4]
  4153                                  
  4154                                  ;-30         writetty(); 
  4155                                  
  4156 0000879E E8BA12                   call writetty
  4157                                  
  4158                                  ;-31         }
  4159                                  
  4160                                  
  4161                                  ;-32     fputcR(c,lst_fd); 
  4162                                  
  4163                                  @@prc188:
  4164 000087A1 FF36[1A02]               push word [lst_fd]
  4165 000087A5 8A4604                   mov al, byte [bp+4]
  4166 000087A8 B400                     mov ah, 0
  4167 000087AA 50                       push ax
  4168 000087AB E86D14                   call fputcR
  4169 000087AE 83C404                   add  sp, 4
  4170                                  
  4171                                  ;-33 }
  4172                                  
  4173                                  
  4174                                  ;-34 
  4175                                  
  4176                                  
  4177                                  ;-35 int prscomment(unsigned char *s) {
  4178 000087B1 C9                       LEAVE
  4179 000087B2 C3                       ret
  4180                                  ; ENDP
  4181                                  
  4182                                  prscomment:  ; *** PROC ***
  4183                                  
  4184                                  ;-36     unsigned char c;
  4185                                  
  4186                                  
  4187                                  ;-37     while (*s){
  4188                                  
  4189                                  ;Function : prscomment, Number of local variables: 2
  4190                                  ;   # type sign width line used address name   list of local variables
  4191                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4192                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4193 000087B3 C8020000                 ENTER  2,0
  4194                                  @@prscomment190:
  4195 000087B7 8B5E04                   mov bx, [bp+4]
  4196 000087BA 8A07                     mov al, [bx]
  4197 000087BC B400                     mov ah, 0
  4198 000087BE 08C0                     or  al, al
  4199 000087C0 0F841B00                 je @@prscomment191
  4200                                  
  4201                                  ;-38         c=*s;
  4202                                  
  4203 000087C4 8B5E04                   mov bx, [bp+4]
  4204 000087C7 8A07                     mov al, [bx]
  4205 000087C9 B400                     mov ah, 0
  4206 000087CB 8846FE                   mov byte [bp-2], al
  4207                                  
  4208                                  ;-39         prc(c);
  4209                                  
  4210 000087CE 8A46FE                   mov al, byte [bp-2]
  4211 000087D1 B400                     mov ah, 0
  4212 000087D3 50                       push ax
  4213 000087D4 E8A9FF                   call prc
  4214 000087D7 83C402                   add  sp, 2
  4215                                  
  4216                                  ;-40         s++;
  4217                                  
  4218 000087DA FF4604                   inc  word [bp+4]
  4219                                  
  4220                                  ;-41     }
  4221                                  
  4222                                  
  4223                                  ;-42 }
  4224                                  
  4225 000087DD EBD8                     jmp @@prscomment190
  4226                                  @@prscomment191:
  4227                                  
  4228                                  ;-43 int prs(unsigned char *s) {
  4229 000087DF C9                       LEAVE
  4230 000087E0 C3                       ret
  4231                                  ; ENDP
  4232                                  
  4233                                  prs:  ; *** PROC ***
  4234                                  
  4235                                  ;-44     unsigned char c; 
  4236                                  
  4237                                  
  4238                                  ;-45     int com; 
  4239                                  
  4240                                  
  4241                                  ;-46     com=0;
  4242                                  
  4243                                  ;Function : prs, Number of local variables: 3
  4244                                  ;   # type sign width line used address name   list of local variables
  4245                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4246                                  ;  201 var unsg byte    44 NULL bp-2    c
  4247                                  ;  202 var sign word    45 NULL bp-4    com;
  4248 000087E1 C8040000                 ENTER  4,0
  4249 000087E5 66B800000000             mov eax, 0
  4250 000087EB 8946FC                   mov word [bp-4], ax
  4251                                  
  4252                                  ;-47     while (*s) { 
  4253                                  
  4254                                  @@prs192:
  4255 000087EE 8B5E04                   mov bx, [bp+4]
  4256 000087F1 8A07                     mov al, [bx]
  4257 000087F3 B400                     mov ah, 0
  4258 000087F5 08C0                     or  al, al
  4259 000087F7 0F848700                 je @@prs193
  4260                                  
  4261                                  ;-48         c=*s; 
  4262                                  
  4263 000087FB 8B5E04                   mov bx, [bp+4]
  4264 000087FE 8A07                     mov al, [bx]
  4265 00008800 B400                     mov ah, 0
  4266 00008802 8846FE                   mov byte [bp-2], al
  4267                                  
  4268                                  ;-49         if (c==34) {
  4269                                  
  4270 00008805 8A46FE                   mov al, [bp-2]
  4271 00008808 3C22                     cmp al, 34
  4272 0000880A 0F851E00                 jne @@prs194
  4273                                  
  4274                                  ;-50             if (com) com=0; 
  4275                                  
  4276 0000880E 8B46FC                   mov ax, [bp-4]
  4277 00008811 08C0                     or  al, al
  4278 00008813 0F840C00                 je @@prs195
  4279 00008817 66B800000000             mov eax, 0
  4280 0000881D 8946FC                   mov word [bp-4], ax
  4281                                  
  4282                                  ;-51                 else com=1;  
  4283                                  
  4284 00008820 E90900                   jmp @@prs196
  4285                                  @@prs195:
  4286 00008823 66B801000000             mov eax, 1
  4287 00008829 8946FC                   mov word [bp-4], ax
  4288                                  
  4289                                  ;-52         }
  4290                                  
  4291                                  @@prs196:
  4292                                  
  4293                                  ;-53         if (c==92) { 
  4294                                  
  4295                                  @@prs194:
  4296 0000882C 8A46FE                   mov al, [bp-2]
  4297 0000882F 3C5C                     cmp al, 92
  4298 00008831 0F853B00                 jne @@prs197
  4299                                  
  4300                                  ;-54             if (com==0) { 
  4301                                  
  4302 00008835 8B46FC                   mov ax, [bp-4]
  4303 00008838 83F800                   cmp ax, 0
  4304 0000883B 0F853100                 jne @@prs198
  4305                                  
  4306                                  ;-55                 s++; 
  4307                                  
  4308 0000883F FF4604                   inc  word [bp+4]
  4309                                  
  4310                                  ;-56                 c=*s;
  4311                                  
  4312 00008842 8B5E04                   mov bx, [bp+4]
  4313 00008845 8A07                     mov al, [bx]
  4314 00008847 B400                     mov ah, 0
  4315 00008849 8846FE                   mov byte [bp-2], al
  4316                                  
  4317                                  ;-57                 if (c=='n') c=10; 
  4318                                  
  4319 0000884C 8A46FE                   mov al, [bp-2]
  4320 0000884F 3C6E                     cmp al, 110
  4321 00008851 0F850900                 jne @@prs199
  4322 00008855 66B80A000000             mov eax, 10
  4323 0000885B 8846FE                   mov byte [bp-2], al
  4324                                  
  4325                                  ;-58                 if (c=='t') c= 9; 
  4326                                  
  4327                                  @@prs199:
  4328 0000885E 8A46FE                   mov al, [bp-2]
  4329 00008861 3C74                     cmp al, 116
  4330 00008863 0F850900                 jne @@prs200
  4331 00008867 66B809000000             mov eax, 9
  4332 0000886D 8846FE                   mov byte [bp-2], al
  4333                                  
  4334                                  ;-59             } 
  4335                                  
  4336                                  @@prs200:
  4337                                  
  4338                                  ;-60         } 
  4339                                  
  4340                                  @@prs198:
  4341                                  
  4342                                  ;-61         prc(c); 
  4343                                  
  4344                                  @@prs197:
  4345 00008870 8A46FE                   mov al, byte [bp-2]
  4346 00008873 B400                     mov ah, 0
  4347 00008875 50                       push ax
  4348 00008876 E807FF                   call prc
  4349 00008879 83C402                   add  sp, 2
  4350                                  
  4351                                  ;-62         s++;  
  4352                                  
  4353 0000887C FF4604                   inc  word [bp+4]
  4354                                  
  4355                                  ;-63     }
  4356                                  
  4357                                  
  4358                                  ;-64 }
  4359                                  
  4360 0000887F E96CFF                   jmp @@prs192
  4361                                  @@prs193:
  4362                                  
  4363                                  ;-65 int printhex8a(unsigned char c) { 
  4364 00008882 C9                       LEAVE
  4365 00008883 C3                       ret
  4366                                  ; ENDP
  4367                                  
  4368                                  printhex8a:  ; *** PROC ***
  4369                                  
  4370                                  ;-66     unsigned char nib;
  4371                                  
  4372                                  
  4373                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4374                                  
  4375                                  ;Function : printhex8a, Number of local variables: 2
  4376                                  ;   # type sign width line used address name   list of local variables
  4377                                  ;  200 var unsg byte    65 NULL bp+4    c
  4378                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4379 00008884 C8020000                 ENTER  2,0
  4380 00008888 8A4604                   mov al, [bp+4]
  4381 0000888B C0E804                   shr al, 4
  4382 0000888E 8846FE                   mov byte [bp-2], al
  4383 00008891 8A46FE                   mov al, byte [bp-2]
  4384 00008894 B400                     mov ah, 0
  4385 00008896 50                       push ax
  4386 00008897 E81900                   call printhex4
  4387 0000889A 83C402                   add  sp, 2
  4388                                  
  4389                                  ;-68     nib = c & 15; printhex4(nib);                    
  4390                                  
  4391 0000889D 8A4604                   mov al, [bp+4]
  4392 000088A0 240F                     and al, 15
  4393 000088A2 8846FE                   mov byte [bp-2], al
  4394 000088A5 8A46FE                   mov al, byte [bp-2]
  4395 000088A8 B400                     mov ah, 0
  4396 000088AA 50                       push ax
  4397 000088AB E80500                   call printhex4
  4398 000088AE 83C402                   add  sp, 2
  4399                                  
  4400                                  ;-69 } 
  4401                                  
  4402                                  
  4403                                  ;-70 int printhex4(unsigned char c) {
  4404 000088B1 C9                       LEAVE
  4405 000088B2 C3                       ret
  4406                                  ; ENDP
  4407                                  
  4408                                  printhex4:  ; *** PROC ***
  4409                                  
  4410                                  ;-71     c += 48; 
  4411                                  
  4412                                  ;Function : printhex4, Number of local variables: 1
  4413                                  ;   # type sign width line used address name   list of local variables
  4414                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4415 000088B3 C8000000                 ENTER  0,0
  4416 000088B7 80460430                 add  byte [bp+4], 48
  4417                                  
  4418                                  ;-72     if (c > 57) c += 7; 
  4419                                  
  4420 000088BB 8A4604                   mov al, [bp+4]
  4421 000088BE 3C39                     cmp al, 57
  4422 000088C0 0F8E0400                 jle @@printhex4201
  4423 000088C4 80460407                 add  byte [bp+4], 7
  4424                                  
  4425                                  ;-73     prc(c);      
  4426                                  
  4427                                  @@printhex4201:
  4428 000088C8 8A4604                   mov al, byte [bp+4]
  4429 000088CB B400                     mov ah, 0
  4430 000088CD 50                       push ax
  4431 000088CE E8AFFE                   call prc
  4432 000088D1 83C402                   add  sp, 2
  4433                                  
  4434                                  ;-74 }
  4435                                  
  4436                                  
  4437                                  ;-75 int printhex16(unsigned int i) {
  4438 000088D4 C9                       LEAVE
  4439 000088D5 C3                       ret
  4440                                  ; ENDP
  4441                                  
  4442                                  printhex16:  ; *** PROC ***
  4443                                  
  4444                                  ;-76     unsigned int half;
  4445                                  
  4446                                  
  4447                                  ;-77     half = i >>  8; printhex8a(half); 
  4448                                  
  4449                                  ;Function : printhex16, Number of local variables: 2
  4450                                  ;   # type sign width line used address name   list of local variables
  4451                                  ;  200 var unsg word    75 NULL bp+4    i
  4452                                  ;  201 var unsg word    76 NULL bp-2    half;
  4453 000088D6 C8020000                 ENTER  2,0
  4454 000088DA 8B4604                   mov ax, [bp+4]
  4455 000088DD C1E808                   shr ax, 8
  4456 000088E0 8946FE                   mov word [bp-2], ax
  4457 000088E3 FF76FE                   push word [bp-2]
  4458 000088E6 E89BFF                   call printhex8a
  4459 000088E9 83C402                   add  sp, 2
  4460                                  
  4461                                  ;-78     half = i & 255; printhex8a(half);
  4462                                  
  4463 000088EC 8B4604                   mov ax, [bp+4]
  4464 000088EF 25FF00                   and ax, 255
  4465 000088F2 8946FE                   mov word [bp-2], ax
  4466 000088F5 FF76FE                   push word [bp-2]
  4467 000088F8 E889FF                   call printhex8a
  4468 000088FB 83C402                   add  sp, 2
  4469                                  
  4470                                  ;-79 }
  4471                                  
  4472                                  
  4473                                  ;-80 int printIntU(unsigned int n) { 
  4474 000088FE C9                       LEAVE
  4475 000088FF C3                       ret
  4476                                  ; ENDP
  4477                                  
  4478                                  printIntU:  ; *** PROC ***
  4479                                  
  4480                                  ;-81     unsigned int e;
  4481                                  
  4482                                  
  4483                                  ;-82     if ( _ n >= 10) {  
  4484                                  
  4485                                  ;Function : printIntU, Number of local variables: 2
  4486                                  ;   # type sign width line used address name   list of local variables
  4487                                  ;  200 var unsg word    80 NULL bp+4    n
  4488                                  ;  201 var unsg word    81 NULL bp-2    e;
  4489 00008900 C8020000                 ENTER  2,0
  4490 00008904 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4491 00008908 0F821700                 jb  @@printIntU202
  4492                                  
  4493                                  ;-83         e=n/10; //DIV
  4494                                  
  4495 0000890C 8B4604                   mov ax, [bp+4]
  4496 0000890F BB0A00                   mov bx, 10
  4497 00008912 BA0000                   mov dx, 0
  4498 00008915 F7F3                     div bx
  4499 00008917 8946FE                   mov word [bp-2], ax
  4500                                  
  4501                                  ;-84         printIntU(e); 
  4502                                  
  4503 0000891A FF76FE                   push word [bp-2]
  4504 0000891D E8E0FF                   call printIntU
  4505 00008920 83C402                   add  sp, 2
  4506                                  
  4507                                  ;-85     }
  4508                                  
  4509                                  
  4510                                  ;-86     n = n % 10; //unsigned mod
  4511                                  
  4512                                  @@printIntU202:
  4513 00008923 8B4604                   mov ax, [bp+4]
  4514 00008926 BB0A00                   mov bx, 10
  4515 00008929 BA0000                   mov dx, 0
  4516 0000892C F7F3                     div bx
  4517 0000892E 89D0                     mov ax, dx
  4518 00008930 894604                   mov word [bp+4], ax
  4519                                  
  4520                                  ;-87     n += '0'; 
  4521                                  
  4522 00008933 83460430                 add  word [bp+4], 48
  4523                                  
  4524                                  ;-88     prc(n);
  4525                                  
  4526 00008937 FF7604                   push word [bp+4]
  4527 0000893A E843FE                   call prc
  4528 0000893D 83C402                   add  sp, 2
  4529                                  
  4530                                  ;-89 }
  4531                                  
  4532                                  
  4533                                  ;-90 
  4534                                  
  4535                                  
  4536                                  ;-91 int error1(char *s) { 
  4537 00008940 C9                       LEAVE
  4538 00008941 C3                       ret
  4539                                  ; ENDP
  4540                                  
  4541                                  error1:  ; *** PROC ***
  4542                                  
  4543                                  ;-92     LIST=1; 
  4544                                  
  4545                                  ;Function : error1, Number of local variables: 1
  4546                                  ;   # type sign width line used address name   list of local variables
  4547                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4548 00008942 C8000000                 ENTER  0,0
  4549 00008946 66B801000000             mov eax, 1
  4550 0000894C A2[0D00]                 mov byte [LIST], al
  4551                                  
  4552                                  ;-93     ErrorCount++;
  4553                                  
  4554 0000894F FF06[2002]               inc  word [ErrorCount]
  4555                                  
  4556                                  ;-94     prs("\n;***** next line ERROR: "); 
  4557                                  
  4558 00008953 68[7B89]                 push error1_0
  4559 00008956 E888FE                   call prs
  4560 00008959 83C402                   add  sp, 2
  4561                                  
  4562                                  ;-95     prs(s);
  4563                                  
  4564 0000895C FF7604                   push word [bp+4]
  4565 0000895F E87FFE                   call prs
  4566 00008962 83C402                   add  sp, 2
  4567                                  
  4568                                  ;-96     prs(", Symbol: "); 
  4569                                  
  4570 00008965 68[9689]                 push error1_1
  4571 00008968 E876FE                   call prs
  4572 0000896B 83C402                   add  sp, 2
  4573                                  
  4574                                  ;-97     prs(Symbol);
  4575                                  
  4576 0000896E 8D06[0E00]               lea  ax, [Symbol]
  4577 00008972 50                       push ax
  4578 00008973 E86BFE                   call prs
  4579 00008976 83C402                   add  sp, 2
  4580                                  
  4581                                  ;-98 }
  4582                                  
  4583                                  
  4584                                  ;-99 int errorexit(char *s) { 
  4585 00008979 C9                       LEAVE
  4586 0000897A C3                       ret
  4587                                  ; ENDP
  4588 0000897B 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4589 00008984 6E657874206C696E65-
  4590 0000898D 204552524F523A2000 
  4591 00008996 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4592 0000899F 2000               
  4593                                  
  4594                                  errorexit:  ; *** PROC ***
  4595                                  
  4596                                  ;-100     error1(s); 
  4597                                  
  4598                                  ;Function : errorexit, Number of local variables: 1
  4599                                  ;   # type sign width line used address name   list of local variables
  4600                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4601 000089A1 C8000000                 ENTER  0,0
  4602 000089A5 FF7604                   push word [bp+4]
  4603 000089A8 E897FF                   call error1
  4604 000089AB 83C402                   add  sp, 2
  4605                                  
  4606                                  ;-101     end1(1);
  4607                                  
  4608 000089AE 6A01                     push 1
  4609 000089B0 E81406                   call end1
  4610 000089B3 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-102 }
  4613                                  
  4614                                  
  4615                                  ;-103 int allowederror() {error1("not allowed here"); }
  4616 000089B6 C9                       LEAVE
  4617 000089B7 C3                       ret
  4618                                  ; ENDP
  4619                                  
  4620                                  allowederror:  ; *** PROC ***
  4621 000089B8 68[C289]                 push allowederror_0
  4622 000089BB E884FF                   call error1
  4623 000089BE 83C402                   add  sp, 2
  4624                                  
  4625                                  ;-104 int addrerror()    {error1("address missing");} 
  4626                                  
  4627 000089C1 C3                       ret
  4628                                  ; ENDP
  4629 000089C2 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4630 000089CB 6564206865726500   
  4631                                  
  4632                                  addrerror:  ; *** PROC ***
  4633 000089D3 68[DD89]                 push addrerror_0
  4634 000089D6 E869FF                   call error1
  4635 000089D9 83C402                   add  sp, 2
  4636                                  
  4637                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4638                                  
  4639 000089DC C3                       ret
  4640                                  ; ENDP
  4641 000089DD 61646472657373206D-     addrerror_0 db "address missing",0
  4642 000089E6 697373696E6700     
  4643                                  
  4644                                  immeerror:  ; *** PROC ***
  4645 000089ED 68[F789]                 push immeerror_0
  4646 000089F0 E84FFF                   call error1
  4647 000089F3 83C402                   add  sp, 2
  4648                                  
  4649                                  ;-106 int implerror()    {error1("not implemented");}
  4650                                  
  4651 000089F6 C3                       ret
  4652                                  ; ENDP
  4653 000089F7 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4654 00008A00 206E6F7420616C6C6F-
  4655 00008A09 776564206865726500 
  4656                                  
  4657                                  implerror:  ; *** PROC ***
  4658 00008A12 68[1C8A]                 push implerror_0
  4659 00008A15 E82AFF                   call error1
  4660 00008A18 83C402                   add  sp, 2
  4661                                  
  4662                                  ;-107 int indexerror()   {error1("invalid index register");}
  4663                                  
  4664 00008A1B C3                       ret
  4665                                  ; ENDP
  4666 00008A1C 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4667 00008A25 6D656E74656400     
  4668                                  
  4669                                  indexerror:  ; *** PROC ***
  4670 00008A2C 68[368A]                 push indexerror_0
  4671 00008A2F E810FF                   call error1
  4672 00008A32 83C402                   add  sp, 2
  4673                                  
  4674                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4675                                  
  4676 00008A35 C3                       ret
  4677                                  ; ENDP
  4678 00008A36 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4679 00008A3F 6E6465782072656769-
  4680 00008A48 7374657200         
  4681                                  
  4682                                  invaloperror:  ; *** PROC ***
  4683 00008A4D 68[578A]                 push invaloperror_0
  4684 00008A50 E8EFFE                   call error1
  4685 00008A53 83C402                   add  sp, 2
  4686                                  
  4687                                  ;-109 int numbererror()  {error1("number expected");}
  4688                                  
  4689 00008A56 C3                       ret
  4690                                  ; ENDP
  4691 00008A57 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4692 00008A60 72206E6F206F706572-
  4693 00008A69 616E647300         
  4694                                  
  4695                                  numbererror:  ; *** PROC ***
  4696 00008A6E 68[788A]                 push numbererror_0
  4697 00008A71 E8CEFE                   call error1
  4698 00008A74 83C402                   add  sp, 2
  4699                                  
  4700                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4701                                  
  4702 00008A77 C3                       ret
  4703                                  ; ENDP
  4704 00008A78 6E756D626572206578-     numbererror_0 db "number expected",0
  4705 00008A81 70656374656400     
  4706                                  
  4707                                  regmemerror:  ; *** PROC ***
  4708 00008A88 68[928A]                 push regmemerror_0
  4709 00008A8B E8B4FE                   call error1
  4710 00008A8E 83C402                   add  sp, 2
  4711                                  
  4712                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4713                                  
  4714 00008A91 C3                       ret
  4715                                  ; ENDP
  4716 00008A92 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4717 00008A9B 73746572206F72206D-
  4718 00008AA4 656D6F727920616C6C-
  4719 00008AAD 6F77656400         
  4720                                  
  4721                                  reg16error:  ; *** PROC ***
  4722 00008AB2 68[BC8A]                 push reg16error_0
  4723 00008AB5 E88AFE                   call error1
  4724 00008AB8 83C402                   add  sp, 2
  4725                                  
  4726                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4727                                  
  4728 00008ABB C3                       ret
  4729                                  ; ENDP
  4730 00008ABC 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4731 00008AC5 362C206E6F20736567-
  4732 00008ACE 72656720616C6C6F77-
  4733 00008AD7 656400             
  4734                                  
  4735                                  segregerror:  ; *** PROC ***
  4736 00008ADA 68[E48A]                 push segregerror_0
  4737 00008ADD E862FE                   call error1
  4738 00008AE0 83C402                   add  sp, 2
  4739                                  
  4740                                  ;-113 int syntaxerror()  {error1("syntax");}
  4741                                  
  4742 00008AE3 C3                       ret
  4743                                  ; ENDP
  4744 00008AE4 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4745 00008AED 65676973746572206E-
  4746 00008AF6 6F7420616C6C6F7765-
  4747 00008AFF 6400               
  4748                                  
  4749                                  syntaxerror:  ; *** PROC ***
  4750 00008B01 68[0B8B]                 push syntaxerror_0
  4751 00008B04 E83BFE                   call error1
  4752 00008B07 83C402                   add  sp, 2
  4753                                  
  4754                                  ;-114          
  4755                                  
  4756                                  
  4757                                  ;-115 int addrexit()     {errorexit("illegal address");}   
  4758                                  
  4759 00008B0A C3                       ret
  4760                                  ; ENDP
  4761 00008B0B 73796E74617800          syntaxerror_0 db "syntax",0
  4762                                  
  4763                                  addrexit:  ; *** PROC ***
  4764 00008B12 68[1C8B]                 push addrexit_0
  4765 00008B15 E889FE                   call errorexit
  4766 00008B18 83C402                   add  sp, 2
  4767                                  
  4768                                  ;-116 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  4769                                  
  4770 00008B1B C3                       ret
  4771                                  ; ENDP
  4772 00008B1C 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4773 00008B25 64647265737300     
  4774                                  
  4775                                  dataexit:  ; *** PROC ***
  4776 00008B2C 68[368B]                 push dataexit_0
  4777 00008B2F E86FFE                   call errorexit
  4778 00008B32 83C402                   add  sp, 2
  4779                                  
  4780                                  ;-117 int internexit()   {errorexit("intern compiler error");}
  4781                                  
  4782 00008B35 C3                       ret
  4783                                  ; ENDP
  4784 00008B36 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  4785 00008B3F 6F7220524553422C57-
  4786 00008B48 2C4420657870656374-
  4787 00008B51 656400             
  4788                                  
  4789                                  internexit:  ; *** PROC ***
  4790 00008B54 68[5E8B]                 push internexit_0
  4791 00008B57 E847FE                   call errorexit
  4792 00008B5A 83C402                   add  sp, 2
  4793 00008B5D C3                       ret
  4794                                  ; ENDP
  4795 00008B5E 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4796 00008B67 6D70696C6572206572-
  4797 00008B70 726F7200           
  4798                                  ;Back to main program: AS.C
  4799                                  
  4800                                  ;-8 #include "MAIN.C"
  4801                                  
  4802                                  ;Use include file: MAIN.C
  4803                                  
  4804                                  ;-1 int main() {
  4805                                  
  4806                                  
  4807                                  main:  ; *** PROC ***
  4808                                  
  4809                                  ;-2     getarg(); 
  4810                                  
  4811 00008B74 E80D00                   call getarg
  4812                                  
  4813                                  ;-3     parse(); 
  4814                                  
  4815 00008B77 E8D5ED                   call parse
  4816                                  
  4817                                  ;-4     fixJmpCall();
  4818                                  
  4819 00008B7A E85F02                   call fixJmpCall
  4820                                  
  4821                                  ;-5     epilog(); 
  4822                                  
  4823 00008B7D E84B03                   call epilog
  4824                                  
  4825                                  ;-6     end1();
  4826                                  
  4827 00008B80 E84404                   call end1
  4828                                  
  4829                                  ;-7 }
  4830                                  
  4831                                  
  4832                                  ;-8 
  4833                                  
  4834                                  
  4835                                  ;-9 int getarg() { 
  4836                                  
  4837 00008B83 C3                       ret
  4838                                  ; ENDP
  4839                                  
  4840                                  getarg:  ; *** PROC ***
  4841                                  
  4842                                  ;-10     int arglen1; int i; char *c;
  4843                                  
  4844                                  
  4845                                  ;-11     arglen1=*arglen;
  4846                                  
  4847                                  ;Function : getarg, Number of local variables: 3
  4848                                  ;   # type sign width line used address name   list of local variables
  4849                                  ;  200 var sign word    10 NULL bp-2    arglen1
  4850                                  ;  201 var sign word    10 NULL bp-4    i
  4851                                  ;  202 ptr sign byte    10 NULL bp-6    c;
  4852 00008B84 C8060000                 ENTER  6,0
  4853 00008B88 8B1E[8170]               mov bx, [arglen]
  4854 00008B8C 8A07                     mov al, [bx]
  4855 00008B8E B400                     mov ah, 0
  4856 00008B90 8946FE                   mov word [bp-2], ax
  4857                                  
  4858                                  ;-12     if (arglen1==0) {
  4859                                  
  4860 00008B93 8B46FE                   mov ax, [bp-2]
  4861 00008B96 83F800                   cmp ax, 0
  4862 00008B99 0F851C00                 jne @@getarg203
  4863                                  
  4864                                  ;-13         cputs(Version1);
  4865                                  
  4866 00008B9D 8D06[0300]               lea  ax, [Version1]
  4867 00008BA1 50                       push ax
  4868 00008BA2 E8BE0E                   call cputs
  4869 00008BA5 83C402                   add  sp, 2
  4870                                  
  4871                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4872                                  
  4873 00008BA8 68[498D]                 push getarg_0
  4874 00008BAB E8B50E                   call cputs
  4875 00008BAE 83C402                   add  sp, 2
  4876                                  
  4877                                  ;-15         exitR(3);
  4878                                  
  4879 00008BB1 6A03                     push 3
  4880 00008BB3 E88810                   call exitR
  4881 00008BB6 83C402                   add  sp, 2
  4882                                  
  4883                                  ;-16     }
  4884                                  
  4885                                  
  4886                                  ;-17     i=arglen1+129; 
  4887                                  
  4888                                  @@getarg203:
  4889 00008BB9 8B46FE                   mov ax, [bp-2]
  4890 00008BBC 058100                   add ax, 129
  4891 00008BBF 8946FC                   mov word [bp-4], ax
  4892                                  
  4893                                  ;-18     *i=0;  
  4894                                  
  4895 00008BC2 66B800000000             mov eax, 0
  4896 00008BC8 8B5EFC                   mov  bx, [bp-4]
  4897 00008BCB 8907                     mov  [bx], ax
  4898                                  
  4899                                  ;-19     arglen1--;
  4900                                  
  4901 00008BCD FF4EFE                   dec  word [bp-2]
  4902                                  
  4903                                  ;-20     toupper(argv);
  4904                                  
  4905 00008BD0 FF36[8370]               push word [argv]
  4906 00008BD4 E8BA0E                   call toupper
  4907 00008BD7 83C402                   add  sp, 2
  4908                                  
  4909                                  ;-21   
  4910                                  
  4911                                  
  4912                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  4913                                  
  4914 00008BDA FF36[8370]               push word [argv]
  4915 00008BDE 8D06[4F01]               lea  ax, [namein]
  4916 00008BE2 50                       push ax
  4917 00008BE3 E8190F                   call strcpy
  4918 00008BE6 83C404                   add  sp, 4
  4919 00008BE9 68[6E8D]                 push getarg_1
  4920 00008BEC 8D06[4F01]               lea  ax, [namein]
  4921 00008BF0 50                       push ax
  4922 00008BF1 E8CC0F                   call strcat1
  4923 00008BF4 83C404                   add  sp, 4
  4924                                  
  4925                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  4926                                  
  4927 00008BF7 FF36[8370]               push word [argv]
  4928 00008BFB 8D06[9201]               lea  ax, [namelst]
  4929 00008BFF 50                       push ax
  4930 00008C00 E8FC0E                   call strcpy
  4931 00008C03 83C404                   add  sp, 4
  4932 00008C06 68[718D]                 push getarg_2
  4933 00008C09 8D06[9201]               lea  ax, [namelst]
  4934 00008C0D 50                       push ax
  4935 00008C0E E8AF0F                   call strcat1
  4936 00008C11 83C404                   add  sp, 4
  4937                                  
  4938                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  4939                                  
  4940 00008C14 FF36[8370]               push word [argv]
  4941 00008C18 8D06[D501]               lea  ax, [namebin]
  4942 00008C1C 50                       push ax
  4943 00008C1D E8DF0E                   call strcpy
  4944 00008C20 83C404                   add  sp, 4
  4945 00008C23 68[768D]                 push getarg_3
  4946 00008C26 8D06[D501]               lea  ax, [namebin]
  4947 00008C2A 50                       push ax
  4948 00008C2B E8920F                   call strcat1
  4949 00008C2E 83C404                   add  sp, 4
  4950                                  
  4951                                  ;-25 
  4952                                  
  4953                                  
  4954                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4955                                  
  4956 00008C31 66B801000000             mov eax, 1
  4957 00008C37 A2[0D00]                 mov byte [LIST], al
  4958 00008C3A 66B800000000             mov eax, 0
  4959 00008C40 A3[1E02]                 mov word [DOS_ERR], ax
  4960 00008C43 66B800000000             mov eax, 0
  4961 00008C49 A3[2502]                 mov word [PC], ax
  4962 00008C4C 66B800000000             mov eax, 0
  4963 00008C52 A3[2002]                 mov word [ErrorCount], ax
  4964                                  
  4965                                  ;-27   
  4966                                  
  4967                                  
  4968                                  ;-28     asm_fd=openR (namein);
  4969                                  
  4970 00008C55 8D06[4F01]               lea  ax, [namein]
  4971 00008C59 50                       push ax
  4972 00008C5A E8880F                   call openR
  4973 00008C5D 83C402                   add  sp, 2
  4974 00008C60 A3[1802]                 mov word [asm_fd], ax
  4975                                  
  4976                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4977                                  
  4978 00008C63 A1[1E02]                 mov ax, [DOS_ERR]
  4979 00008C66 08C0                     or  al, al
  4980 00008C68 0F841C00                 je @@getarg204
  4981 00008C6C 68[7B8D]                 push getarg_4
  4982 00008C6F E8F10D                   call cputs
  4983 00008C72 83C402                   add  sp, 2
  4984 00008C75 8D06[4F01]               lea  ax, [namein]
  4985 00008C79 50                       push ax
  4986 00008C7A E8E60D                   call cputs
  4987 00008C7D 83C402                   add  sp, 2
  4988 00008C80 6A01                     push 1
  4989 00008C82 E8B90F                   call exitR
  4990 00008C85 83C402                   add  sp, 2
  4991                                  
  4992                                  ;-30     lst_fd=creatR(namelst);
  4993                                  
  4994                                  @@getarg204:
  4995 00008C88 8D06[9201]               lea  ax, [namelst]
  4996 00008C8C 50                       push ax
  4997 00008C8D E8640F                   call creatR
  4998 00008C90 83C402                   add  sp, 2
  4999 00008C93 A3[1A02]                 mov word [lst_fd], ax
  5000                                  
  5001                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5002                                  
  5003 00008C96 A1[1E02]                 mov ax, [DOS_ERR]
  5004 00008C99 08C0                     or  al, al
  5005 00008C9B 0F841C00                 je @@getarg205
  5006 00008C9F 68[918D]                 push getarg_5
  5007 00008CA2 E8BE0D                   call cputs
  5008 00008CA5 83C402                   add  sp, 2
  5009 00008CA8 8D06[9201]               lea  ax, [namelst]
  5010 00008CAC 50                       push ax
  5011 00008CAD E8B30D                   call cputs
  5012 00008CB0 83C402                   add  sp, 2
  5013 00008CB3 6A02                     push 2
  5014 00008CB5 E8860F                   call exitR
  5015 00008CB8 83C402                   add  sp, 2
  5016                                  
  5017                                  ;-32     bin_fd=creatR(namebin);
  5018                                  
  5019                                  @@getarg205:
  5020 00008CBB 8D06[D501]               lea  ax, [namebin]
  5021 00008CBF 50                       push ax
  5022 00008CC0 E8310F                   call creatR
  5023 00008CC3 83C402                   add  sp, 2
  5024 00008CC6 A3[1C02]                 mov word [bin_fd], ax
  5025                                  
  5026                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5027                                  
  5028 00008CC9 A1[1E02]                 mov ax, [DOS_ERR]
  5029 00008CCC 08C0                     or  al, al
  5030 00008CCE 0F841C00                 je @@getarg206
  5031 00008CD2 68[A88D]                 push getarg_6
  5032 00008CD5 E88B0D                   call cputs
  5033 00008CD8 83C402                   add  sp, 2
  5034 00008CDB 8D06[D501]               lea  ax, [namebin]
  5035 00008CDF 50                       push ax
  5036 00008CE0 E8800D                   call cputs
  5037 00008CE3 83C402                   add  sp, 2
  5038 00008CE6 6A02                     push 2
  5039 00008CE8 E8530F                   call exitR
  5040 00008CEB 83C402                   add  sp, 2
  5041                                  
  5042                                  ;-34   
  5043                                  
  5044                                  
  5045                                  ;-35     prs(";"); 
  5046                                  
  5047                                  @@getarg206:
  5048 00008CEE 68[BE8D]                 push getarg_7
  5049 00008CF1 E8EDFA                   call prs
  5050 00008CF4 83C402                   add  sp, 2
  5051                                  
  5052                                  ;-36     prs(Version1);
  5053                                  
  5054 00008CF7 8D06[0300]               lea  ax, [Version1]
  5055 00008CFB 50                       push ax
  5056 00008CFC E8E2FA                   call prs
  5057 00008CFF 83C402                   add  sp, 2
  5058                                  
  5059                                  ;-37     prs(", Source: "); prs(namein);  
  5060                                  
  5061 00008D02 68[C08D]                 push getarg_8
  5062 00008D05 E8D9FA                   call prs
  5063 00008D08 83C402                   add  sp, 2
  5064 00008D0B 8D06[4F01]               lea  ax, [namein]
  5065 00008D0F 50                       push ax
  5066 00008D10 E8CEFA                   call prs
  5067 00008D13 83C402                   add  sp, 2
  5068                                  
  5069                                  ;-38     prs(", Output: "); prs(namelst);
  5070                                  
  5071 00008D16 68[CB8D]                 push getarg_9
  5072 00008D19 E8C5FA                   call prs
  5073 00008D1C 83C402                   add  sp, 2
  5074 00008D1F 8D06[9201]               lea  ax, [namelst]
  5075 00008D23 50                       push ax
  5076 00008D24 E8BAFA                   call prs
  5077 00008D27 83C402                   add  sp, 2
  5078                                  
  5079                                  ;-39     prs(", "); prs(namebin);
  5080                                  
  5081 00008D2A 68[D68D]                 push getarg_10
  5082 00008D2D E8B1FA                   call prs
  5083 00008D30 83C402                   add  sp, 2
  5084 00008D33 8D06[D501]               lea  ax, [namebin]
  5085 00008D37 50                       push ax
  5086 00008D38 E8A6FA                   call prs
  5087 00008D3B 83C402                   add  sp, 2
  5088                                  
  5089                                  ;-40     prs("\n");
  5090                                  
  5091 00008D3E 68[D98D]                 push getarg_11
  5092 00008D41 E89DFA                   call prs
  5093 00008D44 83C402                   add  sp, 2
  5094                                  
  5095                                  ;-41 }
  5096                                  
  5097                                  
  5098                                  ;-42 
  5099                                  
  5100                                  
  5101                                  ;-43 int fixJmpCall() {
  5102 00008D47 C9                       LEAVE
  5103 00008D48 C3                       ret
  5104                                  ; ENDP
  5105 00008D49 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5106 00008D52 41532E434F4D206669-
  5107 00008D5B 6C656E616D65205B77-
  5108 00008D64 2F6F202E535D203A20-
  5109 00008D6D 00                 
  5110 00008D6E 2E5300                  getarg_1 db ".S",0
  5111 00008D71 2E4C535400              getarg_2 db ".LST",0
  5112 00008D76 2E434F4D00              getarg_3 db ".COM",0
  5113 00008D7B 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5114 00008D84 6C65206D697373696E-
  5115 00008D8D 673A2000           
  5116 00008D91 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5117 00008D9A 206E6F742063726561-
  5118 00008DA3 74653A2000         
  5119 00008DA8 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5120 00008DB1 6E6F74206372656174-
  5121 00008DBA 653A2000           
  5122 00008DBE 3B00                    getarg_7 db ";",0
  5123 00008DC0 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5124 00008DC9 2000               
  5125 00008DCB 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5126 00008DD4 2000               
  5127 00008DD6 2C2000                  getarg_10 db ", ",0
  5128 00008DD9 5C6E00                  getarg_11 db "\n",0
  5129                                  
  5130                                  fixJmpCall:  ; *** PROC ***
  5131                                  
  5132                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5133                                  
  5134                                  
  5135                                  ;-45     i=1;     
  5136                                  
  5137                                  ;Function : fixJmpCall, Number of local variables: 5
  5138                                  ;   # type sign width line used address name   list of local variables
  5139                                  ;  200 var sign word    44 NULL bp-2    i
  5140                                  ;  201 var unsg word    44 NULL bp-4    hex
  5141                                  ;  202 ptr sign byte    44 NULL bp-6    p
  5142                                  ;  203 var sign word    44 NULL bp-8    Ix
  5143                                  ;  204 var sign byte    44 NULL bp-10    c;
  5144 00008DDC C80A0000                 ENTER  10,0
  5145 00008DE0 66B801000000             mov eax, 1
  5146 00008DE6 8946FE                   mov word [bp-2], ax
  5147                                  
  5148                                  ;-46     prs("\n;END open jmp/call: "); 
  5149                                  
  5150 00008DE9 68[A48E]                 push fixJmpCall_0
  5151 00008DEC E8F2F9                   call prs
  5152 00008DEF 83C402                   add  sp, 2
  5153                                  
  5154                                  ;-47     printIntU(JmpCallMaxIx);      
  5155                                  
  5156 00008DF2 FF36[5D22]               push word [JmpCallMaxIx]
  5157 00008DF6 E807FB                   call printIntU
  5158 00008DF9 83C402                   add  sp, 2
  5159                                  
  5160                                  ;-48     p = &JmpCallNames;   
  5161                                  
  5162 00008DFC B8[A316]                 mov ax, JmpCallNames
  5163 00008DFF 8946FA                   mov word [bp-6], ax
  5164                                  
  5165                                  ;-49     while (i <= JmpCallMaxIx) {
  5166                                  
  5167                                  @@fixJmpCall207:
  5168 00008E02 8B46FE                   mov ax, [bp-2]
  5169 00008E05 3B06[5D22]               cmp ax, [JmpCallMaxIx]
  5170 00008E09 0F8F9500                 jg  @@fixJmpCall208
  5171                                  
  5172                                  ;-50         strcpy(Symbol, p);
  5173                                  
  5174 00008E0D FF76FA                   push word [bp-6]
  5175 00008E10 8D06[0E00]               lea  ax, [Symbol]
  5176 00008E14 50                       push ax
  5177 00008E15 E8E70C                   call strcpy
  5178 00008E18 83C404                   add  sp, 4
  5179                                  
  5180                                  ;-51         p = strlen(Symbol) + p;
  5181                                  
  5182 00008E1B 8D06[0E00]               lea  ax, [Symbol]
  5183 00008E1F 50                       push ax
  5184 00008E20 E8B10C                   call strlen
  5185 00008E23 83C402                   add  sp, 2
  5186 00008E26 0346FA                   add ax, [bp-6]
  5187 00008E29 8946FA                   mov word [bp-6], ax
  5188                                  
  5189                                  ;-52         p++;
  5190                                  
  5191 00008E2C FF46FA                   inc  word [bp-6]
  5192                                  
  5193                                  ;-53 //        prs(Symbol);
  5194                                  
  5195                                  
  5196                                  ;-54 //        prc(' ');  
  5197                                  
  5198                                  
  5199                                  ;-55         hex = JmpCallAddr[i];
  5200                                  
  5201 00008E2F 8B5EFE                   mov bx, [bp-2]
  5202 00008E32 D1E3                     shl bx, 1
  5203 00008E34 8B87[751E]               mov ax, [JmpCallAddr + bx]
  5204 00008E38 8946FC                   mov word [bp-4], ax
  5205                                  
  5206                                  ;-56 //        printhex16(hex);
  5207                                  
  5208                                  
  5209                                  ;-57             
  5210                                  
  5211                                  
  5212                                  ;-58         Ix=searchLabel();
  5213                                  
  5214 00008E3B E8E4ED                   call searchLabel
  5215 00008E3E 8946F8                   mov word [bp-8], ax
  5216                                  
  5217                                  ;-59         if (Ix == 0) error1("Label not found");
  5218                                  
  5219 00008E41 8B46F8                   mov ax, [bp-8]
  5220 00008E44 83F800                   cmp ax, 0
  5221 00008E47 0F850900                 jne @@fixJmpCall209
  5222 00008E4B 68[BB8E]                 push fixJmpCall_1
  5223 00008E4E E8F1FA                   call error1
  5224 00008E51 83C402                   add  sp, 2
  5225                                  
  5226                                  ;-60         disp = LabelAddr[Ix];
  5227                                  
  5228                                  @@fixJmpCall209:
  5229 00008E54 8B5EF8                   mov bx, [bp-8]
  5230 00008E57 D1E3                     shl bx, 1
  5231 00008E59 8B87[EF11]               mov ax, [LabelAddr + bx]
  5232 00008E5D A3[3F02]                 mov word [disp], ax
  5233                                  
  5234                                  ;-61         disp = disp - hex;
  5235                                  
  5236 00008E60 A1[3F02]                 mov ax, [disp]
  5237 00008E63 2B46FC                   sub ax, [bp-4]
  5238 00008E66 A3[3F02]                 mov word [disp], ax
  5239                                  
  5240                                  ;-62         disp = disp - Origin;
  5241                                  
  5242 00008E69 A1[3F02]                 mov ax, [disp]
  5243 00008E6C 2B06[2702]               sub ax, [Origin]
  5244 00008E70 A3[3F02]                 mov word [disp], ax
  5245                                  
  5246                                  ;-63 //        prs(", ");    
  5247                                  
  5248                                  
  5249                                  ;-64         
  5250                                  
  5251                                  
  5252                                  ;-65             hex = hex - 2;//fix at start of word              
  5253                                  
  5254 00008E73 8B46FC                   mov ax, [bp-4]
  5255 00008E76 83E802                   sub ax, 2
  5256 00008E79 8946FC                   mov word [bp-4], ax
  5257                                  
  5258                                  ;-66             FileBin[hex] = disp;//fix low byte    
  5259                                  
  5260 00008E7C A1[3F02]                 mov ax, [disp]
  5261 00008E7F 8B5EFC                   mov bx, [bp-4]
  5262 00008E82 8887[5F22]               mov [FileBin+bx], al
  5263                                  
  5264                                  ;-67             hex++;
  5265                                  
  5266 00008E86 FF46FC                   inc  word [bp-4]
  5267                                  
  5268                                  ;-68             disp = disp >> 8;
  5269                                  
  5270 00008E89 A1[3F02]                 mov ax, [disp]
  5271 00008E8C C1E808                   shr ax, 8
  5272 00008E8F A3[3F02]                 mov word [disp], ax
  5273                                  
  5274                                  ;-69             FileBin[hex] = disp;            
  5275                                  
  5276 00008E92 A1[3F02]                 mov ax, [disp]
  5277 00008E95 8B5EFC                   mov bx, [bp-4]
  5278 00008E98 8887[5F22]               mov [FileBin+bx], al
  5279                                  
  5280                                  ;-70         i++;
  5281                                  
  5282 00008E9C FF46FE                   inc  word [bp-2]
  5283                                  
  5284                                  ;-71     }
  5285                                  
  5286                                  
  5287                                  ;-72 }
  5288                                  
  5289 00008E9F E960FF                   jmp @@fixJmpCall207
  5290                                  @@fixJmpCall208:
  5291                                  
  5292                                  ;-73 
  5293                                  
  5294                                  
  5295                                  ;-74 int epilog() { 
  5296 00008EA2 C9                       LEAVE
  5297 00008EA3 C3                       ret
  5298                                  ; ENDP
  5299 00008EA4 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5300 00008EAD 656E206A6D702F6361-
  5301 00008EB6 6C6C3A2000         
  5302 00008EBB 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5303 00008EC4 20666F756E6400     
  5304                                  
  5305                                  epilog:  ; *** PROC ***
  5306                                  
  5307                                  ;-75     unsigned int i; char c;     int j;
  5308                                  
  5309                                  
  5310                                  ;-76     prs("\n Errors: "); 
  5311                                  
  5312                                  ;Function : epilog, Number of local variables: 3
  5313                                  ;   # type sign width line used address name   list of local variables
  5314                                  ;  200 var unsg word    75 NULL bp-2    i
  5315                                  ;  201 var sign byte    75 NULL bp-4    c
  5316                                  ;  202 var sign word    75 NULL bp-6    j;
  5317 00008ECB C8060000                 ENTER  6,0
  5318 00008ECF 68[898F]                 push epilog_0
  5319 00008ED2 E80CF9                   call prs
  5320 00008ED5 83C402                   add  sp, 2
  5321                                  
  5322                                  ;-77     printIntU(ErrorCount);
  5323                                  
  5324 00008ED8 FF36[2002]               push word [ErrorCount]
  5325 00008EDC E821FA                   call printIntU
  5326 00008EDF 83C402                   add  sp, 2
  5327                                  
  5328                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5329                                  
  5330 00008EE2 A1[2002]                 mov ax, [ErrorCount]
  5331 00008EE5 08C0                     or  al, al
  5332 00008EE7 0F840900                 je @@epilog210
  5333 00008EEB 68[958F]                 push epilog_1
  5334 00008EEE E8F0F8                   call prs
  5335 00008EF1 83C402                   add  sp, 2
  5336                                  
  5337                                  ;-79     prs(", Out: "); 
  5338                                  
  5339                                  @@epilog210:
  5340 00008EF4 68[A38F]                 push epilog_2
  5341 00008EF7 E8E7F8                   call prs
  5342 00008EFA 83C402                   add  sp, 2
  5343                                  
  5344                                  ;-80     prs(namelst);
  5345                                  
  5346 00008EFD 8D06[9201]               lea  ax, [namelst]
  5347 00008F01 50                       push ax
  5348 00008F02 E8DCF8                   call prs
  5349 00008F05 83C402                   add  sp, 2
  5350                                  
  5351                                  ;-81     prs(", ");
  5352                                  
  5353 00008F08 68[AB8F]                 push epilog_3
  5354 00008F0B E8D3F8                   call prs
  5355 00008F0E 83C402                   add  sp, 2
  5356                                  
  5357                                  ;-82     prs(namebin); 
  5358                                  
  5359 00008F11 8D06[D501]               lea  ax, [namebin]
  5360 00008F15 50                       push ax
  5361 00008F16 E8C8F8                   call prs
  5362 00008F19 83C402                   add  sp, 2
  5363                                  
  5364                                  ;-83     prs("= ");
  5365                                  
  5366 00008F1C 68[AE8F]                 push epilog_4
  5367 00008F1F E8BFF8                   call prs
  5368 00008F22 83C402                   add  sp, 2
  5369                                  
  5370                                  ;-84     printIntU(BinLen); 
  5371                                  
  5372 00008F25 FF36[7F70]               push word [BinLen]
  5373 00008F29 E8D4F9                   call printIntU
  5374 00008F2C 83C402                   add  sp, 2
  5375                                  
  5376                                  ;-85     prs(" bytes.");
  5377                                  
  5378 00008F2F 68[B18F]                 push epilog_5
  5379 00008F32 E8ACF8                   call prs
  5380 00008F35 83C402                   add  sp, 2
  5381                                  
  5382                                  ;-86 
  5383                                  
  5384                                  
  5385                                  ;-87     i=0;
  5386                                  
  5387 00008F38 66B800000000             mov eax, 0
  5388 00008F3E 8946FE                   mov word [bp-2], ax
  5389                                  
  5390                                  ;-88     do {
  5391                                  
  5392                                  @@epilog211:
  5393                                  
  5394                                  ;-89         c = FileBin[i];
  5395                                  
  5396 00008F41 8B5EFE                   mov bx, [bp-2]
  5397 00008F44 8A87[5F22]               mov al, [FileBin + bx]
  5398 00008F48 8846FC                   mov byte [bp-4], al
  5399                                  
  5400                                  ;-90         fputcR(c, bin_fd);  
  5401                                  
  5402 00008F4B FF36[1C02]               push word [bin_fd]
  5403 00008F4F 8A46FC                   mov al, byte [bp-4]
  5404 00008F52 B400                     mov ah, 0
  5405 00008F54 50                       push ax
  5406 00008F55 E8C30C                   call fputcR
  5407 00008F58 83C404                   add  sp, 4
  5408                                  
  5409                                  ;-91 //printhex8a(c); prc(' ');      
  5410                                  
  5411                                  
  5412                                  ;-92         i++;
  5413                                  
  5414 00008F5B FF46FE                   inc  word [bp-2]
  5415                                  
  5416                                  ;-93     } while (i < BinLen);
  5417                                  
  5418 00008F5E 8B46FE                   mov ax, [bp-2]
  5419 00008F61 3B06[7F70]               cmp ax, [BinLen]
  5420 00008F65 0F8D0200                 jge @@epilog212
  5421 00008F69 EBD6                     jmp @@epilog211
  5422                                  @@epilog212:
  5423                                  
  5424                                  ;-94 
  5425                                  
  5426                                  
  5427                                  ;-95   prs("\ Labels: "); 
  5428                                  
  5429 00008F6B 68[B98F]                 push epilog_6
  5430 00008F6E E870F8                   call prs
  5431 00008F71 83C402                   add  sp, 2
  5432                                  
  5433                                  ;-96   printIntU(LabelMaxIx); 
  5434                                  
  5435 00008F74 FF36[9F16]               push word [LabelMaxIx]
  5436 00008F78 E885F9                   call printIntU
  5437 00008F7B 83C402                   add  sp, 2
  5438                                  
  5439                                  ;-97   prs(". ");     
  5440                                  
  5441 00008F7E 68[C48F]                 push epilog_7
  5442 00008F81 E85DF8                   call prs
  5443 00008F84 83C402                   add  sp, 2
  5444                                  
  5445                                  ;-98 /*  prs("size: ");
  5446                                  
  5447                                  
  5448                                  ;-99   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  5449                                  
  5450                                  
  5451                                  ;-100   prs(". >>");
  5452                                  
  5453                                  
  5454                                  ;-101   i= &LabelNames;
  5455                                  
  5456                                  
  5457                                  ;-102   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5458                                  
  5459                                  
  5460                                  ;-103   } while (i < LabelNamePtr); prs("<< \n");  */
  5461                                  
  5462                                  
  5463                                  ;-104 /*    i = 1;
  5464                                  
  5465                                  
  5466                                  ;-105     LabelNamePtr= &LabelNames;
  5467                                  
  5468                                  
  5469                                  ;-106     do {
  5470                                  
  5471                                  
  5472                                  ;-107       prs(LabelNamePtr); prc(' ');
  5473                                  
  5474                                  
  5475                                  ;-108       j=LabelAddr[i]; printhex16(j); prs(", ");
  5476                                  
  5477                                  
  5478                                  ;-109       j=strlen(LabelNamePtr);//get end of actual name
  5479                                  
  5480                                  
  5481                                  ;-110       LabelNamePtr=LabelNamePtr+j;
  5482                                  
  5483                                  
  5484                                  ;-111       LabelNamePtr++;
  5485                                  
  5486                                  
  5487                                  ;-112       i++;
  5488                                  
  5489                                  
  5490                                  ;-113     } while (i <= LabelMaxIx);
  5491                                  
  5492                                  
  5493                                  ;-114 */
  5494                                  
  5495                                  
  5496                                  ;-115 }
  5497                                  
  5498                                  
  5499                                  ;-116 
  5500                                  
  5501                                  
  5502                                  ;-117 int end1(int n) {
  5503 00008F87 C9                       LEAVE
  5504 00008F88 C3                       ret
  5505                                  ; ENDP
  5506 00008F89 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  5507 00008F92 3A2000             
  5508 00008F95 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5509 00008F9E 2A2A2A2000         
  5510 00008FA3 2C204F75743A2000        epilog_2 db ", Out: ",0
  5511 00008FAB 2C2000                  epilog_3 db ", ",0
  5512 00008FAE 3D2000                  epilog_4 db "= ",0
  5513 00008FB1 2062797465732E00        epilog_5 db " bytes.",0
  5514 00008FB9 5C204C6162656C733A-     epilog_6 db "\ Labels: ",0
  5515 00008FC2 2000               
  5516 00008FC4 2E2000                  epilog_7 db ". ",0
  5517                                  
  5518                                  end1:  ; *** PROC ***
  5519                                  
  5520                                  ;-118     fcloseR(asm_fd);
  5521                                  
  5522                                  ;Function : end1, Number of local variables: 1
  5523                                  ;   # type sign width line used address name   list of local variables
  5524                                  ;  200 var sign word   117 NULL bp+4    n;
  5525 00008FC7 C8000000                 ENTER  0,0
  5526 00008FCB FF36[1802]               push word [asm_fd]
  5527 00008FCF E85E0C                   call fcloseR
  5528 00008FD2 83C402                   add  sp, 2
  5529                                  
  5530                                  ;-119     fcloseR(lst_fd);
  5531                                  
  5532 00008FD5 FF36[1A02]               push word [lst_fd]
  5533 00008FD9 E8540C                   call fcloseR
  5534 00008FDC 83C402                   add  sp, 2
  5535                                  
  5536                                  ;-120     fcloseR(bin_fd);
  5537                                  
  5538 00008FDF FF36[1C02]               push word [bin_fd]
  5539 00008FE3 E84A0C                   call fcloseR
  5540 00008FE6 83C402                   add  sp, 2
  5541                                  
  5542                                  ;-121     exitR(n);
  5543                                  
  5544 00008FE9 FF7604                   push word [bp+4]
  5545 00008FEC E84F0C                   call exitR
  5546 00008FEF 83C402                   add  sp, 2
  5547                                  
  5548                                  ;-122 }
  5549 00008FF2 C9                       LEAVE
  5550 00008FF3 C3                       ret
  5551                                  ; ENDP
  5552                                  ;Back to main program: AS.C
  5553                                  
  5554                                  ;-9 #include "GENCODE.C"
  5555                                  
  5556                                  ;Use include file: GENCODE.C
  5557                                  
  5558                                  ;-1 // generate code
  5559                                  
  5560                                  
  5561                                  ;-2 int getCodes() {
  5562                                  
  5563                                  
  5564                                  getCodes:  ; *** PROC ***
  5565                                  
  5566                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5567                                  
  5568 00008FF4 FF06[4A02]               inc  word [OpCodePtr]
  5569 00008FF8 8B1E[4A02]               mov bx, [OpCodePtr]
  5570 00008FFC 8A07                     mov al, [bx]
  5571 00008FFE B400                     mov ah, 0
  5572 00009000 A2[3202]                 mov byte [Code1], al
  5573                                  
  5574                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5575                                  
  5576 00009003 FF06[4A02]               inc  word [OpCodePtr]
  5577 00009007 8B1E[4A02]               mov bx, [OpCodePtr]
  5578 0000900B 8A07                     mov al, [bx]
  5579 0000900D B400                     mov ah, 0
  5580 0000900F A2[3302]                 mov byte [Code2], al
  5581                                  
  5582                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5583                                  
  5584 00009012 FF06[4A02]               inc  word [OpCodePtr]
  5585 00009016 8B1E[4A02]               mov bx, [OpCodePtr]
  5586 0000901A 8A07                     mov al, [bx]
  5587 0000901C B400                     mov ah, 0
  5588 0000901E A2[3402]                 mov byte [Code3], al
  5589                                  
  5590                                  ;-6 }
  5591                                  
  5592                                  
  5593                                  ;-7 int gen66h() {genCode8(0x66);
  5594                                  
  5595 00009021 C3                       ret
  5596                                  ; ENDP
  5597                                  
  5598                                  gen66h:  ; *** PROC ***
  5599 00009022 6A66                     push 102
  5600 00009024 E83B00                   call genCode8
  5601 00009027 83C402                   add  sp, 2
  5602                                  
  5603                                  ;-8 }
  5604                                  
  5605                                  
  5606                                  ;-9 int genCode2(char c, char d) {
  5607                                  
  5608 0000902A C3                       ret
  5609                                  ; ENDP
  5610                                  
  5611                                  genCode2:  ; *** PROC ***
  5612                                  
  5613                                  ;-10     c = c + d;
  5614                                  
  5615                                  ;Function : genCode2, Number of local variables: 2
  5616                                  ;   # type sign width line used address name   list of local variables
  5617                                  ;  200 var sign byte     9 NULL bp+4    c
  5618                                  ;  201 var sign byte     9 NULL bp+6    d;
  5619 0000902B C8000000                 ENTER  0,0
  5620 0000902F 8A4604                   mov al, [bp+4]
  5621 00009032 024606                   add al, [bp+6]
  5622 00009035 884604                   mov byte [bp+4], al
  5623                                  
  5624                                  ;-11     genCode8(c);
  5625                                  
  5626 00009038 8A4604                   mov al, byte [bp+4]
  5627 0000903B B400                     mov ah, 0
  5628 0000903D 50                       push ax
  5629 0000903E E82100                   call genCode8
  5630 00009041 83C402                   add  sp, 2
  5631                                  
  5632                                  ;-12 }                             
  5633                                  
  5634                                  
  5635                                  ;-13 int genCodeW(char c) {
  5636 00009044 C9                       LEAVE
  5637 00009045 C3                       ret
  5638                                  ; ENDP
  5639                                  
  5640                                  genCodeW:  ; *** PROC ***
  5641                                  
  5642                                  ;-14     c = c + wflag;  
  5643                                  
  5644                                  ;Function : genCodeW, Number of local variables: 1
  5645                                  ;   # type sign width line used address name   list of local variables
  5646                                  ;  200 var sign byte    13 NULL bp+4    c;
  5647 00009046 C8000000                 ENTER  0,0
  5648 0000904A 8A4604                   mov al, [bp+4]
  5649 0000904D 0206[3A02]               add al, [wflag]
  5650 00009051 884604                   mov byte [bp+4], al
  5651                                  
  5652                                  ;-15     genCode8(c);
  5653                                  
  5654 00009054 8A4604                   mov al, byte [bp+4]
  5655 00009057 B400                     mov ah, 0
  5656 00009059 50                       push ax
  5657 0000905A E80500                   call genCode8
  5658 0000905D 83C402                   add  sp, 2
  5659                                  
  5660                                  ;-16 }   
  5661                                  
  5662                                  
  5663                                  ;-17 int genCode8(char c) {
  5664 00009060 C9                       LEAVE
  5665 00009061 C3                       ret
  5666                                  ; ENDP
  5667                                  
  5668                                  genCode8:  ; *** PROC ***
  5669                                  
  5670                                  ;-18 //set: BinLen++, OpPrintIndex++
  5671                                  
  5672                                  
  5673                                  ;-19     FileBin[BinLen]=c;
  5674                                  
  5675                                  ;Function : genCode8, Number of local variables: 1
  5676                                  ;   # type sign width line used address name   list of local variables
  5677                                  ;  200 var sign byte    17 NULL bp+4    c;
  5678 00009062 C8000000                 ENTER  0,0
  5679 00009066 8A4604                   mov al, [bp+4]
  5680 00009069 8B1E[7F70]               mov bx, [BinLen]
  5681 0000906D 8887[5F22]               mov [FileBin+bx], al
  5682                                  
  5683                                  ;-20     BinLen++;
  5684                                  
  5685 00009071 FF06[7F70]               inc  word [BinLen]
  5686                                  
  5687                                  ;-21     PC++;
  5688                                  
  5689 00009075 FF06[2502]               inc  word [PC]
  5690                                  
  5691                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5692                                  
  5693 00009079 A1[7F70]                 mov ax, [BinLen]
  5694 0000907C 3D204E                   cmp ax, 20000 ;unsigned : 0
  5695 0000907F 0F820900                 jb  @@genCode8213
  5696 00009083 68[A790]                 push genCode8_0
  5697 00009086 E818F9                   call errorexit
  5698 00009089 83C402                   add  sp, 2
  5699                                  
  5700                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5701                                  
  5702                                  @@genCode8213:
  5703 0000908C A1[4802]                 mov ax, [OpPrintIndex]
  5704 0000908F 83F805                   cmp ax, 5
  5705 00009092 0F8D0F00                 jge @@genCode8214
  5706                                  
  5707                                  ;-24         OpPos[OpPrintIndex]=c;
  5708                                  
  5709 00009096 8A4604                   mov al, [bp+4]
  5710 00009099 8B1E[4802]               mov bx, [OpPrintIndex]
  5711 0000909D 8887[4302]               mov [OpPos+bx], al
  5712                                  
  5713                                  ;-25         OpPrintIndex++;
  5714                                  
  5715 000090A1 FF06[4802]               inc  word [OpPrintIndex]
  5716                                  
  5717                                  ;-26     }
  5718                                  
  5719                                  
  5720                                  ;-27 }
  5721                                  
  5722                                  @@genCode8214:
  5723                                  
  5724                                  ;-28 int genCode16(unsigned int i) {
  5725 000090A5 C9                       LEAVE
  5726 000090A6 C3                       ret
  5727                                  ; ENDP
  5728 000090A7 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5729 000090B0 746F6F206C6F6E6700 
  5730                                  
  5731                                  genCode16:  ; *** PROC ***
  5732                                  
  5733                                  ;-29     genCode8(i); i=i >> 8;
  5734                                  
  5735                                  ;Function : genCode16, Number of local variables: 1
  5736                                  ;   # type sign width line used address name   list of local variables
  5737                                  ;  200 var unsg word    28 NULL bp+4    i;
  5738 000090B9 C8000000                 ENTER  0,0
  5739 000090BD FF7604                   push word [bp+4]
  5740 000090C0 E89FFF                   call genCode8
  5741 000090C3 83C402                   add  sp, 2
  5742 000090C6 8B4604                   mov ax, [bp+4]
  5743 000090C9 C1E808                   shr ax, 8
  5744 000090CC 894604                   mov word [bp+4], ax
  5745                                  
  5746                                  ;-30     genCode8(i);
  5747                                  
  5748 000090CF FF7604                   push word [bp+4]
  5749 000090D2 E88DFF                   call genCode8
  5750 000090D5 83C402                   add  sp, 2
  5751                                  
  5752                                  ;-31 }
  5753                                  
  5754                                  
  5755                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5756 000090D8 C9                       LEAVE
  5757 000090D9 C3                       ret
  5758                                  ; ENDP
  5759                                  
  5760                                  writeEA:  ; *** PROC ***
  5761                                  
  5762                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5763                                  
  5764                                  
  5765                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5766                                  
  5767                                  
  5768                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5769                                  
  5770                                  
  5771                                  ;-36     char len;
  5772                                  
  5773                                  
  5774                                  ;-37     len=0;   
  5775                                  
  5776                                  ;Function : writeEA, Number of local variables: 2
  5777                                  ;   # type sign width line used address name   list of local variables
  5778                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5779                                  ;  201 var sign byte    36 NULL bp-2    len;
  5780 000090DA C8020000                 ENTER  2,0
  5781 000090DE 66B800000000             mov eax, 0
  5782 000090E4 8846FE                   mov byte [bp-2], al
  5783                                  
  5784                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5785                                  
  5786 000090E7 8A4604                   mov al, [bp+4]
  5787 000090EA C0E003                   shl al, 3
  5788 000090ED 884604                   mov byte [bp+4], al
  5789                                  
  5790                                  ;-39     if (Op == REG) {
  5791                                  
  5792 000090F0 A0[2F02]                 mov al, [Op]
  5793 000090F3 3C02                     cmp al, 2
  5794 000090F5 0F853A00                 jne @@writeEA215
  5795                                  
  5796                                  ;-40         xxx |= 0xC0;     
  5797                                  
  5798 000090F9 804E04C0                 or  byte [bp+4], 192
  5799                                  
  5800                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5801                                  
  5802 000090FD A0[3002]                 mov al, [Op2]
  5803 00009100 3C01                     cmp al, 1
  5804 00009102 0F8F0D00                 jg  @@writeEA216
  5805 00009106 8A4604                   mov al, [bp+4]
  5806 00009109 0206[3602]               add al, [R1No]
  5807 0000910D 884604                   mov byte [bp+4], al
  5808                                  
  5809                                  ;-42             else {
  5810                                  
  5811 00009110 E92000                   jmp @@writeEA217
  5812                                  @@writeEA216:
  5813                                  
  5814                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5815                                  
  5816 00009113 A0[3002]                 mov al, [Op2]
  5817 00009116 3C02                     cmp al, 2
  5818 00009118 0F850D00                 jne @@writeEA218
  5819 0000911C 8A4604                   mov al, [bp+4]
  5820 0000911F 0206[3602]               add al, [R1No]
  5821 00009123 884604                   mov byte [bp+4], al
  5822                                  
  5823                                  ;-44                 else            xxx = xxx + R2No;  
  5824                                  
  5825 00009126 E90A00                   jmp @@writeEA219
  5826                                  @@writeEA218:
  5827 00009129 8A4604                   mov al, [bp+4]
  5828 0000912C 0206[3502]               add al, [R2No]
  5829 00009130 884604                   mov byte [bp+4], al
  5830                                  
  5831                                  ;-45             }
  5832                                  
  5833                                  @@writeEA219:
  5834                                  
  5835                                  ;-46         } 
  5836                                  
  5837                                  @@writeEA217:
  5838                                  
  5839                                  ;-47     if (Op == MEM) {
  5840                                  
  5841                                  @@writeEA215:
  5842 00009133 A0[2F02]                 mov al, [Op]
  5843 00009136 3C04                     cmp al, 4
  5844 00009138 0F857F00                 jne @@writeEA220
  5845                                  
  5846                                  ;-48         if (isDirect) {
  5847                                  
  5848 0000913C A0[3E02]                 mov al, [isDirect]
  5849 0000913F 08C0                     or  al, al
  5850 00009141 0F841000                 je @@writeEA221
  5851                                  
  5852                                  ;-49             xxx |= 6;
  5853                                  
  5854 00009145 804E0406                 or  byte [bp+4], 6
  5855                                  
  5856                                  ;-50             len = 2;
  5857                                  
  5858 00009149 66B802000000             mov eax, 2
  5859 0000914F 8846FE                   mov byte [bp-2], al
  5860                                  
  5861                                  ;-51         }
  5862                                  
  5863                                  
  5864                                  ;-52         else { 
  5865                                  
  5866 00009152 E96600                   jmp @@writeEA222
  5867                                  @@writeEA221:
  5868                                  
  5869                                  ;-53             xxx = xxx + rm;   
  5870                                  
  5871 00009155 8A4604                   mov al, [bp+4]
  5872 00009158 0206[3D02]               add al, [rm]
  5873 0000915C 884604                   mov byte [bp+4], al
  5874                                  
  5875                                  ;-54             if (rm == 6) {//make [BP+00]
  5876                                  
  5877 0000915F A0[3D02]                 mov al, [rm]
  5878 00009162 3C06                     cmp al, 6
  5879 00009164 0F851700                 jne @@writeEA223
  5880                                  
  5881                                  ;-55                 len=1;
  5882                                  
  5883 00009168 66B801000000             mov eax, 1
  5884 0000916E 8846FE                   mov byte [bp-2], al
  5885                                  
  5886                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5887                                  
  5888 00009171 A1[3F02]                 mov ax, [disp]
  5889 00009174 83F800                   cmp ax, 0
  5890 00009177 0F850400                 jne @@writeEA224
  5891 0000917B 804E0440                 or  byte [bp+4], 64
  5892                                  
  5893                                  ;-57             }
  5894                                  
  5895                                  @@writeEA224:
  5896                                  
  5897                                  ;-58 
  5898                                  
  5899                                  
  5900                                  ;-59             if (disp) {
  5901                                  
  5902                                  @@writeEA223:
  5903 0000917F A1[3F02]                 mov ax, [disp]
  5904 00009182 08C0                     or  al, al
  5905 00009184 0F843300                 je @@writeEA225
  5906                                  
  5907                                  ;-60                 ax = disp;
  5908                                  
  5909 00009188 A1[3F02]                 mov  ax, [disp]
  5910                                  
  5911                                  ;-61                 if(ax > 127) len=2;
  5912                                  
  5913 0000918B 83F87F                   cmp  ax, 127
  5914 0000918E 0F8E0C00                 jle @@writeEA226
  5915 00009192 66B802000000             mov eax, 2
  5916 00009198 8846FE                   mov byte [bp-2], al
  5917                                  
  5918                                  ;-62                 else len=1;
  5919                                  
  5920 0000919B E90900                   jmp @@writeEA227
  5921                                  @@writeEA226:
  5922 0000919E 66B801000000             mov eax, 1
  5923 000091A4 8846FE                   mov byte [bp-2], al
  5924                                  
  5925                                  ;-63                 if (len == 1) xxx |= 0x40;
  5926                                  
  5927                                  @@writeEA227:
  5928 000091A7 8A46FE                   mov al, [bp-2]
  5929 000091AA 3C01                     cmp al, 1
  5930 000091AC 0F850700                 jne @@writeEA228
  5931 000091B0 804E0440                 or  byte [bp+4], 64
  5932                                  
  5933                                  ;-64                 else xxx |= 0x80;
  5934                                  
  5935 000091B4 E90400                   jmp @@writeEA229
  5936                                  @@writeEA228:
  5937 000091B7 804E0480                 or  byte [bp+4], 128
  5938                                  
  5939                                  ;-65             }
  5940                                  
  5941                                  @@writeEA229:
  5942                                  
  5943                                  ;-66         }
  5944                                  
  5945                                  @@writeEA225:
  5946                                  
  5947                                  ;-67     }  
  5948                                  
  5949                                  @@writeEA222:
  5950                                  
  5951                                  ;-68     
  5952                                  
  5953                                  
  5954                                  ;-69     genCode8(xxx);// gen second byte
  5955                                  
  5956                                  @@writeEA220:
  5957 000091BB 8A4604                   mov al, byte [bp+4]
  5958 000091BE B400                     mov ah, 0
  5959 000091C0 50                       push ax
  5960 000091C1 E89EFE                   call genCode8
  5961 000091C4 83C402                   add  sp, 2
  5962                                  
  5963                                  ;-70     if (len == 1) genCode8 (disp);
  5964                                  
  5965 000091C7 8A46FE                   mov al, [bp-2]
  5966 000091CA 3C01                     cmp al, 1
  5967 000091CC 0F850A00                 jne @@writeEA230
  5968 000091D0 FF36[3F02]               push word [disp]
  5969 000091D4 E88BFE                   call genCode8
  5970 000091D7 83C402                   add  sp, 2
  5971                                  
  5972                                  ;-71     if (len == 2) genCode16(disp);
  5973                                  
  5974                                  @@writeEA230:
  5975 000091DA 8A46FE                   mov al, [bp-2]
  5976 000091DD 3C02                     cmp al, 2
  5977 000091DF 0F850A00                 jne @@writeEA231
  5978 000091E3 FF36[3F02]               push word [disp]
  5979 000091E7 E8CFFE                   call genCode16
  5980 000091EA 83C402                   add  sp, 2
  5981                                  
  5982                                  ;-72 }
  5983                                  
  5984                                  @@writeEA231:
  5985                                  
  5986                                  ;-73 
  5987                                  
  5988                                  
  5989                                  ;-74 int genImmediate() { 
  5990 000091ED C9                       LEAVE
  5991 000091EE C3                       ret
  5992                                  ; ENDP
  5993                                  
  5994                                  genImmediate:  ; *** PROC ***
  5995                                  
  5996                                  ;-75     if (wflag) genCode16(imme);
  5997                                  
  5998 000091EF A0[3A02]                 mov al, [wflag]
  5999 000091F2 08C0                     or  al, al
  6000 000091F4 0F840D00                 je @@genImmediate232
  6001 000091F8 FF36[4102]               push word [imme]
  6002 000091FC E8BAFE                   call genCode16
  6003 000091FF 83C402                   add  sp, 2
  6004                                  
  6005                                  ;-76     else       genCode8 (imme);  
  6006                                  
  6007 00009202 E90A00                   jmp @@genImmediate233
  6008                                  @@genImmediate232:
  6009 00009205 FF36[4102]               push word [imme]
  6010 00009209 E856FE                   call genCode8
  6011 0000920C 83C402                   add  sp, 2
  6012                                  
  6013                                  ;-77 }    
  6014                                  
  6015                                  @@genImmediate233:
  6016 0000920F C3                       ret
  6017                                  ; ENDP
  6018                                  ;Back to main program: AS.C
  6019                                  
  6020                                  ;-10 
  6021                                  
  6022                                  
  6023                                  ;-11 int process() { 
  6024                                  
  6025                                  
  6026                                  process:  ; *** PROC ***
  6027                                  
  6028                                  ;-12     char c;           
  6029                                  
  6030                                  
  6031                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6032                                  
  6033                                  ;Function : process, Number of local variables: 1
  6034                                  ;   # type sign width line used address name   list of local variables
  6035                                  ;  200 var sign byte    12 NULL bp-2    c;
  6036 00009210 C8020000                 ENTER  2,0
  6037 00009214 66B800000000             mov eax, 0
  6038 0000921A A2[3D02]                 mov byte [rm], al
  6039 0000921D A2[3A02]                 mov byte [wflag], al
  6040 00009220 A2[3B02]                 mov byte [dflag], al
  6041 00009223 A2[3502]                 mov byte [R2No], al
  6042 00009226 A2[3602]                 mov byte [R1No], al
  6043 00009229 A2[3702]                 mov byte [R2Type], al
  6044 0000922C A2[3802]                 mov byte [R1Type], al
  6045 0000922F A2[3002]                 mov byte [Op2], al
  6046 00009232 A2[2F02]                 mov byte [Op], al
  6047                                  
  6048                                  ;-14     disp=imme=0;//int
  6049                                  
  6050 00009235 66B800000000             mov eax, 0
  6051 0000923B A3[4102]                 mov word [imme], ax
  6052 0000923E A3[3F02]                 mov word [disp], ax
  6053                                  
  6054                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6055                                  
  6056 00009241 66B801000000             mov eax, 1
  6057 00009247 A2[3E02]                 mov byte [isDirect], al
  6058                                  
  6059                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6060                                  
  6061 0000924A E80EE8                   call getTokeType
  6062                                  
  6063                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6064                                  
  6065 0000924D E818EC                   call getCodeSize
  6066 00009250 A2[3902]                 mov byte [OpSize], al
  6067                                  
  6068                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6069                                  
  6070 00009253 E89EFD                   call getCodes
  6071                                  
  6072                                  ;-19 
  6073                                  
  6074                                  
  6075                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6076                                  
  6077 00009256 A0[3102]                 mov al, [CodeType]
  6078 00009259 3C01                     cmp al, 1
  6079 0000925B 0F850F00                 jne @@process234
  6080                                  
  6081                                  ;-21         genCode8(Code1);
  6082                                  
  6083 0000925F A0[3202]                 mov al, byte [Code1]
  6084 00009262 B400                     mov ah, 0
  6085 00009264 50                       push ax
  6086 00009265 E8FAFD                   call genCode8
  6087 00009268 83C402                   add  sp, 2
  6088                                  
  6089                                  ;-22         return;
  6090                                  
  6091 0000926B E9B007                   jmp @@retn
  6092                                  
  6093                                  ;-23     }
  6094                                  
  6095                                  
  6096                                  ;-24   
  6097                                  
  6098                                  
  6099                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  6100                                  
  6101                                  @@process234:
  6102 0000926E A0[3102]                 mov al, [CodeType]
  6103 00009271 3C02                     cmp al, 2
  6104 00009273 0F856900                 jne @@process235
  6105                                  
  6106                                  ;-26         getOpL();    
  6107                                  
  6108 00009277 E8B3E2                   call getOpL
  6109                                  
  6110                                  ;-27         checkOpL();        
  6111                                  
  6112 0000927A E8D3E1                   call checkOpL
  6113                                  
  6114                                  ;-28         if (Code2 <= 1) {//inc,dec
  6115                                  
  6116 0000927D A0[3302]                 mov al, [Code2]
  6117 00009280 3C01                     cmp al, 1
  6118 00009282 0F8F2700                 jg  @@process236
  6119                                  
  6120                                  ;-29   	        if (Op == REG) {//short
  6121                                  
  6122 00009286 A0[2F02]                 mov al, [Op]
  6123 00009289 3C02                     cmp al, 2
  6124 0000928B 0F851E00                 jne @@process237
  6125                                  
  6126                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6127                                  
  6128 0000928F A0[3A02]                 mov al, [wflag]
  6129 00009292 08C0                     or  al, al
  6130 00009294 0F841500                 je @@process238
  6131 00009298 A0[3602]                 mov al, byte [R1No]
  6132 0000929B B400                     mov ah, 0
  6133 0000929D 50                       push ax
  6134 0000929E A0[3402]                 mov al, byte [Code3]
  6135 000092A1 B400                     mov ah, 0
  6136 000092A3 50                       push ax
  6137 000092A4 E884FD                   call genCode2
  6138 000092A7 83C404                   add  sp, 4
  6139 000092AA E97107                   jmp @@retn
  6140                                  
  6141                                  ;-31             }
  6142                                  
  6143                                  @@process238:
  6144                                  
  6145                                  ;-32         }
  6146                                  
  6147                                  @@process237:
  6148                                  
  6149                                  ;-33         if (Code2 == 5) {//imul extension?
  6150                                  
  6151                                  @@process236:
  6152 000092AD A0[3302]                 mov al, [Code2]
  6153 000092B0 3C05                     cmp al, 5
  6154 000092B2 0F850F00                 jne @@process239
  6155                                  
  6156                                  ;-34             getTokeType();
  6157                                  
  6158 000092B6 E8A2E7                   call getTokeType
  6159                                  
  6160                                  ;-35             if (TokeType) implerror();
  6161                                  
  6162 000092B9 A0[2E02]                 mov al, [TokeType]
  6163 000092BC 08C0                     or  al, al
  6164 000092BE 0F840300                 je @@process240
  6165 000092C2 E84DF7                   call implerror
  6166                                  
  6167                                  ;-36         }
  6168                                  
  6169                                  @@process240:
  6170                                  
  6171                                  ;-37         genCodeW(Code1);           
  6172                                  
  6173                                  @@process239:
  6174 000092C5 A0[3202]                 mov al, byte [Code1]
  6175 000092C8 B400                     mov ah, 0
  6176 000092CA 50                       push ax
  6177 000092CB E878FD                   call genCodeW
  6178 000092CE 83C402                   add  sp, 2
  6179                                  
  6180                                  ;-38         writeEA(Code2);
  6181                                  
  6182 000092D1 A0[3302]                 mov al, byte [Code2]
  6183 000092D4 B400                     mov ah, 0
  6184 000092D6 50                       push ax
  6185 000092D7 E800FE                   call writeEA
  6186 000092DA 83C402                   add  sp, 2
  6187                                  
  6188                                  ;-39         return;
  6189                                  
  6190 000092DD E93E07                   jmp @@retn
  6191                                  
  6192                                  ;-40     }
  6193                                  
  6194                                  
  6195                                  ;-41   
  6196                                  
  6197                                  
  6198                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6199                                  
  6200                                  @@process235:
  6201 000092E0 A0[3102]                 mov al, [CodeType]
  6202 000092E3 3C03                     cmp al, 3
  6203 000092E5 0F855100                 jne @@process241
  6204                                  
  6205                                  ;-43         check2Ops();    //setwflag not applicable
  6206                                  
  6207 000092E9 E8E6E1                   call check2Ops
  6208                                  
  6209                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6210                                  
  6211 000092EC A0[3802]                 mov al, [R1Type]
  6212 000092EF 3C02                     cmp al, 2
  6213 000092F1 0F840300                 je  @@process242
  6214 000092F5 E8BAF7                   call reg16error
  6215                                  
  6216                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6217                                  
  6218                                  @@process242:
  6219 000092F8 A0[3002]                 mov al, [Op2]
  6220 000092FB 3C04                     cmp al, 4
  6221 000092FD 0F840300                 je  @@process243
  6222 00009301 E8CFF6                   call addrerror
  6223                                  
  6224                                  ;-46         
  6225                                  
  6226                                  
  6227                                  ;-47         genCode8(Code1);//les,lds,lea
  6228                                  
  6229                                  @@process243:
  6230 00009304 A0[3202]                 mov al, byte [Code1]
  6231 00009307 B400                     mov ah, 0
  6232 00009309 50                       push ax
  6233 0000930A E855FD                   call genCode8
  6234 0000930D 83C402                   add  sp, 2
  6235                                  
  6236                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6237                                  
  6238 00009310 A0[3202]                 mov al, [Code1]
  6239 00009313 3C0F                     cmp al, 15
  6240 00009315 0F850C00                 jne @@process244
  6241 00009319 A0[3302]                 mov al, byte [Code2]
  6242 0000931C B400                     mov ah, 0
  6243 0000931E 50                       push ax
  6244 0000931F E840FD                   call genCode8
  6245 00009322 83C402                   add  sp, 2
  6246                                  
  6247                                  ;-49         Op=Op2;//set MEM for writeEA
  6248                                  
  6249                                  @@process244:
  6250 00009325 A0[3002]                 mov al, [Op2]
  6251 00009328 A2[2F02]                 mov byte [Op], al
  6252                                  
  6253                                  ;-50         writeEA(R1No);           
  6254                                  
  6255 0000932B A0[3602]                 mov al, byte [R1No]
  6256 0000932E B400                     mov ah, 0
  6257 00009330 50                       push ax
  6258 00009331 E8A6FD                   call writeEA
  6259 00009334 83C402                   add  sp, 2
  6260                                  
  6261                                  ;-51         return;
  6262                                  
  6263 00009337 E9E406                   jmp @@retn
  6264                                  
  6265                                  ;-52     }
  6266                                  
  6267                                  
  6268                                  ;-53 
  6269                                  
  6270                                  
  6271                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6272                                  
  6273                                  @@process241:
  6274 0000933A A0[3102]                 mov al, [CodeType]
  6275 0000933D 3C04                     cmp al, 4
  6276 0000933F 0F85EF00                 jne @@process245
  6277                                  
  6278                                  ;-55         check2Ops();    
  6279                                  
  6280 00009343 E88CE1                   call check2Ops
  6281                                  
  6282                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6283                                  
  6284 00009346 A0[3002]                 mov al, [Op2]
  6285 00009349 3C01                     cmp al, 1
  6286 0000934B 0F857900                 jne @@process246
  6287                                  
  6288                                  ;-57             setsflag();   
  6289                                  
  6290 0000934F E863E5                   call setsflag
  6291                                  
  6292                                  ;-58             if (Op == REG) {                
  6293                                  
  6294 00009352 A0[2F02]                 mov al, [Op]
  6295 00009355 3C02                     cmp al, 2
  6296 00009357 0F853100                 jne @@process247
  6297                                  
  6298                                  ;-59                 if (R1No == 0) {// acc,imm   
  6299                                  
  6300 0000935B A0[3602]                 mov al, [R1No]
  6301 0000935E 3C00                     cmp al, 0
  6302 00009360 0F852800                 jne @@process248
  6303                                  
  6304                                  ;-60                     if (sflag == 0) {                        
  6305                                  
  6306 00009364 A0[3C02]                 mov al, [sflag]
  6307 00009367 3C00                     cmp al, 0
  6308 00009369 0F851F00                 jne @@process249
  6309                                  
  6310                                  ;-61                         c = Code1 << 3;
  6311                                  
  6312 0000936D A0[3202]                 mov al, [Code1]
  6313 00009370 C0E003                   shl al, 3
  6314 00009373 8846FE                   mov byte [bp-2], al
  6315                                  
  6316                                  ;-62                         c += 4;    
  6317                                  
  6318 00009376 8046FE04                 add  byte [bp-2], 4
  6319                                  
  6320                                  ;-63                         genCodeW(c);
  6321                                  
  6322 0000937A 8A46FE                   mov al, byte [bp-2]
  6323 0000937D B400                     mov ah, 0
  6324 0000937F 50                       push ax
  6325 00009380 E8C3FC                   call genCodeW
  6326 00009383 83C402                   add  sp, 2
  6327                                  
  6328                                  ;-64                         genImmediate();
  6329                                  
  6330 00009386 E866FE                   call genImmediate
  6331                                  
  6332                                  ;-65                         return;
  6333                                  
  6334 00009389 E99206                   jmp @@retn
  6335                                  
  6336                                  ;-66                     }
  6337                                  
  6338                                  
  6339                                  ;-67                 }
  6340                                  
  6341                                  @@process249:
  6342                                  
  6343                                  ;-68             }
  6344                                  
  6345                                  @@process248:
  6346                                  
  6347                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6348                                  
  6349                                  
  6350                                  ;-70             c = sflag + 0x80;   
  6351                                  
  6352                                  @@process247:
  6353 0000938C A0[3C02]                 mov al, [sflag]
  6354 0000938F 0480                     add al, 128
  6355 00009391 8846FE                   mov byte [bp-2], al
  6356                                  
  6357                                  ;-71             genCodeW(c); 
  6358                                  
  6359 00009394 8A46FE                   mov al, byte [bp-2]
  6360 00009397 B400                     mov ah, 0
  6361 00009399 50                       push ax
  6362 0000939A E8A9FC                   call genCodeW
  6363 0000939D 83C402                   add  sp, 2
  6364                                  
  6365                                  ;-72             writeEA(Code1);  
  6366                                  
  6367 000093A0 A0[3202]                 mov al, byte [Code1]
  6368 000093A3 B400                     mov ah, 0
  6369 000093A5 50                       push ax
  6370 000093A6 E831FD                   call writeEA
  6371 000093A9 83C402                   add  sp, 2
  6372                                  
  6373                                  ;-73             if (sflag) genCode8(imme);
  6374                                  
  6375 000093AC A0[3C02]                 mov al, [sflag]
  6376 000093AF 08C0                     or  al, al
  6377 000093B1 0F840D00                 je @@process250
  6378 000093B5 FF36[4102]               push word [imme]
  6379 000093B9 E8A6FC                   call genCode8
  6380 000093BC 83C402                   add  sp, 2
  6381                                  
  6382                                  ;-74             else genImmediate();    
  6383                                  
  6384 000093BF E90300                   jmp @@process251
  6385                                  @@process250:
  6386 000093C2 E82AFE                   call genImmediate
  6387                                  
  6388                                  ;-75             return;     
  6389                                  
  6390                                  @@process251:
  6391 000093C5 E95606                   jmp @@retn
  6392                                  
  6393                                  ;-76         }  
  6394                                  
  6395                                  
  6396                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6397                                  
  6398                                  @@process246:
  6399 000093C8 A0[3202]                 mov al, [Code1]
  6400 000093CB C0E003                   shl al, 3
  6401 000093CE 8846FE                   mov byte [bp-2], al
  6402                                  
  6403                                  ;-78         if (Op == REG) {
  6404                                  
  6405 000093D1 A0[2F02]                 mov al, [Op]
  6406 000093D4 3C02                     cmp al, 2
  6407 000093D6 0F852E00                 jne @@process252
  6408                                  
  6409                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6410                                  
  6411 000093DA A0[3002]                 mov al, [Op2]
  6412 000093DD 3C04                     cmp al, 4
  6413 000093DF 0F852500                 jne @@process253
  6414                                  
  6415                                  ;-80                 c += 2;//add direction flag
  6416                                  
  6417 000093E3 8046FE02                 add  byte [bp-2], 2
  6418                                  
  6419                                  ;-81                 genCodeW(c);
  6420                                  
  6421 000093E7 8A46FE                   mov al, byte [bp-2]
  6422 000093EA B400                     mov ah, 0
  6423 000093EC 50                       push ax
  6424 000093ED E856FC                   call genCodeW
  6425 000093F0 83C402                   add  sp, 2
  6426                                  
  6427                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6428                                  
  6429 000093F3 A0[3002]                 mov al, [Op2]
  6430 000093F6 A2[2F02]                 mov byte [Op], al
  6431                                  
  6432                                  ;-83                 writeEA(R1No);
  6433                                  
  6434 000093F9 A0[3602]                 mov al, byte [R1No]
  6435 000093FC B400                     mov ah, 0
  6436 000093FE 50                       push ax
  6437 000093FF E8D8FC                   call writeEA
  6438 00009402 83C402                   add  sp, 2
  6439                                  
  6440                                  ;-84                 return;    
  6441                                  
  6442 00009405 E91606                   jmp @@retn
  6443                                  
  6444                                  ;-85             }
  6445                                  
  6446                                  
  6447                                  ;-86         }
  6448                                  
  6449                                  @@process253:
  6450                                  
  6451                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6452                                  
  6453                                  @@process252:
  6454 00009408 A0[3002]                 mov al, [Op2]
  6455 0000940B 3C02                     cmp al, 2
  6456 0000940D 0F851B00                 jne @@process254
  6457                                  
  6458                                  ;-88             genCodeW(c);
  6459                                  
  6460 00009411 8A46FE                   mov al, byte [bp-2]
  6461 00009414 B400                     mov ah, 0
  6462 00009416 50                       push ax
  6463 00009417 E82CFC                   call genCodeW
  6464 0000941A 83C402                   add  sp, 2
  6465                                  
  6466                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6467                                  
  6468 0000941D A0[3502]                 mov al, byte [R2No]
  6469 00009420 B400                     mov ah, 0
  6470 00009422 50                       push ax
  6471 00009423 E8B4FC                   call writeEA
  6472 00009426 83C402                   add  sp, 2
  6473                                  
  6474                                  ;-90             return;            
  6475                                  
  6476 00009429 E9F205                   jmp @@retn
  6477                                  
  6478                                  ;-91         }          
  6479                                  
  6480                                  
  6481                                  ;-92         syntaxerror();        
  6482                                  
  6483                                  @@process254:
  6484 0000942C E8D2F6                   call syntaxerror
  6485                                  
  6486                                  ;-93         return;
  6487                                  
  6488 0000942F E9EC05                   jmp @@retn
  6489                                  
  6490                                  ;-94     }
  6491                                  
  6492                                  
  6493                                  ;-95  
  6494                                  
  6495                                  
  6496                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6497                                  
  6498                                  @@process245:
  6499 00009432 A0[3102]                 mov al, [CodeType]
  6500 00009435 3C05                     cmp al, 5
  6501 00009437 0F857F01                 jne @@process255
  6502                                  
  6503                                  ;-97         check2Ops();    
  6504                                  
  6505 0000943B E894E0                   call check2Ops
  6506                                  
  6507                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6508                                  
  6509                                  
  6510                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6511                                  
  6512                                  
  6513                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6514                                  
  6515                                  
  6516                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6517                                  
  6518                                  
  6519                                  ;-102         if (Op2 == ADR) {
  6520                                  
  6521 0000943E A0[3002]                 mov al, [Op2]
  6522 00009441 3C03                     cmp al, 3
  6523 00009443 0F850F00                 jne @@process256
  6524                                  
  6525                                  ;-103             imme=disp;
  6526                                  
  6527 00009447 A1[3F02]                 mov ax, [disp]
  6528 0000944A A3[4102]                 mov word [imme], ax
  6529                                  
  6530                                  ;-104             Op2=IMM;//continue with IMM    
  6531                                  
  6532 0000944D 66B801000000             mov eax, 1
  6533 00009453 A2[3002]                 mov byte [Op2], al
  6534                                  
  6535                                  ;-105         }  
  6536                                  
  6537                                  
  6538                                  ;-106         if (Op2 == IMM) {// r,i     
  6539                                  
  6540                                  @@process256:
  6541 00009456 A0[3002]                 mov al, [Op2]
  6542 00009459 3C01                     cmp al, 1
  6543 0000945B 0F855400                 jne @@process257
  6544                                  
  6545                                  ;-107             if (Op == REG) {               
  6546                                  
  6547 0000945F A0[2F02]                 mov al, [Op]
  6548 00009462 3C02                     cmp al, 2
  6549 00009464 0F852500                 jne @@process258
  6550                                  
  6551                                  ;-108                 c = wflag << 3;   
  6552                                  
  6553 00009468 A0[3A02]                 mov al, [wflag]
  6554 0000946B C0E003                   shl al, 3
  6555 0000946E 8846FE                   mov byte [bp-2], al
  6556                                  
  6557                                  ;-109                 c += 0xB0;                                     
  6558                                  
  6559 00009471 8046FEB0                 add  byte [bp-2], 176
  6560                                  
  6561                                  ;-110                 genCode2(c, R1No);   
  6562                                  
  6563 00009475 A0[3602]                 mov al, byte [R1No]
  6564 00009478 B400                     mov ah, 0
  6565 0000947A 50                       push ax
  6566 0000947B 8A46FE                   mov al, byte [bp-2]
  6567 0000947E B400                     mov ah, 0
  6568 00009480 50                       push ax
  6569 00009481 E8A7FB                   call genCode2
  6570 00009484 83C404                   add  sp, 4
  6571                                  
  6572                                  ;-111                 genImmediate();
  6573                                  
  6574 00009487 E865FD                   call genImmediate
  6575                                  
  6576                                  ;-112                 return; 
  6577                                  
  6578 0000948A E99105                   jmp @@retn
  6579                                  
  6580                                  ;-113             }
  6581                                  
  6582                                  
  6583                                  ;-114             if (Op == MEM) {// m,i  
  6584                                  
  6585                                  @@process258:
  6586 0000948D A0[2F02]                 mov al, [Op]
  6587 00009490 3C04                     cmp al, 4
  6588 00009492 0F851700                 jne @@process259
  6589                                  
  6590                                  ;-115                 genCodeW(0xC6);
  6591                                  
  6592 00009496 68C600                   push 198
  6593 00009499 E8AAFB                   call genCodeW
  6594 0000949C 83C402                   add  sp, 2
  6595                                  
  6596                                  ;-116                 writeEA( 0 );
  6597                                  
  6598 0000949F 6A00                     push 0
  6599 000094A1 E836FC                   call writeEA
  6600 000094A4 83C402                   add  sp, 2
  6601                                  
  6602                                  ;-117                 genImmediate();
  6603                                  
  6604 000094A7 E845FD                   call genImmediate
  6605                                  
  6606                                  ;-118                 return;  
  6607                                  
  6608 000094AA E97105                   jmp @@retn
  6609                                  
  6610                                  ;-119             }
  6611                                  
  6612                                  
  6613                                  ;-120             regmemerror();
  6614                                  
  6615                                  @@process259:
  6616 000094AD E8D8F5                   call regmemerror
  6617                                  
  6618                                  ;-121             return;
  6619                                  
  6620 000094B0 E96B05                   jmp @@retn
  6621                                  
  6622                                  ;-122         }      
  6623                                  
  6624                                  
  6625                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6626                                  
  6627                                  @@process257:
  6628 000094B3 A0[3802]                 mov al, [R1Type]
  6629 000094B6 3C04                     cmp al, 4
  6630 000094B8 0F850300                 jne @@process260
  6631 000094BC E84CDF                   call ChangeDirection
  6632                                  
  6633                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6634                                  
  6635                                  @@process260:
  6636 000094BF A0[3702]                 mov al, [R2Type]
  6637 000094C2 3C04                     cmp al, 4
  6638 000094C4 0F852A00                 jne @@process261
  6639                                  
  6640                                  ;-125             if (OpSize != WORD) reg16error();
  6641                                  
  6642 000094C8 A0[3902]                 mov al, [OpSize]
  6643 000094CB 3C02                     cmp al, 2
  6644 000094CD 0F840300                 je  @@process262
  6645 000094D1 E8DEF5                   call reg16error
  6646                                  
  6647                                  ;-126                 genCode2(0x8C, dflag);
  6648                                  
  6649                                  @@process262:
  6650 000094D4 A0[3B02]                 mov al, byte [dflag]
  6651 000094D7 B400                     mov ah, 0
  6652 000094D9 50                       push ax
  6653 000094DA 688C00                   push 140
  6654 000094DD E84BFB                   call genCode2
  6655 000094E0 83C404                   add  sp, 4
  6656                                  
  6657                                  ;-127                 writeEA(R2No);
  6658                                  
  6659 000094E3 A0[3502]                 mov al, byte [R2No]
  6660 000094E6 B400                     mov ah, 0
  6661 000094E8 50                       push ax
  6662 000094E9 E8EEFB                   call writeEA
  6663 000094EC 83C402                   add  sp, 2
  6664                                  
  6665                                  ;-128                 return;   
  6666                                  
  6667 000094EF E92C05                   jmp @@retn
  6668                                  
  6669                                  ;-129         }          
  6670                                  
  6671                                  
  6672                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6673                                  
  6674                                  @@process261:
  6675 000094F2 A0[3002]                 mov al, [Op2]
  6676 000094F5 3C04                     cmp al, 4
  6677 000094F7 0F853100                 jne @@process263
  6678                                  
  6679                                  ;-131             if (Op == REG) {
  6680                                  
  6681 000094FB A0[2F02]                 mov al, [Op]
  6682 000094FE 3C02                     cmp al, 2
  6683 00009500 0F852800                 jne @@process264
  6684                                  
  6685                                  ;-132                 if (R1No == 0) {
  6686                                  
  6687 00009504 A0[3602]                 mov al, [R1No]
  6688 00009507 3C00                     cmp al, 0
  6689 00009509 0F851F00                 jne @@process265
  6690                                  
  6691                                  ;-133                     if (isDirect) {
  6692                                  
  6693 0000950D A0[3E02]                 mov al, [isDirect]
  6694 00009510 08C0                     or  al, al
  6695 00009512 0F841600                 je @@process266
  6696                                  
  6697                                  ;-134                         genCodeW(0xA0);
  6698                                  
  6699 00009516 68A000                   push 160
  6700 00009519 E82AFB                   call genCodeW
  6701 0000951C 83C402                   add  sp, 2
  6702                                  
  6703                                  ;-135                         genCode16(disp);
  6704                                  
  6705 0000951F FF36[3F02]               push word [disp]
  6706 00009523 E893FB                   call genCode16
  6707 00009526 83C402                   add  sp, 2
  6708                                  
  6709                                  ;-136                         return;   
  6710                                  
  6711 00009529 E9F204                   jmp @@retn
  6712                                  
  6713                                  ;-137                     }   
  6714                                  
  6715                                  
  6716                                  ;-138                 }   
  6717                                  
  6718                                  @@process266:
  6719                                  
  6720                                  ;-139             }   
  6721                                  
  6722                                  @@process265:
  6723                                  
  6724                                  ;-140         } 
  6725                                  
  6726                                  @@process264:
  6727                                  
  6728                                  ;-141         if (Op == MEM) {//moffs16, acc
  6729                                  
  6730                                  @@process263:
  6731 0000952C A0[2F02]                 mov al, [Op]
  6732 0000952F 3C04                     cmp al, 4
  6733 00009531 0F853100                 jne @@process267
  6734                                  
  6735                                  ;-142             if (Op2 == REG) {
  6736                                  
  6737 00009535 A0[3002]                 mov al, [Op2]
  6738 00009538 3C02                     cmp al, 2
  6739 0000953A 0F852800                 jne @@process268
  6740                                  
  6741                                  ;-143                 if (R2No == 0) {
  6742                                  
  6743 0000953E A0[3502]                 mov al, [R2No]
  6744 00009541 3C00                     cmp al, 0
  6745 00009543 0F851F00                 jne @@process269
  6746                                  
  6747                                  ;-144                     if (isDirect) {
  6748                                  
  6749 00009547 A0[3E02]                 mov al, [isDirect]
  6750 0000954A 08C0                     or  al, al
  6751 0000954C 0F841600                 je @@process270
  6752                                  
  6753                                  ;-145                         genCodeW(0xA2);
  6754                                  
  6755 00009550 68A200                   push 162
  6756 00009553 E8F0FA                   call genCodeW
  6757 00009556 83C402                   add  sp, 2
  6758                                  
  6759                                  ;-146                         genCode16(disp);
  6760                                  
  6761 00009559 FF36[3F02]               push word [disp]
  6762 0000955D E859FB                   call genCode16
  6763 00009560 83C402                   add  sp, 2
  6764                                  
  6765                                  ;-147                         return;   
  6766                                  
  6767 00009563 E9B804                   jmp @@retn
  6768                                  
  6769                                  ;-148                     }   
  6770                                  
  6771                                  
  6772                                  ;-149                 }   
  6773                                  
  6774                                  @@process270:
  6775                                  
  6776                                  ;-150             }
  6777                                  
  6778                                  @@process269:
  6779                                  
  6780                                  ;-151         
  6781                                  
  6782                                  
  6783                                  ;-152         }
  6784                                  
  6785                                  @@process268:
  6786                                  
  6787                                  ;-153         if (Op2 == REG) {//rm, r
  6788                                  
  6789                                  @@process267:
  6790 00009566 A0[3002]                 mov al, [Op2]
  6791 00009569 3C02                     cmp al, 2
  6792 0000956B 0F851800                 jne @@process271
  6793                                  
  6794                                  ;-154             genCodeW(0x88);     
  6795                                  
  6796 0000956F 688800                   push 136
  6797 00009572 E8D1FA                   call genCodeW
  6798 00009575 83C402                   add  sp, 2
  6799                                  
  6800                                  ;-155             writeEA(R2No);
  6801                                  
  6802 00009578 A0[3502]                 mov al, byte [R2No]
  6803 0000957B B400                     mov ah, 0
  6804 0000957D 50                       push ax
  6805 0000957E E859FB                   call writeEA
  6806 00009581 83C402                   add  sp, 2
  6807                                  
  6808                                  ;-156             return;
  6809                                  
  6810 00009584 E99704                   jmp @@retn
  6811                                  
  6812                                  ;-157         }
  6813                                  
  6814                                  
  6815                                  ;-158         if (Op2 == MEM) {//r, m
  6816                                  
  6817                                  @@process271:
  6818 00009587 A0[3002]                 mov al, [Op2]
  6819 0000958A 3C04                     cmp al, 4
  6820 0000958C 0F852400                 jne @@process272
  6821                                  
  6822                                  ;-159             if (Op == REG) {
  6823                                  
  6824 00009590 A0[2F02]                 mov al, [Op]
  6825 00009593 3C02                     cmp al, 2
  6826 00009595 0F851B00                 jne @@process273
  6827                                  
  6828                                  ;-160                 ChangeDirection();
  6829                                  
  6830 00009599 E86FDE                   call ChangeDirection
  6831                                  
  6832                                  ;-161                 genCodeW(0x8A);
  6833                                  
  6834 0000959C 688A00                   push 138
  6835 0000959F E8A4FA                   call genCodeW
  6836 000095A2 83C402                   add  sp, 2
  6837                                  
  6838                                  ;-162                 writeEA(R2No);
  6839                                  
  6840 000095A5 A0[3502]                 mov al, byte [R2No]
  6841 000095A8 B400                     mov ah, 0
  6842 000095AA 50                       push ax
  6843 000095AB E82CFB                   call writeEA
  6844 000095AE 83C402                   add  sp, 2
  6845                                  
  6846                                  ;-163                 return;   
  6847                                  
  6848 000095B1 E96A04                   jmp @@retn
  6849                                  
  6850                                  ;-164             }   
  6851                                  
  6852                                  
  6853                                  ;-165         }         
  6854                                  
  6855                                  @@process273:
  6856                                  
  6857                                  ;-166         syntaxerror();
  6858                                  
  6859                                  @@process272:
  6860 000095B4 E84AF5                   call syntaxerror
  6861                                  
  6862                                  ;-167         return;
  6863                                  
  6864 000095B7 E96404                   jmp @@retn
  6865                                  
  6866                                  ;-168     }    
  6867                                  
  6868                                  
  6869                                  ;-169     
  6870                                  
  6871                                  
  6872                                  ;-170     if (CodeType == 6) {//Jcc       
  6873                                  
  6874                                  @@process255:
  6875 000095BA A0[3102]                 mov al, [CodeType]
  6876 000095BD 3C06                     cmp al, 6
  6877 000095BF 0F85C100                 jne @@process274
  6878                                  
  6879                                  ;-171         if (TokeType == ALNUME) {
  6880                                  
  6881 000095C3 A0[2E02]                 mov al, [TokeType]
  6882 000095C6 3C03                     cmp al, 3
  6883 000095C8 0F85B800                 jne @@process275
  6884                                  
  6885                                  ;-172             LabelIx=searchLabel();
  6886                                  
  6887 000095CC E853E6                   call searchLabel
  6888 000095CF A3[A116]                 mov word [LabelIx], ax
  6889                                  
  6890                                  ;-173             if (LabelIx > 0) {
  6891                                  
  6892 000095D2 A1[A116]                 mov ax, [LabelIx]
  6893 000095D5 83F800                   cmp ax, 0
  6894 000095D8 0F8E7A00                 jle @@process276
  6895                                  
  6896                                  ;-174                 disp=LabelAddr[LabelIx];
  6897                                  
  6898 000095DC 8B1E[A116]               mov bx, [LabelIx]
  6899 000095E0 D1E3                     shl bx, 1
  6900 000095E2 8B87[EF11]               mov ax, [LabelAddr + bx]
  6901 000095E6 A3[3F02]                 mov word [disp], ax
  6902                                  
  6903                                  ;-175                 disp = disp - PC;   
  6904                                  
  6905 000095E9 A1[3F02]                 mov ax, [disp]
  6906 000095EC 2B06[2502]               sub ax, [PC]
  6907 000095F0 A3[3F02]                 mov word [disp], ax
  6908                                  
  6909                                  ;-176                 disp = disp - Origin;
  6910                                  
  6911 000095F3 A1[3F02]                 mov ax, [disp]
  6912 000095F6 2B06[2702]               sub ax, [Origin]
  6913 000095FA A3[3F02]                 mov word [disp], ax
  6914                                  
  6915                                  ;-177                 if (checkConstSize(disp) ) {
  6916                                  
  6917 000095FD FF36[3F02]               push word [disp]
  6918 00009601 E816E3                   call checkConstSize
  6919 00009604 83C402                   add  sp, 2
  6920 00009607 08C0                     or  al, al
  6921 00009609 0F842000                 je @@process277
  6922                                  
  6923                                  ;-178                     genCode2(Code1, 0x70);//short       
  6924                                  
  6925 0000960D 6A70                     push 112
  6926 0000960F A0[3202]                 mov al, byte [Code1]
  6927 00009612 B400                     mov ah, 0
  6928 00009614 50                       push ax
  6929 00009615 E813FA                   call genCode2
  6930 00009618 83C404                   add  sp, 4
  6931                                  
  6932                                  ;-179                     disp -= 2; 
  6933                                  
  6934 0000961B 832E[3F02]02             sub  word [disp], 2
  6935                                  
  6936                                  ;-180                     genCode8(disp);   
  6937                                  
  6938 00009620 FF36[3F02]               push word [disp]
  6939 00009624 E83BFA                   call genCode8
  6940 00009627 83C402                   add  sp, 2
  6941                                  
  6942                                  ;-181                 } else {     
  6943                                  
  6944 0000962A E92600                   jmp @@process278
  6945                                  @@process277:
  6946                                  
  6947                                  ;-182                     genCode8(0x0F);
  6948                                  
  6949 0000962D 6A0F                     push 15
  6950 0000962F E830FA                   call genCode8
  6951 00009632 83C402                   add  sp, 2
  6952                                  
  6953                                  ;-183                     genCode2(Code1, 0x80);//near       
  6954                                  
  6955 00009635 688000                   push 128
  6956 00009638 A0[3202]                 mov al, byte [Code1]
  6957 0000963B B400                     mov ah, 0
  6958 0000963D 50                       push ax
  6959 0000963E E8EAF9                   call genCode2
  6960 00009641 83C404                   add  sp, 4
  6961                                  
  6962                                  ;-184                     disp -= 4; 
  6963                                  
  6964 00009644 832E[3F02]04             sub  word [disp], 4
  6965                                  
  6966                                  ;-185                     genCode16(disp);                       
  6967                                  
  6968 00009649 FF36[3F02]               push word [disp]
  6969 0000964D E869FA                   call genCode16
  6970 00009650 83C402                   add  sp, 2
  6971                                  
  6972                                  ;-186                 }    
  6973                                  
  6974                                  
  6975                                  ;-187             }
  6976                                  
  6977                                  @@process278:
  6978                                  
  6979                                  ;-188             else {//jump forward, near only
  6980                                  
  6981 00009653 E92B00                   jmp @@process279
  6982                                  @@process276:
  6983                                  
  6984                                  ;-189                 genCode8(0x0F);
  6985                                  
  6986 00009656 6A0F                     push 15
  6987 00009658 E807FA                   call genCode8
  6988 0000965B 83C402                   add  sp, 2
  6989                                  
  6990                                  ;-190                 genCode2(Code1, 0x80);
  6991                                  
  6992 0000965E 688000                   push 128
  6993 00009661 A0[3202]                 mov al, byte [Code1]
  6994 00009664 B400                     mov ah, 0
  6995 00009666 50                       push ax
  6996 00009667 E8C1F9                   call genCode2
  6997 0000966A 83C404                   add  sp, 4
  6998                                  
  6999                                  ;-191                 genCode16(0);
  7000                                  
  7001 0000966D 6A00                     push 0
  7002 0000966F E847FA                   call genCode16
  7003 00009672 83C402                   add  sp, 2
  7004                                  
  7005                                  ;-192                 PrintRA='*';
  7006                                  
  7007 00009675 66B82A000000             mov eax, 42
  7008 0000967B A2[4C02]                 mov byte [PrintRA], al
  7009                                  
  7010                                  ;-193                 storeJmpCall();
  7011                                  
  7012 0000967E E875E4                   call storeJmpCall
  7013                                  
  7014                                  ;-194             }   
  7015                                  
  7016                                  
  7017                                  ;-195         return; 
  7018                                  
  7019                                  @@process279:
  7020 00009681 E99A03                   jmp @@retn
  7021                                  
  7022                                  ;-196         }  
  7023                                  
  7024                                  
  7025                                  ;-197     }
  7026                                  
  7027                                  @@process275:
  7028                                  
  7029                                  ;-198 
  7030                                  
  7031                                  
  7032                                  ;-199     if (CodeType == 7) {//jmp, call
  7033                                  
  7034                                  @@process274:
  7035 00009684 A0[3102]                 mov al, [CodeType]
  7036 00009687 3C07                     cmp al, 7
  7037 00009689 0F85CD00                 jne @@process280
  7038                                  
  7039                                  ;-200         if (TokeType == ALNUME) {
  7040                                  
  7041 0000968D A0[2E02]                 mov al, [TokeType]
  7042 00009690 3C03                     cmp al, 3
  7043 00009692 0F85C400                 jne @@process281
  7044                                  
  7045                                  ;-201             LabelIx=searchLabel();
  7046                                  
  7047 00009696 E889E5                   call searchLabel
  7048 00009699 A3[A116]                 mov word [LabelIx], ax
  7049                                  
  7050                                  ;-202             if (LabelIx > 0) {
  7051                                  
  7052 0000969C A1[A116]                 mov ax, [LabelIx]
  7053 0000969F 83F800                   cmp ax, 0
  7054 000096A2 0F8E9100                 jle @@process282
  7055                                  
  7056                                  ;-203                 disp=LabelAddr[LabelIx];
  7057                                  
  7058 000096A6 8B1E[A116]               mov bx, [LabelIx]
  7059 000096AA D1E3                     shl bx, 1
  7060 000096AC 8B87[EF11]               mov ax, [LabelAddr + bx]
  7061 000096B0 A3[3F02]                 mov word [disp], ax
  7062                                  
  7063                                  ;-204                 disp = disp - PC;   
  7064                                  
  7065 000096B3 A1[3F02]                 mov ax, [disp]
  7066 000096B6 2B06[2502]               sub ax, [PC]
  7067 000096BA A3[3F02]                 mov word [disp], ax
  7068                                  
  7069                                  ;-205                 disp = disp - Origin;
  7070                                  
  7071 000096BD A1[3F02]                 mov ax, [disp]
  7072 000096C0 2B06[2702]               sub ax, [Origin]
  7073 000096C4 A3[3F02]                 mov word [disp], ax
  7074                                  
  7075                                  ;-206                 if (checkConstSize(disp) ) {
  7076                                  
  7077 000096C7 FF36[3F02]               push word [disp]
  7078 000096CB E84CE2                   call checkConstSize
  7079 000096CE 83C402                   add  sp, 2
  7080 000096D1 08C0                     or  al, al
  7081 000096D3 0F844200                 je @@process283
  7082                                  
  7083                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7084                                  
  7085 000096D7 A0[3202]                 mov al, [Code1]
  7086 000096DA 3CE9                     cmp al, 233
  7087 000096DC 0F851B00                 jne @@process284
  7088                                  
  7089                                  ;-208                         genCode8(0xEB);//short       
  7090                                  
  7091 000096E0 68EB00                   push 235
  7092 000096E3 E87CF9                   call genCode8
  7093 000096E6 83C402                   add  sp, 2
  7094                                  
  7095                                  ;-209                         disp -= 2; 
  7096                                  
  7097 000096E9 832E[3F02]02             sub  word [disp], 2
  7098                                  
  7099                                  ;-210                         genCode8(disp);
  7100                                  
  7101 000096EE FF36[3F02]               push word [disp]
  7102 000096F2 E86DF9                   call genCode8
  7103 000096F5 83C402                   add  sp, 2
  7104                                  
  7105                                  ;-211                     } 
  7106                                  
  7107                                  
  7108                                  ;-212                     else {     
  7109                                  
  7110 000096F8 E91B00                   jmp @@process285
  7111                                  @@process284:
  7112                                  
  7113                                  ;-213                         genCode8(Code1);//near    
  7114                                  
  7115 000096FB A0[3202]                 mov al, byte [Code1]
  7116 000096FE B400                     mov ah, 0
  7117 00009700 50                       push ax
  7118 00009701 E85EF9                   call genCode8
  7119 00009704 83C402                   add  sp, 2
  7120                                  
  7121                                  ;-214                         disp -= 3; 
  7122                                  
  7123 00009707 832E[3F02]03             sub  word [disp], 3
  7124                                  
  7125                                  ;-215                         genCode16(disp);                       
  7126                                  
  7127 0000970C FF36[3F02]               push word [disp]
  7128 00009710 E8A6F9                   call genCode16
  7129 00009713 83C402                   add  sp, 2
  7130                                  
  7131                                  ;-216                     }    
  7132                                  
  7133                                  
  7134                                  ;-217                 } 
  7135                                  
  7136                                  @@process285:
  7137                                  
  7138                                  ;-218                 else {     
  7139                                  
  7140 00009716 E91B00                   jmp @@process286
  7141                                  @@process283:
  7142                                  
  7143                                  ;-219                     genCode8(Code1);//near    
  7144                                  
  7145 00009719 A0[3202]                 mov al, byte [Code1]
  7146 0000971C B400                     mov ah, 0
  7147 0000971E 50                       push ax
  7148 0000971F E840F9                   call genCode8
  7149 00009722 83C402                   add  sp, 2
  7150                                  
  7151                                  ;-220                     disp -= 3; 
  7152                                  
  7153 00009725 832E[3F02]03             sub  word [disp], 3
  7154                                  
  7155                                  ;-221                     genCode16(disp);                       
  7156                                  
  7157 0000972A FF36[3F02]               push word [disp]
  7158 0000972E E888F9                   call genCode16
  7159 00009731 83C402                   add  sp, 2
  7160                                  
  7161                                  ;-222                 }    
  7162                                  
  7163                                  
  7164                                  ;-223             }
  7165                                  
  7166                                  @@process286:
  7167                                  
  7168                                  ;-224             else {//jump forward, near only
  7169                                  
  7170 00009734 E92000                   jmp @@process287
  7171                                  @@process282:
  7172                                  
  7173                                  ;-225                 genCode8(Code1);
  7174                                  
  7175 00009737 A0[3202]                 mov al, byte [Code1]
  7176 0000973A B400                     mov ah, 0
  7177 0000973C 50                       push ax
  7178 0000973D E822F9                   call genCode8
  7179 00009740 83C402                   add  sp, 2
  7180                                  
  7181                                  ;-226                 genCode16(0);
  7182                                  
  7183 00009743 6A00                     push 0
  7184 00009745 E871F9                   call genCode16
  7185 00009748 83C402                   add  sp, 2
  7186                                  
  7187                                  ;-227                 PrintRA='*';
  7188                                  
  7189 0000974B 66B82A000000             mov eax, 42
  7190 00009751 A2[4C02]                 mov byte [PrintRA], al
  7191                                  
  7192                                  ;-228                 storeJmpCall();
  7193                                  
  7194 00009754 E89FE3                   call storeJmpCall
  7195                                  
  7196                                  ;-229             }   
  7197                                  
  7198                                  
  7199                                  ;-230         return; 
  7200                                  
  7201                                  @@process287:
  7202 00009757 E9C402                   jmp @@retn
  7203                                  
  7204                                  ;-231         }
  7205                                  
  7206                                  
  7207                                  ;-232     }
  7208                                  
  7209                                  @@process281:
  7210                                  
  7211                                  ;-233     
  7212                                  
  7213                                  
  7214                                  ;-234     if (CodeType ==  8) {//ret,retf
  7215                                  
  7216                                  @@process280:
  7217 0000975A A0[3102]                 mov al, [CodeType]
  7218 0000975D 3C08                     cmp al, 8
  7219 0000975F 0F853100                 jne @@process288
  7220                                  
  7221                                  ;-235         if (TokeType == DIGIT) {
  7222                                  
  7223 00009763 A0[2E02]                 mov al, [TokeType]
  7224 00009766 3C01                     cmp al, 1
  7225 00009768 0F851900                 jne @@process289
  7226                                  
  7227                                  ;-236             genCode8(Code2);
  7228                                  
  7229 0000976C A0[3302]                 mov al, byte [Code2]
  7230 0000976F B400                     mov ah, 0
  7231 00009771 50                       push ax
  7232 00009772 E8EDF8                   call genCode8
  7233 00009775 83C402                   add  sp, 2
  7234                                  
  7235                                  ;-237             genCode16(SymbolInt);
  7236                                  
  7237 00009778 FF36[4C00]               push word [SymbolInt]
  7238 0000977C E83AF9                   call genCode16
  7239 0000977F 83C402                   add  sp, 2
  7240                                  
  7241                                  ;-238             return;
  7242                                  
  7243 00009782 E99902                   jmp @@retn
  7244                                  
  7245                                  ;-239         }
  7246                                  
  7247                                  
  7248                                  ;-240         genCode8(Code1); 
  7249                                  
  7250                                  @@process289:
  7251 00009785 A0[3202]                 mov al, byte [Code1]
  7252 00009788 B400                     mov ah, 0
  7253 0000978A 50                       push ax
  7254 0000978B E8D4F8                   call genCode8
  7255 0000978E 83C402                   add  sp, 2
  7256                                  
  7257                                  ;-241         return;
  7258                                  
  7259 00009791 E98A02                   jmp @@retn
  7260                                  
  7261                                  ;-242     }
  7262                                  
  7263                                  
  7264                                  ;-243        
  7265                                  
  7266                                  
  7267                                  ;-244     if (CodeType == 9) {//push, pop  
  7268                                  
  7269                                  @@process288:
  7270 00009794 A0[3102]                 mov al, [CodeType]
  7271 00009797 3C09                     cmp al, 9
  7272 00009799 0F850301                 jne @@process290
  7273                                  
  7274                                  ;-245         getOpL();
  7275                                  
  7276 0000979D E88DDD                   call getOpL
  7277                                  
  7278                                  ;-246         if (Code1 == 0x50) {//push only
  7279                                  
  7280 000097A0 A0[3202]                 mov al, [Code1]
  7281 000097A3 3C50                     cmp al, 80
  7282 000097A5 0F853D00                 jne @@process291
  7283                                  
  7284                                  ;-247             if (Op == IMM) {//push imm8,16
  7285                                  
  7286 000097A9 A0[2F02]                 mov al, [Op]
  7287 000097AC 3C01                     cmp al, 1
  7288 000097AE 0F853400                 jne @@process292
  7289                                  
  7290                                  ;-248                 setsflag();
  7291                                  
  7292 000097B2 E800E1                   call setsflag
  7293                                  
  7294                                  ;-249                 genCode2(0x68, sflag);     
  7295                                  
  7296 000097B5 A0[3C02]                 mov al, byte [sflag]
  7297 000097B8 B400                     mov ah, 0
  7298 000097BA 50                       push ax
  7299 000097BB 6A68                     push 104
  7300 000097BD E86BF8                   call genCode2
  7301 000097C0 83C404                   add  sp, 4
  7302                                  
  7303                                  ;-250                 if (sflag) genCode8 (imme);
  7304                                  
  7305 000097C3 A0[3C02]                 mov al, [sflag]
  7306 000097C6 08C0                     or  al, al
  7307 000097C8 0F840D00                 je @@process293
  7308 000097CC FF36[4102]               push word [imme]
  7309 000097D0 E88FF8                   call genCode8
  7310 000097D3 83C402                   add  sp, 2
  7311                                  
  7312                                  ;-251                 else       genCode16(imme);    
  7313                                  
  7314 000097D6 E90A00                   jmp @@process294
  7315                                  @@process293:
  7316 000097D9 FF36[4102]               push word [imme]
  7317 000097DD E8D9F8                   call genCode16
  7318 000097E0 83C402                   add  sp, 2
  7319                                  
  7320                                  ;-252                 return;   
  7321                                  
  7322                                  @@process294:
  7323 000097E3 E93802                   jmp @@retn
  7324                                  
  7325                                  ;-253             }   
  7326                                  
  7327                                  
  7328                                  ;-254         }
  7329                                  
  7330                                  @@process292:
  7331                                  
  7332                                  ;-255         if (R1Type == SEGREG) {
  7333                                  
  7334                                  @@process291:
  7335 000097E6 A0[3802]                 mov al, [R1Type]
  7336 000097E9 3C04                     cmp al, 4
  7337 000097EB 0F855A00                 jne @@process295
  7338                                  
  7339                                  ;-256             if (Code1 == 0x58) {
  7340                                  
  7341 000097EF A0[3202]                 mov al, [Code1]
  7342 000097F2 3C58                     cmp al, 88
  7343 000097F4 0F851200                 jne @@process296
  7344                                  
  7345                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");   
  7346                                  
  7347 000097F8 A0[3602]                 mov al, [R1No]
  7348 000097FB 3C01                     cmp al, 1
  7349 000097FD 0F850900                 jne @@process297
  7350 00009801 68[209A]                 push process_0
  7351 00009804 E83BF1                   call error1
  7352 00009807 83C402                   add  sp, 2
  7353                                  
  7354                                  ;-258             }
  7355                                  
  7356                                  @@process297:
  7357                                  
  7358                                  ;-259             c = R1No <<3;
  7359                                  
  7360                                  @@process296:
  7361 0000980A A0[3602]                 mov al, [R1No]
  7362 0000980D C0E003                   shl al, 3
  7363 00009810 8846FE                   mov byte [bp-2], al
  7364                                  
  7365                                  ;-260             if (R1No > 3) {//FS, GS
  7366                                  
  7367 00009813 A0[3602]                 mov al, [R1No]
  7368 00009816 3C03                     cmp al, 3
  7369 00009818 0F8E0C00                 jle @@process298
  7370                                  
  7371                                  ;-261                 c += 122;
  7372                                  
  7373 0000981C 8046FE7A                 add  byte [bp-2], 122
  7374                                  
  7375                                  ;-262                 genCode8(0x0F);
  7376                                  
  7377 00009820 6A0F                     push 15
  7378 00009822 E83DF8                   call genCode8
  7379 00009825 83C402                   add  sp, 2
  7380                                  
  7381                                  ;-263             }
  7382                                  
  7383                                  
  7384                                  ;-264             OpCodePtr++;
  7385                                  
  7386                                  @@process298:
  7387 00009828 FF06[4A02]               inc  word [OpCodePtr]
  7388                                  
  7389                                  ;-265             c = c + *OpCodePtr;//is Code4   
  7390                                  
  7391 0000982C 8A46FE                   mov al, [bp-2]
  7392 0000982F 8B1E[4A02]               mov bx, [OpCodePtr]
  7393 00009833 0207                     add al, [bx]
  7394 00009835 B400                     mov ah, 0
  7395 00009837 8846FE                   mov byte [bp-2], al
  7396                                  
  7397                                  ;-266             genCode8(c);  
  7398                                  
  7399 0000983A 8A46FE                   mov al, byte [bp-2]
  7400 0000983D B400                     mov ah, 0
  7401 0000983F 50                       push ax
  7402 00009840 E81FF8                   call genCode8
  7403 00009843 83C402                   add  sp, 2
  7404                                  
  7405                                  ;-267             return; 
  7406                                  
  7407 00009846 E9D501                   jmp @@retn
  7408                                  
  7409                                  ;-268         }  
  7410                                  
  7411                                  
  7412                                  ;-269         checkOpL();    
  7413                                  
  7414                                  @@process295:
  7415 00009849 E804DC                   call checkOpL
  7416                                  
  7417                                  ;-270         if (R1Type == BYTE) reg16error();
  7418                                  
  7419 0000984C A0[3802]                 mov al, [R1Type]
  7420 0000984F 3C01                     cmp al, 1
  7421 00009851 0F850300                 jne @@process299
  7422 00009855 E85AF2                   call reg16error
  7423                                  
  7424                                  ;-271         if (R1Type == WORD) {
  7425                                  
  7426                                  @@process299:
  7427 00009858 A0[3802]                 mov al, [R1Type]
  7428 0000985B 3C02                     cmp al, 2
  7429 0000985D 0F851500                 jne @@process300
  7430                                  
  7431                                  ;-272             genCode2(Code1, R1No);
  7432                                  
  7433 00009861 A0[3602]                 mov al, byte [R1No]
  7434 00009864 B400                     mov ah, 0
  7435 00009866 50                       push ax
  7436 00009867 A0[3202]                 mov al, byte [Code1]
  7437 0000986A B400                     mov ah, 0
  7438 0000986C 50                       push ax
  7439 0000986D E8BBF7                   call genCode2
  7440 00009870 83C404                   add  sp, 4
  7441                                  
  7442                                  ;-273             return;   
  7443                                  
  7444 00009873 E9A801                   jmp @@retn
  7445                                  
  7446                                  ;-274         }                
  7447                                  
  7448                                  
  7449                                  ;-275         if (Op == MEM) {
  7450                                  
  7451                                  @@process300:
  7452 00009876 A0[2F02]                 mov al, [Op]
  7453 00009879 3C04                     cmp al, 4
  7454 0000987B 0F851B00                 jne @@process301
  7455                                  
  7456                                  ;-276             genCode8(Code2);
  7457                                  
  7458 0000987F A0[3302]                 mov al, byte [Code2]
  7459 00009882 B400                     mov ah, 0
  7460 00009884 50                       push ax
  7461 00009885 E8DAF7                   call genCode8
  7462 00009888 83C402                   add  sp, 2
  7463                                  
  7464                                  ;-277             writeEA(Code3);
  7465                                  
  7466 0000988B A0[3402]                 mov al, byte [Code3]
  7467 0000988E B400                     mov ah, 0
  7468 00009890 50                       push ax
  7469 00009891 E846F8                   call writeEA
  7470 00009894 83C402                   add  sp, 2
  7471                                  
  7472                                  ;-278             return;   
  7473                                  
  7474 00009897 E98401                   jmp @@retn
  7475                                  
  7476                                  ;-279         }
  7477                                  
  7478                                  
  7479                                  ;-280         syntaxerror();
  7480                                  
  7481                                  @@process301:
  7482 0000989A E864F2                   call syntaxerror
  7483                                  
  7484                                  ;-281         return;        
  7485                                  
  7486 0000989D E97E01                   jmp @@retn
  7487                                  
  7488                                  ;-282     }
  7489                                  
  7490                                  
  7491                                  ;-283     
  7492                                  
  7493                                  
  7494                                  ;-284     if (CodeType == 11) {//shift, rotate
  7495                                  
  7496                                  @@process290:
  7497 000098A0 A0[3102]                 mov al, [CodeType]
  7498 000098A3 3C0B                     cmp al, 11
  7499 000098A5 0F859500                 jne @@process302
  7500                                  
  7501                                  ;-285         check2Ops();
  7502                                  
  7503 000098A9 E826DC                   call check2Ops
  7504                                  
  7505                                  ;-286         if (Op2 == IMM) {
  7506                                  
  7507 000098AC A0[3002]                 mov al, [Op2]
  7508 000098AF 3C01                     cmp al, 1
  7509 000098B1 0F854400                 jne @@process303
  7510                                  
  7511                                  ;-287             if (imme == 1) {
  7512                                  
  7513 000098B5 A1[4102]                 mov ax, [imme]
  7514 000098B8 83F801                   cmp ax, 1
  7515 000098BB 0F851800                 jne @@process304
  7516                                  
  7517                                  ;-288                 genCodeW(0xD0);
  7518                                  
  7519 000098BF 68D000                   push 208
  7520 000098C2 E881F7                   call genCodeW
  7521 000098C5 83C402                   add  sp, 2
  7522                                  
  7523                                  ;-289                 writeEA(Code1);
  7524                                  
  7525 000098C8 A0[3202]                 mov al, byte [Code1]
  7526 000098CB B400                     mov ah, 0
  7527 000098CD 50                       push ax
  7528 000098CE E809F8                   call writeEA
  7529 000098D1 83C402                   add  sp, 2
  7530                                  
  7531                                  ;-290                 return;
  7532                                  
  7533 000098D4 E94701                   jmp @@retn
  7534                                  
  7535                                  ;-291             }
  7536                                  
  7537                                  
  7538                                  ;-292             genCodeW(0xC0);//80186
  7539                                  
  7540                                  @@process304:
  7541 000098D7 68C000                   push 192
  7542 000098DA E869F7                   call genCodeW
  7543 000098DD 83C402                   add  sp, 2
  7544                                  
  7545                                  ;-293             writeEA(Code1);
  7546                                  
  7547 000098E0 A0[3202]                 mov al, byte [Code1]
  7548 000098E3 B400                     mov ah, 0
  7549 000098E5 50                       push ax
  7550 000098E6 E8F1F7                   call writeEA
  7551 000098E9 83C402                   add  sp, 2
  7552                                  
  7553                                  ;-294             genCode8(imme);
  7554                                  
  7555 000098EC FF36[4102]               push word [imme]
  7556 000098F0 E86FF7                   call genCode8
  7557 000098F3 83C402                   add  sp, 2
  7558                                  
  7559                                  ;-295             return;    
  7560                                  
  7561 000098F6 E92501                   jmp @@retn
  7562                                  
  7563                                  ;-296         }
  7564                                  
  7565                                  
  7566                                  ;-297         if (Op2 == REG) {
  7567                                  
  7568                                  @@process303:
  7569 000098F9 A0[3002]                 mov al, [Op2]
  7570 000098FC 3C02                     cmp al, 2
  7571 000098FE 0F853C00                 jne @@process305
  7572                                  
  7573                                  ;-298             if (R2Type == BYTE) {
  7574                                  
  7575 00009902 A0[3702]                 mov al, [R2Type]
  7576 00009905 3C01                     cmp al, 1
  7577 00009907 0F853300                 jne @@process306
  7578                                  
  7579                                  ;-299                 if (R2No == 1) {//CL-REG 
  7580                                  
  7581 0000990B A0[3502]                 mov al, [R2No]
  7582 0000990E 3C01                     cmp al, 1
  7583 00009910 0F852A00                 jne @@process307
  7584                                  
  7585                                  ;-300                     if (R1Type == WORD) wflag=1;//hack
  7586                                  
  7587 00009914 A0[3802]                 mov al, [R1Type]
  7588 00009917 3C02                     cmp al, 2
  7589 00009919 0F850900                 jne @@process308
  7590 0000991D 66B801000000             mov eax, 1
  7591 00009923 A2[3A02]                 mov byte [wflag], al
  7592                                  
  7593                                  ;-301                     genCodeW(0xD2);
  7594                                  
  7595                                  @@process308:
  7596 00009926 68D200                   push 210
  7597 00009929 E81AF7                   call genCodeW
  7598 0000992C 83C402                   add  sp, 2
  7599                                  
  7600                                  ;-302                     writeEA(Code1);
  7601                                  
  7602 0000992F A0[3202]                 mov al, byte [Code1]
  7603 00009932 B400                     mov ah, 0
  7604 00009934 50                       push ax
  7605 00009935 E8A2F7                   call writeEA
  7606 00009938 83C402                   add  sp, 2
  7607                                  
  7608                                  ;-303                     return;   
  7609                                  
  7610 0000993B E9E000                   jmp @@retn
  7611                                  
  7612                                  ;-304                 }   
  7613                                  
  7614                                  
  7615                                  ;-305             }
  7616                                  
  7617                                  @@process307:
  7618                                  
  7619                                  ;-306         }    
  7620                                  
  7621                                  @@process306:
  7622                                  
  7623                                  ;-307     }     
  7624                                  
  7625                                  @@process305:
  7626                                  
  7627                                  ;-308     
  7628                                  
  7629                                  
  7630                                  ;-309     if (CodeType == 12) {//int
  7631                                  
  7632                                  @@process302:
  7633 0000993E A0[3102]                 mov al, [CodeType]
  7634 00009941 3C0C                     cmp al, 12
  7635 00009943 0F852200                 jne @@process309
  7636                                  
  7637                                  ;-310         if (TokeType == DIGIT) {            
  7638                                  
  7639 00009947 A0[2E02]                 mov al, [TokeType]
  7640 0000994A 3C01                     cmp al, 1
  7641 0000994C 0F851900                 jne @@process310
  7642                                  
  7643                                  ;-311             genCode8(Code1);
  7644                                  
  7645 00009950 A0[3202]                 mov al, byte [Code1]
  7646 00009953 B400                     mov ah, 0
  7647 00009955 50                       push ax
  7648 00009956 E809F7                   call genCode8
  7649 00009959 83C402                   add  sp, 2
  7650                                  
  7651                                  ;-312             genCode8(SymbolInt);
  7652                                  
  7653 0000995C FF36[4C00]               push word [SymbolInt]
  7654 00009960 E8FFF6                   call genCode8
  7655 00009963 83C402                   add  sp, 2
  7656                                  
  7657                                  ;-313             return;   
  7658                                  
  7659 00009966 E9B500                   jmp @@retn
  7660                                  
  7661                                  ;-314         }
  7662                                  
  7663                                  
  7664                                  ;-315     }
  7665                                  
  7666                                  @@process310:
  7667                                  
  7668                                  ;-316     
  7669                                  
  7670                                  
  7671                                  ;-317     if (CodeType == 30) {//enter i18,i8
  7672                                  
  7673                                  @@process309:
  7674 00009969 A0[3102]                 mov al, [CodeType]
  7675 0000996C 3C1E                     cmp al, 30
  7676 0000996E 0F855200                 jne @@process311
  7677                                  
  7678                                  ;-318         genCode8(0xC8);
  7679                                  
  7680 00009972 68C800                   push 200
  7681 00009975 E8EAF6                   call genCode8
  7682 00009978 83C402                   add  sp, 2
  7683                                  
  7684                                  ;-319         Op=getOp1();
  7685                                  
  7686 0000997B E86CDC                   call getOp1
  7687 0000997E A2[2F02]                 mov byte [Op], al
  7688                                  
  7689                                  ;-320         if (Op == IMM) genCode16(SymbolInt);
  7690                                  
  7691 00009981 A0[2F02]                 mov al, [Op]
  7692 00009984 3C01                     cmp al, 1
  7693 00009986 0F850D00                 jne @@process312
  7694 0000998A FF36[4C00]               push word [SymbolInt]
  7695 0000998E E828F7                   call genCode16
  7696 00009991 83C402                   add  sp, 2
  7697                                  
  7698                                  ;-321         else numbererror();
  7699                                  
  7700 00009994 E90300                   jmp @@process313
  7701                                  @@process312:
  7702 00009997 E8D4F0                   call numbererror
  7703                                  
  7704                                  ;-322         need(',');
  7705                                  
  7706                                  @@process313:
  7707 0000999A 6A2C                     push 44
  7708 0000999C E87AE5                   call need
  7709 0000999F 83C402                   add  sp, 2
  7710                                  
  7711                                  ;-323         Op=getOp1();
  7712                                  
  7713 000099A2 E845DC                   call getOp1
  7714 000099A5 A2[2F02]                 mov byte [Op], al
  7715                                  
  7716                                  ;-324         if (Op == IMM) genCode8 (SymbolInt);
  7717                                  
  7718 000099A8 A0[2F02]                 mov al, [Op]
  7719 000099AB 3C01                     cmp al, 1
  7720 000099AD 0F850D00                 jne @@process314
  7721 000099B1 FF36[4C00]               push word [SymbolInt]
  7722 000099B5 E8AAF6                   call genCode8
  7723 000099B8 83C402                   add  sp, 2
  7724                                  
  7725                                  ;-325         else numbererror();           
  7726                                  
  7727 000099BB E90300                   jmp @@process315
  7728                                  @@process314:
  7729 000099BE E8ADF0                   call numbererror
  7730                                  
  7731                                  ;-326         return;
  7732                                  
  7733                                  @@process315:
  7734 000099C1 E95A00                   jmp @@retn
  7735                                  
  7736                                  ;-327     }
  7737                                  
  7738                                  
  7739                                  ;-328        
  7740                                  
  7741                                  
  7742                                  ;-329     if (CodeType==101) {//ORG nn
  7743                                  
  7744                                  @@process311:
  7745 000099C4 A0[3102]                 mov al, [CodeType]
  7746 000099C7 3C65                     cmp al, 101
  7747 000099C9 0F851500                 jne @@process316
  7748                                  
  7749                                  ;-330         if (TokeType != DIGIT) numbererror();
  7750                                  
  7751 000099CD A0[2E02]                 mov al, [TokeType]
  7752 000099D0 3C01                     cmp al, 1
  7753 000099D2 0F840300                 je  @@process317
  7754 000099D6 E895F0                   call numbererror
  7755                                  
  7756                                  ;-331         Origin=SymbolInt;
  7757                                  
  7758                                  @@process317:
  7759 000099D9 A1[4C00]                 mov ax, [SymbolInt]
  7760 000099DC A3[2702]                 mov word [Origin], ax
  7761                                  
  7762                                  ;-332         return;
  7763                                  
  7764 000099DF E93C00                   jmp @@retn
  7765                                  
  7766                                  ;-333     }
  7767                                  
  7768                                  
  7769                                  ;-334     
  7770                                  
  7771                                  
  7772                                  ;-335     if (CodeType == 102) {//section, segment  
  7773                                  
  7774                                  @@process316:
  7775 000099E2 A0[3102]                 mov al, [CodeType]
  7776 000099E5 3C66                     cmp al, 102
  7777 000099E7 0F850C00                 jne @@process318
  7778                                  
  7779                                  ;-336         //getTokeType();//ignore .bss .text .data 
  7780                                  
  7781                                  
  7782                                  ;-337         AbsoluteLab=0;//nasm resets erevy time
  7783                                  
  7784 000099EB 66B800000000             mov eax, 0
  7785 000099F1 A3[2902]                 mov word [AbsoluteLab], ax
  7786                                  
  7787                                  ;-338         return;  
  7788                                  
  7789 000099F4 E92700                   jmp @@retn
  7790                                  
  7791                                  ;-339     }
  7792                                  
  7793                                  
  7794                                  ;-340                
  7795                                  
  7796                                  
  7797                                  ;-341     if (CodeType == 110) {//absolute
  7798                                  
  7799                                  @@process318:
  7800 000099F7 A0[3102]                 mov al, [CodeType]
  7801 000099FA 3C6E                     cmp al, 110
  7802 000099FC 0F851500                 jne @@process319
  7803                                  
  7804                                  ;-342         if (TokeType != DIGIT) numbererror();
  7805                                  
  7806 00009A00 A0[2E02]                 mov al, [TokeType]
  7807 00009A03 3C01                     cmp al, 1
  7808 00009A05 0F840300                 je  @@process320
  7809 00009A09 E862F0                   call numbererror
  7810                                  
  7811                                  ;-343         AbsoluteLab=SymbolInt;
  7812                                  
  7813                                  @@process320:
  7814 00009A0C A1[4C00]                 mov ax, [SymbolInt]
  7815 00009A0F A3[2902]                 mov word [AbsoluteLab], ax
  7816                                  
  7817                                  ;-344         return;           
  7818                                  
  7819 00009A12 E90900                   jmp @@retn
  7820                                  
  7821                                  ;-345     }
  7822                                  
  7823                                  
  7824                                  ;-346                
  7825                                  
  7826                                  
  7827                                  ;-347     error1("Command not implemented or syntax error");
  7828                                  
  7829                                  @@process319:
  7830 00009A15 68[339A]                 push process_1
  7831 00009A18 E827EF                   call error1
  7832 00009A1B 83C402                   add  sp, 2
  7833                                  
  7834                                  ;-348 }    
  7835                                  
  7836 00009A1E C9                      @@retn: LEAVE
  7837 00009A1F C3                       ret
  7838                                  ; ENDP
  7839 00009A20 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7840 00009A29 7420616C6C6F776564-
  7841 00009A32 00                 
  7842 00009A33 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7843 00009A3C 6F7420696D706C656D-
  7844 00009A45 656E746564206F7220-
  7845 00009A4E 73796E746178206572-
  7846 00009A57 726F7200           
  7847                                   
  7848                                  ; missing functions: 
  7849                                  ; digit
  7850                                  ; strcpy
  7851                                  ; strcpy
  7852                                  ; eqstr
  7853                                  ; strlen
  7854                                  ; eqstr
  7855                                  ; eqstr
  7856                                  ; eqstr
  7857                                  ; eqstr
  7858                                  ; readRL
  7859                                  ; readRL
  7860                                  ; digit
  7861                                  ; digit
  7862                                  ; strcpy
  7863                                  ; toupper
  7864                                  ; strlen
  7865                                  ; strlen
  7866                                  ; eqstr
  7867                                  ; eqstr
  7868                                  ; eqstr
  7869                                  ; eqstr
  7870                                  ; eqstr
  7871                                  ; eqstr
  7872                                  ; eqstr
  7873                                  ; eqstr
  7874                                  ; eqstr
  7875                                  ; eqstr
  7876                                  ; eqstr
  7877                                  ; eqstr
  7878                                  ; eqstr
  7879                                  ; eqstr
  7880                                  ; eqstr
  7881                                  ; eqstr
  7882                                  ; eqstr
  7883                                  ; eqstr
  7884                                  ; eqstr
  7885                                  ; eqstr
  7886                                  ; eqstr
  7887                                  ; eqstr
  7888                                  ; eqstr
  7889                                  ; eqstr
  7890                                  ; eqstr
  7891                                  ; eqstr
  7892                                  ; eqstr
  7893                                  ; eqstr
  7894                                  ; eqstr
  7895                                  ; eqstr
  7896                                  ; writetty
  7897                                  ; writetty
  7898                                  ; fputcR
  7899                                  ; cputs
  7900                                  ; cputs
  7901                                  ; exitR
  7902                                  ; toupper
  7903                                  ; strcpy
  7904                                  ; strcat1
  7905                                  ; strcpy
  7906                                  ; strcat1
  7907                                  ; strcpy
  7908                                  ; strcat1
  7909                                  ; openR
  7910                                  ; cputs
  7911                                  ; cputs
  7912                                  ; exitR
  7913                                  ; creatR
  7914                                  ; cputs
  7915                                  ; cputs
  7916                                  ; exitR
  7917                                  ; creatR
  7918                                  ; cputs
  7919                                  ; cputs
  7920                                  ; exitR
  7921                                  ; strcpy
  7922                                  ; strlen
  7923                                  ; fputcR
  7924                                  ; fcloseR
  7925                                  ; fcloseR
  7926                                  ; fcloseR
  7927                                  ; exitR
  7928                                  ; Number of unresolved CALLs :   79
  7929                                  ;use archive file: AR.C
  7930                                  
  7931                                  ;-349 // AR.C Archive
  7932                                  
  7933                                  ;Number of CALLs:    2 : writetty
  7934                                  
  7935                                  writetty:  ; *** PROC ***
  7936 00009A5B B40E                     mov  ah, 14
  7937 00009A5D BB0000                   mov  bx, 0
  7938 00009A60 CD10                     int  16
  7939                                  
  7940                                  ;-350 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7941                                  
  7942 00009A62 C3                       ret
  7943                                  ; ENDP
  7944                                  ;Number of CALLs:    8 : cputs
  7945                                  
  7946                                  cputs:  ; *** PROC ***
  7947                                  ;Function : cputs, Number of local variables: 2
  7948                                  ;   # type sign width line used address name   list of local variables
  7949                                  ;  200 ptr sign byte   350 NULL bp+4    s
  7950                                  ;  201 var sign byte   350 NULL bp-2    c;
  7951 00009A63 C8020000                 ENTER  2,0
  7952                                  @@cputs321:
  7953 00009A67 8B5E04                   mov bx, [bp+4]
  7954 00009A6A 8A07                     mov al, [bx]
  7955 00009A6C B400                     mov ah, 0
  7956 00009A6E 08C0                     or  al, al
  7957 00009A70 0F841B00                 je @@cputs322
  7958 00009A74 8B5E04                   mov bx, [bp+4]
  7959 00009A77 8A07                     mov al, [bx]
  7960 00009A79 B400                     mov ah, 0
  7961 00009A7B 8846FE                   mov byte [bp-2], al
  7962 00009A7E 8A46FE                   mov al, byte [bp-2]
  7963 00009A81 B400                     mov ah, 0
  7964 00009A83 50                       push ax
  7965 00009A84 E8C401                   call putch
  7966 00009A87 83C402                   add  sp, 2
  7967 00009A8A FF4604                   inc  word [bp+4]
  7968 00009A8D EBD8                     jmp @@cputs321
  7969                                  @@cputs322:
  7970                                  
  7971                                  ;-351 int mkneg(int n) { n; __asm {neg ax} }
  7972 00009A8F C9                       LEAVE
  7973 00009A90 C3                       ret
  7974                                  ; ENDP
  7975                                  ;Number of CALLs:    2 : toupper
  7976                                  
  7977                                  toupper:  ; *** PROC ***
  7978                                  ;Function : toupper, Number of local variables: 1
  7979                                  ;   # type sign width line used address name   list of local variables
  7980                                  ;  200 ptr sign byte   351 NULL bp+4    s;
  7981 00009A91 C8000000                 ENTER  0,0
  7982                                  @@toupper323:
  7983 00009A95 8B5E04                   mov bx, [bp+4]
  7984 00009A98 8A07                     mov al, [bx]
  7985 00009A9A B400                     mov ah, 0
  7986 00009A9C 08C0                     or  al, al
  7987 00009A9E 0F843000                 je @@toupper324
  7988 00009AA2 8B5E04                   mov bx, [bp+4]
  7989 00009AA5 8A07                     mov al, [bx]
  7990 00009AA7 B400                     mov ah, 0
  7991 00009AA9 83F861                   cmp ax, 97 ;unsigned : 1
  7992 00009AAC 0F8C1D00                 jl  @@toupper325
  7993 00009AB0 8B5E04                   mov bx, [bp+4]
  7994 00009AB3 8A07                     mov al, [bx]
  7995 00009AB5 B400                     mov ah, 0
  7996 00009AB7 83F87A                   cmp ax, 122
  7997 00009ABA 0F8F0F00                 jg  @@toupper326
  7998 00009ABE 8B5E04                   mov bx, [bp+4]
  7999 00009AC1 8A07                     mov al, [bx]
  8000 00009AC3 B400                     mov ah, 0
  8001 00009AC5 83E820                   sub ax, 32
  8002 00009AC8 8B5E04                   mov  bx, [bp+4]
  8003 00009ACB 8807                     mov  [bx], al
  8004                                  @@toupper326:
  8005                                  @@toupper325:
  8006 00009ACD FF4604                   inc  word [bp+4]
  8007 00009AD0 EBC3                     jmp @@toupper323
  8008                                  @@toupper324:
  8009                                  
  8010                                  ;-352 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  8011                                  
  8012                                  
  8013                                  ;-353 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  8014 00009AD2 C9                       LEAVE
  8015 00009AD3 C3                       ret
  8016                                  ; ENDP
  8017                                  ;Number of CALLs:    4 : strlen
  8018                                  
  8019                                  strlen:  ; *** PROC ***
  8020                                  ;Function : strlen, Number of local variables: 2
  8021                                  ;   # type sign width line used address name   list of local variables
  8022                                  ;  200 ptr sign byte   353 NULL bp+4    s
  8023                                  ;  201 var sign word   353 NULL bp-2    c;
  8024 00009AD4 C8020000                 ENTER  2,0
  8025 00009AD8 66B800000000             mov eax, 0
  8026 00009ADE 8946FE                   mov word [bp-2], ax
  8027                                  @@strlen327:
  8028 00009AE1 8B5E04                   mov bx, [bp+4]
  8029 00009AE4 8A07                     mov al, [bx]
  8030 00009AE6 B400                     mov ah, 0
  8031 00009AE8 83F800                   cmp ax, 0
  8032 00009AEB 0F840800                 je  @@strlen328
  8033 00009AEF FF4604                   inc  word [bp+4]
  8034 00009AF2 FF46FE                   inc  word [bp-2]
  8035 00009AF5 EBEA                     jmp @@strlen327
  8036                                  @@strlen328:
  8037 00009AF7 8B46FE                   mov ax, [bp-2]
  8038 00009AFA E90000                   jmp @@retn
  8039                                  
  8040                                  ;-354 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  8041                                  
  8042 00009AFD C9                      @@retn: LEAVE
  8043 00009AFE C3                       ret
  8044                                  ; ENDP
  8045                                  ;Number of CALLs:    7 : strcpy
  8046                                  
  8047                                  strcpy:  ; *** PROC ***
  8048                                  ;Function : strcpy, Number of local variables: 2
  8049                                  ;   # type sign width line used address name   list of local variables
  8050                                  ;  200 ptr sign byte   354 NULL bp+4    s
  8051                                  ;  201 ptr sign byte   354 NULL bp+6    t;
  8052 00009AFF C8000000                 ENTER  0,0
  8053                                  @@strcpy329:
  8054 00009B03 8B5E06                   mov bx, [bp+6]
  8055 00009B06 8A07                     mov al, [bx]
  8056 00009B08 B400                     mov ah, 0
  8057 00009B0A 8B5E04                   mov  bx, [bp+4]
  8058 00009B0D 8807                     mov  [bx], al
  8059 00009B0F FF4604                   inc  word [bp+4]
  8060 00009B12 FF4606                   inc  word [bp+6]
  8061                                  
  8062                                  ;-355   while (*t!=0); *s=0; return s; }
  8063                                  
  8064 00009B15 8B5E06                   mov bx, [bp+6]
  8065 00009B18 8A07                     mov al, [bx]
  8066 00009B1A B400                     mov ah, 0
  8067 00009B1C 83F800                   cmp ax, 0
  8068 00009B1F 0F840200                 je  @@strcpy330
  8069 00009B23 EBDE                     jmp @@strcpy329
  8070                                  @@strcpy330:
  8071 00009B25 66B800000000             mov eax, 0
  8072 00009B2B 8B5E04                   mov  bx, [bp+4]
  8073 00009B2E 8807                     mov  [bx], al
  8074 00009B30 8B4604                   mov ax, [bp+4]
  8075 00009B33 E90000                   jmp @@retn
  8076                                  
  8077                                  ;-356 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  8078                                  
  8079 00009B36 C9                      @@retn: LEAVE
  8080 00009B37 C3                       ret
  8081                                  ; ENDP
  8082                                  ;Number of CALLs:    3 : digit
  8083                                  
  8084                                  digit:  ; *** PROC ***
  8085                                  ;Function : digit, Number of local variables: 1
  8086                                  ;   # type sign width line used address name   list of local variables
  8087                                  ;  200 var sign byte   356 NULL bp+4    c;
  8088 00009B38 C8000000                 ENTER  0,0
  8089 00009B3C 8A4604                   mov al, [bp+4]
  8090 00009B3F 3C30                     cmp al, 48
  8091 00009B41 0F8D0900                 jge @@digit331
  8092 00009B45 66B800000000             mov eax, 0
  8093 00009B4B E91B00                   jmp @@retn
  8094                                  @@digit331:
  8095 00009B4E 8A4604                   mov al, [bp+4]
  8096 00009B51 3C39                     cmp al, 57
  8097 00009B53 0F8E0900                 jle @@digit332
  8098 00009B57 66B800000000             mov eax, 0
  8099 00009B5D E90900                   jmp @@retn
  8100                                  @@digit332:
  8101 00009B60 66B801000000             mov eax, 1
  8102 00009B66 E90000                   jmp @@retn
  8103                                  
  8104                                  ;-357 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  8105                                  
  8106 00009B69 C9                      @@retn: LEAVE
  8107 00009B6A C3                       ret
  8108                                  ; ENDP
  8109                                  ;Number of CALLs:   35 : eqstr
  8110                                  
  8111                                  eqstr:  ; *** PROC ***
  8112                                  ;Function : eqstr, Number of local variables: 2
  8113                                  ;   # type sign width line used address name   list of local variables
  8114                                  ;  200 ptr sign byte   357 NULL bp+4    p
  8115                                  ;  201 ptr sign byte   357 NULL bp+6    q;
  8116 00009B6B C8000000                 ENTER  0,0
  8117                                  @@eqstr333:
  8118 00009B6F 8B5E04                   mov bx, [bp+4]
  8119 00009B72 8A07                     mov al, [bx]
  8120 00009B74 B400                     mov ah, 0
  8121 00009B76 08C0                     or  al, al
  8122 00009B78 0F842300                 je @@eqstr334
  8123                                  
  8124                                  ;-358     if (*p != *q) return 0; p++; q++; }
  8125                                  
  8126 00009B7C 8B5E04                   mov bx, [bp+4]
  8127 00009B7F 8A07                     mov al, [bx]
  8128 00009B81 B400                     mov ah, 0
  8129 00009B83 8B5E06                   mov bx, [bp+6]
  8130 00009B86 3A07                     cmp al, [bx]
  8131 00009B88 B400                     mov ah, 0
  8132 00009B8A 0F840900                 je  @@eqstr335
  8133 00009B8E 66B800000000             mov eax, 0
  8134 00009B94 E92700                   jmp @@retn
  8135                                  @@eqstr335:
  8136 00009B97 FF4604                   inc  word [bp+4]
  8137 00009B9A FF4606                   inc  word [bp+6]
  8138                                  
  8139                                  ;-359     if(*q) return 0; return 1; }
  8140                                  
  8141 00009B9D EBD0                     jmp @@eqstr333
  8142                                  @@eqstr334:
  8143 00009B9F 8B5E06                   mov bx, [bp+6]
  8144 00009BA2 8A07                     mov al, [bx]
  8145 00009BA4 B400                     mov ah, 0
  8146 00009BA6 08C0                     or  al, al
  8147 00009BA8 0F840900                 je @@eqstr336
  8148 00009BAC 66B800000000             mov eax, 0
  8149 00009BB2 E90900                   jmp @@retn
  8150                                  @@eqstr336:
  8151 00009BB5 66B801000000             mov eax, 1
  8152 00009BBB E90000                   jmp @@retn
  8153                                  
  8154                                  ;-360 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  8155                                  
  8156 00009BBE C9                      @@retn: LEAVE
  8157 00009BBF C3                       ret
  8158                                  ; ENDP
  8159                                  ;Number of CALLs:    3 : strcat1
  8160                                  
  8161                                  strcat1:  ; *** PROC ***
  8162                                  ;Function : strcat1, Number of local variables: 2
  8163                                  ;   # type sign width line used address name   list of local variables
  8164                                  ;  200 ptr sign byte   360 NULL bp+4    s
  8165                                  ;  201 ptr sign byte   360 NULL bp+6    t;
  8166 00009BC0 C8000000                 ENTER  0,0
  8167                                  @@strcat1337:
  8168 00009BC4 8B5E04                   mov bx, [bp+4]
  8169 00009BC7 8A07                     mov al, [bx]
  8170 00009BC9 B400                     mov ah, 0
  8171 00009BCB 83F800                   cmp ax, 0
  8172 00009BCE 0F840500                 je  @@strcat1338
  8173 00009BD2 FF4604                   inc  word [bp+4]
  8174 00009BD5 EBED                     jmp @@strcat1337
  8175                                  @@strcat1338:
  8176 00009BD7 FF7606                   push word [bp+6]
  8177 00009BDA FF7604                   push word [bp+4]
  8178 00009BDD E81FFF                   call strcpy
  8179 00009BE0 83C404                   add  sp, 4
  8180                                  
  8181                                  ;-361 int basename(char *s) { char *p; p=0;
  8182 00009BE3 C9                       LEAVE
  8183 00009BE4 C3                       ret
  8184                                  ; ENDP
  8185                                  ;Number of CALLs:    1 : openR
  8186                                  
  8187                                  openR:  ; *** PROC ***
  8188                                  ;Function : openR, Number of local variables: 1
  8189                                  ;   # type sign width line used address name   list of local variables
  8190                                  ;  200 ptr sign byte   361 NULL bp+4    s;
  8191 00009BE5 C8000000                 ENTER  0,0
  8192 00009BE9 8B5604                   mov  dx, [bp+4]
  8193 00009BEC B8023D                   mov  ax, 15618
  8194 00009BEF E87200                   call DosInt
  8195                                  
  8196                                  ;-362 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  8197 00009BF2 C9                       LEAVE
  8198 00009BF3 C3                       ret
  8199                                  ; ENDP
  8200                                  ;Number of CALLs:    2 : creatR
  8201                                  
  8202                                  creatR:  ; *** PROC ***
  8203                                  ;Function : creatR, Number of local variables: 1
  8204                                  ;   # type sign width line used address name   list of local variables
  8205                                  ;  200 ptr sign byte   362 NULL bp+4    s;
  8206 00009BF4 C8000000                 ENTER  0,0
  8207 00009BF8 8B5604                   mov  dx, [bp+4]
  8208 00009BFB B90000                   mov  cx, 0
  8209 00009BFE B8003C                   mov  ax, 15360
  8210 00009C01 E86000                   call DosInt
  8211                                  
  8212                                  ;-363 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  8213 00009C04 C9                       LEAVE
  8214 00009C05 C3                       ret
  8215                                  ; ENDP
  8216                                  ;Number of CALLs:    2 : readRL
  8217                                  
  8218                                  readRL:  ; *** PROC ***
  8219                                  ;Function : readRL, Number of local variables: 3
  8220                                  ;   # type sign width line used address name   list of local variables
  8221                                  ;  200 ptr sign byte   363 NULL bp+4    s
  8222                                  ;  201 var sign word   363 NULL bp+6    fd
  8223                                  ;  202 var sign word   363 NULL bp+8    len;
  8224 00009C06 C8000000                 ENTER  0,0
  8225 00009C0A 8B5604                   mov  dx, [bp+4]
  8226 00009C0D 8B4E08                   mov  cx, [bp+8]
  8227 00009C10 8B5E06                   mov  bx, [bp+6]
  8228 00009C13 B8003F                   mov  ax, 16128
  8229 00009C16 E84B00                   call DosInt
  8230                                  
  8231                                  ;-364 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  8232 00009C19 C9                       LEAVE
  8233 00009C1A C3                       ret
  8234                                  ; ENDP
  8235                                  ;Number of CALLs:    2 : fputcR
  8236                                  
  8237                                  fputcR:  ; *** PROC ***
  8238                                  ;Function : fputcR, Number of local variables: 2
  8239                                  ;   # type sign width line used address name   list of local variables
  8240                                  ;  200 ptr sign byte   364 NULL bp+4    n
  8241                                  ;  201 var sign word   364 NULL bp+6    fd;
  8242 00009C1B C8000000                 ENTER  0,0
  8243 00009C1F 8D5604                  lea dx, [bp+4]
  8244                                  
  8245                                  ;-365   cx=1; bx=fd; ax=0x4000; DosInt(); }
  8246                                  
  8247 00009C22 B90100                   mov  cx, 1
  8248 00009C25 8B5E06                   mov  bx, [bp+6]
  8249 00009C28 B80040                   mov  ax, 16384
  8250 00009C2B E83600                   call DosInt
  8251                                  
  8252                                  ;-366 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  8253 00009C2E C9                       LEAVE
  8254 00009C2F C3                       ret
  8255                                  ; ENDP
  8256                                  ;Number of CALLs:    3 : fcloseR
  8257                                  
  8258                                  fcloseR:  ; *** PROC ***
  8259                                  ;Function : fcloseR, Number of local variables: 1
  8260                                  ;   # type sign width line used address name   list of local variables
  8261                                  ;  200 var sign word   366 NULL bp+4    fd;
  8262 00009C30 C8000000                 ENTER  0,0
  8263 00009C34 8B5E04                   mov  bx, [bp+4]
  8264 00009C37 B8003E                   mov  ax, 15872
  8265 00009C3A CD21                     int  33
  8266                                  
  8267                                  ;-367 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  8268 00009C3C C9                       LEAVE
  8269 00009C3D C3                       ret
  8270                                  ; ENDP
  8271                                  ;Number of CALLs:    5 : exitR
  8272                                  
  8273                                  exitR:  ; *** PROC ***
  8274                                  ;Function : exitR, Number of local variables: 1
  8275                                  ;   # type sign width line used address name   list of local variables
  8276                                  ;  200 var sign byte   367 NULL bp+4    c;
  8277 00009C3E C8000000                 ENTER  0,0
  8278 00009C42 B44C                     mov  ah, 76
  8279 00009C44 8A4604                   mov  al, [bp+4]
  8280 00009C47 CD21                     int  33
  8281                                  
  8282                                  ;-368 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  8283 00009C49 C9                       LEAVE
  8284 00009C4A C3                       ret
  8285                                  ; ENDP
  8286                                  ;End of archive file. 
  8287                                   
  8288                                  ; missing functions: 
  8289                                  ; putch
  8290                                  ; DosInt
  8291                                  ; DosInt
  8292                                  ; DosInt
  8293                                  ; DosInt
  8294                                  ; Number of unresolved CALLs :    5
  8295                                  ;use archive file: AR.C
  8296                                  
  8297                                  ;-369 // AR.C Archive
  8298                                  
  8299                                  ;Number of CALLs:    1 : putch
  8300                                  
  8301                                  putch:  ; *** PROC ***
  8302                                  ;Function : putch, Number of local variables: 1
  8303                                  ;   # type sign width line used address name   list of local variables
  8304                                  ;  200 var sign byte   369 NULL bp+4    c;
  8305 00009C4B C8000000                 ENTER  0,0
  8306 00009C4F 807E040A                cmp byte [bp+4], 10
  8307 00009C53 0F850500                 jne @@putch339
  8308 00009C57 B00D                     mov  al, 13
  8309 00009C59 E8FFFD                   call writetty
  8310                                  @@putch339:
  8311 00009C5C 8A4604                   mov  al, [bp+4]
  8312 00009C5F E8F9FD                   call writetty
  8313                                  
  8314                                  ;-370 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  8315 00009C62 C9                       LEAVE
  8316 00009C63 C3                       ret
  8317                                  ; ENDP
  8318                                  ;Number of CALLs:    4 : DosInt
  8319                                  
  8320                                  DosInt:  ; *** PROC ***
  8321 00009C64 CD21                     int  33
  8322 00009C66 7304                     jae short @@DosInt340
  8323 00009C68 FF06[1E02]               inc  word [DOS_ERR]
  8324                                  @@DosInt340:
  8325                                  
  8326                                  ;-371 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  8327                                  
  8328 00009C6C C3                       ret
  8329                                  ; ENDP
  8330                                  ;End of archive file. 
  8331                                   
  8332                                  ; missing functions:  All FUNCTIONs in place
  8333 00009C6D E80000                  LastFunctionByt:db 0E8h, 0, 0
  8334 00009C70 58                      pop ax
  8335 00009C71 C3                      ret
  8336                                   
  8337                                  ;   # type sign width line used  address name   list of global variables
  8338                                  
  8339                                  ;    1 arr sign byte     1    2        0 Version1[9]
  8340                                  ;    2 var sign byte     1    3        0 LIST
  8341                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  8342                                  ;    4 arr sign byte     3   11        0 Symbol[31]
  8343                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  8344                                  ;    6 var unsg word     5   23        0 SymbolInt
  8345                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=255
  8346                                  ;    8 arr sign byte     7    4        0 InputBuf[255]
  8347                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  8348                                  ;   10 arr sign byte     9    5        0 namein[67]
  8349                                  ;   11 arr sign byte    10    6        0 namelst[67]
  8350                                  ;   12 arr sign byte    11    6        0 namebin[67]
  8351                                  ;   13 var sign word    12    4        0 asm_fd
  8352                                  ;   14 var sign word    13    3        0 lst_fd
  8353                                  ;   15 var sign word    14    3        0 bin_fd
  8354                                  ;   16 var sign word    15    6        0 DOS_ERR
  8355                                  ;   17 var sign word    16    4        0 ErrorCount
  8356                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  8357                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  8358                                  ;   20 var unsg word    20    7        0 PC
  8359                                  ;   21 var unsg word    21    5        0 Origin
  8360                                  ;   22 var unsg word    22    6        0 AbsoluteLab
  8361                                  ;   23 var unsg word    23    2        0 PCStart
  8362                                  ;   24 var sign byte    24    3        0 isLabel
  8363                                  ;   25 def unsg byte    25    -        0 DIGIT=1
  8364                                  ;   26 def unsg byte    26    -        0 LETTERE=2
  8365                                  ;   27 def unsg byte    27    -        0 ALNUME=3
  8366                                  ;   28 def unsg byte    28    -        0 NOALNUME=4
  8367                                  ;   29 var sign byte    29   26        0 TokeType
  8368                                  ;   30 def unsg byte    30    -        0 BYTE=1
  8369                                  ;   31 def unsg byte    31    -        0 WORD=2
  8370                                  ;   32 def unsg byte    32    -        0 DWORD=3
  8371                                  ;   33 def unsg byte    33    -        0 SEGREG=4
  8372                                  ;   34 def unsg byte    34    -        0 IMM=1
  8373                                  ;   35 def unsg byte    35    -        0 REG=2
  8374                                  ;   36 def unsg byte    36    -        0 ADR=3
  8375                                  ;   37 def unsg byte    37    -        0 MEM=4
  8376                                  ;   38 var sign byte    38   28        0 Op
  8377                                  ;   39 var sign byte    39   31        0 Op2
  8378                                  ;   40 var sign byte    40   27        0 CodeType
  8379                                  ;   41 var sign byte    41   23        0 Code1
  8380                                  ;   42 var sign byte    42    7        0 Code2
  8381                                  ;   43 var sign byte    43    3        0 Code3
  8382                                  ;   44 var sign byte    44   19        0 R2No
  8383                                  ;   45 var sign byte    45   16        0 R1No
  8384                                  ;   46 var sign byte    46   18        0 R2Type
  8385                                  ;   47 var sign byte    47   15        0 R1Type
  8386                                  ;   48 var sign byte    48   13        0 OpSize
  8387                                  ;   49 var sign byte    49    9        0 wflag
  8388                                  ;   50 var sign byte    50    3        0 dflag
  8389                                  ;   51 var sign byte    51    8        0 sflag
  8390                                  ;   52 var sign byte    52   15        0 rm
  8391                                  ;   53 var sign byte    53    5        0 isDirect
  8392                                  ;   54 var sign word    54   48        0 disp
  8393                                  ;   55 var unsg word    55   12        0 imme
  8394                                  ;   56 def unsg byte    57    -        0 OPMAXLEN=5
  8395                                  ;   57 arr sign byte    58    2        0 OpPos[5]
  8396                                  ;   58 var sign word    59    6        0 OpPrintIndex
  8397                                  ;   59 ptr sign byte    60   19        0 OpCodePtr
  8398                                  ;   60 var sign byte    61    4        0 PrintRA
  8399                                  ;   61 def unsg byte    63    -        0 LABELNAMESMAX=3969
  8400                                  ;   62 arr sign byte    64    3        0 LabelNames[4000]
  8401                                  ;   63 ptr sign byte    65    5        0 LabelNamePtr
  8402                                  ;   64 def unsg byte    66    -        0 LABELADRMAX=600
  8403                                  ;   65 arr unsg word    67    7        0 LabelAddr[600]
  8404                                  ;   66 var sign word    68    7        0 LabelMaxIx
  8405                                  ;   67 var sign word    69   10        0 LabelIx
  8406                                  ;   68 def unsg byte    71    -        0 JMPCALLNAMESMAX=1969
  8407                                  ;   69 arr sign byte    72    3        0 JmpCallNames[2000]
  8408                                  ;   70 ptr sign byte    73    5        0 JmpCallNamePtr
  8409                                  ;   71 def unsg byte    74    -        0 JMPCALLMAX=500
  8410                                  ;   72 arr unsg word    75    2        0 JmpCallAddr[500]
  8411                                  ;   73 var sign word    76    6        0 JmpCallMaxIx
  8412                                  ;   74 def unsg byte    78    -        0 FILEBINMAX=20000
  8413                                  ;   75 arr sign byte    79    4        0 FileBin[20000]
  8414                                  ;   76 var unsg word    80    6        0 BinLen
  8415                                  ;   77 ptr sign byte    82    1        0 arglen
  8416                                  ;   78 ptr sign byte    83    4        0 argv
  8417                                  ;   79 var sign byte     1    1        0 I_START
  8418                                  ;   80 arr sign byte     4 NULL        0 I_PUSHA[9]
  8419                                  ;   81 arr sign byte     5 NULL        0 I_POPA[8]
  8420                                  ;   82 arr sign byte     6 NULL        0 I_NOP[7]
  8421                                  ;   83 arr sign byte     7 NULL        0 I_CBW[7]
  8422                                  ;   84 arr sign byte     8 NULL        0 I_CWDE[8]
  8423                                  ;   85 arr sign byte     9 NULL        0 I_CWD[7]
  8424                                  ;   86 arr sign byte    10 NULL        0 I_CDQ[7]
  8425                                  ;   87 arr sign byte    11 NULL        0 I_WAIT[8]
  8426                                  ;   88 arr sign byte    12 NULL        0 I_PUSHF[9]
  8427                                  ;   89 arr sign byte    13 NULL        0 I_POPF[8]
  8428                                  ;   90 arr sign byte    14 NULL        0 I_SAHF[8]
  8429                                  ;   91 arr sign byte    15 NULL        0 I_LAHF[8]
  8430                                  ;   92 arr sign byte    16 NULL        0 I_MOVSB[9]
  8431                                  ;   93 arr sign byte    17 NULL        0 I_MOVSW[9]
  8432                                  ;   94 arr sign byte    18 NULL        0 I_CMPSB[9]
  8433                                  ;   95 arr sign byte    19 NULL        0 I_CMPSW[9]
  8434                                  ;   96 arr sign byte    20 NULL        0 I_STOSB[9]
  8435                                  ;   97 arr sign byte    21 NULL        0 I_STOSW[9]
  8436                                  ;   98 arr sign byte    22 NULL        0 I_LODSB[9]
  8437                                  ;   99 arr sign byte    23 NULL        0 I_LODSW[9]
  8438                                  ;  100 arr sign byte    24 NULL        0 I_SCASB[9]
  8439                                  ;  101 arr sign byte    25 NULL        0 I_SCASW[9]
  8440                                  ;  102 arr sign byte    26 NULL        0 I_LEAVE[9]
  8441                                  ;  103 arr sign byte    27 NULL        0 I_INT3[8]
  8442                                  ;  104 arr sign byte    28 NULL        0 I_INTO[8]
  8443                                  ;  105 arr sign byte    29 NULL        0 I_IRET[8]
  8444                                  ;  106 arr sign byte    30 NULL        0 I_XLAT[8]
  8445                                  ;  107 arr sign byte    31 NULL        0 I_LOCK[8]
  8446                                  ;  108 arr sign byte    32 NULL        0 I_REPNE[9]
  8447                                  ;  109 arr sign byte    33 NULL        0 I_REPNZ[9]
  8448                                  ;  110 arr sign byte    34 NULL        0 I_REPE[8]
  8449                                  ;  111 arr sign byte    35 NULL        0 I_REPZ[8]
  8450                                  ;  112 arr sign byte    36 NULL        0 I_HLT[7]
  8451                                  ;  113 arr sign byte    37 NULL        0 I_CLC[7]
  8452                                  ;  114 arr sign byte    38 NULL        0 I_STC[7]
  8453                                  ;  115 arr sign byte    39 NULL        0 I_CLI[7]
  8454                                  ;  116 arr sign byte    40 NULL        0 I_STI[7]
  8455                                  ;  117 arr sign byte    41 NULL        0 I_CLD[7]
  8456                                  ;  118 arr sign byte    42 NULL        0 I_STD[7]
  8457                                  ;  119 arr sign byte    44 NULL        0 I_INC[9]
  8458                                  ;  120 arr sign byte    45 NULL        0 I_DEC[9]
  8459                                  ;  121 arr sign byte    46 NULL        0 I_NOT[8]
  8460                                  ;  122 arr sign byte    47 NULL        0 I_NEG[8]
  8461                                  ;  123 arr sign byte    48 NULL        0 I_MUL[8]
  8462                                  ;  124 arr sign byte    49 NULL        0 I_IMUL[9]
  8463                                  ;  125 arr sign byte    50 NULL        0 I_DIV[8]
  8464                                  ;  126 arr sign byte    51 NULL        0 I_IDIV[9]
  8465                                  ;  127 arr sign byte    53 NULL        0 I_LES[7]
  8466                                  ;  128 arr sign byte    54 NULL        0 I_LDS[7]
  8467                                  ;  129 arr sign byte    55 NULL        0 I_LEA[7]
  8468                                  ;  130 arr sign byte    56 NULL        0 I_LSS[8]
  8469                                  ;  131 arr sign byte    57 NULL        0 I_LFS[8]
  8470                                  ;  132 arr sign byte    58 NULL        0 I_LGS[8]
  8471                                  ;  133 arr sign byte    60 NULL        0 I_ADD[7]
  8472                                  ;  134 arr sign byte    61 NULL        0 I_OR[6]
  8473                                  ;  135 arr sign byte    62 NULL        0 I_ADC[7]
  8474                                  ;  136 arr sign byte    63 NULL        0 I_SBB[7]
  8475                                  ;  137 arr sign byte    64 NULL        0 I_AND[7]
  8476                                  ;  138 arr sign byte    65 NULL        0 I_SUB[7]
  8477                                  ;  139 arr sign byte    66 NULL        0 I_XOR[7]
  8478                                  ;  140 arr sign byte    67 NULL        0 I_CMP[7]
  8479                                  ;  141 arr sign byte    68 NULL        0 I_TEST[11]
  8480                                  ;  142 arr sign byte    70 NULL        0 I_MOV[6]
  8481                                  ;  143 arr sign byte    71 NULL        0 I_MOVSX[9]
  8482                                  ;  144 arr sign byte    72 NULL        0 I_MOVZX[9]
  8483                                  ;  145 arr sign byte    74 NULL        0 I_JO[6]
  8484                                  ;  146 arr sign byte    75 NULL        0 I_JNO[7]
  8485                                  ;  147 arr sign byte    76 NULL        0 I_JB[6]
  8486                                  ;  148 arr sign byte    77 NULL        0 I_JC[6]
  8487                                  ;  149 arr sign byte    78 NULL        0 I_JNB[7]
  8488                                  ;  150 arr sign byte    79 NULL        0 I_JAE[7]
  8489                                  ;  151 arr sign byte    80 NULL        0 I_JNC[7]
  8490                                  ;  152 arr sign byte    81 NULL        0 I_JE[6]
  8491                                  ;  153 arr sign byte    82 NULL        0 I_JZ[6]
  8492                                  ;  154 arr sign byte    83 NULL        0 I_JNE[7]
  8493                                  ;  155 arr sign byte    84 NULL        0 I_JNZ[7]
  8494                                  ;  156 arr sign byte    85 NULL        0 I_JBE[7]
  8495                                  ;  157 arr sign byte    86 NULL        0 I_JNA[7]
  8496                                  ;  158 arr sign byte    87 NULL        0 I_JA[6]
  8497                                  ;  159 arr sign byte    88 NULL        0 I_JS[6]
  8498                                  ;  160 arr sign byte    89 NULL        0 I_JNS[7]
  8499                                  ;  161 arr sign byte    90 NULL        0 I_JP[6]
  8500                                  ;  162 arr sign byte    91 NULL        0 I_JPE[7]
  8501                                  ;  163 arr sign byte    92 NULL        0 I_JNP[7]
  8502                                  ;  164 arr sign byte    93 NULL        0 I_JPO[7]
  8503                                  ;  165 arr sign byte    94 NULL        0 I_JL[6]
  8504                                  ;  166 arr sign byte    95 NULL        0 I_JNL[7]
  8505                                  ;  167 arr sign byte    96 NULL        0 I_JGE[7]
  8506                                  ;  168 arr sign byte    97 NULL        0 I_JLE[7]
  8507                                  ;  169 arr sign byte    98 NULL        0 I_JNG[7]
  8508                                  ;  170 arr sign byte    99 NULL        0 I_JG[6]
  8509                                  ;  171 arr sign byte   101 NULL        0 I_JMP[8]
  8510                                  ;  172 arr sign byte   102 NULL        0 I_CALL[9]
  8511                                  ;  173 arr sign byte   104 NULL        0 I_RET[8]
  8512                                  ;  174 arr sign byte   105 NULL        0 I_RETF[9]
  8513                                  ;  175 arr sign byte   107 NULL        0 I_PUSH[11]
  8514                                  ;  176 arr sign byte   108 NULL        0 I_POP[10]
  8515                                  ;  177 arr sign byte   110 NULL        0 I_ROL[7]
  8516                                  ;  178 arr sign byte   111 NULL        0 I_ROR[7]
  8517                                  ;  179 arr sign byte   112 NULL        0 I_RCL[7]
  8518                                  ;  180 arr sign byte   113 NULL        0 I_RCR[7]
  8519                                  ;  181 arr sign byte   114 NULL        0 I_SHL[7]
  8520                                  ;  182 arr sign byte   115 NULL        0 I_SAL[7]
  8521                                  ;  183 arr sign byte   116 NULL        0 I_SHR[7]
  8522                                  ;  184 arr sign byte   117 NULL        0 I_SAR[7]
  8523                                  ;  185 arr sign byte   119 NULL        0 I_INT[8]
  8524                                  ;  186 arr sign byte   130 NULL        0 I_XCHG[9]
  8525                                  ;  187 arr sign byte   140 NULL        0 I_ENTER[8]
  8526                                  ;  188 arr sign byte   142 NULL        0 I_ORG[6]
  8527                                  ;  189 arr sign byte   144 NULL        0 I_SECTION[10]
  8528                                  ;  190 arr sign byte   145 NULL        0 I_SEGMENT[10]
  8529                                  ;  191 arr sign byte   146 NULL        0 I_ABSOLUTE[11]
  8530                                  ;  192 arr sign byte   147 NULL        0 I_DB[5]
  8531                                  ;  193 arr sign byte   148 NULL        0 I_DW[5]
  8532                                  ;  194 arr sign byte   149 NULL        0 I_DD[5]
  8533                                  ;  195 arr sign byte   150 NULL        0 I_RESB[7]
  8534                                  ;  196 arr sign byte   151 NULL        0 I_RESW[7]
  8535                                  ;  197 arr sign byte   152 NULL        0 I_RESD[7]
  8536                                  ;  198 var sign byte   153 NULL        0 I_END
  8537                                  
  8538                                  
  8539                                  ;   # Calls Line Width  Name   list of functions
  8540                                  
  8541                                  ;    0    2    1 word   ChangeDirection
  8542                                  ;    1    2    9 word   checkOpL
  8543                                  ;    2    4   18 word   check2Ops
  8544                                  ;    3    1   27 word   get2Ops
  8545                                  ;    4    3   33 word   getOpL
  8546                                  ;    5    2   41 word   getOpR
  8547                                  ;    6    4   51 word   getOp1
  8548                                  ;    7    1   67 word   getMEM
  8549                                  ;    8    1   90 word   getIndReg1
  8550                                  ;    9    1   98 word   getIndReg2
  8551                                  ;   10    2  108 word   setwflag
  8552                                  ;   11    2  119 word   setsflag
  8553                                  ;   12    2  129 word   checkConstSize
  8554                                  ;   13    1    1 word   parse
  8555                                  ;   14   15   35 word   getTokeType
  8556                                  ;   15    2   46 word   storeJmpCall
  8557                                  ;   16    2   57 word   storeLabel
  8558                                  ;   17    5   69 word   searchLabel
  8559                                  ;   18    1   82 word   getVariable
  8560                                  ;   19    2  129 word   lookCode
  8561                                  ;   20    1  145 word   getCodeSize
  8562                                  ;   21    8  153 word   isToken
  8563                                  ;   22    2  161 word   need
  8564                                  ;   23    1  170 word   skipRest
  8565                                  ;   24    1    1 word   getLine
  8566                                  ;   25    1   17 word   ifEOL
  8567                                  ;   26    3   24 word   skipBlank
  8568                                  ;   27    2   29 word   letterE
  8569                                  ;   28    1   39 word   alnumE
  8570                                  ;   29    1   44 word   getDigit
  8571                                  ;   30    1   56 word   getName
  8572                                  ;   31    1   75 word   testReg
  8573                                  ;   32    1    1 word   printLine
  8574                                  ;   33    7   23 word   prc
  8575                                  ;   34    1   35 word   prscomment
  8576                                  ;   35   28   43 word   prs
  8577                                  ;   36    3   65 word   printhex8a
  8578                                  ;   37    2   70 word   printhex4
  8579                                  ;   38    1   75 word   printhex16
  8580                                  ;   39    5   80 word   printIntU
  8581                                  ;   40   26   91 word   error1
  8582                                  ;   41   12   99 word   errorexit
  8583                                  ;   42 NULL  103 word   allowederror
  8584                                  ;   43    3  104 word   addrerror
  8585                                  ;   44    1  105 word   immeerror
  8586                                  ;   45    3  106 word   implerror
  8587                                  ;   46    4  107 word   indexerror
  8588                                  ;   47    3  108 word   invaloperror
  8589                                  ;   48    6  109 word   numbererror
  8590                                  ;   49    1  110 word   regmemerror
  8591                                  ;   50    3  111 word   reg16error
  8592                                  ;   51    1  112 word   segregerror
  8593                                  ;   52    5  113 word   syntaxerror
  8594                                  ;   53 NULL  115 word   addrexit
  8595                                  ;   54    3  116 word   dataexit
  8596                                  ;   55 NULL  117 word   internexit
  8597                                  ;   56 NULL    1 word   main
  8598                                  ;   57    1    9 word   getarg
  8599                                  ;   58    1   43 word   fixJmpCall
  8600                                  ;   59    1   74 word   epilog
  8601                                  ;   60    2  117 word   end1
  8602                                  ;   61    1    2 word   getCodes
  8603                                  ;   62    1    7 word   gen66h
  8604                                  ;   63    8    9 word   genCode2
  8605                                  ;   64   13   13 word   genCodeW
  8606                                  ;   65   33   17 word   genCode8
  8607                                  ;   66   13   28 word   genCode16
  8608                                  ;   67   13   32 word   writeEA
  8609                                  ;   68    4   74 word   genImmediate
  8610                                  ;   69    1   11 word   process
  8611                                  ;   70    4  349 word   writetty
  8612                                  ;   71    8  350 word   cputs
  8613                                  ;   72    2  351 word   toupper
  8614                                  ;   73    4  353 word   strlen
  8615                                  ;   74    8  354 word   strcpy
  8616                                  ;   75    3  356 word   digit
  8617                                  ;   76   35  357 word   eqstr
  8618                                  ;   77    3  360 word   strcat1
  8619                                  ;   78    1  361 word   openR
  8620                                  ;   79    2  362 word   creatR
  8621                                  ;   80    2  363 word   readRL
  8622                                  ;   81    2  364 word   fputcR
  8623                                  ;   82    3  366 word   fcloseR
  8624                                  ;   83    5  367 word   exitR
  8625                                  ;   84    1  369 word   putch
  8626                                  ;   85    4  370 word   DosInt
  8627                                  ;   86 NULL  371 word   LastFunctionByt
  8628                                  
  8629                                  ;    #  addr name   list of CALLs
  8630                                  
  8631                                  ;    0  1442 implerror
  8632                                  ;    1  1452 segregerror
  8633                                  ;    2  1464 setwflag
  8634                                  ;    3  1473 error1
  8635                                  ;    4  1480 error1
  8636                                  ;    5  1497 get2Ops
  8637                                  ;    6  1505 addrerror
  8638                                  ;    7  1515 invaloperror
  8639                                  ;    8  1528 immeerror
  8640                                  ;    9  1538 addrerror
  8641                                  ;   10  1548 invaloperror
  8642                                  ;   11  1561 setwflag
  8643                                  ;   12  1578 getOpL
  8644                                  ;   13  1585 need
  8645                                  ;   14  1590 getOpR
  8646                                  ;   15  1604 getOpR
  8647                                  ;   16  1618 getOp1
  8648                                  ;   17  1625 isToken
  8649                                  ;   18  1633 getMEM
  8650                                  ;   19  1640 invaloperror
  8651                                  ;   20  1653 error1
  8652                                  ;   21  1667 testReg
  8653                                  ;   22  1675 searchLabel
  8654                                  ;   23  1687 error1
  8655                                  ;   24  1703 getTokeType
  8656                                  ;   25  1715 getOp1
  8657                                  ;   26  1722 syntaxerror
  8658                                  ;   27  1734 getIndReg2
  8659                                  ;   28  1745 getIndReg1
  8660                                  ;   29  1756 isToken
  8661                                  ;   30  1764 getTokeType
  8662                                  ;   31  1776 numbererror
  8663                                  ;   32  1788 isToken
  8664                                  ;   33  1796 isToken
  8665                                  ;   34  1804 errorexit
  8666                                  ;   35  1825 indexerror
  8667                                  ;   36  1836 indexerror
  8668                                  ;   37  1860 indexerror
  8669                                  ;   38  1871 indexerror
  8670                                  ;   39  1891 gen66h
  8671                                  ;   40  1910 error1
  8672                                  ;   41  1941 getLine
  8673                                  ;   42  1949 getTokeType
  8674                                  ;   43  1961 storeLabel
  8675                                  ;   44  1972 getTokeType
  8676                                  ;   45  1984 lookCode
  8677                                  ;   46  1993 process
  8678                                  ;   47  2001 getVariable
  8679                                  ;   48  2013 skipRest
  8680                                  ;   49  2022 error1
  8681                                  ;   50  2029 error1
  8682                                  ;   51  2036 printLine
  8683                                  ;   52  2060 skipBlank
  8684                                  ;   53  2070 digit
  8685                                  ;   54  2076 getDigit
  8686                                  ;   55  2085 letterE
  8687                                  ;   56  2093 getName
  8688                                  ;   57  2116 errorexit
  8689                                  ;   58  2126 strcpy
  8690                                  ;   59  2133 errorexit
  8691                                  ;   60  2156 errorexit
  8692                                  ;   61  2166 searchLabel
  8693                                  ;   62  2178 error1
  8694                                  ;   63  2185 strcpy
  8695                                  ;   64  2192 errorexit
  8696                                  ;   65  2220 eqstr
  8697                                  ;   66  2226 strlen
  8698                                  ;   67  2247 storeLabel
  8699                                  ;   68  2258 getTokeType
  8700                                  ;   69  2270 lookCode
  8701                                  ;   70  2279 dataexit
  8702                                  ;   71  2288 dataexit
  8703                                  ;   72  2297 getTokeType
  8704                                  ;   73  2309 genCode8
  8705                                  ;   74  2318 skipBlank
  8706                                  ;   75  2328 isToken
  8707                                  ;   76  2336 genCode8
  8708                                  ;   77  2345 isToken
  8709                                  ;   78  2353 getTokeType
  8710                                  ;   79  2365 genCode16
  8711                                  ;   80  2375 isToken
  8712                                  ;   81  2383 implerror
  8713                                  ;   82  2393 getTokeType
  8714                                  ;   83  2405 syntaxerror
  8715                                  ;   84  2417 error1
  8716                                  ;   85  2424 numbererror
  8717                                  ;   86  2436 dataexit
  8718                                  ;   87  2454 eqstr
  8719                                  ;   88  2472 eqstr
  8720                                  ;   89  2478 getTokeType
  8721                                  ;   90  2490 eqstr
  8722                                  ;   91  2496 getTokeType
  8723                                  ;   92  2508 eqstr
  8724                                  ;   93  2514 getTokeType
  8725                                  ;   94  2536 skipBlank
  8726                                  ;   95  2553 isToken
  8727                                  ;   96  2561 getTokeType
  8728                                  ;   97  2573 error1
  8729                                  ;   98  2580 prs
  8730                                  ;   99  2584 prc
  8731                                  ;  100  2597 getTokeType
  8732                                  ;  101  2609 error1
  8733                                  ;  102  2626 readRL
  8734                                  ;  103  2633 errorexit
  8735                                  ;  104  2643 errorexit
  8736                                  ;  105  2653 ifEOL
  8737                                  ;  106  2667 readRL
  8738                                  ;  107  2703 digit
  8739                                  ;  108  2709 letterE
  8740                                  ;  109  2736 digit
  8741                                  ;  110  2756 alnumE
  8742                                  ;  111  2763 errorexit
  8743                                  ;  112  2773 strcpy
  8744                                  ;  113  2780 toupper
  8745                                  ;  114  2796 strlen
  8746                                  ;  115  2803 strlen
  8747                                  ;  116  2810 eqstr
  8748                                  ;  117  2816 eqstr
  8749                                  ;  118  2822 eqstr
  8750                                  ;  119  2828 eqstr
  8751                                  ;  120  2834 eqstr
  8752                                  ;  121  2840 eqstr
  8753                                  ;  122  2846 eqstr
  8754                                  ;  123  2852 eqstr
  8755                                  ;  124  2858 eqstr
  8756                                  ;  125  2864 eqstr
  8757                                  ;  126  2870 eqstr
  8758                                  ;  127  2876 eqstr
  8759                                  ;  128  2882 eqstr
  8760                                  ;  129  2888 eqstr
  8761                                  ;  130  2894 eqstr
  8762                                  ;  131  2900 eqstr
  8763                                  ;  132  2906 eqstr
  8764                                  ;  133  2912 eqstr
  8765                                  ;  134  2918 eqstr
  8766                                  ;  135  2924 eqstr
  8767                                  ;  136  2930 eqstr
  8768                                  ;  137  2936 eqstr
  8769                                  ;  138  2942 eqstr
  8770                                  ;  139  2948 eqstr
  8771                                  ;  140  2954 eqstr
  8772                                  ;  141  2960 eqstr
  8773                                  ;  142  2966 eqstr
  8774                                  ;  143  2972 eqstr
  8775                                  ;  144  2978 eqstr
  8776                                  ;  145  2984 eqstr
  8777                                  ;  146  3004 prs
  8778                                  ;  147  3008 printhex16
  8779                                  ;  148  3019 prs
  8780                                  ;  149  3023 prc
  8781                                  ;  150  3027 printhex8a
  8782                                  ;  151  3038 prs
  8783                                  ;  152  3042 prc
  8784                                  ;  153  3046 prscomment
  8785                                  ;  154  3063 writetty
  8786                                  ;  155  3072 writetty
  8787                                  ;  156  3081 fputcR
  8788                                  ;  157  3103 prc
  8789                                  ;  158  3119 prc
  8790                                  ;  159  3140 printhex4
  8791                                  ;  160  3150 printhex4
  8792                                  ;  161  3172 prc
  8793                                  ;  162  3194 printhex8a
  8794                                  ;  163  3205 printhex8a
  8795                                  ;  164  3230 printIntU
  8796                                  ;  165  3240 prc
  8797                                  ;  166  3253 prs
  8798                                  ;  167  3257 prs
  8799                                  ;  168  3261 prs
  8800                                  ;  169  3265 prs
  8801                                  ;  170  3281 error1
  8802                                  ;  171  3288 end1
  8803                                  ;  172  3306 error1
  8804                                  ;  173  3323 error1
  8805                                  ;  174  3340 error1
  8806                                  ;  175  3357 error1
  8807                                  ;  176  3375 error1
  8808                                  ;  177  3395 error1
  8809                                  ;  178  3414 error1
  8810                                  ;  179  3433 error1
  8811                                  ;  180  3451 error1
  8812                                  ;  181  3470 error1
  8813                                  ;  182  3489 error1
  8814                                  ;  183  3505 errorexit
  8815                                  ;  184  3524 errorexit
  8816                                  ;  185  3545 errorexit
  8817                                  ;  186  3560 getarg
  8818                                  ;  187  3567 parse
  8819                                  ;  188  3573 fixJmpCall
  8820                                  ;  189  3584 epilog
  8821                                  ;  190  3591 end1
  8822                                  ;  191  3615 cputs
  8823                                  ;  192  3621 cputs
  8824                                  ;  193  3627 exitR
  8825                                  ;  194  3633 toupper
  8826                                  ;  195  3641 strcpy
  8827                                  ;  196  3648 strcat1
  8828                                  ;  197  3656 strcpy
  8829                                  ;  198  3663 strcat1
  8830                                  ;  199  3671 strcpy
  8831                                  ;  200  3678 strcat1
  8832                                  ;  201  3686 openR
  8833                                  ;  202  3692 cputs
  8834                                  ;  203  3698 cputs
  8835                                  ;  204  3704 exitR
  8836                                  ;  205  3710 creatR
  8837                                  ;  206  3717 cputs
  8838                                  ;  207  3723 cputs
  8839                                  ;  208  3729 exitR
  8840                                  ;  209  3735 creatR
  8841                                  ;  210  3742 cputs
  8842                                  ;  211  3748 cputs
  8843                                  ;  212  3754 exitR
  8844                                  ;  213  3760 prs
  8845                                  ;  214  3764 prs
  8846                                  ;  215  3768 prs
  8847                                  ;  216  3772 prs
  8848                                  ;  217  3776 prs
  8849                                  ;  218  3780 prs
  8850                                  ;  219  3784 prs
  8851                                  ;  220  3788 prs
  8852                                  ;  221  3792 prs
  8853                                  ;  222  3820 prs
  8854                                  ;  223  3824 printIntU
  8855                                  ;  224  3834 strcpy
  8856                                  ;  225  3841 strlen
  8857                                  ;  226  3848 searchLabel
  8858                                  ;  227  3860 error1
  8859                                  ;  228  3880 prs
  8860                                  ;  229  3884 printIntU
  8861                                  ;  230  3894 prs
  8862                                  ;  231  3898 prs
  8863                                  ;  232  3902 prs
  8864                                  ;  233  3906 prs
  8865                                  ;  234  3910 prs
  8866                                  ;  235  3914 prs
  8867                                  ;  236  3918 printIntU
  8868                                  ;  237  3928 prs
  8869                                  ;  238  3932 fputcR
  8870                                  ;  239  3939 prs
  8871                                  ;  240  3943 printIntU
  8872                                  ;  241  3953 prs
  8873                                  ;  242  3964 fcloseR
  8874                                  ;  243  3972 fcloseR
  8875                                  ;  244  3980 fcloseR
  8876                                  ;  245  3988 exitR
  8877                                  ;  246  4010 genCode8
  8878                                  ;  247  4032 genCode8
  8879                                  ;  248  4052 genCode8
  8880                                  ;  249  4072 errorexit
  8881                                  ;  250  4094 genCode8
  8882                                  ;  251  4103 genCode8
  8883                                  ;  252  4128 genCode8
  8884                                  ;  253  4137 genCode8
  8885                                  ;  254  4146 genCode16
  8886                                  ;  255  4169 genCode16
  8887                                  ;  256  4179 genCode8
  8888                                  ;  257  4198 getTokeType
  8889                                  ;  258  4210 getCodeSize
  8890                                  ;  259  4222 getCodes
  8891                                  ;  260  4231 genCode8
  8892                                  ;  261  4240 getOpL
  8893                                  ;  262  4247 checkOpL
  8894                                  ;  263  4256 genCode2
  8895                                  ;  264  4265 getTokeType
  8896                                  ;  265  4277 implerror
  8897                                  ;  266  4287 genCodeW
  8898                                  ;  267  4296 writeEA
  8899                                  ;  268  4304 check2Ops
  8900                                  ;  269  4314 reg16error
  8901                                  ;  270  4325 addrerror
  8902                                  ;  271  4335 genCode8
  8903                                  ;  272  4344 genCode8
  8904                                  ;  273  4353 writeEA
  8905                                  ;  274  4361 check2Ops
  8906                                  ;  275  4371 setsflag
  8907                                  ;  276  4380 genCodeW
  8908                                  ;  277  4389 genImmediate
  8909                                  ;  278  4402 genCodeW
  8910                                  ;  279  4411 writeEA
  8911                                  ;  280  4419 genCode8
  8912                                  ;  281  4428 genImmediate
  8913                                  ;  282  4441 genCodeW
  8914                                  ;  283  4450 writeEA
  8915                                  ;  284  4458 genCodeW
  8916                                  ;  285  4467 writeEA
  8917                                  ;  286  4475 syntaxerror
  8918                                  ;  287  4487 check2Ops
  8919                                  ;  288  4497 genCode2
  8920                                  ;  289  4506 genImmediate
  8921                                  ;  290  4519 genCodeW
  8922                                  ;  291  4528 writeEA
  8923                                  ;  292  4536 genImmediate
  8924                                  ;  293  4549 regmemerror
  8925                                  ;  294  4561 ChangeDirection
  8926                                  ;  295  4577 reg16error
  8927                                  ;  296  4588 genCode2
  8928                                  ;  297  4597 writeEA
  8929                                  ;  298  4605 genCodeW
  8930                                  ;  299  4614 genCode16
  8931                                  ;  300  4624 genCodeW
  8932                                  ;  301  4633 genCode16
  8933                                  ;  302  4643 genCodeW
  8934                                  ;  303  4652 writeEA
  8935                                  ;  304  4660 ChangeDirection
  8936                                  ;  305  4676 genCodeW
  8937                                  ;  306  4685 writeEA
  8938                                  ;  307  4693 syntaxerror
  8939                                  ;  308  4705 searchLabel
  8940                                  ;  309  4717 checkConstSize
  8941                                  ;  310  4732 genCode2
  8942                                  ;  311  4741 genCode8
  8943                                  ;  312  4750 genCode8
  8944                                  ;  313  4759 genCode2
  8945                                  ;  314  4768 genCode16
  8946                                  ;  315  4778 genCode8
  8947                                  ;  316  4787 genCode2
  8948                                  ;  317  4796 genCode16
  8949                                  ;  318  4806 storeJmpCall
  8950                                  ;  319  4819 searchLabel
  8951                                  ;  320  4831 checkConstSize
  8952                                  ;  321  4846 genCode8
  8953                                  ;  322  4855 genCode8
  8954                                  ;  323  4864 genCode8
  8955                                  ;  324  4873 genCode16
  8956                                  ;  325  4883 genCode8
  8957                                  ;  326  4892 genCode16
  8958                                  ;  327  4902 genCode8
  8959                                  ;  328  4911 genCode16
  8960                                  ;  329  4921 storeJmpCall
  8961                                  ;  330  4934 genCode8
  8962                                  ;  331  4943 genCode16
  8963                                  ;  332  4953 genCode8
  8964                                  ;  333  4962 getOpL
  8965                                  ;  334  4969 setsflag
  8966                                  ;  335  4978 genCode2
  8967                                  ;  336  4987 genCode8
  8968                                  ;  337  4996 genCode16
  8969                                  ;  338  5006 error1
  8970                                  ;  339  5013 genCode8
  8971                                  ;  340  5022 genCode8
  8972                                  ;  341  5031 checkOpL
  8973                                  ;  342  5040 reg16error
  8974                                  ;  343  5051 genCode2
  8975                                  ;  344  5060 genCode8
  8976                                  ;  345  5069 writeEA
  8977                                  ;  346  5077 syntaxerror
  8978                                  ;  347  5089 check2Ops
  8979                                  ;  348  5099 genCodeW
  8980                                  ;  349  5108 writeEA
  8981                                  ;  350  5116 genCodeW
  8982                                  ;  351  5125 writeEA
  8983                                  ;  352  5133 genCode8
  8984                                  ;  353  5142 genCodeW
  8985                                  ;  354  5151 writeEA
  8986                                  ;  355  5159 genCode8
  8987                                  ;  356  5168 genCode8
  8988                                  ;  357  5177 genCode8
  8989                                  ;  358  5186 getOp1
  8990                                  ;  359  5193 genCode16
  8991                                  ;  360  5203 numbererror
  8992                                  ;  361  5215 need
  8993                                  ;  362  5220 getOp1
  8994                                  ;  363  5227 genCode8
  8995                                  ;  364  5236 numbererror
  8996                                  ;  365  5248 numbererror
  8997                                  ;  366  5260 numbererror
  8998                                  ;  367  5272 error1
  8999                                  ;  368  5298 putch
  9000                                  ;  369  5366 strcpy
  9001                                  ;  370  5381 DosInt
  9002                                  ;  371  5397 DosInt
  9003                                  ;  372  5420 DosInt
  9004                                  ;  373  5439 DosInt
  9005                                  ;  374  5473 writetty
  9006                                  ;  375  5482 writetty
  9007                                  ;Input: AS.C, List: AS.S,  Lines:  372
  9008                                  ;Glob. variables:  198 max.:  200
  9009                                  ;Local variables:    5 max.:  100, in 'fixJmpCall'
  9010                                  ;Functions      :   87 max.:  300
  9011                                  ;Calls          :  376 max.: 2000, NameField: 5514 max.:    65535
  9012                                  ;Code until     :25998 max.: 30000, free: 4002
  9013                                  ;Data (HeapEnd) :58723, resting stacksize:  6812
  9014                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
