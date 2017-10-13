     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9D41C                  jmp main
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
   943 00000489 E8380E                   call eqstr
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
  1079 00000532 E84016                   call implerror
  1080                                  
  1081                                  ;-248     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  1082                                  
  1083                                  .checkOpL8:
  1084 00000535 A0[3600]                 mov al, [R1Type]
  1085 00000538 3C04                     cmp al, 4
  1086 0000053A 0F850600                 jne .checkOpL9
  1087 0000053E E8FC16                   call segregerror
  1088 00000541 E93E00                   jmp .retncheckOpL
  1089                                  
  1090                                  ;-249     setwflag();
  1091                                  
  1092                                  .checkOpL9:
  1093 00000544 E87303                   call setwflag
  1094                                  
  1095                                  ;-250     if (OpSize == 0) error1("no op size declared");
  1096                                  
  1097 00000547 A0[3700]                 mov al, [OpSize]
  1098 0000054A 3C00                     cmp al, 0
  1099 0000054C 0F850900                 jne .checkOpL10
  1100 00000550 68[8305]                 push checkOpL_0
  1101 00000553 E83B15                   call error1
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
  1122 0000057C E81215                   call error1
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
  1156 000005B7 E87C15                   call addrerror
  1157                                  
  1158                                  ;-258     if (Op == ADR) invaloperror();
  1159                                  
  1160                                  .check2Ops14:
  1161 000005BA A0[2D00]                 mov al, [Op]
  1162 000005BD 3C03                     cmp al, 3
  1163 000005BF 0F850300                 jne .check2Ops15
  1164 000005C3 E8EA15                   call invaloperror
  1165                                  
  1166                                  ;-259     if (Op == IMM) immeerror();
  1167                                  
  1168                                  .check2Ops15:
  1169 000005C6 A0[2D00]                 mov al, [Op]
  1170 000005C9 3C01                     cmp al, 1
  1171 000005CB 0F850300                 jne .check2Ops16
  1172 000005CF E87E15                   call immeerror
  1173                                  
  1174                                  ;-260     if (Op2==   0) addrerror();
  1175                                  
  1176                                  .check2Ops16:
  1177 000005D2 A0[2E00]                 mov al, [Op2]
  1178 000005D5 3C00                     cmp al, 0
  1179 000005D7 0F850300                 jne .check2Ops17
  1180 000005DB E85815                   call addrerror
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
  1191 000005F0 E8BD15                   call invaloperror
  1192                                  
  1193                                  ;-262     setwflag();
  1194                                  
  1195                                  .check2Ops19:
  1196                                  .check2Ops18:
  1197 000005F3 E8C402                   call setwflag
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
  1216 000005FC E80F09                   call need
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
  1279 0000062E E88600                   call getOp1
  1280 00000631 A2[2E00]                 mov byte [Op2], al
  1281                                  
  1282                                  ;-280     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1283                                  
  1284 00000634 6A5B                     push 91
  1285 00000636 E8AD08                   call isToken
  1286 00000639 83C402                   add  sp, 2
  1287 0000063C 08C0                     or  al, al
  1288 0000063E 0F840C00                 je .getOpR20
  1289 00000642 B80400                   mov ax, 4
  1290 00000645 A2[2E00]                 mov byte [Op2], al
  1291 00000648 E8BB00                   call getMEM
  1292 0000064B E94F00                   jmp .retngetOpR
  1293                                  
  1294                                  ;-281     if (Op2 == 0)     {invaloperror();         return;}
  1295                                  
  1296                                  .getOpR20:
  1297 0000064E A0[2E00]                 mov al, [Op2]
  1298 00000651 3C00                     cmp al, 0
  1299 00000653 0F850600                 jne .getOpR21
  1300 00000657 E85615                   call invaloperror
  1301 0000065A E94000                   jmp .retngetOpR
  1302                                  
  1303                                  ;-282     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1304                                  
  1305                                  .getOpR21:
  1306 0000065D A0[2E00]                 mov al, [Op2]
  1307 00000660 3C01                     cmp al, 1
  1308 00000662 0F850900                 jne .getOpR22
  1309 00000666 A1[0E00]                 mov ax, [SymbolInt]
  1310 00000669 A3[3F00]                 mov word [imme], ax
  1311 0000066C E92E00                   jmp .retngetOpR
  1312                                  
  1313                                  ;-283     if (Op2 == REG)                            return;
  1314                                  
  1315                                  .getOpR22:
  1316 0000066F A0[2E00]                 mov al, [Op2]
  1317 00000672 3C02                     cmp al, 2
  1318 00000674 0F850300                 jne .getOpR23
  1319 00000678 E92200                   jmp .retngetOpR
  1320                                  
  1321                                  ;-284     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1322                                  
  1323                                  .getOpR23:
  1324 0000067B A0[2E00]                 mov al, [Op2]
  1325 0000067E 3C03                     cmp al, 3
  1326 00000680 0F851000                 jne .getOpR24
  1327 00000684 8B1E[4E00]               mov bx, [LabelIx]
  1328 00000688 D1E3                     shl bx, 1
  1329 0000068A 8B87CA8E                 mov ax, [LabelAddr + bx]
  1330 0000068E A3[3D00]                 mov word [disp], ax
  1331 00000691 E90900                   jmp .retngetOpR
  1332                                  
  1333                                  ;-285     error1("Name of operand expected");
  1334                                  
  1335                                  .getOpR24:
  1336 00000694 68[9E06]                 push getOpR_0
  1337 00000697 E8F713                   call error1
  1338 0000069A 83C402                   add  sp, 2
  1339                                  
  1340                                  ;-286 }
  1341                                  
  1342                                  
  1343                                  ;-287 
  1344                                  
  1345                                  
  1346                                  ;-288 int getOp1() {//scan for a single operand
  1347                                  
  1348                                   .retngetOpR:
  1349 0000069D C3                       ret
  1350 0000069E 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1351 000006A7 706572616E64206578-
  1352 000006B0 70656374656400     
  1353                                  ENDP
  1354                                  
  1355                                  getOp1: PROC
  1356                                  
  1357                                  ;-289 //return:0, IMM, REG, ADR (not MEM)
  1358                                  
  1359                                  
  1360                                  ;-290 //set   :R2Type, R2No by testReg
  1361                                  
  1362                                  
  1363                                  ;-291 //set   :LabelIx by searchLabel
  1364                                  
  1365                                  
  1366                                  ;-292     if (TokeType == 0)      return 0;
  1367                                  
  1368 000006B7 A0[2C00]                 mov al, [TokeType]
  1369 000006BA 3C00                     cmp al, 0
  1370 000006BC 0F850600                 jne .getOp125
  1371 000006C0 B80000                   mov ax, 0
  1372 000006C3 E93F00                   jmp .retngetOp1
  1373                                  
  1374                                  ;-293     if (TokeType == DIGIT)  return IMM;
  1375                                  
  1376                                  .getOp125:
  1377 000006C6 A0[2C00]                 mov al, [TokeType]
  1378 000006C9 3C01                     cmp al, 1
  1379 000006CB 0F850600                 jne .getOp126
  1380 000006CF B80100                   mov ax, 1
  1381 000006D2 E93000                   jmp .retngetOp1
  1382                                  
  1383                                  ;-294     if (TokeType == ALNUME) {
  1384                                  
  1385                                  .getOp126:
  1386 000006D5 A0[2C00]                 mov al, [TokeType]
  1387 000006D8 3C03                     cmp al, 3
  1388 000006DA 0F852100                 jne .getOp127
  1389                                  
  1390                                  ;-295         R2No=testReg();
  1391                                  
  1392 000006DE E8960D                   call testReg
  1393 000006E1 A2[3300]                 mov byte [R2No], al
  1394                                  
  1395                                  ;-296         if (R2Type)        return REG;
  1396                                  
  1397 000006E4 A0[3500]                 mov al, [R2Type]
  1398 000006E7 08C0                     or  al, al
  1399 000006E9 0F840600                 je .getOp128
  1400 000006ED B80200                   mov ax, 2
  1401 000006F0 E91200                   jmp .retngetOp1
  1402                                  
  1403                                  ;-297         LabelIx=searchLabel();
  1404                                  
  1405                                  .getOp128:
  1406 000006F3 E88C05                   call searchLabel
  1407 000006F6 A3[4E00]                 mov word [LabelIx], ax
  1408                                  
  1409                                  ;-298         return ADR;
  1410                                  
  1411 000006F9 B80300                   mov ax, 3
  1412 000006FC E90600                   jmp .retngetOp1
  1413                                  
  1414                                  ;-299 //        if (LabelIx)        return ADR;
  1415                                  
  1416                                  
  1417                                  ;-300 //        else error1("variable not found");
  1418                                  
  1419                                  
  1420                                  ;-301     }
  1421                                  
  1422                                  
  1423                                  ;-302     return 0;
  1424                                  
  1425                                  .getOp127:
  1426 000006FF B80000                   mov ax, 0
  1427 00000702 E90000                   jmp .retngetOp1
  1428                                  
  1429                                  ;-303 }
  1430                                  
  1431                                  
  1432                                  ;-304 
  1433                                  
  1434                                  
  1435                                  ;-305 int getMEM() {// e.g. [array+bp+si-4]
  1436                                  
  1437                                   .retngetOp1:
  1438 00000705 C3                       ret
  1439                                  ENDP
  1440                                  
  1441                                  getMEM: PROC
  1442                                  
  1443                                  ;-306 //set: disp, rm, R2Type
  1444                                  
  1445                                  
  1446                                  ;-307     char c;
  1447                                  
  1448                                  
  1449                                  ;-308     disp=0; rm=0;
  1450                                  
  1451                                  ;Function : getMEM, Number of local variables: 1
  1452                                  ;   # type sign width addr used name   list of local variables
  1453                                  ;  200 var sign byte   307 NULL c = bp-2;
  1454 00000706 C8020000                 ENTER  2,0
  1455 0000070A B80000                   mov ax, 0
  1456 0000070D A3[3D00]                 mov word [disp], ax
  1457 00000710 B80000                   mov ax, 0
  1458 00000713 A2[3B00]                 mov byte [rm], al
  1459                                  
  1460                                  ;-309     do {
  1461                                  
  1462                                  .getMEM29:
  1463                                  
  1464                                  ;-310         getTokeType();
  1465                                  
  1466 00000716 E8AF03                   call getTokeType
  1467                                  
  1468                                  ;-311         c=getOp1();
  1469                                  
  1470 00000719 E89BFF                   call getOp1
  1471 0000071C 8846FE                   mov [bp-2], al
  1472                                  
  1473                                  ;-312         if (c ==   0) syntaxerror();
  1474                                  
  1475 0000071F 8A46FE                   mov al, [bp-2]
  1476 00000722 3C00                     cmp al, 0
  1477 00000724 0F850300                 jne .getMEM30
  1478 00000728 E83915                   call syntaxerror
  1479                                  
  1480                                  ;-313         if (c == REG) {
  1481                                  
  1482                                  .getMEM30:
  1483 0000072B 8A46FE                   mov al, [bp-2]
  1484 0000072E 3C02                     cmp al, 2
  1485 00000730 0F851B00                 jne .getMEM31
  1486                                  
  1487                                  ;-314             isDirect=0;
  1488                                  
  1489 00000734 B80000                   mov ax, 0
  1490 00000737 A2[3C00]                 mov byte [isDirect], al
  1491                                  
  1492                                  ;-315             if (rm) rm=getIndReg2();
  1493                                  
  1494 0000073A A0[3B00]                 mov al, [rm]
  1495 0000073D 08C0                     or  al, al
  1496 0000073F 0F840900                 je .getMEM32
  1497 00000743 E8F600                   call getIndReg2
  1498 00000746 A2[3B00]                 mov byte [rm], al
  1499                                  
  1500                                  ;-316             else getIndReg1();
  1501                                  
  1502 00000749 E90300                   jmp .getMEM33
  1503                                  .getMEM32:
  1504 0000074C E89800                   call getIndReg1
  1505                                  
  1506                                  ;-317         }
  1507                                  
  1508                                  .getMEM33:
  1509                                  
  1510                                  ;-318         if (c == ADR) {
  1511                                  
  1512                                  .getMEM31:
  1513 0000074F 8A46FE                   mov al, [bp-2]
  1514 00000752 3C03                     cmp al, 3
  1515 00000754 0F851F00                 jne .getMEM34
  1516                                  
  1517                                  ;-319             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  1518                                  
  1519 00000758 A1[4E00]                 mov ax, [LabelIx]
  1520 0000075B 08C0                     or  al, al
  1521 0000075D 0F841300                 je .getMEM35
  1522 00000761 A1[3D00]                 mov ax, [disp]
  1523 00000764 8B1E[4E00]               mov bx, [LabelIx]
  1524 00000768 D1E3                     shl bx, 1
  1525 0000076A 0387CA8E                 add ax, [LabelAddr + bx]
  1526 0000076E A3[3D00]                 mov word [disp], ax
  1527                                  
  1528                                  ;-320             else notfounderror();
  1529                                  
  1530 00000771 E90300                   jmp .getMEM36
  1531                                  .getMEM35:
  1532 00000774 E88A13                   call notfounderror
  1533                                  
  1534                                  ;-321         }
  1535                                  
  1536                                  .getMEM36:
  1537                                  
  1538                                  ;-322         if (c == IMM) disp=disp+SymbolInt;
  1539                                  
  1540                                  .getMEM34:
  1541 00000777 8A46FE                   mov al, [bp-2]
  1542 0000077A 3C01                     cmp al, 1
  1543 0000077C 0F850A00                 jne .getMEM37
  1544 00000780 A1[3D00]                 mov ax, [disp]
  1545 00000783 0306[0E00]               add ax, [SymbolInt]
  1546 00000787 A3[3D00]                 mov word [disp], ax
  1547                                  
  1548                                  ;-323         if (isToken('-')) {
  1549                                  
  1550                                  .getMEM37:
  1551 0000078A 6A2D                     push 45
  1552 0000078C E85707                   call isToken
  1553 0000078F 83C402                   add  sp, 2
  1554 00000792 08C0                     or  al, al
  1555 00000794 0F841900                 je .getMEM38
  1556                                  
  1557                                  ;-324             getTokeType();
  1558                                  
  1559 00000798 E82D03                   call getTokeType
  1560                                  
  1561                                  ;-325             if (TokeType != DIGIT) numbererror();
  1562                                  
  1563 0000079B A0[2C00]                 mov al, [TokeType]
  1564 0000079E 3C01                     cmp al, 1
  1565 000007A0 0F840300                 je  .getMEM39
  1566 000007A4 E82A14                   call numbererror
  1567                                  
  1568                                  ;-326             disp = disp - SymbolInt;
  1569                                  
  1570                                  .getMEM39:
  1571 000007A7 A1[3D00]                 mov ax, [disp]
  1572 000007AA 2B06[0E00]               sub ax, [SymbolInt]
  1573 000007AE A3[3D00]                 mov word [disp], ax
  1574                                  
  1575                                  ;-327         }
  1576                                  
  1577                                  
  1578                                  ;-328     } while (isToken('+'));
  1579                                  
  1580                                  .getMEM38:
  1581 000007B1 6A2B                     push 43
  1582 000007B3 E83007                   call isToken
  1583 000007B6 83C402                   add  sp, 2
  1584 000007B9 08C0                     or  al, al
  1585 000007BB 0F840300                 je .getMEM40
  1586 000007BF E954FF                   jmp .getMEM29
  1587                                  .getMEM40:
  1588                                  
  1589                                  ;-329     if (isToken(']') == 0) errorexit("] expected");
  1590                                  
  1591 000007C2 6A5D                     push 93
  1592 000007C4 E81F07                   call isToken
  1593 000007C7 83C402                   add  sp, 2
  1594 000007CA 83F800                   cmp ax, 0
  1595 000007CD 0F850900                 jne .getMEM41
  1596 000007D1 68[DC07]                 push getMEM_0
  1597 000007D4 E81013                   call errorexit
  1598 000007D7 83C402                   add  sp, 2
  1599                                  
  1600                                  ;-330 }
  1601                                  
  1602                                  .getMEM41:
  1603                                  
  1604                                  ;-331 int getIndReg1() {
  1605 000007DA C9                       LEAVE
  1606 000007DB C3                       ret
  1607 000007DC 5D2065787065637465-     getMEM_0 db "] expected",0
  1608 000007E5 6400               
  1609                                  ENDP
  1610                                  
  1611                                  getIndReg1: PROC
  1612                                  
  1613                                  ;-332     if (R2Type !=WORD) indexerror();
  1614                                  
  1615 000007E7 A0[3500]                 mov al, [R2Type]
  1616 000007EA 3C02                     cmp al, 2
  1617 000007EC 0F840300                 je  .getIndReg142
  1618 000007F0 E89C13                   call indexerror
  1619                                  
  1620                                  ;-333     if (R2No==3) rm=7;//BX
  1621                                  
  1622                                  .getIndReg142:
  1623 000007F3 A0[3300]                 mov al, [R2No]
  1624 000007F6 3C03                     cmp al, 3
  1625 000007F8 0F850600                 jne .getIndReg143
  1626 000007FC B80700                   mov ax, 7
  1627 000007FF A2[3B00]                 mov byte [rm], al
  1628                                  
  1629                                  ;-334     if (R2No==5) rm=6;//BP, change to BP+0
  1630                                  
  1631                                  .getIndReg143:
  1632 00000802 A0[3300]                 mov al, [R2No]
  1633 00000805 3C05                     cmp al, 5
  1634 00000807 0F850600                 jne .getIndReg144
  1635 0000080B B80600                   mov ax, 6
  1636 0000080E A2[3B00]                 mov byte [rm], al
  1637                                  
  1638                                  ;-335     if (R2No==7) rm=5;//DI
  1639                                  
  1640                                  .getIndReg144:
  1641 00000811 A0[3300]                 mov al, [R2No]
  1642 00000814 3C07                     cmp al, 7
  1643 00000816 0F850600                 jne .getIndReg145
  1644 0000081A B80500                   mov ax, 5
  1645 0000081D A2[3B00]                 mov byte [rm], al
  1646                                  
  1647                                  ;-336     if (R2No==6) rm=4;//SI
  1648                                  
  1649                                  .getIndReg145:
  1650 00000820 A0[3300]                 mov al, [R2No]
  1651 00000823 3C06                     cmp al, 6
  1652 00000825 0F850600                 jne .getIndReg146
  1653 00000829 B80400                   mov ax, 4
  1654 0000082C A2[3B00]                 mov byte [rm], al
  1655                                  
  1656                                  ;-337     if (rm==0) indexerror();
  1657                                  
  1658                                  .getIndReg146:
  1659 0000082F A0[3B00]                 mov al, [rm]
  1660 00000832 3C00                     cmp al, 0
  1661 00000834 0F850300                 jne .getIndReg147
  1662 00000838 E85413                   call indexerror
  1663                                  
  1664                                  ;-338 }
  1665                                  
  1666                                  .getIndReg147:
  1667                                  
  1668                                  ;-339 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1669                                  
  1670 0000083B C3                       ret
  1671                                  ENDP
  1672                                  
  1673                                  getIndReg2: PROC
  1674                                  ;Function : getIndReg2, Number of local variables: 1
  1675                                  ;   # type sign width addr used name   list of local variables
  1676                                  ;  200 var sign byte   339 NULL m = bp-2;
  1677 0000083C C8020000                 ENTER  2,0
  1678 00000840 B80400                   mov ax, 4
  1679 00000843 8846FE                   mov [bp-2], al
  1680                                  
  1681                                  ;-340     if (R2Type !=WORD) indexerror();
  1682                                  
  1683 00000846 A0[3500]                 mov al, [R2Type]
  1684 00000849 3C02                     cmp al, 2
  1685 0000084B 0F840300                 je  .getIndReg248
  1686 0000084F E83D13                   call indexerror
  1687                                  
  1688                                  ;-341     if (R2No==7) if (rm==6) m=3;//BP+DI
  1689                                  
  1690                                  .getIndReg248:
  1691 00000852 A0[3300]                 mov al, [R2No]
  1692 00000855 3C07                     cmp al, 7
  1693 00000857 0F852100                 jne .getIndReg249
  1694 0000085B A0[3B00]                 mov al, [rm]
  1695 0000085E 3C06                     cmp al, 6
  1696 00000860 0F850900                 jne .getIndReg250
  1697 00000864 B80300                   mov ax, 3
  1698 00000867 8846FE                   mov [bp-2], al
  1699                                  
  1700                                  ;-342              else if (rm==7) m=1;//BX+DI
  1701                                  
  1702 0000086A E90F00                   jmp .getIndReg251
  1703                                  .getIndReg250:
  1704 0000086D A0[3B00]                 mov al, [rm]
  1705 00000870 3C07                     cmp al, 7
  1706 00000872 0F850600                 jne .getIndReg252
  1707 00000876 B80100                   mov ax, 1
  1708 00000879 8846FE                   mov [bp-2], al
  1709                                  
  1710                                  ;-343     if (R2No==6) if (rm==6) m=2;//BP+SI
  1711                                  
  1712                                  .getIndReg252:
  1713                                  .getIndReg251:
  1714                                  .getIndReg249:
  1715 0000087C A0[3300]                 mov al, [R2No]
  1716 0000087F 3C06                     cmp al, 6
  1717 00000881 0F852100                 jne .getIndReg253
  1718 00000885 A0[3B00]                 mov al, [rm]
  1719 00000888 3C06                     cmp al, 6
  1720 0000088A 0F850900                 jne .getIndReg254
  1721 0000088E B80200                   mov ax, 2
  1722 00000891 8846FE                   mov [bp-2], al
  1723                                  
  1724                                  ;-344              else if (rm==7) m=0;//BX+SI
  1725                                  
  1726 00000894 E90F00                   jmp .getIndReg255
  1727                                  .getIndReg254:
  1728 00000897 A0[3B00]                 mov al, [rm]
  1729 0000089A 3C07                     cmp al, 7
  1730 0000089C 0F850600                 jne .getIndReg256
  1731 000008A0 B80000                   mov ax, 0
  1732 000008A3 8846FE                   mov [bp-2], al
  1733                                  
  1734                                  ;-345     if (m > 3) indexerror();
  1735                                  
  1736                                  .getIndReg256:
  1737                                  .getIndReg255:
  1738                                  .getIndReg253:
  1739 000008A6 8A46FE                   mov al, [bp-2]
  1740 000008A9 3C03                     cmp al, 3
  1741 000008AB 0F8E0300                 jle .getIndReg257
  1742 000008AF E8DD12                   call indexerror
  1743                                  
  1744                                  ;-346     return m;
  1745                                  
  1746                                  .getIndReg257:
  1747 000008B2 8A46FE                   mov al, [bp-2]
  1748 000008B5 E90000                   jmp .retngetIndReg2
  1749                                  
  1750                                  ;-347 }
  1751                                  
  1752                                  
  1753                                  ;-348 
  1754                                  
  1755                                  
  1756                                  ;-349 int setwflag() {//word size, bit 0
  1757                                  
  1758 000008B8 C9                       .retngetIndReg2: LEAVE
  1759 000008B9 C3                       ret
  1760                                  ENDP
  1761                                  
  1762                                  setwflag: PROC
  1763                                  
  1764                                  ;-350     wflag=0;
  1765                                  
  1766 000008BA B80000                   mov ax, 0
  1767 000008BD A2[3800]                 mov byte [wflag], al
  1768                                  
  1769                                  ;-351     if (OpSize == 0) {//do not override OpSize
  1770                                  
  1771 000008C0 A0[3700]                 mov al, [OpSize]
  1772 000008C3 3C00                     cmp al, 0
  1773 000008C5 0F853C00                 jne .setwflag58
  1774                                  
  1775                                  ;-352         if (Op == REG) OpSize=R1Type;
  1776                                  
  1777 000008C9 A0[2D00]                 mov al, [Op]
  1778 000008CC 3C02                     cmp al, 2
  1779 000008CE 0F850600                 jne .setwflag59
  1780 000008D2 A0[3600]                 mov al, [R1Type]
  1781 000008D5 A2[3700]                 mov byte [OpSize], al
  1782                                  
  1783                                  ;-353         if (Op2== REG) OpSize=R2Type;
  1784                                  
  1785                                  .setwflag59:
  1786 000008D8 A0[2E00]                 mov al, [Op2]
  1787 000008DB 3C02                     cmp al, 2
  1788 000008DD 0F850600                 jne .setwflag60
  1789 000008E1 A0[3500]                 mov al, [R2Type]
  1790 000008E4 A2[3700]                 mov byte [OpSize], al
  1791                                  
  1792                                  ;-354         if (R2Type== SEGREG) OpSize=WORD;
  1793                                  
  1794                                  .setwflag60:
  1795 000008E7 A0[3500]                 mov al, [R2Type]
  1796 000008EA 3C04                     cmp al, 4
  1797 000008EC 0F850600                 jne .setwflag61
  1798 000008F0 B80200                   mov ax, 2
  1799 000008F3 A2[3700]                 mov byte [OpSize], al
  1800                                  
  1801                                  ;-355         if (R1Type == SEGREG) OpSize=WORD;
  1802                                  
  1803                                  .setwflag61:
  1804 000008F6 A0[3600]                 mov al, [R1Type]
  1805 000008F9 3C04                     cmp al, 4
  1806 000008FB 0F850600                 jne .setwflag62
  1807 000008FF B80200                   mov ax, 2
  1808 00000902 A2[3700]                 mov byte [OpSize], al
  1809                                  
  1810                                  ;-356     }
  1811                                  
  1812                                  .setwflag62:
  1813                                  
  1814                                  ;-357     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1815                                  
  1816                                  .setwflag58:
  1817 00000905 A0[3700]                 mov al, [OpSize]
  1818 00000908 3C03                     cmp al, 3
  1819 0000090A 0F850900                 jne .setwflag63
  1820 0000090E E85318                   call gen66h
  1821 00000911 B80100                   mov ax, 1
  1822 00000914 A2[3800]                 mov byte [wflag], al
  1823                                  
  1824                                  ;-358     if (OpSize  ==  WORD) wflag=1;
  1825                                  
  1826                                  .setwflag63:
  1827 00000917 A0[3700]                 mov al, [OpSize]
  1828 0000091A 3C02                     cmp al, 2
  1829 0000091C 0F850600                 jne .setwflag64
  1830 00000920 B80100                   mov ax, 1
  1831 00000923 A2[3800]                 mov byte [wflag], al
  1832                                  
  1833                                  ;-359 }
  1834                                  
  1835                                  .setwflag64:
  1836                                  
  1837                                  ;-360 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  1838                                  
  1839 00000926 C3                       ret
  1840                                  ENDP
  1841                                  
  1842                                  setsflag: PROC
  1843                                  
  1844                                  ;-361     unsigned int ui;
  1845                                  
  1846                                  
  1847                                  ;-362     sflag=2;
  1848                                  
  1849                                  ;Function : setsflag, Number of local variables: 1
  1850                                  ;   # type sign width addr used name   list of local variables
  1851                                  ;  200 var unsg word   361 NULL ui = bp-2;
  1852 00000927 C8020000                 ENTER  2,0
  1853 0000092B B80200                   mov ax, 2
  1854 0000092E A2[3A00]                 mov byte [sflag], al
  1855                                  
  1856                                  ;-363     ui = imme & 0xFF80;//is greater than signed 127?
  1857                                  
  1858 00000931 A1[3F00]                 mov ax, [imme]
  1859 00000934 2580FF                   and ax, 65408
  1860 00000937 8946FE                   mov [bp-2], ax
  1861                                  
  1862                                  ;-364     if(ui != 0) sflag = 0;
  1863                                  
  1864 0000093A 8B46FE                   mov ax, [bp-2]
  1865 0000093D 83F800                   cmp ax, 0
  1866 00000940 0F840600                 je  .setsflag65
  1867 00000944 B80000                   mov ax, 0
  1868 00000947 A2[3A00]                 mov byte [sflag], al
  1869                                  
  1870                                  ;-365     if (OpSize == BYTE) {
  1871                                  
  1872                                  .setsflag65:
  1873 0000094A A0[3700]                 mov al, [OpSize]
  1874 0000094D 3C01                     cmp al, 1
  1875 0000094F 0F851900                 jne .setsflag66
  1876                                  
  1877                                  ;-366         if (imme > 255) error1("too big for byte r/m");
  1878                                  
  1879 00000953 A1[3F00]                 mov ax, [imme]
  1880 00000956 3DFF00                   cmp ax, 255
  1881 00000959 0F8E0900                 jle .setsflag67
  1882 0000095D 68[6E09]                 push setsflag_0
  1883 00000960 E82E11                   call error1
  1884 00000963 83C402                   add  sp, 2
  1885                                  
  1886                                  ;-367         sflag=0;//byte reg does not need sign extended
  1887                                  
  1888                                  .setsflag67:
  1889 00000966 B80000                   mov ax, 0
  1890 00000969 A2[3A00]                 mov byte [sflag], al
  1891                                  
  1892                                  ;-368     }
  1893                                  
  1894                                  
  1895                                  ;-369 }
  1896                                  
  1897                                  .setsflag66:
  1898                                  
  1899                                  ;-370 int checkConstSize(unsigned int ui) {
  1900 0000096C C9                       LEAVE
  1901 0000096D C3                       ret
  1902 0000096E 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1903 00000977 6F7220627974652072-
  1904 00000980 2F6D00             
  1905                                  ENDP
  1906                                  
  1907                                  checkConstSize: PROC
  1908                                  
  1909                                  ;-371     if (ui > 127   ) return 0;//is near; return sflag
  1910                                  
  1911                                  ;Function : checkConstSize, Number of local variables: 1
  1912                                  ;   # type sign width addr used name   list of local variables
  1913                                  ;  200 var unsg word   370 NULL ui = bp+4;
  1914 00000983 C8000000                 ENTER  0,0
  1915 00000987 8B4604                   mov ax, [bp+4]
  1916 0000098A 83F87F                   cmp ax, 127
  1917 0000098D 0F8E0600                 jle .checkConstSize68
  1918 00000991 B80000                   mov ax, 0
  1919 00000994 E91600                   jmp .retncheckConstSize
  1920                                  
  1921                                  ;-372     if (ui < 0xFF80) return 0;//-128dez
  1922                                  
  1923                                  .checkConstSize68:
  1924 00000997 8B4604                   mov ax, [bp+4]
  1925 0000099A 3D80FF                   cmp ax, 65408
  1926 0000099D 0F8D0600                 jge .checkConstSize69
  1927 000009A1 B80000                   mov ax, 0
  1928 000009A4 E90600                   jmp .retncheckConstSize
  1929                                  
  1930                                  ;-373     return 2;// is short
  1931                                  
  1932                                  .checkConstSize69:
  1933 000009A7 B80200                   mov ax, 2
  1934 000009AA E90000                   jmp .retncheckConstSize
  1935                                  
  1936                                  ;-374 }
  1937                                  
  1938                                  
  1939                                  ;-375 
  1940                                  
  1941                                  
  1942                                  ;-376 
  1943                                  
  1944                                  
  1945                                  ;-377 //#include "PARSE.C"
  1946                                  
  1947                                  
  1948                                  ;-378 int parse() {
  1949                                  
  1950 000009AD C9                       .retncheckConstSize: LEAVE
  1951 000009AE C3                       ret
  1952                                  ENDP
  1953                                  
  1954                                  parse: PROC
  1955                                  
  1956                                  ;-379     LabelNamePtr  = &LabelNames;
  1957                                  
  1958 000009AF B85A77                   mov ax, LabelNames
  1959 000009B2 A3[4600]                 mov word [LabelNamePtr], ax
  1960                                  
  1961                                  ;-380     JmpNamePtr= &JmpNames;
  1962                                  
  1963 000009B5 B87A93                   mov ax, JmpNames
  1964 000009B8 A3[5000]                 mov word [JmpNamePtr], ax
  1965                                  
  1966                                  ;-381     LabelMaxIx=0;
  1967                                  
  1968 000009BB B80000                   mov ax, 0
  1969 000009BE A3[4A00]                 mov word [LabelMaxIx], ax
  1970                                  
  1971                                  ;-382     JmpMaxIx=0;
  1972                                  
  1973 000009C1 B80000                   mov ax, 0
  1974 000009C4 A3[5400]                 mov word [JmpMaxIx], ax
  1975                                  
  1976                                  ;-383     BinLen=0;
  1977                                  
  1978 000009C7 B80000                   mov ax, 0
  1979 000009CA A3[5800]                 mov word [BinLen], ax
  1980                                  
  1981                                  ;-384     isInProc=0;
  1982                                  
  1983 000009CD B80000                   mov ax, 0
  1984 000009D0 A2[0D00]                 mov byte [isInProc], al
  1985                                  
  1986                                  ;-385 
  1987                                  
  1988                                  
  1989                                  ;-386     do {//process a new line
  1990                                  
  1991                                  .parse70:
  1992                                  
  1993                                  ;-387         PCStart=PC;
  1994                                  
  1995 000009D3 A1[2300]                 mov ax, [PC]
  1996 000009D6 A3[2900]                 mov word [PCStart], ax
  1997                                  
  1998                                  ;-388         OpSize=0;
  1999                                  
  2000 000009D9 B80000                   mov ax, 0
  2001 000009DC A2[3700]                 mov byte [OpSize], al
  2002                                  
  2003                                  ;-389         OpPrintIndex=0;
  2004                                  
  2005 000009DF B80000                   mov ax, 0
  2006 000009E2 A3[4100]                 mov word [OpPrintIndex], ax
  2007                                  
  2008                                  ;-390         PrintRA=' ';
  2009                                  
  2010 000009E5 B82000                   mov ax, 32
  2011 000009E8 A2[4500]                 mov byte [PrintRA], al
  2012                                  
  2013                                  ;-391         getLine();
  2014                                  
  2015 000009EB E84806                   call getLine
  2016                                  
  2017                                  ;-392         InputPtr = &InputBuf;
  2018                                  
  2019 000009EE B88D75                   mov ax, InputBuf
  2020 000009F1 A3[1400]                 mov word [InputPtr], ax
  2021                                  
  2022                                  ;-393         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  2023                                  
  2024 000009F4 E8D100                   call getTokeType
  2025                                  
  2026                                  ;-394         if (TokeType == ALNUME) {
  2027                                  
  2028 000009F7 A0[2C00]                 mov al, [TokeType]
  2029 000009FA 3C03                     cmp al, 3
  2030 000009FC 0F852C00                 jne .parse71
  2031                                  
  2032                                  ;-395             if (isLabel) {//set in getName
  2033                                  
  2034 00000A00 A0[2B00]                 mov al, [isLabel]
  2035 00000A03 08C0                     or  al, al
  2036 00000A05 0F842300                 je .parse72
  2037                                  
  2038                                  ;-396               if (isInProc == 0)  strcpy(ProcName, Symbol);
  2039                                  
  2040 00000A09 A0[0D00]                 mov al, [isInProc]
  2041 00000A0C 3C00                     cmp al, 0
  2042 00000A0E 0F851000                 jne .parse73
  2043 00000A12 8D063075                 lea  ax, [Symbol]
  2044 00000A16 50                       push ax
  2045 00000A17 8D066E75                 lea  ax, [ProcName]
  2046 00000A1B 50                       push ax
  2047 00000A1C E86F08                   call strcpy
  2048 00000A1F 83C404                   add  sp, 4
  2049                                  
  2050                                  ;-397                 storeLabel();
  2051                                  
  2052                                  .parse73:
  2053 00000A22 E8B601                   call storeLabel
  2054                                  
  2055                                  ;-398                 InputPtr++;//remove :
  2056                                  
  2057 00000A25 FF06[1400]               inc  word[InputPtr]
  2058                                  
  2059                                  ;-399                 getTokeType();
  2060                                  
  2061 00000A29 E89C00                   call getTokeType
  2062                                  
  2063                                  ;-400             }
  2064                                  
  2065                                  
  2066                                  ;-401         }
  2067                                  
  2068                                  .parse72:
  2069                                  
  2070                                  ;-402         if (TokeType == ALNUME) {
  2071                                  
  2072                                  .parse71:
  2073 00000A2C A0[2C00]                 mov al, [TokeType]
  2074 00000A2F 3C03                     cmp al, 3
  2075 00000A31 0F851B00                 jne .parse74
  2076                                  
  2077                                  ;-403             lookCode();// and OpCodePtr
  2078                                  
  2079 00000A35 E838FA                   call lookCode
  2080                                  
  2081                                  ;-404             if(CodeType) process();
  2082                                  
  2083 00000A38 A0[2F00]                 mov al, [CodeType]
  2084 00000A3B 08C0                     or  al, al
  2085 00000A3D 0F840600                 je .parse75
  2086 00000A41 E83F19                   call process
  2087                                  
  2088                                  ;-405             else getVariable();
  2089                                  
  2090 00000A44 E90300                   jmp .parse76
  2091                                  .parse75:
  2092 00000A47 E88C02                   call getVariable
  2093                                  
  2094                                  ;-406             skipRest();
  2095                                  
  2096                                  .parse76:
  2097 00000A4A E80005                   call skipRest
  2098                                  
  2099                                  ;-407         }
  2100                                  
  2101                                  
  2102                                  ;-408         else if (TokeType >ALNUME) error1("Label or instruction expected");
  2103                                  
  2104 00000A4D E92700                   jmp .parse77
  2105                                  .parse74:
  2106 00000A50 A0[2C00]                 mov al, [TokeType]
  2107 00000A53 3C03                     cmp al, 3
  2108 00000A55 0F8E0C00                 jle .parse78
  2109 00000A59 68[880A]                 push parse_0
  2110 00000A5C E83210                   call error1
  2111 00000A5F 83C402                   add  sp, 2
  2112                                  
  2113                                  ;-409         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  2114                                  
  2115 00000A62 E91200                   jmp .parse79
  2116                                  .parse78:
  2117 00000A65 A0[2C00]                 mov al, [TokeType]
  2118 00000A68 3C01                     cmp al, 1
  2119 00000A6A 0F850900                 jne .parse80
  2120 00000A6E 68[A60A]                 push parse_1
  2121 00000A71 E81D10                   call error1
  2122 00000A74 83C402                   add  sp, 2
  2123                                  
  2124                                  ;-410         printLine();
  2125                                  
  2126                                  .parse80:
  2127                                  .parse79:
  2128                                  .parse77:
  2129 00000A77 E8C40D                   call printLine
  2130                                  
  2131                                  ;-411     } while (DOS_NoBytes != 0 );
  2132                                  
  2133 00000A7A A1[2000]                 mov ax, [DOS_NoBytes]
  2134 00000A7D 83F800                   cmp ax, 0
  2135 00000A80 0F840300                 je  .parse81
  2136 00000A84 E94CFF                   jmp .parse70
  2137                                  .parse81:
  2138                                  
  2139                                  ;-412 }
  2140                                  
  2141                                  
  2142                                  ;-413 
  2143                                  
  2144                                  
  2145                                  ;-414 int getTokeType() {
  2146                                  
  2147 00000A87 C3                       ret
  2148 00000A88 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2149 00000A91 696E73747275637469-
  2150 00000A9A 6F6E20657870656374-
  2151 00000AA3 656400             
  2152 00000AA6 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2153 00000AAF 616C6C6F7765642061-
  2154 00000AB8 74207374617274206F-
  2155 00000AC1 66206C696E6500     
  2156                                  ENDP
  2157                                  
  2158                                  getTokeType: PROC
  2159                                  
  2160                                  ;-415     char c;
  2161                                  
  2162                                  
  2163                                  ;-416     skipBlank();
  2164                                  
  2165                                  ;Function : getTokeType, Number of local variables: 1
  2166                                  ;   # type sign width addr used name   list of local variables
  2167                                  ;  200 var sign byte   415 NULL c = bp-2;
  2168 00000AC8 C8020000                 ENTER  2,0
  2169 00000ACC E88806                   call skipBlank
  2170                                  
  2171                                  ;-417     c = *InputPtr;
  2172                                  
  2173 00000ACF 8B1E[1400]               mov bx, [InputPtr]
  2174 00000AD3 8A07                     mov al, [bx]
  2175 00000AD5 B400                     mov ah, 0
  2176 00000AD7 8846FE                   mov [bp-2], al
  2177                                  
  2178                                  ;-418     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2179                                  
  2180 00000ADA 8A46FE                   mov al, [bp-2]
  2181 00000ADD 3C00                     cmp al, 0
  2182 00000ADF 0F850900                 jne .getTokeType82
  2183 00000AE3 B80000                   mov ax, 0
  2184 00000AE6 A2[2C00]                 mov byte [TokeType], al
  2185 00000AE9 E96600                   jmp .retngetTokeType
  2186                                  
  2187                                  ;-419     if (c == ';') {TokeType=0; return; }//comment
  2188                                  
  2189                                  .getTokeType82:
  2190 00000AEC 8A46FE                   mov al, [bp-2]
  2191 00000AEF 3C3B                     cmp al, 59
  2192 00000AF1 0F850900                 jne .getTokeType83
  2193 00000AF5 B80000                   mov ax, 0
  2194 00000AF8 A2[2C00]                 mov byte [TokeType], al
  2195 00000AFB E95400                   jmp .retngetTokeType
  2196                                  
  2197                                  ;-420     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2198                                  
  2199                                  .getTokeType83:
  2200 00000AFE 8A46FE                   mov al, byte [bp-2]
  2201 00000B01 B400                     mov ah, 0
  2202 00000B03 50                       push ax
  2203 00000B04 E83507                   call digit
  2204 00000B07 83C402                   add  sp, 2
  2205 00000B0A 08C0                     or  al, al
  2206 00000B0C 0F841500                 je .getTokeType84
  2207 00000B10 8A46FE                   mov al, byte [bp-2]
  2208 00000B13 B400                     mov ah, 0
  2209 00000B15 50                       push ax
  2210 00000B16 E85F08                   call getDigit
  2211 00000B19 83C402                   add  sp, 2
  2212 00000B1C B80100                   mov ax, 1
  2213 00000B1F A2[2C00]                 mov byte [TokeType], al
  2214 00000B22 E92D00                   jmp .retngetTokeType
  2215                                  
  2216                                  ;-421     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2217                                  
  2218                                  .getTokeType84:
  2219 00000B25 8A46FE                   mov al, byte [bp-2]
  2220 00000B28 B400                     mov ah, 0
  2221 00000B2A 50                       push ax
  2222 00000B2B E85406                   call letterE
  2223 00000B2E 83C402                   add  sp, 2
  2224 00000B31 08C0                     or  al, al
  2225 00000B33 0F841500                 je .getTokeType85
  2226 00000B37 8A46FE                   mov al, byte [bp-2]
  2227 00000B3A B400                     mov ah, 0
  2228 00000B3C 50                       push ax
  2229 00000B3D E88808                   call getName
  2230 00000B40 83C402                   add  sp, 2
  2231 00000B43 B80300                   mov ax, 3
  2232 00000B46 A2[2C00]                 mov byte [TokeType], al
  2233 00000B49 E90600                   jmp .retngetTokeType
  2234                                  
  2235                                  ;-422     TokeType=NOALNUME;
  2236                                  
  2237                                  .getTokeType85:
  2238 00000B4C B80400                   mov ax, 4
  2239 00000B4F A2[2C00]                 mov byte [TokeType], al
  2240                                  
  2241                                  ;-423 }
  2242                                  
  2243                                  
  2244                                  ;-424 
  2245                                  
  2246                                  
  2247                                  ;-425 int storeJmpCall() {
  2248                                  
  2249 00000B52 C9                       .retngetTokeType: LEAVE
  2250 00000B53 C3                       ret
  2251                                  ENDP
  2252                                  
  2253                                  storeJmpCall: PROC
  2254                                  
  2255                                  ;-426     unsigned int i;
  2256                                  
  2257                                  
  2258                                  ;-427     JmpMaxIx++;
  2259                                  
  2260                                  ;Function : storeJmpCall, Number of local variables: 1
  2261                                  ;   # type sign width addr used name   list of local variables
  2262                                  ;  200 var unsg word   426 NULL i = bp-2;
  2263 00000B54 C8020000                 ENTER  2,0
  2264 00000B58 FF06[5400]               inc  word[JmpMaxIx]
  2265                                  
  2266                                  ;-428     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp Calls");
  2267                                  
  2268 00000B5C A1[5400]                 mov ax, [JmpMaxIx]
  2269 00000B5F 3DC800                   cmp ax, 200 ;unsigned : 1
  2270 00000B62 0F8C0900                 jl  .storeJmpCall86
  2271 00000B66 68[B00B]                 push storeJmpCall_0
  2272 00000B69 E87B0F                   call errorexit
  2273 00000B6C 83C402                   add  sp, 2
  2274                                  
  2275                                  ;-429     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  2276                                  
  2277                                  .storeJmpCall86:
  2278 00000B6F 8D063075                 lea  ax, [Symbol]
  2279 00000B73 50                       push ax
  2280 00000B74 FF36[5000]               push word [JmpNamePtr]
  2281 00000B78 E81307                   call strcpy
  2282 00000B7B 83C404                   add  sp, 4
  2283 00000B7E A3[5000]                 mov word [JmpNamePtr], ax
  2284                                  
  2285                                  ;-430     JmpNamePtr++;
  2286                                  
  2287 00000B81 FF06[5000]               inc  word[JmpNamePtr]
  2288                                  
  2289                                  ;-431     i = JmpNamePtr - &JmpNames;
  2290                                  
  2291 00000B85 A1[5000]                 mov ax, [JmpNamePtr]
  2292 00000B88 2D7A93                   sub ax, JmpNames
  2293 00000B8B 8946FE                   mov [bp-2], ax
  2294                                  
  2295                                  ;-432     if ( i >= JMPNAMESMAX) errorexit("too many Jmp Call names");
  2296                                  
  2297 00000B8E 8B46FE                   mov ax, [bp-2]
  2298 00000B91 3D810F                   cmp ax, 3969 ;unsigned : 0
  2299 00000B94 0F820900                 jb  .storeJmpCall87
  2300 00000B98 68[C30B]                 push storeJmpCall_1
  2301 00000B9B E8490F                   call errorexit
  2302 00000B9E 83C402                   add  sp, 2
  2303                                  
  2304                                  ;-433     JmpAddr[JmpMaxIx] = PC;
  2305                                  
  2306                                  .storeJmpCall87:
  2307 00000BA1 A1[2300]                 mov ax, [PC]
  2308 00000BA4 8B1E[5400]               mov bx, [JmpMaxIx]
  2309 00000BA8 D1E3                     shl bx, 1
  2310 00000BAA 89871AA3                 mov [JmpAddr+bx], ax
  2311                                  
  2312                                  ;-434 }
  2313                                  
  2314                                  
  2315                                  ;-435 
  2316                                  
  2317                                  
  2318                                  ;-436 int storeLabel() {
  2319 00000BAE C9                       LEAVE
  2320 00000BAF C3                       ret
  2321 00000BB0 746F6F206D616E7920-     storeJmpCall_0 db "too many Jmp Calls",0
  2322 00000BB9 4A6D702043616C6C73-
  2323 00000BC2 00                 
  2324 00000BC3 746F6F206D616E7920-     storeJmpCall_1 db "too many Jmp Call names",0
  2325 00000BCC 4A6D702043616C6C20-
  2326 00000BD5 6E616D657300       
  2327                                  ENDP
  2328                                  
  2329                                  storeLabel: PROC
  2330                                  
  2331                                  ;-437     unsigned int i;
  2332                                  
  2333                                  
  2334                                  ;-438     if(searchLabel()) error1("duplicate label");
  2335                                  
  2336                                  ;Function : storeLabel, Number of local variables: 1
  2337                                  ;   # type sign width addr used name   list of local variables
  2338                                  ;  200 var unsg word   437 NULL i = bp-2;
  2339 00000BDB C8020000                 ENTER  2,0
  2340 00000BDF E8A000                   call searchLabel
  2341 00000BE2 08C0                     or  al, al
  2342 00000BE4 0F840900                 je .storeLabel88
  2343 00000BE8 68[4D0C]                 push storeLabel_0
  2344 00000BEB E8A30E                   call error1
  2345 00000BEE 83C402                   add  sp, 2
  2346                                  
  2347                                  ;-439     LabelMaxIx++;
  2348                                  
  2349                                  .storeLabel88:
  2350 00000BF1 FF06[4A00]               inc  word[LabelMaxIx]
  2351                                  
  2352                                  ;-440     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2353                                  
  2354 00000BF5 A1[4A00]                 mov ax, [LabelMaxIx]
  2355 00000BF8 3D5802                   cmp ax, 600 ;unsigned : 1
  2356 00000BFB 0F8C0900                 jl  .storeLabel89
  2357 00000BFF 68[5D0C]                 push storeLabel_1
  2358 00000C02 E8E20E                   call errorexit
  2359 00000C05 83C402                   add  sp, 2
  2360                                  
  2361                                  ;-441     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2362                                  
  2363                                  .storeLabel89:
  2364 00000C08 8D063075                 lea  ax, [Symbol]
  2365 00000C0C 50                       push ax
  2366 00000C0D FF36[4600]               push word [LabelNamePtr]
  2367 00000C11 E87A06                   call strcpy
  2368 00000C14 83C404                   add  sp, 4
  2369 00000C17 A3[4600]                 mov word [LabelNamePtr], ax
  2370                                  
  2371                                  ;-442     LabelNamePtr++;
  2372                                  
  2373 00000C1A FF06[4600]               inc  word[LabelNamePtr]
  2374                                  
  2375                                  ;-443     i = LabelNamePtr - &LabelNames;
  2376                                  
  2377 00000C1E A1[4600]                 mov ax, [LabelNamePtr]
  2378 00000C21 2D5A77                   sub ax, LabelNames
  2379 00000C24 8946FE                   mov [bp-2], ax
  2380                                  
  2381                                  ;-444     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2382                                  
  2383 00000C27 8B46FE                   mov ax, [bp-2]
  2384 00000C2A 3D5117                   cmp ax, 5969 ;unsigned : 0
  2385 00000C2D 0F820900                 jb  .storeLabel90
  2386 00000C31 68[6D0C]                 push storeLabel_2
  2387 00000C34 E8B00E                   call errorexit
  2388 00000C37 83C402                   add  sp, 2
  2389                                  
  2390                                  ;-445     LabelAddr[LabelMaxIx] = PC + Origin;
  2391                                  
  2392                                  .storeLabel90:
  2393 00000C3A A1[2300]                 mov ax, [PC]
  2394 00000C3D 0306[2500]               add ax, [Origin]
  2395 00000C41 8B1E[4A00]               mov bx, [LabelMaxIx]
  2396 00000C45 D1E3                     shl bx, 1
  2397 00000C47 8987CA8E                 mov [LabelAddr+bx], ax
  2398                                  
  2399                                  ;-446 }
  2400                                  
  2401                                  
  2402                                  ;-447 
  2403                                  
  2404                                  
  2405                                  ;-448 int searchLabel() {
  2406 00000C4B C9                       LEAVE
  2407 00000C4C C3                       ret
  2408 00000C4D 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2409 00000C56 206C6162656C00     
  2410 00000C5D 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  2411 00000C66 6C6162656C7300     
  2412 00000C6D 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2413 00000C76 6C6162656C206E616D-
  2414 00000C7F 657300             
  2415                                  ENDP
  2416                                  
  2417                                  searchLabel: PROC
  2418                                  
  2419                                  ;-449     int LIx; char *p;
  2420                                  
  2421                                  
  2422                                  ;-450     p = &LabelNames;
  2423                                  
  2424                                  ;Function : searchLabel, Number of local variables: 2
  2425                                  ;   # type sign width addr used name   list of local variables
  2426                                  ;  200 var sign word   449 NULL LIx = bp-2
  2427                                  ;  201 ptr sign byte   449 NULL p = bp-4;
  2428 00000C82 C8040000                 ENTER  4,0
  2429 00000C86 B85A77                   mov ax, LabelNames
  2430 00000C89 8946FC                   mov [bp-4], ax
  2431                                  
  2432                                  ;-451     LIx = 1;
  2433                                  
  2434 00000C8C B80100                   mov ax, 1
  2435 00000C8F 8946FE                   mov [bp-2], ax
  2436                                  
  2437                                  ;-452     while (LIx <= LabelMaxIx) {
  2438                                  
  2439                                  .searchLabel91:
  2440 00000C92 8B46FE                   mov ax, [bp-2]
  2441 00000C95 3B06[4A00]               cmp ax, [LabelMaxIx]
  2442 00000C99 0F8F3100                 jg  .searchLabel92
  2443                                  
  2444                                  ;-453         if (eqstr(p, Symbol)) return LIx;//pos of label
  2445                                  
  2446 00000C9D 8D063075                 lea  ax, [Symbol]
  2447 00000CA1 50                       push ax
  2448 00000CA2 FF76FC                   push word [bp-4]
  2449 00000CA5 E81C06                   call eqstr
  2450 00000CA8 83C404                   add  sp, 4
  2451 00000CAB 08C0                     or  al, al
  2452 00000CAD 0F840600                 je .searchLabel93
  2453 00000CB1 8B46FE                   mov ax, [bp-2]
  2454 00000CB4 E91D00                   jmp .retnsearchLabel
  2455                                  
  2456                                  ;-454         p=strlen(p) + p;
  2457                                  
  2458                                  .searchLabel93:
  2459 00000CB7 FF76FC                   push word [bp-4]
  2460 00000CBA E8A905                   call strlen
  2461 00000CBD 83C402                   add  sp, 2
  2462 00000CC0 0346FC                   add ax, [bp-4]
  2463 00000CC3 8946FC                   mov [bp-4], ax
  2464                                  
  2465                                  ;-455         p++;
  2466                                  
  2467 00000CC6 FF46FC                   inc  word[bp-4]
  2468                                  
  2469                                  ;-456         LIx++;
  2470                                  
  2471 00000CC9 FF46FE                   inc  word[bp-2]
  2472                                  
  2473                                  ;-457     }
  2474                                  
  2475                                  
  2476                                  ;-458     return 0;
  2477                                  
  2478 00000CCC EBC4                     jmp .searchLabel91
  2479                                  .searchLabel92:
  2480 00000CCE B80000                   mov ax, 0
  2481 00000CD1 E90000                   jmp .retnsearchLabel
  2482                                  
  2483                                  ;-459 }
  2484                                  
  2485                                  
  2486                                  ;-460 
  2487                                  
  2488                                  
  2489                                  ;-461 int getVariable() {
  2490                                  
  2491 00000CD4 C9                       .retnsearchLabel: LEAVE
  2492 00000CD5 C3                       ret
  2493                                  ENDP
  2494                                  
  2495                                  getVariable: PROC
  2496                                  
  2497                                  ;-462     char c;
  2498                                  
  2499                                  
  2500                                  ;-463     storeLabel();
  2501                                  
  2502                                  ;Function : getVariable, Number of local variables: 1
  2503                                  ;   # type sign width addr used name   list of local variables
  2504                                  ;  200 var sign byte   462 NULL c = bp-2;
  2505 00000CD6 C8020000                 ENTER  2,0
  2506 00000CDA E8FEFE                   call storeLabel
  2507                                  
  2508                                  ;-464     getTokeType();
  2509                                  
  2510 00000CDD E8E8FD                   call getTokeType
  2511                                  
  2512                                  ;-465     if(TokeType==ALNUME) {//getName
  2513                                  
  2514 00000CE0 A0[2C00]                 mov al, [TokeType]
  2515 00000CE3 3C03                     cmp al, 3
  2516 00000CE5 0F857001                 jne .getVariable94
  2517                                  
  2518                                  ;-466         lookCode();
  2519                                  
  2520 00000CE9 E884F7                   call lookCode
  2521                                  
  2522                                  ;-467         if (CodeType < 200) dataexit();
  2523                                  
  2524 00000CEC A0[2F00]                 mov al, [CodeType]
  2525 00000CEF 3CC8                     cmp al, 200
  2526 00000CF1 0F8D0300                 jge .getVariable95
  2527 00000CF5 E8970F                   call dataexit
  2528                                  
  2529                                  ;-468         if (CodeType > 205) dataexit();
  2530                                  
  2531                                  .getVariable95:
  2532 00000CF8 A0[2F00]                 mov al, [CodeType]
  2533 00000CFB 3CCD                     cmp al, 205
  2534 00000CFD 0F8E0300                 jle .getVariable96
  2535 00000D01 E88B0F                   call dataexit
  2536                                  
  2537                                  ;-469         if (CodeType== 200) {//DB
  2538                                  
  2539                                  .getVariable96:
  2540 00000D04 A0[2F00]                 mov al, [CodeType]
  2541 00000D07 3CC8                     cmp al, 200
  2542 00000D09 0F856A00                 jne .getVariable97
  2543                                  
  2544                                  ;-470             do {
  2545                                  
  2546                                  .getVariable98:
  2547                                  
  2548                                  ;-471                 getTokeType();
  2549                                  
  2550 00000D0D E8B8FD                   call getTokeType
  2551                                  
  2552                                  ;-472                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2553                                  
  2554 00000D10 A0[2C00]                 mov al, [TokeType]
  2555 00000D13 3C01                     cmp al, 1
  2556 00000D15 0F850D00                 jne .getVariable99
  2557 00000D19 FF36[0E00]               push word [SymbolInt]
  2558 00000D1D E88414                   call genCode8
  2559 00000D20 83C402                   add  sp, 2
  2560                                  
  2561                                  ;-473                 else {
  2562                                  
  2563 00000D23 E94100                   jmp .getVariable100
  2564                                  .getVariable99:
  2565                                  
  2566                                  ;-474                     skipBlank();
  2567                                  
  2568 00000D26 E82E04                   call skipBlank
  2569                                  
  2570                                  ;-475                     if (isToken('"')) {
  2571                                  
  2572 00000D29 6A22                     push 34
  2573 00000D2B E8B801                   call isToken
  2574 00000D2E 83C402                   add  sp, 2
  2575 00000D31 08C0                     or  al, al
  2576 00000D33 0F843000                 je .getVariable101
  2577                                  
  2578                                  ;-476                         do {
  2579                                  
  2580                                  .getVariable102:
  2581                                  
  2582                                  ;-477                             c= *InputPtr;
  2583                                  
  2584 00000D37 8B1E[1400]               mov bx, [InputPtr]
  2585 00000D3B 8A07                     mov al, [bx]
  2586 00000D3D B400                     mov ah, 0
  2587 00000D3F 8846FE                   mov [bp-2], al
  2588                                  
  2589                                  ;-478                             genCode8(c);
  2590                                  
  2591 00000D42 8A46FE                   mov al, byte [bp-2]
  2592 00000D45 B400                     mov ah, 0
  2593 00000D47 50                       push ax
  2594 00000D48 E85914                   call genCode8
  2595 00000D4B 83C402                   add  sp, 2
  2596                                  
  2597                                  ;-479                             InputPtr++;
  2598                                  
  2599 00000D4E FF06[1400]               inc  word[InputPtr]
  2600                                  
  2601                                  ;-480                         } while (*InputPtr != '"' );
  2602                                  
  2603 00000D52 8B1E[1400]               mov bx, [InputPtr]
  2604 00000D56 8A07                     mov al, [bx]
  2605 00000D58 B400                     mov ah, 0
  2606 00000D5A 83F822                   cmp ax, 34
  2607 00000D5D 0F840200                 je  .getVariable103
  2608 00000D61 EBD4                     jmp .getVariable102
  2609                                  .getVariable103:
  2610                                  
  2611                                  ;-481                         InputPtr++;
  2612                                  
  2613 00000D63 FF06[1400]               inc  word[InputPtr]
  2614                                  
  2615                                  ;-482                     }
  2616                                  
  2617                                  
  2618                                  ;-483                 }
  2619                                  
  2620                                  .getVariable101:
  2621                                  
  2622                                  ;-484             } while (isToken(','));
  2623                                  
  2624                                  .getVariable100:
  2625 00000D67 6A2C                     push 44
  2626 00000D69 E87A01                   call isToken
  2627 00000D6C 83C402                   add  sp, 2
  2628 00000D6F 08C0                     or  al, al
  2629 00000D71 0F840200                 je .getVariable104
  2630 00000D75 EB96                     jmp .getVariable98
  2631                                  .getVariable104:
  2632                                  
  2633                                  ;-485         }
  2634                                  
  2635                                  
  2636                                  ;-486         if (CodeType == 201) {//DW
  2637                                  
  2638                                  .getVariable97:
  2639 00000D77 A0[2F00]                 mov al, [CodeType]
  2640 00000D7A 3CC9                     cmp al, 201
  2641 00000D7C 0F852600                 jne .getVariable105
  2642                                  
  2643                                  ;-487             do {
  2644                                  
  2645                                  .getVariable106:
  2646                                  
  2647                                  ;-488                 getTokeType();
  2648                                  
  2649 00000D80 E845FD                   call getTokeType
  2650                                  
  2651                                  ;-489                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2652                                  
  2653 00000D83 A0[2C00]                 mov al, [TokeType]
  2654 00000D86 3C01                     cmp al, 1
  2655 00000D88 0F850A00                 jne .getVariable107
  2656 00000D8C FF36[0E00]               push word [SymbolInt]
  2657 00000D90 E86814                   call genCode16
  2658 00000D93 83C402                   add  sp, 2
  2659                                  
  2660                                  ;-490             } while (isToken(','));
  2661                                  
  2662                                  .getVariable107:
  2663 00000D96 6A2C                     push 44
  2664 00000D98 E84B01                   call isToken
  2665 00000D9B 83C402                   add  sp, 2
  2666 00000D9E 08C0                     or  al, al
  2667 00000DA0 0F840200                 je .getVariable108
  2668 00000DA4 EBDA                     jmp .getVariable106
  2669                                  .getVariable108:
  2670                                  
  2671                                  ;-491         }
  2672                                  
  2673                                  
  2674                                  ;-492         if (CodeType == 202) {//DD
  2675                                  
  2676                                  .getVariable105:
  2677 00000DA6 A0[2F00]                 mov al, [CodeType]
  2678 00000DA9 3CCA                     cmp al, 202
  2679 00000DAB 0F852E00                 jne .getVariable109
  2680                                  
  2681                                  ;-493             do {
  2682                                  
  2683                                  .getVariable110:
  2684                                  
  2685                                  ;-494                 getTokeType();
  2686                                  
  2687 00000DAF E816FD                   call getTokeType
  2688                                  
  2689                                  ;-495                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2690                                  
  2691 00000DB2 A0[2C00]                 mov al, [TokeType]
  2692 00000DB5 3C01                     cmp al, 1
  2693 00000DB7 0F851200                 jne .getVariable111
  2694 00000DBB FF36[0E00]               push word [SymbolInt]
  2695 00000DBF E83914                   call genCode16
  2696 00000DC2 83C402                   add  sp, 2
  2697                                  
  2698                                  ;-496                                     genCode16(0);}//todo genCode32(SymbolLong);
  2699                                  
  2700 00000DC5 6A00                     push 0
  2701 00000DC7 E83114                   call genCode16
  2702 00000DCA 83C402                   add  sp, 2
  2703                                  
  2704                                  ;-497             } while (isToken(','));
  2705                                  
  2706                                  .getVariable111:
  2707 00000DCD 6A2C                     push 44
  2708 00000DCF E81401                   call isToken
  2709 00000DD2 83C402                   add  sp, 2
  2710 00000DD5 08C0                     or  al, al
  2711 00000DD7 0F840200                 je .getVariable112
  2712 00000DDB EBD2                     jmp .getVariable110
  2713                                  .getVariable112:
  2714                                  
  2715                                  ;-498         }
  2716                                  
  2717                                  
  2718                                  ;-499         if (CodeType >= 203) {//resb, resw, resd
  2719                                  
  2720                                  .getVariable109:
  2721 00000DDD A0[2F00]                 mov al, [CodeType]
  2722 00000DE0 3CCB                     cmp al, 203 ;unsigned : 1
  2723 00000DE2 0F8C7000                 jl  .getVariable113
  2724                                  
  2725                                  ;-500             getTokeType();
  2726                                  
  2727 00000DE6 E8DFFC                   call getTokeType
  2728                                  
  2729                                  ;-501             if (TokeType == DIGIT) {
  2730                                  
  2731 00000DE9 A0[2C00]                 mov al, [TokeType]
  2732 00000DEC 3C01                     cmp al, 1
  2733 00000DEE 0F856100                 jne .getVariable114
  2734                                  
  2735                                  ;-502                 if (SymbolInt <= 0) syntaxerror();
  2736                                  
  2737 00000DF2 A1[0E00]                 mov ax, [SymbolInt]
  2738 00000DF5 83F800                   cmp ax, 0
  2739 00000DF8 0F870300                 ja  .getVariable115
  2740 00000DFC E8650E                   call syntaxerror
  2741                                  
  2742                                  ;-503                 if (AbsoluteLab == 0) error1("Absolute is null");
  2743                                  
  2744                                  .getVariable115:
  2745 00000DFF A1[2700]                 mov ax, [AbsoluteLab]
  2746 00000E02 83F800                   cmp ax, 0
  2747 00000E05 0F850900                 jne .getVariable116
  2748 00000E09 68[5E0E]                 push getVariable_0
  2749 00000E0C E8820C                   call error1
  2750 00000E0F 83C402                   add  sp, 2
  2751                                  
  2752                                  ;-504                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2753                                  
  2754                                  .getVariable116:
  2755 00000E12 A1[2700]                 mov ax, [AbsoluteLab]
  2756 00000E15 8B1E[4A00]               mov bx, [LabelMaxIx]
  2757 00000E19 D1E3                     shl bx, 1
  2758 00000E1B 8987CA8E                 mov [LabelAddr+bx], ax
  2759                                  
  2760                                  ;-505                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2761                                  
  2762 00000E1F A0[2F00]                 mov al, [CodeType]
  2763 00000E22 3CCC                     cmp al, 204
  2764 00000E24 0F850A00                 jne .getVariable117
  2765 00000E28 A1[0E00]                 mov ax, [SymbolInt]
  2766 00000E2B 0306[0E00]               add ax, [SymbolInt]
  2767 00000E2F A3[0E00]                 mov word [SymbolInt], ax
  2768                                  
  2769                                  ;-506                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2770                                  
  2771                                  .getVariable117:
  2772 00000E32 A0[2F00]                 mov al, [CodeType]
  2773 00000E35 3CCD                     cmp al, 205
  2774 00000E37 0F850B00                 jne .getVariable118
  2775 00000E3B A1[0E00]                 mov ax, [SymbolInt]
  2776 00000E3E BB0400                   mov bx, 4
  2777 00000E41 F7E3                     mul bx
  2778 00000E43 A3[0E00]                 mov word [SymbolInt], ax
  2779                                  
  2780                                  ;-507                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2781                                  
  2782                                  .getVariable118:
  2783 00000E46 A1[2700]                 mov ax, [AbsoluteLab]
  2784 00000E49 0306[0E00]               add ax, [SymbolInt]
  2785 00000E4D A3[2700]                 mov word [AbsoluteLab], ax
  2786                                  
  2787                                  ;-508             } else numbererror();
  2788                                  
  2789 00000E50 E90300                   jmp .getVariable119
  2790                                  .getVariable114:
  2791 00000E53 E87B0D                   call numbererror
  2792                                  
  2793                                  ;-509         }
  2794                                  
  2795                                  .getVariable119:
  2796                                  
  2797                                  ;-510     }
  2798                                  
  2799                                  .getVariable113:
  2800                                  
  2801                                  ;-511     else dataexit();
  2802                                  
  2803 00000E56 E90300                   jmp .getVariable120
  2804                                  .getVariable94:
  2805 00000E59 E8330E                   call dataexit
  2806                                  
  2807                                  ;-512 }
  2808                                  
  2809                                  .getVariable120:
  2810                                  
  2811                                  ;-513 
  2812                                  
  2813                                  
  2814                                  ;-514 int getCodeSize() {
  2815 00000E5C C9                       LEAVE
  2816 00000E5D C3                       ret
  2817 00000E5E 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2818 00000E67 6973206E756C6C00   
  2819                                  ENDP
  2820                                  
  2821                                  getCodeSize: PROC
  2822                                  
  2823                                  ;-515     if (TokeType ==ALNUME) {
  2824                                  
  2825 00000E6F A0[2C00]                 mov al, [TokeType]
  2826 00000E72 3C03                     cmp al, 3
  2827 00000E74 0F855700                 jne .getCodeSize121
  2828                                  
  2829                                  ;-516         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2830                                  
  2831 00000E78 68[D60E]                 push getCodeSize_0
  2832 00000E7B 8D064F75                 lea  ax, [SymbolUpper]
  2833 00000E7F 50                       push ax
  2834 00000E80 E84104                   call eqstr
  2835 00000E83 83C404                   add  sp, 4
  2836 00000E86 08C0                     or  al, al
  2837 00000E88 0F840900                 je .getCodeSize122
  2838 00000E8C E839FC                   call getTokeType
  2839 00000E8F B80100                   mov ax, 1
  2840 00000E92 E94000                   jmp .retngetCodeSize
  2841                                  
  2842                                  ;-517         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2843                                  
  2844                                  .getCodeSize122:
  2845 00000E95 68[DB0E]                 push getCodeSize_1
  2846 00000E98 8D064F75                 lea  ax, [SymbolUpper]
  2847 00000E9C 50                       push ax
  2848 00000E9D E82404                   call eqstr
  2849 00000EA0 83C404                   add  sp, 4
  2850 00000EA3 08C0                     or  al, al
  2851 00000EA5 0F840900                 je .getCodeSize123
  2852 00000EA9 E81CFC                   call getTokeType
  2853 00000EAC B80200                   mov ax, 2
  2854 00000EAF E92300                   jmp .retngetCodeSize
  2855                                  
  2856                                  ;-518         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2857                                  
  2858                                  .getCodeSize123:
  2859 00000EB2 68[E00E]                 push getCodeSize_2
  2860 00000EB5 8D064F75                 lea  ax, [SymbolUpper]
  2861 00000EB9 50                       push ax
  2862 00000EBA E80704                   call eqstr
  2863 00000EBD 83C404                   add  sp, 4
  2864 00000EC0 08C0                     or  al, al
  2865 00000EC2 0F840900                 je .getCodeSize124
  2866 00000EC6 E8FFFB                   call getTokeType
  2867 00000EC9 B80300                   mov ax, 3
  2868 00000ECC E90600                   jmp .retngetCodeSize
  2869                                  
  2870                                  ;-519     }
  2871                                  
  2872                                  .getCodeSize124:
  2873                                  
  2874                                  ;-520     return 0;
  2875                                  
  2876                                  .getCodeSize121:
  2877 00000ECF B80000                   mov ax, 0
  2878 00000ED2 E90000                   jmp .retngetCodeSize
  2879                                  
  2880                                  ;-521 }
  2881                                  
  2882                                  
  2883                                  ;-522 int isToken(char c) {
  2884                                  
  2885                                   .retngetCodeSize:
  2886 00000ED5 C3                       ret
  2887 00000ED6 4259544500              getCodeSize_0 db "BYTE",0
  2888 00000EDB 574F524400              getCodeSize_1 db "WORD",0
  2889 00000EE0 44574F524400            getCodeSize_2 db "DWORD",0
  2890                                  ENDP
  2891                                  
  2892                                  isToken: PROC
  2893                                  
  2894                                  ;-523     skipBlank();
  2895                                  
  2896                                  ;Function : isToken, Number of local variables: 1
  2897                                  ;   # type sign width addr used name   list of local variables
  2898                                  ;  200 var sign byte   522 NULL c = bp+4;
  2899 00000EE6 C8000000                 ENTER  0,0
  2900 00000EEA E86A02                   call skipBlank
  2901                                  
  2902                                  ;-524     if (*InputPtr == c) {
  2903                                  
  2904 00000EED 8B1E[1400]               mov bx, [InputPtr]
  2905 00000EF1 8A07                     mov al, [bx]
  2906 00000EF3 B400                     mov ah, 0
  2907 00000EF5 3A4604                   cmp al, [bp+4]
  2908 00000EF8 0F850A00                 jne .isToken125
  2909                                  
  2910                                  ;-525         InputPtr++;
  2911                                  
  2912 00000EFC FF06[1400]               inc  word[InputPtr]
  2913                                  
  2914                                  ;-526         return 1;
  2915                                  
  2916 00000F00 B80100                   mov ax, 1
  2917 00000F03 E90600                   jmp .retnisToken
  2918                                  
  2919                                  ;-527         }
  2920                                  
  2921                                  
  2922                                  ;-528     return 0;
  2923                                  
  2924                                  .isToken125:
  2925 00000F06 B80000                   mov ax, 0
  2926 00000F09 E90000                   jmp .retnisToken
  2927                                  
  2928                                  ;-529 }
  2929                                  
  2930                                  
  2931                                  ;-530 int need(char c) {
  2932                                  
  2933 00000F0C C9                       .retnisToken: LEAVE
  2934 00000F0D C3                       ret
  2935                                  ENDP
  2936                                  
  2937                                  need: PROC
  2938                                  
  2939                                  ;-531     if (isToken(c)) {
  2940                                  
  2941                                  ;Function : need, Number of local variables: 1
  2942                                  ;   # type sign width addr used name   list of local variables
  2943                                  ;  200 var sign byte   530 NULL c = bp+4;
  2944 00000F0E C8000000                 ENTER  0,0
  2945 00000F12 8A4604                   mov al, byte [bp+4]
  2946 00000F15 B400                     mov ah, 0
  2947 00000F17 50                       push ax
  2948 00000F18 E8CBFF                   call isToken
  2949 00000F1B 83C402                   add  sp, 2
  2950 00000F1E 08C0                     or  al, al
  2951 00000F20 0F840600                 je .need126
  2952                                  
  2953                                  ;-532         getTokeType();
  2954                                  
  2955 00000F24 E8A1FB                   call getTokeType
  2956                                  
  2957                                  ;-533         return;
  2958                                  
  2959 00000F27 E91800                   jmp .retnneed
  2960                                  
  2961                                  ;-534         }
  2962                                  
  2963                                  
  2964                                  ;-535     error1();
  2965                                  
  2966                                  .need126:
  2967 00000F2A E8640B                   call error1
  2968                                  
  2969                                  ;-536     prs(". need: ");
  2970                                  
  2971 00000F2D 68[440F]                 push need_0
  2972 00000F30 E80C0A                   call prs
  2973 00000F33 83C402                   add  sp, 2
  2974                                  
  2975                                  ;-537     prc(c);
  2976                                  
  2977 00000F36 8A4604                   mov al, byte [bp+4]
  2978 00000F39 B400                     mov ah, 0
  2979 00000F3B 50                       push ax
  2980 00000F3C E8A809                   call prc
  2981 00000F3F 83C402                   add  sp, 2
  2982                                  
  2983                                  ;-538 }
  2984                                  
  2985                                  
  2986                                  ;-539 int skipRest() {
  2987                                  
  2988 00000F42 C9                       .retnneed: LEAVE
  2989 00000F43 C3                       ret
  2990 00000F44 2E206E6565643A2000      need_0 db ". need: ",0
  2991                                  ENDP
  2992                                  
  2993                                  skipRest: PROC
  2994                                  
  2995                                  ;-540     getTokeType();
  2996                                  
  2997 00000F4D E878FB                   call getTokeType
  2998                                  
  2999                                  ;-541     if(TokeType)error1("extra char ignored");
  3000                                  
  3001 00000F50 A0[2C00]                 mov al, [TokeType]
  3002 00000F53 08C0                     or  al, al
  3003 00000F55 0F840900                 je .skipRest127
  3004 00000F59 68[630F]                 push skipRest_0
  3005 00000F5C E8320B                   call error1
  3006 00000F5F 83C402                   add  sp, 2
  3007                                  
  3008                                  ;-542 }
  3009                                  
  3010                                  .skipRest127:
  3011                                  
  3012                                  ;-543 
  3013                                  
  3014                                  
  3015                                  ;-544 
  3016                                  
  3017                                  
  3018                                  ;-545 //#include "HELPER.C"
  3019                                  
  3020                                  
  3021                                  ;-546 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3022                                  
  3023 00000F62 C3                       ret
  3024 00000F63 657874726120636861-     skipRest_0 db "extra char ignored",0
  3025 00000F6C 722069676E6F726564-
  3026 00000F75 00                 
  3027                                  ENDP
  3028                                  
  3029                                  writetty: PROC
  3030 00000F76 B40E                     mov  ah, 14
  3031 00000F78 BB0000                   mov  bx, 0
  3032 00000F7B CD10                     db 205,16
  3033                                  
  3034                                  ;-547 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3035                                  
  3036 00000F7D C3                       ret
  3037                                  ENDP
  3038                                  
  3039                                  putch: PROC
  3040                                  ;Function : putch, Number of local variables: 1
  3041                                  ;   # type sign width addr used name   list of local variables
  3042                                  ;  200 var sign byte   547 NULL c = bp+4;
  3043 00000F7E C8000000                 ENTER  0,0 ; constant expression
  3044 00000F82 807E040A                cmp byte[bp+4], 10
  3045 00000F86 0F850500                 jne .putch128
  3046 00000F8A B00D                     mov  al, 13
  3047 00000F8C E8E7FF                   call writetty
  3048                                  .putch128:
  3049 00000F8F 8A4604                   mov  al, [bp+4]
  3050 00000F92 E8E1FF                   call writetty
  3051                                  
  3052                                  ;-548 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3053 00000F95 C9                       LEAVE
  3054 00000F96 C3                       ret
  3055                                  ENDP
  3056                                  
  3057                                  cputs: PROC
  3058                                  ;Function : cputs, Number of local variables: 2
  3059                                  ;   # type sign width addr used name   list of local variables
  3060                                  ;  200 ptr sign byte   548 NULL s = bp+4
  3061                                  ;  201 var sign byte   548 NULL c = bp-2;
  3062 00000F97 C8020000                 ENTER  2,0
  3063                                  .cputs129:
  3064 00000F9B 8B5E04                   mov bx, [bp+4]
  3065 00000F9E 8A07                     mov al, [bx]
  3066 00000FA0 B400                     mov ah, 0
  3067 00000FA2 08C0                     or  al, al
  3068 00000FA4 0F841B00                 je .cputs130
  3069 00000FA8 8B5E04                   mov bx, [bp+4]
  3070 00000FAB 8A07                     mov al, [bx]
  3071 00000FAD B400                     mov ah, 0
  3072 00000FAF 8846FE                   mov [bp-2], al
  3073 00000FB2 8A46FE                   mov al, byte [bp-2]
  3074 00000FB5 B400                     mov ah, 0
  3075 00000FB7 50                       push ax
  3076 00000FB8 E8C3FF                   call putch
  3077 00000FBB 83C402                   add  sp, 2
  3078 00000FBE FF4604                   inc  word[bp+4]
  3079 00000FC1 EBD8                     jmp .cputs129
  3080                                  .cputs130:
  3081                                  
  3082                                  ;-549 
  3083                                  
  3084                                  
  3085                                  ;-550 int DosInt() {
  3086 00000FC3 C9                       LEAVE
  3087 00000FC4 C3                       ret
  3088                                  ENDP
  3089                                  
  3090                                  DosInt: PROC
  3091                                  
  3092                                  ;-551     __emit__(0xCD,0x21);//inth 0x21;
  3093                                  
  3094 00000FC5 CD21                     db 205,33
  3095                                  
  3096                                  ;-552     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3097                                  
  3098 00000FC7 7304                     db 115,4
  3099                                  
  3100                                  ;-553     DOS_ERR++;
  3101                                  
  3102 00000FC9 FF06[1C00]               inc  word[DOS_ERR]
  3103                                  
  3104                                  ;-554 }
  3105                                  
  3106                                  
  3107                                  ;-555 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3108                                  
  3109 00000FCD C3                       ret
  3110                                  ENDP
  3111                                  
  3112                                  openR: PROC
  3113                                  ;Function : openR, Number of local variables: 1
  3114                                  ;   # type sign width addr used name   list of local variables
  3115                                  ;  200 ptr sign byte   555 NULL s = bp+4;
  3116 00000FCE C8000000                 ENTER  0,0
  3117 00000FD2 8B5604                   mov  dx, [bp+4]
  3118 00000FD5 B8023D                   mov  ax, 15618
  3119 00000FD8 E8EAFF                   call DosInt
  3120                                  
  3121                                  ;-556 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3122 00000FDB C9                       LEAVE
  3123 00000FDC C3                       ret
  3124                                  ENDP
  3125                                  
  3126                                  creatR: PROC
  3127                                  ;Function : creatR, Number of local variables: 1
  3128                                  ;   # type sign width addr used name   list of local variables
  3129                                  ;  200 ptr sign byte   556 NULL s = bp+4;
  3130 00000FDD C8000000                 ENTER  0,0
  3131 00000FE1 8B5604                   mov  dx, [bp+4]
  3132 00000FE4 B90000                   mov  cx, 0
  3133 00000FE7 B8003C                   mov  ax, 15360
  3134 00000FEA E8D8FF                   call DosInt
  3135                                  
  3136                                  ;-557 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3137 00000FED C9                       LEAVE
  3138 00000FEE C3                       ret
  3139                                  ENDP
  3140                                  
  3141                                  fcloseR: PROC
  3142                                  ;Function : fcloseR, Number of local variables: 1
  3143                                  ;   # type sign width addr used name   list of local variables
  3144                                  ;  200 var sign word   557 NULL fd = bp+4;
  3145 00000FEF C8000000                 ENTER  0,0
  3146 00000FF3 8B5E04                   mov  bx, [bp+4]
  3147 00000FF6 B8003E                   mov  ax, 15872
  3148 00000FF9 E8C9FF                   call DosInt
  3149                                  
  3150                                  ;-558 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3151 00000FFC C9                       LEAVE
  3152 00000FFD C3                       ret
  3153                                  ENDP
  3154                                  
  3155                                  exitR: PROC
  3156                                  ;Function : exitR, Number of local variables: 1
  3157                                  ;   # type sign width addr used name   list of local variables
  3158                                  ;  200 var sign byte   558 NULL c = bp+4;
  3159 00000FFE C8000000                 ENTER  0,0
  3160 00001002 B44C                     mov  ah, 76
  3161 00001004 8A4604                   mov  al, [bp+4]
  3162 00001007 E8BBFF                   call DosInt
  3163                                  
  3164                                  ;-559 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3165 0000100A C9                       LEAVE
  3166 0000100B C3                       ret
  3167                                  ENDP
  3168                                  
  3169                                  readRL: PROC
  3170                                  ;Function : readRL, Number of local variables: 3
  3171                                  ;   # type sign width addr used name   list of local variables
  3172                                  ;  200 ptr sign byte   559 NULL s = bp+4
  3173                                  ;  201 var sign word   559 NULL fd = bp+6
  3174                                  ;  202 var sign word   559 NULL len = bp+8;
  3175 0000100C C8000000                 ENTER  0,0
  3176 00001010 8B5604                   mov  dx, [bp+4]
  3177 00001013 8B4E08                   mov  cx, [bp+8]
  3178 00001016 8B5E06                   mov  bx, [bp+6]
  3179 00001019 B8003F                   mov  ax, 16128
  3180 0000101C E8A6FF                   call DosInt
  3181                                  
  3182                                  ;-560 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3183 0000101F C9                       LEAVE
  3184 00001020 C3                       ret
  3185                                  ENDP
  3186                                  
  3187                                  fputcR: PROC
  3188                                  ;Function : fputcR, Number of local variables: 2
  3189                                  ;   # type sign width addr used name   list of local variables
  3190                                  ;  200 ptr sign byte   560 NULL n = bp+4
  3191                                  ;  201 var sign word   560 NULL fd = bp+6;
  3192 00001021 C8000000                 ENTER  0,0
  3193 00001025 8D5604                  lea dx, [bp+4]
  3194                                  
  3195                                  ;-561   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3196                                  
  3197 00001028 B90100                   mov  cx, 1
  3198 0000102B 8B5E06                   mov  bx, [bp+6]
  3199 0000102E B80040                   mov  ax, 16384
  3200 00001031 E891FF                   call DosInt
  3201                                  
  3202                                  ;-562 
  3203                                  
  3204                                  
  3205                                  ;-563 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3206 00001034 C9                       LEAVE
  3207 00001035 C3                       ret
  3208                                  ENDP
  3209                                  
  3210                                  getLine: PROC
  3211                                  
  3212                                  ;-564   unsigned int i;
  3213                                  
  3214                                  
  3215                                  ;-565   InputPtr= &InputBuf;
  3216                                  
  3217                                  ;Function : getLine, Number of local variables: 1
  3218                                  ;   # type sign width addr used name   list of local variables
  3219                                  ;  200 var unsg word   564 NULL i = bp-2;
  3220 00001036 C8020000                 ENTER  2,0
  3221 0000103A B88D75                   mov ax, InputBuf
  3222 0000103D A3[1400]                 mov word [InputPtr], ax
  3223                                  
  3224                                  ;-566   *InputPtr=0;//if last line is empty
  3225                                  
  3226 00001040 B80000                   mov ax, 0
  3227 00001043 8B1E[1400]               mov  bx, [InputPtr]
  3228 00001047 8807                     mov  [bx], al
  3229                                  
  3230                                  ;-567   do {
  3231                                  
  3232                                  .getLine131:
  3233                                  
  3234                                  ;-568     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3235                                  
  3236 00001049 6A01                     push 1
  3237 0000104B FF36[1600]               push word [asm_fd]
  3238 0000104F 8D06[2200]               lea  ax, [DOS_ByteRead]
  3239 00001053 50                       push ax
  3240 00001054 E8B5FF                   call readRL
  3241 00001057 83C406                   add  sp, 6
  3242 0000105A A3[2000]                 mov word [DOS_NoBytes], ax
  3243                                  
  3244                                  ;-569     if (DOS_ERR) errorexit("Reading Source");
  3245                                  
  3246 0000105D A1[1C00]                 mov ax, [DOS_ERR]
  3247 00001060 08C0                     or  al, al
  3248 00001062 0F840900                 je .getLine132
  3249 00001066 68[C810]                 push getLine_0
  3250 00001069 E87B0A                   call errorexit
  3251 0000106C 83C402                   add  sp, 2
  3252                                  
  3253                                  ;-570     if (DOS_NoBytes == 0) return;
  3254                                  
  3255                                  .getLine132:
  3256 0000106F A1[2000]                 mov ax, [DOS_NoBytes]
  3257 00001072 83F800                   cmp ax, 0
  3258 00001075 0F850300                 jne .getLine133
  3259 00001079 E94A00                   jmp .retngetLine
  3260                                  
  3261                                  ;-571     *InputPtr = DOS_ByteRead;
  3262                                  
  3263                                  .getLine133:
  3264 0000107C A0[2200]                 mov al, [DOS_ByteRead]
  3265 0000107F 8B1E[1400]               mov  bx, [InputPtr]
  3266 00001083 8807                     mov  [bx], al
  3267                                  
  3268                                  ;-572     InputPtr++;
  3269                                  
  3270 00001085 FF06[1400]               inc  word[InputPtr]
  3271                                  
  3272                                  ;-573     i = InputPtr - &InputBuf;
  3273                                  
  3274 00001089 A1[1400]                 mov ax, [InputPtr]
  3275 0000108C 2D8D75                   sub ax, InputBuf
  3276 0000108F 8946FE                   mov [bp-2], ax
  3277                                  
  3278                                  ;-574     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3279                                  
  3280 00001092 8B46FE                   mov ax, [bp-2]
  3281 00001095 3DFF00                   cmp ax, 255 ;unsigned : 0
  3282 00001098 0F820900                 jb  .getLine134
  3283 0000109C 68[D710]                 push getLine_1
  3284 0000109F E8450A                   call errorexit
  3285 000010A2 83C402                   add  sp, 2
  3286                                  
  3287                                  ;-575   } while (ifEOL(DOS_ByteRead) == 0);
  3288                                  
  3289                                  .getLine134:
  3290 000010A5 A0[2200]                 mov al, byte [DOS_ByteRead]
  3291 000010A8 B400                     mov ah, 0
  3292 000010AA 50                       push ax
  3293 000010AB E83D00                   call ifEOL
  3294 000010AE 83C402                   add  sp, 2
  3295 000010B1 3C00                     cmp al, 0
  3296 000010B3 0F850200                 jne .getLine135
  3297 000010B7 EB90                     jmp .getLine131
  3298                                  .getLine135:
  3299                                  
  3300                                  ;-576   InputPtr--;
  3301                                  
  3302 000010B9 FF0E[1400]               dec  word[InputPtr]
  3303                                  
  3304                                  ;-577   *InputPtr=0;
  3305                                  
  3306 000010BD B80000                   mov ax, 0
  3307 000010C0 8B1E[1400]               mov  bx, [InputPtr]
  3308 000010C4 8807                     mov  [bx], al
  3309                                  
  3310                                  ;-578 }
  3311                                  
  3312                                  
  3313                                  ;-579 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3314                                  
  3315 000010C6 C9                       .retngetLine: LEAVE
  3316 000010C7 C3                       ret
  3317 000010C8 52656164696E672053-     getLine_0 db "Reading Source",0
  3318 000010D1 6F7572636500       
  3319 000010D7 696E707574206C696E-     getLine_1 db "input line too long",0
  3320 000010E0 6520746F6F206C6F6E-
  3321 000010E9 6700               
  3322                                  ENDP
  3323                                  
  3324                                  ifEOL: PROC
  3325                                  
  3326                                  ;-580   if (c == 10) return 1;//LF
  3327                                  
  3328                                  ;Function : ifEOL, Number of local variables: 1
  3329                                  ;   # type sign width addr used name   list of local variables
  3330                                  ;  200 var sign byte   579 NULL c = bp+4;
  3331 000010EB C8000000                 ENTER  0,0
  3332 000010EF 8A4604                   mov al, [bp+4]
  3333 000010F2 3C0A                     cmp al, 10
  3334 000010F4 0F850600                 jne .ifEOL136
  3335 000010F8 B80100                   mov ax, 1
  3336 000010FB E93B00                   jmp .retnifEOL
  3337                                  
  3338                                  ;-581   if (c == 13) {//CR
  3339                                  
  3340                                  .ifEOL136:
  3341 000010FE 8A4604                   mov al, [bp+4]
  3342 00001101 3C0D                     cmp al, 13
  3343 00001103 0F852C00                 jne .ifEOL137
  3344                                  
  3345                                  ;-582     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3346                                  
  3347 00001107 6A01                     push 1
  3348 00001109 FF36[1600]               push word [asm_fd]
  3349 0000110D 8D06[2200]               lea  ax, [DOS_ByteRead]
  3350 00001111 50                       push ax
  3351 00001112 E8F7FE                   call readRL
  3352 00001115 83C406                   add  sp, 6
  3353 00001118 A3[2000]                 mov word [DOS_NoBytes], ax
  3354                                  
  3355                                  ;-583     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3356                                  
  3357 0000111B A0[2200]                 mov al, [DOS_ByteRead]
  3358 0000111E 3C0A                     cmp al, 10
  3359 00001120 0F840900                 je  .ifEOL138
  3360 00001124 68[3B11]                 push ifEOL_0
  3361 00001127 E8BD09                   call errorexit
  3362 0000112A 83C402                   add  sp, 2
  3363                                  
  3364                                  ;-584     return 1;
  3365                                  
  3366                                  .ifEOL138:
  3367 0000112D B80100                   mov ax, 1
  3368 00001130 E90600                   jmp .retnifEOL
  3369                                  
  3370                                  ;-585   }
  3371                                  
  3372                                  
  3373                                  ;-586   return 0;
  3374                                  
  3375                                  .ifEOL137:
  3376 00001133 B80000                   mov ax, 0
  3377 00001136 E90000                   jmp .retnifEOL
  3378                                  
  3379                                  ;-587 }
  3380                                  
  3381                                  
  3382                                  ;-588 int skipBlank() {
  3383                                  
  3384 00001139 C9                       .retnifEOL: LEAVE
  3385 0000113A C3                       ret
  3386 0000113B 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3387 00001144 462831302920616674-
  3388 0000114D 657220435228313329-
  3389 00001156 00                 
  3390                                  ENDP
  3391                                  
  3392                                  skipBlank: PROC
  3393                                  
  3394                                  ;-589   skipblank1:
  3395                                  
  3396                                  .skipblank1:
  3397                                  
  3398                                  ;-590     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3399                                  
  3400 00001157 8B1E[1400]               mov bx, [InputPtr]
  3401 0000115B 8A07                     mov al, [bx]
  3402 0000115D B400                     mov ah, 0
  3403 0000115F 83F820                   cmp ax, 32
  3404 00001162 0F850600                 jne .skipBlank139
  3405 00001166 FF06[1400]               inc  word[InputPtr]
  3406 0000116A EBEB                     jmp .skipblank1
  3407                                  
  3408                                  ;-591     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3409                                  
  3410                                  .skipBlank139:
  3411 0000116C 8B1E[1400]               mov bx, [InputPtr]
  3412 00001170 8A07                     mov al, [bx]
  3413 00001172 B400                     mov ah, 0
  3414 00001174 83F809                   cmp ax, 9
  3415 00001177 0F850600                 jne .skipBlank140
  3416 0000117B FF06[1400]               inc  word[InputPtr]
  3417 0000117F EBD6                     jmp .skipblank1
  3418                                  
  3419                                  ;-592 }
  3420                                  
  3421                                  .skipBlank140:
  3422                                  
  3423                                  ;-593 int letterE(char c) {
  3424                                  
  3425 00001181 C3                       ret
  3426                                  ENDP
  3427                                  
  3428                                  letterE: PROC
  3429                                  
  3430                                  ;-594   if (c=='_') return 1;
  3431                                  
  3432                                  ;Function : letterE, Number of local variables: 1
  3433                                  ;   # type sign width addr used name   list of local variables
  3434                                  ;  200 var sign byte   593 NULL c = bp+4;
  3435 00001182 C8000000                 ENTER  0,0
  3436 00001186 8A4604                   mov al, [bp+4]
  3437 00001189 3C5F                     cmp al, 95
  3438 0000118B 0F850600                 jne .letterE141
  3439 0000118F B80100                   mov ax, 1
  3440 00001192 E96900                   jmp .retnletterE
  3441                                  
  3442                                  ;-595   if (c=='.') return 1;
  3443                                  
  3444                                  .letterE141:
  3445 00001195 8A4604                   mov al, [bp+4]
  3446 00001198 3C2E                     cmp al, 46
  3447 0000119A 0F850600                 jne .letterE142
  3448 0000119E B80100                   mov ax, 1
  3449 000011A1 E95A00                   jmp .retnletterE
  3450                                  
  3451                                  ;-596   if (c=='?') return 1;
  3452                                  
  3453                                  .letterE142:
  3454 000011A4 8A4604                   mov al, [bp+4]
  3455 000011A7 3C3F                     cmp al, 63
  3456 000011A9 0F850600                 jne .letterE143
  3457 000011AD B80100                   mov ax, 1
  3458 000011B0 E94B00                   jmp .retnletterE
  3459                                  
  3460                                  ;-597   if (c=='$') return 1;
  3461                                  
  3462                                  .letterE143:
  3463 000011B3 8A4604                   mov al, [bp+4]
  3464 000011B6 3C24                     cmp al, 36
  3465 000011B8 0F850600                 jne .letterE144
  3466 000011BC B80100                   mov ax, 1
  3467 000011BF E93C00                   jmp .retnletterE
  3468                                  
  3469                                  ;-598   if (c> 'z') return 0;
  3470                                  
  3471                                  .letterE144:
  3472 000011C2 8A4604                   mov al, [bp+4]
  3473 000011C5 3C7A                     cmp al, 122
  3474 000011C7 0F8E0600                 jle .letterE145
  3475 000011CB B80000                   mov ax, 0
  3476 000011CE E92D00                   jmp .retnletterE
  3477                                  
  3478                                  ;-599   if (c< '@') return 0; // at included
  3479                                  
  3480                                  .letterE145:
  3481 000011D1 8A4604                   mov al, [bp+4]
  3482 000011D4 3C40                     cmp al, 64
  3483 000011D6 0F8D0600                 jge .letterE146
  3484 000011DA B80000                   mov ax, 0
  3485 000011DD E91E00                   jmp .retnletterE
  3486                                  
  3487                                  ;-600   if (c> 'Z') { if (c< 'a') return 0; }
  3488                                  
  3489                                  .letterE146:
  3490 000011E0 8A4604                   mov al, [bp+4]
  3491 000011E3 3C5A                     cmp al, 90
  3492 000011E5 0F8E0F00                 jle .letterE147
  3493 000011E9 8A4604                   mov al, [bp+4]
  3494 000011EC 3C61                     cmp al, 97
  3495 000011EE 0F8D0600                 jge .letterE148
  3496 000011F2 B80000                   mov ax, 0
  3497 000011F5 E90600                   jmp .retnletterE
  3498                                  .letterE148:
  3499                                  
  3500                                  ;-601   return 1;
  3501                                  
  3502                                  .letterE147:
  3503 000011F8 B80100                   mov ax, 1
  3504 000011FB E90000                   jmp .retnletterE
  3505                                  
  3506                                  ;-602 }
  3507                                  
  3508                                  
  3509                                  ;-603 int alnumE(char c) {
  3510                                  
  3511 000011FE C9                       .retnletterE: LEAVE
  3512 000011FF C3                       ret
  3513                                  ENDP
  3514                                  
  3515                                  alnumE: PROC
  3516                                  
  3517                                  ;-604   if (digit(c)) return 1;
  3518                                  
  3519                                  ;Function : alnumE, Number of local variables: 1
  3520                                  ;   # type sign width addr used name   list of local variables
  3521                                  ;  200 var sign byte   603 NULL c = bp+4;
  3522 00001200 C8000000                 ENTER  0,0
  3523 00001204 8A4604                   mov al, byte [bp+4]
  3524 00001207 B400                     mov ah, 0
  3525 00001209 50                       push ax
  3526 0000120A E82F00                   call digit
  3527 0000120D 83C402                   add  sp, 2
  3528 00001210 08C0                     or  al, al
  3529 00001212 0F840600                 je .alnumE149
  3530 00001216 B80100                   mov ax, 1
  3531 00001219 E91E00                   jmp .retnalnumE
  3532                                  
  3533                                  ;-605   if (letterE(c)) return 1;
  3534                                  
  3535                                  .alnumE149:
  3536 0000121C 8A4604                   mov al, byte [bp+4]
  3537 0000121F B400                     mov ah, 0
  3538 00001221 50                       push ax
  3539 00001222 E85DFF                   call letterE
  3540 00001225 83C402                   add  sp, 2
  3541 00001228 08C0                     or  al, al
  3542 0000122A 0F840600                 je .alnumE150
  3543 0000122E B80100                   mov ax, 1
  3544 00001231 E90600                   jmp .retnalnumE
  3545                                  
  3546                                  ;-606   return 0;
  3547                                  
  3548                                  .alnumE150:
  3549 00001234 B80000                   mov ax, 0
  3550 00001237 E90000                   jmp .retnalnumE
  3551                                  
  3552                                  ;-607 }
  3553                                  
  3554                                  
  3555                                  ;-608 int digit(char c){
  3556                                  
  3557 0000123A C9                       .retnalnumE: LEAVE
  3558 0000123B C3                       ret
  3559                                  ENDP
  3560                                  
  3561                                  digit: PROC
  3562                                  
  3563                                  ;-609     if(c<'0') return 0;
  3564                                  
  3565                                  ;Function : digit, Number of local variables: 1
  3566                                  ;   # type sign width addr used name   list of local variables
  3567                                  ;  200 var sign byte   608 NULL c = bp+4;
  3568 0000123C C8000000                 ENTER  0,0
  3569 00001240 8A4604                   mov al, [bp+4]
  3570 00001243 3C30                     cmp al, 48
  3571 00001245 0F8D0600                 jge .digit151
  3572 00001249 B80000                   mov ax, 0
  3573 0000124C E91500                   jmp .retndigit
  3574                                  
  3575                                  ;-610     if(c>'9') return 0;
  3576                                  
  3577                                  .digit151:
  3578 0000124F 8A4604                   mov al, [bp+4]
  3579 00001252 3C39                     cmp al, 57
  3580 00001254 0F8E0600                 jle .digit152
  3581 00001258 B80000                   mov ax, 0
  3582 0000125B E90600                   jmp .retndigit
  3583                                  
  3584                                  ;-611     return 1;
  3585                                  
  3586                                  .digit152:
  3587 0000125E B80100                   mov ax, 1
  3588 00001261 E90000                   jmp .retndigit
  3589                                  
  3590                                  ;-612 }
  3591                                  
  3592                                  
  3593                                  ;-613 int strlen(char *s) { int c;
  3594                                  
  3595 00001264 C9                       .retndigit: LEAVE
  3596 00001265 C3                       ret
  3597                                  ENDP
  3598                                  
  3599                                  strlen: PROC
  3600                                  
  3601                                  ;-614     c=0;
  3602                                  
  3603                                  ;Function : strlen, Number of local variables: 2
  3604                                  ;   # type sign width addr used name   list of local variables
  3605                                  ;  200 ptr sign byte   613 NULL s = bp+4
  3606                                  ;  201 var sign word   613 NULL c = bp-2;
  3607 00001266 C8020000                 ENTER  2,0
  3608 0000126A B80000                   mov ax, 0
  3609 0000126D 8946FE                   mov [bp-2], ax
  3610                                  
  3611                                  ;-615     while (*s!=0) {s++; c++;}
  3612                                  
  3613                                  .strlen153:
  3614 00001270 8B5E04                   mov bx, [bp+4]
  3615 00001273 8A07                     mov al, [bx]
  3616 00001275 B400                     mov ah, 0
  3617 00001277 83F800                   cmp ax, 0
  3618 0000127A 0F840800                 je  .strlen154
  3619 0000127E FF4604                   inc  word[bp+4]
  3620 00001281 FF46FE                   inc  word[bp-2]
  3621                                  
  3622                                  ;-616     return c;
  3623                                  
  3624 00001284 EBEA                     jmp .strlen153
  3625                                  .strlen154:
  3626 00001286 8B46FE                   mov ax, [bp-2]
  3627 00001289 E90000                   jmp .retnstrlen
  3628                                  
  3629                                  ;-617     }
  3630                                  
  3631                                  
  3632                                  ;-618 int strcpy(char *s, char *t) {
  3633                                  
  3634 0000128C C9                       .retnstrlen: LEAVE
  3635 0000128D C3                       ret
  3636                                  ENDP
  3637                                  
  3638                                  strcpy: PROC
  3639                                  
  3640                                  ;-619     do { *s=*t; s++; t++; }
  3641                                  
  3642                                  ;Function : strcpy, Number of local variables: 2
  3643                                  ;   # type sign width addr used name   list of local variables
  3644                                  ;  200 ptr sign byte   618 NULL s = bp+4
  3645                                  ;  201 ptr sign byte   618 NULL t = bp+6;
  3646 0000128E C8000000                 ENTER  0,0
  3647                                  .strcpy155:
  3648 00001292 8B5E06                   mov bx, [bp+6]
  3649 00001295 8A07                     mov al, [bx]
  3650 00001297 B400                     mov ah, 0
  3651 00001299 8B5E04                   mov  bx, [bp+4]
  3652 0000129C 8807                     mov  [bx], al
  3653 0000129E FF4604                   inc  word[bp+4]
  3654 000012A1 FF4606                   inc  word[bp+6]
  3655                                  
  3656                                  ;-620     while (*t!=0);
  3657                                  
  3658 000012A4 8B5E06                   mov bx, [bp+6]
  3659 000012A7 8A07                     mov al, [bx]
  3660 000012A9 B400                     mov ah, 0
  3661 000012AB 83F800                   cmp ax, 0
  3662 000012AE 0F840200                 je  .strcpy156
  3663 000012B2 EBDE                     jmp .strcpy155
  3664                                  .strcpy156:
  3665                                  
  3666                                  ;-621     *s=0;
  3667                                  
  3668 000012B4 B80000                   mov ax, 0
  3669 000012B7 8B5E04                   mov  bx, [bp+4]
  3670 000012BA 8807                     mov  [bx], al
  3671                                  
  3672                                  ;-622     return s;
  3673                                  
  3674 000012BC 8B4604                   mov ax, [bp+4]
  3675 000012BF E90000                   jmp .retnstrcpy
  3676                                  
  3677                                  ;-623     }
  3678                                  
  3679                                  
  3680                                  ;-624 int eqstr(char *p, char *q) {
  3681                                  
  3682 000012C2 C9                       .retnstrcpy: LEAVE
  3683 000012C3 C3                       ret
  3684                                  ENDP
  3685                                  
  3686                                  eqstr: PROC
  3687                                  
  3688                                  ;-625     while(*p) {
  3689                                  
  3690                                  ;Function : eqstr, Number of local variables: 2
  3691                                  ;   # type sign width addr used name   list of local variables
  3692                                  ;  200 ptr sign byte   624 NULL p = bp+4
  3693                                  ;  201 ptr sign byte   624 NULL q = bp+6;
  3694 000012C4 C8000000                 ENTER  0,0
  3695                                  .eqstr157:
  3696 000012C8 8B5E04                   mov bx, [bp+4]
  3697 000012CB 8A07                     mov al, [bx]
  3698 000012CD B400                     mov ah, 0
  3699 000012CF 08C0                     or  al, al
  3700 000012D1 0F842000                 je .eqstr158
  3701                                  
  3702                                  ;-626         if (*p != *q) return 0;
  3703                                  
  3704 000012D5 8B5E04                   mov bx, [bp+4]
  3705 000012D8 8A07                     mov al, [bx]
  3706 000012DA B400                     mov ah, 0
  3707 000012DC 8B5E06                   mov bx, [bp+6]
  3708 000012DF 3A07                     cmp al, [bx]
  3709 000012E1 B400                     mov ah, 0
  3710 000012E3 0F840600                 je  .eqstr159
  3711 000012E7 B80000                   mov ax, 0
  3712 000012EA E92100                   jmp .retneqstr
  3713                                  
  3714                                  ;-627             p++;
  3715                                  
  3716                                  .eqstr159:
  3717 000012ED FF4604                   inc  word[bp+4]
  3718                                  
  3719                                  ;-628             q++;
  3720                                  
  3721 000012F0 FF4606                   inc  word[bp+6]
  3722                                  
  3723                                  ;-629             }
  3724                                  
  3725                                  
  3726                                  ;-630     if(*q) return 0;
  3727                                  
  3728 000012F3 EBD3                     jmp .eqstr157
  3729                                  .eqstr158:
  3730 000012F5 8B5E06                   mov bx, [bp+6]
  3731 000012F8 8A07                     mov al, [bx]
  3732 000012FA B400                     mov ah, 0
  3733 000012FC 08C0                     or  al, al
  3734 000012FE 0F840600                 je .eqstr160
  3735 00001302 B80000                   mov ax, 0
  3736 00001305 E90600                   jmp .retneqstr
  3737                                  
  3738                                  ;-631     return 1;
  3739                                  
  3740                                  .eqstr160:
  3741 00001308 B80100                   mov ax, 1
  3742 0000130B E90000                   jmp .retneqstr
  3743                                  
  3744                                  ;-632     }
  3745                                  
  3746                                  
  3747                                  ;-633 int strcat1(char *s, char *t) {
  3748                                  
  3749 0000130E C9                       .retneqstr: LEAVE
  3750 0000130F C3                       ret
  3751                                  ENDP
  3752                                  
  3753                                  strcat1: PROC
  3754                                  
  3755                                  ;-634     while (*s != 0) s++;
  3756                                  
  3757                                  ;Function : strcat1, Number of local variables: 2
  3758                                  ;   # type sign width addr used name   list of local variables
  3759                                  ;  200 ptr sign byte   633 NULL s = bp+4
  3760                                  ;  201 ptr sign byte   633 NULL t = bp+6;
  3761 00001310 C8000000                 ENTER  0,0
  3762                                  .strcat1161:
  3763 00001314 8B5E04                   mov bx, [bp+4]
  3764 00001317 8A07                     mov al, [bx]
  3765 00001319 B400                     mov ah, 0
  3766 0000131B 83F800                   cmp ax, 0
  3767 0000131E 0F840500                 je  .strcat1162
  3768 00001322 FF4604                   inc  word[bp+4]
  3769                                  
  3770                                  ;-635     strcpy(s, t);
  3771                                  
  3772 00001325 EBED                     jmp .strcat1161
  3773                                  .strcat1162:
  3774 00001327 FF7606                   push word [bp+6]
  3775 0000132A FF7604                   push word [bp+4]
  3776 0000132D E85EFF                   call strcpy
  3777 00001330 83C404                   add  sp, 4
  3778                                  
  3779                                  ;-636     }
  3780                                  
  3781                                  
  3782                                  ;-637 int toupper(char *s) {
  3783 00001333 C9                       LEAVE
  3784 00001334 C3                       ret
  3785                                  ENDP
  3786                                  
  3787                                  toupper: PROC
  3788                                  
  3789                                  ;-638     while(*s) {
  3790                                  
  3791                                  ;Function : toupper, Number of local variables: 1
  3792                                  ;   # type sign width addr used name   list of local variables
  3793                                  ;  200 ptr sign byte   637 NULL s = bp+4;
  3794 00001335 C8000000                 ENTER  0,0
  3795                                  .toupper163:
  3796 00001339 8B5E04                   mov bx, [bp+4]
  3797 0000133C 8A07                     mov al, [bx]
  3798 0000133E B400                     mov ah, 0
  3799 00001340 08C0                     or  al, al
  3800 00001342 0F843000                 je .toupper164
  3801                                  
  3802                                  ;-639         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3803                                  
  3804 00001346 8B5E04                   mov bx, [bp+4]
  3805 00001349 8A07                     mov al, [bx]
  3806 0000134B B400                     mov ah, 0
  3807 0000134D 83F861                   cmp ax, 97 ;unsigned : 1
  3808 00001350 0F8C1D00                 jl  .toupper165
  3809 00001354 8B5E04                   mov bx, [bp+4]
  3810 00001357 8A07                     mov al, [bx]
  3811 00001359 B400                     mov ah, 0
  3812 0000135B 83F87A                   cmp ax, 122
  3813 0000135E 0F8F0F00                 jg  .toupper166
  3814 00001362 8B5E04                   mov bx, [bp+4]
  3815 00001365 8A07                     mov al, [bx]
  3816 00001367 B400                     mov ah, 0
  3817 00001369 83E820                   sub ax, 32
  3818 0000136C 8B5E04                   mov  bx, [bp+4]
  3819 0000136F 8807                     mov  [bx], al
  3820                                  
  3821                                  ;-640             s++;
  3822                                  
  3823                                  .toupper166:
  3824                                  .toupper165:
  3825 00001371 FF4604                   inc  word[bp+4]
  3826                                  
  3827                                  ;-641               }
  3828                                  
  3829                                  
  3830                                  ;-642     }
  3831                                  
  3832 00001374 EBC3                     jmp .toupper163
  3833                                  .toupper164:
  3834                                  
  3835                                  ;-643 
  3836                                  
  3837                                  
  3838                                  ;-644 int getDigit(unsigned char c) {//ret: SymbolInt
  3839 00001376 C9                       LEAVE
  3840 00001377 C3                       ret
  3841                                  ENDP
  3842                                  
  3843                                  getDigit: PROC
  3844                                  
  3845                                  ;-645   unsigned int CastInt;
  3846                                  
  3847                                  
  3848                                  ;-646   SymbolInt=0;
  3849                                  
  3850                                  ;Function : getDigit, Number of local variables: 2
  3851                                  ;   # type sign width addr used name   list of local variables
  3852                                  ;  200 var unsg byte   644 NULL c = bp+4
  3853                                  ;  201 var unsg word   645 NULL CastInt = bp-2;
  3854 00001378 C8020000                 ENTER  2,0
  3855 0000137C B80000                   mov ax, 0
  3856 0000137F A3[0E00]                 mov word [SymbolInt], ax
  3857                                  
  3858                                  ;-647   do {
  3859                                  
  3860                                  .getDigit167:
  3861                                  
  3862                                  ;-648     c-='0';
  3863                                  
  3864 00001382 806E0430                 sub  byte[bp+4], 48
  3865                                  
  3866                                  ;-649     SymbolInt=SymbolInt*10;
  3867                                  
  3868 00001386 A1[0E00]                 mov ax, [SymbolInt]
  3869 00001389 BB0A00                   mov bx, 10
  3870 0000138C F7E3                     mul bx
  3871 0000138E A3[0E00]                 mov word [SymbolInt], ax
  3872                                  
  3873                                  ;-650     ax=0; CastInt=c; //cast b2w
  3874                                  
  3875 00001391 B80000                   mov  ax, 0
  3876 00001394 8A4604                   mov al, [bp+4]
  3877 00001397 8946FE                   mov [bp-2], ax
  3878                                  
  3879                                  ;-651     SymbolInt=SymbolInt+CastInt;
  3880                                  
  3881 0000139A A1[0E00]                 mov ax, [SymbolInt]
  3882 0000139D 0346FE                   add ax, [bp-2]
  3883 000013A0 A3[0E00]                 mov word [SymbolInt], ax
  3884                                  
  3885                                  ;-652     InputPtr++;
  3886                                  
  3887 000013A3 FF06[1400]               inc  word[InputPtr]
  3888                                  
  3889                                  ;-653     c = *InputPtr;
  3890                                  
  3891 000013A7 8B1E[1400]               mov bx, [InputPtr]
  3892 000013AB 8A07                     mov al, [bx]
  3893 000013AD B400                     mov ah, 0
  3894 000013AF 884604                   mov [bp+4], al
  3895                                  
  3896                                  ;-654   } while(digit(c));
  3897                                  
  3898 000013B2 8A4604                   mov al, byte [bp+4]
  3899 000013B5 B400                     mov ah, 0
  3900 000013B7 50                       push ax
  3901 000013B8 E881FE                   call digit
  3902 000013BB 83C402                   add  sp, 2
  3903 000013BE 08C0                     or  al, al
  3904 000013C0 0F840200                 je .getDigit168
  3905 000013C4 EBBC                     jmp .getDigit167
  3906                                  .getDigit168:
  3907                                  
  3908                                  ;-655 }
  3909                                  
  3910                                  
  3911                                  ;-656 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3912 000013C6 C9                       LEAVE
  3913 000013C7 C3                       ret
  3914                                  ENDP
  3915                                  
  3916                                  getName: PROC
  3917                                  
  3918                                  ;-657   char *p; unsigned int i;
  3919                                  
  3920                                  
  3921                                  ;-658   p = &Symbol;
  3922                                  
  3923                                  ;Function : getName, Number of local variables: 3
  3924                                  ;   # type sign width addr used name   list of local variables
  3925                                  ;  200 var unsg byte   656 NULL c = bp+4
  3926                                  ;  201 ptr sign byte   657 NULL p = bp-2
  3927                                  ;  202 var unsg word   657 NULL i = bp-4;
  3928 000013C8 C8040000                 ENTER  4,0
  3929 000013CC B83075                   mov ax, Symbol
  3930 000013CF 8946FE                   mov [bp-2], ax
  3931                                  
  3932                                  ;-659   *p = c;
  3933                                  
  3934 000013D2 8A4604                   mov al, [bp+4]
  3935 000013D5 8B5EFE                   mov  bx, [bp-2]
  3936 000013D8 8807                     mov  [bx], al
  3937                                  
  3938                                  ;-660   p++;
  3939                                  
  3940 000013DA FF46FE                   inc  word[bp-2]
  3941                                  
  3942                                  ;-661   while (alnumE(c)) {
  3943                                  
  3944                                  .getName169:
  3945 000013DD 8A4604                   mov al, byte [bp+4]
  3946 000013E0 B400                     mov ah, 0
  3947 000013E2 50                       push ax
  3948 000013E3 E81AFE                   call alnumE
  3949 000013E6 83C402                   add  sp, 2
  3950 000013E9 08C0                     or  al, al
  3951 000013EB 0F843800                 je .getName170
  3952                                  
  3953                                  ;-662     InputPtr++;
  3954                                  
  3955 000013EF FF06[1400]               inc  word[InputPtr]
  3956                                  
  3957                                  ;-663     c = *InputPtr;
  3958                                  
  3959 000013F3 8B1E[1400]               mov bx, [InputPtr]
  3960 000013F7 8A07                     mov al, [bx]
  3961 000013F9 B400                     mov ah, 0
  3962 000013FB 884604                   mov [bp+4], al
  3963                                  
  3964                                  ;-664     *p = c;
  3965                                  
  3966 000013FE 8A4604                   mov al, [bp+4]
  3967 00001401 8B5EFE                   mov  bx, [bp-2]
  3968 00001404 8807                     mov  [bx], al
  3969                                  
  3970                                  ;-665     p++;
  3971                                  
  3972 00001406 FF46FE                   inc  word[bp-2]
  3973                                  
  3974                                  ;-666     i = p - &Symbol;
  3975                                  
  3976 00001409 8B46FE                   mov ax, [bp-2]
  3977 0000140C 2D3075                   sub ax, Symbol
  3978 0000140F 8946FC                   mov [bp-4], ax
  3979                                  
  3980                                  ;-667     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3981                                  
  3982 00001412 8B46FC                   mov ax, [bp-4]
  3983 00001415 83F81F                   cmp ax, 31 ;unsigned : 0
  3984 00001418 0F820900                 jb  .getName171
  3985 0000141C 68[6714]                 push getName_0
  3986 0000141F E8C506                   call errorexit
  3987 00001422 83C402                   add  sp, 2
  3988                                  
  3989                                  ;-668   }
  3990                                  
  3991                                  .getName171:
  3992                                  
  3993                                  ;-669   if (c == ':') isLabel=1; else isLabel=0;
  3994                                  
  3995 00001425 EBB6                     jmp .getName169
  3996                                  .getName170:
  3997 00001427 8A4604                   mov al, [bp+4]
  3998 0000142A 3C3A                     cmp al, 58
  3999 0000142C 0F850900                 jne .getName172
  4000 00001430 B80100                   mov ax, 1
  4001 00001433 A2[2B00]                 mov byte [isLabel], al
  4002 00001436 E90600                   jmp .getName173
  4003                                  .getName172:
  4004 00001439 B80000                   mov ax, 0
  4005 0000143C A2[2B00]                 mov byte [isLabel], al
  4006                                  
  4007                                  ;-670   p--;
  4008                                  
  4009                                  .getName173:
  4010 0000143F FF4EFE                   dec  word[bp-2]
  4011                                  
  4012                                  ;-671   *p = 0;
  4013                                  
  4014 00001442 B80000                   mov ax, 0
  4015 00001445 8B5EFE                   mov  bx, [bp-2]
  4016 00001448 8807                     mov  [bx], al
  4017                                  
  4018                                  ;-672   strcpy(SymbolUpper, Symbol);
  4019                                  
  4020 0000144A 8D063075                 lea  ax, [Symbol]
  4021 0000144E 50                       push ax
  4022 0000144F 8D064F75                 lea  ax, [SymbolUpper]
  4023 00001453 50                       push ax
  4024 00001454 E837FE                   call strcpy
  4025 00001457 83C404                   add  sp, 4
  4026                                  
  4027                                  ;-673   toupper(SymbolUpper);
  4028                                  
  4029 0000145A 8D064F75                 lea  ax, [SymbolUpper]
  4030 0000145E 50                       push ax
  4031 0000145F E8D3FE                   call toupper
  4032 00001462 83C402                   add  sp, 2
  4033                                  
  4034                                  ;-674 }
  4035                                  
  4036                                  
  4037                                  ;-675 int testReg() {
  4038 00001465 C9                       LEAVE
  4039 00001466 C3                       ret
  4040 00001467 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4041 00001470 6F206C6F6E6700     
  4042                                  ENDP
  4043                                  
  4044                                  testReg: PROC
  4045                                  
  4046                                  ;-676 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4047                                  
  4048                                  
  4049                                  ;-677   R2Type=0;
  4050                                  
  4051 00001477 B80000                   mov ax, 0
  4052 0000147A A2[3500]                 mov byte [R2Type], al
  4053                                  
  4054                                  ;-678   if (strlen(Symbol) < 2) return 0;
  4055                                  
  4056 0000147D 8D063075                 lea  ax, [Symbol]
  4057 00001481 50                       push ax
  4058 00001482 E8E1FD                   call strlen
  4059 00001485 83C402                   add  sp, 2
  4060 00001488 3C02                     cmp al, 2
  4061 0000148A 0F8D0600                 jge .testReg174
  4062 0000148E B80000                   mov ax, 0
  4063 00001491 E94703                   jmp .retntestReg
  4064                                  
  4065                                  ;-679   if (strlen(Symbol) > 3) return 0;
  4066                                  
  4067                                  .testReg174:
  4068 00001494 8D063075                 lea  ax, [Symbol]
  4069 00001498 50                       push ax
  4070 00001499 E8CAFD                   call strlen
  4071 0000149C 83C402                   add  sp, 2
  4072 0000149F 3C03                     cmp al, 3
  4073 000014A1 0F8E0600                 jle .testReg175
  4074 000014A5 B80000                   mov ax, 0
  4075 000014A8 E93003                   jmp .retntestReg
  4076                                  
  4077                                  ;-680   R2Type=BYTE;
  4078                                  
  4079                                  .testReg175:
  4080 000014AB B80100                   mov ax, 1
  4081 000014AE A2[3500]                 mov byte [R2Type], al
  4082                                  
  4083                                  ;-681   if (eqstr(SymbolUpper, "AL")) return 0;
  4084                                  
  4085 000014B1 68[DC17]                 push testReg_0
  4086 000014B4 8D064F75                 lea  ax, [SymbolUpper]
  4087 000014B8 50                       push ax
  4088 000014B9 E808FE                   call eqstr
  4089 000014BC 83C404                   add  sp, 4
  4090 000014BF 08C0                     or  al, al
  4091 000014C1 0F840600                 je .testReg176
  4092 000014C5 B80000                   mov ax, 0
  4093 000014C8 E91003                   jmp .retntestReg
  4094                                  
  4095                                  ;-682   if (eqstr(SymbolUpper, "CL")) return 1;
  4096                                  
  4097                                  .testReg176:
  4098 000014CB 68[DF17]                 push testReg_1
  4099 000014CE 8D064F75                 lea  ax, [SymbolUpper]
  4100 000014D2 50                       push ax
  4101 000014D3 E8EEFD                   call eqstr
  4102 000014D6 83C404                   add  sp, 4
  4103 000014D9 08C0                     or  al, al
  4104 000014DB 0F840600                 je .testReg177
  4105 000014DF B80100                   mov ax, 1
  4106 000014E2 E9F602                   jmp .retntestReg
  4107                                  
  4108                                  ;-683   if (eqstr(SymbolUpper, "DL")) return 2;
  4109                                  
  4110                                  .testReg177:
  4111 000014E5 68[E217]                 push testReg_2
  4112 000014E8 8D064F75                 lea  ax, [SymbolUpper]
  4113 000014EC 50                       push ax
  4114 000014ED E8D4FD                   call eqstr
  4115 000014F0 83C404                   add  sp, 4
  4116 000014F3 08C0                     or  al, al
  4117 000014F5 0F840600                 je .testReg178
  4118 000014F9 B80200                   mov ax, 2
  4119 000014FC E9DC02                   jmp .retntestReg
  4120                                  
  4121                                  ;-684   if (eqstr(SymbolUpper, "BL")) return 3;
  4122                                  
  4123                                  .testReg178:
  4124 000014FF 68[E517]                 push testReg_3
  4125 00001502 8D064F75                 lea  ax, [SymbolUpper]
  4126 00001506 50                       push ax
  4127 00001507 E8BAFD                   call eqstr
  4128 0000150A 83C404                   add  sp, 4
  4129 0000150D 08C0                     or  al, al
  4130 0000150F 0F840600                 je .testReg179
  4131 00001513 B80300                   mov ax, 3
  4132 00001516 E9C202                   jmp .retntestReg
  4133                                  
  4134                                  ;-685   if (eqstr(SymbolUpper, "AH")) return 4;
  4135                                  
  4136                                  .testReg179:
  4137 00001519 68[E817]                 push testReg_4
  4138 0000151C 8D064F75                 lea  ax, [SymbolUpper]
  4139 00001520 50                       push ax
  4140 00001521 E8A0FD                   call eqstr
  4141 00001524 83C404                   add  sp, 4
  4142 00001527 08C0                     or  al, al
  4143 00001529 0F840600                 je .testReg180
  4144 0000152D B80400                   mov ax, 4
  4145 00001530 E9A802                   jmp .retntestReg
  4146                                  
  4147                                  ;-686   if (eqstr(SymbolUpper, "CH")) return 5;
  4148                                  
  4149                                  .testReg180:
  4150 00001533 68[EB17]                 push testReg_5
  4151 00001536 8D064F75                 lea  ax, [SymbolUpper]
  4152 0000153A 50                       push ax
  4153 0000153B E886FD                   call eqstr
  4154 0000153E 83C404                   add  sp, 4
  4155 00001541 08C0                     or  al, al
  4156 00001543 0F840600                 je .testReg181
  4157 00001547 B80500                   mov ax, 5
  4158 0000154A E98E02                   jmp .retntestReg
  4159                                  
  4160                                  ;-687   if (eqstr(SymbolUpper, "DH")) return 6;
  4161                                  
  4162                                  .testReg181:
  4163 0000154D 68[EE17]                 push testReg_6
  4164 00001550 8D064F75                 lea  ax, [SymbolUpper]
  4165 00001554 50                       push ax
  4166 00001555 E86CFD                   call eqstr
  4167 00001558 83C404                   add  sp, 4
  4168 0000155B 08C0                     or  al, al
  4169 0000155D 0F840600                 je .testReg182
  4170 00001561 B80600                   mov ax, 6
  4171 00001564 E97402                   jmp .retntestReg
  4172                                  
  4173                                  ;-688   if (eqstr(SymbolUpper, "BH")) return 7;
  4174                                  
  4175                                  .testReg182:
  4176 00001567 68[F117]                 push testReg_7
  4177 0000156A 8D064F75                 lea  ax, [SymbolUpper]
  4178 0000156E 50                       push ax
  4179 0000156F E852FD                   call eqstr
  4180 00001572 83C404                   add  sp, 4
  4181 00001575 08C0                     or  al, al
  4182 00001577 0F840600                 je .testReg183
  4183 0000157B B80700                   mov ax, 7
  4184 0000157E E95A02                   jmp .retntestReg
  4185                                  
  4186                                  ;-689   R2Type=WORD;
  4187                                  
  4188                                  .testReg183:
  4189 00001581 B80200                   mov ax, 2
  4190 00001584 A2[3500]                 mov byte [R2Type], al
  4191                                  
  4192                                  ;-690   if (eqstr(SymbolUpper, "AX")) return 0;
  4193                                  
  4194 00001587 68[F417]                 push testReg_8
  4195 0000158A 8D064F75                 lea  ax, [SymbolUpper]
  4196 0000158E 50                       push ax
  4197 0000158F E832FD                   call eqstr
  4198 00001592 83C404                   add  sp, 4
  4199 00001595 08C0                     or  al, al
  4200 00001597 0F840600                 je .testReg184
  4201 0000159B B80000                   mov ax, 0
  4202 0000159E E93A02                   jmp .retntestReg
  4203                                  
  4204                                  ;-691   if (eqstr(SymbolUpper, "CX")) return 1;
  4205                                  
  4206                                  .testReg184:
  4207 000015A1 68[F717]                 push testReg_9
  4208 000015A4 8D064F75                 lea  ax, [SymbolUpper]
  4209 000015A8 50                       push ax
  4210 000015A9 E818FD                   call eqstr
  4211 000015AC 83C404                   add  sp, 4
  4212 000015AF 08C0                     or  al, al
  4213 000015B1 0F840600                 je .testReg185
  4214 000015B5 B80100                   mov ax, 1
  4215 000015B8 E92002                   jmp .retntestReg
  4216                                  
  4217                                  ;-692   if (eqstr(SymbolUpper, "DX")) return 2;
  4218                                  
  4219                                  .testReg185:
  4220 000015BB 68[FA17]                 push testReg_10
  4221 000015BE 8D064F75                 lea  ax, [SymbolUpper]
  4222 000015C2 50                       push ax
  4223 000015C3 E8FEFC                   call eqstr
  4224 000015C6 83C404                   add  sp, 4
  4225 000015C9 08C0                     or  al, al
  4226 000015CB 0F840600                 je .testReg186
  4227 000015CF B80200                   mov ax, 2
  4228 000015D2 E90602                   jmp .retntestReg
  4229                                  
  4230                                  ;-693   if (eqstr(SymbolUpper, "BX")) return 3;
  4231                                  
  4232                                  .testReg186:
  4233 000015D5 68[FD17]                 push testReg_11
  4234 000015D8 8D064F75                 lea  ax, [SymbolUpper]
  4235 000015DC 50                       push ax
  4236 000015DD E8E4FC                   call eqstr
  4237 000015E0 83C404                   add  sp, 4
  4238 000015E3 08C0                     or  al, al
  4239 000015E5 0F840600                 je .testReg187
  4240 000015E9 B80300                   mov ax, 3
  4241 000015EC E9EC01                   jmp .retntestReg
  4242                                  
  4243                                  ;-694   if (eqstr(SymbolUpper, "SP")) return 4;
  4244                                  
  4245                                  .testReg187:
  4246 000015EF 68[0018]                 push testReg_12
  4247 000015F2 8D064F75                 lea  ax, [SymbolUpper]
  4248 000015F6 50                       push ax
  4249 000015F7 E8CAFC                   call eqstr
  4250 000015FA 83C404                   add  sp, 4
  4251 000015FD 08C0                     or  al, al
  4252 000015FF 0F840600                 je .testReg188
  4253 00001603 B80400                   mov ax, 4
  4254 00001606 E9D201                   jmp .retntestReg
  4255                                  
  4256                                  ;-695   if (eqstr(SymbolUpper, "BP")) return 5;
  4257                                  
  4258                                  .testReg188:
  4259 00001609 68[0318]                 push testReg_13
  4260 0000160C 8D064F75                 lea  ax, [SymbolUpper]
  4261 00001610 50                       push ax
  4262 00001611 E8B0FC                   call eqstr
  4263 00001614 83C404                   add  sp, 4
  4264 00001617 08C0                     or  al, al
  4265 00001619 0F840600                 je .testReg189
  4266 0000161D B80500                   mov ax, 5
  4267 00001620 E9B801                   jmp .retntestReg
  4268                                  
  4269                                  ;-696   if (eqstr(SymbolUpper, "SI")) return 6;
  4270                                  
  4271                                  .testReg189:
  4272 00001623 68[0618]                 push testReg_14
  4273 00001626 8D064F75                 lea  ax, [SymbolUpper]
  4274 0000162A 50                       push ax
  4275 0000162B E896FC                   call eqstr
  4276 0000162E 83C404                   add  sp, 4
  4277 00001631 08C0                     or  al, al
  4278 00001633 0F840600                 je .testReg190
  4279 00001637 B80600                   mov ax, 6
  4280 0000163A E99E01                   jmp .retntestReg
  4281                                  
  4282                                  ;-697   if (eqstr(SymbolUpper, "DI")) return 7;
  4283                                  
  4284                                  .testReg190:
  4285 0000163D 68[0918]                 push testReg_15
  4286 00001640 8D064F75                 lea  ax, [SymbolUpper]
  4287 00001644 50                       push ax
  4288 00001645 E87CFC                   call eqstr
  4289 00001648 83C404                   add  sp, 4
  4290 0000164B 08C0                     or  al, al
  4291 0000164D 0F840600                 je .testReg191
  4292 00001651 B80700                   mov ax, 7
  4293 00001654 E98401                   jmp .retntestReg
  4294                                  
  4295                                  ;-698   R2Type=SEGREG;
  4296                                  
  4297                                  .testReg191:
  4298 00001657 B80400                   mov ax, 4
  4299 0000165A A2[3500]                 mov byte [R2Type], al
  4300                                  
  4301                                  ;-699   if (eqstr(SymbolUpper, "ES")) return 0;
  4302                                  
  4303 0000165D 68[0C18]                 push testReg_16
  4304 00001660 8D064F75                 lea  ax, [SymbolUpper]
  4305 00001664 50                       push ax
  4306 00001665 E85CFC                   call eqstr
  4307 00001668 83C404                   add  sp, 4
  4308 0000166B 08C0                     or  al, al
  4309 0000166D 0F840600                 je .testReg192
  4310 00001671 B80000                   mov ax, 0
  4311 00001674 E96401                   jmp .retntestReg
  4312                                  
  4313                                  ;-700   if (eqstr(SymbolUpper, "CS")) return 1;
  4314                                  
  4315                                  .testReg192:
  4316 00001677 68[0F18]                 push testReg_17
  4317 0000167A 8D064F75                 lea  ax, [SymbolUpper]
  4318 0000167E 50                       push ax
  4319 0000167F E842FC                   call eqstr
  4320 00001682 83C404                   add  sp, 4
  4321 00001685 08C0                     or  al, al
  4322 00001687 0F840600                 je .testReg193
  4323 0000168B B80100                   mov ax, 1
  4324 0000168E E94A01                   jmp .retntestReg
  4325                                  
  4326                                  ;-701   if (eqstr(SymbolUpper, "SS")) return 2;
  4327                                  
  4328                                  .testReg193:
  4329 00001691 68[1218]                 push testReg_18
  4330 00001694 8D064F75                 lea  ax, [SymbolUpper]
  4331 00001698 50                       push ax
  4332 00001699 E828FC                   call eqstr
  4333 0000169C 83C404                   add  sp, 4
  4334 0000169F 08C0                     or  al, al
  4335 000016A1 0F840600                 je .testReg194
  4336 000016A5 B80200                   mov ax, 2
  4337 000016A8 E93001                   jmp .retntestReg
  4338                                  
  4339                                  ;-702   if (eqstr(SymbolUpper, "DS")) return 3;
  4340                                  
  4341                                  .testReg194:
  4342 000016AB 68[1518]                 push testReg_19
  4343 000016AE 8D064F75                 lea  ax, [SymbolUpper]
  4344 000016B2 50                       push ax
  4345 000016B3 E80EFC                   call eqstr
  4346 000016B6 83C404                   add  sp, 4
  4347 000016B9 08C0                     or  al, al
  4348 000016BB 0F840600                 je .testReg195
  4349 000016BF B80300                   mov ax, 3
  4350 000016C2 E91601                   jmp .retntestReg
  4351                                  
  4352                                  ;-703   if (eqstr(SymbolUpper, "FS")) return 4;
  4353                                  
  4354                                  .testReg195:
  4355 000016C5 68[1818]                 push testReg_20
  4356 000016C8 8D064F75                 lea  ax, [SymbolUpper]
  4357 000016CC 50                       push ax
  4358 000016CD E8F4FB                   call eqstr
  4359 000016D0 83C404                   add  sp, 4
  4360 000016D3 08C0                     or  al, al
  4361 000016D5 0F840600                 je .testReg196
  4362 000016D9 B80400                   mov ax, 4
  4363 000016DC E9FC00                   jmp .retntestReg
  4364                                  
  4365                                  ;-704   if (eqstr(SymbolUpper, "GS")) return 5;
  4366                                  
  4367                                  .testReg196:
  4368 000016DF 68[1B18]                 push testReg_21
  4369 000016E2 8D064F75                 lea  ax, [SymbolUpper]
  4370 000016E6 50                       push ax
  4371 000016E7 E8DAFB                   call eqstr
  4372 000016EA 83C404                   add  sp, 4
  4373 000016ED 08C0                     or  al, al
  4374 000016EF 0F840600                 je .testReg197
  4375 000016F3 B80500                   mov ax, 5
  4376 000016F6 E9E200                   jmp .retntestReg
  4377                                  
  4378                                  ;-705   R2Type=DWORD;
  4379                                  
  4380                                  .testReg197:
  4381 000016F9 B80300                   mov ax, 3
  4382 000016FC A2[3500]                 mov byte [R2Type], al
  4383                                  
  4384                                  ;-706   if (eqstr(SymbolUpper, "EAX"))return 0;
  4385                                  
  4386 000016FF 68[1E18]                 push testReg_22
  4387 00001702 8D064F75                 lea  ax, [SymbolUpper]
  4388 00001706 50                       push ax
  4389 00001707 E8BAFB                   call eqstr
  4390 0000170A 83C404                   add  sp, 4
  4391 0000170D 08C0                     or  al, al
  4392 0000170F 0F840600                 je .testReg198
  4393 00001713 B80000                   mov ax, 0
  4394 00001716 E9C200                   jmp .retntestReg
  4395                                  
  4396                                  ;-707   if (eqstr(SymbolUpper, "ECX"))return 1;
  4397                                  
  4398                                  .testReg198:
  4399 00001719 68[2218]                 push testReg_23
  4400 0000171C 8D064F75                 lea  ax, [SymbolUpper]
  4401 00001720 50                       push ax
  4402 00001721 E8A0FB                   call eqstr
  4403 00001724 83C404                   add  sp, 4
  4404 00001727 08C0                     or  al, al
  4405 00001729 0F840600                 je .testReg199
  4406 0000172D B80100                   mov ax, 1
  4407 00001730 E9A800                   jmp .retntestReg
  4408                                  
  4409                                  ;-708   if (eqstr(SymbolUpper, "EDX"))return 2;
  4410                                  
  4411                                  .testReg199:
  4412 00001733 68[2618]                 push testReg_24
  4413 00001736 8D064F75                 lea  ax, [SymbolUpper]
  4414 0000173A 50                       push ax
  4415 0000173B E886FB                   call eqstr
  4416 0000173E 83C404                   add  sp, 4
  4417 00001741 08C0                     or  al, al
  4418 00001743 0F840600                 je .testReg200
  4419 00001747 B80200                   mov ax, 2
  4420 0000174A E98E00                   jmp .retntestReg
  4421                                  
  4422                                  ;-709   if (eqstr(SymbolUpper, "EBX"))return 3;
  4423                                  
  4424                                  .testReg200:
  4425 0000174D 68[2A18]                 push testReg_25
  4426 00001750 8D064F75                 lea  ax, [SymbolUpper]
  4427 00001754 50                       push ax
  4428 00001755 E86CFB                   call eqstr
  4429 00001758 83C404                   add  sp, 4
  4430 0000175B 08C0                     or  al, al
  4431 0000175D 0F840600                 je .testReg201
  4432 00001761 B80300                   mov ax, 3
  4433 00001764 E97400                   jmp .retntestReg
  4434                                  
  4435                                  ;-710   if (eqstr(SymbolUpper, "ESP"))return 4;
  4436                                  
  4437                                  .testReg201:
  4438 00001767 68[2E18]                 push testReg_26
  4439 0000176A 8D064F75                 lea  ax, [SymbolUpper]
  4440 0000176E 50                       push ax
  4441 0000176F E852FB                   call eqstr
  4442 00001772 83C404                   add  sp, 4
  4443 00001775 08C0                     or  al, al
  4444 00001777 0F840600                 je .testReg202
  4445 0000177B B80400                   mov ax, 4
  4446 0000177E E95A00                   jmp .retntestReg
  4447                                  
  4448                                  ;-711   if (eqstr(SymbolUpper, "EBP"))return 5;
  4449                                  
  4450                                  .testReg202:
  4451 00001781 68[3218]                 push testReg_27
  4452 00001784 8D064F75                 lea  ax, [SymbolUpper]
  4453 00001788 50                       push ax
  4454 00001789 E838FB                   call eqstr
  4455 0000178C 83C404                   add  sp, 4
  4456 0000178F 08C0                     or  al, al
  4457 00001791 0F840600                 je .testReg203
  4458 00001795 B80500                   mov ax, 5
  4459 00001798 E94000                   jmp .retntestReg
  4460                                  
  4461                                  ;-712   if (eqstr(SymbolUpper, "ESI"))return 6;
  4462                                  
  4463                                  .testReg203:
  4464 0000179B 68[3618]                 push testReg_28
  4465 0000179E 8D064F75                 lea  ax, [SymbolUpper]
  4466 000017A2 50                       push ax
  4467 000017A3 E81EFB                   call eqstr
  4468 000017A6 83C404                   add  sp, 4
  4469 000017A9 08C0                     or  al, al
  4470 000017AB 0F840600                 je .testReg204
  4471 000017AF B80600                   mov ax, 6
  4472 000017B2 E92600                   jmp .retntestReg
  4473                                  
  4474                                  ;-713   if (eqstr(SymbolUpper, "EDI"))return 7;
  4475                                  
  4476                                  .testReg204:
  4477 000017B5 68[3A18]                 push testReg_29
  4478 000017B8 8D064F75                 lea  ax, [SymbolUpper]
  4479 000017BC 50                       push ax
  4480 000017BD E804FB                   call eqstr
  4481 000017C0 83C404                   add  sp, 4
  4482 000017C3 08C0                     or  al, al
  4483 000017C5 0F840600                 je .testReg205
  4484 000017C9 B80700                   mov ax, 7
  4485 000017CC E90C00                   jmp .retntestReg
  4486                                  
  4487                                  ;-714   R2Type=0; return 0;
  4488                                  
  4489                                  .testReg205:
  4490 000017CF B80000                   mov ax, 0
  4491 000017D2 A2[3500]                 mov byte [R2Type], al
  4492 000017D5 B80000                   mov ax, 0
  4493 000017D8 E90000                   jmp .retntestReg
  4494                                  
  4495                                  ;-715 }
  4496                                  
  4497                                  
  4498                                  ;-716 
  4499                                  
  4500                                  
  4501                                  ;-717 
  4502                                  
  4503                                  
  4504                                  ;-718 //#include "OUTPUT.C"
  4505                                  
  4506                                  
  4507                                  ;-719 int printLine() {
  4508                                  
  4509                                   .retntestReg:
  4510 000017DB C3                       ret
  4511 000017DC 414C00                  testReg_0 db "AL",0
  4512 000017DF 434C00                  testReg_1 db "CL",0
  4513 000017E2 444C00                  testReg_2 db "DL",0
  4514 000017E5 424C00                  testReg_3 db "BL",0
  4515 000017E8 414800                  testReg_4 db "AH",0
  4516 000017EB 434800                  testReg_5 db "CH",0
  4517 000017EE 444800                  testReg_6 db "DH",0
  4518 000017F1 424800                  testReg_7 db "BH",0
  4519 000017F4 415800                  testReg_8 db "AX",0
  4520 000017F7 435800                  testReg_9 db "CX",0
  4521 000017FA 445800                  testReg_10 db "DX",0
  4522 000017FD 425800                  testReg_11 db "BX",0
  4523 00001800 535000                  testReg_12 db "SP",0
  4524 00001803 425000                  testReg_13 db "BP",0
  4525 00001806 534900                  testReg_14 db "SI",0
  4526 00001809 444900                  testReg_15 db "DI",0
  4527 0000180C 455300                  testReg_16 db "ES",0
  4528 0000180F 435300                  testReg_17 db "CS",0
  4529 00001812 535300                  testReg_18 db "SS",0
  4530 00001815 445300                  testReg_19 db "DS",0
  4531 00001818 465300                  testReg_20 db "FS",0
  4532 0000181B 475300                  testReg_21 db "GS",0
  4533 0000181E 45415800                testReg_22 db "EAX",0
  4534 00001822 45435800                testReg_23 db "ECX",0
  4535 00001826 45445800                testReg_24 db "EDX",0
  4536 0000182A 45425800                testReg_25 db "EBX",0
  4537 0000182E 45535000                testReg_26 db "ESP",0
  4538 00001832 45425000                testReg_27 db "EBP",0
  4539 00001836 45534900                testReg_28 db "ESI",0
  4540 0000183A 45444900                testReg_29 db "EDI",0
  4541                                  ENDP
  4542                                  
  4543                                  printLine: PROC
  4544                                  
  4545                                  ;-720     int i; char c;
  4546                                  
  4547                                  
  4548                                  ;-721     prs("\n");
  4549                                  
  4550                                  ;Function : printLine, Number of local variables: 2
  4551                                  ;   # type sign width addr used name   list of local variables
  4552                                  ;  200 var sign word   720 NULL i = bp-2
  4553                                  ;  201 var sign byte   720 NULL c = bp-4;
  4554 0000183E C8040000                 ENTER  4,0
  4555 00001842 68[D018]                 push printLine_0
  4556 00001845 E8F700                   call prs
  4557 00001848 83C402                   add  sp, 2
  4558                                  
  4559                                  ;-722     printhex16(PCStart);
  4560                                  
  4561 0000184B FF36[2900]               push word [PCStart]
  4562 0000184F E8D301                   call printhex16
  4563 00001852 83C402                   add  sp, 2
  4564                                  
  4565                                  ;-723     if (OpPrintIndex == 0) prs("               ");
  4566                                  
  4567 00001855 A1[4100]                 mov ax, [OpPrintIndex]
  4568 00001858 83F800                   cmp ax, 0
  4569 0000185B 0F850C00                 jne .printLine206
  4570 0000185F 68[D318]                 push printLine_1
  4571 00001862 E8DA00                   call prs
  4572 00001865 83C402                   add  sp, 2
  4573                                  
  4574                                  ;-724     else {
  4575                                  
  4576 00001868 E94C00                   jmp .printLine207
  4577                                  .printLine206:
  4578                                  
  4579                                  ;-725 //        prc(' ');
  4580                                  
  4581                                  
  4582                                  ;-726         i=0;
  4583                                  
  4584 0000186B B80000                   mov ax, 0
  4585 0000186E 8946FE                   mov [bp-2], ax
  4586                                  
  4587                                  ;-727         do {
  4588                                  
  4589                                  .printLine208:
  4590                                  
  4591                                  ;-728             c=OpPos[i];
  4592                                  
  4593 00001871 8B5EFE                   mov bx, [bp-2]
  4594 00001874 8A875577                 mov al, [OpPos + bx]
  4595 00001878 8846FC                   mov [bp-4], al
  4596                                  
  4597                                  ;-729             prc(' ');
  4598                                  
  4599 0000187B 6A20                     push 32
  4600 0000187D E86700                   call prc
  4601 00001880 83C402                   add  sp, 2
  4602                                  
  4603                                  ;-730             printhex8a(c);
  4604                                  
  4605 00001883 8A46FC                   mov al, byte [bp-4]
  4606 00001886 B400                     mov ah, 0
  4607 00001888 50                       push ax
  4608 00001889 E84701                   call printhex8a
  4609 0000188C 83C402                   add  sp, 2
  4610                                  
  4611                                  ;-731             i++;
  4612                                  
  4613 0000188F FF46FE                   inc  word[bp-2]
  4614                                  
  4615                                  ;-732         } while (i < OpPrintIndex);
  4616                                  
  4617 00001892 8B46FE                   mov ax, [bp-2]
  4618 00001895 3B06[4100]               cmp ax, [OpPrintIndex]
  4619 00001899 0F8D0200                 jge .printLine209
  4620 0000189D EBD2                     jmp .printLine208
  4621                                  .printLine209:
  4622                                  
  4623                                  ;-733         while (i < OPMAXLEN) {// fill rest with blank
  4624                                  
  4625                                  .printLine210:
  4626 0000189F 8B46FE                   mov ax, [bp-2]
  4627 000018A2 83F805                   cmp ax, 5
  4628 000018A5 0F8D0E00                 jge .printLine211
  4629                                  
  4630                                  ;-734             prs("   ");
  4631                                  
  4632 000018A9 68[E318]                 push printLine_2
  4633 000018AC E89000                   call prs
  4634 000018AF 83C402                   add  sp, 2
  4635                                  
  4636                                  ;-735             i++;
  4637                                  
  4638 000018B2 FF46FE                   inc  word[bp-2]
  4639                                  
  4640                                  ;-736         }
  4641                                  
  4642                                  
  4643                                  ;-737     }
  4644                                  
  4645 000018B5 EBE8                     jmp .printLine210
  4646                                  .printLine211:
  4647                                  
  4648                                  ;-738     prc(PrintRA);
  4649                                  
  4650                                  .printLine207:
  4651 000018B7 A0[4500]                 mov al, byte [PrintRA]
  4652 000018BA B400                     mov ah, 0
  4653 000018BC 50                       push ax
  4654 000018BD E82700                   call prc
  4655 000018C0 83C402                   add  sp, 2
  4656                                  
  4657                                  ;-739     prscomment(InputBuf);
  4658                                  
  4659 000018C3 8D068D75                 lea  ax, [InputBuf]
  4660 000018C7 50                       push ax
  4661 000018C8 E84600                   call prscomment
  4662 000018CB 83C402                   add  sp, 2
  4663                                  
  4664                                  ;-740 }
  4665                                  
  4666                                  
  4667                                  ;-741 int prc(unsigned char c) {//print char
  4668 000018CE C9                       LEAVE
  4669 000018CF C3                       ret
  4670 000018D0 5C6E00                  printLine_0 db "\n",0
  4671 000018D3 202020202020202020-     printLine_1 db "               ",0
  4672 000018DC 20202020202000     
  4673 000018E3 20202000                printLine_2 db "   ",0
  4674                                  ENDP
  4675                                  
  4676                                  prc: PROC
  4677                                  
  4678                                  ;-742         if ( _ c==10) {
  4679                                  
  4680                                  ;Function : prc, Number of local variables: 1
  4681                                  ;   # type sign width addr used name   list of local variables
  4682                                  ;  200 var unsg byte   741 NULL c = bp+4;
  4683 000018E7 C8000000                 ENTER  0,0 ; constant expression
  4684 000018EB 807E040A                cmp byte[bp+4], 10
  4685 000018EF 0F850600                 jne .prc212
  4686                                  
  4687                                  ;-743             ax=13;
  4688                                  
  4689 000018F3 B80D00                   mov  ax, 13
  4690                                  
  4691                                  ;-744             writetty();
  4692                                  
  4693 000018F6 E87DF6                   call writetty
  4694                                  
  4695                                  ;-745             }
  4696                                  
  4697                                  
  4698                                  ;-746         al=c;
  4699                                  
  4700                                  .prc212:
  4701 000018F9 8A4604                   mov  al, [bp+4]
  4702                                  
  4703                                  ;-747         writetty();
  4704                                  
  4705 000018FC E877F6                   call writetty
  4706                                  
  4707                                  ;-748     fputcR(c,lst_fd);
  4708                                  
  4709 000018FF FF36[1800]               push word [lst_fd]
  4710 00001903 8A4604                   mov al, byte [bp+4]
  4711 00001906 B400                     mov ah, 0
  4712 00001908 50                       push ax
  4713 00001909 E815F7                   call fputcR
  4714 0000190C 83C404                   add  sp, 4
  4715                                  
  4716                                  ;-749 }
  4717                                  
  4718                                  
  4719                                  ;-750 
  4720                                  
  4721                                  
  4722                                  ;-751 int prscomment(unsigned char *s) {
  4723 0000190F C9                       LEAVE
  4724 00001910 C3                       ret
  4725                                  ENDP
  4726                                  
  4727                                  prscomment: PROC
  4728                                  
  4729                                  ;-752     unsigned char c;
  4730                                  
  4731                                  
  4732                                  ;-753     while (*s){
  4733                                  
  4734                                  ;Function : prscomment, Number of local variables: 2
  4735                                  ;   # type sign width addr used name   list of local variables
  4736                                  ;  200 ptr unsg byte   751 NULL s = bp+4
  4737                                  ;  201 var unsg byte   752 NULL c = bp-2;
  4738 00001911 C8020000                 ENTER  2,0
  4739                                  .prscomment213:
  4740 00001915 8B5E04                   mov bx, [bp+4]
  4741 00001918 8A07                     mov al, [bx]
  4742 0000191A B400                     mov ah, 0
  4743 0000191C 08C0                     or  al, al
  4744 0000191E 0F841B00                 je .prscomment214
  4745                                  
  4746                                  ;-754         c=*s;
  4747                                  
  4748 00001922 8B5E04                   mov bx, [bp+4]
  4749 00001925 8A07                     mov al, [bx]
  4750 00001927 B400                     mov ah, 0
  4751 00001929 8846FE                   mov [bp-2], al
  4752                                  
  4753                                  ;-755         prc(c);
  4754                                  
  4755 0000192C 8A46FE                   mov al, byte [bp-2]
  4756 0000192F B400                     mov ah, 0
  4757 00001931 50                       push ax
  4758 00001932 E8B2FF                   call prc
  4759 00001935 83C402                   add  sp, 2
  4760                                  
  4761                                  ;-756         s++;
  4762                                  
  4763 00001938 FF4604                   inc  word[bp+4]
  4764                                  
  4765                                  ;-757     }
  4766                                  
  4767                                  
  4768                                  ;-758 }
  4769                                  
  4770 0000193B EBD8                     jmp .prscomment213
  4771                                  .prscomment214:
  4772                                  
  4773                                  ;-759 int prs(unsigned char *s) {
  4774 0000193D C9                       LEAVE
  4775 0000193E C3                       ret
  4776                                  ENDP
  4777                                  
  4778                                  prs: PROC
  4779                                  
  4780                                  ;-760     unsigned char c;
  4781                                  
  4782                                  
  4783                                  ;-761     int com;
  4784                                  
  4785                                  
  4786                                  ;-762     com=0;
  4787                                  
  4788                                  ;Function : prs, Number of local variables: 3
  4789                                  ;   # type sign width addr used name   list of local variables
  4790                                  ;  200 ptr unsg byte   759 NULL s = bp+4
  4791                                  ;  201 var unsg byte   760 NULL c = bp-2
  4792                                  ;  202 var sign word   761 NULL com = bp-4;
  4793 0000193F C8040000                 ENTER  4,0
  4794 00001943 B80000                   mov ax, 0
  4795 00001946 8946FC                   mov [bp-4], ax
  4796                                  
  4797                                  ;-763     while (*s) {
  4798                                  
  4799                                  .prs215:
  4800 00001949 8B5E04                   mov bx, [bp+4]
  4801 0000194C 8A07                     mov al, [bx]
  4802 0000194E B400                     mov ah, 0
  4803 00001950 08C0                     or  al, al
  4804 00001952 0F847B00                 je .prs216
  4805                                  
  4806                                  ;-764         c=*s;
  4807                                  
  4808 00001956 8B5E04                   mov bx, [bp+4]
  4809 00001959 8A07                     mov al, [bx]
  4810 0000195B B400                     mov ah, 0
  4811 0000195D 8846FE                   mov [bp-2], al
  4812                                  
  4813                                  ;-765         if (c==34) {
  4814                                  
  4815 00001960 8A46FE                   mov al, [bp-2]
  4816 00001963 3C22                     cmp al, 34
  4817 00001965 0F851800                 jne .prs217
  4818                                  
  4819                                  ;-766             if (com) com=0;
  4820                                  
  4821 00001969 8B46FC                   mov ax, [bp-4]
  4822 0000196C 08C0                     or  al, al
  4823 0000196E 0F840900                 je .prs218
  4824 00001972 B80000                   mov ax, 0
  4825 00001975 8946FC                   mov [bp-4], ax
  4826                                  
  4827                                  ;-767                 else com=1;
  4828                                  
  4829 00001978 E90600                   jmp .prs219
  4830                                  .prs218:
  4831 0000197B B80100                   mov ax, 1
  4832 0000197E 8946FC                   mov [bp-4], ax
  4833                                  
  4834                                  ;-768         }
  4835                                  
  4836                                  .prs219:
  4837                                  
  4838                                  ;-769         if (c==92) {
  4839                                  
  4840                                  .prs217:
  4841 00001981 8A46FE                   mov al, [bp-2]
  4842 00001984 3C5C                     cmp al, 92
  4843 00001986 0F853500                 jne .prs220
  4844                                  
  4845                                  ;-770             if (com==0) {
  4846                                  
  4847 0000198A 8B46FC                   mov ax, [bp-4]
  4848 0000198D 83F800                   cmp ax, 0
  4849 00001990 0F852B00                 jne .prs221
  4850                                  
  4851                                  ;-771                 s++;
  4852                                  
  4853 00001994 FF4604                   inc  word[bp+4]
  4854                                  
  4855                                  ;-772                 c=*s;
  4856                                  
  4857 00001997 8B5E04                   mov bx, [bp+4]
  4858 0000199A 8A07                     mov al, [bx]
  4859 0000199C B400                     mov ah, 0
  4860 0000199E 8846FE                   mov [bp-2], al
  4861                                  
  4862                                  ;-773                 if (c=='n') c=10;
  4863                                  
  4864 000019A1 8A46FE                   mov al, [bp-2]
  4865 000019A4 3C6E                     cmp al, 110
  4866 000019A6 0F850600                 jne .prs222
  4867 000019AA B80A00                   mov ax, 10
  4868 000019AD 8846FE                   mov [bp-2], al
  4869                                  
  4870                                  ;-774                 if (c=='t') c= 9;
  4871                                  
  4872                                  .prs222:
  4873 000019B0 8A46FE                   mov al, [bp-2]
  4874 000019B3 3C74                     cmp al, 116
  4875 000019B5 0F850600                 jne .prs223
  4876 000019B9 B80900                   mov ax, 9
  4877 000019BC 8846FE                   mov [bp-2], al
  4878                                  
  4879                                  ;-775             }
  4880                                  
  4881                                  .prs223:
  4882                                  
  4883                                  ;-776         }
  4884                                  
  4885                                  .prs221:
  4886                                  
  4887                                  ;-777         prc(c);
  4888                                  
  4889                                  .prs220:
  4890 000019BF 8A46FE                   mov al, byte [bp-2]
  4891 000019C2 B400                     mov ah, 0
  4892 000019C4 50                       push ax
  4893 000019C5 E81FFF                   call prc
  4894 000019C8 83C402                   add  sp, 2
  4895                                  
  4896                                  ;-778         s++;
  4897                                  
  4898 000019CB FF4604                   inc  word[bp+4]
  4899                                  
  4900                                  ;-779     }
  4901                                  
  4902                                  
  4903                                  ;-780 }
  4904                                  
  4905 000019CE E978FF                   jmp .prs215
  4906                                  .prs216:
  4907                                  
  4908                                  ;-781 int printhex8a(unsigned char c) {
  4909 000019D1 C9                       LEAVE
  4910 000019D2 C3                       ret
  4911                                  ENDP
  4912                                  
  4913                                  printhex8a: PROC
  4914                                  
  4915                                  ;-782     unsigned char nib;
  4916                                  
  4917                                  
  4918                                  ;-783     nib = c >> 4; printhex4(nib);
  4919                                  
  4920                                  ;Function : printhex8a, Number of local variables: 2
  4921                                  ;   # type sign width addr used name   list of local variables
  4922                                  ;  200 var unsg byte   781 NULL c = bp+4
  4923                                  ;  201 var unsg byte   782 NULL nib = bp-2;
  4924 000019D3 C8020000                 ENTER  2,0
  4925 000019D7 8A4604                   mov al, [bp+4]
  4926 000019DA C0E804                   shr al, 4
  4927 000019DD 8846FE                   mov [bp-2], al
  4928 000019E0 8A46FE                   mov al, byte [bp-2]
  4929 000019E3 B400                     mov ah, 0
  4930 000019E5 50                       push ax
  4931 000019E6 E81900                   call printhex4
  4932 000019E9 83C402                   add  sp, 2
  4933                                  
  4934                                  ;-784     nib = c & 15; printhex4(nib);
  4935                                  
  4936 000019EC 8A4604                   mov al, [bp+4]
  4937 000019EF 240F                     and al, 15
  4938 000019F1 8846FE                   mov [bp-2], al
  4939 000019F4 8A46FE                   mov al, byte [bp-2]
  4940 000019F7 B400                     mov ah, 0
  4941 000019F9 50                       push ax
  4942 000019FA E80500                   call printhex4
  4943 000019FD 83C402                   add  sp, 2
  4944                                  
  4945                                  ;-785 }
  4946                                  
  4947                                  
  4948                                  ;-786 int printhex4(unsigned char c) {
  4949 00001A00 C9                       LEAVE
  4950 00001A01 C3                       ret
  4951                                  ENDP
  4952                                  
  4953                                  printhex4: PROC
  4954                                  
  4955                                  ;-787     c += 48;
  4956                                  
  4957                                  ;Function : printhex4, Number of local variables: 1
  4958                                  ;   # type sign width addr used name   list of local variables
  4959                                  ;  200 var unsg byte   786 NULL c = bp+4;
  4960 00001A02 C8000000                 ENTER  0,0
  4961 00001A06 80460430                 add  byte[bp+4], 48
  4962                                  
  4963                                  ;-788     if (c > 57) c += 7;
  4964                                  
  4965 00001A0A 8A4604                   mov al, [bp+4]
  4966 00001A0D 3C39                     cmp al, 57
  4967 00001A0F 0F8E0400                 jle .printhex4224
  4968 00001A13 80460407                 add  byte[bp+4], 7
  4969                                  
  4970                                  ;-789     prc(c);
  4971                                  
  4972                                  .printhex4224:
  4973 00001A17 8A4604                   mov al, byte [bp+4]
  4974 00001A1A B400                     mov ah, 0
  4975 00001A1C 50                       push ax
  4976 00001A1D E8C7FE                   call prc
  4977 00001A20 83C402                   add  sp, 2
  4978                                  
  4979                                  ;-790 }
  4980                                  
  4981                                  
  4982                                  ;-791 int printhex16(unsigned int i) {
  4983 00001A23 C9                       LEAVE
  4984 00001A24 C3                       ret
  4985                                  ENDP
  4986                                  
  4987                                  printhex16: PROC
  4988                                  
  4989                                  ;-792     unsigned int half;
  4990                                  
  4991                                  
  4992                                  ;-793     half = i >>  8; printhex8a(half);
  4993                                  
  4994                                  ;Function : printhex16, Number of local variables: 2
  4995                                  ;   # type sign width addr used name   list of local variables
  4996                                  ;  200 var unsg word   791 NULL i = bp+4
  4997                                  ;  201 var unsg word   792 NULL half = bp-2;
  4998 00001A25 C8020000                 ENTER  2,0
  4999 00001A29 8B4604                   mov ax, [bp+4]
  5000 00001A2C C1E808                   shr ax, 8
  5001 00001A2F 8946FE                   mov [bp-2], ax
  5002 00001A32 FF76FE                   push word [bp-2]
  5003 00001A35 E89BFF                   call printhex8a
  5004 00001A38 83C402                   add  sp, 2
  5005                                  
  5006                                  ;-794     half = i & 255; printhex8a(half);
  5007                                  
  5008 00001A3B 8B4604                   mov ax, [bp+4]
  5009 00001A3E 25FF00                   and ax, 255
  5010 00001A41 8946FE                   mov [bp-2], ax
  5011 00001A44 FF76FE                   push word [bp-2]
  5012 00001A47 E889FF                   call printhex8a
  5013 00001A4A 83C402                   add  sp, 2
  5014                                  
  5015                                  ;-795 }
  5016                                  
  5017                                  
  5018                                  ;-796 int printIntU(unsigned int n) {
  5019 00001A4D C9                       LEAVE
  5020 00001A4E C3                       ret
  5021                                  ENDP
  5022                                  
  5023                                  printIntU: PROC
  5024                                  
  5025                                  ;-797     unsigned int e;
  5026                                  
  5027                                  
  5028                                  ;-798     if ( _ n >= 10) {
  5029                                  
  5030                                  ;Function : printIntU, Number of local variables: 2
  5031                                  ;   # type sign width addr used name   list of local variables
  5032                                  ;  200 var unsg word   796 NULL n = bp+4
  5033                                  ;  201 var unsg word   797 NULL e = bp-2;
  5034 00001A4F C8020000                 ENTER  2,0 ; constant expression
  5035 00001A53 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5036 00001A57 0F821700                 jb  .printIntU225
  5037                                  
  5038                                  ;-799         e=n/10; //DIV
  5039                                  
  5040 00001A5B 8B4604                   mov ax, [bp+4]
  5041 00001A5E BB0A00                   mov bx, 10
  5042 00001A61 BA0000                   mov dx, 0
  5043 00001A64 F7F3                     div bx
  5044 00001A66 8946FE                   mov [bp-2], ax
  5045                                  
  5046                                  ;-800         printIntU(e);
  5047                                  
  5048 00001A69 FF76FE                   push word [bp-2]
  5049 00001A6C E8E0FF                   call printIntU
  5050 00001A6F 83C402                   add  sp, 2
  5051                                  
  5052                                  ;-801     }
  5053                                  
  5054                                  
  5055                                  ;-802     n = n % 10; //unsigned mod
  5056                                  
  5057                                  .printIntU225:
  5058 00001A72 8B4604                   mov ax, [bp+4]
  5059 00001A75 BB0A00                   mov bx, 10
  5060 00001A78 BA0000                   mov dx, 0
  5061 00001A7B F7F3                     div bx
  5062 00001A7D 89D0                     mov ax, dx
  5063 00001A7F 894604                   mov [bp+4], ax
  5064                                  
  5065                                  ;-803     n += '0';
  5066                                  
  5067 00001A82 83460430                 add  word[bp+4], 48
  5068                                  
  5069                                  ;-804     prc(n);
  5070                                  
  5071 00001A86 FF7604                   push word [bp+4]
  5072 00001A89 E85BFE                   call prc
  5073 00001A8C 83C402                   add  sp, 2
  5074                                  
  5075                                  ;-805 }
  5076                                  
  5077                                  
  5078                                  ;-806 
  5079                                  
  5080                                  
  5081                                  ;-807 int error1(char *s) {
  5082 00001A8F C9                       LEAVE
  5083 00001A90 C3                       ret
  5084                                  ENDP
  5085                                  
  5086                                  error1: PROC
  5087                                  
  5088                                  ;-808     ErrorCount++;
  5089                                  
  5090                                  ;Function : error1, Number of local variables: 1
  5091                                  ;   # type sign width addr used name   list of local variables
  5092                                  ;  200 ptr sign byte   807 NULL s = bp+4;
  5093 00001A91 C8000000                 ENTER  0,0
  5094 00001A95 FF06[1E00]               inc  word[ErrorCount]
  5095                                  
  5096                                  ;-809     prs("\n;***** next line ERROR: ");
  5097                                  
  5098 00001A99 68[C11A]                 push error1_0
  5099 00001A9C E8A0FE                   call prs
  5100 00001A9F 83C402                   add  sp, 2
  5101                                  
  5102                                  ;-810     prs(s);
  5103                                  
  5104 00001AA2 FF7604                   push word [bp+4]
  5105 00001AA5 E897FE                   call prs
  5106 00001AA8 83C402                   add  sp, 2
  5107                                  
  5108                                  ;-811     prs(", Symbol: ");
  5109                                  
  5110 00001AAB 68[DC1A]                 push error1_1
  5111 00001AAE E88EFE                   call prs
  5112 00001AB1 83C402                   add  sp, 2
  5113                                  
  5114                                  ;-812     prs(Symbol);
  5115                                  
  5116 00001AB4 8D063075                 lea  ax, [Symbol]
  5117 00001AB8 50                       push ax
  5118 00001AB9 E883FE                   call prs
  5119 00001ABC 83C402                   add  sp, 2
  5120                                  
  5121                                  ;-813 }
  5122                                  
  5123                                  
  5124                                  ;-814 int errorexit(char *s) {
  5125 00001ABF C9                       LEAVE
  5126 00001AC0 C3                       ret
  5127 00001AC1 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5128 00001ACA 6E657874206C696E65-
  5129 00001AD3 204552524F523A2000 
  5130 00001ADC 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5131 00001AE5 2000               
  5132                                  ENDP
  5133                                  
  5134                                  errorexit: PROC
  5135                                  
  5136                                  ;-815     error1(s);
  5137                                  
  5138                                  ;Function : errorexit, Number of local variables: 1
  5139                                  ;   # type sign width addr used name   list of local variables
  5140                                  ;  200 ptr sign byte   814 NULL s = bp+4;
  5141 00001AE7 C8000000                 ENTER  0,0
  5142 00001AEB FF7604                   push word [bp+4]
  5143 00001AEE E8A0FF                   call error1
  5144 00001AF1 83C402                   add  sp, 2
  5145                                  
  5146                                  ;-816     epilog();
  5147                                  
  5148 00001AF4 E81A05                   call epilog
  5149                                  
  5150                                  ;-817     end1(1);
  5151                                  
  5152 00001AF7 6A01                     push 1
  5153 00001AF9 E80D06                   call end1
  5154 00001AFC 83C402                   add  sp, 2
  5155                                  
  5156                                  ;-818 }
  5157                                  
  5158                                  
  5159                                  ;-819 int notfounderror(){error1("label not found"); }
  5160 00001AFF C9                       LEAVE
  5161 00001B00 C3                       ret
  5162                                  ENDP
  5163                                  
  5164                                  notfounderror: PROC
  5165 00001B01 68[0B1B]                 push notfounderror_0
  5166 00001B04 E88AFF                   call error1
  5167 00001B07 83C402                   add  sp, 2
  5168                                  
  5169                                  ;-820 int allowederror() {error1("not allowed here"); }
  5170                                  
  5171 00001B0A C3                       ret
  5172 00001B0B 6C6162656C206E6F74-     notfounderror_0 db "label not found",0
  5173 00001B14 20666F756E6400     
  5174                                  ENDP
  5175                                  
  5176                                  allowederror: PROC
  5177 00001B1B 68[251B]                 push allowederror_0
  5178 00001B1E E870FF                   call error1
  5179 00001B21 83C402                   add  sp, 2
  5180                                  
  5181                                  ;-821 int addrerror()    {error1("address missing");}
  5182                                  
  5183 00001B24 C3                       ret
  5184 00001B25 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5185 00001B2E 6564206865726500   
  5186                                  ENDP
  5187                                  
  5188                                  addrerror: PROC
  5189 00001B36 68[401B]                 push addrerror_0
  5190 00001B39 E855FF                   call error1
  5191 00001B3C 83C402                   add  sp, 2
  5192                                  
  5193                                  ;-822 int immeerror()    {error1("immediate not allowed here");}
  5194                                  
  5195 00001B3F C3                       ret
  5196 00001B40 61646472657373206D-     addrerror_0 db "address missing",0
  5197 00001B49 697373696E6700     
  5198                                  ENDP
  5199                                  
  5200                                  immeerror: PROC
  5201 00001B50 68[5A1B]                 push immeerror_0
  5202 00001B53 E83BFF                   call error1
  5203 00001B56 83C402                   add  sp, 2
  5204                                  
  5205                                  ;-823 int implerror()    {error1("not implemented");}
  5206                                  
  5207 00001B59 C3                       ret
  5208 00001B5A 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5209 00001B63 206E6F7420616C6C6F-
  5210 00001B6C 776564206865726500 
  5211                                  ENDP
  5212                                  
  5213                                  implerror: PROC
  5214 00001B75 68[7F1B]                 push implerror_0
  5215 00001B78 E816FF                   call error1
  5216 00001B7B 83C402                   add  sp, 2
  5217                                  
  5218                                  ;-824 int indexerror()   {error1("invalid index register");}
  5219                                  
  5220 00001B7E C3                       ret
  5221 00001B7F 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5222 00001B88 6D656E74656400     
  5223                                  ENDP
  5224                                  
  5225                                  indexerror: PROC
  5226 00001B8F 68[991B]                 push indexerror_0
  5227 00001B92 E8FCFE                   call error1
  5228 00001B95 83C402                   add  sp, 2
  5229                                  
  5230                                  ;-825 int invaloperror() {error1("invalid or no operands");}
  5231                                  
  5232 00001B98 C3                       ret
  5233 00001B99 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5234 00001BA2 6E6465782072656769-
  5235 00001BAB 7374657200         
  5236                                  ENDP
  5237                                  
  5238                                  invaloperror: PROC
  5239 00001BB0 68[BA1B]                 push invaloperror_0
  5240 00001BB3 E8DBFE                   call error1
  5241 00001BB6 83C402                   add  sp, 2
  5242                                  
  5243                                  ;-826 int numbererror()  {error1("number expected");}
  5244                                  
  5245 00001BB9 C3                       ret
  5246 00001BBA 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5247 00001BC3 72206E6F206F706572-
  5248 00001BCC 616E647300         
  5249                                  ENDP
  5250                                  
  5251                                  numbererror: PROC
  5252 00001BD1 68[DB1B]                 push numbererror_0
  5253 00001BD4 E8BAFE                   call error1
  5254 00001BD7 83C402                   add  sp, 2
  5255                                  
  5256                                  ;-827 int regmemerror()  {error1("only register or memory allowed");}
  5257                                  
  5258 00001BDA C3                       ret
  5259 00001BDB 6E756D626572206578-     numbererror_0 db "number expected",0
  5260 00001BE4 70656374656400     
  5261                                  ENDP
  5262                                  
  5263                                  regmemerror: PROC
  5264 00001BEB 68[F51B]                 push regmemerror_0
  5265 00001BEE E8A0FE                   call error1
  5266 00001BF1 83C402                   add  sp, 2
  5267                                  
  5268                                  ;-828 int reg16error()   {error1("only reg16, no segreg allowed");}
  5269                                  
  5270 00001BF4 C3                       ret
  5271 00001BF5 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5272 00001BFE 73746572206F72206D-
  5273 00001C07 656D6F727920616C6C-
  5274 00001C10 6F77656400         
  5275                                  ENDP
  5276                                  
  5277                                  reg16error: PROC
  5278 00001C15 68[1F1C]                 push reg16error_0
  5279 00001C18 E876FE                   call error1
  5280 00001C1B 83C402                   add  sp, 2
  5281                                  
  5282                                  ;-829 int segregerror()  {error1("segment register not allowed");}
  5283                                  
  5284 00001C1E C3                       ret
  5285 00001C1F 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5286 00001C28 362C206E6F20736567-
  5287 00001C31 72656720616C6C6F77-
  5288 00001C3A 656400             
  5289                                  ENDP
  5290                                  
  5291                                  segregerror: PROC
  5292 00001C3D 68[471C]                 push segregerror_0
  5293 00001C40 E84EFE                   call error1
  5294 00001C43 83C402                   add  sp, 2
  5295                                  
  5296                                  ;-830 int syntaxerror()  {error1("syntax");}
  5297                                  
  5298 00001C46 C3                       ret
  5299 00001C47 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5300 00001C50 65676973746572206E-
  5301 00001C59 6F7420616C6C6F7765-
  5302 00001C62 6400               
  5303                                  ENDP
  5304                                  
  5305                                  syntaxerror: PROC
  5306 00001C64 68[6E1C]                 push syntaxerror_0
  5307 00001C67 E827FE                   call error1
  5308 00001C6A 83C402                   add  sp, 2
  5309                                  
  5310                                  ;-831 
  5311                                  
  5312                                  
  5313                                  ;-832 int addrexit()     {errorexit("illegal address");}
  5314                                  
  5315 00001C6D C3                       ret
  5316 00001C6E 73796E74617800          syntaxerror_0 db "syntax",0
  5317                                  ENDP
  5318                                  
  5319                                  addrexit: PROC
  5320 00001C75 68[7F1C]                 push addrexit_0
  5321 00001C78 E86CFE                   call errorexit
  5322 00001C7B 83C402                   add  sp, 2
  5323                                  
  5324                                  ;-833 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5325                                  
  5326 00001C7E C3                       ret
  5327 00001C7F 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5328 00001C88 64647265737300     
  5329                                  ENDP
  5330                                  
  5331                                  dataexit: PROC
  5332 00001C8F 68[991C]                 push dataexit_0
  5333 00001C92 E852FE                   call errorexit
  5334 00001C95 83C402                   add  sp, 2
  5335                                  
  5336                                  ;-834 int internexit()   {errorexit("intern compiler error");}
  5337                                  
  5338 00001C98 C3                       ret
  5339 00001C99 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5340 00001CA2 6F7220524553422C57-
  5341 00001CAB 2C4420657870656374-
  5342 00001CB4 656400             
  5343                                  ENDP
  5344                                  
  5345                                  internexit: PROC
  5346 00001CB7 68[C11C]                 push internexit_0
  5347 00001CBA E82AFE                   call errorexit
  5348 00001CBD 83C402                   add  sp, 2
  5349                                  
  5350                                  ;-835 
  5351                                  
  5352                                  
  5353                                  ;-836 
  5354                                  
  5355                                  
  5356                                  ;-837 //#include "MAIN.C"
  5357                                  
  5358                                  
  5359                                  ;-838 int main() {
  5360                                  
  5361 00001CC0 C3                       ret
  5362 00001CC1 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5363 00001CCA 6D70696C6572206572-
  5364 00001CD3 726F7200           
  5365                                  ENDP
  5366                                  
  5367                                  main: PROC
  5368                                  
  5369                                  ;-839     getarg();
  5370                                  
  5371 00001CD7 E80D00                   call getarg
  5372                                  
  5373                                  ;-840     parse();
  5374                                  
  5375 00001CDA E8D2EC                   call parse
  5376                                  
  5377                                  ;-841     fixJmpCall();
  5378                                  
  5379 00001CDD E84A02                   call fixJmpCall
  5380                                  
  5381                                  ;-842     epilog();
  5382                                  
  5383 00001CE0 E82E03                   call epilog
  5384                                  
  5385                                  ;-843     end1();
  5386                                  
  5387 00001CE3 E82304                   call end1
  5388                                  
  5389                                  ;-844 }
  5390                                  
  5391                                  
  5392                                  ;-845 
  5393                                  
  5394                                  
  5395                                  ;-846 int getarg() {
  5396                                  
  5397 00001CE6 C3                       ret
  5398                                  ENDP
  5399                                  
  5400                                  getarg: PROC
  5401                                  
  5402                                  ;-847     int arglen1; int i; char *c;
  5403                                  
  5404                                  
  5405                                  ;-848     arglen1=*arglen;
  5406                                  
  5407                                  ;Function : getarg, Number of local variables: 3
  5408                                  ;   # type sign width addr used name   list of local variables
  5409                                  ;  200 var sign word   847 NULL arglen1 = bp-2
  5410                                  ;  201 var sign word   847 NULL i = bp-4
  5411                                  ;  202 ptr sign byte   847 NULL c = bp-6;
  5412 00001CE7 C8060000                 ENTER  6,0
  5413 00001CEB 8B1E[5A00]               mov bx, [arglen]
  5414 00001CEF 8A07                     mov al, [bx]
  5415 00001CF1 B400                     mov ah, 0
  5416 00001CF3 8946FE                   mov [bp-2], ax
  5417                                  
  5418                                  ;-849     if (arglen1==0) {
  5419                                  
  5420 00001CF6 8B46FE                   mov ax, [bp-2]
  5421 00001CF9 83F800                   cmp ax, 0
  5422 00001CFC 0F851C00                 jne .getarg226
  5423                                  
  5424                                  ;-850         cputs(Version1);
  5425                                  
  5426 00001D00 8D06[0300]               lea  ax, [Version1]
  5427 00001D04 50                       push ax
  5428 00001D05 E88FF2                   call cputs
  5429 00001D08 83C402                   add  sp, 2
  5430                                  
  5431                                  ;-851         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5432                                  
  5433 00001D0B 68[971E]                 push getarg_0
  5434 00001D0E E886F2                   call cputs
  5435 00001D11 83C402                   add  sp, 2
  5436                                  
  5437                                  ;-852         exitR(3);
  5438                                  
  5439 00001D14 6A03                     push 3
  5440 00001D16 E8E5F2                   call exitR
  5441 00001D19 83C402                   add  sp, 2
  5442                                  
  5443                                  ;-853     }
  5444                                  
  5445                                  
  5446                                  ;-854     i=arglen1+129;
  5447                                  
  5448                                  .getarg226:
  5449 00001D1C 8B46FE                   mov ax, [bp-2]
  5450 00001D1F 058100                   add ax, 129
  5451 00001D22 8946FC                   mov [bp-4], ax
  5452                                  
  5453                                  ;-855     *i=0;
  5454                                  
  5455 00001D25 B80000                   mov ax, 0
  5456 00001D28 8B5EFC                   mov  bx, [bp-4]
  5457 00001D2B 8907                     mov  [bx], ax
  5458                                  
  5459                                  ;-856     arglen1--;
  5460                                  
  5461 00001D2D FF4EFE                   dec  word[bp-2]
  5462                                  
  5463                                  ;-857     toupper(argv);
  5464                                  
  5465 00001D30 FF36[5C00]               push word [argv]
  5466 00001D34 E8FEF5                   call toupper
  5467 00001D37 83C402                   add  sp, 2
  5468                                  
  5469                                  ;-858 
  5470                                  
  5471                                  
  5472                                  ;-859     strcpy(namein, argv); strcat1(namein, ".S");
  5473                                  
  5474 00001D3A FF36[5C00]               push word [argv]
  5475 00001D3E 8D068C76                 lea  ax, [namein]
  5476 00001D42 50                       push ax
  5477 00001D43 E848F5                   call strcpy
  5478 00001D46 83C404                   add  sp, 4
  5479 00001D49 68[BC1E]                 push getarg_1
  5480 00001D4C 8D068C76                 lea  ax, [namein]
  5481 00001D50 50                       push ax
  5482 00001D51 E8BCF5                   call strcat1
  5483 00001D54 83C404                   add  sp, 4
  5484                                  
  5485                                  ;-860     strcpy(namelst,argv); strcat1(namelst,".LST");
  5486                                  
  5487 00001D57 FF36[5C00]               push word [argv]
  5488 00001D5B 8D06CF76                 lea  ax, [namelst]
  5489 00001D5F 50                       push ax
  5490 00001D60 E82BF5                   call strcpy
  5491 00001D63 83C404                   add  sp, 4
  5492 00001D66 68[BF1E]                 push getarg_2
  5493 00001D69 8D06CF76                 lea  ax, [namelst]
  5494 00001D6D 50                       push ax
  5495 00001D6E E89FF5                   call strcat1
  5496 00001D71 83C404                   add  sp, 4
  5497                                  
  5498                                  ;-861     strcpy(namebin,argv); strcat1(namebin,".COM");
  5499                                  
  5500 00001D74 FF36[5C00]               push word [argv]
  5501 00001D78 8D061277                 lea  ax, [namebin]
  5502 00001D7C 50                       push ax
  5503 00001D7D E80EF5                   call strcpy
  5504 00001D80 83C404                   add  sp, 4
  5505 00001D83 68[C41E]                 push getarg_3
  5506 00001D86 8D061277                 lea  ax, [namebin]
  5507 00001D8A 50                       push ax
  5508 00001D8B E882F5                   call strcat1
  5509 00001D8E 83C404                   add  sp, 4
  5510                                  
  5511                                  ;-862 
  5512                                  
  5513                                  
  5514                                  ;-863   DOS_ERR=0; PC=0; ErrorCount=0;
  5515                                  
  5516 00001D91 B80000                   mov ax, 0
  5517 00001D94 A3[1C00]                 mov word [DOS_ERR], ax
  5518 00001D97 B80000                   mov ax, 0
  5519 00001D9A A3[2300]                 mov word [PC], ax
  5520 00001D9D B80000                   mov ax, 0
  5521 00001DA0 A3[1E00]                 mov word [ErrorCount], ax
  5522                                  
  5523                                  ;-864 
  5524                                  
  5525                                  
  5526                                  ;-865     asm_fd=openR (namein);
  5527                                  
  5528 00001DA3 8D068C76                 lea  ax, [namein]
  5529 00001DA7 50                       push ax
  5530 00001DA8 E823F2                   call openR
  5531 00001DAB 83C402                   add  sp, 2
  5532 00001DAE A3[1600]                 mov word [asm_fd], ax
  5533                                  
  5534                                  ;-866     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5535                                  
  5536 00001DB1 A1[1C00]                 mov ax, [DOS_ERR]
  5537 00001DB4 08C0                     or  al, al
  5538 00001DB6 0F841C00                 je .getarg227
  5539 00001DBA 68[C91E]                 push getarg_4
  5540 00001DBD E8D7F1                   call cputs
  5541 00001DC0 83C402                   add  sp, 2
  5542 00001DC3 8D068C76                 lea  ax, [namein]
  5543 00001DC7 50                       push ax
  5544 00001DC8 E8CCF1                   call cputs
  5545 00001DCB 83C402                   add  sp, 2
  5546 00001DCE 6A01                     push 1
  5547 00001DD0 E82BF2                   call exitR
  5548 00001DD3 83C402                   add  sp, 2
  5549                                  
  5550                                  ;-867     lst_fd=creatR(namelst);
  5551                                  
  5552                                  .getarg227:
  5553 00001DD6 8D06CF76                 lea  ax, [namelst]
  5554 00001DDA 50                       push ax
  5555 00001DDB E8FFF1                   call creatR
  5556 00001DDE 83C402                   add  sp, 2
  5557 00001DE1 A3[1800]                 mov word [lst_fd], ax
  5558                                  
  5559                                  ;-868     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5560                                  
  5561 00001DE4 A1[1C00]                 mov ax, [DOS_ERR]
  5562 00001DE7 08C0                     or  al, al
  5563 00001DE9 0F841C00                 je .getarg228
  5564 00001DED 68[DF1E]                 push getarg_5
  5565 00001DF0 E8A4F1                   call cputs
  5566 00001DF3 83C402                   add  sp, 2
  5567 00001DF6 8D06CF76                 lea  ax, [namelst]
  5568 00001DFA 50                       push ax
  5569 00001DFB E899F1                   call cputs
  5570 00001DFE 83C402                   add  sp, 2
  5571 00001E01 6A02                     push 2
  5572 00001E03 E8F8F1                   call exitR
  5573 00001E06 83C402                   add  sp, 2
  5574                                  
  5575                                  ;-869     bin_fd=creatR(namebin);
  5576                                  
  5577                                  .getarg228:
  5578 00001E09 8D061277                 lea  ax, [namebin]
  5579 00001E0D 50                       push ax
  5580 00001E0E E8CCF1                   call creatR
  5581 00001E11 83C402                   add  sp, 2
  5582 00001E14 A3[1A00]                 mov word [bin_fd], ax
  5583                                  
  5584                                  ;-870     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5585                                  
  5586 00001E17 A1[1C00]                 mov ax, [DOS_ERR]
  5587 00001E1A 08C0                     or  al, al
  5588 00001E1C 0F841C00                 je .getarg229
  5589 00001E20 68[F61E]                 push getarg_6
  5590 00001E23 E871F1                   call cputs
  5591 00001E26 83C402                   add  sp, 2
  5592 00001E29 8D061277                 lea  ax, [namebin]
  5593 00001E2D 50                       push ax
  5594 00001E2E E866F1                   call cputs
  5595 00001E31 83C402                   add  sp, 2
  5596 00001E34 6A02                     push 2
  5597 00001E36 E8C5F1                   call exitR
  5598 00001E39 83C402                   add  sp, 2
  5599                                  
  5600                                  ;-871 
  5601                                  
  5602                                  
  5603                                  ;-872     prs(";");
  5604                                  
  5605                                  .getarg229:
  5606 00001E3C 68[0C1F]                 push getarg_7
  5607 00001E3F E8FDFA                   call prs
  5608 00001E42 83C402                   add  sp, 2
  5609                                  
  5610                                  ;-873     prs(Version1);
  5611                                  
  5612 00001E45 8D06[0300]               lea  ax, [Version1]
  5613 00001E49 50                       push ax
  5614 00001E4A E8F2FA                   call prs
  5615 00001E4D 83C402                   add  sp, 2
  5616                                  
  5617                                  ;-874     prs(", Source: "); prs(namein);
  5618                                  
  5619 00001E50 68[0E1F]                 push getarg_8
  5620 00001E53 E8E9FA                   call prs
  5621 00001E56 83C402                   add  sp, 2
  5622 00001E59 8D068C76                 lea  ax, [namein]
  5623 00001E5D 50                       push ax
  5624 00001E5E E8DEFA                   call prs
  5625 00001E61 83C402                   add  sp, 2
  5626                                  
  5627                                  ;-875     prs(", Output: "); prs(namelst);
  5628                                  
  5629 00001E64 68[191F]                 push getarg_9
  5630 00001E67 E8D5FA                   call prs
  5631 00001E6A 83C402                   add  sp, 2
  5632 00001E6D 8D06CF76                 lea  ax, [namelst]
  5633 00001E71 50                       push ax
  5634 00001E72 E8CAFA                   call prs
  5635 00001E75 83C402                   add  sp, 2
  5636                                  
  5637                                  ;-876     prs(", "); prs(namebin);
  5638                                  
  5639 00001E78 68[241F]                 push getarg_10
  5640 00001E7B E8C1FA                   call prs
  5641 00001E7E 83C402                   add  sp, 2
  5642 00001E81 8D061277                 lea  ax, [namebin]
  5643 00001E85 50                       push ax
  5644 00001E86 E8B6FA                   call prs
  5645 00001E89 83C402                   add  sp, 2
  5646                                  
  5647                                  ;-877     prs("\n");
  5648                                  
  5649 00001E8C 68[271F]                 push getarg_11
  5650 00001E8F E8ADFA                   call prs
  5651 00001E92 83C402                   add  sp, 2
  5652                                  
  5653                                  ;-878 }
  5654                                  
  5655                                  
  5656                                  ;-879 
  5657                                  
  5658                                  
  5659                                  ;-880 int fixJmpCall() {
  5660 00001E95 C9                       LEAVE
  5661 00001E96 C3                       ret
  5662 00001E97 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5663 00001EA0 41532E434F4D206669-
  5664 00001EA9 6C656E616D65205B77-
  5665 00001EB2 2F6F202E535D203A20-
  5666 00001EBB 00                 
  5667 00001EBC 2E5300                  getarg_1 db ".S",0
  5668 00001EBF 2E4C535400              getarg_2 db ".LST",0
  5669 00001EC4 2E434F4D00              getarg_3 db ".COM",0
  5670 00001EC9 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5671 00001ED2 6C65206D697373696E-
  5672 00001EDB 673A2000           
  5673 00001EDF 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5674 00001EE8 206E6F742063726561-
  5675 00001EF1 74653A2000         
  5676 00001EF6 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5677 00001EFF 6E6F74206372656174-
  5678 00001F08 653A2000           
  5679 00001F0C 3B00                    getarg_7 db ";",0
  5680 00001F0E 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5681 00001F17 2000               
  5682 00001F19 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5683 00001F22 2000               
  5684 00001F24 2C2000                  getarg_10 db ", ",0
  5685 00001F27 5C6E00                  getarg_11 db "\n",0
  5686                                  ENDP
  5687                                  
  5688                                  fixJmpCall: PROC
  5689                                  
  5690                                  ;-881     int i;  unsigned int hex;  char *p; int Ix; char c;
  5691                                  
  5692                                  
  5693                                  ;-882     i=1;
  5694                                  
  5695                                  ;Function : fixJmpCall, Number of local variables: 5
  5696                                  ;   # type sign width addr used name   list of local variables
  5697                                  ;  200 var sign word   881 NULL i = bp-2
  5698                                  ;  201 var unsg word   881 NULL hex = bp-4
  5699                                  ;  202 ptr sign byte   881 NULL p = bp-6
  5700                                  ;  203 var sign word   881 NULL Ix = bp-8
  5701                                  ;  204 var sign byte   881 NULL c = bp-10;
  5702 00001F2A C80A0000                 ENTER  10,0
  5703 00001F2E B80100                   mov ax, 1
  5704 00001F31 8946FE                   mov [bp-2], ax
  5705                                  
  5706                                  ;-883     prs("\n;END open jmp: ");
  5707                                  
  5708 00001F34 68[EF1F]                 push fixJmpCall_0
  5709 00001F37 E805FA                   call prs
  5710 00001F3A 83C402                   add  sp, 2
  5711                                  
  5712                                  ;-884     printIntU(JmpMaxIx);
  5713                                  
  5714 00001F3D FF36[5400]               push word [JmpMaxIx]
  5715 00001F41 E80BFB                   call printIntU
  5716 00001F44 83C402                   add  sp, 2
  5717                                  
  5718                                  ;-885     p = &JmpNames;
  5719                                  
  5720 00001F47 B87A93                   mov ax, JmpNames
  5721 00001F4A 8946FA                   mov [bp-6], ax
  5722                                  
  5723                                  ;-886     while (i <= JmpMaxIx) {
  5724                                  
  5725                                  .fixJmpCall230:
  5726 00001F4D 8B46FE                   mov ax, [bp-2]
  5727 00001F50 3B06[5400]               cmp ax, [JmpMaxIx]
  5728 00001F54 0F8F9500                 jg  .fixJmpCall231
  5729                                  
  5730                                  ;-887         strcpy(Symbol, p);
  5731                                  
  5732 00001F58 FF76FA                   push word [bp-6]
  5733 00001F5B 8D063075                 lea  ax, [Symbol]
  5734 00001F5F 50                       push ax
  5735 00001F60 E82BF3                   call strcpy
  5736 00001F63 83C404                   add  sp, 4
  5737                                  
  5738                                  ;-888         p = strlen(Symbol) + p;
  5739                                  
  5740 00001F66 8D063075                 lea  ax, [Symbol]
  5741 00001F6A 50                       push ax
  5742 00001F6B E8F8F2                   call strlen
  5743 00001F6E 83C402                   add  sp, 2
  5744 00001F71 0346FA                   add ax, [bp-6]
  5745 00001F74 8946FA                   mov [bp-6], ax
  5746                                  
  5747                                  ;-889         p++;
  5748                                  
  5749 00001F77 FF46FA                   inc  word[bp-6]
  5750                                  
  5751                                  ;-890 //        prs(Symbol);
  5752                                  
  5753                                  
  5754                                  ;-891 //        prc(' ');
  5755                                  
  5756                                  
  5757                                  ;-892         hex = JmpAddr[i];
  5758                                  
  5759 00001F7A 8B5EFE                   mov bx, [bp-2]
  5760 00001F7D D1E3                     shl bx, 1
  5761 00001F7F 8B871AA3                 mov ax, [JmpAddr + bx]
  5762 00001F83 8946FC                   mov [bp-4], ax
  5763                                  
  5764                                  ;-893 //        printhex16(hex);
  5765                                  
  5766                                  
  5767                                  ;-894 
  5768                                  
  5769                                  
  5770                                  ;-895         Ix=searchLabel();
  5771                                  
  5772 00001F86 E8F9EC                   call searchLabel
  5773 00001F89 8946F8                   mov [bp-8], ax
  5774                                  
  5775                                  ;-896         if (Ix == 0) error1("Label not found");
  5776                                  
  5777 00001F8C 8B46F8                   mov ax, [bp-8]
  5778 00001F8F 83F800                   cmp ax, 0
  5779 00001F92 0F850900                 jne .fixJmpCall232
  5780 00001F96 68[0120]                 push fixJmpCall_1
  5781 00001F99 E8F5FA                   call error1
  5782 00001F9C 83C402                   add  sp, 2
  5783                                  
  5784                                  ;-897         disp = LabelAddr[Ix];
  5785                                  
  5786                                  .fixJmpCall232:
  5787 00001F9F 8B5EF8                   mov bx, [bp-8]
  5788 00001FA2 D1E3                     shl bx, 1
  5789 00001FA4 8B87CA8E                 mov ax, [LabelAddr + bx]
  5790 00001FA8 A3[3D00]                 mov word [disp], ax
  5791                                  
  5792                                  ;-898         disp = disp - hex;
  5793                                  
  5794 00001FAB A1[3D00]                 mov ax, [disp]
  5795 00001FAE 2B46FC                   sub ax, [bp-4]
  5796 00001FB1 A3[3D00]                 mov word [disp], ax
  5797                                  
  5798                                  ;-899         disp = disp - Origin;
  5799                                  
  5800 00001FB4 A1[3D00]                 mov ax, [disp]
  5801 00001FB7 2B06[2500]               sub ax, [Origin]
  5802 00001FBB A3[3D00]                 mov word [disp], ax
  5803                                  
  5804                                  ;-900 //        prs(", ");
  5805                                  
  5806                                  
  5807                                  ;-901 
  5808                                  
  5809                                  
  5810                                  ;-902             hex = hex - 2;//fix at start of word
  5811                                  
  5812 00001FBE 8B46FC                   mov ax, [bp-4]
  5813 00001FC1 83E802                   sub ax, 2
  5814 00001FC4 8946FC                   mov [bp-4], ax
  5815                                  
  5816                                  ;-903             FileBin[hex] = disp;//fix low byte
  5817                                  
  5818 00001FC7 A1[3D00]                 mov ax, [disp]
  5819 00001FCA 8B5EFC                   mov bx, [bp-4]
  5820 00001FCD 8887AAA4                 mov [FileBin+bx], al
  5821                                  
  5822                                  ;-904             hex++;
  5823                                  
  5824 00001FD1 FF46FC                   inc  word[bp-4]
  5825                                  
  5826                                  ;-905             disp = disp >> 8;
  5827                                  
  5828 00001FD4 A1[3D00]                 mov ax, [disp]
  5829 00001FD7 C1E808                   shr ax, 8
  5830 00001FDA A3[3D00]                 mov word [disp], ax
  5831                                  
  5832                                  ;-906             FileBin[hex] = disp;
  5833                                  
  5834 00001FDD A1[3D00]                 mov ax, [disp]
  5835 00001FE0 8B5EFC                   mov bx, [bp-4]
  5836 00001FE3 8887AAA4                 mov [FileBin+bx], al
  5837                                  
  5838                                  ;-907         i++;
  5839                                  
  5840 00001FE7 FF46FE                   inc  word[bp-2]
  5841                                  
  5842                                  ;-908     }
  5843                                  
  5844                                  
  5845                                  ;-909 }
  5846                                  
  5847 00001FEA E960FF                   jmp .fixJmpCall230
  5848                                  .fixJmpCall231:
  5849                                  
  5850                                  ;-910 
  5851                                  
  5852                                  
  5853                                  ;-911 int epilog() {
  5854 00001FED C9                       LEAVE
  5855 00001FEE C3                       ret
  5856 00001FEF 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp: ",0
  5857 00001FF8 656E206A6D703A2000 
  5858 00002001 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5859 0000200A 20666F756E6400     
  5860                                  ENDP
  5861                                  
  5862                                  epilog: PROC
  5863                                  
  5864                                  ;-912     unsigned int i; char c;     int j;
  5865                                  
  5866                                  
  5867                                  ;-913     prs("\n Errors: ");
  5868                                  
  5869                                  ;Function : epilog, Number of local variables: 3
  5870                                  ;   # type sign width addr used name   list of local variables
  5871                                  ;  200 var unsg word   912 NULL i = bp-2
  5872                                  ;  201 var sign byte   912 NULL c = bp-4
  5873                                  ;  202 var sign word   912 NULL j = bp-6;
  5874 00002011 C8060000                 ENTER  6,0
  5875 00002015 68[CC20]                 push epilog_0
  5876 00002018 E824F9                   call prs
  5877 0000201B 83C402                   add  sp, 2
  5878                                  
  5879                                  ;-914     printIntU(ErrorCount);
  5880                                  
  5881 0000201E FF36[1E00]               push word [ErrorCount]
  5882 00002022 E82AFA                   call printIntU
  5883 00002025 83C402                   add  sp, 2
  5884                                  
  5885                                  ;-915     if (ErrorCount) prs(" ***ERROR*** ");
  5886                                  
  5887 00002028 A1[1E00]                 mov ax, [ErrorCount]
  5888 0000202B 08C0                     or  al, al
  5889 0000202D 0F840900                 je .epilog233
  5890 00002031 68[D820]                 push epilog_1
  5891 00002034 E808F9                   call prs
  5892 00002037 83C402                   add  sp, 2
  5893                                  
  5894                                  ;-916     prs(", Out: ");
  5895                                  
  5896                                  .epilog233:
  5897 0000203A 68[E620]                 push epilog_2
  5898 0000203D E8FFF8                   call prs
  5899 00002040 83C402                   add  sp, 2
  5900                                  
  5901                                  ;-917     prs(namelst);
  5902                                  
  5903 00002043 8D06CF76                 lea  ax, [namelst]
  5904 00002047 50                       push ax
  5905 00002048 E8F4F8                   call prs
  5906 0000204B 83C402                   add  sp, 2
  5907                                  
  5908                                  ;-918     prs(", ");
  5909                                  
  5910 0000204E 68[EE20]                 push epilog_3
  5911 00002051 E8EBF8                   call prs
  5912 00002054 83C402                   add  sp, 2
  5913                                  
  5914                                  ;-919     prs(namebin);
  5915                                  
  5916 00002057 8D061277                 lea  ax, [namebin]
  5917 0000205B 50                       push ax
  5918 0000205C E8E0F8                   call prs
  5919 0000205F 83C402                   add  sp, 2
  5920                                  
  5921                                  ;-920     prs("= ");
  5922                                  
  5923 00002062 68[F120]                 push epilog_4
  5924 00002065 E8D7F8                   call prs
  5925 00002068 83C402                   add  sp, 2
  5926                                  
  5927                                  ;-921     printIntU(BinLen);
  5928                                  
  5929 0000206B FF36[5800]               push word [BinLen]
  5930 0000206F E8DDF9                   call printIntU
  5931 00002072 83C402                   add  sp, 2
  5932                                  
  5933                                  ;-922     prs(" bytes.");
  5934                                  
  5935 00002075 68[F420]                 push epilog_5
  5936 00002078 E8C4F8                   call prs
  5937 0000207B 83C402                   add  sp, 2
  5938                                  
  5939                                  ;-923 
  5940                                  
  5941                                  
  5942                                  ;-924     i=0;
  5943                                  
  5944 0000207E B80000                   mov ax, 0
  5945 00002081 8946FE                   mov [bp-2], ax
  5946                                  
  5947                                  ;-925     do {
  5948                                  
  5949                                  .epilog234:
  5950                                  
  5951                                  ;-926         c = FileBin[i];
  5952                                  
  5953 00002084 8B5EFE                   mov bx, [bp-2]
  5954 00002087 8A87AAA4                 mov al, [FileBin + bx]
  5955 0000208B 8846FC                   mov [bp-4], al
  5956                                  
  5957                                  ;-927         fputcR(c, bin_fd);
  5958                                  
  5959 0000208E FF36[1A00]               push word [bin_fd]
  5960 00002092 8A46FC                   mov al, byte [bp-4]
  5961 00002095 B400                     mov ah, 0
  5962 00002097 50                       push ax
  5963 00002098 E886EF                   call fputcR
  5964 0000209B 83C404                   add  sp, 4
  5965                                  
  5966                                  ;-928 //printhex8a(c); prc(' ');
  5967                                  
  5968                                  
  5969                                  ;-929         i++;
  5970                                  
  5971 0000209E FF46FE                   inc  word[bp-2]
  5972                                  
  5973                                  ;-930     } while (i < BinLen);
  5974                                  
  5975 000020A1 8B46FE                   mov ax, [bp-2]
  5976 000020A4 3B06[5800]               cmp ax, [BinLen]
  5977 000020A8 0F8D0200                 jge .epilog235
  5978 000020AC EBD6                     jmp .epilog234
  5979                                  .epilog235:
  5980                                  
  5981                                  ;-931 
  5982                                  
  5983                                  
  5984                                  ;-932   prs(" Labels: ");
  5985                                  
  5986 000020AE 68[FC20]                 push epilog_6
  5987 000020B1 E88BF8                   call prs
  5988 000020B4 83C402                   add  sp, 2
  5989                                  
  5990                                  ;-933   printIntU(LabelMaxIx);
  5991                                  
  5992 000020B7 FF36[4A00]               push word [LabelMaxIx]
  5993 000020BB E891F9                   call printIntU
  5994 000020BE 83C402                   add  sp, 2
  5995                                  
  5996                                  ;-934   prs(". ");
  5997                                  
  5998 000020C1 68[0621]                 push epilog_7
  5999 000020C4 E878F8                   call prs
  6000 000020C7 83C402                   add  sp, 2
  6001                                  
  6002                                  ;-935 /*
  6003                                  
  6004                                  
  6005                                  ;-936   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  6006                                  
  6007                                  
  6008                                  ;-937   i= &LabelNames;
  6009                                  
  6010                                  
  6011                                  ;-938   prs(" &LabelNames:"); printIntU(i);
  6012                                  
  6013                                  
  6014                                  ;-939   i=LabelNamePtr-i;
  6015                                  
  6016                                  
  6017                                  ;-940   prs("size: ");
  6018                                  
  6019                                  
  6020                                  ;-941   printIntU(i);
  6021                                  
  6022                                  
  6023                                  ;-942   prs(". >>");
  6024                                  
  6025                                  
  6026                                  ;-943   i= &LabelNames;
  6027                                  
  6028                                  
  6029                                  ;-944   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6030                                  
  6031                                  
  6032                                  ;-945   } while (i < LabelNamePtr); prs("<< \n");
  6033                                  
  6034                                  
  6035                                  ;-946    i = 1;
  6036                                  
  6037                                  
  6038                                  ;-947     LabelNamePtr= &LabelNames;
  6039                                  
  6040                                  
  6041                                  ;-948     do {
  6042                                  
  6043                                  
  6044                                  ;-949       prs(LabelNamePtr); prc(' ');
  6045                                  
  6046                                  
  6047                                  ;-950       j=LabelAddr[i]; printhex16(j); prs(", ");
  6048                                  
  6049                                  
  6050                                  ;-951       j=strlen(LabelNamePtr);//get end of actual name
  6051                                  
  6052                                  
  6053                                  ;-952       LabelNamePtr=LabelNamePtr+j;
  6054                                  
  6055                                  
  6056                                  ;-953       LabelNamePtr++;
  6057                                  
  6058                                  
  6059                                  ;-954       i++;
  6060                                  
  6061                                  
  6062                                  ;-955     } while (i <= LabelMaxIx);
  6063                                  
  6064                                  
  6065                                  ;-956 */
  6066                                  
  6067                                  
  6068                                  ;-957 }
  6069                                  
  6070                                  
  6071                                  ;-958 
  6072                                  
  6073                                  
  6074                                  ;-959 int end1(int n) {
  6075 000020CA C9                       LEAVE
  6076 000020CB C3                       ret
  6077 000020CC 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6078 000020D5 3A2000             
  6079 000020D8 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6080 000020E1 2A2A2A2000         
  6081 000020E6 2C204F75743A2000        epilog_2 db ", Out: ",0
  6082 000020EE 2C2000                  epilog_3 db ", ",0
  6083 000020F1 3D2000                  epilog_4 db "= ",0
  6084 000020F4 2062797465732E00        epilog_5 db " bytes.",0
  6085 000020FC 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6086 00002105 00                 
  6087 00002106 2E2000                  epilog_7 db ". ",0
  6088                                  ENDP
  6089                                  
  6090                                  end1: PROC
  6091                                  
  6092                                  ;-960     fcloseR(asm_fd);
  6093                                  
  6094                                  ;Function : end1, Number of local variables: 1
  6095                                  ;   # type sign width addr used name   list of local variables
  6096                                  ;  200 var sign word   959 NULL n = bp+4;
  6097 00002109 C8000000                 ENTER  0,0
  6098 0000210D FF36[1600]               push word [asm_fd]
  6099 00002111 E8DBEE                   call fcloseR
  6100 00002114 83C402                   add  sp, 2
  6101                                  
  6102                                  ;-961     fcloseR(lst_fd);
  6103                                  
  6104 00002117 FF36[1800]               push word [lst_fd]
  6105 0000211B E8D1EE                   call fcloseR
  6106 0000211E 83C402                   add  sp, 2
  6107                                  
  6108                                  ;-962     fcloseR(bin_fd);
  6109                                  
  6110 00002121 FF36[1A00]               push word [bin_fd]
  6111 00002125 E8C7EE                   call fcloseR
  6112 00002128 83C402                   add  sp, 2
  6113                                  
  6114                                  ;-963     exitR(n);
  6115                                  
  6116 0000212B FF7604                   push word [bp+4]
  6117 0000212E E8CDEE                   call exitR
  6118 00002131 83C402                   add  sp, 2
  6119                                  
  6120                                  ;-964 }
  6121                                  
  6122                                  
  6123                                  ;-965 
  6124                                  
  6125                                  
  6126                                  ;-966 
  6127                                  
  6128                                  
  6129                                  ;-967 //#include "GENCODE.C"
  6130                                  
  6131                                  
  6132                                  ;-968 // generate code
  6133                                  
  6134                                  
  6135                                  ;-969 int getCodes() {
  6136 00002134 C9                       LEAVE
  6137 00002135 C3                       ret
  6138                                  ENDP
  6139                                  
  6140                                  getCodes: PROC
  6141                                  
  6142                                  ;-970     OpCodePtr ++; Code1 = *OpCodePtr;
  6143                                  
  6144 00002136 FF06[4300]               inc  word[OpCodePtr]
  6145 0000213A 8B1E[4300]               mov bx, [OpCodePtr]
  6146 0000213E 8A07                     mov al, [bx]
  6147 00002140 B400                     mov ah, 0
  6148 00002142 A2[3000]                 mov byte [Code1], al
  6149                                  
  6150                                  ;-971     OpCodePtr ++; Code2 = *OpCodePtr;
  6151                                  
  6152 00002145 FF06[4300]               inc  word[OpCodePtr]
  6153 00002149 8B1E[4300]               mov bx, [OpCodePtr]
  6154 0000214D 8A07                     mov al, [bx]
  6155 0000214F B400                     mov ah, 0
  6156 00002151 A2[3100]                 mov byte [Code2], al
  6157                                  
  6158                                  ;-972     OpCodePtr ++; Code3 = *OpCodePtr;
  6159                                  
  6160 00002154 FF06[4300]               inc  word[OpCodePtr]
  6161 00002158 8B1E[4300]               mov bx, [OpCodePtr]
  6162 0000215C 8A07                     mov al, [bx]
  6163 0000215E B400                     mov ah, 0
  6164 00002160 A2[3200]                 mov byte [Code3], al
  6165                                  
  6166                                  ;-973 }
  6167                                  
  6168                                  
  6169                                  ;-974 int gen66h() {genCode8(0x66);
  6170                                  
  6171 00002163 C3                       ret
  6172                                  ENDP
  6173                                  
  6174                                  gen66h: PROC
  6175 00002164 6A66                     push 102
  6176 00002166 E83B00                   call genCode8
  6177 00002169 83C402                   add  sp, 2
  6178                                  
  6179                                  ;-975 }
  6180                                  
  6181                                  
  6182                                  ;-976 int genCode2(char c, char d) {
  6183                                  
  6184 0000216C C3                       ret
  6185                                  ENDP
  6186                                  
  6187                                  genCode2: PROC
  6188                                  
  6189                                  ;-977     c = c + d;
  6190                                  
  6191                                  ;Function : genCode2, Number of local variables: 2
  6192                                  ;   # type sign width addr used name   list of local variables
  6193                                  ;  200 var sign byte   976 NULL c = bp+4
  6194                                  ;  201 var sign byte   976 NULL d = bp+6;
  6195 0000216D C8000000                 ENTER  0,0
  6196 00002171 8A4604                   mov al, [bp+4]
  6197 00002174 024606                   add al, [bp+6]
  6198 00002177 884604                   mov [bp+4], al
  6199                                  
  6200                                  ;-978     genCode8(c);
  6201                                  
  6202 0000217A 8A4604                   mov al, byte [bp+4]
  6203 0000217D B400                     mov ah, 0
  6204 0000217F 50                       push ax
  6205 00002180 E82100                   call genCode8
  6206 00002183 83C402                   add  sp, 2
  6207                                  
  6208                                  ;-979 }
  6209                                  
  6210                                  
  6211                                  ;-980 int genCodeW(char c) {
  6212 00002186 C9                       LEAVE
  6213 00002187 C3                       ret
  6214                                  ENDP
  6215                                  
  6216                                  genCodeW: PROC
  6217                                  
  6218                                  ;-981     c = c + wflag;
  6219                                  
  6220                                  ;Function : genCodeW, Number of local variables: 1
  6221                                  ;   # type sign width addr used name   list of local variables
  6222                                  ;  200 var sign byte   980 NULL c = bp+4;
  6223 00002188 C8000000                 ENTER  0,0
  6224 0000218C 8A4604                   mov al, [bp+4]
  6225 0000218F 0206[3800]               add al, [wflag]
  6226 00002193 884604                   mov [bp+4], al
  6227                                  
  6228                                  ;-982     genCode8(c);
  6229                                  
  6230 00002196 8A4604                   mov al, byte [bp+4]
  6231 00002199 B400                     mov ah, 0
  6232 0000219B 50                       push ax
  6233 0000219C E80500                   call genCode8
  6234 0000219F 83C402                   add  sp, 2
  6235                                  
  6236                                  ;-983 }
  6237                                  
  6238                                  
  6239                                  ;-984 int genCode8(char c) {
  6240 000021A2 C9                       LEAVE
  6241 000021A3 C3                       ret
  6242                                  ENDP
  6243                                  
  6244                                  genCode8: PROC
  6245                                  
  6246                                  ;-985 //set: BinLen++, OpPrintIndex++
  6247                                  
  6248                                  
  6249                                  ;-986     FileBin[BinLen]=c;
  6250                                  
  6251                                  ;Function : genCode8, Number of local variables: 1
  6252                                  ;   # type sign width addr used name   list of local variables
  6253                                  ;  200 var sign byte   984 NULL c = bp+4;
  6254 000021A4 C8000000                 ENTER  0,0
  6255 000021A8 8A4604                   mov al, [bp+4]
  6256 000021AB 8B1E[5800]               mov bx, [BinLen]
  6257 000021AF 8887AAA4                 mov [FileBin+bx], al
  6258                                  
  6259                                  ;-987     BinLen++;
  6260                                  
  6261 000021B3 FF06[5800]               inc  word[BinLen]
  6262                                  
  6263                                  ;-988     PC++;
  6264                                  
  6265 000021B7 FF06[2300]               inc  word[PC]
  6266                                  
  6267                                  ;-989     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6268                                  
  6269 000021BB A1[5800]                 mov ax, [BinLen]
  6270 000021BE 3D204E                   cmp ax, 20000 ;unsigned : 0
  6271 000021C1 0F820900                 jb  .genCode8236
  6272 000021C5 68[E921]                 push genCode8_0
  6273 000021C8 E81CF9                   call errorexit
  6274 000021CB 83C402                   add  sp, 2
  6275                                  
  6276                                  ;-990     if (OpPrintIndex < OPMAXLEN) {
  6277                                  
  6278                                  .genCode8236:
  6279 000021CE A1[4100]                 mov ax, [OpPrintIndex]
  6280 000021D1 83F805                   cmp ax, 5
  6281 000021D4 0F8D0F00                 jge .genCode8237
  6282                                  
  6283                                  ;-991         OpPos[OpPrintIndex]=c;
  6284                                  
  6285 000021D8 8A4604                   mov al, [bp+4]
  6286 000021DB 8B1E[4100]               mov bx, [OpPrintIndex]
  6287 000021DF 88875577                 mov [OpPos+bx], al
  6288                                  
  6289                                  ;-992         OpPrintIndex++;
  6290                                  
  6291 000021E3 FF06[4100]               inc  word[OpPrintIndex]
  6292                                  
  6293                                  ;-993     }
  6294                                  
  6295                                  
  6296                                  ;-994 }
  6297                                  
  6298                                  .genCode8237:
  6299                                  
  6300                                  ;-995 int genCode16(unsigned int i) {
  6301 000021E7 C9                       LEAVE
  6302 000021E8 C3                       ret
  6303 000021E9 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6304 000021F2 746F6F206C6F6E6700 
  6305                                  ENDP
  6306                                  
  6307                                  genCode16: PROC
  6308                                  
  6309                                  ;-996     genCode8(i); i=i >> 8;
  6310                                  
  6311                                  ;Function : genCode16, Number of local variables: 1
  6312                                  ;   # type sign width addr used name   list of local variables
  6313                                  ;  200 var unsg word   995 NULL i = bp+4;
  6314 000021FB C8000000                 ENTER  0,0
  6315 000021FF FF7604                   push word [bp+4]
  6316 00002202 E89FFF                   call genCode8
  6317 00002205 83C402                   add  sp, 2
  6318 00002208 8B4604                   mov ax, [bp+4]
  6319 0000220B C1E808                   shr ax, 8
  6320 0000220E 894604                   mov [bp+4], ax
  6321                                  
  6322                                  ;-997     genCode8(i);
  6323                                  
  6324 00002211 FF7604                   push word [bp+4]
  6325 00002214 E88DFF                   call genCode8
  6326 00002217 83C402                   add  sp, 2
  6327                                  
  6328                                  ;-998 }
  6329                                  
  6330                                  
  6331                                  ;-999 int genCode32(unsigned long L) {
  6332 0000221A C9                       LEAVE
  6333 0000221B C3                       ret
  6334                                  ENDP
  6335                                  
  6336                                  genCode32: PROC
  6337                                  
  6338                                  ;-1000     genCode16(L); L=L >>16;
  6339                                  
  6340                                  ;Function : genCode32, Number of local variables: 1
  6341                                  ;   # type sign width addr used name   list of local variables
  6342                                  ;  200 var unsg dwrd   999 NULL L = bp+4;
  6343 0000221C C8000000                 ENTER  0,0
  6344 00002220 8A4604                   mov al, byte [bp+4]
  6345 00002223 B400                     mov ah, 0
  6346 00002225 50                       push ax
  6347 00002226 E8D2FF                   call genCode16
  6348 00002229 83C402                   add  sp, 2
  6349 0000222C 668B4604                 mov eax, [bp+4]
  6350 00002230 66C1E810                 shr eax, 16
  6351 00002234 66894604                 mov [bp+4], eax
  6352                                  
  6353                                  ;-1001     genCode16(L);
  6354                                  
  6355 00002238 8A4604                   mov al, byte [bp+4]
  6356 0000223B B400                     mov ah, 0
  6357 0000223D 50                       push ax
  6358 0000223E E8BAFF                   call genCode16
  6359 00002241 83C402                   add  sp, 2
  6360                                  
  6361                                  ;-1002 }
  6362                                  
  6363                                  
  6364                                  ;-1003 int writeEA(char xxx) {//value for reg/operand
  6365 00002244 C9                       LEAVE
  6366 00002245 C3                       ret
  6367                                  ENDP
  6368                                  
  6369                                  writeEA: PROC
  6370                                  
  6371                                  ;-1004 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6372                                  
  6373                                  
  6374                                  ;-1005 //mod-bits: mode76, reg/opcode543, r/m210
  6375                                  
  6376                                  
  6377                                  ;-1006 //Op: 0, IMM, REG, ADR, MEM
  6378                                  
  6379                                  
  6380                                  ;-1007     char len;
  6381                                  
  6382                                  
  6383                                  ;-1008     len=0;
  6384                                  
  6385                                  ;Function : writeEA, Number of local variables: 2
  6386                                  ;   # type sign width addr used name   list of local variables
  6387                                  ;  200 var sign byte  1003 NULL xxx = bp+4
  6388                                  ;  201 var sign byte  1007 NULL len = bp-2;
  6389 00002246 C8020000                 ENTER  2,0
  6390 0000224A B80000                   mov ax, 0
  6391 0000224D 8846FE                   mov [bp-2], al
  6392                                  
  6393                                  ;-1009     xxx = xxx << 3;//in reg/opcode field
  6394                                  
  6395 00002250 8A4604                   mov al, [bp+4]
  6396 00002253 C0E003                   shl al, 3
  6397 00002256 884604                   mov [bp+4], al
  6398                                  
  6399                                  ;-1010     if (Op == REG) {
  6400                                  
  6401 00002259 A0[2D00]                 mov al, [Op]
  6402 0000225C 3C02                     cmp al, 2
  6403 0000225E 0F853A00                 jne .writeEA238
  6404                                  
  6405                                  ;-1011         xxx |= 0xC0;
  6406                                  
  6407 00002262 804E04C0                 or  byte[bp+4], 192
  6408                                  
  6409                                  ;-1012         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6410                                  
  6411 00002266 A0[2E00]                 mov al, [Op2]
  6412 00002269 3C01                     cmp al, 1
  6413 0000226B 0F8F0D00                 jg  .writeEA239
  6414 0000226F 8A4604                   mov al, [bp+4]
  6415 00002272 0206[3400]               add al, [R1No]
  6416 00002276 884604                   mov [bp+4], al
  6417                                  
  6418                                  ;-1013             else {
  6419                                  
  6420 00002279 E92000                   jmp .writeEA240
  6421                                  .writeEA239:
  6422                                  
  6423                                  ;-1014                 if (Op2 == REG) xxx = xxx + R1No;
  6424                                  
  6425 0000227C A0[2E00]                 mov al, [Op2]
  6426 0000227F 3C02                     cmp al, 2
  6427 00002281 0F850D00                 jne .writeEA241
  6428 00002285 8A4604                   mov al, [bp+4]
  6429 00002288 0206[3400]               add al, [R1No]
  6430 0000228C 884604                   mov [bp+4], al
  6431                                  
  6432                                  ;-1015                 else            xxx = xxx + R2No;
  6433                                  
  6434 0000228F E90A00                   jmp .writeEA242
  6435                                  .writeEA241:
  6436 00002292 8A4604                   mov al, [bp+4]
  6437 00002295 0206[3300]               add al, [R2No]
  6438 00002299 884604                   mov [bp+4], al
  6439                                  
  6440                                  ;-1016             }
  6441                                  
  6442                                  .writeEA242:
  6443                                  
  6444                                  ;-1017         }
  6445                                  
  6446                                  .writeEA240:
  6447                                  
  6448                                  ;-1018     if (Op == MEM) {
  6449                                  
  6450                                  .writeEA238:
  6451 0000229C A0[2D00]                 mov al, [Op]
  6452 0000229F 3C04                     cmp al, 4
  6453 000022A1 0F857300                 jne .writeEA243
  6454                                  
  6455                                  ;-1019         if (isDirect) {
  6456                                  
  6457 000022A5 A0[3C00]                 mov al, [isDirect]
  6458 000022A8 08C0                     or  al, al
  6459 000022AA 0F840D00                 je .writeEA244
  6460                                  
  6461                                  ;-1020             xxx |= 6;
  6462                                  
  6463 000022AE 804E0406                 or  byte[bp+4], 6
  6464                                  
  6465                                  ;-1021             len = 2;
  6466                                  
  6467 000022B2 B80200                   mov ax, 2
  6468 000022B5 8846FE                   mov [bp-2], al
  6469                                  
  6470                                  ;-1022         }
  6471                                  
  6472                                  
  6473                                  ;-1023         else {
  6474                                  
  6475 000022B8 E95D00                   jmp .writeEA245
  6476                                  .writeEA244:
  6477                                  
  6478                                  ;-1024             xxx = xxx + rm;
  6479                                  
  6480 000022BB 8A4604                   mov al, [bp+4]
  6481 000022BE 0206[3B00]               add al, [rm]
  6482 000022C2 884604                   mov [bp+4], al
  6483                                  
  6484                                  ;-1025             if (rm == 6) {//make [BP+00]
  6485                                  
  6486 000022C5 A0[3B00]                 mov al, [rm]
  6487 000022C8 3C06                     cmp al, 6
  6488 000022CA 0F851400                 jne .writeEA246
  6489                                  
  6490                                  ;-1026                 len=1;
  6491                                  
  6492 000022CE B80100                   mov ax, 1
  6493 000022D1 8846FE                   mov [bp-2], al
  6494                                  
  6495                                  ;-1027                 if (disp == 0) xxx |= 0x40;
  6496                                  
  6497 000022D4 A1[3D00]                 mov ax, [disp]
  6498 000022D7 83F800                   cmp ax, 0
  6499 000022DA 0F850400                 jne .writeEA247
  6500 000022DE 804E0440                 or  byte[bp+4], 64
  6501                                  
  6502                                  ;-1028             }
  6503                                  
  6504                                  .writeEA247:
  6505                                  
  6506                                  ;-1029 
  6507                                  
  6508                                  
  6509                                  ;-1030             if (disp) {
  6510                                  
  6511                                  .writeEA246:
  6512 000022E2 A1[3D00]                 mov ax, [disp]
  6513 000022E5 08C0                     or  al, al
  6514 000022E7 0F842D00                 je .writeEA248
  6515                                  
  6516                                  ;-1031                 ax = disp;
  6517                                  
  6518 000022EB A1[3D00]                 mov  ax, [disp]
  6519                                  
  6520                                  ;-1032                 if(ax > 127) len=2;
  6521                                  
  6522 000022EE 83F87F                   cmp  ax, 127
  6523 000022F1 0F8E0900                 jle .writeEA249
  6524 000022F5 B80200                   mov ax, 2
  6525 000022F8 8846FE                   mov [bp-2], al
  6526                                  
  6527                                  ;-1033                 else len=1;
  6528                                  
  6529 000022FB E90600                   jmp .writeEA250
  6530                                  .writeEA249:
  6531 000022FE B80100                   mov ax, 1
  6532 00002301 8846FE                   mov [bp-2], al
  6533                                  
  6534                                  ;-1034                 if (len == 1) xxx |= 0x40;
  6535                                  
  6536                                  .writeEA250:
  6537 00002304 8A46FE                   mov al, [bp-2]
  6538 00002307 3C01                     cmp al, 1
  6539 00002309 0F850700                 jne .writeEA251
  6540 0000230D 804E0440                 or  byte[bp+4], 64
  6541                                  
  6542                                  ;-1035                 else xxx |= 0x80;
  6543                                  
  6544 00002311 E90400                   jmp .writeEA252
  6545                                  .writeEA251:
  6546 00002314 804E0480                 or  byte[bp+4], 128
  6547                                  
  6548                                  ;-1036             }
  6549                                  
  6550                                  .writeEA252:
  6551                                  
  6552                                  ;-1037         }
  6553                                  
  6554                                  .writeEA248:
  6555                                  
  6556                                  ;-1038     }
  6557                                  
  6558                                  .writeEA245:
  6559                                  
  6560                                  ;-1039 
  6561                                  
  6562                                  
  6563                                  ;-1040     genCode8(xxx);// gen second byte
  6564                                  
  6565                                  .writeEA243:
  6566 00002318 8A4604                   mov al, byte [bp+4]
  6567 0000231B B400                     mov ah, 0
  6568 0000231D 50                       push ax
  6569 0000231E E883FE                   call genCode8
  6570 00002321 83C402                   add  sp, 2
  6571                                  
  6572                                  ;-1041     if (len == 1) genCode8 (disp);
  6573                                  
  6574 00002324 8A46FE                   mov al, [bp-2]
  6575 00002327 3C01                     cmp al, 1
  6576 00002329 0F850A00                 jne .writeEA253
  6577 0000232D FF36[3D00]               push word [disp]
  6578 00002331 E870FE                   call genCode8
  6579 00002334 83C402                   add  sp, 2
  6580                                  
  6581                                  ;-1042     if (len == 2) genCode16(disp);
  6582                                  
  6583                                  .writeEA253:
  6584 00002337 8A46FE                   mov al, [bp-2]
  6585 0000233A 3C02                     cmp al, 2
  6586 0000233C 0F850A00                 jne .writeEA254
  6587 00002340 FF36[3D00]               push word [disp]
  6588 00002344 E8B4FE                   call genCode16
  6589 00002347 83C402                   add  sp, 2
  6590                                  
  6591                                  ;-1043 }
  6592                                  
  6593                                  .writeEA254:
  6594                                  
  6595                                  ;-1044 
  6596                                  
  6597                                  
  6598                                  ;-1045 int genImmediate() {
  6599 0000234A C9                       LEAVE
  6600 0000234B C3                       ret
  6601                                  ENDP
  6602                                  
  6603                                  genImmediate: PROC
  6604                                  
  6605                                  ;-1046     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6606                                  
  6607 0000234C A0[3800]                 mov al, [wflag]
  6608 0000234F 08C0                     or  al, al
  6609 00002351 0F842300                 je .genImmediate255
  6610 00002355 A0[3700]                 mov al, [OpSize]
  6611 00002358 3C03                     cmp al, 3
  6612 0000235A 0F850D00                 jne .genImmediate256
  6613 0000235E FF36[3F00]               push word [imme]
  6614 00002362 E8B7FE                   call genCode32
  6615 00002365 83C402                   add  sp, 2
  6616                                  
  6617                                  ;-1047         else genCode16(imme);
  6618                                  
  6619 00002368 E90A00                   jmp .genImmediate257
  6620                                  .genImmediate256:
  6621 0000236B FF36[3F00]               push word [imme]
  6622 0000236F E889FE                   call genCode16
  6623 00002372 83C402                   add  sp, 2
  6624                                  
  6625                                  ;-1048     else       genCode8 (imme);
  6626                                  
  6627                                  .genImmediate257:
  6628 00002375 E90A00                   jmp .genImmediate258
  6629                                  .genImmediate255:
  6630 00002378 FF36[3F00]               push word [imme]
  6631 0000237C E825FE                   call genCode8
  6632 0000237F 83C402                   add  sp, 2
  6633                                  
  6634                                  ;-1049 }
  6635                                  
  6636                                  .genImmediate258:
  6637                                  
  6638                                  ;-1050 
  6639                                  
  6640                                  
  6641                                  ;-1051 //AS.C
  6642                                  
  6643                                  
  6644                                  ;-1052 int process() {
  6645                                  
  6646 00002382 C3                       ret
  6647                                  ENDP
  6648                                  
  6649                                  process: PROC
  6650                                  
  6651                                  ;-1053     char c;
  6652                                  
  6653                                  
  6654                                  ;-1054     int i;
  6655                                  
  6656                                  
  6657                                  ;-1055     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6658                                  
  6659                                  ;Function : process, Number of local variables: 2
  6660                                  ;   # type sign width addr used name   list of local variables
  6661                                  ;  200 var sign byte  1053 NULL c = bp-2
  6662                                  ;  201 var sign word  1054 NULL i = bp-4;
  6663 00002383 C8040000                 ENTER  4,0
  6664 00002387 B80000                   mov ax, 0
  6665 0000238A A2[3B00]                 mov byte [rm], al
  6666 0000238D A2[3800]                 mov byte [wflag], al
  6667 00002390 A2[3900]                 mov byte [dflag], al
  6668 00002393 A2[3300]                 mov byte [R2No], al
  6669 00002396 A2[3400]                 mov byte [R1No], al
  6670 00002399 A2[3500]                 mov byte [R2Type], al
  6671 0000239C A2[3600]                 mov byte [R1Type], al
  6672 0000239F A2[2E00]                 mov byte [Op2], al
  6673 000023A2 A2[2D00]                 mov byte [Op], al
  6674                                  
  6675                                  ;-1056     disp=imme=0;//int
  6676                                  
  6677 000023A5 B80000                   mov ax, 0
  6678 000023A8 A3[3F00]                 mov word [imme], ax
  6679 000023AB A3[3D00]                 mov word [disp], ax
  6680                                  
  6681                                  ;-1057     isDirect=1; //set in getMeM=0, need in WriteEA
  6682                                  
  6683 000023AE B80100                   mov ax, 1
  6684 000023B1 A2[3C00]                 mov byte [isDirect], al
  6685                                  
  6686                                  ;-1058     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6687                                  
  6688 000023B4 E811E7                   call getTokeType
  6689                                  
  6690                                  ;-1059     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6691                                  
  6692 000023B7 E8B5EA                   call getCodeSize
  6693 000023BA A2[3700]                 mov byte [OpSize], al
  6694                                  
  6695                                  ;-1060     getCodes();//set: Code1, Code2, Code3
  6696                                  
  6697 000023BD E876FD                   call getCodes
  6698                                  
  6699                                  ;-1061 
  6700                                  
  6701                                  
  6702                                  ;-1062     if (CodeType ==  1) {//1 byte opcode
  6703                                  
  6704 000023C0 A0[2F00]                 mov al, [CodeType]
  6705 000023C3 3C01                     cmp al, 1
  6706 000023C5 0F850F00                 jne .process259
  6707                                  
  6708                                  ;-1063         genCode8(Code1);
  6709                                  
  6710 000023C9 A0[3000]                 mov al, byte [Code1]
  6711 000023CC B400                     mov ah, 0
  6712 000023CE 50                       push ax
  6713 000023CF E8D2FD                   call genCode8
  6714 000023D2 83C402                   add  sp, 2
  6715                                  
  6716                                  ;-1064         return;
  6717                                  
  6718 000023D5 E98D08                   jmp .retnprocess
  6719                                  
  6720                                  ;-1065     }
  6721                                  
  6722                                  
  6723                                  ;-1066 
  6724                                  
  6725                                  
  6726                                  ;-1067     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6727                                  
  6728                                  .process259:
  6729 000023D8 A0[2F00]                 mov al, [CodeType]
  6730 000023DB 3C02                     cmp al, 2
  6731 000023DD 0F856900                 jne .process260
  6732                                  
  6733                                  ;-1068         getOpL();
  6734                                  
  6735 000023E1 E822E2                   call getOpL
  6736                                  
  6737                                  ;-1069         checkOpL();
  6738                                  
  6739 000023E4 E842E1                   call checkOpL
  6740                                  
  6741                                  ;-1070         if (Code2 <= 1) {//inc,dec
  6742                                  
  6743 000023E7 A0[3100]                 mov al, [Code2]
  6744 000023EA 3C01                     cmp al, 1
  6745 000023EC 0F8F2700                 jg  .process261
  6746                                  
  6747                                  ;-1071   	        if (Op == REG) {//short
  6748                                  
  6749 000023F0 A0[2D00]                 mov al, [Op]
  6750 000023F3 3C02                     cmp al, 2
  6751 000023F5 0F851E00                 jne .process262
  6752                                  
  6753                                  ;-1072                 if (wflag) {genCode2(Code3, R1No); return; }
  6754                                  
  6755 000023F9 A0[3800]                 mov al, [wflag]
  6756 000023FC 08C0                     or  al, al
  6757 000023FE 0F841500                 je .process263
  6758 00002402 A0[3400]                 mov al, byte [R1No]
  6759 00002405 B400                     mov ah, 0
  6760 00002407 50                       push ax
  6761 00002408 A0[3200]                 mov al, byte [Code3]
  6762 0000240B B400                     mov ah, 0
  6763 0000240D 50                       push ax
  6764 0000240E E85CFD                   call genCode2
  6765 00002411 83C404                   add  sp, 4
  6766 00002414 E94E08                   jmp .retnprocess
  6767                                  
  6768                                  ;-1073             }
  6769                                  
  6770                                  .process263:
  6771                                  
  6772                                  ;-1074         }
  6773                                  
  6774                                  .process262:
  6775                                  
  6776                                  ;-1075         if (Code2 == 5) {//imul extension?
  6777                                  
  6778                                  .process261:
  6779 00002417 A0[3100]                 mov al, [Code2]
  6780 0000241A 3C05                     cmp al, 5
  6781 0000241C 0F850F00                 jne .process264
  6782                                  
  6783                                  ;-1076             getTokeType();
  6784                                  
  6785 00002420 E8A5E6                   call getTokeType
  6786                                  
  6787                                  ;-1077             if (TokeType) implerror();
  6788                                  
  6789 00002423 A0[2C00]                 mov al, [TokeType]
  6790 00002426 08C0                     or  al, al
  6791 00002428 0F840300                 je .process265
  6792 0000242C E846F7                   call implerror
  6793                                  
  6794                                  ;-1078         }
  6795                                  
  6796                                  .process265:
  6797                                  
  6798                                  ;-1079         genCodeW(Code1);
  6799                                  
  6800                                  .process264:
  6801 0000242F A0[3000]                 mov al, byte [Code1]
  6802 00002432 B400                     mov ah, 0
  6803 00002434 50                       push ax
  6804 00002435 E850FD                   call genCodeW
  6805 00002438 83C402                   add  sp, 2
  6806                                  
  6807                                  ;-1080         writeEA(Code2);
  6808                                  
  6809 0000243B A0[3100]                 mov al, byte [Code2]
  6810 0000243E B400                     mov ah, 0
  6811 00002440 50                       push ax
  6812 00002441 E802FE                   call writeEA
  6813 00002444 83C402                   add  sp, 2
  6814                                  
  6815                                  ;-1081         return;
  6816                                  
  6817 00002447 E91B08                   jmp .retnprocess
  6818                                  
  6819                                  ;-1082     }
  6820                                  
  6821                                  
  6822                                  ;-1083 
  6823                                  
  6824                                  
  6825                                  ;-1084     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6826                                  
  6827                                  .process260:
  6828 0000244A A0[2F00]                 mov al, [CodeType]
  6829 0000244D 3C03                     cmp al, 3
  6830 0000244F 0F855100                 jne .process266
  6831                                  
  6832                                  ;-1085         check2Ops();    //setwflag not applicable
  6833                                  
  6834 00002453 E855E1                   call check2Ops
  6835                                  
  6836                                  ;-1086         if (R1Type != WORD) reg16error();//only r16
  6837                                  
  6838 00002456 A0[3600]                 mov al, [R1Type]
  6839 00002459 3C02                     cmp al, 2
  6840 0000245B 0F840300                 je  .process267
  6841 0000245F E8B3F7                   call reg16error
  6842                                  
  6843                                  ;-1087         if (Op2 != MEM) addrerror();//only m16
  6844                                  
  6845                                  .process267:
  6846 00002462 A0[2E00]                 mov al, [Op2]
  6847 00002465 3C04                     cmp al, 4
  6848 00002467 0F840300                 je  .process268
  6849 0000246B E8C8F6                   call addrerror
  6850                                  
  6851                                  ;-1088 
  6852                                  
  6853                                  
  6854                                  ;-1089         genCode8(Code1);//les,lds,lea
  6855                                  
  6856                                  .process268:
  6857 0000246E A0[3000]                 mov al, byte [Code1]
  6858 00002471 B400                     mov ah, 0
  6859 00002473 50                       push ax
  6860 00002474 E82DFD                   call genCode8
  6861 00002477 83C402                   add  sp, 2
  6862                                  
  6863                                  ;-1090         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6864                                  
  6865 0000247A A0[3000]                 mov al, [Code1]
  6866 0000247D 3C0F                     cmp al, 15
  6867 0000247F 0F850C00                 jne .process269
  6868 00002483 A0[3100]                 mov al, byte [Code2]
  6869 00002486 B400                     mov ah, 0
  6870 00002488 50                       push ax
  6871 00002489 E818FD                   call genCode8
  6872 0000248C 83C402                   add  sp, 2
  6873                                  
  6874                                  ;-1091         Op=Op2;//set MEM for writeEA
  6875                                  
  6876                                  .process269:
  6877 0000248F A0[2E00]                 mov al, [Op2]
  6878 00002492 A2[2D00]                 mov byte [Op], al
  6879                                  
  6880                                  ;-1092         writeEA(R1No);
  6881                                  
  6882 00002495 A0[3400]                 mov al, byte [R1No]
  6883 00002498 B400                     mov ah, 0
  6884 0000249A 50                       push ax
  6885 0000249B E8A8FD                   call writeEA
  6886 0000249E 83C402                   add  sp, 2
  6887                                  
  6888                                  ;-1093         return;
  6889                                  
  6890 000024A1 E9C107                   jmp .retnprocess
  6891                                  
  6892                                  ;-1094     }
  6893                                  
  6894                                  
  6895                                  ;-1095 
  6896                                  
  6897                                  
  6898                                  ;-1096     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6899                                  
  6900                                  .process266:
  6901 000024A4 A0[2F00]                 mov al, [CodeType]
  6902 000024A7 3C04                     cmp al, 4
  6903 000024A9 0F85EF00                 jne .process270
  6904                                  
  6905                                  ;-1097         check2Ops();
  6906                                  
  6907 000024AD E8FBE0                   call check2Ops
  6908                                  
  6909                                  ;-1098         if (Op2 == IMM) {//second operand is imm
  6910                                  
  6911 000024B0 A0[2E00]                 mov al, [Op2]
  6912 000024B3 3C01                     cmp al, 1
  6913 000024B5 0F857900                 jne .process271
  6914                                  
  6915                                  ;-1099             setsflag();
  6916                                  
  6917 000024B9 E86BE4                   call setsflag
  6918                                  
  6919                                  ;-1100             if (Op == REG) {
  6920                                  
  6921 000024BC A0[2D00]                 mov al, [Op]
  6922 000024BF 3C02                     cmp al, 2
  6923 000024C1 0F853100                 jne .process272
  6924                                  
  6925                                  ;-1101                 if (R1No == 0) {// acc,imm
  6926                                  
  6927 000024C5 A0[3400]                 mov al, [R1No]
  6928 000024C8 3C00                     cmp al, 0
  6929 000024CA 0F852800                 jne .process273
  6930                                  
  6931                                  ;-1102                     if (sflag == 0) {
  6932                                  
  6933 000024CE A0[3A00]                 mov al, [sflag]
  6934 000024D1 3C00                     cmp al, 0
  6935 000024D3 0F851F00                 jne .process274
  6936                                  
  6937                                  ;-1103                         c = Code1 << 3;
  6938                                  
  6939 000024D7 A0[3000]                 mov al, [Code1]
  6940 000024DA C0E003                   shl al, 3
  6941 000024DD 8846FE                   mov [bp-2], al
  6942                                  
  6943                                  ;-1104                         c += 4;
  6944                                  
  6945 000024E0 8046FE04                 add  byte[bp-2], 4
  6946                                  
  6947                                  ;-1105                         genCodeW(c);
  6948                                  
  6949 000024E4 8A46FE                   mov al, byte [bp-2]
  6950 000024E7 B400                     mov ah, 0
  6951 000024E9 50                       push ax
  6952 000024EA E89BFC                   call genCodeW
  6953 000024ED 83C402                   add  sp, 2
  6954                                  
  6955                                  ;-1106                         genImmediate();
  6956                                  
  6957 000024F0 E859FE                   call genImmediate
  6958                                  
  6959                                  ;-1107                         return;
  6960                                  
  6961 000024F3 E96F07                   jmp .retnprocess
  6962                                  
  6963                                  ;-1108                     }
  6964                                  
  6965                                  
  6966                                  ;-1109                 }
  6967                                  
  6968                                  .process274:
  6969                                  
  6970                                  ;-1110             }
  6971                                  
  6972                                  .process273:
  6973                                  
  6974                                  ;-1111             //r/m, imm: 80 sign-extended,TTT,imm
  6975                                  
  6976                                  
  6977                                  ;-1112             c = sflag + 0x80;
  6978                                  
  6979                                  .process272:
  6980 000024F6 A0[3A00]                 mov al, [sflag]
  6981 000024F9 0480                     add al, 128
  6982 000024FB 8846FE                   mov [bp-2], al
  6983                                  
  6984                                  ;-1113             genCodeW(c);
  6985                                  
  6986 000024FE 8A46FE                   mov al, byte [bp-2]
  6987 00002501 B400                     mov ah, 0
  6988 00002503 50                       push ax
  6989 00002504 E881FC                   call genCodeW
  6990 00002507 83C402                   add  sp, 2
  6991                                  
  6992                                  ;-1114             writeEA(Code1);
  6993                                  
  6994 0000250A A0[3000]                 mov al, byte [Code1]
  6995 0000250D B400                     mov ah, 0
  6996 0000250F 50                       push ax
  6997 00002510 E833FD                   call writeEA
  6998 00002513 83C402                   add  sp, 2
  6999                                  
  7000                                  ;-1115             if (sflag) genCode8(imme);
  7001                                  
  7002 00002516 A0[3A00]                 mov al, [sflag]
  7003 00002519 08C0                     or  al, al
  7004 0000251B 0F840D00                 je .process275
  7005 0000251F FF36[3F00]               push word [imme]
  7006 00002523 E87EFC                   call genCode8
  7007 00002526 83C402                   add  sp, 2
  7008                                  
  7009                                  ;-1116             else genImmediate();
  7010                                  
  7011 00002529 E90300                   jmp .process276
  7012                                  .process275:
  7013 0000252C E81DFE                   call genImmediate
  7014                                  
  7015                                  ;-1117             return;
  7016                                  
  7017                                  .process276:
  7018 0000252F E93307                   jmp .retnprocess
  7019                                  
  7020                                  ;-1118         }
  7021                                  
  7022                                  
  7023                                  ;-1119         c = Code1 << 3;//r/m, r/r
  7024                                  
  7025                                  .process271:
  7026 00002532 A0[3000]                 mov al, [Code1]
  7027 00002535 C0E003                   shl al, 3
  7028 00002538 8846FE                   mov [bp-2], al
  7029                                  
  7030                                  ;-1120         if (Op == REG) {
  7031                                  
  7032 0000253B A0[2D00]                 mov al, [Op]
  7033 0000253E 3C02                     cmp al, 2
  7034 00002540 0F852E00                 jne .process277
  7035                                  
  7036                                  ;-1121             if (Op2 == MEM) {//reg, mem
  7037                                  
  7038 00002544 A0[2E00]                 mov al, [Op2]
  7039 00002547 3C04                     cmp al, 4
  7040 00002549 0F852500                 jne .process278
  7041                                  
  7042                                  ;-1122                 c += 2;//add direction flag
  7043                                  
  7044 0000254D 8046FE02                 add  byte[bp-2], 2
  7045                                  
  7046                                  ;-1123                 genCodeW(c);
  7047                                  
  7048 00002551 8A46FE                   mov al, byte [bp-2]
  7049 00002554 B400                     mov ah, 0
  7050 00002556 50                       push ax
  7051 00002557 E82EFC                   call genCodeW
  7052 0000255A 83C402                   add  sp, 2
  7053                                  
  7054                                  ;-1124                 Op=Op2;//set MEM for writeEA
  7055                                  
  7056 0000255D A0[2E00]                 mov al, [Op2]
  7057 00002560 A2[2D00]                 mov byte [Op], al
  7058                                  
  7059                                  ;-1125                 writeEA(R1No);
  7060                                  
  7061 00002563 A0[3400]                 mov al, byte [R1No]
  7062 00002566 B400                     mov ah, 0
  7063 00002568 50                       push ax
  7064 00002569 E8DAFC                   call writeEA
  7065 0000256C 83C402                   add  sp, 2
  7066                                  
  7067                                  ;-1126                 return;
  7068                                  
  7069 0000256F E9F306                   jmp .retnprocess
  7070                                  
  7071                                  ;-1127             }
  7072                                  
  7073                                  
  7074                                  ;-1128         }
  7075                                  
  7076                                  .process278:
  7077                                  
  7078                                  ;-1129         if (Op2 == REG) {//mem,reg    reg,reg
  7079                                  
  7080                                  .process277:
  7081 00002572 A0[2E00]                 mov al, [Op2]
  7082 00002575 3C02                     cmp al, 2
  7083 00002577 0F851B00                 jne .process279
  7084                                  
  7085                                  ;-1130             genCodeW(c);
  7086                                  
  7087 0000257B 8A46FE                   mov al, byte [bp-2]
  7088 0000257E B400                     mov ah, 0
  7089 00002580 50                       push ax
  7090 00002581 E804FC                   call genCodeW
  7091 00002584 83C402                   add  sp, 2
  7092                                  
  7093                                  ;-1131             writeEA(R2No);//2. Op in reg-field
  7094                                  
  7095 00002587 A0[3300]                 mov al, byte [R2No]
  7096 0000258A B400                     mov ah, 0
  7097 0000258C 50                       push ax
  7098 0000258D E8B6FC                   call writeEA
  7099 00002590 83C402                   add  sp, 2
  7100                                  
  7101                                  ;-1132             return;
  7102                                  
  7103 00002593 E9CF06                   jmp .retnprocess
  7104                                  
  7105                                  ;-1133         }
  7106                                  
  7107                                  
  7108                                  ;-1134         syntaxerror();
  7109                                  
  7110                                  .process279:
  7111 00002596 E8CBF6                   call syntaxerror
  7112                                  
  7113                                  ;-1135         return;
  7114                                  
  7115 00002599 E9C906                   jmp .retnprocess
  7116                                  
  7117                                  ;-1136     }
  7118                                  
  7119                                  
  7120                                  ;-1137 
  7121                                  
  7122                                  
  7123                                  ;-1138     if (CodeType == 5) {//mov (movsx, movzx=51)
  7124                                  
  7125                                  .process270:
  7126 0000259C A0[2F00]                 mov al, [CodeType]
  7127 0000259F 3C05                     cmp al, 5
  7128 000025A1 0F858B01                 jne .process280
  7129                                  
  7130                                  ;-1139         check2Ops();
  7131                                  
  7132 000025A5 E803E0                   call check2Ops
  7133                                  
  7134                                  ;-1140 /*    prs("\n Op:"); printhex8a(Op);
  7135                                  
  7136                                  
  7137                                  ;-1141     prs(", Op2:"); printhex8a(Op2);
  7138                                  
  7139                                  
  7140                                  ;-1142     prs(", R1No:"); printhex8a(R1No);
  7141                                  
  7142                                  
  7143                                  ;-1143     prs(", R2No:"); printhex8a(R2No);   */
  7144                                  
  7145                                  
  7146                                  ;-1144         if (Op2 == ADR) {
  7147                                  
  7148 000025A8 A0[2E00]                 mov al, [Op2]
  7149 000025AB 3C03                     cmp al, 3
  7150 000025AD 0F851B00                 jne .process281
  7151                                  
  7152                                  ;-1145             if (disp) imme=disp;
  7153                                  
  7154 000025B1 A1[3D00]                 mov ax, [disp]
  7155 000025B4 08C0                     or  al, al
  7156 000025B6 0F840900                 je .process282
  7157 000025BA A1[3D00]                 mov ax, [disp]
  7158 000025BD A3[3F00]                 mov word [imme], ax
  7159                                  
  7160                                  ;-1146             else notfounderror();
  7161                                  
  7162 000025C0 E90300                   jmp .process283
  7163                                  .process282:
  7164 000025C3 E83BF5                   call notfounderror
  7165                                  
  7166                                  ;-1147             Op2=IMM;//continue with IMM
  7167                                  
  7168                                  .process283:
  7169 000025C6 B80100                   mov ax, 1
  7170 000025C9 A2[2E00]                 mov byte [Op2], al
  7171                                  
  7172                                  ;-1148         }
  7173                                  
  7174                                  
  7175                                  ;-1149         if (Op2 == IMM) {// r,i
  7176                                  
  7177                                  .process281:
  7178 000025CC A0[2E00]                 mov al, [Op2]
  7179 000025CF 3C01                     cmp al, 1
  7180 000025D1 0F855400                 jne .process284
  7181                                  
  7182                                  ;-1150             if (Op == REG) {
  7183                                  
  7184 000025D5 A0[2D00]                 mov al, [Op]
  7185 000025D8 3C02                     cmp al, 2
  7186 000025DA 0F852500                 jne .process285
  7187                                  
  7188                                  ;-1151                 c = wflag << 3;
  7189                                  
  7190 000025DE A0[3800]                 mov al, [wflag]
  7191 000025E1 C0E003                   shl al, 3
  7192 000025E4 8846FE                   mov [bp-2], al
  7193                                  
  7194                                  ;-1152                 c += 0xB0;
  7195                                  
  7196 000025E7 8046FEB0                 add  byte[bp-2], 176
  7197                                  
  7198                                  ;-1153                 genCode2(c, R1No);
  7199                                  
  7200 000025EB A0[3400]                 mov al, byte [R1No]
  7201 000025EE B400                     mov ah, 0
  7202 000025F0 50                       push ax
  7203 000025F1 8A46FE                   mov al, byte [bp-2]
  7204 000025F4 B400                     mov ah, 0
  7205 000025F6 50                       push ax
  7206 000025F7 E873FB                   call genCode2
  7207 000025FA 83C404                   add  sp, 4
  7208                                  
  7209                                  ;-1154                 genImmediate();
  7210                                  
  7211 000025FD E84CFD                   call genImmediate
  7212                                  
  7213                                  ;-1155                 return;
  7214                                  
  7215 00002600 E96206                   jmp .retnprocess
  7216                                  
  7217                                  ;-1156             }
  7218                                  
  7219                                  
  7220                                  ;-1157             if (Op == MEM) {// m,i
  7221                                  
  7222                                  .process285:
  7223 00002603 A0[2D00]                 mov al, [Op]
  7224 00002606 3C04                     cmp al, 4
  7225 00002608 0F851700                 jne .process286
  7226                                  
  7227                                  ;-1158                 genCodeW(0xC6);
  7228                                  
  7229 0000260C 68C600                   push 198
  7230 0000260F E876FB                   call genCodeW
  7231 00002612 83C402                   add  sp, 2
  7232                                  
  7233                                  ;-1159                 writeEA( 0 );
  7234                                  
  7235 00002615 6A00                     push 0
  7236 00002617 E82CFC                   call writeEA
  7237 0000261A 83C402                   add  sp, 2
  7238                                  
  7239                                  ;-1160                 genImmediate();
  7240                                  
  7241 0000261D E82CFD                   call genImmediate
  7242                                  
  7243                                  ;-1161                 return;
  7244                                  
  7245 00002620 E94206                   jmp .retnprocess
  7246                                  
  7247                                  ;-1162             }
  7248                                  
  7249                                  
  7250                                  ;-1163             regmemerror();
  7251                                  
  7252                                  .process286:
  7253 00002623 E8C5F5                   call regmemerror
  7254                                  
  7255                                  ;-1164             return;
  7256                                  
  7257 00002626 E93C06                   jmp .retnprocess
  7258                                  
  7259                                  ;-1165         }
  7260                                  
  7261                                  
  7262                                  ;-1166         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7263                                  
  7264                                  .process284:
  7265 00002629 A0[3600]                 mov al, [R1Type]
  7266 0000262C 3C04                     cmp al, 4
  7267 0000262E 0F850300                 jne .process287
  7268 00002632 E8B2DE                   call ChangeDirection
  7269                                  
  7270                                  ;-1167         if (R2Type == SEGREG) {//rm,sreg
  7271                                  
  7272                                  .process287:
  7273 00002635 A0[3500]                 mov al, [R2Type]
  7274 00002638 3C04                     cmp al, 4
  7275 0000263A 0F852A00                 jne .process288
  7276                                  
  7277                                  ;-1168             if (OpSize != WORD) reg16error();
  7278                                  
  7279 0000263E A0[3700]                 mov al, [OpSize]
  7280 00002641 3C02                     cmp al, 2
  7281 00002643 0F840300                 je  .process289
  7282 00002647 E8CBF5                   call reg16error
  7283                                  
  7284                                  ;-1169                 genCode2(0x8C, dflag);
  7285                                  
  7286                                  .process289:
  7287 0000264A A0[3900]                 mov al, byte [dflag]
  7288 0000264D B400                     mov ah, 0
  7289 0000264F 50                       push ax
  7290 00002650 688C00                   push 140
  7291 00002653 E817FB                   call genCode2
  7292 00002656 83C404                   add  sp, 4
  7293                                  
  7294                                  ;-1170                 writeEA(R2No);
  7295                                  
  7296 00002659 A0[3300]                 mov al, byte [R2No]
  7297 0000265C B400                     mov ah, 0
  7298 0000265E 50                       push ax
  7299 0000265F E8E4FB                   call writeEA
  7300 00002662 83C402                   add  sp, 2
  7301                                  
  7302                                  ;-1171                 return;
  7303                                  
  7304 00002665 E9FD05                   jmp .retnprocess
  7305                                  
  7306                                  ;-1172         }
  7307                                  
  7308                                  
  7309                                  ;-1173         if (Op2 == MEM) {//acc, moffs16
  7310                                  
  7311                                  .process288:
  7312 00002668 A0[2E00]                 mov al, [Op2]
  7313 0000266B 3C04                     cmp al, 4
  7314 0000266D 0F853100                 jne .process290
  7315                                  
  7316                                  ;-1174             if (Op == REG) {
  7317                                  
  7318 00002671 A0[2D00]                 mov al, [Op]
  7319 00002674 3C02                     cmp al, 2
  7320 00002676 0F852800                 jne .process291
  7321                                  
  7322                                  ;-1175                 if (R1No == 0) {
  7323                                  
  7324 0000267A A0[3400]                 mov al, [R1No]
  7325 0000267D 3C00                     cmp al, 0
  7326 0000267F 0F851F00                 jne .process292
  7327                                  
  7328                                  ;-1176                     if (isDirect) {
  7329                                  
  7330 00002683 A0[3C00]                 mov al, [isDirect]
  7331 00002686 08C0                     or  al, al
  7332 00002688 0F841600                 je .process293
  7333                                  
  7334                                  ;-1177                         genCodeW(0xA0);
  7335                                  
  7336 0000268C 68A000                   push 160
  7337 0000268F E8F6FA                   call genCodeW
  7338 00002692 83C402                   add  sp, 2
  7339                                  
  7340                                  ;-1178                         genCode16(disp);
  7341                                  
  7342 00002695 FF36[3D00]               push word [disp]
  7343 00002699 E85FFB                   call genCode16
  7344 0000269C 83C402                   add  sp, 2
  7345                                  
  7346                                  ;-1179                         return;
  7347                                  
  7348 0000269F E9C305                   jmp .retnprocess
  7349                                  
  7350                                  ;-1180                     }
  7351                                  
  7352                                  
  7353                                  ;-1181                 }
  7354                                  
  7355                                  .process293:
  7356                                  
  7357                                  ;-1182             }
  7358                                  
  7359                                  .process292:
  7360                                  
  7361                                  ;-1183         }
  7362                                  
  7363                                  .process291:
  7364                                  
  7365                                  ;-1184         if (Op == MEM) {//moffs16, acc
  7366                                  
  7367                                  .process290:
  7368 000026A2 A0[2D00]                 mov al, [Op]
  7369 000026A5 3C04                     cmp al, 4
  7370 000026A7 0F853100                 jne .process294
  7371                                  
  7372                                  ;-1185             if (Op2 == REG) {
  7373                                  
  7374 000026AB A0[2E00]                 mov al, [Op2]
  7375 000026AE 3C02                     cmp al, 2
  7376 000026B0 0F852800                 jne .process295
  7377                                  
  7378                                  ;-1186                 if (R2No == 0) {
  7379                                  
  7380 000026B4 A0[3300]                 mov al, [R2No]
  7381 000026B7 3C00                     cmp al, 0
  7382 000026B9 0F851F00                 jne .process296
  7383                                  
  7384                                  ;-1187                     if (isDirect) {
  7385                                  
  7386 000026BD A0[3C00]                 mov al, [isDirect]
  7387 000026C0 08C0                     or  al, al
  7388 000026C2 0F841600                 je .process297
  7389                                  
  7390                                  ;-1188                         genCodeW(0xA2);
  7391                                  
  7392 000026C6 68A200                   push 162
  7393 000026C9 E8BCFA                   call genCodeW
  7394 000026CC 83C402                   add  sp, 2
  7395                                  
  7396                                  ;-1189                         genCode16(disp);
  7397                                  
  7398 000026CF FF36[3D00]               push word [disp]
  7399 000026D3 E825FB                   call genCode16
  7400 000026D6 83C402                   add  sp, 2
  7401                                  
  7402                                  ;-1190                         return;
  7403                                  
  7404 000026D9 E98905                   jmp .retnprocess
  7405                                  
  7406                                  ;-1191                     }
  7407                                  
  7408                                  
  7409                                  ;-1192                 }
  7410                                  
  7411                                  .process297:
  7412                                  
  7413                                  ;-1193             }
  7414                                  
  7415                                  .process296:
  7416                                  
  7417                                  ;-1194 
  7418                                  
  7419                                  
  7420                                  ;-1195         }
  7421                                  
  7422                                  .process295:
  7423                                  
  7424                                  ;-1196         if (Op2 == REG) {//rm, r
  7425                                  
  7426                                  .process294:
  7427 000026DC A0[2E00]                 mov al, [Op2]
  7428 000026DF 3C02                     cmp al, 2
  7429 000026E1 0F851800                 jne .process298
  7430                                  
  7431                                  ;-1197             genCodeW(0x88);
  7432                                  
  7433 000026E5 688800                   push 136
  7434 000026E8 E89DFA                   call genCodeW
  7435 000026EB 83C402                   add  sp, 2
  7436                                  
  7437                                  ;-1198             writeEA(R2No);
  7438                                  
  7439 000026EE A0[3300]                 mov al, byte [R2No]
  7440 000026F1 B400                     mov ah, 0
  7441 000026F3 50                       push ax
  7442 000026F4 E84FFB                   call writeEA
  7443 000026F7 83C402                   add  sp, 2
  7444                                  
  7445                                  ;-1199             return;
  7446                                  
  7447 000026FA E96805                   jmp .retnprocess
  7448                                  
  7449                                  ;-1200         }
  7450                                  
  7451                                  
  7452                                  ;-1201         if (Op2 == MEM) {//r, m
  7453                                  
  7454                                  .process298:
  7455 000026FD A0[2E00]                 mov al, [Op2]
  7456 00002700 3C04                     cmp al, 4
  7457 00002702 0F852400                 jne .process299
  7458                                  
  7459                                  ;-1202             if (Op == REG) {
  7460                                  
  7461 00002706 A0[2D00]                 mov al, [Op]
  7462 00002709 3C02                     cmp al, 2
  7463 0000270B 0F851B00                 jne .process300
  7464                                  
  7465                                  ;-1203                 ChangeDirection();
  7466                                  
  7467 0000270F E8D5DD                   call ChangeDirection
  7468                                  
  7469                                  ;-1204                 genCodeW(0x8A);
  7470                                  
  7471 00002712 688A00                   push 138
  7472 00002715 E870FA                   call genCodeW
  7473 00002718 83C402                   add  sp, 2
  7474                                  
  7475                                  ;-1205                 writeEA(R2No);
  7476                                  
  7477 0000271B A0[3300]                 mov al, byte [R2No]
  7478 0000271E B400                     mov ah, 0
  7479 00002720 50                       push ax
  7480 00002721 E822FB                   call writeEA
  7481 00002724 83C402                   add  sp, 2
  7482                                  
  7483                                  ;-1206                 return;
  7484                                  
  7485 00002727 E93B05                   jmp .retnprocess
  7486                                  
  7487                                  ;-1207             }
  7488                                  
  7489                                  
  7490                                  ;-1208         }
  7491                                  
  7492                                  .process300:
  7493                                  
  7494                                  ;-1209         syntaxerror();
  7495                                  
  7496                                  .process299:
  7497 0000272A E837F5                   call syntaxerror
  7498                                  
  7499                                  ;-1210         return;
  7500                                  
  7501 0000272D E93505                   jmp .retnprocess
  7502                                  
  7503                                  ;-1211     }
  7504                                  
  7505                                  
  7506                                  ;-1212 
  7507                                  
  7508                                  
  7509                                  ;-1213     if (CodeType == 6) {//Jcc
  7510                                  
  7511                                  .process280:
  7512 00002730 A0[2F00]                 mov al, [CodeType]
  7513 00002733 3C06                     cmp al, 6
  7514 00002735 0F85BE00                 jne .process301
  7515                                  
  7516                                  ;-1214         if (TokeType == ALNUME) {
  7517                                  
  7518 00002739 A0[2C00]                 mov al, [TokeType]
  7519 0000273C 3C03                     cmp al, 3
  7520 0000273E 0F85B500                 jne .process302
  7521                                  
  7522                                  ;-1215             LabelIx=searchLabel();
  7523                                  
  7524 00002742 E83DE5                   call searchLabel
  7525 00002745 A3[4E00]                 mov word [LabelIx], ax
  7526                                  
  7527                                  ;-1216             if (LabelIx > 0) {
  7528                                  
  7529 00002748 A1[4E00]                 mov ax, [LabelIx]
  7530 0000274B 83F800                   cmp ax, 0
  7531 0000274E 0F8E7A00                 jle .process303
  7532                                  
  7533                                  ;-1217                 disp=LabelAddr[LabelIx];
  7534                                  
  7535 00002752 8B1E[4E00]               mov bx, [LabelIx]
  7536 00002756 D1E3                     shl bx, 1
  7537 00002758 8B87CA8E                 mov ax, [LabelAddr + bx]
  7538 0000275C A3[3D00]                 mov word [disp], ax
  7539                                  
  7540                                  ;-1218                 disp = disp - PC;
  7541                                  
  7542 0000275F A1[3D00]                 mov ax, [disp]
  7543 00002762 2B06[2300]               sub ax, [PC]
  7544 00002766 A3[3D00]                 mov word [disp], ax
  7545                                  
  7546                                  ;-1219                 disp = disp - Origin;
  7547                                  
  7548 00002769 A1[3D00]                 mov ax, [disp]
  7549 0000276C 2B06[2500]               sub ax, [Origin]
  7550 00002770 A3[3D00]                 mov word [disp], ax
  7551                                  
  7552                                  ;-1220                 if (checkConstSize(disp) ) {
  7553                                  
  7554 00002773 FF36[3D00]               push word [disp]
  7555 00002777 E809E2                   call checkConstSize
  7556 0000277A 83C402                   add  sp, 2
  7557 0000277D 08C0                     or  al, al
  7558 0000277F 0F842000                 je .process304
  7559                                  
  7560                                  ;-1221                     genCode2(Code1, 0x70);//short
  7561                                  
  7562 00002783 6A70                     push 112
  7563 00002785 A0[3000]                 mov al, byte [Code1]
  7564 00002788 B400                     mov ah, 0
  7565 0000278A 50                       push ax
  7566 0000278B E8DFF9                   call genCode2
  7567 0000278E 83C404                   add  sp, 4
  7568                                  
  7569                                  ;-1222                     disp -= 2;
  7570                                  
  7571 00002791 832E[3D00]02             sub  word[disp], 2
  7572                                  
  7573                                  ;-1223                     genCode8(disp);
  7574                                  
  7575 00002796 FF36[3D00]               push word [disp]
  7576 0000279A E807FA                   call genCode8
  7577 0000279D 83C402                   add  sp, 2
  7578                                  
  7579                                  ;-1224                 } else {
  7580                                  
  7581 000027A0 E92600                   jmp .process305
  7582                                  .process304:
  7583                                  
  7584                                  ;-1225                     genCode8(0x0F);
  7585                                  
  7586 000027A3 6A0F                     push 15
  7587 000027A5 E8FCF9                   call genCode8
  7588 000027A8 83C402                   add  sp, 2
  7589                                  
  7590                                  ;-1226                     genCode2(Code1, 0x80);//near
  7591                                  
  7592 000027AB 688000                   push 128
  7593 000027AE A0[3000]                 mov al, byte [Code1]
  7594 000027B1 B400                     mov ah, 0
  7595 000027B3 50                       push ax
  7596 000027B4 E8B6F9                   call genCode2
  7597 000027B7 83C404                   add  sp, 4
  7598                                  
  7599                                  ;-1227                     disp -= 4;
  7600                                  
  7601 000027BA 832E[3D00]04             sub  word[disp], 4
  7602                                  
  7603                                  ;-1228                     genCode16(disp);
  7604                                  
  7605 000027BF FF36[3D00]               push word [disp]
  7606 000027C3 E835FA                   call genCode16
  7607 000027C6 83C402                   add  sp, 2
  7608                                  
  7609                                  ;-1229                 }
  7610                                  
  7611                                  
  7612                                  ;-1230             }
  7613                                  
  7614                                  .process305:
  7615                                  
  7616                                  ;-1231             else {//jump forward, near only
  7617                                  
  7618 000027C9 E92800                   jmp .process306
  7619                                  .process303:
  7620                                  
  7621                                  ;-1232                 genCode8(0x0F);
  7622                                  
  7623 000027CC 6A0F                     push 15
  7624 000027CE E8D3F9                   call genCode8
  7625 000027D1 83C402                   add  sp, 2
  7626                                  
  7627                                  ;-1233                 genCode2(Code1, 0x80);
  7628                                  
  7629 000027D4 688000                   push 128
  7630 000027D7 A0[3000]                 mov al, byte [Code1]
  7631 000027DA B400                     mov ah, 0
  7632 000027DC 50                       push ax
  7633 000027DD E88DF9                   call genCode2
  7634 000027E0 83C404                   add  sp, 4
  7635                                  
  7636                                  ;-1234                 genCode16(0);
  7637                                  
  7638 000027E3 6A00                     push 0
  7639 000027E5 E813FA                   call genCode16
  7640 000027E8 83C402                   add  sp, 2
  7641                                  
  7642                                  ;-1235                 PrintRA='r';
  7643                                  
  7644 000027EB B87200                   mov ax, 114
  7645 000027EE A2[4500]                 mov byte [PrintRA], al
  7646                                  
  7647                                  ;-1236                 storeJmpCall();
  7648                                  
  7649 000027F1 E860E3                   call storeJmpCall
  7650                                  
  7651                                  ;-1237             }
  7652                                  
  7653                                  
  7654                                  ;-1238         return;
  7655                                  
  7656                                  .process306:
  7657 000027F4 E96E04                   jmp .retnprocess
  7658                                  
  7659                                  ;-1239         }
  7660                                  
  7661                                  
  7662                                  ;-1240     }
  7663                                  
  7664                                  .process302:
  7665                                  
  7666                                  ;-1241 
  7667                                  
  7668                                  
  7669                                  ;-1242     if (CodeType == 7) {//jmp, call
  7670                                  
  7671                                  .process301:
  7672 000027F7 A0[2F00]                 mov al, [CodeType]
  7673 000027FA 3C07                     cmp al, 7
  7674 000027FC 0F85CA00                 jne .process307
  7675                                  
  7676                                  ;-1243         if (TokeType == ALNUME) {
  7677                                  
  7678 00002800 A0[2C00]                 mov al, [TokeType]
  7679 00002803 3C03                     cmp al, 3
  7680 00002805 0F85C100                 jne .process308
  7681                                  
  7682                                  ;-1244             LabelIx=searchLabel();
  7683                                  
  7684 00002809 E876E4                   call searchLabel
  7685 0000280C A3[4E00]                 mov word [LabelIx], ax
  7686                                  
  7687                                  ;-1245             if (LabelIx > 0) {
  7688                                  
  7689 0000280F A1[4E00]                 mov ax, [LabelIx]
  7690 00002812 83F800                   cmp ax, 0
  7691 00002815 0F8E9100                 jle .process309
  7692                                  
  7693                                  ;-1246                 disp=LabelAddr[LabelIx];
  7694                                  
  7695 00002819 8B1E[4E00]               mov bx, [LabelIx]
  7696 0000281D D1E3                     shl bx, 1
  7697 0000281F 8B87CA8E                 mov ax, [LabelAddr + bx]
  7698 00002823 A3[3D00]                 mov word [disp], ax
  7699                                  
  7700                                  ;-1247                 disp = disp - PC;
  7701                                  
  7702 00002826 A1[3D00]                 mov ax, [disp]
  7703 00002829 2B06[2300]               sub ax, [PC]
  7704 0000282D A3[3D00]                 mov word [disp], ax
  7705                                  
  7706                                  ;-1248                 disp = disp - Origin;
  7707                                  
  7708 00002830 A1[3D00]                 mov ax, [disp]
  7709 00002833 2B06[2500]               sub ax, [Origin]
  7710 00002837 A3[3D00]                 mov word [disp], ax
  7711                                  
  7712                                  ;-1249                 if (checkConstSize(disp) ) {
  7713                                  
  7714 0000283A FF36[3D00]               push word [disp]
  7715 0000283E E842E1                   call checkConstSize
  7716 00002841 83C402                   add  sp, 2
  7717 00002844 08C0                     or  al, al
  7718 00002846 0F844200                 je .process310
  7719                                  
  7720                                  ;-1250                     if (Code1 == 0xE9) {//jmp only
  7721                                  
  7722 0000284A A0[3000]                 mov al, [Code1]
  7723 0000284D 3CE9                     cmp al, 233
  7724 0000284F 0F851B00                 jne .process311
  7725                                  
  7726                                  ;-1251                         genCode8(0xEB);//short
  7727                                  
  7728 00002853 68EB00                   push 235
  7729 00002856 E84BF9                   call genCode8
  7730 00002859 83C402                   add  sp, 2
  7731                                  
  7732                                  ;-1252                         disp -= 2;
  7733                                  
  7734 0000285C 832E[3D00]02             sub  word[disp], 2
  7735                                  
  7736                                  ;-1253                         genCode8(disp);
  7737                                  
  7738 00002861 FF36[3D00]               push word [disp]
  7739 00002865 E83CF9                   call genCode8
  7740 00002868 83C402                   add  sp, 2
  7741                                  
  7742                                  ;-1254                     }
  7743                                  
  7744                                  
  7745                                  ;-1255                     else {
  7746                                  
  7747 0000286B E91B00                   jmp .process312
  7748                                  .process311:
  7749                                  
  7750                                  ;-1256                         genCode8(Code1);//near
  7751                                  
  7752 0000286E A0[3000]                 mov al, byte [Code1]
  7753 00002871 B400                     mov ah, 0
  7754 00002873 50                       push ax
  7755 00002874 E82DF9                   call genCode8
  7756 00002877 83C402                   add  sp, 2
  7757                                  
  7758                                  ;-1257                         disp -= 3;
  7759                                  
  7760 0000287A 832E[3D00]03             sub  word[disp], 3
  7761                                  
  7762                                  ;-1258                         genCode16(disp);
  7763                                  
  7764 0000287F FF36[3D00]               push word [disp]
  7765 00002883 E875F9                   call genCode16
  7766 00002886 83C402                   add  sp, 2
  7767                                  
  7768                                  ;-1259                     }
  7769                                  
  7770                                  
  7771                                  ;-1260                 }
  7772                                  
  7773                                  .process312:
  7774                                  
  7775                                  ;-1261                 else {
  7776                                  
  7777 00002889 E91B00                   jmp .process313
  7778                                  .process310:
  7779                                  
  7780                                  ;-1262                     genCode8(Code1);//near
  7781                                  
  7782 0000288C A0[3000]                 mov al, byte [Code1]
  7783 0000288F B400                     mov ah, 0
  7784 00002891 50                       push ax
  7785 00002892 E80FF9                   call genCode8
  7786 00002895 83C402                   add  sp, 2
  7787                                  
  7788                                  ;-1263                     disp -= 3;
  7789                                  
  7790 00002898 832E[3D00]03             sub  word[disp], 3
  7791                                  
  7792                                  ;-1264                     genCode16(disp);
  7793                                  
  7794 0000289D FF36[3D00]               push word [disp]
  7795 000028A1 E857F9                   call genCode16
  7796 000028A4 83C402                   add  sp, 2
  7797                                  
  7798                                  ;-1265                 }
  7799                                  
  7800                                  
  7801                                  ;-1266             }
  7802                                  
  7803                                  .process313:
  7804                                  
  7805                                  ;-1267             else {//jump forward, near only
  7806                                  
  7807 000028A7 E91D00                   jmp .process314
  7808                                  .process309:
  7809                                  
  7810                                  ;-1268                 genCode8(Code1);
  7811                                  
  7812 000028AA A0[3000]                 mov al, byte [Code1]
  7813 000028AD B400                     mov ah, 0
  7814 000028AF 50                       push ax
  7815 000028B0 E8F1F8                   call genCode8
  7816 000028B3 83C402                   add  sp, 2
  7817                                  
  7818                                  ;-1269                 genCode16(0);
  7819                                  
  7820 000028B6 6A00                     push 0
  7821 000028B8 E840F9                   call genCode16
  7822 000028BB 83C402                   add  sp, 2
  7823                                  
  7824                                  ;-1270                 PrintRA='R';
  7825                                  
  7826 000028BE B85200                   mov ax, 82
  7827 000028C1 A2[4500]                 mov byte [PrintRA], al
  7828                                  
  7829                                  ;-1271                 storeJmpCall();
  7830                                  
  7831 000028C4 E88DE2                   call storeJmpCall
  7832                                  
  7833                                  ;-1272             }
  7834                                  
  7835                                  
  7836                                  ;-1273         return;
  7837                                  
  7838                                  .process314:
  7839 000028C7 E99B03                   jmp .retnprocess
  7840                                  
  7841                                  ;-1274         }
  7842                                  
  7843                                  
  7844                                  ;-1275     }
  7845                                  
  7846                                  .process308:
  7847                                  
  7848                                  ;-1276 
  7849                                  
  7850                                  
  7851                                  ;-1277     if (CodeType ==  8) {//ret,retf
  7852                                  
  7853                                  .process307:
  7854 000028CA A0[2F00]                 mov al, [CodeType]
  7855 000028CD 3C08                     cmp al, 8
  7856 000028CF 0F853100                 jne .process315
  7857                                  
  7858                                  ;-1278         if (TokeType == DIGIT) {
  7859                                  
  7860 000028D3 A0[2C00]                 mov al, [TokeType]
  7861 000028D6 3C01                     cmp al, 1
  7862 000028D8 0F851900                 jne .process316
  7863                                  
  7864                                  ;-1279             genCode8(Code2);
  7865                                  
  7866 000028DC A0[3100]                 mov al, byte [Code2]
  7867 000028DF B400                     mov ah, 0
  7868 000028E1 50                       push ax
  7869 000028E2 E8BFF8                   call genCode8
  7870 000028E5 83C402                   add  sp, 2
  7871                                  
  7872                                  ;-1280             genCode16(SymbolInt);
  7873                                  
  7874 000028E8 FF36[0E00]               push word [SymbolInt]
  7875 000028EC E80CF9                   call genCode16
  7876 000028EF 83C402                   add  sp, 2
  7877                                  
  7878                                  ;-1281             return;
  7879                                  
  7880 000028F2 E97003                   jmp .retnprocess
  7881                                  
  7882                                  ;-1282         }
  7883                                  
  7884                                  
  7885                                  ;-1283         genCode8(Code1);
  7886                                  
  7887                                  .process316:
  7888 000028F5 A0[3000]                 mov al, byte [Code1]
  7889 000028F8 B400                     mov ah, 0
  7890 000028FA 50                       push ax
  7891 000028FB E8A6F8                   call genCode8
  7892 000028FE 83C402                   add  sp, 2
  7893                                  
  7894                                  ;-1284         return;
  7895                                  
  7896 00002901 E96103                   jmp .retnprocess
  7897                                  
  7898                                  ;-1285     }
  7899                                  
  7900                                  
  7901                                  ;-1286 
  7902                                  
  7903                                  
  7904                                  ;-1287     if (CodeType == 9) {//push, pop
  7905                                  
  7906                                  .process315:
  7907 00002904 A0[2F00]                 mov al, [CodeType]
  7908 00002907 3C09                     cmp al, 9
  7909 00002909 0F854B01                 jne .process317
  7910                                  
  7911                                  ;-1288         getOpL();
  7912                                  
  7913 0000290D E8F6DC                   call getOpL
  7914                                  
  7915                                  ;-1289         if (Code1 == 0x50) {//push only
  7916                                  
  7917 00002910 A0[3000]                 mov al, [Code1]
  7918 00002913 3C50                     cmp al, 80
  7919 00002915 0F858500                 jne .process318
  7920                                  
  7921                                  ;-1290             if (Op == IMM) {//push imm8,16
  7922                                  
  7923 00002919 A0[2D00]                 mov al, [Op]
  7924 0000291C 3C01                     cmp al, 1
  7925 0000291E 0F853400                 jne .process319
  7926                                  
  7927                                  ;-1291                 setsflag();
  7928                                  
  7929 00002922 E802E0                   call setsflag
  7930                                  
  7931                                  ;-1292                 genCode2(0x68, sflag);
  7932                                  
  7933 00002925 A0[3A00]                 mov al, byte [sflag]
  7934 00002928 B400                     mov ah, 0
  7935 0000292A 50                       push ax
  7936 0000292B 6A68                     push 104
  7937 0000292D E83DF8                   call genCode2
  7938 00002930 83C404                   add  sp, 4
  7939                                  
  7940                                  ;-1293                 if (sflag) genCode8 (imme);
  7941                                  
  7942 00002933 A0[3A00]                 mov al, [sflag]
  7943 00002936 08C0                     or  al, al
  7944 00002938 0F840D00                 je .process320
  7945 0000293C FF36[3F00]               push word [imme]
  7946 00002940 E861F8                   call genCode8
  7947 00002943 83C402                   add  sp, 2
  7948                                  
  7949                                  ;-1294                 else       genCode16(imme);
  7950                                  
  7951 00002946 E90A00                   jmp .process321
  7952                                  .process320:
  7953 00002949 FF36[3F00]               push word [imme]
  7954 0000294D E8ABF8                   call genCode16
  7955 00002950 83C402                   add  sp, 2
  7956                                  
  7957                                  ;-1295                 return;
  7958                                  
  7959                                  .process321:
  7960 00002953 E90F03                   jmp .retnprocess
  7961                                  
  7962                                  ;-1296             }
  7963                                  
  7964                                  
  7965                                  ;-1297             if (Op == ADR) {//push string ABSOLUTE i16
  7966                                  
  7967                                  .process319:
  7968 00002956 A0[2D00]                 mov al, [Op]
  7969 00002959 3C03                     cmp al, 3
  7970 0000295B 0F853F00                 jne .process322
  7971                                  
  7972                                  ;-1298                 if (disp) {
  7973                                  
  7974 0000295F A1[3D00]                 mov ax, [disp]
  7975 00002962 08C0                     or  al, al
  7976 00002964 0F841800                 je .process323
  7977                                  
  7978                                  ;-1299                     genCode8(0x68);
  7979                                  
  7980 00002968 6A68                     push 104
  7981 0000296A E837F8                   call genCode8
  7982 0000296D 83C402                   add  sp, 2
  7983                                  
  7984                                  ;-1300                     genCode16(disp);
  7985                                  
  7986 00002970 FF36[3D00]               push word [disp]
  7987 00002974 E884F8                   call genCode16
  7988 00002977 83C402                   add  sp, 2
  7989                                  
  7990                                  ;-1301                     return;
  7991                                  
  7992 0000297A E9E802                   jmp .retnprocess
  7993                                  
  7994                                  ;-1302                 }
  7995                                  
  7996                                  
  7997                                  ;-1303                 else {
  7998                                  
  7999 0000297D E91E00                   jmp .process324
  8000                                  .process323:
  8001                                  
  8002                                  ;-1304                     genCode8(0x68);
  8003                                  
  8004 00002980 6A68                     push 104
  8005 00002982 E81FF8                   call genCode8
  8006 00002985 83C402                   add  sp, 2
  8007                                  
  8008                                  ;-1305                     genCode8(65);//'A'
  8009                                  
  8010 00002988 6A41                     push 65
  8011 0000298A E817F8                   call genCode8
  8012 0000298D 83C402                   add  sp, 2
  8013                                  
  8014                                  ;-1306                     genCode8(65);
  8015                                  
  8016 00002990 6A41                     push 65
  8017 00002992 E80FF8                   call genCode8
  8018 00002995 83C402                   add  sp, 2
  8019                                  
  8020                                  ;-1307                     PrintRA='A';
  8021                                  
  8022 00002998 B84100                   mov ax, 65
  8023 0000299B A2[4500]                 mov byte [PrintRA], al
  8024                                  
  8025                                  ;-1308 //todo store Adr of push code, as storeJmpCall
  8026                                  
  8027                                  
  8028                                  ;-1309 
  8029                                  
  8030                                  
  8031                                  ;-1310                 }
  8032                                  
  8033                                  
  8034                                  ;-1311             }
  8035                                  
  8036                                  .process324:
  8037                                  
  8038                                  ;-1312         }
  8039                                  
  8040                                  .process322:
  8041                                  
  8042                                  ;-1313         if (R1Type == SEGREG) {
  8043                                  
  8044                                  .process318:
  8045 0000299E A0[3600]                 mov al, [R1Type]
  8046 000029A1 3C04                     cmp al, 4
  8047 000029A3 0F855A00                 jne .process325
  8048                                  
  8049                                  ;-1314             if (Code1 == 0x58) {//pop only
  8050                                  
  8051 000029A7 A0[3000]                 mov al, [Code1]
  8052 000029AA 3C58                     cmp al, 88
  8053 000029AC 0F851200                 jne .process326
  8054                                  
  8055                                  ;-1315                 if (R1No == 1) error1("pop cs not allowed");
  8056                                  
  8057 000029B0 A0[3400]                 mov al, [R1No]
  8058 000029B3 3C01                     cmp al, 1
  8059 000029B5 0F850900                 jne .process327
  8060 000029B9 68[672C]                 push process_0
  8061 000029BC E8D2F0                   call error1
  8062 000029BF 83C402                   add  sp, 2
  8063                                  
  8064                                  ;-1316             }
  8065                                  
  8066                                  .process327:
  8067                                  
  8068                                  ;-1317             c = R1No <<3;
  8069                                  
  8070                                  .process326:
  8071 000029C2 A0[3400]                 mov al, [R1No]
  8072 000029C5 C0E003                   shl al, 3
  8073 000029C8 8846FE                   mov [bp-2], al
  8074                                  
  8075                                  ;-1318             if (R1No > 3) {//FS, GS
  8076                                  
  8077 000029CB A0[3400]                 mov al, [R1No]
  8078 000029CE 3C03                     cmp al, 3
  8079 000029D0 0F8E0C00                 jle .process328
  8080                                  
  8081                                  ;-1319                 c += 122;
  8082                                  
  8083 000029D4 8046FE7A                 add  byte[bp-2], 122
  8084                                  
  8085                                  ;-1320                 genCode8(0x0F);
  8086                                  
  8087 000029D8 6A0F                     push 15
  8088 000029DA E8C7F7                   call genCode8
  8089 000029DD 83C402                   add  sp, 2
  8090                                  
  8091                                  ;-1321             }
  8092                                  
  8093                                  
  8094                                  ;-1322             OpCodePtr++;
  8095                                  
  8096                                  .process328:
  8097 000029E0 FF06[4300]               inc  word[OpCodePtr]
  8098                                  
  8099                                  ;-1323             c = c + *OpCodePtr;//is Code4
  8100                                  
  8101 000029E4 8A46FE                   mov al, [bp-2]
  8102 000029E7 8B1E[4300]               mov bx, [OpCodePtr]
  8103 000029EB 0207                     add al, [bx]
  8104 000029ED B400                     mov ah, 0
  8105 000029EF 8846FE                   mov [bp-2], al
  8106                                  
  8107                                  ;-1324             genCode8(c);
  8108                                  
  8109 000029F2 8A46FE                   mov al, byte [bp-2]
  8110 000029F5 B400                     mov ah, 0
  8111 000029F7 50                       push ax
  8112 000029F8 E8A9F7                   call genCode8
  8113 000029FB 83C402                   add  sp, 2
  8114                                  
  8115                                  ;-1325             return;
  8116                                  
  8117 000029FE E96402                   jmp .retnprocess
  8118                                  
  8119                                  ;-1326         }
  8120                                  
  8121                                  
  8122                                  ;-1327         checkOpL();//no ADR, SEGREG
  8123                                  
  8124                                  .process325:
  8125 00002A01 E825DB                   call checkOpL
  8126                                  
  8127                                  ;-1328         if (R1Type == BYTE) reg16error();
  8128                                  
  8129 00002A04 A0[3600]                 mov al, [R1Type]
  8130 00002A07 3C01                     cmp al, 1
  8131 00002A09 0F850300                 jne .process329
  8132 00002A0D E805F2                   call reg16error
  8133                                  
  8134                                  ;-1329         if (R1Type == WORD) {
  8135                                  
  8136                                  .process329:
  8137 00002A10 A0[3600]                 mov al, [R1Type]
  8138 00002A13 3C02                     cmp al, 2
  8139 00002A15 0F851500                 jne .process330
  8140                                  
  8141                                  ;-1330             genCode2(Code1, R1No);
  8142                                  
  8143 00002A19 A0[3400]                 mov al, byte [R1No]
  8144 00002A1C B400                     mov ah, 0
  8145 00002A1E 50                       push ax
  8146 00002A1F A0[3000]                 mov al, byte [Code1]
  8147 00002A22 B400                     mov ah, 0
  8148 00002A24 50                       push ax
  8149 00002A25 E845F7                   call genCode2
  8150 00002A28 83C404                   add  sp, 4
  8151                                  
  8152                                  ;-1331             return;
  8153                                  
  8154 00002A2B E93702                   jmp .retnprocess
  8155                                  
  8156                                  ;-1332         }
  8157                                  
  8158                                  
  8159                                  ;-1333         if (Op == MEM) {
  8160                                  
  8161                                  .process330:
  8162 00002A2E A0[2D00]                 mov al, [Op]
  8163 00002A31 3C04                     cmp al, 4
  8164 00002A33 0F851B00                 jne .process331
  8165                                  
  8166                                  ;-1334             genCode8(Code2);
  8167                                  
  8168 00002A37 A0[3100]                 mov al, byte [Code2]
  8169 00002A3A B400                     mov ah, 0
  8170 00002A3C 50                       push ax
  8171 00002A3D E864F7                   call genCode8
  8172 00002A40 83C402                   add  sp, 2
  8173                                  
  8174                                  ;-1335             writeEA(Code3);
  8175                                  
  8176 00002A43 A0[3200]                 mov al, byte [Code3]
  8177 00002A46 B400                     mov ah, 0
  8178 00002A48 50                       push ax
  8179 00002A49 E8FAF7                   call writeEA
  8180 00002A4C 83C402                   add  sp, 2
  8181                                  
  8182                                  ;-1336             return;
  8183                                  
  8184 00002A4F E91302                   jmp .retnprocess
  8185                                  
  8186                                  ;-1337         }
  8187                                  
  8188                                  
  8189                                  ;-1338         syntaxerror();
  8190                                  
  8191                                  .process331:
  8192 00002A52 E80FF2                   call syntaxerror
  8193                                  
  8194                                  ;-1339         return;
  8195                                  
  8196 00002A55 E90D02                   jmp .retnprocess
  8197                                  
  8198                                  ;-1340     }
  8199                                  
  8200                                  
  8201                                  ;-1341 
  8202                                  
  8203                                  
  8204                                  ;-1342     if (CodeType == 11) {//shift, rotate
  8205                                  
  8206                                  .process317:
  8207 00002A58 A0[2F00]                 mov al, [CodeType]
  8208 00002A5B 3C0B                     cmp al, 11
  8209 00002A5D 0F859200                 jne .process332
  8210                                  
  8211                                  ;-1343         check2Ops();
  8212                                  
  8213 00002A61 E847DB                   call check2Ops
  8214                                  
  8215                                  ;-1344         if (Op2 == IMM) {
  8216                                  
  8217 00002A64 A0[2E00]                 mov al, [Op2]
  8218 00002A67 3C01                     cmp al, 1
  8219 00002A69 0F854400                 jne .process333
  8220                                  
  8221                                  ;-1345             if (imme == 1) {
  8222                                  
  8223 00002A6D A1[3F00]                 mov ax, [imme]
  8224 00002A70 83F801                   cmp ax, 1
  8225 00002A73 0F851800                 jne .process334
  8226                                  
  8227                                  ;-1346                 genCodeW(0xD0);
  8228                                  
  8229 00002A77 68D000                   push 208
  8230 00002A7A E80BF7                   call genCodeW
  8231 00002A7D 83C402                   add  sp, 2
  8232                                  
  8233                                  ;-1347                 writeEA(Code1);
  8234                                  
  8235 00002A80 A0[3000]                 mov al, byte [Code1]
  8236 00002A83 B400                     mov ah, 0
  8237 00002A85 50                       push ax
  8238 00002A86 E8BDF7                   call writeEA
  8239 00002A89 83C402                   add  sp, 2
  8240                                  
  8241                                  ;-1348                 return;
  8242                                  
  8243 00002A8C E9D601                   jmp .retnprocess
  8244                                  
  8245                                  ;-1349             }
  8246                                  
  8247                                  
  8248                                  ;-1350             genCodeW(0xC0);//80186
  8249                                  
  8250                                  .process334:
  8251 00002A8F 68C000                   push 192
  8252 00002A92 E8F3F6                   call genCodeW
  8253 00002A95 83C402                   add  sp, 2
  8254                                  
  8255                                  ;-1351             writeEA(Code1);
  8256                                  
  8257 00002A98 A0[3000]                 mov al, byte [Code1]
  8258 00002A9B B400                     mov ah, 0
  8259 00002A9D 50                       push ax
  8260 00002A9E E8A5F7                   call writeEA
  8261 00002AA1 83C402                   add  sp, 2
  8262                                  
  8263                                  ;-1352             genCode8(imme);
  8264                                  
  8265 00002AA4 FF36[3F00]               push word [imme]
  8266 00002AA8 E8F9F6                   call genCode8
  8267 00002AAB 83C402                   add  sp, 2
  8268                                  
  8269                                  ;-1353             return;
  8270                                  
  8271 00002AAE E9B401                   jmp .retnprocess
  8272                                  
  8273                                  ;-1354         }
  8274                                  
  8275                                  
  8276                                  ;-1355         if (Op2 == REG) {
  8277                                  
  8278                                  .process333:
  8279 00002AB1 A0[2E00]                 mov al, [Op2]
  8280 00002AB4 3C02                     cmp al, 2
  8281 00002AB6 0F853900                 jne .process335
  8282                                  
  8283                                  ;-1356             if (R2Type == BYTE) {
  8284                                  
  8285 00002ABA A0[3500]                 mov al, [R2Type]
  8286 00002ABD 3C01                     cmp al, 1
  8287 00002ABF 0F853000                 jne .process336
  8288                                  
  8289                                  ;-1357                 if (R2No == 1) {//CL-REG
  8290                                  
  8291 00002AC3 A0[3300]                 mov al, [R2No]
  8292 00002AC6 3C01                     cmp al, 1
  8293 00002AC8 0F852700                 jne .process337
  8294                                  
  8295                                  ;-1358                     if (R1Type == WORD) wflag=1;//hack
  8296                                  
  8297 00002ACC A0[3600]                 mov al, [R1Type]
  8298 00002ACF 3C02                     cmp al, 2
  8299 00002AD1 0F850600                 jne .process338
  8300 00002AD5 B80100                   mov ax, 1
  8301 00002AD8 A2[3800]                 mov byte [wflag], al
  8302                                  
  8303                                  ;-1359                     genCodeW(0xD2);
  8304                                  
  8305                                  .process338:
  8306 00002ADB 68D200                   push 210
  8307 00002ADE E8A7F6                   call genCodeW
  8308 00002AE1 83C402                   add  sp, 2
  8309                                  
  8310                                  ;-1360                     writeEA(Code1);
  8311                                  
  8312 00002AE4 A0[3000]                 mov al, byte [Code1]
  8313 00002AE7 B400                     mov ah, 0
  8314 00002AE9 50                       push ax
  8315 00002AEA E859F7                   call writeEA
  8316 00002AED 83C402                   add  sp, 2
  8317                                  
  8318                                  ;-1361                     return;
  8319                                  
  8320 00002AF0 E97201                   jmp .retnprocess
  8321                                  
  8322                                  ;-1362                 }
  8323                                  
  8324                                  
  8325                                  ;-1363             }
  8326                                  
  8327                                  .process337:
  8328                                  
  8329                                  ;-1364         }
  8330                                  
  8331                                  .process336:
  8332                                  
  8333                                  ;-1365     }
  8334                                  
  8335                                  .process335:
  8336                                  
  8337                                  ;-1366 
  8338                                  
  8339                                  
  8340                                  ;-1367     if (CodeType == 12) {//int
  8341                                  
  8342                                  .process332:
  8343 00002AF3 A0[2F00]                 mov al, [CodeType]
  8344 00002AF6 3C0C                     cmp al, 12
  8345 00002AF8 0F852200                 jne .process339
  8346                                  
  8347                                  ;-1368         if (TokeType == DIGIT) {
  8348                                  
  8349 00002AFC A0[2C00]                 mov al, [TokeType]
  8350 00002AFF 3C01                     cmp al, 1
  8351 00002B01 0F851900                 jne .process340
  8352                                  
  8353                                  ;-1369             genCode8(Code1);
  8354                                  
  8355 00002B05 A0[3000]                 mov al, byte [Code1]
  8356 00002B08 B400                     mov ah, 0
  8357 00002B0A 50                       push ax
  8358 00002B0B E896F6                   call genCode8
  8359 00002B0E 83C402                   add  sp, 2
  8360                                  
  8361                                  ;-1370             genCode8(SymbolInt);
  8362                                  
  8363 00002B11 FF36[0E00]               push word [SymbolInt]
  8364 00002B15 E88CF6                   call genCode8
  8365 00002B18 83C402                   add  sp, 2
  8366                                  
  8367                                  ;-1371             return;
  8368                                  
  8369 00002B1B E94701                   jmp .retnprocess
  8370                                  
  8371                                  ;-1372         }
  8372                                  
  8373                                  
  8374                                  ;-1373     }
  8375                                  
  8376                                  .process340:
  8377                                  
  8378                                  ;-1374 
  8379                                  
  8380                                  
  8381                                  ;-1375     if (CodeType == 30) {//enter i18,i8
  8382                                  
  8383                                  .process339:
  8384 00002B1E A0[2F00]                 mov al, [CodeType]
  8385 00002B21 3C1E                     cmp al, 30
  8386 00002B23 0F855200                 jne .process341
  8387                                  
  8388                                  ;-1376         genCode8(0xC8);
  8389                                  
  8390 00002B27 68C800                   push 200
  8391 00002B2A E877F6                   call genCode8
  8392 00002B2D 83C402                   add  sp, 2
  8393                                  
  8394                                  ;-1377         Op=getOp1();
  8395                                  
  8396 00002B30 E884DB                   call getOp1
  8397 00002B33 A2[2D00]                 mov byte [Op], al
  8398                                  
  8399                                  ;-1378         if (Op == IMM) genCode16(SymbolInt);
  8400                                  
  8401 00002B36 A0[2D00]                 mov al, [Op]
  8402 00002B39 3C01                     cmp al, 1
  8403 00002B3B 0F850D00                 jne .process342
  8404 00002B3F FF36[0E00]               push word [SymbolInt]
  8405 00002B43 E8B5F6                   call genCode16
  8406 00002B46 83C402                   add  sp, 2
  8407                                  
  8408                                  ;-1379         else numbererror();
  8409                                  
  8410 00002B49 E90300                   jmp .process343
  8411                                  .process342:
  8412 00002B4C E882F0                   call numbererror
  8413                                  
  8414                                  ;-1380         need(',');
  8415                                  
  8416                                  .process343:
  8417 00002B4F 6A2C                     push 44
  8418 00002B51 E8BAE3                   call need
  8419 00002B54 83C402                   add  sp, 2
  8420                                  
  8421                                  ;-1381         Op=getOp1();
  8422                                  
  8423 00002B57 E85DDB                   call getOp1
  8424 00002B5A A2[2D00]                 mov byte [Op], al
  8425                                  
  8426                                  ;-1382         if (Op == IMM) genCode8 (SymbolInt);
  8427                                  
  8428 00002B5D A0[2D00]                 mov al, [Op]
  8429 00002B60 3C01                     cmp al, 1
  8430 00002B62 0F850D00                 jne .process344
  8431 00002B66 FF36[0E00]               push word [SymbolInt]
  8432 00002B6A E837F6                   call genCode8
  8433 00002B6D 83C402                   add  sp, 2
  8434                                  
  8435                                  ;-1383         else numbererror();
  8436                                  
  8437 00002B70 E90300                   jmp .process345
  8438                                  .process344:
  8439 00002B73 E85BF0                   call numbererror
  8440                                  
  8441                                  ;-1384         return;
  8442                                  
  8443                                  .process345:
  8444 00002B76 E9EC00                   jmp .retnprocess
  8445                                  
  8446                                  ;-1385     }
  8447                                  
  8448                                  
  8449                                  ;-1386 
  8450                                  
  8451                                  
  8452                                  ;-1387     if (CodeType==101) {//ORG nn
  8453                                  
  8454                                  .process341:
  8455 00002B79 A0[2F00]                 mov al, [CodeType]
  8456 00002B7C 3C65                     cmp al, 101
  8457 00002B7E 0F851500                 jne .process346
  8458                                  
  8459                                  ;-1388         if (TokeType != DIGIT) numbererror();
  8460                                  
  8461 00002B82 A0[2C00]                 mov al, [TokeType]
  8462 00002B85 3C01                     cmp al, 1
  8463 00002B87 0F840300                 je  .process347
  8464 00002B8B E843F0                   call numbererror
  8465                                  
  8466                                  ;-1389         Origin=SymbolInt;
  8467                                  
  8468                                  .process347:
  8469 00002B8E A1[0E00]                 mov ax, [SymbolInt]
  8470 00002B91 A3[2500]                 mov word [Origin], ax
  8471                                  
  8472                                  ;-1390         return;
  8473                                  
  8474 00002B94 E9CE00                   jmp .retnprocess
  8475                                  
  8476                                  ;-1391     }
  8477                                  
  8478                                  
  8479                                  ;-1392 
  8480                                  
  8481                                  
  8482                                  ;-1393     if (CodeType == 102) {//section, segment
  8483                                  
  8484                                  .process346:
  8485 00002B97 A0[2F00]                 mov al, [CodeType]
  8486 00002B9A 3C66                     cmp al, 102
  8487 00002B9C 0F850900                 jne .process348
  8488                                  
  8489                                  ;-1394         //getTokeType();//ignore .bss .text .data
  8490                                  
  8491                                  
  8492                                  ;-1395         AbsoluteLab=0;//nasm resets erevy time
  8493                                  
  8494 00002BA0 B80000                   mov ax, 0
  8495 00002BA3 A3[2700]                 mov word [AbsoluteLab], ax
  8496                                  
  8497                                  ;-1396         return;
  8498                                  
  8499 00002BA6 E9BC00                   jmp .retnprocess
  8500                                  
  8501                                  ;-1397     }
  8502                                  
  8503                                  
  8504                                  ;-1398 
  8505                                  
  8506                                  
  8507                                  ;-1399     if (CodeType == 110) {//absolute
  8508                                  
  8509                                  .process348:
  8510 00002BA9 A0[2F00]                 mov al, [CodeType]
  8511 00002BAC 3C6E                     cmp al, 110
  8512 00002BAE 0F851500                 jne .process349
  8513                                  
  8514                                  ;-1400         if (TokeType != DIGIT) numbererror();
  8515                                  
  8516 00002BB2 A0[2C00]                 mov al, [TokeType]
  8517 00002BB5 3C01                     cmp al, 1
  8518 00002BB7 0F840300                 je  .process350
  8519 00002BBB E813F0                   call numbererror
  8520                                  
  8521                                  ;-1401         AbsoluteLab=SymbolInt;
  8522                                  
  8523                                  .process350:
  8524 00002BBE A1[0E00]                 mov ax, [SymbolInt]
  8525 00002BC1 A3[2700]                 mov word [AbsoluteLab], ax
  8526                                  
  8527                                  ;-1402         return;
  8528                                  
  8529 00002BC4 E99E00                   jmp .retnprocess
  8530                                  
  8531                                  ;-1403     }
  8532                                  
  8533                                  
  8534                                  ;-1404     if (CodeType == 111) {//name: PROC
  8535                                  
  8536                                  .process349:
  8537 00002BC7 A0[2F00]                 mov al, [CodeType]
  8538 00002BCA 3C6F                     cmp al, 111
  8539 00002BCC 0F854A00                 jne .process351
  8540                                  
  8541                                  ;-1405         if (isInProc == 0)  {
  8542                                  
  8543 00002BD0 A0[0D00]                 mov al, [isInProc]
  8544 00002BD3 3C00                     cmp al, 0
  8545 00002BD5 0F853500                 jne .process352
  8546                                  
  8547                                  ;-1406           prs("\n;entering: ");
  8548                                  
  8549 00002BD9 68[7A2C]                 push process_1
  8550 00002BDC E860ED                   call prs
  8551 00002BDF 83C402                   add  sp, 2
  8552                                  
  8553                                  ;-1407           prs(ProcName);
  8554                                  
  8555 00002BE2 8D066E75                 lea  ax, [ProcName]
  8556 00002BE6 50                       push ax
  8557 00002BE7 E855ED                   call prs
  8558 00002BEA 83C402                   add  sp, 2
  8559                                  
  8560                                  ;-1408           isInProc=1;
  8561                                  
  8562 00002BED B80100                   mov ax, 1
  8563 00002BF0 A2[0D00]                 mov byte [isInProc], al
  8564                                  
  8565                                  ;-1409           tmpLabelNamePtr = LabelNamePtr;
  8566                                  
  8567 00002BF3 A1[4600]                 mov ax, [LabelNamePtr]
  8568 00002BF6 A3[4800]                 mov word [tmpLabelNamePtr], ax
  8569                                  
  8570                                  ;-1410           tmpLabelMaxIx = LabelMaxIx;
  8571                                  
  8572 00002BF9 A1[4A00]                 mov ax, [LabelMaxIx]
  8573 00002BFC A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8574                                  
  8575                                  ;-1411           tmpJmpNamePtr = JmpNamePtr;
  8576                                  
  8577 00002BFF A1[5000]                 mov ax, [JmpNamePtr]
  8578 00002C02 A3[5200]                 mov word [tmpJmpNamePtr], ax
  8579                                  
  8580                                  ;-1412           tmpJmpMaxIx = JmpMaxIx;
  8581                                  
  8582 00002C05 A1[5400]                 mov ax, [JmpMaxIx]
  8583 00002C08 A3[5600]                 mov word [tmpJmpMaxIx], ax
  8584                                  
  8585                                  ;-1413         } else error1("already in proc");
  8586                                  
  8587 00002C0B E90900                   jmp .process353
  8588                                  .process352:
  8589 00002C0E 68[882C]                 push process_2
  8590 00002C11 E87DEE                   call error1
  8591 00002C14 83C402                   add  sp, 2
  8592                                  
  8593                                  ;-1414         return;
  8594                                  
  8595                                  .process353:
  8596 00002C17 E94B00                   jmp .retnprocess
  8597                                  
  8598                                  ;-1415     }
  8599                                  
  8600                                  
  8601                                  ;-1416     if (CodeType == 112) {//ENDP
  8602                                  
  8603                                  .process351:
  8604 00002C1A A0[2F00]                 mov al, [CodeType]
  8605 00002C1D 3C70                     cmp al, 112
  8606 00002C1F 0F853900                 jne .process354
  8607                                  
  8608                                  ;-1417       prs("\n;leaving: ");
  8609                                  
  8610 00002C23 68[982C]                 push process_3
  8611 00002C26 E816ED                   call prs
  8612 00002C29 83C402                   add  sp, 2
  8613                                  
  8614                                  ;-1418       prs(ProcName);
  8615                                  
  8616 00002C2C 8D066E75                 lea  ax, [ProcName]
  8617 00002C30 50                       push ax
  8618 00002C31 E80BED                   call prs
  8619 00002C34 83C402                   add  sp, 2
  8620                                  
  8621                                  ;-1419       isInProc=0;
  8622                                  
  8623 00002C37 B80000                   mov ax, 0
  8624 00002C3A A2[0D00]                 mov byte [isInProc], al
  8625                                  
  8626                                  ;-1420       i = LabelMaxIx - tmpLabelMaxIx;
  8627                                  
  8628 00002C3D A1[4A00]                 mov ax, [LabelMaxIx]
  8629 00002C40 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8630 00002C44 8946FC                   mov [bp-4], ax
  8631                                  
  8632                                  ;-1421       prs(". # local labels :");
  8633                                  
  8634 00002C47 68[A52C]                 push process_4
  8635 00002C4A E8F2EC                   call prs
  8636 00002C4D 83C402                   add  sp, 2
  8637                                  
  8638                                  ;-1422       printIntU(i);
  8639                                  
  8640 00002C50 FF76FC                   push word [bp-4]
  8641 00002C53 E8F9ED                   call printIntU
  8642 00002C56 83C402                   add  sp, 2
  8643                                  
  8644                                  ;-1423 
  8645                                  
  8646                                  
  8647                                  ;-1424       return;
  8648                                  
  8649 00002C59 E90900                   jmp .retnprocess
  8650                                  
  8651                                  ;-1425     }
  8652                                  
  8653                                  
  8654                                  ;-1426     error1("Command not implemented or syntax error");
  8655                                  
  8656                                  .process354:
  8657 00002C5C 68[B82C]                 push process_5
  8658 00002C5F E82FEE                   call error1
  8659 00002C62 83C402                   add  sp, 2
  8660                                  
  8661                                  ;-1427 }
  8662                                  
  8663 00002C65 C9                       .retnprocess: LEAVE
  8664 00002C66 C3                       ret
  8665 00002C67 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8666 00002C70 7420616C6C6F776564-
  8667 00002C79 00                 
  8668 00002C7A 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8669 00002C83 6E673A2000         
  8670 00002C88 616C72656164792069-     process_2 db "already in proc",0
  8671 00002C91 6E2070726F6300     
  8672 00002C98 5C6E3B6C656176696E-     process_3 db "\n;leaving: ",0
  8673 00002CA1 673A2000           
  8674 00002CA5 2E2023206C6F63616C-     process_4 db ". # local labels :",0
  8675 00002CAE 206C6162656C73203A-
  8676 00002CB7 00                 
  8677 00002CB8 436F6D6D616E64206E-     process_5 db "Command not implemented or syntax error",0
  8678 00002CC1 6F7420696D706C656D-
  8679 00002CCA 656E746564206F7220-
  8680 00002CD3 73796E746178206572-
  8681 00002CDC 726F7200           
  8682                                  ENDP
  8683                                   
  8684                                  ; missing functions: 
  8685                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8686 00002CE0 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8687 00002CE3 58                      pop ax
  8688 00002CE4 C3                      ret
  8689                                   
  8690                                  ;   # type sign width  adr used name   list of global variables
  8691                                  
  8692                                  ;    1 arr sign byte     1    2 Version1[9]
  8693                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  8694                                  ;    3 arr sign byte     4   12 Symbol[31]
  8695                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  8696                                  ;    5 arr sign byte     6    3 ProcName[31]
  8697                                  ;    6 var sign byte     7    5 isInProc
  8698                                  ;    7 var unsg word     8   24 SymbolInt
  8699                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  8700                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  8701                                  ;   10 arr sign byte    11    4 InputBuf[255]
  8702                                  ;   11 ptr unsg byte    12   24 InputPtr
  8703                                  ;   12 arr sign byte    13    5 namein[67]
  8704                                  ;   13 arr sign byte    14    6 namelst[67]
  8705                                  ;   14 arr sign byte    15    6 namebin[67]
  8706                                  ;   15 var sign word    16    4 asm_fd
  8707                                  ;   16 var sign word    17    3 lst_fd
  8708                                  ;   17 var sign word    18    3 bin_fd
  8709                                  ;   18 var sign word    19    6 DOS_ERR
  8710                                  ;   19 var sign word    20    4 ErrorCount
  8711                                  ;   20 var sign word    21    4 DOS_NoBytes
  8712                                  ;   21 var sign byte    22    5 DOS_ByteRead
  8713                                  ;   22 var unsg word    24    7 PC
  8714                                  ;   23 var unsg word    25    5 Origin
  8715                                  ;   24 var unsg word    26    6 AbsoluteLab
  8716                                  ;   25 var unsg word    27    2 PCStart
  8717                                  ;   26 var sign byte    28    3 isLabel
  8718                                  ;   27 def unsg byte    29    - DIGIT=1
  8719                                  ;   28 def unsg byte    30    - LETTERE=2
  8720                                  ;   29 def unsg byte    31    - ALNUME=3
  8721                                  ;   30 def unsg byte    32    - NOALNUME=4
  8722                                  ;   31 var sign byte    33   27 TokeType
  8723                                  ;   32 def unsg byte    34    - BYTE=1
  8724                                  ;   33 def unsg byte    35    - WORD=2
  8725                                  ;   34 def unsg byte    36    - DWORD=3
  8726                                  ;   35 def unsg byte    37    - SEGREG=4
  8727                                  ;   36 def unsg byte    38    - IMM=1
  8728                                  ;   37 def unsg byte    39    - REG=2
  8729                                  ;   38 def unsg byte    40    - ADR=3
  8730                                  ;   39 def unsg byte    41    - MEM=4
  8731                                  ;   40 var sign byte    42   29 Op
  8732                                  ;   41 var sign byte    43   31 Op2
  8733                                  ;   42 var sign byte    44   29 CodeType
  8734                                  ;   43 var sign byte    45   23 Code1
  8735                                  ;   44 var sign byte    46    7 Code2
  8736                                  ;   45 var sign byte    47    3 Code3
  8737                                  ;   46 var sign byte    48   19 R2No
  8738                                  ;   47 var sign byte    49   16 R1No
  8739                                  ;   48 var sign byte    50   18 R2Type
  8740                                  ;   49 var sign byte    51   15 R1Type
  8741                                  ;   50 var sign byte    52   14 OpSize
  8742                                  ;   51 var sign byte    53    9 wflag
  8743                                  ;   52 var sign byte    54    3 dflag
  8744                                  ;   53 var sign byte    55    8 sflag
  8745                                  ;   54 var sign byte    56   15 rm
  8746                                  ;   55 var sign byte    57    5 isDirect
  8747                                  ;   56 var sign word    58   51 disp
  8748                                  ;   57 var unsg word    59   13 imme
  8749                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  8750                                  ;   59 arr sign byte    62    2 OpPos[5]
  8751                                  ;   60 var sign word    63    6 OpPrintIndex
  8752                                  ;   61 ptr sign byte    64   19 OpCodePtr
  8753                                  ;   62 var sign byte    65    5 PrintRA
  8754                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  8755                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  8756                                  ;   65 ptr sign byte    69    6 LabelNamePtr
  8757                                  ;   66 ptr sign byte    70    1 tmpLabelNamePtr
  8758                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  8759                                  ;   68 arr unsg word    73    7 LabelAddr[600]
  8760                                  ;   69 var sign word    74    9 LabelMaxIx
  8761                                  ;   70 var sign word    75    2 tmpLabelMaxIx
  8762                                  ;   71 var sign word    76   10 LabelIx
  8763                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  8764                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  8765                                  ;   74 ptr sign byte    80    6 JmpNamePtr
  8766                                  ;   75 ptr sign byte    81    1 tmpJmpNamePtr
  8767                                  ;   76 def unsg byte    83    - JMPMAX=200
  8768                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  8769                                  ;   78 var sign word    85    7 JmpMaxIx
  8770                                  ;   79 var sign word    86    1 tmpJmpMaxIx
  8771                                  ;   80 def unsg byte    88    - FILEBINMAX=20000
  8772                                  ;   81 arr sign byte    89    4 FileBin[20000]
  8773                                  ;   82 var unsg word    90    6 BinLen
  8774                                  ;   83 ptr sign byte    92    1 arglen
  8775                                  ;   84 ptr sign byte    93    4 argv
  8776                                  ;   85 var sign byte    97    1 I_START
  8777                                  ;   86 arr sign byte   100 NULL I_PUSHA[8125]
  8778                                  ;   87 arr sign byte   101 NULL I_NOP[24260]
  8779                                  ;   88 arr sign byte   102 NULL I_CWDE[9734]
  8780                                  ;   89 arr sign byte   103 NULL I_CDQ[1931]
  8781                                  ;   90 arr sign byte   104 NULL I_PUSHF[35622]
  8782                                  ;   91 arr sign byte   105 NULL I_SAHF[599]
  8783                                  ;   92 arr sign byte   106 NULL I_MOVSB[53495]
  8784                                  ;   93 arr sign byte   107 NULL I_CMPSB[54007]
  8785                                  ;   94 arr sign byte   108 NULL I_STOSB[37]
  8786                                  ;   95 arr sign byte   109 NULL I_LODSB[33600]
  8787                                  ;   96 arr sign byte   110 NULL I_SCASB[8418]
  8788                                  ;   97 arr sign byte   111 NULL I_LEAVE[53259]
  8789                                  ;   98 arr sign byte   112 NULL I_INTO[12917]
  8790                                  ;   99 arr sign byte   113 NULL I_XLAT[35622]
  8791                                  ;  100 arr sign byte   114 NULL I_REPNE[2119]
  8792                                  ;  101 arr sign byte   115 NULL I_REPE[18057]
  8793                                  ;  102 arr sign byte   116 NULL I_HLT[9982]
  8794                                  ;  103 arr sign byte   117 NULL I_STC[18315]
  8795                                  ;  104 arr sign byte   118 NULL I_STI[9734]
  8796                                  ;  105 arr sign byte   119 NULL I_STD[32643]
  8797                                  ;  106 arr sign byte   121 NULL I_INC[10]
  8798                                  ;  107 arr sign byte   122 NULL I_DEC[1397]
  8799                                  ;  108 arr sign byte   123 NULL I_NOT[18119]
  8800                                  ;  109 arr sign byte   124 NULL I_NEG[65534]
  8801                                  ;  110 arr sign byte   125 NULL I_MUL[33791]
  8802                                  ;  111 arr sign byte   126 NULL I_IMUL[65150]
  8803                                  ;  112 arr sign byte   127 NULL I_DIV[30207]
  8804                                  ;  113 arr sign byte   128 NULL I_IDIV[15642]
  8805                                  ;  114 arr sign byte   130 NULL I_LES[65535]
  8806                                  ;  115 arr sign byte   131 NULL I_LDS[5493]
  8807                                  ;  116 arr sign byte   132 NULL I_LEA[33574]
  8808                                  ;  117 arr sign byte   133 NULL I_LSS[1151]
  8809                                  ;  118 arr sign byte   134 NULL I_LFS[29696]
  8810                                  ;  119 arr sign byte   135 NULL I_LGS[35593]
  8811                                  ;  120 arr sign byte   137 NULL I_ADD[2630]
  8812                                  ;  121 arr sign byte   138 NULL I_OR[14630]
  8813                                  ;  122 arr sign byte   139 NULL I_ADC[1095]
  8814                                  ;  123 arr sign byte   140 NULL I_SBB[26997]
  8815                                  ;  124 arr sign byte   141 NULL I_AND[49203]
  8816                                  ;  125 arr sign byte   142 NULL I_SUB[52169]
  8817                                  ;  126 arr sign byte   143 NULL I_XOR[33680]
  8818                                  ;  127 arr sign byte   144 NULL I_CMP[65150]
  8819                                  ;  128 arr sign byte   145 NULL I_TEST[29729]
  8820                                  ;  129 arr sign byte   147 NULL I_MOV[33618]
  8821                                  ;  130 arr sign byte   148 NULL I_MOVSX[65150]
  8822                                  ;  131 arr sign byte   149 NULL I_MOVZX[29731]
  8823                                  ;  132 arr sign byte   151 NULL I_JO[33612]
  8824                                  ;  133 arr sign byte   152 NULL I_JNO[65150]
  8825                                  ;  134 arr sign byte   153 NULL I_JB[29732]
  8826                                  ;  135 arr sign byte   154 NULL I_JNB[33606]
  8827                                  ;  136 arr sign byte   155 NULL I_JAE[65150]
  8828                                  ;  137 arr sign byte   156 NULL I_JE[29734]
  8829                                  ;  138 arr sign byte   157 NULL I_JNE[33600]
  8830                                  ;  139 arr sign byte   158 NULL I_JBE[65150]
  8831                                  ;  140 arr sign byte   159 NULL I_JA[29730]
  8832                                  ;  141 arr sign byte   160 NULL I_JS[33594]
  8833                                  ;  142 arr sign byte   161 NULL I_JNS[65150]
  8834                                  ;  143 arr sign byte   162 NULL I_JP[29737]
  8835                                  ;  144 arr sign byte   163 NULL I_JNP[33588]
  8836                                  ;  145 arr sign byte   164 NULL I_JL[65150]
  8837                                  ;  146 arr sign byte   165 NULL I_JNL[29736]
  8838                                  ;  147 arr sign byte   166 NULL I_JLE[33582]
  8839                                  ;  148 arr sign byte   167 NULL I_JG[65150]
  8840                                  ;  149 arr sign byte   169 NULL I_JMP[29733]
  8841                                  ;  150 arr sign byte   170 NULL I_CALL[15656]
  8842                                  ;  151 arr sign byte   172 NULL I_RET[33]
  8843                                  ;  152 arr sign byte   173 NULL I_RETF[9076]
  8844                                  ;  153 arr sign byte   175 NULL I_PUSH[9021]
  8845                                  ;  154 arr sign byte   176 NULL I_POP[29696]
  8846                                  ;  155 arr sign byte   178 NULL I_ROL[15646]
  8847                                  ;  156 arr sign byte   179 NULL I_RCL[36]
  8848                                  ;  157 arr sign byte   180 NULL I_SHL[6516]
  8849                                  ;  158 arr sign byte   181 NULL I_SHR[9789]
  8850                                  ;  159 arr sign byte   183 NULL I_INT[29696]
  8851                                  ;  160 arr sign byte   185 NULL I_IN[15636]
  8852                                  ;  161 arr sign byte   186 NULL I_INSB[34]
  8853                                  ;  162 arr sign byte   187 NULL I_INSW[3956]
  8854                                  ;  163 arr sign byte   188 NULL I_INSD[10557]
  8855                                  ;  164 arr sign byte   189 NULL I_OUT[29696]
  8856                                  ;  165 arr sign byte   190 NULL I_OUTSB[15626]
  8857                                  ;  166 arr sign byte   191 NULL I_OUTSW[40]
  8858                                  ;  167 arr sign byte   192 NULL I_OUTSD[1396]
  8859                                  ;  168 arr sign byte   194 NULL I_XCHG[9533]
  8860                                  ;  169 arr sign byte   196 NULL I_LOOPNZ[29952]
  8861                                  ;  170 arr sign byte   197 NULL I_LOOPNE[33542]
  8862                                  ;  171 arr sign byte   198 NULL I_LOOPZ[2686]
  8863                                  ;  172 arr sign byte   199 NULL I_LOOPE[60176]
  8864                                  ;  173 arr sign byte   200 NULL I_LOOP[33540]
  8865                                  ;  174 arr sign byte   201 NULL I_JCXZ[2686]
  8866                                  ;  175 arr sign byte   202 NULL I_JECXZ[29984]
  8867                                  ;  176 arr sign byte   204 NULL I_ENTER[47255]
  8868                                  ;  177 arr sign byte   206 NULL I_ORG[1]
  8869                                  ;  178 arr sign byte   208 NULL I_SECTION[52169]
  8870                                  ;  179 arr sign byte   209 NULL I_SEGMENT[21904]
  8871                                  ;  180 arr sign byte   210 NULL I_ABSOLUTE[60555]
  8872                                  ;  181 arr sign byte   211 NULL I_PROC[5816]
  8873                                  ;  182 arr sign byte   212 NULL I_ENDP[39424]
  8874                                  ;  183 arr sign byte   213 NULL I_DB[674]
  8875                                  ;  184 arr sign byte   214 NULL I_DW[8125]
  8876                                  ;  185 arr sign byte   215 NULL I_DD[51030]
  8877                                  ;  186 arr sign byte   216 NULL I_RESB[65094]
  8878                                  ;  187 arr sign byte   217 NULL I_RESW[0]
  8879                                  ;  188 arr sign byte   218 NULL I_RESD[1678]
  8880                                  ;  189 var sign byte   219 NULL I_END
  8881                                  
  8882                                  
  8883                                  ;   # Calls Line Width  Name   list of functions
  8884                                  
  8885                                  ;    0    2  221   lookCode
  8886                                  ;    1    2  238   ChangeDirection
  8887                                  ;    2    2  246   checkOpL
  8888                                  ;    3    4  255   check2Ops
  8889                                  ;    4    1  264   get2Ops
  8890                                  ;    5    3  270   getOpL
  8891                                  ;    6    2  278   getOpR
  8892                                  ;    7    4  288   getOp1
  8893                                  ;    8    1  305   getMEM
  8894                                  ;    9    1  331   getIndReg1
  8895                                  ;   10    1  339   getIndReg2
  8896                                  ;   11    2  349   setwflag
  8897                                  ;   12    2  360   setsflag
  8898                                  ;   13    2  370   checkConstSize
  8899                                  ;   14    1  378   parse
  8900                                  ;   15   16  414   getTokeType
  8901                                  ;   16    2  425   storeJmpCall
  8902                                  ;   17    2  436   storeLabel
  8903                                  ;   18    5  448   searchLabel
  8904                                  ;   19    1  461   getVariable
  8905                                  ;   20    1  514   getCodeSize
  8906                                  ;   21    9  522   isToken
  8907                                  ;   22    2  530   need
  8908                                  ;   23    1  539   skipRest
  8909                                  ;   24    4  546   writetty
  8910                                  ;   25    1  547   putch
  8911                                  ;   26    8  548   cputs
  8912                                  ;   27    6  550   DosInt
  8913                                  ;   28    1  555   openR
  8914                                  ;   29    2  556   creatR
  8915                                  ;   30    3  557   fcloseR
  8916                                  ;   31    5  558   exitR
  8917                                  ;   32    2  559   readRL
  8918                                  ;   33    2  560   fputcR
  8919                                  ;   34    1  563   getLine
  8920                                  ;   35    1  579   ifEOL
  8921                                  ;   36    3  588   skipBlank
  8922                                  ;   37    2  593   letterE
  8923                                  ;   38    1  603   alnumE
  8924                                  ;   39    3  608   digit
  8925                                  ;   40    4  613   strlen
  8926                                  ;   41    9  618   strcpy
  8927                                  ;   42   35  624   eqstr
  8928                                  ;   43    3  633   strcat1
  8929                                  ;   44    2  637   toupper
  8930                                  ;   45    1  644   getDigit
  8931                                  ;   46    1  656   getName
  8932                                  ;   47    1  675   testReg
  8933                                  ;   48    1  719   printLine
  8934                                  ;   49    7  741   prc
  8935                                  ;   50    1  751   prscomment
  8936                                  ;   51   33  759   prs
  8937                                  ;   52    3  781   printhex8a
  8938                                  ;   53    2  786   printhex4
  8939                                  ;   54    1  791   printhex16
  8940                                  ;   55    6  796   printIntU
  8941                                  ;   56   27  807   error1
  8942                                  ;   57   13  814   errorexit
  8943                                  ;   58    2  819   notfounderror
  8944                                  ;   59 NULL  820   allowederror
  8945                                  ;   60    3  821   addrerror
  8946                                  ;   61    1  822   immeerror
  8947                                  ;   62    2  823   implerror
  8948                                  ;   63    4  824   indexerror
  8949                                  ;   64    3  825   invaloperror
  8950                                  ;   65    6  826   numbererror
  8951                                  ;   66    1  827   regmemerror
  8952                                  ;   67    3  828   reg16error
  8953                                  ;   68    1  829   segregerror
  8954                                  ;   69    5  830   syntaxerror
  8955                                  ;   70 NULL  832   addrexit
  8956                                  ;   71    3  833   dataexit
  8957                                  ;   72 NULL  834   internexit
  8958                                  ;   73 NULL  838   main
  8959                                  ;   74    1  846   getarg
  8960                                  ;   75    1  880   fixJmpCall
  8961                                  ;   76    2  911   epilog
  8962                                  ;   77    2  959   end1
  8963                                  ;   78    1  969   getCodes
  8964                                  ;   79    1  974   gen66h
  8965                                  ;   80    8  976   genCode2
  8966                                  ;   81   13  980   genCodeW
  8967                                  ;   82   37  984   genCode8
  8968                                  ;   83   18  995   genCode16
  8969                                  ;   84    1  999   genCode32
  8970                                  ;   85   13 1003   writeEA
  8971                                  ;   86    4 1045   genImmediate
  8972                                  ;   87    1 1052   process
  8973                                  ;   88 NULL 1427   LastFunctionByt
  8974                                  
  8975                                  ;    #  addr name   list of CALLs
  8976                                  
  8977                                  ;    0     0 eqstr
  8978                                  ;    1     6 implerror
  8979                                  ;    2    16 segregerror
  8980                                  ;    3    28 setwflag
  8981                                  ;    4    37 error1
  8982                                  ;    5    44 error1
  8983                                  ;    6    51 get2Ops
  8984                                  ;    7    59 addrerror
  8985                                  ;    8    69 invaloperror
  8986                                  ;    9    82 immeerror
  8987                                  ;   10    92 addrerror
  8988                                  ;   11   102 invaloperror
  8989                                  ;   12   115 setwflag
  8990                                  ;   13   124 getOpL
  8991                                  ;   14   131 need
  8992                                  ;   15   136 getOpR
  8993                                  ;   16   143 getOpR
  8994                                  ;   17   150 getOp1
  8995                                  ;   18   157 isToken
  8996                                  ;   19   165 getMEM
  8997                                  ;   20   172 invaloperror
  8998                                  ;   21   185 error1
  8999                                  ;   22   192 testReg
  9000                                  ;   23   200 searchLabel
  9001                                  ;   24   212 getTokeType
  9002                                  ;   25   224 getOp1
  9003                                  ;   26   231 syntaxerror
  9004                                  ;   27   243 getIndReg2
  9005                                  ;   28   254 getIndReg1
  9006                                  ;   29   265 notfounderror
  9007                                  ;   30   279 isToken
  9008                                  ;   31   287 getTokeType
  9009                                  ;   32   299 numbererror
  9010                                  ;   33   311 isToken
  9011                                  ;   34   319 isToken
  9012                                  ;   35   327 errorexit
  9013                                  ;   36   337 indexerror
  9014                                  ;   37   348 indexerror
  9015                                  ;   38   359 indexerror
  9016                                  ;   39   370 indexerror
  9017                                  ;   40   381 gen66h
  9018                                  ;   41   388 error1
  9019                                  ;   42   395 getLine
  9020                                  ;   43   403 getTokeType
  9021                                  ;   44   415 strcpy
  9022                                  ;   45   422 storeLabel
  9023                                  ;   46   433 getTokeType
  9024                                  ;   47   445 lookCode
  9025                                  ;   48   454 process
  9026                                  ;   49   462 getVariable
  9027                                  ;   50   474 skipRest
  9028                                  ;   51   483 error1
  9029                                  ;   52   490 error1
  9030                                  ;   53   497 printLine
  9031                                  ;   54   507 skipBlank
  9032                                  ;   55   517 digit
  9033                                  ;   56   523 getDigit
  9034                                  ;   57   532 letterE
  9035                                  ;   58   540 getName
  9036                                  ;   59   548 errorexit
  9037                                  ;   60   558 strcpy
  9038                                  ;   61   565 errorexit
  9039                                  ;   62   575 searchLabel
  9040                                  ;   63   587 error1
  9041                                  ;   64   594 errorexit
  9042                                  ;   65   604 strcpy
  9043                                  ;   66   611 errorexit
  9044                                  ;   67   621 eqstr
  9045                                  ;   68   627 strlen
  9046                                  ;   69   634 storeLabel
  9047                                  ;   70   645 getTokeType
  9048                                  ;   71   657 lookCode
  9049                                  ;   72   666 dataexit
  9050                                  ;   73   675 dataexit
  9051                                  ;   74   684 getTokeType
  9052                                  ;   75   696 genCode8
  9053                                  ;   76   705 skipBlank
  9054                                  ;   77   715 isToken
  9055                                  ;   78   723 genCode8
  9056                                  ;   79   732 isToken
  9057                                  ;   80   740 getTokeType
  9058                                  ;   81   752 genCode16
  9059                                  ;   82   762 isToken
  9060                                  ;   83   770 getTokeType
  9061                                  ;   84   782 genCode16
  9062                                  ;   85   792 genCode16
  9063                                  ;   86   802 isToken
  9064                                  ;   87   810 getTokeType
  9065                                  ;   88   822 syntaxerror
  9066                                  ;   89   834 error1
  9067                                  ;   90   841 numbererror
  9068                                  ;   91   853 dataexit
  9069                                  ;   92   862 eqstr
  9070                                  ;   93   868 getTokeType
  9071                                  ;   94   880 eqstr
  9072                                  ;   95   886 getTokeType
  9073                                  ;   96   898 eqstr
  9074                                  ;   97   904 getTokeType
  9075                                  ;   98   916 skipBlank
  9076                                  ;   99   926 isToken
  9077                                  ;  100   934 getTokeType
  9078                                  ;  101   946 error1
  9079                                  ;  102   953 prs
  9080                                  ;  103   957 prc
  9081                                  ;  104   961 getTokeType
  9082                                  ;  105   973 error1
  9083                                  ;  106   980 writetty
  9084                                  ;  107   989 writetty
  9085                                  ;  108   998 putch
  9086                                  ;  109  1004 DosInt
  9087                                  ;  110  1011 DosInt
  9088                                  ;  111  1018 DosInt
  9089                                  ;  112  1025 DosInt
  9090                                  ;  113  1032 DosInt
  9091                                  ;  114  1039 DosInt
  9092                                  ;  115  1046 readRL
  9093                                  ;  116  1053 errorexit
  9094                                  ;  117  1063 errorexit
  9095                                  ;  118  1073 ifEOL
  9096                                  ;  119  1079 readRL
  9097                                  ;  120  1086 errorexit
  9098                                  ;  121  1096 digit
  9099                                  ;  122  1102 letterE
  9100                                  ;  123  1110 strcpy
  9101                                  ;  124  1117 digit
  9102                                  ;  125  1123 alnumE
  9103                                  ;  126  1130 errorexit
  9104                                  ;  127  1140 strcpy
  9105                                  ;  128  1147 toupper
  9106                                  ;  129  1155 strlen
  9107                                  ;  130  1162 strlen
  9108                                  ;  131  1169 eqstr
  9109                                  ;  132  1175 eqstr
  9110                                  ;  133  1181 eqstr
  9111                                  ;  134  1187 eqstr
  9112                                  ;  135  1193 eqstr
  9113                                  ;  136  1199 eqstr
  9114                                  ;  137  1205 eqstr
  9115                                  ;  138  1211 eqstr
  9116                                  ;  139  1217 eqstr
  9117                                  ;  140  1223 eqstr
  9118                                  ;  141  1229 eqstr
  9119                                  ;  142  1235 eqstr
  9120                                  ;  143  1241 eqstr
  9121                                  ;  144  1247 eqstr
  9122                                  ;  145  1253 eqstr
  9123                                  ;  146  1259 eqstr
  9124                                  ;  147  1265 eqstr
  9125                                  ;  148  1271 eqstr
  9126                                  ;  149  1277 eqstr
  9127                                  ;  150  1283 eqstr
  9128                                  ;  151  1289 eqstr
  9129                                  ;  152  1295 eqstr
  9130                                  ;  153  1301 eqstr
  9131                                  ;  154  1307 eqstr
  9132                                  ;  155  1313 eqstr
  9133                                  ;  156  1319 eqstr
  9134                                  ;  157  1325 eqstr
  9135                                  ;  158  1331 eqstr
  9136                                  ;  159  1337 eqstr
  9137                                  ;  160  1343 eqstr
  9138                                  ;  161  1349 prs
  9139                                  ;  162  1353 printhex16
  9140                                  ;  163  1364 prs
  9141                                  ;  164  1368 prc
  9142                                  ;  165  1372 printhex8a
  9143                                  ;  166  1383 prs
  9144                                  ;  167  1387 prc
  9145                                  ;  168  1391 prscomment
  9146                                  ;  169  1402 writetty
  9147                                  ;  170  1411 writetty
  9148                                  ;  171  1420 fputcR
  9149                                  ;  172  1427 prc
  9150                                  ;  173  1431 prc
  9151                                  ;  174  1435 printhex4
  9152                                  ;  175  1445 printhex4
  9153                                  ;  176  1455 prc
  9154                                  ;  177  1459 printhex8a
  9155                                  ;  178  1470 printhex8a
  9156                                  ;  179  1481 printIntU
  9157                                  ;  180  1491 prc
  9158                                  ;  181  1495 prs
  9159                                  ;  182  1499 prs
  9160                                  ;  183  1503 prs
  9161                                  ;  184  1507 prs
  9162                                  ;  185  1511 error1
  9163                                  ;  186  1518 epilog
  9164                                  ;  187  1525 end1
  9165                                  ;  188  1530 error1
  9166                                  ;  189  1537 error1
  9167                                  ;  190  1544 error1
  9168                                  ;  191  1551 error1
  9169                                  ;  192  1558 error1
  9170                                  ;  193  1565 error1
  9171                                  ;  194  1572 error1
  9172                                  ;  195  1579 error1
  9173                                  ;  196  1586 error1
  9174                                  ;  197  1593 error1
  9175                                  ;  198  1600 error1
  9176                                  ;  199  1607 error1
  9177                                  ;  200  1614 errorexit
  9178                                  ;  201  1624 errorexit
  9179                                  ;  202  1634 errorexit
  9180                                  ;  203  1644 getarg
  9181                                  ;  204  1651 parse
  9182                                  ;  205  1657 fixJmpCall
  9183                                  ;  206  1668 epilog
  9184                                  ;  207  1675 end1
  9185                                  ;  208  1680 cputs
  9186                                  ;  209  1686 cputs
  9187                                  ;  210  1692 exitR
  9188                                  ;  211  1698 toupper
  9189                                  ;  212  1706 strcpy
  9190                                  ;  213  1713 strcat1
  9191                                  ;  214  1721 strcpy
  9192                                  ;  215  1728 strcat1
  9193                                  ;  216  1736 strcpy
  9194                                  ;  217  1743 strcat1
  9195                                  ;  218  1751 openR
  9196                                  ;  219  1757 cputs
  9197                                  ;  220  1763 cputs
  9198                                  ;  221  1769 exitR
  9199                                  ;  222  1775 creatR
  9200                                  ;  223  1782 cputs
  9201                                  ;  224  1788 cputs
  9202                                  ;  225  1794 exitR
  9203                                  ;  226  1800 creatR
  9204                                  ;  227  1807 cputs
  9205                                  ;  228  1813 cputs
  9206                                  ;  229  1819 exitR
  9207                                  ;  230  1825 prs
  9208                                  ;  231  1829 prs
  9209                                  ;  232  1833 prs
  9210                                  ;  233  1837 prs
  9211                                  ;  234  1841 prs
  9212                                  ;  235  1845 prs
  9213                                  ;  236  1849 prs
  9214                                  ;  237  1853 prs
  9215                                  ;  238  1857 prs
  9216                                  ;  239  1861 prs
  9217                                  ;  240  1865 printIntU
  9218                                  ;  241  1875 strcpy
  9219                                  ;  242  1882 strlen
  9220                                  ;  243  1889 searchLabel
  9221                                  ;  244  1901 error1
  9222                                  ;  245  1908 prs
  9223                                  ;  246  1912 printIntU
  9224                                  ;  247  1922 prs
  9225                                  ;  248  1926 prs
  9226                                  ;  249  1930 prs
  9227                                  ;  250  1934 prs
  9228                                  ;  251  1938 prs
  9229                                  ;  252  1942 prs
  9230                                  ;  253  1946 printIntU
  9231                                  ;  254  1956 prs
  9232                                  ;  255  1960 fputcR
  9233                                  ;  256  1967 prs
  9234                                  ;  257  1971 printIntU
  9235                                  ;  258  1981 prs
  9236                                  ;  259  1985 fcloseR
  9237                                  ;  260  1993 fcloseR
  9238                                  ;  261  2001 fcloseR
  9239                                  ;  262  2009 exitR
  9240                                  ;  263  2015 genCode8
  9241                                  ;  264  2024 genCode8
  9242                                  ;  265  2033 genCode8
  9243                                  ;  266  2042 errorexit
  9244                                  ;  267  2052 genCode8
  9245                                  ;  268  2061 genCode8
  9246                                  ;  269  2070 genCode16
  9247                                  ;  270  2080 genCode16
  9248                                  ;  271  2090 genCode8
  9249                                  ;  272  2099 genCode8
  9250                                  ;  273  2108 genCode16
  9251                                  ;  274  2118 genCode32
  9252                                  ;  275  2128 genCode16
  9253                                  ;  276  2138 genCode8
  9254                                  ;  277  2147 getTokeType
  9255                                  ;  278  2159 getCodeSize
  9256                                  ;  279  2171 getCodes
  9257                                  ;  280  2180 genCode8
  9258                                  ;  281  2189 getOpL
  9259                                  ;  282  2196 checkOpL
  9260                                  ;  283  2205 genCode2
  9261                                  ;  284  2214 getTokeType
  9262                                  ;  285  2226 implerror
  9263                                  ;  286  2236 genCodeW
  9264                                  ;  287  2245 writeEA
  9265                                  ;  288  2253 check2Ops
  9266                                  ;  289  2263 reg16error
  9267                                  ;  290  2274 addrerror
  9268                                  ;  291  2284 genCode8
  9269                                  ;  292  2293 genCode8
  9270                                  ;  293  2302 writeEA
  9271                                  ;  294  2310 check2Ops
  9272                                  ;  295  2320 setsflag
  9273                                  ;  296  2329 genCodeW
  9274                                  ;  297  2338 genImmediate
  9275                                  ;  298  2351 genCodeW
  9276                                  ;  299  2360 writeEA
  9277                                  ;  300  2368 genCode8
  9278                                  ;  301  2377 genImmediate
  9279                                  ;  302  2390 genCodeW
  9280                                  ;  303  2399 writeEA
  9281                                  ;  304  2407 genCodeW
  9282                                  ;  305  2416 writeEA
  9283                                  ;  306  2424 syntaxerror
  9284                                  ;  307  2436 check2Ops
  9285                                  ;  308  2446 notfounderror
  9286                                  ;  309  2460 genCode2
  9287                                  ;  310  2469 genImmediate
  9288                                  ;  311  2482 genCodeW
  9289                                  ;  312  2491 writeEA
  9290                                  ;  313  2499 genImmediate
  9291                                  ;  314  2512 regmemerror
  9292                                  ;  315  2524 ChangeDirection
  9293                                  ;  316  2540 reg16error
  9294                                  ;  317  2551 genCode2
  9295                                  ;  318  2560 writeEA
  9296                                  ;  319  2568 genCodeW
  9297                                  ;  320  2577 genCode16
  9298                                  ;  321  2587 genCodeW
  9299                                  ;  322  2596 genCode16
  9300                                  ;  323  2606 genCodeW
  9301                                  ;  324  2615 writeEA
  9302                                  ;  325  2623 ChangeDirection
  9303                                  ;  326  2639 genCodeW
  9304                                  ;  327  2648 writeEA
  9305                                  ;  328  2656 syntaxerror
  9306                                  ;  329  2668 searchLabel
  9307                                  ;  330  2680 checkConstSize
  9308                                  ;  331  2695 genCode2
  9309                                  ;  332  2704 genCode8
  9310                                  ;  333  2713 genCode8
  9311                                  ;  334  2722 genCode2
  9312                                  ;  335  2731 genCode16
  9313                                  ;  336  2741 genCode8
  9314                                  ;  337  2750 genCode2
  9315                                  ;  338  2759 genCode16
  9316                                  ;  339  2769 storeJmpCall
  9317                                  ;  340  2782 searchLabel
  9318                                  ;  341  2794 checkConstSize
  9319                                  ;  342  2809 genCode8
  9320                                  ;  343  2818 genCode8
  9321                                  ;  344  2827 genCode8
  9322                                  ;  345  2836 genCode16
  9323                                  ;  346  2846 genCode8
  9324                                  ;  347  2855 genCode16
  9325                                  ;  348  2865 genCode8
  9326                                  ;  349  2874 genCode16
  9327                                  ;  350  2884 storeJmpCall
  9328                                  ;  351  2897 genCode8
  9329                                  ;  352  2906 genCode16
  9330                                  ;  353  2916 genCode8
  9331                                  ;  354  2925 getOpL
  9332                                  ;  355  2932 setsflag
  9333                                  ;  356  2941 genCode2
  9334                                  ;  357  2950 genCode8
  9335                                  ;  358  2959 genCode16
  9336                                  ;  359  2969 genCode8
  9337                                  ;  360  2978 genCode16
  9338                                  ;  361  2988 genCode8
  9339                                  ;  362  2997 genCode8
  9340                                  ;  363  3006 genCode8
  9341                                  ;  364  3015 error1
  9342                                  ;  365  3022 genCode8
  9343                                  ;  366  3031 genCode8
  9344                                  ;  367  3040 checkOpL
  9345                                  ;  368  3049 reg16error
  9346                                  ;  369  3060 genCode2
  9347                                  ;  370  3069 genCode8
  9348                                  ;  371  3078 writeEA
  9349                                  ;  372  3086 syntaxerror
  9350                                  ;  373  3098 check2Ops
  9351                                  ;  374  3108 genCodeW
  9352                                  ;  375  3117 writeEA
  9353                                  ;  376  3125 genCodeW
  9354                                  ;  377  3134 writeEA
  9355                                  ;  378  3142 genCode8
  9356                                  ;  379  3151 genCodeW
  9357                                  ;  380  3160 writeEA
  9358                                  ;  381  3168 genCode8
  9359                                  ;  382  3177 genCode8
  9360                                  ;  383  3186 genCode8
  9361                                  ;  384  3195 getOp1
  9362                                  ;  385  3202 genCode16
  9363                                  ;  386  3212 numbererror
  9364                                  ;  387  3224 need
  9365                                  ;  388  3229 getOp1
  9366                                  ;  389  3236 genCode8
  9367                                  ;  390  3245 numbererror
  9368                                  ;  391  3257 numbererror
  9369                                  ;  392  3269 numbererror
  9370                                  ;  393  3281 prs
  9371                                  ;  394  3285 prs
  9372                                  ;  395  3289 error1
  9373                                  ;  396  3296 prs
  9374                                  ;  397  3300 prs
  9375                                  ;  398  3304 prs
  9376                                  ;  399  3308 printIntU
  9377                                  ;  400  3318 error1
  9378                                  ;Input: AS.C, List: AS.S,  Lines: 1428
  9379                                  ;Glob. variables:  189 max.:  200
  9380                                  ;Functions      :   89 max.:  300
  9381                                  ;Calls          :  401 max.: 2000, NameField: 3325 max.:    65535
  9382                                  ;Code until     :21667 max.: 30000, free: 8333
  9383                                  ;Data (HeapEnd) :62154, resting stacksize:  3381 *** Warning *** Stack too small
  9384                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
