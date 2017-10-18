     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9DC1C                  jmp main
     5                                  
     6                                  ;-1 char Version1[]="AS.C V0.2";//BAS.BAT, AS TE, NAS.BAT
     7                                  
     8 00000003 41532E432056302E32-     Version1 db "AS.C V0.2",0
     9 0000000C 00                 
    10                                  
    11                                  ;-2 //#include "DECL.C"
    12                                  
    13                                  
    14                                  ;-3 #define SYMBOLMAX    31
    15                                  
    16                                  
    17                                  ;-4 char Symbol[SYMBOLMAX]; //next symbol to decode
    18                                  
    19                                  section .bss
    20                                  absolute 30000
    21 00007530 <res 0000001F>          Symbol resb 31
    22                                  section .text
    23                                  
    24                                  ;-5 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    25                                  
    26                                  section .bss
    27                                  absolute 30031
    28 0000754F <res 0000001F>          SymbolUpper resb 31
    29                                  section .text
    30                                  
    31                                  ;-6 char ProcName[SYMBOLMAX];//name of actual proc
    32                                  
    33                                  section .bss
    34                                  absolute 30062
    35 0000756E <res 0000001F>          ProcName resb 31
    36                                  section .text
    37                                  
    38                                  ;-7 char isInProc=0;        //is inside a procedure
    39                                  
    40 0000000D 00                      isInProc db 0
    41                                  
    42                                  ;-8 unsigned int SymbolInt; //integer value set in getDigit
    43                                  
    44 0000000E 0000                    SymbolInt dw 0
    45                                  
    46                                  ;-9 unsigned long SymbolLong;//integer value set in getDigit
    47                                  
    48 00000010 00000000                SymbolLong dd 0
    49                                  
    50                                  ;-10 #define INPUTBUFMAX 255
    51                                  
    52                                  
    53                                  ;-11 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    54                                  
    55                                  section .bss
    56                                  absolute 30093
    57 0000758D <res 000000FF>          InputBuf resb 255
    58                                  section .text
    59                                  
    60                                  ;-12 unsigned char *InputPtr;//position in InputBuf
    61                                  
    62 00000014 0000                    InputPtr dw 0
    63                                  
    64                                  ;-13 char namein [67];       //input file name  .S
    65                                  
    66                                  section .bss
    67                                  absolute 30348
    68 0000768C <res 00000043>          namein resb 67
    69                                  section .text
    70                                  
    71                                  ;-14 char namelst[67];       //list file name   .LST
    72                                  
    73                                  section .bss
    74                                  absolute 30415
    75 000076CF <res 00000043>          namelst resb 67
    76                                  section .text
    77                                  
    78                                  ;-15 char namebin[67];       //output file name .COM
    79                                  
    80                                  section .bss
    81                                  absolute 30482
    82 00007712 <res 00000043>          namebin resb 67
    83                                  section .text
    84                                  
    85                                  ;-16 int  asm_fd;            //input file descriptor
    86                                  
    87 00000016 0000                    asm_fd dw 0
    88                                  
    89                                  ;-17 int lst_fd;             //list file descriptor
    90                                  
    91 00000018 0000                    lst_fd dw 0
    92                                  
    93                                  ;-18 int bin_fd;             //output file descriptor
    94                                  
    95 0000001A 0000                    bin_fd dw 0
    96                                  
    97                                  ;-19 int DOS_ERR=0;          //global var
    98                                  
    99 0000001C 0000                    DOS_ERR dw 0
   100                                  
   101                                  ;-20 int ErrorCount=0;       //number of errors
   102                                  
   103 0000001E 0000                    ErrorCount dw 0
   104                                  
   105                                  ;-21 int DOS_NoBytes;        //number of bytes read (0 or 1)
   106                                  
   107 00000020 0000                    DOS_NoBytes dw 0
   108                                  
   109                                  ;-22 char DOS_ByteRead;      //the byte just read by DOS
   110                                  
   111 00000022 00                      DOS_ByteRead db 0
   112                                  
   113                                  ;-23 
   114                                  
   115                                  
   116                                  ;-24 unsigned int PC=0;      //program counter
   117                                  
   118 00000023 0000                    PC dw 0
   119                                  
   120                                  ;-25 unsigned int Origin=0;  //ORG nn
   121                                  
   122 00000025 0000                    Origin dw 0
   123                                  
   124                                  ;-26 unsigned int AbsoluteLab=0;//uninitialised data
   125                                  
   126 00000027 0000                    AbsoluteLab dw 0
   127                                  
   128                                  ;-27 unsigned int PCStart;   //PC at start of line by PrintLine()
   129                                  
   130 00000029 0000                    PCStart dw 0
   131                                  
   132                                  ;-28 char isLabel;           //by getName()
   133                                  
   134 0000002B 00                      isLabel db 0
   135                                  
   136                                  ;-29 #define DIGIT    1      //0-9
   137                                  
   138                                  
   139                                  ;-30 #define LETTERE  2      //a-z A-Z @ . _
   140                                  
   141                                  
   142                                  ;-31 #define ALNUME   3      //a-z A-Z @ . _  0-9
   143                                  
   144                                  
   145                                  ;-32 #define NOALNUME 4      //other char
   146                                  
   147                                  
   148                                  ;-33 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   149                                  
   150 0000002C 00                      TokeType db 0
   151                                  
   152                                  ;-34 #define BYTE     1
   153                                  
   154                                  
   155                                  ;-35 #define WORD     2
   156                                  
   157                                  
   158                                  ;-36 #define DWORD    3
   159                                  
   160                                  
   161                                  ;-37 #define SEGREG   4
   162                                  
   163                                  
   164                                  ;-38 #define IMM      1      //const  ,123
   165                                  
   166                                  
   167                                  ;-39 #define REG      2      //       ,BX    mode=11
   168                                  
   169                                  
   170                                  ;-40 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   171                                  
   172                                  
   173                                  ;-41 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   174                                  
   175                                  
   176                                  ;-42 char Op;                //1. operand: 0, IMM, REG, ADR, MEM
   177                                  
   178 0000002D 00                      Op db 0
   179                                  
   180                                  ;-43 char Op2;               //2. operand
   181                                  
   182 0000002E 00                      Op2 db 0
   183                                  
   184                                  ;-44 char CodeType;          //1-207 by searchSymbol(), must be byte size
   185                                  
   186 0000002F 00                      CodeType db 0
   187                                  
   188                                  ;-45 char Code1;             //1. Opcode
   189                                  
   190 00000030 00                      Code1 db 0
   191                                  
   192                                  ;-46 char Code2;             //2. Opcode
   193                                  
   194 00000031 00                      Code2 db 0
   195                                  
   196                                  ;-47 char Code3;             //3. Opcode
   197                                  
   198 00000032 00                      Code3 db 0
   199                                  
   200                                  ;-48 char R2No;              //0 - 7 AL, CL, ...  set in testReg()
   201                                  
   202 00000033 00                      R2No db 0
   203                                  
   204                                  ;-49 char R1No;              //temp for 1. register
   205                                  
   206 00000034 00                      R1No db 0
   207                                  
   208                                  ;-50 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   209                                  
   210 00000035 00                      R2Type db 0
   211                                  
   212                                  ;-51 char R1Type;            //temp for 1. register
   213                                  
   214 00000036 00                      R1Type db 0
   215                                  
   216                                  ;-52 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   217                                  
   218 00000037 00                      OpSize db 0
   219                                  
   220                                  ;-53 char wflag;             //wordflag: 0=byte, 1=word/dword
   221                                  
   222 00000038 00                      wflag db 0
   223                                  
   224                                  ;-54 char dflag;             //directionflag: 1=to reg MOV,ALU
   225                                  
   226 00000039 00                      dflag db 0
   227                                  
   228                                  ;-55 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3
   229                                  
   230 0000003A 00                      sflag db 0
   231                                  
   232                                  ;-56 char rm;                //combination of index and base reg
   233                                  
   234 0000003B 00                      rm db 0
   235                                  
   236                                  ;-57 char isDirect;          //set in process and getMeM, need in WriteEA
   237                                  
   238 0000003C 00                      isDirect db 0
   239                                  
   240                                  ;-58 int disp;               //displacement      0-8 bytes
   241                                  
   242 0000003D 0000                    disp dw 0
   243                                  
   244                                  ;-59 unsigned int imme;      //immediate         0-8 bytes
   245                                  
   246 0000003F 0000                    imme dw 0
   247                                  
   248                                  ;-60 
   249                                  
   250                                  
   251                                  ;-61 #define OPMAXLEN 5
   252                                  
   253                                  
   254                                  ;-62 char OpPos[OPMAXLEN];   //array for one opcode to list
   255                                  
   256                                  section .bss
   257                                  absolute 30549
   258 00007755 <res 00000005>          OpPos resb 5
   259                                  section .text
   260                                  
   261                                  ;-63 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   262                                  
   263 00000041 0000                    OpPrintIndex dw 0
   264                                  
   265                                  ;-64 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   266                                  
   267 00000043 0000                    OpCodePtr dw 0
   268                                  
   269                                  ;-65 char PrintRA;           //print * for forward relocative jmp
   270                                  
   271 00000045 00                      PrintRA db 0
   272                                  
   273                                  ;-66 
   274                                  
   275                                  
   276                                  ;-67 #define LABELNAMESMAX 5969//next number - SYMBOLMAX
   277                                  
   278                                  
   279                                  ;-68 char LabelNames[6000];  //space for names of all labels
   280                                  
   281                                  section .bss
   282                                  absolute 30554
   283 0000775A <res 00001770>          LabelNames resb 6000
   284                                  section .text
   285                                  
   286                                  ;-69 char *LabelNamePtr;     //first free position
   287                                  
   288 00000046 0000                    LabelNamePtr dw 0
   289                                  
   290                                  ;-70 char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr
   291                                  
   292 00000048 0000                    tmpLabelNamePtr dw 0
   293                                  
   294                                  ;-71 
   295                                  
   296                                  
   297                                  ;-72 #define LABELADRMAX 600
   298                                  
   299                                  
   300                                  ;-73 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   301                                  
   302                                  section .bss
   303                                  absolute 36554
   304 00008ECA <res 000004B0>          LabelAddr resw 600
   305                                  section .text
   306                                  
   307                                  ;-74 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   308                                  
   309 0000004A 0000                    LabelMaxIx dw 0
   310                                  
   311                                  ;-75 int tmpLabelMaxIx;      //set after PROC to LabelMaxIx
   312                                  
   313 0000004C 0000                    tmpLabelMaxIx dw 0
   314                                  
   315                                  ;-76 int LabelIx;            //actual # of just searched label
   316                                  
   317 0000004E 0000                    LabelIx dw 0
   318                                  
   319                                  ;-77 
   320                                  
   321                                  
   322                                  ;-78 #define JMPNAMESMAX 3969//next number - SYMBOLMAX
   323                                  
   324                                  
   325                                  ;-79 char JmpNames[4000];    //space for names of jmp, call
   326                                  
   327                                  section .bss
   328                                  absolute 37754
   329 0000937A <res 00000FA0>          JmpNames resb 4000
   330                                  section .text
   331                                  
   332                                  ;-80 char *JmpNamePtr;       //first free position
   333                                  
   334 00000050 0000                    JmpNamePtr dw 0
   335                                  
   336                                  ;-81 char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr
   337                                  
   338 00000052 0000                    tmpJmpNamePtr dw 0
   339                                  
   340                                  ;-82 
   341                                  
   342                                  
   343                                  ;-83 #define JMPMAX 200      //max. jmp and call
   344                                  
   345                                  
   346                                  ;-84 unsigned int JmpAddr[JMPMAX];//addr to be fixed
   347                                  
   348                                  section .bss
   349                                  absolute 41754
   350 0000A31A <res 00000190>          JmpAddr resw 200
   351                                  section .text
   352                                  
   353                                  ;-85 int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1
   354                                  
   355 00000054 0000                    JmpMaxIx dw 0
   356                                  
   357                                  ;-86 int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx
   358                                  
   359 00000056 0000                    tmpJmpMaxIx dw 0
   360                                  
   361                                  ;-87 
   362                                  
   363                                  
   364                                  ;-88 #define FILEBINMAX 20000
   365                                  
   366                                  
   367                                  ;-89 char FileBin  [FILEBINMAX];//output binary file
   368                                  
   369                                  section .bss
   370                                  absolute 42154
   371 0000A4AA <res 00004E20>          FileBin resb 20000
   372                                  section .text
   373                                  
   374                                  ;-90 unsigned int BinLen=0;  //length of binary file
   375                                  
   376 00000058 0000                    BinLen dw 0
   377                                  
   378                                  ;-91 
   379                                  
   380                                  
   381                                  ;-92 char *arglen=0x80;      // for main only
   382                                  
   383 0000005A 8000                    arglen dw 128
   384                                  
   385                                  ;-93 char *argv=0x82;        // for main only
   386                                  
   387 0000005C 8200                    argv dw 130
   388                                  
   389                                  ;-94 
   390                                  
   391                                  
   392                                  ;-95 
   393                                  
   394                                  
   395                                  ;-96 //#include "OPTABL.C"
   396                                  
   397                                  
   398                                  ;-97 char I_START=0xF1;
   399                                  
   400 0000005E F1                      I_START db 241
   401                                  
   402                                  ;-98 //OpName, 0, CodeType, OpCode1-n, F1h
   403                                  
   404                                  
   405                                  ;-99 //  1:   1 byte opcode
   406                                  
   407                                  
   408                                  ;-100 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
   409                                  
   410 0000005F 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
   411 00000068 504F5041000161F1   
   412                                  
   413                                  ;-101 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
   414                                  
   415 00000070 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
   416 00000079 57000198F1         
   417                                  
   418                                  ;-102 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
   419                                  
   420 0000007E 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
   421 00000087 5744000199F1       
   422                                  
   423                                  ;-103 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
   424                                  
   425 0000008D 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
   426 00000096 495400019BF1       
   427                                  
   428                                  ;-104 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
   429                                  
   430 0000009C 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
   431 000000A5 504F504600019DF1   
   432                                  
   433                                  ;-105 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
   434                                  
   435 000000AD 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
   436 000000B6 41484600019FF1     
   437                                  
   438                                  ;-106 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
   439                                  
   440 000000BD 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
   441 000000C6 4D4F5653570001A5F1 
   442                                  
   443                                  ;-107 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
   444                                  
   445 000000CF 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
   446 000000D8 434D5053570001A7F1 
   447                                  
   448                                  ;-108 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
   449                                  
   450 000000E1 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
   451 000000EA 53544F53570001ABF1 
   452                                  
   453                                  ;-109 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
   454                                  
   455 000000F3 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
   456 000000FC 4C4F4453570001ADF1 
   457                                  
   458                                  ;-110 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
   459                                  
   460 00000105 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
   461 0000010E 53434153570001AFF1 
   462                                  
   463                                  ;-111 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
   464                                  
   465 00000117 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
   466 00000120 494E54330001CCF1   
   467                                  
   468                                  ;-112 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
   469                                  
   470 00000128 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
   471 00000131 5245540001CFF1     
   472                                  
   473                                  ;-113 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
   474                                  
   475 00000138 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
   476 00000141 4F434B0001F0F1     
   477                                  
   478                                  ;-114 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
   479                                  
   480 00000148 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
   481 00000151 5245504E5A0001F2F1 
   482                                  
   483                                  ;-115 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
   484                                  
   485 0000015A 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
   486 00000163 45505A0001F3F1     
   487                                  
   488                                  ;-116 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
   489                                  
   490 0000016A 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
   491 00000173 430001F8F1         
   492                                  
   493                                  ;-117 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
   494                                  
   495 00000178 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
   496 00000181 490001FAF1         
   497                                  
   498                                  ;-118 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
   499                                  
   500 00000186 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
   501 0000018F 440001FCF1         
   502                                  
   503                                  ;-119 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
   504                                  
   505 00000194 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   506                                  
   507                                  ;-120 // 2: mem reg 16 bit
   508                                  
   509                                  
   510                                  ;-121 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   511                                  
   512 0000019B 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   513                                  
   514                                  ;-122 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   515                                  
   516 000001A4 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   517                                  
   518                                  ;-123 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   519                                  
   520 000001AD 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   521                                  
   522                                  ;-124 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   523                                  
   524 000001B5 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   525                                  
   526                                  ;-125 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   527                                  
   528 000001BD 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   529                                  
   530                                  ;-126 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   531                                  
   532 000001C5 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   533                                  
   534                                  ;-127 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   535                                  
   536 000001CE 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   537                                  
   538                                  ;-128 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   539                                  
   540 000001D6 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   541                                  
   542                                  ;-129 //  3: les, lda, lea, lss, lfs, lgs
   543                                  
   544                                  
   545                                  ;-130 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   546                                  
   547 000001DF 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   548                                  
   549                                  ;-131 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   550                                  
   551 000001E6 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   552                                  
   553                                  ;-132 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   554                                  
   555 000001ED 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   556                                  
   557                                  ;-133 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   558                                  
   559 000001F4 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   560                                  
   561                                  ;-134 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   562                                  
   563 000001FC 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   564                                  
   565                                  ;-135 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   566                                  
   567 00000204 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   568                                  
   569                                  ;-136 //  4: acc,imm  reg,imm  index,reg
   570                                  
   571                                  
   572                                  ;-137 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   573                                  
   574 0000020C 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   575                                  
   576                                  ;-138 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   577                                  
   578 00000213 4F52000401F1            I_OR db 79,82,0,4,1,241
   579                                  
   580                                  ;-139 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   581                                  
   582 00000219 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   583                                  
   584                                  ;-140 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   585                                  
   586 00000220 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   587                                  
   588                                  ;-141 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   589                                  
   590 00000227 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   591                                  
   592                                  ;-142 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   593                                  
   594 0000022E 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   595                                  
   596                                  ;-143 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   597                                  
   598 00000235 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   599                                  
   600                                  ;-144 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   601                                  
   602 0000023C 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   603                                  
   604                                  ;-145 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   605                                  
   606 00000243 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   607 0000024C 00F1               
   608                                  
   609                                  ;-146 //  5: mov
   610                                  
   611                                  
   612                                  ;-147 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   613                                  
   614 0000024E 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   615                                  
   616                                  ;-148 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   617                                  
   618 00000254 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   619                                  
   620                                  ;-149 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   621                                  
   622 0000025D 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   623                                  
   624                                  ;-150 //  6: single byte relative jump
   625                                  
   626                                  
   627                                  ;-151 char I_JO []=  {'J','O',0,     6, 0,0xF1};
   628                                  
   629 00000266 4A4F000600F1            I_JO db 74,79,0,6,0,241
   630                                  
   631                                  ;-152 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
   632                                  
   633 0000026C 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   634                                  
   635                                  ;-153 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
   636                                  
   637 00000273 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
   638 0000027C 0602F1             
   639                                  
   640                                  ;-154 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
   641                                  
   642 0000027F 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   643                                  
   644                                  ;-155 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
   645                                  
   646 00000286 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
   647 0000028F 43000603F1         
   648                                  
   649                                  ;-156 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
   650                                  
   651 00000294 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
   652 0000029D 0604F1             
   653                                  
   654                                  ;-157 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
   655                                  
   656 000002A0 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
   657 000002A9 5A000605F1         
   658                                  
   659                                  ;-158 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
   660                                  
   661 000002AE 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
   662 000002B7 41000606F1         
   663                                  
   664                                  ;-159 char I_JA []=  {'J','A',0,     6, 7,0xF1};
   665                                  
   666 000002BC 4A41000607F1            I_JA db 74,65,0,6,7,241
   667                                  
   668                                  ;-160 char I_JS []=  {'J','S',0,     6, 8,0xF1};
   669                                  
   670 000002C2 4A53000608F1            I_JS db 74,83,0,6,8,241
   671                                  
   672                                  ;-161 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
   673                                  
   674 000002C8 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   675                                  
   676                                  ;-162 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
   677                                  
   678 000002CF 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
   679 000002D8 00060AF1           
   680                                  
   681                                  ;-163 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
   682                                  
   683 000002DC 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
   684 000002E5 4F00060BF1         
   685                                  
   686                                  ;-164 char I_JL []=  {'J','L',0,     6,12,0xF1};
   687                                  
   688 000002EA 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   689                                  
   690                                  ;-165 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
   691                                  
   692 000002F0 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
   693 000002F9 4500060DF1         
   694                                  
   695                                  ;-166 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
   696                                  
   697 000002FE 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
   698 00000307 4700060EF1         
   699                                  
   700                                  ;-167 char I_JG []=  {'J','G',0,     6,15,0xF1};
   701                                  
   702 0000030C 4A4700060FF1            I_JG db 74,71,0,6,15,241
   703                                  
   704                                  ;-168 //  7: jmp, call
   705                                  
   706                                  
   707                                  ;-169 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   708                                  
   709 00000312 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   710                                  
   711                                  ;-170 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   712                                  
   713 0000031A 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   714                                  
   715                                  ;-171 //  8: ret
   716                                  
   717                                  
   718                                  ;-172 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   719                                  
   720 00000323 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   721                                  
   722                                  ;-173 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   723                                  
   724 0000032B 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   725                                  
   726                                  ;-174 //  9: seg, r/m
   727                                  
   728                                  
   729                                  ;-175 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   730                                  
   731 00000334 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   732 0000033D 06F1               
   733                                  
   734                                  ;-176 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   735                                  
   736 0000033F 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   737 00000348 F1                 
   738                                  
   739                                  ;-177 //  11: shift, rotates
   740                                  
   741                                  
   742                                  ;-178 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
   743                                  
   744 00000349 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
   745 00000352 52000B01F1         
   746                                  
   747                                  ;-179 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
   748                                  
   749 00000357 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
   750 00000360 52000B03F1         
   751                                  
   752                                  ;-180 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
   753                                  
   754 00000365 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
   755 0000036E 4C000B04F1         
   756                                  
   757                                  ;-181 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
   758                                  
   759 00000373 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
   760 0000037C 52000B07F1         
   761                                  
   762                                  ;-182 //  12: int
   763                                  
   764                                  
   765                                  ;-183 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   766                                  
   767 00000381 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   768                                  
   769                                  ;-184 //  14: in/out
   770                                  
   771                                  
   772                                  ;-185 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   773                                  
   774 00000389 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   775                                  
   776                                  ;-186 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   777                                  
   778 00000390 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   779                                  
   780                                  ;-187 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   781                                  
   782 00000398 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   783                                  
   784                                  ;-188 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   785                                  
   786 000003A0 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   787                                  
   788                                  ;-189 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   789                                  
   790 000003A8 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   791                                  
   792                                  ;-190 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   793                                  
   794 000003B0 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   795                                  
   796                                  ;-191 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   797                                  
   798 000003B8 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   799                                  
   800                                  ;-192 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   801                                  
   802 000003C0 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   803                                  
   804                                  ;-193 //  15: xchg
   805                                  
   806                                  
   807                                  ;-194 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   808                                  
   809 000003C8 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   810                                  
   811                                  ;-195 //  16: loop, jcxz
   812                                  
   813                                  
   814                                  ;-196 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   815                                  
   816 000003D1 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   817 000003DA F1                 
   818                                  
   819                                  ;-197 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   820                                  
   821 000003DB 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   822 000003E4 F1                 
   823                                  
   824                                  ;-198 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   825                                  
   826 000003E5 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   827                                  
   828                                  ;-199 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   829                                  
   830 000003EE 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   831                                  
   832                                  ;-200 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   833                                  
   834 000003F7 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   835                                  
   836                                  ;-201 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   837                                  
   838 000003FF 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   839                                  
   840                                  ;-202 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   841                                  
   842 00000407 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   843                                  
   844                                  ;-203 //  30: enter
   845                                  
   846                                  
   847                                  ;-204 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
   848                                  
   849 00000410 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   850                                  
   851                                  ;-205 // 100: directives
   852                                  
   853                                  
   854                                  ;-206 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   855                                  
   856 00000418 4F52470065F1            I_ORG db 79,82,71,0,101,241
   857                                  
   858                                  ;-207 // section, segment .TEXT .DATA .BSS
   859                                  
   860                                  
   861                                  ;-208 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   862                                  
   863 0000041E 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
   864 00000427 F1                 
   865                                  
   866                                  ;-209 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   867                                  
   868 00000428 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
   869 00000431 F1                 
   870                                  
   871                                  ;-210 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   872                                  
   873 00000432 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
   874 0000043B 6EF1               
   875                                  
   876                                  ;-211 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
   877                                  
   878 0000043D 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
   879                                  
   880                                  ;-212 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
   881                                  
   882 00000444 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
   883                                  
   884                                  ;-213 char I_DB[]=   {'D','B',0,            200,        0xF1};
   885                                  
   886 0000044B 444200C8F1              I_DB db 68,66,0,200,241
   887                                  
   888                                  ;-214 char I_DW[]=   {'D','W',0,            201,        0xF1};
   889                                  
   890 00000450 445700C9F1              I_DW db 68,87,0,201,241
   891                                  
   892                                  ;-215 char I_DD[]=   {'D','D',0,            202,        0xF1};
   893                                  
   894 00000455 444400CAF1              I_DD db 68,68,0,202,241
   895                                  
   896                                  ;-216 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   897                                  
   898 0000045A 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   899                                  
   900                                  ;-217 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   901                                  
   902 00000461 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   903                                  
   904                                  ;-218 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   905                                  
   906 00000468 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   907                                  
   908                                  ;-219 char I_END=0;// end of table char
   909                                  
   910 0000046F 00                      I_END db 0
   911                                  
   912                                  ;-220 
   913                                  
   914                                  
   915                                  ;-221 int lookCode() {//ret: CodeType, *OpCodePtr
   916                                  
   917                                  
   918                                  lookCode: PROC
   919                                  
   920                                  ;-222     CodeType=0;
   921                                  
   922 00000470 B80000                   mov ax, 0
   923 00000473 A2[2F00]                 mov byte [CodeType], al
   924                                  
   925                                  ;-223     OpCodePtr= &I_START;
   926                                  
   927 00000476 B8[5E00]                 mov ax, I_START
   928 00000479 A3[4300]                 mov word [OpCodePtr], ax
   929                                  
   930                                  ;-224     OpCodePtr++;
   931                                  
   932 0000047C FF06[4300]               inc  word[OpCodePtr]
   933                                  
   934                                  ;-225     do  {
   935                                  
   936                                  .lookCode1:
   937                                  
   938                                  ;-226         if (eqstr(SymbolUpper, OpCodePtr))  {
   939                                  
   940 00000480 FF36[4300]               push word [OpCodePtr]
   941 00000484 8D064F75                 lea  ax, [SymbolUpper]
   942 00000488 50                       push ax
   943 00000489 E8400E                   call eqstr
   944 0000048C 83C404                   add  sp, 4
   945 0000048F 08C0                     or  al, al
   946 00000491 0F842700                 je .lookCode2
   947                                  
   948                                  ;-227             while(*OpCodePtr!=0) OpCodePtr++;
   949                                  
   950                                  .lookCode3:
   951 00000495 8B1E[4300]               mov bx, [OpCodePtr]
   952 00000499 8A07                     mov al, [bx]
   953 0000049B B400                     mov ah, 0
   954 0000049D 83F800                   cmp ax, 0
   955 000004A0 0F840600                 je  .lookCode4
   956 000004A4 FF06[4300]               inc  word[OpCodePtr]
   957                                  
   958                                  ;-228             OpCodePtr++;
   959                                  
   960 000004A8 EBEB                     jmp .lookCode3
   961                                  .lookCode4:
   962 000004AA FF06[4300]               inc  word[OpCodePtr]
   963                                  
   964                                  ;-229             CodeType =*OpCodePtr;
   965                                  
   966 000004AE 8B1E[4300]               mov bx, [OpCodePtr]
   967 000004B2 8A07                     mov al, [bx]
   968 000004B4 B400                     mov ah, 0
   969 000004B6 A2[2F00]                 mov byte [CodeType], al
   970                                  
   971                                  ;-230             return;
   972                                  
   973 000004B9 E92A00                   jmp .retnlookCode
   974                                  
   975                                  ;-231         }
   976                                  
   977                                  
   978                                  ;-232     while(*OpCodePtr!=0xF1) OpCodePtr++;
   979                                  
   980                                  .lookCode2:
   981                                  .lookCode5:
   982 000004BC 8B1E[4300]               mov bx, [OpCodePtr]
   983 000004C0 8A07                     mov al, [bx]
   984 000004C2 B400                     mov ah, 0
   985 000004C4 3DF100                   cmp ax, 241
   986 000004C7 0F840600                 je  .lookCode6
   987 000004CB FF06[4300]               inc  word[OpCodePtr]
   988                                  
   989                                  ;-233     OpCodePtr++;
   990                                  
   991 000004CF EBEB                     jmp .lookCode5
   992                                  .lookCode6:
   993 000004D1 FF06[4300]               inc  word[OpCodePtr]
   994                                  
   995                                  ;-234     } while(*OpCodePtr!=0);
   996                                  
   997 000004D5 8B1E[4300]               mov bx, [OpCodePtr]
   998 000004D9 8A07                     mov al, [bx]
   999 000004DB B400                     mov ah, 0
  1000 000004DD 83F800                   cmp ax, 0
  1001 000004E0 0F840200                 je  .lookCode7
  1002 000004E4 EB9A                     jmp .lookCode1
  1003                                  .lookCode7:
  1004                                  
  1005                                  ;-235 }
  1006                                  
  1007                                  
  1008                                  ;-236 
  1009                                  
  1010                                  
  1011                                  ;-237 //#include "OPS.C"
  1012                                  
  1013                                  
  1014                                  ;-238 int ChangeDirection() {
  1015                                  
  1016                                   .retnlookCode:
  1017 000004E6 C3                       ret
  1018                                  ENDP
  1019                                  
  1020                                  ChangeDirection: PROC
  1021                                  
  1022                                  ;-239     char c;
  1023                                  
  1024                                  
  1025                                  ;-240     c=Op;     Op    =Op2;    Op2   =c;
  1026                                  
  1027                                  ;Function : ChangeDirection, Number of local variables: 1
  1028                                  ;   # type sign width addr used name   list of local variables
  1029                                  ;  200 var sign byte   239 NULL c = bp-2;
  1030 000004E7 C8020000                 ENTER  2,0
  1031 000004EB A0[2D00]                 mov al, [Op]
  1032 000004EE 8846FE                   mov [bp-2], al
  1033 000004F1 A0[2E00]                 mov al, [Op2]
  1034 000004F4 A2[2D00]                 mov byte [Op], al
  1035 000004F7 8A46FE                   mov al, [bp-2]
  1036 000004FA A2[2E00]                 mov byte [Op2], al
  1037                                  
  1038                                  ;-241     c=R1Type; R1Type=R2Type; R2Type=c;
  1039                                  
  1040 000004FD A0[3600]                 mov al, [R1Type]
  1041 00000500 8846FE                   mov [bp-2], al
  1042 00000503 A0[3500]                 mov al, [R2Type]
  1043 00000506 A2[3600]                 mov byte [R1Type], al
  1044 00000509 8A46FE                   mov al, [bp-2]
  1045 0000050C A2[3500]                 mov byte [R2Type], al
  1046                                  
  1047                                  ;-242     c=R1No;   R1No  =R2No;   R2No  =c;
  1048                                  
  1049 0000050F A0[3400]                 mov al, [R1No]
  1050 00000512 8846FE                   mov [bp-2], al
  1051 00000515 A0[3300]                 mov al, [R2No]
  1052 00000518 A2[3400]                 mov byte [R1No], al
  1053 0000051B 8A46FE                   mov al, [bp-2]
  1054 0000051E A2[3300]                 mov byte [R2No], al
  1055                                  
  1056                                  ;-243     dflag=2;
  1057                                  
  1058 00000521 B80200                   mov ax, 2
  1059 00000524 A2[3900]                 mov byte [dflag], al
  1060                                  
  1061                                  ;-244 }
  1062                                  
  1063                                  
  1064                                  ;-245 
  1065                                  
  1066                                  
  1067                                  ;-246 int checkOpL() {
  1068 00000527 C9                       LEAVE
  1069 00000528 C3                       ret
  1070                                  ENDP
  1071                                  
  1072                                  checkOpL: PROC
  1073                                  
  1074                                  ;-247     if (Op == ADR) implerror();
  1075                                  
  1076 00000529 A0[2D00]                 mov al, [Op]
  1077 0000052C 3C03                     cmp al, 3
  1078 0000052E 0F850300                 jne .checkOpL8
  1079 00000532 E84816                   call implerror
  1080                                  
  1081                                  ;-248     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  1082                                  
  1083                                  .checkOpL8:
  1084 00000535 A0[3600]                 mov al, [R1Type]
  1085 00000538 3C04                     cmp al, 4
  1086 0000053A 0F850600                 jne .checkOpL9
  1087 0000053E E80417                   call segregerror
  1088 00000541 E93E00                   jmp .retncheckOpL
  1089                                  
  1090                                  ;-249     setwflag();
  1091                                  
  1092                                  .checkOpL9:
  1093 00000544 E88603                   call setwflag
  1094                                  
  1095                                  ;-250     if (OpSize == 0) error1("no op size declared");
  1096                                  
  1097 00000547 A0[3700]                 mov al, [OpSize]
  1098 0000054A 3C00                     cmp al, 0
  1099 0000054C 0F850900                 jne .checkOpL10
  1100 00000550 68[8305]                 push checkOpL_0
  1101 00000553 E84315                   call error1
  1102 00000556 83C402                   add  sp, 2
  1103                                  
  1104                                  ;-251     if (OpSize == R1Type) return;
  1105                                  
  1106                                  .checkOpL10:
  1107 00000559 A0[3700]                 mov al, [OpSize]
  1108 0000055C 3A06[3600]               cmp al, [R1Type]
  1109 00000560 0F850300                 jne .checkOpL11
  1110 00000564 E91B00                   jmp .retncheckOpL
  1111                                  
  1112                                  ;-252     if (Op == REG) if (R1Type==0) error1("no register defined");
  1113                                  
  1114                                  .checkOpL11:
  1115 00000567 A0[2D00]                 mov al, [Op]
  1116 0000056A 3C02                     cmp al, 2
  1117 0000056C 0F851200                 jne .checkOpL12
  1118 00000570 A0[3600]                 mov al, [R1Type]
  1119 00000573 3C00                     cmp al, 0
  1120 00000575 0F850900                 jne .checkOpL13
  1121 00000579 68[9705]                 push checkOpL_1
  1122 0000057C E81A15                   call error1
  1123 0000057F 83C402                   add  sp, 2
  1124                                  
  1125                                  ;-253 }
  1126                                  
  1127                                  .checkOpL13:
  1128                                  .checkOpL12:
  1129                                  
  1130                                  ;-254 
  1131                                  
  1132                                  
  1133                                  ;-255 int check2Ops() {
  1134                                  
  1135                                   .retncheckOpL:
  1136 00000582 C3                       ret
  1137 00000583 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1138 0000058C 65206465636C617265-
  1139 00000595 6400               
  1140 00000597 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1141 000005A0 657220646566696E65-
  1142 000005A9 6400               
  1143                                  ENDP
  1144                                  
  1145                                  check2Ops: PROC
  1146                                  
  1147                                  ;-256     get2Ops();
  1148                                  
  1149 000005AB E84900                   call get2Ops
  1150                                  
  1151                                  ;-257     if (Op ==   0) addrerror();
  1152                                  
  1153 000005AE A0[2D00]                 mov al, [Op]
  1154 000005B1 3C00                     cmp al, 0
  1155 000005B3 0F850300                 jne .check2Ops14
  1156 000005B7 E88415                   call addrerror
  1157                                  
  1158                                  ;-258     if (Op == ADR) invaloperror();
  1159                                  
  1160                                  .check2Ops14:
  1161 000005BA A0[2D00]                 mov al, [Op]
  1162 000005BD 3C03                     cmp al, 3
  1163 000005BF 0F850300                 jne .check2Ops15
  1164 000005C3 E8F215                   call invaloperror
  1165                                  
  1166                                  ;-259     if (Op == IMM) immeerror();
  1167                                  
  1168                                  .check2Ops15:
  1169 000005C6 A0[2D00]                 mov al, [Op]
  1170 000005C9 3C01                     cmp al, 1
  1171 000005CB 0F850300                 jne .check2Ops16
  1172 000005CF E88615                   call immeerror
  1173                                  
  1174                                  ;-260     if (Op2==   0) addrerror();
  1175                                  
  1176                                  .check2Ops16:
  1177 000005D2 A0[2E00]                 mov al, [Op2]
  1178 000005D5 3C00                     cmp al, 0
  1179 000005D7 0F850300                 jne .check2Ops17
  1180 000005DB E86015                   call addrerror
  1181                                  
  1182                                  ;-261     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov
  1183                                  
  1184                                  .check2Ops17:
  1185 000005DE A0[2F00]                 mov al, [CodeType]
  1186 000005E1 3C05                     cmp al, 5
  1187 000005E3 0F840C00                 je  .check2Ops18
  1188 000005E7 A0[2E00]                 mov al, [Op2]
  1189 000005EA 3C03                     cmp al, 3
  1190 000005EC 0F850300                 jne .check2Ops19
  1191 000005F0 E8C515                   call invaloperror
  1192                                  
  1193                                  ;-262     setwflag();
  1194                                  
  1195                                  .check2Ops19:
  1196                                  .check2Ops18:
  1197 000005F3 E8D702                   call setwflag
  1198                                  
  1199                                  ;-263 }
  1200                                  
  1201                                  
  1202                                  ;-264 int get2Ops() {
  1203                                  
  1204 000005F6 C3                       ret
  1205                                  ENDP
  1206                                  
  1207                                  get2Ops: PROC
  1208                                  
  1209                                  ;-265     getOpL();
  1210                                  
  1211 000005F7 E80C00                   call getOpL
  1212                                  
  1213                                  ;-266     need(',');
  1214                                  
  1215 000005FA 6A2C                     push 44
  1216 000005FC E81709                   call need
  1217 000005FF 83C402                   add  sp, 2
  1218                                  
  1219                                  ;-267     getOpR();
  1220                                  
  1221 00000602 E82900                   call getOpR
  1222                                  
  1223                                  ;-268 }
  1224                                  
  1225                                  
  1226                                  ;-269 
  1227                                  
  1228                                  
  1229                                  ;-270 int getOpL() {
  1230                                  
  1231 00000605 C3                       ret
  1232                                  ENDP
  1233                                  
  1234                                  getOpL: PROC
  1235                                  
  1236                                  ;-271 //set: op=0,IMM,REG,ADR,MEM
  1237                                  
  1238                                  
  1239                                  ;-272     getOpR();
  1240                                  
  1241 00000606 E82500                   call getOpR
  1242                                  
  1243                                  ;-273     Op=Op2;         Op2=0;
  1244                                  
  1245 00000609 A0[2E00]                 mov al, [Op2]
  1246 0000060C A2[2D00]                 mov byte [Op], al
  1247 0000060F B80000                   mov ax, 0
  1248 00000612 A2[2E00]                 mov byte [Op2], al
  1249                                  
  1250                                  ;-274     R1No=R2No;      R2No=0;
  1251                                  
  1252 00000615 A0[3300]                 mov al, [R2No]
  1253 00000618 A2[3400]                 mov byte [R1No], al
  1254 0000061B B80000                   mov ax, 0
  1255 0000061E A2[3300]                 mov byte [R2No], al
  1256                                  
  1257                                  ;-275     R1Type=R2Type; R2Type=0;
  1258                                  
  1259 00000621 A0[3500]                 mov al, [R2Type]
  1260 00000624 A2[3600]                 mov byte [R1Type], al
  1261 00000627 B80000                   mov ax, 0
  1262 0000062A A2[3500]                 mov byte [R2Type], al
  1263                                  
  1264                                  ;-276 }
  1265                                  
  1266                                  
  1267                                  ;-277 
  1268                                  
  1269                                  
  1270                                  ;-278 int getOpR() {
  1271                                  
  1272 0000062D C3                       ret
  1273                                  ENDP
  1274                                  
  1275                                  getOpR: PROC
  1276                                  
  1277                                  ;-279     Op2=getOp1();
  1278                                  
  1279 0000062E E89900                   call getOp1
  1280 00000631 A2[2E00]                 mov byte [Op2], al
  1281                                  
  1282                                  ;-280     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1283                                  
  1284 00000634 6A5B                     push 91
  1285 00000636 E8B508                   call isToken
  1286 00000639 83C402                   add  sp, 2
  1287 0000063C 08C0                     or  al, al
  1288 0000063E 0F840C00                 je .getOpR20
  1289 00000642 B80400                   mov ax, 4
  1290 00000645 A2[2E00]                 mov byte [Op2], al
  1291 00000648 E8CE00                   call getMEM
  1292 0000064B E96200                   jmp .retngetOpR
  1293                                  
  1294                                  ;-281     if (Op2 == 0)     {invaloperror();         return;}
  1295                                  
  1296                                  .getOpR20:
  1297 0000064E A0[2E00]                 mov al, [Op2]
  1298 00000651 3C00                     cmp al, 0
  1299 00000653 0F850600                 jne .getOpR21
  1300 00000657 E85E15                   call invaloperror
  1301 0000065A E95300                   jmp .retngetOpR
  1302                                  
  1303                                  ;-282     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1304                                  
  1305                                  .getOpR21:
  1306 0000065D A0[2E00]                 mov al, [Op2]
  1307 00000660 3C01                     cmp al, 1
  1308 00000662 0F850900                 jne .getOpR22
  1309 00000666 A1[0E00]                 mov ax, [SymbolInt]
  1310 00000669 A3[3F00]                 mov word [imme], ax
  1311 0000066C E94100                   jmp .retngetOpR
  1312                                  
  1313                                  ;-283     if (Op2 == REG)                            return;
  1314                                  
  1315                                  .getOpR22:
  1316 0000066F A0[2E00]                 mov al, [Op2]
  1317 00000672 3C02                     cmp al, 2
  1318 00000674 0F850300                 jne .getOpR23
  1319 00000678 E93500                   jmp .retngetOpR
  1320                                  
  1321                                  ;-284     if (Op2 == ADR)   {
  1322                                  
  1323                                  .getOpR23:
  1324 0000067B A0[2E00]                 mov al, [Op2]
  1325 0000067E 3C03                     cmp al, 3
  1326 00000680 0F852300                 jne .getOpR24
  1327                                  
  1328                                  ;-285         if (LabelIx == 0) disp=0;
  1329                                  
  1330 00000684 A1[4E00]                 mov ax, [LabelIx]
  1331 00000687 83F800                   cmp ax, 0
  1332 0000068A 0F850900                 jne .getOpR25
  1333 0000068E B80000                   mov ax, 0
  1334 00000691 A3[3D00]                 mov word [disp], ax
  1335                                  
  1336                                  ;-286         else disp=LabelAddr[LabelIx];
  1337                                  
  1338 00000694 E90D00                   jmp .getOpR26
  1339                                  .getOpR25:
  1340 00000697 8B1E[4E00]               mov bx, [LabelIx]
  1341 0000069B D1E3                     shl bx, 1
  1342 0000069D 8B87CA8E                 mov ax, [LabelAddr + bx]
  1343 000006A1 A3[3D00]                 mov word [disp], ax
  1344                                  
  1345                                  ;-287         return;}
  1346                                  
  1347                                  .getOpR26:
  1348 000006A4 E90900                   jmp .retngetOpR
  1349                                  
  1350                                  ;-288     error1("Name of operand expected");
  1351                                  
  1352                                  .getOpR24:
  1353 000006A7 68[B106]                 push getOpR_0
  1354 000006AA E8EC13                   call error1
  1355 000006AD 83C402                   add  sp, 2
  1356                                  
  1357                                  ;-289 }
  1358                                  
  1359                                  
  1360                                  ;-290 
  1361                                  
  1362                                  
  1363                                  ;-291 int getOp1() {//scan for a single operand
  1364                                  
  1365                                   .retngetOpR:
  1366 000006B0 C3                       ret
  1367 000006B1 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1368 000006BA 706572616E64206578-
  1369 000006C3 70656374656400     
  1370                                  ENDP
  1371                                  
  1372                                  getOp1: PROC
  1373                                  
  1374                                  ;-292 //return:0, IMM, REG, ADR (not MEM)
  1375                                  
  1376                                  
  1377                                  ;-293 //set   :R2Type, R2No by testReg
  1378                                  
  1379                                  
  1380                                  ;-294 //set   :LabelIx by searchLabel
  1381                                  
  1382                                  
  1383                                  ;-295     if (TokeType == 0)      return 0;
  1384                                  
  1385 000006CA A0[2C00]                 mov al, [TokeType]
  1386 000006CD 3C00                     cmp al, 0
  1387 000006CF 0F850600                 jne .getOp127
  1388 000006D3 B80000                   mov ax, 0
  1389 000006D6 E93F00                   jmp .retngetOp1
  1390                                  
  1391                                  ;-296     if (TokeType == DIGIT)  return IMM;
  1392                                  
  1393                                  .getOp127:
  1394 000006D9 A0[2C00]                 mov al, [TokeType]
  1395 000006DC 3C01                     cmp al, 1
  1396 000006DE 0F850600                 jne .getOp128
  1397 000006E2 B80100                   mov ax, 1
  1398 000006E5 E93000                   jmp .retngetOp1
  1399                                  
  1400                                  ;-297     if (TokeType == ALNUME) {
  1401                                  
  1402                                  .getOp128:
  1403 000006E8 A0[2C00]                 mov al, [TokeType]
  1404 000006EB 3C03                     cmp al, 3
  1405 000006ED 0F852100                 jne .getOp129
  1406                                  
  1407                                  ;-298         R2No=testReg();
  1408                                  
  1409 000006F1 E88B0D                   call testReg
  1410 000006F4 A2[3300]                 mov byte [R2No], al
  1411                                  
  1412                                  ;-299         if (R2Type)        return REG;
  1413                                  
  1414 000006F7 A0[3500]                 mov al, [R2Type]
  1415 000006FA 08C0                     or  al, al
  1416 000006FC 0F840600                 je .getOp130
  1417 00000700 B80200                   mov ax, 2
  1418 00000703 E91200                   jmp .retngetOp1
  1419                                  
  1420                                  ;-300         LabelIx=searchLabel();
  1421                                  
  1422                                  .getOp130:
  1423 00000706 E88105                   call searchLabel
  1424 00000709 A3[4E00]                 mov word [LabelIx], ax
  1425                                  
  1426                                  ;-301         return ADR;
  1427                                  
  1428 0000070C B80300                   mov ax, 3
  1429 0000070F E90600                   jmp .retngetOp1
  1430                                  
  1431                                  ;-302 //        if (LabelIx)        return ADR;
  1432                                  
  1433                                  
  1434                                  ;-303 //        else error1("variable not found");
  1435                                  
  1436                                  
  1437                                  ;-304     }
  1438                                  
  1439                                  
  1440                                  ;-305     return 0;
  1441                                  
  1442                                  .getOp129:
  1443 00000712 B80000                   mov ax, 0
  1444 00000715 E90000                   jmp .retngetOp1
  1445                                  
  1446                                  ;-306 }
  1447                                  
  1448                                  
  1449                                  ;-307 
  1450                                  
  1451                                  
  1452                                  ;-308 int getMEM() {// e.g. [array+bp+si-4]
  1453                                  
  1454                                   .retngetOp1:
  1455 00000718 C3                       ret
  1456                                  ENDP
  1457                                  
  1458                                  getMEM: PROC
  1459                                  
  1460                                  ;-309 //set: disp, rm, R2Type
  1461                                  
  1462                                  
  1463                                  ;-310     char c;
  1464                                  
  1465                                  
  1466                                  ;-311     disp=0; rm=0;
  1467                                  
  1468                                  ;Function : getMEM, Number of local variables: 1
  1469                                  ;   # type sign width addr used name   list of local variables
  1470                                  ;  200 var sign byte   310 NULL c = bp-2;
  1471 00000719 C8020000                 ENTER  2,0
  1472 0000071D B80000                   mov ax, 0
  1473 00000720 A3[3D00]                 mov word [disp], ax
  1474 00000723 B80000                   mov ax, 0
  1475 00000726 A2[3B00]                 mov byte [rm], al
  1476                                  
  1477                                  ;-312     do {
  1478                                  
  1479                                  .getMEM31:
  1480                                  
  1481                                  ;-313         getTokeType();
  1482                                  
  1483 00000729 E8AF03                   call getTokeType
  1484                                  
  1485                                  ;-314         c=getOp1();
  1486                                  
  1487 0000072C E89BFF                   call getOp1
  1488 0000072F 8846FE                   mov [bp-2], al
  1489                                  
  1490                                  ;-315         if (c ==   0) syntaxerror();
  1491                                  
  1492 00000732 8A46FE                   mov al, [bp-2]
  1493 00000735 3C00                     cmp al, 0
  1494 00000737 0F850300                 jne .getMEM32
  1495 0000073B E82E15                   call syntaxerror
  1496                                  
  1497                                  ;-316         if (c == REG) {
  1498                                  
  1499                                  .getMEM32:
  1500 0000073E 8A46FE                   mov al, [bp-2]
  1501 00000741 3C02                     cmp al, 2
  1502 00000743 0F851B00                 jne .getMEM33
  1503                                  
  1504                                  ;-317             isDirect=0;
  1505                                  
  1506 00000747 B80000                   mov ax, 0
  1507 0000074A A2[3C00]                 mov byte [isDirect], al
  1508                                  
  1509                                  ;-318             if (rm) rm=getIndReg2();
  1510                                  
  1511 0000074D A0[3B00]                 mov al, [rm]
  1512 00000750 08C0                     or  al, al
  1513 00000752 0F840900                 je .getMEM34
  1514 00000756 E8F600                   call getIndReg2
  1515 00000759 A2[3B00]                 mov byte [rm], al
  1516                                  
  1517                                  ;-319             else getIndReg1();
  1518                                  
  1519 0000075C E90300                   jmp .getMEM35
  1520                                  .getMEM34:
  1521 0000075F E89800                   call getIndReg1
  1522                                  
  1523                                  ;-320         }
  1524                                  
  1525                                  .getMEM35:
  1526                                  
  1527                                  ;-321         if (c == ADR) {
  1528                                  
  1529                                  .getMEM33:
  1530 00000762 8A46FE                   mov al, [bp-2]
  1531 00000765 3C03                     cmp al, 3
  1532 00000767 0F851F00                 jne .getMEM36
  1533                                  
  1534                                  ;-322             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  1535                                  
  1536 0000076B A1[4E00]                 mov ax, [LabelIx]
  1537 0000076E 08C0                     or  al, al
  1538 00000770 0F841300                 je .getMEM37
  1539 00000774 A1[3D00]                 mov ax, [disp]
  1540 00000777 8B1E[4E00]               mov bx, [LabelIx]
  1541 0000077B D1E3                     shl bx, 1
  1542 0000077D 0387CA8E                 add ax, [LabelAddr + bx]
  1543 00000781 A3[3D00]                 mov word [disp], ax
  1544                                  
  1545                                  ;-323             else notfounderror();
  1546                                  
  1547 00000784 E90300                   jmp .getMEM38
  1548                                  .getMEM37:
  1549 00000787 E87F13                   call notfounderror
  1550                                  
  1551                                  ;-324         }
  1552                                  
  1553                                  .getMEM38:
  1554                                  
  1555                                  ;-325         if (c == IMM) disp=disp+SymbolInt;
  1556                                  
  1557                                  .getMEM36:
  1558 0000078A 8A46FE                   mov al, [bp-2]
  1559 0000078D 3C01                     cmp al, 1
  1560 0000078F 0F850A00                 jne .getMEM39
  1561 00000793 A1[3D00]                 mov ax, [disp]
  1562 00000796 0306[0E00]               add ax, [SymbolInt]
  1563 0000079A A3[3D00]                 mov word [disp], ax
  1564                                  
  1565                                  ;-326         if (isToken('-')) {
  1566                                  
  1567                                  .getMEM39:
  1568 0000079D 6A2D                     push 45
  1569 0000079F E84C07                   call isToken
  1570 000007A2 83C402                   add  sp, 2
  1571 000007A5 08C0                     or  al, al
  1572 000007A7 0F841900                 je .getMEM40
  1573                                  
  1574                                  ;-327             getTokeType();
  1575                                  
  1576 000007AB E82D03                   call getTokeType
  1577                                  
  1578                                  ;-328             if (TokeType != DIGIT) numbererror();
  1579                                  
  1580 000007AE A0[2C00]                 mov al, [TokeType]
  1581 000007B1 3C01                     cmp al, 1
  1582 000007B3 0F840300                 je  .getMEM41
  1583 000007B7 E81F14                   call numbererror
  1584                                  
  1585                                  ;-329             disp = disp - SymbolInt;
  1586                                  
  1587                                  .getMEM41:
  1588 000007BA A1[3D00]                 mov ax, [disp]
  1589 000007BD 2B06[0E00]               sub ax, [SymbolInt]
  1590 000007C1 A3[3D00]                 mov word [disp], ax
  1591                                  
  1592                                  ;-330         }
  1593                                  
  1594                                  
  1595                                  ;-331     } while (isToken('+'));
  1596                                  
  1597                                  .getMEM40:
  1598 000007C4 6A2B                     push 43
  1599 000007C6 E82507                   call isToken
  1600 000007C9 83C402                   add  sp, 2
  1601 000007CC 08C0                     or  al, al
  1602 000007CE 0F840300                 je .getMEM42
  1603 000007D2 E954FF                   jmp .getMEM31
  1604                                  .getMEM42:
  1605                                  
  1606                                  ;-332     if (isToken(']') == 0) errorexit("] expected");
  1607                                  
  1608 000007D5 6A5D                     push 93
  1609 000007D7 E81407                   call isToken
  1610 000007DA 83C402                   add  sp, 2
  1611 000007DD 83F800                   cmp ax, 0
  1612 000007E0 0F850900                 jne .getMEM43
  1613 000007E4 68[EF07]                 push getMEM_0
  1614 000007E7 E80513                   call errorexit
  1615 000007EA 83C402                   add  sp, 2
  1616                                  
  1617                                  ;-333 }
  1618                                  
  1619                                  .getMEM43:
  1620                                  
  1621                                  ;-334 int getIndReg1() {
  1622 000007ED C9                       LEAVE
  1623 000007EE C3                       ret
  1624 000007EF 5D2065787065637465-     getMEM_0 db "] expected",0
  1625 000007F8 6400               
  1626                                  ENDP
  1627                                  
  1628                                  getIndReg1: PROC
  1629                                  
  1630                                  ;-335     if (R2Type !=WORD) indexerror();
  1631                                  
  1632 000007FA A0[3500]                 mov al, [R2Type]
  1633 000007FD 3C02                     cmp al, 2
  1634 000007FF 0F840300                 je  .getIndReg144
  1635 00000803 E89113                   call indexerror
  1636                                  
  1637                                  ;-336     if (R2No==3) rm=7;//BX
  1638                                  
  1639                                  .getIndReg144:
  1640 00000806 A0[3300]                 mov al, [R2No]
  1641 00000809 3C03                     cmp al, 3
  1642 0000080B 0F850600                 jne .getIndReg145
  1643 0000080F B80700                   mov ax, 7
  1644 00000812 A2[3B00]                 mov byte [rm], al
  1645                                  
  1646                                  ;-337     if (R2No==5) rm=6;//BP, change to BP+0
  1647                                  
  1648                                  .getIndReg145:
  1649 00000815 A0[3300]                 mov al, [R2No]
  1650 00000818 3C05                     cmp al, 5
  1651 0000081A 0F850600                 jne .getIndReg146
  1652 0000081E B80600                   mov ax, 6
  1653 00000821 A2[3B00]                 mov byte [rm], al
  1654                                  
  1655                                  ;-338     if (R2No==7) rm=5;//DI
  1656                                  
  1657                                  .getIndReg146:
  1658 00000824 A0[3300]                 mov al, [R2No]
  1659 00000827 3C07                     cmp al, 7
  1660 00000829 0F850600                 jne .getIndReg147
  1661 0000082D B80500                   mov ax, 5
  1662 00000830 A2[3B00]                 mov byte [rm], al
  1663                                  
  1664                                  ;-339     if (R2No==6) rm=4;//SI
  1665                                  
  1666                                  .getIndReg147:
  1667 00000833 A0[3300]                 mov al, [R2No]
  1668 00000836 3C06                     cmp al, 6
  1669 00000838 0F850600                 jne .getIndReg148
  1670 0000083C B80400                   mov ax, 4
  1671 0000083F A2[3B00]                 mov byte [rm], al
  1672                                  
  1673                                  ;-340     if (rm==0) indexerror();
  1674                                  
  1675                                  .getIndReg148:
  1676 00000842 A0[3B00]                 mov al, [rm]
  1677 00000845 3C00                     cmp al, 0
  1678 00000847 0F850300                 jne .getIndReg149
  1679 0000084B E84913                   call indexerror
  1680                                  
  1681                                  ;-341 }
  1682                                  
  1683                                  .getIndReg149:
  1684                                  
  1685                                  ;-342 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1686                                  
  1687 0000084E C3                       ret
  1688                                  ENDP
  1689                                  
  1690                                  getIndReg2: PROC
  1691                                  ;Function : getIndReg2, Number of local variables: 1
  1692                                  ;   # type sign width addr used name   list of local variables
  1693                                  ;  200 var sign byte   342 NULL m = bp-2;
  1694 0000084F C8020000                 ENTER  2,0
  1695 00000853 B80400                   mov ax, 4
  1696 00000856 8846FE                   mov [bp-2], al
  1697                                  
  1698                                  ;-343     if (R2Type !=WORD) indexerror();
  1699                                  
  1700 00000859 A0[3500]                 mov al, [R2Type]
  1701 0000085C 3C02                     cmp al, 2
  1702 0000085E 0F840300                 je  .getIndReg250
  1703 00000862 E83213                   call indexerror
  1704                                  
  1705                                  ;-344     if (R2No==7) if (rm==6) m=3;//BP+DI
  1706                                  
  1707                                  .getIndReg250:
  1708 00000865 A0[3300]                 mov al, [R2No]
  1709 00000868 3C07                     cmp al, 7
  1710 0000086A 0F852100                 jne .getIndReg251
  1711 0000086E A0[3B00]                 mov al, [rm]
  1712 00000871 3C06                     cmp al, 6
  1713 00000873 0F850900                 jne .getIndReg252
  1714 00000877 B80300                   mov ax, 3
  1715 0000087A 8846FE                   mov [bp-2], al
  1716                                  
  1717                                  ;-345              else if (rm==7) m=1;//BX+DI
  1718                                  
  1719 0000087D E90F00                   jmp .getIndReg253
  1720                                  .getIndReg252:
  1721 00000880 A0[3B00]                 mov al, [rm]
  1722 00000883 3C07                     cmp al, 7
  1723 00000885 0F850600                 jne .getIndReg254
  1724 00000889 B80100                   mov ax, 1
  1725 0000088C 8846FE                   mov [bp-2], al
  1726                                  
  1727                                  ;-346     if (R2No==6) if (rm==6) m=2;//BP+SI
  1728                                  
  1729                                  .getIndReg254:
  1730                                  .getIndReg253:
  1731                                  .getIndReg251:
  1732 0000088F A0[3300]                 mov al, [R2No]
  1733 00000892 3C06                     cmp al, 6
  1734 00000894 0F852100                 jne .getIndReg255
  1735 00000898 A0[3B00]                 mov al, [rm]
  1736 0000089B 3C06                     cmp al, 6
  1737 0000089D 0F850900                 jne .getIndReg256
  1738 000008A1 B80200                   mov ax, 2
  1739 000008A4 8846FE                   mov [bp-2], al
  1740                                  
  1741                                  ;-347              else if (rm==7) m=0;//BX+SI
  1742                                  
  1743 000008A7 E90F00                   jmp .getIndReg257
  1744                                  .getIndReg256:
  1745 000008AA A0[3B00]                 mov al, [rm]
  1746 000008AD 3C07                     cmp al, 7
  1747 000008AF 0F850600                 jne .getIndReg258
  1748 000008B3 B80000                   mov ax, 0
  1749 000008B6 8846FE                   mov [bp-2], al
  1750                                  
  1751                                  ;-348     if (m > 3) indexerror();
  1752                                  
  1753                                  .getIndReg258:
  1754                                  .getIndReg257:
  1755                                  .getIndReg255:
  1756 000008B9 8A46FE                   mov al, [bp-2]
  1757 000008BC 3C03                     cmp al, 3
  1758 000008BE 0F8E0300                 jle .getIndReg259
  1759 000008C2 E8D212                   call indexerror
  1760                                  
  1761                                  ;-349     return m;
  1762                                  
  1763                                  .getIndReg259:
  1764 000008C5 8A46FE                   mov al, [bp-2]
  1765 000008C8 E90000                   jmp .retngetIndReg2
  1766                                  
  1767                                  ;-350 }
  1768                                  
  1769                                  
  1770                                  ;-351 
  1771                                  
  1772                                  
  1773                                  ;-352 int setwflag() {//word size, bit 0
  1774                                  
  1775 000008CB C9                       .retngetIndReg2: LEAVE
  1776 000008CC C3                       ret
  1777                                  ENDP
  1778                                  
  1779                                  setwflag: PROC
  1780                                  
  1781                                  ;-353     wflag=0;
  1782                                  
  1783 000008CD B80000                   mov ax, 0
  1784 000008D0 A2[3800]                 mov byte [wflag], al
  1785                                  
  1786                                  ;-354     if (OpSize == 0) {//do not override OpSize
  1787                                  
  1788 000008D3 A0[3700]                 mov al, [OpSize]
  1789 000008D6 3C00                     cmp al, 0
  1790 000008D8 0F853C00                 jne .setwflag60
  1791                                  
  1792                                  ;-355         if (Op == REG) OpSize=R1Type;
  1793                                  
  1794 000008DC A0[2D00]                 mov al, [Op]
  1795 000008DF 3C02                     cmp al, 2
  1796 000008E1 0F850600                 jne .setwflag61
  1797 000008E5 A0[3600]                 mov al, [R1Type]
  1798 000008E8 A2[3700]                 mov byte [OpSize], al
  1799                                  
  1800                                  ;-356         if (Op2== REG) OpSize=R2Type;
  1801                                  
  1802                                  .setwflag61:
  1803 000008EB A0[2E00]                 mov al, [Op2]
  1804 000008EE 3C02                     cmp al, 2
  1805 000008F0 0F850600                 jne .setwflag62
  1806 000008F4 A0[3500]                 mov al, [R2Type]
  1807 000008F7 A2[3700]                 mov byte [OpSize], al
  1808                                  
  1809                                  ;-357         if (R2Type== SEGREG) OpSize=WORD;
  1810                                  
  1811                                  .setwflag62:
  1812 000008FA A0[3500]                 mov al, [R2Type]
  1813 000008FD 3C04                     cmp al, 4
  1814 000008FF 0F850600                 jne .setwflag63
  1815 00000903 B80200                   mov ax, 2
  1816 00000906 A2[3700]                 mov byte [OpSize], al
  1817                                  
  1818                                  ;-358         if (R1Type == SEGREG) OpSize=WORD;
  1819                                  
  1820                                  .setwflag63:
  1821 00000909 A0[3600]                 mov al, [R1Type]
  1822 0000090C 3C04                     cmp al, 4
  1823 0000090E 0F850600                 jne .setwflag64
  1824 00000912 B80200                   mov ax, 2
  1825 00000915 A2[3700]                 mov byte [OpSize], al
  1826                                  
  1827                                  ;-359     }
  1828                                  
  1829                                  .setwflag64:
  1830                                  
  1831                                  ;-360     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1832                                  
  1833                                  .setwflag60:
  1834 00000918 A0[3700]                 mov al, [OpSize]
  1835 0000091B 3C03                     cmp al, 3
  1836 0000091D 0F850900                 jne .setwflag65
  1837 00000921 E84C18                   call gen66h
  1838 00000924 B80100                   mov ax, 1
  1839 00000927 A2[3800]                 mov byte [wflag], al
  1840                                  
  1841                                  ;-361     if (OpSize  ==  WORD) wflag=1;
  1842                                  
  1843                                  .setwflag65:
  1844 0000092A A0[3700]                 mov al, [OpSize]
  1845 0000092D 3C02                     cmp al, 2
  1846 0000092F 0F850600                 jne .setwflag66
  1847 00000933 B80100                   mov ax, 1
  1848 00000936 A2[3800]                 mov byte [wflag], al
  1849                                  
  1850                                  ;-362 }
  1851                                  
  1852                                  .setwflag66:
  1853                                  
  1854                                  ;-363 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  1855                                  
  1856 00000939 C3                       ret
  1857                                  ENDP
  1858                                  
  1859                                  setsflag: PROC
  1860                                  
  1861                                  ;-364     unsigned int ui;
  1862                                  
  1863                                  
  1864                                  ;-365     sflag=2;
  1865                                  
  1866                                  ;Function : setsflag, Number of local variables: 1
  1867                                  ;   # type sign width addr used name   list of local variables
  1868                                  ;  200 var unsg word   364 NULL ui = bp-2;
  1869 0000093A C8020000                 ENTER  2,0
  1870 0000093E B80200                   mov ax, 2
  1871 00000941 A2[3A00]                 mov byte [sflag], al
  1872                                  
  1873                                  ;-366     ui = imme & 0xFF80;//is greater than signed 127?
  1874                                  
  1875 00000944 A1[3F00]                 mov ax, [imme]
  1876 00000947 2580FF                   and ax, 65408
  1877 0000094A 8946FE                   mov [bp-2], ax
  1878                                  
  1879                                  ;-367     if(ui != 0) sflag = 0;
  1880                                  
  1881 0000094D 8B46FE                   mov ax, [bp-2]
  1882 00000950 83F800                   cmp ax, 0
  1883 00000953 0F840600                 je  .setsflag67
  1884 00000957 B80000                   mov ax, 0
  1885 0000095A A2[3A00]                 mov byte [sflag], al
  1886                                  
  1887                                  ;-368     if (OpSize == BYTE) {
  1888                                  
  1889                                  .setsflag67:
  1890 0000095D A0[3700]                 mov al, [OpSize]
  1891 00000960 3C01                     cmp al, 1
  1892 00000962 0F851900                 jne .setsflag68
  1893                                  
  1894                                  ;-369         if (imme > 255) error1("too big for byte r/m");
  1895                                  
  1896 00000966 A1[3F00]                 mov ax, [imme]
  1897 00000969 3DFF00                   cmp ax, 255
  1898 0000096C 0F8E0900                 jle .setsflag69
  1899 00000970 68[8109]                 push setsflag_0
  1900 00000973 E82311                   call error1
  1901 00000976 83C402                   add  sp, 2
  1902                                  
  1903                                  ;-370         sflag=0;//byte reg does not need sign extended
  1904                                  
  1905                                  .setsflag69:
  1906 00000979 B80000                   mov ax, 0
  1907 0000097C A2[3A00]                 mov byte [sflag], al
  1908                                  
  1909                                  ;-371     }
  1910                                  
  1911                                  
  1912                                  ;-372 }
  1913                                  
  1914                                  .setsflag68:
  1915                                  
  1916                                  ;-373 int checkConstSize(unsigned int ui) {
  1917 0000097F C9                       LEAVE
  1918 00000980 C3                       ret
  1919 00000981 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1920 0000098A 6F7220627974652072-
  1921 00000993 2F6D00             
  1922                                  ENDP
  1923                                  
  1924                                  checkConstSize: PROC
  1925                                  
  1926                                  ;-374     if (ui > 127   ) return 0;//is near; return sflag
  1927                                  
  1928                                  ;Function : checkConstSize, Number of local variables: 1
  1929                                  ;   # type sign width addr used name   list of local variables
  1930                                  ;  200 var unsg word   373 NULL ui = bp+4;
  1931 00000996 C8000000                 ENTER  0,0
  1932 0000099A 8B4604                   mov ax, [bp+4]
  1933 0000099D 83F87F                   cmp ax, 127
  1934 000009A0 0F8E0600                 jle .checkConstSize70
  1935 000009A4 B80000                   mov ax, 0
  1936 000009A7 E91600                   jmp .retncheckConstSize
  1937                                  
  1938                                  ;-375     if (ui < 0xFF80) return 0;//-128dez
  1939                                  
  1940                                  .checkConstSize70:
  1941 000009AA 8B4604                   mov ax, [bp+4]
  1942 000009AD 3D80FF                   cmp ax, 65408
  1943 000009B0 0F8D0600                 jge .checkConstSize71
  1944 000009B4 B80000                   mov ax, 0
  1945 000009B7 E90600                   jmp .retncheckConstSize
  1946                                  
  1947                                  ;-376     return 2;// is short
  1948                                  
  1949                                  .checkConstSize71:
  1950 000009BA B80200                   mov ax, 2
  1951 000009BD E90000                   jmp .retncheckConstSize
  1952                                  
  1953                                  ;-377 }
  1954                                  
  1955                                  
  1956                                  ;-378 
  1957                                  
  1958                                  
  1959                                  ;-379 
  1960                                  
  1961                                  
  1962                                  ;-380 //#include "PARSE.C"
  1963                                  
  1964                                  
  1965                                  ;-381 int parse() {
  1966                                  
  1967 000009C0 C9                       .retncheckConstSize: LEAVE
  1968 000009C1 C3                       ret
  1969                                  ENDP
  1970                                  
  1971                                  parse: PROC
  1972                                  
  1973                                  ;-382     LabelNamePtr  = &LabelNames;
  1974                                  
  1975 000009C2 B85A77                   mov ax, LabelNames
  1976 000009C5 A3[4600]                 mov word [LabelNamePtr], ax
  1977                                  
  1978                                  ;-383     JmpNamePtr= &JmpNames;
  1979                                  
  1980 000009C8 B87A93                   mov ax, JmpNames
  1981 000009CB A3[5000]                 mov word [JmpNamePtr], ax
  1982                                  
  1983                                  ;-384     LabelMaxIx=0;
  1984                                  
  1985 000009CE B80000                   mov ax, 0
  1986 000009D1 A3[4A00]                 mov word [LabelMaxIx], ax
  1987                                  
  1988                                  ;-385     JmpMaxIx=0;
  1989                                  
  1990 000009D4 B80000                   mov ax, 0
  1991 000009D7 A3[5400]                 mov word [JmpMaxIx], ax
  1992                                  
  1993                                  ;-386     BinLen=0;
  1994                                  
  1995 000009DA B80000                   mov ax, 0
  1996 000009DD A3[5800]                 mov word [BinLen], ax
  1997                                  
  1998                                  ;-387     isInProc=0;
  1999                                  
  2000 000009E0 B80000                   mov ax, 0
  2001 000009E3 A2[0D00]                 mov byte [isInProc], al
  2002                                  
  2003                                  ;-388 
  2004                                  
  2005                                  
  2006                                  ;-389     do {//process a new line
  2007                                  
  2008                                  .parse72:
  2009                                  
  2010                                  ;-390         PCStart=PC;
  2011                                  
  2012 000009E6 A1[2300]                 mov ax, [PC]
  2013 000009E9 A3[2900]                 mov word [PCStart], ax
  2014                                  
  2015                                  ;-391         OpSize=0;
  2016                                  
  2017 000009EC B80000                   mov ax, 0
  2018 000009EF A2[3700]                 mov byte [OpSize], al
  2019                                  
  2020                                  ;-392         OpPrintIndex=0;
  2021                                  
  2022 000009F2 B80000                   mov ax, 0
  2023 000009F5 A3[4100]                 mov word [OpPrintIndex], ax
  2024                                  
  2025                                  ;-393         PrintRA=' ';
  2026                                  
  2027 000009F8 B82000                   mov ax, 32
  2028 000009FB A2[4500]                 mov byte [PrintRA], al
  2029                                  
  2030                                  ;-394         getLine();
  2031                                  
  2032 000009FE E83D06                   call getLine
  2033                                  
  2034                                  ;-395         InputPtr = &InputBuf;
  2035                                  
  2036 00000A01 B88D75                   mov ax, InputBuf
  2037 00000A04 A3[1400]                 mov word [InputPtr], ax
  2038                                  
  2039                                  ;-396         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2040                                  
  2041 00000A07 E8D100                   call getTokeType
  2042                                  
  2043                                  ;-397         if (TokeType == ALNUME) {
  2044                                  
  2045 00000A0A A0[2C00]                 mov al, [TokeType]
  2046 00000A0D 3C03                     cmp al, 3
  2047 00000A0F 0F852C00                 jne .parse73
  2048                                  
  2049                                  ;-398             if (isLabel) {//set in getName
  2050                                  
  2051 00000A13 A0[2B00]                 mov al, [isLabel]
  2052 00000A16 08C0                     or  al, al
  2053 00000A18 0F842300                 je .parse74
  2054                                  
  2055                                  ;-399               if (isInProc == 0)  strcpy(ProcName, Symbol);
  2056                                  
  2057 00000A1C A0[0D00]                 mov al, [isInProc]
  2058 00000A1F 3C00                     cmp al, 0
  2059 00000A21 0F851000                 jne .parse75
  2060 00000A25 8D063075                 lea  ax, [Symbol]
  2061 00000A29 50                       push ax
  2062 00000A2A 8D066E75                 lea  ax, [ProcName]
  2063 00000A2E 50                       push ax
  2064 00000A2F E86408                   call strcpy
  2065 00000A32 83C404                   add  sp, 4
  2066                                  
  2067                                  ;-400                 storeLabel();
  2068                                  
  2069                                  .parse75:
  2070 00000A35 E8AB01                   call storeLabel
  2071                                  
  2072                                  ;-401                 InputPtr++;//remove :
  2073                                  
  2074 00000A38 FF06[1400]               inc  word[InputPtr]
  2075                                  
  2076                                  ;-402                 getTokeType();
  2077                                  
  2078 00000A3C E89C00                   call getTokeType
  2079                                  
  2080                                  ;-403             }
  2081                                  
  2082                                  
  2083                                  ;-404         }
  2084                                  
  2085                                  .parse74:
  2086                                  
  2087                                  ;-405         if (TokeType == ALNUME) {
  2088                                  
  2089                                  .parse73:
  2090 00000A3F A0[2C00]                 mov al, [TokeType]
  2091 00000A42 3C03                     cmp al, 3
  2092 00000A44 0F851B00                 jne .parse76
  2093                                  
  2094                                  ;-406             lookCode();// and OpCodePtr
  2095                                  
  2096 00000A48 E825FA                   call lookCode
  2097                                  
  2098                                  ;-407             if(CodeType) process();
  2099                                  
  2100 00000A4B A0[2F00]                 mov al, [CodeType]
  2101 00000A4E 08C0                     or  al, al
  2102 00000A50 0F840600                 je .parse77
  2103 00000A54 E83819                   call process
  2104                                  
  2105                                  ;-408             else getVariable();
  2106                                  
  2107 00000A57 E90300                   jmp .parse78
  2108                                  .parse77:
  2109 00000A5A E88102                   call getVariable
  2110                                  
  2111                                  ;-409             skipRest();
  2112                                  
  2113                                  .parse78:
  2114 00000A5D E8F504                   call skipRest
  2115                                  
  2116                                  ;-410         }
  2117                                  
  2118                                  
  2119                                  ;-411         else if (TokeType >ALNUME) error1("Label or instruction expected");
  2120                                  
  2121 00000A60 E92700                   jmp .parse79
  2122                                  .parse76:
  2123 00000A63 A0[2C00]                 mov al, [TokeType]
  2124 00000A66 3C03                     cmp al, 3
  2125 00000A68 0F8E0C00                 jle .parse80
  2126 00000A6C 68[9B0A]                 push parse_0
  2127 00000A6F E82710                   call error1
  2128 00000A72 83C402                   add  sp, 2
  2129                                  
  2130                                  ;-412         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  2131                                  
  2132 00000A75 E91200                   jmp .parse81
  2133                                  .parse80:
  2134 00000A78 A0[2C00]                 mov al, [TokeType]
  2135 00000A7B 3C01                     cmp al, 1
  2136 00000A7D 0F850900                 jne .parse82
  2137 00000A81 68[B90A]                 push parse_1
  2138 00000A84 E81210                   call error1
  2139 00000A87 83C402                   add  sp, 2
  2140                                  
  2141                                  ;-413         printLine();
  2142                                  
  2143                                  .parse82:
  2144                                  .parse81:
  2145                                  .parse79:
  2146 00000A8A E8B90D                   call printLine
  2147                                  
  2148                                  ;-414     } while (DOS_NoBytes != 0 );
  2149                                  
  2150 00000A8D A1[2000]                 mov ax, [DOS_NoBytes]
  2151 00000A90 83F800                   cmp ax, 0
  2152 00000A93 0F840300                 je  .parse83
  2153 00000A97 E94CFF                   jmp .parse72
  2154                                  .parse83:
  2155                                  
  2156                                  ;-415 }
  2157                                  
  2158                                  
  2159                                  ;-416 
  2160                                  
  2161                                  
  2162                                  ;-417 int getTokeType() {
  2163                                  
  2164 00000A9A C3                       ret
  2165 00000A9B 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2166 00000AA4 696E73747275637469-
  2167 00000AAD 6F6E20657870656374-
  2168 00000AB6 656400             
  2169 00000AB9 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2170 00000AC2 616C6C6F7765642061-
  2171 00000ACB 74207374617274206F-
  2172 00000AD4 66206C696E6500     
  2173                                  ENDP
  2174                                  
  2175                                  getTokeType: PROC
  2176                                  
  2177                                  ;-418     char c;
  2178                                  
  2179                                  
  2180                                  ;-419     skipBlank();
  2181                                  
  2182                                  ;Function : getTokeType, Number of local variables: 1
  2183                                  ;   # type sign width addr used name   list of local variables
  2184                                  ;  200 var sign byte   418 NULL c = bp-2;
  2185 00000ADB C8020000                 ENTER  2,0
  2186 00000ADF E87D06                   call skipBlank
  2187                                  
  2188                                  ;-420     c = *InputPtr;
  2189                                  
  2190 00000AE2 8B1E[1400]               mov bx, [InputPtr]
  2191 00000AE6 8A07                     mov al, [bx]
  2192 00000AE8 B400                     mov ah, 0
  2193 00000AEA 8846FE                   mov [bp-2], al
  2194                                  
  2195                                  ;-421     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2196                                  
  2197 00000AED 8A46FE                   mov al, [bp-2]
  2198 00000AF0 3C00                     cmp al, 0
  2199 00000AF2 0F850900                 jne .getTokeType84
  2200 00000AF6 B80000                   mov ax, 0
  2201 00000AF9 A2[2C00]                 mov byte [TokeType], al
  2202 00000AFC E96600                   jmp .retngetTokeType
  2203                                  
  2204                                  ;-422     if (c == ';') {TokeType=0; return; }//comment
  2205                                  
  2206                                  .getTokeType84:
  2207 00000AFF 8A46FE                   mov al, [bp-2]
  2208 00000B02 3C3B                     cmp al, 59
  2209 00000B04 0F850900                 jne .getTokeType85
  2210 00000B08 B80000                   mov ax, 0
  2211 00000B0B A2[2C00]                 mov byte [TokeType], al
  2212 00000B0E E95400                   jmp .retngetTokeType
  2213                                  
  2214                                  ;-423     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2215                                  
  2216                                  .getTokeType85:
  2217 00000B11 8A46FE                   mov al, byte [bp-2]
  2218 00000B14 B400                     mov ah, 0
  2219 00000B16 50                       push ax
  2220 00000B17 E82A07                   call digit
  2221 00000B1A 83C402                   add  sp, 2
  2222 00000B1D 08C0                     or  al, al
  2223 00000B1F 0F841500                 je .getTokeType86
  2224 00000B23 8A46FE                   mov al, byte [bp-2]
  2225 00000B26 B400                     mov ah, 0
  2226 00000B28 50                       push ax
  2227 00000B29 E85408                   call getDigit
  2228 00000B2C 83C402                   add  sp, 2
  2229 00000B2F B80100                   mov ax, 1
  2230 00000B32 A2[2C00]                 mov byte [TokeType], al
  2231 00000B35 E92D00                   jmp .retngetTokeType
  2232                                  
  2233                                  ;-424     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2234                                  
  2235                                  .getTokeType86:
  2236 00000B38 8A46FE                   mov al, byte [bp-2]
  2237 00000B3B B400                     mov ah, 0
  2238 00000B3D 50                       push ax
  2239 00000B3E E84906                   call letterE
  2240 00000B41 83C402                   add  sp, 2
  2241 00000B44 08C0                     or  al, al
  2242 00000B46 0F841500                 je .getTokeType87
  2243 00000B4A 8A46FE                   mov al, byte [bp-2]
  2244 00000B4D B400                     mov ah, 0
  2245 00000B4F 50                       push ax
  2246 00000B50 E87D08                   call getName
  2247 00000B53 83C402                   add  sp, 2
  2248 00000B56 B80300                   mov ax, 3
  2249 00000B59 A2[2C00]                 mov byte [TokeType], al
  2250 00000B5C E90600                   jmp .retngetTokeType
  2251                                  
  2252                                  ;-425     TokeType=NOALNUME;
  2253                                  
  2254                                  .getTokeType87:
  2255 00000B5F B80400                   mov ax, 4
  2256 00000B62 A2[2C00]                 mov byte [TokeType], al
  2257                                  
  2258                                  ;-426 }
  2259                                  
  2260                                  
  2261                                  ;-427 
  2262                                  
  2263                                  
  2264                                  ;-428 int storeJmp() {
  2265                                  
  2266 00000B65 C9                       .retngetTokeType: LEAVE
  2267 00000B66 C3                       ret
  2268                                  ENDP
  2269                                  
  2270                                  storeJmp: PROC
  2271                                  
  2272                                  ;-429     unsigned int i;
  2273                                  
  2274                                  
  2275                                  ;-430     JmpMaxIx++;
  2276                                  
  2277                                  ;Function : storeJmp, Number of local variables: 1
  2278                                  ;   # type sign width addr used name   list of local variables
  2279                                  ;  200 var unsg word   429 NULL i = bp-2;
  2280 00000B67 C8020000                 ENTER  2,0
  2281 00000B6B FF06[5400]               inc  word[JmpMaxIx]
  2282                                  
  2283                                  ;-431     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  2284                                  
  2285 00000B6F A1[5400]                 mov ax, [JmpMaxIx]
  2286 00000B72 3DC800                   cmp ax, 200 ;unsigned : 1
  2287 00000B75 0F8C0900                 jl  .storeJmp88
  2288 00000B79 68[C30B]                 push storeJmp_0
  2289 00000B7C E8700F                   call errorexit
  2290 00000B7F 83C402                   add  sp, 2
  2291                                  
  2292                                  ;-432     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  2293                                  
  2294                                  .storeJmp88:
  2295 00000B82 8D063075                 lea  ax, [Symbol]
  2296 00000B86 50                       push ax
  2297 00000B87 FF36[5000]               push word [JmpNamePtr]
  2298 00000B8B E80807                   call strcpy
  2299 00000B8E 83C404                   add  sp, 4
  2300 00000B91 A3[5000]                 mov word [JmpNamePtr], ax
  2301                                  
  2302                                  ;-433     JmpNamePtr++;
  2303                                  
  2304 00000B94 FF06[5000]               inc  word[JmpNamePtr]
  2305                                  
  2306                                  ;-434     i = JmpNamePtr - &JmpNames;
  2307                                  
  2308 00000B98 A1[5000]                 mov ax, [JmpNamePtr]
  2309 00000B9B 2D7A93                   sub ax, JmpNames
  2310 00000B9E 8946FE                   mov [bp-2], ax
  2311                                  
  2312                                  ;-435     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  2313                                  
  2314 00000BA1 8B46FE                   mov ax, [bp-2]
  2315 00000BA4 3D810F                   cmp ax, 3969 ;unsigned : 0
  2316 00000BA7 0F820900                 jb  .storeJmp89
  2317 00000BAB 68[D00B]                 push storeJmp_1
  2318 00000BAE E83E0F                   call errorexit
  2319 00000BB1 83C402                   add  sp, 2
  2320                                  
  2321                                  ;-436     JmpAddr[JmpMaxIx] = PC;
  2322                                  
  2323                                  .storeJmp89:
  2324 00000BB4 A1[2300]                 mov ax, [PC]
  2325 00000BB7 8B1E[5400]               mov bx, [JmpMaxIx]
  2326 00000BBB D1E3                     shl bx, 1
  2327 00000BBD 89871AA3                 mov [JmpAddr+bx], ax
  2328                                  
  2329                                  ;-437 }
  2330                                  
  2331                                  
  2332                                  ;-438 
  2333                                  
  2334                                  
  2335                                  ;-439 int storeLabel() {
  2336 00000BC1 C9                       LEAVE
  2337 00000BC2 C3                       ret
  2338 00000BC3 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  2339 00000BCC 4A6D7000           
  2340 00000BD0 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  2341 00000BD9 4A6D70206E616D6573-
  2342 00000BE2 00                 
  2343                                  ENDP
  2344                                  
  2345                                  storeLabel: PROC
  2346                                  
  2347                                  ;-440     unsigned int i;
  2348                                  
  2349                                  
  2350                                  ;-441     if(searchLabel()) error1("duplicate label");
  2351                                  
  2352                                  ;Function : storeLabel, Number of local variables: 1
  2353                                  ;   # type sign width addr used name   list of local variables
  2354                                  ;  200 var unsg word   440 NULL i = bp-2;
  2355 00000BE3 C8020000                 ENTER  2,0
  2356 00000BE7 E8A000                   call searchLabel
  2357 00000BEA 08C0                     or  al, al
  2358 00000BEC 0F840900                 je .storeLabel90
  2359 00000BF0 68[550C]                 push storeLabel_0
  2360 00000BF3 E8A30E                   call error1
  2361 00000BF6 83C402                   add  sp, 2
  2362                                  
  2363                                  ;-442     LabelMaxIx++;
  2364                                  
  2365                                  .storeLabel90:
  2366 00000BF9 FF06[4A00]               inc  word[LabelMaxIx]
  2367                                  
  2368                                  ;-443     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2369                                  
  2370 00000BFD A1[4A00]                 mov ax, [LabelMaxIx]
  2371 00000C00 3D5802                   cmp ax, 600 ;unsigned : 1
  2372 00000C03 0F8C0900                 jl  .storeLabel91
  2373 00000C07 68[650C]                 push storeLabel_1
  2374 00000C0A E8E20E                   call errorexit
  2375 00000C0D 83C402                   add  sp, 2
  2376                                  
  2377                                  ;-444     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2378                                  
  2379                                  .storeLabel91:
  2380 00000C10 8D063075                 lea  ax, [Symbol]
  2381 00000C14 50                       push ax
  2382 00000C15 FF36[4600]               push word [LabelNamePtr]
  2383 00000C19 E87A06                   call strcpy
  2384 00000C1C 83C404                   add  sp, 4
  2385 00000C1F A3[4600]                 mov word [LabelNamePtr], ax
  2386                                  
  2387                                  ;-445     LabelNamePtr++;
  2388                                  
  2389 00000C22 FF06[4600]               inc  word[LabelNamePtr]
  2390                                  
  2391                                  ;-446     i = LabelNamePtr - &LabelNames;
  2392                                  
  2393 00000C26 A1[4600]                 mov ax, [LabelNamePtr]
  2394 00000C29 2D5A77                   sub ax, LabelNames
  2395 00000C2C 8946FE                   mov [bp-2], ax
  2396                                  
  2397                                  ;-447     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2398                                  
  2399 00000C2F 8B46FE                   mov ax, [bp-2]
  2400 00000C32 3D5117                   cmp ax, 5969 ;unsigned : 0
  2401 00000C35 0F820900                 jb  .storeLabel92
  2402 00000C39 68[750C]                 push storeLabel_2
  2403 00000C3C E8B00E                   call errorexit
  2404 00000C3F 83C402                   add  sp, 2
  2405                                  
  2406                                  ;-448     LabelAddr[LabelMaxIx] = PC + Origin;
  2407                                  
  2408                                  .storeLabel92:
  2409 00000C42 A1[2300]                 mov ax, [PC]
  2410 00000C45 0306[2500]               add ax, [Origin]
  2411 00000C49 8B1E[4A00]               mov bx, [LabelMaxIx]
  2412 00000C4D D1E3                     shl bx, 1
  2413 00000C4F 8987CA8E                 mov [LabelAddr+bx], ax
  2414                                  
  2415                                  ;-449 }
  2416                                  
  2417                                  
  2418                                  ;-450 
  2419                                  
  2420                                  
  2421                                  ;-451 int searchLabel() {
  2422 00000C53 C9                       LEAVE
  2423 00000C54 C3                       ret
  2424 00000C55 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2425 00000C5E 206C6162656C00     
  2426 00000C65 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  2427 00000C6E 6C6162656C7300     
  2428 00000C75 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2429 00000C7E 6C6162656C206E616D-
  2430 00000C87 657300             
  2431                                  ENDP
  2432                                  
  2433                                  searchLabel: PROC
  2434                                  
  2435                                  ;-452     int LIx; char *p;
  2436                                  
  2437                                  
  2438                                  ;-453     p = &LabelNames;
  2439                                  
  2440                                  ;Function : searchLabel, Number of local variables: 2
  2441                                  ;   # type sign width addr used name   list of local variables
  2442                                  ;  200 var sign word   452 NULL LIx = bp-2
  2443                                  ;  201 ptr sign byte   452 NULL p = bp-4;
  2444 00000C8A C8040000                 ENTER  4,0
  2445 00000C8E B85A77                   mov ax, LabelNames
  2446 00000C91 8946FC                   mov [bp-4], ax
  2447                                  
  2448                                  ;-454     LIx = 1;
  2449                                  
  2450 00000C94 B80100                   mov ax, 1
  2451 00000C97 8946FE                   mov [bp-2], ax
  2452                                  
  2453                                  ;-455     while (LIx <= LabelMaxIx) {
  2454                                  
  2455                                  .searchLabel93:
  2456 00000C9A 8B46FE                   mov ax, [bp-2]
  2457 00000C9D 3B06[4A00]               cmp ax, [LabelMaxIx]
  2458 00000CA1 0F8F3100                 jg  .searchLabel94
  2459                                  
  2460                                  ;-456         if (eqstr(p, Symbol)) return LIx;//pos of label
  2461                                  
  2462 00000CA5 8D063075                 lea  ax, [Symbol]
  2463 00000CA9 50                       push ax
  2464 00000CAA FF76FC                   push word [bp-4]
  2465 00000CAD E81C06                   call eqstr
  2466 00000CB0 83C404                   add  sp, 4
  2467 00000CB3 08C0                     or  al, al
  2468 00000CB5 0F840600                 je .searchLabel95
  2469 00000CB9 8B46FE                   mov ax, [bp-2]
  2470 00000CBC E91D00                   jmp .retnsearchLabel
  2471                                  
  2472                                  ;-457         p=strlen(p) + p;
  2473                                  
  2474                                  .searchLabel95:
  2475 00000CBF FF76FC                   push word [bp-4]
  2476 00000CC2 E8A905                   call strlen
  2477 00000CC5 83C402                   add  sp, 2
  2478 00000CC8 0346FC                   add ax, [bp-4]
  2479 00000CCB 8946FC                   mov [bp-4], ax
  2480                                  
  2481                                  ;-458         p++;
  2482                                  
  2483 00000CCE FF46FC                   inc  word[bp-4]
  2484                                  
  2485                                  ;-459         LIx++;
  2486                                  
  2487 00000CD1 FF46FE                   inc  word[bp-2]
  2488                                  
  2489                                  ;-460     }
  2490                                  
  2491                                  
  2492                                  ;-461     return 0;
  2493                                  
  2494 00000CD4 EBC4                     jmp .searchLabel93
  2495                                  .searchLabel94:
  2496 00000CD6 B80000                   mov ax, 0
  2497 00000CD9 E90000                   jmp .retnsearchLabel
  2498                                  
  2499                                  ;-462 }
  2500                                  
  2501                                  
  2502                                  ;-463 
  2503                                  
  2504                                  
  2505                                  ;-464 int getVariable() {
  2506                                  
  2507 00000CDC C9                       .retnsearchLabel: LEAVE
  2508 00000CDD C3                       ret
  2509                                  ENDP
  2510                                  
  2511                                  getVariable: PROC
  2512                                  
  2513                                  ;-465     char c;
  2514                                  
  2515                                  
  2516                                  ;-466     storeLabel();
  2517                                  
  2518                                  ;Function : getVariable, Number of local variables: 1
  2519                                  ;   # type sign width addr used name   list of local variables
  2520                                  ;  200 var sign byte   465 NULL c = bp-2;
  2521 00000CDE C8020000                 ENTER  2,0
  2522 00000CE2 E8FEFE                   call storeLabel
  2523                                  
  2524                                  ;-467     getTokeType();
  2525                                  
  2526 00000CE5 E8F3FD                   call getTokeType
  2527                                  
  2528                                  ;-468     if(TokeType==ALNUME) {//getName
  2529                                  
  2530 00000CE8 A0[2C00]                 mov al, [TokeType]
  2531 00000CEB 3C03                     cmp al, 3
  2532 00000CED 0F857001                 jne .getVariable96
  2533                                  
  2534                                  ;-469         lookCode();
  2535                                  
  2536 00000CF1 E87CF7                   call lookCode
  2537                                  
  2538                                  ;-470         if (CodeType < 200) dataexit();
  2539                                  
  2540 00000CF4 A0[2F00]                 mov al, [CodeType]
  2541 00000CF7 3CC8                     cmp al, 200
  2542 00000CF9 0F8D0300                 jge .getVariable97
  2543 00000CFD E8970F                   call dataexit
  2544                                  
  2545                                  ;-471         if (CodeType > 205) dataexit();
  2546                                  
  2547                                  .getVariable97:
  2548 00000D00 A0[2F00]                 mov al, [CodeType]
  2549 00000D03 3CCD                     cmp al, 205
  2550 00000D05 0F8E0300                 jle .getVariable98
  2551 00000D09 E88B0F                   call dataexit
  2552                                  
  2553                                  ;-472         if (CodeType== 200) {//DB
  2554                                  
  2555                                  .getVariable98:
  2556 00000D0C A0[2F00]                 mov al, [CodeType]
  2557 00000D0F 3CC8                     cmp al, 200
  2558 00000D11 0F856A00                 jne .getVariable99
  2559                                  
  2560                                  ;-473             do {
  2561                                  
  2562                                  .getVariable100:
  2563                                  
  2564                                  ;-474                 getTokeType();
  2565                                  
  2566 00000D15 E8C3FD                   call getTokeType
  2567                                  
  2568                                  ;-475                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2569                                  
  2570 00000D18 A0[2C00]                 mov al, [TokeType]
  2571 00000D1B 3C01                     cmp al, 1
  2572 00000D1D 0F850D00                 jne .getVariable101
  2573 00000D21 FF36[0E00]               push word [SymbolInt]
  2574 00000D25 E88814                   call genCode8
  2575 00000D28 83C402                   add  sp, 2
  2576                                  
  2577                                  ;-476                 else {
  2578                                  
  2579 00000D2B E94100                   jmp .getVariable102
  2580                                  .getVariable101:
  2581                                  
  2582                                  ;-477                     skipBlank();
  2583                                  
  2584 00000D2E E82E04                   call skipBlank
  2585                                  
  2586                                  ;-478                     if (isToken('"')) {
  2587                                  
  2588 00000D31 6A22                     push 34
  2589 00000D33 E8B801                   call isToken
  2590 00000D36 83C402                   add  sp, 2
  2591 00000D39 08C0                     or  al, al
  2592 00000D3B 0F843000                 je .getVariable103
  2593                                  
  2594                                  ;-479                         do {
  2595                                  
  2596                                  .getVariable104:
  2597                                  
  2598                                  ;-480                             c= *InputPtr;
  2599                                  
  2600 00000D3F 8B1E[1400]               mov bx, [InputPtr]
  2601 00000D43 8A07                     mov al, [bx]
  2602 00000D45 B400                     mov ah, 0
  2603 00000D47 8846FE                   mov [bp-2], al
  2604                                  
  2605                                  ;-481                             genCode8(c);
  2606                                  
  2607 00000D4A 8A46FE                   mov al, byte [bp-2]
  2608 00000D4D B400                     mov ah, 0
  2609 00000D4F 50                       push ax
  2610 00000D50 E85D14                   call genCode8
  2611 00000D53 83C402                   add  sp, 2
  2612                                  
  2613                                  ;-482                             InputPtr++;
  2614                                  
  2615 00000D56 FF06[1400]               inc  word[InputPtr]
  2616                                  
  2617                                  ;-483                         } while (*InputPtr != '"' );
  2618                                  
  2619 00000D5A 8B1E[1400]               mov bx, [InputPtr]
  2620 00000D5E 8A07                     mov al, [bx]
  2621 00000D60 B400                     mov ah, 0
  2622 00000D62 83F822                   cmp ax, 34
  2623 00000D65 0F840200                 je  .getVariable105
  2624 00000D69 EBD4                     jmp .getVariable104
  2625                                  .getVariable105:
  2626                                  
  2627                                  ;-484                         InputPtr++;
  2628                                  
  2629 00000D6B FF06[1400]               inc  word[InputPtr]
  2630                                  
  2631                                  ;-485                     }
  2632                                  
  2633                                  
  2634                                  ;-486                 }
  2635                                  
  2636                                  .getVariable103:
  2637                                  
  2638                                  ;-487             } while (isToken(','));
  2639                                  
  2640                                  .getVariable102:
  2641 00000D6F 6A2C                     push 44
  2642 00000D71 E87A01                   call isToken
  2643 00000D74 83C402                   add  sp, 2
  2644 00000D77 08C0                     or  al, al
  2645 00000D79 0F840200                 je .getVariable106
  2646 00000D7D EB96                     jmp .getVariable100
  2647                                  .getVariable106:
  2648                                  
  2649                                  ;-488         }
  2650                                  
  2651                                  
  2652                                  ;-489         if (CodeType == 201) {//DW
  2653                                  
  2654                                  .getVariable99:
  2655 00000D7F A0[2F00]                 mov al, [CodeType]
  2656 00000D82 3CC9                     cmp al, 201
  2657 00000D84 0F852600                 jne .getVariable107
  2658                                  
  2659                                  ;-490             do {
  2660                                  
  2661                                  .getVariable108:
  2662                                  
  2663                                  ;-491                 getTokeType();
  2664                                  
  2665 00000D88 E850FD                   call getTokeType
  2666                                  
  2667                                  ;-492                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2668                                  
  2669 00000D8B A0[2C00]                 mov al, [TokeType]
  2670 00000D8E 3C01                     cmp al, 1
  2671 00000D90 0F850A00                 jne .getVariable109
  2672 00000D94 FF36[0E00]               push word [SymbolInt]
  2673 00000D98 E86C14                   call genCode16
  2674 00000D9B 83C402                   add  sp, 2
  2675                                  
  2676                                  ;-493             } while (isToken(','));
  2677                                  
  2678                                  .getVariable109:
  2679 00000D9E 6A2C                     push 44
  2680 00000DA0 E84B01                   call isToken
  2681 00000DA3 83C402                   add  sp, 2
  2682 00000DA6 08C0                     or  al, al
  2683 00000DA8 0F840200                 je .getVariable110
  2684 00000DAC EBDA                     jmp .getVariable108
  2685                                  .getVariable110:
  2686                                  
  2687                                  ;-494         }
  2688                                  
  2689                                  
  2690                                  ;-495         if (CodeType == 202) {//DD
  2691                                  
  2692                                  .getVariable107:
  2693 00000DAE A0[2F00]                 mov al, [CodeType]
  2694 00000DB1 3CCA                     cmp al, 202
  2695 00000DB3 0F852E00                 jne .getVariable111
  2696                                  
  2697                                  ;-496             do {
  2698                                  
  2699                                  .getVariable112:
  2700                                  
  2701                                  ;-497                 getTokeType();
  2702                                  
  2703 00000DB7 E821FD                   call getTokeType
  2704                                  
  2705                                  ;-498                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2706                                  
  2707 00000DBA A0[2C00]                 mov al, [TokeType]
  2708 00000DBD 3C01                     cmp al, 1
  2709 00000DBF 0F851200                 jne .getVariable113
  2710 00000DC3 FF36[0E00]               push word [SymbolInt]
  2711 00000DC7 E83D14                   call genCode16
  2712 00000DCA 83C402                   add  sp, 2
  2713                                  
  2714                                  ;-499                                     genCode16(0);}//todo genCode32(SymbolLong);
  2715                                  
  2716 00000DCD 6A00                     push 0
  2717 00000DCF E83514                   call genCode16
  2718 00000DD2 83C402                   add  sp, 2
  2719                                  
  2720                                  ;-500             } while (isToken(','));
  2721                                  
  2722                                  .getVariable113:
  2723 00000DD5 6A2C                     push 44
  2724 00000DD7 E81401                   call isToken
  2725 00000DDA 83C402                   add  sp, 2
  2726 00000DDD 08C0                     or  al, al
  2727 00000DDF 0F840200                 je .getVariable114
  2728 00000DE3 EBD2                     jmp .getVariable112
  2729                                  .getVariable114:
  2730                                  
  2731                                  ;-501         }
  2732                                  
  2733                                  
  2734                                  ;-502         if (CodeType >= 203) {//resb, resw, resd
  2735                                  
  2736                                  .getVariable111:
  2737 00000DE5 A0[2F00]                 mov al, [CodeType]
  2738 00000DE8 3CCB                     cmp al, 203 ;unsigned : 1
  2739 00000DEA 0F8C7000                 jl  .getVariable115
  2740                                  
  2741                                  ;-503             getTokeType();
  2742                                  
  2743 00000DEE E8EAFC                   call getTokeType
  2744                                  
  2745                                  ;-504             if (TokeType == DIGIT) {
  2746                                  
  2747 00000DF1 A0[2C00]                 mov al, [TokeType]
  2748 00000DF4 3C01                     cmp al, 1
  2749 00000DF6 0F856100                 jne .getVariable116
  2750                                  
  2751                                  ;-505                 if (SymbolInt <= 0) syntaxerror();
  2752                                  
  2753 00000DFA A1[0E00]                 mov ax, [SymbolInt]
  2754 00000DFD 83F800                   cmp ax, 0
  2755 00000E00 0F870300                 ja  .getVariable117
  2756 00000E04 E8650E                   call syntaxerror
  2757                                  
  2758                                  ;-506                 if (AbsoluteLab == 0) error1("Absolute is null");
  2759                                  
  2760                                  .getVariable117:
  2761 00000E07 A1[2700]                 mov ax, [AbsoluteLab]
  2762 00000E0A 83F800                   cmp ax, 0
  2763 00000E0D 0F850900                 jne .getVariable118
  2764 00000E11 68[660E]                 push getVariable_0
  2765 00000E14 E8820C                   call error1
  2766 00000E17 83C402                   add  sp, 2
  2767                                  
  2768                                  ;-507                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2769                                  
  2770                                  .getVariable118:
  2771 00000E1A A1[2700]                 mov ax, [AbsoluteLab]
  2772 00000E1D 8B1E[4A00]               mov bx, [LabelMaxIx]
  2773 00000E21 D1E3                     shl bx, 1
  2774 00000E23 8987CA8E                 mov [LabelAddr+bx], ax
  2775                                  
  2776                                  ;-508                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2777                                  
  2778 00000E27 A0[2F00]                 mov al, [CodeType]
  2779 00000E2A 3CCC                     cmp al, 204
  2780 00000E2C 0F850A00                 jne .getVariable119
  2781 00000E30 A1[0E00]                 mov ax, [SymbolInt]
  2782 00000E33 0306[0E00]               add ax, [SymbolInt]
  2783 00000E37 A3[0E00]                 mov word [SymbolInt], ax
  2784                                  
  2785                                  ;-509                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2786                                  
  2787                                  .getVariable119:
  2788 00000E3A A0[2F00]                 mov al, [CodeType]
  2789 00000E3D 3CCD                     cmp al, 205
  2790 00000E3F 0F850B00                 jne .getVariable120
  2791 00000E43 A1[0E00]                 mov ax, [SymbolInt]
  2792 00000E46 BB0400                   mov bx, 4
  2793 00000E49 F7E3                     mul bx
  2794 00000E4B A3[0E00]                 mov word [SymbolInt], ax
  2795                                  
  2796                                  ;-510                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2797                                  
  2798                                  .getVariable120:
  2799 00000E4E A1[2700]                 mov ax, [AbsoluteLab]
  2800 00000E51 0306[0E00]               add ax, [SymbolInt]
  2801 00000E55 A3[2700]                 mov word [AbsoluteLab], ax
  2802                                  
  2803                                  ;-511             } else numbererror();
  2804                                  
  2805 00000E58 E90300                   jmp .getVariable121
  2806                                  .getVariable116:
  2807 00000E5B E87B0D                   call numbererror
  2808                                  
  2809                                  ;-512         }
  2810                                  
  2811                                  .getVariable121:
  2812                                  
  2813                                  ;-513     }
  2814                                  
  2815                                  .getVariable115:
  2816                                  
  2817                                  ;-514     else dataexit();
  2818                                  
  2819 00000E5E E90300                   jmp .getVariable122
  2820                                  .getVariable96:
  2821 00000E61 E8330E                   call dataexit
  2822                                  
  2823                                  ;-515 }
  2824                                  
  2825                                  .getVariable122:
  2826                                  
  2827                                  ;-516 
  2828                                  
  2829                                  
  2830                                  ;-517 int getCodeSize() {
  2831 00000E64 C9                       LEAVE
  2832 00000E65 C3                       ret
  2833 00000E66 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2834 00000E6F 6973206E756C6C00   
  2835                                  ENDP
  2836                                  
  2837                                  getCodeSize: PROC
  2838                                  
  2839                                  ;-518     if (TokeType ==ALNUME) {
  2840                                  
  2841 00000E77 A0[2C00]                 mov al, [TokeType]
  2842 00000E7A 3C03                     cmp al, 3
  2843 00000E7C 0F855700                 jne .getCodeSize123
  2844                                  
  2845                                  ;-519         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2846                                  
  2847 00000E80 68[DE0E]                 push getCodeSize_0
  2848 00000E83 8D064F75                 lea  ax, [SymbolUpper]
  2849 00000E87 50                       push ax
  2850 00000E88 E84104                   call eqstr
  2851 00000E8B 83C404                   add  sp, 4
  2852 00000E8E 08C0                     or  al, al
  2853 00000E90 0F840900                 je .getCodeSize124
  2854 00000E94 E844FC                   call getTokeType
  2855 00000E97 B80100                   mov ax, 1
  2856 00000E9A E94000                   jmp .retngetCodeSize
  2857                                  
  2858                                  ;-520         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2859                                  
  2860                                  .getCodeSize124:
  2861 00000E9D 68[E30E]                 push getCodeSize_1
  2862 00000EA0 8D064F75                 lea  ax, [SymbolUpper]
  2863 00000EA4 50                       push ax
  2864 00000EA5 E82404                   call eqstr
  2865 00000EA8 83C404                   add  sp, 4
  2866 00000EAB 08C0                     or  al, al
  2867 00000EAD 0F840900                 je .getCodeSize125
  2868 00000EB1 E827FC                   call getTokeType
  2869 00000EB4 B80200                   mov ax, 2
  2870 00000EB7 E92300                   jmp .retngetCodeSize
  2871                                  
  2872                                  ;-521         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2873                                  
  2874                                  .getCodeSize125:
  2875 00000EBA 68[E80E]                 push getCodeSize_2
  2876 00000EBD 8D064F75                 lea  ax, [SymbolUpper]
  2877 00000EC1 50                       push ax
  2878 00000EC2 E80704                   call eqstr
  2879 00000EC5 83C404                   add  sp, 4
  2880 00000EC8 08C0                     or  al, al
  2881 00000ECA 0F840900                 je .getCodeSize126
  2882 00000ECE E80AFC                   call getTokeType
  2883 00000ED1 B80300                   mov ax, 3
  2884 00000ED4 E90600                   jmp .retngetCodeSize
  2885                                  
  2886                                  ;-522     }
  2887                                  
  2888                                  .getCodeSize126:
  2889                                  
  2890                                  ;-523     return 0;
  2891                                  
  2892                                  .getCodeSize123:
  2893 00000ED7 B80000                   mov ax, 0
  2894 00000EDA E90000                   jmp .retngetCodeSize
  2895                                  
  2896                                  ;-524 }
  2897                                  
  2898                                  
  2899                                  ;-525 int isToken(char c) {
  2900                                  
  2901                                   .retngetCodeSize:
  2902 00000EDD C3                       ret
  2903 00000EDE 4259544500              getCodeSize_0 db "BYTE",0
  2904 00000EE3 574F524400              getCodeSize_1 db "WORD",0
  2905 00000EE8 44574F524400            getCodeSize_2 db "DWORD",0
  2906                                  ENDP
  2907                                  
  2908                                  isToken: PROC
  2909                                  
  2910                                  ;-526     skipBlank();
  2911                                  
  2912                                  ;Function : isToken, Number of local variables: 1
  2913                                  ;   # type sign width addr used name   list of local variables
  2914                                  ;  200 var sign byte   525 NULL c = bp+4;
  2915 00000EEE C8000000                 ENTER  0,0
  2916 00000EF2 E86A02                   call skipBlank
  2917                                  
  2918                                  ;-527     if (*InputPtr == c) {
  2919                                  
  2920 00000EF5 8B1E[1400]               mov bx, [InputPtr]
  2921 00000EF9 8A07                     mov al, [bx]
  2922 00000EFB B400                     mov ah, 0
  2923 00000EFD 3A4604                   cmp al, [bp+4]
  2924 00000F00 0F850A00                 jne .isToken127
  2925                                  
  2926                                  ;-528         InputPtr++;
  2927                                  
  2928 00000F04 FF06[1400]               inc  word[InputPtr]
  2929                                  
  2930                                  ;-529         return 1;
  2931                                  
  2932 00000F08 B80100                   mov ax, 1
  2933 00000F0B E90600                   jmp .retnisToken
  2934                                  
  2935                                  ;-530         }
  2936                                  
  2937                                  
  2938                                  ;-531     return 0;
  2939                                  
  2940                                  .isToken127:
  2941 00000F0E B80000                   mov ax, 0
  2942 00000F11 E90000                   jmp .retnisToken
  2943                                  
  2944                                  ;-532 }
  2945                                  
  2946                                  
  2947                                  ;-533 int need(char c) {
  2948                                  
  2949 00000F14 C9                       .retnisToken: LEAVE
  2950 00000F15 C3                       ret
  2951                                  ENDP
  2952                                  
  2953                                  need: PROC
  2954                                  
  2955                                  ;-534     if (isToken(c)) {
  2956                                  
  2957                                  ;Function : need, Number of local variables: 1
  2958                                  ;   # type sign width addr used name   list of local variables
  2959                                  ;  200 var sign byte   533 NULL c = bp+4;
  2960 00000F16 C8000000                 ENTER  0,0
  2961 00000F1A 8A4604                   mov al, byte [bp+4]
  2962 00000F1D B400                     mov ah, 0
  2963 00000F1F 50                       push ax
  2964 00000F20 E8CBFF                   call isToken
  2965 00000F23 83C402                   add  sp, 2
  2966 00000F26 08C0                     or  al, al
  2967 00000F28 0F840600                 je .need128
  2968                                  
  2969                                  ;-535         getTokeType();
  2970                                  
  2971 00000F2C E8ACFB                   call getTokeType
  2972                                  
  2973                                  ;-536         return;
  2974                                  
  2975 00000F2F E91800                   jmp .retnneed
  2976                                  
  2977                                  ;-537         }
  2978                                  
  2979                                  
  2980                                  ;-538     error1();
  2981                                  
  2982                                  .need128:
  2983 00000F32 E8640B                   call error1
  2984                                  
  2985                                  ;-539     prs(". need: ");
  2986                                  
  2987 00000F35 68[4C0F]                 push need_0
  2988 00000F38 E80C0A                   call prs
  2989 00000F3B 83C402                   add  sp, 2
  2990                                  
  2991                                  ;-540     prc(c);
  2992                                  
  2993 00000F3E 8A4604                   mov al, byte [bp+4]
  2994 00000F41 B400                     mov ah, 0
  2995 00000F43 50                       push ax
  2996 00000F44 E8A809                   call prc
  2997 00000F47 83C402                   add  sp, 2
  2998                                  
  2999                                  ;-541 }
  3000                                  
  3001                                  
  3002                                  ;-542 int skipRest() {
  3003                                  
  3004 00000F4A C9                       .retnneed: LEAVE
  3005 00000F4B C3                       ret
  3006 00000F4C 2E206E6565643A2000      need_0 db ". need: ",0
  3007                                  ENDP
  3008                                  
  3009                                  skipRest: PROC
  3010                                  
  3011                                  ;-543     getTokeType();
  3012                                  
  3013 00000F55 E883FB                   call getTokeType
  3014                                  
  3015                                  ;-544     if(TokeType)error1("extra char ignored");
  3016                                  
  3017 00000F58 A0[2C00]                 mov al, [TokeType]
  3018 00000F5B 08C0                     or  al, al
  3019 00000F5D 0F840900                 je .skipRest129
  3020 00000F61 68[6B0F]                 push skipRest_0
  3021 00000F64 E8320B                   call error1
  3022 00000F67 83C402                   add  sp, 2
  3023                                  
  3024                                  ;-545 }
  3025                                  
  3026                                  .skipRest129:
  3027                                  
  3028                                  ;-546 
  3029                                  
  3030                                  
  3031                                  ;-547 
  3032                                  
  3033                                  
  3034                                  ;-548 //#include "HELPER.C"
  3035                                  
  3036                                  
  3037                                  ;-549 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3038                                  
  3039 00000F6A C3                       ret
  3040 00000F6B 657874726120636861-     skipRest_0 db "extra char ignored",0
  3041 00000F74 722069676E6F726564-
  3042 00000F7D 00                 
  3043                                  ENDP
  3044                                  
  3045                                  writetty: PROC
  3046 00000F7E B40E                     mov  ah, 14
  3047 00000F80 BB0000                   mov  bx, 0
  3048 00000F83 CD10                     db 205,16
  3049                                  
  3050                                  ;-550 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3051                                  
  3052 00000F85 C3                       ret
  3053                                  ENDP
  3054                                  
  3055                                  putch: PROC
  3056                                  ;Function : putch, Number of local variables: 1
  3057                                  ;   # type sign width addr used name   list of local variables
  3058                                  ;  200 var sign byte   550 NULL c = bp+4;
  3059 00000F86 C8000000                 ENTER  0,0 ; constant expression
  3060 00000F8A 807E040A                cmp byte[bp+4], 10
  3061 00000F8E 0F850500                 jne .putch130
  3062 00000F92 B00D                     mov  al, 13
  3063 00000F94 E8E7FF                   call writetty
  3064                                  .putch130:
  3065 00000F97 8A4604                   mov  al, [bp+4]
  3066 00000F9A E8E1FF                   call writetty
  3067                                  
  3068                                  ;-551 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3069 00000F9D C9                       LEAVE
  3070 00000F9E C3                       ret
  3071                                  ENDP
  3072                                  
  3073                                  cputs: PROC
  3074                                  ;Function : cputs, Number of local variables: 2
  3075                                  ;   # type sign width addr used name   list of local variables
  3076                                  ;  200 ptr sign byte   551 NULL s = bp+4
  3077                                  ;  201 var sign byte   551 NULL c = bp-2;
  3078 00000F9F C8020000                 ENTER  2,0
  3079                                  .cputs131:
  3080 00000FA3 8B5E04                   mov bx, [bp+4]
  3081 00000FA6 8A07                     mov al, [bx]
  3082 00000FA8 B400                     mov ah, 0
  3083 00000FAA 08C0                     or  al, al
  3084 00000FAC 0F841B00                 je .cputs132
  3085 00000FB0 8B5E04                   mov bx, [bp+4]
  3086 00000FB3 8A07                     mov al, [bx]
  3087 00000FB5 B400                     mov ah, 0
  3088 00000FB7 8846FE                   mov [bp-2], al
  3089 00000FBA 8A46FE                   mov al, byte [bp-2]
  3090 00000FBD B400                     mov ah, 0
  3091 00000FBF 50                       push ax
  3092 00000FC0 E8C3FF                   call putch
  3093 00000FC3 83C402                   add  sp, 2
  3094 00000FC6 FF4604                   inc  word[bp+4]
  3095 00000FC9 EBD8                     jmp .cputs131
  3096                                  .cputs132:
  3097                                  
  3098                                  ;-552 
  3099                                  
  3100                                  
  3101                                  ;-553 int DosInt() {
  3102 00000FCB C9                       LEAVE
  3103 00000FCC C3                       ret
  3104                                  ENDP
  3105                                  
  3106                                  DosInt: PROC
  3107                                  
  3108                                  ;-554     __emit__(0xCD,0x21);//inth 0x21;
  3109                                  
  3110 00000FCD CD21                     db 205,33
  3111                                  
  3112                                  ;-555     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3113                                  
  3114 00000FCF 7304                     db 115,4
  3115                                  
  3116                                  ;-556     DOS_ERR++;
  3117                                  
  3118 00000FD1 FF06[1C00]               inc  word[DOS_ERR]
  3119                                  
  3120                                  ;-557 }
  3121                                  
  3122                                  
  3123                                  ;-558 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3124                                  
  3125 00000FD5 C3                       ret
  3126                                  ENDP
  3127                                  
  3128                                  openR: PROC
  3129                                  ;Function : openR, Number of local variables: 1
  3130                                  ;   # type sign width addr used name   list of local variables
  3131                                  ;  200 ptr sign byte   558 NULL s = bp+4;
  3132 00000FD6 C8000000                 ENTER  0,0
  3133 00000FDA 8B5604                   mov  dx, [bp+4]
  3134 00000FDD B8023D                   mov  ax, 15618
  3135 00000FE0 E8EAFF                   call DosInt
  3136                                  
  3137                                  ;-559 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3138 00000FE3 C9                       LEAVE
  3139 00000FE4 C3                       ret
  3140                                  ENDP
  3141                                  
  3142                                  creatR: PROC
  3143                                  ;Function : creatR, Number of local variables: 1
  3144                                  ;   # type sign width addr used name   list of local variables
  3145                                  ;  200 ptr sign byte   559 NULL s = bp+4;
  3146 00000FE5 C8000000                 ENTER  0,0
  3147 00000FE9 8B5604                   mov  dx, [bp+4]
  3148 00000FEC B90000                   mov  cx, 0
  3149 00000FEF B8003C                   mov  ax, 15360
  3150 00000FF2 E8D8FF                   call DosInt
  3151                                  
  3152                                  ;-560 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3153 00000FF5 C9                       LEAVE
  3154 00000FF6 C3                       ret
  3155                                  ENDP
  3156                                  
  3157                                  fcloseR: PROC
  3158                                  ;Function : fcloseR, Number of local variables: 1
  3159                                  ;   # type sign width addr used name   list of local variables
  3160                                  ;  200 var sign word   560 NULL fd = bp+4;
  3161 00000FF7 C8000000                 ENTER  0,0
  3162 00000FFB 8B5E04                   mov  bx, [bp+4]
  3163 00000FFE B8003E                   mov  ax, 15872
  3164 00001001 E8C9FF                   call DosInt
  3165                                  
  3166                                  ;-561 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3167 00001004 C9                       LEAVE
  3168 00001005 C3                       ret
  3169                                  ENDP
  3170                                  
  3171                                  exitR: PROC
  3172                                  ;Function : exitR, Number of local variables: 1
  3173                                  ;   # type sign width addr used name   list of local variables
  3174                                  ;  200 var sign byte   561 NULL c = bp+4;
  3175 00001006 C8000000                 ENTER  0,0
  3176 0000100A B44C                     mov  ah, 76
  3177 0000100C 8A4604                   mov  al, [bp+4]
  3178 0000100F E8BBFF                   call DosInt
  3179                                  
  3180                                  ;-562 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3181 00001012 C9                       LEAVE
  3182 00001013 C3                       ret
  3183                                  ENDP
  3184                                  
  3185                                  readRL: PROC
  3186                                  ;Function : readRL, Number of local variables: 3
  3187                                  ;   # type sign width addr used name   list of local variables
  3188                                  ;  200 ptr sign byte   562 NULL s = bp+4
  3189                                  ;  201 var sign word   562 NULL fd = bp+6
  3190                                  ;  202 var sign word   562 NULL len = bp+8;
  3191 00001014 C8000000                 ENTER  0,0
  3192 00001018 8B5604                   mov  dx, [bp+4]
  3193 0000101B 8B4E08                   mov  cx, [bp+8]
  3194 0000101E 8B5E06                   mov  bx, [bp+6]
  3195 00001021 B8003F                   mov  ax, 16128
  3196 00001024 E8A6FF                   call DosInt
  3197                                  
  3198                                  ;-563 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3199 00001027 C9                       LEAVE
  3200 00001028 C3                       ret
  3201                                  ENDP
  3202                                  
  3203                                  fputcR: PROC
  3204                                  ;Function : fputcR, Number of local variables: 2
  3205                                  ;   # type sign width addr used name   list of local variables
  3206                                  ;  200 ptr sign byte   563 NULL n = bp+4
  3207                                  ;  201 var sign word   563 NULL fd = bp+6;
  3208 00001029 C8000000                 ENTER  0,0
  3209 0000102D 8D5604                  lea dx, [bp+4]
  3210                                  
  3211                                  ;-564   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3212                                  
  3213 00001030 B90100                   mov  cx, 1
  3214 00001033 8B5E06                   mov  bx, [bp+6]
  3215 00001036 B80040                   mov  ax, 16384
  3216 00001039 E891FF                   call DosInt
  3217                                  
  3218                                  ;-565 
  3219                                  
  3220                                  
  3221                                  ;-566 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3222 0000103C C9                       LEAVE
  3223 0000103D C3                       ret
  3224                                  ENDP
  3225                                  
  3226                                  getLine: PROC
  3227                                  
  3228                                  ;-567   unsigned int i;
  3229                                  
  3230                                  
  3231                                  ;-568   InputPtr= &InputBuf;
  3232                                  
  3233                                  ;Function : getLine, Number of local variables: 1
  3234                                  ;   # type sign width addr used name   list of local variables
  3235                                  ;  200 var unsg word   567 NULL i = bp-2;
  3236 0000103E C8020000                 ENTER  2,0
  3237 00001042 B88D75                   mov ax, InputBuf
  3238 00001045 A3[1400]                 mov word [InputPtr], ax
  3239                                  
  3240                                  ;-569   *InputPtr=0;//if last line is empty
  3241                                  
  3242 00001048 B80000                   mov ax, 0
  3243 0000104B 8B1E[1400]               mov  bx, [InputPtr]
  3244 0000104F 8807                     mov  [bx], al
  3245                                  
  3246                                  ;-570   do {
  3247                                  
  3248                                  .getLine133:
  3249                                  
  3250                                  ;-571     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3251                                  
  3252 00001051 6A01                     push 1
  3253 00001053 FF36[1600]               push word [asm_fd]
  3254 00001057 8D06[2200]               lea  ax, [DOS_ByteRead]
  3255 0000105B 50                       push ax
  3256 0000105C E8B5FF                   call readRL
  3257 0000105F 83C406                   add  sp, 6
  3258 00001062 A3[2000]                 mov word [DOS_NoBytes], ax
  3259                                  
  3260                                  ;-572     if (DOS_ERR) errorexit("Reading Source");
  3261                                  
  3262 00001065 A1[1C00]                 mov ax, [DOS_ERR]
  3263 00001068 08C0                     or  al, al
  3264 0000106A 0F840900                 je .getLine134
  3265 0000106E 68[D010]                 push getLine_0
  3266 00001071 E87B0A                   call errorexit
  3267 00001074 83C402                   add  sp, 2
  3268                                  
  3269                                  ;-573     if (DOS_NoBytes == 0) return;
  3270                                  
  3271                                  .getLine134:
  3272 00001077 A1[2000]                 mov ax, [DOS_NoBytes]
  3273 0000107A 83F800                   cmp ax, 0
  3274 0000107D 0F850300                 jne .getLine135
  3275 00001081 E94A00                   jmp .retngetLine
  3276                                  
  3277                                  ;-574     *InputPtr = DOS_ByteRead;
  3278                                  
  3279                                  .getLine135:
  3280 00001084 A0[2200]                 mov al, [DOS_ByteRead]
  3281 00001087 8B1E[1400]               mov  bx, [InputPtr]
  3282 0000108B 8807                     mov  [bx], al
  3283                                  
  3284                                  ;-575     InputPtr++;
  3285                                  
  3286 0000108D FF06[1400]               inc  word[InputPtr]
  3287                                  
  3288                                  ;-576     i = InputPtr - &InputBuf;
  3289                                  
  3290 00001091 A1[1400]                 mov ax, [InputPtr]
  3291 00001094 2D8D75                   sub ax, InputBuf
  3292 00001097 8946FE                   mov [bp-2], ax
  3293                                  
  3294                                  ;-577     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3295                                  
  3296 0000109A 8B46FE                   mov ax, [bp-2]
  3297 0000109D 3DFF00                   cmp ax, 255 ;unsigned : 0
  3298 000010A0 0F820900                 jb  .getLine136
  3299 000010A4 68[DF10]                 push getLine_1
  3300 000010A7 E8450A                   call errorexit
  3301 000010AA 83C402                   add  sp, 2
  3302                                  
  3303                                  ;-578   } while (ifEOL(DOS_ByteRead) == 0);
  3304                                  
  3305                                  .getLine136:
  3306 000010AD A0[2200]                 mov al, byte [DOS_ByteRead]
  3307 000010B0 B400                     mov ah, 0
  3308 000010B2 50                       push ax
  3309 000010B3 E83D00                   call ifEOL
  3310 000010B6 83C402                   add  sp, 2
  3311 000010B9 3C00                     cmp al, 0
  3312 000010BB 0F850200                 jne .getLine137
  3313 000010BF EB90                     jmp .getLine133
  3314                                  .getLine137:
  3315                                  
  3316                                  ;-579   InputPtr--;
  3317                                  
  3318 000010C1 FF0E[1400]               dec  word[InputPtr]
  3319                                  
  3320                                  ;-580   *InputPtr=0;
  3321                                  
  3322 000010C5 B80000                   mov ax, 0
  3323 000010C8 8B1E[1400]               mov  bx, [InputPtr]
  3324 000010CC 8807                     mov  [bx], al
  3325                                  
  3326                                  ;-581 }
  3327                                  
  3328                                  
  3329                                  ;-582 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3330                                  
  3331 000010CE C9                       .retngetLine: LEAVE
  3332 000010CF C3                       ret
  3333 000010D0 52656164696E672053-     getLine_0 db "Reading Source",0
  3334 000010D9 6F7572636500       
  3335 000010DF 696E707574206C696E-     getLine_1 db "input line too long",0
  3336 000010E8 6520746F6F206C6F6E-
  3337 000010F1 6700               
  3338                                  ENDP
  3339                                  
  3340                                  ifEOL: PROC
  3341                                  
  3342                                  ;-583   if (c == 10) return 1;//LF
  3343                                  
  3344                                  ;Function : ifEOL, Number of local variables: 1
  3345                                  ;   # type sign width addr used name   list of local variables
  3346                                  ;  200 var sign byte   582 NULL c = bp+4;
  3347 000010F3 C8000000                 ENTER  0,0
  3348 000010F7 8A4604                   mov al, [bp+4]
  3349 000010FA 3C0A                     cmp al, 10
  3350 000010FC 0F850600                 jne .ifEOL138
  3351 00001100 B80100                   mov ax, 1
  3352 00001103 E93B00                   jmp .retnifEOL
  3353                                  
  3354                                  ;-584   if (c == 13) {//CR
  3355                                  
  3356                                  .ifEOL138:
  3357 00001106 8A4604                   mov al, [bp+4]
  3358 00001109 3C0D                     cmp al, 13
  3359 0000110B 0F852C00                 jne .ifEOL139
  3360                                  
  3361                                  ;-585     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3362                                  
  3363 0000110F 6A01                     push 1
  3364 00001111 FF36[1600]               push word [asm_fd]
  3365 00001115 8D06[2200]               lea  ax, [DOS_ByteRead]
  3366 00001119 50                       push ax
  3367 0000111A E8F7FE                   call readRL
  3368 0000111D 83C406                   add  sp, 6
  3369 00001120 A3[2000]                 mov word [DOS_NoBytes], ax
  3370                                  
  3371                                  ;-586     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3372                                  
  3373 00001123 A0[2200]                 mov al, [DOS_ByteRead]
  3374 00001126 3C0A                     cmp al, 10
  3375 00001128 0F840900                 je  .ifEOL140
  3376 0000112C 68[4311]                 push ifEOL_0
  3377 0000112F E8BD09                   call errorexit
  3378 00001132 83C402                   add  sp, 2
  3379                                  
  3380                                  ;-587     return 1;
  3381                                  
  3382                                  .ifEOL140:
  3383 00001135 B80100                   mov ax, 1
  3384 00001138 E90600                   jmp .retnifEOL
  3385                                  
  3386                                  ;-588   }
  3387                                  
  3388                                  
  3389                                  ;-589   return 0;
  3390                                  
  3391                                  .ifEOL139:
  3392 0000113B B80000                   mov ax, 0
  3393 0000113E E90000                   jmp .retnifEOL
  3394                                  
  3395                                  ;-590 }
  3396                                  
  3397                                  
  3398                                  ;-591 int skipBlank() {
  3399                                  
  3400 00001141 C9                       .retnifEOL: LEAVE
  3401 00001142 C3                       ret
  3402 00001143 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3403 0000114C 462831302920616674-
  3404 00001155 657220435228313329-
  3405 0000115E 00                 
  3406                                  ENDP
  3407                                  
  3408                                  skipBlank: PROC
  3409                                  
  3410                                  ;-592   skipblank1:
  3411                                  
  3412                                  .skipblank1:
  3413                                  
  3414                                  ;-593     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3415                                  
  3416 0000115F 8B1E[1400]               mov bx, [InputPtr]
  3417 00001163 8A07                     mov al, [bx]
  3418 00001165 B400                     mov ah, 0
  3419 00001167 83F820                   cmp ax, 32
  3420 0000116A 0F850600                 jne .skipBlank141
  3421 0000116E FF06[1400]               inc  word[InputPtr]
  3422 00001172 EBEB                     jmp .skipblank1
  3423                                  
  3424                                  ;-594     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3425                                  
  3426                                  .skipBlank141:
  3427 00001174 8B1E[1400]               mov bx, [InputPtr]
  3428 00001178 8A07                     mov al, [bx]
  3429 0000117A B400                     mov ah, 0
  3430 0000117C 83F809                   cmp ax, 9
  3431 0000117F 0F850600                 jne .skipBlank142
  3432 00001183 FF06[1400]               inc  word[InputPtr]
  3433 00001187 EBD6                     jmp .skipblank1
  3434                                  
  3435                                  ;-595 }
  3436                                  
  3437                                  .skipBlank142:
  3438                                  
  3439                                  ;-596 int letterE(char c) {
  3440                                  
  3441 00001189 C3                       ret
  3442                                  ENDP
  3443                                  
  3444                                  letterE: PROC
  3445                                  
  3446                                  ;-597   if (c=='_') return 1;
  3447                                  
  3448                                  ;Function : letterE, Number of local variables: 1
  3449                                  ;   # type sign width addr used name   list of local variables
  3450                                  ;  200 var sign byte   596 NULL c = bp+4;
  3451 0000118A C8000000                 ENTER  0,0
  3452 0000118E 8A4604                   mov al, [bp+4]
  3453 00001191 3C5F                     cmp al, 95
  3454 00001193 0F850600                 jne .letterE143
  3455 00001197 B80100                   mov ax, 1
  3456 0000119A E96900                   jmp .retnletterE
  3457                                  
  3458                                  ;-598   if (c=='.') return 1;
  3459                                  
  3460                                  .letterE143:
  3461 0000119D 8A4604                   mov al, [bp+4]
  3462 000011A0 3C2E                     cmp al, 46
  3463 000011A2 0F850600                 jne .letterE144
  3464 000011A6 B80100                   mov ax, 1
  3465 000011A9 E95A00                   jmp .retnletterE
  3466                                  
  3467                                  ;-599   if (c=='?') return 1;
  3468                                  
  3469                                  .letterE144:
  3470 000011AC 8A4604                   mov al, [bp+4]
  3471 000011AF 3C3F                     cmp al, 63
  3472 000011B1 0F850600                 jne .letterE145
  3473 000011B5 B80100                   mov ax, 1
  3474 000011B8 E94B00                   jmp .retnletterE
  3475                                  
  3476                                  ;-600   if (c=='$') return 1;
  3477                                  
  3478                                  .letterE145:
  3479 000011BB 8A4604                   mov al, [bp+4]
  3480 000011BE 3C24                     cmp al, 36
  3481 000011C0 0F850600                 jne .letterE146
  3482 000011C4 B80100                   mov ax, 1
  3483 000011C7 E93C00                   jmp .retnletterE
  3484                                  
  3485                                  ;-601   if (c> 'z') return 0;
  3486                                  
  3487                                  .letterE146:
  3488 000011CA 8A4604                   mov al, [bp+4]
  3489 000011CD 3C7A                     cmp al, 122
  3490 000011CF 0F8E0600                 jle .letterE147
  3491 000011D3 B80000                   mov ax, 0
  3492 000011D6 E92D00                   jmp .retnletterE
  3493                                  
  3494                                  ;-602   if (c< '@') return 0; // at included
  3495                                  
  3496                                  .letterE147:
  3497 000011D9 8A4604                   mov al, [bp+4]
  3498 000011DC 3C40                     cmp al, 64
  3499 000011DE 0F8D0600                 jge .letterE148
  3500 000011E2 B80000                   mov ax, 0
  3501 000011E5 E91E00                   jmp .retnletterE
  3502                                  
  3503                                  ;-603   if (c> 'Z') { if (c< 'a') return 0; }
  3504                                  
  3505                                  .letterE148:
  3506 000011E8 8A4604                   mov al, [bp+4]
  3507 000011EB 3C5A                     cmp al, 90
  3508 000011ED 0F8E0F00                 jle .letterE149
  3509 000011F1 8A4604                   mov al, [bp+4]
  3510 000011F4 3C61                     cmp al, 97
  3511 000011F6 0F8D0600                 jge .letterE150
  3512 000011FA B80000                   mov ax, 0
  3513 000011FD E90600                   jmp .retnletterE
  3514                                  .letterE150:
  3515                                  
  3516                                  ;-604   return 1;
  3517                                  
  3518                                  .letterE149:
  3519 00001200 B80100                   mov ax, 1
  3520 00001203 E90000                   jmp .retnletterE
  3521                                  
  3522                                  ;-605 }
  3523                                  
  3524                                  
  3525                                  ;-606 int alnumE(char c) {
  3526                                  
  3527 00001206 C9                       .retnletterE: LEAVE
  3528 00001207 C3                       ret
  3529                                  ENDP
  3530                                  
  3531                                  alnumE: PROC
  3532                                  
  3533                                  ;-607   if (digit(c)) return 1;
  3534                                  
  3535                                  ;Function : alnumE, Number of local variables: 1
  3536                                  ;   # type sign width addr used name   list of local variables
  3537                                  ;  200 var sign byte   606 NULL c = bp+4;
  3538 00001208 C8000000                 ENTER  0,0
  3539 0000120C 8A4604                   mov al, byte [bp+4]
  3540 0000120F B400                     mov ah, 0
  3541 00001211 50                       push ax
  3542 00001212 E82F00                   call digit
  3543 00001215 83C402                   add  sp, 2
  3544 00001218 08C0                     or  al, al
  3545 0000121A 0F840600                 je .alnumE151
  3546 0000121E B80100                   mov ax, 1
  3547 00001221 E91E00                   jmp .retnalnumE
  3548                                  
  3549                                  ;-608   if (letterE(c)) return 1;
  3550                                  
  3551                                  .alnumE151:
  3552 00001224 8A4604                   mov al, byte [bp+4]
  3553 00001227 B400                     mov ah, 0
  3554 00001229 50                       push ax
  3555 0000122A E85DFF                   call letterE
  3556 0000122D 83C402                   add  sp, 2
  3557 00001230 08C0                     or  al, al
  3558 00001232 0F840600                 je .alnumE152
  3559 00001236 B80100                   mov ax, 1
  3560 00001239 E90600                   jmp .retnalnumE
  3561                                  
  3562                                  ;-609   return 0;
  3563                                  
  3564                                  .alnumE152:
  3565 0000123C B80000                   mov ax, 0
  3566 0000123F E90000                   jmp .retnalnumE
  3567                                  
  3568                                  ;-610 }
  3569                                  
  3570                                  
  3571                                  ;-611 int digit(char c){
  3572                                  
  3573 00001242 C9                       .retnalnumE: LEAVE
  3574 00001243 C3                       ret
  3575                                  ENDP
  3576                                  
  3577                                  digit: PROC
  3578                                  
  3579                                  ;-612     if(c<'0') return 0;
  3580                                  
  3581                                  ;Function : digit, Number of local variables: 1
  3582                                  ;   # type sign width addr used name   list of local variables
  3583                                  ;  200 var sign byte   611 NULL c = bp+4;
  3584 00001244 C8000000                 ENTER  0,0
  3585 00001248 8A4604                   mov al, [bp+4]
  3586 0000124B 3C30                     cmp al, 48
  3587 0000124D 0F8D0600                 jge .digit153
  3588 00001251 B80000                   mov ax, 0
  3589 00001254 E91500                   jmp .retndigit
  3590                                  
  3591                                  ;-613     if(c>'9') return 0;
  3592                                  
  3593                                  .digit153:
  3594 00001257 8A4604                   mov al, [bp+4]
  3595 0000125A 3C39                     cmp al, 57
  3596 0000125C 0F8E0600                 jle .digit154
  3597 00001260 B80000                   mov ax, 0
  3598 00001263 E90600                   jmp .retndigit
  3599                                  
  3600                                  ;-614     return 1;
  3601                                  
  3602                                  .digit154:
  3603 00001266 B80100                   mov ax, 1
  3604 00001269 E90000                   jmp .retndigit
  3605                                  
  3606                                  ;-615 }
  3607                                  
  3608                                  
  3609                                  ;-616 int strlen(char *s) { int c;
  3610                                  
  3611 0000126C C9                       .retndigit: LEAVE
  3612 0000126D C3                       ret
  3613                                  ENDP
  3614                                  
  3615                                  strlen: PROC
  3616                                  
  3617                                  ;-617     c=0;
  3618                                  
  3619                                  ;Function : strlen, Number of local variables: 2
  3620                                  ;   # type sign width addr used name   list of local variables
  3621                                  ;  200 ptr sign byte   616 NULL s = bp+4
  3622                                  ;  201 var sign word   616 NULL c = bp-2;
  3623 0000126E C8020000                 ENTER  2,0
  3624 00001272 B80000                   mov ax, 0
  3625 00001275 8946FE                   mov [bp-2], ax
  3626                                  
  3627                                  ;-618     while (*s!=0) {s++; c++;}
  3628                                  
  3629                                  .strlen155:
  3630 00001278 8B5E04                   mov bx, [bp+4]
  3631 0000127B 8A07                     mov al, [bx]
  3632 0000127D B400                     mov ah, 0
  3633 0000127F 83F800                   cmp ax, 0
  3634 00001282 0F840800                 je  .strlen156
  3635 00001286 FF4604                   inc  word[bp+4]
  3636 00001289 FF46FE                   inc  word[bp-2]
  3637                                  
  3638                                  ;-619     return c;
  3639                                  
  3640 0000128C EBEA                     jmp .strlen155
  3641                                  .strlen156:
  3642 0000128E 8B46FE                   mov ax, [bp-2]
  3643 00001291 E90000                   jmp .retnstrlen
  3644                                  
  3645                                  ;-620     }
  3646                                  
  3647                                  
  3648                                  ;-621 int strcpy(char *s, char *t) {
  3649                                  
  3650 00001294 C9                       .retnstrlen: LEAVE
  3651 00001295 C3                       ret
  3652                                  ENDP
  3653                                  
  3654                                  strcpy: PROC
  3655                                  
  3656                                  ;-622     do { *s=*t; s++; t++; }
  3657                                  
  3658                                  ;Function : strcpy, Number of local variables: 2
  3659                                  ;   # type sign width addr used name   list of local variables
  3660                                  ;  200 ptr sign byte   621 NULL s = bp+4
  3661                                  ;  201 ptr sign byte   621 NULL t = bp+6;
  3662 00001296 C8000000                 ENTER  0,0
  3663                                  .strcpy157:
  3664 0000129A 8B5E06                   mov bx, [bp+6]
  3665 0000129D 8A07                     mov al, [bx]
  3666 0000129F B400                     mov ah, 0
  3667 000012A1 8B5E04                   mov  bx, [bp+4]
  3668 000012A4 8807                     mov  [bx], al
  3669 000012A6 FF4604                   inc  word[bp+4]
  3670 000012A9 FF4606                   inc  word[bp+6]
  3671                                  
  3672                                  ;-623     while (*t!=0);
  3673                                  
  3674 000012AC 8B5E06                   mov bx, [bp+6]
  3675 000012AF 8A07                     mov al, [bx]
  3676 000012B1 B400                     mov ah, 0
  3677 000012B3 83F800                   cmp ax, 0
  3678 000012B6 0F840200                 je  .strcpy158
  3679 000012BA EBDE                     jmp .strcpy157
  3680                                  .strcpy158:
  3681                                  
  3682                                  ;-624     *s=0;
  3683                                  
  3684 000012BC B80000                   mov ax, 0
  3685 000012BF 8B5E04                   mov  bx, [bp+4]
  3686 000012C2 8807                     mov  [bx], al
  3687                                  
  3688                                  ;-625     return s;
  3689                                  
  3690 000012C4 8B4604                   mov ax, [bp+4]
  3691 000012C7 E90000                   jmp .retnstrcpy
  3692                                  
  3693                                  ;-626     }
  3694                                  
  3695                                  
  3696                                  ;-627 int eqstr(char *p, char *q) {
  3697                                  
  3698 000012CA C9                       .retnstrcpy: LEAVE
  3699 000012CB C3                       ret
  3700                                  ENDP
  3701                                  
  3702                                  eqstr: PROC
  3703                                  
  3704                                  ;-628     while(*p) {
  3705                                  
  3706                                  ;Function : eqstr, Number of local variables: 2
  3707                                  ;   # type sign width addr used name   list of local variables
  3708                                  ;  200 ptr sign byte   627 NULL p = bp+4
  3709                                  ;  201 ptr sign byte   627 NULL q = bp+6;
  3710 000012CC C8000000                 ENTER  0,0
  3711                                  .eqstr159:
  3712 000012D0 8B5E04                   mov bx, [bp+4]
  3713 000012D3 8A07                     mov al, [bx]
  3714 000012D5 B400                     mov ah, 0
  3715 000012D7 08C0                     or  al, al
  3716 000012D9 0F842000                 je .eqstr160
  3717                                  
  3718                                  ;-629         if (*p != *q) return 0;
  3719                                  
  3720 000012DD 8B5E04                   mov bx, [bp+4]
  3721 000012E0 8A07                     mov al, [bx]
  3722 000012E2 B400                     mov ah, 0
  3723 000012E4 8B5E06                   mov bx, [bp+6]
  3724 000012E7 3A07                     cmp al, [bx]
  3725 000012E9 B400                     mov ah, 0
  3726 000012EB 0F840600                 je  .eqstr161
  3727 000012EF B80000                   mov ax, 0
  3728 000012F2 E92100                   jmp .retneqstr
  3729                                  
  3730                                  ;-630             p++;
  3731                                  
  3732                                  .eqstr161:
  3733 000012F5 FF4604                   inc  word[bp+4]
  3734                                  
  3735                                  ;-631             q++;
  3736                                  
  3737 000012F8 FF4606                   inc  word[bp+6]
  3738                                  
  3739                                  ;-632             }
  3740                                  
  3741                                  
  3742                                  ;-633     if(*q) return 0;
  3743                                  
  3744 000012FB EBD3                     jmp .eqstr159
  3745                                  .eqstr160:
  3746 000012FD 8B5E06                   mov bx, [bp+6]
  3747 00001300 8A07                     mov al, [bx]
  3748 00001302 B400                     mov ah, 0
  3749 00001304 08C0                     or  al, al
  3750 00001306 0F840600                 je .eqstr162
  3751 0000130A B80000                   mov ax, 0
  3752 0000130D E90600                   jmp .retneqstr
  3753                                  
  3754                                  ;-634     return 1;
  3755                                  
  3756                                  .eqstr162:
  3757 00001310 B80100                   mov ax, 1
  3758 00001313 E90000                   jmp .retneqstr
  3759                                  
  3760                                  ;-635     }
  3761                                  
  3762                                  
  3763                                  ;-636 int strcat1(char *s, char *t) {
  3764                                  
  3765 00001316 C9                       .retneqstr: LEAVE
  3766 00001317 C3                       ret
  3767                                  ENDP
  3768                                  
  3769                                  strcat1: PROC
  3770                                  
  3771                                  ;-637     while (*s != 0) s++;
  3772                                  
  3773                                  ;Function : strcat1, Number of local variables: 2
  3774                                  ;   # type sign width addr used name   list of local variables
  3775                                  ;  200 ptr sign byte   636 NULL s = bp+4
  3776                                  ;  201 ptr sign byte   636 NULL t = bp+6;
  3777 00001318 C8000000                 ENTER  0,0
  3778                                  .strcat1163:
  3779 0000131C 8B5E04                   mov bx, [bp+4]
  3780 0000131F 8A07                     mov al, [bx]
  3781 00001321 B400                     mov ah, 0
  3782 00001323 83F800                   cmp ax, 0
  3783 00001326 0F840500                 je  .strcat1164
  3784 0000132A FF4604                   inc  word[bp+4]
  3785                                  
  3786                                  ;-638     strcpy(s, t);
  3787                                  
  3788 0000132D EBED                     jmp .strcat1163
  3789                                  .strcat1164:
  3790 0000132F FF7606                   push word [bp+6]
  3791 00001332 FF7604                   push word [bp+4]
  3792 00001335 E85EFF                   call strcpy
  3793 00001338 83C404                   add  sp, 4
  3794                                  
  3795                                  ;-639     }
  3796                                  
  3797                                  
  3798                                  ;-640 int toupper(char *s) {
  3799 0000133B C9                       LEAVE
  3800 0000133C C3                       ret
  3801                                  ENDP
  3802                                  
  3803                                  toupper: PROC
  3804                                  
  3805                                  ;-641     while(*s) {
  3806                                  
  3807                                  ;Function : toupper, Number of local variables: 1
  3808                                  ;   # type sign width addr used name   list of local variables
  3809                                  ;  200 ptr sign byte   640 NULL s = bp+4;
  3810 0000133D C8000000                 ENTER  0,0
  3811                                  .toupper165:
  3812 00001341 8B5E04                   mov bx, [bp+4]
  3813 00001344 8A07                     mov al, [bx]
  3814 00001346 B400                     mov ah, 0
  3815 00001348 08C0                     or  al, al
  3816 0000134A 0F843000                 je .toupper166
  3817                                  
  3818                                  ;-642         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3819                                  
  3820 0000134E 8B5E04                   mov bx, [bp+4]
  3821 00001351 8A07                     mov al, [bx]
  3822 00001353 B400                     mov ah, 0
  3823 00001355 83F861                   cmp ax, 97 ;unsigned : 1
  3824 00001358 0F8C1D00                 jl  .toupper167
  3825 0000135C 8B5E04                   mov bx, [bp+4]
  3826 0000135F 8A07                     mov al, [bx]
  3827 00001361 B400                     mov ah, 0
  3828 00001363 83F87A                   cmp ax, 122
  3829 00001366 0F8F0F00                 jg  .toupper168
  3830 0000136A 8B5E04                   mov bx, [bp+4]
  3831 0000136D 8A07                     mov al, [bx]
  3832 0000136F B400                     mov ah, 0
  3833 00001371 83E820                   sub ax, 32
  3834 00001374 8B5E04                   mov  bx, [bp+4]
  3835 00001377 8807                     mov  [bx], al
  3836                                  
  3837                                  ;-643             s++;
  3838                                  
  3839                                  .toupper168:
  3840                                  .toupper167:
  3841 00001379 FF4604                   inc  word[bp+4]
  3842                                  
  3843                                  ;-644               }
  3844                                  
  3845                                  
  3846                                  ;-645     }
  3847                                  
  3848 0000137C EBC3                     jmp .toupper165
  3849                                  .toupper166:
  3850                                  
  3851                                  ;-646 
  3852                                  
  3853                                  
  3854                                  ;-647 int getDigit(unsigned char c) {//ret: SymbolInt
  3855 0000137E C9                       LEAVE
  3856 0000137F C3                       ret
  3857                                  ENDP
  3858                                  
  3859                                  getDigit: PROC
  3860                                  
  3861                                  ;-648   unsigned int CastInt;
  3862                                  
  3863                                  
  3864                                  ;-649   SymbolInt=0;
  3865                                  
  3866                                  ;Function : getDigit, Number of local variables: 2
  3867                                  ;   # type sign width addr used name   list of local variables
  3868                                  ;  200 var unsg byte   647 NULL c = bp+4
  3869                                  ;  201 var unsg word   648 NULL CastInt = bp-2;
  3870 00001380 C8020000                 ENTER  2,0
  3871 00001384 B80000                   mov ax, 0
  3872 00001387 A3[0E00]                 mov word [SymbolInt], ax
  3873                                  
  3874                                  ;-650   do {
  3875                                  
  3876                                  .getDigit169:
  3877                                  
  3878                                  ;-651     c-='0';
  3879                                  
  3880 0000138A 806E0430                 sub  byte[bp+4], 48
  3881                                  
  3882                                  ;-652     SymbolInt=SymbolInt*10;
  3883                                  
  3884 0000138E A1[0E00]                 mov ax, [SymbolInt]
  3885 00001391 BB0A00                   mov bx, 10
  3886 00001394 F7E3                     mul bx
  3887 00001396 A3[0E00]                 mov word [SymbolInt], ax
  3888                                  
  3889                                  ;-653     ax=0; CastInt=c; //cast b2w
  3890                                  
  3891 00001399 B80000                   mov  ax, 0
  3892 0000139C 8A4604                   mov al, [bp+4]
  3893 0000139F 8946FE                   mov [bp-2], ax
  3894                                  
  3895                                  ;-654     SymbolInt=SymbolInt+CastInt;
  3896                                  
  3897 000013A2 A1[0E00]                 mov ax, [SymbolInt]
  3898 000013A5 0346FE                   add ax, [bp-2]
  3899 000013A8 A3[0E00]                 mov word [SymbolInt], ax
  3900                                  
  3901                                  ;-655     InputPtr++;
  3902                                  
  3903 000013AB FF06[1400]               inc  word[InputPtr]
  3904                                  
  3905                                  ;-656     c = *InputPtr;
  3906                                  
  3907 000013AF 8B1E[1400]               mov bx, [InputPtr]
  3908 000013B3 8A07                     mov al, [bx]
  3909 000013B5 B400                     mov ah, 0
  3910 000013B7 884604                   mov [bp+4], al
  3911                                  
  3912                                  ;-657   } while(digit(c));
  3913                                  
  3914 000013BA 8A4604                   mov al, byte [bp+4]
  3915 000013BD B400                     mov ah, 0
  3916 000013BF 50                       push ax
  3917 000013C0 E881FE                   call digit
  3918 000013C3 83C402                   add  sp, 2
  3919 000013C6 08C0                     or  al, al
  3920 000013C8 0F840200                 je .getDigit170
  3921 000013CC EBBC                     jmp .getDigit169
  3922                                  .getDigit170:
  3923                                  
  3924                                  ;-658 }
  3925                                  
  3926                                  
  3927                                  ;-659 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3928 000013CE C9                       LEAVE
  3929 000013CF C3                       ret
  3930                                  ENDP
  3931                                  
  3932                                  getName: PROC
  3933                                  
  3934                                  ;-660   char *p; unsigned int i;
  3935                                  
  3936                                  
  3937                                  ;-661   p = &Symbol;
  3938                                  
  3939                                  ;Function : getName, Number of local variables: 3
  3940                                  ;   # type sign width addr used name   list of local variables
  3941                                  ;  200 var unsg byte   659 NULL c = bp+4
  3942                                  ;  201 ptr sign byte   660 NULL p = bp-2
  3943                                  ;  202 var unsg word   660 NULL i = bp-4;
  3944 000013D0 C8040000                 ENTER  4,0
  3945 000013D4 B83075                   mov ax, Symbol
  3946 000013D7 8946FE                   mov [bp-2], ax
  3947                                  
  3948                                  ;-662   *p = c;
  3949                                  
  3950 000013DA 8A4604                   mov al, [bp+4]
  3951 000013DD 8B5EFE                   mov  bx, [bp-2]
  3952 000013E0 8807                     mov  [bx], al
  3953                                  
  3954                                  ;-663   p++;
  3955                                  
  3956 000013E2 FF46FE                   inc  word[bp-2]
  3957                                  
  3958                                  ;-664   while (alnumE(c)) {
  3959                                  
  3960                                  .getName171:
  3961 000013E5 8A4604                   mov al, byte [bp+4]
  3962 000013E8 B400                     mov ah, 0
  3963 000013EA 50                       push ax
  3964 000013EB E81AFE                   call alnumE
  3965 000013EE 83C402                   add  sp, 2
  3966 000013F1 08C0                     or  al, al
  3967 000013F3 0F843800                 je .getName172
  3968                                  
  3969                                  ;-665     InputPtr++;
  3970                                  
  3971 000013F7 FF06[1400]               inc  word[InputPtr]
  3972                                  
  3973                                  ;-666     c = *InputPtr;
  3974                                  
  3975 000013FB 8B1E[1400]               mov bx, [InputPtr]
  3976 000013FF 8A07                     mov al, [bx]
  3977 00001401 B400                     mov ah, 0
  3978 00001403 884604                   mov [bp+4], al
  3979                                  
  3980                                  ;-667     *p = c;
  3981                                  
  3982 00001406 8A4604                   mov al, [bp+4]
  3983 00001409 8B5EFE                   mov  bx, [bp-2]
  3984 0000140C 8807                     mov  [bx], al
  3985                                  
  3986                                  ;-668     p++;
  3987                                  
  3988 0000140E FF46FE                   inc  word[bp-2]
  3989                                  
  3990                                  ;-669     i = p - &Symbol;
  3991                                  
  3992 00001411 8B46FE                   mov ax, [bp-2]
  3993 00001414 2D3075                   sub ax, Symbol
  3994 00001417 8946FC                   mov [bp-4], ax
  3995                                  
  3996                                  ;-670     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3997                                  
  3998 0000141A 8B46FC                   mov ax, [bp-4]
  3999 0000141D 83F81F                   cmp ax, 31 ;unsigned : 0
  4000 00001420 0F820900                 jb  .getName173
  4001 00001424 68[6F14]                 push getName_0
  4002 00001427 E8C506                   call errorexit
  4003 0000142A 83C402                   add  sp, 2
  4004                                  
  4005                                  ;-671   }
  4006                                  
  4007                                  .getName173:
  4008                                  
  4009                                  ;-672   if (c == ':') isLabel=1; else isLabel=0;
  4010                                  
  4011 0000142D EBB6                     jmp .getName171
  4012                                  .getName172:
  4013 0000142F 8A4604                   mov al, [bp+4]
  4014 00001432 3C3A                     cmp al, 58
  4015 00001434 0F850900                 jne .getName174
  4016 00001438 B80100                   mov ax, 1
  4017 0000143B A2[2B00]                 mov byte [isLabel], al
  4018 0000143E E90600                   jmp .getName175
  4019                                  .getName174:
  4020 00001441 B80000                   mov ax, 0
  4021 00001444 A2[2B00]                 mov byte [isLabel], al
  4022                                  
  4023                                  ;-673   p--;
  4024                                  
  4025                                  .getName175:
  4026 00001447 FF4EFE                   dec  word[bp-2]
  4027                                  
  4028                                  ;-674   *p = 0;
  4029                                  
  4030 0000144A B80000                   mov ax, 0
  4031 0000144D 8B5EFE                   mov  bx, [bp-2]
  4032 00001450 8807                     mov  [bx], al
  4033                                  
  4034                                  ;-675   strcpy(SymbolUpper, Symbol);
  4035                                  
  4036 00001452 8D063075                 lea  ax, [Symbol]
  4037 00001456 50                       push ax
  4038 00001457 8D064F75                 lea  ax, [SymbolUpper]
  4039 0000145B 50                       push ax
  4040 0000145C E837FE                   call strcpy
  4041 0000145F 83C404                   add  sp, 4
  4042                                  
  4043                                  ;-676   toupper(SymbolUpper);
  4044                                  
  4045 00001462 8D064F75                 lea  ax, [SymbolUpper]
  4046 00001466 50                       push ax
  4047 00001467 E8D3FE                   call toupper
  4048 0000146A 83C402                   add  sp, 2
  4049                                  
  4050                                  ;-677 }
  4051                                  
  4052                                  
  4053                                  ;-678 int testReg() {
  4054 0000146D C9                       LEAVE
  4055 0000146E C3                       ret
  4056 0000146F 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4057 00001478 6F206C6F6E6700     
  4058                                  ENDP
  4059                                  
  4060                                  testReg: PROC
  4061                                  
  4062                                  ;-679 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4063                                  
  4064                                  
  4065                                  ;-680   R2Type=0;
  4066                                  
  4067 0000147F B80000                   mov ax, 0
  4068 00001482 A2[3500]                 mov byte [R2Type], al
  4069                                  
  4070                                  ;-681   if (strlen(Symbol) < 2) return 0;
  4071                                  
  4072 00001485 8D063075                 lea  ax, [Symbol]
  4073 00001489 50                       push ax
  4074 0000148A E8E1FD                   call strlen
  4075 0000148D 83C402                   add  sp, 2
  4076 00001490 3C02                     cmp al, 2
  4077 00001492 0F8D0600                 jge .testReg176
  4078 00001496 B80000                   mov ax, 0
  4079 00001499 E94703                   jmp .retntestReg
  4080                                  
  4081                                  ;-682   if (strlen(Symbol) > 3) return 0;
  4082                                  
  4083                                  .testReg176:
  4084 0000149C 8D063075                 lea  ax, [Symbol]
  4085 000014A0 50                       push ax
  4086 000014A1 E8CAFD                   call strlen
  4087 000014A4 83C402                   add  sp, 2
  4088 000014A7 3C03                     cmp al, 3
  4089 000014A9 0F8E0600                 jle .testReg177
  4090 000014AD B80000                   mov ax, 0
  4091 000014B0 E93003                   jmp .retntestReg
  4092                                  
  4093                                  ;-683   R2Type=BYTE;
  4094                                  
  4095                                  .testReg177:
  4096 000014B3 B80100                   mov ax, 1
  4097 000014B6 A2[3500]                 mov byte [R2Type], al
  4098                                  
  4099                                  ;-684   if (eqstr(SymbolUpper, "AL")) return 0;
  4100                                  
  4101 000014B9 68[E417]                 push testReg_0
  4102 000014BC 8D064F75                 lea  ax, [SymbolUpper]
  4103 000014C0 50                       push ax
  4104 000014C1 E808FE                   call eqstr
  4105 000014C4 83C404                   add  sp, 4
  4106 000014C7 08C0                     or  al, al
  4107 000014C9 0F840600                 je .testReg178
  4108 000014CD B80000                   mov ax, 0
  4109 000014D0 E91003                   jmp .retntestReg
  4110                                  
  4111                                  ;-685   if (eqstr(SymbolUpper, "CL")) return 1;
  4112                                  
  4113                                  .testReg178:
  4114 000014D3 68[E717]                 push testReg_1
  4115 000014D6 8D064F75                 lea  ax, [SymbolUpper]
  4116 000014DA 50                       push ax
  4117 000014DB E8EEFD                   call eqstr
  4118 000014DE 83C404                   add  sp, 4
  4119 000014E1 08C0                     or  al, al
  4120 000014E3 0F840600                 je .testReg179
  4121 000014E7 B80100                   mov ax, 1
  4122 000014EA E9F602                   jmp .retntestReg
  4123                                  
  4124                                  ;-686   if (eqstr(SymbolUpper, "DL")) return 2;
  4125                                  
  4126                                  .testReg179:
  4127 000014ED 68[EA17]                 push testReg_2
  4128 000014F0 8D064F75                 lea  ax, [SymbolUpper]
  4129 000014F4 50                       push ax
  4130 000014F5 E8D4FD                   call eqstr
  4131 000014F8 83C404                   add  sp, 4
  4132 000014FB 08C0                     or  al, al
  4133 000014FD 0F840600                 je .testReg180
  4134 00001501 B80200                   mov ax, 2
  4135 00001504 E9DC02                   jmp .retntestReg
  4136                                  
  4137                                  ;-687   if (eqstr(SymbolUpper, "BL")) return 3;
  4138                                  
  4139                                  .testReg180:
  4140 00001507 68[ED17]                 push testReg_3
  4141 0000150A 8D064F75                 lea  ax, [SymbolUpper]
  4142 0000150E 50                       push ax
  4143 0000150F E8BAFD                   call eqstr
  4144 00001512 83C404                   add  sp, 4
  4145 00001515 08C0                     or  al, al
  4146 00001517 0F840600                 je .testReg181
  4147 0000151B B80300                   mov ax, 3
  4148 0000151E E9C202                   jmp .retntestReg
  4149                                  
  4150                                  ;-688   if (eqstr(SymbolUpper, "AH")) return 4;
  4151                                  
  4152                                  .testReg181:
  4153 00001521 68[F017]                 push testReg_4
  4154 00001524 8D064F75                 lea  ax, [SymbolUpper]
  4155 00001528 50                       push ax
  4156 00001529 E8A0FD                   call eqstr
  4157 0000152C 83C404                   add  sp, 4
  4158 0000152F 08C0                     or  al, al
  4159 00001531 0F840600                 je .testReg182
  4160 00001535 B80400                   mov ax, 4
  4161 00001538 E9A802                   jmp .retntestReg
  4162                                  
  4163                                  ;-689   if (eqstr(SymbolUpper, "CH")) return 5;
  4164                                  
  4165                                  .testReg182:
  4166 0000153B 68[F317]                 push testReg_5
  4167 0000153E 8D064F75                 lea  ax, [SymbolUpper]
  4168 00001542 50                       push ax
  4169 00001543 E886FD                   call eqstr
  4170 00001546 83C404                   add  sp, 4
  4171 00001549 08C0                     or  al, al
  4172 0000154B 0F840600                 je .testReg183
  4173 0000154F B80500                   mov ax, 5
  4174 00001552 E98E02                   jmp .retntestReg
  4175                                  
  4176                                  ;-690   if (eqstr(SymbolUpper, "DH")) return 6;
  4177                                  
  4178                                  .testReg183:
  4179 00001555 68[F617]                 push testReg_6
  4180 00001558 8D064F75                 lea  ax, [SymbolUpper]
  4181 0000155C 50                       push ax
  4182 0000155D E86CFD                   call eqstr
  4183 00001560 83C404                   add  sp, 4
  4184 00001563 08C0                     or  al, al
  4185 00001565 0F840600                 je .testReg184
  4186 00001569 B80600                   mov ax, 6
  4187 0000156C E97402                   jmp .retntestReg
  4188                                  
  4189                                  ;-691   if (eqstr(SymbolUpper, "BH")) return 7;
  4190                                  
  4191                                  .testReg184:
  4192 0000156F 68[F917]                 push testReg_7
  4193 00001572 8D064F75                 lea  ax, [SymbolUpper]
  4194 00001576 50                       push ax
  4195 00001577 E852FD                   call eqstr
  4196 0000157A 83C404                   add  sp, 4
  4197 0000157D 08C0                     or  al, al
  4198 0000157F 0F840600                 je .testReg185
  4199 00001583 B80700                   mov ax, 7
  4200 00001586 E95A02                   jmp .retntestReg
  4201                                  
  4202                                  ;-692   R2Type=WORD;
  4203                                  
  4204                                  .testReg185:
  4205 00001589 B80200                   mov ax, 2
  4206 0000158C A2[3500]                 mov byte [R2Type], al
  4207                                  
  4208                                  ;-693   if (eqstr(SymbolUpper, "AX")) return 0;
  4209                                  
  4210 0000158F 68[FC17]                 push testReg_8
  4211 00001592 8D064F75                 lea  ax, [SymbolUpper]
  4212 00001596 50                       push ax
  4213 00001597 E832FD                   call eqstr
  4214 0000159A 83C404                   add  sp, 4
  4215 0000159D 08C0                     or  al, al
  4216 0000159F 0F840600                 je .testReg186
  4217 000015A3 B80000                   mov ax, 0
  4218 000015A6 E93A02                   jmp .retntestReg
  4219                                  
  4220                                  ;-694   if (eqstr(SymbolUpper, "CX")) return 1;
  4221                                  
  4222                                  .testReg186:
  4223 000015A9 68[FF17]                 push testReg_9
  4224 000015AC 8D064F75                 lea  ax, [SymbolUpper]
  4225 000015B0 50                       push ax
  4226 000015B1 E818FD                   call eqstr
  4227 000015B4 83C404                   add  sp, 4
  4228 000015B7 08C0                     or  al, al
  4229 000015B9 0F840600                 je .testReg187
  4230 000015BD B80100                   mov ax, 1
  4231 000015C0 E92002                   jmp .retntestReg
  4232                                  
  4233                                  ;-695   if (eqstr(SymbolUpper, "DX")) return 2;
  4234                                  
  4235                                  .testReg187:
  4236 000015C3 68[0218]                 push testReg_10
  4237 000015C6 8D064F75                 lea  ax, [SymbolUpper]
  4238 000015CA 50                       push ax
  4239 000015CB E8FEFC                   call eqstr
  4240 000015CE 83C404                   add  sp, 4
  4241 000015D1 08C0                     or  al, al
  4242 000015D3 0F840600                 je .testReg188
  4243 000015D7 B80200                   mov ax, 2
  4244 000015DA E90602                   jmp .retntestReg
  4245                                  
  4246                                  ;-696   if (eqstr(SymbolUpper, "BX")) return 3;
  4247                                  
  4248                                  .testReg188:
  4249 000015DD 68[0518]                 push testReg_11
  4250 000015E0 8D064F75                 lea  ax, [SymbolUpper]
  4251 000015E4 50                       push ax
  4252 000015E5 E8E4FC                   call eqstr
  4253 000015E8 83C404                   add  sp, 4
  4254 000015EB 08C0                     or  al, al
  4255 000015ED 0F840600                 je .testReg189
  4256 000015F1 B80300                   mov ax, 3
  4257 000015F4 E9EC01                   jmp .retntestReg
  4258                                  
  4259                                  ;-697   if (eqstr(SymbolUpper, "SP")) return 4;
  4260                                  
  4261                                  .testReg189:
  4262 000015F7 68[0818]                 push testReg_12
  4263 000015FA 8D064F75                 lea  ax, [SymbolUpper]
  4264 000015FE 50                       push ax
  4265 000015FF E8CAFC                   call eqstr
  4266 00001602 83C404                   add  sp, 4
  4267 00001605 08C0                     or  al, al
  4268 00001607 0F840600                 je .testReg190
  4269 0000160B B80400                   mov ax, 4
  4270 0000160E E9D201                   jmp .retntestReg
  4271                                  
  4272                                  ;-698   if (eqstr(SymbolUpper, "BP")) return 5;
  4273                                  
  4274                                  .testReg190:
  4275 00001611 68[0B18]                 push testReg_13
  4276 00001614 8D064F75                 lea  ax, [SymbolUpper]
  4277 00001618 50                       push ax
  4278 00001619 E8B0FC                   call eqstr
  4279 0000161C 83C404                   add  sp, 4
  4280 0000161F 08C0                     or  al, al
  4281 00001621 0F840600                 je .testReg191
  4282 00001625 B80500                   mov ax, 5
  4283 00001628 E9B801                   jmp .retntestReg
  4284                                  
  4285                                  ;-699   if (eqstr(SymbolUpper, "SI")) return 6;
  4286                                  
  4287                                  .testReg191:
  4288 0000162B 68[0E18]                 push testReg_14
  4289 0000162E 8D064F75                 lea  ax, [SymbolUpper]
  4290 00001632 50                       push ax
  4291 00001633 E896FC                   call eqstr
  4292 00001636 83C404                   add  sp, 4
  4293 00001639 08C0                     or  al, al
  4294 0000163B 0F840600                 je .testReg192
  4295 0000163F B80600                   mov ax, 6
  4296 00001642 E99E01                   jmp .retntestReg
  4297                                  
  4298                                  ;-700   if (eqstr(SymbolUpper, "DI")) return 7;
  4299                                  
  4300                                  .testReg192:
  4301 00001645 68[1118]                 push testReg_15
  4302 00001648 8D064F75                 lea  ax, [SymbolUpper]
  4303 0000164C 50                       push ax
  4304 0000164D E87CFC                   call eqstr
  4305 00001650 83C404                   add  sp, 4
  4306 00001653 08C0                     or  al, al
  4307 00001655 0F840600                 je .testReg193
  4308 00001659 B80700                   mov ax, 7
  4309 0000165C E98401                   jmp .retntestReg
  4310                                  
  4311                                  ;-701   R2Type=SEGREG;
  4312                                  
  4313                                  .testReg193:
  4314 0000165F B80400                   mov ax, 4
  4315 00001662 A2[3500]                 mov byte [R2Type], al
  4316                                  
  4317                                  ;-702   if (eqstr(SymbolUpper, "ES")) return 0;
  4318                                  
  4319 00001665 68[1418]                 push testReg_16
  4320 00001668 8D064F75                 lea  ax, [SymbolUpper]
  4321 0000166C 50                       push ax
  4322 0000166D E85CFC                   call eqstr
  4323 00001670 83C404                   add  sp, 4
  4324 00001673 08C0                     or  al, al
  4325 00001675 0F840600                 je .testReg194
  4326 00001679 B80000                   mov ax, 0
  4327 0000167C E96401                   jmp .retntestReg
  4328                                  
  4329                                  ;-703   if (eqstr(SymbolUpper, "CS")) return 1;
  4330                                  
  4331                                  .testReg194:
  4332 0000167F 68[1718]                 push testReg_17
  4333 00001682 8D064F75                 lea  ax, [SymbolUpper]
  4334 00001686 50                       push ax
  4335 00001687 E842FC                   call eqstr
  4336 0000168A 83C404                   add  sp, 4
  4337 0000168D 08C0                     or  al, al
  4338 0000168F 0F840600                 je .testReg195
  4339 00001693 B80100                   mov ax, 1
  4340 00001696 E94A01                   jmp .retntestReg
  4341                                  
  4342                                  ;-704   if (eqstr(SymbolUpper, "SS")) return 2;
  4343                                  
  4344                                  .testReg195:
  4345 00001699 68[1A18]                 push testReg_18
  4346 0000169C 8D064F75                 lea  ax, [SymbolUpper]
  4347 000016A0 50                       push ax
  4348 000016A1 E828FC                   call eqstr
  4349 000016A4 83C404                   add  sp, 4
  4350 000016A7 08C0                     or  al, al
  4351 000016A9 0F840600                 je .testReg196
  4352 000016AD B80200                   mov ax, 2
  4353 000016B0 E93001                   jmp .retntestReg
  4354                                  
  4355                                  ;-705   if (eqstr(SymbolUpper, "DS")) return 3;
  4356                                  
  4357                                  .testReg196:
  4358 000016B3 68[1D18]                 push testReg_19
  4359 000016B6 8D064F75                 lea  ax, [SymbolUpper]
  4360 000016BA 50                       push ax
  4361 000016BB E80EFC                   call eqstr
  4362 000016BE 83C404                   add  sp, 4
  4363 000016C1 08C0                     or  al, al
  4364 000016C3 0F840600                 je .testReg197
  4365 000016C7 B80300                   mov ax, 3
  4366 000016CA E91601                   jmp .retntestReg
  4367                                  
  4368                                  ;-706   if (eqstr(SymbolUpper, "FS")) return 4;
  4369                                  
  4370                                  .testReg197:
  4371 000016CD 68[2018]                 push testReg_20
  4372 000016D0 8D064F75                 lea  ax, [SymbolUpper]
  4373 000016D4 50                       push ax
  4374 000016D5 E8F4FB                   call eqstr
  4375 000016D8 83C404                   add  sp, 4
  4376 000016DB 08C0                     or  al, al
  4377 000016DD 0F840600                 je .testReg198
  4378 000016E1 B80400                   mov ax, 4
  4379 000016E4 E9FC00                   jmp .retntestReg
  4380                                  
  4381                                  ;-707   if (eqstr(SymbolUpper, "GS")) return 5;
  4382                                  
  4383                                  .testReg198:
  4384 000016E7 68[2318]                 push testReg_21
  4385 000016EA 8D064F75                 lea  ax, [SymbolUpper]
  4386 000016EE 50                       push ax
  4387 000016EF E8DAFB                   call eqstr
  4388 000016F2 83C404                   add  sp, 4
  4389 000016F5 08C0                     or  al, al
  4390 000016F7 0F840600                 je .testReg199
  4391 000016FB B80500                   mov ax, 5
  4392 000016FE E9E200                   jmp .retntestReg
  4393                                  
  4394                                  ;-708   R2Type=DWORD;
  4395                                  
  4396                                  .testReg199:
  4397 00001701 B80300                   mov ax, 3
  4398 00001704 A2[3500]                 mov byte [R2Type], al
  4399                                  
  4400                                  ;-709   if (eqstr(SymbolUpper, "EAX"))return 0;
  4401                                  
  4402 00001707 68[2618]                 push testReg_22
  4403 0000170A 8D064F75                 lea  ax, [SymbolUpper]
  4404 0000170E 50                       push ax
  4405 0000170F E8BAFB                   call eqstr
  4406 00001712 83C404                   add  sp, 4
  4407 00001715 08C0                     or  al, al
  4408 00001717 0F840600                 je .testReg200
  4409 0000171B B80000                   mov ax, 0
  4410 0000171E E9C200                   jmp .retntestReg
  4411                                  
  4412                                  ;-710   if (eqstr(SymbolUpper, "ECX"))return 1;
  4413                                  
  4414                                  .testReg200:
  4415 00001721 68[2A18]                 push testReg_23
  4416 00001724 8D064F75                 lea  ax, [SymbolUpper]
  4417 00001728 50                       push ax
  4418 00001729 E8A0FB                   call eqstr
  4419 0000172C 83C404                   add  sp, 4
  4420 0000172F 08C0                     or  al, al
  4421 00001731 0F840600                 je .testReg201
  4422 00001735 B80100                   mov ax, 1
  4423 00001738 E9A800                   jmp .retntestReg
  4424                                  
  4425                                  ;-711   if (eqstr(SymbolUpper, "EDX"))return 2;
  4426                                  
  4427                                  .testReg201:
  4428 0000173B 68[2E18]                 push testReg_24
  4429 0000173E 8D064F75                 lea  ax, [SymbolUpper]
  4430 00001742 50                       push ax
  4431 00001743 E886FB                   call eqstr
  4432 00001746 83C404                   add  sp, 4
  4433 00001749 08C0                     or  al, al
  4434 0000174B 0F840600                 je .testReg202
  4435 0000174F B80200                   mov ax, 2
  4436 00001752 E98E00                   jmp .retntestReg
  4437                                  
  4438                                  ;-712   if (eqstr(SymbolUpper, "EBX"))return 3;
  4439                                  
  4440                                  .testReg202:
  4441 00001755 68[3218]                 push testReg_25
  4442 00001758 8D064F75                 lea  ax, [SymbolUpper]
  4443 0000175C 50                       push ax
  4444 0000175D E86CFB                   call eqstr
  4445 00001760 83C404                   add  sp, 4
  4446 00001763 08C0                     or  al, al
  4447 00001765 0F840600                 je .testReg203
  4448 00001769 B80300                   mov ax, 3
  4449 0000176C E97400                   jmp .retntestReg
  4450                                  
  4451                                  ;-713   if (eqstr(SymbolUpper, "ESP"))return 4;
  4452                                  
  4453                                  .testReg203:
  4454 0000176F 68[3618]                 push testReg_26
  4455 00001772 8D064F75                 lea  ax, [SymbolUpper]
  4456 00001776 50                       push ax
  4457 00001777 E852FB                   call eqstr
  4458 0000177A 83C404                   add  sp, 4
  4459 0000177D 08C0                     or  al, al
  4460 0000177F 0F840600                 je .testReg204
  4461 00001783 B80400                   mov ax, 4
  4462 00001786 E95A00                   jmp .retntestReg
  4463                                  
  4464                                  ;-714   if (eqstr(SymbolUpper, "EBP"))return 5;
  4465                                  
  4466                                  .testReg204:
  4467 00001789 68[3A18]                 push testReg_27
  4468 0000178C 8D064F75                 lea  ax, [SymbolUpper]
  4469 00001790 50                       push ax
  4470 00001791 E838FB                   call eqstr
  4471 00001794 83C404                   add  sp, 4
  4472 00001797 08C0                     or  al, al
  4473 00001799 0F840600                 je .testReg205
  4474 0000179D B80500                   mov ax, 5
  4475 000017A0 E94000                   jmp .retntestReg
  4476                                  
  4477                                  ;-715   if (eqstr(SymbolUpper, "ESI"))return 6;
  4478                                  
  4479                                  .testReg205:
  4480 000017A3 68[3E18]                 push testReg_28
  4481 000017A6 8D064F75                 lea  ax, [SymbolUpper]
  4482 000017AA 50                       push ax
  4483 000017AB E81EFB                   call eqstr
  4484 000017AE 83C404                   add  sp, 4
  4485 000017B1 08C0                     or  al, al
  4486 000017B3 0F840600                 je .testReg206
  4487 000017B7 B80600                   mov ax, 6
  4488 000017BA E92600                   jmp .retntestReg
  4489                                  
  4490                                  ;-716   if (eqstr(SymbolUpper, "EDI"))return 7;
  4491                                  
  4492                                  .testReg206:
  4493 000017BD 68[4218]                 push testReg_29
  4494 000017C0 8D064F75                 lea  ax, [SymbolUpper]
  4495 000017C4 50                       push ax
  4496 000017C5 E804FB                   call eqstr
  4497 000017C8 83C404                   add  sp, 4
  4498 000017CB 08C0                     or  al, al
  4499 000017CD 0F840600                 je .testReg207
  4500 000017D1 B80700                   mov ax, 7
  4501 000017D4 E90C00                   jmp .retntestReg
  4502                                  
  4503                                  ;-717   R2Type=0; return 0;
  4504                                  
  4505                                  .testReg207:
  4506 000017D7 B80000                   mov ax, 0
  4507 000017DA A2[3500]                 mov byte [R2Type], al
  4508 000017DD B80000                   mov ax, 0
  4509 000017E0 E90000                   jmp .retntestReg
  4510                                  
  4511                                  ;-718 }
  4512                                  
  4513                                  
  4514                                  ;-719 
  4515                                  
  4516                                  
  4517                                  ;-720 
  4518                                  
  4519                                  
  4520                                  ;-721 //#include "OUTPUT.C"
  4521                                  
  4522                                  
  4523                                  ;-722 int printLine() {
  4524                                  
  4525                                   .retntestReg:
  4526 000017E3 C3                       ret
  4527 000017E4 414C00                  testReg_0 db "AL",0
  4528 000017E7 434C00                  testReg_1 db "CL",0
  4529 000017EA 444C00                  testReg_2 db "DL",0
  4530 000017ED 424C00                  testReg_3 db "BL",0
  4531 000017F0 414800                  testReg_4 db "AH",0
  4532 000017F3 434800                  testReg_5 db "CH",0
  4533 000017F6 444800                  testReg_6 db "DH",0
  4534 000017F9 424800                  testReg_7 db "BH",0
  4535 000017FC 415800                  testReg_8 db "AX",0
  4536 000017FF 435800                  testReg_9 db "CX",0
  4537 00001802 445800                  testReg_10 db "DX",0
  4538 00001805 425800                  testReg_11 db "BX",0
  4539 00001808 535000                  testReg_12 db "SP",0
  4540 0000180B 425000                  testReg_13 db "BP",0
  4541 0000180E 534900                  testReg_14 db "SI",0
  4542 00001811 444900                  testReg_15 db "DI",0
  4543 00001814 455300                  testReg_16 db "ES",0
  4544 00001817 435300                  testReg_17 db "CS",0
  4545 0000181A 535300                  testReg_18 db "SS",0
  4546 0000181D 445300                  testReg_19 db "DS",0
  4547 00001820 465300                  testReg_20 db "FS",0
  4548 00001823 475300                  testReg_21 db "GS",0
  4549 00001826 45415800                testReg_22 db "EAX",0
  4550 0000182A 45435800                testReg_23 db "ECX",0
  4551 0000182E 45445800                testReg_24 db "EDX",0
  4552 00001832 45425800                testReg_25 db "EBX",0
  4553 00001836 45535000                testReg_26 db "ESP",0
  4554 0000183A 45425000                testReg_27 db "EBP",0
  4555 0000183E 45534900                testReg_28 db "ESI",0
  4556 00001842 45444900                testReg_29 db "EDI",0
  4557                                  ENDP
  4558                                  
  4559                                  printLine: PROC
  4560                                  
  4561                                  ;-723     int i; char c;
  4562                                  
  4563                                  
  4564                                  ;-724     prs("\n");
  4565                                  
  4566                                  ;Function : printLine, Number of local variables: 2
  4567                                  ;   # type sign width addr used name   list of local variables
  4568                                  ;  200 var sign word   723 NULL i = bp-2
  4569                                  ;  201 var sign byte   723 NULL c = bp-4;
  4570 00001846 C8040000                 ENTER  4,0
  4571 0000184A 68[D818]                 push printLine_0
  4572 0000184D E8F700                   call prs
  4573 00001850 83C402                   add  sp, 2
  4574                                  
  4575                                  ;-725     printhex16(PCStart);
  4576                                  
  4577 00001853 FF36[2900]               push word [PCStart]
  4578 00001857 E8D301                   call printhex16
  4579 0000185A 83C402                   add  sp, 2
  4580                                  
  4581                                  ;-726     if (OpPrintIndex == 0) prs("               ");
  4582                                  
  4583 0000185D A1[4100]                 mov ax, [OpPrintIndex]
  4584 00001860 83F800                   cmp ax, 0
  4585 00001863 0F850C00                 jne .printLine208
  4586 00001867 68[DB18]                 push printLine_1
  4587 0000186A E8DA00                   call prs
  4588 0000186D 83C402                   add  sp, 2
  4589                                  
  4590                                  ;-727     else {
  4591                                  
  4592 00001870 E94C00                   jmp .printLine209
  4593                                  .printLine208:
  4594                                  
  4595                                  ;-728 //        prc(' ');
  4596                                  
  4597                                  
  4598                                  ;-729         i=0;
  4599                                  
  4600 00001873 B80000                   mov ax, 0
  4601 00001876 8946FE                   mov [bp-2], ax
  4602                                  
  4603                                  ;-730         do {
  4604                                  
  4605                                  .printLine210:
  4606                                  
  4607                                  ;-731             c=OpPos[i];
  4608                                  
  4609 00001879 8B5EFE                   mov bx, [bp-2]
  4610 0000187C 8A875577                 mov al, [OpPos + bx]
  4611 00001880 8846FC                   mov [bp-4], al
  4612                                  
  4613                                  ;-732             prc(' ');
  4614                                  
  4615 00001883 6A20                     push 32
  4616 00001885 E86700                   call prc
  4617 00001888 83C402                   add  sp, 2
  4618                                  
  4619                                  ;-733             printhex8a(c);
  4620                                  
  4621 0000188B 8A46FC                   mov al, byte [bp-4]
  4622 0000188E B400                     mov ah, 0
  4623 00001890 50                       push ax
  4624 00001891 E84701                   call printhex8a
  4625 00001894 83C402                   add  sp, 2
  4626                                  
  4627                                  ;-734             i++;
  4628                                  
  4629 00001897 FF46FE                   inc  word[bp-2]
  4630                                  
  4631                                  ;-735         } while (i < OpPrintIndex);
  4632                                  
  4633 0000189A 8B46FE                   mov ax, [bp-2]
  4634 0000189D 3B06[4100]               cmp ax, [OpPrintIndex]
  4635 000018A1 0F8D0200                 jge .printLine211
  4636 000018A5 EBD2                     jmp .printLine210
  4637                                  .printLine211:
  4638                                  
  4639                                  ;-736         while (i < OPMAXLEN) {// fill rest with blank
  4640                                  
  4641                                  .printLine212:
  4642 000018A7 8B46FE                   mov ax, [bp-2]
  4643 000018AA 83F805                   cmp ax, 5
  4644 000018AD 0F8D0E00                 jge .printLine213
  4645                                  
  4646                                  ;-737             prs("   ");
  4647                                  
  4648 000018B1 68[EB18]                 push printLine_2
  4649 000018B4 E89000                   call prs
  4650 000018B7 83C402                   add  sp, 2
  4651                                  
  4652                                  ;-738             i++;
  4653                                  
  4654 000018BA FF46FE                   inc  word[bp-2]
  4655                                  
  4656                                  ;-739         }
  4657                                  
  4658                                  
  4659                                  ;-740     }
  4660                                  
  4661 000018BD EBE8                     jmp .printLine212
  4662                                  .printLine213:
  4663                                  
  4664                                  ;-741     prc(PrintRA);
  4665                                  
  4666                                  .printLine209:
  4667 000018BF A0[4500]                 mov al, byte [PrintRA]
  4668 000018C2 B400                     mov ah, 0
  4669 000018C4 50                       push ax
  4670 000018C5 E82700                   call prc
  4671 000018C8 83C402                   add  sp, 2
  4672                                  
  4673                                  ;-742     prscomment(InputBuf);
  4674                                  
  4675 000018CB 8D068D75                 lea  ax, [InputBuf]
  4676 000018CF 50                       push ax
  4677 000018D0 E84600                   call prscomment
  4678 000018D3 83C402                   add  sp, 2
  4679                                  
  4680                                  ;-743 }
  4681                                  
  4682                                  
  4683                                  ;-744 int prc(unsigned char c) {//print char
  4684 000018D6 C9                       LEAVE
  4685 000018D7 C3                       ret
  4686 000018D8 5C6E00                  printLine_0 db "\n",0
  4687 000018DB 202020202020202020-     printLine_1 db "               ",0
  4688 000018E4 20202020202000     
  4689 000018EB 20202000                printLine_2 db "   ",0
  4690                                  ENDP
  4691                                  
  4692                                  prc: PROC
  4693                                  
  4694                                  ;-745         if ( _ c==10) {
  4695                                  
  4696                                  ;Function : prc, Number of local variables: 1
  4697                                  ;   # type sign width addr used name   list of local variables
  4698                                  ;  200 var unsg byte   744 NULL c = bp+4;
  4699 000018EF C8000000                 ENTER  0,0 ; constant expression
  4700 000018F3 807E040A                cmp byte[bp+4], 10
  4701 000018F7 0F850600                 jne .prc214
  4702                                  
  4703                                  ;-746             ax=13;
  4704                                  
  4705 000018FB B80D00                   mov  ax, 13
  4706                                  
  4707                                  ;-747             writetty();
  4708                                  
  4709 000018FE E87DF6                   call writetty
  4710                                  
  4711                                  ;-748             }
  4712                                  
  4713                                  
  4714                                  ;-749         al=c;
  4715                                  
  4716                                  .prc214:
  4717 00001901 8A4604                   mov  al, [bp+4]
  4718                                  
  4719                                  ;-750         writetty();
  4720                                  
  4721 00001904 E877F6                   call writetty
  4722                                  
  4723                                  ;-751     fputcR(c,lst_fd);
  4724                                  
  4725 00001907 FF36[1800]               push word [lst_fd]
  4726 0000190B 8A4604                   mov al, byte [bp+4]
  4727 0000190E B400                     mov ah, 0
  4728 00001910 50                       push ax
  4729 00001911 E815F7                   call fputcR
  4730 00001914 83C404                   add  sp, 4
  4731                                  
  4732                                  ;-752 }
  4733                                  
  4734                                  
  4735                                  ;-753 
  4736                                  
  4737                                  
  4738                                  ;-754 int prscomment(unsigned char *s) {
  4739 00001917 C9                       LEAVE
  4740 00001918 C3                       ret
  4741                                  ENDP
  4742                                  
  4743                                  prscomment: PROC
  4744                                  
  4745                                  ;-755     unsigned char c;
  4746                                  
  4747                                  
  4748                                  ;-756     while (*s){
  4749                                  
  4750                                  ;Function : prscomment, Number of local variables: 2
  4751                                  ;   # type sign width addr used name   list of local variables
  4752                                  ;  200 ptr unsg byte   754 NULL s = bp+4
  4753                                  ;  201 var unsg byte   755 NULL c = bp-2;
  4754 00001919 C8020000                 ENTER  2,0
  4755                                  .prscomment215:
  4756 0000191D 8B5E04                   mov bx, [bp+4]
  4757 00001920 8A07                     mov al, [bx]
  4758 00001922 B400                     mov ah, 0
  4759 00001924 08C0                     or  al, al
  4760 00001926 0F841B00                 je .prscomment216
  4761                                  
  4762                                  ;-757         c=*s;
  4763                                  
  4764 0000192A 8B5E04                   mov bx, [bp+4]
  4765 0000192D 8A07                     mov al, [bx]
  4766 0000192F B400                     mov ah, 0
  4767 00001931 8846FE                   mov [bp-2], al
  4768                                  
  4769                                  ;-758         prc(c);
  4770                                  
  4771 00001934 8A46FE                   mov al, byte [bp-2]
  4772 00001937 B400                     mov ah, 0
  4773 00001939 50                       push ax
  4774 0000193A E8B2FF                   call prc
  4775 0000193D 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-759         s++;
  4778                                  
  4779 00001940 FF4604                   inc  word[bp+4]
  4780                                  
  4781                                  ;-760     }
  4782                                  
  4783                                  
  4784                                  ;-761 }
  4785                                  
  4786 00001943 EBD8                     jmp .prscomment215
  4787                                  .prscomment216:
  4788                                  
  4789                                  ;-762 int prs(unsigned char *s) {
  4790 00001945 C9                       LEAVE
  4791 00001946 C3                       ret
  4792                                  ENDP
  4793                                  
  4794                                  prs: PROC
  4795                                  
  4796                                  ;-763     unsigned char c;
  4797                                  
  4798                                  
  4799                                  ;-764     int com;
  4800                                  
  4801                                  
  4802                                  ;-765     com=0;
  4803                                  
  4804                                  ;Function : prs, Number of local variables: 3
  4805                                  ;   # type sign width addr used name   list of local variables
  4806                                  ;  200 ptr unsg byte   762 NULL s = bp+4
  4807                                  ;  201 var unsg byte   763 NULL c = bp-2
  4808                                  ;  202 var sign word   764 NULL com = bp-4;
  4809 00001947 C8040000                 ENTER  4,0
  4810 0000194B B80000                   mov ax, 0
  4811 0000194E 8946FC                   mov [bp-4], ax
  4812                                  
  4813                                  ;-766     while (*s) {
  4814                                  
  4815                                  .prs217:
  4816 00001951 8B5E04                   mov bx, [bp+4]
  4817 00001954 8A07                     mov al, [bx]
  4818 00001956 B400                     mov ah, 0
  4819 00001958 08C0                     or  al, al
  4820 0000195A 0F847B00                 je .prs218
  4821                                  
  4822                                  ;-767         c=*s;
  4823                                  
  4824 0000195E 8B5E04                   mov bx, [bp+4]
  4825 00001961 8A07                     mov al, [bx]
  4826 00001963 B400                     mov ah, 0
  4827 00001965 8846FE                   mov [bp-2], al
  4828                                  
  4829                                  ;-768         if (c==34) {
  4830                                  
  4831 00001968 8A46FE                   mov al, [bp-2]
  4832 0000196B 3C22                     cmp al, 34
  4833 0000196D 0F851800                 jne .prs219
  4834                                  
  4835                                  ;-769             if (com) com=0;
  4836                                  
  4837 00001971 8B46FC                   mov ax, [bp-4]
  4838 00001974 08C0                     or  al, al
  4839 00001976 0F840900                 je .prs220
  4840 0000197A B80000                   mov ax, 0
  4841 0000197D 8946FC                   mov [bp-4], ax
  4842                                  
  4843                                  ;-770                 else com=1;
  4844                                  
  4845 00001980 E90600                   jmp .prs221
  4846                                  .prs220:
  4847 00001983 B80100                   mov ax, 1
  4848 00001986 8946FC                   mov [bp-4], ax
  4849                                  
  4850                                  ;-771         }
  4851                                  
  4852                                  .prs221:
  4853                                  
  4854                                  ;-772         if (c==92) {
  4855                                  
  4856                                  .prs219:
  4857 00001989 8A46FE                   mov al, [bp-2]
  4858 0000198C 3C5C                     cmp al, 92
  4859 0000198E 0F853500                 jne .prs222
  4860                                  
  4861                                  ;-773             if (com==0) {
  4862                                  
  4863 00001992 8B46FC                   mov ax, [bp-4]
  4864 00001995 83F800                   cmp ax, 0
  4865 00001998 0F852B00                 jne .prs223
  4866                                  
  4867                                  ;-774                 s++;
  4868                                  
  4869 0000199C FF4604                   inc  word[bp+4]
  4870                                  
  4871                                  ;-775                 c=*s;
  4872                                  
  4873 0000199F 8B5E04                   mov bx, [bp+4]
  4874 000019A2 8A07                     mov al, [bx]
  4875 000019A4 B400                     mov ah, 0
  4876 000019A6 8846FE                   mov [bp-2], al
  4877                                  
  4878                                  ;-776                 if (c=='n') c=10;
  4879                                  
  4880 000019A9 8A46FE                   mov al, [bp-2]
  4881 000019AC 3C6E                     cmp al, 110
  4882 000019AE 0F850600                 jne .prs224
  4883 000019B2 B80A00                   mov ax, 10
  4884 000019B5 8846FE                   mov [bp-2], al
  4885                                  
  4886                                  ;-777                 if (c=='t') c= 9;
  4887                                  
  4888                                  .prs224:
  4889 000019B8 8A46FE                   mov al, [bp-2]
  4890 000019BB 3C74                     cmp al, 116
  4891 000019BD 0F850600                 jne .prs225
  4892 000019C1 B80900                   mov ax, 9
  4893 000019C4 8846FE                   mov [bp-2], al
  4894                                  
  4895                                  ;-778             }
  4896                                  
  4897                                  .prs225:
  4898                                  
  4899                                  ;-779         }
  4900                                  
  4901                                  .prs223:
  4902                                  
  4903                                  ;-780         prc(c);
  4904                                  
  4905                                  .prs222:
  4906 000019C7 8A46FE                   mov al, byte [bp-2]
  4907 000019CA B400                     mov ah, 0
  4908 000019CC 50                       push ax
  4909 000019CD E81FFF                   call prc
  4910 000019D0 83C402                   add  sp, 2
  4911                                  
  4912                                  ;-781         s++;
  4913                                  
  4914 000019D3 FF4604                   inc  word[bp+4]
  4915                                  
  4916                                  ;-782     }
  4917                                  
  4918                                  
  4919                                  ;-783 }
  4920                                  
  4921 000019D6 E978FF                   jmp .prs217
  4922                                  .prs218:
  4923                                  
  4924                                  ;-784 int printhex8a(unsigned char c) {
  4925 000019D9 C9                       LEAVE
  4926 000019DA C3                       ret
  4927                                  ENDP
  4928                                  
  4929                                  printhex8a: PROC
  4930                                  
  4931                                  ;-785     unsigned char nib;
  4932                                  
  4933                                  
  4934                                  ;-786     nib = c >> 4; printhex4(nib);
  4935                                  
  4936                                  ;Function : printhex8a, Number of local variables: 2
  4937                                  ;   # type sign width addr used name   list of local variables
  4938                                  ;  200 var unsg byte   784 NULL c = bp+4
  4939                                  ;  201 var unsg byte   785 NULL nib = bp-2;
  4940 000019DB C8020000                 ENTER  2,0
  4941 000019DF 8A4604                   mov al, [bp+4]
  4942 000019E2 C0E804                   shr al, 4
  4943 000019E5 8846FE                   mov [bp-2], al
  4944 000019E8 8A46FE                   mov al, byte [bp-2]
  4945 000019EB B400                     mov ah, 0
  4946 000019ED 50                       push ax
  4947 000019EE E81900                   call printhex4
  4948 000019F1 83C402                   add  sp, 2
  4949                                  
  4950                                  ;-787     nib = c & 15; printhex4(nib);
  4951                                  
  4952 000019F4 8A4604                   mov al, [bp+4]
  4953 000019F7 240F                     and al, 15
  4954 000019F9 8846FE                   mov [bp-2], al
  4955 000019FC 8A46FE                   mov al, byte [bp-2]
  4956 000019FF B400                     mov ah, 0
  4957 00001A01 50                       push ax
  4958 00001A02 E80500                   call printhex4
  4959 00001A05 83C402                   add  sp, 2
  4960                                  
  4961                                  ;-788 }
  4962                                  
  4963                                  
  4964                                  ;-789 int printhex4(unsigned char c) {
  4965 00001A08 C9                       LEAVE
  4966 00001A09 C3                       ret
  4967                                  ENDP
  4968                                  
  4969                                  printhex4: PROC
  4970                                  
  4971                                  ;-790     c += 48;
  4972                                  
  4973                                  ;Function : printhex4, Number of local variables: 1
  4974                                  ;   # type sign width addr used name   list of local variables
  4975                                  ;  200 var unsg byte   789 NULL c = bp+4;
  4976 00001A0A C8000000                 ENTER  0,0
  4977 00001A0E 80460430                 add  byte[bp+4], 48
  4978                                  
  4979                                  ;-791     if (c > 57) c += 7;
  4980                                  
  4981 00001A12 8A4604                   mov al, [bp+4]
  4982 00001A15 3C39                     cmp al, 57
  4983 00001A17 0F8E0400                 jle .printhex4226
  4984 00001A1B 80460407                 add  byte[bp+4], 7
  4985                                  
  4986                                  ;-792     prc(c);
  4987                                  
  4988                                  .printhex4226:
  4989 00001A1F 8A4604                   mov al, byte [bp+4]
  4990 00001A22 B400                     mov ah, 0
  4991 00001A24 50                       push ax
  4992 00001A25 E8C7FE                   call prc
  4993 00001A28 83C402                   add  sp, 2
  4994                                  
  4995                                  ;-793 }
  4996                                  
  4997                                  
  4998                                  ;-794 int printhex16(unsigned int i) {
  4999 00001A2B C9                       LEAVE
  5000 00001A2C C3                       ret
  5001                                  ENDP
  5002                                  
  5003                                  printhex16: PROC
  5004                                  
  5005                                  ;-795     unsigned int half;
  5006                                  
  5007                                  
  5008                                  ;-796     half = i >>  8; printhex8a(half);
  5009                                  
  5010                                  ;Function : printhex16, Number of local variables: 2
  5011                                  ;   # type sign width addr used name   list of local variables
  5012                                  ;  200 var unsg word   794 NULL i = bp+4
  5013                                  ;  201 var unsg word   795 NULL half = bp-2;
  5014 00001A2D C8020000                 ENTER  2,0
  5015 00001A31 8B4604                   mov ax, [bp+4]
  5016 00001A34 C1E808                   shr ax, 8
  5017 00001A37 8946FE                   mov [bp-2], ax
  5018 00001A3A FF76FE                   push word [bp-2]
  5019 00001A3D E89BFF                   call printhex8a
  5020 00001A40 83C402                   add  sp, 2
  5021                                  
  5022                                  ;-797     half = i & 255; printhex8a(half);
  5023                                  
  5024 00001A43 8B4604                   mov ax, [bp+4]
  5025 00001A46 25FF00                   and ax, 255
  5026 00001A49 8946FE                   mov [bp-2], ax
  5027 00001A4C FF76FE                   push word [bp-2]
  5028 00001A4F E889FF                   call printhex8a
  5029 00001A52 83C402                   add  sp, 2
  5030                                  
  5031                                  ;-798 }
  5032                                  
  5033                                  
  5034                                  ;-799 int printIntU(unsigned int n) {
  5035 00001A55 C9                       LEAVE
  5036 00001A56 C3                       ret
  5037                                  ENDP
  5038                                  
  5039                                  printIntU: PROC
  5040                                  
  5041                                  ;-800     unsigned int e;
  5042                                  
  5043                                  
  5044                                  ;-801     if ( _ n >= 10) {
  5045                                  
  5046                                  ;Function : printIntU, Number of local variables: 2
  5047                                  ;   # type sign width addr used name   list of local variables
  5048                                  ;  200 var unsg word   799 NULL n = bp+4
  5049                                  ;  201 var unsg word   800 NULL e = bp-2;
  5050 00001A57 C8020000                 ENTER  2,0 ; constant expression
  5051 00001A5B 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5052 00001A5F 0F821700                 jb  .printIntU227
  5053                                  
  5054                                  ;-802         e=n/10; //DIV
  5055                                  
  5056 00001A63 8B4604                   mov ax, [bp+4]
  5057 00001A66 BB0A00                   mov bx, 10
  5058 00001A69 BA0000                   mov dx, 0
  5059 00001A6C F7F3                     div bx
  5060 00001A6E 8946FE                   mov [bp-2], ax
  5061                                  
  5062                                  ;-803         printIntU(e);
  5063                                  
  5064 00001A71 FF76FE                   push word [bp-2]
  5065 00001A74 E8E0FF                   call printIntU
  5066 00001A77 83C402                   add  sp, 2
  5067                                  
  5068                                  ;-804     }
  5069                                  
  5070                                  
  5071                                  ;-805     n = n % 10; //unsigned mod
  5072                                  
  5073                                  .printIntU227:
  5074 00001A7A 8B4604                   mov ax, [bp+4]
  5075 00001A7D BB0A00                   mov bx, 10
  5076 00001A80 BA0000                   mov dx, 0
  5077 00001A83 F7F3                     div bx
  5078 00001A85 89D0                     mov ax, dx
  5079 00001A87 894604                   mov [bp+4], ax
  5080                                  
  5081                                  ;-806     n += '0';
  5082                                  
  5083 00001A8A 83460430                 add  word[bp+4], 48
  5084                                  
  5085                                  ;-807     prc(n);
  5086                                  
  5087 00001A8E FF7604                   push word [bp+4]
  5088 00001A91 E85BFE                   call prc
  5089 00001A94 83C402                   add  sp, 2
  5090                                  
  5091                                  ;-808 }
  5092                                  
  5093                                  
  5094                                  ;-809 
  5095                                  
  5096                                  
  5097                                  ;-810 int error1(char *s) {
  5098 00001A97 C9                       LEAVE
  5099 00001A98 C3                       ret
  5100                                  ENDP
  5101                                  
  5102                                  error1: PROC
  5103                                  
  5104                                  ;-811     ErrorCount++;
  5105                                  
  5106                                  ;Function : error1, Number of local variables: 1
  5107                                  ;   # type sign width addr used name   list of local variables
  5108                                  ;  200 ptr sign byte   810 NULL s = bp+4;
  5109 00001A99 C8000000                 ENTER  0,0
  5110 00001A9D FF06[1E00]               inc  word[ErrorCount]
  5111                                  
  5112                                  ;-812     prs("\n;***** next line ERROR: ");
  5113                                  
  5114 00001AA1 68[C91A]                 push error1_0
  5115 00001AA4 E8A0FE                   call prs
  5116 00001AA7 83C402                   add  sp, 2
  5117                                  
  5118                                  ;-813     prs(s);
  5119                                  
  5120 00001AAA FF7604                   push word [bp+4]
  5121 00001AAD E897FE                   call prs
  5122 00001AB0 83C402                   add  sp, 2
  5123                                  
  5124                                  ;-814     prs(", Symbol: ");
  5125                                  
  5126 00001AB3 68[E41A]                 push error1_1
  5127 00001AB6 E88EFE                   call prs
  5128 00001AB9 83C402                   add  sp, 2
  5129                                  
  5130                                  ;-815     prs(Symbol);
  5131                                  
  5132 00001ABC 8D063075                 lea  ax, [Symbol]
  5133 00001AC0 50                       push ax
  5134 00001AC1 E883FE                   call prs
  5135 00001AC4 83C402                   add  sp, 2
  5136                                  
  5137                                  ;-816 }
  5138                                  
  5139                                  
  5140                                  ;-817 int errorexit(char *s) {
  5141 00001AC7 C9                       LEAVE
  5142 00001AC8 C3                       ret
  5143 00001AC9 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5144 00001AD2 6E657874206C696E65-
  5145 00001ADB 204552524F523A2000 
  5146 00001AE4 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5147 00001AED 2000               
  5148                                  ENDP
  5149                                  
  5150                                  errorexit: PROC
  5151                                  
  5152                                  ;-818     error1(s);
  5153                                  
  5154                                  ;Function : errorexit, Number of local variables: 1
  5155                                  ;   # type sign width addr used name   list of local variables
  5156                                  ;  200 ptr sign byte   817 NULL s = bp+4;
  5157 00001AEF C8000000                 ENTER  0,0
  5158 00001AF3 FF7604                   push word [bp+4]
  5159 00001AF6 E8A0FF                   call error1
  5160 00001AF9 83C402                   add  sp, 2
  5161                                  
  5162                                  ;-819     epilog();
  5163                                  
  5164 00001AFC E82A05                   call epilog
  5165                                  
  5166                                  ;-820     end1(1);
  5167                                  
  5168 00001AFF 6A01                     push 1
  5169 00001B01 E81106                   call end1
  5170 00001B04 83C402                   add  sp, 2
  5171                                  
  5172                                  ;-821 }
  5173                                  
  5174                                  
  5175                                  ;-822 int notfounderror(){error1("label not found"); }
  5176 00001B07 C9                       LEAVE
  5177 00001B08 C3                       ret
  5178                                  ENDP
  5179                                  
  5180                                  notfounderror: PROC
  5181 00001B09 68[131B]                 push notfounderror_0
  5182 00001B0C E88AFF                   call error1
  5183 00001B0F 83C402                   add  sp, 2
  5184                                  
  5185                                  ;-823 int allowederror() {error1("not allowed here"); }
  5186                                  
  5187 00001B12 C3                       ret
  5188 00001B13 6C6162656C206E6F74-     notfounderror_0 db "label not found",0
  5189 00001B1C 20666F756E6400     
  5190                                  ENDP
  5191                                  
  5192                                  allowederror: PROC
  5193 00001B23 68[2D1B]                 push allowederror_0
  5194 00001B26 E870FF                   call error1
  5195 00001B29 83C402                   add  sp, 2
  5196                                  
  5197                                  ;-824 int addrerror()    {error1("address missing");}
  5198                                  
  5199 00001B2C C3                       ret
  5200 00001B2D 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5201 00001B36 6564206865726500   
  5202                                  ENDP
  5203                                  
  5204                                  addrerror: PROC
  5205 00001B3E 68[481B]                 push addrerror_0
  5206 00001B41 E855FF                   call error1
  5207 00001B44 83C402                   add  sp, 2
  5208                                  
  5209                                  ;-825 int immeerror()    {error1("immediate not allowed here");}
  5210                                  
  5211 00001B47 C3                       ret
  5212 00001B48 61646472657373206D-     addrerror_0 db "address missing",0
  5213 00001B51 697373696E6700     
  5214                                  ENDP
  5215                                  
  5216                                  immeerror: PROC
  5217 00001B58 68[621B]                 push immeerror_0
  5218 00001B5B E83BFF                   call error1
  5219 00001B5E 83C402                   add  sp, 2
  5220                                  
  5221                                  ;-826 int implerror()    {error1("not implemented");}
  5222                                  
  5223 00001B61 C3                       ret
  5224 00001B62 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5225 00001B6B 206E6F7420616C6C6F-
  5226 00001B74 776564206865726500 
  5227                                  ENDP
  5228                                  
  5229                                  implerror: PROC
  5230 00001B7D 68[871B]                 push implerror_0
  5231 00001B80 E816FF                   call error1
  5232 00001B83 83C402                   add  sp, 2
  5233                                  
  5234                                  ;-827 int indexerror()   {error1("invalid index register");}
  5235                                  
  5236 00001B86 C3                       ret
  5237 00001B87 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5238 00001B90 6D656E74656400     
  5239                                  ENDP
  5240                                  
  5241                                  indexerror: PROC
  5242 00001B97 68[A11B]                 push indexerror_0
  5243 00001B9A E8FCFE                   call error1
  5244 00001B9D 83C402                   add  sp, 2
  5245                                  
  5246                                  ;-828 int invaloperror() {error1("invalid or no operands");}
  5247                                  
  5248 00001BA0 C3                       ret
  5249 00001BA1 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5250 00001BAA 6E6465782072656769-
  5251 00001BB3 7374657200         
  5252                                  ENDP
  5253                                  
  5254                                  invaloperror: PROC
  5255 00001BB8 68[C21B]                 push invaloperror_0
  5256 00001BBB E8DBFE                   call error1
  5257 00001BBE 83C402                   add  sp, 2
  5258                                  
  5259                                  ;-829 int numbererror()  {error1("number expected");}
  5260                                  
  5261 00001BC1 C3                       ret
  5262 00001BC2 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5263 00001BCB 72206E6F206F706572-
  5264 00001BD4 616E647300         
  5265                                  ENDP
  5266                                  
  5267                                  numbererror: PROC
  5268 00001BD9 68[E31B]                 push numbererror_0
  5269 00001BDC E8BAFE                   call error1
  5270 00001BDF 83C402                   add  sp, 2
  5271                                  
  5272                                  ;-830 int regmemerror()  {error1("only register or memory allowed");}
  5273                                  
  5274 00001BE2 C3                       ret
  5275 00001BE3 6E756D626572206578-     numbererror_0 db "number expected",0
  5276 00001BEC 70656374656400     
  5277                                  ENDP
  5278                                  
  5279                                  regmemerror: PROC
  5280 00001BF3 68[FD1B]                 push regmemerror_0
  5281 00001BF6 E8A0FE                   call error1
  5282 00001BF9 83C402                   add  sp, 2
  5283                                  
  5284                                  ;-831 int reg16error()   {error1("only reg16, no segreg allowed");}
  5285                                  
  5286 00001BFC C3                       ret
  5287 00001BFD 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5288 00001C06 73746572206F72206D-
  5289 00001C0F 656D6F727920616C6C-
  5290 00001C18 6F77656400         
  5291                                  ENDP
  5292                                  
  5293                                  reg16error: PROC
  5294 00001C1D 68[271C]                 push reg16error_0
  5295 00001C20 E876FE                   call error1
  5296 00001C23 83C402                   add  sp, 2
  5297                                  
  5298                                  ;-832 int segregerror()  {error1("segment register not allowed");}
  5299                                  
  5300 00001C26 C3                       ret
  5301 00001C27 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5302 00001C30 362C206E6F20736567-
  5303 00001C39 72656720616C6C6F77-
  5304 00001C42 656400             
  5305                                  ENDP
  5306                                  
  5307                                  segregerror: PROC
  5308 00001C45 68[4F1C]                 push segregerror_0
  5309 00001C48 E84EFE                   call error1
  5310 00001C4B 83C402                   add  sp, 2
  5311                                  
  5312                                  ;-833 int syntaxerror()  {error1("syntax");}
  5313                                  
  5314 00001C4E C3                       ret
  5315 00001C4F 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5316 00001C58 65676973746572206E-
  5317 00001C61 6F7420616C6C6F7765-
  5318 00001C6A 6400               
  5319                                  ENDP
  5320                                  
  5321                                  syntaxerror: PROC
  5322 00001C6C 68[761C]                 push syntaxerror_0
  5323 00001C6F E827FE                   call error1
  5324 00001C72 83C402                   add  sp, 2
  5325                                  
  5326                                  ;-834 
  5327                                  
  5328                                  
  5329                                  ;-835 int addrexit()     {errorexit("illegal address");}
  5330                                  
  5331 00001C75 C3                       ret
  5332 00001C76 73796E74617800          syntaxerror_0 db "syntax",0
  5333                                  ENDP
  5334                                  
  5335                                  addrexit: PROC
  5336 00001C7D 68[871C]                 push addrexit_0
  5337 00001C80 E86CFE                   call errorexit
  5338 00001C83 83C402                   add  sp, 2
  5339                                  
  5340                                  ;-836 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5341                                  
  5342 00001C86 C3                       ret
  5343 00001C87 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5344 00001C90 64647265737300     
  5345                                  ENDP
  5346                                  
  5347                                  dataexit: PROC
  5348 00001C97 68[A11C]                 push dataexit_0
  5349 00001C9A E852FE                   call errorexit
  5350 00001C9D 83C402                   add  sp, 2
  5351                                  
  5352                                  ;-837 int internexit()   {errorexit("intern compiler error");}
  5353                                  
  5354 00001CA0 C3                       ret
  5355 00001CA1 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5356 00001CAA 6F7220524553422C57-
  5357 00001CB3 2C4420657870656374-
  5358 00001CBC 656400             
  5359                                  ENDP
  5360                                  
  5361                                  internexit: PROC
  5362 00001CBF 68[C91C]                 push internexit_0
  5363 00001CC2 E82AFE                   call errorexit
  5364 00001CC5 83C402                   add  sp, 2
  5365                                  
  5366                                  ;-838 
  5367                                  
  5368                                  
  5369                                  ;-839 
  5370                                  
  5371                                  
  5372                                  ;-840 //#include "MAIN.C"
  5373                                  
  5374                                  
  5375                                  ;-841 int main() {
  5376                                  
  5377 00001CC8 C3                       ret
  5378 00001CC9 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5379 00001CD2 6D70696C6572206572-
  5380 00001CDB 726F7200           
  5381                                  ENDP
  5382                                  
  5383                                  main: PROC
  5384                                  
  5385                                  ;-842     getarg();
  5386                                  
  5387 00001CDF E80D00                   call getarg
  5388                                  
  5389                                  ;-843     parse();
  5390                                  
  5391 00001CE2 E8DDEC                   call parse
  5392                                  
  5393                                  ;-844     fixJmp();
  5394                                  
  5395 00001CE5 E84A02                   call fixJmp
  5396                                  
  5397                                  ;-845     epilog();
  5398                                  
  5399 00001CE8 E83E03                   call epilog
  5400                                  
  5401                                  ;-846     end1();
  5402                                  
  5403 00001CEB E82704                   call end1
  5404                                  
  5405                                  ;-847 }
  5406                                  
  5407                                  
  5408                                  ;-848 
  5409                                  
  5410                                  
  5411                                  ;-849 int getarg() {
  5412                                  
  5413 00001CEE C3                       ret
  5414                                  ENDP
  5415                                  
  5416                                  getarg: PROC
  5417                                  
  5418                                  ;-850     int arglen1; int i; char *c;
  5419                                  
  5420                                  
  5421                                  ;-851     arglen1=*arglen;
  5422                                  
  5423                                  ;Function : getarg, Number of local variables: 3
  5424                                  ;   # type sign width addr used name   list of local variables
  5425                                  ;  200 var sign word   850 NULL arglen1 = bp-2
  5426                                  ;  201 var sign word   850 NULL i = bp-4
  5427                                  ;  202 ptr sign byte   850 NULL c = bp-6;
  5428 00001CEF C8060000                 ENTER  6,0
  5429 00001CF3 8B1E[5A00]               mov bx, [arglen]
  5430 00001CF7 8A07                     mov al, [bx]
  5431 00001CF9 B400                     mov ah, 0
  5432 00001CFB 8946FE                   mov [bp-2], ax
  5433                                  
  5434                                  ;-852     if (arglen1==0) {
  5435                                  
  5436 00001CFE 8B46FE                   mov ax, [bp-2]
  5437 00001D01 83F800                   cmp ax, 0
  5438 00001D04 0F851C00                 jne .getarg228
  5439                                  
  5440                                  ;-853         cputs(Version1);
  5441                                  
  5442 00001D08 8D06[0300]               lea  ax, [Version1]
  5443 00001D0C 50                       push ax
  5444 00001D0D E88FF2                   call cputs
  5445 00001D10 83C402                   add  sp, 2
  5446                                  
  5447                                  ;-854         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5448                                  
  5449 00001D13 68[9F1E]                 push getarg_0
  5450 00001D16 E886F2                   call cputs
  5451 00001D19 83C402                   add  sp, 2
  5452                                  
  5453                                  ;-855         exitR(3);
  5454                                  
  5455 00001D1C 6A03                     push 3
  5456 00001D1E E8E5F2                   call exitR
  5457 00001D21 83C402                   add  sp, 2
  5458                                  
  5459                                  ;-856     }
  5460                                  
  5461                                  
  5462                                  ;-857     i=arglen1+129;
  5463                                  
  5464                                  .getarg228:
  5465 00001D24 8B46FE                   mov ax, [bp-2]
  5466 00001D27 058100                   add ax, 129
  5467 00001D2A 8946FC                   mov [bp-4], ax
  5468                                  
  5469                                  ;-858     *i=0;
  5470                                  
  5471 00001D2D B80000                   mov ax, 0
  5472 00001D30 8B5EFC                   mov  bx, [bp-4]
  5473 00001D33 8907                     mov  [bx], ax
  5474                                  
  5475                                  ;-859     arglen1--;
  5476                                  
  5477 00001D35 FF4EFE                   dec  word[bp-2]
  5478                                  
  5479                                  ;-860     toupper(argv);
  5480                                  
  5481 00001D38 FF36[5C00]               push word [argv]
  5482 00001D3C E8FEF5                   call toupper
  5483 00001D3F 83C402                   add  sp, 2
  5484                                  
  5485                                  ;-861 
  5486                                  
  5487                                  
  5488                                  ;-862     strcpy(namein, argv); strcat1(namein, ".S");
  5489                                  
  5490 00001D42 FF36[5C00]               push word [argv]
  5491 00001D46 8D068C76                 lea  ax, [namein]
  5492 00001D4A 50                       push ax
  5493 00001D4B E848F5                   call strcpy
  5494 00001D4E 83C404                   add  sp, 4
  5495 00001D51 68[C41E]                 push getarg_1
  5496 00001D54 8D068C76                 lea  ax, [namein]
  5497 00001D58 50                       push ax
  5498 00001D59 E8BCF5                   call strcat1
  5499 00001D5C 83C404                   add  sp, 4
  5500                                  
  5501                                  ;-863     strcpy(namelst,argv); strcat1(namelst,".LST");
  5502                                  
  5503 00001D5F FF36[5C00]               push word [argv]
  5504 00001D63 8D06CF76                 lea  ax, [namelst]
  5505 00001D67 50                       push ax
  5506 00001D68 E82BF5                   call strcpy
  5507 00001D6B 83C404                   add  sp, 4
  5508 00001D6E 68[C71E]                 push getarg_2
  5509 00001D71 8D06CF76                 lea  ax, [namelst]
  5510 00001D75 50                       push ax
  5511 00001D76 E89FF5                   call strcat1
  5512 00001D79 83C404                   add  sp, 4
  5513                                  
  5514                                  ;-864     strcpy(namebin,argv); strcat1(namebin,".COM");
  5515                                  
  5516 00001D7C FF36[5C00]               push word [argv]
  5517 00001D80 8D061277                 lea  ax, [namebin]
  5518 00001D84 50                       push ax
  5519 00001D85 E80EF5                   call strcpy
  5520 00001D88 83C404                   add  sp, 4
  5521 00001D8B 68[CC1E]                 push getarg_3
  5522 00001D8E 8D061277                 lea  ax, [namebin]
  5523 00001D92 50                       push ax
  5524 00001D93 E882F5                   call strcat1
  5525 00001D96 83C404                   add  sp, 4
  5526                                  
  5527                                  ;-865 
  5528                                  
  5529                                  
  5530                                  ;-866   DOS_ERR=0; PC=0; ErrorCount=0;
  5531                                  
  5532 00001D99 B80000                   mov ax, 0
  5533 00001D9C A3[1C00]                 mov word [DOS_ERR], ax
  5534 00001D9F B80000                   mov ax, 0
  5535 00001DA2 A3[2300]                 mov word [PC], ax
  5536 00001DA5 B80000                   mov ax, 0
  5537 00001DA8 A3[1E00]                 mov word [ErrorCount], ax
  5538                                  
  5539                                  ;-867 
  5540                                  
  5541                                  
  5542                                  ;-868     asm_fd=openR (namein);
  5543                                  
  5544 00001DAB 8D068C76                 lea  ax, [namein]
  5545 00001DAF 50                       push ax
  5546 00001DB0 E823F2                   call openR
  5547 00001DB3 83C402                   add  sp, 2
  5548 00001DB6 A3[1600]                 mov word [asm_fd], ax
  5549                                  
  5550                                  ;-869     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5551                                  
  5552 00001DB9 A1[1C00]                 mov ax, [DOS_ERR]
  5553 00001DBC 08C0                     or  al, al
  5554 00001DBE 0F841C00                 je .getarg229
  5555 00001DC2 68[D11E]                 push getarg_4
  5556 00001DC5 E8D7F1                   call cputs
  5557 00001DC8 83C402                   add  sp, 2
  5558 00001DCB 8D068C76                 lea  ax, [namein]
  5559 00001DCF 50                       push ax
  5560 00001DD0 E8CCF1                   call cputs
  5561 00001DD3 83C402                   add  sp, 2
  5562 00001DD6 6A01                     push 1
  5563 00001DD8 E82BF2                   call exitR
  5564 00001DDB 83C402                   add  sp, 2
  5565                                  
  5566                                  ;-870     lst_fd=creatR(namelst);
  5567                                  
  5568                                  .getarg229:
  5569 00001DDE 8D06CF76                 lea  ax, [namelst]
  5570 00001DE2 50                       push ax
  5571 00001DE3 E8FFF1                   call creatR
  5572 00001DE6 83C402                   add  sp, 2
  5573 00001DE9 A3[1800]                 mov word [lst_fd], ax
  5574                                  
  5575                                  ;-871     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5576                                  
  5577 00001DEC A1[1C00]                 mov ax, [DOS_ERR]
  5578 00001DEF 08C0                     or  al, al
  5579 00001DF1 0F841C00                 je .getarg230
  5580 00001DF5 68[E71E]                 push getarg_5
  5581 00001DF8 E8A4F1                   call cputs
  5582 00001DFB 83C402                   add  sp, 2
  5583 00001DFE 8D06CF76                 lea  ax, [namelst]
  5584 00001E02 50                       push ax
  5585 00001E03 E899F1                   call cputs
  5586 00001E06 83C402                   add  sp, 2
  5587 00001E09 6A02                     push 2
  5588 00001E0B E8F8F1                   call exitR
  5589 00001E0E 83C402                   add  sp, 2
  5590                                  
  5591                                  ;-872     bin_fd=creatR(namebin);
  5592                                  
  5593                                  .getarg230:
  5594 00001E11 8D061277                 lea  ax, [namebin]
  5595 00001E15 50                       push ax
  5596 00001E16 E8CCF1                   call creatR
  5597 00001E19 83C402                   add  sp, 2
  5598 00001E1C A3[1A00]                 mov word [bin_fd], ax
  5599                                  
  5600                                  ;-873     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5601                                  
  5602 00001E1F A1[1C00]                 mov ax, [DOS_ERR]
  5603 00001E22 08C0                     or  al, al
  5604 00001E24 0F841C00                 je .getarg231
  5605 00001E28 68[FE1E]                 push getarg_6
  5606 00001E2B E871F1                   call cputs
  5607 00001E2E 83C402                   add  sp, 2
  5608 00001E31 8D061277                 lea  ax, [namebin]
  5609 00001E35 50                       push ax
  5610 00001E36 E866F1                   call cputs
  5611 00001E39 83C402                   add  sp, 2
  5612 00001E3C 6A02                     push 2
  5613 00001E3E E8C5F1                   call exitR
  5614 00001E41 83C402                   add  sp, 2
  5615                                  
  5616                                  ;-874 
  5617                                  
  5618                                  
  5619                                  ;-875     prs(";");
  5620                                  
  5621                                  .getarg231:
  5622 00001E44 68[141F]                 push getarg_7
  5623 00001E47 E8FDFA                   call prs
  5624 00001E4A 83C402                   add  sp, 2
  5625                                  
  5626                                  ;-876     prs(Version1);
  5627                                  
  5628 00001E4D 8D06[0300]               lea  ax, [Version1]
  5629 00001E51 50                       push ax
  5630 00001E52 E8F2FA                   call prs
  5631 00001E55 83C402                   add  sp, 2
  5632                                  
  5633                                  ;-877     prs(", Source: "); prs(namein);
  5634                                  
  5635 00001E58 68[161F]                 push getarg_8
  5636 00001E5B E8E9FA                   call prs
  5637 00001E5E 83C402                   add  sp, 2
  5638 00001E61 8D068C76                 lea  ax, [namein]
  5639 00001E65 50                       push ax
  5640 00001E66 E8DEFA                   call prs
  5641 00001E69 83C402                   add  sp, 2
  5642                                  
  5643                                  ;-878     prs(", Output: "); prs(namelst);
  5644                                  
  5645 00001E6C 68[211F]                 push getarg_9
  5646 00001E6F E8D5FA                   call prs
  5647 00001E72 83C402                   add  sp, 2
  5648 00001E75 8D06CF76                 lea  ax, [namelst]
  5649 00001E79 50                       push ax
  5650 00001E7A E8CAFA                   call prs
  5651 00001E7D 83C402                   add  sp, 2
  5652                                  
  5653                                  ;-879     prs(", "); prs(namebin);
  5654                                  
  5655 00001E80 68[2C1F]                 push getarg_10
  5656 00001E83 E8C1FA                   call prs
  5657 00001E86 83C402                   add  sp, 2
  5658 00001E89 8D061277                 lea  ax, [namebin]
  5659 00001E8D 50                       push ax
  5660 00001E8E E8B6FA                   call prs
  5661 00001E91 83C402                   add  sp, 2
  5662                                  
  5663                                  ;-880     prs("\n");
  5664                                  
  5665 00001E94 68[2F1F]                 push getarg_11
  5666 00001E97 E8ADFA                   call prs
  5667 00001E9A 83C402                   add  sp, 2
  5668                                  
  5669                                  ;-881 }
  5670                                  
  5671                                  
  5672                                  ;-882 
  5673                                  
  5674                                  
  5675                                  ;-883 int fixJmp() {   
  5676 00001E9D C9                       LEAVE
  5677 00001E9E C3                       ret
  5678 00001E9F 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5679 00001EA8 41532E434F4D206669-
  5680 00001EB1 6C656E616D65205B77-
  5681 00001EBA 2F6F202E535D203A20-
  5682 00001EC3 00                 
  5683 00001EC4 2E5300                  getarg_1 db ".S",0
  5684 00001EC7 2E4C535400              getarg_2 db ".LST",0
  5685 00001ECC 2E434F4D00              getarg_3 db ".COM",0
  5686 00001ED1 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5687 00001EDA 6C65206D697373696E-
  5688 00001EE3 673A2000           
  5689 00001EE7 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5690 00001EF0 206E6F742063726561-
  5691 00001EF9 74653A2000         
  5692 00001EFE 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5693 00001F07 6E6F74206372656174-
  5694 00001F10 653A2000           
  5695 00001F14 3B00                    getarg_7 db ";",0
  5696 00001F16 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5697 00001F1F 2000               
  5698 00001F21 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5699 00001F2A 2000               
  5700 00001F2C 2C2000                  getarg_10 db ", ",0
  5701 00001F2F 5C6E00                  getarg_11 db "\n",0
  5702                                  ENDP
  5703                                  
  5704                                  fixJmp: PROC
  5705                                  
  5706                                  ;-884     //todo ENDP: search backwards until tmpJmpMaxIx    
  5707                                  
  5708                                  
  5709                                  ;-885     int i;  unsigned int hex; 
  5710                                  
  5711                                  
  5712                                  ;-886     char *p; int Ix; char c;
  5713                                  
  5714                                  
  5715                                  ;-887     i=1;
  5716                                  
  5717                                  ;Function : fixJmp, Number of local variables: 5
  5718                                  ;   # type sign width addr used name   list of local variables
  5719                                  ;  200 var sign word   885 NULL i = bp-2
  5720                                  ;  201 var unsg word   885 NULL hex = bp-4
  5721                                  ;  202 ptr sign byte   886 NULL p = bp-6
  5722                                  ;  203 var sign word   886 NULL Ix = bp-8
  5723                                  ;  204 var sign byte   886 NULL c = bp-10;
  5724 00001F32 C80A0000                 ENTER  10,0
  5725 00001F36 B80100                   mov ax, 1
  5726 00001F39 8946FE                   mov [bp-2], ax
  5727                                  
  5728                                  ;-888     prs("\n;jmp to fix:");
  5729                                  
  5730 00001F3C 68[0A20]                 push fixJmp_0
  5731 00001F3F E805FA                   call prs
  5732 00001F42 83C402                   add  sp, 2
  5733                                  
  5734                                  ;-889     printIntU(JmpMaxIx);
  5735                                  
  5736 00001F45 FF36[5400]               push word [JmpMaxIx]
  5737 00001F49 E80BFB                   call printIntU
  5738 00001F4C 83C402                   add  sp, 2
  5739                                  
  5740                                  ;-890     p = &JmpNames;
  5741                                  
  5742 00001F4F B87A93                   mov ax, JmpNames
  5743 00001F52 8946FA                   mov [bp-6], ax
  5744                                  
  5745                                  ;-891     while (i <= JmpMaxIx) {
  5746                                  
  5747                                  .fixJmp232:
  5748 00001F55 8B46FE                   mov ax, [bp-2]
  5749 00001F58 3B06[5400]               cmp ax, [JmpMaxIx]
  5750 00001F5C 0F8FA800                 jg  .fixJmp233
  5751                                  
  5752                                  ;-892         strcpy(Symbol, p);
  5753                                  
  5754 00001F60 FF76FA                   push word [bp-6]
  5755 00001F63 8D063075                 lea  ax, [Symbol]
  5756 00001F67 50                       push ax
  5757 00001F68 E82BF3                   call strcpy
  5758 00001F6B 83C404                   add  sp, 4
  5759                                  
  5760                                  ;-893         p = strlen(Symbol) + p;
  5761                                  
  5762 00001F6E 8D063075                 lea  ax, [Symbol]
  5763 00001F72 50                       push ax
  5764 00001F73 E8F8F2                   call strlen
  5765 00001F76 83C402                   add  sp, 2
  5766 00001F79 0346FA                   add ax, [bp-6]
  5767 00001F7C 8946FA                   mov [bp-6], ax
  5768                                  
  5769                                  ;-894         p++;
  5770                                  
  5771 00001F7F FF46FA                   inc  word[bp-6]
  5772                                  
  5773                                  ;-895         hex = JmpAddr[i];
  5774                                  
  5775 00001F82 8B5EFE                   mov bx, [bp-2]
  5776 00001F85 D1E3                     shl bx, 1
  5777 00001F87 8B871AA3                 mov ax, [JmpAddr + bx]
  5778 00001F8B 8946FC                   mov [bp-4], ax
  5779                                  
  5780                                  ;-896 //prs("\nSymbol:"); prs(Symbol); prs(",from:");                                       
  5781                                  
  5782                                  
  5783                                  ;-897 //printhex16(hex);//debug
  5784                                  
  5785                                  
  5786                                  ;-898         
  5787                                  
  5788                                  
  5789                                  ;-899         Ix=searchLabel();
  5790                                  
  5791 00001F8E E8F9EC                   call searchLabel
  5792 00001F91 8946F8                   mov [bp-8], ax
  5793                                  
  5794                                  ;-900         if (Ix == 0) error1("Label not found");
  5795                                  
  5796 00001F94 8B46F8                   mov ax, [bp-8]
  5797 00001F97 83F800                   cmp ax, 0
  5798 00001F9A 0F850900                 jne .fixJmp234
  5799 00001F9E 68[1920]                 push fixJmp_1
  5800 00001FA1 E8F5FA                   call error1
  5801 00001FA4 83C402                   add  sp, 2
  5802                                  
  5803                                  ;-901         disp = LabelAddr[Ix];   
  5804                                  
  5805                                  .fixJmp234:
  5806 00001FA7 8B5EF8                   mov bx, [bp-8]
  5807 00001FAA D1E3                     shl bx, 1
  5808 00001FAC 8B87CA8E                 mov ax, [LabelAddr + bx]
  5809 00001FB0 A3[3D00]                 mov word [disp], ax
  5810                                  
  5811                                  ;-902         c = FileBin[hex];//look for 'A' push Absolute 
  5812                                  
  5813 00001FB3 8B5EFC                   mov bx, [bp-4]
  5814 00001FB6 8A87AAA4                 mov al, [FileBin + bx]
  5815 00001FBA 8846F6                   mov [bp-10], al
  5816                                  
  5817                                  ;-903 //prs(",=00/AA:["); printhex8a(c);
  5818                                  
  5819                                  
  5820                                  ;-904 //prs("],Lab:"); printhex16(disp);
  5821                                  
  5822                                  
  5823                                  ;-905         if (c != 0xAA) {
  5824                                  
  5825 00001FBD 8A46F6                   mov al, [bp-10]
  5826 00001FC0 3CAA                     cmp al, 170
  5827 00001FC2 0F841C00                 je  .fixJmp235
  5828                                  
  5829                                  ;-906             disp = disp - hex;
  5830                                  
  5831 00001FC6 A1[3D00]                 mov ax, [disp]
  5832 00001FC9 2B46FC                   sub ax, [bp-4]
  5833 00001FCC A3[3D00]                 mov word [disp], ax
  5834                                  
  5835                                  ;-907             disp = disp -2;//PC points to next instruction
  5836                                  
  5837 00001FCF A1[3D00]                 mov ax, [disp]
  5838 00001FD2 83E802                   sub ax, 2
  5839 00001FD5 A3[3D00]                 mov word [disp], ax
  5840                                  
  5841                                  ;-908             disp = disp - Origin;
  5842                                  
  5843 00001FD8 A1[3D00]                 mov ax, [disp]
  5844 00001FDB 2B06[2500]               sub ax, [Origin]
  5845 00001FDF A3[3D00]                 mov word [disp], ax
  5846                                  
  5847                                  ;-909         }
  5848                                  
  5849                                  
  5850                                  ;-910             FileBin[hex] = disp;//fix low byte
  5851                                  
  5852                                  .fixJmp235:
  5853 00001FE2 A1[3D00]                 mov ax, [disp]
  5854 00001FE5 8B5EFC                   mov bx, [bp-4]
  5855 00001FE8 8887AAA4                 mov [FileBin+bx], al
  5856                                  
  5857                                  ;-911             hex++;
  5858                                  
  5859 00001FEC FF46FC                   inc  word[bp-4]
  5860                                  
  5861                                  ;-912             disp = disp >> 8;
  5862                                  
  5863 00001FEF A1[3D00]                 mov ax, [disp]
  5864 00001FF2 C1E808                   shr ax, 8
  5865 00001FF5 A3[3D00]                 mov word [disp], ax
  5866                                  
  5867                                  ;-913             FileBin[hex] = disp; 
  5868                                  
  5869 00001FF8 A1[3D00]                 mov ax, [disp]
  5870 00001FFB 8B5EFC                   mov bx, [bp-4]
  5871 00001FFE 8887AAA4                 mov [FileBin+bx], al
  5872                                  
  5873                                  ;-914         i++;
  5874                                  
  5875 00002002 FF46FE                   inc  word[bp-2]
  5876                                  
  5877                                  ;-915     }
  5878                                  
  5879                                  
  5880                                  ;-916 }
  5881                                  
  5882 00002005 E94DFF                   jmp .fixJmp232
  5883                                  .fixJmp233:
  5884                                  
  5885                                  ;-917 
  5886                                  
  5887                                  
  5888                                  ;-918 int epilog() {
  5889 00002008 C9                       LEAVE
  5890 00002009 C3                       ret
  5891 0000200A 5C6E3B6A6D7020746F-     fixJmp_0 db "\n;jmp to fix:",0
  5892 00002013 206669783A00       
  5893 00002019 4C6162656C206E6F74-     fixJmp_1 db "Label not found",0
  5894 00002022 20666F756E6400     
  5895                                  ENDP
  5896                                  
  5897                                  epilog: PROC
  5898                                  
  5899                                  ;-919     unsigned int i; char c;     int j;
  5900                                  
  5901                                  
  5902                                  ;-920     prs("\n Errors: ");
  5903                                  
  5904                                  ;Function : epilog, Number of local variables: 3
  5905                                  ;   # type sign width addr used name   list of local variables
  5906                                  ;  200 var unsg word   919 NULL i = bp-2
  5907                                  ;  201 var sign byte   919 NULL c = bp-4
  5908                                  ;  202 var sign word   919 NULL j = bp-6;
  5909 00002029 C8060000                 ENTER  6,0
  5910 0000202D 68[DB20]                 push epilog_0
  5911 00002030 E814F9                   call prs
  5912 00002033 83C402                   add  sp, 2
  5913                                  
  5914                                  ;-921     printIntU(ErrorCount);
  5915                                  
  5916 00002036 FF36[1E00]               push word [ErrorCount]
  5917 0000203A E81AFA                   call printIntU
  5918 0000203D 83C402                   add  sp, 2
  5919                                  
  5920                                  ;-922     if (ErrorCount) prs(" ***ERROR*** ");
  5921                                  
  5922 00002040 A1[1E00]                 mov ax, [ErrorCount]
  5923 00002043 08C0                     or  al, al
  5924 00002045 0F840900                 je .epilog236
  5925 00002049 68[E720]                 push epilog_1
  5926 0000204C E8F8F8                   call prs
  5927 0000204F 83C402                   add  sp, 2
  5928                                  
  5929                                  ;-923     prs(", Out: ");
  5930                                  
  5931                                  .epilog236:
  5932 00002052 68[F520]                 push epilog_2
  5933 00002055 E8EFF8                   call prs
  5934 00002058 83C402                   add  sp, 2
  5935                                  
  5936                                  ;-924     prs(namelst);
  5937                                  
  5938 0000205B 8D06CF76                 lea  ax, [namelst]
  5939 0000205F 50                       push ax
  5940 00002060 E8E4F8                   call prs
  5941 00002063 83C402                   add  sp, 2
  5942                                  
  5943                                  ;-925     prs(", ");
  5944                                  
  5945 00002066 68[FD20]                 push epilog_3
  5946 00002069 E8DBF8                   call prs
  5947 0000206C 83C402                   add  sp, 2
  5948                                  
  5949                                  ;-926     prs(namebin);
  5950                                  
  5951 0000206F 8D061277                 lea  ax, [namebin]
  5952 00002073 50                       push ax
  5953 00002074 E8D0F8                   call prs
  5954 00002077 83C402                   add  sp, 2
  5955                                  
  5956                                  ;-927     prs("= ");
  5957                                  
  5958 0000207A 68[0021]                 push epilog_4
  5959 0000207D E8C7F8                   call prs
  5960 00002080 83C402                   add  sp, 2
  5961                                  
  5962                                  ;-928     printIntU(BinLen);
  5963                                  
  5964 00002083 FF36[5800]               push word [BinLen]
  5965 00002087 E8CDF9                   call printIntU
  5966 0000208A 83C402                   add  sp, 2
  5967                                  
  5968                                  ;-929     prs(" bytes.");
  5969                                  
  5970 0000208D 68[0321]                 push epilog_5
  5971 00002090 E8B4F8                   call prs
  5972 00002093 83C402                   add  sp, 2
  5973                                  
  5974                                  ;-930     prs(" Labels: ");
  5975                                  
  5976 00002096 68[0B21]                 push epilog_6
  5977 00002099 E8ABF8                   call prs
  5978 0000209C 83C402                   add  sp, 2
  5979                                  
  5980                                  ;-931     printIntU(LabelMaxIx);
  5981                                  
  5982 0000209F FF36[4A00]               push word [LabelMaxIx]
  5983 000020A3 E8B1F9                   call printIntU
  5984 000020A6 83C402                   add  sp, 2
  5985                                  
  5986                                  ;-932 // prs(", code:\n ");//debug
  5987                                  
  5988                                  
  5989                                  ;-933 
  5990                                  
  5991                                  
  5992                                  ;-934     i=0;
  5993                                  
  5994 000020A9 B80000                   mov ax, 0
  5995 000020AC 8946FE                   mov [bp-2], ax
  5996                                  
  5997                                  ;-935     do {
  5998                                  
  5999                                  .epilog237:
  6000                                  
  6001                                  ;-936         c = FileBin[i];
  6002                                  
  6003 000020AF 8B5EFE                   mov bx, [bp-2]
  6004 000020B2 8A87AAA4                 mov al, [FileBin + bx]
  6005 000020B6 8846FC                   mov [bp-4], al
  6006                                  
  6007                                  ;-937         fputcR(c, bin_fd);
  6008                                  
  6009 000020B9 FF36[1A00]               push word [bin_fd]
  6010 000020BD 8A46FC                   mov al, byte [bp-4]
  6011 000020C0 B400                     mov ah, 0
  6012 000020C2 50                       push ax
  6013 000020C3 E863EF                   call fputcR
  6014 000020C6 83C404                   add  sp, 4
  6015                                  
  6016                                  ;-938 // printhex8a(c); prc(' ');//debug
  6017                                  
  6018                                  
  6019                                  ;-939         i++;
  6020                                  
  6021 000020C9 FF46FE                   inc  word[bp-2]
  6022                                  
  6023                                  ;-940     } while (i < BinLen);
  6024                                  
  6025 000020CC 8B46FE                   mov ax, [bp-2]
  6026 000020CF 3B06[5800]               cmp ax, [BinLen]
  6027 000020D3 0F8D0200                 jge .epilog238
  6028 000020D7 EBD6                     jmp .epilog237
  6029                                  .epilog238:
  6030                                  
  6031                                  ;-941 
  6032                                  
  6033                                  
  6034                                  ;-942 /* 
  6035                                  
  6036                                  
  6037                                  ;-943   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);
  6038                                  
  6039                                  
  6040                                  ;-944   i= &LabelNames;
  6041                                  
  6042                                  
  6043                                  ;-945   prs(" &LabelNames:"); printIntU(i);
  6044                                  
  6045                                  
  6046                                  ;-946   i=LabelNamePtr-i;
  6047                                  
  6048                                  
  6049                                  ;-947   prs(", size: ");
  6050                                  
  6051                                  
  6052                                  ;-948   printIntU(i);
  6053                                  
  6054                                  
  6055                                  ;-949   prs(".\n >>");
  6056                                  
  6057                                  
  6058                                  ;-950   i= &LabelNames;
  6059                                  
  6060                                  
  6061                                  ;-951   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6062                                  
  6063                                  
  6064                                  ;-952   } while (i < LabelNamePtr); prs("<< \n");
  6065                                  
  6066                                  
  6067                                  ;-953    i = 1;
  6068                                  
  6069                                  
  6070                                  ;-954     LabelNamePtr= &LabelNames;
  6071                                  
  6072                                  
  6073                                  ;-955     do {
  6074                                  
  6075                                  
  6076                                  ;-956       prs(LabelNamePtr); prc(' ');
  6077                                  
  6078                                  
  6079                                  ;-957       j=LabelAddr[i]; printhex16(j); prs(", ");
  6080                                  
  6081                                  
  6082                                  ;-958       j=strlen(LabelNamePtr);//get end of actual name
  6083                                  
  6084                                  
  6085                                  ;-959       LabelNamePtr=LabelNamePtr+j;
  6086                                  
  6087                                  
  6088                                  ;-960       LabelNamePtr++;
  6089                                  
  6090                                  
  6091                                  ;-961       i++;
  6092                                  
  6093                                  
  6094                                  ;-962     } while (i <= LabelMaxIx);
  6095                                  
  6096                                  
  6097                                  ;-963 */
  6098                                  
  6099                                  
  6100                                  ;-964 }
  6101                                  
  6102                                  
  6103                                  ;-965 
  6104                                  
  6105                                  
  6106                                  ;-966 int end1(int n) {
  6107 000020D9 C9                       LEAVE
  6108 000020DA C3                       ret
  6109 000020DB 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6110 000020E4 3A2000             
  6111 000020E7 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6112 000020F0 2A2A2A2000         
  6113 000020F5 2C204F75743A2000        epilog_2 db ", Out: ",0
  6114 000020FD 2C2000                  epilog_3 db ", ",0
  6115 00002100 3D2000                  epilog_4 db "= ",0
  6116 00002103 2062797465732E00        epilog_5 db " bytes.",0
  6117 0000210B 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6118 00002114 00                 
  6119                                  ENDP
  6120                                  
  6121                                  end1: PROC
  6122                                  
  6123                                  ;-967     fcloseR(asm_fd);
  6124                                  
  6125                                  ;Function : end1, Number of local variables: 1
  6126                                  ;   # type sign width addr used name   list of local variables
  6127                                  ;  200 var sign word   966 NULL n = bp+4;
  6128 00002115 C8000000                 ENTER  0,0
  6129 00002119 FF36[1600]               push word [asm_fd]
  6130 0000211D E8D7EE                   call fcloseR
  6131 00002120 83C402                   add  sp, 2
  6132                                  
  6133                                  ;-968     fcloseR(lst_fd);
  6134                                  
  6135 00002123 FF36[1800]               push word [lst_fd]
  6136 00002127 E8CDEE                   call fcloseR
  6137 0000212A 83C402                   add  sp, 2
  6138                                  
  6139                                  ;-969     fcloseR(bin_fd);
  6140                                  
  6141 0000212D FF36[1A00]               push word [bin_fd]
  6142 00002131 E8C3EE                   call fcloseR
  6143 00002134 83C402                   add  sp, 2
  6144                                  
  6145                                  ;-970     exitR(n);
  6146                                  
  6147 00002137 FF7604                   push word [bp+4]
  6148 0000213A E8C9EE                   call exitR
  6149 0000213D 83C402                   add  sp, 2
  6150                                  
  6151                                  ;-971 }
  6152                                  
  6153                                  
  6154                                  ;-972 
  6155                                  
  6156                                  
  6157                                  ;-973 
  6158                                  
  6159                                  
  6160                                  ;-974 //#include "GENCODE.C"
  6161                                  
  6162                                  
  6163                                  ;-975 // generate code
  6164                                  
  6165                                  
  6166                                  ;-976 int getCodes() {
  6167 00002140 C9                       LEAVE
  6168 00002141 C3                       ret
  6169                                  ENDP
  6170                                  
  6171                                  getCodes: PROC
  6172                                  
  6173                                  ;-977     OpCodePtr ++; Code1 = *OpCodePtr;
  6174                                  
  6175 00002142 FF06[4300]               inc  word[OpCodePtr]
  6176 00002146 8B1E[4300]               mov bx, [OpCodePtr]
  6177 0000214A 8A07                     mov al, [bx]
  6178 0000214C B400                     mov ah, 0
  6179 0000214E A2[3000]                 mov byte [Code1], al
  6180                                  
  6181                                  ;-978     OpCodePtr ++; Code2 = *OpCodePtr;
  6182                                  
  6183 00002151 FF06[4300]               inc  word[OpCodePtr]
  6184 00002155 8B1E[4300]               mov bx, [OpCodePtr]
  6185 00002159 8A07                     mov al, [bx]
  6186 0000215B B400                     mov ah, 0
  6187 0000215D A2[3100]                 mov byte [Code2], al
  6188                                  
  6189                                  ;-979     OpCodePtr ++; Code3 = *OpCodePtr;
  6190                                  
  6191 00002160 FF06[4300]               inc  word[OpCodePtr]
  6192 00002164 8B1E[4300]               mov bx, [OpCodePtr]
  6193 00002168 8A07                     mov al, [bx]
  6194 0000216A B400                     mov ah, 0
  6195 0000216C A2[3200]                 mov byte [Code3], al
  6196                                  
  6197                                  ;-980 }
  6198                                  
  6199                                  
  6200                                  ;-981 int gen66h() {genCode8(0x66);
  6201                                  
  6202 0000216F C3                       ret
  6203                                  ENDP
  6204                                  
  6205                                  gen66h: PROC
  6206 00002170 6A66                     push 102
  6207 00002172 E83B00                   call genCode8
  6208 00002175 83C402                   add  sp, 2
  6209                                  
  6210                                  ;-982 }
  6211                                  
  6212                                  
  6213                                  ;-983 int genCode2(char c, char d) {
  6214                                  
  6215 00002178 C3                       ret
  6216                                  ENDP
  6217                                  
  6218                                  genCode2: PROC
  6219                                  
  6220                                  ;-984     c = c + d;
  6221                                  
  6222                                  ;Function : genCode2, Number of local variables: 2
  6223                                  ;   # type sign width addr used name   list of local variables
  6224                                  ;  200 var sign byte   983 NULL c = bp+4
  6225                                  ;  201 var sign byte   983 NULL d = bp+6;
  6226 00002179 C8000000                 ENTER  0,0
  6227 0000217D 8A4604                   mov al, [bp+4]
  6228 00002180 024606                   add al, [bp+6]
  6229 00002183 884604                   mov [bp+4], al
  6230                                  
  6231                                  ;-985     genCode8(c);
  6232                                  
  6233 00002186 8A4604                   mov al, byte [bp+4]
  6234 00002189 B400                     mov ah, 0
  6235 0000218B 50                       push ax
  6236 0000218C E82100                   call genCode8
  6237 0000218F 83C402                   add  sp, 2
  6238                                  
  6239                                  ;-986 }
  6240                                  
  6241                                  
  6242                                  ;-987 int genCodeW(char c) {
  6243 00002192 C9                       LEAVE
  6244 00002193 C3                       ret
  6245                                  ENDP
  6246                                  
  6247                                  genCodeW: PROC
  6248                                  
  6249                                  ;-988     c = c + wflag;
  6250                                  
  6251                                  ;Function : genCodeW, Number of local variables: 1
  6252                                  ;   # type sign width addr used name   list of local variables
  6253                                  ;  200 var sign byte   987 NULL c = bp+4;
  6254 00002194 C8000000                 ENTER  0,0
  6255 00002198 8A4604                   mov al, [bp+4]
  6256 0000219B 0206[3800]               add al, [wflag]
  6257 0000219F 884604                   mov [bp+4], al
  6258                                  
  6259                                  ;-989     genCode8(c);
  6260                                  
  6261 000021A2 8A4604                   mov al, byte [bp+4]
  6262 000021A5 B400                     mov ah, 0
  6263 000021A7 50                       push ax
  6264 000021A8 E80500                   call genCode8
  6265 000021AB 83C402                   add  sp, 2
  6266                                  
  6267                                  ;-990 }
  6268                                  
  6269                                  
  6270                                  ;-991 int genCode8(char c) {
  6271 000021AE C9                       LEAVE
  6272 000021AF C3                       ret
  6273                                  ENDP
  6274                                  
  6275                                  genCode8: PROC
  6276                                  
  6277                                  ;-992 //set: BinLen++, OpPrintIndex++
  6278                                  
  6279                                  
  6280                                  ;-993     FileBin[BinLen]=c;
  6281                                  
  6282                                  ;Function : genCode8, Number of local variables: 1
  6283                                  ;   # type sign width addr used name   list of local variables
  6284                                  ;  200 var sign byte   991 NULL c = bp+4;
  6285 000021B0 C8000000                 ENTER  0,0
  6286 000021B4 8A4604                   mov al, [bp+4]
  6287 000021B7 8B1E[5800]               mov bx, [BinLen]
  6288 000021BB 8887AAA4                 mov [FileBin+bx], al
  6289                                  
  6290                                  ;-994     BinLen++;
  6291                                  
  6292 000021BF FF06[5800]               inc  word[BinLen]
  6293                                  
  6294                                  ;-995     PC++;
  6295                                  
  6296 000021C3 FF06[2300]               inc  word[PC]
  6297                                  
  6298                                  ;-996     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6299                                  
  6300 000021C7 A1[5800]                 mov ax, [BinLen]
  6301 000021CA 3D204E                   cmp ax, 20000 ;unsigned : 0
  6302 000021CD 0F820900                 jb  .genCode8239
  6303 000021D1 68[F521]                 push genCode8_0
  6304 000021D4 E818F9                   call errorexit
  6305 000021D7 83C402                   add  sp, 2
  6306                                  
  6307                                  ;-997     if (OpPrintIndex < OPMAXLEN) {
  6308                                  
  6309                                  .genCode8239:
  6310 000021DA A1[4100]                 mov ax, [OpPrintIndex]
  6311 000021DD 83F805                   cmp ax, 5
  6312 000021E0 0F8D0F00                 jge .genCode8240
  6313                                  
  6314                                  ;-998         OpPos[OpPrintIndex]=c;
  6315                                  
  6316 000021E4 8A4604                   mov al, [bp+4]
  6317 000021E7 8B1E[4100]               mov bx, [OpPrintIndex]
  6318 000021EB 88875577                 mov [OpPos+bx], al
  6319                                  
  6320                                  ;-999         OpPrintIndex++;
  6321                                  
  6322 000021EF FF06[4100]               inc  word[OpPrintIndex]
  6323                                  
  6324                                  ;-1000     }
  6325                                  
  6326                                  
  6327                                  ;-1001 }
  6328                                  
  6329                                  .genCode8240:
  6330                                  
  6331                                  ;-1002 int genCode16(unsigned int i) {
  6332 000021F3 C9                       LEAVE
  6333 000021F4 C3                       ret
  6334 000021F5 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6335 000021FE 746F6F206C6F6E6700 
  6336                                  ENDP
  6337                                  
  6338                                  genCode16: PROC
  6339                                  
  6340                                  ;-1003     genCode8(i); i=i >> 8;
  6341                                  
  6342                                  ;Function : genCode16, Number of local variables: 1
  6343                                  ;   # type sign width addr used name   list of local variables
  6344                                  ;  200 var unsg word  1002 NULL i = bp+4;
  6345 00002207 C8000000                 ENTER  0,0
  6346 0000220B FF7604                   push word [bp+4]
  6347 0000220E E89FFF                   call genCode8
  6348 00002211 83C402                   add  sp, 2
  6349 00002214 8B4604                   mov ax, [bp+4]
  6350 00002217 C1E808                   shr ax, 8
  6351 0000221A 894604                   mov [bp+4], ax
  6352                                  
  6353                                  ;-1004     genCode8(i);
  6354                                  
  6355 0000221D FF7604                   push word [bp+4]
  6356 00002220 E88DFF                   call genCode8
  6357 00002223 83C402                   add  sp, 2
  6358                                  
  6359                                  ;-1005 }
  6360                                  
  6361                                  
  6362                                  ;-1006 int genCode32(unsigned long L) {
  6363 00002226 C9                       LEAVE
  6364 00002227 C3                       ret
  6365                                  ENDP
  6366                                  
  6367                                  genCode32: PROC
  6368                                  
  6369                                  ;-1007     genCode16(L); L=L >>16;
  6370                                  
  6371                                  ;Function : genCode32, Number of local variables: 1
  6372                                  ;   # type sign width addr used name   list of local variables
  6373                                  ;  200 var unsg dwrd  1006 NULL L = bp+4;
  6374 00002228 C8000000                 ENTER  0,0
  6375 0000222C 8A4604                   mov al, byte [bp+4]
  6376 0000222F B400                     mov ah, 0
  6377 00002231 50                       push ax
  6378 00002232 E8D2FF                   call genCode16
  6379 00002235 83C402                   add  sp, 2
  6380 00002238 668B4604                 mov eax, [bp+4]
  6381 0000223C 66C1E810                 shr eax, 16
  6382 00002240 66894604                 mov [bp+4], eax
  6383                                  
  6384                                  ;-1008     genCode16(L);
  6385                                  
  6386 00002244 8A4604                   mov al, byte [bp+4]
  6387 00002247 B400                     mov ah, 0
  6388 00002249 50                       push ax
  6389 0000224A E8BAFF                   call genCode16
  6390 0000224D 83C402                   add  sp, 2
  6391                                  
  6392                                  ;-1009 }
  6393                                  
  6394                                  
  6395                                  ;-1010 int writeEA(char xxx) {//value for reg/operand
  6396 00002250 C9                       LEAVE
  6397 00002251 C3                       ret
  6398                                  ENDP
  6399                                  
  6400                                  writeEA: PROC
  6401                                  
  6402                                  ;-1011 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6403                                  
  6404                                  
  6405                                  ;-1012 //mod-bits: mode76, reg/opcode543, r/m210
  6406                                  
  6407                                  
  6408                                  ;-1013 //Op: 0, IMM, REG, ADR, MEM
  6409                                  
  6410                                  
  6411                                  ;-1014     char len;
  6412                                  
  6413                                  
  6414                                  ;-1015     len=0;
  6415                                  
  6416                                  ;Function : writeEA, Number of local variables: 2
  6417                                  ;   # type sign width addr used name   list of local variables
  6418                                  ;  200 var sign byte  1010 NULL xxx = bp+4
  6419                                  ;  201 var sign byte  1014 NULL len = bp-2;
  6420 00002252 C8020000                 ENTER  2,0
  6421 00002256 B80000                   mov ax, 0
  6422 00002259 8846FE                   mov [bp-2], al
  6423                                  
  6424                                  ;-1016     xxx = xxx << 3;//in reg/opcode field
  6425                                  
  6426 0000225C 8A4604                   mov al, [bp+4]
  6427 0000225F C0E003                   shl al, 3
  6428 00002262 884604                   mov [bp+4], al
  6429                                  
  6430                                  ;-1017     if (Op == REG) {
  6431                                  
  6432 00002265 A0[2D00]                 mov al, [Op]
  6433 00002268 3C02                     cmp al, 2
  6434 0000226A 0F853A00                 jne .writeEA241
  6435                                  
  6436                                  ;-1018         xxx |= 0xC0;
  6437                                  
  6438 0000226E 804E04C0                 or  byte[bp+4], 192
  6439                                  
  6440                                  ;-1019         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6441                                  
  6442 00002272 A0[2E00]                 mov al, [Op2]
  6443 00002275 3C01                     cmp al, 1
  6444 00002277 0F8F0D00                 jg  .writeEA242
  6445 0000227B 8A4604                   mov al, [bp+4]
  6446 0000227E 0206[3400]               add al, [R1No]
  6447 00002282 884604                   mov [bp+4], al
  6448                                  
  6449                                  ;-1020             else {
  6450                                  
  6451 00002285 E92000                   jmp .writeEA243
  6452                                  .writeEA242:
  6453                                  
  6454                                  ;-1021                 if (Op2 == REG) xxx = xxx + R1No;
  6455                                  
  6456 00002288 A0[2E00]                 mov al, [Op2]
  6457 0000228B 3C02                     cmp al, 2
  6458 0000228D 0F850D00                 jne .writeEA244
  6459 00002291 8A4604                   mov al, [bp+4]
  6460 00002294 0206[3400]               add al, [R1No]
  6461 00002298 884604                   mov [bp+4], al
  6462                                  
  6463                                  ;-1022                 else            xxx = xxx + R2No;
  6464                                  
  6465 0000229B E90A00                   jmp .writeEA245
  6466                                  .writeEA244:
  6467 0000229E 8A4604                   mov al, [bp+4]
  6468 000022A1 0206[3300]               add al, [R2No]
  6469 000022A5 884604                   mov [bp+4], al
  6470                                  
  6471                                  ;-1023             }
  6472                                  
  6473                                  .writeEA245:
  6474                                  
  6475                                  ;-1024         }
  6476                                  
  6477                                  .writeEA243:
  6478                                  
  6479                                  ;-1025     if (Op == MEM) {
  6480                                  
  6481                                  .writeEA241:
  6482 000022A8 A0[2D00]                 mov al, [Op]
  6483 000022AB 3C04                     cmp al, 4
  6484 000022AD 0F857300                 jne .writeEA246
  6485                                  
  6486                                  ;-1026         if (isDirect) {
  6487                                  
  6488 000022B1 A0[3C00]                 mov al, [isDirect]
  6489 000022B4 08C0                     or  al, al
  6490 000022B6 0F840D00                 je .writeEA247
  6491                                  
  6492                                  ;-1027             xxx |= 6;
  6493                                  
  6494 000022BA 804E0406                 or  byte[bp+4], 6
  6495                                  
  6496                                  ;-1028             len = 2;
  6497                                  
  6498 000022BE B80200                   mov ax, 2
  6499 000022C1 8846FE                   mov [bp-2], al
  6500                                  
  6501                                  ;-1029         }
  6502                                  
  6503                                  
  6504                                  ;-1030         else {
  6505                                  
  6506 000022C4 E95D00                   jmp .writeEA248
  6507                                  .writeEA247:
  6508                                  
  6509                                  ;-1031             xxx = xxx + rm;
  6510                                  
  6511 000022C7 8A4604                   mov al, [bp+4]
  6512 000022CA 0206[3B00]               add al, [rm]
  6513 000022CE 884604                   mov [bp+4], al
  6514                                  
  6515                                  ;-1032             if (rm == 6) {//make [BP+00]
  6516                                  
  6517 000022D1 A0[3B00]                 mov al, [rm]
  6518 000022D4 3C06                     cmp al, 6
  6519 000022D6 0F851400                 jne .writeEA249
  6520                                  
  6521                                  ;-1033                 len=1;
  6522                                  
  6523 000022DA B80100                   mov ax, 1
  6524 000022DD 8846FE                   mov [bp-2], al
  6525                                  
  6526                                  ;-1034                 if (disp == 0) xxx |= 0x40;
  6527                                  
  6528 000022E0 A1[3D00]                 mov ax, [disp]
  6529 000022E3 83F800                   cmp ax, 0
  6530 000022E6 0F850400                 jne .writeEA250
  6531 000022EA 804E0440                 or  byte[bp+4], 64
  6532                                  
  6533                                  ;-1035             }
  6534                                  
  6535                                  .writeEA250:
  6536                                  
  6537                                  ;-1036 
  6538                                  
  6539                                  
  6540                                  ;-1037             if (disp) {
  6541                                  
  6542                                  .writeEA249:
  6543 000022EE A1[3D00]                 mov ax, [disp]
  6544 000022F1 08C0                     or  al, al
  6545 000022F3 0F842D00                 je .writeEA251
  6546                                  
  6547                                  ;-1038                 ax = disp;
  6548                                  
  6549 000022F7 A1[3D00]                 mov  ax, [disp]
  6550                                  
  6551                                  ;-1039                 if(ax > 127) len=2;
  6552                                  
  6553 000022FA 83F87F                   cmp  ax, 127
  6554 000022FD 0F8E0900                 jle .writeEA252
  6555 00002301 B80200                   mov ax, 2
  6556 00002304 8846FE                   mov [bp-2], al
  6557                                  
  6558                                  ;-1040                 else len=1;
  6559                                  
  6560 00002307 E90600                   jmp .writeEA253
  6561                                  .writeEA252:
  6562 0000230A B80100                   mov ax, 1
  6563 0000230D 8846FE                   mov [bp-2], al
  6564                                  
  6565                                  ;-1041                 if (len == 1) xxx |= 0x40;
  6566                                  
  6567                                  .writeEA253:
  6568 00002310 8A46FE                   mov al, [bp-2]
  6569 00002313 3C01                     cmp al, 1
  6570 00002315 0F850700                 jne .writeEA254
  6571 00002319 804E0440                 or  byte[bp+4], 64
  6572                                  
  6573                                  ;-1042                 else xxx |= 0x80;
  6574                                  
  6575 0000231D E90400                   jmp .writeEA255
  6576                                  .writeEA254:
  6577 00002320 804E0480                 or  byte[bp+4], 128
  6578                                  
  6579                                  ;-1043             }
  6580                                  
  6581                                  .writeEA255:
  6582                                  
  6583                                  ;-1044         }
  6584                                  
  6585                                  .writeEA251:
  6586                                  
  6587                                  ;-1045     }
  6588                                  
  6589                                  .writeEA248:
  6590                                  
  6591                                  ;-1046 
  6592                                  
  6593                                  
  6594                                  ;-1047     genCode8(xxx);// gen second byte
  6595                                  
  6596                                  .writeEA246:
  6597 00002324 8A4604                   mov al, byte [bp+4]
  6598 00002327 B400                     mov ah, 0
  6599 00002329 50                       push ax
  6600 0000232A E883FE                   call genCode8
  6601 0000232D 83C402                   add  sp, 2
  6602                                  
  6603                                  ;-1048     if (len == 1) genCode8 (disp);
  6604                                  
  6605 00002330 8A46FE                   mov al, [bp-2]
  6606 00002333 3C01                     cmp al, 1
  6607 00002335 0F850A00                 jne .writeEA256
  6608 00002339 FF36[3D00]               push word [disp]
  6609 0000233D E870FE                   call genCode8
  6610 00002340 83C402                   add  sp, 2
  6611                                  
  6612                                  ;-1049     if (len == 2) genCode16(disp);
  6613                                  
  6614                                  .writeEA256:
  6615 00002343 8A46FE                   mov al, [bp-2]
  6616 00002346 3C02                     cmp al, 2
  6617 00002348 0F850A00                 jne .writeEA257
  6618 0000234C FF36[3D00]               push word [disp]
  6619 00002350 E8B4FE                   call genCode16
  6620 00002353 83C402                   add  sp, 2
  6621                                  
  6622                                  ;-1050 }
  6623                                  
  6624                                  .writeEA257:
  6625                                  
  6626                                  ;-1051 
  6627                                  
  6628                                  
  6629                                  ;-1052 int genImmediate() {
  6630 00002356 C9                       LEAVE
  6631 00002357 C3                       ret
  6632                                  ENDP
  6633                                  
  6634                                  genImmediate: PROC
  6635                                  
  6636                                  ;-1053     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6637                                  
  6638 00002358 A0[3800]                 mov al, [wflag]
  6639 0000235B 08C0                     or  al, al
  6640 0000235D 0F842300                 je .genImmediate258
  6641 00002361 A0[3700]                 mov al, [OpSize]
  6642 00002364 3C03                     cmp al, 3
  6643 00002366 0F850D00                 jne .genImmediate259
  6644 0000236A FF36[3F00]               push word [imme]
  6645 0000236E E8B7FE                   call genCode32
  6646 00002371 83C402                   add  sp, 2
  6647                                  
  6648                                  ;-1054         else genCode16(imme);
  6649                                  
  6650 00002374 E90A00                   jmp .genImmediate260
  6651                                  .genImmediate259:
  6652 00002377 FF36[3F00]               push word [imme]
  6653 0000237B E889FE                   call genCode16
  6654 0000237E 83C402                   add  sp, 2
  6655                                  
  6656                                  ;-1055     else       genCode8 (imme);
  6657                                  
  6658                                  .genImmediate260:
  6659 00002381 E90A00                   jmp .genImmediate261
  6660                                  .genImmediate258:
  6661 00002384 FF36[3F00]               push word [imme]
  6662 00002388 E825FE                   call genCode8
  6663 0000238B 83C402                   add  sp, 2
  6664                                  
  6665                                  ;-1056 }
  6666                                  
  6667                                  .genImmediate261:
  6668                                  
  6669                                  ;-1057 
  6670                                  
  6671                                  
  6672                                  ;-1058 //AS.C
  6673                                  
  6674                                  
  6675                                  ;-1059 int process() {
  6676                                  
  6677 0000238E C3                       ret
  6678                                  ENDP
  6679                                  
  6680                                  process: PROC
  6681                                  
  6682                                  ;-1060     char c;
  6683                                  
  6684                                  
  6685                                  ;-1061     int i;
  6686                                  
  6687                                  
  6688                                  ;-1062     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6689                                  
  6690                                  ;Function : process, Number of local variables: 2
  6691                                  ;   # type sign width addr used name   list of local variables
  6692                                  ;  200 var sign byte  1060 NULL c = bp-2
  6693                                  ;  201 var sign word  1061 NULL i = bp-4;
  6694 0000238F C8040000                 ENTER  4,0
  6695 00002393 B80000                   mov ax, 0
  6696 00002396 A2[3B00]                 mov byte [rm], al
  6697 00002399 A2[3800]                 mov byte [wflag], al
  6698 0000239C A2[3900]                 mov byte [dflag], al
  6699 0000239F A2[3300]                 mov byte [R2No], al
  6700 000023A2 A2[3400]                 mov byte [R1No], al
  6701 000023A5 A2[3500]                 mov byte [R2Type], al
  6702 000023A8 A2[3600]                 mov byte [R1Type], al
  6703 000023AB A2[2E00]                 mov byte [Op2], al
  6704 000023AE A2[2D00]                 mov byte [Op], al
  6705                                  
  6706                                  ;-1063     disp=imme=0;//int
  6707                                  
  6708 000023B1 B80000                   mov ax, 0
  6709 000023B4 A3[3F00]                 mov word [imme], ax
  6710 000023B7 A3[3D00]                 mov word [disp], ax
  6711                                  
  6712                                  ;-1064     isDirect=1; //set in getMeM=0, need in WriteEA
  6713                                  
  6714 000023BA B80100                   mov ax, 1
  6715 000023BD A2[3C00]                 mov byte [isDirect], al
  6716                                  
  6717                                  ;-1065     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6718                                  
  6719 000023C0 E818E7                   call getTokeType
  6720                                  
  6721                                  ;-1066     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6722                                  
  6723 000023C3 E8B1EA                   call getCodeSize
  6724 000023C6 A2[3700]                 mov byte [OpSize], al
  6725                                  
  6726                                  ;-1067     getCodes();//set: Code1, Code2, Code3
  6727                                  
  6728 000023C9 E876FD                   call getCodes
  6729                                  
  6730                                  ;-1068 
  6731                                  
  6732                                  
  6733                                  ;-1069     if (CodeType ==  1) {//1 byte opcode
  6734                                  
  6735 000023CC A0[2F00]                 mov al, [CodeType]
  6736 000023CF 3C01                     cmp al, 1
  6737 000023D1 0F850F00                 jne .process262
  6738                                  
  6739                                  ;-1070         genCode8(Code1);
  6740                                  
  6741 000023D5 A0[3000]                 mov al, byte [Code1]
  6742 000023D8 B400                     mov ah, 0
  6743 000023DA 50                       push ax
  6744 000023DB E8D2FD                   call genCode8
  6745 000023DE 83C402                   add  sp, 2
  6746                                  
  6747                                  ;-1071         return;
  6748                                  
  6749 000023E1 E9D508                   jmp .retnprocess
  6750                                  
  6751                                  ;-1072     }
  6752                                  
  6753                                  
  6754                                  ;-1073 
  6755                                  
  6756                                  
  6757                                  ;-1074     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6758                                  
  6759                                  .process262:
  6760 000023E4 A0[2F00]                 mov al, [CodeType]
  6761 000023E7 3C02                     cmp al, 2
  6762 000023E9 0F856900                 jne .process263
  6763                                  
  6764                                  ;-1075         getOpL();
  6765                                  
  6766 000023ED E816E2                   call getOpL
  6767                                  
  6768                                  ;-1076         checkOpL();
  6769                                  
  6770 000023F0 E836E1                   call checkOpL
  6771                                  
  6772                                  ;-1077         if (Code2 <= 1) {//inc,dec
  6773                                  
  6774 000023F3 A0[3100]                 mov al, [Code2]
  6775 000023F6 3C01                     cmp al, 1
  6776 000023F8 0F8F2700                 jg  .process264
  6777                                  
  6778                                  ;-1078   	        if (Op == REG) {//short
  6779                                  
  6780 000023FC A0[2D00]                 mov al, [Op]
  6781 000023FF 3C02                     cmp al, 2
  6782 00002401 0F851E00                 jne .process265
  6783                                  
  6784                                  ;-1079                 if (wflag) {genCode2(Code3, R1No); return; }
  6785                                  
  6786 00002405 A0[3800]                 mov al, [wflag]
  6787 00002408 08C0                     or  al, al
  6788 0000240A 0F841500                 je .process266
  6789 0000240E A0[3400]                 mov al, byte [R1No]
  6790 00002411 B400                     mov ah, 0
  6791 00002413 50                       push ax
  6792 00002414 A0[3200]                 mov al, byte [Code3]
  6793 00002417 B400                     mov ah, 0
  6794 00002419 50                       push ax
  6795 0000241A E85CFD                   call genCode2
  6796 0000241D 83C404                   add  sp, 4
  6797 00002420 E99608                   jmp .retnprocess
  6798                                  
  6799                                  ;-1080             }
  6800                                  
  6801                                  .process266:
  6802                                  
  6803                                  ;-1081         }
  6804                                  
  6805                                  .process265:
  6806                                  
  6807                                  ;-1082         if (Code2 == 5) {//imul extension?
  6808                                  
  6809                                  .process264:
  6810 00002423 A0[3100]                 mov al, [Code2]
  6811 00002426 3C05                     cmp al, 5
  6812 00002428 0F850F00                 jne .process267
  6813                                  
  6814                                  ;-1083             getTokeType();
  6815                                  
  6816 0000242C E8ACE6                   call getTokeType
  6817                                  
  6818                                  ;-1084             if (TokeType) implerror();
  6819                                  
  6820 0000242F A0[2C00]                 mov al, [TokeType]
  6821 00002432 08C0                     or  al, al
  6822 00002434 0F840300                 je .process268
  6823 00002438 E842F7                   call implerror
  6824                                  
  6825                                  ;-1085         }
  6826                                  
  6827                                  .process268:
  6828                                  
  6829                                  ;-1086         genCodeW(Code1);
  6830                                  
  6831                                  .process267:
  6832 0000243B A0[3000]                 mov al, byte [Code1]
  6833 0000243E B400                     mov ah, 0
  6834 00002440 50                       push ax
  6835 00002441 E850FD                   call genCodeW
  6836 00002444 83C402                   add  sp, 2
  6837                                  
  6838                                  ;-1087         writeEA(Code2);
  6839                                  
  6840 00002447 A0[3100]                 mov al, byte [Code2]
  6841 0000244A B400                     mov ah, 0
  6842 0000244C 50                       push ax
  6843 0000244D E802FE                   call writeEA
  6844 00002450 83C402                   add  sp, 2
  6845                                  
  6846                                  ;-1088         return;
  6847                                  
  6848 00002453 E96308                   jmp .retnprocess
  6849                                  
  6850                                  ;-1089     }
  6851                                  
  6852                                  
  6853                                  ;-1090 
  6854                                  
  6855                                  
  6856                                  ;-1091     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6857                                  
  6858                                  .process263:
  6859 00002456 A0[2F00]                 mov al, [CodeType]
  6860 00002459 3C03                     cmp al, 3
  6861 0000245B 0F855100                 jne .process269
  6862                                  
  6863                                  ;-1092         check2Ops();    //setwflag not applicable
  6864                                  
  6865 0000245F E849E1                   call check2Ops
  6866                                  
  6867                                  ;-1093         if (R1Type != WORD) reg16error();//only r16
  6868                                  
  6869 00002462 A0[3600]                 mov al, [R1Type]
  6870 00002465 3C02                     cmp al, 2
  6871 00002467 0F840300                 je  .process270
  6872 0000246B E8AFF7                   call reg16error
  6873                                  
  6874                                  ;-1094         if (Op2 != MEM) addrerror();//only m16
  6875                                  
  6876                                  .process270:
  6877 0000246E A0[2E00]                 mov al, [Op2]
  6878 00002471 3C04                     cmp al, 4
  6879 00002473 0F840300                 je  .process271
  6880 00002477 E8C4F6                   call addrerror
  6881                                  
  6882                                  ;-1095 
  6883                                  
  6884                                  
  6885                                  ;-1096         genCode8(Code1);//les,lds,lea
  6886                                  
  6887                                  .process271:
  6888 0000247A A0[3000]                 mov al, byte [Code1]
  6889 0000247D B400                     mov ah, 0
  6890 0000247F 50                       push ax
  6891 00002480 E82DFD                   call genCode8
  6892 00002483 83C402                   add  sp, 2
  6893                                  
  6894                                  ;-1097         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6895                                  
  6896 00002486 A0[3000]                 mov al, [Code1]
  6897 00002489 3C0F                     cmp al, 15
  6898 0000248B 0F850C00                 jne .process272
  6899 0000248F A0[3100]                 mov al, byte [Code2]
  6900 00002492 B400                     mov ah, 0
  6901 00002494 50                       push ax
  6902 00002495 E818FD                   call genCode8
  6903 00002498 83C402                   add  sp, 2
  6904                                  
  6905                                  ;-1098         Op=Op2;//set MEM for writeEA
  6906                                  
  6907                                  .process272:
  6908 0000249B A0[2E00]                 mov al, [Op2]
  6909 0000249E A2[2D00]                 mov byte [Op], al
  6910                                  
  6911                                  ;-1099         writeEA(R1No);
  6912                                  
  6913 000024A1 A0[3400]                 mov al, byte [R1No]
  6914 000024A4 B400                     mov ah, 0
  6915 000024A6 50                       push ax
  6916 000024A7 E8A8FD                   call writeEA
  6917 000024AA 83C402                   add  sp, 2
  6918                                  
  6919                                  ;-1100         return;
  6920                                  
  6921 000024AD E90908                   jmp .retnprocess
  6922                                  
  6923                                  ;-1101     }
  6924                                  
  6925                                  
  6926                                  ;-1102 
  6927                                  
  6928                                  
  6929                                  ;-1103     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6930                                  
  6931                                  .process269:
  6932 000024B0 A0[2F00]                 mov al, [CodeType]
  6933 000024B3 3C04                     cmp al, 4
  6934 000024B5 0F85EF00                 jne .process273
  6935                                  
  6936                                  ;-1104         check2Ops();
  6937                                  
  6938 000024B9 E8EFE0                   call check2Ops
  6939                                  
  6940                                  ;-1105         if (Op2 == IMM) {//second operand is imm
  6941                                  
  6942 000024BC A0[2E00]                 mov al, [Op2]
  6943 000024BF 3C01                     cmp al, 1
  6944 000024C1 0F857900                 jne .process274
  6945                                  
  6946                                  ;-1106             setsflag();
  6947                                  
  6948 000024C5 E872E4                   call setsflag
  6949                                  
  6950                                  ;-1107             if (Op == REG) {
  6951                                  
  6952 000024C8 A0[2D00]                 mov al, [Op]
  6953 000024CB 3C02                     cmp al, 2
  6954 000024CD 0F853100                 jne .process275
  6955                                  
  6956                                  ;-1108                 if (R1No == 0) {// acc,imm
  6957                                  
  6958 000024D1 A0[3400]                 mov al, [R1No]
  6959 000024D4 3C00                     cmp al, 0
  6960 000024D6 0F852800                 jne .process276
  6961                                  
  6962                                  ;-1109                     if (sflag == 0) {
  6963                                  
  6964 000024DA A0[3A00]                 mov al, [sflag]
  6965 000024DD 3C00                     cmp al, 0
  6966 000024DF 0F851F00                 jne .process277
  6967                                  
  6968                                  ;-1110                         c = Code1 << 3;
  6969                                  
  6970 000024E3 A0[3000]                 mov al, [Code1]
  6971 000024E6 C0E003                   shl al, 3
  6972 000024E9 8846FE                   mov [bp-2], al
  6973                                  
  6974                                  ;-1111                         c += 4;
  6975                                  
  6976 000024EC 8046FE04                 add  byte[bp-2], 4
  6977                                  
  6978                                  ;-1112                         genCodeW(c);
  6979                                  
  6980 000024F0 8A46FE                   mov al, byte [bp-2]
  6981 000024F3 B400                     mov ah, 0
  6982 000024F5 50                       push ax
  6983 000024F6 E89BFC                   call genCodeW
  6984 000024F9 83C402                   add  sp, 2
  6985                                  
  6986                                  ;-1113                         genImmediate();
  6987                                  
  6988 000024FC E859FE                   call genImmediate
  6989                                  
  6990                                  ;-1114                         return;
  6991                                  
  6992 000024FF E9B707                   jmp .retnprocess
  6993                                  
  6994                                  ;-1115                     }
  6995                                  
  6996                                  
  6997                                  ;-1116                 }
  6998                                  
  6999                                  .process277:
  7000                                  
  7001                                  ;-1117             }
  7002                                  
  7003                                  .process276:
  7004                                  
  7005                                  ;-1118             //r/m, imm: 80 sign-extended,TTT,imm
  7006                                  
  7007                                  
  7008                                  ;-1119             c = sflag + 0x80;
  7009                                  
  7010                                  .process275:
  7011 00002502 A0[3A00]                 mov al, [sflag]
  7012 00002505 0480                     add al, 128
  7013 00002507 8846FE                   mov [bp-2], al
  7014                                  
  7015                                  ;-1120             genCodeW(c);
  7016                                  
  7017 0000250A 8A46FE                   mov al, byte [bp-2]
  7018 0000250D B400                     mov ah, 0
  7019 0000250F 50                       push ax
  7020 00002510 E881FC                   call genCodeW
  7021 00002513 83C402                   add  sp, 2
  7022                                  
  7023                                  ;-1121             writeEA(Code1);
  7024                                  
  7025 00002516 A0[3000]                 mov al, byte [Code1]
  7026 00002519 B400                     mov ah, 0
  7027 0000251B 50                       push ax
  7028 0000251C E833FD                   call writeEA
  7029 0000251F 83C402                   add  sp, 2
  7030                                  
  7031                                  ;-1122             if (sflag) genCode8(imme);
  7032                                  
  7033 00002522 A0[3A00]                 mov al, [sflag]
  7034 00002525 08C0                     or  al, al
  7035 00002527 0F840D00                 je .process278
  7036 0000252B FF36[3F00]               push word [imme]
  7037 0000252F E87EFC                   call genCode8
  7038 00002532 83C402                   add  sp, 2
  7039                                  
  7040                                  ;-1123             else genImmediate();
  7041                                  
  7042 00002535 E90300                   jmp .process279
  7043                                  .process278:
  7044 00002538 E81DFE                   call genImmediate
  7045                                  
  7046                                  ;-1124             return;
  7047                                  
  7048                                  .process279:
  7049 0000253B E97B07                   jmp .retnprocess
  7050                                  
  7051                                  ;-1125         }
  7052                                  
  7053                                  
  7054                                  ;-1126         c = Code1 << 3;//r/m, r/r
  7055                                  
  7056                                  .process274:
  7057 0000253E A0[3000]                 mov al, [Code1]
  7058 00002541 C0E003                   shl al, 3
  7059 00002544 8846FE                   mov [bp-2], al
  7060                                  
  7061                                  ;-1127         if (Op == REG) {
  7062                                  
  7063 00002547 A0[2D00]                 mov al, [Op]
  7064 0000254A 3C02                     cmp al, 2
  7065 0000254C 0F852E00                 jne .process280
  7066                                  
  7067                                  ;-1128             if (Op2 == MEM) {//reg, mem
  7068                                  
  7069 00002550 A0[2E00]                 mov al, [Op2]
  7070 00002553 3C04                     cmp al, 4
  7071 00002555 0F852500                 jne .process281
  7072                                  
  7073                                  ;-1129                 c += 2;//add direction flag
  7074                                  
  7075 00002559 8046FE02                 add  byte[bp-2], 2
  7076                                  
  7077                                  ;-1130                 genCodeW(c);
  7078                                  
  7079 0000255D 8A46FE                   mov al, byte [bp-2]
  7080 00002560 B400                     mov ah, 0
  7081 00002562 50                       push ax
  7082 00002563 E82EFC                   call genCodeW
  7083 00002566 83C402                   add  sp, 2
  7084                                  
  7085                                  ;-1131                 Op=Op2;//set MEM for writeEA
  7086                                  
  7087 00002569 A0[2E00]                 mov al, [Op2]
  7088 0000256C A2[2D00]                 mov byte [Op], al
  7089                                  
  7090                                  ;-1132                 writeEA(R1No);
  7091                                  
  7092 0000256F A0[3400]                 mov al, byte [R1No]
  7093 00002572 B400                     mov ah, 0
  7094 00002574 50                       push ax
  7095 00002575 E8DAFC                   call writeEA
  7096 00002578 83C402                   add  sp, 2
  7097                                  
  7098                                  ;-1133                 return;
  7099                                  
  7100 0000257B E93B07                   jmp .retnprocess
  7101                                  
  7102                                  ;-1134             }
  7103                                  
  7104                                  
  7105                                  ;-1135         }
  7106                                  
  7107                                  .process281:
  7108                                  
  7109                                  ;-1136         if (Op2 == REG) {//mem,reg    reg,reg
  7110                                  
  7111                                  .process280:
  7112 0000257E A0[2E00]                 mov al, [Op2]
  7113 00002581 3C02                     cmp al, 2
  7114 00002583 0F851B00                 jne .process282
  7115                                  
  7116                                  ;-1137             genCodeW(c);
  7117                                  
  7118 00002587 8A46FE                   mov al, byte [bp-2]
  7119 0000258A B400                     mov ah, 0
  7120 0000258C 50                       push ax
  7121 0000258D E804FC                   call genCodeW
  7122 00002590 83C402                   add  sp, 2
  7123                                  
  7124                                  ;-1138             writeEA(R2No);//2. Op in reg-field
  7125                                  
  7126 00002593 A0[3300]                 mov al, byte [R2No]
  7127 00002596 B400                     mov ah, 0
  7128 00002598 50                       push ax
  7129 00002599 E8B6FC                   call writeEA
  7130 0000259C 83C402                   add  sp, 2
  7131                                  
  7132                                  ;-1139             return;
  7133                                  
  7134 0000259F E91707                   jmp .retnprocess
  7135                                  
  7136                                  ;-1140         }
  7137                                  
  7138                                  
  7139                                  ;-1141         syntaxerror();
  7140                                  
  7141                                  .process282:
  7142 000025A2 E8C7F6                   call syntaxerror
  7143                                  
  7144                                  ;-1142         return;
  7145                                  
  7146 000025A5 E91107                   jmp .retnprocess
  7147                                  
  7148                                  ;-1143     }
  7149                                  
  7150                                  
  7151                                  ;-1144 
  7152                                  
  7153                                  
  7154                                  ;-1145     if (CodeType == 5) {//mov (movsx, movzx=51)
  7155                                  
  7156                                  .process273:
  7157 000025A8 A0[2F00]                 mov al, [CodeType]
  7158 000025AB 3C05                     cmp al, 5
  7159 000025AD 0F858B01                 jne .process283
  7160                                  
  7161                                  ;-1146         check2Ops();
  7162                                  
  7163 000025B1 E8F7DF                   call check2Ops
  7164                                  
  7165                                  ;-1147 /*    prs("\n Op:"); printhex8a(Op);
  7166                                  
  7167                                  
  7168                                  ;-1148     prs(", Op2:"); printhex8a(Op2);
  7169                                  
  7170                                  
  7171                                  ;-1149     prs(", R1No:"); printhex8a(R1No);
  7172                                  
  7173                                  
  7174                                  ;-1150     prs(", R2No:"); printhex8a(R2No);   */
  7175                                  
  7176                                  
  7177                                  ;-1151         if (Op2 == ADR) {
  7178                                  
  7179 000025B4 A0[2E00]                 mov al, [Op2]
  7180 000025B7 3C03                     cmp al, 3
  7181 000025B9 0F851B00                 jne .process284
  7182                                  
  7183                                  ;-1152             if (disp) imme=disp;
  7184                                  
  7185 000025BD A1[3D00]                 mov ax, [disp]
  7186 000025C0 08C0                     or  al, al
  7187 000025C2 0F840900                 je .process285
  7188 000025C6 A1[3D00]                 mov ax, [disp]
  7189 000025C9 A3[3F00]                 mov word [imme], ax
  7190                                  
  7191                                  ;-1153             else notfounderror();
  7192                                  
  7193 000025CC E90300                   jmp .process286
  7194                                  .process285:
  7195 000025CF E837F5                   call notfounderror
  7196                                  
  7197                                  ;-1154             Op2=IMM;//continue with IMM
  7198                                  
  7199                                  .process286:
  7200 000025D2 B80100                   mov ax, 1
  7201 000025D5 A2[2E00]                 mov byte [Op2], al
  7202                                  
  7203                                  ;-1155         }
  7204                                  
  7205                                  
  7206                                  ;-1156         if (Op2 == IMM) {// r,i
  7207                                  
  7208                                  .process284:
  7209 000025D8 A0[2E00]                 mov al, [Op2]
  7210 000025DB 3C01                     cmp al, 1
  7211 000025DD 0F855400                 jne .process287
  7212                                  
  7213                                  ;-1157             if (Op == REG) {
  7214                                  
  7215 000025E1 A0[2D00]                 mov al, [Op]
  7216 000025E4 3C02                     cmp al, 2
  7217 000025E6 0F852500                 jne .process288
  7218                                  
  7219                                  ;-1158                 c = wflag << 3;
  7220                                  
  7221 000025EA A0[3800]                 mov al, [wflag]
  7222 000025ED C0E003                   shl al, 3
  7223 000025F0 8846FE                   mov [bp-2], al
  7224                                  
  7225                                  ;-1159                 c += 0xB0;
  7226                                  
  7227 000025F3 8046FEB0                 add  byte[bp-2], 176
  7228                                  
  7229                                  ;-1160                 genCode2(c, R1No);
  7230                                  
  7231 000025F7 A0[3400]                 mov al, byte [R1No]
  7232 000025FA B400                     mov ah, 0
  7233 000025FC 50                       push ax
  7234 000025FD 8A46FE                   mov al, byte [bp-2]
  7235 00002600 B400                     mov ah, 0
  7236 00002602 50                       push ax
  7237 00002603 E873FB                   call genCode2
  7238 00002606 83C404                   add  sp, 4
  7239                                  
  7240                                  ;-1161                 genImmediate();
  7241                                  
  7242 00002609 E84CFD                   call genImmediate
  7243                                  
  7244                                  ;-1162                 return;
  7245                                  
  7246 0000260C E9AA06                   jmp .retnprocess
  7247                                  
  7248                                  ;-1163             }
  7249                                  
  7250                                  
  7251                                  ;-1164             if (Op == MEM) {// m,i
  7252                                  
  7253                                  .process288:
  7254 0000260F A0[2D00]                 mov al, [Op]
  7255 00002612 3C04                     cmp al, 4
  7256 00002614 0F851700                 jne .process289
  7257                                  
  7258                                  ;-1165                 genCodeW(0xC6);
  7259                                  
  7260 00002618 68C600                   push 198
  7261 0000261B E876FB                   call genCodeW
  7262 0000261E 83C402                   add  sp, 2
  7263                                  
  7264                                  ;-1166                 writeEA( 0 );
  7265                                  
  7266 00002621 6A00                     push 0
  7267 00002623 E82CFC                   call writeEA
  7268 00002626 83C402                   add  sp, 2
  7269                                  
  7270                                  ;-1167                 genImmediate();
  7271                                  
  7272 00002629 E82CFD                   call genImmediate
  7273                                  
  7274                                  ;-1168                 return;
  7275                                  
  7276 0000262C E98A06                   jmp .retnprocess
  7277                                  
  7278                                  ;-1169             }
  7279                                  
  7280                                  
  7281                                  ;-1170             regmemerror();
  7282                                  
  7283                                  .process289:
  7284 0000262F E8C1F5                   call regmemerror
  7285                                  
  7286                                  ;-1171             return;
  7287                                  
  7288 00002632 E98406                   jmp .retnprocess
  7289                                  
  7290                                  ;-1172         }
  7291                                  
  7292                                  
  7293                                  ;-1173         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7294                                  
  7295                                  .process287:
  7296 00002635 A0[3600]                 mov al, [R1Type]
  7297 00002638 3C04                     cmp al, 4
  7298 0000263A 0F850300                 jne .process290
  7299 0000263E E8A6DE                   call ChangeDirection
  7300                                  
  7301                                  ;-1174         if (R2Type == SEGREG) {//rm,sreg
  7302                                  
  7303                                  .process290:
  7304 00002641 A0[3500]                 mov al, [R2Type]
  7305 00002644 3C04                     cmp al, 4
  7306 00002646 0F852A00                 jne .process291
  7307                                  
  7308                                  ;-1175             if (OpSize != WORD) reg16error();
  7309                                  
  7310 0000264A A0[3700]                 mov al, [OpSize]
  7311 0000264D 3C02                     cmp al, 2
  7312 0000264F 0F840300                 je  .process292
  7313 00002653 E8C7F5                   call reg16error
  7314                                  
  7315                                  ;-1176                 genCode2(0x8C, dflag);
  7316                                  
  7317                                  .process292:
  7318 00002656 A0[3900]                 mov al, byte [dflag]
  7319 00002659 B400                     mov ah, 0
  7320 0000265B 50                       push ax
  7321 0000265C 688C00                   push 140
  7322 0000265F E817FB                   call genCode2
  7323 00002662 83C404                   add  sp, 4
  7324                                  
  7325                                  ;-1177                 writeEA(R2No);
  7326                                  
  7327 00002665 A0[3300]                 mov al, byte [R2No]
  7328 00002668 B400                     mov ah, 0
  7329 0000266A 50                       push ax
  7330 0000266B E8E4FB                   call writeEA
  7331 0000266E 83C402                   add  sp, 2
  7332                                  
  7333                                  ;-1178                 return;
  7334                                  
  7335 00002671 E94506                   jmp .retnprocess
  7336                                  
  7337                                  ;-1179         }
  7338                                  
  7339                                  
  7340                                  ;-1180         if (Op2 == MEM) {//acc, moffs16
  7341                                  
  7342                                  .process291:
  7343 00002674 A0[2E00]                 mov al, [Op2]
  7344 00002677 3C04                     cmp al, 4
  7345 00002679 0F853100                 jne .process293
  7346                                  
  7347                                  ;-1181             if (Op == REG) {
  7348                                  
  7349 0000267D A0[2D00]                 mov al, [Op]
  7350 00002680 3C02                     cmp al, 2
  7351 00002682 0F852800                 jne .process294
  7352                                  
  7353                                  ;-1182                 if (R1No == 0) {
  7354                                  
  7355 00002686 A0[3400]                 mov al, [R1No]
  7356 00002689 3C00                     cmp al, 0
  7357 0000268B 0F851F00                 jne .process295
  7358                                  
  7359                                  ;-1183                     if (isDirect) {
  7360                                  
  7361 0000268F A0[3C00]                 mov al, [isDirect]
  7362 00002692 08C0                     or  al, al
  7363 00002694 0F841600                 je .process296
  7364                                  
  7365                                  ;-1184                         genCodeW(0xA0);
  7366                                  
  7367 00002698 68A000                   push 160
  7368 0000269B E8F6FA                   call genCodeW
  7369 0000269E 83C402                   add  sp, 2
  7370                                  
  7371                                  ;-1185                         genCode16(disp);
  7372                                  
  7373 000026A1 FF36[3D00]               push word [disp]
  7374 000026A5 E85FFB                   call genCode16
  7375 000026A8 83C402                   add  sp, 2
  7376                                  
  7377                                  ;-1186                         return;
  7378                                  
  7379 000026AB E90B06                   jmp .retnprocess
  7380                                  
  7381                                  ;-1187                     }
  7382                                  
  7383                                  
  7384                                  ;-1188                 }
  7385                                  
  7386                                  .process296:
  7387                                  
  7388                                  ;-1189             }
  7389                                  
  7390                                  .process295:
  7391                                  
  7392                                  ;-1190         }
  7393                                  
  7394                                  .process294:
  7395                                  
  7396                                  ;-1191         if (Op == MEM) {//moffs16, acc
  7397                                  
  7398                                  .process293:
  7399 000026AE A0[2D00]                 mov al, [Op]
  7400 000026B1 3C04                     cmp al, 4
  7401 000026B3 0F853100                 jne .process297
  7402                                  
  7403                                  ;-1192             if (Op2 == REG) {
  7404                                  
  7405 000026B7 A0[2E00]                 mov al, [Op2]
  7406 000026BA 3C02                     cmp al, 2
  7407 000026BC 0F852800                 jne .process298
  7408                                  
  7409                                  ;-1193                 if (R2No == 0) {
  7410                                  
  7411 000026C0 A0[3300]                 mov al, [R2No]
  7412 000026C3 3C00                     cmp al, 0
  7413 000026C5 0F851F00                 jne .process299
  7414                                  
  7415                                  ;-1194                     if (isDirect) {
  7416                                  
  7417 000026C9 A0[3C00]                 mov al, [isDirect]
  7418 000026CC 08C0                     or  al, al
  7419 000026CE 0F841600                 je .process300
  7420                                  
  7421                                  ;-1195                         genCodeW(0xA2);
  7422                                  
  7423 000026D2 68A200                   push 162
  7424 000026D5 E8BCFA                   call genCodeW
  7425 000026D8 83C402                   add  sp, 2
  7426                                  
  7427                                  ;-1196                         genCode16(disp);
  7428                                  
  7429 000026DB FF36[3D00]               push word [disp]
  7430 000026DF E825FB                   call genCode16
  7431 000026E2 83C402                   add  sp, 2
  7432                                  
  7433                                  ;-1197                         return;
  7434                                  
  7435 000026E5 E9D105                   jmp .retnprocess
  7436                                  
  7437                                  ;-1198                     }
  7438                                  
  7439                                  
  7440                                  ;-1199                 }
  7441                                  
  7442                                  .process300:
  7443                                  
  7444                                  ;-1200             }
  7445                                  
  7446                                  .process299:
  7447                                  
  7448                                  ;-1201 
  7449                                  
  7450                                  
  7451                                  ;-1202         }
  7452                                  
  7453                                  .process298:
  7454                                  
  7455                                  ;-1203         if (Op2 == REG) {//rm, r
  7456                                  
  7457                                  .process297:
  7458 000026E8 A0[2E00]                 mov al, [Op2]
  7459 000026EB 3C02                     cmp al, 2
  7460 000026ED 0F851800                 jne .process301
  7461                                  
  7462                                  ;-1204             genCodeW(0x88);
  7463                                  
  7464 000026F1 688800                   push 136
  7465 000026F4 E89DFA                   call genCodeW
  7466 000026F7 83C402                   add  sp, 2
  7467                                  
  7468                                  ;-1205             writeEA(R2No);
  7469                                  
  7470 000026FA A0[3300]                 mov al, byte [R2No]
  7471 000026FD B400                     mov ah, 0
  7472 000026FF 50                       push ax
  7473 00002700 E84FFB                   call writeEA
  7474 00002703 83C402                   add  sp, 2
  7475                                  
  7476                                  ;-1206             return;
  7477                                  
  7478 00002706 E9B005                   jmp .retnprocess
  7479                                  
  7480                                  ;-1207         }
  7481                                  
  7482                                  
  7483                                  ;-1208         if (Op2 == MEM) {//r, m
  7484                                  
  7485                                  .process301:
  7486 00002709 A0[2E00]                 mov al, [Op2]
  7487 0000270C 3C04                     cmp al, 4
  7488 0000270E 0F852400                 jne .process302
  7489                                  
  7490                                  ;-1209             if (Op == REG) {
  7491                                  
  7492 00002712 A0[2D00]                 mov al, [Op]
  7493 00002715 3C02                     cmp al, 2
  7494 00002717 0F851B00                 jne .process303
  7495                                  
  7496                                  ;-1210                 ChangeDirection();
  7497                                  
  7498 0000271B E8C9DD                   call ChangeDirection
  7499                                  
  7500                                  ;-1211                 genCodeW(0x8A);
  7501                                  
  7502 0000271E 688A00                   push 138
  7503 00002721 E870FA                   call genCodeW
  7504 00002724 83C402                   add  sp, 2
  7505                                  
  7506                                  ;-1212                 writeEA(R2No);
  7507                                  
  7508 00002727 A0[3300]                 mov al, byte [R2No]
  7509 0000272A B400                     mov ah, 0
  7510 0000272C 50                       push ax
  7511 0000272D E822FB                   call writeEA
  7512 00002730 83C402                   add  sp, 2
  7513                                  
  7514                                  ;-1213                 return;
  7515                                  
  7516 00002733 E98305                   jmp .retnprocess
  7517                                  
  7518                                  ;-1214             }
  7519                                  
  7520                                  
  7521                                  ;-1215         }
  7522                                  
  7523                                  .process303:
  7524                                  
  7525                                  ;-1216         syntaxerror();
  7526                                  
  7527                                  .process302:
  7528 00002736 E833F5                   call syntaxerror
  7529                                  
  7530                                  ;-1217         return;
  7531                                  
  7532 00002739 E97D05                   jmp .retnprocess
  7533                                  
  7534                                  ;-1218     }
  7535                                  
  7536                                  
  7537                                  ;-1219 
  7538                                  
  7539                                  
  7540                                  ;-1220     if (CodeType == 6) {//Jcc
  7541                                  
  7542                                  .process283:
  7543 0000273C A0[2F00]                 mov al, [CodeType]
  7544 0000273F 3C06                     cmp al, 6
  7545 00002741 0F85BE00                 jne .process304
  7546                                  
  7547                                  ;-1221         if (TokeType == ALNUME) {
  7548                                  
  7549 00002745 A0[2C00]                 mov al, [TokeType]
  7550 00002748 3C03                     cmp al, 3
  7551 0000274A 0F85B500                 jne .process305
  7552                                  
  7553                                  ;-1222             LabelIx=searchLabel();
  7554                                  
  7555 0000274E E839E5                   call searchLabel
  7556 00002751 A3[4E00]                 mov word [LabelIx], ax
  7557                                  
  7558                                  ;-1223             if (LabelIx > 0) {
  7559                                  
  7560 00002754 A1[4E00]                 mov ax, [LabelIx]
  7561 00002757 83F800                   cmp ax, 0
  7562 0000275A 0F8E7A00                 jle .process306
  7563                                  
  7564                                  ;-1224                 disp=LabelAddr[LabelIx];
  7565                                  
  7566 0000275E 8B1E[4E00]               mov bx, [LabelIx]
  7567 00002762 D1E3                     shl bx, 1
  7568 00002764 8B87CA8E                 mov ax, [LabelAddr + bx]
  7569 00002768 A3[3D00]                 mov word [disp], ax
  7570                                  
  7571                                  ;-1225                 disp = disp - PC;
  7572                                  
  7573 0000276B A1[3D00]                 mov ax, [disp]
  7574 0000276E 2B06[2300]               sub ax, [PC]
  7575 00002772 A3[3D00]                 mov word [disp], ax
  7576                                  
  7577                                  ;-1226                 disp = disp - Origin;
  7578                                  
  7579 00002775 A1[3D00]                 mov ax, [disp]
  7580 00002778 2B06[2500]               sub ax, [Origin]
  7581 0000277C A3[3D00]                 mov word [disp], ax
  7582                                  
  7583                                  ;-1227                 if (checkConstSize(disp) ) {
  7584                                  
  7585 0000277F FF36[3D00]               push word [disp]
  7586 00002783 E810E2                   call checkConstSize
  7587 00002786 83C402                   add  sp, 2
  7588 00002789 08C0                     or  al, al
  7589 0000278B 0F842000                 je .process307
  7590                                  
  7591                                  ;-1228                     genCode2(Code1, 0x70);//short
  7592                                  
  7593 0000278F 6A70                     push 112
  7594 00002791 A0[3000]                 mov al, byte [Code1]
  7595 00002794 B400                     mov ah, 0
  7596 00002796 50                       push ax
  7597 00002797 E8DFF9                   call genCode2
  7598 0000279A 83C404                   add  sp, 4
  7599                                  
  7600                                  ;-1229                     disp -= 2;
  7601                                  
  7602 0000279D 832E[3D00]02             sub  word[disp], 2
  7603                                  
  7604                                  ;-1230                     genCode8(disp);
  7605                                  
  7606 000027A2 FF36[3D00]               push word [disp]
  7607 000027A6 E807FA                   call genCode8
  7608 000027A9 83C402                   add  sp, 2
  7609                                  
  7610                                  ;-1231                 } else {
  7611                                  
  7612 000027AC E92600                   jmp .process308
  7613                                  .process307:
  7614                                  
  7615                                  ;-1232                     genCode8(0x0F);
  7616                                  
  7617 000027AF 6A0F                     push 15
  7618 000027B1 E8FCF9                   call genCode8
  7619 000027B4 83C402                   add  sp, 2
  7620                                  
  7621                                  ;-1233                     genCode2(Code1, 0x80);//near
  7622                                  
  7623 000027B7 688000                   push 128
  7624 000027BA A0[3000]                 mov al, byte [Code1]
  7625 000027BD B400                     mov ah, 0
  7626 000027BF 50                       push ax
  7627 000027C0 E8B6F9                   call genCode2
  7628 000027C3 83C404                   add  sp, 4
  7629                                  
  7630                                  ;-1234                     disp -= 4;
  7631                                  
  7632 000027C6 832E[3D00]04             sub  word[disp], 4
  7633                                  
  7634                                  ;-1235                     genCode16(disp);
  7635                                  
  7636 000027CB FF36[3D00]               push word [disp]
  7637 000027CF E835FA                   call genCode16
  7638 000027D2 83C402                   add  sp, 2
  7639                                  
  7640                                  ;-1236                 }
  7641                                  
  7642                                  
  7643                                  ;-1237             }
  7644                                  
  7645                                  .process308:
  7646                                  
  7647                                  ;-1238             else {//jump forward, near only
  7648                                  
  7649 000027D5 E92800                   jmp .process309
  7650                                  .process306:
  7651                                  
  7652                                  ;-1239                 genCode8(0x0F);
  7653                                  
  7654 000027D8 6A0F                     push 15
  7655 000027DA E8D3F9                   call genCode8
  7656 000027DD 83C402                   add  sp, 2
  7657                                  
  7658                                  ;-1240                 genCode2(Code1, 0x80);
  7659                                  
  7660 000027E0 688000                   push 128
  7661 000027E3 A0[3000]                 mov al, byte [Code1]
  7662 000027E6 B400                     mov ah, 0
  7663 000027E8 50                       push ax
  7664 000027E9 E88DF9                   call genCode2
  7665 000027EC 83C404                   add  sp, 4
  7666                                  
  7667                                  ;-1241                 storeJmp();
  7668                                  
  7669 000027EF E875E3                   call storeJmp
  7670                                  
  7671                                  ;-1242                 genCode16(0);
  7672                                  
  7673 000027F2 6A00                     push 0
  7674 000027F4 E810FA                   call genCode16
  7675 000027F7 83C402                   add  sp, 2
  7676                                  
  7677                                  ;-1243                 PrintRA='r';
  7678                                  
  7679 000027FA B87200                   mov ax, 114
  7680 000027FD A2[4500]                 mov byte [PrintRA], al
  7681                                  
  7682                                  ;-1244             }
  7683                                  
  7684                                  
  7685                                  ;-1245         return;
  7686                                  
  7687                                  .process309:
  7688 00002800 E9B604                   jmp .retnprocess
  7689                                  
  7690                                  ;-1246         }
  7691                                  
  7692                                  
  7693                                  ;-1247     }
  7694                                  
  7695                                  .process305:
  7696                                  
  7697                                  ;-1248 
  7698                                  
  7699                                  
  7700                                  ;-1249     if (CodeType == 7) {//jmp, call
  7701                                  
  7702                                  .process304:
  7703 00002803 A0[2F00]                 mov al, [CodeType]
  7704 00002806 3C07                     cmp al, 7
  7705 00002808 0F85CA00                 jne .process310
  7706                                  
  7707                                  ;-1250         if (TokeType == ALNUME) {
  7708                                  
  7709 0000280C A0[2C00]                 mov al, [TokeType]
  7710 0000280F 3C03                     cmp al, 3
  7711 00002811 0F85C100                 jne .process311
  7712                                  
  7713                                  ;-1251             LabelIx=searchLabel();
  7714                                  
  7715 00002815 E872E4                   call searchLabel
  7716 00002818 A3[4E00]                 mov word [LabelIx], ax
  7717                                  
  7718                                  ;-1252             if (LabelIx > 0) {
  7719                                  
  7720 0000281B A1[4E00]                 mov ax, [LabelIx]
  7721 0000281E 83F800                   cmp ax, 0
  7722 00002821 0F8E9100                 jle .process312
  7723                                  
  7724                                  ;-1253                 disp=LabelAddr[LabelIx];
  7725                                  
  7726 00002825 8B1E[4E00]               mov bx, [LabelIx]
  7727 00002829 D1E3                     shl bx, 1
  7728 0000282B 8B87CA8E                 mov ax, [LabelAddr + bx]
  7729 0000282F A3[3D00]                 mov word [disp], ax
  7730                                  
  7731                                  ;-1254                 disp = disp - PC;
  7732                                  
  7733 00002832 A1[3D00]                 mov ax, [disp]
  7734 00002835 2B06[2300]               sub ax, [PC]
  7735 00002839 A3[3D00]                 mov word [disp], ax
  7736                                  
  7737                                  ;-1255                 disp = disp - Origin;
  7738                                  
  7739 0000283C A1[3D00]                 mov ax, [disp]
  7740 0000283F 2B06[2500]               sub ax, [Origin]
  7741 00002843 A3[3D00]                 mov word [disp], ax
  7742                                  
  7743                                  ;-1256                 if (checkConstSize(disp) ) {
  7744                                  
  7745 00002846 FF36[3D00]               push word [disp]
  7746 0000284A E849E1                   call checkConstSize
  7747 0000284D 83C402                   add  sp, 2
  7748 00002850 08C0                     or  al, al
  7749 00002852 0F844200                 je .process313
  7750                                  
  7751                                  ;-1257                     if (Code1 == 0xE9) {//jmp only
  7752                                  
  7753 00002856 A0[3000]                 mov al, [Code1]
  7754 00002859 3CE9                     cmp al, 233
  7755 0000285B 0F851B00                 jne .process314
  7756                                  
  7757                                  ;-1258                         genCode8(0xEB);//short
  7758                                  
  7759 0000285F 68EB00                   push 235
  7760 00002862 E84BF9                   call genCode8
  7761 00002865 83C402                   add  sp, 2
  7762                                  
  7763                                  ;-1259                         disp -= 2;
  7764                                  
  7765 00002868 832E[3D00]02             sub  word[disp], 2
  7766                                  
  7767                                  ;-1260                         genCode8(disp);
  7768                                  
  7769 0000286D FF36[3D00]               push word [disp]
  7770 00002871 E83CF9                   call genCode8
  7771 00002874 83C402                   add  sp, 2
  7772                                  
  7773                                  ;-1261                     }
  7774                                  
  7775                                  
  7776                                  ;-1262                     else {
  7777                                  
  7778 00002877 E91B00                   jmp .process315
  7779                                  .process314:
  7780                                  
  7781                                  ;-1263                         genCode8(Code1);//near
  7782                                  
  7783 0000287A A0[3000]                 mov al, byte [Code1]
  7784 0000287D B400                     mov ah, 0
  7785 0000287F 50                       push ax
  7786 00002880 E82DF9                   call genCode8
  7787 00002883 83C402                   add  sp, 2
  7788                                  
  7789                                  ;-1264                         disp -= 3;
  7790                                  
  7791 00002886 832E[3D00]03             sub  word[disp], 3
  7792                                  
  7793                                  ;-1265                         genCode16(disp);
  7794                                  
  7795 0000288B FF36[3D00]               push word [disp]
  7796 0000288F E875F9                   call genCode16
  7797 00002892 83C402                   add  sp, 2
  7798                                  
  7799                                  ;-1266                     }
  7800                                  
  7801                                  
  7802                                  ;-1267                 }
  7803                                  
  7804                                  .process315:
  7805                                  
  7806                                  ;-1268                 else {
  7807                                  
  7808 00002895 E91B00                   jmp .process316
  7809                                  .process313:
  7810                                  
  7811                                  ;-1269                     genCode8(Code1);//near
  7812                                  
  7813 00002898 A0[3000]                 mov al, byte [Code1]
  7814 0000289B B400                     mov ah, 0
  7815 0000289D 50                       push ax
  7816 0000289E E80FF9                   call genCode8
  7817 000028A1 83C402                   add  sp, 2
  7818                                  
  7819                                  ;-1270                     disp -= 3;
  7820                                  
  7821 000028A4 832E[3D00]03             sub  word[disp], 3
  7822                                  
  7823                                  ;-1271                     genCode16(disp);
  7824                                  
  7825 000028A9 FF36[3D00]               push word [disp]
  7826 000028AD E857F9                   call genCode16
  7827 000028B0 83C402                   add  sp, 2
  7828                                  
  7829                                  ;-1272                 }
  7830                                  
  7831                                  
  7832                                  ;-1273             }
  7833                                  
  7834                                  .process316:
  7835                                  
  7836                                  ;-1274             else {//jump forward, near only
  7837                                  
  7838 000028B3 E91D00                   jmp .process317
  7839                                  .process312:
  7840                                  
  7841                                  ;-1275                 genCode8(Code1);
  7842                                  
  7843 000028B6 A0[3000]                 mov al, byte [Code1]
  7844 000028B9 B400                     mov ah, 0
  7845 000028BB 50                       push ax
  7846 000028BC E8F1F8                   call genCode8
  7847 000028BF 83C402                   add  sp, 2
  7848                                  
  7849                                  ;-1276                 storeJmp();
  7850                                  
  7851 000028C2 E8A2E2                   call storeJmp
  7852                                  
  7853                                  ;-1277                 genCode16(0);
  7854                                  
  7855 000028C5 6A00                     push 0
  7856 000028C7 E83DF9                   call genCode16
  7857 000028CA 83C402                   add  sp, 2
  7858                                  
  7859                                  ;-1278                 PrintRA='R';
  7860                                  
  7861 000028CD B85200                   mov ax, 82
  7862 000028D0 A2[4500]                 mov byte [PrintRA], al
  7863                                  
  7864                                  ;-1279             }
  7865                                  
  7866                                  
  7867                                  ;-1280         return;
  7868                                  
  7869                                  .process317:
  7870 000028D3 E9E303                   jmp .retnprocess
  7871                                  
  7872                                  ;-1281         }
  7873                                  
  7874                                  
  7875                                  ;-1282     }
  7876                                  
  7877                                  .process311:
  7878                                  
  7879                                  ;-1283 
  7880                                  
  7881                                  
  7882                                  ;-1284     if (CodeType ==  8) {//ret,retf
  7883                                  
  7884                                  .process310:
  7885 000028D6 A0[2F00]                 mov al, [CodeType]
  7886 000028D9 3C08                     cmp al, 8
  7887 000028DB 0F853100                 jne .process318
  7888                                  
  7889                                  ;-1285         if (TokeType == DIGIT) {
  7890                                  
  7891 000028DF A0[2C00]                 mov al, [TokeType]
  7892 000028E2 3C01                     cmp al, 1
  7893 000028E4 0F851900                 jne .process319
  7894                                  
  7895                                  ;-1286             genCode8(Code2);
  7896                                  
  7897 000028E8 A0[3100]                 mov al, byte [Code2]
  7898 000028EB B400                     mov ah, 0
  7899 000028ED 50                       push ax
  7900 000028EE E8BFF8                   call genCode8
  7901 000028F1 83C402                   add  sp, 2
  7902                                  
  7903                                  ;-1287             genCode16(SymbolInt);
  7904                                  
  7905 000028F4 FF36[0E00]               push word [SymbolInt]
  7906 000028F8 E80CF9                   call genCode16
  7907 000028FB 83C402                   add  sp, 2
  7908                                  
  7909                                  ;-1288             return;
  7910                                  
  7911 000028FE E9B803                   jmp .retnprocess
  7912                                  
  7913                                  ;-1289         }
  7914                                  
  7915                                  
  7916                                  ;-1290         genCode8(Code1);
  7917                                  
  7918                                  .process319:
  7919 00002901 A0[3000]                 mov al, byte [Code1]
  7920 00002904 B400                     mov ah, 0
  7921 00002906 50                       push ax
  7922 00002907 E8A6F8                   call genCode8
  7923 0000290A 83C402                   add  sp, 2
  7924                                  
  7925                                  ;-1291         return;
  7926                                  
  7927 0000290D E9A903                   jmp .retnprocess
  7928                                  
  7929                                  ;-1292     }
  7930                                  
  7931                                  
  7932                                  ;-1293 
  7933                                  
  7934                                  
  7935                                  ;-1294     if (CodeType == 9) {//push, pop
  7936                                  
  7937                                  .process318:
  7938 00002910 A0[2F00]                 mov al, [CodeType]
  7939 00002913 3C09                     cmp al, 9
  7940 00002915 0F854A01                 jne .process320
  7941                                  
  7942                                  ;-1295         getOpL();
  7943                                  
  7944 00002919 E8EADC                   call getOpL
  7945                                  
  7946                                  ;-1296         if (Code1 == 0x50) {//push only
  7947                                  
  7948 0000291C A0[3000]                 mov al, [Code1]
  7949 0000291F 3C50                     cmp al, 80
  7950 00002921 0F858400                 jne .process321
  7951                                  
  7952                                  ;-1297             if (Op == IMM) {//push imm8,16
  7953                                  
  7954 00002925 A0[2D00]                 mov al, [Op]
  7955 00002928 3C01                     cmp al, 1
  7956 0000292A 0F853400                 jne .process322
  7957                                  
  7958                                  ;-1298                 setsflag();
  7959                                  
  7960 0000292E E809E0                   call setsflag
  7961                                  
  7962                                  ;-1299                 genCode2(0x68, sflag);
  7963                                  
  7964 00002931 A0[3A00]                 mov al, byte [sflag]
  7965 00002934 B400                     mov ah, 0
  7966 00002936 50                       push ax
  7967 00002937 6A68                     push 104
  7968 00002939 E83DF8                   call genCode2
  7969 0000293C 83C404                   add  sp, 4
  7970                                  
  7971                                  ;-1300                 if (sflag) genCode8 (imme);
  7972                                  
  7973 0000293F A0[3A00]                 mov al, [sflag]
  7974 00002942 08C0                     or  al, al
  7975 00002944 0F840D00                 je .process323
  7976 00002948 FF36[3F00]               push word [imme]
  7977 0000294C E861F8                   call genCode8
  7978 0000294F 83C402                   add  sp, 2
  7979                                  
  7980                                  ;-1301                 else       genCode16(imme);
  7981                                  
  7982 00002952 E90A00                   jmp .process324
  7983                                  .process323:
  7984 00002955 FF36[3F00]               push word [imme]
  7985 00002959 E8ABF8                   call genCode16
  7986 0000295C 83C402                   add  sp, 2
  7987                                  
  7988                                  ;-1302                 return;
  7989                                  
  7990                                  .process324:
  7991 0000295F E95703                   jmp .retnprocess
  7992                                  
  7993                                  ;-1303             }
  7994                                  
  7995                                  
  7996                                  ;-1304             if (Op == ADR) {//push string ABSOLUTE i16 
  7997                                  
  7998                                  .process322:
  7999 00002962 A0[2D00]                 mov al, [Op]
  8000 00002965 3C03                     cmp al, 3
  8001 00002967 0F853E00                 jne .process325
  8002                                  
  8003                                  ;-1305 //prscomment("\n push disp: "); printhex16 (disp);
  8004                                  
  8005                                  
  8006                                  ;-1306                 if (disp) {
  8007                                  
  8008 0000296B A1[3D00]                 mov ax, [disp]
  8009 0000296E 08C0                     or  al, al
  8010 00002970 0F841800                 je .process326
  8011                                  
  8012                                  ;-1307                     genCode8(0x68);
  8013                                  
  8014 00002974 6A68                     push 104
  8015 00002976 E837F8                   call genCode8
  8016 00002979 83C402                   add  sp, 2
  8017                                  
  8018                                  ;-1308                     genCode16(disp);
  8019                                  
  8020 0000297C FF36[3D00]               push word [disp]
  8021 00002980 E884F8                   call genCode16
  8022 00002983 83C402                   add  sp, 2
  8023                                  
  8024                                  ;-1309                     return;
  8025                                  
  8026 00002986 E93003                   jmp .retnprocess
  8027                                  
  8028                                  ;-1310                 }
  8029                                  
  8030                                  
  8031                                  ;-1311                 else {
  8032                                  
  8033 00002989 E91D00                   jmp .process327
  8034                                  .process326:
  8035                                  
  8036                                  ;-1312                     genCode8(0x68);
  8037                                  
  8038 0000298C 6A68                     push 104
  8039 0000298E E81FF8                   call genCode8
  8040 00002991 83C402                   add  sp, 2
  8041                                  
  8042                                  ;-1313                     storeJmp();
  8043                                  
  8044 00002994 E8D0E1                   call storeJmp
  8045                                  
  8046                                  ;-1314                     genCode16(0xAAAA);//magic for abs ADR
  8047                                  
  8048 00002997 68AAAA                   push 43690
  8049 0000299A E86AF8                   call genCode16
  8050 0000299D 83C402                   add  sp, 2
  8051                                  
  8052                                  ;-1315                     PrintRA='A';
  8053                                  
  8054 000029A0 B84100                   mov ax, 65
  8055 000029A3 A2[4500]                 mov byte [PrintRA], al
  8056                                  
  8057                                  ;-1316                     return;
  8058                                  
  8059 000029A6 E91003                   jmp .retnprocess
  8060                                  
  8061                                  ;-1317                 }
  8062                                  
  8063                                  
  8064                                  ;-1318             }
  8065                                  
  8066                                  .process327:
  8067                                  
  8068                                  ;-1319         }
  8069                                  
  8070                                  .process325:
  8071                                  
  8072                                  ;-1320         if (R1Type == SEGREG) {
  8073                                  
  8074                                  .process321:
  8075 000029A9 A0[3600]                 mov al, [R1Type]
  8076 000029AC 3C04                     cmp al, 4
  8077 000029AE 0F855A00                 jne .process328
  8078                                  
  8079                                  ;-1321             if (Code1 == 0x58) {//pop only
  8080                                  
  8081 000029B2 A0[3000]                 mov al, [Code1]
  8082 000029B5 3C58                     cmp al, 88
  8083 000029B7 0F851200                 jne .process329
  8084                                  
  8085                                  ;-1322                 if (R1No == 1) error1("pop cs not allowed");
  8086                                  
  8087 000029BB A0[3400]                 mov al, [R1No]
  8088 000029BE 3C01                     cmp al, 1
  8089 000029C0 0F850900                 jne .process330
  8090 000029C4 68[BB2C]                 push process_0
  8091 000029C7 E8CFF0                   call error1
  8092 000029CA 83C402                   add  sp, 2
  8093                                  
  8094                                  ;-1323             }
  8095                                  
  8096                                  .process330:
  8097                                  
  8098                                  ;-1324             c = R1No <<3;
  8099                                  
  8100                                  .process329:
  8101 000029CD A0[3400]                 mov al, [R1No]
  8102 000029D0 C0E003                   shl al, 3
  8103 000029D3 8846FE                   mov [bp-2], al
  8104                                  
  8105                                  ;-1325             if (R1No > 3) {//FS, GS
  8106                                  
  8107 000029D6 A0[3400]                 mov al, [R1No]
  8108 000029D9 3C03                     cmp al, 3
  8109 000029DB 0F8E0C00                 jle .process331
  8110                                  
  8111                                  ;-1326                 c += 122;
  8112                                  
  8113 000029DF 8046FE7A                 add  byte[bp-2], 122
  8114                                  
  8115                                  ;-1327                 genCode8(0x0F);
  8116                                  
  8117 000029E3 6A0F                     push 15
  8118 000029E5 E8C8F7                   call genCode8
  8119 000029E8 83C402                   add  sp, 2
  8120                                  
  8121                                  ;-1328             }
  8122                                  
  8123                                  
  8124                                  ;-1329             OpCodePtr++;
  8125                                  
  8126                                  .process331:
  8127 000029EB FF06[4300]               inc  word[OpCodePtr]
  8128                                  
  8129                                  ;-1330             c = c + *OpCodePtr;////////////////is Code4
  8130                                  
  8131 000029EF 8A46FE                   mov al, [bp-2]
  8132 000029F2 8B1E[4300]               mov bx, [OpCodePtr]
  8133 000029F6 0207                     add al, [bx]
  8134 000029F8 B400                     mov ah, 0
  8135 000029FA 8846FE                   mov [bp-2], al
  8136                                  
  8137                                  ;-1331             genCode8(c);
  8138                                  
  8139 000029FD 8A46FE                   mov al, byte [bp-2]
  8140 00002A00 B400                     mov ah, 0
  8141 00002A02 50                       push ax
  8142 00002A03 E8AAF7                   call genCode8
  8143 00002A06 83C402                   add  sp, 2
  8144                                  
  8145                                  ;-1332             return;
  8146                                  
  8147 00002A09 E9AD02                   jmp .retnprocess
  8148                                  
  8149                                  ;-1333         }
  8150                                  
  8151                                  
  8152                                  ;-1334         checkOpL();//no ADR, SEGREG
  8153                                  
  8154                                  .process328:
  8155 00002A0C E81ADB                   call checkOpL
  8156                                  
  8157                                  ;-1335         if (R1Type == BYTE) reg16error();
  8158                                  
  8159 00002A0F A0[3600]                 mov al, [R1Type]
  8160 00002A12 3C01                     cmp al, 1
  8161 00002A14 0F850300                 jne .process332
  8162 00002A18 E802F2                   call reg16error
  8163                                  
  8164                                  ;-1336         if (R1Type == WORD) {
  8165                                  
  8166                                  .process332:
  8167 00002A1B A0[3600]                 mov al, [R1Type]
  8168 00002A1E 3C02                     cmp al, 2
  8169 00002A20 0F851500                 jne .process333
  8170                                  
  8171                                  ;-1337             genCode2(Code1, R1No);
  8172                                  
  8173 00002A24 A0[3400]                 mov al, byte [R1No]
  8174 00002A27 B400                     mov ah, 0
  8175 00002A29 50                       push ax
  8176 00002A2A A0[3000]                 mov al, byte [Code1]
  8177 00002A2D B400                     mov ah, 0
  8178 00002A2F 50                       push ax
  8179 00002A30 E846F7                   call genCode2
  8180 00002A33 83C404                   add  sp, 4
  8181                                  
  8182                                  ;-1338             return;
  8183                                  
  8184 00002A36 E98002                   jmp .retnprocess
  8185                                  
  8186                                  ;-1339         }
  8187                                  
  8188                                  
  8189                                  ;-1340         if (Op == MEM) {
  8190                                  
  8191                                  .process333:
  8192 00002A39 A0[2D00]                 mov al, [Op]
  8193 00002A3C 3C04                     cmp al, 4
  8194 00002A3E 0F851B00                 jne .process334
  8195                                  
  8196                                  ;-1341             genCode8(Code2);
  8197                                  
  8198 00002A42 A0[3100]                 mov al, byte [Code2]
  8199 00002A45 B400                     mov ah, 0
  8200 00002A47 50                       push ax
  8201 00002A48 E865F7                   call genCode8
  8202 00002A4B 83C402                   add  sp, 2
  8203                                  
  8204                                  ;-1342             writeEA(Code3);//////////////////Code3
  8205                                  
  8206 00002A4E A0[3200]                 mov al, byte [Code3]
  8207 00002A51 B400                     mov ah, 0
  8208 00002A53 50                       push ax
  8209 00002A54 E8FBF7                   call writeEA
  8210 00002A57 83C402                   add  sp, 2
  8211                                  
  8212                                  ;-1343             return;
  8213                                  
  8214 00002A5A E95C02                   jmp .retnprocess
  8215                                  
  8216                                  ;-1344         }
  8217                                  
  8218                                  
  8219                                  ;-1345         syntaxerror();
  8220                                  
  8221                                  .process334:
  8222 00002A5D E80CF2                   call syntaxerror
  8223                                  
  8224                                  ;-1346         return;
  8225                                  
  8226 00002A60 E95602                   jmp .retnprocess
  8227                                  
  8228                                  ;-1347     }
  8229                                  
  8230                                  
  8231                                  ;-1348 
  8232                                  
  8233                                  
  8234                                  ;-1349     if (CodeType == 11) {//shift, rotate
  8235                                  
  8236                                  .process320:
  8237 00002A63 A0[2F00]                 mov al, [CodeType]
  8238 00002A66 3C0B                     cmp al, 11
  8239 00002A68 0F859200                 jne .process335
  8240                                  
  8241                                  ;-1350         check2Ops();
  8242                                  
  8243 00002A6C E83CDB                   call check2Ops
  8244                                  
  8245                                  ;-1351         if (Op2 == IMM) {
  8246                                  
  8247 00002A6F A0[2E00]                 mov al, [Op2]
  8248 00002A72 3C01                     cmp al, 1
  8249 00002A74 0F854400                 jne .process336
  8250                                  
  8251                                  ;-1352             if (imme == 1) {
  8252                                  
  8253 00002A78 A1[3F00]                 mov ax, [imme]
  8254 00002A7B 83F801                   cmp ax, 1
  8255 00002A7E 0F851800                 jne .process337
  8256                                  
  8257                                  ;-1353                 genCodeW(0xD0);
  8258                                  
  8259 00002A82 68D000                   push 208
  8260 00002A85 E80CF7                   call genCodeW
  8261 00002A88 83C402                   add  sp, 2
  8262                                  
  8263                                  ;-1354                 writeEA(Code1);
  8264                                  
  8265 00002A8B A0[3000]                 mov al, byte [Code1]
  8266 00002A8E B400                     mov ah, 0
  8267 00002A90 50                       push ax
  8268 00002A91 E8BEF7                   call writeEA
  8269 00002A94 83C402                   add  sp, 2
  8270                                  
  8271                                  ;-1355                 return;
  8272                                  
  8273 00002A97 E91F02                   jmp .retnprocess
  8274                                  
  8275                                  ;-1356             }
  8276                                  
  8277                                  
  8278                                  ;-1357             genCodeW(0xC0);//80186
  8279                                  
  8280                                  .process337:
  8281 00002A9A 68C000                   push 192
  8282 00002A9D E8F4F6                   call genCodeW
  8283 00002AA0 83C402                   add  sp, 2
  8284                                  
  8285                                  ;-1358             writeEA(Code1);
  8286                                  
  8287 00002AA3 A0[3000]                 mov al, byte [Code1]
  8288 00002AA6 B400                     mov ah, 0
  8289 00002AA8 50                       push ax
  8290 00002AA9 E8A6F7                   call writeEA
  8291 00002AAC 83C402                   add  sp, 2
  8292                                  
  8293                                  ;-1359             genCode8(imme);
  8294                                  
  8295 00002AAF FF36[3F00]               push word [imme]
  8296 00002AB3 E8FAF6                   call genCode8
  8297 00002AB6 83C402                   add  sp, 2
  8298                                  
  8299                                  ;-1360             return;
  8300                                  
  8301 00002AB9 E9FD01                   jmp .retnprocess
  8302                                  
  8303                                  ;-1361         }
  8304                                  
  8305                                  
  8306                                  ;-1362         if (Op2 == REG) {
  8307                                  
  8308                                  .process336:
  8309 00002ABC A0[2E00]                 mov al, [Op2]
  8310 00002ABF 3C02                     cmp al, 2
  8311 00002AC1 0F853900                 jne .process338
  8312                                  
  8313                                  ;-1363             if (R2Type == BYTE) {
  8314                                  
  8315 00002AC5 A0[3500]                 mov al, [R2Type]
  8316 00002AC8 3C01                     cmp al, 1
  8317 00002ACA 0F853000                 jne .process339
  8318                                  
  8319                                  ;-1364                 if (R2No == 1) {//CL-REG
  8320                                  
  8321 00002ACE A0[3300]                 mov al, [R2No]
  8322 00002AD1 3C01                     cmp al, 1
  8323 00002AD3 0F852700                 jne .process340
  8324                                  
  8325                                  ;-1365                     if (R1Type == WORD) wflag=1;//hack
  8326                                  
  8327 00002AD7 A0[3600]                 mov al, [R1Type]
  8328 00002ADA 3C02                     cmp al, 2
  8329 00002ADC 0F850600                 jne .process341
  8330 00002AE0 B80100                   mov ax, 1
  8331 00002AE3 A2[3800]                 mov byte [wflag], al
  8332                                  
  8333                                  ;-1366                     genCodeW(0xD2);
  8334                                  
  8335                                  .process341:
  8336 00002AE6 68D200                   push 210
  8337 00002AE9 E8A8F6                   call genCodeW
  8338 00002AEC 83C402                   add  sp, 2
  8339                                  
  8340                                  ;-1367                     writeEA(Code1);
  8341                                  
  8342 00002AEF A0[3000]                 mov al, byte [Code1]
  8343 00002AF2 B400                     mov ah, 0
  8344 00002AF4 50                       push ax
  8345 00002AF5 E85AF7                   call writeEA
  8346 00002AF8 83C402                   add  sp, 2
  8347                                  
  8348                                  ;-1368                     return;
  8349                                  
  8350 00002AFB E9BB01                   jmp .retnprocess
  8351                                  
  8352                                  ;-1369                 }
  8353                                  
  8354                                  
  8355                                  ;-1370             }
  8356                                  
  8357                                  .process340:
  8358                                  
  8359                                  ;-1371         }
  8360                                  
  8361                                  .process339:
  8362                                  
  8363                                  ;-1372     }
  8364                                  
  8365                                  .process338:
  8366                                  
  8367                                  ;-1373 
  8368                                  
  8369                                  
  8370                                  ;-1374     if (CodeType == 12) {//int
  8371                                  
  8372                                  .process335:
  8373 00002AFE A0[2F00]                 mov al, [CodeType]
  8374 00002B01 3C0C                     cmp al, 12
  8375 00002B03 0F852200                 jne .process342
  8376                                  
  8377                                  ;-1375         if (TokeType == DIGIT) {
  8378                                  
  8379 00002B07 A0[2C00]                 mov al, [TokeType]
  8380 00002B0A 3C01                     cmp al, 1
  8381 00002B0C 0F851900                 jne .process343
  8382                                  
  8383                                  ;-1376             genCode8(Code1);
  8384                                  
  8385 00002B10 A0[3000]                 mov al, byte [Code1]
  8386 00002B13 B400                     mov ah, 0
  8387 00002B15 50                       push ax
  8388 00002B16 E897F6                   call genCode8
  8389 00002B19 83C402                   add  sp, 2
  8390                                  
  8391                                  ;-1377             genCode8(SymbolInt);
  8392                                  
  8393 00002B1C FF36[0E00]               push word [SymbolInt]
  8394 00002B20 E88DF6                   call genCode8
  8395 00002B23 83C402                   add  sp, 2
  8396                                  
  8397                                  ;-1378             return;
  8398                                  
  8399 00002B26 E99001                   jmp .retnprocess
  8400                                  
  8401                                  ;-1379         }
  8402                                  
  8403                                  
  8404                                  ;-1380     }
  8405                                  
  8406                                  .process343:
  8407                                  
  8408                                  ;-1381 
  8409                                  
  8410                                  
  8411                                  ;-1382     if (CodeType == 30) {//enter i18,i8
  8412                                  
  8413                                  .process342:
  8414 00002B29 A0[2F00]                 mov al, [CodeType]
  8415 00002B2C 3C1E                     cmp al, 30
  8416 00002B2E 0F855200                 jne .process344
  8417                                  
  8418                                  ;-1383         genCode8(0xC8);
  8419                                  
  8420 00002B32 68C800                   push 200
  8421 00002B35 E878F6                   call genCode8
  8422 00002B38 83C402                   add  sp, 2
  8423                                  
  8424                                  ;-1384         Op=getOp1();
  8425                                  
  8426 00002B3B E88CDB                   call getOp1
  8427 00002B3E A2[2D00]                 mov byte [Op], al
  8428                                  
  8429                                  ;-1385         if (Op == IMM) genCode16(SymbolInt);
  8430                                  
  8431 00002B41 A0[2D00]                 mov al, [Op]
  8432 00002B44 3C01                     cmp al, 1
  8433 00002B46 0F850D00                 jne .process345
  8434 00002B4A FF36[0E00]               push word [SymbolInt]
  8435 00002B4E E8B6F6                   call genCode16
  8436 00002B51 83C402                   add  sp, 2
  8437                                  
  8438                                  ;-1386         else numbererror();
  8439                                  
  8440 00002B54 E90300                   jmp .process346
  8441                                  .process345:
  8442 00002B57 E87FF0                   call numbererror
  8443                                  
  8444                                  ;-1387         need(',');
  8445                                  
  8446                                  .process346:
  8447 00002B5A 6A2C                     push 44
  8448 00002B5C E8B7E3                   call need
  8449 00002B5F 83C402                   add  sp, 2
  8450                                  
  8451                                  ;-1388         Op=getOp1();
  8452                                  
  8453 00002B62 E865DB                   call getOp1
  8454 00002B65 A2[2D00]                 mov byte [Op], al
  8455                                  
  8456                                  ;-1389         if (Op == IMM) genCode8 (SymbolInt);
  8457                                  
  8458 00002B68 A0[2D00]                 mov al, [Op]
  8459 00002B6B 3C01                     cmp al, 1
  8460 00002B6D 0F850D00                 jne .process347
  8461 00002B71 FF36[0E00]               push word [SymbolInt]
  8462 00002B75 E838F6                   call genCode8
  8463 00002B78 83C402                   add  sp, 2
  8464                                  
  8465                                  ;-1390         else numbererror();
  8466                                  
  8467 00002B7B E90300                   jmp .process348
  8468                                  .process347:
  8469 00002B7E E858F0                   call numbererror
  8470                                  
  8471                                  ;-1391         return;
  8472                                  
  8473                                  .process348:
  8474 00002B81 E93501                   jmp .retnprocess
  8475                                  
  8476                                  ;-1392     }
  8477                                  
  8478                                  
  8479                                  ;-1393 
  8480                                  
  8481                                  
  8482                                  ;-1394     if (CodeType==101) {//ORG nn
  8483                                  
  8484                                  .process344:
  8485 00002B84 A0[2F00]                 mov al, [CodeType]
  8486 00002B87 3C65                     cmp al, 101
  8487 00002B89 0F851500                 jne .process349
  8488                                  
  8489                                  ;-1395         if (TokeType != DIGIT) numbererror();
  8490                                  
  8491 00002B8D A0[2C00]                 mov al, [TokeType]
  8492 00002B90 3C01                     cmp al, 1
  8493 00002B92 0F840300                 je  .process350
  8494 00002B96 E840F0                   call numbererror
  8495                                  
  8496                                  ;-1396         Origin=SymbolInt;
  8497                                  
  8498                                  .process350:
  8499 00002B99 A1[0E00]                 mov ax, [SymbolInt]
  8500 00002B9C A3[2500]                 mov word [Origin], ax
  8501                                  
  8502                                  ;-1397         return;
  8503                                  
  8504 00002B9F E91701                   jmp .retnprocess
  8505                                  
  8506                                  ;-1398     }
  8507                                  
  8508                                  
  8509                                  ;-1399 
  8510                                  
  8511                                  
  8512                                  ;-1400     if (CodeType == 102) {//section, segment
  8513                                  
  8514                                  .process349:
  8515 00002BA2 A0[2F00]                 mov al, [CodeType]
  8516 00002BA5 3C66                     cmp al, 102
  8517 00002BA7 0F850900                 jne .process351
  8518                                  
  8519                                  ;-1401         //getTokeType();//ignore .bss .text .data
  8520                                  
  8521                                  
  8522                                  ;-1402         AbsoluteLab=0;//nasm resets erevy time
  8523                                  
  8524 00002BAB B80000                   mov ax, 0
  8525 00002BAE A3[2700]                 mov word [AbsoluteLab], ax
  8526                                  
  8527                                  ;-1403         return;
  8528                                  
  8529 00002BB1 E90501                   jmp .retnprocess
  8530                                  
  8531                                  ;-1404     }
  8532                                  
  8533                                  
  8534                                  ;-1405 
  8535                                  
  8536                                  
  8537                                  ;-1406     if (CodeType == 110) {//absolute
  8538                                  
  8539                                  .process351:
  8540 00002BB4 A0[2F00]                 mov al, [CodeType]
  8541 00002BB7 3C6E                     cmp al, 110
  8542 00002BB9 0F851500                 jne .process352
  8543                                  
  8544                                  ;-1407         if (TokeType != DIGIT) numbererror();
  8545                                  
  8546 00002BBD A0[2C00]                 mov al, [TokeType]
  8547 00002BC0 3C01                     cmp al, 1
  8548 00002BC2 0F840300                 je  .process353
  8549 00002BC6 E810F0                   call numbererror
  8550                                  
  8551                                  ;-1408         AbsoluteLab=SymbolInt;
  8552                                  
  8553                                  .process353:
  8554 00002BC9 A1[0E00]                 mov ax, [SymbolInt]
  8555 00002BCC A3[2700]                 mov word [AbsoluteLab], ax
  8556                                  
  8557                                  ;-1409         return;
  8558                                  
  8559 00002BCF E9E700                   jmp .retnprocess
  8560                                  
  8561                                  ;-1410     }
  8562                                  
  8563                                  
  8564                                  ;-1411     if (CodeType == 111) {//name: PROC
  8565                                  
  8566                                  .process352:
  8567 00002BD2 A0[2F00]                 mov al, [CodeType]
  8568 00002BD5 3C6F                     cmp al, 111
  8569 00002BD7 0F854A00                 jne .process354
  8570                                  
  8571                                  ;-1412         if (isInProc == 0)  {
  8572                                  
  8573 00002BDB A0[0D00]                 mov al, [isInProc]
  8574 00002BDE 3C00                     cmp al, 0
  8575 00002BE0 0F853500                 jne .process355
  8576                                  
  8577                                  ;-1413             prs("\n;entering: ");
  8578                                  
  8579 00002BE4 68[CE2C]                 push process_1
  8580 00002BE7 E85DED                   call prs
  8581 00002BEA 83C402                   add  sp, 2
  8582                                  
  8583                                  ;-1414             prs(ProcName);
  8584                                  
  8585 00002BED 8D066E75                 lea  ax, [ProcName]
  8586 00002BF1 50                       push ax
  8587 00002BF2 E852ED                   call prs
  8588 00002BF5 83C402                   add  sp, 2
  8589                                  
  8590                                  ;-1415             isInProc=1;
  8591                                  
  8592 00002BF8 B80100                   mov ax, 1
  8593 00002BFB A2[0D00]                 mov byte [isInProc], al
  8594                                  
  8595                                  ;-1416             tmpLabelNamePtr = LabelNamePtr;
  8596                                  
  8597 00002BFE A1[4600]                 mov ax, [LabelNamePtr]
  8598 00002C01 A3[4800]                 mov word [tmpLabelNamePtr], ax
  8599                                  
  8600                                  ;-1417             tmpLabelMaxIx   = LabelMaxIx;
  8601                                  
  8602 00002C04 A1[4A00]                 mov ax, [LabelMaxIx]
  8603 00002C07 A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8604                                  
  8605                                  ;-1418             tmpJmpNamePtr   = JmpNamePtr;
  8606                                  
  8607 00002C0A A1[5000]                 mov ax, [JmpNamePtr]
  8608 00002C0D A3[5200]                 mov word [tmpJmpNamePtr], ax
  8609                                  
  8610                                  ;-1419             tmpJmpMaxIx     = JmpMaxIx;
  8611                                  
  8612 00002C10 A1[5400]                 mov ax, [JmpMaxIx]
  8613 00002C13 A3[5600]                 mov word [tmpJmpMaxIx], ax
  8614                                  
  8615                                  ;-1420         } else error1("already in PROC");
  8616                                  
  8617 00002C16 E90900                   jmp .process356
  8618                                  .process355:
  8619 00002C19 68[DC2C]                 push process_2
  8620 00002C1C E87AEE                   call error1
  8621 00002C1F 83C402                   add  sp, 2
  8622                                  
  8623                                  ;-1421         return;
  8624                                  
  8625                                  .process356:
  8626 00002C22 E99400                   jmp .retnprocess
  8627                                  
  8628                                  ;-1422     }
  8629                                  
  8630                                  
  8631                                  ;-1423     if (CodeType == 112) {//ENDP 
  8632                                  
  8633                                  .process354:
  8634 00002C25 A0[2F00]                 mov al, [CodeType]
  8635 00002C28 3C70                     cmp al, 112
  8636 00002C2A 0F858200                 jne .process357
  8637                                  
  8638                                  ;-1424         if (isInProc == 0) error1("not in PROC");
  8639                                  
  8640 00002C2E A0[0D00]                 mov al, [isInProc]
  8641 00002C31 3C00                     cmp al, 0
  8642 00002C33 0F850900                 jne .process358
  8643 00002C37 68[EC2C]                 push process_3
  8644 00002C3A E85CEE                   call error1
  8645 00002C3D 83C402                   add  sp, 2
  8646                                  
  8647                                  ;-1425         prs("\n;leaving: ");
  8648                                  
  8649                                  .process358:
  8650 00002C40 68[F82C]                 push process_4
  8651 00002C43 E801ED                   call prs
  8652 00002C46 83C402                   add  sp, 2
  8653                                  
  8654                                  ;-1426         prs(ProcName);
  8655                                  
  8656 00002C49 8D066E75                 lea  ax, [ProcName]
  8657 00002C4D 50                       push ax
  8658 00002C4E E8F6EC                   call prs
  8659 00002C51 83C402                   add  sp, 2
  8660                                  
  8661                                  ;-1427         isInProc=0;
  8662                                  
  8663 00002C54 B80000                   mov ax, 0
  8664 00002C57 A2[0D00]                 mov byte [isInProc], al
  8665                                  
  8666                                  ;-1428         prs(". loc labels:");
  8667                                  
  8668 00002C5A 68[052D]                 push process_5
  8669 00002C5D E8E7EC                   call prs
  8670 00002C60 83C402                   add  sp, 2
  8671                                  
  8672                                  ;-1429         i = LabelMaxIx - tmpLabelMaxIx;
  8673                                  
  8674 00002C63 A1[4A00]                 mov ax, [LabelMaxIx]
  8675 00002C66 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8676 00002C6A 8946FC                   mov [bp-4], ax
  8677                                  
  8678                                  ;-1430         printIntU(i);
  8679                                  
  8680 00002C6D FF76FC                   push word [bp-4]
  8681 00002C70 E8E4ED                   call printIntU
  8682 00002C73 83C402                   add  sp, 2
  8683                                  
  8684                                  ;-1431         prs(",loc jmp forward:");
  8685                                  
  8686 00002C76 68[132D]                 push process_6
  8687 00002C79 E8CBEC                   call prs
  8688 00002C7C 83C402                   add  sp, 2
  8689                                  
  8690                                  ;-1432         i = JmpMaxIx - tmpJmpMaxIx;
  8691                                  
  8692 00002C7F A1[5400]                 mov ax, [JmpMaxIx]
  8693 00002C82 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8694 00002C86 8946FC                   mov [bp-4], ax
  8695                                  
  8696                                  ;-1433         printIntU(i);        
  8697                                  
  8698 00002C89 FF76FC                   push word [bp-4]
  8699 00002C8C E8C8ED                   call printIntU
  8700 00002C8F 83C402                   add  sp, 2
  8701                                  
  8702                                  ;-1434         fixJmp();
  8703                                  
  8704 00002C92 E89DF2                   call fixJmp
  8705                                  
  8706                                  ;-1435         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8707                                  
  8708 00002C95 A1[4800]                 mov ax, [tmpLabelNamePtr]
  8709 00002C98 A3[4600]                 mov word [LabelNamePtr], ax
  8710                                  
  8711                                  ;-1436         LabelMaxIx   = tmpLabelMaxIx;                       
  8712                                  
  8713 00002C9B A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8714 00002C9E A3[4A00]                 mov word [LabelMaxIx], ax
  8715                                  
  8716                                  ;-1437         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8717                                  
  8718 00002CA1 A1[5200]                 mov ax, [tmpJmpNamePtr]
  8719 00002CA4 A3[5000]                 mov word [JmpNamePtr], ax
  8720                                  
  8721                                  ;-1438         JmpMaxIx     = tmpJmpMaxIx;
  8722                                  
  8723 00002CA7 A1[5600]                 mov ax, [tmpJmpMaxIx]
  8724 00002CAA A3[5400]                 mov word [JmpMaxIx], ax
  8725                                  
  8726                                  ;-1439         return;
  8727                                  
  8728 00002CAD E90900                   jmp .retnprocess
  8729                                  
  8730                                  ;-1440     }
  8731                                  
  8732                                  
  8733                                  ;-1441     error1("Command not implemented or syntax error");
  8734                                  
  8735                                  .process357:
  8736 00002CB0 68[252D]                 push process_7
  8737 00002CB3 E8E3ED                   call error1
  8738 00002CB6 83C402                   add  sp, 2
  8739                                  
  8740                                  ;-1442 }
  8741                                  
  8742                                  
  8743                                  ;-1443 
  8744                                  
  8745 00002CB9 C9                       .retnprocess: LEAVE
  8746 00002CBA C3                       ret
  8747 00002CBB 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8748 00002CC4 7420616C6C6F776564-
  8749 00002CCD 00                 
  8750 00002CCE 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8751 00002CD7 6E673A2000         
  8752 00002CDC 616C72656164792069-     process_2 db "already in PROC",0
  8753 00002CE5 6E2050524F4300     
  8754 00002CEC 6E6F7420696E205052-     process_3 db "not in PROC",0
  8755 00002CF5 4F4300             
  8756 00002CF8 5C6E3B6C656176696E-     process_4 db "\n;leaving: ",0
  8757 00002D01 673A2000           
  8758 00002D05 2E206C6F63206C6162-     process_5 db ". loc labels:",0
  8759 00002D0E 656C733A00         
  8760 00002D13 2C6C6F63206A6D7020-     process_6 db ",loc jmp forward:",0
  8761 00002D1C 666F72776172643A00 
  8762 00002D25 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8763 00002D2E 6F7420696D706C656D-
  8764 00002D37 656E746564206F7220-
  8765 00002D40 73796E746178206572-
  8766 00002D49 726F7200           
  8767                                  ENDP
  8768                                   
  8769                                  ; missing functions: 
  8770                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8771 00002D4D E80000                  LastFunctionByt:db 0E8h, 0, 0
  8772 00002D50 58                      pop ax
  8773 00002D51 C3                      ret
  8774                                   
  8775                                  ;   # type sign width  adr used name   list of global variables
  8776                                  
  8777                                  ;    1 arr sign byte     1    2 Version1[9]
  8778                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  8779                                  ;    3 arr sign byte     4   12 Symbol[31]
  8780                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  8781                                  ;    5 arr sign byte     6    3 ProcName[31]
  8782                                  ;    6 var sign byte     7    6 isInProc
  8783                                  ;    7 var unsg word     8   24 SymbolInt
  8784                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  8785                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  8786                                  ;   10 arr sign byte    11    4 InputBuf[255]
  8787                                  ;   11 ptr unsg byte    12   24 InputPtr
  8788                                  ;   12 arr sign byte    13    5 namein[67]
  8789                                  ;   13 arr sign byte    14    6 namelst[67]
  8790                                  ;   14 arr sign byte    15    6 namebin[67]
  8791                                  ;   15 var sign word    16    4 asm_fd
  8792                                  ;   16 var sign word    17    3 lst_fd
  8793                                  ;   17 var sign word    18    3 bin_fd
  8794                                  ;   18 var sign word    19    6 DOS_ERR
  8795                                  ;   19 var sign word    20    4 ErrorCount
  8796                                  ;   20 var sign word    21    4 DOS_NoBytes
  8797                                  ;   21 var sign byte    22    5 DOS_ByteRead
  8798                                  ;   22 var unsg word    24    7 PC
  8799                                  ;   23 var unsg word    25    5 Origin
  8800                                  ;   24 var unsg word    26    6 AbsoluteLab
  8801                                  ;   25 var unsg word    27    2 PCStart
  8802                                  ;   26 var sign byte    28    3 isLabel
  8803                                  ;   27 def unsg byte    29    - DIGIT=1
  8804                                  ;   28 def unsg byte    30    - LETTERE=2
  8805                                  ;   29 def unsg byte    31    - ALNUME=3
  8806                                  ;   30 def unsg byte    32    - NOALNUME=4
  8807                                  ;   31 var sign byte    33   27 TokeType
  8808                                  ;   32 def unsg byte    34    - BYTE=1
  8809                                  ;   33 def unsg byte    35    - WORD=2
  8810                                  ;   34 def unsg byte    36    - DWORD=3
  8811                                  ;   35 def unsg byte    37    - SEGREG=4
  8812                                  ;   36 def unsg byte    38    - IMM=1
  8813                                  ;   37 def unsg byte    39    - REG=2
  8814                                  ;   38 def unsg byte    40    - ADR=3
  8815                                  ;   39 def unsg byte    41    - MEM=4
  8816                                  ;   40 var sign byte    42   29 Op
  8817                                  ;   41 var sign byte    43   31 Op2
  8818                                  ;   42 var sign byte    44   29 CodeType
  8819                                  ;   43 var sign byte    45   23 Code1
  8820                                  ;   44 var sign byte    46    7 Code2
  8821                                  ;   45 var sign byte    47    3 Code3
  8822                                  ;   46 var sign byte    48   19 R2No
  8823                                  ;   47 var sign byte    49   16 R1No
  8824                                  ;   48 var sign byte    50   18 R2Type
  8825                                  ;   49 var sign byte    51   15 R1Type
  8826                                  ;   50 var sign byte    52   14 OpSize
  8827                                  ;   51 var sign byte    53    9 wflag
  8828                                  ;   52 var sign byte    54    3 dflag
  8829                                  ;   53 var sign byte    55    8 sflag
  8830                                  ;   54 var sign byte    56   15 rm
  8831                                  ;   55 var sign byte    57    5 isDirect
  8832                                  ;   56 var sign word    58   54 disp
  8833                                  ;   57 var unsg word    59   13 imme
  8834                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  8835                                  ;   59 arr sign byte    62    2 OpPos[5]
  8836                                  ;   60 var sign word    63    6 OpPrintIndex
  8837                                  ;   61 ptr sign byte    64   19 OpCodePtr
  8838                                  ;   62 var sign byte    65    5 PrintRA
  8839                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  8840                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  8841                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  8842                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  8843                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  8844                                  ;   68 arr unsg word    73    7 LabelAddr[600]
  8845                                  ;   69 var sign word    74   10 LabelMaxIx
  8846                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  8847                                  ;   71 var sign word    76   11 LabelIx
  8848                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  8849                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  8850                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  8851                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  8852                                  ;   76 def unsg byte    83    - JMPMAX=200
  8853                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  8854                                  ;   78 var sign word    85    9 JmpMaxIx
  8855                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  8856                                  ;   80 def unsg byte    88    - FILEBINMAX=20000
  8857                                  ;   81 arr sign byte    89    5 FileBin[20000]
  8858                                  ;   82 var unsg word    90    6 BinLen
  8859                                  ;   83 ptr sign byte    92    1 arglen
  8860                                  ;   84 ptr sign byte    93    4 argv
  8861                                  ;   85 var sign byte    97    1 I_START
  8862                                  ;   86 arr sign byte   100 NULL I_PUSHA[8125]
  8863                                  ;   87 arr sign byte   101 NULL I_NOP[24260]
  8864                                  ;   88 arr sign byte   102 NULL I_CWDE[9734]
  8865                                  ;   89 arr sign byte   103 NULL I_CDQ[1931]
  8866                                  ;   90 arr sign byte   104 NULL I_PUSHF[35622]
  8867                                  ;   91 arr sign byte   105 NULL I_SAHF[599]
  8868                                  ;   92 arr sign byte   106 NULL I_MOVSB[53495]
  8869                                  ;   93 arr sign byte   107 NULL I_CMPSB[54007]
  8870                                  ;   94 arr sign byte   108 NULL I_STOSB[37]
  8871                                  ;   95 arr sign byte   109 NULL I_LODSB[33600]
  8872                                  ;   96 arr sign byte   110 NULL I_SCASB[8418]
  8873                                  ;   97 arr sign byte   111 NULL I_LEAVE[53259]
  8874                                  ;   98 arr sign byte   112 NULL I_INTO[12917]
  8875                                  ;   99 arr sign byte   113 NULL I_XLAT[35622]
  8876                                  ;  100 arr sign byte   114 NULL I_REPNE[2119]
  8877                                  ;  101 arr sign byte   115 NULL I_REPE[18057]
  8878                                  ;  102 arr sign byte   116 NULL I_HLT[9982]
  8879                                  ;  103 arr sign byte   117 NULL I_STC[18315]
  8880                                  ;  104 arr sign byte   118 NULL I_STI[9734]
  8881                                  ;  105 arr sign byte   119 NULL I_STD[32643]
  8882                                  ;  106 arr sign byte   121 NULL I_INC[10]
  8883                                  ;  107 arr sign byte   122 NULL I_DEC[1397]
  8884                                  ;  108 arr sign byte   123 NULL I_NOT[18119]
  8885                                  ;  109 arr sign byte   124 NULL I_NEG[65534]
  8886                                  ;  110 arr sign byte   125 NULL I_MUL[33791]
  8887                                  ;  111 arr sign byte   126 NULL I_IMUL[65150]
  8888                                  ;  112 arr sign byte   127 NULL I_DIV[30207]
  8889                                  ;  113 arr sign byte   128 NULL I_IDIV[15642]
  8890                                  ;  114 arr sign byte   130 NULL I_LES[65535]
  8891                                  ;  115 arr sign byte   131 NULL I_LDS[5493]
  8892                                  ;  116 arr sign byte   132 NULL I_LEA[33574]
  8893                                  ;  117 arr sign byte   133 NULL I_LSS[1151]
  8894                                  ;  118 arr sign byte   134 NULL I_LFS[29696]
  8895                                  ;  119 arr sign byte   135 NULL I_LGS[35593]
  8896                                  ;  120 arr sign byte   137 NULL I_ADD[2630]
  8897                                  ;  121 arr sign byte   138 NULL I_OR[14630]
  8898                                  ;  122 arr sign byte   139 NULL I_ADC[1095]
  8899                                  ;  123 arr sign byte   140 NULL I_SBB[26997]
  8900                                  ;  124 arr sign byte   141 NULL I_AND[49203]
  8901                                  ;  125 arr sign byte   142 NULL I_SUB[52169]
  8902                                  ;  126 arr sign byte   143 NULL I_XOR[33680]
  8903                                  ;  127 arr sign byte   144 NULL I_CMP[65150]
  8904                                  ;  128 arr sign byte   145 NULL I_TEST[29729]
  8905                                  ;  129 arr sign byte   147 NULL I_MOV[33618]
  8906                                  ;  130 arr sign byte   148 NULL I_MOVSX[65150]
  8907                                  ;  131 arr sign byte   149 NULL I_MOVZX[29731]
  8908                                  ;  132 arr sign byte   151 NULL I_JO[33612]
  8909                                  ;  133 arr sign byte   152 NULL I_JNO[65150]
  8910                                  ;  134 arr sign byte   153 NULL I_JB[29732]
  8911                                  ;  135 arr sign byte   154 NULL I_JNB[33606]
  8912                                  ;  136 arr sign byte   155 NULL I_JAE[65150]
  8913                                  ;  137 arr sign byte   156 NULL I_JE[29734]
  8914                                  ;  138 arr sign byte   157 NULL I_JNE[33600]
  8915                                  ;  139 arr sign byte   158 NULL I_JBE[65150]
  8916                                  ;  140 arr sign byte   159 NULL I_JA[29730]
  8917                                  ;  141 arr sign byte   160 NULL I_JS[33594]
  8918                                  ;  142 arr sign byte   161 NULL I_JNS[65150]
  8919                                  ;  143 arr sign byte   162 NULL I_JP[29737]
  8920                                  ;  144 arr sign byte   163 NULL I_JNP[33588]
  8921                                  ;  145 arr sign byte   164 NULL I_JL[65150]
  8922                                  ;  146 arr sign byte   165 NULL I_JNL[29736]
  8923                                  ;  147 arr sign byte   166 NULL I_JLE[33582]
  8924                                  ;  148 arr sign byte   167 NULL I_JG[65150]
  8925                                  ;  149 arr sign byte   169 NULL I_JMP[29733]
  8926                                  ;  150 arr sign byte   170 NULL I_CALL[15656]
  8927                                  ;  151 arr sign byte   172 NULL I_RET[33]
  8928                                  ;  152 arr sign byte   173 NULL I_RETF[9076]
  8929                                  ;  153 arr sign byte   175 NULL I_PUSH[9021]
  8930                                  ;  154 arr sign byte   176 NULL I_POP[29696]
  8931                                  ;  155 arr sign byte   178 NULL I_ROL[15646]
  8932                                  ;  156 arr sign byte   179 NULL I_RCL[36]
  8933                                  ;  157 arr sign byte   180 NULL I_SHL[6516]
  8934                                  ;  158 arr sign byte   181 NULL I_SHR[9789]
  8935                                  ;  159 arr sign byte   183 NULL I_INT[29696]
  8936                                  ;  160 arr sign byte   185 NULL I_IN[15636]
  8937                                  ;  161 arr sign byte   186 NULL I_INSB[34]
  8938                                  ;  162 arr sign byte   187 NULL I_INSW[3956]
  8939                                  ;  163 arr sign byte   188 NULL I_INSD[10557]
  8940                                  ;  164 arr sign byte   189 NULL I_OUT[29696]
  8941                                  ;  165 arr sign byte   190 NULL I_OUTSB[15626]
  8942                                  ;  166 arr sign byte   191 NULL I_OUTSW[40]
  8943                                  ;  167 arr sign byte   192 NULL I_OUTSD[1396]
  8944                                  ;  168 arr sign byte   194 NULL I_XCHG[9533]
  8945                                  ;  169 arr sign byte   196 NULL I_LOOPNZ[29952]
  8946                                  ;  170 arr sign byte   197 NULL I_LOOPNE[33542]
  8947                                  ;  171 arr sign byte   198 NULL I_LOOPZ[2686]
  8948                                  ;  172 arr sign byte   199 NULL I_LOOPE[60176]
  8949                                  ;  173 arr sign byte   200 NULL I_LOOP[33540]
  8950                                  ;  174 arr sign byte   201 NULL I_JCXZ[2686]
  8951                                  ;  175 arr sign byte   202 NULL I_JECXZ[29984]
  8952                                  ;  176 arr sign byte   204 NULL I_ENTER[47255]
  8953                                  ;  177 arr sign byte   206 NULL I_ORG[1]
  8954                                  ;  178 arr sign byte   208 NULL I_SECTION[52169]
  8955                                  ;  179 arr sign byte   209 NULL I_SEGMENT[21904]
  8956                                  ;  180 arr sign byte   210 NULL I_ABSOLUTE[60555]
  8957                                  ;  181 arr sign byte   211 NULL I_PROC[5816]
  8958                                  ;  182 arr sign byte   212 NULL I_ENDP[39424]
  8959                                  ;  183 arr sign byte   213 NULL I_DB[674]
  8960                                  ;  184 arr sign byte   214 NULL I_DW[8125]
  8961                                  ;  185 arr sign byte   215 NULL I_DD[51030]
  8962                                  ;  186 arr sign byte   216 NULL I_RESB[65094]
  8963                                  ;  187 arr sign byte   217 NULL I_RESW[0]
  8964                                  ;  188 arr sign byte   218 NULL I_RESD[1678]
  8965                                  ;  189 var sign byte   219 NULL I_END
  8966                                  
  8967                                  
  8968                                  ;   # Calls Line Width  Name   list of functions
  8969                                  
  8970                                  ;    0    2  221   lookCode
  8971                                  ;    1    2  238   ChangeDirection
  8972                                  ;    2    2  246   checkOpL
  8973                                  ;    3    4  255   check2Ops
  8974                                  ;    4    1  264   get2Ops
  8975                                  ;    5    3  270   getOpL
  8976                                  ;    6    2  278   getOpR
  8977                                  ;    7    4  291   getOp1
  8978                                  ;    8    1  308   getMEM
  8979                                  ;    9    1  334   getIndReg1
  8980                                  ;   10    1  342   getIndReg2
  8981                                  ;   11    2  352   setwflag
  8982                                  ;   12    2  363   setsflag
  8983                                  ;   13    2  373   checkConstSize
  8984                                  ;   14    1  381   parse
  8985                                  ;   15   16  417   getTokeType
  8986                                  ;   16    3  428   storeJmp
  8987                                  ;   17    2  439   storeLabel
  8988                                  ;   18    5  451   searchLabel
  8989                                  ;   19    1  464   getVariable
  8990                                  ;   20    1  517   getCodeSize
  8991                                  ;   21    9  525   isToken
  8992                                  ;   22    2  533   need
  8993                                  ;   23    1  542   skipRest
  8994                                  ;   24    4  549   writetty
  8995                                  ;   25    1  550   putch
  8996                                  ;   26    8  551   cputs
  8997                                  ;   27    6  553   DosInt
  8998                                  ;   28    1  558   openR
  8999                                  ;   29    2  559   creatR
  9000                                  ;   30    3  560   fcloseR
  9001                                  ;   31    5  561   exitR
  9002                                  ;   32    2  562   readRL
  9003                                  ;   33    2  563   fputcR
  9004                                  ;   34    1  566   getLine
  9005                                  ;   35    1  582   ifEOL
  9006                                  ;   36    3  591   skipBlank
  9007                                  ;   37    2  596   letterE
  9008                                  ;   38    1  606   alnumE
  9009                                  ;   39    3  611   digit
  9010                                  ;   40    4  616   strlen
  9011                                  ;   41    9  621   strcpy
  9012                                  ;   42   35  627   eqstr
  9013                                  ;   43    3  636   strcat1
  9014                                  ;   44    2  640   toupper
  9015                                  ;   45    1  647   getDigit
  9016                                  ;   46    1  659   getName
  9017                                  ;   47    1  678   testReg
  9018                                  ;   48    1  722   printLine
  9019                                  ;   49    7  744   prc
  9020                                  ;   50    1  754   prscomment
  9021                                  ;   51   33  762   prs
  9022                                  ;   52    3  784   printhex8a
  9023                                  ;   53    2  789   printhex4
  9024                                  ;   54    1  794   printhex16
  9025                                  ;   55    7  799   printIntU
  9026                                  ;   56   28  810   error1
  9027                                  ;   57   13  817   errorexit
  9028                                  ;   58    2  822   notfounderror
  9029                                  ;   59 NULL  823   allowederror
  9030                                  ;   60    3  824   addrerror
  9031                                  ;   61    1  825   immeerror
  9032                                  ;   62    2  826   implerror
  9033                                  ;   63    4  827   indexerror
  9034                                  ;   64    3  828   invaloperror
  9035                                  ;   65    6  829   numbererror
  9036                                  ;   66    1  830   regmemerror
  9037                                  ;   67    3  831   reg16error
  9038                                  ;   68    1  832   segregerror
  9039                                  ;   69    5  833   syntaxerror
  9040                                  ;   70 NULL  835   addrexit
  9041                                  ;   71    3  836   dataexit
  9042                                  ;   72 NULL  837   internexit
  9043                                  ;   73 NULL  841   main
  9044                                  ;   74    1  849   getarg
  9045                                  ;   75    2  883   fixJmp
  9046                                  ;   76    2  918   epilog
  9047                                  ;   77    2  966   end1
  9048                                  ;   78    1  976   getCodes
  9049                                  ;   79    1  981   gen66h
  9050                                  ;   80    8  983   genCode2
  9051                                  ;   81   13  987   genCodeW
  9052                                  ;   82   35  991   genCode8
  9053                                  ;   83   19 1002   genCode16
  9054                                  ;   84    1 1006   genCode32
  9055                                  ;   85   13 1010   writeEA
  9056                                  ;   86    4 1052   genImmediate
  9057                                  ;   87    1 1059   process
  9058                                  ;   88 NULL 1443   LastFunctionByt
  9059                                  
  9060                                  ;    #  addr name   list of CALLs
  9061                                  
  9062                                  ;    0     0 eqstr
  9063                                  ;    1     6 implerror
  9064                                  ;    2    16 segregerror
  9065                                  ;    3    28 setwflag
  9066                                  ;    4    37 error1
  9067                                  ;    5    44 error1
  9068                                  ;    6    51 get2Ops
  9069                                  ;    7    59 addrerror
  9070                                  ;    8    69 invaloperror
  9071                                  ;    9    82 immeerror
  9072                                  ;   10    92 addrerror
  9073                                  ;   11   102 invaloperror
  9074                                  ;   12   115 setwflag
  9075                                  ;   13   124 getOpL
  9076                                  ;   14   131 need
  9077                                  ;   15   136 getOpR
  9078                                  ;   16   143 getOpR
  9079                                  ;   17   150 getOp1
  9080                                  ;   18   157 isToken
  9081                                  ;   19   165 getMEM
  9082                                  ;   20   172 invaloperror
  9083                                  ;   21   185 error1
  9084                                  ;   22   192 testReg
  9085                                  ;   23   200 searchLabel
  9086                                  ;   24   212 getTokeType
  9087                                  ;   25   224 getOp1
  9088                                  ;   26   231 syntaxerror
  9089                                  ;   27   243 getIndReg2
  9090                                  ;   28   254 getIndReg1
  9091                                  ;   29   265 notfounderror
  9092                                  ;   30   279 isToken
  9093                                  ;   31   287 getTokeType
  9094                                  ;   32   299 numbererror
  9095                                  ;   33   311 isToken
  9096                                  ;   34   319 isToken
  9097                                  ;   35   327 errorexit
  9098                                  ;   36   337 indexerror
  9099                                  ;   37   348 indexerror
  9100                                  ;   38   359 indexerror
  9101                                  ;   39   370 indexerror
  9102                                  ;   40   381 gen66h
  9103                                  ;   41   388 error1
  9104                                  ;   42   395 getLine
  9105                                  ;   43   403 getTokeType
  9106                                  ;   44   415 strcpy
  9107                                  ;   45   422 storeLabel
  9108                                  ;   46   433 getTokeType
  9109                                  ;   47   445 lookCode
  9110                                  ;   48   454 process
  9111                                  ;   49   462 getVariable
  9112                                  ;   50   474 skipRest
  9113                                  ;   51   483 error1
  9114                                  ;   52   490 error1
  9115                                  ;   53   497 printLine
  9116                                  ;   54   507 skipBlank
  9117                                  ;   55   517 digit
  9118                                  ;   56   523 getDigit
  9119                                  ;   57   532 letterE
  9120                                  ;   58   540 getName
  9121                                  ;   59   548 errorexit
  9122                                  ;   60   558 strcpy
  9123                                  ;   61   565 errorexit
  9124                                  ;   62   575 searchLabel
  9125                                  ;   63   587 error1
  9126                                  ;   64   594 errorexit
  9127                                  ;   65   604 strcpy
  9128                                  ;   66   611 errorexit
  9129                                  ;   67   621 eqstr
  9130                                  ;   68   627 strlen
  9131                                  ;   69   634 storeLabel
  9132                                  ;   70   645 getTokeType
  9133                                  ;   71   657 lookCode
  9134                                  ;   72   666 dataexit
  9135                                  ;   73   675 dataexit
  9136                                  ;   74   684 getTokeType
  9137                                  ;   75   696 genCode8
  9138                                  ;   76   705 skipBlank
  9139                                  ;   77   715 isToken
  9140                                  ;   78   723 genCode8
  9141                                  ;   79   732 isToken
  9142                                  ;   80   740 getTokeType
  9143                                  ;   81   752 genCode16
  9144                                  ;   82   762 isToken
  9145                                  ;   83   770 getTokeType
  9146                                  ;   84   782 genCode16
  9147                                  ;   85   792 genCode16
  9148                                  ;   86   802 isToken
  9149                                  ;   87   810 getTokeType
  9150                                  ;   88   822 syntaxerror
  9151                                  ;   89   834 error1
  9152                                  ;   90   841 numbererror
  9153                                  ;   91   853 dataexit
  9154                                  ;   92   862 eqstr
  9155                                  ;   93   868 getTokeType
  9156                                  ;   94   880 eqstr
  9157                                  ;   95   886 getTokeType
  9158                                  ;   96   898 eqstr
  9159                                  ;   97   904 getTokeType
  9160                                  ;   98   916 skipBlank
  9161                                  ;   99   926 isToken
  9162                                  ;  100   934 getTokeType
  9163                                  ;  101   946 error1
  9164                                  ;  102   953 prs
  9165                                  ;  103   957 prc
  9166                                  ;  104   961 getTokeType
  9167                                  ;  105   973 error1
  9168                                  ;  106   980 writetty
  9169                                  ;  107   989 writetty
  9170                                  ;  108   998 putch
  9171                                  ;  109  1004 DosInt
  9172                                  ;  110  1011 DosInt
  9173                                  ;  111  1018 DosInt
  9174                                  ;  112  1025 DosInt
  9175                                  ;  113  1032 DosInt
  9176                                  ;  114  1039 DosInt
  9177                                  ;  115  1046 readRL
  9178                                  ;  116  1053 errorexit
  9179                                  ;  117  1063 errorexit
  9180                                  ;  118  1073 ifEOL
  9181                                  ;  119  1079 readRL
  9182                                  ;  120  1086 errorexit
  9183                                  ;  121  1096 digit
  9184                                  ;  122  1102 letterE
  9185                                  ;  123  1110 strcpy
  9186                                  ;  124  1117 digit
  9187                                  ;  125  1123 alnumE
  9188                                  ;  126  1130 errorexit
  9189                                  ;  127  1140 strcpy
  9190                                  ;  128  1147 toupper
  9191                                  ;  129  1155 strlen
  9192                                  ;  130  1162 strlen
  9193                                  ;  131  1169 eqstr
  9194                                  ;  132  1175 eqstr
  9195                                  ;  133  1181 eqstr
  9196                                  ;  134  1187 eqstr
  9197                                  ;  135  1193 eqstr
  9198                                  ;  136  1199 eqstr
  9199                                  ;  137  1205 eqstr
  9200                                  ;  138  1211 eqstr
  9201                                  ;  139  1217 eqstr
  9202                                  ;  140  1223 eqstr
  9203                                  ;  141  1229 eqstr
  9204                                  ;  142  1235 eqstr
  9205                                  ;  143  1241 eqstr
  9206                                  ;  144  1247 eqstr
  9207                                  ;  145  1253 eqstr
  9208                                  ;  146  1259 eqstr
  9209                                  ;  147  1265 eqstr
  9210                                  ;  148  1271 eqstr
  9211                                  ;  149  1277 eqstr
  9212                                  ;  150  1283 eqstr
  9213                                  ;  151  1289 eqstr
  9214                                  ;  152  1295 eqstr
  9215                                  ;  153  1301 eqstr
  9216                                  ;  154  1307 eqstr
  9217                                  ;  155  1313 eqstr
  9218                                  ;  156  1319 eqstr
  9219                                  ;  157  1325 eqstr
  9220                                  ;  158  1331 eqstr
  9221                                  ;  159  1337 eqstr
  9222                                  ;  160  1343 eqstr
  9223                                  ;  161  1349 prs
  9224                                  ;  162  1353 printhex16
  9225                                  ;  163  1364 prs
  9226                                  ;  164  1368 prc
  9227                                  ;  165  1372 printhex8a
  9228                                  ;  166  1383 prs
  9229                                  ;  167  1387 prc
  9230                                  ;  168  1391 prscomment
  9231                                  ;  169  1402 writetty
  9232                                  ;  170  1411 writetty
  9233                                  ;  171  1420 fputcR
  9234                                  ;  172  1427 prc
  9235                                  ;  173  1431 prc
  9236                                  ;  174  1435 printhex4
  9237                                  ;  175  1445 printhex4
  9238                                  ;  176  1455 prc
  9239                                  ;  177  1459 printhex8a
  9240                                  ;  178  1470 printhex8a
  9241                                  ;  179  1481 printIntU
  9242                                  ;  180  1491 prc
  9243                                  ;  181  1495 prs
  9244                                  ;  182  1499 prs
  9245                                  ;  183  1503 prs
  9246                                  ;  184  1507 prs
  9247                                  ;  185  1511 error1
  9248                                  ;  186  1518 epilog
  9249                                  ;  187  1525 end1
  9250                                  ;  188  1530 error1
  9251                                  ;  189  1537 error1
  9252                                  ;  190  1544 error1
  9253                                  ;  191  1551 error1
  9254                                  ;  192  1558 error1
  9255                                  ;  193  1565 error1
  9256                                  ;  194  1572 error1
  9257                                  ;  195  1579 error1
  9258                                  ;  196  1586 error1
  9259                                  ;  197  1593 error1
  9260                                  ;  198  1600 error1
  9261                                  ;  199  1607 error1
  9262                                  ;  200  1614 errorexit
  9263                                  ;  201  1624 errorexit
  9264                                  ;  202  1634 errorexit
  9265                                  ;  203  1644 getarg
  9266                                  ;  204  1651 parse
  9267                                  ;  205  1657 fixJmp
  9268                                  ;  206  1664 epilog
  9269                                  ;  207  1671 end1
  9270                                  ;  208  1676 cputs
  9271                                  ;  209  1682 cputs
  9272                                  ;  210  1688 exitR
  9273                                  ;  211  1694 toupper
  9274                                  ;  212  1702 strcpy
  9275                                  ;  213  1709 strcat1
  9276                                  ;  214  1717 strcpy
  9277                                  ;  215  1724 strcat1
  9278                                  ;  216  1732 strcpy
  9279                                  ;  217  1739 strcat1
  9280                                  ;  218  1747 openR
  9281                                  ;  219  1753 cputs
  9282                                  ;  220  1759 cputs
  9283                                  ;  221  1765 exitR
  9284                                  ;  222  1771 creatR
  9285                                  ;  223  1778 cputs
  9286                                  ;  224  1784 cputs
  9287                                  ;  225  1790 exitR
  9288                                  ;  226  1796 creatR
  9289                                  ;  227  1803 cputs
  9290                                  ;  228  1809 cputs
  9291                                  ;  229  1815 exitR
  9292                                  ;  230  1821 prs
  9293                                  ;  231  1825 prs
  9294                                  ;  232  1829 prs
  9295                                  ;  233  1833 prs
  9296                                  ;  234  1837 prs
  9297                                  ;  235  1841 prs
  9298                                  ;  236  1845 prs
  9299                                  ;  237  1849 prs
  9300                                  ;  238  1853 prs
  9301                                  ;  239  1857 prs
  9302                                  ;  240  1861 printIntU
  9303                                  ;  241  1871 strcpy
  9304                                  ;  242  1878 strlen
  9305                                  ;  243  1885 searchLabel
  9306                                  ;  244  1897 error1
  9307                                  ;  245  1904 prs
  9308                                  ;  246  1908 printIntU
  9309                                  ;  247  1918 prs
  9310                                  ;  248  1922 prs
  9311                                  ;  249  1926 prs
  9312                                  ;  250  1930 prs
  9313                                  ;  251  1934 prs
  9314                                  ;  252  1938 prs
  9315                                  ;  253  1942 printIntU
  9316                                  ;  254  1952 prs
  9317                                  ;  255  1956 prs
  9318                                  ;  256  1960 printIntU
  9319                                  ;  257  1970 fputcR
  9320                                  ;  258  1977 fcloseR
  9321                                  ;  259  1985 fcloseR
  9322                                  ;  260  1993 fcloseR
  9323                                  ;  261  2001 exitR
  9324                                  ;  262  2007 genCode8
  9325                                  ;  263  2016 genCode8
  9326                                  ;  264  2025 genCode8
  9327                                  ;  265  2034 errorexit
  9328                                  ;  266  2044 genCode8
  9329                                  ;  267  2053 genCode8
  9330                                  ;  268  2062 genCode16
  9331                                  ;  269  2072 genCode16
  9332                                  ;  270  2082 genCode8
  9333                                  ;  271  2091 genCode8
  9334                                  ;  272  2100 genCode16
  9335                                  ;  273  2110 genCode32
  9336                                  ;  274  2120 genCode16
  9337                                  ;  275  2130 genCode8
  9338                                  ;  276  2139 getTokeType
  9339                                  ;  277  2151 getCodeSize
  9340                                  ;  278  2163 getCodes
  9341                                  ;  279  2172 genCode8
  9342                                  ;  280  2181 getOpL
  9343                                  ;  281  2188 checkOpL
  9344                                  ;  282  2197 genCode2
  9345                                  ;  283  2206 getTokeType
  9346                                  ;  284  2218 implerror
  9347                                  ;  285  2228 genCodeW
  9348                                  ;  286  2237 writeEA
  9349                                  ;  287  2245 check2Ops
  9350                                  ;  288  2255 reg16error
  9351                                  ;  289  2266 addrerror
  9352                                  ;  290  2276 genCode8
  9353                                  ;  291  2285 genCode8
  9354                                  ;  292  2294 writeEA
  9355                                  ;  293  2302 check2Ops
  9356                                  ;  294  2312 setsflag
  9357                                  ;  295  2321 genCodeW
  9358                                  ;  296  2330 genImmediate
  9359                                  ;  297  2343 genCodeW
  9360                                  ;  298  2352 writeEA
  9361                                  ;  299  2360 genCode8
  9362                                  ;  300  2369 genImmediate
  9363                                  ;  301  2382 genCodeW
  9364                                  ;  302  2391 writeEA
  9365                                  ;  303  2399 genCodeW
  9366                                  ;  304  2408 writeEA
  9367                                  ;  305  2416 syntaxerror
  9368                                  ;  306  2428 check2Ops
  9369                                  ;  307  2438 notfounderror
  9370                                  ;  308  2452 genCode2
  9371                                  ;  309  2461 genImmediate
  9372                                  ;  310  2474 genCodeW
  9373                                  ;  311  2483 writeEA
  9374                                  ;  312  2491 genImmediate
  9375                                  ;  313  2504 regmemerror
  9376                                  ;  314  2516 ChangeDirection
  9377                                  ;  315  2532 reg16error
  9378                                  ;  316  2543 genCode2
  9379                                  ;  317  2552 writeEA
  9380                                  ;  318  2560 genCodeW
  9381                                  ;  319  2569 genCode16
  9382                                  ;  320  2579 genCodeW
  9383                                  ;  321  2588 genCode16
  9384                                  ;  322  2598 genCodeW
  9385                                  ;  323  2607 writeEA
  9386                                  ;  324  2615 ChangeDirection
  9387                                  ;  325  2631 genCodeW
  9388                                  ;  326  2640 writeEA
  9389                                  ;  327  2648 syntaxerror
  9390                                  ;  328  2660 searchLabel
  9391                                  ;  329  2672 checkConstSize
  9392                                  ;  330  2687 genCode2
  9393                                  ;  331  2696 genCode8
  9394                                  ;  332  2705 genCode8
  9395                                  ;  333  2714 genCode2
  9396                                  ;  334  2723 genCode16
  9397                                  ;  335  2733 genCode8
  9398                                  ;  336  2742 genCode2
  9399                                  ;  337  2751 storeJmp
  9400                                  ;  338  2760 genCode16
  9401                                  ;  339  2770 searchLabel
  9402                                  ;  340  2782 checkConstSize
  9403                                  ;  341  2797 genCode8
  9404                                  ;  342  2806 genCode8
  9405                                  ;  343  2815 genCode8
  9406                                  ;  344  2824 genCode16
  9407                                  ;  345  2834 genCode8
  9408                                  ;  346  2843 genCode16
  9409                                  ;  347  2853 genCode8
  9410                                  ;  348  2862 storeJmp
  9411                                  ;  349  2871 genCode16
  9412                                  ;  350  2881 genCode8
  9413                                  ;  351  2890 genCode16
  9414                                  ;  352  2900 genCode8
  9415                                  ;  353  2909 getOpL
  9416                                  ;  354  2916 setsflag
  9417                                  ;  355  2925 genCode2
  9418                                  ;  356  2934 genCode8
  9419                                  ;  357  2943 genCode16
  9420                                  ;  358  2953 genCode8
  9421                                  ;  359  2962 genCode16
  9422                                  ;  360  2972 genCode8
  9423                                  ;  361  2981 storeJmp
  9424                                  ;  362  2990 genCode16
  9425                                  ;  363  3000 error1
  9426                                  ;  364  3007 genCode8
  9427                                  ;  365  3016 genCode8
  9428                                  ;  366  3025 checkOpL
  9429                                  ;  367  3034 reg16error
  9430                                  ;  368  3045 genCode2
  9431                                  ;  369  3054 genCode8
  9432                                  ;  370  3063 writeEA
  9433                                  ;  371  3071 syntaxerror
  9434                                  ;  372  3083 check2Ops
  9435                                  ;  373  3093 genCodeW
  9436                                  ;  374  3102 writeEA
  9437                                  ;  375  3110 genCodeW
  9438                                  ;  376  3119 writeEA
  9439                                  ;  377  3127 genCode8
  9440                                  ;  378  3136 genCodeW
  9441                                  ;  379  3145 writeEA
  9442                                  ;  380  3153 genCode8
  9443                                  ;  381  3162 genCode8
  9444                                  ;  382  3171 genCode8
  9445                                  ;  383  3180 getOp1
  9446                                  ;  384  3187 genCode16
  9447                                  ;  385  3197 numbererror
  9448                                  ;  386  3209 need
  9449                                  ;  387  3214 getOp1
  9450                                  ;  388  3221 genCode8
  9451                                  ;  389  3230 numbererror
  9452                                  ;  390  3242 numbererror
  9453                                  ;  391  3254 numbererror
  9454                                  ;  392  3266 prs
  9455                                  ;  393  3270 prs
  9456                                  ;  394  3274 error1
  9457                                  ;  395  3281 error1
  9458                                  ;  396  3288 prs
  9459                                  ;  397  3292 prs
  9460                                  ;  398  3296 prs
  9461                                  ;  399  3300 printIntU
  9462                                  ;  400  3310 prs
  9463                                  ;  401  3314 printIntU
  9464                                  ;  402  3324 fixJmp
  9465                                  ;  403  3331 error1
  9466                                  ;Input: AS.C, List: AS.S,  Lines: 1444
  9467                                  ;Glob. variables:  189 max.:  200
  9468                                  ;Functions      :   89 max.:  300
  9469                                  ;Calls          :  404 max.: 2000, NameField: 3338 max.:    65535
  9470                                  ;Code until     :21667 max.: 30000, free: 8333
  9471                                  ;Data (HeapEnd) :62154, resting stacksize:  3381 *** Warning *** Stack too small
  9472                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
