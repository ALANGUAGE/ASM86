     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9C91C                  jmp main
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
   943 00000489 E82D0E                   call eqstr
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
  1079 00000532 E83516                   call implerror
  1080                                  
  1081                                  ;-248     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  1082                                  
  1083                                  .checkOpL8:
  1084 00000535 A0[3600]                 mov al, [R1Type]
  1085 00000538 3C04                     cmp al, 4
  1086 0000053A 0F850600                 jne .checkOpL9
  1087 0000053E E8F116                   call segregerror
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
  1101 00000553 E83015                   call error1
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
  1122 0000057C E80715                   call error1
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
  1156 000005B7 E87115                   call addrerror
  1157                                  
  1158                                  ;-258     if (Op == ADR) invaloperror();
  1159                                  
  1160                                  .check2Ops14:
  1161 000005BA A0[2D00]                 mov al, [Op]
  1162 000005BD 3C03                     cmp al, 3
  1163 000005BF 0F850300                 jne .check2Ops15
  1164 000005C3 E8DF15                   call invaloperror
  1165                                  
  1166                                  ;-259     if (Op == IMM) immeerror();
  1167                                  
  1168                                  .check2Ops15:
  1169 000005C6 A0[2D00]                 mov al, [Op]
  1170 000005C9 3C01                     cmp al, 1
  1171 000005CB 0F850300                 jne .check2Ops16
  1172 000005CF E87315                   call immeerror
  1173                                  
  1174                                  ;-260     if (Op2==   0) addrerror();
  1175                                  
  1176                                  .check2Ops16:
  1177 000005D2 A0[2E00]                 mov al, [Op2]
  1178 000005D5 3C00                     cmp al, 0
  1179 000005D7 0F850300                 jne .check2Ops17
  1180 000005DB E84D15                   call addrerror
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
  1191 000005F0 E8B215                   call invaloperror
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
  1216 000005FC E80409                   call need
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
  1285 00000636 E8A208                   call isToken
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
  1300 00000657 E84B15                   call invaloperror
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
  1337 00000697 E8EC13                   call error1
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
  1392 000006DE E88B0D                   call testReg
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
  1406 000006F3 E88105                   call searchLabel
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
  1478 00000728 E82E15                   call syntaxerror
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
  1532 00000774 E87F13                   call notfounderror
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
  1552 0000078C E84C07                   call isToken
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
  1566 000007A4 E81F14                   call numbererror
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
  1582 000007B3 E82507                   call isToken
  1583 000007B6 83C402                   add  sp, 2
  1584 000007B9 08C0                     or  al, al
  1585 000007BB 0F840300                 je .getMEM40
  1586 000007BF E954FF                   jmp .getMEM29
  1587                                  .getMEM40:
  1588                                  
  1589                                  ;-329     if (isToken(']') == 0) errorexit("] expected");
  1590                                  
  1591 000007C2 6A5D                     push 93
  1592 000007C4 E81407                   call isToken
  1593 000007C7 83C402                   add  sp, 2
  1594 000007CA 83F800                   cmp ax, 0
  1595 000007CD 0F850900                 jne .getMEM41
  1596 000007D1 68[DC07]                 push getMEM_0
  1597 000007D4 E80513                   call errorexit
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
  1618 000007F0 E89113                   call indexerror
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
  1662 00000838 E84913                   call indexerror
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
  1686 0000084F E83213                   call indexerror
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
  1742 000008AF E8D212                   call indexerror
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
  1820 0000090E E86D18                   call gen66h
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
  1883 00000960 E82311                   call error1
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
  2015 000009EB E83D06                   call getLine
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
  2047 00000A1C E86408                   call strcpy
  2048 00000A1F 83C404                   add  sp, 4
  2049                                  
  2050                                  ;-397                 storeLabel();
  2051                                  
  2052                                  .parse73:
  2053 00000A22 E8AB01                   call storeLabel
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
  2086 00000A41 E85919                   call process
  2087                                  
  2088                                  ;-405             else getVariable();
  2089                                  
  2090 00000A44 E90300                   jmp .parse76
  2091                                  .parse75:
  2092 00000A47 E88102                   call getVariable
  2093                                  
  2094                                  ;-406             skipRest();
  2095                                  
  2096                                  .parse76:
  2097 00000A4A E8F504                   call skipRest
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
  2110 00000A5C E82710                   call error1
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
  2121 00000A71 E81210                   call error1
  2122 00000A74 83C402                   add  sp, 2
  2123                                  
  2124                                  ;-410         printLine();
  2125                                  
  2126                                  .parse80:
  2127                                  .parse79:
  2128                                  .parse77:
  2129 00000A77 E8B90D                   call printLine
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
  2169 00000ACC E87D06                   call skipBlank
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
  2203 00000B04 E82A07                   call digit
  2204 00000B07 83C402                   add  sp, 2
  2205 00000B0A 08C0                     or  al, al
  2206 00000B0C 0F841500                 je .getTokeType84
  2207 00000B10 8A46FE                   mov al, byte [bp-2]
  2208 00000B13 B400                     mov ah, 0
  2209 00000B15 50                       push ax
  2210 00000B16 E85408                   call getDigit
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
  2222 00000B2B E84906                   call letterE
  2223 00000B2E 83C402                   add  sp, 2
  2224 00000B31 08C0                     or  al, al
  2225 00000B33 0F841500                 je .getTokeType85
  2226 00000B37 8A46FE                   mov al, byte [bp-2]
  2227 00000B3A B400                     mov ah, 0
  2228 00000B3C 50                       push ax
  2229 00000B3D E87D08                   call getName
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
  2247                                  ;-425 int storeJmp() {
  2248                                  
  2249 00000B52 C9                       .retngetTokeType: LEAVE
  2250 00000B53 C3                       ret
  2251                                  ENDP
  2252                                  
  2253                                  storeJmp: PROC
  2254                                  
  2255                                  ;-426     unsigned int i;
  2256                                  
  2257                                  
  2258                                  ;-427     JmpMaxIx++;
  2259                                  
  2260                                  ;Function : storeJmp, Number of local variables: 1
  2261                                  ;   # type sign width addr used name   list of local variables
  2262                                  ;  200 var unsg word   426 NULL i = bp-2;
  2263 00000B54 C8020000                 ENTER  2,0
  2264 00000B58 FF06[5400]               inc  word[JmpMaxIx]
  2265                                  
  2266                                  ;-428     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  2267                                  
  2268 00000B5C A1[5400]                 mov ax, [JmpMaxIx]
  2269 00000B5F 3DC800                   cmp ax, 200 ;unsigned : 1
  2270 00000B62 0F8C0900                 jl  .storeJmp86
  2271 00000B66 68[B00B]                 push storeJmp_0
  2272 00000B69 E8700F                   call errorexit
  2273 00000B6C 83C402                   add  sp, 2
  2274                                  
  2275                                  ;-429     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  2276                                  
  2277                                  .storeJmp86:
  2278 00000B6F 8D063075                 lea  ax, [Symbol]
  2279 00000B73 50                       push ax
  2280 00000B74 FF36[5000]               push word [JmpNamePtr]
  2281 00000B78 E80807                   call strcpy
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
  2295                                  ;-432     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  2296                                  
  2297 00000B8E 8B46FE                   mov ax, [bp-2]
  2298 00000B91 3D810F                   cmp ax, 3969 ;unsigned : 0
  2299 00000B94 0F820900                 jb  .storeJmp87
  2300 00000B98 68[BD0B]                 push storeJmp_1
  2301 00000B9B E83E0F                   call errorexit
  2302 00000B9E 83C402                   add  sp, 2
  2303                                  
  2304                                  ;-433     JmpAddr[JmpMaxIx] = PC;
  2305                                  
  2306                                  .storeJmp87:
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
  2321 00000BB0 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  2322 00000BB9 4A6D7000           
  2323 00000BBD 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  2324 00000BC6 4A6D70206E616D6573-
  2325 00000BCF 00                 
  2326                                  ENDP
  2327                                  
  2328                                  storeLabel: PROC
  2329                                  
  2330                                  ;-437     unsigned int i;
  2331                                  
  2332                                  
  2333                                  ;-438     if(searchLabel()) error1("duplicate label");
  2334                                  
  2335                                  ;Function : storeLabel, Number of local variables: 1
  2336                                  ;   # type sign width addr used name   list of local variables
  2337                                  ;  200 var unsg word   437 NULL i = bp-2;
  2338 00000BD0 C8020000                 ENTER  2,0
  2339 00000BD4 E8A000                   call searchLabel
  2340 00000BD7 08C0                     or  al, al
  2341 00000BD9 0F840900                 je .storeLabel88
  2342 00000BDD 68[420C]                 push storeLabel_0
  2343 00000BE0 E8A30E                   call error1
  2344 00000BE3 83C402                   add  sp, 2
  2345                                  
  2346                                  ;-439     LabelMaxIx++;
  2347                                  
  2348                                  .storeLabel88:
  2349 00000BE6 FF06[4A00]               inc  word[LabelMaxIx]
  2350                                  
  2351                                  ;-440     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2352                                  
  2353 00000BEA A1[4A00]                 mov ax, [LabelMaxIx]
  2354 00000BED 3D5802                   cmp ax, 600 ;unsigned : 1
  2355 00000BF0 0F8C0900                 jl  .storeLabel89
  2356 00000BF4 68[520C]                 push storeLabel_1
  2357 00000BF7 E8E20E                   call errorexit
  2358 00000BFA 83C402                   add  sp, 2
  2359                                  
  2360                                  ;-441     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2361                                  
  2362                                  .storeLabel89:
  2363 00000BFD 8D063075                 lea  ax, [Symbol]
  2364 00000C01 50                       push ax
  2365 00000C02 FF36[4600]               push word [LabelNamePtr]
  2366 00000C06 E87A06                   call strcpy
  2367 00000C09 83C404                   add  sp, 4
  2368 00000C0C A3[4600]                 mov word [LabelNamePtr], ax
  2369                                  
  2370                                  ;-442     LabelNamePtr++;
  2371                                  
  2372 00000C0F FF06[4600]               inc  word[LabelNamePtr]
  2373                                  
  2374                                  ;-443     i = LabelNamePtr - &LabelNames;
  2375                                  
  2376 00000C13 A1[4600]                 mov ax, [LabelNamePtr]
  2377 00000C16 2D5A77                   sub ax, LabelNames
  2378 00000C19 8946FE                   mov [bp-2], ax
  2379                                  
  2380                                  ;-444     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2381                                  
  2382 00000C1C 8B46FE                   mov ax, [bp-2]
  2383 00000C1F 3D5117                   cmp ax, 5969 ;unsigned : 0
  2384 00000C22 0F820900                 jb  .storeLabel90
  2385 00000C26 68[620C]                 push storeLabel_2
  2386 00000C29 E8B00E                   call errorexit
  2387 00000C2C 83C402                   add  sp, 2
  2388                                  
  2389                                  ;-445     LabelAddr[LabelMaxIx] = PC + Origin;
  2390                                  
  2391                                  .storeLabel90:
  2392 00000C2F A1[2300]                 mov ax, [PC]
  2393 00000C32 0306[2500]               add ax, [Origin]
  2394 00000C36 8B1E[4A00]               mov bx, [LabelMaxIx]
  2395 00000C3A D1E3                     shl bx, 1
  2396 00000C3C 8987CA8E                 mov [LabelAddr+bx], ax
  2397                                  
  2398                                  ;-446 }
  2399                                  
  2400                                  
  2401                                  ;-447 
  2402                                  
  2403                                  
  2404                                  ;-448 int searchLabel() {
  2405 00000C40 C9                       LEAVE
  2406 00000C41 C3                       ret
  2407 00000C42 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  2408 00000C4B 206C6162656C00     
  2409 00000C52 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  2410 00000C5B 6C6162656C7300     
  2411 00000C62 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2412 00000C6B 6C6162656C206E616D-
  2413 00000C74 657300             
  2414                                  ENDP
  2415                                  
  2416                                  searchLabel: PROC
  2417                                  
  2418                                  ;-449     int LIx; char *p;
  2419                                  
  2420                                  
  2421                                  ;-450     p = &LabelNames;
  2422                                  
  2423                                  ;Function : searchLabel, Number of local variables: 2
  2424                                  ;   # type sign width addr used name   list of local variables
  2425                                  ;  200 var sign word   449 NULL LIx = bp-2
  2426                                  ;  201 ptr sign byte   449 NULL p = bp-4;
  2427 00000C77 C8040000                 ENTER  4,0
  2428 00000C7B B85A77                   mov ax, LabelNames
  2429 00000C7E 8946FC                   mov [bp-4], ax
  2430                                  
  2431                                  ;-451     LIx = 1;
  2432                                  
  2433 00000C81 B80100                   mov ax, 1
  2434 00000C84 8946FE                   mov [bp-2], ax
  2435                                  
  2436                                  ;-452     while (LIx <= LabelMaxIx) {
  2437                                  
  2438                                  .searchLabel91:
  2439 00000C87 8B46FE                   mov ax, [bp-2]
  2440 00000C8A 3B06[4A00]               cmp ax, [LabelMaxIx]
  2441 00000C8E 0F8F3100                 jg  .searchLabel92
  2442                                  
  2443                                  ;-453         if (eqstr(p, Symbol)) return LIx;//pos of label
  2444                                  
  2445 00000C92 8D063075                 lea  ax, [Symbol]
  2446 00000C96 50                       push ax
  2447 00000C97 FF76FC                   push word [bp-4]
  2448 00000C9A E81C06                   call eqstr
  2449 00000C9D 83C404                   add  sp, 4
  2450 00000CA0 08C0                     or  al, al
  2451 00000CA2 0F840600                 je .searchLabel93
  2452 00000CA6 8B46FE                   mov ax, [bp-2]
  2453 00000CA9 E91D00                   jmp .retnsearchLabel
  2454                                  
  2455                                  ;-454         p=strlen(p) + p;
  2456                                  
  2457                                  .searchLabel93:
  2458 00000CAC FF76FC                   push word [bp-4]
  2459 00000CAF E8A905                   call strlen
  2460 00000CB2 83C402                   add  sp, 2
  2461 00000CB5 0346FC                   add ax, [bp-4]
  2462 00000CB8 8946FC                   mov [bp-4], ax
  2463                                  
  2464                                  ;-455         p++;
  2465                                  
  2466 00000CBB FF46FC                   inc  word[bp-4]
  2467                                  
  2468                                  ;-456         LIx++;
  2469                                  
  2470 00000CBE FF46FE                   inc  word[bp-2]
  2471                                  
  2472                                  ;-457     }
  2473                                  
  2474                                  
  2475                                  ;-458     return 0;
  2476                                  
  2477 00000CC1 EBC4                     jmp .searchLabel91
  2478                                  .searchLabel92:
  2479 00000CC3 B80000                   mov ax, 0
  2480 00000CC6 E90000                   jmp .retnsearchLabel
  2481                                  
  2482                                  ;-459 }
  2483                                  
  2484                                  
  2485                                  ;-460 
  2486                                  
  2487                                  
  2488                                  ;-461 int getVariable() {
  2489                                  
  2490 00000CC9 C9                       .retnsearchLabel: LEAVE
  2491 00000CCA C3                       ret
  2492                                  ENDP
  2493                                  
  2494                                  getVariable: PROC
  2495                                  
  2496                                  ;-462     char c;
  2497                                  
  2498                                  
  2499                                  ;-463     storeLabel();
  2500                                  
  2501                                  ;Function : getVariable, Number of local variables: 1
  2502                                  ;   # type sign width addr used name   list of local variables
  2503                                  ;  200 var sign byte   462 NULL c = bp-2;
  2504 00000CCB C8020000                 ENTER  2,0
  2505 00000CCF E8FEFE                   call storeLabel
  2506                                  
  2507                                  ;-464     getTokeType();
  2508                                  
  2509 00000CD2 E8F3FD                   call getTokeType
  2510                                  
  2511                                  ;-465     if(TokeType==ALNUME) {//getName
  2512                                  
  2513 00000CD5 A0[2C00]                 mov al, [TokeType]
  2514 00000CD8 3C03                     cmp al, 3
  2515 00000CDA 0F857001                 jne .getVariable94
  2516                                  
  2517                                  ;-466         lookCode();
  2518                                  
  2519 00000CDE E88FF7                   call lookCode
  2520                                  
  2521                                  ;-467         if (CodeType < 200) dataexit();
  2522                                  
  2523 00000CE1 A0[2F00]                 mov al, [CodeType]
  2524 00000CE4 3CC8                     cmp al, 200
  2525 00000CE6 0F8D0300                 jge .getVariable95
  2526 00000CEA E8970F                   call dataexit
  2527                                  
  2528                                  ;-468         if (CodeType > 205) dataexit();
  2529                                  
  2530                                  .getVariable95:
  2531 00000CED A0[2F00]                 mov al, [CodeType]
  2532 00000CF0 3CCD                     cmp al, 205
  2533 00000CF2 0F8E0300                 jle .getVariable96
  2534 00000CF6 E88B0F                   call dataexit
  2535                                  
  2536                                  ;-469         if (CodeType== 200) {//DB
  2537                                  
  2538                                  .getVariable96:
  2539 00000CF9 A0[2F00]                 mov al, [CodeType]
  2540 00000CFC 3CC8                     cmp al, 200
  2541 00000CFE 0F856A00                 jne .getVariable97
  2542                                  
  2543                                  ;-470             do {
  2544                                  
  2545                                  .getVariable98:
  2546                                  
  2547                                  ;-471                 getTokeType();
  2548                                  
  2549 00000D02 E8C3FD                   call getTokeType
  2550                                  
  2551                                  ;-472                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2552                                  
  2553 00000D05 A0[2C00]                 mov al, [TokeType]
  2554 00000D08 3C01                     cmp al, 1
  2555 00000D0A 0F850D00                 jne .getVariable99
  2556 00000D0E FF36[0E00]               push word [SymbolInt]
  2557 00000D12 E8A914                   call genCode8
  2558 00000D15 83C402                   add  sp, 2
  2559                                  
  2560                                  ;-473                 else {
  2561                                  
  2562 00000D18 E94100                   jmp .getVariable100
  2563                                  .getVariable99:
  2564                                  
  2565                                  ;-474                     skipBlank();
  2566                                  
  2567 00000D1B E82E04                   call skipBlank
  2568                                  
  2569                                  ;-475                     if (isToken('"')) {
  2570                                  
  2571 00000D1E 6A22                     push 34
  2572 00000D20 E8B801                   call isToken
  2573 00000D23 83C402                   add  sp, 2
  2574 00000D26 08C0                     or  al, al
  2575 00000D28 0F843000                 je .getVariable101
  2576                                  
  2577                                  ;-476                         do {
  2578                                  
  2579                                  .getVariable102:
  2580                                  
  2581                                  ;-477                             c= *InputPtr;
  2582                                  
  2583 00000D2C 8B1E[1400]               mov bx, [InputPtr]
  2584 00000D30 8A07                     mov al, [bx]
  2585 00000D32 B400                     mov ah, 0
  2586 00000D34 8846FE                   mov [bp-2], al
  2587                                  
  2588                                  ;-478                             genCode8(c);
  2589                                  
  2590 00000D37 8A46FE                   mov al, byte [bp-2]
  2591 00000D3A B400                     mov ah, 0
  2592 00000D3C 50                       push ax
  2593 00000D3D E87E14                   call genCode8
  2594 00000D40 83C402                   add  sp, 2
  2595                                  
  2596                                  ;-479                             InputPtr++;
  2597                                  
  2598 00000D43 FF06[1400]               inc  word[InputPtr]
  2599                                  
  2600                                  ;-480                         } while (*InputPtr != '"' );
  2601                                  
  2602 00000D47 8B1E[1400]               mov bx, [InputPtr]
  2603 00000D4B 8A07                     mov al, [bx]
  2604 00000D4D B400                     mov ah, 0
  2605 00000D4F 83F822                   cmp ax, 34
  2606 00000D52 0F840200                 je  .getVariable103
  2607 00000D56 EBD4                     jmp .getVariable102
  2608                                  .getVariable103:
  2609                                  
  2610                                  ;-481                         InputPtr++;
  2611                                  
  2612 00000D58 FF06[1400]               inc  word[InputPtr]
  2613                                  
  2614                                  ;-482                     }
  2615                                  
  2616                                  
  2617                                  ;-483                 }
  2618                                  
  2619                                  .getVariable101:
  2620                                  
  2621                                  ;-484             } while (isToken(','));
  2622                                  
  2623                                  .getVariable100:
  2624 00000D5C 6A2C                     push 44
  2625 00000D5E E87A01                   call isToken
  2626 00000D61 83C402                   add  sp, 2
  2627 00000D64 08C0                     or  al, al
  2628 00000D66 0F840200                 je .getVariable104
  2629 00000D6A EB96                     jmp .getVariable98
  2630                                  .getVariable104:
  2631                                  
  2632                                  ;-485         }
  2633                                  
  2634                                  
  2635                                  ;-486         if (CodeType == 201) {//DW
  2636                                  
  2637                                  .getVariable97:
  2638 00000D6C A0[2F00]                 mov al, [CodeType]
  2639 00000D6F 3CC9                     cmp al, 201
  2640 00000D71 0F852600                 jne .getVariable105
  2641                                  
  2642                                  ;-487             do {
  2643                                  
  2644                                  .getVariable106:
  2645                                  
  2646                                  ;-488                 getTokeType();
  2647                                  
  2648 00000D75 E850FD                   call getTokeType
  2649                                  
  2650                                  ;-489                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2651                                  
  2652 00000D78 A0[2C00]                 mov al, [TokeType]
  2653 00000D7B 3C01                     cmp al, 1
  2654 00000D7D 0F850A00                 jne .getVariable107
  2655 00000D81 FF36[0E00]               push word [SymbolInt]
  2656 00000D85 E88D14                   call genCode16
  2657 00000D88 83C402                   add  sp, 2
  2658                                  
  2659                                  ;-490             } while (isToken(','));
  2660                                  
  2661                                  .getVariable107:
  2662 00000D8B 6A2C                     push 44
  2663 00000D8D E84B01                   call isToken
  2664 00000D90 83C402                   add  sp, 2
  2665 00000D93 08C0                     or  al, al
  2666 00000D95 0F840200                 je .getVariable108
  2667 00000D99 EBDA                     jmp .getVariable106
  2668                                  .getVariable108:
  2669                                  
  2670                                  ;-491         }
  2671                                  
  2672                                  
  2673                                  ;-492         if (CodeType == 202) {//DD
  2674                                  
  2675                                  .getVariable105:
  2676 00000D9B A0[2F00]                 mov al, [CodeType]
  2677 00000D9E 3CCA                     cmp al, 202
  2678 00000DA0 0F852E00                 jne .getVariable109
  2679                                  
  2680                                  ;-493             do {
  2681                                  
  2682                                  .getVariable110:
  2683                                  
  2684                                  ;-494                 getTokeType();
  2685                                  
  2686 00000DA4 E821FD                   call getTokeType
  2687                                  
  2688                                  ;-495                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  2689                                  
  2690 00000DA7 A0[2C00]                 mov al, [TokeType]
  2691 00000DAA 3C01                     cmp al, 1
  2692 00000DAC 0F851200                 jne .getVariable111
  2693 00000DB0 FF36[0E00]               push word [SymbolInt]
  2694 00000DB4 E85E14                   call genCode16
  2695 00000DB7 83C402                   add  sp, 2
  2696                                  
  2697                                  ;-496                                     genCode16(0);}//todo genCode32(SymbolLong);
  2698                                  
  2699 00000DBA 6A00                     push 0
  2700 00000DBC E85614                   call genCode16
  2701 00000DBF 83C402                   add  sp, 2
  2702                                  
  2703                                  ;-497             } while (isToken(','));
  2704                                  
  2705                                  .getVariable111:
  2706 00000DC2 6A2C                     push 44
  2707 00000DC4 E81401                   call isToken
  2708 00000DC7 83C402                   add  sp, 2
  2709 00000DCA 08C0                     or  al, al
  2710 00000DCC 0F840200                 je .getVariable112
  2711 00000DD0 EBD2                     jmp .getVariable110
  2712                                  .getVariable112:
  2713                                  
  2714                                  ;-498         }
  2715                                  
  2716                                  
  2717                                  ;-499         if (CodeType >= 203) {//resb, resw, resd
  2718                                  
  2719                                  .getVariable109:
  2720 00000DD2 A0[2F00]                 mov al, [CodeType]
  2721 00000DD5 3CCB                     cmp al, 203 ;unsigned : 1
  2722 00000DD7 0F8C7000                 jl  .getVariable113
  2723                                  
  2724                                  ;-500             getTokeType();
  2725                                  
  2726 00000DDB E8EAFC                   call getTokeType
  2727                                  
  2728                                  ;-501             if (TokeType == DIGIT) {
  2729                                  
  2730 00000DDE A0[2C00]                 mov al, [TokeType]
  2731 00000DE1 3C01                     cmp al, 1
  2732 00000DE3 0F856100                 jne .getVariable114
  2733                                  
  2734                                  ;-502                 if (SymbolInt <= 0) syntaxerror();
  2735                                  
  2736 00000DE7 A1[0E00]                 mov ax, [SymbolInt]
  2737 00000DEA 83F800                   cmp ax, 0
  2738 00000DED 0F870300                 ja  .getVariable115
  2739 00000DF1 E8650E                   call syntaxerror
  2740                                  
  2741                                  ;-503                 if (AbsoluteLab == 0) error1("Absolute is null");
  2742                                  
  2743                                  .getVariable115:
  2744 00000DF4 A1[2700]                 mov ax, [AbsoluteLab]
  2745 00000DF7 83F800                   cmp ax, 0
  2746 00000DFA 0F850900                 jne .getVariable116
  2747 00000DFE 68[530E]                 push getVariable_0
  2748 00000E01 E8820C                   call error1
  2749 00000E04 83C402                   add  sp, 2
  2750                                  
  2751                                  ;-504                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  2752                                  
  2753                                  .getVariable116:
  2754 00000E07 A1[2700]                 mov ax, [AbsoluteLab]
  2755 00000E0A 8B1E[4A00]               mov bx, [LabelMaxIx]
  2756 00000E0E D1E3                     shl bx, 1
  2757 00000E10 8987CA8E                 mov [LabelAddr+bx], ax
  2758                                  
  2759                                  ;-505                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  2760                                  
  2761 00000E14 A0[2F00]                 mov al, [CodeType]
  2762 00000E17 3CCC                     cmp al, 204
  2763 00000E19 0F850A00                 jne .getVariable117
  2764 00000E1D A1[0E00]                 mov ax, [SymbolInt]
  2765 00000E20 0306[0E00]               add ax, [SymbolInt]
  2766 00000E24 A3[0E00]                 mov word [SymbolInt], ax
  2767                                  
  2768                                  ;-506                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  2769                                  
  2770                                  .getVariable117:
  2771 00000E27 A0[2F00]                 mov al, [CodeType]
  2772 00000E2A 3CCD                     cmp al, 205
  2773 00000E2C 0F850B00                 jne .getVariable118
  2774 00000E30 A1[0E00]                 mov ax, [SymbolInt]
  2775 00000E33 BB0400                   mov bx, 4
  2776 00000E36 F7E3                     mul bx
  2777 00000E38 A3[0E00]                 mov word [SymbolInt], ax
  2778                                  
  2779                                  ;-507                 AbsoluteLab = AbsoluteLab + SymbolInt;
  2780                                  
  2781                                  .getVariable118:
  2782 00000E3B A1[2700]                 mov ax, [AbsoluteLab]
  2783 00000E3E 0306[0E00]               add ax, [SymbolInt]
  2784 00000E42 A3[2700]                 mov word [AbsoluteLab], ax
  2785                                  
  2786                                  ;-508             } else numbererror();
  2787                                  
  2788 00000E45 E90300                   jmp .getVariable119
  2789                                  .getVariable114:
  2790 00000E48 E87B0D                   call numbererror
  2791                                  
  2792                                  ;-509         }
  2793                                  
  2794                                  .getVariable119:
  2795                                  
  2796                                  ;-510     }
  2797                                  
  2798                                  .getVariable113:
  2799                                  
  2800                                  ;-511     else dataexit();
  2801                                  
  2802 00000E4B E90300                   jmp .getVariable120
  2803                                  .getVariable94:
  2804 00000E4E E8330E                   call dataexit
  2805                                  
  2806                                  ;-512 }
  2807                                  
  2808                                  .getVariable120:
  2809                                  
  2810                                  ;-513 
  2811                                  
  2812                                  
  2813                                  ;-514 int getCodeSize() {
  2814 00000E51 C9                       LEAVE
  2815 00000E52 C3                       ret
  2816 00000E53 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  2817 00000E5C 6973206E756C6C00   
  2818                                  ENDP
  2819                                  
  2820                                  getCodeSize: PROC
  2821                                  
  2822                                  ;-515     if (TokeType ==ALNUME) {
  2823                                  
  2824 00000E64 A0[2C00]                 mov al, [TokeType]
  2825 00000E67 3C03                     cmp al, 3
  2826 00000E69 0F855700                 jne .getCodeSize121
  2827                                  
  2828                                  ;-516         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2829                                  
  2830 00000E6D 68[CB0E]                 push getCodeSize_0
  2831 00000E70 8D064F75                 lea  ax, [SymbolUpper]
  2832 00000E74 50                       push ax
  2833 00000E75 E84104                   call eqstr
  2834 00000E78 83C404                   add  sp, 4
  2835 00000E7B 08C0                     or  al, al
  2836 00000E7D 0F840900                 je .getCodeSize122
  2837 00000E81 E844FC                   call getTokeType
  2838 00000E84 B80100                   mov ax, 1
  2839 00000E87 E94000                   jmp .retngetCodeSize
  2840                                  
  2841                                  ;-517         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2842                                  
  2843                                  .getCodeSize122:
  2844 00000E8A 68[D00E]                 push getCodeSize_1
  2845 00000E8D 8D064F75                 lea  ax, [SymbolUpper]
  2846 00000E91 50                       push ax
  2847 00000E92 E82404                   call eqstr
  2848 00000E95 83C404                   add  sp, 4
  2849 00000E98 08C0                     or  al, al
  2850 00000E9A 0F840900                 je .getCodeSize123
  2851 00000E9E E827FC                   call getTokeType
  2852 00000EA1 B80200                   mov ax, 2
  2853 00000EA4 E92300                   jmp .retngetCodeSize
  2854                                  
  2855                                  ;-518         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2856                                  
  2857                                  .getCodeSize123:
  2858 00000EA7 68[D50E]                 push getCodeSize_2
  2859 00000EAA 8D064F75                 lea  ax, [SymbolUpper]
  2860 00000EAE 50                       push ax
  2861 00000EAF E80704                   call eqstr
  2862 00000EB2 83C404                   add  sp, 4
  2863 00000EB5 08C0                     or  al, al
  2864 00000EB7 0F840900                 je .getCodeSize124
  2865 00000EBB E80AFC                   call getTokeType
  2866 00000EBE B80300                   mov ax, 3
  2867 00000EC1 E90600                   jmp .retngetCodeSize
  2868                                  
  2869                                  ;-519     }
  2870                                  
  2871                                  .getCodeSize124:
  2872                                  
  2873                                  ;-520     return 0;
  2874                                  
  2875                                  .getCodeSize121:
  2876 00000EC4 B80000                   mov ax, 0
  2877 00000EC7 E90000                   jmp .retngetCodeSize
  2878                                  
  2879                                  ;-521 }
  2880                                  
  2881                                  
  2882                                  ;-522 int isToken(char c) {
  2883                                  
  2884                                   .retngetCodeSize:
  2885 00000ECA C3                       ret
  2886 00000ECB 4259544500              getCodeSize_0 db "BYTE",0
  2887 00000ED0 574F524400              getCodeSize_1 db "WORD",0
  2888 00000ED5 44574F524400            getCodeSize_2 db "DWORD",0
  2889                                  ENDP
  2890                                  
  2891                                  isToken: PROC
  2892                                  
  2893                                  ;-523     skipBlank();
  2894                                  
  2895                                  ;Function : isToken, Number of local variables: 1
  2896                                  ;   # type sign width addr used name   list of local variables
  2897                                  ;  200 var sign byte   522 NULL c = bp+4;
  2898 00000EDB C8000000                 ENTER  0,0
  2899 00000EDF E86A02                   call skipBlank
  2900                                  
  2901                                  ;-524     if (*InputPtr == c) {
  2902                                  
  2903 00000EE2 8B1E[1400]               mov bx, [InputPtr]
  2904 00000EE6 8A07                     mov al, [bx]
  2905 00000EE8 B400                     mov ah, 0
  2906 00000EEA 3A4604                   cmp al, [bp+4]
  2907 00000EED 0F850A00                 jne .isToken125
  2908                                  
  2909                                  ;-525         InputPtr++;
  2910                                  
  2911 00000EF1 FF06[1400]               inc  word[InputPtr]
  2912                                  
  2913                                  ;-526         return 1;
  2914                                  
  2915 00000EF5 B80100                   mov ax, 1
  2916 00000EF8 E90600                   jmp .retnisToken
  2917                                  
  2918                                  ;-527         }
  2919                                  
  2920                                  
  2921                                  ;-528     return 0;
  2922                                  
  2923                                  .isToken125:
  2924 00000EFB B80000                   mov ax, 0
  2925 00000EFE E90000                   jmp .retnisToken
  2926                                  
  2927                                  ;-529 }
  2928                                  
  2929                                  
  2930                                  ;-530 int need(char c) {
  2931                                  
  2932 00000F01 C9                       .retnisToken: LEAVE
  2933 00000F02 C3                       ret
  2934                                  ENDP
  2935                                  
  2936                                  need: PROC
  2937                                  
  2938                                  ;-531     if (isToken(c)) {
  2939                                  
  2940                                  ;Function : need, Number of local variables: 1
  2941                                  ;   # type sign width addr used name   list of local variables
  2942                                  ;  200 var sign byte   530 NULL c = bp+4;
  2943 00000F03 C8000000                 ENTER  0,0
  2944 00000F07 8A4604                   mov al, byte [bp+4]
  2945 00000F0A B400                     mov ah, 0
  2946 00000F0C 50                       push ax
  2947 00000F0D E8CBFF                   call isToken
  2948 00000F10 83C402                   add  sp, 2
  2949 00000F13 08C0                     or  al, al
  2950 00000F15 0F840600                 je .need126
  2951                                  
  2952                                  ;-532         getTokeType();
  2953                                  
  2954 00000F19 E8ACFB                   call getTokeType
  2955                                  
  2956                                  ;-533         return;
  2957                                  
  2958 00000F1C E91800                   jmp .retnneed
  2959                                  
  2960                                  ;-534         }
  2961                                  
  2962                                  
  2963                                  ;-535     error1();
  2964                                  
  2965                                  .need126:
  2966 00000F1F E8640B                   call error1
  2967                                  
  2968                                  ;-536     prs(". need: ");
  2969                                  
  2970 00000F22 68[390F]                 push need_0
  2971 00000F25 E80C0A                   call prs
  2972 00000F28 83C402                   add  sp, 2
  2973                                  
  2974                                  ;-537     prc(c);
  2975                                  
  2976 00000F2B 8A4604                   mov al, byte [bp+4]
  2977 00000F2E B400                     mov ah, 0
  2978 00000F30 50                       push ax
  2979 00000F31 E8A809                   call prc
  2980 00000F34 83C402                   add  sp, 2
  2981                                  
  2982                                  ;-538 }
  2983                                  
  2984                                  
  2985                                  ;-539 int skipRest() {
  2986                                  
  2987 00000F37 C9                       .retnneed: LEAVE
  2988 00000F38 C3                       ret
  2989 00000F39 2E206E6565643A2000      need_0 db ". need: ",0
  2990                                  ENDP
  2991                                  
  2992                                  skipRest: PROC
  2993                                  
  2994                                  ;-540     getTokeType();
  2995                                  
  2996 00000F42 E883FB                   call getTokeType
  2997                                  
  2998                                  ;-541     if(TokeType)error1("extra char ignored");
  2999                                  
  3000 00000F45 A0[2C00]                 mov al, [TokeType]
  3001 00000F48 08C0                     or  al, al
  3002 00000F4A 0F840900                 je .skipRest127
  3003 00000F4E 68[580F]                 push skipRest_0
  3004 00000F51 E8320B                   call error1
  3005 00000F54 83C402                   add  sp, 2
  3006                                  
  3007                                  ;-542 }
  3008                                  
  3009                                  .skipRest127:
  3010                                  
  3011                                  ;-543 
  3012                                  
  3013                                  
  3014                                  ;-544 
  3015                                  
  3016                                  
  3017                                  ;-545 //#include "HELPER.C"
  3018                                  
  3019                                  
  3020                                  ;-546 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
  3021                                  
  3022 00000F57 C3                       ret
  3023 00000F58 657874726120636861-     skipRest_0 db "extra char ignored",0
  3024 00000F61 722069676E6F726564-
  3025 00000F6A 00                 
  3026                                  ENDP
  3027                                  
  3028                                  writetty: PROC
  3029 00000F6B B40E                     mov  ah, 14
  3030 00000F6D BB0000                   mov  bx, 0
  3031 00000F70 CD10                     db 205,16
  3032                                  
  3033                                  ;-547 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  3034                                  
  3035 00000F72 C3                       ret
  3036                                  ENDP
  3037                                  
  3038                                  putch: PROC
  3039                                  ;Function : putch, Number of local variables: 1
  3040                                  ;   # type sign width addr used name   list of local variables
  3041                                  ;  200 var sign byte   547 NULL c = bp+4;
  3042 00000F73 C8000000                 ENTER  0,0 ; constant expression
  3043 00000F77 807E040A                cmp byte[bp+4], 10
  3044 00000F7B 0F850500                 jne .putch128
  3045 00000F7F B00D                     mov  al, 13
  3046 00000F81 E8E7FF                   call writetty
  3047                                  .putch128:
  3048 00000F84 8A4604                   mov  al, [bp+4]
  3049 00000F87 E8E1FF                   call writetty
  3050                                  
  3051                                  ;-548 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  3052 00000F8A C9                       LEAVE
  3053 00000F8B C3                       ret
  3054                                  ENDP
  3055                                  
  3056                                  cputs: PROC
  3057                                  ;Function : cputs, Number of local variables: 2
  3058                                  ;   # type sign width addr used name   list of local variables
  3059                                  ;  200 ptr sign byte   548 NULL s = bp+4
  3060                                  ;  201 var sign byte   548 NULL c = bp-2;
  3061 00000F8C C8020000                 ENTER  2,0
  3062                                  .cputs129:
  3063 00000F90 8B5E04                   mov bx, [bp+4]
  3064 00000F93 8A07                     mov al, [bx]
  3065 00000F95 B400                     mov ah, 0
  3066 00000F97 08C0                     or  al, al
  3067 00000F99 0F841B00                 je .cputs130
  3068 00000F9D 8B5E04                   mov bx, [bp+4]
  3069 00000FA0 8A07                     mov al, [bx]
  3070 00000FA2 B400                     mov ah, 0
  3071 00000FA4 8846FE                   mov [bp-2], al
  3072 00000FA7 8A46FE                   mov al, byte [bp-2]
  3073 00000FAA B400                     mov ah, 0
  3074 00000FAC 50                       push ax
  3075 00000FAD E8C3FF                   call putch
  3076 00000FB0 83C402                   add  sp, 2
  3077 00000FB3 FF4604                   inc  word[bp+4]
  3078 00000FB6 EBD8                     jmp .cputs129
  3079                                  .cputs130:
  3080                                  
  3081                                  ;-549 
  3082                                  
  3083                                  
  3084                                  ;-550 int DosInt() {
  3085 00000FB8 C9                       LEAVE
  3086 00000FB9 C3                       ret
  3087                                  ENDP
  3088                                  
  3089                                  DosInt: PROC
  3090                                  
  3091                                  ;-551     __emit__(0xCD,0x21);//inth 0x21;
  3092                                  
  3093 00000FBA CD21                     db 205,33
  3094                                  
  3095                                  ;-552     __emit__(0x73, 04); //ifcarry DOS_ERR++;
  3096                                  
  3097 00000FBC 7304                     db 115,4
  3098                                  
  3099                                  ;-553     DOS_ERR++;
  3100                                  
  3101 00000FBE FF06[1C00]               inc  word[DOS_ERR]
  3102                                  
  3103                                  ;-554 }
  3104                                  
  3105                                  
  3106                                  ;-555 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
  3107                                  
  3108 00000FC2 C3                       ret
  3109                                  ENDP
  3110                                  
  3111                                  openR: PROC
  3112                                  ;Function : openR, Number of local variables: 1
  3113                                  ;   # type sign width addr used name   list of local variables
  3114                                  ;  200 ptr sign byte   555 NULL s = bp+4;
  3115 00000FC3 C8000000                 ENTER  0,0
  3116 00000FC7 8B5604                   mov  dx, [bp+4]
  3117 00000FCA B8023D                   mov  ax, 15618
  3118 00000FCD E8EAFF                   call DosInt
  3119                                  
  3120                                  ;-556 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  3121 00000FD0 C9                       LEAVE
  3122 00000FD1 C3                       ret
  3123                                  ENDP
  3124                                  
  3125                                  creatR: PROC
  3126                                  ;Function : creatR, Number of local variables: 1
  3127                                  ;   # type sign width addr used name   list of local variables
  3128                                  ;  200 ptr sign byte   556 NULL s = bp+4;
  3129 00000FD2 C8000000                 ENTER  0,0
  3130 00000FD6 8B5604                   mov  dx, [bp+4]
  3131 00000FD9 B90000                   mov  cx, 0
  3132 00000FDC B8003C                   mov  ax, 15360
  3133 00000FDF E8D8FF                   call DosInt
  3134                                  
  3135                                  ;-557 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
  3136 00000FE2 C9                       LEAVE
  3137 00000FE3 C3                       ret
  3138                                  ENDP
  3139                                  
  3140                                  fcloseR: PROC
  3141                                  ;Function : fcloseR, Number of local variables: 1
  3142                                  ;   # type sign width addr used name   list of local variables
  3143                                  ;  200 var sign word   557 NULL fd = bp+4;
  3144 00000FE4 C8000000                 ENTER  0,0
  3145 00000FE8 8B5E04                   mov  bx, [bp+4]
  3146 00000FEB B8003E                   mov  ax, 15872
  3147 00000FEE E8C9FF                   call DosInt
  3148                                  
  3149                                  ;-558 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
  3150 00000FF1 C9                       LEAVE
  3151 00000FF2 C3                       ret
  3152                                  ENDP
  3153                                  
  3154                                  exitR: PROC
  3155                                  ;Function : exitR, Number of local variables: 1
  3156                                  ;   # type sign width addr used name   list of local variables
  3157                                  ;  200 var sign byte   558 NULL c = bp+4;
  3158 00000FF3 C8000000                 ENTER  0,0
  3159 00000FF7 B44C                     mov  ah, 76
  3160 00000FF9 8A4604                   mov  al, [bp+4]
  3161 00000FFC E8BBFF                   call DosInt
  3162                                  
  3163                                  ;-559 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
  3164 00000FFF C9                       LEAVE
  3165 00001000 C3                       ret
  3166                                  ENDP
  3167                                  
  3168                                  readRL: PROC
  3169                                  ;Function : readRL, Number of local variables: 3
  3170                                  ;   # type sign width addr used name   list of local variables
  3171                                  ;  200 ptr sign byte   559 NULL s = bp+4
  3172                                  ;  201 var sign word   559 NULL fd = bp+6
  3173                                  ;  202 var sign word   559 NULL len = bp+8;
  3174 00001001 C8000000                 ENTER  0,0
  3175 00001005 8B5604                   mov  dx, [bp+4]
  3176 00001008 8B4E08                   mov  cx, [bp+8]
  3177 0000100B 8B5E06                   mov  bx, [bp+6]
  3178 0000100E B8003F                   mov  ax, 16128
  3179 00001011 E8A6FF                   call DosInt
  3180                                  
  3181                                  ;-560 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  3182 00001014 C9                       LEAVE
  3183 00001015 C3                       ret
  3184                                  ENDP
  3185                                  
  3186                                  fputcR: PROC
  3187                                  ;Function : fputcR, Number of local variables: 2
  3188                                  ;   # type sign width addr used name   list of local variables
  3189                                  ;  200 ptr sign byte   560 NULL n = bp+4
  3190                                  ;  201 var sign word   560 NULL fd = bp+6;
  3191 00001016 C8000000                 ENTER  0,0
  3192 0000101A 8D5604                  lea dx, [bp+4]
  3193                                  
  3194                                  ;-561   cx=1; bx=fd; ax=0x4000; DosInt(); }
  3195                                  
  3196 0000101D B90100                   mov  cx, 1
  3197 00001020 8B5E06                   mov  bx, [bp+6]
  3198 00001023 B80040                   mov  ax, 16384
  3199 00001026 E891FF                   call DosInt
  3200                                  
  3201                                  ;-562 
  3202                                  
  3203                                  
  3204                                  ;-563 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  3205 00001029 C9                       LEAVE
  3206 0000102A C3                       ret
  3207                                  ENDP
  3208                                  
  3209                                  getLine: PROC
  3210                                  
  3211                                  ;-564   unsigned int i;
  3212                                  
  3213                                  
  3214                                  ;-565   InputPtr= &InputBuf;
  3215                                  
  3216                                  ;Function : getLine, Number of local variables: 1
  3217                                  ;   # type sign width addr used name   list of local variables
  3218                                  ;  200 var unsg word   564 NULL i = bp-2;
  3219 0000102B C8020000                 ENTER  2,0
  3220 0000102F B88D75                   mov ax, InputBuf
  3221 00001032 A3[1400]                 mov word [InputPtr], ax
  3222                                  
  3223                                  ;-566   *InputPtr=0;//if last line is empty
  3224                                  
  3225 00001035 B80000                   mov ax, 0
  3226 00001038 8B1E[1400]               mov  bx, [InputPtr]
  3227 0000103C 8807                     mov  [bx], al
  3228                                  
  3229                                  ;-567   do {
  3230                                  
  3231                                  .getLine131:
  3232                                  
  3233                                  ;-568     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3234                                  
  3235 0000103E 6A01                     push 1
  3236 00001040 FF36[1600]               push word [asm_fd]
  3237 00001044 8D06[2200]               lea  ax, [DOS_ByteRead]
  3238 00001048 50                       push ax
  3239 00001049 E8B5FF                   call readRL
  3240 0000104C 83C406                   add  sp, 6
  3241 0000104F A3[2000]                 mov word [DOS_NoBytes], ax
  3242                                  
  3243                                  ;-569     if (DOS_ERR) errorexit("Reading Source");
  3244                                  
  3245 00001052 A1[1C00]                 mov ax, [DOS_ERR]
  3246 00001055 08C0                     or  al, al
  3247 00001057 0F840900                 je .getLine132
  3248 0000105B 68[BD10]                 push getLine_0
  3249 0000105E E87B0A                   call errorexit
  3250 00001061 83C402                   add  sp, 2
  3251                                  
  3252                                  ;-570     if (DOS_NoBytes == 0) return;
  3253                                  
  3254                                  .getLine132:
  3255 00001064 A1[2000]                 mov ax, [DOS_NoBytes]
  3256 00001067 83F800                   cmp ax, 0
  3257 0000106A 0F850300                 jne .getLine133
  3258 0000106E E94A00                   jmp .retngetLine
  3259                                  
  3260                                  ;-571     *InputPtr = DOS_ByteRead;
  3261                                  
  3262                                  .getLine133:
  3263 00001071 A0[2200]                 mov al, [DOS_ByteRead]
  3264 00001074 8B1E[1400]               mov  bx, [InputPtr]
  3265 00001078 8807                     mov  [bx], al
  3266                                  
  3267                                  ;-572     InputPtr++;
  3268                                  
  3269 0000107A FF06[1400]               inc  word[InputPtr]
  3270                                  
  3271                                  ;-573     i = InputPtr - &InputBuf;
  3272                                  
  3273 0000107E A1[1400]                 mov ax, [InputPtr]
  3274 00001081 2D8D75                   sub ax, InputBuf
  3275 00001084 8946FE                   mov [bp-2], ax
  3276                                  
  3277                                  ;-574     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3278                                  
  3279 00001087 8B46FE                   mov ax, [bp-2]
  3280 0000108A 3DFF00                   cmp ax, 255 ;unsigned : 0
  3281 0000108D 0F820900                 jb  .getLine134
  3282 00001091 68[CC10]                 push getLine_1
  3283 00001094 E8450A                   call errorexit
  3284 00001097 83C402                   add  sp, 2
  3285                                  
  3286                                  ;-575   } while (ifEOL(DOS_ByteRead) == 0);
  3287                                  
  3288                                  .getLine134:
  3289 0000109A A0[2200]                 mov al, byte [DOS_ByteRead]
  3290 0000109D B400                     mov ah, 0
  3291 0000109F 50                       push ax
  3292 000010A0 E83D00                   call ifEOL
  3293 000010A3 83C402                   add  sp, 2
  3294 000010A6 3C00                     cmp al, 0
  3295 000010A8 0F850200                 jne .getLine135
  3296 000010AC EB90                     jmp .getLine131
  3297                                  .getLine135:
  3298                                  
  3299                                  ;-576   InputPtr--;
  3300                                  
  3301 000010AE FF0E[1400]               dec  word[InputPtr]
  3302                                  
  3303                                  ;-577   *InputPtr=0;
  3304                                  
  3305 000010B2 B80000                   mov ax, 0
  3306 000010B5 8B1E[1400]               mov  bx, [InputPtr]
  3307 000010B9 8807                     mov  [bx], al
  3308                                  
  3309                                  ;-578 }
  3310                                  
  3311                                  
  3312                                  ;-579 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  3313                                  
  3314 000010BB C9                       .retngetLine: LEAVE
  3315 000010BC C3                       ret
  3316 000010BD 52656164696E672053-     getLine_0 db "Reading Source",0
  3317 000010C6 6F7572636500       
  3318 000010CC 696E707574206C696E-     getLine_1 db "input line too long",0
  3319 000010D5 6520746F6F206C6F6E-
  3320 000010DE 6700               
  3321                                  ENDP
  3322                                  
  3323                                  ifEOL: PROC
  3324                                  
  3325                                  ;-580   if (c == 10) return 1;//LF
  3326                                  
  3327                                  ;Function : ifEOL, Number of local variables: 1
  3328                                  ;   # type sign width addr used name   list of local variables
  3329                                  ;  200 var sign byte   579 NULL c = bp+4;
  3330 000010E0 C8000000                 ENTER  0,0
  3331 000010E4 8A4604                   mov al, [bp+4]
  3332 000010E7 3C0A                     cmp al, 10
  3333 000010E9 0F850600                 jne .ifEOL136
  3334 000010ED B80100                   mov ax, 1
  3335 000010F0 E93B00                   jmp .retnifEOL
  3336                                  
  3337                                  ;-581   if (c == 13) {//CR
  3338                                  
  3339                                  .ifEOL136:
  3340 000010F3 8A4604                   mov al, [bp+4]
  3341 000010F6 3C0D                     cmp al, 13
  3342 000010F8 0F852C00                 jne .ifEOL137
  3343                                  
  3344                                  ;-582     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3345                                  
  3346 000010FC 6A01                     push 1
  3347 000010FE FF36[1600]               push word [asm_fd]
  3348 00001102 8D06[2200]               lea  ax, [DOS_ByteRead]
  3349 00001106 50                       push ax
  3350 00001107 E8F7FE                   call readRL
  3351 0000110A 83C406                   add  sp, 6
  3352 0000110D A3[2000]                 mov word [DOS_NoBytes], ax
  3353                                  
  3354                                  ;-583     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  3355                                  
  3356 00001110 A0[2200]                 mov al, [DOS_ByteRead]
  3357 00001113 3C0A                     cmp al, 10
  3358 00001115 0F840900                 je  .ifEOL138
  3359 00001119 68[3011]                 push ifEOL_0
  3360 0000111C E8BD09                   call errorexit
  3361 0000111F 83C402                   add  sp, 2
  3362                                  
  3363                                  ;-584     return 1;
  3364                                  
  3365                                  .ifEOL138:
  3366 00001122 B80100                   mov ax, 1
  3367 00001125 E90600                   jmp .retnifEOL
  3368                                  
  3369                                  ;-585   }
  3370                                  
  3371                                  
  3372                                  ;-586   return 0;
  3373                                  
  3374                                  .ifEOL137:
  3375 00001128 B80000                   mov ax, 0
  3376 0000112B E90000                   jmp .retnifEOL
  3377                                  
  3378                                  ;-587 }
  3379                                  
  3380                                  
  3381                                  ;-588 int skipBlank() {
  3382                                  
  3383 0000112E C9                       .retnifEOL: LEAVE
  3384 0000112F C3                       ret
  3385 00001130 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  3386 00001139 462831302920616674-
  3387 00001142 657220435228313329-
  3388 0000114B 00                 
  3389                                  ENDP
  3390                                  
  3391                                  skipBlank: PROC
  3392                                  
  3393                                  ;-589   skipblank1:
  3394                                  
  3395                                  .skipblank1:
  3396                                  
  3397                                  ;-590     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3398                                  
  3399 0000114C 8B1E[1400]               mov bx, [InputPtr]
  3400 00001150 8A07                     mov al, [bx]
  3401 00001152 B400                     mov ah, 0
  3402 00001154 83F820                   cmp ax, 32
  3403 00001157 0F850600                 jne .skipBlank139
  3404 0000115B FF06[1400]               inc  word[InputPtr]
  3405 0000115F EBEB                     jmp .skipblank1
  3406                                  
  3407                                  ;-591     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3408                                  
  3409                                  .skipBlank139:
  3410 00001161 8B1E[1400]               mov bx, [InputPtr]
  3411 00001165 8A07                     mov al, [bx]
  3412 00001167 B400                     mov ah, 0
  3413 00001169 83F809                   cmp ax, 9
  3414 0000116C 0F850600                 jne .skipBlank140
  3415 00001170 FF06[1400]               inc  word[InputPtr]
  3416 00001174 EBD6                     jmp .skipblank1
  3417                                  
  3418                                  ;-592 }
  3419                                  
  3420                                  .skipBlank140:
  3421                                  
  3422                                  ;-593 int letterE(char c) {
  3423                                  
  3424 00001176 C3                       ret
  3425                                  ENDP
  3426                                  
  3427                                  letterE: PROC
  3428                                  
  3429                                  ;-594   if (c=='_') return 1;
  3430                                  
  3431                                  ;Function : letterE, Number of local variables: 1
  3432                                  ;   # type sign width addr used name   list of local variables
  3433                                  ;  200 var sign byte   593 NULL c = bp+4;
  3434 00001177 C8000000                 ENTER  0,0
  3435 0000117B 8A4604                   mov al, [bp+4]
  3436 0000117E 3C5F                     cmp al, 95
  3437 00001180 0F850600                 jne .letterE141
  3438 00001184 B80100                   mov ax, 1
  3439 00001187 E96900                   jmp .retnletterE
  3440                                  
  3441                                  ;-595   if (c=='.') return 1;
  3442                                  
  3443                                  .letterE141:
  3444 0000118A 8A4604                   mov al, [bp+4]
  3445 0000118D 3C2E                     cmp al, 46
  3446 0000118F 0F850600                 jne .letterE142
  3447 00001193 B80100                   mov ax, 1
  3448 00001196 E95A00                   jmp .retnletterE
  3449                                  
  3450                                  ;-596   if (c=='?') return 1;
  3451                                  
  3452                                  .letterE142:
  3453 00001199 8A4604                   mov al, [bp+4]
  3454 0000119C 3C3F                     cmp al, 63
  3455 0000119E 0F850600                 jne .letterE143
  3456 000011A2 B80100                   mov ax, 1
  3457 000011A5 E94B00                   jmp .retnletterE
  3458                                  
  3459                                  ;-597   if (c=='$') return 1;
  3460                                  
  3461                                  .letterE143:
  3462 000011A8 8A4604                   mov al, [bp+4]
  3463 000011AB 3C24                     cmp al, 36
  3464 000011AD 0F850600                 jne .letterE144
  3465 000011B1 B80100                   mov ax, 1
  3466 000011B4 E93C00                   jmp .retnletterE
  3467                                  
  3468                                  ;-598   if (c> 'z') return 0;
  3469                                  
  3470                                  .letterE144:
  3471 000011B7 8A4604                   mov al, [bp+4]
  3472 000011BA 3C7A                     cmp al, 122
  3473 000011BC 0F8E0600                 jle .letterE145
  3474 000011C0 B80000                   mov ax, 0
  3475 000011C3 E92D00                   jmp .retnletterE
  3476                                  
  3477                                  ;-599   if (c< '@') return 0; // at included
  3478                                  
  3479                                  .letterE145:
  3480 000011C6 8A4604                   mov al, [bp+4]
  3481 000011C9 3C40                     cmp al, 64
  3482 000011CB 0F8D0600                 jge .letterE146
  3483 000011CF B80000                   mov ax, 0
  3484 000011D2 E91E00                   jmp .retnletterE
  3485                                  
  3486                                  ;-600   if (c> 'Z') { if (c< 'a') return 0; }
  3487                                  
  3488                                  .letterE146:
  3489 000011D5 8A4604                   mov al, [bp+4]
  3490 000011D8 3C5A                     cmp al, 90
  3491 000011DA 0F8E0F00                 jle .letterE147
  3492 000011DE 8A4604                   mov al, [bp+4]
  3493 000011E1 3C61                     cmp al, 97
  3494 000011E3 0F8D0600                 jge .letterE148
  3495 000011E7 B80000                   mov ax, 0
  3496 000011EA E90600                   jmp .retnletterE
  3497                                  .letterE148:
  3498                                  
  3499                                  ;-601   return 1;
  3500                                  
  3501                                  .letterE147:
  3502 000011ED B80100                   mov ax, 1
  3503 000011F0 E90000                   jmp .retnletterE
  3504                                  
  3505                                  ;-602 }
  3506                                  
  3507                                  
  3508                                  ;-603 int alnumE(char c) {
  3509                                  
  3510 000011F3 C9                       .retnletterE: LEAVE
  3511 000011F4 C3                       ret
  3512                                  ENDP
  3513                                  
  3514                                  alnumE: PROC
  3515                                  
  3516                                  ;-604   if (digit(c)) return 1;
  3517                                  
  3518                                  ;Function : alnumE, Number of local variables: 1
  3519                                  ;   # type sign width addr used name   list of local variables
  3520                                  ;  200 var sign byte   603 NULL c = bp+4;
  3521 000011F5 C8000000                 ENTER  0,0
  3522 000011F9 8A4604                   mov al, byte [bp+4]
  3523 000011FC B400                     mov ah, 0
  3524 000011FE 50                       push ax
  3525 000011FF E82F00                   call digit
  3526 00001202 83C402                   add  sp, 2
  3527 00001205 08C0                     or  al, al
  3528 00001207 0F840600                 je .alnumE149
  3529 0000120B B80100                   mov ax, 1
  3530 0000120E E91E00                   jmp .retnalnumE
  3531                                  
  3532                                  ;-605   if (letterE(c)) return 1;
  3533                                  
  3534                                  .alnumE149:
  3535 00001211 8A4604                   mov al, byte [bp+4]
  3536 00001214 B400                     mov ah, 0
  3537 00001216 50                       push ax
  3538 00001217 E85DFF                   call letterE
  3539 0000121A 83C402                   add  sp, 2
  3540 0000121D 08C0                     or  al, al
  3541 0000121F 0F840600                 je .alnumE150
  3542 00001223 B80100                   mov ax, 1
  3543 00001226 E90600                   jmp .retnalnumE
  3544                                  
  3545                                  ;-606   return 0;
  3546                                  
  3547                                  .alnumE150:
  3548 00001229 B80000                   mov ax, 0
  3549 0000122C E90000                   jmp .retnalnumE
  3550                                  
  3551                                  ;-607 }
  3552                                  
  3553                                  
  3554                                  ;-608 int digit(char c){
  3555                                  
  3556 0000122F C9                       .retnalnumE: LEAVE
  3557 00001230 C3                       ret
  3558                                  ENDP
  3559                                  
  3560                                  digit: PROC
  3561                                  
  3562                                  ;-609     if(c<'0') return 0;
  3563                                  
  3564                                  ;Function : digit, Number of local variables: 1
  3565                                  ;   # type sign width addr used name   list of local variables
  3566                                  ;  200 var sign byte   608 NULL c = bp+4;
  3567 00001231 C8000000                 ENTER  0,0
  3568 00001235 8A4604                   mov al, [bp+4]
  3569 00001238 3C30                     cmp al, 48
  3570 0000123A 0F8D0600                 jge .digit151
  3571 0000123E B80000                   mov ax, 0
  3572 00001241 E91500                   jmp .retndigit
  3573                                  
  3574                                  ;-610     if(c>'9') return 0;
  3575                                  
  3576                                  .digit151:
  3577 00001244 8A4604                   mov al, [bp+4]
  3578 00001247 3C39                     cmp al, 57
  3579 00001249 0F8E0600                 jle .digit152
  3580 0000124D B80000                   mov ax, 0
  3581 00001250 E90600                   jmp .retndigit
  3582                                  
  3583                                  ;-611     return 1;
  3584                                  
  3585                                  .digit152:
  3586 00001253 B80100                   mov ax, 1
  3587 00001256 E90000                   jmp .retndigit
  3588                                  
  3589                                  ;-612 }
  3590                                  
  3591                                  
  3592                                  ;-613 int strlen(char *s) { int c;
  3593                                  
  3594 00001259 C9                       .retndigit: LEAVE
  3595 0000125A C3                       ret
  3596                                  ENDP
  3597                                  
  3598                                  strlen: PROC
  3599                                  
  3600                                  ;-614     c=0;
  3601                                  
  3602                                  ;Function : strlen, Number of local variables: 2
  3603                                  ;   # type sign width addr used name   list of local variables
  3604                                  ;  200 ptr sign byte   613 NULL s = bp+4
  3605                                  ;  201 var sign word   613 NULL c = bp-2;
  3606 0000125B C8020000                 ENTER  2,0
  3607 0000125F B80000                   mov ax, 0
  3608 00001262 8946FE                   mov [bp-2], ax
  3609                                  
  3610                                  ;-615     while (*s!=0) {s++; c++;}
  3611                                  
  3612                                  .strlen153:
  3613 00001265 8B5E04                   mov bx, [bp+4]
  3614 00001268 8A07                     mov al, [bx]
  3615 0000126A B400                     mov ah, 0
  3616 0000126C 83F800                   cmp ax, 0
  3617 0000126F 0F840800                 je  .strlen154
  3618 00001273 FF4604                   inc  word[bp+4]
  3619 00001276 FF46FE                   inc  word[bp-2]
  3620                                  
  3621                                  ;-616     return c;
  3622                                  
  3623 00001279 EBEA                     jmp .strlen153
  3624                                  .strlen154:
  3625 0000127B 8B46FE                   mov ax, [bp-2]
  3626 0000127E E90000                   jmp .retnstrlen
  3627                                  
  3628                                  ;-617     }
  3629                                  
  3630                                  
  3631                                  ;-618 int strcpy(char *s, char *t) {
  3632                                  
  3633 00001281 C9                       .retnstrlen: LEAVE
  3634 00001282 C3                       ret
  3635                                  ENDP
  3636                                  
  3637                                  strcpy: PROC
  3638                                  
  3639                                  ;-619     do { *s=*t; s++; t++; }
  3640                                  
  3641                                  ;Function : strcpy, Number of local variables: 2
  3642                                  ;   # type sign width addr used name   list of local variables
  3643                                  ;  200 ptr sign byte   618 NULL s = bp+4
  3644                                  ;  201 ptr sign byte   618 NULL t = bp+6;
  3645 00001283 C8000000                 ENTER  0,0
  3646                                  .strcpy155:
  3647 00001287 8B5E06                   mov bx, [bp+6]
  3648 0000128A 8A07                     mov al, [bx]
  3649 0000128C B400                     mov ah, 0
  3650 0000128E 8B5E04                   mov  bx, [bp+4]
  3651 00001291 8807                     mov  [bx], al
  3652 00001293 FF4604                   inc  word[bp+4]
  3653 00001296 FF4606                   inc  word[bp+6]
  3654                                  
  3655                                  ;-620     while (*t!=0);
  3656                                  
  3657 00001299 8B5E06                   mov bx, [bp+6]
  3658 0000129C 8A07                     mov al, [bx]
  3659 0000129E B400                     mov ah, 0
  3660 000012A0 83F800                   cmp ax, 0
  3661 000012A3 0F840200                 je  .strcpy156
  3662 000012A7 EBDE                     jmp .strcpy155
  3663                                  .strcpy156:
  3664                                  
  3665                                  ;-621     *s=0;
  3666                                  
  3667 000012A9 B80000                   mov ax, 0
  3668 000012AC 8B5E04                   mov  bx, [bp+4]
  3669 000012AF 8807                     mov  [bx], al
  3670                                  
  3671                                  ;-622     return s;
  3672                                  
  3673 000012B1 8B4604                   mov ax, [bp+4]
  3674 000012B4 E90000                   jmp .retnstrcpy
  3675                                  
  3676                                  ;-623     }
  3677                                  
  3678                                  
  3679                                  ;-624 int eqstr(char *p, char *q) {
  3680                                  
  3681 000012B7 C9                       .retnstrcpy: LEAVE
  3682 000012B8 C3                       ret
  3683                                  ENDP
  3684                                  
  3685                                  eqstr: PROC
  3686                                  
  3687                                  ;-625     while(*p) {
  3688                                  
  3689                                  ;Function : eqstr, Number of local variables: 2
  3690                                  ;   # type sign width addr used name   list of local variables
  3691                                  ;  200 ptr sign byte   624 NULL p = bp+4
  3692                                  ;  201 ptr sign byte   624 NULL q = bp+6;
  3693 000012B9 C8000000                 ENTER  0,0
  3694                                  .eqstr157:
  3695 000012BD 8B5E04                   mov bx, [bp+4]
  3696 000012C0 8A07                     mov al, [bx]
  3697 000012C2 B400                     mov ah, 0
  3698 000012C4 08C0                     or  al, al
  3699 000012C6 0F842000                 je .eqstr158
  3700                                  
  3701                                  ;-626         if (*p != *q) return 0;
  3702                                  
  3703 000012CA 8B5E04                   mov bx, [bp+4]
  3704 000012CD 8A07                     mov al, [bx]
  3705 000012CF B400                     mov ah, 0
  3706 000012D1 8B5E06                   mov bx, [bp+6]
  3707 000012D4 3A07                     cmp al, [bx]
  3708 000012D6 B400                     mov ah, 0
  3709 000012D8 0F840600                 je  .eqstr159
  3710 000012DC B80000                   mov ax, 0
  3711 000012DF E92100                   jmp .retneqstr
  3712                                  
  3713                                  ;-627             p++;
  3714                                  
  3715                                  .eqstr159:
  3716 000012E2 FF4604                   inc  word[bp+4]
  3717                                  
  3718                                  ;-628             q++;
  3719                                  
  3720 000012E5 FF4606                   inc  word[bp+6]
  3721                                  
  3722                                  ;-629             }
  3723                                  
  3724                                  
  3725                                  ;-630     if(*q) return 0;
  3726                                  
  3727 000012E8 EBD3                     jmp .eqstr157
  3728                                  .eqstr158:
  3729 000012EA 8B5E06                   mov bx, [bp+6]
  3730 000012ED 8A07                     mov al, [bx]
  3731 000012EF B400                     mov ah, 0
  3732 000012F1 08C0                     or  al, al
  3733 000012F3 0F840600                 je .eqstr160
  3734 000012F7 B80000                   mov ax, 0
  3735 000012FA E90600                   jmp .retneqstr
  3736                                  
  3737                                  ;-631     return 1;
  3738                                  
  3739                                  .eqstr160:
  3740 000012FD B80100                   mov ax, 1
  3741 00001300 E90000                   jmp .retneqstr
  3742                                  
  3743                                  ;-632     }
  3744                                  
  3745                                  
  3746                                  ;-633 int strcat1(char *s, char *t) {
  3747                                  
  3748 00001303 C9                       .retneqstr: LEAVE
  3749 00001304 C3                       ret
  3750                                  ENDP
  3751                                  
  3752                                  strcat1: PROC
  3753                                  
  3754                                  ;-634     while (*s != 0) s++;
  3755                                  
  3756                                  ;Function : strcat1, Number of local variables: 2
  3757                                  ;   # type sign width addr used name   list of local variables
  3758                                  ;  200 ptr sign byte   633 NULL s = bp+4
  3759                                  ;  201 ptr sign byte   633 NULL t = bp+6;
  3760 00001305 C8000000                 ENTER  0,0
  3761                                  .strcat1161:
  3762 00001309 8B5E04                   mov bx, [bp+4]
  3763 0000130C 8A07                     mov al, [bx]
  3764 0000130E B400                     mov ah, 0
  3765 00001310 83F800                   cmp ax, 0
  3766 00001313 0F840500                 je  .strcat1162
  3767 00001317 FF4604                   inc  word[bp+4]
  3768                                  
  3769                                  ;-635     strcpy(s, t);
  3770                                  
  3771 0000131A EBED                     jmp .strcat1161
  3772                                  .strcat1162:
  3773 0000131C FF7606                   push word [bp+6]
  3774 0000131F FF7604                   push word [bp+4]
  3775 00001322 E85EFF                   call strcpy
  3776 00001325 83C404                   add  sp, 4
  3777                                  
  3778                                  ;-636     }
  3779                                  
  3780                                  
  3781                                  ;-637 int toupper(char *s) {
  3782 00001328 C9                       LEAVE
  3783 00001329 C3                       ret
  3784                                  ENDP
  3785                                  
  3786                                  toupper: PROC
  3787                                  
  3788                                  ;-638     while(*s) {
  3789                                  
  3790                                  ;Function : toupper, Number of local variables: 1
  3791                                  ;   # type sign width addr used name   list of local variables
  3792                                  ;  200 ptr sign byte   637 NULL s = bp+4;
  3793 0000132A C8000000                 ENTER  0,0
  3794                                  .toupper163:
  3795 0000132E 8B5E04                   mov bx, [bp+4]
  3796 00001331 8A07                     mov al, [bx]
  3797 00001333 B400                     mov ah, 0
  3798 00001335 08C0                     or  al, al
  3799 00001337 0F843000                 je .toupper164
  3800                                  
  3801                                  ;-639         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  3802                                  
  3803 0000133B 8B5E04                   mov bx, [bp+4]
  3804 0000133E 8A07                     mov al, [bx]
  3805 00001340 B400                     mov ah, 0
  3806 00001342 83F861                   cmp ax, 97 ;unsigned : 1
  3807 00001345 0F8C1D00                 jl  .toupper165
  3808 00001349 8B5E04                   mov bx, [bp+4]
  3809 0000134C 8A07                     mov al, [bx]
  3810 0000134E B400                     mov ah, 0
  3811 00001350 83F87A                   cmp ax, 122
  3812 00001353 0F8F0F00                 jg  .toupper166
  3813 00001357 8B5E04                   mov bx, [bp+4]
  3814 0000135A 8A07                     mov al, [bx]
  3815 0000135C B400                     mov ah, 0
  3816 0000135E 83E820                   sub ax, 32
  3817 00001361 8B5E04                   mov  bx, [bp+4]
  3818 00001364 8807                     mov  [bx], al
  3819                                  
  3820                                  ;-640             s++;
  3821                                  
  3822                                  .toupper166:
  3823                                  .toupper165:
  3824 00001366 FF4604                   inc  word[bp+4]
  3825                                  
  3826                                  ;-641               }
  3827                                  
  3828                                  
  3829                                  ;-642     }
  3830                                  
  3831 00001369 EBC3                     jmp .toupper163
  3832                                  .toupper164:
  3833                                  
  3834                                  ;-643 
  3835                                  
  3836                                  
  3837                                  ;-644 int getDigit(unsigned char c) {//ret: SymbolInt
  3838 0000136B C9                       LEAVE
  3839 0000136C C3                       ret
  3840                                  ENDP
  3841                                  
  3842                                  getDigit: PROC
  3843                                  
  3844                                  ;-645   unsigned int CastInt;
  3845                                  
  3846                                  
  3847                                  ;-646   SymbolInt=0;
  3848                                  
  3849                                  ;Function : getDigit, Number of local variables: 2
  3850                                  ;   # type sign width addr used name   list of local variables
  3851                                  ;  200 var unsg byte   644 NULL c = bp+4
  3852                                  ;  201 var unsg word   645 NULL CastInt = bp-2;
  3853 0000136D C8020000                 ENTER  2,0
  3854 00001371 B80000                   mov ax, 0
  3855 00001374 A3[0E00]                 mov word [SymbolInt], ax
  3856                                  
  3857                                  ;-647   do {
  3858                                  
  3859                                  .getDigit167:
  3860                                  
  3861                                  ;-648     c-='0';
  3862                                  
  3863 00001377 806E0430                 sub  byte[bp+4], 48
  3864                                  
  3865                                  ;-649     SymbolInt=SymbolInt*10;
  3866                                  
  3867 0000137B A1[0E00]                 mov ax, [SymbolInt]
  3868 0000137E BB0A00                   mov bx, 10
  3869 00001381 F7E3                     mul bx
  3870 00001383 A3[0E00]                 mov word [SymbolInt], ax
  3871                                  
  3872                                  ;-650     ax=0; CastInt=c; //cast b2w
  3873                                  
  3874 00001386 B80000                   mov  ax, 0
  3875 00001389 8A4604                   mov al, [bp+4]
  3876 0000138C 8946FE                   mov [bp-2], ax
  3877                                  
  3878                                  ;-651     SymbolInt=SymbolInt+CastInt;
  3879                                  
  3880 0000138F A1[0E00]                 mov ax, [SymbolInt]
  3881 00001392 0346FE                   add ax, [bp-2]
  3882 00001395 A3[0E00]                 mov word [SymbolInt], ax
  3883                                  
  3884                                  ;-652     InputPtr++;
  3885                                  
  3886 00001398 FF06[1400]               inc  word[InputPtr]
  3887                                  
  3888                                  ;-653     c = *InputPtr;
  3889                                  
  3890 0000139C 8B1E[1400]               mov bx, [InputPtr]
  3891 000013A0 8A07                     mov al, [bx]
  3892 000013A2 B400                     mov ah, 0
  3893 000013A4 884604                   mov [bp+4], al
  3894                                  
  3895                                  ;-654   } while(digit(c));
  3896                                  
  3897 000013A7 8A4604                   mov al, byte [bp+4]
  3898 000013AA B400                     mov ah, 0
  3899 000013AC 50                       push ax
  3900 000013AD E881FE                   call digit
  3901 000013B0 83C402                   add  sp, 2
  3902 000013B3 08C0                     or  al, al
  3903 000013B5 0F840200                 je .getDigit168
  3904 000013B9 EBBC                     jmp .getDigit167
  3905                                  .getDigit168:
  3906                                  
  3907                                  ;-655 }
  3908                                  
  3909                                  
  3910                                  ;-656 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3911 000013BB C9                       LEAVE
  3912 000013BC C3                       ret
  3913                                  ENDP
  3914                                  
  3915                                  getName: PROC
  3916                                  
  3917                                  ;-657   char *p; unsigned int i;
  3918                                  
  3919                                  
  3920                                  ;-658   p = &Symbol;
  3921                                  
  3922                                  ;Function : getName, Number of local variables: 3
  3923                                  ;   # type sign width addr used name   list of local variables
  3924                                  ;  200 var unsg byte   656 NULL c = bp+4
  3925                                  ;  201 ptr sign byte   657 NULL p = bp-2
  3926                                  ;  202 var unsg word   657 NULL i = bp-4;
  3927 000013BD C8040000                 ENTER  4,0
  3928 000013C1 B83075                   mov ax, Symbol
  3929 000013C4 8946FE                   mov [bp-2], ax
  3930                                  
  3931                                  ;-659   *p = c;
  3932                                  
  3933 000013C7 8A4604                   mov al, [bp+4]
  3934 000013CA 8B5EFE                   mov  bx, [bp-2]
  3935 000013CD 8807                     mov  [bx], al
  3936                                  
  3937                                  ;-660   p++;
  3938                                  
  3939 000013CF FF46FE                   inc  word[bp-2]
  3940                                  
  3941                                  ;-661   while (alnumE(c)) {
  3942                                  
  3943                                  .getName169:
  3944 000013D2 8A4604                   mov al, byte [bp+4]
  3945 000013D5 B400                     mov ah, 0
  3946 000013D7 50                       push ax
  3947 000013D8 E81AFE                   call alnumE
  3948 000013DB 83C402                   add  sp, 2
  3949 000013DE 08C0                     or  al, al
  3950 000013E0 0F843800                 je .getName170
  3951                                  
  3952                                  ;-662     InputPtr++;
  3953                                  
  3954 000013E4 FF06[1400]               inc  word[InputPtr]
  3955                                  
  3956                                  ;-663     c = *InputPtr;
  3957                                  
  3958 000013E8 8B1E[1400]               mov bx, [InputPtr]
  3959 000013EC 8A07                     mov al, [bx]
  3960 000013EE B400                     mov ah, 0
  3961 000013F0 884604                   mov [bp+4], al
  3962                                  
  3963                                  ;-664     *p = c;
  3964                                  
  3965 000013F3 8A4604                   mov al, [bp+4]
  3966 000013F6 8B5EFE                   mov  bx, [bp-2]
  3967 000013F9 8807                     mov  [bx], al
  3968                                  
  3969                                  ;-665     p++;
  3970                                  
  3971 000013FB FF46FE                   inc  word[bp-2]
  3972                                  
  3973                                  ;-666     i = p - &Symbol;
  3974                                  
  3975 000013FE 8B46FE                   mov ax, [bp-2]
  3976 00001401 2D3075                   sub ax, Symbol
  3977 00001404 8946FC                   mov [bp-4], ax
  3978                                  
  3979                                  ;-667     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3980                                  
  3981 00001407 8B46FC                   mov ax, [bp-4]
  3982 0000140A 83F81F                   cmp ax, 31 ;unsigned : 0
  3983 0000140D 0F820900                 jb  .getName171
  3984 00001411 68[5C14]                 push getName_0
  3985 00001414 E8C506                   call errorexit
  3986 00001417 83C402                   add  sp, 2
  3987                                  
  3988                                  ;-668   }
  3989                                  
  3990                                  .getName171:
  3991                                  
  3992                                  ;-669   if (c == ':') isLabel=1; else isLabel=0;
  3993                                  
  3994 0000141A EBB6                     jmp .getName169
  3995                                  .getName170:
  3996 0000141C 8A4604                   mov al, [bp+4]
  3997 0000141F 3C3A                     cmp al, 58
  3998 00001421 0F850900                 jne .getName172
  3999 00001425 B80100                   mov ax, 1
  4000 00001428 A2[2B00]                 mov byte [isLabel], al
  4001 0000142B E90600                   jmp .getName173
  4002                                  .getName172:
  4003 0000142E B80000                   mov ax, 0
  4004 00001431 A2[2B00]                 mov byte [isLabel], al
  4005                                  
  4006                                  ;-670   p--;
  4007                                  
  4008                                  .getName173:
  4009 00001434 FF4EFE                   dec  word[bp-2]
  4010                                  
  4011                                  ;-671   *p = 0;
  4012                                  
  4013 00001437 B80000                   mov ax, 0
  4014 0000143A 8B5EFE                   mov  bx, [bp-2]
  4015 0000143D 8807                     mov  [bx], al
  4016                                  
  4017                                  ;-672   strcpy(SymbolUpper, Symbol);
  4018                                  
  4019 0000143F 8D063075                 lea  ax, [Symbol]
  4020 00001443 50                       push ax
  4021 00001444 8D064F75                 lea  ax, [SymbolUpper]
  4022 00001448 50                       push ax
  4023 00001449 E837FE                   call strcpy
  4024 0000144C 83C404                   add  sp, 4
  4025                                  
  4026                                  ;-673   toupper(SymbolUpper);
  4027                                  
  4028 0000144F 8D064F75                 lea  ax, [SymbolUpper]
  4029 00001453 50                       push ax
  4030 00001454 E8D3FE                   call toupper
  4031 00001457 83C402                   add  sp, 2
  4032                                  
  4033                                  ;-674 }
  4034                                  
  4035                                  
  4036                                  ;-675 int testReg() {
  4037 0000145A C9                       LEAVE
  4038 0000145B C3                       ret
  4039 0000145C 73796D626F6C20746F-     getName_0 db "symbol too long",0
  4040 00001465 6F206C6F6E6700     
  4041                                  ENDP
  4042                                  
  4043                                  testReg: PROC
  4044                                  
  4045                                  ;-676 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  4046                                  
  4047                                  
  4048                                  ;-677   R2Type=0;
  4049                                  
  4050 0000146C B80000                   mov ax, 0
  4051 0000146F A2[3500]                 mov byte [R2Type], al
  4052                                  
  4053                                  ;-678   if (strlen(Symbol) < 2) return 0;
  4054                                  
  4055 00001472 8D063075                 lea  ax, [Symbol]
  4056 00001476 50                       push ax
  4057 00001477 E8E1FD                   call strlen
  4058 0000147A 83C402                   add  sp, 2
  4059 0000147D 3C02                     cmp al, 2
  4060 0000147F 0F8D0600                 jge .testReg174
  4061 00001483 B80000                   mov ax, 0
  4062 00001486 E94703                   jmp .retntestReg
  4063                                  
  4064                                  ;-679   if (strlen(Symbol) > 3) return 0;
  4065                                  
  4066                                  .testReg174:
  4067 00001489 8D063075                 lea  ax, [Symbol]
  4068 0000148D 50                       push ax
  4069 0000148E E8CAFD                   call strlen
  4070 00001491 83C402                   add  sp, 2
  4071 00001494 3C03                     cmp al, 3
  4072 00001496 0F8E0600                 jle .testReg175
  4073 0000149A B80000                   mov ax, 0
  4074 0000149D E93003                   jmp .retntestReg
  4075                                  
  4076                                  ;-680   R2Type=BYTE;
  4077                                  
  4078                                  .testReg175:
  4079 000014A0 B80100                   mov ax, 1
  4080 000014A3 A2[3500]                 mov byte [R2Type], al
  4081                                  
  4082                                  ;-681   if (eqstr(SymbolUpper, "AL")) return 0;
  4083                                  
  4084 000014A6 68[D117]                 push testReg_0
  4085 000014A9 8D064F75                 lea  ax, [SymbolUpper]
  4086 000014AD 50                       push ax
  4087 000014AE E808FE                   call eqstr
  4088 000014B1 83C404                   add  sp, 4
  4089 000014B4 08C0                     or  al, al
  4090 000014B6 0F840600                 je .testReg176
  4091 000014BA B80000                   mov ax, 0
  4092 000014BD E91003                   jmp .retntestReg
  4093                                  
  4094                                  ;-682   if (eqstr(SymbolUpper, "CL")) return 1;
  4095                                  
  4096                                  .testReg176:
  4097 000014C0 68[D417]                 push testReg_1
  4098 000014C3 8D064F75                 lea  ax, [SymbolUpper]
  4099 000014C7 50                       push ax
  4100 000014C8 E8EEFD                   call eqstr
  4101 000014CB 83C404                   add  sp, 4
  4102 000014CE 08C0                     or  al, al
  4103 000014D0 0F840600                 je .testReg177
  4104 000014D4 B80100                   mov ax, 1
  4105 000014D7 E9F602                   jmp .retntestReg
  4106                                  
  4107                                  ;-683   if (eqstr(SymbolUpper, "DL")) return 2;
  4108                                  
  4109                                  .testReg177:
  4110 000014DA 68[D717]                 push testReg_2
  4111 000014DD 8D064F75                 lea  ax, [SymbolUpper]
  4112 000014E1 50                       push ax
  4113 000014E2 E8D4FD                   call eqstr
  4114 000014E5 83C404                   add  sp, 4
  4115 000014E8 08C0                     or  al, al
  4116 000014EA 0F840600                 je .testReg178
  4117 000014EE B80200                   mov ax, 2
  4118 000014F1 E9DC02                   jmp .retntestReg
  4119                                  
  4120                                  ;-684   if (eqstr(SymbolUpper, "BL")) return 3;
  4121                                  
  4122                                  .testReg178:
  4123 000014F4 68[DA17]                 push testReg_3
  4124 000014F7 8D064F75                 lea  ax, [SymbolUpper]
  4125 000014FB 50                       push ax
  4126 000014FC E8BAFD                   call eqstr
  4127 000014FF 83C404                   add  sp, 4
  4128 00001502 08C0                     or  al, al
  4129 00001504 0F840600                 je .testReg179
  4130 00001508 B80300                   mov ax, 3
  4131 0000150B E9C202                   jmp .retntestReg
  4132                                  
  4133                                  ;-685   if (eqstr(SymbolUpper, "AH")) return 4;
  4134                                  
  4135                                  .testReg179:
  4136 0000150E 68[DD17]                 push testReg_4
  4137 00001511 8D064F75                 lea  ax, [SymbolUpper]
  4138 00001515 50                       push ax
  4139 00001516 E8A0FD                   call eqstr
  4140 00001519 83C404                   add  sp, 4
  4141 0000151C 08C0                     or  al, al
  4142 0000151E 0F840600                 je .testReg180
  4143 00001522 B80400                   mov ax, 4
  4144 00001525 E9A802                   jmp .retntestReg
  4145                                  
  4146                                  ;-686   if (eqstr(SymbolUpper, "CH")) return 5;
  4147                                  
  4148                                  .testReg180:
  4149 00001528 68[E017]                 push testReg_5
  4150 0000152B 8D064F75                 lea  ax, [SymbolUpper]
  4151 0000152F 50                       push ax
  4152 00001530 E886FD                   call eqstr
  4153 00001533 83C404                   add  sp, 4
  4154 00001536 08C0                     or  al, al
  4155 00001538 0F840600                 je .testReg181
  4156 0000153C B80500                   mov ax, 5
  4157 0000153F E98E02                   jmp .retntestReg
  4158                                  
  4159                                  ;-687   if (eqstr(SymbolUpper, "DH")) return 6;
  4160                                  
  4161                                  .testReg181:
  4162 00001542 68[E317]                 push testReg_6
  4163 00001545 8D064F75                 lea  ax, [SymbolUpper]
  4164 00001549 50                       push ax
  4165 0000154A E86CFD                   call eqstr
  4166 0000154D 83C404                   add  sp, 4
  4167 00001550 08C0                     or  al, al
  4168 00001552 0F840600                 je .testReg182
  4169 00001556 B80600                   mov ax, 6
  4170 00001559 E97402                   jmp .retntestReg
  4171                                  
  4172                                  ;-688   if (eqstr(SymbolUpper, "BH")) return 7;
  4173                                  
  4174                                  .testReg182:
  4175 0000155C 68[E617]                 push testReg_7
  4176 0000155F 8D064F75                 lea  ax, [SymbolUpper]
  4177 00001563 50                       push ax
  4178 00001564 E852FD                   call eqstr
  4179 00001567 83C404                   add  sp, 4
  4180 0000156A 08C0                     or  al, al
  4181 0000156C 0F840600                 je .testReg183
  4182 00001570 B80700                   mov ax, 7
  4183 00001573 E95A02                   jmp .retntestReg
  4184                                  
  4185                                  ;-689   R2Type=WORD;
  4186                                  
  4187                                  .testReg183:
  4188 00001576 B80200                   mov ax, 2
  4189 00001579 A2[3500]                 mov byte [R2Type], al
  4190                                  
  4191                                  ;-690   if (eqstr(SymbolUpper, "AX")) return 0;
  4192                                  
  4193 0000157C 68[E917]                 push testReg_8
  4194 0000157F 8D064F75                 lea  ax, [SymbolUpper]
  4195 00001583 50                       push ax
  4196 00001584 E832FD                   call eqstr
  4197 00001587 83C404                   add  sp, 4
  4198 0000158A 08C0                     or  al, al
  4199 0000158C 0F840600                 je .testReg184
  4200 00001590 B80000                   mov ax, 0
  4201 00001593 E93A02                   jmp .retntestReg
  4202                                  
  4203                                  ;-691   if (eqstr(SymbolUpper, "CX")) return 1;
  4204                                  
  4205                                  .testReg184:
  4206 00001596 68[EC17]                 push testReg_9
  4207 00001599 8D064F75                 lea  ax, [SymbolUpper]
  4208 0000159D 50                       push ax
  4209 0000159E E818FD                   call eqstr
  4210 000015A1 83C404                   add  sp, 4
  4211 000015A4 08C0                     or  al, al
  4212 000015A6 0F840600                 je .testReg185
  4213 000015AA B80100                   mov ax, 1
  4214 000015AD E92002                   jmp .retntestReg
  4215                                  
  4216                                  ;-692   if (eqstr(SymbolUpper, "DX")) return 2;
  4217                                  
  4218                                  .testReg185:
  4219 000015B0 68[EF17]                 push testReg_10
  4220 000015B3 8D064F75                 lea  ax, [SymbolUpper]
  4221 000015B7 50                       push ax
  4222 000015B8 E8FEFC                   call eqstr
  4223 000015BB 83C404                   add  sp, 4
  4224 000015BE 08C0                     or  al, al
  4225 000015C0 0F840600                 je .testReg186
  4226 000015C4 B80200                   mov ax, 2
  4227 000015C7 E90602                   jmp .retntestReg
  4228                                  
  4229                                  ;-693   if (eqstr(SymbolUpper, "BX")) return 3;
  4230                                  
  4231                                  .testReg186:
  4232 000015CA 68[F217]                 push testReg_11
  4233 000015CD 8D064F75                 lea  ax, [SymbolUpper]
  4234 000015D1 50                       push ax
  4235 000015D2 E8E4FC                   call eqstr
  4236 000015D5 83C404                   add  sp, 4
  4237 000015D8 08C0                     or  al, al
  4238 000015DA 0F840600                 je .testReg187
  4239 000015DE B80300                   mov ax, 3
  4240 000015E1 E9EC01                   jmp .retntestReg
  4241                                  
  4242                                  ;-694   if (eqstr(SymbolUpper, "SP")) return 4;
  4243                                  
  4244                                  .testReg187:
  4245 000015E4 68[F517]                 push testReg_12
  4246 000015E7 8D064F75                 lea  ax, [SymbolUpper]
  4247 000015EB 50                       push ax
  4248 000015EC E8CAFC                   call eqstr
  4249 000015EF 83C404                   add  sp, 4
  4250 000015F2 08C0                     or  al, al
  4251 000015F4 0F840600                 je .testReg188
  4252 000015F8 B80400                   mov ax, 4
  4253 000015FB E9D201                   jmp .retntestReg
  4254                                  
  4255                                  ;-695   if (eqstr(SymbolUpper, "BP")) return 5;
  4256                                  
  4257                                  .testReg188:
  4258 000015FE 68[F817]                 push testReg_13
  4259 00001601 8D064F75                 lea  ax, [SymbolUpper]
  4260 00001605 50                       push ax
  4261 00001606 E8B0FC                   call eqstr
  4262 00001609 83C404                   add  sp, 4
  4263 0000160C 08C0                     or  al, al
  4264 0000160E 0F840600                 je .testReg189
  4265 00001612 B80500                   mov ax, 5
  4266 00001615 E9B801                   jmp .retntestReg
  4267                                  
  4268                                  ;-696   if (eqstr(SymbolUpper, "SI")) return 6;
  4269                                  
  4270                                  .testReg189:
  4271 00001618 68[FB17]                 push testReg_14
  4272 0000161B 8D064F75                 lea  ax, [SymbolUpper]
  4273 0000161F 50                       push ax
  4274 00001620 E896FC                   call eqstr
  4275 00001623 83C404                   add  sp, 4
  4276 00001626 08C0                     or  al, al
  4277 00001628 0F840600                 je .testReg190
  4278 0000162C B80600                   mov ax, 6
  4279 0000162F E99E01                   jmp .retntestReg
  4280                                  
  4281                                  ;-697   if (eqstr(SymbolUpper, "DI")) return 7;
  4282                                  
  4283                                  .testReg190:
  4284 00001632 68[FE17]                 push testReg_15
  4285 00001635 8D064F75                 lea  ax, [SymbolUpper]
  4286 00001639 50                       push ax
  4287 0000163A E87CFC                   call eqstr
  4288 0000163D 83C404                   add  sp, 4
  4289 00001640 08C0                     or  al, al
  4290 00001642 0F840600                 je .testReg191
  4291 00001646 B80700                   mov ax, 7
  4292 00001649 E98401                   jmp .retntestReg
  4293                                  
  4294                                  ;-698   R2Type=SEGREG;
  4295                                  
  4296                                  .testReg191:
  4297 0000164C B80400                   mov ax, 4
  4298 0000164F A2[3500]                 mov byte [R2Type], al
  4299                                  
  4300                                  ;-699   if (eqstr(SymbolUpper, "ES")) return 0;
  4301                                  
  4302 00001652 68[0118]                 push testReg_16
  4303 00001655 8D064F75                 lea  ax, [SymbolUpper]
  4304 00001659 50                       push ax
  4305 0000165A E85CFC                   call eqstr
  4306 0000165D 83C404                   add  sp, 4
  4307 00001660 08C0                     or  al, al
  4308 00001662 0F840600                 je .testReg192
  4309 00001666 B80000                   mov ax, 0
  4310 00001669 E96401                   jmp .retntestReg
  4311                                  
  4312                                  ;-700   if (eqstr(SymbolUpper, "CS")) return 1;
  4313                                  
  4314                                  .testReg192:
  4315 0000166C 68[0418]                 push testReg_17
  4316 0000166F 8D064F75                 lea  ax, [SymbolUpper]
  4317 00001673 50                       push ax
  4318 00001674 E842FC                   call eqstr
  4319 00001677 83C404                   add  sp, 4
  4320 0000167A 08C0                     or  al, al
  4321 0000167C 0F840600                 je .testReg193
  4322 00001680 B80100                   mov ax, 1
  4323 00001683 E94A01                   jmp .retntestReg
  4324                                  
  4325                                  ;-701   if (eqstr(SymbolUpper, "SS")) return 2;
  4326                                  
  4327                                  .testReg193:
  4328 00001686 68[0718]                 push testReg_18
  4329 00001689 8D064F75                 lea  ax, [SymbolUpper]
  4330 0000168D 50                       push ax
  4331 0000168E E828FC                   call eqstr
  4332 00001691 83C404                   add  sp, 4
  4333 00001694 08C0                     or  al, al
  4334 00001696 0F840600                 je .testReg194
  4335 0000169A B80200                   mov ax, 2
  4336 0000169D E93001                   jmp .retntestReg
  4337                                  
  4338                                  ;-702   if (eqstr(SymbolUpper, "DS")) return 3;
  4339                                  
  4340                                  .testReg194:
  4341 000016A0 68[0A18]                 push testReg_19
  4342 000016A3 8D064F75                 lea  ax, [SymbolUpper]
  4343 000016A7 50                       push ax
  4344 000016A8 E80EFC                   call eqstr
  4345 000016AB 83C404                   add  sp, 4
  4346 000016AE 08C0                     or  al, al
  4347 000016B0 0F840600                 je .testReg195
  4348 000016B4 B80300                   mov ax, 3
  4349 000016B7 E91601                   jmp .retntestReg
  4350                                  
  4351                                  ;-703   if (eqstr(SymbolUpper, "FS")) return 4;
  4352                                  
  4353                                  .testReg195:
  4354 000016BA 68[0D18]                 push testReg_20
  4355 000016BD 8D064F75                 lea  ax, [SymbolUpper]
  4356 000016C1 50                       push ax
  4357 000016C2 E8F4FB                   call eqstr
  4358 000016C5 83C404                   add  sp, 4
  4359 000016C8 08C0                     or  al, al
  4360 000016CA 0F840600                 je .testReg196
  4361 000016CE B80400                   mov ax, 4
  4362 000016D1 E9FC00                   jmp .retntestReg
  4363                                  
  4364                                  ;-704   if (eqstr(SymbolUpper, "GS")) return 5;
  4365                                  
  4366                                  .testReg196:
  4367 000016D4 68[1018]                 push testReg_21
  4368 000016D7 8D064F75                 lea  ax, [SymbolUpper]
  4369 000016DB 50                       push ax
  4370 000016DC E8DAFB                   call eqstr
  4371 000016DF 83C404                   add  sp, 4
  4372 000016E2 08C0                     or  al, al
  4373 000016E4 0F840600                 je .testReg197
  4374 000016E8 B80500                   mov ax, 5
  4375 000016EB E9E200                   jmp .retntestReg
  4376                                  
  4377                                  ;-705   R2Type=DWORD;
  4378                                  
  4379                                  .testReg197:
  4380 000016EE B80300                   mov ax, 3
  4381 000016F1 A2[3500]                 mov byte [R2Type], al
  4382                                  
  4383                                  ;-706   if (eqstr(SymbolUpper, "EAX"))return 0;
  4384                                  
  4385 000016F4 68[1318]                 push testReg_22
  4386 000016F7 8D064F75                 lea  ax, [SymbolUpper]
  4387 000016FB 50                       push ax
  4388 000016FC E8BAFB                   call eqstr
  4389 000016FF 83C404                   add  sp, 4
  4390 00001702 08C0                     or  al, al
  4391 00001704 0F840600                 je .testReg198
  4392 00001708 B80000                   mov ax, 0
  4393 0000170B E9C200                   jmp .retntestReg
  4394                                  
  4395                                  ;-707   if (eqstr(SymbolUpper, "ECX"))return 1;
  4396                                  
  4397                                  .testReg198:
  4398 0000170E 68[1718]                 push testReg_23
  4399 00001711 8D064F75                 lea  ax, [SymbolUpper]
  4400 00001715 50                       push ax
  4401 00001716 E8A0FB                   call eqstr
  4402 00001719 83C404                   add  sp, 4
  4403 0000171C 08C0                     or  al, al
  4404 0000171E 0F840600                 je .testReg199
  4405 00001722 B80100                   mov ax, 1
  4406 00001725 E9A800                   jmp .retntestReg
  4407                                  
  4408                                  ;-708   if (eqstr(SymbolUpper, "EDX"))return 2;
  4409                                  
  4410                                  .testReg199:
  4411 00001728 68[1B18]                 push testReg_24
  4412 0000172B 8D064F75                 lea  ax, [SymbolUpper]
  4413 0000172F 50                       push ax
  4414 00001730 E886FB                   call eqstr
  4415 00001733 83C404                   add  sp, 4
  4416 00001736 08C0                     or  al, al
  4417 00001738 0F840600                 je .testReg200
  4418 0000173C B80200                   mov ax, 2
  4419 0000173F E98E00                   jmp .retntestReg
  4420                                  
  4421                                  ;-709   if (eqstr(SymbolUpper, "EBX"))return 3;
  4422                                  
  4423                                  .testReg200:
  4424 00001742 68[1F18]                 push testReg_25
  4425 00001745 8D064F75                 lea  ax, [SymbolUpper]
  4426 00001749 50                       push ax
  4427 0000174A E86CFB                   call eqstr
  4428 0000174D 83C404                   add  sp, 4
  4429 00001750 08C0                     or  al, al
  4430 00001752 0F840600                 je .testReg201
  4431 00001756 B80300                   mov ax, 3
  4432 00001759 E97400                   jmp .retntestReg
  4433                                  
  4434                                  ;-710   if (eqstr(SymbolUpper, "ESP"))return 4;
  4435                                  
  4436                                  .testReg201:
  4437 0000175C 68[2318]                 push testReg_26
  4438 0000175F 8D064F75                 lea  ax, [SymbolUpper]
  4439 00001763 50                       push ax
  4440 00001764 E852FB                   call eqstr
  4441 00001767 83C404                   add  sp, 4
  4442 0000176A 08C0                     or  al, al
  4443 0000176C 0F840600                 je .testReg202
  4444 00001770 B80400                   mov ax, 4
  4445 00001773 E95A00                   jmp .retntestReg
  4446                                  
  4447                                  ;-711   if (eqstr(SymbolUpper, "EBP"))return 5;
  4448                                  
  4449                                  .testReg202:
  4450 00001776 68[2718]                 push testReg_27
  4451 00001779 8D064F75                 lea  ax, [SymbolUpper]
  4452 0000177D 50                       push ax
  4453 0000177E E838FB                   call eqstr
  4454 00001781 83C404                   add  sp, 4
  4455 00001784 08C0                     or  al, al
  4456 00001786 0F840600                 je .testReg203
  4457 0000178A B80500                   mov ax, 5
  4458 0000178D E94000                   jmp .retntestReg
  4459                                  
  4460                                  ;-712   if (eqstr(SymbolUpper, "ESI"))return 6;
  4461                                  
  4462                                  .testReg203:
  4463 00001790 68[2B18]                 push testReg_28
  4464 00001793 8D064F75                 lea  ax, [SymbolUpper]
  4465 00001797 50                       push ax
  4466 00001798 E81EFB                   call eqstr
  4467 0000179B 83C404                   add  sp, 4
  4468 0000179E 08C0                     or  al, al
  4469 000017A0 0F840600                 je .testReg204
  4470 000017A4 B80600                   mov ax, 6
  4471 000017A7 E92600                   jmp .retntestReg
  4472                                  
  4473                                  ;-713   if (eqstr(SymbolUpper, "EDI"))return 7;
  4474                                  
  4475                                  .testReg204:
  4476 000017AA 68[2F18]                 push testReg_29
  4477 000017AD 8D064F75                 lea  ax, [SymbolUpper]
  4478 000017B1 50                       push ax
  4479 000017B2 E804FB                   call eqstr
  4480 000017B5 83C404                   add  sp, 4
  4481 000017B8 08C0                     or  al, al
  4482 000017BA 0F840600                 je .testReg205
  4483 000017BE B80700                   mov ax, 7
  4484 000017C1 E90C00                   jmp .retntestReg
  4485                                  
  4486                                  ;-714   R2Type=0; return 0;
  4487                                  
  4488                                  .testReg205:
  4489 000017C4 B80000                   mov ax, 0
  4490 000017C7 A2[3500]                 mov byte [R2Type], al
  4491 000017CA B80000                   mov ax, 0
  4492 000017CD E90000                   jmp .retntestReg
  4493                                  
  4494                                  ;-715 }
  4495                                  
  4496                                  
  4497                                  ;-716 
  4498                                  
  4499                                  
  4500                                  ;-717 
  4501                                  
  4502                                  
  4503                                  ;-718 //#include "OUTPUT.C"
  4504                                  
  4505                                  
  4506                                  ;-719 int printLine() {
  4507                                  
  4508                                   .retntestReg:
  4509 000017D0 C3                       ret
  4510 000017D1 414C00                  testReg_0 db "AL",0
  4511 000017D4 434C00                  testReg_1 db "CL",0
  4512 000017D7 444C00                  testReg_2 db "DL",0
  4513 000017DA 424C00                  testReg_3 db "BL",0
  4514 000017DD 414800                  testReg_4 db "AH",0
  4515 000017E0 434800                  testReg_5 db "CH",0
  4516 000017E3 444800                  testReg_6 db "DH",0
  4517 000017E6 424800                  testReg_7 db "BH",0
  4518 000017E9 415800                  testReg_8 db "AX",0
  4519 000017EC 435800                  testReg_9 db "CX",0
  4520 000017EF 445800                  testReg_10 db "DX",0
  4521 000017F2 425800                  testReg_11 db "BX",0
  4522 000017F5 535000                  testReg_12 db "SP",0
  4523 000017F8 425000                  testReg_13 db "BP",0
  4524 000017FB 534900                  testReg_14 db "SI",0
  4525 000017FE 444900                  testReg_15 db "DI",0
  4526 00001801 455300                  testReg_16 db "ES",0
  4527 00001804 435300                  testReg_17 db "CS",0
  4528 00001807 535300                  testReg_18 db "SS",0
  4529 0000180A 445300                  testReg_19 db "DS",0
  4530 0000180D 465300                  testReg_20 db "FS",0
  4531 00001810 475300                  testReg_21 db "GS",0
  4532 00001813 45415800                testReg_22 db "EAX",0
  4533 00001817 45435800                testReg_23 db "ECX",0
  4534 0000181B 45445800                testReg_24 db "EDX",0
  4535 0000181F 45425800                testReg_25 db "EBX",0
  4536 00001823 45535000                testReg_26 db "ESP",0
  4537 00001827 45425000                testReg_27 db "EBP",0
  4538 0000182B 45534900                testReg_28 db "ESI",0
  4539 0000182F 45444900                testReg_29 db "EDI",0
  4540                                  ENDP
  4541                                  
  4542                                  printLine: PROC
  4543                                  
  4544                                  ;-720     int i; char c;
  4545                                  
  4546                                  
  4547                                  ;-721     prs("\n");
  4548                                  
  4549                                  ;Function : printLine, Number of local variables: 2
  4550                                  ;   # type sign width addr used name   list of local variables
  4551                                  ;  200 var sign word   720 NULL i = bp-2
  4552                                  ;  201 var sign byte   720 NULL c = bp-4;
  4553 00001833 C8040000                 ENTER  4,0
  4554 00001837 68[C518]                 push printLine_0
  4555 0000183A E8F700                   call prs
  4556 0000183D 83C402                   add  sp, 2
  4557                                  
  4558                                  ;-722     printhex16(PCStart);
  4559                                  
  4560 00001840 FF36[2900]               push word [PCStart]
  4561 00001844 E8D301                   call printhex16
  4562 00001847 83C402                   add  sp, 2
  4563                                  
  4564                                  ;-723     if (OpPrintIndex == 0) prs("               ");
  4565                                  
  4566 0000184A A1[4100]                 mov ax, [OpPrintIndex]
  4567 0000184D 83F800                   cmp ax, 0
  4568 00001850 0F850C00                 jne .printLine206
  4569 00001854 68[C818]                 push printLine_1
  4570 00001857 E8DA00                   call prs
  4571 0000185A 83C402                   add  sp, 2
  4572                                  
  4573                                  ;-724     else {
  4574                                  
  4575 0000185D E94C00                   jmp .printLine207
  4576                                  .printLine206:
  4577                                  
  4578                                  ;-725 //        prc(' ');
  4579                                  
  4580                                  
  4581                                  ;-726         i=0;
  4582                                  
  4583 00001860 B80000                   mov ax, 0
  4584 00001863 8946FE                   mov [bp-2], ax
  4585                                  
  4586                                  ;-727         do {
  4587                                  
  4588                                  .printLine208:
  4589                                  
  4590                                  ;-728             c=OpPos[i];
  4591                                  
  4592 00001866 8B5EFE                   mov bx, [bp-2]
  4593 00001869 8A875577                 mov al, [OpPos + bx]
  4594 0000186D 8846FC                   mov [bp-4], al
  4595                                  
  4596                                  ;-729             prc(' ');
  4597                                  
  4598 00001870 6A20                     push 32
  4599 00001872 E86700                   call prc
  4600 00001875 83C402                   add  sp, 2
  4601                                  
  4602                                  ;-730             printhex8a(c);
  4603                                  
  4604 00001878 8A46FC                   mov al, byte [bp-4]
  4605 0000187B B400                     mov ah, 0
  4606 0000187D 50                       push ax
  4607 0000187E E84701                   call printhex8a
  4608 00001881 83C402                   add  sp, 2
  4609                                  
  4610                                  ;-731             i++;
  4611                                  
  4612 00001884 FF46FE                   inc  word[bp-2]
  4613                                  
  4614                                  ;-732         } while (i < OpPrintIndex);
  4615                                  
  4616 00001887 8B46FE                   mov ax, [bp-2]
  4617 0000188A 3B06[4100]               cmp ax, [OpPrintIndex]
  4618 0000188E 0F8D0200                 jge .printLine209
  4619 00001892 EBD2                     jmp .printLine208
  4620                                  .printLine209:
  4621                                  
  4622                                  ;-733         while (i < OPMAXLEN) {// fill rest with blank
  4623                                  
  4624                                  .printLine210:
  4625 00001894 8B46FE                   mov ax, [bp-2]
  4626 00001897 83F805                   cmp ax, 5
  4627 0000189A 0F8D0E00                 jge .printLine211
  4628                                  
  4629                                  ;-734             prs("   ");
  4630                                  
  4631 0000189E 68[D818]                 push printLine_2
  4632 000018A1 E89000                   call prs
  4633 000018A4 83C402                   add  sp, 2
  4634                                  
  4635                                  ;-735             i++;
  4636                                  
  4637 000018A7 FF46FE                   inc  word[bp-2]
  4638                                  
  4639                                  ;-736         }
  4640                                  
  4641                                  
  4642                                  ;-737     }
  4643                                  
  4644 000018AA EBE8                     jmp .printLine210
  4645                                  .printLine211:
  4646                                  
  4647                                  ;-738     prc(PrintRA);
  4648                                  
  4649                                  .printLine207:
  4650 000018AC A0[4500]                 mov al, byte [PrintRA]
  4651 000018AF B400                     mov ah, 0
  4652 000018B1 50                       push ax
  4653 000018B2 E82700                   call prc
  4654 000018B5 83C402                   add  sp, 2
  4655                                  
  4656                                  ;-739     prscomment(InputBuf);
  4657                                  
  4658 000018B8 8D068D75                 lea  ax, [InputBuf]
  4659 000018BC 50                       push ax
  4660 000018BD E84600                   call prscomment
  4661 000018C0 83C402                   add  sp, 2
  4662                                  
  4663                                  ;-740 }
  4664                                  
  4665                                  
  4666                                  ;-741 int prc(unsigned char c) {//print char
  4667 000018C3 C9                       LEAVE
  4668 000018C4 C3                       ret
  4669 000018C5 5C6E00                  printLine_0 db "\n",0
  4670 000018C8 202020202020202020-     printLine_1 db "               ",0
  4671 000018D1 20202020202000     
  4672 000018D8 20202000                printLine_2 db "   ",0
  4673                                  ENDP
  4674                                  
  4675                                  prc: PROC
  4676                                  
  4677                                  ;-742         if ( _ c==10) {
  4678                                  
  4679                                  ;Function : prc, Number of local variables: 1
  4680                                  ;   # type sign width addr used name   list of local variables
  4681                                  ;  200 var unsg byte   741 NULL c = bp+4;
  4682 000018DC C8000000                 ENTER  0,0 ; constant expression
  4683 000018E0 807E040A                cmp byte[bp+4], 10
  4684 000018E4 0F850600                 jne .prc212
  4685                                  
  4686                                  ;-743             ax=13;
  4687                                  
  4688 000018E8 B80D00                   mov  ax, 13
  4689                                  
  4690                                  ;-744             writetty();
  4691                                  
  4692 000018EB E87DF6                   call writetty
  4693                                  
  4694                                  ;-745             }
  4695                                  
  4696                                  
  4697                                  ;-746         al=c;
  4698                                  
  4699                                  .prc212:
  4700 000018EE 8A4604                   mov  al, [bp+4]
  4701                                  
  4702                                  ;-747         writetty();
  4703                                  
  4704 000018F1 E877F6                   call writetty
  4705                                  
  4706                                  ;-748     fputcR(c,lst_fd);
  4707                                  
  4708 000018F4 FF36[1800]               push word [lst_fd]
  4709 000018F8 8A4604                   mov al, byte [bp+4]
  4710 000018FB B400                     mov ah, 0
  4711 000018FD 50                       push ax
  4712 000018FE E815F7                   call fputcR
  4713 00001901 83C404                   add  sp, 4
  4714                                  
  4715                                  ;-749 }
  4716                                  
  4717                                  
  4718                                  ;-750 
  4719                                  
  4720                                  
  4721                                  ;-751 int prscomment(unsigned char *s) {
  4722 00001904 C9                       LEAVE
  4723 00001905 C3                       ret
  4724                                  ENDP
  4725                                  
  4726                                  prscomment: PROC
  4727                                  
  4728                                  ;-752     unsigned char c;
  4729                                  
  4730                                  
  4731                                  ;-753     while (*s){
  4732                                  
  4733                                  ;Function : prscomment, Number of local variables: 2
  4734                                  ;   # type sign width addr used name   list of local variables
  4735                                  ;  200 ptr unsg byte   751 NULL s = bp+4
  4736                                  ;  201 var unsg byte   752 NULL c = bp-2;
  4737 00001906 C8020000                 ENTER  2,0
  4738                                  .prscomment213:
  4739 0000190A 8B5E04                   mov bx, [bp+4]
  4740 0000190D 8A07                     mov al, [bx]
  4741 0000190F B400                     mov ah, 0
  4742 00001911 08C0                     or  al, al
  4743 00001913 0F841B00                 je .prscomment214
  4744                                  
  4745                                  ;-754         c=*s;
  4746                                  
  4747 00001917 8B5E04                   mov bx, [bp+4]
  4748 0000191A 8A07                     mov al, [bx]
  4749 0000191C B400                     mov ah, 0
  4750 0000191E 8846FE                   mov [bp-2], al
  4751                                  
  4752                                  ;-755         prc(c);
  4753                                  
  4754 00001921 8A46FE                   mov al, byte [bp-2]
  4755 00001924 B400                     mov ah, 0
  4756 00001926 50                       push ax
  4757 00001927 E8B2FF                   call prc
  4758 0000192A 83C402                   add  sp, 2
  4759                                  
  4760                                  ;-756         s++;
  4761                                  
  4762 0000192D FF4604                   inc  word[bp+4]
  4763                                  
  4764                                  ;-757     }
  4765                                  
  4766                                  
  4767                                  ;-758 }
  4768                                  
  4769 00001930 EBD8                     jmp .prscomment213
  4770                                  .prscomment214:
  4771                                  
  4772                                  ;-759 int prs(unsigned char *s) {
  4773 00001932 C9                       LEAVE
  4774 00001933 C3                       ret
  4775                                  ENDP
  4776                                  
  4777                                  prs: PROC
  4778                                  
  4779                                  ;-760     unsigned char c;
  4780                                  
  4781                                  
  4782                                  ;-761     int com;
  4783                                  
  4784                                  
  4785                                  ;-762     com=0;
  4786                                  
  4787                                  ;Function : prs, Number of local variables: 3
  4788                                  ;   # type sign width addr used name   list of local variables
  4789                                  ;  200 ptr unsg byte   759 NULL s = bp+4
  4790                                  ;  201 var unsg byte   760 NULL c = bp-2
  4791                                  ;  202 var sign word   761 NULL com = bp-4;
  4792 00001934 C8040000                 ENTER  4,0
  4793 00001938 B80000                   mov ax, 0
  4794 0000193B 8946FC                   mov [bp-4], ax
  4795                                  
  4796                                  ;-763     while (*s) {
  4797                                  
  4798                                  .prs215:
  4799 0000193E 8B5E04                   mov bx, [bp+4]
  4800 00001941 8A07                     mov al, [bx]
  4801 00001943 B400                     mov ah, 0
  4802 00001945 08C0                     or  al, al
  4803 00001947 0F847B00                 je .prs216
  4804                                  
  4805                                  ;-764         c=*s;
  4806                                  
  4807 0000194B 8B5E04                   mov bx, [bp+4]
  4808 0000194E 8A07                     mov al, [bx]
  4809 00001950 B400                     mov ah, 0
  4810 00001952 8846FE                   mov [bp-2], al
  4811                                  
  4812                                  ;-765         if (c==34) {
  4813                                  
  4814 00001955 8A46FE                   mov al, [bp-2]
  4815 00001958 3C22                     cmp al, 34
  4816 0000195A 0F851800                 jne .prs217
  4817                                  
  4818                                  ;-766             if (com) com=0;
  4819                                  
  4820 0000195E 8B46FC                   mov ax, [bp-4]
  4821 00001961 08C0                     or  al, al
  4822 00001963 0F840900                 je .prs218
  4823 00001967 B80000                   mov ax, 0
  4824 0000196A 8946FC                   mov [bp-4], ax
  4825                                  
  4826                                  ;-767                 else com=1;
  4827                                  
  4828 0000196D E90600                   jmp .prs219
  4829                                  .prs218:
  4830 00001970 B80100                   mov ax, 1
  4831 00001973 8946FC                   mov [bp-4], ax
  4832                                  
  4833                                  ;-768         }
  4834                                  
  4835                                  .prs219:
  4836                                  
  4837                                  ;-769         if (c==92) {
  4838                                  
  4839                                  .prs217:
  4840 00001976 8A46FE                   mov al, [bp-2]
  4841 00001979 3C5C                     cmp al, 92
  4842 0000197B 0F853500                 jne .prs220
  4843                                  
  4844                                  ;-770             if (com==0) {
  4845                                  
  4846 0000197F 8B46FC                   mov ax, [bp-4]
  4847 00001982 83F800                   cmp ax, 0
  4848 00001985 0F852B00                 jne .prs221
  4849                                  
  4850                                  ;-771                 s++;
  4851                                  
  4852 00001989 FF4604                   inc  word[bp+4]
  4853                                  
  4854                                  ;-772                 c=*s;
  4855                                  
  4856 0000198C 8B5E04                   mov bx, [bp+4]
  4857 0000198F 8A07                     mov al, [bx]
  4858 00001991 B400                     mov ah, 0
  4859 00001993 8846FE                   mov [bp-2], al
  4860                                  
  4861                                  ;-773                 if (c=='n') c=10;
  4862                                  
  4863 00001996 8A46FE                   mov al, [bp-2]
  4864 00001999 3C6E                     cmp al, 110
  4865 0000199B 0F850600                 jne .prs222
  4866 0000199F B80A00                   mov ax, 10
  4867 000019A2 8846FE                   mov [bp-2], al
  4868                                  
  4869                                  ;-774                 if (c=='t') c= 9;
  4870                                  
  4871                                  .prs222:
  4872 000019A5 8A46FE                   mov al, [bp-2]
  4873 000019A8 3C74                     cmp al, 116
  4874 000019AA 0F850600                 jne .prs223
  4875 000019AE B80900                   mov ax, 9
  4876 000019B1 8846FE                   mov [bp-2], al
  4877                                  
  4878                                  ;-775             }
  4879                                  
  4880                                  .prs223:
  4881                                  
  4882                                  ;-776         }
  4883                                  
  4884                                  .prs221:
  4885                                  
  4886                                  ;-777         prc(c);
  4887                                  
  4888                                  .prs220:
  4889 000019B4 8A46FE                   mov al, byte [bp-2]
  4890 000019B7 B400                     mov ah, 0
  4891 000019B9 50                       push ax
  4892 000019BA E81FFF                   call prc
  4893 000019BD 83C402                   add  sp, 2
  4894                                  
  4895                                  ;-778         s++;
  4896                                  
  4897 000019C0 FF4604                   inc  word[bp+4]
  4898                                  
  4899                                  ;-779     }
  4900                                  
  4901                                  
  4902                                  ;-780 }
  4903                                  
  4904 000019C3 E978FF                   jmp .prs215
  4905                                  .prs216:
  4906                                  
  4907                                  ;-781 int printhex8a(unsigned char c) {
  4908 000019C6 C9                       LEAVE
  4909 000019C7 C3                       ret
  4910                                  ENDP
  4911                                  
  4912                                  printhex8a: PROC
  4913                                  
  4914                                  ;-782     unsigned char nib;
  4915                                  
  4916                                  
  4917                                  ;-783     nib = c >> 4; printhex4(nib);
  4918                                  
  4919                                  ;Function : printhex8a, Number of local variables: 2
  4920                                  ;   # type sign width addr used name   list of local variables
  4921                                  ;  200 var unsg byte   781 NULL c = bp+4
  4922                                  ;  201 var unsg byte   782 NULL nib = bp-2;
  4923 000019C8 C8020000                 ENTER  2,0
  4924 000019CC 8A4604                   mov al, [bp+4]
  4925 000019CF C0E804                   shr al, 4
  4926 000019D2 8846FE                   mov [bp-2], al
  4927 000019D5 8A46FE                   mov al, byte [bp-2]
  4928 000019D8 B400                     mov ah, 0
  4929 000019DA 50                       push ax
  4930 000019DB E81900                   call printhex4
  4931 000019DE 83C402                   add  sp, 2
  4932                                  
  4933                                  ;-784     nib = c & 15; printhex4(nib);
  4934                                  
  4935 000019E1 8A4604                   mov al, [bp+4]
  4936 000019E4 240F                     and al, 15
  4937 000019E6 8846FE                   mov [bp-2], al
  4938 000019E9 8A46FE                   mov al, byte [bp-2]
  4939 000019EC B400                     mov ah, 0
  4940 000019EE 50                       push ax
  4941 000019EF E80500                   call printhex4
  4942 000019F2 83C402                   add  sp, 2
  4943                                  
  4944                                  ;-785 }
  4945                                  
  4946                                  
  4947                                  ;-786 int printhex4(unsigned char c) {
  4948 000019F5 C9                       LEAVE
  4949 000019F6 C3                       ret
  4950                                  ENDP
  4951                                  
  4952                                  printhex4: PROC
  4953                                  
  4954                                  ;-787     c += 48;
  4955                                  
  4956                                  ;Function : printhex4, Number of local variables: 1
  4957                                  ;   # type sign width addr used name   list of local variables
  4958                                  ;  200 var unsg byte   786 NULL c = bp+4;
  4959 000019F7 C8000000                 ENTER  0,0
  4960 000019FB 80460430                 add  byte[bp+4], 48
  4961                                  
  4962                                  ;-788     if (c > 57) c += 7;
  4963                                  
  4964 000019FF 8A4604                   mov al, [bp+4]
  4965 00001A02 3C39                     cmp al, 57
  4966 00001A04 0F8E0400                 jle .printhex4224
  4967 00001A08 80460407                 add  byte[bp+4], 7
  4968                                  
  4969                                  ;-789     prc(c);
  4970                                  
  4971                                  .printhex4224:
  4972 00001A0C 8A4604                   mov al, byte [bp+4]
  4973 00001A0F B400                     mov ah, 0
  4974 00001A11 50                       push ax
  4975 00001A12 E8C7FE                   call prc
  4976 00001A15 83C402                   add  sp, 2
  4977                                  
  4978                                  ;-790 }
  4979                                  
  4980                                  
  4981                                  ;-791 int printhex16(unsigned int i) {
  4982 00001A18 C9                       LEAVE
  4983 00001A19 C3                       ret
  4984                                  ENDP
  4985                                  
  4986                                  printhex16: PROC
  4987                                  
  4988                                  ;-792     unsigned int half;
  4989                                  
  4990                                  
  4991                                  ;-793     half = i >>  8; printhex8a(half);
  4992                                  
  4993                                  ;Function : printhex16, Number of local variables: 2
  4994                                  ;   # type sign width addr used name   list of local variables
  4995                                  ;  200 var unsg word   791 NULL i = bp+4
  4996                                  ;  201 var unsg word   792 NULL half = bp-2;
  4997 00001A1A C8020000                 ENTER  2,0
  4998 00001A1E 8B4604                   mov ax, [bp+4]
  4999 00001A21 C1E808                   shr ax, 8
  5000 00001A24 8946FE                   mov [bp-2], ax
  5001 00001A27 FF76FE                   push word [bp-2]
  5002 00001A2A E89BFF                   call printhex8a
  5003 00001A2D 83C402                   add  sp, 2
  5004                                  
  5005                                  ;-794     half = i & 255; printhex8a(half);
  5006                                  
  5007 00001A30 8B4604                   mov ax, [bp+4]
  5008 00001A33 25FF00                   and ax, 255
  5009 00001A36 8946FE                   mov [bp-2], ax
  5010 00001A39 FF76FE                   push word [bp-2]
  5011 00001A3C E889FF                   call printhex8a
  5012 00001A3F 83C402                   add  sp, 2
  5013                                  
  5014                                  ;-795 }
  5015                                  
  5016                                  
  5017                                  ;-796 int printIntU(unsigned int n) {
  5018 00001A42 C9                       LEAVE
  5019 00001A43 C3                       ret
  5020                                  ENDP
  5021                                  
  5022                                  printIntU: PROC
  5023                                  
  5024                                  ;-797     unsigned int e;
  5025                                  
  5026                                  
  5027                                  ;-798     if ( _ n >= 10) {
  5028                                  
  5029                                  ;Function : printIntU, Number of local variables: 2
  5030                                  ;   # type sign width addr used name   list of local variables
  5031                                  ;  200 var unsg word   796 NULL n = bp+4
  5032                                  ;  201 var unsg word   797 NULL e = bp-2;
  5033 00001A44 C8020000                 ENTER  2,0 ; constant expression
  5034 00001A48 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  5035 00001A4C 0F821700                 jb  .printIntU225
  5036                                  
  5037                                  ;-799         e=n/10; //DIV
  5038                                  
  5039 00001A50 8B4604                   mov ax, [bp+4]
  5040 00001A53 BB0A00                   mov bx, 10
  5041 00001A56 BA0000                   mov dx, 0
  5042 00001A59 F7F3                     div bx
  5043 00001A5B 8946FE                   mov [bp-2], ax
  5044                                  
  5045                                  ;-800         printIntU(e);
  5046                                  
  5047 00001A5E FF76FE                   push word [bp-2]
  5048 00001A61 E8E0FF                   call printIntU
  5049 00001A64 83C402                   add  sp, 2
  5050                                  
  5051                                  ;-801     }
  5052                                  
  5053                                  
  5054                                  ;-802     n = n % 10; //unsigned mod
  5055                                  
  5056                                  .printIntU225:
  5057 00001A67 8B4604                   mov ax, [bp+4]
  5058 00001A6A BB0A00                   mov bx, 10
  5059 00001A6D BA0000                   mov dx, 0
  5060 00001A70 F7F3                     div bx
  5061 00001A72 89D0                     mov ax, dx
  5062 00001A74 894604                   mov [bp+4], ax
  5063                                  
  5064                                  ;-803     n += '0';
  5065                                  
  5066 00001A77 83460430                 add  word[bp+4], 48
  5067                                  
  5068                                  ;-804     prc(n);
  5069                                  
  5070 00001A7B FF7604                   push word [bp+4]
  5071 00001A7E E85BFE                   call prc
  5072 00001A81 83C402                   add  sp, 2
  5073                                  
  5074                                  ;-805 }
  5075                                  
  5076                                  
  5077                                  ;-806 
  5078                                  
  5079                                  
  5080                                  ;-807 int error1(char *s) {
  5081 00001A84 C9                       LEAVE
  5082 00001A85 C3                       ret
  5083                                  ENDP
  5084                                  
  5085                                  error1: PROC
  5086                                  
  5087                                  ;-808     ErrorCount++;
  5088                                  
  5089                                  ;Function : error1, Number of local variables: 1
  5090                                  ;   # type sign width addr used name   list of local variables
  5091                                  ;  200 ptr sign byte   807 NULL s = bp+4;
  5092 00001A86 C8000000                 ENTER  0,0
  5093 00001A8A FF06[1E00]               inc  word[ErrorCount]
  5094                                  
  5095                                  ;-809     prs("\n;***** next line ERROR: ");
  5096                                  
  5097 00001A8E 68[B61A]                 push error1_0
  5098 00001A91 E8A0FE                   call prs
  5099 00001A94 83C402                   add  sp, 2
  5100                                  
  5101                                  ;-810     prs(s);
  5102                                  
  5103 00001A97 FF7604                   push word [bp+4]
  5104 00001A9A E897FE                   call prs
  5105 00001A9D 83C402                   add  sp, 2
  5106                                  
  5107                                  ;-811     prs(", Symbol: ");
  5108                                  
  5109 00001AA0 68[D11A]                 push error1_1
  5110 00001AA3 E88EFE                   call prs
  5111 00001AA6 83C402                   add  sp, 2
  5112                                  
  5113                                  ;-812     prs(Symbol);
  5114                                  
  5115 00001AA9 8D063075                 lea  ax, [Symbol]
  5116 00001AAD 50                       push ax
  5117 00001AAE E883FE                   call prs
  5118 00001AB1 83C402                   add  sp, 2
  5119                                  
  5120                                  ;-813 }
  5121                                  
  5122                                  
  5123                                  ;-814 int errorexit(char *s) {
  5124 00001AB4 C9                       LEAVE
  5125 00001AB5 C3                       ret
  5126 00001AB6 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  5127 00001ABF 6E657874206C696E65-
  5128 00001AC8 204552524F523A2000 
  5129 00001AD1 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  5130 00001ADA 2000               
  5131                                  ENDP
  5132                                  
  5133                                  errorexit: PROC
  5134                                  
  5135                                  ;-815     error1(s);
  5136                                  
  5137                                  ;Function : errorexit, Number of local variables: 1
  5138                                  ;   # type sign width addr used name   list of local variables
  5139                                  ;  200 ptr sign byte   814 NULL s = bp+4;
  5140 00001ADC C8000000                 ENTER  0,0
  5141 00001AE0 FF7604                   push word [bp+4]
  5142 00001AE3 E8A0FF                   call error1
  5143 00001AE6 83C402                   add  sp, 2
  5144                                  
  5145                                  ;-816     epilog();
  5146                                  
  5147 00001AE9 E83F05                   call epilog
  5148                                  
  5149                                  ;-817     end1(1);
  5150                                  
  5151 00001AEC 6A01                     push 1
  5152 00001AEE E83206                   call end1
  5153 00001AF1 83C402                   add  sp, 2
  5154                                  
  5155                                  ;-818 }
  5156                                  
  5157                                  
  5158                                  ;-819 int notfounderror(){error1("label not found"); }
  5159 00001AF4 C9                       LEAVE
  5160 00001AF5 C3                       ret
  5161                                  ENDP
  5162                                  
  5163                                  notfounderror: PROC
  5164 00001AF6 68[001B]                 push notfounderror_0
  5165 00001AF9 E88AFF                   call error1
  5166 00001AFC 83C402                   add  sp, 2
  5167                                  
  5168                                  ;-820 int allowederror() {error1("not allowed here"); }
  5169                                  
  5170 00001AFF C3                       ret
  5171 00001B00 6C6162656C206E6F74-     notfounderror_0 db "label not found",0
  5172 00001B09 20666F756E6400     
  5173                                  ENDP
  5174                                  
  5175                                  allowederror: PROC
  5176 00001B10 68[1A1B]                 push allowederror_0
  5177 00001B13 E870FF                   call error1
  5178 00001B16 83C402                   add  sp, 2
  5179                                  
  5180                                  ;-821 int addrerror()    {error1("address missing");}
  5181                                  
  5182 00001B19 C3                       ret
  5183 00001B1A 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  5184 00001B23 6564206865726500   
  5185                                  ENDP
  5186                                  
  5187                                  addrerror: PROC
  5188 00001B2B 68[351B]                 push addrerror_0
  5189 00001B2E E855FF                   call error1
  5190 00001B31 83C402                   add  sp, 2
  5191                                  
  5192                                  ;-822 int immeerror()    {error1("immediate not allowed here");}
  5193                                  
  5194 00001B34 C3                       ret
  5195 00001B35 61646472657373206D-     addrerror_0 db "address missing",0
  5196 00001B3E 697373696E6700     
  5197                                  ENDP
  5198                                  
  5199                                  immeerror: PROC
  5200 00001B45 68[4F1B]                 push immeerror_0
  5201 00001B48 E83BFF                   call error1
  5202 00001B4B 83C402                   add  sp, 2
  5203                                  
  5204                                  ;-823 int implerror()    {error1("not implemented");}
  5205                                  
  5206 00001B4E C3                       ret
  5207 00001B4F 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  5208 00001B58 206E6F7420616C6C6F-
  5209 00001B61 776564206865726500 
  5210                                  ENDP
  5211                                  
  5212                                  implerror: PROC
  5213 00001B6A 68[741B]                 push implerror_0
  5214 00001B6D E816FF                   call error1
  5215 00001B70 83C402                   add  sp, 2
  5216                                  
  5217                                  ;-824 int indexerror()   {error1("invalid index register");}
  5218                                  
  5219 00001B73 C3                       ret
  5220 00001B74 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  5221 00001B7D 6D656E74656400     
  5222                                  ENDP
  5223                                  
  5224                                  indexerror: PROC
  5225 00001B84 68[8E1B]                 push indexerror_0
  5226 00001B87 E8FCFE                   call error1
  5227 00001B8A 83C402                   add  sp, 2
  5228                                  
  5229                                  ;-825 int invaloperror() {error1("invalid or no operands");}
  5230                                  
  5231 00001B8D C3                       ret
  5232 00001B8E 696E76616C69642069-     indexerror_0 db "invalid index register",0
  5233 00001B97 6E6465782072656769-
  5234 00001BA0 7374657200         
  5235                                  ENDP
  5236                                  
  5237                                  invaloperror: PROC
  5238 00001BA5 68[AF1B]                 push invaloperror_0
  5239 00001BA8 E8DBFE                   call error1
  5240 00001BAB 83C402                   add  sp, 2
  5241                                  
  5242                                  ;-826 int numbererror()  {error1("number expected");}
  5243                                  
  5244 00001BAE C3                       ret
  5245 00001BAF 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  5246 00001BB8 72206E6F206F706572-
  5247 00001BC1 616E647300         
  5248                                  ENDP
  5249                                  
  5250                                  numbererror: PROC
  5251 00001BC6 68[D01B]                 push numbererror_0
  5252 00001BC9 E8BAFE                   call error1
  5253 00001BCC 83C402                   add  sp, 2
  5254                                  
  5255                                  ;-827 int regmemerror()  {error1("only register or memory allowed");}
  5256                                  
  5257 00001BCF C3                       ret
  5258 00001BD0 6E756D626572206578-     numbererror_0 db "number expected",0
  5259 00001BD9 70656374656400     
  5260                                  ENDP
  5261                                  
  5262                                  regmemerror: PROC
  5263 00001BE0 68[EA1B]                 push regmemerror_0
  5264 00001BE3 E8A0FE                   call error1
  5265 00001BE6 83C402                   add  sp, 2
  5266                                  
  5267                                  ;-828 int reg16error()   {error1("only reg16, no segreg allowed");}
  5268                                  
  5269 00001BE9 C3                       ret
  5270 00001BEA 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  5271 00001BF3 73746572206F72206D-
  5272 00001BFC 656D6F727920616C6C-
  5273 00001C05 6F77656400         
  5274                                  ENDP
  5275                                  
  5276                                  reg16error: PROC
  5277 00001C0A 68[141C]                 push reg16error_0
  5278 00001C0D E876FE                   call error1
  5279 00001C10 83C402                   add  sp, 2
  5280                                  
  5281                                  ;-829 int segregerror()  {error1("segment register not allowed");}
  5282                                  
  5283 00001C13 C3                       ret
  5284 00001C14 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  5285 00001C1D 362C206E6F20736567-
  5286 00001C26 72656720616C6C6F77-
  5287 00001C2F 656400             
  5288                                  ENDP
  5289                                  
  5290                                  segregerror: PROC
  5291 00001C32 68[3C1C]                 push segregerror_0
  5292 00001C35 E84EFE                   call error1
  5293 00001C38 83C402                   add  sp, 2
  5294                                  
  5295                                  ;-830 int syntaxerror()  {error1("syntax");}
  5296                                  
  5297 00001C3B C3                       ret
  5298 00001C3C 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  5299 00001C45 65676973746572206E-
  5300 00001C4E 6F7420616C6C6F7765-
  5301 00001C57 6400               
  5302                                  ENDP
  5303                                  
  5304                                  syntaxerror: PROC
  5305 00001C59 68[631C]                 push syntaxerror_0
  5306 00001C5C E827FE                   call error1
  5307 00001C5F 83C402                   add  sp, 2
  5308                                  
  5309                                  ;-831 
  5310                                  
  5311                                  
  5312                                  ;-832 int addrexit()     {errorexit("illegal address");}
  5313                                  
  5314 00001C62 C3                       ret
  5315 00001C63 73796E74617800          syntaxerror_0 db "syntax",0
  5316                                  ENDP
  5317                                  
  5318                                  addrexit: PROC
  5319 00001C6A 68[741C]                 push addrexit_0
  5320 00001C6D E86CFE                   call errorexit
  5321 00001C70 83C402                   add  sp, 2
  5322                                  
  5323                                  ;-833 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  5324                                  
  5325 00001C73 C3                       ret
  5326 00001C74 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  5327 00001C7D 64647265737300     
  5328                                  ENDP
  5329                                  
  5330                                  dataexit: PROC
  5331 00001C84 68[8E1C]                 push dataexit_0
  5332 00001C87 E852FE                   call errorexit
  5333 00001C8A 83C402                   add  sp, 2
  5334                                  
  5335                                  ;-834 int internexit()   {errorexit("intern compiler error");}
  5336                                  
  5337 00001C8D C3                       ret
  5338 00001C8E 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  5339 00001C97 6F7220524553422C57-
  5340 00001CA0 2C4420657870656374-
  5341 00001CA9 656400             
  5342                                  ENDP
  5343                                  
  5344                                  internexit: PROC
  5345 00001CAC 68[B61C]                 push internexit_0
  5346 00001CAF E82AFE                   call errorexit
  5347 00001CB2 83C402                   add  sp, 2
  5348                                  
  5349                                  ;-835 
  5350                                  
  5351                                  
  5352                                  ;-836 
  5353                                  
  5354                                  
  5355                                  ;-837 //#include "MAIN.C"
  5356                                  
  5357                                  
  5358                                  ;-838 int main() {
  5359                                  
  5360 00001CB5 C3                       ret
  5361 00001CB6 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  5362 00001CBF 6D70696C6572206572-
  5363 00001CC8 726F7200           
  5364                                  ENDP
  5365                                  
  5366                                  main: PROC
  5367                                  
  5368                                  ;-839     getarg();
  5369                                  
  5370 00001CCC E80D00                   call getarg
  5371                                  
  5372                                  ;-840     parse();
  5373                                  
  5374 00001CCF E8DDEC                   call parse
  5375                                  
  5376                                  ;-841     fixJmp();
  5377                                  
  5378 00001CD2 E84A02                   call fixJmp
  5379                                  
  5380                                  ;-842     epilog();
  5381                                  
  5382 00001CD5 E85303                   call epilog
  5383                                  
  5384                                  ;-843     end1();
  5385                                  
  5386 00001CD8 E84804                   call end1
  5387                                  
  5388                                  ;-844 }
  5389                                  
  5390                                  
  5391                                  ;-845 
  5392                                  
  5393                                  
  5394                                  ;-846 int getarg() {
  5395                                  
  5396 00001CDB C3                       ret
  5397                                  ENDP
  5398                                  
  5399                                  getarg: PROC
  5400                                  
  5401                                  ;-847     int arglen1; int i; char *c;
  5402                                  
  5403                                  
  5404                                  ;-848     arglen1=*arglen;
  5405                                  
  5406                                  ;Function : getarg, Number of local variables: 3
  5407                                  ;   # type sign width addr used name   list of local variables
  5408                                  ;  200 var sign word   847 NULL arglen1 = bp-2
  5409                                  ;  201 var sign word   847 NULL i = bp-4
  5410                                  ;  202 ptr sign byte   847 NULL c = bp-6;
  5411 00001CDC C8060000                 ENTER  6,0
  5412 00001CE0 8B1E[5A00]               mov bx, [arglen]
  5413 00001CE4 8A07                     mov al, [bx]
  5414 00001CE6 B400                     mov ah, 0
  5415 00001CE8 8946FE                   mov [bp-2], ax
  5416                                  
  5417                                  ;-849     if (arglen1==0) {
  5418                                  
  5419 00001CEB 8B46FE                   mov ax, [bp-2]
  5420 00001CEE 83F800                   cmp ax, 0
  5421 00001CF1 0F851C00                 jne .getarg226
  5422                                  
  5423                                  ;-850         cputs(Version1);
  5424                                  
  5425 00001CF5 8D06[0300]               lea  ax, [Version1]
  5426 00001CF9 50                       push ax
  5427 00001CFA E88FF2                   call cputs
  5428 00001CFD 83C402                   add  sp, 2
  5429                                  
  5430                                  ;-851         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5431                                  
  5432 00001D00 68[8C1E]                 push getarg_0
  5433 00001D03 E886F2                   call cputs
  5434 00001D06 83C402                   add  sp, 2
  5435                                  
  5436                                  ;-852         exitR(3);
  5437                                  
  5438 00001D09 6A03                     push 3
  5439 00001D0B E8E5F2                   call exitR
  5440 00001D0E 83C402                   add  sp, 2
  5441                                  
  5442                                  ;-853     }
  5443                                  
  5444                                  
  5445                                  ;-854     i=arglen1+129;
  5446                                  
  5447                                  .getarg226:
  5448 00001D11 8B46FE                   mov ax, [bp-2]
  5449 00001D14 058100                   add ax, 129
  5450 00001D17 8946FC                   mov [bp-4], ax
  5451                                  
  5452                                  ;-855     *i=0;
  5453                                  
  5454 00001D1A B80000                   mov ax, 0
  5455 00001D1D 8B5EFC                   mov  bx, [bp-4]
  5456 00001D20 8907                     mov  [bx], ax
  5457                                  
  5458                                  ;-856     arglen1--;
  5459                                  
  5460 00001D22 FF4EFE                   dec  word[bp-2]
  5461                                  
  5462                                  ;-857     toupper(argv);
  5463                                  
  5464 00001D25 FF36[5C00]               push word [argv]
  5465 00001D29 E8FEF5                   call toupper
  5466 00001D2C 83C402                   add  sp, 2
  5467                                  
  5468                                  ;-858 
  5469                                  
  5470                                  
  5471                                  ;-859     strcpy(namein, argv); strcat1(namein, ".S");
  5472                                  
  5473 00001D2F FF36[5C00]               push word [argv]
  5474 00001D33 8D068C76                 lea  ax, [namein]
  5475 00001D37 50                       push ax
  5476 00001D38 E848F5                   call strcpy
  5477 00001D3B 83C404                   add  sp, 4
  5478 00001D3E 68[B11E]                 push getarg_1
  5479 00001D41 8D068C76                 lea  ax, [namein]
  5480 00001D45 50                       push ax
  5481 00001D46 E8BCF5                   call strcat1
  5482 00001D49 83C404                   add  sp, 4
  5483                                  
  5484                                  ;-860     strcpy(namelst,argv); strcat1(namelst,".LST");
  5485                                  
  5486 00001D4C FF36[5C00]               push word [argv]
  5487 00001D50 8D06CF76                 lea  ax, [namelst]
  5488 00001D54 50                       push ax
  5489 00001D55 E82BF5                   call strcpy
  5490 00001D58 83C404                   add  sp, 4
  5491 00001D5B 68[B41E]                 push getarg_2
  5492 00001D5E 8D06CF76                 lea  ax, [namelst]
  5493 00001D62 50                       push ax
  5494 00001D63 E89FF5                   call strcat1
  5495 00001D66 83C404                   add  sp, 4
  5496                                  
  5497                                  ;-861     strcpy(namebin,argv); strcat1(namebin,".COM");
  5498                                  
  5499 00001D69 FF36[5C00]               push word [argv]
  5500 00001D6D 8D061277                 lea  ax, [namebin]
  5501 00001D71 50                       push ax
  5502 00001D72 E80EF5                   call strcpy
  5503 00001D75 83C404                   add  sp, 4
  5504 00001D78 68[B91E]                 push getarg_3
  5505 00001D7B 8D061277                 lea  ax, [namebin]
  5506 00001D7F 50                       push ax
  5507 00001D80 E882F5                   call strcat1
  5508 00001D83 83C404                   add  sp, 4
  5509                                  
  5510                                  ;-862 
  5511                                  
  5512                                  
  5513                                  ;-863   DOS_ERR=0; PC=0; ErrorCount=0;
  5514                                  
  5515 00001D86 B80000                   mov ax, 0
  5516 00001D89 A3[1C00]                 mov word [DOS_ERR], ax
  5517 00001D8C B80000                   mov ax, 0
  5518 00001D8F A3[2300]                 mov word [PC], ax
  5519 00001D92 B80000                   mov ax, 0
  5520 00001D95 A3[1E00]                 mov word [ErrorCount], ax
  5521                                  
  5522                                  ;-864 
  5523                                  
  5524                                  
  5525                                  ;-865     asm_fd=openR (namein);
  5526                                  
  5527 00001D98 8D068C76                 lea  ax, [namein]
  5528 00001D9C 50                       push ax
  5529 00001D9D E823F2                   call openR
  5530 00001DA0 83C402                   add  sp, 2
  5531 00001DA3 A3[1600]                 mov word [asm_fd], ax
  5532                                  
  5533                                  ;-866     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5534                                  
  5535 00001DA6 A1[1C00]                 mov ax, [DOS_ERR]
  5536 00001DA9 08C0                     or  al, al
  5537 00001DAB 0F841C00                 je .getarg227
  5538 00001DAF 68[BE1E]                 push getarg_4
  5539 00001DB2 E8D7F1                   call cputs
  5540 00001DB5 83C402                   add  sp, 2
  5541 00001DB8 8D068C76                 lea  ax, [namein]
  5542 00001DBC 50                       push ax
  5543 00001DBD E8CCF1                   call cputs
  5544 00001DC0 83C402                   add  sp, 2
  5545 00001DC3 6A01                     push 1
  5546 00001DC5 E82BF2                   call exitR
  5547 00001DC8 83C402                   add  sp, 2
  5548                                  
  5549                                  ;-867     lst_fd=creatR(namelst);
  5550                                  
  5551                                  .getarg227:
  5552 00001DCB 8D06CF76                 lea  ax, [namelst]
  5553 00001DCF 50                       push ax
  5554 00001DD0 E8FFF1                   call creatR
  5555 00001DD3 83C402                   add  sp, 2
  5556 00001DD6 A3[1800]                 mov word [lst_fd], ax
  5557                                  
  5558                                  ;-868     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5559                                  
  5560 00001DD9 A1[1C00]                 mov ax, [DOS_ERR]
  5561 00001DDC 08C0                     or  al, al
  5562 00001DDE 0F841C00                 je .getarg228
  5563 00001DE2 68[D41E]                 push getarg_5
  5564 00001DE5 E8A4F1                   call cputs
  5565 00001DE8 83C402                   add  sp, 2
  5566 00001DEB 8D06CF76                 lea  ax, [namelst]
  5567 00001DEF 50                       push ax
  5568 00001DF0 E899F1                   call cputs
  5569 00001DF3 83C402                   add  sp, 2
  5570 00001DF6 6A02                     push 2
  5571 00001DF8 E8F8F1                   call exitR
  5572 00001DFB 83C402                   add  sp, 2
  5573                                  
  5574                                  ;-869     bin_fd=creatR(namebin);
  5575                                  
  5576                                  .getarg228:
  5577 00001DFE 8D061277                 lea  ax, [namebin]
  5578 00001E02 50                       push ax
  5579 00001E03 E8CCF1                   call creatR
  5580 00001E06 83C402                   add  sp, 2
  5581 00001E09 A3[1A00]                 mov word [bin_fd], ax
  5582                                  
  5583                                  ;-870     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5584                                  
  5585 00001E0C A1[1C00]                 mov ax, [DOS_ERR]
  5586 00001E0F 08C0                     or  al, al
  5587 00001E11 0F841C00                 je .getarg229
  5588 00001E15 68[EB1E]                 push getarg_6
  5589 00001E18 E871F1                   call cputs
  5590 00001E1B 83C402                   add  sp, 2
  5591 00001E1E 8D061277                 lea  ax, [namebin]
  5592 00001E22 50                       push ax
  5593 00001E23 E866F1                   call cputs
  5594 00001E26 83C402                   add  sp, 2
  5595 00001E29 6A02                     push 2
  5596 00001E2B E8C5F1                   call exitR
  5597 00001E2E 83C402                   add  sp, 2
  5598                                  
  5599                                  ;-871 
  5600                                  
  5601                                  
  5602                                  ;-872     prs(";");
  5603                                  
  5604                                  .getarg229:
  5605 00001E31 68[011F]                 push getarg_7
  5606 00001E34 E8FDFA                   call prs
  5607 00001E37 83C402                   add  sp, 2
  5608                                  
  5609                                  ;-873     prs(Version1);
  5610                                  
  5611 00001E3A 8D06[0300]               lea  ax, [Version1]
  5612 00001E3E 50                       push ax
  5613 00001E3F E8F2FA                   call prs
  5614 00001E42 83C402                   add  sp, 2
  5615                                  
  5616                                  ;-874     prs(", Source: "); prs(namein);
  5617                                  
  5618 00001E45 68[031F]                 push getarg_8
  5619 00001E48 E8E9FA                   call prs
  5620 00001E4B 83C402                   add  sp, 2
  5621 00001E4E 8D068C76                 lea  ax, [namein]
  5622 00001E52 50                       push ax
  5623 00001E53 E8DEFA                   call prs
  5624 00001E56 83C402                   add  sp, 2
  5625                                  
  5626                                  ;-875     prs(", Output: "); prs(namelst);
  5627                                  
  5628 00001E59 68[0E1F]                 push getarg_9
  5629 00001E5C E8D5FA                   call prs
  5630 00001E5F 83C402                   add  sp, 2
  5631 00001E62 8D06CF76                 lea  ax, [namelst]
  5632 00001E66 50                       push ax
  5633 00001E67 E8CAFA                   call prs
  5634 00001E6A 83C402                   add  sp, 2
  5635                                  
  5636                                  ;-876     prs(", "); prs(namebin);
  5637                                  
  5638 00001E6D 68[191F]                 push getarg_10
  5639 00001E70 E8C1FA                   call prs
  5640 00001E73 83C402                   add  sp, 2
  5641 00001E76 8D061277                 lea  ax, [namebin]
  5642 00001E7A 50                       push ax
  5643 00001E7B E8B6FA                   call prs
  5644 00001E7E 83C402                   add  sp, 2
  5645                                  
  5646                                  ;-877     prs("\n");
  5647                                  
  5648 00001E81 68[1C1F]                 push getarg_11
  5649 00001E84 E8ADFA                   call prs
  5650 00001E87 83C402                   add  sp, 2
  5651                                  
  5652                                  ;-878 }
  5653                                  
  5654                                  
  5655                                  ;-879 
  5656                                  
  5657                                  
  5658                                  ;-880 int fixJmp() {   
  5659 00001E8A C9                       LEAVE
  5660 00001E8B C3                       ret
  5661 00001E8C 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5662 00001E95 41532E434F4D206669-
  5663 00001E9E 6C656E616D65205B77-
  5664 00001EA7 2F6F202E535D203A20-
  5665 00001EB0 00                 
  5666 00001EB1 2E5300                  getarg_1 db ".S",0
  5667 00001EB4 2E4C535400              getarg_2 db ".LST",0
  5668 00001EB9 2E434F4D00              getarg_3 db ".COM",0
  5669 00001EBE 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5670 00001EC7 6C65206D697373696E-
  5671 00001ED0 673A2000           
  5672 00001ED4 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5673 00001EDD 206E6F742063726561-
  5674 00001EE6 74653A2000         
  5675 00001EEB 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5676 00001EF4 6E6F74206372656174-
  5677 00001EFD 653A2000           
  5678 00001F01 3B00                    getarg_7 db ";",0
  5679 00001F03 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5680 00001F0C 2000               
  5681 00001F0E 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5682 00001F17 2000               
  5683 00001F19 2C2000                  getarg_10 db ", ",0
  5684 00001F1C 5C6E00                  getarg_11 db "\n",0
  5685                                  ENDP
  5686                                  
  5687                                  fixJmp: PROC
  5688                                  
  5689                                  ;-881     //todo ENDP: search backwards until tmpJmpMaxIx
  5690                                  
  5691                                  
  5692                                  ;-882     
  5693                                  
  5694                                  
  5695                                  ;-883     int i;  unsigned int hex; unsigned int hex1; 
  5696                                  
  5697                                  
  5698                                  ;-884     char *p; int Ix; char c;
  5699                                  
  5700                                  
  5701                                  ;-885     i=1;
  5702                                  
  5703                                  ;Function : fixJmp, Number of local variables: 6
  5704                                  ;   # type sign width addr used name   list of local variables
  5705                                  ;  200 var sign word   883 NULL i = bp-2
  5706                                  ;  201 var unsg word   883 NULL hex = bp-4
  5707                                  ;  202 var unsg word   883 NULL hex1 = bp-6
  5708                                  ;  203 ptr sign byte   884 NULL p = bp-8
  5709                                  ;  204 var sign word   884 NULL Ix = bp-10
  5710                                  ;  205 var sign byte   884 NULL c = bp-12;
  5711 00001F1F C80C0000                 ENTER  12,0
  5712 00001F23 B80100                   mov ax, 1
  5713 00001F26 8946FE                   mov [bp-2], ax
  5714                                  
  5715                                  ;-886     prs("\n;END open jmp: ");
  5716                                  
  5717 00001F29 68[0920]                 push fixJmp_0
  5718 00001F2C E805FA                   call prs
  5719 00001F2F 83C402                   add  sp, 2
  5720                                  
  5721                                  ;-887     printIntU(JmpMaxIx);
  5722                                  
  5723 00001F32 FF36[5400]               push word [JmpMaxIx]
  5724 00001F36 E80BFB                   call printIntU
  5725 00001F39 83C402                   add  sp, 2
  5726                                  
  5727                                  ;-888     p = &JmpNames;
  5728                                  
  5729 00001F3C B87A93                   mov ax, JmpNames
  5730 00001F3F 8946F8                   mov [bp-8], ax
  5731                                  
  5732                                  ;-889     while (i <= JmpMaxIx) {
  5733                                  
  5734                                  .fixJmp230:
  5735 00001F42 8B46FE                   mov ax, [bp-2]
  5736 00001F45 3B06[5400]               cmp ax, [JmpMaxIx]
  5737 00001F49 0F8FBA00                 jg  .fixJmp231
  5738                                  
  5739                                  ;-890         strcpy(Symbol, p);
  5740                                  
  5741 00001F4D FF76F8                   push word [bp-8]
  5742 00001F50 8D063075                 lea  ax, [Symbol]
  5743 00001F54 50                       push ax
  5744 00001F55 E82BF3                   call strcpy
  5745 00001F58 83C404                   add  sp, 4
  5746                                  
  5747                                  ;-891         p = strlen(Symbol) + p;
  5748                                  
  5749 00001F5B 8D063075                 lea  ax, [Symbol]
  5750 00001F5F 50                       push ax
  5751 00001F60 E8F8F2                   call strlen
  5752 00001F63 83C402                   add  sp, 2
  5753 00001F66 0346F8                   add ax, [bp-8]
  5754 00001F69 8946F8                   mov [bp-8], ax
  5755                                  
  5756                                  ;-892         p++;
  5757                                  
  5758 00001F6C FF46F8                   inc  word[bp-8]
  5759                                  
  5760                                  ;-893         hex = JmpAddr[i];//hex point to PC at low byte of addr 
  5761                                  
  5762 00001F6F 8B5EFE                   mov bx, [bp-2]
  5763 00001F72 D1E3                     shl bx, 1
  5764 00001F74 8B871AA3                 mov ax, [JmpAddr + bx]
  5765 00001F78 8946FC                   mov [bp-4], ax
  5766                                  
  5767                                  ;-894         hex1 = hex + 1;
  5768                                  
  5769 00001F7B 8B46FC                   mov ax, [bp-4]
  5770 00001F7E 83C001                   add ax, 1
  5771 00001F81 8946FA                   mov [bp-6], ax
  5772                                  
  5773                                  ;-895         
  5774                                  
  5775                                  
  5776                                  ;-896         Ix=searchLabel();
  5777                                  
  5778 00001F84 E8F0EC                   call searchLabel
  5779 00001F87 8946F6                   mov [bp-10], ax
  5780                                  
  5781                                  ;-897         if (Ix == 0) error1("Label not found");
  5782                                  
  5783 00001F8A 8B46F6                   mov ax, [bp-10]
  5784 00001F8D 83F800                   cmp ax, 0
  5785 00001F90 0F850900                 jne .fixJmp232
  5786 00001F94 68[1B20]                 push fixJmp_1
  5787 00001F97 E8ECFA                   call error1
  5788 00001F9A 83C402                   add  sp, 2
  5789                                  
  5790                                  ;-898         disp = LabelAddr[Ix];   
  5791                                  
  5792                                  .fixJmp232:
  5793 00001F9D 8B5EF6                   mov bx, [bp-10]
  5794 00001FA0 D1E3                     shl bx, 1
  5795 00001FA2 8B87CA8E                 mov ax, [LabelAddr + bx]
  5796 00001FA6 A3[3D00]                 mov word [disp], ax
  5797                                  
  5798                                  ;-899         c = FileBin[hex1];//look for 'A' push Absolute
  5799                                  
  5800 00001FA9 8B5EFA                   mov bx, [bp-6]
  5801 00001FAC 8A87AAA4                 mov al, [FileBin + bx]
  5802 00001FB0 8846F4                   mov [bp-12], al
  5803                                  
  5804                                  ;-900         if (c == 'A') disp = hex;
  5805                                  
  5806 00001FB3 8A46F4                   mov al, [bp-12]
  5807 00001FB6 3C41                     cmp al, 65
  5808 00001FB8 0F850900                 jne .fixJmp233
  5809 00001FBC 8B46FC                   mov ax, [bp-4]
  5810 00001FBF A3[3D00]                 mov word [disp], ax
  5811                                  
  5812                                  ;-901         else {
  5813                                  
  5814 00001FC2 E91C00                   jmp .fixJmp234
  5815                                  .fixJmp233:
  5816                                  
  5817                                  ;-902             disp = disp - hex;
  5818                                  
  5819 00001FC5 A1[3D00]                 mov ax, [disp]
  5820 00001FC8 2B46FC                   sub ax, [bp-4]
  5821 00001FCB A3[3D00]                 mov word [disp], ax
  5822                                  
  5823                                  ;-903             disp = disp +2;//PC points to next instruction
  5824                                  
  5825 00001FCE A1[3D00]                 mov ax, [disp]
  5826 00001FD1 83C002                   add ax, 2
  5827 00001FD4 A3[3D00]                 mov word [disp], ax
  5828                                  
  5829                                  ;-904             disp = disp - Origin;
  5830                                  
  5831 00001FD7 A1[3D00]                 mov ax, [disp]
  5832 00001FDA 2B06[2500]               sub ax, [Origin]
  5833 00001FDE A3[3D00]                 mov word [disp], ax
  5834                                  
  5835                                  ;-905         }
  5836                                  
  5837                                  
  5838                                  ;-906 
  5839                                  
  5840                                  
  5841                                  ;-907             FileBin[hex] = disp;//fix low byte
  5842                                  
  5843                                  .fixJmp234:
  5844 00001FE1 A1[3D00]                 mov ax, [disp]
  5845 00001FE4 8B5EFC                   mov bx, [bp-4]
  5846 00001FE7 8887AAA4                 mov [FileBin+bx], al
  5847                                  
  5848                                  ;-908             hex++;
  5849                                  
  5850 00001FEB FF46FC                   inc  word[bp-4]
  5851                                  
  5852                                  ;-909             disp = disp >> 8;
  5853                                  
  5854 00001FEE A1[3D00]                 mov ax, [disp]
  5855 00001FF1 C1E808                   shr ax, 8
  5856 00001FF4 A3[3D00]                 mov word [disp], ax
  5857                                  
  5858                                  ;-910             FileBin[hex] = disp;
  5859                                  
  5860 00001FF7 A1[3D00]                 mov ax, [disp]
  5861 00001FFA 8B5EFC                   mov bx, [bp-4]
  5862 00001FFD 8887AAA4                 mov [FileBin+bx], al
  5863                                  
  5864                                  ;-911         i++;
  5865                                  
  5866 00002001 FF46FE                   inc  word[bp-2]
  5867                                  
  5868                                  ;-912     }
  5869                                  
  5870                                  
  5871                                  ;-913 }
  5872                                  
  5873 00002004 E93BFF                   jmp .fixJmp230
  5874                                  .fixJmp231:
  5875                                  
  5876                                  ;-914 
  5877                                  
  5878                                  
  5879                                  ;-915 int epilog() {
  5880 00002007 C9                       LEAVE
  5881 00002008 C3                       ret
  5882 00002009 5C6E3B454E44206F70-     fixJmp_0 db "\n;END open jmp: ",0
  5883 00002012 656E206A6D703A2000 
  5884 0000201B 4C6162656C206E6F74-     fixJmp_1 db "Label not found",0
  5885 00002024 20666F756E6400     
  5886                                  ENDP
  5887                                  
  5888                                  epilog: PROC
  5889                                  
  5890                                  ;-916     unsigned int i; char c;     int j;
  5891                                  
  5892                                  
  5893                                  ;-917     prs("\n Errors: ");
  5894                                  
  5895                                  ;Function : epilog, Number of local variables: 3
  5896                                  ;   # type sign width addr used name   list of local variables
  5897                                  ;  200 var unsg word   916 NULL i = bp-2
  5898                                  ;  201 var sign byte   916 NULL c = bp-4
  5899                                  ;  202 var sign word   916 NULL j = bp-6;
  5900 0000202B C8060000                 ENTER  6,0
  5901 0000202F 68[E620]                 push epilog_0
  5902 00002032 E8FFF8                   call prs
  5903 00002035 83C402                   add  sp, 2
  5904                                  
  5905                                  ;-918     printIntU(ErrorCount);
  5906                                  
  5907 00002038 FF36[1E00]               push word [ErrorCount]
  5908 0000203C E805FA                   call printIntU
  5909 0000203F 83C402                   add  sp, 2
  5910                                  
  5911                                  ;-919     if (ErrorCount) prs(" ***ERROR*** ");
  5912                                  
  5913 00002042 A1[1E00]                 mov ax, [ErrorCount]
  5914 00002045 08C0                     or  al, al
  5915 00002047 0F840900                 je .epilog235
  5916 0000204B 68[F220]                 push epilog_1
  5917 0000204E E8E3F8                   call prs
  5918 00002051 83C402                   add  sp, 2
  5919                                  
  5920                                  ;-920     prs(", Out: ");
  5921                                  
  5922                                  .epilog235:
  5923 00002054 68[0021]                 push epilog_2
  5924 00002057 E8DAF8                   call prs
  5925 0000205A 83C402                   add  sp, 2
  5926                                  
  5927                                  ;-921     prs(namelst);
  5928                                  
  5929 0000205D 8D06CF76                 lea  ax, [namelst]
  5930 00002061 50                       push ax
  5931 00002062 E8CFF8                   call prs
  5932 00002065 83C402                   add  sp, 2
  5933                                  
  5934                                  ;-922     prs(", ");
  5935                                  
  5936 00002068 68[0821]                 push epilog_3
  5937 0000206B E8C6F8                   call prs
  5938 0000206E 83C402                   add  sp, 2
  5939                                  
  5940                                  ;-923     prs(namebin);
  5941                                  
  5942 00002071 8D061277                 lea  ax, [namebin]
  5943 00002075 50                       push ax
  5944 00002076 E8BBF8                   call prs
  5945 00002079 83C402                   add  sp, 2
  5946                                  
  5947                                  ;-924     prs("= ");
  5948                                  
  5949 0000207C 68[0B21]                 push epilog_4
  5950 0000207F E8B2F8                   call prs
  5951 00002082 83C402                   add  sp, 2
  5952                                  
  5953                                  ;-925     printIntU(BinLen);
  5954                                  
  5955 00002085 FF36[5800]               push word [BinLen]
  5956 00002089 E8B8F9                   call printIntU
  5957 0000208C 83C402                   add  sp, 2
  5958                                  
  5959                                  ;-926     prs(" bytes.");
  5960                                  
  5961 0000208F 68[0E21]                 push epilog_5
  5962 00002092 E89FF8                   call prs
  5963 00002095 83C402                   add  sp, 2
  5964                                  
  5965                                  ;-927 
  5966                                  
  5967                                  
  5968                                  ;-928     i=0;
  5969                                  
  5970 00002098 B80000                   mov ax, 0
  5971 0000209B 8946FE                   mov [bp-2], ax
  5972                                  
  5973                                  ;-929     do {
  5974                                  
  5975                                  .epilog236:
  5976                                  
  5977                                  ;-930         c = FileBin[i];
  5978                                  
  5979 0000209E 8B5EFE                   mov bx, [bp-2]
  5980 000020A1 8A87AAA4                 mov al, [FileBin + bx]
  5981 000020A5 8846FC                   mov [bp-4], al
  5982                                  
  5983                                  ;-931         fputcR(c, bin_fd);
  5984                                  
  5985 000020A8 FF36[1A00]               push word [bin_fd]
  5986 000020AC 8A46FC                   mov al, byte [bp-4]
  5987 000020AF B400                     mov ah, 0
  5988 000020B1 50                       push ax
  5989 000020B2 E861EF                   call fputcR
  5990 000020B5 83C404                   add  sp, 4
  5991                                  
  5992                                  ;-932 //printhex8a(c); prc(' ');
  5993                                  
  5994                                  
  5995                                  ;-933         i++;
  5996                                  
  5997 000020B8 FF46FE                   inc  word[bp-2]
  5998                                  
  5999                                  ;-934     } while (i < BinLen);
  6000                                  
  6001 000020BB 8B46FE                   mov ax, [bp-2]
  6002 000020BE 3B06[5800]               cmp ax, [BinLen]
  6003 000020C2 0F8D0200                 jge .epilog237
  6004 000020C6 EBD6                     jmp .epilog236
  6005                                  .epilog237:
  6006                                  
  6007                                  ;-935 
  6008                                  
  6009                                  
  6010                                  ;-936   prs(" Labels: ");
  6011                                  
  6012 000020C8 68[1621]                 push epilog_6
  6013 000020CB E866F8                   call prs
  6014 000020CE 83C402                   add  sp, 2
  6015                                  
  6016                                  ;-937   printIntU(LabelMaxIx);
  6017                                  
  6018 000020D1 FF36[4A00]               push word [LabelMaxIx]
  6019 000020D5 E86CF9                   call printIntU
  6020 000020D8 83C402                   add  sp, 2
  6021                                  
  6022                                  ;-938   prs(". ");
  6023                                  
  6024 000020DB 68[2021]                 push epilog_7
  6025 000020DE E853F8                   call prs
  6026 000020E1 83C402                   add  sp, 2
  6027                                  
  6028                                  ;-939 /*
  6029                                  
  6030                                  
  6031                                  ;-940   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);
  6032                                  
  6033                                  
  6034                                  ;-941   i= &LabelNames;
  6035                                  
  6036                                  
  6037                                  ;-942   prs(" &LabelNames:"); printIntU(i);
  6038                                  
  6039                                  
  6040                                  ;-943   i=LabelNamePtr-i;
  6041                                  
  6042                                  
  6043                                  ;-944   prs("size: ");
  6044                                  
  6045                                  
  6046                                  ;-945   printIntU(i);
  6047                                  
  6048                                  
  6049                                  ;-946   prs(". >>");
  6050                                  
  6051                                  
  6052                                  ;-947   i= &LabelNames;
  6053                                  
  6054                                  
  6055                                  ;-948   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6056                                  
  6057                                  
  6058                                  ;-949   } while (i < LabelNamePtr); prs("<< \n");
  6059                                  
  6060                                  
  6061                                  ;-950    i = 1;
  6062                                  
  6063                                  
  6064                                  ;-951     LabelNamePtr= &LabelNames;
  6065                                  
  6066                                  
  6067                                  ;-952     do {
  6068                                  
  6069                                  
  6070                                  ;-953       prs(LabelNamePtr); prc(' ');
  6071                                  
  6072                                  
  6073                                  ;-954       j=LabelAddr[i]; printhex16(j); prs(", ");
  6074                                  
  6075                                  
  6076                                  ;-955       j=strlen(LabelNamePtr);//get end of actual name
  6077                                  
  6078                                  
  6079                                  ;-956       LabelNamePtr=LabelNamePtr+j;
  6080                                  
  6081                                  
  6082                                  ;-957       LabelNamePtr++;
  6083                                  
  6084                                  
  6085                                  ;-958       i++;
  6086                                  
  6087                                  
  6088                                  ;-959     } while (i <= LabelMaxIx);
  6089                                  
  6090                                  
  6091                                  ;-960 */
  6092                                  
  6093                                  
  6094                                  ;-961 }
  6095                                  
  6096                                  
  6097                                  ;-962 
  6098                                  
  6099                                  
  6100                                  ;-963 int end1(int n) {
  6101 000020E4 C9                       LEAVE
  6102 000020E5 C3                       ret
  6103 000020E6 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6104 000020EF 3A2000             
  6105 000020F2 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6106 000020FB 2A2A2A2000         
  6107 00002100 2C204F75743A2000        epilog_2 db ", Out: ",0
  6108 00002108 2C2000                  epilog_3 db ", ",0
  6109 0000210B 3D2000                  epilog_4 db "= ",0
  6110 0000210E 2062797465732E00        epilog_5 db " bytes.",0
  6111 00002116 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6112 0000211F 00                 
  6113 00002120 2E2000                  epilog_7 db ". ",0
  6114                                  ENDP
  6115                                  
  6116                                  end1: PROC
  6117                                  
  6118                                  ;-964     fcloseR(asm_fd);
  6119                                  
  6120                                  ;Function : end1, Number of local variables: 1
  6121                                  ;   # type sign width addr used name   list of local variables
  6122                                  ;  200 var sign word   963 NULL n = bp+4;
  6123 00002123 C8000000                 ENTER  0,0
  6124 00002127 FF36[1600]               push word [asm_fd]
  6125 0000212B E8B6EE                   call fcloseR
  6126 0000212E 83C402                   add  sp, 2
  6127                                  
  6128                                  ;-965     fcloseR(lst_fd);
  6129                                  
  6130 00002131 FF36[1800]               push word [lst_fd]
  6131 00002135 E8ACEE                   call fcloseR
  6132 00002138 83C402                   add  sp, 2
  6133                                  
  6134                                  ;-966     fcloseR(bin_fd);
  6135                                  
  6136 0000213B FF36[1A00]               push word [bin_fd]
  6137 0000213F E8A2EE                   call fcloseR
  6138 00002142 83C402                   add  sp, 2
  6139                                  
  6140                                  ;-967     exitR(n);
  6141                                  
  6142 00002145 FF7604                   push word [bp+4]
  6143 00002148 E8A8EE                   call exitR
  6144 0000214B 83C402                   add  sp, 2
  6145                                  
  6146                                  ;-968 }
  6147                                  
  6148                                  
  6149                                  ;-969 
  6150                                  
  6151                                  
  6152                                  ;-970 
  6153                                  
  6154                                  
  6155                                  ;-971 //#include "GENCODE.C"
  6156                                  
  6157                                  
  6158                                  ;-972 // generate code
  6159                                  
  6160                                  
  6161                                  ;-973 int getCodes() {
  6162 0000214E C9                       LEAVE
  6163 0000214F C3                       ret
  6164                                  ENDP
  6165                                  
  6166                                  getCodes: PROC
  6167                                  
  6168                                  ;-974     OpCodePtr ++; Code1 = *OpCodePtr;
  6169                                  
  6170 00002150 FF06[4300]               inc  word[OpCodePtr]
  6171 00002154 8B1E[4300]               mov bx, [OpCodePtr]
  6172 00002158 8A07                     mov al, [bx]
  6173 0000215A B400                     mov ah, 0
  6174 0000215C A2[3000]                 mov byte [Code1], al
  6175                                  
  6176                                  ;-975     OpCodePtr ++; Code2 = *OpCodePtr;
  6177                                  
  6178 0000215F FF06[4300]               inc  word[OpCodePtr]
  6179 00002163 8B1E[4300]               mov bx, [OpCodePtr]
  6180 00002167 8A07                     mov al, [bx]
  6181 00002169 B400                     mov ah, 0
  6182 0000216B A2[3100]                 mov byte [Code2], al
  6183                                  
  6184                                  ;-976     OpCodePtr ++; Code3 = *OpCodePtr;
  6185                                  
  6186 0000216E FF06[4300]               inc  word[OpCodePtr]
  6187 00002172 8B1E[4300]               mov bx, [OpCodePtr]
  6188 00002176 8A07                     mov al, [bx]
  6189 00002178 B400                     mov ah, 0
  6190 0000217A A2[3200]                 mov byte [Code3], al
  6191                                  
  6192                                  ;-977 }
  6193                                  
  6194                                  
  6195                                  ;-978 int gen66h() {genCode8(0x66);
  6196                                  
  6197 0000217D C3                       ret
  6198                                  ENDP
  6199                                  
  6200                                  gen66h: PROC
  6201 0000217E 6A66                     push 102
  6202 00002180 E83B00                   call genCode8
  6203 00002183 83C402                   add  sp, 2
  6204                                  
  6205                                  ;-979 }
  6206                                  
  6207                                  
  6208                                  ;-980 int genCode2(char c, char d) {
  6209                                  
  6210 00002186 C3                       ret
  6211                                  ENDP
  6212                                  
  6213                                  genCode2: PROC
  6214                                  
  6215                                  ;-981     c = c + d;
  6216                                  
  6217                                  ;Function : genCode2, Number of local variables: 2
  6218                                  ;   # type sign width addr used name   list of local variables
  6219                                  ;  200 var sign byte   980 NULL c = bp+4
  6220                                  ;  201 var sign byte   980 NULL d = bp+6;
  6221 00002187 C8000000                 ENTER  0,0
  6222 0000218B 8A4604                   mov al, [bp+4]
  6223 0000218E 024606                   add al, [bp+6]
  6224 00002191 884604                   mov [bp+4], al
  6225                                  
  6226                                  ;-982     genCode8(c);
  6227                                  
  6228 00002194 8A4604                   mov al, byte [bp+4]
  6229 00002197 B400                     mov ah, 0
  6230 00002199 50                       push ax
  6231 0000219A E82100                   call genCode8
  6232 0000219D 83C402                   add  sp, 2
  6233                                  
  6234                                  ;-983 }
  6235                                  
  6236                                  
  6237                                  ;-984 int genCodeW(char c) {
  6238 000021A0 C9                       LEAVE
  6239 000021A1 C3                       ret
  6240                                  ENDP
  6241                                  
  6242                                  genCodeW: PROC
  6243                                  
  6244                                  ;-985     c = c + wflag;
  6245                                  
  6246                                  ;Function : genCodeW, Number of local variables: 1
  6247                                  ;   # type sign width addr used name   list of local variables
  6248                                  ;  200 var sign byte   984 NULL c = bp+4;
  6249 000021A2 C8000000                 ENTER  0,0
  6250 000021A6 8A4604                   mov al, [bp+4]
  6251 000021A9 0206[3800]               add al, [wflag]
  6252 000021AD 884604                   mov [bp+4], al
  6253                                  
  6254                                  ;-986     genCode8(c);
  6255                                  
  6256 000021B0 8A4604                   mov al, byte [bp+4]
  6257 000021B3 B400                     mov ah, 0
  6258 000021B5 50                       push ax
  6259 000021B6 E80500                   call genCode8
  6260 000021B9 83C402                   add  sp, 2
  6261                                  
  6262                                  ;-987 }
  6263                                  
  6264                                  
  6265                                  ;-988 int genCode8(char c) {
  6266 000021BC C9                       LEAVE
  6267 000021BD C3                       ret
  6268                                  ENDP
  6269                                  
  6270                                  genCode8: PROC
  6271                                  
  6272                                  ;-989 //set: BinLen++, OpPrintIndex++
  6273                                  
  6274                                  
  6275                                  ;-990     FileBin[BinLen]=c;
  6276                                  
  6277                                  ;Function : genCode8, Number of local variables: 1
  6278                                  ;   # type sign width addr used name   list of local variables
  6279                                  ;  200 var sign byte   988 NULL c = bp+4;
  6280 000021BE C8000000                 ENTER  0,0
  6281 000021C2 8A4604                   mov al, [bp+4]
  6282 000021C5 8B1E[5800]               mov bx, [BinLen]
  6283 000021C9 8887AAA4                 mov [FileBin+bx], al
  6284                                  
  6285                                  ;-991     BinLen++;
  6286                                  
  6287 000021CD FF06[5800]               inc  word[BinLen]
  6288                                  
  6289                                  ;-992     PC++;
  6290                                  
  6291 000021D1 FF06[2300]               inc  word[PC]
  6292                                  
  6293                                  ;-993     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6294                                  
  6295 000021D5 A1[5800]                 mov ax, [BinLen]
  6296 000021D8 3D204E                   cmp ax, 20000 ;unsigned : 0
  6297 000021DB 0F820900                 jb  .genCode8238
  6298 000021DF 68[0322]                 push genCode8_0
  6299 000021E2 E8F7F8                   call errorexit
  6300 000021E5 83C402                   add  sp, 2
  6301                                  
  6302                                  ;-994     if (OpPrintIndex < OPMAXLEN) {
  6303                                  
  6304                                  .genCode8238:
  6305 000021E8 A1[4100]                 mov ax, [OpPrintIndex]
  6306 000021EB 83F805                   cmp ax, 5
  6307 000021EE 0F8D0F00                 jge .genCode8239
  6308                                  
  6309                                  ;-995         OpPos[OpPrintIndex]=c;
  6310                                  
  6311 000021F2 8A4604                   mov al, [bp+4]
  6312 000021F5 8B1E[4100]               mov bx, [OpPrintIndex]
  6313 000021F9 88875577                 mov [OpPos+bx], al
  6314                                  
  6315                                  ;-996         OpPrintIndex++;
  6316                                  
  6317 000021FD FF06[4100]               inc  word[OpPrintIndex]
  6318                                  
  6319                                  ;-997     }
  6320                                  
  6321                                  
  6322                                  ;-998 }
  6323                                  
  6324                                  .genCode8239:
  6325                                  
  6326                                  ;-999 int genCode16(unsigned int i) {
  6327 00002201 C9                       LEAVE
  6328 00002202 C3                       ret
  6329 00002203 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6330 0000220C 746F6F206C6F6E6700 
  6331                                  ENDP
  6332                                  
  6333                                  genCode16: PROC
  6334                                  
  6335                                  ;-1000     genCode8(i); i=i >> 8;
  6336                                  
  6337                                  ;Function : genCode16, Number of local variables: 1
  6338                                  ;   # type sign width addr used name   list of local variables
  6339                                  ;  200 var unsg word   999 NULL i = bp+4;
  6340 00002215 C8000000                 ENTER  0,0
  6341 00002219 FF7604                   push word [bp+4]
  6342 0000221C E89FFF                   call genCode8
  6343 0000221F 83C402                   add  sp, 2
  6344 00002222 8B4604                   mov ax, [bp+4]
  6345 00002225 C1E808                   shr ax, 8
  6346 00002228 894604                   mov [bp+4], ax
  6347                                  
  6348                                  ;-1001     genCode8(i);
  6349                                  
  6350 0000222B FF7604                   push word [bp+4]
  6351 0000222E E88DFF                   call genCode8
  6352 00002231 83C402                   add  sp, 2
  6353                                  
  6354                                  ;-1002 }
  6355                                  
  6356                                  
  6357                                  ;-1003 int genCode32(unsigned long L) {
  6358 00002234 C9                       LEAVE
  6359 00002235 C3                       ret
  6360                                  ENDP
  6361                                  
  6362                                  genCode32: PROC
  6363                                  
  6364                                  ;-1004     genCode16(L); L=L >>16;
  6365                                  
  6366                                  ;Function : genCode32, Number of local variables: 1
  6367                                  ;   # type sign width addr used name   list of local variables
  6368                                  ;  200 var unsg dwrd  1003 NULL L = bp+4;
  6369 00002236 C8000000                 ENTER  0,0
  6370 0000223A 8A4604                   mov al, byte [bp+4]
  6371 0000223D B400                     mov ah, 0
  6372 0000223F 50                       push ax
  6373 00002240 E8D2FF                   call genCode16
  6374 00002243 83C402                   add  sp, 2
  6375 00002246 668B4604                 mov eax, [bp+4]
  6376 0000224A 66C1E810                 shr eax, 16
  6377 0000224E 66894604                 mov [bp+4], eax
  6378                                  
  6379                                  ;-1005     genCode16(L);
  6380                                  
  6381 00002252 8A4604                   mov al, byte [bp+4]
  6382 00002255 B400                     mov ah, 0
  6383 00002257 50                       push ax
  6384 00002258 E8BAFF                   call genCode16
  6385 0000225B 83C402                   add  sp, 2
  6386                                  
  6387                                  ;-1006 }
  6388                                  
  6389                                  
  6390                                  ;-1007 int writeEA(char xxx) {//value for reg/operand
  6391 0000225E C9                       LEAVE
  6392 0000225F C3                       ret
  6393                                  ENDP
  6394                                  
  6395                                  writeEA: PROC
  6396                                  
  6397                                  ;-1008 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6398                                  
  6399                                  
  6400                                  ;-1009 //mod-bits: mode76, reg/opcode543, r/m210
  6401                                  
  6402                                  
  6403                                  ;-1010 //Op: 0, IMM, REG, ADR, MEM
  6404                                  
  6405                                  
  6406                                  ;-1011     char len;
  6407                                  
  6408                                  
  6409                                  ;-1012     len=0;
  6410                                  
  6411                                  ;Function : writeEA, Number of local variables: 2
  6412                                  ;   # type sign width addr used name   list of local variables
  6413                                  ;  200 var sign byte  1007 NULL xxx = bp+4
  6414                                  ;  201 var sign byte  1011 NULL len = bp-2;
  6415 00002260 C8020000                 ENTER  2,0
  6416 00002264 B80000                   mov ax, 0
  6417 00002267 8846FE                   mov [bp-2], al
  6418                                  
  6419                                  ;-1013     xxx = xxx << 3;//in reg/opcode field
  6420                                  
  6421 0000226A 8A4604                   mov al, [bp+4]
  6422 0000226D C0E003                   shl al, 3
  6423 00002270 884604                   mov [bp+4], al
  6424                                  
  6425                                  ;-1014     if (Op == REG) {
  6426                                  
  6427 00002273 A0[2D00]                 mov al, [Op]
  6428 00002276 3C02                     cmp al, 2
  6429 00002278 0F853A00                 jne .writeEA240
  6430                                  
  6431                                  ;-1015         xxx |= 0xC0;
  6432                                  
  6433 0000227C 804E04C0                 or  byte[bp+4], 192
  6434                                  
  6435                                  ;-1016         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6436                                  
  6437 00002280 A0[2E00]                 mov al, [Op2]
  6438 00002283 3C01                     cmp al, 1
  6439 00002285 0F8F0D00                 jg  .writeEA241
  6440 00002289 8A4604                   mov al, [bp+4]
  6441 0000228C 0206[3400]               add al, [R1No]
  6442 00002290 884604                   mov [bp+4], al
  6443                                  
  6444                                  ;-1017             else {
  6445                                  
  6446 00002293 E92000                   jmp .writeEA242
  6447                                  .writeEA241:
  6448                                  
  6449                                  ;-1018                 if (Op2 == REG) xxx = xxx + R1No;
  6450                                  
  6451 00002296 A0[2E00]                 mov al, [Op2]
  6452 00002299 3C02                     cmp al, 2
  6453 0000229B 0F850D00                 jne .writeEA243
  6454 0000229F 8A4604                   mov al, [bp+4]
  6455 000022A2 0206[3400]               add al, [R1No]
  6456 000022A6 884604                   mov [bp+4], al
  6457                                  
  6458                                  ;-1019                 else            xxx = xxx + R2No;
  6459                                  
  6460 000022A9 E90A00                   jmp .writeEA244
  6461                                  .writeEA243:
  6462 000022AC 8A4604                   mov al, [bp+4]
  6463 000022AF 0206[3300]               add al, [R2No]
  6464 000022B3 884604                   mov [bp+4], al
  6465                                  
  6466                                  ;-1020             }
  6467                                  
  6468                                  .writeEA244:
  6469                                  
  6470                                  ;-1021         }
  6471                                  
  6472                                  .writeEA242:
  6473                                  
  6474                                  ;-1022     if (Op == MEM) {
  6475                                  
  6476                                  .writeEA240:
  6477 000022B6 A0[2D00]                 mov al, [Op]
  6478 000022B9 3C04                     cmp al, 4
  6479 000022BB 0F857300                 jne .writeEA245
  6480                                  
  6481                                  ;-1023         if (isDirect) {
  6482                                  
  6483 000022BF A0[3C00]                 mov al, [isDirect]
  6484 000022C2 08C0                     or  al, al
  6485 000022C4 0F840D00                 je .writeEA246
  6486                                  
  6487                                  ;-1024             xxx |= 6;
  6488                                  
  6489 000022C8 804E0406                 or  byte[bp+4], 6
  6490                                  
  6491                                  ;-1025             len = 2;
  6492                                  
  6493 000022CC B80200                   mov ax, 2
  6494 000022CF 8846FE                   mov [bp-2], al
  6495                                  
  6496                                  ;-1026         }
  6497                                  
  6498                                  
  6499                                  ;-1027         else {
  6500                                  
  6501 000022D2 E95D00                   jmp .writeEA247
  6502                                  .writeEA246:
  6503                                  
  6504                                  ;-1028             xxx = xxx + rm;
  6505                                  
  6506 000022D5 8A4604                   mov al, [bp+4]
  6507 000022D8 0206[3B00]               add al, [rm]
  6508 000022DC 884604                   mov [bp+4], al
  6509                                  
  6510                                  ;-1029             if (rm == 6) {//make [BP+00]
  6511                                  
  6512 000022DF A0[3B00]                 mov al, [rm]
  6513 000022E2 3C06                     cmp al, 6
  6514 000022E4 0F851400                 jne .writeEA248
  6515                                  
  6516                                  ;-1030                 len=1;
  6517                                  
  6518 000022E8 B80100                   mov ax, 1
  6519 000022EB 8846FE                   mov [bp-2], al
  6520                                  
  6521                                  ;-1031                 if (disp == 0) xxx |= 0x40;
  6522                                  
  6523 000022EE A1[3D00]                 mov ax, [disp]
  6524 000022F1 83F800                   cmp ax, 0
  6525 000022F4 0F850400                 jne .writeEA249
  6526 000022F8 804E0440                 or  byte[bp+4], 64
  6527                                  
  6528                                  ;-1032             }
  6529                                  
  6530                                  .writeEA249:
  6531                                  
  6532                                  ;-1033 
  6533                                  
  6534                                  
  6535                                  ;-1034             if (disp) {
  6536                                  
  6537                                  .writeEA248:
  6538 000022FC A1[3D00]                 mov ax, [disp]
  6539 000022FF 08C0                     or  al, al
  6540 00002301 0F842D00                 je .writeEA250
  6541                                  
  6542                                  ;-1035                 ax = disp;
  6543                                  
  6544 00002305 A1[3D00]                 mov  ax, [disp]
  6545                                  
  6546                                  ;-1036                 if(ax > 127) len=2;
  6547                                  
  6548 00002308 83F87F                   cmp  ax, 127
  6549 0000230B 0F8E0900                 jle .writeEA251
  6550 0000230F B80200                   mov ax, 2
  6551 00002312 8846FE                   mov [bp-2], al
  6552                                  
  6553                                  ;-1037                 else len=1;
  6554                                  
  6555 00002315 E90600                   jmp .writeEA252
  6556                                  .writeEA251:
  6557 00002318 B80100                   mov ax, 1
  6558 0000231B 8846FE                   mov [bp-2], al
  6559                                  
  6560                                  ;-1038                 if (len == 1) xxx |= 0x40;
  6561                                  
  6562                                  .writeEA252:
  6563 0000231E 8A46FE                   mov al, [bp-2]
  6564 00002321 3C01                     cmp al, 1
  6565 00002323 0F850700                 jne .writeEA253
  6566 00002327 804E0440                 or  byte[bp+4], 64
  6567                                  
  6568                                  ;-1039                 else xxx |= 0x80;
  6569                                  
  6570 0000232B E90400                   jmp .writeEA254
  6571                                  .writeEA253:
  6572 0000232E 804E0480                 or  byte[bp+4], 128
  6573                                  
  6574                                  ;-1040             }
  6575                                  
  6576                                  .writeEA254:
  6577                                  
  6578                                  ;-1041         }
  6579                                  
  6580                                  .writeEA250:
  6581                                  
  6582                                  ;-1042     }
  6583                                  
  6584                                  .writeEA247:
  6585                                  
  6586                                  ;-1043 
  6587                                  
  6588                                  
  6589                                  ;-1044     genCode8(xxx);// gen second byte
  6590                                  
  6591                                  .writeEA245:
  6592 00002332 8A4604                   mov al, byte [bp+4]
  6593 00002335 B400                     mov ah, 0
  6594 00002337 50                       push ax
  6595 00002338 E883FE                   call genCode8
  6596 0000233B 83C402                   add  sp, 2
  6597                                  
  6598                                  ;-1045     if (len == 1) genCode8 (disp);
  6599                                  
  6600 0000233E 8A46FE                   mov al, [bp-2]
  6601 00002341 3C01                     cmp al, 1
  6602 00002343 0F850A00                 jne .writeEA255
  6603 00002347 FF36[3D00]               push word [disp]
  6604 0000234B E870FE                   call genCode8
  6605 0000234E 83C402                   add  sp, 2
  6606                                  
  6607                                  ;-1046     if (len == 2) genCode16(disp);
  6608                                  
  6609                                  .writeEA255:
  6610 00002351 8A46FE                   mov al, [bp-2]
  6611 00002354 3C02                     cmp al, 2
  6612 00002356 0F850A00                 jne .writeEA256
  6613 0000235A FF36[3D00]               push word [disp]
  6614 0000235E E8B4FE                   call genCode16
  6615 00002361 83C402                   add  sp, 2
  6616                                  
  6617                                  ;-1047 }
  6618                                  
  6619                                  .writeEA256:
  6620                                  
  6621                                  ;-1048 
  6622                                  
  6623                                  
  6624                                  ;-1049 int genImmediate() {
  6625 00002364 C9                       LEAVE
  6626 00002365 C3                       ret
  6627                                  ENDP
  6628                                  
  6629                                  genImmediate: PROC
  6630                                  
  6631                                  ;-1050     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6632                                  
  6633 00002366 A0[3800]                 mov al, [wflag]
  6634 00002369 08C0                     or  al, al
  6635 0000236B 0F842300                 je .genImmediate257
  6636 0000236F A0[3700]                 mov al, [OpSize]
  6637 00002372 3C03                     cmp al, 3
  6638 00002374 0F850D00                 jne .genImmediate258
  6639 00002378 FF36[3F00]               push word [imme]
  6640 0000237C E8B7FE                   call genCode32
  6641 0000237F 83C402                   add  sp, 2
  6642                                  
  6643                                  ;-1051         else genCode16(imme);
  6644                                  
  6645 00002382 E90A00                   jmp .genImmediate259
  6646                                  .genImmediate258:
  6647 00002385 FF36[3F00]               push word [imme]
  6648 00002389 E889FE                   call genCode16
  6649 0000238C 83C402                   add  sp, 2
  6650                                  
  6651                                  ;-1052     else       genCode8 (imme);
  6652                                  
  6653                                  .genImmediate259:
  6654 0000238F E90A00                   jmp .genImmediate260
  6655                                  .genImmediate257:
  6656 00002392 FF36[3F00]               push word [imme]
  6657 00002396 E825FE                   call genCode8
  6658 00002399 83C402                   add  sp, 2
  6659                                  
  6660                                  ;-1053 }
  6661                                  
  6662                                  .genImmediate260:
  6663                                  
  6664                                  ;-1054 
  6665                                  
  6666                                  
  6667                                  ;-1055 //AS.C
  6668                                  
  6669                                  
  6670                                  ;-1056 int process() {
  6671                                  
  6672 0000239C C3                       ret
  6673                                  ENDP
  6674                                  
  6675                                  process: PROC
  6676                                  
  6677                                  ;-1057     char c;
  6678                                  
  6679                                  
  6680                                  ;-1058     int i;
  6681                                  
  6682                                  
  6683                                  ;-1059     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6684                                  
  6685                                  ;Function : process, Number of local variables: 2
  6686                                  ;   # type sign width addr used name   list of local variables
  6687                                  ;  200 var sign byte  1057 NULL c = bp-2
  6688                                  ;  201 var sign word  1058 NULL i = bp-4;
  6689 0000239D C8040000                 ENTER  4,0
  6690 000023A1 B80000                   mov ax, 0
  6691 000023A4 A2[3B00]                 mov byte [rm], al
  6692 000023A7 A2[3800]                 mov byte [wflag], al
  6693 000023AA A2[3900]                 mov byte [dflag], al
  6694 000023AD A2[3300]                 mov byte [R2No], al
  6695 000023B0 A2[3400]                 mov byte [R1No], al
  6696 000023B3 A2[3500]                 mov byte [R2Type], al
  6697 000023B6 A2[3600]                 mov byte [R1Type], al
  6698 000023B9 A2[2E00]                 mov byte [Op2], al
  6699 000023BC A2[2D00]                 mov byte [Op], al
  6700                                  
  6701                                  ;-1060     disp=imme=0;//int
  6702                                  
  6703 000023BF B80000                   mov ax, 0
  6704 000023C2 A3[3F00]                 mov word [imme], ax
  6705 000023C5 A3[3D00]                 mov word [disp], ax
  6706                                  
  6707                                  ;-1061     isDirect=1; //set in getMeM=0, need in WriteEA
  6708                                  
  6709 000023C8 B80100                   mov ax, 1
  6710 000023CB A2[3C00]                 mov byte [isDirect], al
  6711                                  
  6712                                  ;-1062     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6713                                  
  6714 000023CE E8F7E6                   call getTokeType
  6715                                  
  6716                                  ;-1063     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6717                                  
  6718 000023D1 E890EA                   call getCodeSize
  6719 000023D4 A2[3700]                 mov byte [OpSize], al
  6720                                  
  6721                                  ;-1064     getCodes();//set: Code1, Code2, Code3
  6722                                  
  6723 000023D7 E876FD                   call getCodes
  6724                                  
  6725                                  ;-1065 
  6726                                  
  6727                                  
  6728                                  ;-1066     if (CodeType ==  1) {//1 byte opcode
  6729                                  
  6730 000023DA A0[2F00]                 mov al, [CodeType]
  6731 000023DD 3C01                     cmp al, 1
  6732 000023DF 0F850F00                 jne .process261
  6733                                  
  6734                                  ;-1067         genCode8(Code1);
  6735                                  
  6736 000023E3 A0[3000]                 mov al, byte [Code1]
  6737 000023E6 B400                     mov ah, 0
  6738 000023E8 50                       push ax
  6739 000023E9 E8D2FD                   call genCode8
  6740 000023EC 83C402                   add  sp, 2
  6741                                  
  6742                                  ;-1068         return;
  6743                                  
  6744 000023EF E9D008                   jmp .retnprocess
  6745                                  
  6746                                  ;-1069     }
  6747                                  
  6748                                  
  6749                                  ;-1070 
  6750                                  
  6751                                  
  6752                                  ;-1071     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6753                                  
  6754                                  .process261:
  6755 000023F2 A0[2F00]                 mov al, [CodeType]
  6756 000023F5 3C02                     cmp al, 2
  6757 000023F7 0F856900                 jne .process262
  6758                                  
  6759                                  ;-1072         getOpL();
  6760                                  
  6761 000023FB E808E2                   call getOpL
  6762                                  
  6763                                  ;-1073         checkOpL();
  6764                                  
  6765 000023FE E828E1                   call checkOpL
  6766                                  
  6767                                  ;-1074         if (Code2 <= 1) {//inc,dec
  6768                                  
  6769 00002401 A0[3100]                 mov al, [Code2]
  6770 00002404 3C01                     cmp al, 1
  6771 00002406 0F8F2700                 jg  .process263
  6772                                  
  6773                                  ;-1075   	        if (Op == REG) {//short
  6774                                  
  6775 0000240A A0[2D00]                 mov al, [Op]
  6776 0000240D 3C02                     cmp al, 2
  6777 0000240F 0F851E00                 jne .process264
  6778                                  
  6779                                  ;-1076                 if (wflag) {genCode2(Code3, R1No); return; }
  6780                                  
  6781 00002413 A0[3800]                 mov al, [wflag]
  6782 00002416 08C0                     or  al, al
  6783 00002418 0F841500                 je .process265
  6784 0000241C A0[3400]                 mov al, byte [R1No]
  6785 0000241F B400                     mov ah, 0
  6786 00002421 50                       push ax
  6787 00002422 A0[3200]                 mov al, byte [Code3]
  6788 00002425 B400                     mov ah, 0
  6789 00002427 50                       push ax
  6790 00002428 E85CFD                   call genCode2
  6791 0000242B 83C404                   add  sp, 4
  6792 0000242E E99108                   jmp .retnprocess
  6793                                  
  6794                                  ;-1077             }
  6795                                  
  6796                                  .process265:
  6797                                  
  6798                                  ;-1078         }
  6799                                  
  6800                                  .process264:
  6801                                  
  6802                                  ;-1079         if (Code2 == 5) {//imul extension?
  6803                                  
  6804                                  .process263:
  6805 00002431 A0[3100]                 mov al, [Code2]
  6806 00002434 3C05                     cmp al, 5
  6807 00002436 0F850F00                 jne .process266
  6808                                  
  6809                                  ;-1080             getTokeType();
  6810                                  
  6811 0000243A E88BE6                   call getTokeType
  6812                                  
  6813                                  ;-1081             if (TokeType) implerror();
  6814                                  
  6815 0000243D A0[2C00]                 mov al, [TokeType]
  6816 00002440 08C0                     or  al, al
  6817 00002442 0F840300                 je .process267
  6818 00002446 E821F7                   call implerror
  6819                                  
  6820                                  ;-1082         }
  6821                                  
  6822                                  .process267:
  6823                                  
  6824                                  ;-1083         genCodeW(Code1);
  6825                                  
  6826                                  .process266:
  6827 00002449 A0[3000]                 mov al, byte [Code1]
  6828 0000244C B400                     mov ah, 0
  6829 0000244E 50                       push ax
  6830 0000244F E850FD                   call genCodeW
  6831 00002452 83C402                   add  sp, 2
  6832                                  
  6833                                  ;-1084         writeEA(Code2);
  6834                                  
  6835 00002455 A0[3100]                 mov al, byte [Code2]
  6836 00002458 B400                     mov ah, 0
  6837 0000245A 50                       push ax
  6838 0000245B E802FE                   call writeEA
  6839 0000245E 83C402                   add  sp, 2
  6840                                  
  6841                                  ;-1085         return;
  6842                                  
  6843 00002461 E95E08                   jmp .retnprocess
  6844                                  
  6845                                  ;-1086     }
  6846                                  
  6847                                  
  6848                                  ;-1087 
  6849                                  
  6850                                  
  6851                                  ;-1088     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6852                                  
  6853                                  .process262:
  6854 00002464 A0[2F00]                 mov al, [CodeType]
  6855 00002467 3C03                     cmp al, 3
  6856 00002469 0F855100                 jne .process268
  6857                                  
  6858                                  ;-1089         check2Ops();    //setwflag not applicable
  6859                                  
  6860 0000246D E83BE1                   call check2Ops
  6861                                  
  6862                                  ;-1090         if (R1Type != WORD) reg16error();//only r16
  6863                                  
  6864 00002470 A0[3600]                 mov al, [R1Type]
  6865 00002473 3C02                     cmp al, 2
  6866 00002475 0F840300                 je  .process269
  6867 00002479 E88EF7                   call reg16error
  6868                                  
  6869                                  ;-1091         if (Op2 != MEM) addrerror();//only m16
  6870                                  
  6871                                  .process269:
  6872 0000247C A0[2E00]                 mov al, [Op2]
  6873 0000247F 3C04                     cmp al, 4
  6874 00002481 0F840300                 je  .process270
  6875 00002485 E8A3F6                   call addrerror
  6876                                  
  6877                                  ;-1092 
  6878                                  
  6879                                  
  6880                                  ;-1093         genCode8(Code1);//les,lds,lea
  6881                                  
  6882                                  .process270:
  6883 00002488 A0[3000]                 mov al, byte [Code1]
  6884 0000248B B400                     mov ah, 0
  6885 0000248D 50                       push ax
  6886 0000248E E82DFD                   call genCode8
  6887 00002491 83C402                   add  sp, 2
  6888                                  
  6889                                  ;-1094         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6890                                  
  6891 00002494 A0[3000]                 mov al, [Code1]
  6892 00002497 3C0F                     cmp al, 15
  6893 00002499 0F850C00                 jne .process271
  6894 0000249D A0[3100]                 mov al, byte [Code2]
  6895 000024A0 B400                     mov ah, 0
  6896 000024A2 50                       push ax
  6897 000024A3 E818FD                   call genCode8
  6898 000024A6 83C402                   add  sp, 2
  6899                                  
  6900                                  ;-1095         Op=Op2;//set MEM for writeEA
  6901                                  
  6902                                  .process271:
  6903 000024A9 A0[2E00]                 mov al, [Op2]
  6904 000024AC A2[2D00]                 mov byte [Op], al
  6905                                  
  6906                                  ;-1096         writeEA(R1No);
  6907                                  
  6908 000024AF A0[3400]                 mov al, byte [R1No]
  6909 000024B2 B400                     mov ah, 0
  6910 000024B4 50                       push ax
  6911 000024B5 E8A8FD                   call writeEA
  6912 000024B8 83C402                   add  sp, 2
  6913                                  
  6914                                  ;-1097         return;
  6915                                  
  6916 000024BB E90408                   jmp .retnprocess
  6917                                  
  6918                                  ;-1098     }
  6919                                  
  6920                                  
  6921                                  ;-1099 
  6922                                  
  6923                                  
  6924                                  ;-1100     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6925                                  
  6926                                  .process268:
  6927 000024BE A0[2F00]                 mov al, [CodeType]
  6928 000024C1 3C04                     cmp al, 4
  6929 000024C3 0F85EF00                 jne .process272
  6930                                  
  6931                                  ;-1101         check2Ops();
  6932                                  
  6933 000024C7 E8E1E0                   call check2Ops
  6934                                  
  6935                                  ;-1102         if (Op2 == IMM) {//second operand is imm
  6936                                  
  6937 000024CA A0[2E00]                 mov al, [Op2]
  6938 000024CD 3C01                     cmp al, 1
  6939 000024CF 0F857900                 jne .process273
  6940                                  
  6941                                  ;-1103             setsflag();
  6942                                  
  6943 000024D3 E851E4                   call setsflag
  6944                                  
  6945                                  ;-1104             if (Op == REG) {
  6946                                  
  6947 000024D6 A0[2D00]                 mov al, [Op]
  6948 000024D9 3C02                     cmp al, 2
  6949 000024DB 0F853100                 jne .process274
  6950                                  
  6951                                  ;-1105                 if (R1No == 0) {// acc,imm
  6952                                  
  6953 000024DF A0[3400]                 mov al, [R1No]
  6954 000024E2 3C00                     cmp al, 0
  6955 000024E4 0F852800                 jne .process275
  6956                                  
  6957                                  ;-1106                     if (sflag == 0) {
  6958                                  
  6959 000024E8 A0[3A00]                 mov al, [sflag]
  6960 000024EB 3C00                     cmp al, 0
  6961 000024ED 0F851F00                 jne .process276
  6962                                  
  6963                                  ;-1107                         c = Code1 << 3;
  6964                                  
  6965 000024F1 A0[3000]                 mov al, [Code1]
  6966 000024F4 C0E003                   shl al, 3
  6967 000024F7 8846FE                   mov [bp-2], al
  6968                                  
  6969                                  ;-1108                         c += 4;
  6970                                  
  6971 000024FA 8046FE04                 add  byte[bp-2], 4
  6972                                  
  6973                                  ;-1109                         genCodeW(c);
  6974                                  
  6975 000024FE 8A46FE                   mov al, byte [bp-2]
  6976 00002501 B400                     mov ah, 0
  6977 00002503 50                       push ax
  6978 00002504 E89BFC                   call genCodeW
  6979 00002507 83C402                   add  sp, 2
  6980                                  
  6981                                  ;-1110                         genImmediate();
  6982                                  
  6983 0000250A E859FE                   call genImmediate
  6984                                  
  6985                                  ;-1111                         return;
  6986                                  
  6987 0000250D E9B207                   jmp .retnprocess
  6988                                  
  6989                                  ;-1112                     }
  6990                                  
  6991                                  
  6992                                  ;-1113                 }
  6993                                  
  6994                                  .process276:
  6995                                  
  6996                                  ;-1114             }
  6997                                  
  6998                                  .process275:
  6999                                  
  7000                                  ;-1115             //r/m, imm: 80 sign-extended,TTT,imm
  7001                                  
  7002                                  
  7003                                  ;-1116             c = sflag + 0x80;
  7004                                  
  7005                                  .process274:
  7006 00002510 A0[3A00]                 mov al, [sflag]
  7007 00002513 0480                     add al, 128
  7008 00002515 8846FE                   mov [bp-2], al
  7009                                  
  7010                                  ;-1117             genCodeW(c);
  7011                                  
  7012 00002518 8A46FE                   mov al, byte [bp-2]
  7013 0000251B B400                     mov ah, 0
  7014 0000251D 50                       push ax
  7015 0000251E E881FC                   call genCodeW
  7016 00002521 83C402                   add  sp, 2
  7017                                  
  7018                                  ;-1118             writeEA(Code1);
  7019                                  
  7020 00002524 A0[3000]                 mov al, byte [Code1]
  7021 00002527 B400                     mov ah, 0
  7022 00002529 50                       push ax
  7023 0000252A E833FD                   call writeEA
  7024 0000252D 83C402                   add  sp, 2
  7025                                  
  7026                                  ;-1119             if (sflag) genCode8(imme);
  7027                                  
  7028 00002530 A0[3A00]                 mov al, [sflag]
  7029 00002533 08C0                     or  al, al
  7030 00002535 0F840D00                 je .process277
  7031 00002539 FF36[3F00]               push word [imme]
  7032 0000253D E87EFC                   call genCode8
  7033 00002540 83C402                   add  sp, 2
  7034                                  
  7035                                  ;-1120             else genImmediate();
  7036                                  
  7037 00002543 E90300                   jmp .process278
  7038                                  .process277:
  7039 00002546 E81DFE                   call genImmediate
  7040                                  
  7041                                  ;-1121             return;
  7042                                  
  7043                                  .process278:
  7044 00002549 E97607                   jmp .retnprocess
  7045                                  
  7046                                  ;-1122         }
  7047                                  
  7048                                  
  7049                                  ;-1123         c = Code1 << 3;//r/m, r/r
  7050                                  
  7051                                  .process273:
  7052 0000254C A0[3000]                 mov al, [Code1]
  7053 0000254F C0E003                   shl al, 3
  7054 00002552 8846FE                   mov [bp-2], al
  7055                                  
  7056                                  ;-1124         if (Op == REG) {
  7057                                  
  7058 00002555 A0[2D00]                 mov al, [Op]
  7059 00002558 3C02                     cmp al, 2
  7060 0000255A 0F852E00                 jne .process279
  7061                                  
  7062                                  ;-1125             if (Op2 == MEM) {//reg, mem
  7063                                  
  7064 0000255E A0[2E00]                 mov al, [Op2]
  7065 00002561 3C04                     cmp al, 4
  7066 00002563 0F852500                 jne .process280
  7067                                  
  7068                                  ;-1126                 c += 2;//add direction flag
  7069                                  
  7070 00002567 8046FE02                 add  byte[bp-2], 2
  7071                                  
  7072                                  ;-1127                 genCodeW(c);
  7073                                  
  7074 0000256B 8A46FE                   mov al, byte [bp-2]
  7075 0000256E B400                     mov ah, 0
  7076 00002570 50                       push ax
  7077 00002571 E82EFC                   call genCodeW
  7078 00002574 83C402                   add  sp, 2
  7079                                  
  7080                                  ;-1128                 Op=Op2;//set MEM for writeEA
  7081                                  
  7082 00002577 A0[2E00]                 mov al, [Op2]
  7083 0000257A A2[2D00]                 mov byte [Op], al
  7084                                  
  7085                                  ;-1129                 writeEA(R1No);
  7086                                  
  7087 0000257D A0[3400]                 mov al, byte [R1No]
  7088 00002580 B400                     mov ah, 0
  7089 00002582 50                       push ax
  7090 00002583 E8DAFC                   call writeEA
  7091 00002586 83C402                   add  sp, 2
  7092                                  
  7093                                  ;-1130                 return;
  7094                                  
  7095 00002589 E93607                   jmp .retnprocess
  7096                                  
  7097                                  ;-1131             }
  7098                                  
  7099                                  
  7100                                  ;-1132         }
  7101                                  
  7102                                  .process280:
  7103                                  
  7104                                  ;-1133         if (Op2 == REG) {//mem,reg    reg,reg
  7105                                  
  7106                                  .process279:
  7107 0000258C A0[2E00]                 mov al, [Op2]
  7108 0000258F 3C02                     cmp al, 2
  7109 00002591 0F851B00                 jne .process281
  7110                                  
  7111                                  ;-1134             genCodeW(c);
  7112                                  
  7113 00002595 8A46FE                   mov al, byte [bp-2]
  7114 00002598 B400                     mov ah, 0
  7115 0000259A 50                       push ax
  7116 0000259B E804FC                   call genCodeW
  7117 0000259E 83C402                   add  sp, 2
  7118                                  
  7119                                  ;-1135             writeEA(R2No);//2. Op in reg-field
  7120                                  
  7121 000025A1 A0[3300]                 mov al, byte [R2No]
  7122 000025A4 B400                     mov ah, 0
  7123 000025A6 50                       push ax
  7124 000025A7 E8B6FC                   call writeEA
  7125 000025AA 83C402                   add  sp, 2
  7126                                  
  7127                                  ;-1136             return;
  7128                                  
  7129 000025AD E91207                   jmp .retnprocess
  7130                                  
  7131                                  ;-1137         }
  7132                                  
  7133                                  
  7134                                  ;-1138         syntaxerror();
  7135                                  
  7136                                  .process281:
  7137 000025B0 E8A6F6                   call syntaxerror
  7138                                  
  7139                                  ;-1139         return;
  7140                                  
  7141 000025B3 E90C07                   jmp .retnprocess
  7142                                  
  7143                                  ;-1140     }
  7144                                  
  7145                                  
  7146                                  ;-1141 
  7147                                  
  7148                                  
  7149                                  ;-1142     if (CodeType == 5) {//mov (movsx, movzx=51)
  7150                                  
  7151                                  .process272:
  7152 000025B6 A0[2F00]                 mov al, [CodeType]
  7153 000025B9 3C05                     cmp al, 5
  7154 000025BB 0F858B01                 jne .process282
  7155                                  
  7156                                  ;-1143         check2Ops();
  7157                                  
  7158 000025BF E8E9DF                   call check2Ops
  7159                                  
  7160                                  ;-1144 /*    prs("\n Op:"); printhex8a(Op);
  7161                                  
  7162                                  
  7163                                  ;-1145     prs(", Op2:"); printhex8a(Op2);
  7164                                  
  7165                                  
  7166                                  ;-1146     prs(", R1No:"); printhex8a(R1No);
  7167                                  
  7168                                  
  7169                                  ;-1147     prs(", R2No:"); printhex8a(R2No);   */
  7170                                  
  7171                                  
  7172                                  ;-1148         if (Op2 == ADR) {
  7173                                  
  7174 000025C2 A0[2E00]                 mov al, [Op2]
  7175 000025C5 3C03                     cmp al, 3
  7176 000025C7 0F851B00                 jne .process283
  7177                                  
  7178                                  ;-1149             if (disp) imme=disp;
  7179                                  
  7180 000025CB A1[3D00]                 mov ax, [disp]
  7181 000025CE 08C0                     or  al, al
  7182 000025D0 0F840900                 je .process284
  7183 000025D4 A1[3D00]                 mov ax, [disp]
  7184 000025D7 A3[3F00]                 mov word [imme], ax
  7185                                  
  7186                                  ;-1150             else notfounderror();
  7187                                  
  7188 000025DA E90300                   jmp .process285
  7189                                  .process284:
  7190 000025DD E816F5                   call notfounderror
  7191                                  
  7192                                  ;-1151             Op2=IMM;//continue with IMM
  7193                                  
  7194                                  .process285:
  7195 000025E0 B80100                   mov ax, 1
  7196 000025E3 A2[2E00]                 mov byte [Op2], al
  7197                                  
  7198                                  ;-1152         }
  7199                                  
  7200                                  
  7201                                  ;-1153         if (Op2 == IMM) {// r,i
  7202                                  
  7203                                  .process283:
  7204 000025E6 A0[2E00]                 mov al, [Op2]
  7205 000025E9 3C01                     cmp al, 1
  7206 000025EB 0F855400                 jne .process286
  7207                                  
  7208                                  ;-1154             if (Op == REG) {
  7209                                  
  7210 000025EF A0[2D00]                 mov al, [Op]
  7211 000025F2 3C02                     cmp al, 2
  7212 000025F4 0F852500                 jne .process287
  7213                                  
  7214                                  ;-1155                 c = wflag << 3;
  7215                                  
  7216 000025F8 A0[3800]                 mov al, [wflag]
  7217 000025FB C0E003                   shl al, 3
  7218 000025FE 8846FE                   mov [bp-2], al
  7219                                  
  7220                                  ;-1156                 c += 0xB0;
  7221                                  
  7222 00002601 8046FEB0                 add  byte[bp-2], 176
  7223                                  
  7224                                  ;-1157                 genCode2(c, R1No);
  7225                                  
  7226 00002605 A0[3400]                 mov al, byte [R1No]
  7227 00002608 B400                     mov ah, 0
  7228 0000260A 50                       push ax
  7229 0000260B 8A46FE                   mov al, byte [bp-2]
  7230 0000260E B400                     mov ah, 0
  7231 00002610 50                       push ax
  7232 00002611 E873FB                   call genCode2
  7233 00002614 83C404                   add  sp, 4
  7234                                  
  7235                                  ;-1158                 genImmediate();
  7236                                  
  7237 00002617 E84CFD                   call genImmediate
  7238                                  
  7239                                  ;-1159                 return;
  7240                                  
  7241 0000261A E9A506                   jmp .retnprocess
  7242                                  
  7243                                  ;-1160             }
  7244                                  
  7245                                  
  7246                                  ;-1161             if (Op == MEM) {// m,i
  7247                                  
  7248                                  .process287:
  7249 0000261D A0[2D00]                 mov al, [Op]
  7250 00002620 3C04                     cmp al, 4
  7251 00002622 0F851700                 jne .process288
  7252                                  
  7253                                  ;-1162                 genCodeW(0xC6);
  7254                                  
  7255 00002626 68C600                   push 198
  7256 00002629 E876FB                   call genCodeW
  7257 0000262C 83C402                   add  sp, 2
  7258                                  
  7259                                  ;-1163                 writeEA( 0 );
  7260                                  
  7261 0000262F 6A00                     push 0
  7262 00002631 E82CFC                   call writeEA
  7263 00002634 83C402                   add  sp, 2
  7264                                  
  7265                                  ;-1164                 genImmediate();
  7266                                  
  7267 00002637 E82CFD                   call genImmediate
  7268                                  
  7269                                  ;-1165                 return;
  7270                                  
  7271 0000263A E98506                   jmp .retnprocess
  7272                                  
  7273                                  ;-1166             }
  7274                                  
  7275                                  
  7276                                  ;-1167             regmemerror();
  7277                                  
  7278                                  .process288:
  7279 0000263D E8A0F5                   call regmemerror
  7280                                  
  7281                                  ;-1168             return;
  7282                                  
  7283 00002640 E97F06                   jmp .retnprocess
  7284                                  
  7285                                  ;-1169         }
  7286                                  
  7287                                  
  7288                                  ;-1170         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7289                                  
  7290                                  .process286:
  7291 00002643 A0[3600]                 mov al, [R1Type]
  7292 00002646 3C04                     cmp al, 4
  7293 00002648 0F850300                 jne .process289
  7294 0000264C E898DE                   call ChangeDirection
  7295                                  
  7296                                  ;-1171         if (R2Type == SEGREG) {//rm,sreg
  7297                                  
  7298                                  .process289:
  7299 0000264F A0[3500]                 mov al, [R2Type]
  7300 00002652 3C04                     cmp al, 4
  7301 00002654 0F852A00                 jne .process290
  7302                                  
  7303                                  ;-1172             if (OpSize != WORD) reg16error();
  7304                                  
  7305 00002658 A0[3700]                 mov al, [OpSize]
  7306 0000265B 3C02                     cmp al, 2
  7307 0000265D 0F840300                 je  .process291
  7308 00002661 E8A6F5                   call reg16error
  7309                                  
  7310                                  ;-1173                 genCode2(0x8C, dflag);
  7311                                  
  7312                                  .process291:
  7313 00002664 A0[3900]                 mov al, byte [dflag]
  7314 00002667 B400                     mov ah, 0
  7315 00002669 50                       push ax
  7316 0000266A 688C00                   push 140
  7317 0000266D E817FB                   call genCode2
  7318 00002670 83C404                   add  sp, 4
  7319                                  
  7320                                  ;-1174                 writeEA(R2No);
  7321                                  
  7322 00002673 A0[3300]                 mov al, byte [R2No]
  7323 00002676 B400                     mov ah, 0
  7324 00002678 50                       push ax
  7325 00002679 E8E4FB                   call writeEA
  7326 0000267C 83C402                   add  sp, 2
  7327                                  
  7328                                  ;-1175                 return;
  7329                                  
  7330 0000267F E94006                   jmp .retnprocess
  7331                                  
  7332                                  ;-1176         }
  7333                                  
  7334                                  
  7335                                  ;-1177         if (Op2 == MEM) {//acc, moffs16
  7336                                  
  7337                                  .process290:
  7338 00002682 A0[2E00]                 mov al, [Op2]
  7339 00002685 3C04                     cmp al, 4
  7340 00002687 0F853100                 jne .process292
  7341                                  
  7342                                  ;-1178             if (Op == REG) {
  7343                                  
  7344 0000268B A0[2D00]                 mov al, [Op]
  7345 0000268E 3C02                     cmp al, 2
  7346 00002690 0F852800                 jne .process293
  7347                                  
  7348                                  ;-1179                 if (R1No == 0) {
  7349                                  
  7350 00002694 A0[3400]                 mov al, [R1No]
  7351 00002697 3C00                     cmp al, 0
  7352 00002699 0F851F00                 jne .process294
  7353                                  
  7354                                  ;-1180                     if (isDirect) {
  7355                                  
  7356 0000269D A0[3C00]                 mov al, [isDirect]
  7357 000026A0 08C0                     or  al, al
  7358 000026A2 0F841600                 je .process295
  7359                                  
  7360                                  ;-1181                         genCodeW(0xA0);
  7361                                  
  7362 000026A6 68A000                   push 160
  7363 000026A9 E8F6FA                   call genCodeW
  7364 000026AC 83C402                   add  sp, 2
  7365                                  
  7366                                  ;-1182                         genCode16(disp);
  7367                                  
  7368 000026AF FF36[3D00]               push word [disp]
  7369 000026B3 E85FFB                   call genCode16
  7370 000026B6 83C402                   add  sp, 2
  7371                                  
  7372                                  ;-1183                         return;
  7373                                  
  7374 000026B9 E90606                   jmp .retnprocess
  7375                                  
  7376                                  ;-1184                     }
  7377                                  
  7378                                  
  7379                                  ;-1185                 }
  7380                                  
  7381                                  .process295:
  7382                                  
  7383                                  ;-1186             }
  7384                                  
  7385                                  .process294:
  7386                                  
  7387                                  ;-1187         }
  7388                                  
  7389                                  .process293:
  7390                                  
  7391                                  ;-1188         if (Op == MEM) {//moffs16, acc
  7392                                  
  7393                                  .process292:
  7394 000026BC A0[2D00]                 mov al, [Op]
  7395 000026BF 3C04                     cmp al, 4
  7396 000026C1 0F853100                 jne .process296
  7397                                  
  7398                                  ;-1189             if (Op2 == REG) {
  7399                                  
  7400 000026C5 A0[2E00]                 mov al, [Op2]
  7401 000026C8 3C02                     cmp al, 2
  7402 000026CA 0F852800                 jne .process297
  7403                                  
  7404                                  ;-1190                 if (R2No == 0) {
  7405                                  
  7406 000026CE A0[3300]                 mov al, [R2No]
  7407 000026D1 3C00                     cmp al, 0
  7408 000026D3 0F851F00                 jne .process298
  7409                                  
  7410                                  ;-1191                     if (isDirect) {
  7411                                  
  7412 000026D7 A0[3C00]                 mov al, [isDirect]
  7413 000026DA 08C0                     or  al, al
  7414 000026DC 0F841600                 je .process299
  7415                                  
  7416                                  ;-1192                         genCodeW(0xA2);
  7417                                  
  7418 000026E0 68A200                   push 162
  7419 000026E3 E8BCFA                   call genCodeW
  7420 000026E6 83C402                   add  sp, 2
  7421                                  
  7422                                  ;-1193                         genCode16(disp);
  7423                                  
  7424 000026E9 FF36[3D00]               push word [disp]
  7425 000026ED E825FB                   call genCode16
  7426 000026F0 83C402                   add  sp, 2
  7427                                  
  7428                                  ;-1194                         return;
  7429                                  
  7430 000026F3 E9CC05                   jmp .retnprocess
  7431                                  
  7432                                  ;-1195                     }
  7433                                  
  7434                                  
  7435                                  ;-1196                 }
  7436                                  
  7437                                  .process299:
  7438                                  
  7439                                  ;-1197             }
  7440                                  
  7441                                  .process298:
  7442                                  
  7443                                  ;-1198 
  7444                                  
  7445                                  
  7446                                  ;-1199         }
  7447                                  
  7448                                  .process297:
  7449                                  
  7450                                  ;-1200         if (Op2 == REG) {//rm, r
  7451                                  
  7452                                  .process296:
  7453 000026F6 A0[2E00]                 mov al, [Op2]
  7454 000026F9 3C02                     cmp al, 2
  7455 000026FB 0F851800                 jne .process300
  7456                                  
  7457                                  ;-1201             genCodeW(0x88);
  7458                                  
  7459 000026FF 688800                   push 136
  7460 00002702 E89DFA                   call genCodeW
  7461 00002705 83C402                   add  sp, 2
  7462                                  
  7463                                  ;-1202             writeEA(R2No);
  7464                                  
  7465 00002708 A0[3300]                 mov al, byte [R2No]
  7466 0000270B B400                     mov ah, 0
  7467 0000270D 50                       push ax
  7468 0000270E E84FFB                   call writeEA
  7469 00002711 83C402                   add  sp, 2
  7470                                  
  7471                                  ;-1203             return;
  7472                                  
  7473 00002714 E9AB05                   jmp .retnprocess
  7474                                  
  7475                                  ;-1204         }
  7476                                  
  7477                                  
  7478                                  ;-1205         if (Op2 == MEM) {//r, m
  7479                                  
  7480                                  .process300:
  7481 00002717 A0[2E00]                 mov al, [Op2]
  7482 0000271A 3C04                     cmp al, 4
  7483 0000271C 0F852400                 jne .process301
  7484                                  
  7485                                  ;-1206             if (Op == REG) {
  7486                                  
  7487 00002720 A0[2D00]                 mov al, [Op]
  7488 00002723 3C02                     cmp al, 2
  7489 00002725 0F851B00                 jne .process302
  7490                                  
  7491                                  ;-1207                 ChangeDirection();
  7492                                  
  7493 00002729 E8BBDD                   call ChangeDirection
  7494                                  
  7495                                  ;-1208                 genCodeW(0x8A);
  7496                                  
  7497 0000272C 688A00                   push 138
  7498 0000272F E870FA                   call genCodeW
  7499 00002732 83C402                   add  sp, 2
  7500                                  
  7501                                  ;-1209                 writeEA(R2No);
  7502                                  
  7503 00002735 A0[3300]                 mov al, byte [R2No]
  7504 00002738 B400                     mov ah, 0
  7505 0000273A 50                       push ax
  7506 0000273B E822FB                   call writeEA
  7507 0000273E 83C402                   add  sp, 2
  7508                                  
  7509                                  ;-1210                 return;
  7510                                  
  7511 00002741 E97E05                   jmp .retnprocess
  7512                                  
  7513                                  ;-1211             }
  7514                                  
  7515                                  
  7516                                  ;-1212         }
  7517                                  
  7518                                  .process302:
  7519                                  
  7520                                  ;-1213         syntaxerror();
  7521                                  
  7522                                  .process301:
  7523 00002744 E812F5                   call syntaxerror
  7524                                  
  7525                                  ;-1214         return;
  7526                                  
  7527 00002747 E97805                   jmp .retnprocess
  7528                                  
  7529                                  ;-1215     }
  7530                                  
  7531                                  
  7532                                  ;-1216 
  7533                                  
  7534                                  
  7535                                  ;-1217     if (CodeType == 6) {//Jcc
  7536                                  
  7537                                  .process282:
  7538 0000274A A0[2F00]                 mov al, [CodeType]
  7539 0000274D 3C06                     cmp al, 6
  7540 0000274F 0F85BE00                 jne .process303
  7541                                  
  7542                                  ;-1218         if (TokeType == ALNUME) {
  7543                                  
  7544 00002753 A0[2C00]                 mov al, [TokeType]
  7545 00002756 3C03                     cmp al, 3
  7546 00002758 0F85B500                 jne .process304
  7547                                  
  7548                                  ;-1219             LabelIx=searchLabel();
  7549                                  
  7550 0000275C E818E5                   call searchLabel
  7551 0000275F A3[4E00]                 mov word [LabelIx], ax
  7552                                  
  7553                                  ;-1220             if (LabelIx > 0) {
  7554                                  
  7555 00002762 A1[4E00]                 mov ax, [LabelIx]
  7556 00002765 83F800                   cmp ax, 0
  7557 00002768 0F8E7A00                 jle .process305
  7558                                  
  7559                                  ;-1221                 disp=LabelAddr[LabelIx];
  7560                                  
  7561 0000276C 8B1E[4E00]               mov bx, [LabelIx]
  7562 00002770 D1E3                     shl bx, 1
  7563 00002772 8B87CA8E                 mov ax, [LabelAddr + bx]
  7564 00002776 A3[3D00]                 mov word [disp], ax
  7565                                  
  7566                                  ;-1222                 disp = disp - PC;
  7567                                  
  7568 00002779 A1[3D00]                 mov ax, [disp]
  7569 0000277C 2B06[2300]               sub ax, [PC]
  7570 00002780 A3[3D00]                 mov word [disp], ax
  7571                                  
  7572                                  ;-1223                 disp = disp - Origin;
  7573                                  
  7574 00002783 A1[3D00]                 mov ax, [disp]
  7575 00002786 2B06[2500]               sub ax, [Origin]
  7576 0000278A A3[3D00]                 mov word [disp], ax
  7577                                  
  7578                                  ;-1224                 if (checkConstSize(disp) ) {
  7579                                  
  7580 0000278D FF36[3D00]               push word [disp]
  7581 00002791 E8EFE1                   call checkConstSize
  7582 00002794 83C402                   add  sp, 2
  7583 00002797 08C0                     or  al, al
  7584 00002799 0F842000                 je .process306
  7585                                  
  7586                                  ;-1225                     genCode2(Code1, 0x70);//short
  7587                                  
  7588 0000279D 6A70                     push 112
  7589 0000279F A0[3000]                 mov al, byte [Code1]
  7590 000027A2 B400                     mov ah, 0
  7591 000027A4 50                       push ax
  7592 000027A5 E8DFF9                   call genCode2
  7593 000027A8 83C404                   add  sp, 4
  7594                                  
  7595                                  ;-1226                     disp -= 2;
  7596                                  
  7597 000027AB 832E[3D00]02             sub  word[disp], 2
  7598                                  
  7599                                  ;-1227                     genCode8(disp);
  7600                                  
  7601 000027B0 FF36[3D00]               push word [disp]
  7602 000027B4 E807FA                   call genCode8
  7603 000027B7 83C402                   add  sp, 2
  7604                                  
  7605                                  ;-1228                 } else {
  7606                                  
  7607 000027BA E92600                   jmp .process307
  7608                                  .process306:
  7609                                  
  7610                                  ;-1229                     genCode8(0x0F);
  7611                                  
  7612 000027BD 6A0F                     push 15
  7613 000027BF E8FCF9                   call genCode8
  7614 000027C2 83C402                   add  sp, 2
  7615                                  
  7616                                  ;-1230                     genCode2(Code1, 0x80);//near
  7617                                  
  7618 000027C5 688000                   push 128
  7619 000027C8 A0[3000]                 mov al, byte [Code1]
  7620 000027CB B400                     mov ah, 0
  7621 000027CD 50                       push ax
  7622 000027CE E8B6F9                   call genCode2
  7623 000027D1 83C404                   add  sp, 4
  7624                                  
  7625                                  ;-1231                     disp -= 4;
  7626                                  
  7627 000027D4 832E[3D00]04             sub  word[disp], 4
  7628                                  
  7629                                  ;-1232                     genCode16(disp);
  7630                                  
  7631 000027D9 FF36[3D00]               push word [disp]
  7632 000027DD E835FA                   call genCode16
  7633 000027E0 83C402                   add  sp, 2
  7634                                  
  7635                                  ;-1233                 }
  7636                                  
  7637                                  
  7638                                  ;-1234             }
  7639                                  
  7640                                  .process307:
  7641                                  
  7642                                  ;-1235             else {//jump forward, near only
  7643                                  
  7644 000027E3 E92800                   jmp .process308
  7645                                  .process305:
  7646                                  
  7647                                  ;-1236                 genCode8(0x0F);
  7648                                  
  7649 000027E6 6A0F                     push 15
  7650 000027E8 E8D3F9                   call genCode8
  7651 000027EB 83C402                   add  sp, 2
  7652                                  
  7653                                  ;-1237                 genCode2(Code1, 0x80);
  7654                                  
  7655 000027EE 688000                   push 128
  7656 000027F1 A0[3000]                 mov al, byte [Code1]
  7657 000027F4 B400                     mov ah, 0
  7658 000027F6 50                       push ax
  7659 000027F7 E88DF9                   call genCode2
  7660 000027FA 83C404                   add  sp, 4
  7661                                  
  7662                                  ;-1238                 storeJmp();
  7663                                  
  7664 000027FD E854E3                   call storeJmp
  7665                                  
  7666                                  ;-1239                 genCode16(0);
  7667                                  
  7668 00002800 6A00                     push 0
  7669 00002802 E810FA                   call genCode16
  7670 00002805 83C402                   add  sp, 2
  7671                                  
  7672                                  ;-1240                 PrintRA='r';
  7673                                  
  7674 00002808 B87200                   mov ax, 114
  7675 0000280B A2[4500]                 mov byte [PrintRA], al
  7676                                  
  7677                                  ;-1241             }
  7678                                  
  7679                                  
  7680                                  ;-1242         return;
  7681                                  
  7682                                  .process308:
  7683 0000280E E9B104                   jmp .retnprocess
  7684                                  
  7685                                  ;-1243         }
  7686                                  
  7687                                  
  7688                                  ;-1244     }
  7689                                  
  7690                                  .process304:
  7691                                  
  7692                                  ;-1245 
  7693                                  
  7694                                  
  7695                                  ;-1246     if (CodeType == 7) {//jmp, call
  7696                                  
  7697                                  .process303:
  7698 00002811 A0[2F00]                 mov al, [CodeType]
  7699 00002814 3C07                     cmp al, 7
  7700 00002816 0F85CA00                 jne .process309
  7701                                  
  7702                                  ;-1247         if (TokeType == ALNUME) {
  7703                                  
  7704 0000281A A0[2C00]                 mov al, [TokeType]
  7705 0000281D 3C03                     cmp al, 3
  7706 0000281F 0F85C100                 jne .process310
  7707                                  
  7708                                  ;-1248             LabelIx=searchLabel();
  7709                                  
  7710 00002823 E851E4                   call searchLabel
  7711 00002826 A3[4E00]                 mov word [LabelIx], ax
  7712                                  
  7713                                  ;-1249             if (LabelIx > 0) {
  7714                                  
  7715 00002829 A1[4E00]                 mov ax, [LabelIx]
  7716 0000282C 83F800                   cmp ax, 0
  7717 0000282F 0F8E9100                 jle .process311
  7718                                  
  7719                                  ;-1250                 disp=LabelAddr[LabelIx];
  7720                                  
  7721 00002833 8B1E[4E00]               mov bx, [LabelIx]
  7722 00002837 D1E3                     shl bx, 1
  7723 00002839 8B87CA8E                 mov ax, [LabelAddr + bx]
  7724 0000283D A3[3D00]                 mov word [disp], ax
  7725                                  
  7726                                  ;-1251                 disp = disp - PC;
  7727                                  
  7728 00002840 A1[3D00]                 mov ax, [disp]
  7729 00002843 2B06[2300]               sub ax, [PC]
  7730 00002847 A3[3D00]                 mov word [disp], ax
  7731                                  
  7732                                  ;-1252                 disp = disp - Origin;
  7733                                  
  7734 0000284A A1[3D00]                 mov ax, [disp]
  7735 0000284D 2B06[2500]               sub ax, [Origin]
  7736 00002851 A3[3D00]                 mov word [disp], ax
  7737                                  
  7738                                  ;-1253                 if (checkConstSize(disp) ) {
  7739                                  
  7740 00002854 FF36[3D00]               push word [disp]
  7741 00002858 E828E1                   call checkConstSize
  7742 0000285B 83C402                   add  sp, 2
  7743 0000285E 08C0                     or  al, al
  7744 00002860 0F844200                 je .process312
  7745                                  
  7746                                  ;-1254                     if (Code1 == 0xE9) {//jmp only
  7747                                  
  7748 00002864 A0[3000]                 mov al, [Code1]
  7749 00002867 3CE9                     cmp al, 233
  7750 00002869 0F851B00                 jne .process313
  7751                                  
  7752                                  ;-1255                         genCode8(0xEB);//short
  7753                                  
  7754 0000286D 68EB00                   push 235
  7755 00002870 E84BF9                   call genCode8
  7756 00002873 83C402                   add  sp, 2
  7757                                  
  7758                                  ;-1256                         disp -= 2;
  7759                                  
  7760 00002876 832E[3D00]02             sub  word[disp], 2
  7761                                  
  7762                                  ;-1257                         genCode8(disp);
  7763                                  
  7764 0000287B FF36[3D00]               push word [disp]
  7765 0000287F E83CF9                   call genCode8
  7766 00002882 83C402                   add  sp, 2
  7767                                  
  7768                                  ;-1258                     }
  7769                                  
  7770                                  
  7771                                  ;-1259                     else {
  7772                                  
  7773 00002885 E91B00                   jmp .process314
  7774                                  .process313:
  7775                                  
  7776                                  ;-1260                         genCode8(Code1);//near
  7777                                  
  7778 00002888 A0[3000]                 mov al, byte [Code1]
  7779 0000288B B400                     mov ah, 0
  7780 0000288D 50                       push ax
  7781 0000288E E82DF9                   call genCode8
  7782 00002891 83C402                   add  sp, 2
  7783                                  
  7784                                  ;-1261                         disp -= 3;
  7785                                  
  7786 00002894 832E[3D00]03             sub  word[disp], 3
  7787                                  
  7788                                  ;-1262                         genCode16(disp);
  7789                                  
  7790 00002899 FF36[3D00]               push word [disp]
  7791 0000289D E875F9                   call genCode16
  7792 000028A0 83C402                   add  sp, 2
  7793                                  
  7794                                  ;-1263                     }
  7795                                  
  7796                                  
  7797                                  ;-1264                 }
  7798                                  
  7799                                  .process314:
  7800                                  
  7801                                  ;-1265                 else {
  7802                                  
  7803 000028A3 E91B00                   jmp .process315
  7804                                  .process312:
  7805                                  
  7806                                  ;-1266                     genCode8(Code1);//near
  7807                                  
  7808 000028A6 A0[3000]                 mov al, byte [Code1]
  7809 000028A9 B400                     mov ah, 0
  7810 000028AB 50                       push ax
  7811 000028AC E80FF9                   call genCode8
  7812 000028AF 83C402                   add  sp, 2
  7813                                  
  7814                                  ;-1267                     disp -= 3;
  7815                                  
  7816 000028B2 832E[3D00]03             sub  word[disp], 3
  7817                                  
  7818                                  ;-1268                     genCode16(disp);
  7819                                  
  7820 000028B7 FF36[3D00]               push word [disp]
  7821 000028BB E857F9                   call genCode16
  7822 000028BE 83C402                   add  sp, 2
  7823                                  
  7824                                  ;-1269                 }
  7825                                  
  7826                                  
  7827                                  ;-1270             }
  7828                                  
  7829                                  .process315:
  7830                                  
  7831                                  ;-1271             else {//jump forward, near only
  7832                                  
  7833 000028C1 E91D00                   jmp .process316
  7834                                  .process311:
  7835                                  
  7836                                  ;-1272                 genCode8(Code1);
  7837                                  
  7838 000028C4 A0[3000]                 mov al, byte [Code1]
  7839 000028C7 B400                     mov ah, 0
  7840 000028C9 50                       push ax
  7841 000028CA E8F1F8                   call genCode8
  7842 000028CD 83C402                   add  sp, 2
  7843                                  
  7844                                  ;-1273                 storeJmp();
  7845                                  
  7846 000028D0 E881E2                   call storeJmp
  7847                                  
  7848                                  ;-1274                 genCode16(0);
  7849                                  
  7850 000028D3 6A00                     push 0
  7851 000028D5 E83DF9                   call genCode16
  7852 000028D8 83C402                   add  sp, 2
  7853                                  
  7854                                  ;-1275                 PrintRA='R';
  7855                                  
  7856 000028DB B85200                   mov ax, 82
  7857 000028DE A2[4500]                 mov byte [PrintRA], al
  7858                                  
  7859                                  ;-1276             }
  7860                                  
  7861                                  
  7862                                  ;-1277         return;
  7863                                  
  7864                                  .process316:
  7865 000028E1 E9DE03                   jmp .retnprocess
  7866                                  
  7867                                  ;-1278         }
  7868                                  
  7869                                  
  7870                                  ;-1279     }
  7871                                  
  7872                                  .process310:
  7873                                  
  7874                                  ;-1280 
  7875                                  
  7876                                  
  7877                                  ;-1281     if (CodeType ==  8) {//ret,retf
  7878                                  
  7879                                  .process309:
  7880 000028E4 A0[2F00]                 mov al, [CodeType]
  7881 000028E7 3C08                     cmp al, 8
  7882 000028E9 0F853100                 jne .process317
  7883                                  
  7884                                  ;-1282         if (TokeType == DIGIT) {
  7885                                  
  7886 000028ED A0[2C00]                 mov al, [TokeType]
  7887 000028F0 3C01                     cmp al, 1
  7888 000028F2 0F851900                 jne .process318
  7889                                  
  7890                                  ;-1283             genCode8(Code2);
  7891                                  
  7892 000028F6 A0[3100]                 mov al, byte [Code2]
  7893 000028F9 B400                     mov ah, 0
  7894 000028FB 50                       push ax
  7895 000028FC E8BFF8                   call genCode8
  7896 000028FF 83C402                   add  sp, 2
  7897                                  
  7898                                  ;-1284             genCode16(SymbolInt);
  7899                                  
  7900 00002902 FF36[0E00]               push word [SymbolInt]
  7901 00002906 E80CF9                   call genCode16
  7902 00002909 83C402                   add  sp, 2
  7903                                  
  7904                                  ;-1285             return;
  7905                                  
  7906 0000290C E9B303                   jmp .retnprocess
  7907                                  
  7908                                  ;-1286         }
  7909                                  
  7910                                  
  7911                                  ;-1287         genCode8(Code1);
  7912                                  
  7913                                  .process318:
  7914 0000290F A0[3000]                 mov al, byte [Code1]
  7915 00002912 B400                     mov ah, 0
  7916 00002914 50                       push ax
  7917 00002915 E8A6F8                   call genCode8
  7918 00002918 83C402                   add  sp, 2
  7919                                  
  7920                                  ;-1288         return;
  7921                                  
  7922 0000291B E9A403                   jmp .retnprocess
  7923                                  
  7924                                  ;-1289     }
  7925                                  
  7926                                  
  7927                                  ;-1290 
  7928                                  
  7929                                  
  7930                                  ;-1291     if (CodeType == 9) {//push, pop
  7931                                  
  7932                                  .process317:
  7933 0000291E A0[2F00]                 mov al, [CodeType]
  7934 00002921 3C09                     cmp al, 9
  7935 00002923 0F854E01                 jne .process319
  7936                                  
  7937                                  ;-1292         getOpL();
  7938                                  
  7939 00002927 E8DCDC                   call getOpL
  7940                                  
  7941                                  ;-1293         if (Code1 == 0x50) {//push only
  7942                                  
  7943 0000292A A0[3000]                 mov al, [Code1]
  7944 0000292D 3C50                     cmp al, 80
  7945 0000292F 0F858800                 jne .process320
  7946                                  
  7947                                  ;-1294             if (Op == IMM) {//push imm8,16
  7948                                  
  7949 00002933 A0[2D00]                 mov al, [Op]
  7950 00002936 3C01                     cmp al, 1
  7951 00002938 0F853400                 jne .process321
  7952                                  
  7953                                  ;-1295                 setsflag();
  7954                                  
  7955 0000293C E8E8DF                   call setsflag
  7956                                  
  7957                                  ;-1296                 genCode2(0x68, sflag);
  7958                                  
  7959 0000293F A0[3A00]                 mov al, byte [sflag]
  7960 00002942 B400                     mov ah, 0
  7961 00002944 50                       push ax
  7962 00002945 6A68                     push 104
  7963 00002947 E83DF8                   call genCode2
  7964 0000294A 83C404                   add  sp, 4
  7965                                  
  7966                                  ;-1297                 if (sflag) genCode8 (imme);
  7967                                  
  7968 0000294D A0[3A00]                 mov al, [sflag]
  7969 00002950 08C0                     or  al, al
  7970 00002952 0F840D00                 je .process322
  7971 00002956 FF36[3F00]               push word [imme]
  7972 0000295A E861F8                   call genCode8
  7973 0000295D 83C402                   add  sp, 2
  7974                                  
  7975                                  ;-1298                 else       genCode16(imme);
  7976                                  
  7977 00002960 E90A00                   jmp .process323
  7978                                  .process322:
  7979 00002963 FF36[3F00]               push word [imme]
  7980 00002967 E8ABF8                   call genCode16
  7981 0000296A 83C402                   add  sp, 2
  7982                                  
  7983                                  ;-1299                 return;
  7984                                  
  7985                                  .process323:
  7986 0000296D E95203                   jmp .retnprocess
  7987                                  
  7988                                  ;-1300             }
  7989                                  
  7990                                  
  7991                                  ;-1301             if (Op == ADR) {//push string ABSOLUTE i16
  7992                                  
  7993                                  .process321:
  7994 00002970 A0[2D00]                 mov al, [Op]
  7995 00002973 3C03                     cmp al, 3
  7996 00002975 0F854200                 jne .process324
  7997                                  
  7998                                  ;-1302                 if (disp) {
  7999                                  
  8000 00002979 A1[3D00]                 mov ax, [disp]
  8001 0000297C 08C0                     or  al, al
  8002 0000297E 0F841800                 je .process325
  8003                                  
  8004                                  ;-1303                     genCode8(0x68);
  8005                                  
  8006 00002982 6A68                     push 104
  8007 00002984 E837F8                   call genCode8
  8008 00002987 83C402                   add  sp, 2
  8009                                  
  8010                                  ;-1304                     genCode16(disp);
  8011                                  
  8012 0000298A FF36[3D00]               push word [disp]
  8013 0000298E E884F8                   call genCode16
  8014 00002991 83C402                   add  sp, 2
  8015                                  
  8016                                  ;-1305                     return;
  8017                                  
  8018 00002994 E92B03                   jmp .retnprocess
  8019                                  
  8020                                  ;-1306                 }
  8021                                  
  8022                                  
  8023                                  ;-1307                 else {
  8024                                  
  8025 00002997 E92100                   jmp .process326
  8026                                  .process325:
  8027                                  
  8028                                  ;-1308                     genCode8(0x68);
  8029                                  
  8030 0000299A 6A68                     push 104
  8031 0000299C E81FF8                   call genCode8
  8032 0000299F 83C402                   add  sp, 2
  8033                                  
  8034                                  ;-1309                     storeJmp();
  8035                                  
  8036 000029A2 E8AFE1                   call storeJmp
  8037                                  
  8038                                  ;-1310                     genCode8(65);//'A'
  8039                                  
  8040 000029A5 6A41                     push 65
  8041 000029A7 E814F8                   call genCode8
  8042 000029AA 83C402                   add  sp, 2
  8043                                  
  8044                                  ;-1311                     genCode8(65);
  8045                                  
  8046 000029AD 6A41                     push 65
  8047 000029AF E80CF8                   call genCode8
  8048 000029B2 83C402                   add  sp, 2
  8049                                  
  8050                                  ;-1312                     PrintRA='A';
  8051                                  
  8052 000029B5 B84100                   mov ax, 65
  8053 000029B8 A2[4500]                 mov byte [PrintRA], al
  8054                                  
  8055                                  ;-1313                 }
  8056                                  
  8057                                  
  8058                                  ;-1314             }
  8059                                  
  8060                                  .process326:
  8061                                  
  8062                                  ;-1315         }
  8063                                  
  8064                                  .process324:
  8065                                  
  8066                                  ;-1316         if (R1Type == SEGREG) {
  8067                                  
  8068                                  .process320:
  8069 000029BB A0[3600]                 mov al, [R1Type]
  8070 000029BE 3C04                     cmp al, 4
  8071 000029C0 0F855A00                 jne .process327
  8072                                  
  8073                                  ;-1317             if (Code1 == 0x58) {//pop only
  8074                                  
  8075 000029C4 A0[3000]                 mov al, [Code1]
  8076 000029C7 3C58                     cmp al, 88
  8077 000029C9 0F851200                 jne .process328
  8078                                  
  8079                                  ;-1318                 if (R1No == 1) error1("pop cs not allowed");
  8080                                  
  8081 000029CD A0[3400]                 mov al, [R1No]
  8082 000029D0 3C01                     cmp al, 1
  8083 000029D2 0F850900                 jne .process329
  8084 000029D6 68[C42C]                 push process_0
  8085 000029D9 E8AAF0                   call error1
  8086 000029DC 83C402                   add  sp, 2
  8087                                  
  8088                                  ;-1319             }
  8089                                  
  8090                                  .process329:
  8091                                  
  8092                                  ;-1320             c = R1No <<3;
  8093                                  
  8094                                  .process328:
  8095 000029DF A0[3400]                 mov al, [R1No]
  8096 000029E2 C0E003                   shl al, 3
  8097 000029E5 8846FE                   mov [bp-2], al
  8098                                  
  8099                                  ;-1321             if (R1No > 3) {//FS, GS
  8100                                  
  8101 000029E8 A0[3400]                 mov al, [R1No]
  8102 000029EB 3C03                     cmp al, 3
  8103 000029ED 0F8E0C00                 jle .process330
  8104                                  
  8105                                  ;-1322                 c += 122;
  8106                                  
  8107 000029F1 8046FE7A                 add  byte[bp-2], 122
  8108                                  
  8109                                  ;-1323                 genCode8(0x0F);
  8110                                  
  8111 000029F5 6A0F                     push 15
  8112 000029F7 E8C4F7                   call genCode8
  8113 000029FA 83C402                   add  sp, 2
  8114                                  
  8115                                  ;-1324             }
  8116                                  
  8117                                  
  8118                                  ;-1325             OpCodePtr++;
  8119                                  
  8120                                  .process330:
  8121 000029FD FF06[4300]               inc  word[OpCodePtr]
  8122                                  
  8123                                  ;-1326             c = c + *OpCodePtr;//is Code4
  8124                                  
  8125 00002A01 8A46FE                   mov al, [bp-2]
  8126 00002A04 8B1E[4300]               mov bx, [OpCodePtr]
  8127 00002A08 0207                     add al, [bx]
  8128 00002A0A B400                     mov ah, 0
  8129 00002A0C 8846FE                   mov [bp-2], al
  8130                                  
  8131                                  ;-1327             genCode8(c);
  8132                                  
  8133 00002A0F 8A46FE                   mov al, byte [bp-2]
  8134 00002A12 B400                     mov ah, 0
  8135 00002A14 50                       push ax
  8136 00002A15 E8A6F7                   call genCode8
  8137 00002A18 83C402                   add  sp, 2
  8138                                  
  8139                                  ;-1328             return;
  8140                                  
  8141 00002A1B E9A402                   jmp .retnprocess
  8142                                  
  8143                                  ;-1329         }
  8144                                  
  8145                                  
  8146                                  ;-1330         checkOpL();//no ADR, SEGREG
  8147                                  
  8148                                  .process327:
  8149 00002A1E E808DB                   call checkOpL
  8150                                  
  8151                                  ;-1331         if (R1Type == BYTE) reg16error();
  8152                                  
  8153 00002A21 A0[3600]                 mov al, [R1Type]
  8154 00002A24 3C01                     cmp al, 1
  8155 00002A26 0F850300                 jne .process331
  8156 00002A2A E8DDF1                   call reg16error
  8157                                  
  8158                                  ;-1332         if (R1Type == WORD) {
  8159                                  
  8160                                  .process331:
  8161 00002A2D A0[3600]                 mov al, [R1Type]
  8162 00002A30 3C02                     cmp al, 2
  8163 00002A32 0F851500                 jne .process332
  8164                                  
  8165                                  ;-1333             genCode2(Code1, R1No);
  8166                                  
  8167 00002A36 A0[3400]                 mov al, byte [R1No]
  8168 00002A39 B400                     mov ah, 0
  8169 00002A3B 50                       push ax
  8170 00002A3C A0[3000]                 mov al, byte [Code1]
  8171 00002A3F B400                     mov ah, 0
  8172 00002A41 50                       push ax
  8173 00002A42 E842F7                   call genCode2
  8174 00002A45 83C404                   add  sp, 4
  8175                                  
  8176                                  ;-1334             return;
  8177                                  
  8178 00002A48 E97702                   jmp .retnprocess
  8179                                  
  8180                                  ;-1335         }
  8181                                  
  8182                                  
  8183                                  ;-1336         if (Op == MEM) {
  8184                                  
  8185                                  .process332:
  8186 00002A4B A0[2D00]                 mov al, [Op]
  8187 00002A4E 3C04                     cmp al, 4
  8188 00002A50 0F851B00                 jne .process333
  8189                                  
  8190                                  ;-1337             genCode8(Code2);
  8191                                  
  8192 00002A54 A0[3100]                 mov al, byte [Code2]
  8193 00002A57 B400                     mov ah, 0
  8194 00002A59 50                       push ax
  8195 00002A5A E861F7                   call genCode8
  8196 00002A5D 83C402                   add  sp, 2
  8197                                  
  8198                                  ;-1338             writeEA(Code3);
  8199                                  
  8200 00002A60 A0[3200]                 mov al, byte [Code3]
  8201 00002A63 B400                     mov ah, 0
  8202 00002A65 50                       push ax
  8203 00002A66 E8F7F7                   call writeEA
  8204 00002A69 83C402                   add  sp, 2
  8205                                  
  8206                                  ;-1339             return;
  8207                                  
  8208 00002A6C E95302                   jmp .retnprocess
  8209                                  
  8210                                  ;-1340         }
  8211                                  
  8212                                  
  8213                                  ;-1341         syntaxerror();
  8214                                  
  8215                                  .process333:
  8216 00002A6F E8E7F1                   call syntaxerror
  8217                                  
  8218                                  ;-1342         return;
  8219                                  
  8220 00002A72 E94D02                   jmp .retnprocess
  8221                                  
  8222                                  ;-1343     }
  8223                                  
  8224                                  
  8225                                  ;-1344 
  8226                                  
  8227                                  
  8228                                  ;-1345     if (CodeType == 11) {//shift, rotate
  8229                                  
  8230                                  .process319:
  8231 00002A75 A0[2F00]                 mov al, [CodeType]
  8232 00002A78 3C0B                     cmp al, 11
  8233 00002A7A 0F859200                 jne .process334
  8234                                  
  8235                                  ;-1346         check2Ops();
  8236                                  
  8237 00002A7E E82ADB                   call check2Ops
  8238                                  
  8239                                  ;-1347         if (Op2 == IMM) {
  8240                                  
  8241 00002A81 A0[2E00]                 mov al, [Op2]
  8242 00002A84 3C01                     cmp al, 1
  8243 00002A86 0F854400                 jne .process335
  8244                                  
  8245                                  ;-1348             if (imme == 1) {
  8246                                  
  8247 00002A8A A1[3F00]                 mov ax, [imme]
  8248 00002A8D 83F801                   cmp ax, 1
  8249 00002A90 0F851800                 jne .process336
  8250                                  
  8251                                  ;-1349                 genCodeW(0xD0);
  8252                                  
  8253 00002A94 68D000                   push 208
  8254 00002A97 E808F7                   call genCodeW
  8255 00002A9A 83C402                   add  sp, 2
  8256                                  
  8257                                  ;-1350                 writeEA(Code1);
  8258                                  
  8259 00002A9D A0[3000]                 mov al, byte [Code1]
  8260 00002AA0 B400                     mov ah, 0
  8261 00002AA2 50                       push ax
  8262 00002AA3 E8BAF7                   call writeEA
  8263 00002AA6 83C402                   add  sp, 2
  8264                                  
  8265                                  ;-1351                 return;
  8266                                  
  8267 00002AA9 E91602                   jmp .retnprocess
  8268                                  
  8269                                  ;-1352             }
  8270                                  
  8271                                  
  8272                                  ;-1353             genCodeW(0xC0);//80186
  8273                                  
  8274                                  .process336:
  8275 00002AAC 68C000                   push 192
  8276 00002AAF E8F0F6                   call genCodeW
  8277 00002AB2 83C402                   add  sp, 2
  8278                                  
  8279                                  ;-1354             writeEA(Code1);
  8280                                  
  8281 00002AB5 A0[3000]                 mov al, byte [Code1]
  8282 00002AB8 B400                     mov ah, 0
  8283 00002ABA 50                       push ax
  8284 00002ABB E8A2F7                   call writeEA
  8285 00002ABE 83C402                   add  sp, 2
  8286                                  
  8287                                  ;-1355             genCode8(imme);
  8288                                  
  8289 00002AC1 FF36[3F00]               push word [imme]
  8290 00002AC5 E8F6F6                   call genCode8
  8291 00002AC8 83C402                   add  sp, 2
  8292                                  
  8293                                  ;-1356             return;
  8294                                  
  8295 00002ACB E9F401                   jmp .retnprocess
  8296                                  
  8297                                  ;-1357         }
  8298                                  
  8299                                  
  8300                                  ;-1358         if (Op2 == REG) {
  8301                                  
  8302                                  .process335:
  8303 00002ACE A0[2E00]                 mov al, [Op2]
  8304 00002AD1 3C02                     cmp al, 2
  8305 00002AD3 0F853900                 jne .process337
  8306                                  
  8307                                  ;-1359             if (R2Type == BYTE) {
  8308                                  
  8309 00002AD7 A0[3500]                 mov al, [R2Type]
  8310 00002ADA 3C01                     cmp al, 1
  8311 00002ADC 0F853000                 jne .process338
  8312                                  
  8313                                  ;-1360                 if (R2No == 1) {//CL-REG
  8314                                  
  8315 00002AE0 A0[3300]                 mov al, [R2No]
  8316 00002AE3 3C01                     cmp al, 1
  8317 00002AE5 0F852700                 jne .process339
  8318                                  
  8319                                  ;-1361                     if (R1Type == WORD) wflag=1;//hack
  8320                                  
  8321 00002AE9 A0[3600]                 mov al, [R1Type]
  8322 00002AEC 3C02                     cmp al, 2
  8323 00002AEE 0F850600                 jne .process340
  8324 00002AF2 B80100                   mov ax, 1
  8325 00002AF5 A2[3800]                 mov byte [wflag], al
  8326                                  
  8327                                  ;-1362                     genCodeW(0xD2);
  8328                                  
  8329                                  .process340:
  8330 00002AF8 68D200                   push 210
  8331 00002AFB E8A4F6                   call genCodeW
  8332 00002AFE 83C402                   add  sp, 2
  8333                                  
  8334                                  ;-1363                     writeEA(Code1);
  8335                                  
  8336 00002B01 A0[3000]                 mov al, byte [Code1]
  8337 00002B04 B400                     mov ah, 0
  8338 00002B06 50                       push ax
  8339 00002B07 E856F7                   call writeEA
  8340 00002B0A 83C402                   add  sp, 2
  8341                                  
  8342                                  ;-1364                     return;
  8343                                  
  8344 00002B0D E9B201                   jmp .retnprocess
  8345                                  
  8346                                  ;-1365                 }
  8347                                  
  8348                                  
  8349                                  ;-1366             }
  8350                                  
  8351                                  .process339:
  8352                                  
  8353                                  ;-1367         }
  8354                                  
  8355                                  .process338:
  8356                                  
  8357                                  ;-1368     }
  8358                                  
  8359                                  .process337:
  8360                                  
  8361                                  ;-1369 
  8362                                  
  8363                                  
  8364                                  ;-1370     if (CodeType == 12) {//int
  8365                                  
  8366                                  .process334:
  8367 00002B10 A0[2F00]                 mov al, [CodeType]
  8368 00002B13 3C0C                     cmp al, 12
  8369 00002B15 0F852200                 jne .process341
  8370                                  
  8371                                  ;-1371         if (TokeType == DIGIT) {
  8372                                  
  8373 00002B19 A0[2C00]                 mov al, [TokeType]
  8374 00002B1C 3C01                     cmp al, 1
  8375 00002B1E 0F851900                 jne .process342
  8376                                  
  8377                                  ;-1372             genCode8(Code1);
  8378                                  
  8379 00002B22 A0[3000]                 mov al, byte [Code1]
  8380 00002B25 B400                     mov ah, 0
  8381 00002B27 50                       push ax
  8382 00002B28 E893F6                   call genCode8
  8383 00002B2B 83C402                   add  sp, 2
  8384                                  
  8385                                  ;-1373             genCode8(SymbolInt);
  8386                                  
  8387 00002B2E FF36[0E00]               push word [SymbolInt]
  8388 00002B32 E889F6                   call genCode8
  8389 00002B35 83C402                   add  sp, 2
  8390                                  
  8391                                  ;-1374             return;
  8392                                  
  8393 00002B38 E98701                   jmp .retnprocess
  8394                                  
  8395                                  ;-1375         }
  8396                                  
  8397                                  
  8398                                  ;-1376     }
  8399                                  
  8400                                  .process342:
  8401                                  
  8402                                  ;-1377 
  8403                                  
  8404                                  
  8405                                  ;-1378     if (CodeType == 30) {//enter i18,i8
  8406                                  
  8407                                  .process341:
  8408 00002B3B A0[2F00]                 mov al, [CodeType]
  8409 00002B3E 3C1E                     cmp al, 30
  8410 00002B40 0F855200                 jne .process343
  8411                                  
  8412                                  ;-1379         genCode8(0xC8);
  8413                                  
  8414 00002B44 68C800                   push 200
  8415 00002B47 E874F6                   call genCode8
  8416 00002B4A 83C402                   add  sp, 2
  8417                                  
  8418                                  ;-1380         Op=getOp1();
  8419                                  
  8420 00002B4D E867DB                   call getOp1
  8421 00002B50 A2[2D00]                 mov byte [Op], al
  8422                                  
  8423                                  ;-1381         if (Op == IMM) genCode16(SymbolInt);
  8424                                  
  8425 00002B53 A0[2D00]                 mov al, [Op]
  8426 00002B56 3C01                     cmp al, 1
  8427 00002B58 0F850D00                 jne .process344
  8428 00002B5C FF36[0E00]               push word [SymbolInt]
  8429 00002B60 E8B2F6                   call genCode16
  8430 00002B63 83C402                   add  sp, 2
  8431                                  
  8432                                  ;-1382         else numbererror();
  8433                                  
  8434 00002B66 E90300                   jmp .process345
  8435                                  .process344:
  8436 00002B69 E85AF0                   call numbererror
  8437                                  
  8438                                  ;-1383         need(',');
  8439                                  
  8440                                  .process345:
  8441 00002B6C 6A2C                     push 44
  8442 00002B6E E892E3                   call need
  8443 00002B71 83C402                   add  sp, 2
  8444                                  
  8445                                  ;-1384         Op=getOp1();
  8446                                  
  8447 00002B74 E840DB                   call getOp1
  8448 00002B77 A2[2D00]                 mov byte [Op], al
  8449                                  
  8450                                  ;-1385         if (Op == IMM) genCode8 (SymbolInt);
  8451                                  
  8452 00002B7A A0[2D00]                 mov al, [Op]
  8453 00002B7D 3C01                     cmp al, 1
  8454 00002B7F 0F850D00                 jne .process346
  8455 00002B83 FF36[0E00]               push word [SymbolInt]
  8456 00002B87 E834F6                   call genCode8
  8457 00002B8A 83C402                   add  sp, 2
  8458                                  
  8459                                  ;-1386         else numbererror();
  8460                                  
  8461 00002B8D E90300                   jmp .process347
  8462                                  .process346:
  8463 00002B90 E833F0                   call numbererror
  8464                                  
  8465                                  ;-1387         return;
  8466                                  
  8467                                  .process347:
  8468 00002B93 E92C01                   jmp .retnprocess
  8469                                  
  8470                                  ;-1388     }
  8471                                  
  8472                                  
  8473                                  ;-1389 
  8474                                  
  8475                                  
  8476                                  ;-1390     if (CodeType==101) {//ORG nn
  8477                                  
  8478                                  .process343:
  8479 00002B96 A0[2F00]                 mov al, [CodeType]
  8480 00002B99 3C65                     cmp al, 101
  8481 00002B9B 0F851500                 jne .process348
  8482                                  
  8483                                  ;-1391         if (TokeType != DIGIT) numbererror();
  8484                                  
  8485 00002B9F A0[2C00]                 mov al, [TokeType]
  8486 00002BA2 3C01                     cmp al, 1
  8487 00002BA4 0F840300                 je  .process349
  8488 00002BA8 E81BF0                   call numbererror
  8489                                  
  8490                                  ;-1392         Origin=SymbolInt;
  8491                                  
  8492                                  .process349:
  8493 00002BAB A1[0E00]                 mov ax, [SymbolInt]
  8494 00002BAE A3[2500]                 mov word [Origin], ax
  8495                                  
  8496                                  ;-1393         return;
  8497                                  
  8498 00002BB1 E90E01                   jmp .retnprocess
  8499                                  
  8500                                  ;-1394     }
  8501                                  
  8502                                  
  8503                                  ;-1395 
  8504                                  
  8505                                  
  8506                                  ;-1396     if (CodeType == 102) {//section, segment
  8507                                  
  8508                                  .process348:
  8509 00002BB4 A0[2F00]                 mov al, [CodeType]
  8510 00002BB7 3C66                     cmp al, 102
  8511 00002BB9 0F850900                 jne .process350
  8512                                  
  8513                                  ;-1397         //getTokeType();//ignore .bss .text .data
  8514                                  
  8515                                  
  8516                                  ;-1398         AbsoluteLab=0;//nasm resets erevy time
  8517                                  
  8518 00002BBD B80000                   mov ax, 0
  8519 00002BC0 A3[2700]                 mov word [AbsoluteLab], ax
  8520                                  
  8521                                  ;-1399         return;
  8522                                  
  8523 00002BC3 E9FC00                   jmp .retnprocess
  8524                                  
  8525                                  ;-1400     }
  8526                                  
  8527                                  
  8528                                  ;-1401 
  8529                                  
  8530                                  
  8531                                  ;-1402     if (CodeType == 110) {//absolute
  8532                                  
  8533                                  .process350:
  8534 00002BC6 A0[2F00]                 mov al, [CodeType]
  8535 00002BC9 3C6E                     cmp al, 110
  8536 00002BCB 0F851500                 jne .process351
  8537                                  
  8538                                  ;-1403         if (TokeType != DIGIT) numbererror();
  8539                                  
  8540 00002BCF A0[2C00]                 mov al, [TokeType]
  8541 00002BD2 3C01                     cmp al, 1
  8542 00002BD4 0F840300                 je  .process352
  8543 00002BD8 E8EBEF                   call numbererror
  8544                                  
  8545                                  ;-1404         AbsoluteLab=SymbolInt;
  8546                                  
  8547                                  .process352:
  8548 00002BDB A1[0E00]                 mov ax, [SymbolInt]
  8549 00002BDE A3[2700]                 mov word [AbsoluteLab], ax
  8550                                  
  8551                                  ;-1405         return;
  8552                                  
  8553 00002BE1 E9DE00                   jmp .retnprocess
  8554                                  
  8555                                  ;-1406     }
  8556                                  
  8557                                  
  8558                                  ;-1407     if (CodeType == 111) {//name: PROC
  8559                                  
  8560                                  .process351:
  8561 00002BE4 A0[2F00]                 mov al, [CodeType]
  8562 00002BE7 3C6F                     cmp al, 111
  8563 00002BE9 0F854A00                 jne .process353
  8564                                  
  8565                                  ;-1408         if (isInProc == 0)  {
  8566                                  
  8567 00002BED A0[0D00]                 mov al, [isInProc]
  8568 00002BF0 3C00                     cmp al, 0
  8569 00002BF2 0F853500                 jne .process354
  8570                                  
  8571                                  ;-1409             prs("\n;entering: ");
  8572                                  
  8573 00002BF6 68[D72C]                 push process_1
  8574 00002BF9 E838ED                   call prs
  8575 00002BFC 83C402                   add  sp, 2
  8576                                  
  8577                                  ;-1410             prs(ProcName);
  8578                                  
  8579 00002BFF 8D066E75                 lea  ax, [ProcName]
  8580 00002C03 50                       push ax
  8581 00002C04 E82DED                   call prs
  8582 00002C07 83C402                   add  sp, 2
  8583                                  
  8584                                  ;-1411             isInProc=1;
  8585                                  
  8586 00002C0A B80100                   mov ax, 1
  8587 00002C0D A2[0D00]                 mov byte [isInProc], al
  8588                                  
  8589                                  ;-1412             tmpLabelNamePtr = LabelNamePtr;
  8590                                  
  8591 00002C10 A1[4600]                 mov ax, [LabelNamePtr]
  8592 00002C13 A3[4800]                 mov word [tmpLabelNamePtr], ax
  8593                                  
  8594                                  ;-1413             tmpLabelMaxIx   = LabelMaxIx;
  8595                                  
  8596 00002C16 A1[4A00]                 mov ax, [LabelMaxIx]
  8597 00002C19 A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8598                                  
  8599                                  ;-1414             tmpJmpNamePtr   = JmpNamePtr;
  8600                                  
  8601 00002C1C A1[5000]                 mov ax, [JmpNamePtr]
  8602 00002C1F A3[5200]                 mov word [tmpJmpNamePtr], ax
  8603                                  
  8604                                  ;-1415             tmpJmpMaxIx     = JmpMaxIx;
  8605                                  
  8606 00002C22 A1[5400]                 mov ax, [JmpMaxIx]
  8607 00002C25 A3[5600]                 mov word [tmpJmpMaxIx], ax
  8608                                  
  8609                                  ;-1416         } else error1("already in PROC");
  8610                                  
  8611 00002C28 E90900                   jmp .process355
  8612                                  .process354:
  8613 00002C2B 68[E52C]                 push process_2
  8614 00002C2E E855EE                   call error1
  8615 00002C31 83C402                   add  sp, 2
  8616                                  
  8617                                  ;-1417         return;
  8618                                  
  8619                                  .process355:
  8620 00002C34 E98B00                   jmp .retnprocess
  8621                                  
  8622                                  ;-1418     }
  8623                                  
  8624                                  
  8625                                  ;-1419     if (CodeType == 112) {//ENDP 
  8626                                  
  8627                                  .process353:
  8628 00002C37 A0[2F00]                 mov al, [CodeType]
  8629 00002C3A 3C70                     cmp al, 112
  8630 00002C3C 0F857900                 jne .process356
  8631                                  
  8632                                  ;-1420         if (isInProc == 0) error1("not in PROC");
  8633                                  
  8634 00002C40 A0[0D00]                 mov al, [isInProc]
  8635 00002C43 3C00                     cmp al, 0
  8636 00002C45 0F850900                 jne .process357
  8637 00002C49 68[F52C]                 push process_3
  8638 00002C4C E837EE                   call error1
  8639 00002C4F 83C402                   add  sp, 2
  8640                                  
  8641                                  ;-1421         prs("\n;leaving: ");
  8642                                  
  8643                                  .process357:
  8644 00002C52 68[012D]                 push process_4
  8645 00002C55 E8DCEC                   call prs
  8646 00002C58 83C402                   add  sp, 2
  8647                                  
  8648                                  ;-1422         prs(ProcName);
  8649                                  
  8650 00002C5B 8D066E75                 lea  ax, [ProcName]
  8651 00002C5F 50                       push ax
  8652 00002C60 E8D1EC                   call prs
  8653 00002C63 83C402                   add  sp, 2
  8654                                  
  8655                                  ;-1423         isInProc=0;
  8656                                  
  8657 00002C66 B80000                   mov ax, 0
  8658 00002C69 A2[0D00]                 mov byte [isInProc], al
  8659                                  
  8660                                  ;-1424         prs(". local labels :");
  8661                                  
  8662 00002C6C 68[0E2D]                 push process_5
  8663 00002C6F E8C2EC                   call prs
  8664 00002C72 83C402                   add  sp, 2
  8665                                  
  8666                                  ;-1425         i = LabelMaxIx - tmpLabelMaxIx;
  8667                                  
  8668 00002C75 A1[4A00]                 mov ax, [LabelMaxIx]
  8669 00002C78 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8670 00002C7C 8946FC                   mov [bp-4], ax
  8671                                  
  8672                                  ;-1426         printIntU(i);
  8673                                  
  8674 00002C7F FF76FC                   push word [bp-4]
  8675 00002C82 E8BFED                   call printIntU
  8676 00002C85 83C402                   add  sp, 2
  8677                                  
  8678                                  ;-1427         prs(", local jmp :");
  8679                                  
  8680 00002C88 68[1F2D]                 push process_6
  8681 00002C8B E8A6EC                   call prs
  8682 00002C8E 83C402                   add  sp, 2
  8683                                  
  8684                                  ;-1428         i = JmpMaxIx - tmpJmpMaxIx;
  8685                                  
  8686 00002C91 A1[5400]                 mov ax, [JmpMaxIx]
  8687 00002C94 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8688 00002C98 8946FC                   mov [bp-4], ax
  8689                                  
  8690                                  ;-1429         
  8691                                  
  8692                                  
  8693                                  ;-1430         fixJmp();
  8694                                  
  8695 00002C9B E881F2                   call fixJmp
  8696                                  
  8697                                  ;-1431         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8698                                  
  8699 00002C9E A1[4800]                 mov ax, [tmpLabelNamePtr]
  8700 00002CA1 A3[4600]                 mov word [LabelNamePtr], ax
  8701                                  
  8702                                  ;-1432         LabelMaxIx   = tmpLabelMaxIx;                       
  8703                                  
  8704 00002CA4 A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8705 00002CA7 A3[4A00]                 mov word [LabelMaxIx], ax
  8706                                  
  8707                                  ;-1433         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8708                                  
  8709 00002CAA A1[5200]                 mov ax, [tmpJmpNamePtr]
  8710 00002CAD A3[5000]                 mov word [JmpNamePtr], ax
  8711                                  
  8712                                  ;-1434         JmpMaxIx     = tmpJmpMaxIx;
  8713                                  
  8714 00002CB0 A1[5600]                 mov ax, [tmpJmpMaxIx]
  8715 00002CB3 A3[5400]                 mov word [JmpMaxIx], ax
  8716                                  
  8717                                  ;-1435         return;
  8718                                  
  8719 00002CB6 E90900                   jmp .retnprocess
  8720                                  
  8721                                  ;-1436     }
  8722                                  
  8723                                  
  8724                                  ;-1437     error1("Command not implemented or syntax error");
  8725                                  
  8726                                  .process356:
  8727 00002CB9 68[2D2D]                 push process_7
  8728 00002CBC E8C7ED                   call error1
  8729 00002CBF 83C402                   add  sp, 2
  8730                                  
  8731                                  ;-1438 }
  8732                                  
  8733                                  
  8734                                  ;-1439 
  8735                                  
  8736 00002CC2 C9                       .retnprocess: LEAVE
  8737 00002CC3 C3                       ret
  8738 00002CC4 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8739 00002CCD 7420616C6C6F776564-
  8740 00002CD6 00                 
  8741 00002CD7 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8742 00002CE0 6E673A2000         
  8743 00002CE5 616C72656164792069-     process_2 db "already in PROC",0
  8744 00002CEE 6E2050524F4300     
  8745 00002CF5 6E6F7420696E205052-     process_3 db "not in PROC",0
  8746 00002CFE 4F4300             
  8747 00002D01 5C6E3B6C656176696E-     process_4 db "\n;leaving: ",0
  8748 00002D0A 673A2000           
  8749 00002D0E 2E206C6F63616C206C-     process_5 db ". local labels :",0
  8750 00002D17 6162656C73203A00   
  8751 00002D1F 2C206C6F63616C206A-     process_6 db ", local jmp :",0
  8752 00002D28 6D70203A00         
  8753 00002D2D 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8754 00002D36 6F7420696D706C656D-
  8755 00002D3F 656E746564206F7220-
  8756 00002D48 73796E746178206572-
  8757 00002D51 726F7200           
  8758                                  ENDP
  8759                                   
  8760                                  ; missing functions: 
  8761                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  8762 00002D55 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8763 00002D58 58                      pop ax
  8764 00002D59 C3                      ret
  8765                                   
  8766                                  ;   # type sign width  adr used name   list of global variables
  8767                                  
  8768                                  ;    1 arr sign byte     1    2 Version1[9]
  8769                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  8770                                  ;    3 arr sign byte     4   12 Symbol[31]
  8771                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  8772                                  ;    5 arr sign byte     6    3 ProcName[31]
  8773                                  ;    6 var sign byte     7    6 isInProc
  8774                                  ;    7 var unsg word     8   24 SymbolInt
  8775                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  8776                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  8777                                  ;   10 arr sign byte    11    4 InputBuf[255]
  8778                                  ;   11 ptr unsg byte    12   24 InputPtr
  8779                                  ;   12 arr sign byte    13    5 namein[67]
  8780                                  ;   13 arr sign byte    14    6 namelst[67]
  8781                                  ;   14 arr sign byte    15    6 namebin[67]
  8782                                  ;   15 var sign word    16    4 asm_fd
  8783                                  ;   16 var sign word    17    3 lst_fd
  8784                                  ;   17 var sign word    18    3 bin_fd
  8785                                  ;   18 var sign word    19    6 DOS_ERR
  8786                                  ;   19 var sign word    20    4 ErrorCount
  8787                                  ;   20 var sign word    21    4 DOS_NoBytes
  8788                                  ;   21 var sign byte    22    5 DOS_ByteRead
  8789                                  ;   22 var unsg word    24    7 PC
  8790                                  ;   23 var unsg word    25    5 Origin
  8791                                  ;   24 var unsg word    26    6 AbsoluteLab
  8792                                  ;   25 var unsg word    27    2 PCStart
  8793                                  ;   26 var sign byte    28    3 isLabel
  8794                                  ;   27 def unsg byte    29    - DIGIT=1
  8795                                  ;   28 def unsg byte    30    - LETTERE=2
  8796                                  ;   29 def unsg byte    31    - ALNUME=3
  8797                                  ;   30 def unsg byte    32    - NOALNUME=4
  8798                                  ;   31 var sign byte    33   27 TokeType
  8799                                  ;   32 def unsg byte    34    - BYTE=1
  8800                                  ;   33 def unsg byte    35    - WORD=2
  8801                                  ;   34 def unsg byte    36    - DWORD=3
  8802                                  ;   35 def unsg byte    37    - SEGREG=4
  8803                                  ;   36 def unsg byte    38    - IMM=1
  8804                                  ;   37 def unsg byte    39    - REG=2
  8805                                  ;   38 def unsg byte    40    - ADR=3
  8806                                  ;   39 def unsg byte    41    - MEM=4
  8807                                  ;   40 var sign byte    42   29 Op
  8808                                  ;   41 var sign byte    43   31 Op2
  8809                                  ;   42 var sign byte    44   29 CodeType
  8810                                  ;   43 var sign byte    45   23 Code1
  8811                                  ;   44 var sign byte    46    7 Code2
  8812                                  ;   45 var sign byte    47    3 Code3
  8813                                  ;   46 var sign byte    48   19 R2No
  8814                                  ;   47 var sign byte    49   16 R1No
  8815                                  ;   48 var sign byte    50   18 R2Type
  8816                                  ;   49 var sign byte    51   15 R1Type
  8817                                  ;   50 var sign byte    52   14 OpSize
  8818                                  ;   51 var sign byte    53    9 wflag
  8819                                  ;   52 var sign byte    54    3 dflag
  8820                                  ;   53 var sign byte    55    8 sflag
  8821                                  ;   54 var sign byte    56   15 rm
  8822                                  ;   55 var sign byte    57    5 isDirect
  8823                                  ;   56 var sign word    58   54 disp
  8824                                  ;   57 var unsg word    59   13 imme
  8825                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  8826                                  ;   59 arr sign byte    62    2 OpPos[5]
  8827                                  ;   60 var sign word    63    6 OpPrintIndex
  8828                                  ;   61 ptr sign byte    64   19 OpCodePtr
  8829                                  ;   62 var sign byte    65    5 PrintRA
  8830                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  8831                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  8832                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  8833                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  8834                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  8835                                  ;   68 arr unsg word    73    7 LabelAddr[600]
  8836                                  ;   69 var sign word    74   10 LabelMaxIx
  8837                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  8838                                  ;   71 var sign word    76   10 LabelIx
  8839                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  8840                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  8841                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  8842                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  8843                                  ;   76 def unsg byte    83    - JMPMAX=200
  8844                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  8845                                  ;   78 var sign word    85    9 JmpMaxIx
  8846                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  8847                                  ;   80 def unsg byte    88    - FILEBINMAX=20000
  8848                                  ;   81 arr sign byte    89    5 FileBin[20000]
  8849                                  ;   82 var unsg word    90    6 BinLen
  8850                                  ;   83 ptr sign byte    92    1 arglen
  8851                                  ;   84 ptr sign byte    93    4 argv
  8852                                  ;   85 var sign byte    97    1 I_START
  8853                                  ;   86 arr sign byte   100 NULL I_PUSHA[8125]
  8854                                  ;   87 arr sign byte   101 NULL I_NOP[24260]
  8855                                  ;   88 arr sign byte   102 NULL I_CWDE[9734]
  8856                                  ;   89 arr sign byte   103 NULL I_CDQ[1931]
  8857                                  ;   90 arr sign byte   104 NULL I_PUSHF[35622]
  8858                                  ;   91 arr sign byte   105 NULL I_SAHF[599]
  8859                                  ;   92 arr sign byte   106 NULL I_MOVSB[53495]
  8860                                  ;   93 arr sign byte   107 NULL I_CMPSB[54007]
  8861                                  ;   94 arr sign byte   108 NULL I_STOSB[37]
  8862                                  ;   95 arr sign byte   109 NULL I_LODSB[33600]
  8863                                  ;   96 arr sign byte   110 NULL I_SCASB[8418]
  8864                                  ;   97 arr sign byte   111 NULL I_LEAVE[53259]
  8865                                  ;   98 arr sign byte   112 NULL I_INTO[12917]
  8866                                  ;   99 arr sign byte   113 NULL I_XLAT[35622]
  8867                                  ;  100 arr sign byte   114 NULL I_REPNE[2119]
  8868                                  ;  101 arr sign byte   115 NULL I_REPE[18057]
  8869                                  ;  102 arr sign byte   116 NULL I_HLT[9982]
  8870                                  ;  103 arr sign byte   117 NULL I_STC[18315]
  8871                                  ;  104 arr sign byte   118 NULL I_STI[9734]
  8872                                  ;  105 arr sign byte   119 NULL I_STD[32643]
  8873                                  ;  106 arr sign byte   121 NULL I_INC[10]
  8874                                  ;  107 arr sign byte   122 NULL I_DEC[1397]
  8875                                  ;  108 arr sign byte   123 NULL I_NOT[18119]
  8876                                  ;  109 arr sign byte   124 NULL I_NEG[65534]
  8877                                  ;  110 arr sign byte   125 NULL I_MUL[33791]
  8878                                  ;  111 arr sign byte   126 NULL I_IMUL[65150]
  8879                                  ;  112 arr sign byte   127 NULL I_DIV[30207]
  8880                                  ;  113 arr sign byte   128 NULL I_IDIV[15642]
  8881                                  ;  114 arr sign byte   130 NULL I_LES[65535]
  8882                                  ;  115 arr sign byte   131 NULL I_LDS[5493]
  8883                                  ;  116 arr sign byte   132 NULL I_LEA[33574]
  8884                                  ;  117 arr sign byte   133 NULL I_LSS[1151]
  8885                                  ;  118 arr sign byte   134 NULL I_LFS[29696]
  8886                                  ;  119 arr sign byte   135 NULL I_LGS[35593]
  8887                                  ;  120 arr sign byte   137 NULL I_ADD[2630]
  8888                                  ;  121 arr sign byte   138 NULL I_OR[14630]
  8889                                  ;  122 arr sign byte   139 NULL I_ADC[1095]
  8890                                  ;  123 arr sign byte   140 NULL I_SBB[26997]
  8891                                  ;  124 arr sign byte   141 NULL I_AND[49203]
  8892                                  ;  125 arr sign byte   142 NULL I_SUB[52169]
  8893                                  ;  126 arr sign byte   143 NULL I_XOR[33680]
  8894                                  ;  127 arr sign byte   144 NULL I_CMP[65150]
  8895                                  ;  128 arr sign byte   145 NULL I_TEST[29729]
  8896                                  ;  129 arr sign byte   147 NULL I_MOV[33618]
  8897                                  ;  130 arr sign byte   148 NULL I_MOVSX[65150]
  8898                                  ;  131 arr sign byte   149 NULL I_MOVZX[29731]
  8899                                  ;  132 arr sign byte   151 NULL I_JO[33612]
  8900                                  ;  133 arr sign byte   152 NULL I_JNO[65150]
  8901                                  ;  134 arr sign byte   153 NULL I_JB[29732]
  8902                                  ;  135 arr sign byte   154 NULL I_JNB[33606]
  8903                                  ;  136 arr sign byte   155 NULL I_JAE[65150]
  8904                                  ;  137 arr sign byte   156 NULL I_JE[29734]
  8905                                  ;  138 arr sign byte   157 NULL I_JNE[33600]
  8906                                  ;  139 arr sign byte   158 NULL I_JBE[65150]
  8907                                  ;  140 arr sign byte   159 NULL I_JA[29730]
  8908                                  ;  141 arr sign byte   160 NULL I_JS[33594]
  8909                                  ;  142 arr sign byte   161 NULL I_JNS[65150]
  8910                                  ;  143 arr sign byte   162 NULL I_JP[29737]
  8911                                  ;  144 arr sign byte   163 NULL I_JNP[33588]
  8912                                  ;  145 arr sign byte   164 NULL I_JL[65150]
  8913                                  ;  146 arr sign byte   165 NULL I_JNL[29736]
  8914                                  ;  147 arr sign byte   166 NULL I_JLE[33582]
  8915                                  ;  148 arr sign byte   167 NULL I_JG[65150]
  8916                                  ;  149 arr sign byte   169 NULL I_JMP[29733]
  8917                                  ;  150 arr sign byte   170 NULL I_CALL[15656]
  8918                                  ;  151 arr sign byte   172 NULL I_RET[33]
  8919                                  ;  152 arr sign byte   173 NULL I_RETF[9076]
  8920                                  ;  153 arr sign byte   175 NULL I_PUSH[9021]
  8921                                  ;  154 arr sign byte   176 NULL I_POP[29696]
  8922                                  ;  155 arr sign byte   178 NULL I_ROL[15646]
  8923                                  ;  156 arr sign byte   179 NULL I_RCL[36]
  8924                                  ;  157 arr sign byte   180 NULL I_SHL[6516]
  8925                                  ;  158 arr sign byte   181 NULL I_SHR[9789]
  8926                                  ;  159 arr sign byte   183 NULL I_INT[29696]
  8927                                  ;  160 arr sign byte   185 NULL I_IN[15636]
  8928                                  ;  161 arr sign byte   186 NULL I_INSB[34]
  8929                                  ;  162 arr sign byte   187 NULL I_INSW[3956]
  8930                                  ;  163 arr sign byte   188 NULL I_INSD[10557]
  8931                                  ;  164 arr sign byte   189 NULL I_OUT[29696]
  8932                                  ;  165 arr sign byte   190 NULL I_OUTSB[15626]
  8933                                  ;  166 arr sign byte   191 NULL I_OUTSW[40]
  8934                                  ;  167 arr sign byte   192 NULL I_OUTSD[1396]
  8935                                  ;  168 arr sign byte   194 NULL I_XCHG[9533]
  8936                                  ;  169 arr sign byte   196 NULL I_LOOPNZ[29952]
  8937                                  ;  170 arr sign byte   197 NULL I_LOOPNE[33542]
  8938                                  ;  171 arr sign byte   198 NULL I_LOOPZ[2686]
  8939                                  ;  172 arr sign byte   199 NULL I_LOOPE[60176]
  8940                                  ;  173 arr sign byte   200 NULL I_LOOP[33540]
  8941                                  ;  174 arr sign byte   201 NULL I_JCXZ[2686]
  8942                                  ;  175 arr sign byte   202 NULL I_JECXZ[29984]
  8943                                  ;  176 arr sign byte   204 NULL I_ENTER[47255]
  8944                                  ;  177 arr sign byte   206 NULL I_ORG[1]
  8945                                  ;  178 arr sign byte   208 NULL I_SECTION[52169]
  8946                                  ;  179 arr sign byte   209 NULL I_SEGMENT[21904]
  8947                                  ;  180 arr sign byte   210 NULL I_ABSOLUTE[60555]
  8948                                  ;  181 arr sign byte   211 NULL I_PROC[5816]
  8949                                  ;  182 arr sign byte   212 NULL I_ENDP[39424]
  8950                                  ;  183 arr sign byte   213 NULL I_DB[674]
  8951                                  ;  184 arr sign byte   214 NULL I_DW[8125]
  8952                                  ;  185 arr sign byte   215 NULL I_DD[51030]
  8953                                  ;  186 arr sign byte   216 NULL I_RESB[65094]
  8954                                  ;  187 arr sign byte   217 NULL I_RESW[0]
  8955                                  ;  188 arr sign byte   218 NULL I_RESD[1678]
  8956                                  ;  189 var sign byte   219 NULL I_END
  8957                                  
  8958                                  
  8959                                  ;   # Calls Line Width  Name   list of functions
  8960                                  
  8961                                  ;    0    2  221   lookCode
  8962                                  ;    1    2  238   ChangeDirection
  8963                                  ;    2    2  246   checkOpL
  8964                                  ;    3    4  255   check2Ops
  8965                                  ;    4    1  264   get2Ops
  8966                                  ;    5    3  270   getOpL
  8967                                  ;    6    2  278   getOpR
  8968                                  ;    7    4  288   getOp1
  8969                                  ;    8    1  305   getMEM
  8970                                  ;    9    1  331   getIndReg1
  8971                                  ;   10    1  339   getIndReg2
  8972                                  ;   11    2  349   setwflag
  8973                                  ;   12    2  360   setsflag
  8974                                  ;   13    2  370   checkConstSize
  8975                                  ;   14    1  378   parse
  8976                                  ;   15   16  414   getTokeType
  8977                                  ;   16    3  425   storeJmp
  8978                                  ;   17    2  436   storeLabel
  8979                                  ;   18    5  448   searchLabel
  8980                                  ;   19    1  461   getVariable
  8981                                  ;   20    1  514   getCodeSize
  8982                                  ;   21    9  522   isToken
  8983                                  ;   22    2  530   need
  8984                                  ;   23    1  539   skipRest
  8985                                  ;   24    4  546   writetty
  8986                                  ;   25    1  547   putch
  8987                                  ;   26    8  548   cputs
  8988                                  ;   27    6  550   DosInt
  8989                                  ;   28    1  555   openR
  8990                                  ;   29    2  556   creatR
  8991                                  ;   30    3  557   fcloseR
  8992                                  ;   31    5  558   exitR
  8993                                  ;   32    2  559   readRL
  8994                                  ;   33    2  560   fputcR
  8995                                  ;   34    1  563   getLine
  8996                                  ;   35    1  579   ifEOL
  8997                                  ;   36    3  588   skipBlank
  8998                                  ;   37    2  593   letterE
  8999                                  ;   38    1  603   alnumE
  9000                                  ;   39    3  608   digit
  9001                                  ;   40    4  613   strlen
  9002                                  ;   41    9  618   strcpy
  9003                                  ;   42   35  624   eqstr
  9004                                  ;   43    3  633   strcat1
  9005                                  ;   44    2  637   toupper
  9006                                  ;   45    1  644   getDigit
  9007                                  ;   46    1  656   getName
  9008                                  ;   47    1  675   testReg
  9009                                  ;   48    1  719   printLine
  9010                                  ;   49    7  741   prc
  9011                                  ;   50    1  751   prscomment
  9012                                  ;   51   34  759   prs
  9013                                  ;   52    3  781   printhex8a
  9014                                  ;   53    2  786   printhex4
  9015                                  ;   54    1  791   printhex16
  9016                                  ;   55    6  796   printIntU
  9017                                  ;   56   28  807   error1
  9018                                  ;   57   13  814   errorexit
  9019                                  ;   58    2  819   notfounderror
  9020                                  ;   59 NULL  820   allowederror
  9021                                  ;   60    3  821   addrerror
  9022                                  ;   61    1  822   immeerror
  9023                                  ;   62    2  823   implerror
  9024                                  ;   63    4  824   indexerror
  9025                                  ;   64    3  825   invaloperror
  9026                                  ;   65    6  826   numbererror
  9027                                  ;   66    1  827   regmemerror
  9028                                  ;   67    3  828   reg16error
  9029                                  ;   68    1  829   segregerror
  9030                                  ;   69    5  830   syntaxerror
  9031                                  ;   70 NULL  832   addrexit
  9032                                  ;   71    3  833   dataexit
  9033                                  ;   72 NULL  834   internexit
  9034                                  ;   73 NULL  838   main
  9035                                  ;   74    1  846   getarg
  9036                                  ;   75    2  880   fixJmp
  9037                                  ;   76    2  915   epilog
  9038                                  ;   77    2  963   end1
  9039                                  ;   78    1  973   getCodes
  9040                                  ;   79    1  978   gen66h
  9041                                  ;   80    8  980   genCode2
  9042                                  ;   81   13  984   genCodeW
  9043                                  ;   82   37  988   genCode8
  9044                                  ;   83   18  999   genCode16
  9045                                  ;   84    1 1003   genCode32
  9046                                  ;   85   13 1007   writeEA
  9047                                  ;   86    4 1049   genImmediate
  9048                                  ;   87    1 1056   process
  9049                                  ;   88 NULL 1439   LastFunctionByt
  9050                                  
  9051                                  ;    #  addr name   list of CALLs
  9052                                  
  9053                                  ;    0     0 eqstr
  9054                                  ;    1     6 implerror
  9055                                  ;    2    16 segregerror
  9056                                  ;    3    28 setwflag
  9057                                  ;    4    37 error1
  9058                                  ;    5    44 error1
  9059                                  ;    6    51 get2Ops
  9060                                  ;    7    59 addrerror
  9061                                  ;    8    69 invaloperror
  9062                                  ;    9    82 immeerror
  9063                                  ;   10    92 addrerror
  9064                                  ;   11   102 invaloperror
  9065                                  ;   12   115 setwflag
  9066                                  ;   13   124 getOpL
  9067                                  ;   14   131 need
  9068                                  ;   15   136 getOpR
  9069                                  ;   16   143 getOpR
  9070                                  ;   17   150 getOp1
  9071                                  ;   18   157 isToken
  9072                                  ;   19   165 getMEM
  9073                                  ;   20   172 invaloperror
  9074                                  ;   21   185 error1
  9075                                  ;   22   192 testReg
  9076                                  ;   23   200 searchLabel
  9077                                  ;   24   212 getTokeType
  9078                                  ;   25   224 getOp1
  9079                                  ;   26   231 syntaxerror
  9080                                  ;   27   243 getIndReg2
  9081                                  ;   28   254 getIndReg1
  9082                                  ;   29   265 notfounderror
  9083                                  ;   30   279 isToken
  9084                                  ;   31   287 getTokeType
  9085                                  ;   32   299 numbererror
  9086                                  ;   33   311 isToken
  9087                                  ;   34   319 isToken
  9088                                  ;   35   327 errorexit
  9089                                  ;   36   337 indexerror
  9090                                  ;   37   348 indexerror
  9091                                  ;   38   359 indexerror
  9092                                  ;   39   370 indexerror
  9093                                  ;   40   381 gen66h
  9094                                  ;   41   388 error1
  9095                                  ;   42   395 getLine
  9096                                  ;   43   403 getTokeType
  9097                                  ;   44   415 strcpy
  9098                                  ;   45   422 storeLabel
  9099                                  ;   46   433 getTokeType
  9100                                  ;   47   445 lookCode
  9101                                  ;   48   454 process
  9102                                  ;   49   462 getVariable
  9103                                  ;   50   474 skipRest
  9104                                  ;   51   483 error1
  9105                                  ;   52   490 error1
  9106                                  ;   53   497 printLine
  9107                                  ;   54   507 skipBlank
  9108                                  ;   55   517 digit
  9109                                  ;   56   523 getDigit
  9110                                  ;   57   532 letterE
  9111                                  ;   58   540 getName
  9112                                  ;   59   548 errorexit
  9113                                  ;   60   558 strcpy
  9114                                  ;   61   565 errorexit
  9115                                  ;   62   575 searchLabel
  9116                                  ;   63   587 error1
  9117                                  ;   64   594 errorexit
  9118                                  ;   65   604 strcpy
  9119                                  ;   66   611 errorexit
  9120                                  ;   67   621 eqstr
  9121                                  ;   68   627 strlen
  9122                                  ;   69   634 storeLabel
  9123                                  ;   70   645 getTokeType
  9124                                  ;   71   657 lookCode
  9125                                  ;   72   666 dataexit
  9126                                  ;   73   675 dataexit
  9127                                  ;   74   684 getTokeType
  9128                                  ;   75   696 genCode8
  9129                                  ;   76   705 skipBlank
  9130                                  ;   77   715 isToken
  9131                                  ;   78   723 genCode8
  9132                                  ;   79   732 isToken
  9133                                  ;   80   740 getTokeType
  9134                                  ;   81   752 genCode16
  9135                                  ;   82   762 isToken
  9136                                  ;   83   770 getTokeType
  9137                                  ;   84   782 genCode16
  9138                                  ;   85   792 genCode16
  9139                                  ;   86   802 isToken
  9140                                  ;   87   810 getTokeType
  9141                                  ;   88   822 syntaxerror
  9142                                  ;   89   834 error1
  9143                                  ;   90   841 numbererror
  9144                                  ;   91   853 dataexit
  9145                                  ;   92   862 eqstr
  9146                                  ;   93   868 getTokeType
  9147                                  ;   94   880 eqstr
  9148                                  ;   95   886 getTokeType
  9149                                  ;   96   898 eqstr
  9150                                  ;   97   904 getTokeType
  9151                                  ;   98   916 skipBlank
  9152                                  ;   99   926 isToken
  9153                                  ;  100   934 getTokeType
  9154                                  ;  101   946 error1
  9155                                  ;  102   953 prs
  9156                                  ;  103   957 prc
  9157                                  ;  104   961 getTokeType
  9158                                  ;  105   973 error1
  9159                                  ;  106   980 writetty
  9160                                  ;  107   989 writetty
  9161                                  ;  108   998 putch
  9162                                  ;  109  1004 DosInt
  9163                                  ;  110  1011 DosInt
  9164                                  ;  111  1018 DosInt
  9165                                  ;  112  1025 DosInt
  9166                                  ;  113  1032 DosInt
  9167                                  ;  114  1039 DosInt
  9168                                  ;  115  1046 readRL
  9169                                  ;  116  1053 errorexit
  9170                                  ;  117  1063 errorexit
  9171                                  ;  118  1073 ifEOL
  9172                                  ;  119  1079 readRL
  9173                                  ;  120  1086 errorexit
  9174                                  ;  121  1096 digit
  9175                                  ;  122  1102 letterE
  9176                                  ;  123  1110 strcpy
  9177                                  ;  124  1117 digit
  9178                                  ;  125  1123 alnumE
  9179                                  ;  126  1130 errorexit
  9180                                  ;  127  1140 strcpy
  9181                                  ;  128  1147 toupper
  9182                                  ;  129  1155 strlen
  9183                                  ;  130  1162 strlen
  9184                                  ;  131  1169 eqstr
  9185                                  ;  132  1175 eqstr
  9186                                  ;  133  1181 eqstr
  9187                                  ;  134  1187 eqstr
  9188                                  ;  135  1193 eqstr
  9189                                  ;  136  1199 eqstr
  9190                                  ;  137  1205 eqstr
  9191                                  ;  138  1211 eqstr
  9192                                  ;  139  1217 eqstr
  9193                                  ;  140  1223 eqstr
  9194                                  ;  141  1229 eqstr
  9195                                  ;  142  1235 eqstr
  9196                                  ;  143  1241 eqstr
  9197                                  ;  144  1247 eqstr
  9198                                  ;  145  1253 eqstr
  9199                                  ;  146  1259 eqstr
  9200                                  ;  147  1265 eqstr
  9201                                  ;  148  1271 eqstr
  9202                                  ;  149  1277 eqstr
  9203                                  ;  150  1283 eqstr
  9204                                  ;  151  1289 eqstr
  9205                                  ;  152  1295 eqstr
  9206                                  ;  153  1301 eqstr
  9207                                  ;  154  1307 eqstr
  9208                                  ;  155  1313 eqstr
  9209                                  ;  156  1319 eqstr
  9210                                  ;  157  1325 eqstr
  9211                                  ;  158  1331 eqstr
  9212                                  ;  159  1337 eqstr
  9213                                  ;  160  1343 eqstr
  9214                                  ;  161  1349 prs
  9215                                  ;  162  1353 printhex16
  9216                                  ;  163  1364 prs
  9217                                  ;  164  1368 prc
  9218                                  ;  165  1372 printhex8a
  9219                                  ;  166  1383 prs
  9220                                  ;  167  1387 prc
  9221                                  ;  168  1391 prscomment
  9222                                  ;  169  1402 writetty
  9223                                  ;  170  1411 writetty
  9224                                  ;  171  1420 fputcR
  9225                                  ;  172  1427 prc
  9226                                  ;  173  1431 prc
  9227                                  ;  174  1435 printhex4
  9228                                  ;  175  1445 printhex4
  9229                                  ;  176  1455 prc
  9230                                  ;  177  1459 printhex8a
  9231                                  ;  178  1470 printhex8a
  9232                                  ;  179  1481 printIntU
  9233                                  ;  180  1491 prc
  9234                                  ;  181  1495 prs
  9235                                  ;  182  1499 prs
  9236                                  ;  183  1503 prs
  9237                                  ;  184  1507 prs
  9238                                  ;  185  1511 error1
  9239                                  ;  186  1518 epilog
  9240                                  ;  187  1525 end1
  9241                                  ;  188  1530 error1
  9242                                  ;  189  1537 error1
  9243                                  ;  190  1544 error1
  9244                                  ;  191  1551 error1
  9245                                  ;  192  1558 error1
  9246                                  ;  193  1565 error1
  9247                                  ;  194  1572 error1
  9248                                  ;  195  1579 error1
  9249                                  ;  196  1586 error1
  9250                                  ;  197  1593 error1
  9251                                  ;  198  1600 error1
  9252                                  ;  199  1607 error1
  9253                                  ;  200  1614 errorexit
  9254                                  ;  201  1624 errorexit
  9255                                  ;  202  1634 errorexit
  9256                                  ;  203  1644 getarg
  9257                                  ;  204  1651 parse
  9258                                  ;  205  1657 fixJmp
  9259                                  ;  206  1664 epilog
  9260                                  ;  207  1671 end1
  9261                                  ;  208  1676 cputs
  9262                                  ;  209  1682 cputs
  9263                                  ;  210  1688 exitR
  9264                                  ;  211  1694 toupper
  9265                                  ;  212  1702 strcpy
  9266                                  ;  213  1709 strcat1
  9267                                  ;  214  1717 strcpy
  9268                                  ;  215  1724 strcat1
  9269                                  ;  216  1732 strcpy
  9270                                  ;  217  1739 strcat1
  9271                                  ;  218  1747 openR
  9272                                  ;  219  1753 cputs
  9273                                  ;  220  1759 cputs
  9274                                  ;  221  1765 exitR
  9275                                  ;  222  1771 creatR
  9276                                  ;  223  1778 cputs
  9277                                  ;  224  1784 cputs
  9278                                  ;  225  1790 exitR
  9279                                  ;  226  1796 creatR
  9280                                  ;  227  1803 cputs
  9281                                  ;  228  1809 cputs
  9282                                  ;  229  1815 exitR
  9283                                  ;  230  1821 prs
  9284                                  ;  231  1825 prs
  9285                                  ;  232  1829 prs
  9286                                  ;  233  1833 prs
  9287                                  ;  234  1837 prs
  9288                                  ;  235  1841 prs
  9289                                  ;  236  1845 prs
  9290                                  ;  237  1849 prs
  9291                                  ;  238  1853 prs
  9292                                  ;  239  1857 prs
  9293                                  ;  240  1861 printIntU
  9294                                  ;  241  1871 strcpy
  9295                                  ;  242  1878 strlen
  9296                                  ;  243  1885 searchLabel
  9297                                  ;  244  1897 error1
  9298                                  ;  245  1904 prs
  9299                                  ;  246  1908 printIntU
  9300                                  ;  247  1918 prs
  9301                                  ;  248  1922 prs
  9302                                  ;  249  1926 prs
  9303                                  ;  250  1930 prs
  9304                                  ;  251  1934 prs
  9305                                  ;  252  1938 prs
  9306                                  ;  253  1942 printIntU
  9307                                  ;  254  1952 prs
  9308                                  ;  255  1956 fputcR
  9309                                  ;  256  1963 prs
  9310                                  ;  257  1967 printIntU
  9311                                  ;  258  1977 prs
  9312                                  ;  259  1981 fcloseR
  9313                                  ;  260  1989 fcloseR
  9314                                  ;  261  1997 fcloseR
  9315                                  ;  262  2005 exitR
  9316                                  ;  263  2011 genCode8
  9317                                  ;  264  2020 genCode8
  9318                                  ;  265  2029 genCode8
  9319                                  ;  266  2038 errorexit
  9320                                  ;  267  2048 genCode8
  9321                                  ;  268  2057 genCode8
  9322                                  ;  269  2066 genCode16
  9323                                  ;  270  2076 genCode16
  9324                                  ;  271  2086 genCode8
  9325                                  ;  272  2095 genCode8
  9326                                  ;  273  2104 genCode16
  9327                                  ;  274  2114 genCode32
  9328                                  ;  275  2124 genCode16
  9329                                  ;  276  2134 genCode8
  9330                                  ;  277  2143 getTokeType
  9331                                  ;  278  2155 getCodeSize
  9332                                  ;  279  2167 getCodes
  9333                                  ;  280  2176 genCode8
  9334                                  ;  281  2185 getOpL
  9335                                  ;  282  2192 checkOpL
  9336                                  ;  283  2201 genCode2
  9337                                  ;  284  2210 getTokeType
  9338                                  ;  285  2222 implerror
  9339                                  ;  286  2232 genCodeW
  9340                                  ;  287  2241 writeEA
  9341                                  ;  288  2249 check2Ops
  9342                                  ;  289  2259 reg16error
  9343                                  ;  290  2270 addrerror
  9344                                  ;  291  2280 genCode8
  9345                                  ;  292  2289 genCode8
  9346                                  ;  293  2298 writeEA
  9347                                  ;  294  2306 check2Ops
  9348                                  ;  295  2316 setsflag
  9349                                  ;  296  2325 genCodeW
  9350                                  ;  297  2334 genImmediate
  9351                                  ;  298  2347 genCodeW
  9352                                  ;  299  2356 writeEA
  9353                                  ;  300  2364 genCode8
  9354                                  ;  301  2373 genImmediate
  9355                                  ;  302  2386 genCodeW
  9356                                  ;  303  2395 writeEA
  9357                                  ;  304  2403 genCodeW
  9358                                  ;  305  2412 writeEA
  9359                                  ;  306  2420 syntaxerror
  9360                                  ;  307  2432 check2Ops
  9361                                  ;  308  2442 notfounderror
  9362                                  ;  309  2456 genCode2
  9363                                  ;  310  2465 genImmediate
  9364                                  ;  311  2478 genCodeW
  9365                                  ;  312  2487 writeEA
  9366                                  ;  313  2495 genImmediate
  9367                                  ;  314  2508 regmemerror
  9368                                  ;  315  2520 ChangeDirection
  9369                                  ;  316  2536 reg16error
  9370                                  ;  317  2547 genCode2
  9371                                  ;  318  2556 writeEA
  9372                                  ;  319  2564 genCodeW
  9373                                  ;  320  2573 genCode16
  9374                                  ;  321  2583 genCodeW
  9375                                  ;  322  2592 genCode16
  9376                                  ;  323  2602 genCodeW
  9377                                  ;  324  2611 writeEA
  9378                                  ;  325  2619 ChangeDirection
  9379                                  ;  326  2635 genCodeW
  9380                                  ;  327  2644 writeEA
  9381                                  ;  328  2652 syntaxerror
  9382                                  ;  329  2664 searchLabel
  9383                                  ;  330  2676 checkConstSize
  9384                                  ;  331  2691 genCode2
  9385                                  ;  332  2700 genCode8
  9386                                  ;  333  2709 genCode8
  9387                                  ;  334  2718 genCode2
  9388                                  ;  335  2727 genCode16
  9389                                  ;  336  2737 genCode8
  9390                                  ;  337  2746 genCode2
  9391                                  ;  338  2755 storeJmp
  9392                                  ;  339  2764 genCode16
  9393                                  ;  340  2774 searchLabel
  9394                                  ;  341  2786 checkConstSize
  9395                                  ;  342  2801 genCode8
  9396                                  ;  343  2810 genCode8
  9397                                  ;  344  2819 genCode8
  9398                                  ;  345  2828 genCode16
  9399                                  ;  346  2838 genCode8
  9400                                  ;  347  2847 genCode16
  9401                                  ;  348  2857 genCode8
  9402                                  ;  349  2866 storeJmp
  9403                                  ;  350  2875 genCode16
  9404                                  ;  351  2885 genCode8
  9405                                  ;  352  2894 genCode16
  9406                                  ;  353  2904 genCode8
  9407                                  ;  354  2913 getOpL
  9408                                  ;  355  2920 setsflag
  9409                                  ;  356  2929 genCode2
  9410                                  ;  357  2938 genCode8
  9411                                  ;  358  2947 genCode16
  9412                                  ;  359  2957 genCode8
  9413                                  ;  360  2966 genCode16
  9414                                  ;  361  2976 genCode8
  9415                                  ;  362  2985 storeJmp
  9416                                  ;  363  2994 genCode8
  9417                                  ;  364  3003 genCode8
  9418                                  ;  365  3012 error1
  9419                                  ;  366  3019 genCode8
  9420                                  ;  367  3028 genCode8
  9421                                  ;  368  3037 checkOpL
  9422                                  ;  369  3046 reg16error
  9423                                  ;  370  3057 genCode2
  9424                                  ;  371  3066 genCode8
  9425                                  ;  372  3075 writeEA
  9426                                  ;  373  3083 syntaxerror
  9427                                  ;  374  3095 check2Ops
  9428                                  ;  375  3105 genCodeW
  9429                                  ;  376  3114 writeEA
  9430                                  ;  377  3122 genCodeW
  9431                                  ;  378  3131 writeEA
  9432                                  ;  379  3139 genCode8
  9433                                  ;  380  3148 genCodeW
  9434                                  ;  381  3157 writeEA
  9435                                  ;  382  3165 genCode8
  9436                                  ;  383  3174 genCode8
  9437                                  ;  384  3183 genCode8
  9438                                  ;  385  3192 getOp1
  9439                                  ;  386  3199 genCode16
  9440                                  ;  387  3209 numbererror
  9441                                  ;  388  3221 need
  9442                                  ;  389  3226 getOp1
  9443                                  ;  390  3233 genCode8
  9444                                  ;  391  3242 numbererror
  9445                                  ;  392  3254 numbererror
  9446                                  ;  393  3266 numbererror
  9447                                  ;  394  3278 prs
  9448                                  ;  395  3282 prs
  9449                                  ;  396  3286 error1
  9450                                  ;  397  3293 error1
  9451                                  ;  398  3300 prs
  9452                                  ;  399  3304 prs
  9453                                  ;  400  3308 prs
  9454                                  ;  401  3312 printIntU
  9455                                  ;  402  3322 prs
  9456                                  ;  403  3326 fixJmp
  9457                                  ;  404  3333 error1
  9458                                  ;Input: AS.C, List: AS.S,  Lines: 1440
  9459                                  ;Glob. variables:  189 max.:  200
  9460                                  ;Functions      :   89 max.:  300
  9461                                  ;Calls          :  405 max.: 2000, NameField: 3340 max.:    65535
  9462                                  ;Code until     :21667 max.: 30000, free: 8333
  9463                                  ;Data (HeapEnd) :62154, resting stacksize:  3381 *** Warning *** Stack too small
  9464                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
